// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaRepresentaciones en húngaro. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let hungaro = TextosDeRepresentaciones(
        // AfinacionHistorica.swift
        temperamentoIgual: "kiegyenlített temperálás",
        pitagorico: "püthagoraszi hangolás",
        mesotonico: "negyedkommás középhangos hangolás",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "tiszta hangolás",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "kvintkör",

        // DibujoSVG.swift
        conjunto: "Halmaz ",
        cicloDesde: { nombre, cifrado in "\(nombre), kezdete: \(cifrado)" },
        primeraClase: "első hangosztály",
        primeraNota: "első hang",
        leyendaNota: "hang",
        leyendaClaseDeAltura: "hangosztály (minden példánya)",
        leyendaAltura: "hangmagasság (minden billentyű)",
        leyendaIntervalos: "kvint vagy terc a hangok között",
        leyendaContorno: "az alakzat körvonala",
        leyendaTriadaMayor: "dúr hármashangzat",
        leyendaTriadaMenor: "moll hármashangzat",
        leyendaPasoDelRecorrido: "a menet lépése (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "az első akkord alaphangja",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "hexatonikus ciklus",
        cicloOctatonico: "oktatonikus ciklus",
        cicloLR: "LR-ciklus",

        // ConduccionParsimoniosa.swift
        semitonos: { n in Idioma.hungaro.contar(n, "félhang") },

        // TransformacionNeorriemanniana.swift
        homonima: "azonos alaphangú",
        cambioDeSensible: "vezetőhangcsere",
        relativa: "párhuzamos",

        // TecladoIsomorfico.swift
        tablaArmonica: "Harmonikus tábla",
        wickiHaydenEspejo: "Wicki–Hayden (tükrözött)",
        wickiHaydenPlano: "Wicki–Hayden (lapos tetejű)",
        acordeonC: "C-rendszerű harmonika",
        acordeonB: "B-rendszerű harmonika"
    )
}
