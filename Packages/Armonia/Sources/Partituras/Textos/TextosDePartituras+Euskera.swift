// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en euskera. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let euskera = TextosDePartituras(
        // Duracion.swift
        cuadrada: "karratua",
        redonda: "biribila",
        blanca: "zuria",
        negra: "beltza",
        corchea: "kortxea",
        semicorchea: "semikortxea",
        fusa: "fusa",
        semifusa: "semifusa",
        garrapatea: "garrapatea",
        cero: "zero",
        fraccionDeRedonda: { fraccion in "biribilaren \(fraccion)" },
        conPuntillos: ["_ puntuduna", "_ puntu bikoitzarekin", "_ puntu hirukoitzarekin", "_ puntu laukoitzarekin"],

        // Pentagrama.swift
        claveDeSol: "sol giltza",
        claveDeSolOctavaBaja: "sol giltza zortzidun bat beherago",
        claveDeSolOctavaAlta: "sol giltza zortzidun bat gorago",
        claveDeFa: "fa giltza",
        claveDeFaEnTercera: "fa giltza hirugarren lerroan",
        claveDeDoEnPrimera: "do giltza lehen lerroan",
        claveDeDoEnSegunda: "do giltza bigarren lerroan",
        claveDeDoEnTercera: "do giltza hirugarren lerroan",
        claveDeDoEnCuarta: "do giltza laugarren lerroan",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: false,
        instrumentoPiano: "pianoa",
        instrumentoFlauta: "flauta",
        instrumentoFlautin: "pikoloa",
        instrumentoFlautaEnSol: "sol flauta",
        instrumentoOboe: "oboea",
        instrumentoCornoIngles: "korno ingelesa",
        instrumentoClarineteEnSib: "si♭ klarinetea",
        instrumentoClarineteEnLa: "la klarinetea",
        instrumentoClarineteEnMib: "mi♭ klarinetea",
        instrumentoClarineteBajo: "klarinete baxua",
        instrumentoFagot: "fagota",
        instrumentoSaxofonSoprano: "saxofoi sopranoa",
        instrumentoSaxofonAlto: "saxofoi altua",
        instrumentoSaxofonTenor: "saxofoi tenorra",
        instrumentoSaxofonBaritono: "saxofoi baritonoa",
        instrumentoTrompetaEnSib: "si♭ tronpeta",
        instrumentoTrompetaEnDo: "do tronpeta",
        instrumentoFliscorno: "fliscornoa",
        instrumentoTrompaEnFa: "fa tronpa",
        instrumentoTrombon: "tronboia",
        instrumentoTuba: "tuba",
        instrumentoViolin: "biolina",
        instrumentoViola: "biola",
        instrumentoViolonchelo: "biolontxeloa",
        instrumentoContrabajo: "kontrabaxua",
        instrumentoGuitarra: "gitarra",
        instrumentoBajoElectrico: "baxu elektrikoa",
        instrumentoXilofono: "xilofonoa",
        instrumentoGlockenspiel: "glockenspiela",
        instrumentoCelesta: "zelesta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: { texto in "«\(texto)» ez da iraupen bat: figura bat espero zen (1, 2, 4, 8, 16…, puntuekin: 4.) edo biribilaren zatiki bat (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» ez da konpas bat: zenbakitzailea/izendatzailea espero zen, izendatzailea 2ren berretura izanik (4/4, 6/8, 7/8), C edo ¢" },
        contrapuntoDeOtraDuracion: { redondas in "kontrapuntuak cantus firmusak beste iraun behar du: \(redondas) biribil, nota bakoitzeko bat" }
    )
}
