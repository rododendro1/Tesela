// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// MARK: - Textos de Polifonia
//
// Un idioma por fichero: `TextosDePolifonia+Espanol.swift`, `TextosDePolifonia+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los trece y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de Polifonia en un idioma.
struct TextosDePolifonia: TextosTraducidos {
    // MARK: Coral.swift
    let entreLasVoces: @Sendable ([String]) -> String
    let enLaVoz: @Sendable (String) -> String
    let enLosAcordes: Plantilla  // {1} pasos
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
    let vozNumero: Plantilla  // {1} numero

    // MARK: NotaExtrana.swift
    /// En el orden de `NotaExtrana.allCases`: nota de paso, bordadura, apoyatura, retardo, anticipación, escapada,
    /// pedal y libre.
    let nombresDeNotasExtranas: [String]

    // MARK: Contrapunto.swift
    let enElCompas: Plantilla  // {1} n
    let enLosCompases: Plantilla  // {1} pasos
    let ritmoDeLaEspecie: String
    let comienzoImperfecto: String
    let finalImperfecto: String
    let finalSinGradoConjunto: String
    let disonanciaEnParteFuerte: String
    let disonanciaMalTratada: String
    let retardoMalResuelto: String
    let unisono: String
    let saltoSinCompensar: String
    let notaRepetida: String
    let especieConElContrapuntoEncima: Plantilla  // {1} n
    let especieConElContrapuntoDebajo: Plantilla  // {1} n
    /// La cabecera del informe de `ContrapuntoAVariasVoces`, con cuántas voces suenan (con el cantus).
    let contrapuntoAVariasVoces: Plantilla  // {1} n
    /// Una voz de `ContrapuntoAVariasVoces`, contada desde 1 (el cantus firmus se nombra aparte).
    let vozDelContrapunto: Plantilla  // {1} n
    let sinFaltas: String

    /// Los textos en los trece idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDePolifonia>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)
}
