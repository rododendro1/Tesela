// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en portugués. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let portugues = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " e ") },
        enLaVoz: { primera in "em \(primera)" },
        enLosAcordes: "(acordes {1})",
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
        vozNumero: "voz {1}",

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nota de passagem", "bordadura", "apojatura", "retardo", "antecipação", "escapada", "nota pedal", "nota livre"],

        // Contrapunto.swift
        enElCompas: "(compasso {1})",
        enLosCompases: "(compassos {1})",
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
        especieConElContrapuntoEncima: "Espécie {1}, com o contraponto acima do cantus firmus",
        especieConElContrapuntoDebajo: "Espécie {1}, com o contraponto abaixo do cantus firmus",
        contrapuntoAVariasVoces: "Contraponto a {1} vozes",
        vozDelContrapunto: "voz {1}",
        sinFaltas: "Sem erros."
    )
}
