// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaRepresentaciones en aragonés. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let aragones = TextosDeRepresentaciones(
        // AfinacionHistorica.swift
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
        semitonos: { n in Idioma.aragones.contar(n, "semitono", "semitonos") },

        // TransformacionNeorriemanniana.swift
        homonima: "homónima",
        cambioDeSensible: "cambio de sensible",
        relativa: "relativa",

        // TecladoIsomorfico.swift
        tablaArmonica: "Tabla armónica",
        wickiHaydenEspejo: "Wicki-Hayden (espello)",
        wickiHaydenPlano: "Wicki-Hayden (plano)",
        acordeonC: "Acordeón sistema C",
        acordeonB: "Acordeón sistema B"
    )
}
