// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en italiano. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let italiano = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "tra " + nombres.joined(separator: " e ") },
        enLaVoz: { primera in "in \(primera)" },
        enLosAcordes: { pasos in "(accordi \(pasos))" },
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
        vozNumero: { numero in "voce \(numero)" },

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nota di passaggio", "nota di volta", "appoggiatura", "ritardo", "anticipazione", "nota sfuggita", "pedale", "nota libera"],

        // Contrapunto.swift
        enElCompas: { n in "(battuta \(n))" },
        enLosCompases: { pasos in "(battute \(pasos))" },
        ritmoDeLaEspecie: "Ritmo estraneo alla specie",
        comienzoImperfecto: "Inizio senza consonanza perfetta",
        finalImperfecto: "Finale senza unisono né ottava",
        finalSinGradoConjunto: "Finale non raggiunto per grado congiunto",
        disonanciaEnParteFuerte: "Dissonanza in battere",
        disonanciaMalTratada: "Dissonanza mal trattata",
        retardoMalResuelto: "Ritardo mal risolto",
        unisono: "Unisono a metà esercizio",
        saltoSinCompensar: "Salto non compensato",
        notaRepetida: "Nota ripetuta",
        especieConElContrapuntoEncima: { n in "Specie \(n), con il contrappunto sopra il cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Specie \(n), con il contrappunto sotto il cantus firmus" },
        sinFaltas: "Nessun errore."
    )
}
