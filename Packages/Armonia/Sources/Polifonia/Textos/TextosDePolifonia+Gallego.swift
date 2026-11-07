// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en gallego. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let gallego = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " e ") },
        enLaVoz: { primera in "en \(primera)" },
        enLosAcordes: { pasos in "(acordes \(pasos))" },
        enElAcorde: { acorde in "(acorde \(acorde + 1))" },
        quintasParalelas: "Quintas paralelas",
        octavasParalelas: "Oitavas paralelas",
        quintasDirectas: "Quintas directas",
        octavasDirectas: "Oitavas directas",
        cruceDeVoces: "Cruzamento de voces",
        superposicion: "Superposición",
        separacionExcesiva: "Máis dunha oitava",
        saltoNoMelodico: "Salto non melódico",
        fueraDeTesitura: "Fóra de tesitura",
        vozBajo: "baixo",
        vozTenor: "tenor",
        vozContralto: "contralto",
        vozSoprano: "soprano",
        vozNumero: { numero in "voz \(numero)" },

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nota de paso", "bordadura", "apoiatura", "retardo", "anticipación", "escapada", "nota pedal", "nota libre"],

        // Contrapunto.swift
        enElCompas: { n in "(compás \(n))" },
        enLosCompases: { pasos in "(compases \(pasos))" },
        ritmoDeLaEspecie: "Ritmo alleo á especie",
        comienzoImperfecto: "Comezo sen consonancia perfecta",
        finalImperfecto: "Final sen unísono nin oitava",
        finalSinGradoConjunto: "Final sen grao conxunto",
        disonanciaEnParteFuerte: "Disonancia en parte forte",
        disonanciaMalTratada: "Disonancia mal tratada",
        retardoMalResuelto: "Retardo mal resolto",
        unisono: "Unísono no medio do exercicio",
        saltoSinCompensar: "Salto sen compensar",
        notaRepetida: "Nota repetida",
        especieConElContrapuntoEncima: { n in "Especie \(n), co contrapunto enriba do cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Especie \(n), co contrapunto debaixo do cantus firmus" },
        sinFaltas: "Sen faltas."
    )
}
