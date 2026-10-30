// Los textos de ArmoniaRepresentaciones en inglés. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let ingles = TextosDeRepresentaciones(
        // Temperamento+Idiomas.swift
        temperamentoIgual: "equal temperament",
        pitagorico: "Pythagorean tuning",
        mesotonico: "quarter-comma meantone",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "just intonation",

        // CorrespondenciaDeColores+Idiomas.swift
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
        semitonos: { n in n == 1 ? "1 semitone" : "\(n) semitones" },

        // TransformacionNeorriemanniana+Idiomas.swift
        homonima: "parallel",
        cambioDeSensible: "leading-tone exchange",
        relativa: "relative"
    )
}
