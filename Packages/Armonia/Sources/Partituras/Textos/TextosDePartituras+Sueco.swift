// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en sueco. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let sueco = TextosDePartituras(
        // Duracion.swift
        cuadrada: "brevis",
        redonda: "helnot",
        blanca: "halvnot",
        negra: "fjärdedelsnot",
        corchea: "åttondelsnot",
        semicorchea: "sextondelsnot",
        fusa: "trettiotvåondelsnot",
        semifusa: "sextiofjärdedelsnot",
        garrapatea: "hundratjugoåttondelsnot",
        cero: "noll",
        fraccionDeRedonda: "{1} av en helnot",
        conPuntillos: ["punkterad {1}", "dubbelpunkterad {1}", "trippelpunkterad {1}", "fyrdubbelt punkterad {1}"],

        // Pentagrama.swift
        claveDeSol: "G-klav",
        claveDeSolOctavaBaja: "G-klav en oktav lägre",
        claveDeSolOctavaAlta: "G-klav en oktav högre",
        claveDeFa: "F-klav",
        claveDeFaEnTercera: "barytonklav",
        claveDeDoEnPrimera: "sopranklav",
        claveDeDoEnSegunda: "mezzosopranklav",
        claveDeDoEnTercera: "altklav",
        claveDeDoEnCuarta: "tenorklav",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: true,
        instrumentoPiano: "Piano",
        instrumentoFlauta: "Flöjt",
        instrumentoFlautin: "Piccolaflöjt",
        instrumentoFlautaEnSol: "Altflöjt i G",
        instrumentoOboe: "Oboe",
        instrumentoCornoIngles: "Engelskt horn",
        instrumentoClarineteEnSib: "Klarinett i B",
        instrumentoClarineteEnLa: "Klarinett i A",
        instrumentoClarineteEnMib: "Klarinett i Ess",
        instrumentoClarineteBajo: "Basklarinett",
        instrumentoFagot: "Fagott",
        instrumentoSaxofonSoprano: "Sopransaxofon",
        instrumentoSaxofonAlto: "Altsaxofon",
        instrumentoSaxofonTenor: "Tenorsaxofon",
        instrumentoSaxofonBaritono: "Barytonsaxofon",
        instrumentoTrompetaEnSib: "Trumpet i B",
        instrumentoTrompetaEnDo: "Trumpet i C",
        instrumentoFliscorno: "Flygelhorn",
        instrumentoTrompaEnFa: "Valthorn i F",
        instrumentoTrombon: "Trombon",
        instrumentoTuba: "Tuba",
        instrumentoViolin: "Violin",
        instrumentoViola: "Viola",
        instrumentoViolonchelo: "Violoncell",
        instrumentoContrabajo: "Kontrabas",
        instrumentoGuitarra: "Gitarr",
        instrumentoBajoElectrico: "Elbas",
        instrumentoXilofono: "Xylofon",
        instrumentoGlockenspiel: "Klockspel",
        instrumentoCelesta: "Celesta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: "”{1}” är inget notvärde: ett notvärde (1, 2, 4, 8, 16…, punkterat: 4.) eller en del av en helnot (3/8, 1/12) väntades",
        compasNoValido: "”{1}” är ingen taktart: täljare/nämnare med en tvåpotens som nämnare (4/4, 6/8, 7/8), C eller ¢ väntades",
        contrapuntoDeOtraDuracion: "kontrapunkten måste vara lika lång som cantus firmus: {1} helnoter, en per ton"
    )
}
