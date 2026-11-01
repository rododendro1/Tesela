// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaRepresentaciones en inglés. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let ingles = TextosDeRepresentaciones(
        // AfinacionHistorica.swift
        temperamentoIgual: "equal temperament",
        pitagorico: "Pythagorean tuning",
        mesotonico: "quarter-comma meantone",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "just intonation",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "circle of fifths",

        // DibujoSVG.swift
        conjunto: "Set ",
        cicloDesde: { nombre, cifrado in "\(nombre) from \(cifrado)" },
        primeraClase: "first pitch class",
        primeraNota: "first note",
        leyendaNota: "note",
        leyendaClaseDeAltura: "pitch class (every copy)",
        leyendaAltura: "pitch (every key)",
        leyendaIntervalos: "fifth or third between notes",
        leyendaContorno: "outline of the shape",
        leyendaTriadaMayor: "major triad",
        leyendaTriadaMenor: "minor triad",
        leyendaPasoDelRecorrido: "step of the progression (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "root of the first chord",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "hexatonic cycle",
        cicloOctatonico: "octatonic cycle",
        cicloLR: "LR cycle",

        // ConduccionParsimoniosa.swift
        semitonos: { n in Idioma.ingles.contar(n, "semitone", "semitones") },

        // TransformacionNeorriemanniana.swift
        homonima: "parallel",
        cambioDeSensible: "leading-tone exchange",
        relativa: "relative",

        // TecladoIsomorfico.swift
        tablaArmonica: "Harmonic table",
        wickiHaydenEspejo: "Wicki-Hayden (mirrored)",
        wickiHaydenPlano: "Wicki-Hayden (flat-top)",
        acordeonC: "C-system accordion",
        acordeonB: "B-system accordion"
    )
}
