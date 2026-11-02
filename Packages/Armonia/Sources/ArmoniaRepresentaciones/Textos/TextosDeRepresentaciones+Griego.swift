// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaRepresentaciones en griego. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let griego = TextosDeRepresentaciones(
        // AfinacionHistorica.swift
        temperamentoIgual: "ίσος συγκερασμός",
        pitagorico: "πυθαγόρειο κούρδισμα",
        mesotonico: "μεσοτονικό ¼ κόμματος",
        werckmeisterIII: "Βέρκμαϊστερ III",
        kirnbergerIII: "Κίρνμπεργκερ III",
        vallotti: "Βαλλόττι",
        young: "Γιανγκ",
        afinacionJusta: "φυσικό κούρδισμα",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "κύκλος των πεμπτών",

        // DibujoSVG.swift
        conjunto: "Σύνολο ",
        cicloDesde: { nombre, cifrado in "\(nombre) από \(cifrado)" },
        primeraClase: "πρώτη τονική κλάση",
        primeraNota: "πρώτη νότα",
        leyendaNota: "νότα",
        leyendaClaseDeAltura: "τονική κλάση (όλα τα αντίγραφά της)",
        leyendaAltura: "τονικό ύψος (όλα τα πλήκτρα του)",
        leyendaIntervalos: "πέμπτη ή τρίτη ανάμεσα σε νότες",
        leyendaContorno: "περίγραμμα του σχήματος",
        leyendaTriadaMayor: "μείζον τρίφωνο",
        leyendaTriadaMenor: "ελάσσον τρίφωνο",
        leyendaPasoDelRecorrido: "βήμα της ακολουθίας (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "θεμέλια της πρώτης συγχορδίας",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "εξατονικός κύκλος",
        cicloOctatonico: "οκτατονικός κύκλος",
        cicloLR: "κύκλος LR",

        // ConduccionParsimoniosa.swift
        semitonos: { n in Idioma.griego.contar(n, "ημιτόνιο", "ημιτόνια") },

        // TransformacionNeorriemanniana.swift
        homonima: "ομώνυμη",
        cambioDeSensible: "αλλαγή προσαγωγέα",
        relativa: "σχετική",

        // TecladoIsomorfico.swift
        tablaArmonica: "Αρμονικός πίνακας",
        wickiHaydenEspejo: "Wicki-Hayden (καθρέφτης)",
        wickiHaydenPlano: "Wicki-Hayden (επίπεδο)",
        acordeonC: "Ακορντεόν συστήματος C",
        acordeonB: "Ακορντεόν συστήματος B",
        // FormatoUIL.swift
        uilNoValido: { texto in "Μη έγκυρο UIL: «\(texto)». Αναμένεται L,G,D;R<μοίρες>[M], για παράδειγμα 2,7,5;R30M." },
        intervalosIncoherentes: { menor, mayor, diferencia in "Ασυνεπή διαστήματα: \(menor),\(mayor),\(diferencia). Πρέπει να ισχύει 0 < L ≤ D και G = L + D." },
        giroNoValido: { grados in "Η περιστροφή των \(grados)° δεν είναι πολλαπλάσιο των 30°." },
        afinacionNoSoportada: { tonos in "Σχεδιάζονται μόνο πληκτρολόγια 12 φθόγγων, όχι \(tonos)." },
        cizallaNoSoportada: { cizalla in "Η διάτμηση S\(cizalla) δεν υποστηρίζεται." }
    )
}
