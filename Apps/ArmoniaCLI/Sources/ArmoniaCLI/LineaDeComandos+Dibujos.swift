import Armonia
import ArmoniaPresentacion
import Foundation

// MARK: - Dibujos: Tonnetz, tabla armónica y teclados de cuadrícula

extension LineaDeComandos {
    /// Lo que piden dibujar `tonnetz`, `tabla` y `cuadricula`.
    enum Dibujo {
        case notas([String])
        case acorde(Acorde)
        case escala(Escala)
        case clases(ConjuntoDeClasesDeAltura)
        case recorrido([Acorde])
        case camino(Acorde, Acorde)
        case ciclo(CicloNeorriemanniano, Acorde)
    }

    /// Lee los argumentos comunes de `tonnetz` y `tabla`: `--margen N` y lo que se dibuja
    /// (notas, `--acorde`, `--escala`, `--clases`, `--recorrido`, `--camino` o `--ciclo`).
    static func leerDibujo(_ argumentos: [String], orden: String) throws -> (dibujo: Dibujo, margen: Int?) {
        var lectura = Argumentos(argumentos)
        var margen: Int?
        if let texto = try lectura.valor("--margen", siFalta: .margenFueraDeRango) {
            guard let n = Int(texto), (0...6).contains(n) else { throw ErrorDeUso.margenFueraDeRango }
            margen = n
        }
        let argumentos = lectura.restantes
        guard let primero = argumentos.first else { throw ErrorDeUso.faltanNotasDelDibujo(orden: orden) }
        let resto = argumentos.dropFirst().joined(separator: " ")
        let dibujo: Dibujo
        switch primero {
        case "--acorde", "--chord":
            guard !resto.isEmpty else { throw ErrorDeUso.faltaAcordeDelDibujo(orden: orden) }
            dibujo = .acorde(try Acorde(leyendo: resto))
        case "--escala", "--scale":
            guard !resto.isEmpty else { throw ErrorDeUso.faltaEscalaDelDibujo(orden: orden) }
            dibujo = .escala(try Escala(leyendo: resto))
        case "--clases", "--pcs":
            // Como `armonia conjunto`: «0 4 7», «047», «01t», «Do Mi Sol» o «3-11».
            guard !resto.isEmpty else { throw ErrorDeUso.faltanClasesDelDibujo(orden: orden) }
            dibujo = .clases(try ConjuntoDeClasesDeAltura(leyendo: resto))
        case "--recorrido", "--sequence":
            let acordes = try argumentos.dropFirst().map { try Acorde(leyendo: $0) }
            guard !acordes.isEmpty else { throw ErrorDeUso.faltanTriadasDelRecorrido(orden: orden) }
            dibujo = .recorrido(acordes)
        case "--camino", "--shortest":
            let acordes = try argumentos.dropFirst().map { try Acorde(leyendo: $0) }
            guard acordes.count == 2 else { throw ErrorDeUso.caminoSoloTriadas(orden: orden) }
            dibujo = .camino(acordes[0], acordes[1])
        case "--ciclo", "--cycle":
            let partes = Array(argumentos.dropFirst())
            guard partes.count >= 2,
                let ciclo = try? CicloNeorriemanniano(leyendo: partes.dropLast().joined(separator: " "))
            else {
                throw ErrorDeUso.cicloMalEscrito(orden: orden)
            }
            dibujo = .ciclo(ciclo, try Acorde(leyendo: partes.last!))
        default:
            if primero.hasPrefix("--") { throw ErrorDeUso.opcionDesconocida(primero) }
            dibujo = .notas(argumentos)
        }
        return (dibujo, margen)
    }

    /// `tonnetz Do Mi Sol`, `tonnetz --acorde Domaj7`, `tonnetz --ciclo hexatonico Do`…
    static func tonnetz(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (dibujo, margen) = try leerDibujo(argumentos, orden: "tonnetz")
        let tonnetz: Tonnetz
        switch dibujo {
        case .notas(let textos): tonnetz = Tonnetz(try textos.map { try Nota(leyendo: $0) })
        case .acorde(let acorde): tonnetz = Tonnetz(acorde)
        case .escala(let escala): tonnetz = Tonnetz(escala)
        case .clases(let conjunto): tonnetz = Tonnetz(conjunto)
        case .recorrido(let acordes):
            guard let recorrido = Tonnetz(recorrido: acordes) else {
                throw ErrorDeUso.recorridoSoloTriadas(orden: "tonnetz")
            }
            tonnetz = recorrido
        case .camino(let origen, let destino):
            guard let camino = Tonnetz(caminoDesde: origen, hasta: destino) else {
                throw ErrorDeUso.caminoSoloTriadas(orden: "tonnetz")
            }
            tonnetz = camino
        case .ciclo(let ciclo, let acorde):
            guard let dibujo = Tonnetz(ciclo: ciclo, desde: acorde) else {
                throw ErrorDeUso.cicloSoloTriadas(orden: "tonnetz")
            }
            tonnetz = dibujo
        }
        return bien(tonnetz.svg(opciones: .init(notacion: notacion), margen: margen).trimmingCharacters(in: "\n"))
    }

