// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// Los textos de Diagramas en sueco. Los campos y lo que significa cada uno están en
// `TextosDeDiagramas.swift`.

extension TextosDeDiagramas {
    static let sueco = TextosDeDiagramas(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "kvintcirkeln",

        // DibujoSVG.swift
        conjunto: "mängd ",
        cicloDesde: "{1} från {2}",
        primeraClase: "första tonklass",
        primeraNota: "första ton",
        leyendaNota: "ton",
        leyendaClaseDeAltura: "tonklass (alla kopior)",
        leyendaAltura: "tonhöjd (alla tangenter)",
        leyendaIntervalos: "kvint eller ters mellan toner",
        leyendaContorno: "formens kontur",
        leyendaTriadaMayor: "durtreklang",
        leyendaTriadaMenor: "molltreklang",
        leyendaPasoDelRecorrido: "steg i följden (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "grundton i första ackordet",

        // TecladoIsomorfico.swift
        tablaArmonica: "harmonisk tabell",
        wickiHaydenEspejo: "Wicki-Hayden (spegelvänd)",
        wickiHaydenPlano: "Wicki-Hayden (platt)",
        acordeonC: "dragspel med C-grepp",
        acordeonB: "dragspel med B-grepp",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "kvartrutnät",
        cuadriculaEnTercerasMayores: "stortersrutnät",
        cuadriculaEnQuintas: "kvintrutnät",
        wickiHaydenCuadrado: "Wicki-Hayden (rutnät)",
        cuadriculaDeTonosEnteros: "heltonsrutnät",
        tonnetzDeEuler: "Eulers Tonnetz",
        cuadriculaEnTercerasMenores: "lilltersrutnät",
        cuadriculaEnTritonos: "tritonusrutnät",
        cuadriculaEnOctavas: "oktavrutnät",
        cuadriculaSecuencial: "sekventiellt rutnät",
        // FormatoUIL.swift
        uilNoValido: "Ogiltig UIL: ”{1}”. Väntat är L,G,D;R<grader>[M], till exempel 2,7,5;R30M.",
        intervalosIncoherentes: "Motstridiga intervall: {1},{2},{3}. Det måste gälla att 0 < L ≤ D och G = L + D.",
        giroNoValido: "En vridning på {1}° är ingen multipel av 30°.",
        afinacionNoSoportada: "Bara klaviaturer med 12 toner kan ritas, inte med {1}.",
        cizallaNoSoportada: "Skjuvningen S{1} stöds inte."
    )
}
