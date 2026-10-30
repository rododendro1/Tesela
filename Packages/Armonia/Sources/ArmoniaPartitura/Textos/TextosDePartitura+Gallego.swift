// Los textos de ArmoniaPartitura en gallego. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let gallego = TextosDePartitura(
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
        sinFaltas: "Sen faltas.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "acordes",
        pistaDelBajo: "baixo",

        // Importacion.swift
        formatoDesconocido: "O ficheiro non é MIDI nin MusicXML.",
        musicXMLComprimido: "É MusicXML comprimido (.mxl), que aínda non se le: expórtao sen comprimir (.musicxml).",
        midiDanado: "O ficheiro MIDI está danado ou cortado.",
        midiConTiempoSMPTE: "O ficheiro MIDI conta o tempo en fotogramas SMPTE, non en pulsos por negra.",
        xmlDanado: { linea in "O ficheiro MusicXML está danado (liña \(linea))." },
        noEsMusicXMLPorPartes: "O XML non é unha partitura MusicXML por partes (score-partwise).",
        sinNotas: "O ficheiro non ten ningunha nota.",
        sinAcordes: "No ficheiro non soa ningún acorde.",

        // Duracion.swift
        cuadrada: "cadrada",
        redonda: "redonda",
        blanca: "branca",
        negra: "negra",
        corchea: "corchea",
        semicorchea: "semicorchea",
        fusa: "fusa",
        semifusa: "semifusa",
        garrapatea: "garrapatea",
        cero: "cero",
        fraccionDeRedonda: { fraccion in "\(fraccion) de redonda" },
        conPuntillos: ["_ con puntiño", "_ con dobre puntiño", "_ con triplo puntiño", "_ con cuádruplo puntiño"],

        // Pentagrama.swift
        claveDeSol: "clave de sol",
        claveDeSolOctavaBaja: "clave de sol oitava baixa",
        claveDeSolOctavaAlta: "clave de sol oitava alta",
        claveDeFa: "clave de fa",
        claveDeFaEnTercera: "clave de fa en terceira",
        claveDeDoEnPrimera: "clave de do en primeira",
        claveDeDoEnSegunda: "clave de do en segunda",
        claveDeDoEnTercera: "clave de do en terceira",
        claveDeDoEnCuarta: "clave de do en cuarta"
    )
}
