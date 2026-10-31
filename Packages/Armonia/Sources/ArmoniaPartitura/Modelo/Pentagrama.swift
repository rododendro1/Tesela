import ArmoniaNucleo
import ArmoniaTeoria

// Claves y posición de las notas en el pentagrama.
//
// La posición se cuenta en pasos diatónicos desde la primera línea (la inferior):
//
//     8  ───── 5.ª línea
//     7        4.º espacio
//     6  ───── 4.ª línea
//     5        3.er espacio
//     4  ───── 3.ª línea
//     3        2.º espacio
//     2  ───── 2.ª línea
//     1        1.er espacio
//     0  ───── 1.ª línea
//    −1        debajo del pentagrama
//    −2  ─ ─   1.ª línea adicional inferior
//
// Como `Altura.pasos` ya cuenta pasos diatónicos, la posición es una simple resta, y la
// alteración (♯, ♭) no cambia la posición: Fa4 y Fa♯4 se escriben en el mismo sitio.

public enum Clave: Hashable, Sendable, CaseIterable, CustomStringConvertible {
    /// Clave de sol en 2.ª línea (violín).
    case sol
    /// Clave de sol que suena una octava más grave (tenor, guitarra).
    case solOctavaBaja
    /// Clave de sol que suena una octava más aguda (flautín, en partituras modernas).
    case solOctavaAlta
    /// Clave de fa en 4.ª línea (bajo).
    case fa
    /// Clave de fa en 3.ª línea (barítono).
    case faEnTercera
    /// Clave de do en 1.ª línea (soprano).
    case doEnPrimera
    /// Clave de do en 2.ª línea (mezzosoprano).
    case doEnSegunda
    /// Clave de do en 3.ª línea (contralto, viola).
    case doEnTercera
    /// Clave de do en 4.ª línea (tenor, violonchelo y fagot en el registro agudo).
    case doEnCuarta

    /// Altura que se escribe en la primera línea.
    public var alturaDeLaPrimeraLinea: Altura {
        switch self {
        case .sol: return Altura(.mi, octava: 4)
        case .solOctavaBaja: return Altura(.mi, octava: 3)
        case .solOctavaAlta: return Altura(.mi, octava: 5)
        case .fa: return Altura(.sol, octava: 2)
        case .faEnTercera: return Altura(.si, octava: 2)
        case .doEnPrimera: return Altura(.do, octava: 4)
        case .doEnSegunda: return Altura(.la, octava: 3)
        case .doEnTercera: return Altura(.fa, octava: 3)
        case .doEnCuarta: return Altura(.re, octava: 3)
        }
    }

    public var description: String { nombre }

    /// Dónde se escribe una nota: `Clave.sol.posicion(de: "Do4")` → 1.ª línea adicional inferior.
    public func posicion(de nota: Altura) -> PosicionEnPentagrama {
        PosicionEnPentagrama(lugar: nota.pasos - alturaDeLaPrimeraLinea.pasos, alteracion: nota.nota.alteracion)
    }

    /// La nota escrita en una posición, con la alteración indicada:
    /// `Clave.fa.altura(lugar: 8)` → La3.
    public func altura(lugar: Int, alteracion: Alteracion = .natural) -> Altura {
        let pasos = alturaDeLaPrimeraLinea.pasos + lugar
        let letra = NotaNatural(rawValue: modulo(pasos, 7)) ?? .do
        return Altura(Nota(letra, alteracion), octava: 4 + divisionEntera(pasos, 7))
    }

    /// Altura de la línea central (3.ª línea).
    public var alturaCentral: Altura { altura(lugar: 4) }

    /// La clave que necesita menos líneas adicionales para escribir unas notas
    /// (por defecto, entre sol y fa). En caso de empate, la primera de la lista.
    public static func masAdecuada(para notas: [Altura], entre claves: [Clave] = [.sol, .fa]) -> Clave? {
        claves.min { a, b in
            let la = notas.reduce(0) { $0 + abs(a.posicion(de: $1).lineasAdicionales) }
            let lb = notas.reduce(0) { $0 + abs(b.posicion(de: $1).lineasAdicionales) }
            return la < lb
        }
    }
}

extension Clave: Nombrable {}

