// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaPartitura en ruso. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let ruso = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(такт \(n))" },
        enLosCompases: { pasos in "(такты \(pasos))" },
        ritmoDeLaEspecie: "Ритм не соответствует виду",
        comienzoImperfecto: "Начало без совершенного консонанса",
        finalImperfecto: "Окончание не в унисон и не в октаву",
        finalSinGradoConjunto: "К последней ноте не поступенно",
        disonanciaEnParteFuerte: "Диссонанс на сильной доле",
        disonanciaMalTratada: "Неправильно введённый диссонанс",
        retardoMalResuelto: "Неправильно разрешённое задержание",
        unisono: "Унисон в середине упражнения",
        saltoSinCompensar: "Скачок без заполнения",
        notaRepetida: "Повторённая нота",
        especieConElContrapuntoEncima: { n in "Вид \(n), контрапункт над cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Вид \(n), контрапункт под cantus firmus" },
        sinFaltas: "Ошибок нет.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "аккорды",
        pistaDelBajo: "бас",

        // Importacion.swift
        formatoDesconocido: "Файл не является ни MIDI, ни MusicXML.",
        musicXMLComprimido: "Сжатый MusicXML (.mxl) повреждён или не читается: экспортируйте его без сжатия (.musicxml).",
        midiDanado: "Файл MIDI повреждён или обрезан.",
        midiConTiempoSMPTE: "Файл MIDI считает время в кадрах SMPTE, а не в тиках на четверть.",
        xmlDanado: { linea in "Файл MusicXML повреждён (строка \(linea))." },
        noEsMusicXMLPorPartes: "XML не является партитурой MusicXML по партиям (score-partwise).",
        sinNotas: "В файле нет ни одной ноты.",
        sinAcordes: "В файле не звучит ни одного аккорда.",

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
        instrumentoCelesta: "челеста"
    )
}
