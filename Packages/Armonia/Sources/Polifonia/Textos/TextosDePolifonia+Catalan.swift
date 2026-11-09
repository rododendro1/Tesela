// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en catalán. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let catalan = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " i ") },
        enLaVoz: { primera in "en \(primera)" },
        enLosAcordes: "(acords {1})",
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
        vozNumero: "veu {1}",

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nota de pas", "brodadura", "appoggiatura", "retard", "anticipació", "escapada", "nota pedal", "nota lliure"],

        // Contrapunto.swift
        enElCompas: "(compàs {1})",
        enLosCompases: "(compassos {1})",
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
        especieConElContrapuntoEncima: "Espècie {1}, amb el contrapunt damunt del cantus firmus",
        especieConElContrapuntoDebajo: "Espècie {1}, amb el contrapunt sota el cantus firmus",
        contrapuntoAVariasVoces: "Contrapunt a {1} veus",
        vozDelContrapunto: "veu {1}",
        sinFaltas: "Sense faltes."
    )
}
