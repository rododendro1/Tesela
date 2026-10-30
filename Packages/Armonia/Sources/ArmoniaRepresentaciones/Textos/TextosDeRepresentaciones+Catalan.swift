// Los textos de ArmoniaRepresentaciones en catalán. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let catalan = TextosDeRepresentaciones(
        // Temperamento.swift
        temperamentoIgual: "temperament igual",
        pitagorico: "afinació pitagòrica",
        mesotonico: "mesotònic d'¼ de coma",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "afinació justa",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "cercle de quintes",

        // DibujoSVG.swift
        conjunto: "Conjunt ",
        cicloDesde: { nombre, cifrado in "\(nombre) des de \(cifrado)" },
        primeraClase: "primera classe",
        primeraNota: "primera nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "classe d'altura (totes les còpies)",
        leyendaAltura: "altura (totes les tecles)",
        leyendaIntervalos: "quinta o tercera entre notes",
        leyendaContorno: "contorn de la forma",
        leyendaTriadaMayor: "tríada major",
        leyendaTriadaMenor: "tríada menor",
        leyendaPasoDelRecorrido: "pas del recorregut (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fonamental del primer acord",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "cicle hexatònic",
        cicloOctatonico: "cicle octatònic",
        cicloLR: "cicle LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in n == 1 ? "1 semitò" : "\(n) semitons" },

        // TransformacionNeorriemanniana.swift
        homonima: "homònima",
        cambioDeSensible: "canvi de sensible",
        relativa: "relativa"
    )
}
