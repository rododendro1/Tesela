// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// MARK: - Textos de Diagramas
//
// Un idioma por fichero: `TextosDeDiagramas+Espanol.swift`, `TextosDeDiagramas+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los trece y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de Diagramas en un idioma.
struct TextosDeDiagramas: TextosTraducidos {
    // MARK: CorrespondenciaDeColores.swift
    let circuloDeQuintas: String

    // MARK: DibujoSVG.swift
    let conjunto: String
    let cicloDesde: Plantilla  // {1} nombre, {2} cifrado
    let primeraClase: String
    let primeraNota: String
    let leyendaNota: String
    let leyendaClaseDeAltura: String
    let leyendaAltura: String
    let leyendaIntervalos: String
    let leyendaContorno: String
    let leyendaTriadaMayor: String
    let leyendaTriadaMenor: String
    let leyendaPasoDelRecorrido: String
    let leyendaFundamentalDelPrimerAcorde: String

    // MARK: TecladoIsomorfico.swift
    let tablaArmonica: String
    let wickiHaydenEspejo: String
    let wickiHaydenPlano: String
    let acordeonC: String
    let acordeonB: String

    // MARK: TecladoCuadrado.swift
    let cuadriculaEnCuartas: String
    let cuadriculaEnTercerasMayores: String
    let cuadriculaEnQuintas: String
    let wickiHaydenCuadrado: String
    let cuadriculaDeTonosEnteros: String
    let tonnetzDeEuler: String
    let cuadriculaEnTercerasMenores: String
    let cuadriculaEnTritonos: String
    let cuadriculaEnOctavas: String
    let cuadriculaSecuencial: String

    // MARK: FormatoUIL.swift
    let uilNoValido: Plantilla  // {1} texto
    let intervalosIncoherentes: Plantilla  // {1} menor, {2} mayor, {3} diferencia
    let giroNoValido: Plantilla  // {1} grados
    let afinacionNoSoportada: Plantilla  // {1} tonos
    let cizallaNoSoportada: Plantilla  // {1} cizalla

    /// Los textos en los trece idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDeDiagramas>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)
}
