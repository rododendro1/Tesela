// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// Los textos de Diagramas en asturiano. Los campos y lo que significa cada uno están en
// `TextosDeDiagramas.swift`.

extension TextosDeDiagramas {
    static let asturiano = TextosDeDiagramas(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "círculu de quintes",

        // DibujoSVG.swift
        conjunto: "Conxuntu ",
        cicloDesde: { nombre, cifrado in "\(nombre) dende \(cifrado)" },
        primeraClase: "primer clase",
        primeraNota: "primer nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "clase d\'altura (toles sos copies)",
        leyendaAltura: "altura (toles sos tecles)",
        leyendaIntervalos: "quinta o tercera ente notes",
        leyendaContorno: "contornu de la forma",
        leyendaTriadaMayor: "tríada mayor",
        leyendaTriadaMenor: "tríada menor",
        leyendaPasoDelRecorrido: "pasu del percorríu (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fundamental del primer acorde",

        // TecladoIsomorfico.swift
        tablaArmonica: "Tabla armónica",
        wickiHaydenEspejo: "Wicki-Hayden (espeyu)",
        wickiHaydenPlano: "Wicki-Hayden (planu)",
        acordeonC: "Acordeón sistema C",
        acordeonB: "Acordeón sistema B",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Cuadrícula en cuartes",
        cuadriculaEnTercerasMayores: "Cuadrícula en terceres mayores",
        cuadriculaEnQuintas: "Cuadrícula en quintes",
        wickiHaydenCuadrado: "Wicki-Hayden (cuadrícula)",
        cuadriculaDeTonosEnteros: "Cuadrícula de tonos enteros",
        tonnetzDeEuler: "Tonnetz d'Euler",
        cuadriculaEnTercerasMenores: "Cuadrícula en terceres menores",
        cuadriculaEnTritonos: "Cuadrícula en trítonos",
        cuadriculaEnOctavas: "Cuadrícula en octaves",
        cuadriculaSecuencial: "Cuadrícula secuencial",
        // FormatoUIL.swift
        uilNoValido: { texto in "UIL non válidu: «\(texto)». Espérase L,G,D;R<graos>[M], por exemplu 2,7,5;R30M." },
        intervalosIncoherentes: { menor, mayor, diferencia in "Intervalos incoherentes: \(menor),\(mayor),\(diferencia). Tienen de cumplir 0 < L ≤ D y G = L + D." },
        giroNoValido: { grados in "El xiru de \(grados)° nun ye múltiplu de 30°." },
        afinacionNoSoportada: { tonos in "Namás se dibuxen teclaos de 12 notes, non de \(tonos)." },
        cizallaNoSoportada: { cizalla in "La cizalla S\(cizalla) nun ta soportada." }
    )
}
