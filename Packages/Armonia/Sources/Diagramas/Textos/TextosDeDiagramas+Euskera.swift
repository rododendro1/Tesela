// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Diagramas en euskera. Los campos y lo que significa cada uno están en
// `TextosDeDiagramas.swift`.

extension TextosDeDiagramas {
    static let euskera = TextosDeDiagramas(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "bosgarrenen zirkulua",

        // DibujoSVG.swift
        conjunto: "Multzoa ",
        cicloDesde: "{1} {2}-tik",
        primeraClase: "lehen klasea",
        primeraNota: "lehen nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "altuera-klasea (kopia guztiak)",
        leyendaAltura: "altuera (tekla guztiak)",
        leyendaIntervalos: "noten arteko bosgarrena edo hirugarrena",
        leyendaContorno: "formaren ingerada",
        leyendaTriadaMayor: "triade maiorra",
        leyendaTriadaMenor: "triade minorra",
        leyendaPasoDelRecorrido: "ibilbidearen urratsa (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "lehen akordearen oinarria",

        // TecladoIsomorfico.swift
        tablaArmonica: "Taula harmonikoa",
        wickiHaydenEspejo: "Wicki-Hayden (ispilua)",
        wickiHaydenPlano: "Wicki-Hayden (laua)",
        acordeonC: "C sistemako akordeoia",
        acordeonB: "B sistemako akordeoia",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Laukisarea laugarrenetan",
        cuadriculaEnTercerasMayores: "Laukisarea hirugarren handietan",
        cuadriculaEnQuintas: "Laukisarea bosgarrenetan",
        wickiHaydenCuadrado: "Wicki-Hayden (laukisarea)",
        cuadriculaDeTonosEnteros: "Tonu osoen laukisarea",
        tonnetzDeEuler: "Eulerren Tonnetz-a",
        cuadriculaEnTercerasMenores: "Laukisarea hirugarren txikietan",
        cuadriculaEnTritonos: "Laukisarea tritonoetan",
        cuadriculaEnOctavas: "Laukisarea zortziduretan",
        cuadriculaSecuencial: "Laukisare sekuentziala",
        // FormatoUIL.swift
        uilNoValido: "UIL baliogabea: «{1}». L,G,D;R<graduak>[M] espero da, adibidez 2,7,5;R30M.",
        intervalosIncoherentes: "Tarte koherentegabeak: {1},{2},{3}. 0 < L ≤ D eta G = L + D bete behar dituzte.",
        giroNoValido: "{1}°-ko biraketa ez da 30°-ren multiploa.",
        afinacionNoSoportada: "12 notako teklatuak bakarrik marrazten dira, ez {1} notakoak.",
        cizallaNoSoportada: "S{1} ebakidura ez dago onartuta."
    )
}
