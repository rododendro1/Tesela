// Los textos de ArmoniaRepresentaciones en portugués. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let portugues = TextosDeRepresentaciones(
        // Temperamento.swift
        temperamentoIgual: "temperamento igual",
        pitagorico: "afinação pitagórica",
        mesotonico: "mesotónico de ¼ de coma",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "afinação justa",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "círculo das quintas",

        // DibujoSVG.swift
        conjunto: "Conjunto ",
        cicloDesde: { nombre, cifrado in "\(nombre) a partir de \(cifrado)" },
        primeraClase: "primeira classe",
        primeraNota: "primeira nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "classe de altura (todas as cópias)",
        leyendaAltura: "altura (todas as teclas)",
        leyendaIntervalos: "quinta ou terceira entre notas",
        leyendaContorno: "contorno da forma",
        leyendaTriadaMayor: "tríade maior",
        leyendaTriadaMenor: "tríade menor",
        leyendaPasoDelRecorrido: "passo do percurso (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fundamental do primeiro acorde",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "ciclo hexatónico",
        cicloOctatonico: "ciclo octatónico",
        cicloLR: "ciclo LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in n == 1 ? "1 meio-tom" : "\(n) meios-tons" },

        // TransformacionNeorriemanniana.swift
        homonima: "homónima",
        cambioDeSensible: "troca de sensível",
        relativa: "relativa"
    )
}
