// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaRepresentaciones en gallego. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let gallego = TextosDeRepresentaciones(
        // Temperamento.swift
        temperamentoIgual: "temperamento igual",
        pitagorico: "afinación pitagórica",
        mesotonico: "mesotónico de ¼ de coma",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "afinación xusta",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "círculo de quintas",

        // DibujoSVG.swift
        conjunto: "Conxunto ",
        cicloDesde: { nombre, cifrado in "\(nombre) desde \(cifrado)" },
        primeraClase: "primeira clase",
        primeraNota: "primeira nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "clase de altura (todas as súas copias)",
        leyendaAltura: "altura (todas as súas teclas)",
        leyendaIntervalos: "quinta ou terceira entre notas",
        leyendaContorno: "contorno da forma",
        leyendaTriadaMayor: "tríade maior",
        leyendaTriadaMenor: "tríade menor",
        leyendaPasoDelRecorrido: "paso do percorrido (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fundamental do primeiro acorde",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "ciclo hexatónico",
        cicloOctatonico: "ciclo octatónico",
        cicloLR: "ciclo LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in n == 1 ? "1 semiton" : "\(n) semitons" },

        // TransformacionNeorriemanniana.swift
        homonima: "homónima",
        cambioDeSensible: "cambio de sensible",
        relativa: "relativa"
    )
}
