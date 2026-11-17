// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en gallego. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let gallego = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " e ") },
        enLaVoz: { primera in "en \(primera)" },
        enLosAcordes: "(acordes {1})",
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
        vozNumero: "voz {1}",

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nota de paso", "bordadura", "apoiatura", "retardo", "anticipación", "escapada", "nota pedal", "nota libre"],

        // Contrapunto.swift
        enElCompas: "(compás {1})",
        enLosCompases: "(compases {1})",
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
        especieConElContrapuntoEncima: "Especie {1}, co contrapunto enriba do cantus firmus",
        especieConElContrapuntoDebajo: "Especie {1}, co contrapunto debaixo do cantus firmus",
        contrapuntoAVariasVoces: "Contrapunto a {1} voces",
        vozDelContrapunto: "voz {1}",
        sinFaltas: "Sen faltas.",
        realizacionSinNotas: "Non hai acordes nin notas que escribir.",
        realizacionSopranoDeOtraLongitud: "O soprano debe ter unha nota por acorde (notas: {1}; acordes: {2}).",
        realizacionNotaAjena: "A nota do soprano non é do acorde {1}.",
        realizacionSopranoFueraDeTesitura: "A nota do soprano do acorde {1} está fóra da súa tesitura.",
        realizacionDemasiadasNotas: "O acorde {1} ten máis de catro notas que non poden faltar.",
        realizacionSinDisposicion: "O acorde {1} non se pode escribir a catro voces sen erros.",
        realizacionNotaSinAcorde: "Ningún acorde da tonalidade ten a nota {1} da melodía.",
        realizacionSinEnlaceSinFaltas: "Os acordes non se poden enlazar a catro voces sen erros.",
        realizacionOtraMelodia: "O soprano non é a melodía da harmonización."
    )
}
