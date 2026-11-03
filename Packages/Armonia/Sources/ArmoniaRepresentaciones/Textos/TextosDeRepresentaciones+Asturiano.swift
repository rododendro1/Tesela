// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaRepresentaciones en asturiano. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let asturiano = TextosDeRepresentaciones(
        // AfinacionHistorica.swift
        temperamentoIgual: "temperamentu igual",
        pitagorico: "afinación pitagórica",
        mesotonico: "mesotónicu de ¼ de coma",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "afinación xusta",

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

        // CicloNeorriemanniano.swift
        cicloHexatonico: "ciclu hexatónicu",
        cicloOctatonico: "ciclu octatónicu",
        cicloLR: "ciclu LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in Idioma.asturiano.contar(n, "semitonu", "semitonos") },

        // TransformacionNeorriemanniana.swift
        homonima: "homónima",
        cambioDeSensible: "cambéu de sensible",
        relativa: "relativa",

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
        // FormatoUIL.swift
        uilNoValido: { texto in "UIL non válidu: «\(texto)». Espérase L,G,D;R<graos>[M], por exemplu 2,7,5;R30M." },
        intervalosIncoherentes: { menor, mayor, diferencia in "Intervalos incoherentes: \(menor),\(mayor),\(diferencia). Tienen de cumplir 0 < L ≤ D y G = L + D." },
        giroNoValido: { grados in "El xiru de \(grados)° nun ye múltiplu de 30°." },
        afinacionNoSoportada: { tonos in "Namás se dibuxen teclaos de 12 notes, non de \(tonos)." },
        cizallaNoSoportada: { cizalla in "La cizalla S\(cizalla) nun ta soportada." }
    )
}
