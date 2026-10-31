// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaRepresentaciones en francés. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let frances = TextosDeRepresentaciones(
        // Temperamento.swift
        temperamentoIgual: "tempérament égal",
        pitagorico: "accord pythagoricien",
        mesotonico: "mésotonique au quart de comma",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "intonation juste",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "cycle des quintes",

        // DibujoSVG.swift
        conjunto: "Ensemble ",
        cicloDesde: { nombre, cifrado in "\(nombre) depuis \(cifrado)" },
        primeraClase: "première classe",
        primeraNota: "première note",
        leyendaNota: "note",
        leyendaClaseDeAltura: "classe de hauteur (toutes ses copies)",
        leyendaAltura: "hauteur (toutes ses touches)",
        leyendaIntervalos: "quinte ou tierce entre notes",
        leyendaContorno: "contour de la forme",
        leyendaTriadaMayor: "triade majeure",
        leyendaTriadaMenor: "triade mineure",
        leyendaPasoDelRecorrido: "étape du parcours (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fondamentale du premier accord",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "cycle hexatonique",
        cicloOctatonico: "cycle octatonique",
        cicloLR: "cycle LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in n == 1 ? "1 demi-ton" : "\(n) demi-tons" },

        // TransformacionNeorriemanniana.swift
        homonima: "homonyme",
        cambioDeSensible: "échange de sensible",
        relativa: "relative"
    )
}
