// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de PartituraArmonia en húngaro. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let hungaro = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(\(n). ütem)" },
        enLosCompases: { pasos in "(ütemek: \(pasos))" },
        ritmoDeLaEspecie: "A fajtától eltérő ritmus",
        comienzoImperfecto: "Kezdés tökéletes konszonancia nélkül",
        finalImperfecto: "Befejezés prím vagy oktáv nélkül",
        finalSinGradoConjunto: "A befejezést nem lépés vezeti be",
        disonanciaEnParteFuerte: "Disszonancia súlyos ütemrészen",
        disonanciaMalTratada: "Helytelenül kezelt disszonancia",
        retardoMalResuelto: "Rosszul feloldott késleltetés",
        unisono: "Prím a darab közepén",
        saltoSinCompensar: "Kiegyenlítetlen ugrás",
        notaRepetida: "Ismételt hang",
        especieConElContrapuntoEncima: { n in "\(n). fajta, ellenpont a cantus firmus fölött" },
        especieConElContrapuntoDebajo: { n in "\(n). fajta, ellenpont a cantus firmus alatt" },
        sinFaltas: "Nincs hiba.",

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
        fraccionDeRedonda: { fraccion in "egész hang \(fraccion) része" },
        conPuntillos: ["pontozott _", "kétszer pontozott _", "háromszor pontozott _", "négyszer pontozott _"],

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
        duracionNoValida: { texto in "„\(texto)” nem időtartam: hangérték (1, 2, 4, 8, 16…, pontozva: 4.) vagy az egész hang törtrésze (3/8, 1/12) várható" },
        compasNoValido: { texto in "„\(texto)” nem ütemmutató: számláló/nevező várható, a nevező kettő hatványa (4/4, 6/8, 7/8), vagy C, illetve ¢" },
        contrapuntoDeOtraDuracion: { redondas in "az ellenpontnak ugyanolyan hosszúnak kell lennie, mint a cantus firmusnak: \(redondas) egész hang, hangonként egy" }
    )
}
