// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// Los textos de Diagramas en gallego. Los campos y lo que significa cada uno están en
// `TextosDeDiagramas.swift`.

extension TextosDeDiagramas {
    static let gallego = TextosDeDiagramas(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "círculo de quintas",

        // DibujoSVG.swift
        conjunto: "Conxunto ",
        cicloDesde: "{1} desde {2}",
        primeraClase: "primeira clase",
        primeraNota: "primeira nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "clase de altura (todas as súas copias)",
        leyendaAltura: "altura (todas as súas teclas)",
        leyendaIntervalos: "quinta ou terceira entre notas",
        leyendaContorno: "contorno da forma",
        leyendaTriadaMayor: "tríade maior",
        leyendaTriadaMenor: "tríade menor",
        leyendaPasoDelRecorrido: "paso do percorrido (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fundamental do primeiro acorde",

        // TecladoIsomorfico.swift
        tablaArmonica: "Táboa harmónica",
        wickiHaydenEspejo: "Wicki-Hayden (espello)",
        wickiHaydenPlano: "Wicki-Hayden (plano)",
        acordeonC: "Acordeón sistema C",
        acordeonB: "Acordeón sistema B",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Cuadrícula en cuartas",
        cuadriculaEnTercerasMayores: "Cuadrícula en terceiras maiores",
        cuadriculaEnQuintas: "Cuadrícula en quintas",
        wickiHaydenCuadrado: "Wicki-Hayden (cuadrícula)",
        cuadriculaDeTonosEnteros: "Cuadrícula de tons enteiros",
        tonnetzDeEuler: "Tonnetz de Euler",
        cuadriculaEnTercerasMenores: "Cuadrícula en terceiras menores",
        cuadriculaEnTritonos: "Cuadrícula en trítonos",
        cuadriculaEnOctavas: "Cuadrícula en oitavas",
        cuadriculaSecuencial: "Cuadrícula secuencial",
        // FormatoUIL.swift
        uilNoValido: "UIL non válido: «{1}». Espérase L,G,D;R<graos>[M], por exemplo 2,7,5;R30M.",
        intervalosIncoherentes: "Intervalos incoherentes: {1},{2},{3}. Deben cumprir 0 < L ≤ D e G = L + D.",
        giroNoValido: "O xiro de {1}° non é múltiplo de 30°.",
        afinacionNoSoportada: "Só se debuxan teclados de 12 notas, non de {1}.",
        cizallaNoSoportada: "A cizalla S{1} non está soportada."
    )
}
