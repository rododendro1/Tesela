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
        sinFaltas: "Sin faltas.",
        realizacionSinNotas: "No hay acordes ni notas que escribir.",
        realizacionSopranoDeOtraLongitud: "El soprano debe tener una nota por acorde (notas: {1}; acordes: {2}).",
        realizacionNotaAjena: "La nota del soprano no es del acorde {1}.",
        realizacionSopranoFueraDeTesitura: "La nota del soprano del acorde {1} está fuera de su tesitura.",
        realizacionDemasiadasNotas: "El acorde {1} tiene más de cuatro notas que no pueden faltar.",
        realizacionSinDisposicion: "El acorde {1} no se puede escribir a cuatro voces sin faltas.",
        realizacionNotaSinAcorde: "Ningún acorde de la tonalidad tiene la nota {1} de la melodía.",
        realizacionSinEnlaceSinFaltas: "Los acordes no se pueden enlazar a cuatro voces sin faltas.",
        realizacionOtraMelodia: "El soprano no es la melodía de la armonización."
    )
}
