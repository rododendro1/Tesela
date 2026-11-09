// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// Los textos de Diagramas en catalán. Los campos y lo que significa cada uno están en
// `TextosDeDiagramas.swift`.

extension TextosDeDiagramas {
    static let catalan = TextosDeDiagramas(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "cercle de cinquenes",

        // DibujoSVG.swift
        conjunto: "Conjunt ",
        cicloDesde: "{1} des de {2}",
        primeraClase: "primera classe",
        primeraNota: "primera nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "classe d'altura (totes les còpies)",
        leyendaAltura: "altura (totes les tecles)",
        leyendaIntervalos: "cinquena o tercera entre notes",
        leyendaContorno: "contorn de la forma",
        leyendaTriadaMayor: "tríada major",
        leyendaTriadaMenor: "tríada menor",
        leyendaPasoDelRecorrido: "pas del recorregut (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fonamental del primer acord",

        // TecladoIsomorfico.swift
        tablaArmonica: "Taula harmònica",
        wickiHaydenEspejo: "Wicki-Hayden (mirall)",
        wickiHaydenPlano: "Wicki-Hayden (pla)",
        acordeonC: "Acordió sistema C",
        acordeonB: "Acordió sistema B",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Quadrícula en quartes",
        cuadriculaEnTercerasMayores: "Quadrícula en terceres majors",
        cuadriculaEnQuintas: "Quadrícula en cinquenes",
        wickiHaydenCuadrado: "Wicki-Hayden (quadrícula)",
        cuadriculaDeTonosEnteros: "Quadrícula de tons sencers",
        tonnetzDeEuler: "Tonnetz d'Euler",
        cuadriculaEnTercerasMenores: "Quadrícula en terceres menors",
        cuadriculaEnTritonos: "Quadrícula en trítons",
        cuadriculaEnOctavas: "Quadrícula en octaves",
        cuadriculaSecuencial: "Quadrícula seqüencial",
        // FormatoUIL.swift
        uilNoValido: "UIL no vàlid: «{1}». S'espera L,G,D;R<graus>[M], per exemple 2,7,5;R30M.",
        intervalosIncoherentes: "Intervals incoherents: {1},{2},{3}. Han de complir 0 < L ≤ D i G = L + D.",
        giroNoValido: "El gir de {1}° no és múltiple de 30°.",
        afinacionNoSoportada: "Només es dibuixen teclats de 12 notes, no de {1}.",
        cizallaNoSoportada: "La cisalla S{1} no està suportada."
    )
}
