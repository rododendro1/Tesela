import Armonia
import Exposicion
import Foundation

// MARK: - Consultas: acordes y arpegios

extension LineaDeComandos {
    /// `acorde Sol7 [--disposiciones] [--nombres] [--tonalidades] [--sustituciones] [--comparar Do] [--en Do mayor]`:
    /// cada acorde con sus notas y, si se piden, sus disposiciones, sus otros nombres, las tonalidades en que está,
    /// sus sustituciones (en la tonalidad de `--en` o en la suya) y la conducción hasta otro acorde.
    static func acorde(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(textos)
        guard let tonalidad = try argumentos.quitarTonalidad() else { throw ErrorDeUso.faltaTonalidadTrasEn }
        var otro: Acorde?
        if let texto = try argumentos.valor(.comparar) { otro = try Acorde(leyendoEnLaOrden: texto) }
        let pedido = RelacionesPedidas(
            bebop: argumentos.quitarMarca(.bebop),
            pentatonicas: argumentos.quitarMarca(.pentatonicas),
            disposiciones: argumentos.quitarMarca(.disposiciones),
            nombres: argumentos.quitarMarca(.nombres),
            tonalidades: argumentos.quitarMarca(.tonalidades),
            sustituciones: argumentos.quitarMarca(.sustituciones),
            tonalidad: tonalidad, otro: otro)
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaCifrado }
        let bloques = try argumentos.restantes.map { texto in
            let acorde = try Acorde(leyendoEnLaOrden: texto)
            return ([describir(acorde: acorde, notacion)] + relaciones(de: acorde, pedido, notacion))
                .joined(separator: "\n")
        }
        return bien(bloques.joined(separator: "\n\n"))
    }

    /// Lo que se pide de cada acorde además de sus notas.
    struct RelacionesPedidas {
        var bebop: Bool
        var pentatonicas: Bool
        var disposiciones: Bool
        var nombres: Bool
        var tonalidades: Bool
        var sustituciones: Bool
        var tonalidad: Tonalidad?
        var otro: Acorde?
    }

    /// Las líneas de lo pedido de un acorde, cada parte con su título.
    static func relaciones(de acorde: Acorde, _ pedido: RelacionesPedidas, _ notacion: Notacion) -> [String] {
        var lineas: [String] = []
        if pedido.disposiciones {
            lineas.append(notacion.texto(\.disposicion) + ":")
            for disposicion in DisposicionDeAcorde.allCases {
                if let fila = PresentacionDeDisposiciones.acorde(acorde, disposicion, en: notacion)?.filas.first {
                    lineas.append("  " + disposicion.nombre(en: notacion) + ": " + fila.voces)
                }
            }
        }
        if pedido.bebop {
            lineas.append(notacion.texto(\.escalasBebop) + ":")
            lineas += PresentacionDeEstudioDeEscala.bebop(sobre: acorde, en: notacion).map {
                "  " + $0.nombre + ": " + $0.detalle
            }
        }
        if pedido.pentatonicas {
            lineas.append(notacion.texto(\.pentatonicas) + ":")
            lineas += PresentacionDeEstudioDeEscala.pentatonicas(sobre: acorde, en: notacion).map {
                "  " + $0.nombre + ": " + $0.detalle
            }
        }
        let relaciones = PresentacionDeRelacionesDeAcorde.relaciones(
            de: acorde, en: pedido.tonalidad, notacion: notacion)
        if pedido.nombres {
            lineas.append(notacion.texto(\.otrosNombres) + ": " + relaciones.otrosNombres.joined(separator: ", "))
            if let sinFundamental = relaciones.sinFundamental {
                lineas.append(notacion.texto(\.sinLaFundamental) + ": " + sinFundamental)
            }
        }
        if pedido.tonalidades {
            lineas.append(notacion.texto(\.tonalidadesDelAcorde) + ":")
            lineas += relaciones.tonalidades.map { "  " + $0 }
        }
        if pedido.sustituciones {
            lineas.append(notacion.texto(\.sustituciones) + " (" + relaciones.tonalidad.nombre(en: notacion) + "):")
            lineas += relaciones.sustituciones.map { "  " + $0.descripcion }
        }
        if let otro = pedido.otro,
            let comparacion = PresentacionDeRelacionesDeAcorde.comparar(acorde, con: otro, en: notacion)
        {
            lineas.append(notacion.texto(\.compararCon) + " " + otro.cifrado(en: notacion) + ":")
            lineas.append("  " + notacion.texto(\.notasComunes) + ": " + comparacion.comunes)
            lineas += comparacion.voces.reversed().map { "  " + $0 }
            lineas.append("  " + comparacion.movimiento)
        }
        return lineas
    }

    /// El acorde con sus notas y el papel de cada una: los datos de `--json` (`DatosDeAcorde`), en texto.
    static func describir(acorde: Acorde, _ notacion: Notacion) -> String {
        let datos = DatosDeAcorde(acorde, notacion: notacion)
        var lineas = ["\(datos.cifrado): \(datos.nombre)"]
        let notas = datos.notas.joined(separator: " ")
        let traducir = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        if datos.tieneOtroBajo {
            let bajo = traducir(.bajo(datos.bajo))
            let inversion = datos.inversion.map { traducir(.inversion($0)) } ?? traducir(.bajoAjeno)
            lineas.append("  \(traducir(.notas)): \(notas)  (\(bajo), \(inversion))")
        } else {
            lineas.append("  \(traducir(.notas)): \(notas)")
        }
        lineas.append("  " + datos.componentes.map { "\($0.nota) \($0.papel)" }.joined(separator: " · "))
        return lineas.joined(separator: "\n")
    }

    /// `identificar Do Mi Sol Si Fa# [--escalas]` o `identificar --archivo melodia.mid`: los acordes que forman
    /// unas notas o, con `--escalas` o con un fichero, las escalas que las contienen.
    static func identificarConOpciones(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(textos)
        let conEscalas = argumentos.quitarMarca(.escalas)
        let archivo = try argumentos.valor(.archivo)
        try argumentos.sinOpcionesDesconocidas()
        let encontradas: [EscalaEncontrada]
        if let archivo {
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.archivoConNotas }
            let datos = try Self.datos(deArchivo: archivo)
            let pieza = try PiezaImportada(leyendo: datos)
            encontradas = PresentacionDeEstudioDeEscala.escalas(de: pieza, en: notacion)
        } else {
            guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltanNotas }
            guard conEscalas else { return bien(try identificar(argumentos.restantes, notacion)) }
            // Con octava o sin ella, solo cuentan las notas.
            let notas = try argumentos.restantes.map { texto in
                try (try? Altura(leyendoEnLaOrden: texto))?.nota ?? Nota(leyendoEnLaOrden: texto)
            }
            encontradas = PresentacionDeEstudioDeEscala.escalas(conLasNotas: notas, en: notacion)
        }
        // Nunca vacío: la cromática las contiene todas.
        return bien(
            encontradas.map { $0.ademas.isEmpty ? $0.nombre : $0.nombre + " — " + $0.ademas }
                .joined(separator: "\n"))
    }

    /// Los acordes que pueden formar las notas, como en `--json` (`DatosDeCandidato.identificar`).
    static func identificar(_ textos: [String], _ notacion: Notacion) throws -> String {
        let candidatos = try DatosDeCandidato.identificar(textos, en: notacion)
        guard !candidatos.isEmpty else { return Mensaje.sinAcordes.texto(en: notacion) }
        return candidatos.map { candidato in
            var linea = "\(candidato.cifrado)  \(candidato.nombre)"
            if !candidato.omitidas.isEmpty {
                linea += "  (\(Mensaje.sin(candidato.omitidas.joined(separator: ", ")).texto(en: notacion)))"
            }
            return linea
        }.joined(separator: "\n")
    }

    /// `arpegio Do7 --patron alberti`: las notas del arpegio desde la octava 4 y las escalas que encajan con el
    /// acorde (Do7 → Do mixolidio…).
    static func arpegio(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        bien(try arpegios(textos).map { describir(arpegio: $0, notacion) }.joined(separator: "\n\n"))
    }

    /// Los arpegios de `arpegio`, uno por acorde, para el texto y para `--json`. Lanza el `ErrorDeUso` si una opción
    /// está mal escrita.
    static func arpegios(_ textos: [String]) throws -> [Arpegio] {
        var argumentos = Argumentos(textos)
        var patron = Arpegio.Patron.ascendente
        if let texto = try argumentos.valor(.patron) {
            guard let elegido = patronDeArpegio(texto) else { throw ErrorDeUso.patronDesconocido(texto) }
            patron = elegido
        }
        var recorrido = RecorridoDeArpegio()
        try leerRecorrido(&argumentos, en: &recorrido)
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaCifradoDelArpegio }
        var arpegios: [Arpegio] = []
        for texto in argumentos.restantes {
            let acorde = try Acorde(leyendoEnLaOrden: texto)
            var inicio = 0
            if let desde = recorrido.desde {
                let delGrado = Int(desde).flatMap { Arpegio.indice(delGrado: $0, en: acorde) }
                let deLaNota = (try? Nota(leyendoEnLaOrden: desde)).flatMap { Arpegio.indice(de: $0, en: acorde) }
                guard let indice = delGrado ?? deLaNota else { throw ErrorDeUso.desdeNoValido(desde) }
                inicio = indice
            }
            let arpegio: Arpegio
            if let grados = recorrido.grados {
                arpegio = Arpegio(
                    acorde, grados: grados, octavas: recorrido.octavas, aproximacion: recorrido.aproximacion)
            } else {
                arpegio = Arpegio(
                    acorde, patron: patron, octavas: recorrido.octavas, conOctava: recorrido.conOctava, inicio: inicio,
                    tensiones: recorrido.tensiones, aproximacion: recorrido.aproximacion)
            }
            arpegios.append(arpegio)
        }
        return arpegios
    }

    /// Lo que cambia el recorrido de `arpegio`, además del patrón.
    struct RecorridoDeArpegio {
        var octavas = 1
        var conOctava = true
        /// Lo que sigue a `--desde`: una nota o un grado, que se busca en cada acorde.
        var desde: String?
        var tensiones: [Int] = []
        var grados: [Int]?
        var aproximacion: Arpegio.Aproximacion?
    }

    /// Quita y lee `--octavas`, `--sin-octava`, `--desde`, `--tensiones`, `--grados` y `--aproximacion`, o lanza
    /// el `ErrorDeUso` con lo que está mal escrito.
    static func leerRecorrido(_ argumentos: inout Argumentos, en recorrido: inout RecorridoDeArpegio) throws {
        recorrido.conOctava = !argumentos.quitarMarca(.sinOctava)
        let octavas = try argumentos.valor(.octavas)
        recorrido.desde = try argumentos.valor(.desde)
        let tensiones = try argumentos.valor(.tensiones)
        let grados = try argumentos.valor(.grados)
        let aproximacion = try argumentos.valor(.aproximacion)
        if let octavas {
            guard let n = Int(octavas), (1...4).contains(n) else { throw ErrorDeUso.octavasFueraDeRango }
            recorrido.octavas = n
        }
        if let tensiones {
            guard let leidas = try? Arpegio.tensiones(leyendo: tensiones) else { throw ErrorDeUso.tensionesMalEscritas }
            recorrido.tensiones = leidas
        }
        if let grados {
            guard let leidos = try? Arpegio.grados(leyendo: grados) else { throw ErrorDeUso.gradosMalEscritos }
            recorrido.grados = leidos
        }
        if let aproximacion {
            guard let leida = try? Arpegio.Aproximacion(leyendo: aproximacion) else {
                throw ErrorDeUso.aproximacionDesconocida(aproximacion)
            }
            recorrido.aproximacion = leida
        }
    }

    static func describir(arpegio: Arpegio, _ notacion: Notacion) -> String {
        let traducir = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        let notas = arpegio.alturas(octava: 4).map { $0.nombre(en: notacion) }.joined(separator: " ")
        // El patrón, o el recorrido por grados si es propio: «Do (1-5-3-8)».
        let recorrido =
            arpegio.grados.isEmpty
            ? arpegio.patron.nombre(en: notacion) : arpegio.grados.map(String.init).joined(separator: "-")
        var lineas = [
            "\(arpegio.nombre(en: notacion)) (\(recorrido))",
            "  \(traducir(.notas)): \(notas)",
        ]
        // Las escalas del acorde, de las que tienen menos notas a evitar a las que más; con ocho basta para orientarse.
        let escalas = arpegio.acorde.escalasCompatibles()
        if !escalas.isEmpty {
            let nombres = escalas.prefix(8).map { $0.nombre(en: notacion) }.joined(separator: ", ")
            lineas.append("  \(traducir(.escalas)): \(nombres)" + (escalas.count > 8 ? "…" : ""))
        }
        return lineas.joined(separator: "\n")
    }

    /// El patrón de `--patron`, como lo lee `Arpegio.Patron(leyendo:)`: `alberti`, `ida-y-vuelta`, `up-down` o su
    /// nombre en cualquiera de los quince idiomas («bajo de Alberti»).
    static func patronDeArpegio(_ texto: String) -> Arpegio.Patron? { try? Arpegio.Patron(leyendo: texto) }
}
