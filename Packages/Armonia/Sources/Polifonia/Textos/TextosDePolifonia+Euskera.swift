// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en euskera. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let euskera = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in nombres.joined(separator: " eta ") },
        enLaVoz: { primera in primera },
        enLosAcordes: { pasos in "(\(pasos) akordeak)" },
        enElAcorde: { acorde in "(\(acorde + 1). akordea)" },
        quintasParalelas: "Bosgarren paraleloak",
        octavasParalelas: "Zortzidun paraleloak",
        quintasDirectas: "Bosgarren zuzenak",
        octavasDirectas: "Zortzidun zuzenak",
        cruceDeVoces: "Ahotsen gurutzatzea",
        superposicion: "Gainjartzea",
        separacionExcesiva: "Zortzidun bat baino gehiago",
        saltoNoMelodico: "Jauzi ez-melodikoa",
        fueraDeTesitura: "Tesituratik kanpo",
        vozBajo: "baxua",
        vozTenor: "tenorra",
        vozContralto: "altua",
        vozSoprano: "sopranoa",
        vozNumero: { numero in "\(numero). ahotsa" },

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["igarotze-nota", "brodadura", "apoiatura", "atzerapena", "aurrerapena", "ihes-nota", "pedal-nota", "nota askea"],

        // Contrapunto.swift
        enElCompas: { n in "(\(n). konpasa)" },
        enLosCompases: { pasos in "(\(pasos) konpasak)" },
        ritmoDeLaEspecie: "Espeziez kanpoko erritmoa",
        comienzoImperfecto: "Hasiera kontsonantzia perfekturik gabe",
        finalImperfecto: "Amaiera unisonorik eta zortzidunik gabe",
        finalSinGradoConjunto: "Amaiera gradu jarraiturik gabe",
        disonanciaEnParteFuerte: "Disonantzia zati sendoan",
        disonanciaMalTratada: "Gaizki tratatutako disonantzia",
        retardoMalResuelto: "Gaizki ebatzitako atzerapena",
        unisono: "Unisonoa ariketaren erdian",
        saltoSinCompensar: "Konpentsatu gabeko jauzia",
        notaRepetida: "Nota errepikatua",
        especieConElContrapuntoEncima: { n in "\(n). espeziea, kontrapuntua cantus firmusaren gainean" },
        especieConElContrapuntoDebajo: { n in "\(n). espeziea, kontrapuntua cantus firmusaren azpian" },
        sinFaltas: "Akatsik gabe."
    )
}
