import Armonia

// Lo que se consulta de un conjunto de clases de altura, sin darle forma: lo mismo para el texto de `armonia`, para su
// salida `--json` y para las apps, así que se calcula en un solo sitio. Los nombres van en la notación pedida y, al
// lado, lo que no depende de ella (las clases de altura: 0 = Do … 11 = Si).
//
// Son `Codable`, y sus nombres son las claves del JSON de `armonia … --json`: en español, sin tildes y siempre las
// mismas, sea cual sea el idioma. Cambiar uno rompe a quien lee ese JSON. Lo que es `nil` no sale en el JSON.

/// Un conjunto de clases de altura: sus notas, sus formas y sus vectores.
///
///     let datos = ConjuntoPresentado(ConjuntoDeClasesDeAltura([0, 4, 7]), en: .compacta(.espanol))
///     datos.forte        // "3-11"
///     datos.formaPrima   // [0, 3, 7]
public struct ConjuntoPresentado: Hashable, Sendable, Codable {
    public let clases: [Int]
    public let notas: [String]
    /// `nil` si el conjunto no está en la tabla de Forte (el vacío).
    public let forte: String?
    public let formaNormal: [Int]
    public let formaPrima: [Int]
    public let vectorIntervalico: [Int]
    public let vectorDeIndice: [Int]

    /// Los datos del conjunto de clases, con las notas escritas en la notación.
    public init(_ conjunto: ConjuntoDeClasesDeAltura, en notacion: Notacion) {
        clases = conjunto.clases
        notas = conjunto.notas().map { $0.nombre(en: notacion) }
        forte = conjunto.numeroDeForte
        formaNormal = conjunto.formaNormal
        formaPrima = conjunto.formaPrima
        vectorIntervalico = conjunto.vectorIntervalico
        vectorDeIndice = conjunto.vectorDeIndice
    }
}
