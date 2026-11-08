// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en sueco. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let sueco = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "mellan " + nombres.joined(separator: " och ") },
        enLaVoz: { primera in "i \(primera)" },
        enLosAcordes: "(ackord {1})",
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
        vozNumero: "stämma {1}",

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["genomgångston", "växelton", "fri förhållning", "förhållning", "föregripning", "échappée", "orgelpunkt", "fri dissonans"],

        // Contrapunto.swift
        enElCompas: "(takt {1})",
        enLosCompases: "(takter {1})",
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
        especieConElContrapuntoEncima: "Art {1}, kontrapunkt över cantus firmus",
        especieConElContrapuntoDebajo: "Art {1}, kontrapunkt under cantus firmus",
        contrapuntoAVariasVoces: "{1}-stämmig kontrapunkt",
        vozDelContrapunto: "stämma {1}",
        sinFaltas: "Inga fel."
    )
}
