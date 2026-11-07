// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en ruso. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let ruso = TextosDePartituras(
        // Duracion.swift
        cuadrada: "бревис",
        redonda: "целая",
        blanca: "половинная",
        negra: "четвертная",
        corchea: "восьмая",
        semicorchea: "шестнадцатая",
        fusa: "тридцать вторая",
        semifusa: "шестьдесят четвёртая",
        garrapatea: "сто двадцать восьмая",
        cero: "ноль",
        fraccionDeRedonda: { fraccion in "\(fraccion) целой" },
        conPuntillos: ["_ с точкой", "_ с двумя точками", "_ с тремя точками", "_ с четырьмя точками"],

        // Pentagrama.swift
        claveDeSol: "скрипичный ключ",
        claveDeSolOctavaBaja: "скрипичный ключ октавой ниже",
        claveDeSolOctavaAlta: "скрипичный ключ октавой выше",
        claveDeFa: "басовый ключ",
        claveDeFaEnTercera: "баритоновый ключ",
        claveDeDoEnPrimera: "сопрановый ключ",
        claveDeDoEnSegunda: "меццо-сопрановый ключ",
        claveDeDoEnTercera: "альтовый ключ",
        claveDeDoEnCuarta: "теноровый ключ",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: true,
        instrumentoPiano: "фортепиано",
        instrumentoFlauta: "флейта",
        instrumentoFlautin: "флейта-пикколо",
        instrumentoFlautaEnSol: "альтовая флейта",
        instrumentoOboe: "гобой",
        instrumentoCornoIngles: "английский рожок",
        instrumentoClarineteEnSib: "кларнет in B",
        instrumentoClarineteEnLa: "кларнет in A",
        instrumentoClarineteEnMib: "кларнет in Es",
        instrumentoClarineteBajo: "бас-кларнет",
        instrumentoFagot: "фагот",
        instrumentoSaxofonSoprano: "саксофон-сопрано",
        instrumentoSaxofonAlto: "саксофон-альт",
        instrumentoSaxofonTenor: "саксофон-тенор",
        instrumentoSaxofonBaritono: "саксофон-баритон",
        instrumentoTrompetaEnSib: "труба in B",
        instrumentoTrompetaEnDo: "труба in C",
        instrumentoFliscorno: "флюгельгорн",
        instrumentoTrompaEnFa: "валторна in F",
        instrumentoTrombon: "тромбон",
        instrumentoTuba: "туба",
        instrumentoViolin: "скрипка",
        instrumentoViola: "альт",
        instrumentoViolonchelo: "виолончель",
        instrumentoContrabajo: "контрабас",
        instrumentoGuitarra: "гитара",
        instrumentoBajoElectrico: "бас-гитара",
        instrumentoXilofono: "ксилофон",
        instrumentoGlockenspiel: "колокольчики",
        instrumentoCelesta: "челеста",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: { texto in "«\(texto)» — не длительность: ожидалась нота (1, 2, 4, 8, 16…, с точкой: 4.) или доля целой (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» — не размер: ожидалось числитель/знаменатель, где знаменатель — степень двойки (4/4, 6/8, 7/8), C или ¢" },
        contrapuntoDeOtraDuracion: { redondas in "контрапункт должен длиться столько же, сколько cantus firmus: \(redondas) целых, по одной на ноту" }
    )
}