/// Lugar de una nota en el pentagrama.
public struct PosicionEnPentagrama: Hashable, Sendable, CustomStringConvertible {
    /// 0 = primera línea, 1 = primer espacio … 8 = quinta línea. Negativo por debajo,
    /// mayor que 8 por encima.
    public let lugar: Int
    /// Alteración que hay que escribir delante (+1 = ♯, −1 = ♭), sin contar la armadura.
    public let alteracion: Alteracion

    public init(lugar: Int, alteracion: Alteracion = .natural) {
        self.lugar = lugar
        self.alteracion = alteracion
    }

    public var esLinea: Bool { modulo(lugar, 2) == 0 }
    public var estaDentroDelPentagrama: Bool { (0...8).contains(lugar) }

    /// Líneas adicionales necesarias: negativas por debajo, positivas por encima, 0 dentro.
    /// Do4 en clave de sol → −1; La5 → 1; Si3 → −1 (el espacio bajo la línea del Do).
    public var lineasAdicionales: Int {
        if lugar <= -2 { return -(-lugar / 2) }
        if lugar >= 10 { return (lugar - 8) / 2 }
        return 0
    }

    /// "2.ª línea", "3.er espacio", "1.ª línea adicional inferior", "encima de la 5.ª línea".
    public var descripcion: String {
        let lineas = ["1.ª", "2.ª", "3.ª", "4.ª", "5.ª"]
        let espacios = ["1.er", "2.º", "3.er", "4.º"]
        switch lugar {
        case 0...8:
            return esLinea ? "\(lineas[lugar / 2]) línea" : "\(espacios[lugar / 2]) espacio"
        case -1:
            return "debajo de la 1.ª línea"
        case 9:
            return "encima de la 5.ª línea"
        default:
            let n = abs(lineasAdicionales)
            let lado = lugar < 0 ? "inferior" : "superior"
            let linea = "\(n).ª línea adicional \(lado)"
            if esLinea { return linea }
            return (lugar < 0 ? "debajo de la " : "encima de la ") + linea
        }
    }

    public var description: String {
        descripcion + (alteracion.esNatural ? "" : " (\(alteracion.simbolo))")
    }
}

// Instrumentos y transposición.
//
// Un instrumento transpositor lee una nota y suena otra: el clarinete en Si♭ lee Do y suena
// Si♭ (una 2ª mayor más grave). La transposición es un intervalo con dirección desde la nota
// escrita hasta la que suena, así que escribir para el instrumento es restarlo.

/// Un instrumento tal como se escribe en la partitura: su nombre, la clave en la que se lee y, si es
/// transpositor, lo que transporta. Las cuerdas de un instrumento con trastes y su afinación son un `Encordado`.
public struct InstrumentoDePartitura: Hashable, Sendable, CustomStringConvertible {
    public let nombre: String
    private let nombreEnIngles: String
    /// Intervalo desde la nota escrita hasta la que suena (descendente si suena más grave).
    public let transposicion: Intervalo
    /// Clave en la que se escribe habitualmente.
    public let clave: Clave

    public init(
        nombre: String, nombreEnIngles: String, transposicion: Intervalo = .unisono,
        clave: Clave = .sol
    ) {
        self.nombre = nombre
        self.nombreEnIngles = nombreEnIngles
        self.transposicion = transposicion
        self.clave = clave
    }

    /// "clarinete en si♭", "B♭ clarinet", "clarinet en si♭", "clarinete en si♭", "si♭ klarinetea",
    /// "clarinete em si♭", "clarinette en si♭", "clarinetto in si♭", "Klarinette in B", "кларнет in B"…
    public func nombre(en notacion: Notacion) -> String {
        switch notacion.textos {
        case .espanol: return nombre
        case .ingles: return nombreEnIngles
        case .catalan: return InstrumentoDePartitura.nombresPeninsulares[nombre]?.catalan ?? nombre
        case .gallego: return InstrumentoDePartitura.nombresPeninsulares[nombre]?.gallego ?? nombre
        case .asturiano: return InstrumentoDePartitura.nombresAragonesesYAsturianos[nombre]?.asturiano ?? nombre
        case .aragones: return InstrumentoDePartitura.nombresAragonesesYAsturianos[nombre]?.aragones ?? nombre
        case .euskera: return InstrumentoDePartitura.nombresPeninsulares[nombre]?.euskera ?? nombre
        case .portugues: return InstrumentoDePartitura.nombresRomanicos[nombre]?.portugues ?? nombre
        case .frances: return InstrumentoDePartitura.nombresRomanicos[nombre]?.frances ?? nombre
        case .occitano: return InstrumentoDePartitura.nombresDeOtrasLenguas[nombre]?.occitano ?? nombreEnIngles
        case .italiano: return InstrumentoDePartitura.nombresRomanicos[nombre]?.italiano ?? nombre
        case .aleman: return InstrumentoDePartitura.nombresDeOtrasLenguas[nombre]?.aleman ?? nombreEnIngles
        case .griego: return InstrumentoDePartitura.nombresDeOtrasLenguas[nombre]?.griego ?? nombreEnIngles
        case .ruso: return InstrumentoDePartitura.nombresDeOtrasLenguas[nombre]?.ruso ?? nombreEnIngles
        }
    }

