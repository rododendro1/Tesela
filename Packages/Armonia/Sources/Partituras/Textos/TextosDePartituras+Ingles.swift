// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en inglés. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let ingles = TextosDePartituras(
        // Duracion.swift
        cuadrada: "double whole note",
        redonda: "whole note",
        blanca: "half note",
        negra: "quarter note",
        corchea: "eighth note",
        semicorchea: "sixteenth note",
        fusa: "thirty-second note",
        semifusa: "sixty-fourth note",
        garrapatea: "hundred twenty-eighth note",
        cero: "zero",
        fraccionDeRedonda: "{1} of a whole note",
        conPuntillos: ["dotted {1}", "double-dotted {1}", "triple-dotted {1}", "quadruple-dotted {1}"],

        // Pentagrama.swift
        claveDeSol: "treble clef",
        claveDeSolOctavaBaja: "treble clef 8vb",
        claveDeSolOctavaAlta: "treble clef 8va",
        claveDeFa: "bass clef",
        claveDeFaEnTercera: "baritone clef",
        claveDeDoEnPrimera: "soprano clef",
        claveDeDoEnSegunda: "mezzo-soprano clef",
        claveDeDoEnTercera: "alto clef",
        claveDeDoEnCuarta: "tenor clef",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: true,
        instrumentoPiano: "piano",
        instrumentoFlauta: "flute",
        instrumentoFlautin: "piccolo",
        instrumentoFlautaEnSol: "alto flute",
        instrumentoOboe: "oboe",
        instrumentoCornoIngles: "English horn",
        instrumentoClarineteEnSib: "B♭ clarinet",
        instrumentoClarineteEnLa: "A clarinet",
        instrumentoClarineteEnMib: "E♭ clarinet",
        instrumentoClarineteBajo: "bass clarinet",
        instrumentoFagot: "bassoon",
        instrumentoSaxofonSoprano: "soprano saxophone",
        instrumentoSaxofonAlto: "alto saxophone",
        instrumentoSaxofonTenor: "tenor saxophone",
        instrumentoSaxofonBaritono: "baritone saxophone",
        instrumentoTrompetaEnSib: "B♭ trumpet",
        instrumentoTrompetaEnDo: "C trumpet",
        instrumentoFliscorno: "flugelhorn",
        instrumentoTrompaEnFa: "horn in F",
        instrumentoTrombon: "trombone",
        instrumentoTuba: "tuba",
        instrumentoViolin: "violin",
        instrumentoViola: "viola",
        instrumentoViolonchelo: "cello",
        instrumentoContrabajo: "double bass",
        instrumentoGuitarra: "guitar",
        instrumentoBajoElectrico: "electric bass",
        instrumentoXilofono: "xylophone",
        instrumentoGlockenspiel: "glockenspiel",
        instrumentoCelesta: "celesta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: "\"{1}\" is not a duration: expected a note value (1, 2, 4, 8, 16…, dotted: 4.) or a fraction of a whole note (3/8, 1/12)",
        compasNoValido: "\"{1}\" is not a time signature: expected numerator/denominator with a power-of-2 denominator (4/4, 6/8, 7/8), C or ¢",
        contrapuntoDeOtraDuracion: "the counterpoint must last as long as the cantus firmus: {1} whole notes, one per note"
    )
}
