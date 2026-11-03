// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaRepresentaciones en aragonés. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let aragones = TextosDeRepresentaciones(
        // AfinacionHistorica.swift
        temperamentoIgual: "temperamento igual",
        pitagorico: "afinación pitagorica",
        mesotonico: "mesotonico de ¼ de coma",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "afinación chusta",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "cerclo de quintas",

        // DibujoSVG.swift
        conjunto: "Conchunto ",
        cicloDesde: { nombre, cifrado in "\(nombre) dende \(cifrado)" },
        primeraClase: "primera clase",
        primeraNota: "primera nota",
        leyendaNota: "nota",
        leyendaClaseDeAltura: "clase d\'altura (todas as suyas copias)",
        leyendaAltura: "altura (todas as suyas teclas)",
        leyendaIntervalos: "quinta u tercera entre notas",
        leyendaContorno: "contorno d\'a forma",
        leyendaTriadaMayor: "tríada mayor",
        leyendaTriadaMenor: "tríada menor",
        leyendaPasoDelRecorrido: "paso d\'o recorrido (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "fundamental d\'o primer acorde",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "ciclo hexatónico",
        cicloOctatonico: "ciclo octatónico",
        cicloLR: "ciclo LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in Idioma.aragones.contar(n, "semitono", "semitonos") },

        // TransformacionNeorriemanniana.swift
        homonima: "homónima",
        cambioDeSensible: "cambio de sensible",
        relativa: "relativa",

        // TecladoIsomorfico.swift
        tablaArmonica: "Tabla armónica",
        wickiHaydenEspejo: "Wicki-Hayden (espello)",
        wickiHaydenPlano: "Wicki-Hayden (plano)",
        acordeonC: "Acordeón sistema C",
        acordeonB: "Acordeón sistema B",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Cuadricula en cuartas",
        cuadriculaEnTercerasMayores: "Cuadricula en terceras mayors",
        cuadriculaEnQuintas: "Cuadricula en quintas",
        wickiHaydenCuadrado: "Wicki-Hayden (cuadricula)",
        cuadriculaDeTonosEnteros: "Cuadricula de tons enteros",
        tonnetzDeEuler: "Tonnetz d'Euler",
        // FormatoUIL.swift
        uilNoValido: { texto in "UIL no valido: «\(texto)». S'aspera L,G,D;R<graus>[M], per eixemplo 2,7,5;R30M." },
        intervalosIncoherentes: { menor, mayor, diferencia in "Intervalos incoherents: \(menor),\(mayor),\(diferencia). Han de cumplir 0 < L ≤ D y G = L + D." },
        giroNoValido: { grados in "O chiro de \(grados)° no ye multiplo de 30°." },
        afinacionNoSoportada: { tonos in "Nomás se dibuixan teclaus de 12 notas, no de \(tonos)." },
        cizallaNoSoportada: { cizalla in "A cizalla S\(cizalla) no ye suportada." }
    )
}
