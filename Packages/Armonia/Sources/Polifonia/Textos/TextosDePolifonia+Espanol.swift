// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en español. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let espanol = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " y ") },
        enLaVoz: { primera in "en \(primera)" },
        enLosAcordes: "(acordes {1})",
        enElAcorde: { acorde in "(acorde \(acorde + 1))" },
        quintasParalelas: "Quintas paralelas",
        octavasParalelas: "Octavas paralelas",
        quintasDirectas: "Quintas directas",
        octavasDirectas: "Octavas directas",
        cruceDeVoces: "Cruce de voces",
        superposicion: "Superposición",
        separacionExcesiva: "Más de una octava",
        saltoNoMelodico: "Salto no melódico",
        fueraDeTesitura: "Fuera de tesitura",
        vozBajo: "bajo",
        vozTenor: "tenor",
        vozContralto: "contralto",
        vozSoprano: "soprano",
        vozNumero: "voz {1}",

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nota de paso", "bordadura", "apoyatura", "retardo", "anticipación", "escapada", "nota pedal", "nota libre"],

        // Contrapunto.swift
        enElCompas: "(compás {1})",
        enLosCompases: "(compases {1})",
        ritmoDeLaEspecie: "Ritmo ajeno a la especie",
        comienzoImperfecto: "Comienzo sin consonancia perfecta",
        finalImperfecto: "Final sin unísono ni octava",
        finalSinGradoConjunto: "Final sin grado conjunto",
        disonanciaEnParteFuerte: "Disonancia en parte fuerte",
        disonanciaMalTratada: "Disonancia mal tratada",
        retardoMalResuelto: "Retardo mal resuelto",
        unisono: "Unísono en mitad del ejercicio",
        saltoSinCompensar: "Salto sin compensar",
        notaRepetida: "Nota repetida",
        especieConElContrapuntoEncima: "Especie {1}, con el contrapunto encima del cantus firmus",
        especieConElContrapuntoDebajo: "Especie {1}, con el contrapunto debajo del cantus firmus",
        contrapuntoAVariasVoces: "Contrapunto a {1} voces",
        vozDelContrapunto: "voz {1}",
        sinFaltas: "Sin faltas."
    )
}