    public var esTranspositor: Bool { transposicion != .unisono }

    /// Altura que suena al tocar una nota escrita: clarinete en Si♭, Do5 escrito → Si♭4.
    public func sonido(de escrita: Altura) -> Altura { escrita + transposicion }

    /// Altura que hay que escribir para que suene la dada: clarinete en Si♭, Si♭4 → Do5.
    public func escritura(de sonido: Altura) -> Altura { sonido - transposicion }

    public func sonido(de escrita: Nota) -> Nota { escrita + transposicion }
    public func escritura(de sonido: Nota) -> Nota { sonido - transposicion }

    /// Cifrado escrito para un acorde que debe sonar: saxo alto, Do7 → La7.
    public func escritura(de acorde: Acorde) -> Acorde { acorde.transponer(-transposicion) }

    /// Escala escrita para una escala de concierto: clarinete en Si♭, Mi♭ mayor → Fa mayor.
    /// Con `simplificar`, se cambia por su enarmónica si tiene menos alteraciones
    /// (saxo alto, Si mayor → La♭ mayor en lugar de Sol♯ mayor).
    public func escritura(de escala: Escala, simplificar: Bool = true) -> Escala {
        let escrita = escala.transponer(-transposicion)
        return simplificar ? escrita.enarmonicaMasSimple : escrita
    }

    /// Lo mismo para una tonalidad: trompa en fa, Si♭ mayor de concierto → Fa mayor.
    public func escritura(de tonalidad: Tonalidad, simplificar: Bool = true) -> Tonalidad {
        let escrita = tonalidad.transponer(-transposicion)
        return simplificar ? escrita.enarmonicaMasSimple : escrita
    }

    /// Melodía escrita para una melodía que debe sonar.
    public func escritura(de melodia: Melodia) -> Melodia { melodia.transponer(-transposicion) }
    public func sonido(de melodia: Melodia) -> Melodia { melodia.transponer(transposicion) }

    public var description: String { nombre }

    // MARK: Instrumentos predefinidos

    private static func abajo(_ i: Intervalo) -> Intervalo { -i }

