// Los textos de ArmoniaRepresentaciones en occitano. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let occitano = TextosDeRepresentaciones(
        // Temperamento+Idiomas.swift
        temperamentoIgual: "temperament egal",
        pitagorico: "acordatge pitagoric",
        mesotonico: "mesotonic d'¼ de coma",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "acordatge just",

        // CorrespondenciaDeColores+Idiomas.swift
        circuloDeQuintas: "cercle de quintas",

        // DibujoSVG.swift
        conjunto: "Ensems ",
        cicloDesde: { nombre, cifrado in "\(nombre) dempuèi \(cifrado)" },
        primeraClase: "primièra classa de nautor",
        primeraNota: "primièra nòta",
        leyendaNota: "nòta",
        leyendaClaseDeAltura: "classa de nautor (totas sas còpias)",
        leyendaAltura: "nautor (totas sas tòcas)",
        leyendaIntervalos: "quinta o tèrça entre nòtas",
        leyendaContorno: "contorn de la forma",
        leyendaTriadaMayor: "triada majora",
        leyendaTriadaMenor: "triada menora",
        leyendaPasoDelRecorrido: "pas del percors (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fondamentala del primièr acòrd",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "cicle exatonic",
        cicloOctatonico: "cicle octatonic",
        cicloLR: "cicle LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in n == 1 ? "1 semiton" : "\(n) semitons" },

        // TransformacionNeorriemanniana+Idiomas.swift
        homonima: "omonima",
        cambioDeSensible: "cambi de sensibla",
        relativa: "relativa"
    )
}
