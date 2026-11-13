import Elementos

// MARK: - Lo que tienen en común los catálogos con nombre
//
// Los siete catálogos del motor tienen la misma forma: un nombre en español con sus alias y sus variantes, los mismos
// en los trece idiomas, una búsqueda por cualquiera de ellos, sus referencias y la fecha en que aparecen.
// `ElementoConNombre` lo dice, para que quien los presenta (la consola, Exposicion, los TSV de `EjemploCatalogos`)
// escriba una sola función para todos. Cada tipo da lo suyo en su fichero; aquí solo va lo que sale de eso.

/// Un elemento de uno de los catálogos con nombre: `TipoDeEscala`, `AcordeConNombre`, `ProgresionConNombre`,
/// `RitmoConNombre`, `TemperamentoConNombre`, `NotaConNombre` y `FuncionDeNota`.
///
///     func fila(_ elemento: some ElementoConNombre, en notacion: Notacion) -> String {
///         elemento.nombres(en: notacion).joined(separator: ", ")
///     }
///     fila(AcordeConNombre.dominanteSeptima, en: .conPalabras(.ingles))   // "dominant seventh, …"
///     TemperamentoConNombre.werckmeisterIII.epocaDeOrigen                 // .barroco (1691)
public protocol ElementoConNombre: Nombrable, Hashable, Sendable, CustomStringConvertible {
    /// El nombre en español.
    var nombre: String { get }
    /// Otros nombres en español, escritos correctamente.
    var alias: [String] { get }
    /// Otras formas de escribir el nombre o uno de los alias en español, que no son otro nombre.
    var variantes: [String] { get }
    /// Los otros nombres en el idioma de la notación, como `nombre(en:)`; vacío si no tiene.
    func alias(en notacion: Notacion) -> [String]
    /// Las otras formas de escribir su nombre o un alias en el idioma de la notación; vacío si no tiene.
    func variantes(en notacion: Notacion) -> [String]

    /// Dónde se lee, con la obra que lo documenta (`documentada`), si la tiene, la primera.
    var referencias: [Referencia] { get }
    /// La obra más antigua que lo da, con su año; `nil` si no se sabe.
    var documentada: Referencia? { get }
    /// El año en que aparece, si se sabe: el de `documentada` o el que da su catálogo (el de un temperamento, el de un
    /// diapasón).
    var anioDeOrigen: Int? { get }
    /// La época en que aparece: la de `anioDeOrigen` o, si no se sabe, la que dan sus estilos; `nil` si no se sabe.
    var epocaDeOrigen: Epoca? { get }
    /// Lo que dicen las fuentes de su carácter, en orden cronológico; vacío si ninguna dice nada.
    var caracter: [Caracter] { get }

    /// Todo el catálogo, en su orden.
    static var catalogo: [Self] { get }
    /// El del catálogo con ese nombre, alias o variante en cualquier idioma, sin mirar mayúsculas, tildes, espacios
    /// ni guiones; `nil` si no hay ninguno.
    static func buscar(nombre: String) -> Self?
    /// Los del catálogo cuyo nombre, alias o variante contiene el texto en algún idioma, en el orden del catálogo;
    /// todos, si el texto está vacío.
    static func buscar(conteniendo texto: String) -> [Self]
}

extension ElementoConNombre {
    /// El nombre, los alias y las variantes en el idioma de la notación, en ese orden.
    ///
    ///     AcordeConNombre.tristan.nombres(en: .compacta(.espanol))   // ["acorde de Tristán"]
    public func nombres(en notacion: Notacion) -> [String] {
        [nombre(en: notacion)] + alias(en: notacion) + variantes(en: notacion)
    }
}

extension ElementoConNombre {
    /// Los afectos de todas sus fuentes, sin repetir, en el orden en que salen.
    ///
    ///     TipoDeEscala.harmoniaDoria.afectos   // [.valiente, .majestuoso, .severo, .grave, .sereno]
    ///     AcordeConNombre.menor.afectos        // [.triste, .tierno, .lastimero]
    public var afectos: [Afecto] {
        var vistos = Set<Afecto>()
        return caracter.flatMap(\.afectos).filter { vistos.insert($0).inserted }
    }

    /// Los momentos del día en que se toca, sin repetir.
    public var momentos: [MomentoDelDia] {
        var vistos = Set<MomentoDelDia>()
        return caracter.compactMap(\.momento).filter { vistos.insert($0).inserted }
    }

    /// Las ocasiones en que se toca, sin repetir: el lamento, la danza.
    public var ocasiones: [Ocasion] {
        var vistos = Set<Ocasion>()
        return caracter.compactMap(\.ocasion).filter { vistos.insert($0).inserted }
    }
}

extension TipoDeEscala: ElementoConNombre {}
extension AcordeConNombre: ElementoConNombre {}
extension ProgresionConNombre: ElementoConNombre {}
extension RitmoConNombre: ElementoConNombre {}
extension TemperamentoConNombre: ElementoConNombre {}
extension NotaConNombre: ElementoConNombre {}
extension FuncionDeNota: ElementoConNombre {}
