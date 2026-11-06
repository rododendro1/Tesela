import Armonia
import Foundation
import TeselaPresentacion

// MARK: - Consultas: acordes, notas, escalas, tonalidades y análisis

extension LineaDeComandos {
    /// `intervalo <nota> <nota>`: el intervalo entre dos notas.
    static func consultarIntervalo(_ resto: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        if let opcion = Argumentos(resto).opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        guard resto.count == 2 else { throw ErrorDeUso.dosNotas }
        return bien(try intervalo(resto[0], resto[1], notacion))
    }

    /// `tonalidad <tonalidad>`: su armadura, sus acordes y sus relativas.
    static func consultarTonalidad(_ resto: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(resto)
        let modulaciones = argumentos.quitarOpcionConPalabras("--modulaciones", "--modulations")
        if let opcion = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaTonalidad }
        let tonalidad = try Tonalidad(leyendo: argumentos.unidos)
        var lineas = [describir(tonalidad: tonalidad, notacion)]
        // `--modulaciones [Sol mayor]`: a los tonos vecinos o, si se da, a esa tonalidad de todas las maneras.
        var destino: Tonalidad?
        switch modulaciones {
        case .ausente: return bien(lineas[0])
        case .sinValor: destino = nil
        case .valor(let texto): destino = try Tonalidad(leyendo: texto)
        }
        lineas.append(notacion.texto(\.modulaciones) + ":")
        lineas += PresentacionDeModulaciones.modulaciones(desde: tonalidad, hasta: destino, notacion: notacion).map {
            "  " + $0.destino + " · " + $0.tecnica + ": " + $0.plan.descripcion(en: notacion)
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// `conjunto <clases>`: el conjunto de clases de altura, con su forma prima y su vector.
    static func consultarConjunto(_ resto: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        if let opcion = Argumentos(resto).opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        guard !resto.isEmpty else { throw ErrorDeUso.faltaConjunto }
        return bien(describir(conjunto: try ConjuntoDeClasesDeAltura(leyendo: resto.joined(separator: " ")), notacion))
    }

    /// `serie <doce notas>`: la serie dodecafónica y su matriz.
    static func consultarSerie(_ resto: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        if let opcion = Argumentos(resto).opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        guard !resto.isEmpty else { throw ErrorDeUso.faltaSerie }
        return bien(describir(serie: try SerieDodecafonica(leyendo: resto.joined(separator: " ")), notacion))
    }

    /// `acorde Sol7 [--disposiciones] [--nombres] [--tonalidades] [--sustituciones] [--comparar Do] [--en Do mayor]`:
    /// cada acorde con sus notas y, si se piden, sus disposiciones, sus otros nombres, las tonalidades en que está,
    /// sus sustituciones (en la tonalidad de `--en` o en la suya) y la conducción hasta otro acorde.
    static func acorde(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(textos)
        guard let tonalidad = try argumentos.quitarTonalidad() else { throw ErrorDeUso.faltaTonalidadTrasEn }
        var otro: Acorde?
        if let texto = try argumentos.valor("--comparar", "--compare") { otro = try Acorde(leyendo: texto) }
        let pedido = RelacionesPedidas(
            bebop: argumentos.quitarMarca("--bebop"),
            pentatonicas: argumentos.quitarMarca("--pentatonicas", "--pentatonics"),
            disposiciones: argumentos.quitarMarca("--disposiciones", "--voicings"),
            nombres: argumentos.quitarMarca("--nombres", "--names"),
            tonalidades: argumentos.quitarMarca("--tonalidades", "--keys"),
            sustituciones: argumentos.quitarMarca("--sustituciones", "--substitutions"),
            tonalidad: tonalidad, otro: otro)
        if let desconocida = argumentos.opcionDesconocida {
            throw ErrorDeUso.opcionDesconocida(desconocida)
        }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaCifrado }
        let bloques = try argumentos.restantes.map { texto in
            let acorde = try Acorde(leyendo: texto)
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
                if let fila = PresentacionDeDisposiciones.acorde(acorde, disposicion, notacion: notacion)?.filas.first {
                    lineas.append("  " + disposicion.nombre(en: notacion) + ": " + fila.voces)
                }
            }
        }
        if pedido.bebop {
            lineas.append(notacion.texto(\.escalasBebop) + ":")
            lineas += PresentacionDeEstudioDeEscala.bebop(sobre: acorde, notacion: notacion).map {
                "  " + $0.nombre + ": " + $0.detalle
            }
        }
        if pedido.pentatonicas {
            lineas.append(notacion.texto(\.pentatonicas) + ":")
            lineas += PresentacionDeEstudioDeEscala.pentatonicas(sobre: acorde, notacion: notacion).map {
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
            let comparacion = PresentacionDeRelacionesDeAcorde.comparar(acorde, con: otro, notacion: notacion)
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
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        if datos.tieneOtroBajo {
            let bajo = t(.bajo(datos.bajo))
            let inversion = datos.inversion.map { t(.inversion($0)) } ?? t(.bajoAjeno)
            lineas.append("  \(t(.notas)): \(notas)  (\(bajo), \(inversion))")
        } else {
            lineas.append("  \(t(.notas)): \(notas)")
        }
        lineas.append("  " + datos.componentes.map { "\($0.nota) \($0.papel)" }.joined(separator: " · "))
        return lineas.joined(separator: "\n")
    }

    /// `identificar Do Mi Sol Si Fa# [--escalas]` o `identificar --archivo melodia.mid`: los acordes que forman
    /// unas notas o, con `--escalas` o con un fichero, las escalas que las contienen.
    static func identificarConOpciones(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(textos)
        let conEscalas = argumentos.quitarMarca("--escalas", "--scales")
        let archivo = try argumentos.valor("--archivo", "--file")
        if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
        let encontradas: [EscalaEncontrada]
        if let archivo {
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.archivoConNotas }
            guard let datos = contenido(deArchivo: archivo) else { return archivoIlegible(archivo, notacion) }
            let pieza = try PiezaImportada(leyendo: datos)
            encontradas = PresentacionDeEstudioDeEscala.escalas(de: pieza, notacion: notacion)
        } else {
            guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltanNotas }
            guard conEscalas else { return bien(try identificar(argumentos.restantes, notacion)) }
            // Con octava o sin ella, solo cuentan las notas.
            let notas = try argumentos.restantes.map { texto in
                try (try? Altura(leyendo: texto))?.nota ?? Nota(leyendo: texto)
            }
            encontradas = PresentacionDeEstudioDeEscala.escalas(conLasNotas: notas, notacion: notacion)
        }
        // Nunca vacío: la cromática las contiene todas.
        return bien(
            encontradas.map { $0.ademas.isEmpty ? $0.nombre : $0.nombre + " — " + $0.ademas }
                .joined(separator: "\n"))
    }

    /// Los acordes que pueden formar las notas, como en `--json` (`DatosDeCandidato.identificar`).
    static func identificar(_ textos: [String], _ notacion: Notacion) throws -> String {
        let candidatos = try DatosDeCandidato.identificar(textos, notacion: notacion)
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
        if let texto = try argumentos.valor("--patron", "--patrón", "--pattern") {
            guard let elegido = patronDeArpegio(texto) else { throw ErrorDeUso.patronDesconocido(texto) }
            patron = elegido
        }
        var recorrido = RecorridoDeArpegio()
        try leerRecorrido(&argumentos, en: &recorrido)
        if let desconocida = argumentos.opcionDesconocida {
            throw ErrorDeUso.opcionDesconocida(desconocida)
        }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaCifradoDelArpegio }
        var arpegios: [Arpegio] = []
        for texto in argumentos.restantes {
            let acorde = try Acorde(leyendo: texto)
            var inicio = 0
            if let desde = recorrido.desde {
                let delGrado = Int(desde).flatMap { Arpegio.indice(delGrado: $0, en: acorde) }
                let deLaNota = (try? Nota(leyendo: desde)).flatMap { Arpegio.indice(de: $0, en: acorde) }
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
        recorrido.conOctava = !argumentos.quitarMarca("--sin-octava", "--no-octave")
        let octavas = try argumentos.valor("--octavas", "--octaves")
        recorrido.desde = try argumentos.valor("--desde", "--from")
        let tensiones = try argumentos.valor("--tensiones", "--tensions")
        let grados = try argumentos.valor("--grados", "--degrees")
        let aproximacion = try argumentos.valor("--aproximacion", "--aproximación", "--approach")
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
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        let notas = arpegio.alturas(octava: 4).map { $0.nombre(en: notacion) }.joined(separator: " ")
        // El patrón, o el recorrido por grados si es propio: «Do (1-5-3-8)».
        let recorrido =
            arpegio.grados.isEmpty
            ? arpegio.patron.nombre(en: notacion) : arpegio.grados.map(String.init).joined(separator: "-")
        var lineas = [
            "\(arpegio.nombre(en: notacion)) (\(recorrido))",
            "  \(t(.notas)): \(notas)",
        ]
        // Las escalas del acorde, de las que tienen menos notas a evitar a las que más; con ocho basta para orientarse.
        let escalas = arpegio.acorde.escalasCompatibles()
        if !escalas.isEmpty {
            let nombres = escalas.prefix(8).map { $0.nombre(en: notacion) }.joined(separator: ", ")
            lineas.append("  \(t(.escalas)): \(nombres)" + (escalas.count > 8 ? "…" : ""))
        }
        return lineas.joined(separator: "\n")
    }

    /// El patrón de `--patron`, como lo lee `Arpegio.Patron(leyendo:)`: `alberti`, `ida-y-vuelta`, `up-down` o su
    /// nombre en cualquiera de los quince idiomas («bajo de Alberti»).
    static func patronDeArpegio(_ texto: String) -> Arpegio.Patron? { try? Arpegio.Patron(leyendo: texto) }

    static func intervalo(_ a: String, _ b: String, _ notacion: Notacion) throws -> String {
        let intervalo = try intervalo(a, b)
        let semitonos = Mensaje.semitonos(intervalo.semitonos).texto(en: notacion)
        return "\(intervalo.nombre(en: notacion)) (\(intervalo.texto(en: notacion)), \(semitonos))"
    }

    /// El intervalo de una nota a otra: entre las alturas si las dos llevan octava (Do4 Mi5 es una décima), y si no,
    /// el ascendente entre las notas.
    static func intervalo(_ a: String, _ b: String) throws -> Intervalo {
        if let grave = try? Altura(leyendo: a), let aguda = try? Altura(leyendo: b) { return aguda - grave }
        return try Nota(leyendo: a).intervalo(hasta: try Nota(leyendo: b))
    }

    /// Con `conTodosSusAcordes` (`--acordes`), también los acordes que caben sobre cada grado, no solo los de
    /// terceras.
    /// Lo que pide `escala`: la escala y sus opciones, lo mismo para el texto y para `--json`.
    struct PedidoDeEscala {
        let escala: Escala
        /// `--acordes`: todos los acordes que caben en cada grado (y, con `--doce`, los de cada grado en las doce).
        let conAcordes: Bool
        /// `--secuencia`, a lo largo de `--octavas` octavas, bajando con `--bajando`.
        let secuencia: SecuenciaDeEscala?
        let octavas: Int
        let bajando: Bool
        let piano: Bool
        let modos: Bool
        let simetria: Bool
        let vecinas: Bool
        /// `--estadisticas`.
        let estadisticas: Bool
        /// `--escalera`.
        let escalera: Bool
        let doce: Bool
        /// `--triadas`: con `--doce` y `--acordes`, tríadas en lugar de cuatríadas.
        let triadas: Bool
        /// `--comparar`.
        let otra: Escala?
        /// `--contra`: la comparación nota a nota, en SVG.
        let contra: Escala?
        /// `--parecidas`: las escalas con más notas en común.
        let parecidas: Bool

        var sentido: SentidoDelIntervalo { bajando ? .descendente : .ascendente }
    }

    /// Lee la escala y las opciones de `escala`, o lanza el `ErrorDeUso` de lo que está mal escrito.
    static func pedidoDeEscala(_ textos: [String]) throws -> PedidoDeEscala {
        var argumentos = Argumentos(textos)
        let conAcordes = argumentos.quitarMarca("--acordes", "--chords")
        let bajando = argumentos.quitarMarca("--bajando", "--descending")
        let piano = argumentos.quitarMarca("--piano")
        let modos = argumentos.quitarMarca("--modos", "--modes")
        let simetria = argumentos.quitarMarca("--simetria", "--symmetry")
        let vecinas = argumentos.quitarMarca("--vecinas", "--neighbors")
        let parecidas = argumentos.quitarMarca("--parecidas", "--closest")
        let estadisticas = argumentos.quitarMarca("--estadisticas", "--statistics")
        let escalera = argumentos.quitarMarca("--escalera", "--brightness-ladder")
        let doce = argumentos.quitarMarca("--doce", "--all-keys")
        let triadas = argumentos.quitarMarca("--triadas", "--triads")
        guard let octavas = argumentos.quitarNumero("--octavas", "--octaves", en: 1...4, porDefecto: 1) else {
            throw ErrorDeUso.octavasFueraDeRango
        }
        var secuencia: SecuenciaDeEscala?
        if let texto = try argumentos.valor("--secuencia", "--sequence") {
            guard let elegida = secuenciaDeEscala(texto) else { throw ErrorDeUso.secuenciaDesconocida(texto) }
            secuencia = elegida
        }
        var otra: Escala?
        if let texto = try argumentos.valorConPalabras("--comparar", "--compare") { otra = try Escala(leyendo: texto) }
        var contra: Escala?
        if let texto = try argumentos.valorConPalabras("--contra", "--against") { contra = try Escala(leyendo: texto) }
        if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscala }
        return PedidoDeEscala(
            escala: try Escala(leyendo: argumentos.unidos), conAcordes: conAcordes, secuencia: secuencia,
            octavas: octavas, bajando: bajando, piano: piano, modos: modos, simetria: simetria, vecinas: vecinas,
            estadisticas: estadisticas, escalera: escalera, doce: doce, triadas: triadas, otra: otra,
            contra: contra, parecidas: parecidas)
    }

    /// `escala Do mayor [--acordes] [--secuencia terceras] [--bajando] [--octavas 2] [--piano] [--modos]
    /// [--estadisticas] [--escalera] [--comparar Do lidio]`: la escala y, si se piden, todos los acordes que caben en
    /// cada grado, una secuencia de estudio, la digitación de piano, los modos paralelos y relativos, lo que se mide de
    /// ella, su escalera de brillo y la comparación con otra escala. Con `--contra Do dórico`, solo la comparación
    /// nota a nota, en SVG.
    static func escala(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let pedido = try pedidoDeEscala(textos)
        let escala = pedido.escala
        if let contra = pedido.contra {
            return bien(PresentacionDeEstudioDeEscala.comparacionNotaANota(escala, con: contra, notacion: notacion))
        }
        var lineas = [describir(escala: escala, conTodosSusAcordes: pedido.conAcordes, notacion)]
        if let secuencia = pedido.secuencia {
            let presentada = PresentacionDeEstudioDeEscala.secuencia(
                escala, secuencia, octavas: pedido.octavas, sentido: pedido.sentido, notacion: notacion)
            lineas.append(notacion.texto(\.secuencia) + " " + secuencia.nombre(en: notacion) + ":")
            lineas.append("  " + presentada.notas)
        }
        if pedido.piano {
            lineas.append(notacion.texto(\.digitacionDePiano) + ":")
            let digitaciones = PresentacionDeEstudioDeEscala.digitaciones(
                escala, octavas: pedido.octavas, notacion: notacion)
            for mano in digitaciones {
                let pares = zip(mano.notas.split(separator: " "), mano.dedos.split(separator: " "))
                lineas.append("  " + mano.mano + ": " + pares.map { "\($0) \($1)" }.joined(separator: " · "))
            }
        }
        if pedido.modos {
            lineas.append(notacion.texto(\.modosParalelos) + ":")
            lineas += PresentacionDeEstudioDeEscala.modosParalelos(de: escala, notacion: notacion).map { modo in
                "  " + modo.nombre + " (" + modo.brillo + ")" + (modo.cambios.isEmpty ? "" : ": " + modo.cambios)
            }
            let relativos = PresentacionDeEstudioDeEscala.modosRelativos(de: escala, notacion: notacion)
            lineas.append(notacion.texto(\.modosRelativos) + ":")
            lineas.append("  " + relativos.map(\.nombre).joined(separator: " · "))
        }
        if pedido.simetria { lineas += lineasDeSimetria(de: escala, notacion) }
        if pedido.vecinas {
            lineas.append(notacion.texto(\.escalasVecinas) + ":")
            lineas += PresentacionDeEstudioDeEscala.vecinas(de: escala, notacion: notacion).map {
                "  " + $0.nombre + ": " + $0.detalle
            }
        }
        if pedido.parecidas {
            lineas.append(notacion.texto(\.escalasParecidas) + ":")
            lineas += PresentacionDeEstudioDeEscala.parecidas(a: escala, notacion: notacion).map {
                "  " + $0.nombre + ": " + $0.detalle
            }
        }
        if pedido.estadisticas {
            lineas.append(notacion.texto(\.estadisticas) + ":")
            lineas += PresentacionDeEstudioDeEscala.estadisticas(de: escala, notacion: notacion).map {
                "  " + $0.nombre + ": " + $0.valor
            }
        }
        // `--escalera`: de la más oscura a la más brillante, «  +3  Do lidio · Fa → Fa♯», con «←» en la de partida.
        if pedido.escalera {
            lineas.append(notacion.texto(\.escaleraDeBrillo) + ":")
            lineas += PresentacionDeEstudioDeEscala.escaleraDeBrillo(de: escala, notacion: notacion).map { peldano in
                let cambio = peldano.cambio.isEmpty ? "" : " · " + peldano.cambio
                return "  " + peldano.brillo + "  " + peldano.nombre + cambio + (peldano.esLaDePartida ? " ←" : "")
            }
        }
        if pedido.doce {
            let hoja = PresentacionDeEstudioDeEscala.enLasDoceTonalidades(
                escala, secuencia: pedido.secuencia, notacion: notacion)
            lineas.append(hoja.titulo + ":")
            lineas += hoja.tonalidades.map { "  " + $0.titulo + ": " + $0.notas }
            // Con --acordes, también los acordes de cada grado en las doce, si la escala los forma.
            if pedido.conAcordes,
                let tabla = PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(
                    escala, cuatriadas: !pedido.triadas, notacion: notacion)
            {
                lineas.append(tabla.titulo + ":")
                lineas.append("  " + tabla.grados.joined(separator: " · "))
                lineas += tabla.filas.map { "  " + $0.tonalidad + ": " + $0.acordes.joined(separator: " · ") }
            }
        }
        if let otra = pedido.otra {
            let comparacion = PresentacionDeEstudioDeEscala.comparar(escala, con: otra, notacion: notacion)
            lineas.append(notacion.texto(\.compararCon) + " " + otra.nombre(en: notacion) + ":")
            lineas.append("  " + notacion.texto(\.notasComunes) + ": " + comparacion.comunes)
            let resto = [comparacion.soloEnOrigen, comparacion.soloEnDestino] + comparacion.cambios
            lineas += (resto + [comparacion.distancia ?? ""]).filter { !$0.isEmpty }.map { "  " + $0 }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// `escala … --simetria`: cada cuánto se repite, desde qué notas empieza igual y los acordes que se repiten. Una
    /// escala que no es simétrica se repite a la octava, con sus doce transposiciones.
    static func lineasDeSimetria(de escala: Escala, _ notacion: Notacion) -> [String] {
        var lineas = [notacion.texto(\.simetria) + ":"]
        guard let simetria = PresentacionDeEstudioDeEscala.simetria(de: escala, notacion: notacion) else {
            let veces = escala.transposicionesDistintas
            return lineas + ["  " + notacion.texto { $0.repiteCada(veces, veces) }]
        }
        lineas.append("  " + simetria.resumen)
        lineas.append("  " + notacion.texto(\.tonicasEquivalentes) + ": " + simetria.tonicas)
        lineas += simetria.ciclos.map { "  " + $0.nombre + ": " + $0.detalle }
        return lineas
    }

    /// La secuencia de `--secuencia`, por su nombre en español o en inglés.
    static func secuenciaDeEscala(_ texto: String) -> SecuenciaDeEscala? {
        let nombres: [String: SecuenciaDeEscala] = [
            "terceras": .terceras, "thirds": .terceras, "cuartas": .cuartas, "fourths": .cuartas,
            "grupos-de-3": .gruposDeTres, "groups-of-3": .gruposDeTres, "grupos-de-4": .gruposDeCuatro,
            "groups-of-4": .gruposDeCuatro, "triadas": .triadas, "tríadas": .triadas, "triads": .triadas,
            "cuatriadas": .cuatriadas, "sevenths": .cuatriadas,
        ]
        return nombres[texto.lowercased()]
    }

    /// La escala con los datos de `--json` (`DatosDeEscala`) y, además, sus microtonos y, si se piden, todos los
    /// acordes que caben en ella.
    static func describir(escala: Escala, conTodosSusAcordes: Bool = false, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        let datos = DatosDeEscala(escala, notacion: notacion)
        var lineas = [datos.nombre, "  \(t(.notas)): " + datos.notas.joined(separator: " ")]
        // De qué escala es modo: Re dórico → modo 2 de Do mayor.
        if let modo = datos.modo { lineas.append("  " + modo) }
        // La versión microtonal (Re Bayātī: Re Mi𝄳 Fa…) y los cents de cada grado, si la escala la tiene.
        if let subida = escala.notasMicrotonales() {
            let bajada = escala.notasMicrotonales(sentido: .descendente) ?? subida
            func nombres(_ notas: [NotaMicrotonal]) -> String {
                notas.map { $0.nombre(en: notacion) }.joined(separator: " ")
            }
            func cents(_ notas: [NotaMicrotonal]) -> String {
                notas.map { "\(Int($0.cents.rounded()))" }.joined(separator: " ")
            }
            lineas.append("  \(t(.microtonos)): " + nombres(subida))
            lineas.append("  ¢: " + cents(subida))
            if bajada != subida {
                lineas.append("  \(t(.microtonos)) ↓: " + nombres(bajada))
                lineas.append("  ¢ ↓: " + cents(bajada))
            }
        }
        // Los acordes de cada grado, si la escala es heptatónica y todos forman un acorde conocido.
        if let acordes = datos.acordes {
            let pares = acordes.map { "\($0.grado) \($0.cifrado)" }
            lineas.append("  \(t(.acordes)): " + pares.joined(separator: " · "))
        }
        let grados = conTodosSusAcordes ? PresentacionDeEscalaYAcorde.acordesQueCaben(escala, notacion: notacion) : []
        if !grados.isEmpty {
            lineas.append("  " + notacion.texto(\.acordesQueCaben) + ":")
            lineas += grados.map { "    \($0.grado): \($0.cifrados)" }
        }
        return lineas.joined(separator: "\n")
    }

    // MARK: Catálogo de escalas

    /// Cómo se escribe cada tradición en `--tradicion`, con los nombres españoles y con los ingleses (se aceptan los
    /// dos en cualquier idioma): `--tradicion mundo-arabe`, `--tradition arab-world`.
    static let nombresDeLasTradiciones: [(tradicion: Tradicion, espanol: String, ingles: String)] = [
        (.india, "india", "india"), (.grecia, "grecia", "greece"), (.greciaAntigua, "grecia-antigua", "ancient-greece"),
        (.mundoArabe, "mundo-arabe", "arab-world"), (.persia, "persia", "persia"), (.turquia, "turquia", "turkey"),
        (.azerbaiyan, "azerbaiyan", "azerbaijan"), (.china, "china", "china"), (.japon, "japon", "japan"),
        (.corea, "corea", "korea"), (.etiopia, "etiopia", "ethiopia"), (.indonesia, "indonesia", "indonesia"),
        (.klezmer, "klezmer", "klezmer"), (.andes, "andes", "andes"), (.bizancio, "bizancio", "byzantium"),
        (.mesopotamia, "mesopotamia", "mesopotamia"), (.africa, "africa", "africa"),
        (.sudesteAsiatico, "sudeste-asiatico", "southeast-asia"), (.gregoriano, "gregoriano", "gregorian"),
        (.europa, "europa", "europe"), (.vietnam, "vietnam", "vietnam"), (.brasil, "brasil", "brazil"),
    ]

    /// Cómo se escribe cada uso en `--uso`, en español y en inglés (se aceptan los dos en cualquier idioma):
    /// `--uso siglo-xx`, `--use 20th-century`.
    static let nombresDeLosUsos: [(uso: UsoDeEscala, espanol: String, ingles: String)] = [
        (.clasica, "clasica", "classical"), (.jazz, "jazz", "jazz"), (.blues, "blues", "blues"),
        (.sigloXX, "siglo-xx", "20th-century"), (.popular, "popular", "folk"), (.sintetica, "sintetica", "synthetic"),
    ]

    /// Un texto para comparar nombres: sin mayúsculas, tildes, guiones ni espacios («Mundo árabe» → «mundoarabe»).
    private static func claveDeBusqueda(_ texto: String) -> String {
        texto.replacingOccurrences(of: "ı", with: "i")
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
            .filter { $0.isLetter || $0.isNumber }
    }

    /// `tradiciones`: cada tradición del catálogo, con cómo se escribe en `--tradicion` y cuántas escalas tiene de cada
    /// categoría: «Japón (japon): escala 13». `tradiciones japon [--categoria …]` es `escalas --tradicion japon`.
    static func tradiciones(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        if let primera = argumentos.first, !Argumentos.pareceUnaOpcion(primera) {
            return try escalas(["--tradicion"] + argumentos, notacion)
        }
        if let opcion = Argumentos(argumentos).opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        let lineas = catalogoDeTradiciones().map { ficha in
            let clave = ejemplo(ficha.claves.espanol, ficha.claves.ingles).en(notacion)
            let categorias = ficha.categorias.map { "\($0.categoria.nombre(en: notacion)) \($0.escalas)" }
            return "\(ficha.tradicion.nombre(en: notacion)) (\(clave)): " + categorias.joined(separator: " · ")
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// Una tradición del catálogo: cómo se escribe en `--tradicion` y cuántas escalas tiene de cada categoría, en el
    /// orden del catálogo.
    struct TradicionDelCatalogo {
        let tradicion: Tradicion
        let claves: (espanol: String, ingles: String)
        let categorias: [(categoria: CategoriaTradicional, escalas: Int)]
    }

    /// Las tradiciones, en el orden de `Tradicion.allCases`, con sus categorías en el de `TipoDeEscala.tradicionales`.
    static func catalogoDeTradiciones() -> [TradicionDelCatalogo] {
        Tradicion.allCases.compactMap { tradicion in
            guard let claves = nombresDeLasTradiciones.first(where: { $0.tradicion == tradicion }) else { return nil }
            var categorias: [(categoria: CategoriaTradicional, escalas: Int)] = []
            for tipo in TipoDeEscala.tradicionales where tipo.tradicion == tradicion {
                guard let categoria = tipo.categoria else { continue }
                if let i = categorias.firstIndex(where: { $0.categoria == categoria }) {
                    categorias[i].escalas += 1
                } else {
                    categorias.append((categoria, 1))
                }
            }
            return TradicionDelCatalogo(
                tradicion: tradicion, claves: (claves.espanol, claves.ingles), categorias: categorias)
        }
    }

    /// Cómo ordena `escalas --orden`: de la más brillante a la más oscura (por `brilloPorQuintas`) o de menos a más
    /// notas.
    enum OrdenDeEscalas { case brillo, notas }

    /// Los valores de `escalas --orden`, en español y en inglés.
    static let ordenesDeEscalas: [String: OrdenDeEscalas] = [
        "brillo": .brillo, "brightness": .brillo, "notas": .notas, "notes": .notas,
    ]

    /// Unas filas de texto en columnas alineadas, separadas por dos espacios, sin espacios al final.
    static func columnas(_ filas: [[String]]) -> String {
        let anchos = filas.reduce(into: [Int]()) { anchos, fila in
            for (i, celda) in fila.enumerated() {
                if i < anchos.count { anchos[i] = max(anchos[i], celda.count) } else { anchos.append(celda.count) }
            }
        }
        return filas.map { fila in
            fila.enumerated().map { i, celda in celda + String(repeating: " ", count: anchos[i] - celda.count) }
                .joined(separator: "  ").replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        }.joined(separator: "\n")
    }

    /// Las clases interválicas de `escalas --con-intervalo` y `--sin-intervalo`, por su nombre en español y en inglés
    /// (también valen sus números, del 1 al 6).
    static let clasesIntervalicasPorNombre: [String: Int] = [
        "semitono": 1, "semitone": 1, "tono": 2, "tone": 2, "terceramenor": 3, "minorthird": 3, "terceramayor": 4,
        "majorthird": 4, "cuarta": 5, "fourth": 5, "tritono": 6, "tritone": 6,
    ]

    /// La clase interválica (1…6) de un número o un nombre, o el error de uso.
    static func claseIntervalica(_ texto: String) throws -> Int {
        if let n = Int(texto), (1...6).contains(n) { return n }
        guard let clase = clasesIntervalicasPorNombre[claveDeBusqueda(texto)] else {
            throw ErrorDeUso.intervaloDeEscalasDesconocido(texto)
        }
        return clase
    }

    /// `escalas [<texto>] [--tradicion <tradición>] [--categoria <categoría>] [--uso <uso>] [--notas <n>]
    /// [--orden brillo] [--con-intervalo tritono] [--comparar Do mayor, Do lidio]`: el
    /// catálogo de escalas, las habituales y las de otras tradiciones agrupadas por tradición y categoría, cada una
    /// con sus notas desde Do (y la marca de los microtonos, si los tiene). Un texto suelto busca en los nombres.
    /// `--uso jazz` deja solo las habituales de ese uso (las de otras tradiciones no tienen), y `--notas 5`, las de
    /// cinco notas. `--comparar` deja el catálogo y pone las escalas que se le dan en una tabla, una por fila, y
    /// `--mapa` lo dibuja en un mapa de brillo (SVG).
    static func escalas(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        var entrada = Argumentos(argumentos)
        // `--comparar Do mayor, Do dórico, Do lidio`: las escalas en una tabla, con lo que se mide de cada una.
        if let texto = try entrada.valorConPalabras("--comparar", "--compare") {
            if let opcion = entrada.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
            let nombres = texto.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            guard !nombres.isEmpty else { throw ErrorDeUso.faltaValor("--comparar") }
            let escalas = try nombres.map { try Escala(leyendo: $0) }
            let tabla = PresentacionDeEstudioDeEscala.tablaDeEstadisticas(escalas, notacion: notacion)
            return bien(columnas([tabla.encabezados] + tabla.filas))
        }
        // `--mapa [Re dórico] [--notas 7]`: el mapa de brillo en SVG, resaltando la escala que se dé.
        if entrada.quitarMarca("--mapa", "--map") {
            var numeroDeNotas = 7
            if let texto = try entrada.valor("--notas", "--notes", siFalta: .notasFueraDeRango) {
                guard let n = Int(texto), (1...24).contains(n) else { throw ErrorDeUso.notasFueraDeRango }
                numeroDeNotas = n
            }
            if let opcion = entrada.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
            let resaltada = entrada.restantes.isEmpty ? nil : try Escala(leyendo: entrada.unidos)
            return bien(
                PresentacionDeEstudioDeEscala.mapaDeBrillo(
                    numeroDeNotas: numeroDeNotas, resaltada: resaltada, notacion: notacion))
        }
        var tradicion: Tradicion?
        if let texto = try entrada.valor("--tradicion", "--tradición", "--tradition") {
            let clave = claveDeBusqueda(texto)
            guard
                let encontrada = nombresDeLasTradiciones.first(where: {
                    claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
                })
            else { throw ErrorDeUso.tradicionDesconocida(texto) }
            tradicion = encontrada.tradicion
        }
        var categoria: CategoriaTradicional?
        if let texto = try entrada.valor("--categoria", "--categoría", "--category") {
            let clave = claveDeBusqueda(texto)
            let nombres = { (candidata: CategoriaTradicional) in
                [candidata.rawValue, candidata.nombre, candidata.nombre(en: notacion)].map(claveDeBusqueda)
            }
            guard let encontrada = CategoriaTradicional.allCases.first(where: { nombres($0).contains(clave) }) else {
                throw ErrorDeUso.categoriaDesconocida(texto)
            }
            categoria = encontrada
        }
        var usoPedido: UsoDeEscala?
        if let texto = try entrada.valor("--uso", "--use") {
            let clave = claveDeBusqueda(texto)
            let nombres = { (candidato: UsoDeEscala) -> [String] in
                let claves = nombresDeLosUsos.first { $0.uso == candidato }.map { [$0.espanol, $0.ingles] } ?? []
                return (claves + [candidato.nombre, candidato.nombre(en: notacion)]).map(claveDeBusqueda)
            }
            guard let encontrado = UsoDeEscala.allCases.first(where: { nombres($0).contains(clave) }) else {
                throw ErrorDeUso.usoDesconocido(texto)
            }
            usoPedido = encontrado
        }
        // `--notas 5`: solo las de cinco notas (las pentatónicas).
        var numeroDeNotas: Int?
        if let texto = try entrada.valor("--notas", "--notes", siFalta: .notasFueraDeRango) {
            guard let n = Int(texto), (1...24).contains(n) else { throw ErrorDeUso.notasFueraDeRango }
            numeroDeNotas = n
        }
        // `--orden brillo`, `--sin-semitonos`, `--regulares`: por lo que se mide de cada escala.
        var orden: OrdenDeEscalas?
        if let texto = try entrada.valor("--orden", "--sort") {
            guard let elegido = ordenesDeEscalas[claveDeBusqueda(texto)] else {
                throw ErrorDeUso.ordenDeEscalasDesconocido(texto)
            }
            orden = elegido
        }
        let sinSemitonos = entrada.quitarMarca("--sin-semitonos", "--anhemitonic")
        // `--con-intervalo tritono`, `--sin-intervalo 1`, `--con-paso 3`: por el vector interválico y los pasos.
        var conIntervalo: Int?
        if let texto = try entrada.valor("--con-intervalo", "--with-interval") {
            conIntervalo = try claseIntervalica(texto)
        }
        var sinIntervalo: Int?
        if let texto = try entrada.valor("--sin-intervalo", "--without-interval") {
            sinIntervalo = try claseIntervalica(texto)
        }
        var conPaso: Int?
        if let texto = try entrada.valor("--con-paso", "--with-step", siFalta: .pasoFueraDeRango) {
            guard let n = Int(texto), (1...11).contains(n) else { throw ErrorDeUso.pasoFueraDeRango }
            conPaso = n
        }
        let regulares = entrada.quitarMarca("--regulares", "--maximally-even")
        if let opcion = entrada.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        let buscado = claveDeBusqueda(entrada.unidos)
        func estadisticas(_ tipo: TipoDeEscala) -> EstadisticasDeEscala { Escala(.do, tipo).estadisticas }
        func cumple(_ tipo: TipoDeEscala) -> Bool {
            guard numeroDeNotas == nil || tipo.numeroDeNotas == numeroDeNotas else { return false }
            guard !sinSemitonos || estadisticas(tipo).anhemitonica else { return false }
            guard !regulares || estadisticas(tipo).maximamenteRegular else { return false }
            if conIntervalo != nil || sinIntervalo != nil || conPaso != nil {
                let medidas = estadisticas(tipo)
                if let conIntervalo, medidas.vectorIntervalico[conIntervalo - 1] == 0 { return false }
                if let sinIntervalo, medidas.vectorIntervalico[sinIntervalo - 1] > 0 { return false }
                if let conPaso, !medidas.pasos.contains(conPaso) { return false }
            }
            return buscado.isEmpty || claveDeBusqueda(tipo.nombre(en: notacion)).contains(buscado)
                || claveDeBusqueda(tipo.nombre).contains(buscado)
        }

        // Los grupos, en el orden del catálogo: las habituales (si no se filtra por tradición ni por categoría) y,
        // después, cada tradición con su categoría.
        var grupos: [(titulo: String, tipos: [TipoDeEscala])] = []
        if tradicion == nil && categoria == nil {
            if let usoPedido {
                let delUso = TipoDeEscala.todos(uso: usoPedido).filter(cumple)
                if !delUso.isEmpty { grupos.append((t(.habituales) + " · " + usoPedido.nombre(en: notacion), delUso)) }
            } else {
                let habituales = TipoDeEscala.todos.filter(cumple)
                if !habituales.isEmpty { grupos.append((t(.habituales), habituales)) }
            }
        }
        for tipo in TipoDeEscala.tradicionales where usoPedido == nil && cumple(tipo) {
            guard let suya = tipo.tradicion, let deTipo = tipo.categoria else { continue }
            guard tradicion == nil || tradicion == suya, categoria == nil || categoria == deTipo else { continue }
            let titulo = suya.nombre(en: notacion) + " · " + deTipo.nombre(en: notacion)
            if let i = grupos.firstIndex(where: { $0.titulo == titulo }) {
                grupos[i].tipos.append(tipo)
            } else {
                grupos.append((titulo, [tipo]))
            }
        }
        guard !grupos.isEmpty else {
            // `escalas` busca por el nombre: con unas notas, lo que se quería era `identificar --escalas`.
            let palabras = entrada.restantes
            let sonNotas = !palabras.isEmpty && palabras.allSatisfy { (try? Nota(leyendo: $0)) != nil }
            let texto =
                sonNotas
                ? TextosDeCLI.en(notacion) {
                    $0.escalasPorNotas(
                        ejemplo(
                            "armonia identificar --escalas " + entrada.unidos,
                            "armonia identify --scales " + entrada.unidos
                        ).en(notacion))
                } : t(.ningunaEscala)
            return ResultadoDeOrden(salida: "", error: "armonia: " + texto + "\n", codigo: 1)
        }
        // Con `--orden`, cada grupo de la más brillante a la más oscura, o de menos a más notas; a igualdad, en el
        // orden del catálogo.
        func ordenados(_ tipos: [TipoDeEscala]) -> [TipoDeEscala] {
            guard let orden else { return tipos }
            // La clave de cada una, de menor a mayor: el brillo, cambiado de signo, o el número de notas.
            let claves = tipos.map { orden == .brillo ? -estadisticas($0).brilloPorQuintas : Double($0.numeroDeNotas) }
            return tipos.indices.sorted { (claves[$0], $0) < (claves[$1], $1) }.map { tipos[$0] }
        }
        var lineas: [String] = []
        for grupo in grupos {
            if !lineas.isEmpty { lineas.append("") }
            lineas.append("\(grupo.titulo) (\(grupo.tipos.count))")
            for tipo in ordenados(grupo.tipos) {
                let notas = Escala(.do, tipo).notas.map { $0.nombre(en: notacion) }.joined(separator: " ")
                let microtonos = tipo.microtonal == nil ? "" : " · " + t(.microtonos)
                // Ordenadas por brillo, con su brillo por quintas: «lidio: Do Re Mi Fa♯ Sol La Si · +3».
                let brillo =
                    orden == .brillo
                    ? " · " + PresentacionDeEstudioDeEscala.conSigno(estadisticas(tipo).brilloPorQuintas) : ""
                lineas.append("  \(tipo.nombre(en: notacion)): \(notas)\(microtonos)\(brillo)")
            }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    static func describir(tonalidad: Tonalidad, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        let armadura: String
        switch tonalidad.armadura {
        case 0: armadura = t(.sinAlteraciones)
        default:
            let signos = tonalidad.notasDeLaArmadura.map { $0.nombre(en: notacion) }.joined(separator: " ")
            armadura = "\(signos) (\(t(.alteraciones(abs(tonalidad.armadura), sostenidos: tonalidad.armadura > 0))))"
        }
        let acordes = zip(tonalidad.cifradosRomanos(cuatriadas: true), tonalidad.armonizar(cuatriadas: true))
            .map { "\($0) \($1.cifrado(en: notacion))" }.joined(separator: " · ")
        return [
            tonalidad.nombre(en: notacion),
            "  \(t(.armadura)): " + armadura,
            "  \(t(.relativa)): " + tonalidad.relativa.nombre(en: notacion)
                + " · \(t(.homonima)): " + tonalidad.homonima.nombre(en: notacion),
            "  \(t(.acordes)): " + acordes,
        ].joined(separator: "\n")
    }

    static func analizar(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var acordes = Argumentos(argumentos)
        // Con --escalas, debajo de cada acorde, su escala con sus tensiones y sus notas a evitar. Se quita antes que
        // la tonalidad, que se lleva todo lo que va detrás de --en.
        let conEscalas = acordes.quitarMarca("--escalas", "--scales")
        let conNotasGuia = acordes.quitarMarca("--notas-guia", "--guide-tones")
        let conConduccion = acordes.quitarMarca("--conduccion", "--voice-leading")
        let contra = try acordes.valorConPalabras("--contra", "--against")
        guard let tonalidad = try acordes.quitarTonalidad() else { throw ErrorDeUso.faltaTonalidadTrasEn }
        let archivo = try acordes.valor("--archivo", "--file")
        let ventana = try acordes.valor("--ventana", "--window").map { try Duracion(leyendo: $0) }
        if let opcion = acordes.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        let analisis: AnalisisPresentado
        if let archivo {
            guard acordes.restantes.isEmpty else { throw ErrorDeUso.archivoConAcordes }
            guard let datos = contenido(deArchivo: archivo) else { return archivoIlegible(archivo, notacion) }
            let pieza = try PiezaImportada(leyendo: datos)
            guard
                let leido = PresentacionDeAnalisis.analizar(
                    pieza.acordes(ventana: ventana), en: tonalidad,
                    notacion: notacion)
            else {
                throw ErrorDeUso.archivoSinAcordes
            }
            analisis = leido
        } else {
            guard !acordes.restantes.isEmpty else { throw ErrorDeUso.faltanAcordesDelAnalisis }
            // Con la tonalidad dada, sin modulaciones; si no, en tramos.
            analisis = try PresentacionDeAnalisis.analizar(acordes.unidos, en: tonalidad, notacion: notacion)
        }
        var lineas = [analisis.titulo]
        let todas = analisis.tramos.flatMap(\.filas)
        // Con --escalas, también las notas que cambian de una escala a la siguiente y las notas guía.
        let cambios = analisis.cambiosDeEscala(en: notacion)
        var indice = 0
        // Columnas de al menos 10 caracteres, más anchas si un cifrado no cabe.
        let anchoDelCifrado = max(10, (todas.map(\.cifrado.count).max() ?? 0) + 2)
        let anchoDelGrado = max(10, (todas.map(\.grado.count).max() ?? 0) + 2)
        for tramo in analisis.tramos {
            if let cabecera = tramo.cabecera { lineas.append(cabecera) }
            for fila in tramo.filas {
                let funcion = fila.funcion.isEmpty ? "–" : fila.funcion
                lineas.append(
                    "  " + fila.cifrado.padding(hasta: anchoDelCifrado) + fila.grado.padding(hasta: anchoDelGrado)
                        + funcion)
                if conEscalas, let escala = fila.escala {
                    let resumen = escala.resumen.isEmpty ? "" : " — " + escala.resumen
                    lineas.append("    " + escala.nombre + resumen)
                    if !escala.estructurasSuperiores.isEmpty {
                        let etiqueta = notacion.texto(\.estructurasSuperiores)
                        lineas.append("      " + etiqueta + ": " + escala.estructurasSuperiores)
                    }
                    if cambios.indices.contains(indice) { lineas.append("      " + cambios[indice]) }
                }
                indice += 1
            }
        }
        lineas += analisis.cadencias
        if conNotasGuia {
            lineas.append(notacion.texto(\.lineasDeNotasGuia) + ":")
            lineas += PresentacionDeEstudioDeEscala.lineasDeNotasGuia(
                analisis.acordes, tonalidad: analisis.tonalidad, notacion: notacion
            ).map { "  " + $0.titulo + ": " + $0.notas }
        }
        // Con --conduccion, cada paso con sus notas comunes y lo que se mueve cada voz, en drop 2.
        if conConduccion, let conduccion = PresentacionDeAnalisis.conduccion(analisis.acordes, notacion: notacion) {
            lineas.append(notacion.texto(\.conduccionDeVoces) + " (" + conduccion.disposicion + "):")
            for paso in conduccion.pasos {
                lineas.append("  " + paso.titulo + " · " + paso.comunes)
                lineas.append("    " + paso.voces.joined(separator: " · "))
            }
            lineas.append("  " + conduccion.movimientoTotal)
        }
        // Con --contra, la otra versión acorde a acorde: lo que cambia, sus grados y sus notas comunes.
        if let contra {
            let otra = try contra.split(separator: " ").map { try Acorde(leyendo: String($0)) }
            if let comparacion = PresentacionDeAnalisis.comparar(
                analisis.acordes, con: otra, en: tonalidad, notacion: notacion)
            {
                let cifrados = otra.map { $0.cifrado(en: notacion) }.joined(separator: " ")
                lineas.append(notacion.texto(\.compararCon) + " " + cifrados + " (" + comparacion.tonalidad + "):")
                for fila in comparacion.filas {
                    let acordesDeLaFila = fila.cambia ? fila.original + " → " + fila.nueva : fila.original
                    let comunes = fila.comunes.isEmpty ? "" : " · " + fila.comunes
                    lineas.append("  \(fila.posicion). " + acordesDeLaFila + " · " + fila.grados + comunes)
                }
                lineas.append("  " + comparacion.resumen)
            }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    // MARK: Teoría postonal

    /// `conjunto 0 4 7`: el conjunto con sus notas, sus formas, sus vectores y sus ejes de simetría.
    static func describir(conjunto: ConjuntoDeClasesDeAltura, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        let datos = DatosDeConjunto(conjunto, notacion: notacion)
        func lista(_ numeros: [Int]) -> String { "[" + numeros.map(String.init).joined(separator: ", ") + "]" }
        let ejes = conjunto.ejesDeSimetria.map(\.description).joined(separator: " · ")
        return [
            [lista(datos.clases), datos.forte].compactMap { $0 }.joined(separator: "  "),
            "  \(t(.notas)): " + datos.notas.joined(separator: " "),
            "  \(t(.formaNormal)): \(lista(datos.formaNormal))",
            "  \(t(.formaPrima)): \(lista(datos.formaPrima))",
            "  \(t(.vectorIntervalico)): \(lista(datos.vectorIntervalico))",
            "  \(t(.vectorDeIndice)): \(lista(datos.vectorDeIndice))",
            "  \(t(.ejesDeSimetria)): " + (ejes.isEmpty ? "—" : ejes),
        ].joined(separator: "\n")
    }

    /// `serie 0 e 7 4 2 9 3 8 t 1 5 6`: la serie con sus notas, sus intervalos, sus hexacordos, sus formas
    /// combinatorias y la matriz, con las P a la izquierda, las R a la derecha, las I arriba y las RI abajo.
    static func describir(serie: SerieDodecafonica, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        // Los datos de `--json` (`DatosDeSerie`), en texto.
        let datos = DatosDeSerie(serie, notacion: notacion)
        var intervalos = "  \(t(.intervalos)): " + datos.intervalos.map(String.init).joined(separator: " ")
        if datos.deTodosLosIntervalos { intervalos += "  (\(t(.deTodosLosIntervalos)))" }
        var lineas = [
            datos.clases.map(SerieDodecafonica.cifra).joined(separator: " "),
            "  \(t(.notas)): " + datos.notas.joined(separator: " "),
            intervalos,
            "  \(t(.hexacordos)): " + datos.hexacordos.joined(separator: " · "),
            "  \(t(.formasCombinatorias)): " + datos.formasCombinatorias.joined(separator: " "),
            "  " + t(.formasDistintas(datos.formasDistintas)),
            "",
        ]
        func celda(_ texto: String) -> String { texto + String(repeating: " ", count: max(1, 5 - texto.count)) }
        let cifra = SerieDodecafonica.cifra
        let matriz = datos.matriz
        let margen = "  " + celda("")
        func cabecera(_ tipo: TipoDeFormaDeSerie) -> String {
            margen + matriz[0].map { celda(FormaDeSerie(tipo, $0).description) }.joined()
        }
        lineas.append(cabecera(.inversion))
        for fila in matriz {
            let p = FormaDeSerie(.original, fila[0]).description
            let r = FormaDeSerie(.retrogrado, fila[0]).description
            lineas.append("  " + celda(p) + fila.map { celda(cifra($0)) }.joined() + r)
        }
        lineas.append(cabecera(.retrogradoDeLaInversion))
        return lineas.map { String($0.reversed().drop(while: { $0 == " " }).reversed()) }.joined(separator: "\n")
    }
}
