// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaTeoria en inglés. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let ingles = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { acorde, bajo in "\(acorde) over \(bajo)" },
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
        semicadenciaFrigia: "Phrygian half cadence",
        cadenciaPlagalMenor: "minor plagal cadence",

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
        aproximacionDesdeAbajo: "from below",
        aproximacionDesdeArriba: "from above",
        aproximacionEncierro: "enclosure",
        // Escala+Acorde.swift
        papelNotaDelAcorde: "chord tone",
        papelTensionDisponible: "tension",
        papelNotaAEvitar: "avoid note",
        modoDe: { modo, escala in "mode \(modo) of \(escala)" },
        // NotaExtrana.swift
        nombresDeNotasExtranas: ["passing tone", "neighbor tone", "appoggiatura", "suspension", "anticipation", "escape tone", "pedal tone", "free tone"],
        // EsquemaArmonico.swift
        nombresDeEsquemas: ["ii–V–I", "ii–V", "turnaround", "backdoor", "12-bar blues", "circle-of-fifths sequence", "romanesca", "Pachelbel's canon", "monte", "fonte", "ponte"],
        // Rearmonizacion.swift
        sustitutoTritonal: "tritone substitution",
        dominanteSecundaria: "secondary dominant",
        prestamoModal: "modal borrowing",
        sustitutoDiatonico: "diatonic substitution",
        rearmonizacionIIV: "ii–V",
        rearmonizacionBackdoor: "backdoor",
        rearmonizacionIIRelativo: "related ii",
        rearmonizacionDisminuido: "diminished substitution",
        secuenciaTerceras: "in thirds",
        secuenciaCuartas: "in fourths",
        secuenciaGruposDeTres: "in groups of three",
        secuenciaGruposDeCuatro: "in groups of four",
        secuenciaTriadas: "in triads",
        secuenciaCuatriadas: "in seventh chords",
        // ErrorDeLecturaDeTeoria.swift (acordes)
        simboloNoReconocido: { simbolo in "\"\(simbolo)\" is not part of any known chord symbol" },
        tensionNoValida: { tension in "\"\(tension)\" is not a valid tension (♭/♯ go with 5, 9, 11 and 13, and add with 2, 4, 6, 9, 11 and 13)" },
        numeroDeAcordeNoValido: { numero in "\"\(numero)\" is not a chord number (5, 6, 7, 9, 11 or 13)" },
        numeroRepetido: { numero in "\"\(numero)\" comes after another number; additional tensions go in parentheses, as in 7(9)" },
        disminuidoYSemidisminuido: "diminished (°) and half-diminished (ø) cannot be combined",
        quintaConCalidad: "a power chord (5) has no third, so it cannot take m, °, ø or +",
        fundamentalNoOmitible: "the root cannot be omitted",
        gradoNoOmitible: { grado in "\"omit\(grado)\" is not valid (3, 5, 7, 9, 11 and 13 can be omitted)" },
        faltaLaFundamental: "the root is missing",
        intervaloSinPapel: { intervalo, notacion in "the \(intervalo.nombre(en: notacion)) has no role in a tertian chord" },
        terceraMayorYMenor: "it has both a major and a minor third (♯9 is written as an augmented 9th, not a minor 3rd)",
        variasSeptimas: "it has more than one seventh",
        septimaDisminuidaFueraDelDisminuido: "the diminished seventh only appears in the diminished chord (with a minor 3rd and a diminished 5th)",
        noEsPorTerceras: "it is not a tertian chord",
        bajoNoValido: { bajo in "\"\(bajo)\" is not a note name for the bass" },
        idiomasMezclados: { nombre in "\"\(nombre)\" is written in a different language from the root: write everything with letters (G7/B) or everything in Spanish (Sol7/Si)" },
        // ErrorDeLecturaDeTeoria.swift (escalas)
        modoNoReconocido: { nombre in "\"\(nombre)\" is not the mode of a key: a key is major or minor (for other modes, use Escala)" },
        faltaElTipoDeEscala: "the scale type is missing (major, dorian, harmonic minor…)",
        tipoDeEscalaNoReconocido: { nombre in "\"\(nombre)\" is not a known scale type" },
        // ErrorDeLecturaDeTeoria.swift (coral)
        vocesDistintas: "every chord must have the same number of voices, and at least two",
        vocesDeDistintaLongitud: "every voice must have the same number of notes",
        // ErrorDeLecturaDeTeoria.swift (nombres y digitaciones)
        nombreNoReconocido: { n, o in "\"\(n)\" is none of these: \(o)" },
        numeroFueraDeRango: { t, d, h in "\"\(t)\" is not a number from \(d) to \(h)" },
        trasteNoValido: { t, u in "\"\(t)\" is not a fret: it must be x (muted string) or a number from 0 to \(u)" },
        cuerdasDistintas: { e, l in "one fret (or x) is needed for each of the \(e) strings, and there are \(l)" },
        // Gramática (Acorde.swift, Tonalidad.swift)
        acordeSobre: { tipo, raiz in "\(raiz) \(tipo)" },
        enLaTonalidad: { tonalidad in "in " + tonalidad }
    )
}
