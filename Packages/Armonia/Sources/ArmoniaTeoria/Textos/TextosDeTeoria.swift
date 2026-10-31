// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// MARK: - Textos de ArmoniaTeoria
//
// Un idioma por fichero: `TextosDeTeoria+Espanol.swift`, `TextosDeTeoria+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los catorce y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de ArmoniaTeoria en un idioma.
struct TextosDeTeoria: TextosTraducidos {
    // MARK: Acorde.swift
    let conBajoEn: @Sendable (String) -> String
    let nombresDeLasInversiones: [String]
    let inversionConNumero: String

    // MARK: EstructuraDeAcorde.swift
    let papelFundamental: String
    let papelTercera: String
    let papelSuspension: String
    let papelQuinta: String
    let papelSexta: String
    let papelSeptima: String
    let papelNovena: String
    let papelUndecima: String
    let papelDecimotercera: String
    let papelTension: @Sendable (Int) -> String
    let triadaMayor: String
    let triadaMenor: String
    let triadaDisminuida: String
    let triadaAumentada: String
    let triadaSuspendida: String
    let triadaDeQuinta: String
    let triadaSinTercera: String

    // MARK: TipoDeAcorde.swift
    let acordeDesconocido: @Sendable (Bool, String, String) -> String
    let tipoMayor: String
    let tipoMenor: String
    let tipoDisminuido: String
    let tipoAumentado: String
    let tipoSuspendidoDeSegunda: String
    let tipoSuspendidoDeCuarta: String
    let tipoQuintaAcordeDePotencia: String
    let tipoSeptimaDeDominante: String
    let tipoSeptimaMayor: String
    let tipoMenorSeptima: String
    let tipoSemidisminuido: String
    let tipoSeptimaDisminuida: String
    let tipoMenorConSeptimaMayor: String
    let tipoAumentadoConSeptimaMenor: String
    let tipoAumentadoConSeptimaMayor: String
    let tipoSeptimaSuspendida: String
    let tipoSexta: String
    let tipoMenorSexta: String
    let tipoSextaYNovena: String
    let tipoNovenaDeDominante: String
    let tipoNovenaMayor: String
    let tipoMenorNovena: String
    let tipoNovenaAnadida: String
    let tipoUndecima: String
    let tipoMenorUndecima: String
    let tipoDecimotercera: String
    let tipoMenorDecimotercera: String
    let tipoSeptimaConNovenaMenor: String
    let tipoSextaAumentadaItaliana: String
    let tipoSextaAumentadaFrancesa: String
    let tipoSextaAumentadaAlemana: String

    // MARK: Coral.swift
    let entreLasVoces: @Sendable ([String]) -> String
    let enLaVoz: @Sendable (String) -> String
    let enLosAcordes: @Sendable (String) -> String
    let enElAcorde: @Sendable (Int) -> String
    let quintasParalelas: String
    let octavasParalelas: String
    let quintasDirectas: String
    let octavasDirectas: String
    let cruceDeVoces: String
    let superposicion: String
    let separacionExcesiva: String
    let saltoNoMelodico: String
    let fueraDeTesitura: String
    let vozBajo: String
    let vozTenor: String
    let vozContralto: String
    let vozSoprano: String
    let vozNumero: @Sendable (Int) -> String

    // MARK: Escala.swift
    let gradoTonica: String
    let gradoSupertonica: String
    let gradoMediante: String
    let gradoSubdominante: String
    let gradoDominante: String
    let gradoSuperdominante: String
    let gradoSensible: String
    let gradoSubtonica: String

    // MARK: AnalisisArmonico.swift
    let funcionTonica: String
    let funcionSubdominante: String
    let funcionDominante: String

    // MARK: Cadencia.swift
    let cadenciaEnLosAcordes: @Sendable (String) -> String
    let cadenciaAutentica: String
    let cadenciaPlagal: String
    let cadenciaRota: String
    let semicadencia: String

    // MARK: RecorridoTonal.swift
    let deUnaTonalidadAOtra: @Sendable (String, String, Int) -> String
    let pivote: String
    let directa: String

    // MARK: Arpegio.swift
    let arpegioDe: @Sendable (String) -> String
    let patronAscendente: String
    let patronDescendente: String
    let patronIdaYVuelta: String
    let patronAlberti: String
    let patronQuebrado: String
    let patronBajaYSube: String

    // MARK: Rearmonizacion.swift
    let sustitutoTritonal: String
    let dominanteSecundaria: String
    let prestamoModal: String
    let sustitutoDiatonico: String

    /// Los textos en los catorce idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDeTeoria>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso)
}
