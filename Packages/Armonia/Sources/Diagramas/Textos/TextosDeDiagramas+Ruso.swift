// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// Los textos de Diagramas en ruso. Los campos y lo que significa cada uno están en
// `TextosDeDiagramas.swift`.

extension TextosDeDiagramas {
    static let ruso = TextosDeDiagramas(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "квинтовый круг",

        // DibujoSVG.swift
        conjunto: "Множество ",
        cicloDesde: "{1} от {2}",
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

        // TecladoIsomorfico.swift
        tablaArmonica: "Гармоническая таблица",
        wickiHaydenEspejo: "Уикки-Хейден (зеркальный)",
        wickiHaydenPlano: "Уикки-Хейден (плоский)",
        acordeonC: "Аккордеон системы C",
        acordeonB: "Аккордеон системы B",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Сетка по квартам",
        cuadriculaEnTercerasMayores: "Сетка по большим терциям",
        cuadriculaEnQuintas: "Сетка по квинтам",
        wickiHaydenCuadrado: "Wicki-Hayden (сетка)",
        cuadriculaDeTonosEnteros: "Целотонная сетка",
        tonnetzDeEuler: "Тоннец Эйлера",
        cuadriculaEnTercerasMenores: "Сетка по малым терциям",
        cuadriculaEnTritonos: "Сетка по тритонам",
        cuadriculaEnOctavas: "Сетка по октавам",
        cuadriculaSecuencial: "Последовательная сетка",
        // FormatoUIL.swift
        uilNoValido: "Неверный UIL: «{1}». Ожидается L,G,D;R<градусы>[M], например 2,7,5;R30M.",
        intervalosIncoherentes: "Несогласованные интервалы: {1},{2},{3}. Должно выполняться 0 < L ≤ D и G = L + D.",
        giroNoValido: "Поворот на {1}° не кратен 30°.",
        afinacionNoSoportada: "Рисуются только клавиатуры на 12 звуков, а не на {1}.",
        cizallaNoSoportada: "Сдвиг S{1} не поддерживается."
    )
}