    /// `tabla Do Mi Sol`, `tabla Do3 Sol3 Mi4` (con octava, alturas), `tabla --acorde Domaj7`,
    /// `tabla --ciclo octatonico Do`…
    static func tablaArmonica(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (dibujo, margen) = try leerDibujo(argumentos, orden: "tabla")
        let tabla: TablaArmonica
        switch dibujo {
        case .notas(let textos):
            // Con un número de octava, alturas; sin él, notas.
            if textos.contains(where: { $0.contains(where: \.isNumber) }) {
                tabla = TablaArmonica(try textos.map { try Altura(leyendo: $0) })
            } else {
                tabla = TablaArmonica(try textos.map { try Nota(leyendo: $0) })
            }
        case .acorde(let acorde): tabla = TablaArmonica(acorde)
        case .escala(let escala): tabla = TablaArmonica(escala)
        case .clases(let conjunto): tabla = TablaArmonica(conjunto)
        case .recorrido(let acordes):
            guard let recorrido = TablaArmonica(recorrido: acordes) else {
                throw ErrorDeUso.recorridoSoloTriadas(orden: "tabla")
            }
            tabla = recorrido
        case .camino(let origen, let destino):
            guard let camino = TablaArmonica(caminoDesde: origen, hasta: destino) else {
                throw ErrorDeUso.caminoSoloTriadas(orden: "tabla")
            }
            tabla = camino
        case .ciclo(let ciclo, let acorde):
            guard let dibujo = TablaArmonica(ciclo: ciclo, desde: acorde) else {
                throw ErrorDeUso.cicloSoloTriadas(orden: "tabla")
            }
            tabla = dibujo
        }
        return bien(tabla.svg(opciones: .init(notacion: notacion), margen: margen).trimmingCharacters(in: "\n"))
    }

