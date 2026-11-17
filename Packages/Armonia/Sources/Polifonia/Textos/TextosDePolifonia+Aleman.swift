// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en alemán. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let aleman = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "zwischen " + nombres.joined(separator: " und ") },
        enLaVoz: { primera in (primera.hasPrefix("Stimme") ? "in \(primera)" : "im \(primera)") },
        enLosAcordes: "(Akkorde {1})",
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
        vozNumero: "Stimme {1}",

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["Durchgangston", "Wechselnote", "freier Vorhalt", "Vorhalt", "Antizipation", "Echappée", "Orgelpunkt", "freie Dissonanz"],

        // Contrapunto.swift
        enElCompas: "(Takt {1})",
        enLosCompases: "(Takte {1})",
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
        especieConElContrapuntoEncima: "Gattung {1}, Kontrapunkt über dem Cantus firmus",
        especieConElContrapuntoDebajo: "Gattung {1}, Kontrapunkt unter dem Cantus firmus",
        contrapuntoAVariasVoces: "{1}-stimmiger Kontrapunkt",
        vozDelContrapunto: "Stimme {1}",
        sinFaltas: "Keine Fehler.",
        realizacionSinNotas: "Es gibt keine Akkorde oder Noten zum Setzen.",
        realizacionSopranoDeOtraLongitud: "Der Sopran muss eine Note pro Akkord haben (Noten: {1}; Akkorde: {2}).",
        realizacionNotaAjena: "Die Soprannote gehört nicht zu Akkord {1}.",
        realizacionSopranoFueraDeTesitura: "Die Soprannote von Akkord {1} liegt außerhalb seines Umfangs.",
        realizacionDemasiadasNotas: "Akkord {1} hat mehr als vier Töne, die nicht fehlen dürfen.",
        realizacionSinDisposicion: "Akkord {1} lässt sich nicht fehlerfrei vierstimmig setzen.",
        realizacionNotaSinAcorde: "Kein Akkord der Tonart enthält Ton {1} der Melodie.",
        realizacionSinEnlaceSinFaltas: "Die Akkorde lassen sich nicht fehlerfrei vierstimmig verbinden.",
        realizacionOtraMelodia: "Der Sopran ist nicht die Melodie der Harmonisierung."
    )
}
