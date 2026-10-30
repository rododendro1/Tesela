// Los textos de ArmoniaRepresentaciones en español. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let espanol = TextosDeRepresentaciones(
        // Temperamento.swift
        temperamentoIgual: "temperamento igual",
        pitagorico: "afinación pitagórica",
        mesotonico: "mesotónico de ¼ de coma",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "afinación justa",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "círculo de quintas",

        // DibujoSVG.swift
        conjunto: "Conjunto ",
        cicloDesde: { nombre, cifrado in "\(nombre) desde \(cifrado)" },
        primeraClase: "primera clase",
        primeraNota: "primera nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "clase de altura (todas sus copias)",
        leyendaAltura: "altura (todas sus teclas)",
        leyendaIntervalos: "quinta o tercera entre notas",
        leyendaContorno: "contorno de la forma",
        leyendaTriadaMayor: "tríada mayor",
        leyendaTriadaMenor: "tríada menor",
        leyendaPasoDelRecorrido: "paso del recorrido (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fundamental del primer acorde",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "ciclo hexatónico",
        cicloOctatonico: "ciclo octatónico",
        cicloLR: "ciclo LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in n == 1 ? "1 semitono" : "\(n) semitonos" },

        // TransformacionNeorriemanniana.swift
        homonima: "homónima",
        cambioDeSensible: "cambio de sensible",
        relativa: "relativa"
    )
}
