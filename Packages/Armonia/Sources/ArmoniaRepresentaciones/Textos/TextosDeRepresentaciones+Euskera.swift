// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaRepresentaciones en euskera. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let euskera = TextosDeRepresentaciones(
        // Temperamento.swift
        temperamentoIgual: "tenperamentu berdina",
        pitagorico: "afinazio pitagorikoa",
        mesotonico: "¼ komako mesotonikoa",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "afinazio justua",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "bosgarrenen zirkulua",

        // DibujoSVG.swift
        conjunto: "Multzoa ",
        cicloDesde: { nombre, cifrado in "\(nombre) \(cifrado)-tik" },
        primeraClase: "lehen klasea",
        primeraNota: "lehen nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "altuera-klasea (kopia guztiak)",
        leyendaAltura: "altuera (tekla guztiak)",
        leyendaIntervalos: "noten arteko bosgarrena edo hirugarrena",
        leyendaContorno: "formaren ingerada",
        leyendaTriadaMayor: "triade maiorra",
        leyendaTriadaMenor: "triade minorra",
        leyendaPasoDelRecorrido: "ibilbidearen urratsa (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "lehen akordearen oinarria",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "ziklo hexatonikoa",
        cicloOctatonico: "ziklo oktatonikoa",
        cicloLR: "LR zikloa",

        // ConduccionParsimoniosa.swift
        semitonos: { n in "\(n) tonuerdi" },

        // TransformacionNeorriemanniana.swift
        homonima: "homonimoa",
        cambioDeSensible: "sentsiblearen aldaketa",
        relativa: "erlatiboa",

        // TecladoIsomorfico.swift
        tablaArmonica: "Taula harmonikoa",
        wickiHaydenEspejo: "Wicki-Hayden (ispilua)",
        wickiHaydenPlano: "Wicki-Hayden (laua)",
        acordeonC: "C sistemako akordeoia",
        acordeonB: "B sistemako akordeoia"
    )
}
