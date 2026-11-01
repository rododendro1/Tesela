// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// MARK: - Textos de las apps
//
// Un idioma por fichero: `TextosDeApps+Espanol.swift`, `TextosDeApps+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los catorce y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de la interfaz de las apps en un idioma: los de las pestañas, secciones y etiquetas, que se leen con
/// `Notacion.texto(_:)`, los avisos y las tareas de `PresentacionDeCoral` y los nombres de `FicheroParaExportar`.
///
///     Notacion.inglesASCII.texto(\.digitaciones)    // "Fingerings"
public struct TextosDeApps: TextosTraducidos {
    // MARK: Notacion+TextosDeApps.swift y las vistas
    public let acordes: String
    public let escalas: String
    public let analisis: String
    public let coral: String
    public let acorde: String
    public let campoDeCifrado: @Sendable (String) -> String
    public let informacion: String
    public let nombre: String
    public let cifrado: String
    public let notas: String
    public let digitaciones: String
    public let arpegio: String
    public let patron: String
    public let arpegioEnElMastil: String
    public let trastes: @Sendable (Int, Int) -> String
    public let escalasCompatibles: String
    public let identificar: String
    public let tocaElMastil: String
    public let tocaNotas: String
    public let borrar: String
    public let sinAcordeConocido: String
    public let verEnAcordes: String
    public let tecladoMIDI: String
    public let dispositivosMIDI: String
    public let teoriaPostonal: String
    public let formaPrima: String
    public let numeroDeForte: String
    public let vectorIntervalico: String
    public let instrumentoYAfinacion: String
    public let sinDigitaciones: String
    public let calculando: String
    public let dedos: @Sendable (Int) -> String
    public let cejilla: @Sendable (Int) -> String
    public let escala: String
    public let tonica: String
    public let tipo: String
    public let habituales: String
    public let otrasTradiciones: String
    public let acordesDeLaEscala: String
    public let posicionesEnElMastil: String
    public let notasPorCuerda: @Sendable (Int) -> String
    public let forma: @Sendable (String) -> String
    public let mastilDeGuitarra: String
    public let pentagrama: String
    public let progresion: String
    public let campoDeProgresion: String
    public let resultado: String
    public let acordeAAcorde: String
    public let arpegiar: String
    public let cadencias: String
    public let tarea: String
    public let campoDeTonalidad: String
    public let tonalidad: String
    public let armonizaciones: String
    public let aCuatroVoces: String
    public let conduccionDeLasVoces: String
    public let avisos: String
    public let recorridoPLR: String
    public let modo: String
    public let red: String
    public let formatoUIL: String
    public let giro: String
    public let espejo: String
    public let noSeDibuja: String
    public let campoDeTriadaInicial: @Sendable (String) -> String
    public let reiniciar: String
    public let deshacer: String
    public let textos: String
    public let comoLasNotas: String
    public let octavaEnSubindice: String
    public let octavas: String
    public let conLaOctavaFinal: String
    public let figura: String
    public let sinCapo: String
    public let capo: @Sendable (Int) -> String
    public let rearmonizar: String
    public let aplicar: String
    public let detener: String
    public let transponer: String
    public let escuchar: String
    public let afinacionAlEscuchar: String
    public let exportar: String
    public let abrir: String
    public let rejillaHexagonal: String
    public let casillas: @Sendable (Int) -> String
    public let elegida: String
    public let mastilDe: @Sendable (String, Int, Int) -> String
    public let posicion: @Sendable (Int, Int) -> String
    public let marcas: @Sendable (Int) -> String
    public let cuerdasApagadas: @Sendable (String) -> String
    public let sinMarcas: String

    // MARK: PresentacionDeCoral.swift
    public let sinArmonizacion: String
    public let faltanOctavas: @Sendable (String) -> String
    public let sinCoralParaLaMelodia: @Sendable (String, String) -> String
    public let sinRealizacion: String
    public let sinFaltasDeConduccion: String
    public let armonizar: String
    public let realizar: String
    public let revisar: String
    public let indicacionArmonizar: @Sendable (String, String) -> String
    public let indicacionRevisar: @Sendable (String) -> String

    // MARK: FicheroParaExportar.swift
    public let partituraMusicXML: String
    public let partituraMEI: String
    public let dibujoSVG: String

    /// Los textos en los catorce idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    public static let traducidos = Traducido<TextosDeApps>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso)
}
