// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// Los textos de Diagramas en alemán. Los campos y lo que significa cada uno están en
// `TextosDeDiagramas.swift`.

extension TextosDeDiagramas {
    static let aleman = TextosDeDiagramas(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "Quintenzirkel",

        // DibujoSVG.swift
        conjunto: "Menge ",
        cicloDesde: "{1} ab {2}",
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

        // TecladoIsomorfico.swift
        tablaArmonica: "Harmonische Tabelle",
        wickiHaydenEspejo: "Wicki-Hayden (gespiegelt)",
        wickiHaydenPlano: "Wicki-Hayden (flach)",
        acordeonC: "Akkordeon C-Griff",
        acordeonB: "Akkordeon B-Griff",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Quartenraster",
        cuadriculaEnTercerasMayores: "Großterzraster",
        cuadriculaEnQuintas: "Quintenraster",
        wickiHaydenCuadrado: "Wicki-Hayden (Raster)",
        cuadriculaDeTonosEnteros: "Ganztonraster",
        tonnetzDeEuler: "Eulers Tonnetz",
        cuadriculaEnTercerasMenores: "Kleinterzraster",
        cuadriculaEnTritonos: "Tritonusraster",
        cuadriculaEnOctavas: "Oktavraster",
        cuadriculaSecuencial: "Sequenzielles Raster",
        // FormatoUIL.swift
        uilNoValido: "Ungültiges UIL: „{1}“. Erwartet wird L,G,D;R<Grad>[M], zum Beispiel 2,7,5;R30M.",
        intervalosIncoherentes: "Widersprüchliche Intervalle: {1},{2},{3}. Es muss 0 < L ≤ D und G = L + D gelten.",
        giroNoValido: "Eine Drehung um {1}° ist kein Vielfaches von 30°.",
        afinacionNoSoportada: "Es lassen sich nur Tastaturen mit 12 Tönen zeichnen, nicht mit {1}.",
        cizallaNoSoportada: "Die Scherung S{1} wird nicht unterstützt."
    )
}
