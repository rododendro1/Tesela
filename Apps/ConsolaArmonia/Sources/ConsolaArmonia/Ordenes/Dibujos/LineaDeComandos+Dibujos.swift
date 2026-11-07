import Armonia
import Exposicion
import Foundation

// MARK: - Dibujos: Tonnetz, tabla armónica y teclados de cuadrícula

extension LineaDeComandos {
    /// Una suborden como `acorde` en `tonnetz acorde Sol7` o `hoja acordes Rem7 Sol7`, cambiada por la opción con que
    /// se lee (`--acorde`): los argumentos con la primera palabra cambiada si es el nombre, sin los guiones, de una de
    /// `opciones`, o sin ella si es una de `sinNada` (`hoja escala Re dórico` es `hoja Re dórico`). Esas opciones no se
    /// escriben: `tonnetz --acorde Sol7` es una opción desconocida.
    static func conLaSuborden(
        _ argumentos: [String], entre opciones: [OpcionDeOrden], sinNada: Set<String> = []
    ) throws -> [String] {
        if let escrita = argumentos.first(where: { texto in opciones.contains { $0.leidos.contains(texto) } }) {
            throw ErrorDeUso.opcionDesconocida(escrita)
        }
        guard let primera = argumentos.first?.lowercased(), !primera.hasPrefix("-") else { return argumentos }
        if sinNada.contains(primera) { return Array(argumentos.dropFirst()) }
        guard let opcion = opciones.first(where: { $0.leidos.contains("--" + primera) }) else { return argumentos }
        return [opcion.nombres[0]] + argumentos.dropFirst()
    }

    /// `--dedos piano` y `--dedos guitarra`, cambiados por las opciones con que se leen: `--mano derecha` y `--tab
    /// --dedos`. Con `soloPiano` (en `teclado`), `--dedos` a secas es también `--mano derecha` (y `--dedos izquierda`,
    /// `--mano izquierda`); si no, `--dedos` lleva detrás el instrumento. `--mano` no se escribe.
    static func conLosDedos(_ argumentos: [String], soloPiano: Bool) throws -> [String] {
        if let escrita = argumentos.first(where: OpcionDeOrden.mano.leidos.contains) {
            throw ErrorDeUso.opcionDesconocida(escrita)
        }
        let nombres = OpcionDeOrden.dedos.leidos
        guard let i = argumentos.firstIndex(where: nombres.contains) else { return argumentos }
        let siguiente = argumentos.indices.contains(i + 1) ? argumentos[i + 1].lowercased() : nil
        var cambiados = argumentos
        if let siguiente, instrumentosDeLosDedos.piano.contains(siguiente) {
            cambiados.replaceSubrange(i...(i + 1), with: ["--mano", "derecha"])
        } else if !soloPiano, let siguiente, instrumentosDeLosDedos.guitarra.contains(siguiente) {
            cambiados.replaceSubrange(i...(i + 1), with: ["--tab", "--dedos"])
        } else if soloPiano {
            // `teclado … --dedos izquierda` es `--mano izquierda`; `--dedos` a secas, la derecha.
            cambiados[i] = "--mano"
            if siguiente.flatMap(manoDePiano) == nil { cambiados.insert("derecha", at: i + 1) }
        } else {
            throw ErrorDeUso.faltaValor(String(argumentos[i].dropFirst(2)))
        }
        return cambiados
    }

    /// Lo que puede ir tras `--dedos`.
    static let instrumentosDeLosDedos = (piano: Set(["piano"]), guitarra: Set(["guitarra", "guitar"]))

    /// Las subórdenes de `tonnetz`, `tabla` y `cuadricula`.
    static let subordenesDeLosDibujos: [OpcionDeOrden] = [.acorde, .escala, .clases, .recorrido, .camino, .ciclo]

    /// Las palabras que dicen que lo que sigue son unas notas: `tonnetz notas Do Mi Sol` es `tonnetz Do Mi Sol`.
    static let subordenDeNotas: Set = ["notas", "notes"]

