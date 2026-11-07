// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en portugués. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let portugues = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " e ") },
        enLaVoz: { primera in "em \(primera)" },
        enLosAcordes: { pasos in "(acordes \(pasos))" },
        enElAcorde: { acorde in "(acorde \(acorde + 1))" },
        quintasParalelas: "Quintas paralelas",
        octavasParalelas: "Oitavas paralelas",
        quintasDirectas: "Quintas diretas",
        octavasDirectas: "Oitavas diretas",
        cruceDeVoces: "Cruzamento de vozes",
        superposicion: "Sobreposição",
        separacionExcesiva: "Mais de uma oitava",
        saltoNoMelodico: "Salto não melódico",
        fueraDeTesitura: "Fora da tessitura",
        vozBajo: "baixo",
        vozTenor: "tenor",
        vozContralto: "contralto",
        vozSoprano: "soprano",
        vozNumero: { numero in "voz \(numero)" },

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nota de passagem", "bordadura", "apojatura", "retardo", "antecipação", "escapada", "nota pedal", "nota livre"],

        // Contrapunto.swift
        enElCompas: { n in "(compasso \(n))" },
        enLosCompases: { pasos in "(compassos \(pasos))" },
        ritmoDeLaEspecie: "Ritmo alheio à espécie",
        comienzoImperfecto: "Início sem consonância perfeita",
        finalImperfecto: "Final sem uníssono nem oitava",
        finalSinGradoConjunto: "Final sem grau conjunto",
        disonanciaEnParteFuerte: "Dissonância em tempo forte",
        disonanciaMalTratada: "Dissonância mal tratada",
        retardoMalResuelto: "Retardo mal resolvido",
        unisono: "Uníssono no meio do exercício",
        saltoSinCompensar: "Salto sem compensação",
        notaRepetida: "Nota repetida",
        especieConElContrapuntoEncima: { n in "Espécie \(n), com o contraponto acima do cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Espécie \(n), com o contraponto abaixo do cantus firmus" },
        sinFaltas: "Sem erros."
    )
}
