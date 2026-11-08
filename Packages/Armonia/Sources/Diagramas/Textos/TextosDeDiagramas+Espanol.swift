// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// Los textos de Diagramas en español. Los campos y lo que significa cada uno están en
// `TextosDeDiagramas.swift`.

extension TextosDeDiagramas {
    static let espanol = TextosDeDiagramas(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "círculo de quintas",

        // DibujoSVG.swift
        conjunto: "Conjunto ",
        cicloDesde: "{1} desde {2}",
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

        // TecladoIsomorfico.swift
        tablaArmonica: "Tabla armónica",
        wickiHaydenEspejo: "Wicki-Hayden (espejo)",
        wickiHaydenPlano: "Wicki-Hayden (plano)",
        acordeonC: "Acordeón C",
        acordeonB: "Acordeón B",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Cuadrícula en cuartas",
        cuadriculaEnTercerasMayores: "Cuadrícula en terceras mayores",
        cuadriculaEnQuintas: "Cuadrícula en quintas",
        wickiHaydenCuadrado: "Wicki-Hayden (cuadrícula)",
        cuadriculaDeTonosEnteros: "Cuadrícula de tonos enteros",
        tonnetzDeEuler: "Tonnetz de Euler",
        cuadriculaEnTercerasMenores: "Cuadrícula en terceras menores",
        cuadriculaEnTritonos: "Cuadrícula en tritonos",
        cuadriculaEnOctavas: "Cuadrícula en octavas",
        cuadriculaSecuencial: "Cuadrícula secuencial",
        // FormatoUIL.swift
        uilNoValido: "UIL no válido: «{1}». Se espera L,G,D;R<grados>[M], por ejemplo 2,7,5;R30M.",
        intervalosIncoherentes: "Intervalos incoherentes: {1},{2},{3}. Deben cumplir 0 < L ≤ D y G = L + D.",
        giroNoValido: "El giro de {1}° no es múltiplo de 30°.",
        afinacionNoSoportada: "Solo se dibujan teclados de 12 notas, no de {1}.",
        cizallaNoSoportada: "La cizalla S{1} no está soportada."
    )
}
