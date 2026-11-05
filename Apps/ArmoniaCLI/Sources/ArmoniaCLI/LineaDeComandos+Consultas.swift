import Armonia
import ArmoniaPresentacion
import Foundation

// MARK: - Consultas: acordes, notas, escalas, tonalidades y análisis

extension LineaDeComandos {
    /// `acorde Sol7 [--disposiciones] [--nombres] [--tonalidades] [--sustituciones] [--comparar Do] [--en Do mayor]`:
    /// cada acorde con sus notas y, si se piden, sus disposiciones, sus otros nombres, las tonalidades en que está,
    /// sus sustituciones (en la tonalidad de `--en` o en la suya) y la conducción hasta otro acorde.
    static func acorde(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(textos)
        guard let tonalidad = try argumentos.quitarTonalidad() else { return uso(.faltaTonalidadTrasEn, notacion) }
        var otro: Acorde?
        switch argumentos.quitarOpcion("--comparar", "--compare") {
        case .ausente: break
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto): otro = try Acorde(leyendo: texto)
        }
        let pedido = RelacionesPedidas(
            bebop: argumentos.quitarMarca("--bebop"),
            pentatonicas: argumentos.quitarMarca("--pentatonicas", "--pentatonics"),
            disposiciones: argumentos.quitarMarca("--disposiciones", "--voicings"),
            nombres: argumentos.quitarMarca("--nombres", "--names"),
            tonalidades: argumentos.quitarMarca("--tonalidades", "--keys"),
            sustituciones: argumentos.quitarMarca("--sustituciones", "--substitutions"),
            tonalidad: tonalidad, otro: otro)
        if let desconocida = argumentos.opcionDesconocida {
            return uso(.opcionDesconocida(desconocida), notacion)
        }
        guard !argumentos.restantes.isEmpty else { return uso(.faltaCifrado, notacion) }
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
        let archivo: String?
        switch argumentos.quitarOpcion("--archivo", "--file") {
        case .ausente: archivo = nil
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let ruta): archivo = ruta
        }
        if let desconocida = argumentos.opcionDesconocida { return uso(.opcionDesconocida(desconocida), notacion) }
        let encontradas: [EscalaEncontrada]
        if let archivo {
            guard argumentos.restantes.isEmpty else { return uso(.archivoConNotas, notacion) }
            guard let datos = contenido(deArchivo: archivo) else { return uso(.archivoIlegible(archivo), notacion) }
            let pieza = try PiezaImportada(leyendo: datos)
            encontradas = PresentacionDeEstudioDeEscala.escalas(de: pieza, notacion: notacion)
        } else {
            guard !argumentos.restantes.isEmpty else { return uso(.faltanNotas, notacion) }
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

    /// Los arpegios de `arpegio`, uno por acorde, para el texto y para `--json`. Lanza `FalloDeUso` si una opción
    /// está mal escrita.
    static func arpegios(_ textos: [String]) throws -> [Arpegio] {
        func fallo(_ error: ErrorDeUso) -> FalloDeUso { FalloDeUso(error: error) }
        var argumentos = Argumentos(textos)
        var patron = Arpegio.Patron.ascendente
        switch argumentos.quitarOpcion("--patron", "--patrón", "--pattern") {
        case .ausente:
            break
        case .sinValor(let nombre):
            throw fallo(.faltaValor(nombre))
        case .valor(let texto):
            guard let elegido = patronDeArpegio(texto) else { throw fallo(.patronDesconocido(texto)) }
            patron = elegido
        }
        var recorrido = RecorridoDeArpegio()
        if let error = leerRecorrido(&argumentos, en: &recorrido) { throw fallo(error) }
        if let desconocida = argumentos.opcionDesconocida {
            throw fallo(.opcionDesconocida(desconocida))
        }
        guard !argumentos.restantes.isEmpty else { throw fallo(.faltaCifradoDelArpegio) }
        var arpegios: [Arpegio] = []
        for texto in argumentos.restantes {
            let acorde = try Acorde(leyendo: texto)
            var inicio = 0
            if let desde = recorrido.desde {
                let delGrado = Int(desde).flatMap { Arpegio.indice(delGrado: $0, en: acorde) }
                let deLaNota = (try? Nota(leyendo: desde)).flatMap { Arpegio.indice(de: $0, en: acorde) }
                guard let indice = delGrado ?? deLaNota else { throw fallo(.desdeNoValido(desde)) }
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

    /// Quita y lee `--octavas`, `--sin-octava`, `--desde`, `--tensiones`, `--grados` y `--aproximacion`, o dice
    /// qué está mal escrito.
    static func leerRecorrido(_ argumentos: inout Argumentos, en recorrido: inout RecorridoDeArpegio)
        -> ErrorDeUso?
    {
        recorrido.conOctava = !argumentos.quitarMarca("--sin-octava", "--no-octave")
        var sinValor: String?
        /// El valor de la opción, `nil` si no está o no lo lleva (y entonces se apunta en `sinValor`).
        func valor(_ opcion: Argumentos.Opcion) -> String? {
            switch opcion {
            case .ausente: return nil
            case .sinValor(let nombre):
                sinValor = sinValor ?? nombre
                return nil
            case .valor(let texto): return texto
            }
        }
        let octavas = valor(argumentos.quitarOpcion("--octavas", "--octaves"))
        recorrido.desde = valor(argumentos.quitarOpcion("--desde", "--from"))
        let tensiones = valor(argumentos.quitarOpcion("--tensiones", "--tensions"))
        let grados = valor(argumentos.quitarOpcion("--grados", "--degrees"))
        let aproximacion = valor(argumentos.quitarOpcion("--aproximacion", "--aproximación", "--approach"))
        if let sinValor { return .faltaValor(sinValor) }
        if let octavas {
            guard let n = Int(octavas), (1...4).contains(n) else { return .octavasFueraDeRango }
            recorrido.octavas = n
        }
        if let tensiones {
            guard let leidas = try? Arpegio.tensiones(leyendo: tensiones) else { return .tensionesMalEscritas }
            recorrido.tensiones = leidas
        }
        if let grados {
            guard let leidos = try? Arpegio.grados(leyendo: grados) else { return .gradosMalEscritos }
            recorrido.grados = leidos
        }
        if let aproximacion {
            guard let leida = try? Arpegio.Aproximacion(leyendo: aproximacion) else {
                return .aproximacionDesconocida(aproximacion)
            }
            recorrido.aproximacion = leida
        }
        return nil
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
    /// `escala Do mayor [--acordes] [--secuencia terceras] [--bajando] [--octavas 2] [--piano] [--modos]
    /// [--comparar Do lidio]`: la escala y, si se piden, todos los acordes que caben en cada grado, una secuencia de
    /// estudio, la digitación de piano, los modos paralelos y relativos y la comparación con otra escala.
    static func escala(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(textos)
        let conAcordes = argumentos.quitarMarca("--acordes", "--chords")
        let bajando = argumentos.quitarMarca("--bajando", "--descending")
        let piano = argumentos.quitarMarca("--piano")
        let modos = argumentos.quitarMarca("--modos", "--modes")
        let simetria = argumentos.quitarMarca("--simetria", "--symmetry")
        let vecinas = argumentos.quitarMarca("--vecinas", "--neighbors")
        let doce = argumentos.quitarMarca("--doce", "--all-keys")
        let triadas = argumentos.quitarMarca("--triadas", "--triads")
        guard let octavas = argumentos.quitarNumero("--octavas", "--octaves", en: 1...4, porDefecto: 1) else {
            return uso(.octavasFueraDeRango, notacion)
        }
        var secuencia: SecuenciaDeEscala?
        switch argumentos.quitarOpcion("--secuencia", "--sequence") {
        case .ausente: break
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let elegida = secuenciaDeEscala(texto) else { return uso(.secuenciaDesconocida(texto), notacion) }
            secuencia = elegida
        }
        var otra: Escala?
        switch argumentos.quitarOpcionConPalabras("--comparar", "--compare") {
        case .ausente: break
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto): otra = try Escala(leyendo: texto)
        }
        if let desconocida = argumentos.opcionDesconocida { return uso(.opcionDesconocida(desconocida), notacion) }
        guard !argumentos.restantes.isEmpty else { return uso(.faltaEscala, notacion) }
        let escala = try Escala(leyendo: argumentos.unidos)
        var lineas = [describir(escala: escala, conTodosSusAcordes: conAcordes, notacion)]
        if let secuencia {
            let presentada = PresentacionDeEstudioDeEscala.secuencia(
                escala, secuencia, octavas: octavas, sentido: bajando ? .descendente : .ascendente, notacion: notacion)
            lineas.append(notacion.texto(\.secuencia) + " " + secuencia.nombre(en: notacion) + ":")
            lineas.append("  " + presentada.notas)
        }
        if piano {
            lineas.append(notacion.texto(\.digitacionDePiano) + ":")
            for mano in PresentacionDeEstudioDeEscala.digitaciones(escala, octavas: octavas, notacion: notacion) {
                let pares = zip(mano.notas.split(separator: " "), mano.dedos.split(separator: " "))
                lineas.append("  " + mano.mano + ": " + pares.map { "\($0) \($1)" }.joined(separator: " · "))
            }
        }
        if modos {
            lineas.append(notacion.texto(\.modosParalelos) + ":")
            lineas += PresentacionDeEstudioDeEscala.modosParalelos(de: escala, notacion: notacion).map { modo in
                "  " + modo.nombre + " (" + modo.brillo + ")" + (modo.cambios.isEmpty ? "" : ": " + modo.cambios)
            }
            let relativos = PresentacionDeEstudioDeEscala.modosRelativos(de: escala, notacion: notacion)
            lineas.append(notacion.texto(\.modosRelativos) + ":")
            lineas.append("  " + relativos.map(\.nombre).joined(separator: " · "))
        }
        if simetria { lineas += lineasDeSimetria(de: escala, notacion) }
        if vecinas {
            lineas.append(notacion.texto(\.escalasVecinas) + ":")
            lineas += PresentacionDeEstudioDeEscala.vecinas(de: escala, notacion: notacion).map {
                "  " + $0.nombre + ": " + $0.detalle
            }
        }
        if doce {
            let hoja = PresentacionDeEstudioDeEscala.enLasDoceTonalidades(
                escala, secuencia: secuencia, notacion: notacion)
            lineas.append(hoja.titulo + ":")
            lineas += hoja.tonalidades.map { "  " + $0.titulo + ": " + $0.notas }
            // Con --acordes, también los acordes de cada grado en las doce, si la escala los forma.
            if conAcordes,
                let tabla = PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(
                    escala, cuatriadas: !triadas, notacion: notacion)
            {
                lineas.append(tabla.titulo + ":")
                lineas.append("  " + tabla.grados.joined(separator: " · "))
                lineas += tabla.filas.map { "  " + $0.tonalidad + ": " + $0.acordes.joined(separator: " · ") }
            }
        }
        if let otra {
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
        (.europa, "europa", "europe"),
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
    static func tradiciones(_ argumentos: [String], _ notacion: Notacion) -> ResultadoDeOrden {
        if let primera = argumentos.first, !Argumentos.pareceUnaOpcion(primera) {
            return escalas(["--tradicion"] + argumentos, notacion)
        }
        if let opcion = Argumentos(argumentos).opcionDesconocida { return uso(.opcionDesconocida(opcion), notacion) }
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

    /// `escalas [<texto>] [--tradicion <tradición>] [--categoria <categoría>] [--uso <uso>]`: el catálogo de escalas,
    /// las habituales y las de otras tradiciones agrupadas por tradición y categoría, cada una con sus notas desde Do
    /// (y la marca de los microtonos, si los tiene). Un texto suelto busca en los nombres. `--uso jazz` deja solo las
    /// habituales de ese uso (las de otras tradiciones no tienen).
    static func escalas(_ argumentos: [String], _ notacion: Notacion) -> ResultadoDeOrden {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        var entrada = Argumentos(argumentos)
        var tradicion: Tradicion?
        switch entrada.quitarOpcion("--tradicion", "--tradición", "--tradition") {
        case .ausente: break
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            let clave = claveDeBusqueda(texto)
            guard
                let encontrada = nombresDeLasTradiciones.first(where: {
                    claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
                })
            else { return uso(.tradicionDesconocida(texto), notacion) }
            tradicion = encontrada.tradicion
        }
        var categoria: CategoriaTradicional?
        switch entrada.quitarOpcion("--categoria", "--categoría", "--category") {
        case .ausente: break
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            let clave = claveDeBusqueda(texto)
            let nombres = { (candidata: CategoriaTradicional) in
                [candidata.rawValue, candidata.nombre, candidata.nombre(en: notacion)].map(claveDeBusqueda)
            }
            guard let encontrada = CategoriaTradicional.allCases.first(where: { nombres($0).contains(clave) }) else {
                return uso(.categoriaDesconocida(texto), notacion)
            }
            categoria = encontrada
        }
        var usoPedido: UsoDeEscala?
        switch entrada.quitarOpcion("--uso", "--use") {
        case .ausente: break
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            let clave = claveDeBusqueda(texto)
            let nombres = { (candidato: UsoDeEscala) -> [String] in
                let claves = nombresDeLosUsos.first { $0.uso == candidato }.map { [$0.espanol, $0.ingles] } ?? []
                return (claves + [candidato.nombre, candidato.nombre(en: notacion)]).map(claveDeBusqueda)
            }
            guard let encontrado = UsoDeEscala.allCases.first(where: { nombres($0).contains(clave) }) else {
                return uso(.usoDesconocido(texto), notacion)
            }
            usoPedido = encontrado
        }
        if let opcion = entrada.opcionDesconocida { return uso(.opcionDesconocida(opcion), notacion) }
        let buscado = claveDeBusqueda(entrada.unidos)
        func cumple(_ tipo: TipoDeEscala) -> Bool {
            buscado.isEmpty || claveDeBusqueda(tipo.nombre(en: notacion)).contains(buscado)
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
        var lineas: [String] = []
        for grupo in grupos {
            if !lineas.isEmpty { lineas.append("") }
            lineas.append("\(grupo.titulo) (\(grupo.tipos.count))")
            for tipo in grupo.tipos {
                let notas = Escala(.do, tipo).notas.map { $0.nombre(en: notacion) }.joined(separator: " ")
                let microtonos = tipo.microtonal == nil ? "" : " · " + t(.microtonos)
                lineas.append("  \(tipo.nombre(en: notacion)): \(notas)\(microtonos)")
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
        guard let tonalidad = try acordes.quitarTonalidad() else { return uso(.faltaTonalidadTrasEn, notacion) }
        let archivo: String?
        switch acordes.quitarOpcion("--archivo", "--file") {
        case .ausente: archivo = nil
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let ruta): archivo = ruta
        }
        let ventana: Duracion?
        switch acordes.quitarOpcion("--ventana", "--window") {
        case .ausente: ventana = nil
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto): ventana = try Duracion(leyendo: texto)
        }
        if let opcion = acordes.opcionDesconocida { return uso(.opcionDesconocida(opcion), notacion) }
        let analisis: AnalisisPresentado
        if let archivo {
            guard acordes.restantes.isEmpty else { return uso(.archivoConAcordes, notacion) }
            guard let datos = contenido(deArchivo: archivo) else { return uso(.archivoIlegible(archivo), notacion) }
            let pieza = try PiezaImportada(leyendo: datos)
            guard
                let leido = PresentacionDeAnalisis.analizar(
                    pieza.acordes(ventana: ventana), en: tonalidad,
                    notacion: notacion)
            else {
                return uso(.archivoSinAcordes, notacion)
            }
            analisis = leido
        } else {
            guard !acordes.restantes.isEmpty else { return uso(.faltanAcordesDelAnalisis, notacion) }
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
        return bien(lineas.joined(separator: "\n"))
    }

    // MARK: Teoría postonal

    /// `conjunto 0 4 7`: el conjunto con sus notas, sus formas, sus vectores y sus ejes de simetría.
    static func describir(conjunto: ConjuntoDeClases, _ notacion: Notacion) -> String {
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
