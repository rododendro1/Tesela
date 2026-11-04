// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaPartitura en alemán. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let aleman = TextosDePartitura(
        // Contrapunto.swift
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

        // Duracion.swift
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

        // Pentagrama.swift
        claveDeSol: "Violinschlüssel",
        claveDeSolOctavaBaja: "Violinschlüssel eine Oktave tiefer",
        claveDeSolOctavaAlta: "Violinschlüssel eine Oktave höher",
        claveDeFa: "Bassschlüssel",
        claveDeFaEnTercera: "Baritonschlüssel",
        claveDeDoEnPrimera: "Sopranschlüssel",
        claveDeDoEnSegunda: "Mezzosopranschlüssel",
        claveDeDoEnTercera: "Altschlüssel",
        claveDeDoEnCuarta: "Tenorschlüssel",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: true,
        instrumentoPiano: "Klavier",
        instrumentoFlauta: "Flöte",
        instrumentoFlautin: "Piccoloflöte",
        instrumentoFlautaEnSol: "Altflöte in G",
        instrumentoOboe: "Oboe",
        instrumentoCornoIngles: "Englischhorn",
        instrumentoClarineteEnSib: "Klarinette in B",
        instrumentoClarineteEnLa: "Klarinette in A",
        instrumentoClarineteEnMib: "Klarinette in Es",
        instrumentoClarineteBajo: "Bassklarinette",
        instrumentoFagot: "Fagott",
        instrumentoSaxofonSoprano: "Sopransaxophon",
        instrumentoSaxofonAlto: "Altsaxophon",
        instrumentoSaxofonTenor: "Tenorsaxophon",
        instrumentoSaxofonBaritono: "Baritonsaxophon",
        instrumentoTrompetaEnSib: "Trompete in B",
        instrumentoTrompetaEnDo: "Trompete in C",
        instrumentoFliscorno: "Flügelhorn",
        instrumentoTrompaEnFa: "Horn in F",
        instrumentoTrombon: "Posaune",
        instrumentoTuba: "Tuba",
        instrumentoViolin: "Violine",
        instrumentoViola: "Viola",
        instrumentoViolonchelo: "Violoncello",
        instrumentoContrabajo: "Kontrabass",
        instrumentoGuitarra: "Gitarre",
        instrumentoBajoElectrico: "E-Bass",
        instrumentoXilofono: "Xylophon",
        instrumentoGlockenspiel: "Glockenspiel",
        instrumentoCelesta: "Celesta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: { texto in "„\(texto)“ ist keine Dauer: erwartet wurde ein Notenwert (1, 2, 4, 8, 16…, punktiert: 4.) oder ein Bruchteil der Ganzen (3/8, 1/12)" },
        compasNoValido: { texto in "„\(texto)“ ist keine Taktart: erwartet wurde Zähler/Nenner mit einer Zweierpotenz als Nenner (4/4, 6/8, 7/8), C oder ¢" },
        contrapuntoDeOtraDuracion: { redondas in "der Kontrapunkt muss so lange dauern wie der Cantus firmus: \(redondas) ganze Noten, eine pro Note" },
        figuraSinDuracion: "der Notenwert eines Arpeggios muss eine Dauer haben",
        duracionesPorAcorde: { acordes, duraciones in "pro Akkord ist eine Dauer nötig: es gibt \(acordes) Akkorde und \(duraciones) Dauern" },
        duracionNoPositiva: { n in "die Dauer von Akkord \(n) muss positiv sein" }
    )
}
