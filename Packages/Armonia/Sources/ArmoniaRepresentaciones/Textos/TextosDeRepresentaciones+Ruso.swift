import ArmoniaNucleo
// Los textos de ArmoniaRepresentaciones en ruso. Los campos y lo que significa cada uno están en
// `TextosDeRepresentaciones.swift`.

extension TextosDeRepresentaciones {
    static let ruso = TextosDeRepresentaciones(
        // Temperamento.swift
        temperamentoIgual: "равномерная темперация",
        pitagorico: "пифагоров строй",
        mesotonico: "среднетоновый строй в ¼ коммы",
        werckmeisterIII: "Веркмейстер III",
        kirnbergerIII: "Кирнбергер III",
        vallotti: "Валлотти",
        young: "Юнг",
        afinacionJusta: "чистый строй",

        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "квинтовый круг",

        // DibujoSVG.swift
        conjunto: "Множество ",
        cicloDesde: { nombre, cifrado in "\(nombre) от \(cifrado)" },
        primeraClase: "первый звуковысотный класс",
        primeraNota: "первая нота",
        leyendaNota: "нота",
        leyendaClaseDeAltura: "звуковысотный класс (все копии)",
        leyendaAltura: "высота (все клавиши)",
        leyendaIntervalos: "квинта или терция между нотами",
        leyendaContorno: "контур фигуры",
        leyendaTriadaMayor: "мажорное трезвучие",
        leyendaTriadaMenor: "минорное трезвучие",
        leyendaPasoDelRecorrido: "шаг последовательности (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "основной тон первого аккорда",

        // CicloNeorriemanniano.swift
        cicloHexatonico: "гексатонический цикл",
        cicloOctatonico: "октатонический цикл",
        cicloLR: "LR-цикл",

        // ConduccionParsimoniosa.swift
        semitonos: { n in Traduccion.pluralRuso(n, "полутон", "полутона", "полутонов") },

        // TransformacionNeorriemanniana.swift
        homonima: "одноимённая",
        cambioDeSensible: "смена вводного тона",
        relativa: "параллельная"
    )
}
