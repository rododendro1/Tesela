// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaTeoria en inglés. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let ingles = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { bajo in "over \(bajo)" },
        nombresDeLasInversiones: ["root position", "first inversion", "second inversion", "third inversion",
                                  "fourth inversion", "fifth inversion", "sixth inversion"],
        inversionConNumero: "inversion _",

        // EstructuraDeAcorde.swift
        papelFundamental: "root",
        papelTercera: "third",
        papelSuspension: "suspension",
        papelQuinta: "fifth",
        papelSexta: "sixth",
        papelSeptima: "seventh",
        papelNovena: "ninth",
        papelUndecima: "eleventh",
        papelDecimotercera: "thirteenth",
        papelTension: { n in Intervalo.ordinal(n, en: .ingles) },
        triadaMayor: "major",
        triadaMenor: "minor",
        triadaDisminuida: "diminished",
        triadaAumentada: "augmented",
        triadaSuspendida: "suspended",
        triadaDeQuinta: "power chord",
        triadaSinTercera: "no third",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in "\(propio) chord" },
        tipoMayor: "major",
        tipoMenor: "minor",
        tipoDisminuido: "diminished",
        tipoAumentado: "augmented",
        tipoSuspendidoDeSegunda: "suspended second",
        tipoSuspendidoDeCuarta: "suspended fourth",
        tipoQuintaAcordeDePotencia: "power chord",
        tipoSeptimaDeDominante: "dominant seventh",
        tipoSeptimaMayor: "major seventh",
        tipoMenorSeptima: "minor seventh",
        tipoSemidisminuido: "half-diminished seventh",
        tipoSeptimaDisminuida: "diminished seventh",
        tipoMenorConSeptimaMayor: "minor major seventh",
        tipoAumentadoConSeptimaMenor: "augmented seventh",
        tipoAumentadoConSeptimaMayor: "augmented major seventh",
        tipoSeptimaSuspendida: "dominant seventh suspended fourth",
        tipoSexta: "major sixth",
        tipoMenorSexta: "minor sixth",
        tipoSextaYNovena: "six-nine",
        tipoNovenaDeDominante: "dominant ninth",
        tipoNovenaMayor: "major ninth",
        tipoMenorNovena: "minor ninth",
        tipoNovenaAnadida: "added ninth",
        tipoUndecima: "dominant eleventh",
        tipoMenorUndecima: "minor eleventh",
        tipoDecimotercera: "dominant thirteenth",
        tipoMenorDecimotercera: "minor thirteenth",
        tipoSeptimaConNovenaMenor: "dominant seventh flat nine",
        tipoSextaAumentadaItaliana: "Italian augmented sixth",
        tipoSextaAumentadaFrancesa: "French augmented sixth",
        tipoSextaAumentadaAlemana: "German augmented sixth",

        // Coral.swift
        entreLasVoces: { nombres in "between " + nombres.joined(separator: " and ") },
        enLaVoz: { primera in "in the \(primera)" },
        enLosAcordes: { pasos in "(chords \(pasos))" },
        enElAcorde: { acorde in "(chord \(acorde + 1))" },
        quintasParalelas: "Parallel fifths",
        octavasParalelas: "Parallel octaves",
        quintasDirectas: "Direct fifths",
        octavasDirectas: "Direct octaves",
        cruceDeVoces: "Voice crossing",
        superposicion: "Voice overlap",
        separacionExcesiva: "More than an octave",
        saltoNoMelodico: "Unmelodic leap",
        fueraDeTesitura: "Out of range",
        vozBajo: "bass",
        vozTenor: "tenor",
        vozContralto: "alto",
        vozSoprano: "soprano",
        vozNumero: { numero in "voice \(numero)" },

        // Escala.swift
        gradoTonica: "tonic",
        gradoSupertonica: "supertonic",
        gradoMediante: "mediant",
        gradoSubdominante: "subdominant",
        gradoDominante: "dominant",
        gradoSuperdominante: "submediant",
        gradoSensible: "leading tone",
        gradoSubtonica: "subtonic",

        // AnalisisArmonico.swift
        funcionTonica: "tonic",
        funcionSubdominante: "subdominant",
        funcionDominante: "dominant",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "chords \(pasos)" },
        cadenciaAutentica: "authentic cadence",
        cadenciaPlagal: "plagal cadence",
        cadenciaRota: "deceptive cadence",
        semicadencia: "half cadence",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "From \(de) to \(a) at chord \(n)" },
        pivote: "pivot",
        directa: " (direct)",
        // Arpegio.swift
        arpegioDe: { acorde in "\(acorde) arpeggio" },
        patronAscendente: "ascending",
        patronDescendente: "descending",
        patronIdaYVuelta: "up and down",
        patronAlberti: "Alberti bass",
        patronQuebrado: "broken",
        patronBajaYSube: "down and up",
        // Rearmonizacion.swift
        sustitutoTritonal: "tritone substitution",
        dominanteSecundaria: "secondary dominant",
        prestamoModal: "modal borrowing",
        sustitutoDiatonico: "diatonic substitution"
    )
}