    public static let piano = InstrumentoDePartitura(nombre: "piano", nombreEnIngles: "piano")
    public static let flauta = InstrumentoDePartitura(nombre: "flauta", nombreEnIngles: "flute")
    public static let flautin = InstrumentoDePartitura(
        nombre: "flautín", nombreEnIngles: "piccolo",
        transposicion: .octava)
    public static let flautaEnSol = InstrumentoDePartitura(
        nombre: "flauta en sol", nombreEnIngles: "alto flute",
        transposicion: abajo(.cuartaJusta))
    public static let oboe = InstrumentoDePartitura(nombre: "oboe", nombreEnIngles: "oboe")
    public static let cornoIngles = InstrumentoDePartitura(
        nombre: "corno inglés", nombreEnIngles: "English horn",
        transposicion: abajo(.quintaJusta))
    public static let clarineteEnSib = InstrumentoDePartitura(
        nombre: "clarinete en si♭", nombreEnIngles: "B♭ clarinet",
        transposicion: abajo(.segundaMayor))
    public static let clarineteEnLa = InstrumentoDePartitura(
        nombre: "clarinete en la", nombreEnIngles: "A clarinet",
        transposicion: abajo(.terceraMenor))
    public static let clarineteEnMib = InstrumentoDePartitura(
        nombre: "clarinete en mi♭", nombreEnIngles: "E♭ clarinet",
        transposicion: .terceraMenor)
    public static let clarineteBajo = InstrumentoDePartitura(
        nombre: "clarinete bajo", nombreEnIngles: "bass clarinet",
        transposicion: abajo(.novenaMayor))
    public static let fagot = InstrumentoDePartitura(nombre: "fagot", nombreEnIngles: "bassoon", clave: .fa)
    public static let saxofonSoprano = InstrumentoDePartitura(
        nombre: "saxofón soprano", nombreEnIngles: "soprano saxophone",
        transposicion: abajo(.segundaMayor))
    public static let saxofonAlto = InstrumentoDePartitura(
        nombre: "saxofón alto", nombreEnIngles: "alto saxophone",
        transposicion: abajo(.sextaMayor))
    public static let saxofonTenor = InstrumentoDePartitura(
        nombre: "saxofón tenor", nombreEnIngles: "tenor saxophone",
        transposicion: abajo(.novenaMayor))
    public static let saxofonBaritono = InstrumentoDePartitura(
        nombre: "saxofón barítono", nombreEnIngles: "baritone saxophone",
        transposicion: abajo(.decimoterceraMayor))
    public static let trompetaEnSib = InstrumentoDePartitura(
        nombre: "trompeta en si♭", nombreEnIngles: "B♭ trumpet",
        transposicion: abajo(.segundaMayor))
    public static let trompetaEnDo = InstrumentoDePartitura(nombre: "trompeta en do", nombreEnIngles: "C trumpet")
    public static let fliscorno = InstrumentoDePartitura(
        nombre: "fliscorno", nombreEnIngles: "flugelhorn",
        transposicion: abajo(.segundaMayor))
    public static let trompaEnFa = InstrumentoDePartitura(
        nombre: "trompa en fa", nombreEnIngles: "horn in F",
        transposicion: abajo(.quintaJusta))
    public static let trombon = InstrumentoDePartitura(nombre: "trombón", nombreEnIngles: "trombone", clave: .fa)
    public static let tuba = InstrumentoDePartitura(nombre: "tuba", nombreEnIngles: "tuba", clave: .fa)
    public static let violin = InstrumentoDePartitura(nombre: "violín", nombreEnIngles: "violin")
    public static let viola = InstrumentoDePartitura(nombre: "viola", nombreEnIngles: "viola", clave: .doEnTercera)
    public static let violonchelo = InstrumentoDePartitura(nombre: "violonchelo", nombreEnIngles: "cello", clave: .fa)
    public static let contrabajo = InstrumentoDePartitura(
        nombre: "contrabajo", nombreEnIngles: "double bass",
        transposicion: abajo(.octava), clave: .fa)
    public static let guitarra = InstrumentoDePartitura(
        nombre: "guitarra", nombreEnIngles: "guitar",
        transposicion: abajo(.octava), clave: .solOctavaBaja)
    public static let bajoElectrico = InstrumentoDePartitura(
        nombre: "bajo eléctrico", nombreEnIngles: "electric bass",
        transposicion: abajo(.octava), clave: .fa)
    public static let xilofono = InstrumentoDePartitura(
        nombre: "xilófono", nombreEnIngles: "xylophone",
        transposicion: .octava)
    public static let glockenspiel = InstrumentoDePartitura(
        nombre: "glockenspiel", nombreEnIngles: "glockenspiel",
        transposicion: 2 * Intervalo.octava)
    public static let celesta = InstrumentoDePartitura(
        nombre: "celesta", nombreEnIngles: "celesta",
        transposicion: .octava)

    public static let todos: [InstrumentoDePartitura] = [
        .piano, .flauta, .flautin, .flautaEnSol, .oboe, .cornoIngles,
        .clarineteEnSib, .clarineteEnLa, .clarineteEnMib, .clarineteBajo, .fagot,
        .saxofonSoprano, .saxofonAlto, .saxofonTenor, .saxofonBaritono,
        .trompetaEnSib, .trompetaEnDo, .fliscorno, .trompaEnFa, .trombon, .tuba,
        .violin, .viola, .violonchelo, .contrabajo, .guitarra, .bajoElectrico,
        .xilofono, .glockenspiel, .celesta,
    ]
}

extension InstrumentoDePartitura: Nombrable {}

