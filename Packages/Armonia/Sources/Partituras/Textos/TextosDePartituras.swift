// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// MARK: - Textos de Partituras
//
// Un idioma por fichero: `TextosDePartituras+Espanol.swift`, `TextosDePartituras+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los trece y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de Partituras en un idioma.
struct TextosDePartituras: TextosTraducidos {
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

    // MARK: Pentagrama.swift (InstrumentoDePartitura)
    /// Si un instrumento propio se llama por su nombre inglés (`nombreEnIngles`) y no por el español.
    let instrumentosPropiosEnIngles: Bool
    let instrumentoPiano: String
    let instrumentoFlauta: String
    let instrumentoFlautin: String
    let instrumentoFlautaEnSol: String
    let instrumentoOboe: String
    let instrumentoCornoIngles: String
    let instrumentoClarineteEnSib: String
    let instrumentoClarineteEnLa: String
    let instrumentoClarineteEnMib: String
    let instrumentoClarineteBajo: String
    let instrumentoFagot: String
    let instrumentoSaxofonSoprano: String
    let instrumentoSaxofonAlto: String
    let instrumentoSaxofonTenor: String
    let instrumentoSaxofonBaritono: String
    let instrumentoTrompetaEnSib: String
    let instrumentoTrompetaEnDo: String
    let instrumentoFliscorno: String
    let instrumentoTrompaEnFa: String
    let instrumentoTrombon: String
    let instrumentoTuba: String
    let instrumentoViolin: String
    let instrumentoViola: String
    let instrumentoViolonchelo: String
    let instrumentoContrabajo: String
    let instrumentoGuitarra: String
    let instrumentoBajoElectrico: String
    let instrumentoXilofono: String
    let instrumentoGlockenspiel: String
    let instrumentoCelesta: String

    // MARK: ErrorDeLecturaDePartitura.swift
    let duracionNoValida: @Sendable (String) -> String
    let compasNoValido: @Sendable (String) -> String
    let contrapuntoDeOtraDuracion: @Sendable (Int) -> String

    /// Los textos en los trece idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDePartituras>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)
}
