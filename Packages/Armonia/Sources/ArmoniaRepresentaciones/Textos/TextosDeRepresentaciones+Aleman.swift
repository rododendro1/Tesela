// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaRepresentaciones en alemán. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let aleman = TextosDeRepresentaciones(
        // AfinacionHistorica.swift
        temperamentoIgual: "gleichstufige Stimmung",
        pitagorico: "pythagoreische Stimmung",
        mesotonico: "Viertelkomma-Mitteltönigkeit",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "reine Stimmung",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "Quintenzirkel",

        // DibujoSVG.swift
        conjunto: "Menge ",
        cicloDesde: { nombre, cifrado in "\(nombre) ab \(cifrado)" },
        primeraClase: "erste Tonklasse",
        primeraNota: "erste Note",
        leyendaNota: "Note",
        leyendaClaseDeAltura: "Tonklasse (alle Kopien)",
        leyendaAltura: "Tonhöhe (alle Tasten)",
        leyendaIntervalos: "Quinte oder Terz zwischen Noten",
        leyendaContorno: "Umriss der Form",
        leyendaTriadaMayor: "Durdreiklang",
        leyendaTriadaMenor: "Molldreiklang",
        leyendaPasoDelRecorrido: "Schritt der Folge (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "Grundton des ersten Akkords",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "hexatonischer Zyklus",
        cicloOctatonico: "oktatonischer Zyklus",
        cicloLR: "LR-Zyklus",

        // ConduccionParsimoniosa.swift
        semitonos: { n in Idioma.aleman.contar(n, "Halbton", "Halbtöne") },

        // TransformacionNeorriemanniana.swift
        homonima: "Variante",
        cambioDeSensible: "Leittonwechsel",
        relativa: "Parallele",

        // TecladoIsomorfico.swift
        tablaArmonica: "Harmonische Tabelle",
        wickiHaydenEspejo: "Wicki-Hayden (gespiegelt)",
        wickiHaydenPlano: "Wicki-Hayden (flach)",
        acordeonC: "Akkordeon C-Griff",
        acordeonB: "Akkordeon B-Griff"
    )
}
