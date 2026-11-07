// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en occitano. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let occitano = TextosDePartituras(
        // Duracion.swift
        cuadrada: "quadrada",
        redonda: "redonda",
        blanca: "blanca",
        negra: "negra",
        corchea: "crocha",
        semicorchea: "doble crocha",
        fusa: "tripla crocha",
        semifusa: "quadrupla crocha",
        garrapatea: "quintupla crocha",
        cero: "zèro",
        fraccionDeRedonda: { fraccion in "\(fraccion) de redonda" },
        conPuntillos: ["_ puntada", "_ doblament puntada", "_ triplament puntada", "_ quadruplament puntada"],

        // Pentagrama.swift
        claveDeSol: "clau de sòl",
        claveDeSolOctavaBaja: "clau de sòl octava bassa",
        claveDeSolOctavaAlta: "clau de sòl octava nauta",
        claveDeFa: "clau de fa",
        claveDeFaEnTercera: "clau de fa en tèrça",
        claveDeDoEnPrimera: "clau de do en primièra",
        claveDeDoEnSegunda: "clau de do en segonda",
        claveDeDoEnTercera: "clau de do en tèrça",
        claveDeDoEnCuarta: "clau de do en quarta",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: true,
        instrumentoPiano: "piano",
        instrumentoFlauta: "flaüta",
        instrumentoFlautin: "flautin",
        instrumentoFlautaEnSol: "flaüta en sòl",
        instrumentoOboe: "oboè",
        instrumentoCornoIngles: "còrn anglés",
        instrumentoClarineteEnSib: "clarinet en si♭",
        instrumentoClarineteEnLa: "clarinet en la",
        instrumentoClarineteEnMib: "clarinet en mi♭",
        instrumentoClarineteBajo: "clarinet bas",
        instrumentoFagot: "fagòt",
        instrumentoSaxofonSoprano: "saxofòn soprano",
        instrumentoSaxofonAlto: "saxofòn alt",
        instrumentoSaxofonTenor: "saxofòn tenor",
        instrumentoSaxofonBaritono: "saxofòn bariton",
        instrumentoTrompetaEnSib: "trompeta en si♭",
        instrumentoTrompetaEnDo: "trompeta en do",
        instrumentoFliscorno: "flicòrn",
        instrumentoTrompaEnFa: "còrn en fa",
        instrumentoTrombon: "trombòn",
        instrumentoTuba: "tuba",
        instrumentoViolin: "violon",
        instrumentoViola: "viòla",
        instrumentoViolonchelo: "violoncèl",
        instrumentoContrabajo: "contrabassa",
        instrumentoGuitarra: "guitarra",
        instrumentoBajoElectrico: "bassa electrica",
        instrumentoXilofono: "xilofòn",
        instrumentoGlockenspiel: "glockenspiel",
        instrumentoCelesta: "celèsta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: { texto in "«\(texto)» es pas una durada: s'esperava una figura (1, 2, 4, 8, 16…, puntada: 4.) o una fraccion de redonda (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» es pas una mesura: s'esperava numerator/denominator amb lo denominator poténcia de 2 (4/4, 6/8, 7/8), C o ¢" },
        contrapuntoDeOtraDuracion: { redondas in "lo contrapunt deu durar autant coma lo cantus firmus: \(redondas) redondas, una per nòta" }
    )
}
