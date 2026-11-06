// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaElementos
// Los textos de ArmoniaDiagramas en occitano. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let occitano = TextosDeRepresentaciones(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "cercle de quintas",

        // DibujoSVG.swift
        conjunto: "Ensems ",
        cicloDesde: { nombre, cifrado in "\(nombre) dempuèi \(cifrado)" },
        primeraClase: "primièra classa de nautor",
        primeraNota: "primièra nòta",
        leyendaNota: "nòta",
        leyendaClaseDeAltura: "classa de nautor (totas sas còpias)",
        leyendaAltura: "nautor (totas sas tòcas)",
        leyendaIntervalos: "quinta o tèrça entre nòtas",
        leyendaContorno: "contorn de la forma",
        leyendaTriadaMayor: "triada majora",
        leyendaTriadaMenor: "triada menora",
        leyendaPasoDelRecorrido: "pas del percors (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fondamentala del primièr acòrd",

        // TecladoIsomorfico.swift
        tablaArmonica: "Taula armonica",
        wickiHaydenEspejo: "Wicki-Hayden (miralh)",
        wickiHaydenPlano: "Wicki-Hayden (plan)",
        acordeonC: "Acordeon sistèma C",
        acordeonB: "Acordeon sistèma B",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Quadrilha en quartas",
        cuadriculaEnTercerasMayores: "Quadrilha en tèrças majoras",
        cuadriculaEnQuintas: "Quadrilha en quintas",
        wickiHaydenCuadrado: "Wicki-Hayden (quadrilha)",
        cuadriculaDeTonosEnteros: "Quadrilha de tons entièrs",
        tonnetzDeEuler: "Tonnetz d'Euler",
        cuadriculaEnTercerasMenores: "Quadrilha en tèrças menoras",
        cuadriculaEnTritonos: "Quadrilha en tritons",
        cuadriculaEnOctavas: "Quadrilha en octavas",
        cuadriculaSecuencial: "Quadrilha sequenciala",
        // FormatoUIL.swift
        uilNoValido: { texto in "UIL pas valid : «\(texto)». S'espèra L,G,D;R<grases>[M], per exemple 2,7,5;R30M." },
        intervalosIncoherentes: { menor, mayor, diferencia in "Intervals incoerents : \(menor),\(mayor),\(diferencia). Devon complir 0 < L ≤ D e G = L + D." },
        giroNoValido: { grados in "Lo virament de \(grados)° es pas multiple de 30°." },
        afinacionNoSoportada: { tonos in "Se dessenhan pas que de clavièrs de 12 nòtas, pas de \(tonos)." },
        cizallaNoSoportada: { cizalla in "Lo cisalhament S\(cizalla) es pas pres en carga." }
    )
}