    /// Lee los argumentos comunes de `tonnetz`, `tabla` y `cuadricula`: `--margen N` y lo que se dibuja (notas,
    /// `acorde`, `escala`, `clases`, `recorrido`, `camino` o `ciclo`), como en la app Tonnetz. Con
    /// `conOctavas`, unas notas con número de octava se leen como alturas (`Do3 Sol3 Mi4`), que se dan también aparte.
    static func leerDibujo(_ argumentos: [String], orden: String, conOctavas: Bool = true) throws -> (
        contenido: ContenidoDeRed, alturas: [Altura]?, margen: Int?
    ) {
        var lectura = Argumentos(argumentos)
        var margen: Int?
        if let texto = try lectura.valor(.margen, siFalta: .margenFueraDeRango) {
            guard let n = Int(texto), (0...6).contains(n) else { throw ErrorDeUso.margenFueraDeRango }
            margen = n
        }
        let argumentos = try conLaSuborden(lectura.restantes, entre: subordenesDeLosDibujos, sinNada: subordenDeNotas)
        guard let primero = argumentos.first else { throw ErrorDeUso.faltanNotasDelDibujo(orden: orden) }
        // Tras la suborden (`acorde`, `escala`…, que se puede escribir como opción), ninguna opción más.
        try Argumentos(Array(argumentos.dropFirst())).sinOpcionesDesconocidas()
        let resto = argumentos.dropFirst().joined(separator: " ")
        let contenido: ContenidoDeRed
        var alturas: [Altura]?
        switch primero {
        case OpcionDeOrden.acorde:
            guard !resto.isEmpty else { throw ErrorDeUso.faltaAcordeDelDibujo(orden: orden) }
            contenido = .acorde(try Acorde(leyendoEnLaOrden: resto))
        case OpcionDeOrden.escala:
            guard !resto.isEmpty else { throw ErrorDeUso.faltaEscalaDelDibujo(orden: orden) }
            contenido = .escala(try Escala(leyendoEnLaOrden: resto))
        case OpcionDeOrden.clases:
            // Como `armonia conjunto`: «0 4 7», «047», «01t», «Do Mi Sol» o «3-11».
            guard !resto.isEmpty else { throw ErrorDeUso.faltanClasesDelDibujo(orden: orden) }
            contenido = .clases(try ConjuntoDeClasesDeAltura(leyendo: resto).clases)
        case OpcionDeOrden.recorrido:
            let acordes = try argumentos.dropFirst().map { try Acorde(leyendoEnLaOrden: $0) }
            guard !acordes.isEmpty else { throw ErrorDeUso.faltanTriadasDelRecorrido(orden: orden) }
            contenido = .recorrido(acordes)
        case OpcionDeOrden.camino:
            let acordes = try argumentos.dropFirst().map { try Acorde(leyendoEnLaOrden: $0) }
            guard acordes.count == 2 else { throw ErrorDeUso.caminoSoloTriadas(orden: orden) }
            contenido = .camino(acordes[0], acordes[1])
        case OpcionDeOrden.ciclo:
            let partes = Array(argumentos.dropFirst())
            guard partes.count >= 2,
                let ciclo = try? CicloNeorriemanniano(leyendo: partes.dropLast().joined(separator: " "))
            else {
                throw ErrorDeUso.cicloMalEscrito(orden: orden)
            }
            contenido = .ciclo(ciclo, try Acorde(leyendoEnLaOrden: partes.last!))
        default:
            if primero.hasPrefix("--") { throw ErrorDeUso.opcionDesconocida(primero) }
            if conOctavas, argumentos.contains(where: { $0.contains(where: \.isNumber) }) {
                let leidas = try argumentos.map { try Altura(leyendoEnLaOrden: $0) }
                alturas = leidas
                contenido = .notas(leidas.map(\.nota))
            } else {
                contenido = .notas(try argumentos.map { try Nota(leyendoEnLaOrden: $0) })
            }
        }
        return (contenido, alturas, margen)
    }

