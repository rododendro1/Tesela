// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// MARK: - Textos de ArmoniaPartitura
//
// Un idioma por fichero: `TextosDePartitura+Espanol.swift`, `TextosDePartitura+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los catorce y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de ArmoniaPartitura en un idioma.
struct TextosDePartitura: TextosTraducidos {
    // MARK: Contrapunto.swift
    let enElCompas: @Sendable (Int) -> String
    let enLosCompases: @Sendable (String) -> String
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
    let especieConElContrapuntoEncima: @Sendable (Int) -> String
    let especieConElContrapuntoDebajo: @Sendable (Int) -> String
    let sinFaltas: String

    // MARK: ArchivoMIDI.swift
    let pistaDeAcordes: String
    let pistaDelBajo: String

    // MARK: Importacion.swift
    let formatoDesconocido: String
    let musicXMLComprimido: String
    let midiDanado: String
    let midiConTiempoSMPTE: String
    let xmlDanado: @Sendable (Int) -> String
    let noEsMusicXMLPorPartes: String
    let sinNotas: String
    let sinAcordes: String

    // MARK: Duracion.swift
    let cuadrada: String
    let redonda: String
    let blanca: String
    let negra: String
    let corchea: String
    let semicorchea: String
    let fusa: String
    let semifusa: String
    let garrapatea: String
    let cero: String
    let fraccionDeRedonda: @Sendable (String) -> String
    let conPuntillos: [String]

    // MARK: Pentagrama.swift
    let claveDeSol: String
    let claveDeSolOctavaBaja: String
    let claveDeSolOctavaAlta: String
    let claveDeFa: String
    let claveDeFaEnTercera: String
    let claveDeDoEnPrimera: String
    let claveDeDoEnSegunda: String
    let claveDeDoEnTercera: String
    let claveDeDoEnCuarta: String

    /// Los textos en los catorce idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDePartitura>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso)
}