// MARK: - Idiomas
//
// Nombres de las claves y de los instrumentos predefinidos en los catorce idiomas de los textos (`Traduccion`). El resto de nombres que dependen del idioma, en `Fundamentos/Nota.swift` y `Fundamentos/Intervalo.swift`.

// MARK: - Clave

extension Clave {
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .sol:
            return TextosDePartitura.traducidos.map(\.claveDeSol)
        case .solOctavaBaja:
            return TextosDePartitura.traducidos.map(\.claveDeSolOctavaBaja)
        case .solOctavaAlta:
            return TextosDePartitura.traducidos.map(\.claveDeSolOctavaAlta)
        case .fa:
            return TextosDePartitura.traducidos.map(\.claveDeFa)
        case .faEnTercera:
            return TextosDePartitura.traducidos.map(\.claveDeFaEnTercera)
        case .doEnPrimera:
            return TextosDePartitura.traducidos.map(\.claveDeDoEnPrimera)
        case .doEnSegunda:
            return TextosDePartitura.traducidos.map(\.claveDeDoEnSegunda)
        case .doEnTercera:
            return TextosDePartitura.traducidos.map(\.claveDeDoEnTercera)
        case .doEnCuarta:
            return TextosDePartitura.traducidos.map(\.claveDeDoEnCuarta)
        }
    }
}

// MARK: - InstrumentoDePartitura

extension InstrumentoDePartitura {
    /// Catalán, gallego y euskera de los instrumentos predefinidos, por su nombre en español. Un
    /// instrumento que no está aquí usa su nombre español.
    package static let nombresPeninsulares: [String: (catalan: String, gallego: String, euskera: String)] = [
        "piano": ("piano", "piano", "pianoa"),
        "flauta": ("flauta", "frauta", "flauta"),
        "flautín": ("flautí", "frautín", "pikoloa"),
        "flauta en sol": ("flauta en sol", "frauta en sol", "sol flauta"),
        "oboe": ("oboè", "óboe", "oboea"),
        "corno inglés": ("corn anglès", "corno inglés", "korno ingelesa"),
        "clarinete en si♭": ("clarinet en si♭", "clarinete en si♭", "si♭ klarinetea"),
        "clarinete en la": ("clarinet en la", "clarinete en la", "la klarinetea"),
        "clarinete en mi♭": ("clarinet en mi♭", "clarinete en mi♭", "mi♭ klarinetea"),
        "clarinete bajo": ("clarinet baix", "clarinete baixo", "klarinete baxua"),
        "fagot": ("fagot", "fagot", "fagota"),
        "saxofón soprano": ("saxòfon soprano", "saxofón soprano", "saxofoi sopranoa"),
        "saxofón alto": ("saxòfon alt", "saxofón alto", "saxofoi altua"),
        "saxofón tenor": ("saxòfon tenor", "saxofón tenor", "saxofoi tenorra"),
        "saxofón barítono": ("saxòfon baríton", "saxofón barítono", "saxofoi baritonoa"),
        "trompeta en si♭": ("trompeta en si♭", "trompeta en si♭", "si♭ tronpeta"),
        "trompeta en do": ("trompeta en do", "trompeta en do", "do tronpeta"),
        "fliscorno": ("fiscorn", "fliscorno", "fliscornoa"),
        "trompa en fa": ("trompa en fa", "trompa en fa", "fa tronpa"),
        "trombón": ("trombó", "trombón", "tronboia"),
        "tuba": ("tuba", "tuba", "tuba"),
        "violín": ("violí", "violín", "biolina"),
        "viola": ("viola", "viola", "biola"),
        "violonchelo": ("violoncel", "violonchelo", "biolontxeloa"),
        "contrabajo": ("contrabaix", "contrabaixo", "kontrabaxua"),
        "guitarra": ("guitarra", "guitarra", "gitarra"),
        "bajo eléctrico": ("baix elèctric", "baixo eléctrico", "baxu elektrikoa"),
        "xilófono": ("xilòfon", "xilófono", "xilofonoa"),
        "glockenspiel": ("glockenspiel", "glockenspiel", "glockenspiela"),
        "celesta": ("celesta", "celesta", "zelesta"),
    ]

