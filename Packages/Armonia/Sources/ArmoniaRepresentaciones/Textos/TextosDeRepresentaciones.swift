// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// MARK: - Textos de ArmoniaRepresentaciones
//
// Un idioma por fichero: `TextosDeRepresentaciones+Espanol.swift`, `TextosDeRepresentaciones+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los catorce y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de ArmoniaRepresentaciones en un idioma.
struct TextosDeRepresentaciones: Sendable {
    // MARK: AfinacionHistorica.swift
    let temperamentoIgual: String
    let pitagorico: String
    let mesotonico: String
    let werckmeisterIII: String
    let kirnbergerIII: String
    let vallotti: String
    let young: String
    let afinacionJusta: String

    // MARK: CorrespondenciaDeColores.swift
    let circuloDeQuintas: String

    // MARK: DibujoSVG.swift
    let conjunto: String
    let cicloDesde: @Sendable (String, String) -> String
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

    // MARK: CicloNeorriemanniano.swift
    let cicloHexatonico: String
    let cicloOctatonico: String
    let cicloLR: String

    // MARK: ConduccionParsimoniosa.swift
    let semitonos: @Sendable (Int) -> String

    // MARK: TransformacionNeorriemanniana.swift
    let homonima: String
    let cambioDeSensible: String
    let relativa: String

    // MARK: TecladoIsomorfico.swift
    let tablaArmonica: String
    let wickiHaydenEspejo: String
    let wickiHaydenPlano: String
    let acordeonC: String
    let acordeonB: String

    /// Los textos en los catorce idiomas: `traducidos.map(\.campo)` es la `Traduccion` de un campo.
    static let traducidos = Traducido<TextosDeRepresentaciones>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso)
}
