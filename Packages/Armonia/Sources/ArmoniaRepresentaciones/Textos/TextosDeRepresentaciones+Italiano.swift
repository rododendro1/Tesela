// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaRepresentaciones en italiano. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let italiano = TextosDeRepresentaciones(
        // Temperamento.swift
        temperamentoIgual: "temperamento equabile",
        pitagorico: "accordatura pitagorica",
        mesotonico: "mesotonico a ¼ di comma",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "intonazione naturale",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "circolo delle quinte",

        // DibujoSVG.swift
        conjunto: "Insieme ",
        cicloDesde: { nombre, cifrado in "\(nombre) da \(cifrado)" },
        primeraClase: "prima classe",
        primeraNota: "prima nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "classe di altezza (tutte le sue copie)",
        leyendaAltura: "altezza (tutti i suoi tasti)",
        leyendaIntervalos: "quinta o terza tra note",
        leyendaContorno: "contorno della forma",
        leyendaTriadaMayor: "triade maggiore",
        leyendaTriadaMenor: "triade minore",
        leyendaPasoDelRecorrido: "passo del percorso (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fondamentale del primo accordo",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "ciclo esatonico",
        cicloOctatonico: "ciclo ottatonico",
        cicloLR: "ciclo LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in n == 1 ? "1 semitono" : "\(n) semitoni" },

        // TransformacionNeorriemanniana.swift
        homonima: "omonima",
        cambioDeSensible: "scambio della sensibile",
        relativa: "relativa"
    )
}
