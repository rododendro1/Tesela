// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en sueco. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let sueco = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "mellan " + nombres.joined(separator: " och ") },
        enLaVoz: { primera in "i \(primera)" },
        enLosAcordes: { pasos in "(ackord \(pasos))" },
        enElAcorde: { acorde in "(ackord \(acorde + 1))" },
        quintasParalelas: "Kvintparalleller",
        octavasParalelas: "Oktavparalleller",
        quintasDirectas: "Dolda kvinter",
        octavasDirectas: "Dolda oktaver",
        cruceDeVoces: "Stämkorsning",
        superposicion: "Stämöverlappning",
        separacionExcesiva: "Mer än en oktav",
        saltoNoMelodico: "Omelodiskt språng",
        fueraDeTesitura: "Utanför stämomfånget",
        vozBajo: "bas",
        vozTenor: "tenor",
        vozContralto: "alt",
        vozSoprano: "sopran",
        vozNumero: { numero in "stämma \(numero)" },

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["genomgångston", "växelton", "fri förhållning", "förhållning", "föregripning", "échappée", "orgelpunkt", "fri dissonans"],

        // Contrapunto.swift
        enElCompas: { n in "(takt \(n))" },
        enLosCompases: { pasos in "(takter \(pasos))" },
        ritmoDeLaEspecie: "Rytmen passar inte arten",
        comienzoImperfecto: "Början utan fullkomlig konsonans",
        finalImperfecto: "Slut utan prim eller oktav",
        finalSinGradoConjunto: "Slutet nås inte stegvis",
        disonanciaEnParteFuerte: "Dissonans på betonat taktslag",
        disonanciaMalTratada: "Felbehandlad dissonans",
        retardoMalResuelto: "Felupplöst förhållning",
        unisono: "Prim mitt i satsen",
        saltoSinCompensar: "Okompenserat språng",
        notaRepetida: "Tonupprepning",
        especieConElContrapuntoEncima: { n in "Art \(n), kontrapunkt över cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Art \(n), kontrapunkt under cantus firmus" },
        contrapuntoAVariasVoces: { n in "\(n)-stämmig kontrapunkt" },
        vozDelContrapunto: { n in "stämma \(n)" },
        sinFaltas: "Inga fel."
    )
}