    /// Aragonés y asturiano de los instrumentos predefinidos, por su nombre en español. Un instrumento que no
    /// está aquí usa su nombre español.
    package static let nombresAragonesesYAsturianos: [String: (aragones: String, asturiano: String)] = [
        "piano": ("piano", "pianu"),
        "flauta": ("flauta", "flauta"),
        "flautín": ("flautín", "flautín"),
        "flauta en sol": ("flauta en sol", "flauta en sol"),
        "oboe": ("oboe", "oboe"),
        "corno inglés": ("corno anglés", "cornu inglés"),
        "clarinete en si♭": ("clarinet en si♭", "clarinete en si♭"),
        "clarinete en la": ("clarinet en la", "clarinete en la"),
        "clarinete en mi♭": ("clarinet en mi♭", "clarinete en mi♭"),
        "clarinete bajo": ("clarinet baixo", "clarinete baxu"),
        "fagot": ("fagot", "fagot"),
        "saxofón soprano": ("saxofón soprano", "saxofón soprano"),
        "saxofón alto": ("saxofón alto", "saxofón altu"),
        "saxofón tenor": ("saxofón tenor", "saxofón tenor"),
        "saxofón barítono": ("saxofón barítono", "saxofón barítonu"),
        "trompeta en si♭": ("trompeta en si♭", "trompeta en si♭"),
        "trompeta en do": ("trompeta en do", "trompeta en do"),
        "fliscorno": ("fliscorno", "fliscornu"),
        "trompa en fa": ("trompa en fa", "trompa en fa"),
        "trombón": ("trombón", "trombón"),
        "tuba": ("tuba", "tuba"),
        "violín": ("violín", "violín"),
        "viola": ("viola", "viola"),
        "violonchelo": ("violonchelo", "violonchelu"),
        "contrabajo": ("contrabaixo", "contrabaxu"),
        "guitarra": ("guitarra", "guitarra"),
        "bajo eléctrico": ("baixo electrico", "baxu llétricu"),
        "xilófono": ("xilófono", "xilófonu"),
        "glockenspiel": ("glockenspiel", "glockenspiel"),
        "celesta": ("celesta", "celesta"),
    ]

    /// Portugués, francés e italiano de los instrumentos predefinidos, por su nombre en español. Un
    /// instrumento que no está aquí usa su nombre español.
    package static let nombresRomanicos: [String: (portugues: String, frances: String, italiano: String)] = [
        "piano": ("piano", "piano", "pianoforte"),
        "flauta": ("flauta", "flûte", "flauto"),
        "flautín": ("flautim", "piccolo", "ottavino"),
        "flauta en sol": ("flauta em sol", "flûte en sol", "flauto contralto"),
        "oboe": ("oboé", "hautbois", "oboe"),
        "corno inglés": ("corne-inglês", "cor anglais", "corno inglese"),
        "clarinete en si♭": ("clarinete em si♭", "clarinette en si♭", "clarinetto in si♭"),
        "clarinete en la": ("clarinete em lá", "clarinette en la", "clarinetto in la"),
        "clarinete en mi♭": ("clarinete em mi♭", "clarinette en mi♭", "clarinetto in mi♭"),
        "clarinete bajo": ("clarinete baixo", "clarinette basse", "clarinetto basso"),
        "fagot": ("fagote", "basson", "fagotto"),
        "saxofón soprano": ("saxofone soprano", "saxophone soprano", "sassofono soprano"),
        "saxofón alto": ("saxofone alto", "saxophone alto", "sassofono contralto"),
        "saxofón tenor": ("saxofone tenor", "saxophone ténor", "sassofono tenore"),
        "saxofón barítono": ("saxofone barítono", "saxophone baryton", "sassofono baritono"),
        "trompeta en si♭": ("trompete em si♭", "trompette en si♭", "tromba in si♭"),
        "trompeta en do": ("trompete em dó", "trompette en ut", "tromba in do"),
        "fliscorno": ("fliscórnio", "bugle", "flicorno"),
        "trompa en fa": ("trompa em fá", "cor en fa", "corno in fa"),
        "trombón": ("trombone", "trombone", "trombone"),
        "tuba": ("tuba", "tuba", "tuba"),
        "violín": ("violino", "violon", "violino"),
        "viola": ("viola", "alto", "viola"),
        "violonchelo": ("violoncelo", "violoncelle", "violoncello"),
        "contrabajo": ("contrabaixo", "contrebasse", "contrabbasso"),
        "guitarra": ("guitarra", "guitare", "chitarra"),
        "bajo eléctrico": ("baixo elétrico", "basse électrique", "basso elettrico"),
        "xilófono": ("xilofone", "xylophone", "xilofono"),
        "glockenspiel": ("glockenspiel", "glockenspiel", "glockenspiel"),
        "celesta": ("celesta", "célesta", "celesta"),
    ]

