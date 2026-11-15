import Armonia

/// Una obra o una cita, para `--json`: su clave de BibTeX, la cita breve («West 1992: 160–172»), la referencia
/// completa y, si los tiene, las páginas citadas, el DOI y el URL.
///
///     let presentada = ReferenciaPresentada(Referencia.persichetti1961)
///     presentada.cita   // "Persichetti 1961"
public struct ReferenciaPresentada: Hashable, Sendable, Codable {
    public let clave: String
    public let cita: String
    public let descripcion: String
    public let paginas: String?
    public let doi: String?
    public let url: String?

    public init(_ referencia: Referencia) {
        clave = referencia.clave
        cita = referencia.cita
        descripcion = referencia.descripcion
        paginas = referencia.paginasCitadas
        doi = referencia.doi
        url = referencia.url
    }
}
