// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// Los textos de Diagramas en portugués. Los campos y lo que significa cada uno están en
// `TextosDeDiagramas.swift`.

extension TextosDeDiagramas {
    static let portugues = TextosDeDiagramas(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "círculo das quintas",

        // DibujoSVG.swift
        conjunto: "Conjunto ",
        cicloDesde: "{1} a partir de {2}",
        primeraClase: "primeira classe",
        primeraNota: "primeira nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "classe de altura (todas as cópias)",
        leyendaAltura: "altura (todas as teclas)",
        leyendaIntervalos: "quinta ou terceira entre notas",
        leyendaContorno: "contorno da forma",
        leyendaTriadaMayor: "tríade maior",
        leyendaTriadaMenor: "tríade menor",
        leyendaPasoDelRecorrido: "passo do percurso (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fundamental do primeiro acorde",

        // TecladoIsomorfico.swift
        tablaArmonica: "Tabela harmónica",
        wickiHaydenEspejo: "Wicki-Hayden (espelho)",
        wickiHaydenPlano: "Wicki-Hayden (plano)",
        acordeonC: "Acordeão sistema C",
        acordeonB: "Acordeão sistema B",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Grelha em quartas",
        cuadriculaEnTercerasMayores: "Grelha em terceiras maiores",
        cuadriculaEnQuintas: "Grelha em quintas",
        wickiHaydenCuadrado: "Wicki-Hayden (grelha)",
        cuadriculaDeTonosEnteros: "Grelha de tons inteiros",
        tonnetzDeEuler: "Tonnetz de Euler",
        cuadriculaEnTercerasMenores: "Grelha em terceiras menores",
        cuadriculaEnTritonos: "Grelha em trítonos",
        cuadriculaEnOctavas: "Grelha em oitavas",
        cuadriculaSecuencial: "Grelha sequencial",
        // FormatoUIL.swift
        uilNoValido: "UIL inválido: «{1}». Espera-se L,G,D;R<graus>[M], por exemplo 2,7,5;R30M.",
        intervalosIncoherentes: "Intervalos incoerentes: {1},{2},{3}. Devem cumprir 0 < L ≤ D e G = L + D.",
        giroNoValido: "A rotação de {1}° não é múltipla de 30°.",
        afinacionNoSoportada: "Só se desenham teclados de 12 notas, não de {1}.",
        cizallaNoSoportada: "O cisalhamento S{1} não é suportado."
    )
}
