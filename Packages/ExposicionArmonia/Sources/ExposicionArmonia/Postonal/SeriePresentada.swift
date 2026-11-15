import Armonia

// Lo que se consulta de una serie dodecafónica, sin darle forma: lo mismo para el texto de `armonia`, para su salida
// `--json` y para las apps, así que se calcula en un solo sitio. Los nombres van en la notación pedida y, al lado, lo
// que no depende de ella (las clases de altura: 0 = Do … 11 = Si).
//
// Son `Codable`, y sus nombres son las claves del JSON de `armonia … --json`: en español, sin tildes y siempre las
// mismas, sea cual sea el idioma. Cambiar uno rompe a quien lee ese JSON. Lo que es `nil` no sale en el JSON.

/// Una serie dodecafónica: sus notas, sus intervalos, sus hexacordos, sus formas y su matriz.
public struct SeriePresentada: Hashable, Sendable, Codable {
    public let clases: [Int]
    /// Una nota por clase, escritas todas a la vez para que ninguna se repita
    /// (`ConjuntoDeClasesDeAltura.nombresDeLasClases(en:)`).
    public let notas: [String]
    public let intervalos: [Int]
    public let deTodosLosIntervalos: Bool
    /// El número de Forte de cada hexacordo (o sus clases, si no lo tiene).
    public let hexacordos: [String]
    public let formasCombinatorias: [String]
    public let formasDistintas: Int
    /// Cada fila es una P, de izquierda a derecha; cada columna, una I, de arriba abajo.
    public let matriz: [[Int]]

    /// Los datos de la serie, con las notas escritas en la notación.
    public init(_ serie: SerieDodecafonica, en notacion: Notacion) {
        let nombres = ConjuntoDeClasesDeAltura.nombresDeLasClases(en: notacion)
        let mitades = serie.hexacordos
        clases = serie.clases
        notas = serie.clases.map { nombres[$0] }
        intervalos = serie.intervalos
        deTodosLosIntervalos = serie.esDeTodosLosIntervalos
        hexacordos = [mitades.primero, mitades.segundo].map { $0.numeroDeForte ?? $0.description }
        formasCombinatorias = serie.formasCombinatorias.map(\.description)
        formasDistintas = serie.numeroDeFormasDistintas
        matriz = serie.matriz
    }
}
