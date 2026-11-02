// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaRepresentaciones en alemán. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let aleman = TextosDeRepresentaciones(
        // AfinacionHistorica.swift
        temperamentoIgual: "gleichstufige Stimmung",
        pitagorico: "pythagoreische Stimmung",
        mesotonico: "Viertelkomma-Mitteltönigkeit",
        werckmeisterIII: "Werckmeister III",
        kirnbergerIII: "Kirnberger III",
        vallotti: "Vallotti",
        young: "Young",
        afinacionJusta: "reine Stimmung",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "Quintenzirkel",

        // DibujoSVG.swift
        conjunto: "Menge ",
        cicloDesde: { nombre, cifrado in "\(nombre) ab \(cifrado)" },
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

        // CicloNeorriemanniano.swift
        cicloHexatonico: "hexatonischer Zyklus",
        cicloOctatonico: "oktatonischer Zyklus",
        cicloLR: "LR-Zyklus",

        // ConduccionParsimoniosa.swift
        semitonos: { n in Idioma.aleman.contar(n, "Halbton", "Halbtöne") },

        // TransformacionNeorriemanniana.swift
        homonima: "Variante",
        cambioDeSensible: "Leittonwechsel",
        relativa: "Parallele",

        // TecladoIsomorfico.swift
        tablaArmonica: "Harmonische Tabelle",
        wickiHaydenEspejo: "Wicki-Hayden (gespiegelt)",
        wickiHaydenPlano: "Wicki-Hayden (flach)",
        acordeonC: "Akkordeon C-Griff",
        acordeonB: "Akkordeon B-Griff",
        // FormatoUIL.swift
        uilNoValido: { texto in "Ungültiges UIL: „\(texto)“. Erwartet wird L,G,D;R<Grad>[M], zum Beispiel 2,7,5;R30M." },
        intervalosIncoherentes: { menor, mayor, diferencia in "Widersprüchliche Intervalle: \(menor),\(mayor),\(diferencia). Es muss 0 < L ≤ D und G = L + D gelten." },
        giroNoValido: { grados in "Eine Drehung um \(grados)° ist kein Vielfaches von 30°." },
        afinacionNoSoportada: { tonos in "Es lassen sich nur Tastaturen mit 12 Tönen zeichnen, nicht mit \(tonos)." },
        cizallaNoSoportada: { cizalla in "Die Scherung S\(cizalla) wird nicht unterstützt." }
    )
}
