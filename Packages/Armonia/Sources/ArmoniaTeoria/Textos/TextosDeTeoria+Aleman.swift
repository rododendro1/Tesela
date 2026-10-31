// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaTeoria en alemán. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let aleman = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { bajo in "mit \(bajo) im Bass" },
        nombresDeLasInversiones: ["Grundstellung", "erste Umkehrung", "zweite Umkehrung", "dritte Umkehrung",
                                  "vierte Umkehrung", "fünfte Umkehrung", "sechste Umkehrung"],
        inversionConNumero: "_. Umkehrung",

        // EstructuraDeAcorde.swift
        papelFundamental: "Grundton",
        papelTercera: "Terz",
        papelSuspension: "Vorhalt",
        papelQuinta: "Quinte",
        papelSexta: "Sexte",
        papelSeptima: "Septime",
        papelNovena: "None",
        papelUndecima: "Undezime",
        papelDecimotercera: "Tredezime",
        papelTension: { n in "Tension \(n)" },
        triadaMayor: "Dur",
        triadaMenor: "Moll",
        triadaDisminuida: "vermindert",
        triadaAumentada: "übermäßig",
        triadaSuspendida: "suspendiert",
        triadaDeQuinta: "Quintklang",
        triadaSinTercera: "ohne Terz",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in vacio ? "Durdreiklang" : "Akkord \(propio)" },
        tipoMayor: "Durdreiklang",
        tipoMenor: "Molldreiklang",
        tipoDisminuido: "verminderter Dreiklang",
        tipoAumentado: "übermäßiger Dreiklang",
        tipoSuspendidoDeSegunda: "Sus2-Akkord",
        tipoSuspendidoDeCuarta: "Sus4-Akkord",
        tipoQuintaAcordeDePotencia: "Quintklang (Powerchord)",
        tipoSeptimaDeDominante: "Dominantseptakkord",
        tipoSeptimaMayor: "großer Septakkord",
        tipoMenorSeptima: "Mollseptakkord",
        tipoSemidisminuido: "halbverminderter Septakkord",
        tipoSeptimaDisminuida: "verminderter Septakkord",
        tipoMenorConSeptimaMayor: "Moll-Major-Septakkord",
        tipoAumentadoConSeptimaMenor: "übermäßiger Septakkord",
        tipoAumentadoConSeptimaMayor: "übermäßiger großer Septakkord",
        tipoSeptimaSuspendida: "Dominantseptakkord mit Quartvorhalt",
        tipoSexta: "Dur mit Sexte",
        tipoMenorSexta: "Moll mit Sexte",
        tipoSextaYNovena: "Sext-Non-Akkord",
        tipoNovenaDeDominante: "Dominantnonakkord",
        tipoNovenaMayor: "großer Nonakkord",
        tipoMenorNovena: "Mollnonakkord",
        tipoNovenaAnadida: "Dur mit hinzugefügter None",
        tipoUndecima: "Dominant-Undezimakkord",
        tipoMenorUndecima: "Moll-Undezimakkord",
        tipoDecimotercera: "Dominant-Tredezimakkord",
        tipoMenorDecimotercera: "Moll-Tredezimakkord",
        tipoSeptimaConNovenaMenor: "Dominantseptakkord mit kleiner None",
        tipoSextaAumentadaItaliana: "italienischer übermäßiger Sextakkord",
        tipoSextaAumentadaFrancesa: "französischer übermäßiger Sextakkord",
        tipoSextaAumentadaAlemana: "deutscher übermäßiger Sextakkord",

        // Coral.swift
        entreLasVoces: { nombres in "zwischen " + nombres.joined(separator: " und ") },
        enLaVoz: { primera in (primera.hasPrefix("Stimme") ? "in \(primera)" : "im \(primera)") },
        enLosAcordes: { pasos in "(Akkorde \(pasos))" },
        enElAcorde: { acorde in "(Akkord \(acorde + 1))" },
        quintasParalelas: "Quintparallelen",
        octavasParalelas: "Oktavparallelen",
        quintasDirectas: "Verdeckte Quinten",
        octavasDirectas: "Verdeckte Oktaven",
        cruceDeVoces: "Stimmkreuzung",
        superposicion: "Stimmüberschreitung",
        separacionExcesiva: "Mehr als eine Oktave",
        saltoNoMelodico: "Unmelodischer Sprung",
        fueraDeTesitura: "Außerhalb des Stimmumfangs",
        vozBajo: "Bass",
        vozTenor: "Tenor",
        vozContralto: "Alt",
        vozSoprano: "Sopran",
        vozNumero: { numero in "Stimme \(numero)" },

        // Escala.swift
        gradoTonica: "Tonika",
        gradoSupertonica: "Supertonika",
        gradoMediante: "Mediante",
        gradoSubdominante: "Subdominante",
        gradoDominante: "Dominante",
        gradoSuperdominante: "Submediante",
        gradoSensible: "Leitton",
        gradoSubtonica: "Subtonika",

        // AnalisisArmonico.swift
        funcionTonica: "Tonika",
        funcionSubdominante: "Subdominante",
        funcionDominante: "Dominante",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "Akkorde \(pasos)" },
        cadenciaAutentica: "authentischer Schluss",
        cadenciaPlagal: "plagaler Schluss",
        cadenciaRota: "Trugschluss",
        semicadencia: "Halbschluss",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "Von \(de) nach \(a) bei Akkord \(n)" },
        pivote: "Drehakkord",
        directa: " (direkt)"
    )
}
