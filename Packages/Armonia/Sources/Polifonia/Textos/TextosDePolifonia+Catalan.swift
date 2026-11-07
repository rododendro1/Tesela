// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en catalán. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let catalan = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " i ") },
        enLaVoz: { primera in "en \(primera)" },
        enLosAcordes: { pasos in "(acords \(pasos))" },
        enElAcorde: { acorde in "(acord \(acorde + 1))" },
        quintasParalelas: "Quintes paral·leles",
        octavasParalelas: "Octaves paral·leles",
        quintasDirectas: "Quintes directes",
        octavasDirectas: "Octaves directes",
        cruceDeVoces: "Encreuament de veus",
        superposicion: "Superposició",
        separacionExcesiva: "Més d'una octava",
        saltoNoMelodico: "Salt no melòdic",
        fueraDeTesitura: "Fora de tessitura",
        vozBajo: "baix",
        vozTenor: "tenor",
        vozContralto: "contralt",
        vozSoprano: "soprano",
        vozNumero: { numero in "veu \(numero)" },

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nota de pas", "brodadura", "appoggiatura", "retard", "anticipació", "escapada", "nota pedal", "nota lliure"],

        // Contrapunto.swift
        enElCompas: { n in "(compàs \(n))" },
        enLosCompases: { pasos in "(compassos \(pasos))" },
        ritmoDeLaEspecie: "Ritme aliè a l'espècie",
        comienzoImperfecto: "Inici sense consonància perfecta",
        finalImperfecto: "Final sense uníson ni octava",
        finalSinGradoConjunto: "Final sense grau conjunt",
        disonanciaEnParteFuerte: "Dissonància en part forta",
        disonanciaMalTratada: "Dissonància mal tractada",
        retardoMalResuelto: "Retard mal resolt",
        unisono: "Uníson al mig de l'exercici",
        saltoSinCompensar: "Salt sense compensar",
        notaRepetida: "Nota repetida",
        especieConElContrapuntoEncima: { n in "Espècie \(n), amb el contrapunt damunt del cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Espècie \(n), amb el contrapunt davall del cantus firmus" },
        sinFaltas: "Sense faltes."
    )
}
