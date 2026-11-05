// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaRepresentaciones en catalán. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let catalan = TextosDeRepresentaciones(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "cercle de quintes",

        // DibujoSVG.swift
        conjunto: "Conjunt ",
        cicloDesde: { nombre, cifrado in "\(nombre) des de \(cifrado)" },
        primeraClase: "primera classe",
        primeraNota: "primera nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "classe d'altura (totes les còpies)",
        leyendaAltura: "altura (totes les tecles)",
        leyendaIntervalos: "quinta o tercera entre notes",
        leyendaContorno: "contorn de la forma",
        leyendaTriadaMayor: "tríada major",
        leyendaTriadaMenor: "tríada menor",
        leyendaPasoDelRecorrido: "pas del recorregut (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fonamental del primer acord",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "cicle hexatònic",
        cicloOctatonico: "cicle octatònic",
        cicloLR: "cicle LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in Idioma.catalan.contar(n, "semitò", "semitons") },

        // TransformacionNeorriemanniana.swift
        homonima: "homònima",
        cambioDeSensible: "canvi de sensible",
        relativa: "relativa",

        // TecladoIsomorfico.swift
        tablaArmonica: "Taula harmònica",
        wickiHaydenEspejo: "Wicki-Hayden (mirall)",
        wickiHaydenPlano: "Wicki-Hayden (pla)",
        acordeonC: "Acordió sistema C",
        acordeonB: "Acordió sistema B",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Quadrícula en quartes",
        cuadriculaEnTercerasMayores: "Quadrícula en terceres majors",
        cuadriculaEnQuintas: "Quadrícula en quintes",
        wickiHaydenCuadrado: "Wicki-Hayden (quadrícula)",
        cuadriculaDeTonosEnteros: "Quadrícula de tons sencers",
        tonnetzDeEuler: "Tonnetz d'Euler",
        cuadriculaEnTercerasMenores: "Quadrícula en terceres menors",
        cuadriculaEnTritonos: "Quadrícula en trítons",
        cuadriculaEnOctavas: "Quadrícula en octaves",
        cuadriculaSecuencial: "Quadrícula seqüencial",
        // FormatoUIL.swift
        uilNoValido: { texto in "UIL no vàlid: «\(texto)». S'espera L,G,D;R<graus>[M], per exemple 2,7,5;R30M." },
        intervalosIncoherentes: { menor, mayor, diferencia in "Intervals incoherents: \(menor),\(mayor),\(diferencia). Han de complir 0 < L ≤ D i G = L + D." },
        giroNoValido: { grados in "El gir de \(grados)° no és múltiple de 30°." },
        afinacionNoSoportada: { tonos in "Només es dibuixen teclats de 12 notes, no de \(tonos)." },
        cizallaNoSoportada: { cizalla in "La cisalla S\(cizalla) no està suportada." }
    )
}
