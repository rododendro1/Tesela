// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en occitano. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let occitano = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " e ") },
        enLaVoz: { primera in "en \(primera)" },
        enLosAcordes: { pasos in "(acòrds \(pasos))" },
        enElAcorde: { acorde in "(acòrd \(acorde + 1))" },
        quintasParalelas: "Quintas parallèlas",
        octavasParalelas: "Octavas parallèlas",
        quintasDirectas: "Quintas dirèctas",
        octavasDirectas: "Octavas dirèctas",
        cruceDeVoces: "Crosament de voses",
        superposicion: "Sobreposicion",
        separacionExcesiva: "Mai d'una octava",
        saltoNoMelodico: "Saut pas melodic",
        fueraDeTesitura: "Fòra de tessitura",
        vozBajo: "bassa",
        vozTenor: "tenor",
        vozContralto: "contralt",
        vozSoprano: "soprano",
        vozNumero: { numero in "votz \(numero)" },

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nòta de passatge", "brodadura", "apojatura", "retard", "anticipacion", "escapada", "nòta pedala", "nòta liura"],

        // Contrapunto.swift
        enElCompas: { n in "(mesura \(n))" },
        enLosCompases: { pasos in "(mesuras \(pasos))" },
        ritmoDeLaEspecie: "Ritme estrangièr a l'espècia",
        comienzoImperfecto: "Començament sens consonància perfiecha",
        finalImperfecto: "Final sens unisson ni octava",
        finalSinGradoConjunto: "Final sens gra conjunt",
        disonanciaEnParteFuerte: "Dissonància en temps fòrt",
        disonanciaMalTratada: "Dissonància mal tractada",
        retardoMalResuelto: "Retard mal resolgut",
        unisono: "Unisson al mitan de l'exercici",
        saltoSinCompensar: "Saut sens compensar",
        notaRepetida: "Nòta repetida",
        especieConElContrapuntoEncima: { n in "Espècia \(n), amb lo contrapunt dessús lo cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Espècia \(n), amb lo contrapunt dejós lo cantus firmus" },
        sinFaltas: "Sens fautas."
    )
}