    /// El contenido en el Tonnetz o en la tabla armónica, o el error de un recorrido, un camino o un ciclo que no son
    /// de tríadas mayores y menores.
    static func red<Red: RedDeTriadas>(_ tipo: Red.Type, de contenido: ContenidoDeRed, orden: String) throws -> Red {
        if let red = contenido.red(tipo) { return red }
        switch contenido {
        case .camino: throw ErrorDeUso.caminoSoloTriadas(orden: orden)
        case .ciclo: throw ErrorDeUso.cicloSoloTriadas(orden: orden)
        default: throw ErrorDeUso.recorridoSoloTriadas(orden: orden)
        }
    }

    /// `tonnetz Do Mi Sol`, `tonnetz acorde Domaj7`, `tonnetz ciclo hexatonico Do`…
    static func tonnetz(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (contenido, _, margen) = try leerDibujo(argumentos, orden: "tonnetz", conOctavas: false)
        let tonnetz = try red(Tonnetz.self, de: contenido, orden: "tonnetz")
        return bien(tonnetz.svg(opciones: .init(notacion: notacion), margen: margen).trimmingCharacters(in: "\n"))
    }

    /// `tabla Do Mi Sol`, `tabla Do3 Sol3 Mi4` (con octava, alturas), `tabla acorde Domaj7`,
    /// `tabla ciclo octatonico Do`…
    static func tablaArmonica(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (contenido, alturas, margen) = try leerDibujo(argumentos, orden: "tabla")
        // Con un número de octava, las alturas como en el instrumento; sin él, las notas.
        let tabla = try alturas.map { TablaArmonica($0) } ?? red(TablaArmonica.self, de: contenido, orden: "tabla")
        return bien(tabla.svg(opciones: .init(notacion: notacion), margen: margen).trimmingCharacters(in: "\n"))
    }

