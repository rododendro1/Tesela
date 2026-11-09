// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// Los textos de Diagramas en francés. Los campos y lo que significa cada uno están en
// `TextosDeDiagramas.swift`.

extension TextosDeDiagramas {
    static let frances = TextosDeDiagramas(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "cercle des quintes",

        // DibujoSVG.swift
        conjunto: "Ensemble ",
        cicloDesde: "{1} depuis {2}",
        primeraClase: "première classe",
        primeraNota: "première note",
        leyendaNota: "note",
        leyendaClaseDeAltura: "classe de hauteur (toutes ses copies)",
        leyendaAltura: "hauteur (toutes ses touches)",
        leyendaIntervalos: "quinte ou tierce entre notes",
        leyendaContorno: "contour de la forme",
        leyendaTriadaMayor: "triade majeure",
        leyendaTriadaMenor: "triade mineure",
        leyendaPasoDelRecorrido: "étape du parcours (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fondamentale du premier accord",

        // TecladoIsomorfico.swift
        tablaArmonica: "Table harmonique",
        wickiHaydenEspejo: "Wicki-Hayden (miroir)",
        wickiHaydenPlano: "Wicki-Hayden (plat)",
        acordeonC: "Accordéon système C",
        acordeonB: "Accordéon système B",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Grille en quartes",
        cuadriculaEnTercerasMayores: "Grille en tierces majeures",
        cuadriculaEnQuintas: "Grille en quintes",
        wickiHaydenCuadrado: "Wicki-Hayden (grille)",
        cuadriculaDeTonosEnteros: "Grille par tons entiers",
        tonnetzDeEuler: "Tonnetz d'Euler",
        cuadriculaEnTercerasMenores: "Grille en tierces mineures",
        cuadriculaEnTritonos: "Grille en tritons",
        cuadriculaEnOctavas: "Grille en octaves",
        cuadriculaSecuencial: "Grille séquentielle",
        // FormatoUIL.swift
        uilNoValido: "UIL non valide : « {1} ». On attend L,G,D;R<degrés>[M], par exemple 2,7,5;R30M.",
        intervalosIncoherentes: "Intervalles incohérents : {1},{2},{3}. Ils doivent vérifier 0 < L ≤ D et G = L + D.",
        giroNoValido: "Une rotation de {1}° n'est pas un multiple de 30°.",
        afinacionNoSoportada: "Seuls les claviers à 12 notes se dessinent, pas à {1}.",
        cizallaNoSoportada: "Le cisaillement S{1} n'est pas pris en charge."
    )
}
