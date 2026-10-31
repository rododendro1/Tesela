// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaRepresentaciones en asturiano. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let asturiano = TextosDeRepresentaciones(
        // Temperamento.swift
        temperamentoIgual: "temperamentu igual",
        pitagorico: "afinación pitagórica",
        mesotonico: "mesotónicu de ¼ de coma",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "afinación xusta",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "círculu de quintes",

        // DibujoSVG.swift
        conjunto: "Conxuntu ",
        cicloDesde: { nombre, cifrado in "\(nombre) dende \(cifrado)" },
        primeraClase: "primer clase",
        primeraNota: "primer nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "clase d\'altura (toles sos copies)",
        leyendaAltura: "altura (toles sos tecles)",
        leyendaIntervalos: "quinta o tercera ente notes",
        leyendaContorno: "contornu de la forma",
        leyendaTriadaMayor: "tríada mayor",
        leyendaTriadaMenor: "tríada menor",
        leyendaPasoDelRecorrido: "pasu del percorríu (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fundamental del primer acorde",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "ciclu hexatónicu",
        cicloOctatonico: "ciclu octatónicu",
        cicloLR: "ciclu LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in n == 1 ? "1 semitonu" : "\(n) semitonos" },

        // TransformacionNeorriemanniana.swift
        homonima: "homónima",
        cambioDeSensible: "cambéu de sensible",
        relativa: "relativa"
    )
}