    /// Alemán, occitano, griego y ruso de los instrumentos predefinidos, por su nombre en español. Un
    /// instrumento que no está aquí usa su nombre inglés. En alemán y en ruso, la afinación va con letras
    /// alemanas: «Klarinette in B» es el clarinete en si♭.
    package static let nombresDeOtrasLenguas:
        [String: (aleman: String, occitano: String, ruso: String, griego: String)] = [
            "piano": ("Klavier", "piano", "фортепиано", "πιάνο"),
            "flauta": ("Flöte", "flaüta", "флейта", "φλάουτο"),
            "flautín": ("Piccoloflöte", "flautin", "флейта-пикколо", "πίκολο"),
            "flauta en sol": ("Altflöte in G", "flaüta en sòl", "альтовая флейта", "φλάουτο άλτο σε σολ"),
            "oboe": ("Oboe", "oboè", "гобой", "όμποε"),
            "corno inglés": ("Englischhorn", "còrn anglés", "английский рожок", "αγγλικό κόρνο"),
            "clarinete en si♭": ("Klarinette in B", "clarinet en si♭", "кларнет in B", "κλαρινέτο σε σι♭"),
            "clarinete en la": ("Klarinette in A", "clarinet en la", "кларнет in A", "κλαρινέτο σε λα"),
            "clarinete en mi♭": ("Klarinette in Es", "clarinet en mi♭", "кларнет in Es", "κλαρινέτο σε μι♭"),
            "clarinete bajo": ("Bassklarinette", "clarinet bas", "бас-кларнет", "μπάσο κλαρινέτο"),
            "fagot": ("Fagott", "fagòt", "фагот", "φαγκότο"),
            "saxofón soprano": ("Sopransaxophon", "saxofòn soprano", "саксофон-сопрано", "σαξόφωνο σοπράνο"),
            "saxofón alto": ("Altsaxophon", "saxofòn alt", "саксофон-альт", "σαξόφωνο άλτο"),
            "saxofón tenor": ("Tenorsaxophon", "saxofòn tenor", "саксофон-тенор", "σαξόφωνο τενόρο"),
            "saxofón barítono": ("Baritonsaxophon", "saxofòn bariton", "саксофон-баритон", "σαξόφωνο βαρύτονο"),
            "trompeta en si♭": ("Trompete in B", "trompeta en si♭", "труба in B", "τρομπέτα σε σι♭"),
            "trompeta en do": ("Trompete in C", "trompeta en do", "труба in C", "τρομπέτα σε ντο"),
            "fliscorno": ("Flügelhorn", "flicòrn", "флюгельгорн", "φλικόρνο"),
            "trompa en fa": ("Horn in F", "còrn en fa", "валторна in F", "κόρνο σε φα"),
            "trombón": ("Posaune", "trombòn", "тромбон", "τρομπόνι"),
            "tuba": ("Tuba", "tuba", "туба", "τούμπα"),
            "violín": ("Violine", "violon", "скрипка", "βιολί"),
            "viola": ("Viola", "viòla", "альт", "βιόλα"),
            "violonchelo": ("Violoncello", "violoncèl", "виолончель", "βιολοντσέλο"),
            "contrabajo": ("Kontrabass", "contrabassa", "контрабас", "κοντραμπάσο"),
            "guitarra": ("Gitarre", "guitarra", "гитара", "κιθάρα"),
            "bajo eléctrico": ("E-Bass", "bassa electrica", "бас-гитара", "ηλεκτρικό μπάσο"),
            "xilófono": ("Xylophon", "xilofòn", "ксилофон", "ξυλόφωνο"),
            "glockenspiel": ("Glockenspiel", "glockenspiel", "колокольчики", "γκλόκενσπιλ"),
            "celesta": ("Celesta", "celèsta", "челеста", "τσελέστα"),
        ]
}