    /// `teclado Re mayor [--mano derecha|izquierda] [--octavas 2]`: la escala en un teclado de piano, en SVG, con
    /// el nombre de cada nota o, con una mano, sus dedos.
    static func teclado(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        guard let octavas = argumentos.quitarNumero("--octavas", "--octaves", en: 1...4, porDefecto: 1) else {
            throw ErrorDeUso.octavasFueraDeRango
        }
        var mano: Mano?
        if let texto = try argumentos.valor("--mano", "--hand") {
            guard let elegida = manoDePiano(texto) else { throw ErrorDeUso.manoDesconocida(texto) }
            mano = elegida
        }
        if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscalaDelTeclado }
        let escala = try Escala(leyendo: argumentos.unidos)
        let svg = PresentacionDeEstudioDeEscala.teclado(de: escala, mano: mano, octavas: octavas, notacion: notacion)
        return bien(svg.trimmingCharacters(in: "\n"))
    }

    /// `reloj Do disminuida [--quintas]`: la escala en un reloj de doce horas, en SVG.
    static func reloj(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        let quintas = argumentos.quitarMarca("--quintas", "--fifths")
        if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscalaDelReloj }
        let escala = try Escala(leyendo: argumentos.unidos)
        let svg = PresentacionDeEstudioDeEscala.reloj(
            de: escala, orden: quintas ? .quintas : .cromatico, notacion: notacion)
        return bien(svg.trimmingCharacters(in: "\n"))
    }

    /// `hoja Re dórico`: la escala en una hoja de estudio para imprimir, en SVG; `hoja --acorde Sol7`, la de un
    /// acorde; `hoja --tonalidad Do mayor`, la de una tonalidad, y `hoja --acordes Rem7 Sol7 Do7M [--en Do mayor]
    /// [--doce] [--contra …]`, la de una progresión, en las doce tonalidades o comparada con otra. `grabar hoja …` la
    /// pasa a PDF.
    static func hoja(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        if let cifrado = try argumentos.valor("--acorde", "--chord", siFalta: .faltaElAcordeDeLaHoja) {
            if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaElAcordeDeLaHoja }
            let acorde = try Acorde(leyendo: cifrado)
            return bien(PresentacionDeRelacionesDeAcorde.hojaDeEstudio(de: acorde, notacion: notacion))
        }
        if let texto = try argumentos.valorConPalabras("--tonalidad", "--key", siFalta: .faltaTonalidad) {
            if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaTonalidad }
            let tonalidad = try Tonalidad(leyendo: texto)
            return bien(PresentacionDeTonalidad.hojaDeEstudio(de: tonalidad, notacion: notacion))
        }
        if argumentos.quitarMarca("--acordes", "--chords") {
            // --doce y --contra se quitan antes que la tonalidad, que se lleva todo lo que va detrás de --en.
            let doce = argumentos.quitarMarca("--doce", "--all-keys")
            let contra = try argumentos.valorConPalabras("--contra", "--against")
            guard let tonalidad = try argumentos.quitarTonalidad() else { throw ErrorDeUso.faltaValor("--en") }
            if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
            guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltanLosAcordesDeLaHoja }
            let analisis = try PresentacionDeAnalisis.analizar(
                argumentos.restantes.joined(separator: " "), en: tonalidad, notacion: notacion)
            // Con --contra, las dos progresiones comparadas acorde a acorde.
            if let contra {
                let otra = try contra.split(separator: " ").map { try Acorde(leyendo: String($0)) }
                if let hoja = PresentacionDeAnalisis.hojaDeLaComparacion(
                    analisis.acordes, con: otra, en: tonalidad, notacion: notacion)
                {
                    return bien(hoja)
                }
            }
            // Con --doce, la progresión en las doce tonalidades, desde la dada o la del análisis.
            if doce, let propia = tonalidad ?? analisis.tonalidad ?? analisis.acordes.first?.tonalidadPropia {
                return bien(
                    PresentacionDeAnalisis.hojaEnLasDoceTonalidades(
                        analisis.acordes, tonalidad: propia, notacion: notacion))
            }
            return bien(PresentacionDeAnalisis.hojaDeEstudio(analisis, notacion: notacion))
        }
        if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscalaDeLaHoja }
        let escala = try Escala(leyendo: argumentos.unidos)
        return bien(PresentacionDeEstudioDeEscala.hojaDeEstudio(de: escala, notacion: notacion))
    }

    /// `pentagrama escala Re dórico [--octavas 2] [--bajando] [--secuencia terceras] [--mano derecha] [--tab]`,
    /// `pentagrama acorde Sol7`, `pentagrama arpegio Do Lam [--patron alberti] [--figura 16] [--tresillos] [--tab]`,
    /// `pentagrama acordes Rem7 Sol7 Do7M [--romanos] [--bajo-cifrado]`, `pentagrama melodia Do4:8 Re4:8 … --sobre Do
    /// Sol7`: lo que se pide en un pentagrama, en SVG. Con `--nombres`, `--intervalos`, `--semitonos` y `--tonica`, el
    /// nombre y el intervalo de cada nota, los semitonos y la tónica en color; con `--ajenas`, las notas que no son del
    /// acorde en color; con `--octava`, `--clave`, `--doble` y `--cambiar-clave`, el registro y las claves; con
    /// `--en <tonalidad>` (al final), la armadura de esa tonalidad.
    static func pentagrama(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(textos)
        guard let tonalidad = try argumentos.quitarTonalidad() else { throw ErrorDeUso.faltaValor("en") }
        var opciones = OpcionesDePentagrama(notacion: notacion)
        if let tonalidad { opciones.armadura = .tonalidad(tonalidad) }
        opciones.marcas.nombresDeLasNotas = argumentos.quitarMarca("--nombres", "--names")
        opciones.marcas.intervalosDeLasNotas = argumentos.quitarMarca("--intervalos", "--intervals")
        opciones.marcas.semitonos = argumentos.quitarMarca("--semitonos", "--semitones")
        opciones.marcas.tonica = argumentos.quitarMarca("--tonica", "--tónica", "--tonic")
        opciones.marcas.notasAjenas = argumentos.quitarMarca("--ajenas", "--non-chord")
        if argumentos.quitarMarca("--doble", "--grand-staff") { opciones.maquetacion.pentagramas = .doble }
        // Los cambios de clave son en un solo pentagrama.
        opciones.maquetacion.cambiosDeClave = argumentos.quitarMarca("--cambiar-clave", "--clef-changes")
        if opciones.maquetacion.cambiosDeClave { opciones.maquetacion.pentagramas = .simple }
        if let texto = try argumentos.valor("--clave", "--clef") {
            guard let clave = leerClave(texto) else { throw ErrorDeUso.claveDesconocida(texto) }
            opciones.maquetacion.clave = clave
            opciones.maquetacion.pentagramas = .simple
        }
        guard let octava = argumentos.quitarNumero("--octava", "--octave", en: 0...7, porDefecto: 4) else {
            throw ErrorDeUso.octavaFueraDeRango
        }
        let tipos = [
            "escala": "escala", "scale": "escala", "acorde": "acorde", "chord": "acorde", "arpegio": "arpegio",
            "arpeggio": "arpegio", "acordes": "acordes", "chords": "acordes", "melodia": "melodia",
            "melodía": "melodia", "melody": "melodia", "bajo": "bajo", "bass": "bajo",
        ]
        guard let primera = argumentos.restantes.first, let tipo = tipos[primera.lowercased()] else {
            throw ErrorDeUso.faltaLoQueDibujaElPentagrama
        }
        argumentos = Argumentos(Array(argumentos.restantes.dropFirst()))
        let svg: String
        switch tipo {
        case "escala":
            return try pentagramaDeEscala(&argumentos, opciones, octava, notacion)
        case "acorde":
            if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
            guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaLoQueDibujaElPentagrama }
            svg = try Acorde(leyendo: argumentos.unidos).svgPentagrama(octava: octava, opciones: opciones)
        case "acordes":
            let romanos = argumentos.quitarMarca("--romanos", "--roman")
            let conBajoCifrado = argumentos.quitarMarca("--bajo-cifrado", "--figured-bass")
            if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
            guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaLoQueDibujaElPentagrama }
            let acordes = try argumentos.restantes.map { try Acorde(leyendo: $0) }
            // En posición cerrada, desde el Do de la octava (el central, si no se da), en dos octavas.
            let desde = Altura(.do, octava: octava).midi
            let voces = DisposicionDeAcorde.cerrada.conducir(acordes, en: desde...(desde + 24)) ?? []
            let titulo = acordes.map { $0.cifrado(en: notacion) }.joined(separator: " – ")
            let grados = romanos ? gradosRomanos(de: acordes, en: tonalidad) : []
            let cifras = conBajoCifrado ? bajoCifrado(de: acordes, en: tonalidad) : []
            let porEvento = Partitura.AnotacionesPorEvento(
                cifrados: .enOrden(acordes), grados: .enOrden(grados), bajoCifrado: .enOrden(cifras))
            let partitura = Partitura(acordes: voces, titulo: titulo, porEvento: porEvento)
            svg = partitura.svg(opciones: opciones)
        case "melodia":
            return try pentagramaDeMelodia(&argumentos, opciones, notacion)
        case "bajo":
            // Un bajo caminante en clave de fa; con --tab, con la tablatura del bajo debajo.
            let tab = argumentos.quitarMarca("--tab")
            if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
            let acordes = try argumentos.restantes.map { try Acorde(leyendo: $0) }
            guard let bajo = PresentacionDeAnalisis.bajoCaminante(acordes, notacion: notacion) else {
                throw ErrorDeUso.faltaLoQueDibujaElPentagrama
            }
            var partitura = bajo.partitura
            if !tab {
                partitura.pentagramas[0].numeroDeCuerdas = nil
                partitura.pentagramas[0].voces[0].pulsaciones = [:]
            }
            svg = partitura.svg(opciones: opciones)
        default:
            return try pentagramaDeArpegios(&argumentos, opciones, tonalidad, octava, notacion)
        }
        return bien(svg.trimmingCharacters(in: "\n"))
    }

    /// Las cifras del bajo continuo de los acordes, en la tonalidad dada o en la que mejor los explica.
    private static func bajoCifrado(de acordes: [Acorde], en tonalidad: Tonalidad?) -> [[String]] {
        guard let tonalidad = tonalidad ?? AnalisisArmonico.analizar(acordes)?.tonalidad else { return [] }
        return acordes.map { tonalidad.cifrasDeBajo(de: $0) }
    }

    /// `pentagrama melodia Do4:8 Re4:8 Mi4:4 … --sobre Do Sol7`: una melodía con su ritmo y, con `--sobre`, un acorde
    /// por compás, con su cifrado encima y las notas que no son suyas en color (las de la tonalidad de `--en`, o
    /// todas si no se da, en verde; las cromáticas, en rojo).
    private static func pentagramaDeMelodia(
        _ argumentos: inout Argumentos, _ opciones: OpcionesDePentagrama, _ notacion: Notacion
    ) throws -> ResultadoDeOrden {
        var opciones = opciones
        var acordes: [Acorde] = []
        if let texto = try argumentos.valorConPalabras("--sobre", "--over") {
            acordes = try texto.split(separator: " ").map { try Acorde(leyendo: String($0)) }
            opciones.marcas.notasAjenas = true
        }
        if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaLoQueDibujaElPentagrama }
        let voz = try Voz(leyendo: argumentos.unidos)
        // El primer evento que empieza en cada compás lleva el acorde de ese compás.
        var porEvento: [Int: Acorde] = [:]
        var inicio = Duracion.cero
        var compas = 0
        for (i, evento) in voz.eventos.enumerated() {
            let delCompas = voz.compas.duracion * compas
            if compas < acordes.count, inicio >= delCompas {
                porEvento[i] = acordes[compas]
                compas += 1
            }
            inicio = inicio + evento.duracion
        }
        let titulo = acordes.map { $0.cifrado(en: notacion) }.joined(separator: " – ")
        let linea = Partitura.Linea(voz, cifrados: voz.porInicio(porEvento))
        let svg = Partitura(linea, encabezado: Encabezado(titulo: titulo)).svg(opciones: opciones)
        return bien(svg.trimmingCharacters(in: "\n"))
    }

    /// Los grados de los acordes en números romanos, en la tonalidad dada o en la que mejor los explica.
    private static func gradosRomanos(de acordes: [Acorde], en tonalidad: Tonalidad?) -> [String] {
        (tonalidad.map { $0.analizar(acordes) } ?? AnalisisArmonico.analizar(acordes))?.cifrados ?? []
    }

    /// Lee el mástil de `--instrumento` (la guitarra, si no se da), o lanza el `ErrorDeUso` de lo que está mal escrito.
    private static func leerMastil(_ argumentos: inout Argumentos, en mastil: inout Mastil) throws {
        guard let nombre = try argumentos.valor("--instrumento", "--instrument", siFalta: .faltaInstrumento) else {
            return
        }
        guard let encordado = try? Encordado(leyendo: nombre) else {
            throw ErrorDeUso.instrumentoDesconocido(nombre)
        }
        mastil = Mastil(encordado, numeroDeTrastes: 15)
    }

    /// Las notas de unas posiciones del mástil y su tablatura, con la afinación del instrumento: la guitarra va en
    /// clave de sol octava baja, una octava más aguda de lo que suena (`Partitura.Pentagrama.claveDelInstrumento`).
    private static func enTablatura(_ posiciones: [PosicionEnElMastil], en mastil: Mastil)
        -> (alturas: [Altura], tablatura: Tablatura)
    {
        let alturas = posiciones.map { mastil.altura(en: $0) }
        var porEvento: [Int: [PosicionEnElMastil]] = [:]
        for (i, posicion) in posiciones.enumerated() { porEvento[i] = [posicion] }
        return (alturas, Tablatura(mastil, posiciones: porEvento))
    }

    /// Los dedos de la mano izquierda en unas posiciones: 0 al aire, 1 en el traste más bajo que se pisa y uno por
    /// traste hasta el 4.
    private static func dedosEnElMastil(_ posiciones: [PosicionEnElMastil]) -> [Int: [Int]] {
        guard let base = posiciones.map(\.traste).filter({ $0 > 0 }).min() else { return [:] }
        var dedos: [Int: [Int]] = [:]
        for (i, posicion) in posiciones.enumerated() {
            dedos[i] = [posicion.traste == 0 ? 0 : min(4, max(1, posicion.traste - base + 1))]
        }
        return dedos
    }

    /// `pentagrama escala`: la escala en redondas o, con `--secuencia`, en una secuencia con ritmo; con `--mano`, con
    /// los dedos del piano; con `--tab`, en la primera posición del mástil (`--caged`, en la primera forma CAGED), con
    /// su tablatura y, con `--dedos`, los dedos.
    private static func pentagramaDeEscala(
        _ argumentos: inout Argumentos, _ opciones: OpcionesDePentagrama, _ octava: Int, _ notacion: Notacion
    ) throws -> ResultadoDeOrden {
        guard let octavas = argumentos.quitarNumero("--octavas", "--octaves", en: 1...4, porDefecto: 1) else {
            throw ErrorDeUso.octavasFueraDeRango
        }
        let bajando = argumentos.quitarMarca("--bajando", "--descending")
        let tab = argumentos.quitarMarca("--tab")
        let caged = argumentos.quitarMarca("--caged")
        let conDedos = argumentos.quitarMarca("--dedos", "--fingers")
        var secuencia: SecuenciaDeEscala?
        if let texto = try argumentos.valor("--secuencia", "--sequence") {
            guard let elegida = secuenciaDeEscala(texto) else { throw ErrorDeUso.secuenciaDesconocida(texto) }
            secuencia = elegida
        }
        var mano: Mano?
        if let texto = try argumentos.valor("--mano", "--hand") {
            guard let elegida = manoDePiano(texto) else { throw ErrorDeUso.manoDesconocida(texto) }
            mano = elegida
        }
        var mastil = Mastil(.guitarra, numeroDeTrastes: 15)
        try leerMastil(&argumentos, en: &mastil)
        if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaLoQueDibujaElPentagrama }
        let escala = try Escala(leyendo: argumentos.unidos)
        let sentido: SentidoDelIntervalo = bajando ? .descendente : .ascendente
        let svg: String
        if tab {
            // En el mástil: la primera posición (o forma CAGED), de la nota más grave a la más aguda.
            let formas = caged ? mastil.posicionesCAGED(de: escala) : mastil.posicionesPorCuerda(de: escala)
            // Si no hay formas (el ukelele, con su cuerda de Sol aguda), la escala en los cinco primeros trastes.
            let clases = Set(escala.notas.map(\.claseDeAltura))
            let posicion =
                formas.first
                ?? EscalaEnElMastil(
                    mastil: mastil, rangoDeTrastes: 0...4,
                    posiciones: mastil.posiciones(deClases: clases).filter { $0.traste <= 4 }.sorted {
                        (mastil.altura(en: $0).midi, $0.traste) < (mastil.altura(en: $1).midi, $1.traste)
                    })
            var titulo = escala.nombre(en: notacion)
            var posiciones: [PosicionEnElMastil]
            if let secuencia {
                posiciones = posicion.secuencia(secuencia, sentido: sentido)
                titulo += " · " + secuencia.nombre(en: notacion)
            } else {
                // De la tónica más grave de la posición a la más aguda, si hay dos.
                posiciones = posicion.recorrido
                let tonicas = posiciones.indices.filter {
                    mastil.altura(en: posiciones[$0]).nota.claseDeAltura == escala.tonica.claseDeAltura
                }
                if let primera = tonicas.first, let ultima = tonicas.last, primera < ultima {
                    posiciones = Array(posiciones[primera...ultima])
                }
                if bajando { posiciones.reverse() }
            }
            let (alturas, tablatura) = enTablatura(posiciones, en: mastil)
            let ritmo = secuencia.map { Partitura.Ritmo.uniforme(figuraDeLaSecuencia($0)) } ?? .libre
            svg = escala.svgPentagrama(
                tocadaEn: alturas, titulo: titulo, ritmo: ritmo,
                porEvento: .init(dedos: conDedos ? dedosEnElMastil(posiciones) : [:]), tablatura: tablatura,
                opciones: opciones)
        } else if let secuencia {
            svg = escala.svgPentagrama(
                secuencia: secuencia, octava: octava, octavas: octavas, sentido: sentido, opciones: opciones)
        } else {
            svg = escala.svgPentagrama(
                octava: octava, octavas: octavas, sentido: bajando ? .descendente : nil,
                digitacion: mano ?? (conDedos ? .derecha : nil), opciones: opciones)
        }
        return bien(svg.trimmingCharacters(in: "\n"))
    }

    /// La figura de una secuencia de estudio, para que cada grupo dure un pulso: corcheas, tresillos o semicorcheas.
    private static func figuraDeLaSecuencia(_ secuencia: SecuenciaDeEscala) -> Duracion {
        switch secuencia.pasos.count {
        case ...2: return .corchea
        case 3: return Duracion.corchea.grupoIrregular(3, en: 2)
        default: return .semicorchea
        }
    }

    /// `pentagrama arpegio`: los arpegios uno detrás de otro, con el cifrado de cada uno encima de su primera nota y,
    /// con `--romanos`, su grado debajo; con `--figura` o `--tresillos`, con su ritmo y sus barras; con `--tab`, el
    /// del primer acorde en la primera posición del mástil, con su tablatura (y, con `--dedos`, los dedos).
    private static func pentagramaDeArpegios(
        _ argumentos: inout Argumentos, _ opciones: OpcionesDePentagrama, _ tonalidad: Tonalidad?, _ octava: Int,
        _ notacion: Notacion
    ) throws -> ResultadoDeOrden {
        var patron = Arpegio.Patron.ascendente
        if let texto = try argumentos.valor("--patron", "--patrón", "--pattern") {
            guard let elegido = patronDeArpegio(texto) else { throw ErrorDeUso.patronDesconocido(texto) }
            patron = elegido
        }
        var figura: Duracion?
        if let texto = try argumentos.valor("--figura", "--figure") {
            let leida = try Duracion(leyendo: texto)
            guard leida > .cero else {
                throw ErrorDeLecturaDePartitura(texto: texto, posicion: nil, motivo: .duracionNoValida(texto))
            }
            figura = leida
        }
        if argumentos.quitarMarca("--tresillos", "--triplets") {
            figura = (figura ?? .corchea).grupoIrregular(3, en: 2)
        }
        let romanos = argumentos.quitarMarca("--romanos", "--roman")
        let conBajoCifrado = argumentos.quitarMarca("--bajo-cifrado", "--figured-bass")
        let tab = argumentos.quitarMarca("--tab")
        let conDedos = argumentos.quitarMarca("--dedos", "--fingers")
        var mastil = Mastil(.guitarra, numeroDeTrastes: 15)
        try leerMastil(&argumentos, en: &mastil)
        var recorrido = RecorridoDeArpegio()
        try leerRecorrido(&argumentos, en: &recorrido)
        if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaLoQueDibujaElPentagrama }
        if tab {
            // En el mástil: el arpegio del acorde en su primera posición, de la nota más grave a la más aguda.
            let acorde = try Acorde(leyendo: argumentos.restantes[0])
            guard let enElMastil = mastil.arpegios(de: acorde).first else {
                throw ErrorDeUso.faltaLoQueDibujaElPentagrama
            }
            // La partitura del arpegio en el mástil, con sus dedos (`ArpegioEnElMastil.dedos`) si se piden.
            let ritmo = figura.map { Partitura.Ritmo.uniforme($0) } ?? .libre
            var partitura = enElMastil.partitura(de: acorde, ritmo: ritmo)
            if !conDedos { partitura.pentagramas[0].voces[0].dedos = [:] }
            return bien(partitura.svg(opciones: opciones).trimmingCharacters(in: "\n"))
        }
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
            if let grados = recorrido.grados {
                arpegios.append(
                    Arpegio(acorde, grados: grados, octavas: recorrido.octavas, aproximacion: recorrido.aproximacion))
            } else {
                arpegios.append(
                    Arpegio(
                        acorde, patron: patron, octavas: recorrido.octavas, conOctava: recorrido.conOctava,
                        inicio: inicio, tensiones: recorrido.tensiones, aproximacion: recorrido.aproximacion))
            }
        }
        let svg: String
        if arpegios.count == 1, figura == nil, !romanos, !conBajoCifrado {
            svg = arpegios[0].svgPentagrama(octava: octava, cifrado: true, opciones: opciones)
        } else {
            // Uno detrás de otro, cada cifrado encima de la primera nota de su arpegio y su grado debajo.
            var eventos: [Evento] = []
            var acordes: [Int: Acorde] = [:]
            for arpegio in arpegios {
                acordes[eventos.count] = arpegio.acorde
                eventos += arpegio.alturas(octava: octava).map { Evento($0, figura ?? .corchea) }
            }
            var grados: [Int: String] = [:]
            if romanos {
                let inicios = acordes.keys.sorted()
                for (inicio, grado) in zip(inicios, gradosRomanos(de: arpegios.map(\.acorde), en: tonalidad)) {
                    grados[inicio] = grado
                }
            }
            var cifrasDelBajo: [Int: [String]] = [:]
            if conBajoCifrado {
                let inicios = acordes.keys.sorted()
                for (inicio, cifras) in zip(inicios, bajoCifrado(de: arpegios.map(\.acorde), en: tonalidad)) {
                    cifrasDelBajo[inicio] = cifras
                }
            }
            let titulo = arpegios.map { $0.nombre(en: notacion) }.joined(separator: " – ")
            let voz = Voz(eventos)
            let linea = Partitura.Linea(
                voz, cifrados: voz.porInicio(acordes), grados: voz.porInicio(grados),
                bajoCifrado: voz.porInicio(cifrasDelBajo))
            svg = Partitura(linea, encabezado: Encabezado(titulo: titulo)).svg(opciones: opciones)
        }
        return bien(svg.trimmingCharacters(in: "\n"))
    }

    /// La mano de `--mano`, en español o en inglés.
    static func manoDePiano(_ texto: String) -> Mano? {
        let manos: [String: Mano] = [
            "derecha": .derecha, "right": .derecha, "izquierda": .izquierda, "left": .izquierda,
        ]
        return manos[texto.lowercased()]
    }

    /// `cuadricula Do Mi Sol`, `cuadricula --ejes 2,5 --acorde Sol7`,
    /// `cuadricula --rejilla 8x8 --origen Do2 --en-tono --escala Re dórico`… Un teclado de cuadrícula con las notas
    /// marcadas en todas las octavas, su contorno y la primera nota con borde naranja. Por defecto, en cuartas (1,5) y
    /// en una ventana de 12 × 7 alrededor del Do4.
    static func cuadricula(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var lectura = Argumentos(argumentos)
        let espejo = lectura.quitarMarca("--espejo", "--mirror")
        let enTono = lectura.quitarMarca("--en-tono", "--in-key")
        guard
            let ejes = valorDe(lectura.quitarOpcion("--ejes", "--axes"), porDefecto: "1,5"),
            let rejillaEscrita = valorDe(lectura.quitarOpcion("--rejilla", "--grid"), porDefecto: "12x7"),
            let origenEscrito = valorDe(lectura.quitarOpcion("--origen", "--origin"), porDefecto: ""),
            let giros = lectura.quitarNumero("--giro", "--rotate", en: 0...3, porDefecto: 0),
            var teclado = TecladoCuadrado.conEjes(ejes),
            let rejilla = leerRejilla(rejillaEscrita)
        else {
            throw ErrorDeUso.opcionesDeCuadricula
        }
        let origen = try origenEscrito.isEmpty ? rejilla.origenPorDefecto : Altura(leyendo: origenEscrito).midi

        let dibujo = try leerDibujo(lectura.restantes, orden: "cuadricula").dibujo
        var escala: Escala?
        let notas: [Nota]
        switch dibujo {
        case .notas(let textos):
            // Con un número de octava, alturas; sin él, notas.
            if textos.contains(where: { $0.contains(where: \.isNumber) }) {
                notas = try textos.map { try Altura(leyendo: $0).nota }
            } else {
                notas = try textos.map { try Nota(leyendo: $0) }
            }
        case .acorde(let acorde): notas = acorde.notas
        case .escala(let leida):
            notas = leida.notas
            escala = leida
        case .clases(let conjunto): notas = conjunto.clases.map { Altura(midi: 60 + $0).nota }
        case .recorrido(let acordes): notas = acordes.flatMap(\.notas)
        case .camino(let desde, let hasta):
            guard let camino = Tonnetz(caminoDesde: desde, hasta: hasta) else {
                throw ErrorDeUso.caminoSoloTriadas(orden: "cuadricula")
            }
            notas = camino.puntos.map(\.nota)
        case .ciclo(let ciclo, let acorde):
            guard let vuelta = Tonnetz(ciclo: ciclo, desde: acorde) else {
                throw ErrorDeUso.cicloSoloTriadas(orden: "cuadricula")
            }
            notas = vuelta.puntos.map(\.nota)
        }

        teclado = teclado.rotado(cuartos: giros)
        if espejo { teclado = teclado.reflejado }
        teclado = teclado.conOrigen(origen)
        if enTono, let escala { teclado = teclado.enTono(escala) }
        let clases = Set(notas.map(\.claseDeAltura))
        let primera = notas.first?.claseDeAltura
        let marcadas = Set((0...127).filter { clases.contains($0 % 12) })
        let primeras = Set((0...127).filter { $0 % 12 == primera })
        let bemoles = notas.contains { $0.pasosDeQuinta < -1 }
        let svg = teclado.svg(
            rejilla.casillas, marcadas: MarcasDeDiagrama(marcadas), primeras: primeras, contorno: true,
            opciones: .init(notacion: notacion, ventana: bemoles ? .bemoles : .sostenidos))
        return bien(svg)
    }

    /// El valor de una opción, `porDefecto` si no está, o `nil` si está sin valor.
    private static func valorDe(_ opcion: Argumentos.Opcion, porDefecto: String) -> String? {
        switch opcion {
        case .ausente: return porDefecto
        case .sinValor: return nil
        case .valor(let texto): return texto
        }
    }

    /// Una rejilla escrita «columnas x filas» (`8x8`, `25×8`), o `nil` si no se lee.
    private static func leerRejilla(_ texto: String) -> RejillaDeControlador? {
        let medidas = texto.lowercased().split(whereSeparator: { $0 == "x" || $0 == "×" }).compactMap { Int($0) }
        guard medidas.count == 2 else { return nil }
        return RejillaDeControlador(comprobando: medidas[0], filas: medidas[1])
    }
}
