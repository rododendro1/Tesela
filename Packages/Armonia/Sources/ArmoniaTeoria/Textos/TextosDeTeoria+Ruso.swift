// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaTeoria en ruso. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let ruso = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { bajo in "с басом \(bajo)" },
        nombresDeLasInversiones: ["основной вид", "первое обращение", "второе обращение", "третье обращение",
                                  "четвёртое обращение", "пятое обращение", "шестое обращение"],
        inversionConNumero: "_-е обращение",

        // EstructuraDeAcorde.swift
        papelFundamental: "основной тон",
        papelTercera: "терция",
        papelSuspension: "задержание",
        papelQuinta: "квинта",
        papelSexta: "секста",
        papelSeptima: "септима",
        papelNovena: "нона",
        papelUndecima: "ундецима",
        papelDecimotercera: "терцдецима",
        papelTension: { n in "\(n)-й тон" },
        triadaMayor: "мажорное",
        triadaMenor: "минорное",
        triadaDisminuida: "уменьшённое",
        triadaAumentada: "увеличенное",
        triadaSuspendida: "задержанное",
        triadaDeQuinta: "квинтовое",
        triadaSinTercera: "без терции",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in vacio ? "мажорный аккорд" : "аккорд \(propio)" },
        tipoMayor: "мажорное трезвучие",
        tipoMenor: "минорное трезвучие",
        tipoDisminuido: "уменьшённое трезвучие",
        tipoAumentado: "увеличенное трезвучие",
        tipoSuspendidoDeSegunda: "аккорд sus2",
        tipoSuspendidoDeCuarta: "аккорд sus4",
        tipoQuintaAcordeDePotencia: "квинтовое созвучие",
        tipoSeptimaDeDominante: "доминантсептаккорд",
        tipoSeptimaMayor: "большой мажорный септаккорд",
        tipoMenorSeptima: "малый минорный септаккорд",
        tipoSemidisminuido: "малый уменьшённый септаккорд",
        tipoSeptimaDisminuida: "уменьшённый септаккорд",
        tipoMenorConSeptimaMayor: "большой минорный септаккорд",
        tipoAumentadoConSeptimaMenor: "увеличенный септаккорд с малой септимой",
        tipoAumentadoConSeptimaMayor: "большой увеличенный септаккорд",
        tipoSeptimaSuspendida: "доминантсептаккорд с задержанием кварты",
        tipoSexta: "мажорный аккорд с секстой",
        tipoMenorSexta: "минорный аккорд с секстой",
        tipoSextaYNovena: "аккорд с секстой и ноной",
        tipoNovenaDeDominante: "доминантнонаккорд",
        tipoNovenaMayor: "большой мажорный нонаккорд",
        tipoMenorNovena: "минорный нонаккорд",
        tipoNovenaAnadida: "мажорный аккорд с добавленной ноной",
        tipoUndecima: "доминантовый ундецимаккорд",
        tipoMenorUndecima: "минорный ундецимаккорд",
        tipoDecimotercera: "доминантовый терцдецимаккорд",
        tipoMenorDecimotercera: "минорный терцдецимаккорд",
        tipoSeptimaConNovenaMenor: "доминантсептаккорд с малой ноной",
        tipoSextaAumentadaItaliana: "итальянский увеличенный секстаккорд",
        tipoSextaAumentadaFrancesa: "французский увеличенный секстаккорд",
        tipoSextaAumentadaAlemana: "немецкий увеличенный секстаккорд",

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

        // Escala.swift
        gradoTonica: "тоника",
        gradoSupertonica: "супертоника",
        gradoMediante: "медианта",
        gradoSubdominante: "субдоминанта",
        gradoDominante: "доминанта",
        gradoSuperdominante: "субмедианта",
        gradoSensible: "вводный тон",
        gradoSubtonica: "субтоника",

        // AnalisisArmonico.swift
        funcionTonica: "тоника",
        funcionSubdominante: "субдоминанта",
        funcionDominante: "доминанта",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "аккорды \(pasos)" },
        cadenciaAutentica: "автентический каданс",
        cadenciaPlagal: "плагальный каданс",
        cadenciaRota: "прерванный каданс",
        semicadencia: "половинный каданс",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "\(de) → \(a), аккорд \(n)" },
        pivote: "общий аккорд",
        directa: " (прямая)",
        // Arpegio.swift
        arpegioDe: { acorde in "Арпеджио \(acorde)" },
        patronAscendente: "восходящий",
        patronDescendente: "нисходящий",
        patronIdaYVuelta: "вверх и вниз",
        patronAlberti: "альбертиев бас",
        patronQuebrado: "ломаный",
        patronBajaYSube: "вниз и вверх",
        // Rearmonizacion.swift
        sustitutoTritonal: "тритоновая замена",
        dominanteSecundaria: "побочная доминанта",
        prestamoModal: "модальное заимствование",
        sustitutoDiatonico: "диатоническая замена"
    )
}
