// Los textos de ArmoniaPartitura en alemán. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let aleman = TextosDePartitura(
        // Contrapunto+Idiomas.swift
        enElCompas: { n in "(Takt \(n))" },
        enLosCompases: { pasos in "(Takte \(pasos))" },
        ritmoDeLaEspecie: "Rhythmus passt nicht zur Gattung",
        comienzoImperfecto: "Beginn ohne vollkommene Konsonanz",
        finalImperfecto: "Schluss ohne Einklang oder Oktave",
        finalSinGradoConjunto: "Schluss nicht schrittweise erreicht",
        disonanciaEnParteFuerte: "Dissonanz auf schwerer Zeit",
        disonanciaMalTratada: "Falsch behandelte Dissonanz",
        retardoMalResuelto: "Falsch aufgelöster Vorhalt",
        unisono: "Einklang mitten im Satz",
        saltoSinCompensar: "Nicht ausgeglichener Sprung",
        notaRepetida: "Tonwiederholung",
        especieConElContrapuntoEncima: { n in "Gattung \(n), Kontrapunkt über dem Cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Gattung \(n), Kontrapunkt unter dem Cantus firmus" },
        sinFaltas: "Keine Fehler.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "Akkorde",
        pistaDelBajo: "Bass",

        // Duracion+Idiomas.swift
        cuadrada: "Doppelganze",
        redonda: "Ganze",
        blanca: "Halbe",
        negra: "Viertel",
        corchea: "Achtel",
        semicorchea: "Sechzehntel",
        fusa: "Zweiunddreißigstel",
        semifusa: "Vierundsechzigstel",
        garrapatea: "Hundertachtundzwanzigstel",
        cero: "null",
        fraccionDeRedonda: { fraccion in "\(fraccion) einer Ganzen" },
        conPuntillos: ["punktierte _", "doppelt punktierte _", "dreifach punktierte _", "vierfach punktierte _"],

        // Pentagrama+Idiomas.swift
        claveDeSol: "Violinschlüssel",
        claveDeSolOctavaBaja: "Violinschlüssel eine Oktave tiefer",
        claveDeSolOctavaAlta: "Violinschlüssel eine Oktave höher",
        claveDeFa: "Bassschlüssel",
        claveDeFaEnTercera: "Baritonschlüssel",
        claveDeDoEnPrimera: "Sopranschlüssel",
        claveDeDoEnSegunda: "Mezzosopranschlüssel",
        claveDeDoEnTercera: "Altschlüssel",
        claveDeDoEnCuarta: "Tenorschlüssel"
    )
}
