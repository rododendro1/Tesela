// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaPartitura en portugués. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let portugues = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(compasso \(n))" },
        enLosCompases: { pasos in "(compassos \(pasos))" },
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
        especieConElContrapuntoEncima: { n in "Espécie \(n), com o contraponto acima do cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Espécie \(n), com o contraponto abaixo do cantus firmus" },
        sinFaltas: "Sem erros.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "acordes",
        pistaDelBajo: "baixo",

        // Importacion.swift
        formatoDesconocido: "O ficheiro não é MIDI nem MusicXML.",
        musicXMLComprimido: "É MusicXML comprimido (.mxl), que ainda não se lê: exporte-o sem comprimir (.musicxml).",
        midiDanado: "O ficheiro MIDI está danificado ou cortado.",
        midiConTiempoSMPTE: "O ficheiro MIDI conta o tempo em fotogramas SMPTE, não em pulsos por semínima.",
        xmlDanado: { linea in "O ficheiro MusicXML está danificado (linha \(linea))." },
        noEsMusicXMLPorPartes: "O XML não é uma partitura MusicXML por partes (score-partwise).",
        sinNotas: "O ficheiro não tem nenhuma nota.",
        sinAcordes: "No ficheiro não soa nenhum acorde.",

        // Duracion.swift
        cuadrada: "breve",
        redonda: "semibreve",
        blanca: "mínima",
        negra: "semínima",
        corchea: "colcheia",
        semicorchea: "semicolcheia",
        fusa: "fusa",
        semifusa: "semifusa",
        garrapatea: "quartifusa",
        cero: "zero",
        fraccionDeRedonda: { fraccion in "\(fraccion) de semibreve" },
        conPuntillos: ["_ pontuada", "_ duplamente pontuada", "_ triplamente pontuada", "_ quadruplamente pontuada"],

        // Pentagrama.swift
        claveDeSol: "clave de sol",
        claveDeSolOctavaBaja: "clave de sol oitava abaixo",
        claveDeSolOctavaAlta: "clave de sol oitava acima",
        claveDeFa: "clave de fá",
        claveDeFaEnTercera: "clave de fá na terceira linha",
        claveDeDoEnPrimera: "clave de dó na primeira linha",
        claveDeDoEnSegunda: "clave de dó na segunda linha",
        claveDeDoEnTercera: "clave de dó na terceira linha",
        claveDeDoEnCuarta: "clave de dó na quarta linha"
    )
}
