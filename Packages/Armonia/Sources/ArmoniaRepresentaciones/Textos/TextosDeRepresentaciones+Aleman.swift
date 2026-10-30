// Los textos de ArmoniaRepresentaciones en alemán. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let aleman = TextosDeRepresentaciones(
        // Temperamento.swift
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
        semitonos: { n in n == 1 ? "1 Halbton" : "\(n) Halbtöne" },

        // TransformacionNeorriemanniana.swift
        homonima: "Variante",
        cambioDeSensible: "Leittonwechsel",
        relativa: "Parallele"
    )
}
