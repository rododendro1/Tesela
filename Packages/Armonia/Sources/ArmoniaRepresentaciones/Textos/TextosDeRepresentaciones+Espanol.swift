// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaRepresentaciones en español. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let espanol = TextosDeRepresentaciones(
        // AfinacionHistorica.swift
        temperamentoIgual: "temperamento igual",
        pitagorico: "afinación pitagórica",
        mesotonico: "mesotónico de ¼ de coma",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "afinación justa",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "círculo de quintas",

        // DibujoSVG.swift
        conjunto: "Conjunto ",
        cicloDesde: { nombre, cifrado in "\(nombre) desde \(cifrado)" },
        primeraClase: "primera clase",
        primeraNota: "primera nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "clase de altura (todas sus copias)",
        leyendaAltura: "altura (todas sus teclas)",
        leyendaIntervalos: "quinta o tercera entre notas",
        leyendaContorno: "contorno de la forma",
        leyendaTriadaMayor: "tríada mayor",
        leyendaTriadaMenor: "tríada menor",
        leyendaPasoDelRecorrido: "paso del recorrido (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fundamental del primer acorde",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "ciclo hexatónico",
        cicloOctatonico: "ciclo octatónico",
        cicloLR: "ciclo LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in Idioma.espanol.contar(n, "semitono", "semitonos") },

        // TransformacionNeorriemanniana.swift
        homonima: "homónima",
        cambioDeSensible: "cambio de sensible",
        relativa: "relativa",

        // TecladoIsomorfico.swift
        tablaArmonica: "Tabla armónica",
        wickiHaydenEspejo: "Wicki-Hayden (espejo)",
        wickiHaydenPlano: "Wicki-Hayden (plano)",
        acordeonC: "Acordeón C",
        acordeonB: "Acordeón B",
        // FormatoUIL.swift
        uilNoValido: { texto in "UIL no válido: «\(texto)». Se espera L,G,D;R<grados>[M], por ejemplo 2,7,5;R30M." },
        intervalosIncoherentes: { menor, mayor, diferencia in "Intervalos incoherentes: \(menor),\(mayor),\(diferencia). Deben cumplir 0 < L ≤ D y G = L + D." },
        giroNoValido: { grados in "El giro de \(grados)° no es múltiplo de 30°." },
        afinacionNoSoportada: { tonos in "Solo se dibujan teclados de 12 notas, no de \(tonos)." },
        cizallaNoSoportada: { cizalla in "La cizalla S\(cizalla) no está soportada." }
    )
}
