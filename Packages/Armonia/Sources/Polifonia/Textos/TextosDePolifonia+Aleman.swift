// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en alemán. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let aleman = TextosDePolifonia(
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

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["Durchgangston", "Wechselnote", "freier Vorhalt", "Vorhalt", "Antizipation", "Echappée", "Orgelpunkt", "freie Dissonanz"],

        // Contrapunto.swift
        enElCompas: { n in "(Takt \(n))" },
        enLosCompases: { pasos in "(Takte \(pasos))" },
        ritmoDeLaEspecie: "Rhythmus passt nicht zur Gattung",
        comienzoImperfecto: "Beginn ohne vollkommene Konsonanz",
        finalImperfecto: "Schluss ohne Einklang oder Oktave",
        finalSinGradoConjunto: "Schluss nicht schrittweise erreicht",
        disonanciaEnParteFuerte: "Dissonanz auf schwerer Zeit",
        disonanciaMalTratada: "Falsch behandelte Dissonanz",
        retardoMalResuelto: "Falsch aufgelöster Vorhalt",
        unisono: "Einklang mitten im Satz",
        saltoSinCompensar: "Nicht ausgeglichener Sprung",
        notaRepetida: "Tonwiederholung",
        especieConElContrapuntoEncima: { n in "Gattung \(n), Kontrapunkt über dem Cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Gattung \(n), Kontrapunkt unter dem Cantus firmus" },
        sinFaltas: "Keine Fehler."
    )
}