    /// `teclado Re mayor [--dedos [derecha|izquierda]] [--octavas 2]`: la escala en un teclado de piano, en SVG, con
    /// el nombre de cada nota o, con una mano, sus dedos.
    static func teclado(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(try conLosDedos(argumentos, soloPiano: true))
        guard let octavas = argumentos.quitarNumero(.octavas, en: 1...4, porDefecto: 1) else {
            throw ErrorDeUso.octavasFueraDeRango
        }
        var mano: Mano?
        if let texto = try argumentos.valor(.mano) {
            guard let elegida = manoDePiano(texto) else { throw ErrorDeUso.manoDesconocida(texto) }
            mano = elegida
        }
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscalaDelTeclado }
        let escala = try Escala(leyendoEnLaOrden: argumentos.unidos)
        let svg = PresentacionDeEstudioDeEscala.teclado(de: escala, mano: mano, octavas: octavas, en: notacion)
        return bien(svg.trimmingCharacters(in: "\n"))
    }

    /// `reloj Do disminuida [--quintas]`: la escala en un reloj de doce horas, en SVG.
    static func reloj(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        let quintas = argumentos.quitarMarca(.quintas)
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscalaDelReloj }
        let escala = try Escala(leyendoEnLaOrden: argumentos.unidos)
        let svg = PresentacionDeEstudioDeEscala.reloj(
            de: escala, orden: quintas ? .quintas : .cromatico, en: notacion)
        return bien(svg.trimmingCharacters(in: "\n"))
    }

    /// `hoja Re dórico` (o `hoja escala Re dórico`): la escala en una hoja de estudio para imprimir, en SVG, y, con
    /// `--comparar Do dórico`, comparada nota a nota con otra; `hoja acorde Sol7`, la de un acorde; `hoja tonalidad Do
    /// mayor`, la de una tonalidad, y `hoja acordes Rem7 Sol7 Do7M [--en Do mayor] [--doce] [--comparar …]`, la de una
    /// progresión, en las doce tonalidades o comparada con otra. `grabar hoja …` la pasa a PDF.
    static func hoja(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(
            try conLaSuborden(argumentos, entre: [.acorde, .acordes, .tonalidad], sinNada: ["escala", "scale"]))
        if let cifrado = try argumentos.valor(.acorde, siFalta: .faltaElAcordeDeLaHoja) {
            try argumentos.sinOpcionesDesconocidas()
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaElAcordeDeLaHoja }
            let acorde = try Acorde(leyendoEnLaOrden: cifrado)
            return bien(PresentacionDeRelacionesDeAcorde.hojaDeEstudio(de: acorde, en: notacion))
        }
        // Los acordes antes que la tonalidad: en `hoja acordes … --en Do mayor`, es la de los acordes.
        if argumentos.quitarMarca(.acordes) {
            // --doce y --comparar se quitan antes que la tonalidad, que se lleva todo lo que va detrás de --en.
            let doce = argumentos.quitarMarca(.doce)
            let contra = try argumentos.valorConPalabras(.comparar)
            guard let tonalidad = try argumentos.quitarTonalidad() else { throw ErrorDeUso.faltaValor("en") }
            try argumentos.sinOpcionesDesconocidas()
            guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltanLosAcordesDeLaHoja }
            let analisis = try PresentacionDeAnalisis.analizar(
                argumentos.restantes.joined(separator: " "), en: tonalidad, notacion: notacion)
            // Con --comparar, las dos progresiones comparadas acorde a acorde.
            if let contra {
                let otra = try contra.split(separator: " ").map { try Acorde(leyendoEnLaOrden: String($0)) }
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
                        analisis.acordes, tonalidad: propia, en: notacion))
            }
            return bien(PresentacionDeAnalisis.hojaDeEstudio(analisis, en: notacion))
        }
        if let texto = try argumentos.valorConPalabras(.tonalidad, siFalta: .faltaTonalidad) {
            try argumentos.sinOpcionesDesconocidas()
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaTonalidad }
            let tonalidad = try Tonalidad(leyendoEnLaOrden: texto)
            return bien(PresentacionDeTonalidad.hojaDeEstudio(de: tonalidad, en: notacion))
        }
        // `hoja Do mayor --comparar Do dórico`: las dos escalas nota a nota, en el pentagrama y en el reloj.
        let otra = try argumentos.valorConPalabras(.comparar)
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscalaDeLaHoja }
        let escala = try Escala(leyendoEnLaOrden: argumentos.unidos)
        if let otra {
            return bien(
                PresentacionDeEstudioDeEscala.comparacionNotaANota(
                    escala, con: try Escala(leyendoEnLaOrden: otra), en: notacion)
            )
        }
        return bien(PresentacionDeEstudioDeEscala.hojaDeEstudio(de: escala, en: notacion))
    }

    /// `pentagrama escala Re dórico [--octavas 2] [--bajando] [--secuencia terceras] [--dedos piano] [--tab]`,
    /// `pentagrama acorde Sol7`, `pentagrama arpegio Do Lam [--patron alberti] [--figura 16] [--tresillos] [--tab]`,
    /// `pentagrama acordes Rem7 Sol7 Do7M [--romanos] [--bajo-cifrado]`, `pentagrama melodia Do4:8 Re4:8 … --sobre Do
    /// Sol7`: lo que se pide en un pentagrama, en SVG. Con `--nombres`, `--intervalos`, `--semitonos` y `--tonica`, el
    /// nombre y el intervalo de cada nota, los semitonos y la tónica en color; con `--ajenas`, las notas que no son del
    /// acorde en color; con `--octava`, `--clave`, `--doble` y `--cambiar-clave`, el registro y las claves; con
    /// `--en <tonalidad>` (al final), la armadura de esa tonalidad.
    static func pentagrama(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(try conLosDedos(textos, soloPiano: false))
        guard let tonalidad = try argumentos.quitarTonalidad() else { throw ErrorDeUso.faltaValor("en") }
        var opciones = OpcionesDePentagrama(notacion: notacion)
        if let tonalidad { opciones.armadura = .tonalidad(tonalidad) }
        opciones.marcas.nombresDeLasNotas = argumentos.quitarMarca(.nombres)
        opciones.marcas.intervalosDeLasNotas = argumentos.quitarMarca(.intervalos)
        opciones.marcas.semitonos = argumentos.quitarMarca(.semitonos)
        opciones.marcas.tonica = argumentos.quitarMarca(.tonica)
        opciones.marcas.notasAjenas = argumentos.quitarMarca(.ajenas)
        if argumentos.quitarMarca(.doble) { opciones.maquetacion.pentagramas = .doble }
        // Los cambios de clave son en un solo pentagrama.
        opciones.maquetacion.cambiosDeClave = argumentos.quitarMarca(.cambiarClave)
        if opciones.maquetacion.cambiosDeClave { opciones.maquetacion.pentagramas = .simple }
        if let texto = try argumentos.valor(.clave) {
            guard let clave = leerClave(texto) else { throw ErrorDeUso.claveDesconocida(texto) }
            opciones.maquetacion.clave = clave
            opciones.maquetacion.pentagramas = .simple
        }
        guard let octava = argumentos.quitarNumero(.registro, en: 0...7, porDefecto: 4) else {
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
            try argumentos.sinOpcionesDesconocidas()
            guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaLoQueDibujaElPentagrama }
            svg = try Acorde(leyendoEnLaOrden: argumentos.unidos).svgPentagrama(octava: octava, opciones: opciones)
        case "acordes":
            let romanos = argumentos.quitarMarca(.romanos)
            let conBajoCifrado = argumentos.quitarMarca(.bajoCifrado)
            try argumentos.sinOpcionesDesconocidas()
            guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaLoQueDibujaElPentagrama }
            let acordes = try argumentos.restantes.map { try Acorde(leyendoEnLaOrden: $0) }
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
            let tab = argumentos.quitarMarca(.tab)
            try argumentos.sinOpcionesDesconocidas()
            let acordes = try argumentos.restantes.map { try Acorde(leyendoEnLaOrden: $0) }
            guard let bajo = PresentacionDeAnalisis.bajoCaminante(acordes, en: notacion) else {
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
        if let texto = try argumentos.valorConPalabras(.sobre) {
            acordes = try texto.split(separator: " ").map { try Acorde(leyendoEnLaOrden: String($0)) }
            opciones.marcas.notasAjenas = true
        }
        try argumentos.sinOpcionesDesconocidas()
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
        guard let nombre = try argumentos.valor(.instrumento, siFalta: .faltaInstrumento) else {
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

    /// `pentagrama escala`: la escala en redondas o, con `--secuencia`, en una secuencia con ritmo; con `--dedos piano`, con
    /// los dedos del piano; con `--tab`, en la primera posición del mástil (`--caged`, en la primera forma CAGED), con
    /// su tablatura y, con `--dedos`, los dedos.
    private static func pentagramaDeEscala(
        _ argumentos: inout Argumentos, _ opciones: OpcionesDePentagrama, _ octava: Int, _ notacion: Notacion
    ) throws -> ResultadoDeOrden {
        guard let octavas = argumentos.quitarNumero(.octavas, en: 1...4, porDefecto: 1) else {
            throw ErrorDeUso.octavasFueraDeRango
        }
        let bajando = argumentos.quitarMarca(.bajando)
        let tab = argumentos.quitarMarca(.tab)
        let caged = argumentos.quitarMarca(.caged)
        let conDedos = argumentos.quitarMarca(.dedos)
        var secuencia: SecuenciaDeEscala?
        if let texto = try argumentos.valor(.secuencia) {
            guard let elegida = secuenciaDeEscala(texto) else { throw ErrorDeUso.secuenciaDesconocida(texto) }
            secuencia = elegida
        }
        var mano: Mano?
        if let texto = try argumentos.valor(.mano) {
            guard let elegida = manoDePiano(texto) else { throw ErrorDeUso.manoDesconocida(texto) }
            mano = elegida
        }
        var mastil = Mastil(.guitarra, numeroDeTrastes: 15)
        try leerMastil(&argumentos, en: &mastil)
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaLoQueDibujaElPentagrama }
        let escala = try Escala(leyendoEnLaOrden: argumentos.unidos)
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
        if let texto = try argumentos.valor(.patron) {
            guard let elegido = patronDeArpegio(texto) else { throw ErrorDeUso.patronDesconocido(texto) }
            patron = elegido
        }
        var figura: Duracion?
        if let texto = try argumentos.valor(.figura) {
            let leida = try Duracion(leyendo: texto)
            guard leida > .cero else {
                throw ErrorDeLecturaDePartitura(texto: texto, posicion: nil, motivo: .duracionNoValida(texto))
            }
            figura = leida
        }
        if argumentos.quitarMarca(.tresillos) {
            figura = (figura ?? .corchea).grupoIrregular(3, en: 2)
        }
        let romanos = argumentos.quitarMarca(.romanos)
        let conBajoCifrado = argumentos.quitarMarca(.bajoCifrado)
        let tab = argumentos.quitarMarca(.tab)
        let conDedos = argumentos.quitarMarca(.dedos)
        var mastil = Mastil(.guitarra, numeroDeTrastes: 15)
        try leerMastil(&argumentos, en: &mastil)
        var recorrido = RecorridoDeArpegio()
        try leerRecorrido(&argumentos, en: &recorrido)
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaLoQueDibujaElPentagrama }
        if tab {
            // En el mástil: el arpegio del acorde en su primera posición, de la nota más grave a la más aguda.
            let acorde = try Acorde(leyendoEnLaOrden: argumentos.restantes[0])
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
            let acorde = try Acorde(leyendoEnLaOrden: texto)
            var inicio = 0
            if let desde = recorrido.desde {
                let delGrado = Int(desde).flatMap { Arpegio.indice(delGrado: $0, en: acorde) }
                let deLaNota = (try? Nota(leyendoEnLaOrden: desde)).flatMap { Arpegio.indice(de: $0, en: acorde) }
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

    /// La mano de `teclado … --dedos`, en español o en inglés.
    static func manoDePiano(_ texto: String) -> Mano? {
        let manos: [String: Mano] = [
            "derecha": .derecha, "right": .derecha, "izquierda": .izquierda, "left": .izquierda,
        ]
        return manos[texto.lowercased()]
    }

    /// `cuadricula Do Mi Sol`, `cuadricula acorde Sol7 --ejes 2,5`,
    /// `cuadricula escala Re dórico --rejilla 8x8 --origen Do2 --en-tono`… Un teclado de cuadrícula con las notas
    /// marcadas en todas las octavas, su contorno y la primera nota con borde naranja. Por defecto, en cuartas (1,5) y
    /// en una ventana de 12 × 7 alrededor del Do4.
    static func cuadricula(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var lectura = Argumentos(argumentos)
        let espejo = lectura.quitarMarca(.espejo)
        let enTono = lectura.quitarMarca(.enTono)
        guard
            let ejes = valorDe(lectura.quitarOpcion(.ejes), porDefecto: "1,5"),
            let rejillaEscrita = valorDe(lectura.quitarOpcion(.rejilla), porDefecto: "12x7"),
            let origenEscrito = valorDe(lectura.quitarOpcion(.origen), porDefecto: ""),
            let giros = lectura.quitarNumero(.giro, en: 0...3, porDefecto: 0),
            var teclado = TecladoCuadrado.conEjes(ejes),
            let rejilla = leerRejilla(rejillaEscrita)
        else {
            throw ErrorDeUso.opcionesDeCuadricula
        }
        let origen = try origenEscrito.isEmpty ? rejilla.origenPorDefecto : Altura(leyendoEnLaOrden: origenEscrito).midi

        let contenido = try leerDibujo(lectura.restantes, orden: "cuadricula").contenido
        // Las notas de un camino o un ciclo son las de sus tríadas en el Tonnetz: sin tríadas, no hay nada que dibujar.
        switch contenido {
        case .camino, .ciclo: _ = try red(Tonnetz.self, de: contenido, orden: "cuadricula")
        default: break
        }

        teclado = teclado.rotado(cuartos: giros)
        if espejo { teclado = teclado.reflejado }
        teclado = teclado.conOrigen(origen)
        if enTono, let escala = contenido.escala { teclado = teclado.enTono(escala) }
        let svg = PresentacionDeRedes.svg(contenido, en: teclado, casillas: rejilla.casillas, notacion: notacion)
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
