// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en ruso. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let ruso = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "— " + nombres.joined(separator: " и ") },
        enLaVoz: { primera in "— \(primera)" },
        enLosAcordes: { pasos in "(аккорды \(pasos))" },
        enElAcorde: { acorde in "(аккорд \(acorde + 1))" },
        quintasParalelas: "Параллельные квинты",
        octavasParalelas: "Параллельные октавы",
        quintasDirectas: "Скрытые квинты",
        octavasDirectas: "Скрытые октавы",
        cruceDeVoces: "Перекрещивание голосов",
        superposicion: "Перекрытие голосов",
        separacionExcesiva: "Больше октавы",
        saltoNoMelodico: "Немелодичный скачок",
        fueraDeTesitura: "Вне диапазона",
        vozBajo: "бас",
        vozTenor: "тенор",
        vozContralto: "альт",
        vozSoprano: "сопрано",
        vozNumero: { numero in "голос \(numero)" },

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["проходящий звук", "вспомогательный звук", "неприготовленное задержание", "задержание", "предъём", "отлетающий звук", "органный пункт", "свободный звук"],

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
        contrapuntoAVariasVoces: { n in "Контрапункт на \(n) голоса" },
        vozDelContrapunto: { n in "голос \(n)" },
        sinFaltas: "Ошибок нет."
    )
}
