// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// MARK: - Textos de las apps
//
// Un idioma por fichero: `TextosDeApps+Espanol.swift`, `TextosDeApps+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los catorce y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de la interfaz de las apps en un idioma: los de `TextoDeLasApps`, los avisos y las tareas de
/// `PresentacionDeCoral` y los nombres de `FicheroParaExportar`.
struct TextosDeApps: TextosTraducidos {
    // MARK: TextoDeLasApps.swift
    let acordes: String
    let escalas: String
    let analisis: String
    let coral: String
    let acorde: String
    let campoDeCifrado: @Sendable (String) -> String
    let informacion: String
    let nombre: String
    let cifrado: String
    let notas: String
    let digitaciones: String
    let arpegio: String
    let patron: String
    let arpegioEnElMastil: String
    let trastes: @Sendable (Int, Int) -> String
    let escalasCompatibles: String
    let identificar: String
    let tocaElMastil: String
    let tocaNotas: String
    let borrar: String
    let sinAcordeConocido: String
    let verEnAcordes: String
    let tecladoMIDI: String
    let dispositivosMIDI: String
    let teoriaPostonal: String
    let formaPrima: String
    let numeroDeForte: String
    let vectorIntervalico: String
    let instrumentoYAfinacion: String
    let sinDigitaciones: String
    let calculando: String
    let dedos: @Sendable (Int) -> String
    let cejilla: @Sendable (Int) -> String
    let escala: String
    let tonica: String
    let tipo: String
    let habituales: String
    let otrasTradiciones: String
    let acordesDeLaEscala: String
    let posicionesEnElMastil: String
    let notasPorCuerda: @Sendable (Int) -> String
    let forma: @Sendable (String) -> String
    let mastilDeGuitarra: String
    let pentagrama: String
    let progresion: String
    let campoDeProgresion: String
    let resultado: String
    let acordeAAcorde: String
    let arpegiar: String
    let cadencias: String
    let tarea: String
    let campoDeTonalidad: String
    let tonalidad: String
    let armonizaciones: String
    let aCuatroVoces: String
    let conduccionDeLasVoces: String
    let avisos: String
    let recorridoPLR: String
    let modo: String
    let red: String
    let formatoUIL: String
    let giro: String
    let espejo: String
    let noSeDibuja: String
    let campoDeTriadaInicial: @Sendable (String) -> String
    let reiniciar: String
    let deshacer: String
    let textos: String
    let comoLasNotas: String
    let octavas: String
    let conLaOctavaFinal: String
    let figura: String
    let sinCapo: String
    let capo: @Sendable (Int) -> String
    let rearmonizar: String
    let aplicar: String
    let detener: String
    let transponer: String
    let escuchar: String
    let afinacionAlEscuchar: String
    let exportar: String
    let abrir: String
    let rejillaHexagonal: String
    let casillas: @Sendable (Int) -> String
    let elegida: String
    let mastilDe: @Sendable (String, Int, Int) -> String
    let posicion: @Sendable (Int, Int) -> String
    let marcas: @Sendable (Int) -> String
    let cuerdasApagadas: @Sendable (String) -> String
    let sinMarcas: String

    // MARK: PresentacionDeCoral.swift
    let sinArmonizacion: String
    let faltanOctavas: @Sendable (String) -> String
    let sinCoralParaLaMelodia: @Sendable (String, String) -> String
    let sinRealizacion: String
    let sinFaltasDeConduccion: String
    let armonizar: String
    let realizar: String
    let revisar: String
    let indicacionArmonizar: @Sendable (String, String) -> String
    let indicacionRevisar: @Sendable (String) -> String

    // MARK: FicheroParaExportar.swift
    let partituraMusicXML: String
    let partituraMEI: String
    let dibujoSVG: String

    /// Los textos en los catorce idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDeApps>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso)
}
