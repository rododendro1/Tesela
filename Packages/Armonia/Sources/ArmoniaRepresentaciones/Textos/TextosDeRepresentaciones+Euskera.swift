// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaRepresentaciones en euskera. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let euskera = TextosDeRepresentaciones(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "bosgarrenen zirkulua",

        // DibujoSVG.swift
        conjunto: "Multzoa ",
        cicloDesde: { nombre, cifrado in "\(nombre) \(cifrado)-tik" },
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

        // CicloNeorriemanniano.swift
        cicloHexatonico: "ziklo hexatonikoa",
        cicloOctatonico: "ziklo oktatonikoa",
        cicloLR: "LR zikloa",

        // ConduccionParsimoniosa.swift
        semitonos: { n in "\(n) tonuerdi" },

        // TransformacionNeorriemanniana.swift
        homonima: "homonimoa",
        cambioDeSensible: "sentsiblearen aldaketa",
        relativa: "erlatiboa",

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
        uilNoValido: { texto in "UIL baliogabea: «\(texto)». L,G,D;R<graduak>[M] espero da, adibidez 2,7,5;R30M." },
        intervalosIncoherentes: { menor, mayor, diferencia in "Tarte koherentegabeak: \(menor),\(mayor),\(diferencia). 0 < L ≤ D eta G = L + D bete behar dituzte." },
        giroNoValido: { grados in "\(grados)°-ko biraketa ez da 30°-ren multiploa." },
        afinacionNoSoportada: { tonos in "12 notako teklatuak bakarrik marrazten dira, ez \(tonos) notakoak." },
        cizallaNoSoportada: { cizalla in "S\(cizalla) ebakidura ez dago onartuta." }
    )
}
