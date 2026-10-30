// Los textos de ArmoniaRepresentaciones en aragonés. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let aragones = TextosDeRepresentaciones(
        // Temperamento.swift
        temperamentoIgual: "temperamento igual",
        pitagorico: "afinación pitagorica",
        mesotonico: "mesotonico de ¼ de coma",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "afinación chusta",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "cerclo de quintas",

        // DibujoSVG.swift
        conjunto: "Conchunto ",
        cicloDesde: { nombre, cifrado in "\(nombre) dende \(cifrado)" },
        primeraClase: "primera clase",
        primeraNota: "primera nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "clase d\'altura (todas as suyas copias)",
        leyendaAltura: "altura (todas as suyas teclas)",
        leyendaIntervalos: "quinta u tercera entre notas",
        leyendaContorno: "contorno d\'a forma",
        leyendaTriadaMayor: "tríada mayor",
        leyendaTriadaMenor: "tríada menor",
        leyendaPasoDelRecorrido: "paso d\'o recorrido (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fundamental d\'o primer acorde",

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
