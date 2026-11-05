// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaRepresentaciones en inglés. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let ingles = TextosDeRepresentaciones(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "circle of fifths",

        // DibujoSVG.swift
        conjunto: "Set ",
        cicloDesde: { nombre, cifrado in "\(nombre) from \(cifrado)" },
        primeraClase: "first pitch class",
        primeraNota: "first note",
        leyendaNota: "note",
        leyendaClaseDeAltura: "pitch class (every copy)",
        leyendaAltura: "pitch (every key)",
        leyendaIntervalos: "fifth or third between notes",
        leyendaContorno: "outline of the shape",
        leyendaTriadaMayor: "major triad",
        leyendaTriadaMenor: "minor triad",
        leyendaPasoDelRecorrido: "step of the progression (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "root of the first chord",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "hexatonic cycle",
        cicloOctatonico: "octatonic cycle",
        cicloLR: "LR cycle",

        // ConduccionParsimoniosa.swift
        semitonos: { n in Idioma.ingles.contar(n, "semitone", "semitones") },

        // TransformacionNeorriemanniana.swift
        homonima: "parallel",
        cambioDeSensible: "leading-tone exchange",
        relativa: "relative",

        // TecladoIsomorfico.swift
        tablaArmonica: "Harmonic table",
        wickiHaydenEspejo: "Wicki-Hayden (mirrored)",
        wickiHaydenPlano: "Wicki-Hayden (flat-top)",
        acordeonC: "C-system accordion",
        acordeonB: "B-system accordion",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Grid in fourths",
        cuadriculaEnTercerasMayores: "Grid in major thirds",
        cuadriculaEnQuintas: "Grid in fifths",
        wickiHaydenCuadrado: "Wicki-Hayden (grid)",
        cuadriculaDeTonosEnteros: "Whole-tone grid",
        tonnetzDeEuler: "Euler's Tonnetz",
        cuadriculaEnTercerasMenores: "Grid in minor thirds",
        cuadriculaEnTritonos: "Grid in tritones",
        cuadriculaEnOctavas: "Grid in octaves",
        cuadriculaSecuencial: "Sequential grid",
        // FormatoUIL.swift
        uilNoValido: { texto in "Invalid UIL: \"\(texto)\". Expected L,G,D;R<degrees>[M], for example 2,7,5;R30M." },
        intervalosIncoherentes: { menor, mayor, diferencia in "Inconsistent intervals: \(menor),\(mayor),\(diferencia). They must satisfy 0 < L ≤ D and G = L + D." },
        giroNoValido: { grados in "A rotation of \(grados)° is not a multiple of 30°." },
        afinacionNoSoportada: { tonos in "Only 12-note keyboards can be drawn, not \(tonos)-note ones." },
        cizallaNoSoportada: { cizalla in "Shear S\(cizalla) is not supported." }
    )
}
