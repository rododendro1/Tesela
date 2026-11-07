// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en francés. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let frances = TextosDePartituras(
        // Contrapunto.swift
        enElCompas: { n in "(mesure \(n))" },
        enLosCompases: { pasos in "(mesures \(pasos))" },
        ritmoDeLaEspecie: "Rythme étranger à l'espèce",
        comienzoImperfecto: "Début sans consonance parfaite",
        finalImperfecto: "Fin sans unisson ni octave",
        finalSinGradoConjunto: "Fin non atteinte par degré conjoint",
        disonanciaEnParteFuerte: "Dissonance sur le temps fort",
        disonanciaMalTratada: "Dissonance mal traitée",
        retardoMalResuelto: "Retard mal résolu",
        unisono: "Unisson au milieu de l'exercice",
        saltoSinCompensar: "Saut non compensé",
        notaRepetida: "Note répétée",
        especieConElContrapuntoEncima: { n in "Espèce \(n), contrepoint au-dessus du cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Espèce \(n), contrepoint au-dessous du cantus firmus" },
        sinFaltas: "Aucune faute.",

        // Duracion.swift
        cuadrada: "carrée",
        redonda: "ronde",
        blanca: "blanche",
        negra: "noire",
        corchea: "croche",
        semicorchea: "double croche",
        fusa: "triple croche",
        semifusa: "quadruple croche",
        garrapatea: "quintuple croche",
        cero: "zéro",
        fraccionDeRedonda: { fraccion in "\(fraccion) de ronde" },
        conPuntillos: ["_ pointée", "_ doublement pointée", "_ triplement pointée", "_ quadruplement pointée"],

        // Pentagrama.swift
        claveDeSol: "clé de sol",
        claveDeSolOctavaBaja: "clé de sol octave basse",
        claveDeSolOctavaAlta: "clé de sol octave haute",
        claveDeFa: "clé de fa",
        claveDeFaEnTercera: "clé de fa troisième ligne",
        claveDeDoEnPrimera: "clé d'ut première ligne",
        claveDeDoEnSegunda: "clé d'ut deuxième ligne",
        claveDeDoEnTercera: "clé d'ut troisième ligne",
        claveDeDoEnCuarta: "clé d'ut quatrième ligne",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: false,
        instrumentoPiano: "piano",
        instrumentoFlauta: "flûte",
        instrumentoFlautin: "piccolo",
        instrumentoFlautaEnSol: "flûte en sol",
        instrumentoOboe: "hautbois",
        instrumentoCornoIngles: "cor anglais",
        instrumentoClarineteEnSib: "clarinette en si♭",
        instrumentoClarineteEnLa: "clarinette en la",
        instrumentoClarineteEnMib: "clarinette en mi♭",
        instrumentoClarineteBajo: "clarinette basse",
        instrumentoFagot: "basson",
        instrumentoSaxofonSoprano: "saxophone soprano",
        instrumentoSaxofonAlto: "saxophone alto",
        instrumentoSaxofonTenor: "saxophone ténor",
        instrumentoSaxofonBaritono: "saxophone baryton",
        instrumentoTrompetaEnSib: "trompette en si♭",
        instrumentoTrompetaEnDo: "trompette en ut",
        instrumentoFliscorno: "bugle",
        instrumentoTrompaEnFa: "cor en fa",
        instrumentoTrombon: "trombone",
        instrumentoTuba: "tuba",
        instrumentoViolin: "violon",
        instrumentoViola: "alto",
        instrumentoViolonchelo: "violoncelle",
        instrumentoContrabajo: "contrebasse",
        instrumentoGuitarra: "guitare",
        instrumentoBajoElectrico: "basse électrique",
        instrumentoXilofono: "xylophone",
        instrumentoGlockenspiel: "glockenspiel",
        instrumentoCelesta: "célesta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: { texto in "« \(texto) » n'est pas une durée : une figure était attendue (1, 2, 4, 8, 16…, pointée : 4.) ou une fraction de ronde (3/8, 1/12)" },
        compasNoValido: { texto in "« \(texto) » n'est pas une mesure : numérateur/dénominateur attendu, avec un dénominateur puissance de 2 (4/4, 6/8, 7/8), C ou ¢" },
        contrapuntoDeOtraDuracion: { redondas in "le contrepoint doit durer autant que le cantus firmus : \(redondas) rondes, une par note" }
    )
}
