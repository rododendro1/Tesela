// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en asturiano. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let asturiano = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "ente " + nombres.joined(separator: " y ") },
        enLaVoz: { primera in "en \(primera)" },
        enLosAcordes: { pasos in "(acordes \(pasos))" },
        enElAcorde: { acorde in "(acorde \(acorde + 1))" },
        quintasParalelas: "Quintes paraleles",
        octavasParalelas: "Octaves paraleles",
        quintasDirectas: "Quintes direutes",
        octavasDirectas: "Octaves direutes",
        cruceDeVoces: "Crucia de voces",
        superposicion: "Superposición",
        separacionExcesiva: "Más d\'una octava",
        saltoNoMelodico: "Saltu non melódicu",
        fueraDeTesitura: "Fuera de tesitura",
        vozBajo: "baxu",
        vozTenor: "tenor",
        vozContralto: "contraltu",
        vozSoprano: "soprano",
        vozNumero: { numero in "voz \(numero)" },

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nota de pasu", "bordadura", "apoyatura", "retardu", "anticipación", "escapada", "nota pedal", "nota llibre"],

        // Contrapunto.swift
        enElCompas: { n in "(compás \(n))" },
        enLosCompases: { pasos in "(compases \(pasos))" },
        ritmoDeLaEspecie: "Ritmu ayenu a la especie",
        comienzoImperfecto: "Entamu ensin consonancia perfeuta",
        finalImperfecto: "Final ensin unísonu nin octava",
        finalSinGradoConjunto: "Final ensin grau conxuntu",
        disonanciaEnParteFuerte: "Disonancia en parte fuerte",
        disonanciaMalTratada: "Disonancia mal tratada",
        retardoMalResuelto: "Retardu mal resueltu",
        unisono: "Unísonu en metá del exerciciu",
        saltoSinCompensar: "Saltu ensin compensar",
        notaRepetida: "Nota repetida",
        especieConElContrapuntoEncima: { n in "Especie \(n), col contrapuntu enriba del cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Especie \(n), col contrapuntu embaxo del cantus firmus" },
        contrapuntoAVariasVoces: { n in "Contrapuntu a \(n) voces" },
        vozDelContrapunto: { n in "voz \(n)" },
        sinFaltas: "Ensin faltes."
    )
}
