// Los textos de ArmoniaRepresentaciones en griego. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let griego = TextosDeRepresentaciones(
        // Temperamento+Idiomas.swift
        temperamentoIgual: "ίσος συγκερασμός",
        pitagorico: "πυθαγόρειο κούρδισμα",
        mesotonico: "μεσοτονικό ¼ κόμματος",
        werckmeisterIII: "Βέρκμαϊστερ III",
        kirnbergerIII: "Κίρνμπεργκερ III",
        vallotti: "Βαλλόττι",
        young: "Γιανγκ",
        afinacionJusta: "φυσικό κούρδισμα",

        // CorrespondenciaDeColores+Idiomas.swift
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
        semitonos: { n in n == 1 ? "1 ημιτόνιο" : "\(n) ημιτόνια" },

        // TransformacionNeorriemanniana+Idiomas.swift
        homonima: "ομώνυμη",
        cambioDeSensible: "αλλαγή προσαγωγέα",
        relativa: "σχετική"
    )
}
