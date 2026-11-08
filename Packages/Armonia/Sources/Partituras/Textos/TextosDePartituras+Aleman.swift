// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en alemán. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let aleman = TextosDePartituras(
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
        fraccionDeRedonda: "{1} einer Ganzen",
        conPuntillos: ["punktierte {1}", "doppelt punktierte {1}", "dreifach punktierte {1}", "vierfach punktierte {1}"],

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
        duracionNoValida: "„{1}“ ist keine Dauer: erwartet wurde ein Notenwert (1, 2, 4, 8, 16…, punktiert: 4.) oder ein Bruchteil der Ganzen (3/8, 1/12)",
        compasNoValido: "„{1}“ ist keine Taktart: erwartet wurde Zähler/Nenner mit einer Zweierpotenz als Nenner (4/4, 6/8, 7/8), C oder ¢",
        contrapuntoDeOtraDuracion: "der Kontrapunkt muss so lange dauern wie der Cantus firmus: {1} ganze Noten, eine pro Note"
    )
}
