// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en italiano. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let italiano = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "tra " + nombres.joined(separator: " e ") },
        enLaVoz: { primera in "in \(primera)" },
        enLosAcordes: "(accordi {1})",
        enElAcorde: { acorde in "(accordo \(acorde + 1))" },
        quintasParalelas: "Quinte parallele",
        octavasParalelas: "Ottave parallele",
        quintasDirectas: "Quinte nascoste",
        octavasDirectas: "Ottave nascoste",
        cruceDeVoces: "Incrocio delle voci",
        superposicion: "Sovrapposizione",
        separacionExcesiva: "Più di un'ottava",
        saltoNoMelodico: "Salto non melodico",
        fueraDeTesitura: "Fuori tessitura",
        vozBajo: "basso",
        vozTenor: "tenore",
        vozContralto: "contralto",
        vozSoprano: "soprano",
        vozNumero: "voce {1}",

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nota di passaggio", "nota di volta", "appoggiatura", "ritardo", "anticipazione", "nota sfuggita", "pedale", "nota libera"],

        // Contrapunto.swift
        enElCompas: "(battuta {1})",
        enLosCompases: "(battute {1})",
        ritmoDeLaEspecie: "Ritmo estraneo alla specie",
        comienzoImperfecto: "Inizio senza consonanza perfetta",
        finalImperfecto: "Finale senza unisono né ottava",
        finalSinGradoConjunto: "Finale non raggiunto per grado congiunto",
        disonanciaEnParteFuerte: "Dissonanza su tempo forte",
        disonanciaMalTratada: "Dissonanza mal trattata",
        retardoMalResuelto: "Ritardo mal risolto",
        unisono: "Unisono a metà esercizio",
        saltoSinCompensar: "Salto non compensato",
        notaRepetida: "Nota ripetuta",
        especieConElContrapuntoEncima: "Specie {1}, con il contrappunto sopra il cantus firmus",
        especieConElContrapuntoDebajo: "Specie {1}, con il contrappunto sotto il cantus firmus",
        contrapuntoAVariasVoces: "Contrappunto a {1} voci",
        vozDelContrapunto: "voce {1}",
        sinFaltas: "Nessun errore.",
        realizacionSinNotas: "Non ci sono accordi né note da scrivere.",
        realizacionSopranoDeOtraLongitud: "Il soprano deve avere una nota per accordo (note: {1}; accordi: {2}).",
        realizacionNotaAjena: "La nota del soprano non appartiene all’accordo {1}.",
        realizacionSopranoFueraDeTesitura: "La nota del soprano dell’accordo {1} è fuori dalla sua tessitura.",
        realizacionDemasiadasNotas: "L’accordo {1} ha più di quattro note che non possono mancare.",
        realizacionSinDisposicion: "L’accordo {1} non si può scrivere a quattro voci senza errori.",
        realizacionNotaSinAcorde: "Nessun accordo della tonalità contiene la nota {1} della melodia.",
        realizacionSinEnlaceSinFaltas: "Gli accordi non si possono collegare a quattro voci senza errori.",
        realizacionOtraMelodia: "Il soprano non è la melodia dell’armonizzazione."
    )
}
