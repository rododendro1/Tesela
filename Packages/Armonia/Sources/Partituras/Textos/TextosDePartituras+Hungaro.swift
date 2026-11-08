// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en húngaro. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let hungaro = TextosDePartituras(
        // Duracion.swift
        cuadrada: "brevis",
        redonda: "egész hang",
        blanca: "fél hang",
        negra: "negyed hang",
        corchea: "nyolcad hang",
        semicorchea: "tizenhatod hang",
        fusa: "harmincketted hang",
        semifusa: "hatvannegyed hang",
        garrapatea: "százhuszonnyolcad hang",
        cero: "nulla",
        fraccionDeRedonda: "egész hang {1} része",
        conPuntillos: ["pontozott {1}", "kétszer pontozott {1}", "háromszor pontozott {1}", "négyszer pontozott {1}"],

        // Pentagrama.swift
        claveDeSol: "violinkulcs",
        claveDeSolOctavaBaja: "violinkulcs 8vb",
        claveDeSolOctavaAlta: "violinkulcs 8va",
        claveDeFa: "basszuskulcs",
        claveDeFaEnTercera: "baritonkulcs",
        claveDeDoEnPrimera: "szopránkulcs",
        claveDeDoEnSegunda: "mezzoszopránkulcs",
        claveDeDoEnTercera: "altkulcs",
        claveDeDoEnCuarta: "tenorkulcs",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: true,
        instrumentoPiano: "zongora",
        instrumentoFlauta: "fuvola",
        instrumentoFlautin: "piccolo",
        instrumentoFlautaEnSol: "altfuvola",
        instrumentoOboe: "oboa",
        instrumentoCornoIngles: "angolkürt",
        instrumentoClarineteEnSib: "B klarinét",
        instrumentoClarineteEnLa: "A klarinét",
        instrumentoClarineteEnMib: "Esz klarinét",
        instrumentoClarineteBajo: "basszusklarinét",
        instrumentoFagot: "fagott",
        instrumentoSaxofonSoprano: "szopránszaxofon",
        instrumentoSaxofonAlto: "altszaxofon",
        instrumentoSaxofonTenor: "tenorszaxofon",
        instrumentoSaxofonBaritono: "baritonszaxofon",
        instrumentoTrompetaEnSib: "B trombita",
        instrumentoTrompetaEnDo: "C trombita",
        instrumentoFliscorno: "szárnykürt",
        instrumentoTrompaEnFa: "F kürt",
        instrumentoTrombon: "harsona",
        instrumentoTuba: "tuba",
        instrumentoViolin: "hegedű",
        instrumentoViola: "brácsa",
        instrumentoViolonchelo: "cselló",
        instrumentoContrabajo: "nagybőgő",
        instrumentoGuitarra: "gitár",
        instrumentoBajoElectrico: "basszusgitár",
        instrumentoXilofono: "xilofon",
        instrumentoGlockenspiel: "harangjáték",
        instrumentoCelesta: "cseleszta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: "„{1}” nem időtartam: hangérték (1, 2, 4, 8, 16…, pontozva: 4.) vagy az egész hang törtrésze (3/8, 1/12) várható",
        compasNoValido: "„{1}” nem ütemmutató: számláló/nevező várható, a nevező kettő hatványa (4/4, 6/8, 7/8), vagy C, illetve ¢",
        contrapuntoDeOtraDuracion: "az ellenpontnak ugyanolyan hosszúnak kell lennie, mint a cantus firmusnak: {1} egész hang, hangonként egy"
    )
}
