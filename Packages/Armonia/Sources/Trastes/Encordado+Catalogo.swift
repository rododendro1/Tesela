import Elementos
import Teoria

// MARK: - El catálogo de instrumentos
//
// Lo que se sabe de cada instrumento de `Encordado.todos` además de sus cuerdas al aire: cuántas cuerdas lleva cada
// orden (las dobles de la mandolina y el laúd), sus trastes (cromáticos, diatónicos o ninguno), de dónde viene y dónde
// se lee. Los nombres en los trece idiomas están en `Textos/TextosDeTrastes+…`.

/// Los trastes de un instrumento del catálogo.
public enum TrastesDeEncordado: String, Hashable, Sendable, Codable, CaseIterable {
    /// Uno por semitono: la guitarra, el laúd, la mandolina.
    case cromaticos
    /// Solo los de una escala diatónica: el dulcémele de los Apalaches.
    case diatonicos
    /// Ninguno: el ud y la familia del violín. En el mástil, las posiciones se cuentan en semitonos, como si los
    /// tuviera.
    case sinTrastes

    /// «cromáticos», «diatónicos» o «sin trastes», en el idioma de la notación.
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .cromaticos: TextosDeTrastes.traduccion(\.trastesCromaticos).en(notacion)
        case .diatonicos: TextosDeTrastes.traduccion(\.trastesDiatonicos).en(notacion)
        case .sinTrastes: TextosDeTrastes.traduccion(\.sinTrastes).en(notacion)
        }
    }
}

/// La ficha de un instrumento del catálogo.
package struct FichaDeEncordado: Sendable {
    /// Las cuerdas de cada orden, en el orden de `afinacion`: 2 en cada orden doble.
    package let cuerdasPorOrden: [Int]
    package let trastes: TrastesDeEncordado
    package let datos: DatosDelCatalogo
    /// Las octavas de cada cuerda de los órdenes que no van al unísono, por su índice en `afinacion`, contadas
    /// desde la cuerda de `afinacion`: `[0, -1]` en el tercer orden del charango (Mi5 y Mi4).
    package var octavas: [Int: [Int]] = [:]
    /// Los trastes de una octava, en semitonos desde la cuerda al aire, si no son los doce: los de la escala
    /// mixolidia del dulcémele, con el «6½».
    package var trastesDeLaOctava: Set<Int>? = nil
    /// Los trastes que les faltan a las cuerdas cortas, por su índice en `afinacion`: la quinta del banjo nace en el
    /// 5.º traste del mástil y tiene cinco menos.
    package var cuerdasCortas: [Int: Int] = [:]
    /// Los trastes de `trastesDeLaOctava` que se añadieron entre dos de la escala y se numeran con «½»: el 6½ del
    /// dulcémele, a un semitono de la octava.
    package var mediosTrastes: Set<Int> = []
}

extension Encordado {
    /// La ficha de cada instrumento de `todos`. Que estén todos lo comprueban las pruebas.
    package static let fichas: [Encordado: FichaDeEncordado] = [
        .guitarra: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], lugares: [.pais(.espana)])),
        .guitarraEnReGrave: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984])),
        .guitarraEnReAbierto: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(estilos: [.blues], referencias: [.sadie1984], lugares: [.pais(.estadosUnidos)])),
        .guitarraEnSolAbierto: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(estilos: [.blues], referencias: [.sadie1984], lugares: [.pais(.estadosUnidos)])),
        .guitarraDADGAD: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(estilos: [.folclore], referencias: [.sadie1984], lugares: [.pais(.reinoUnido)])),
        .guitarraDeSieteCuerdas: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], lugares: [.pais(.brasil)])),
        .guitarraEnDoAbierto: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984])),
        .guitarraEnDoGrave: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(estilos: [.popRock], referencias: [.sadie1984])),
        .guitarraEnMiAbierto: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(estilos: [.blues], referencias: [.sadie1984], lugares: [.pais(.estadosUnidos)])),
        .guitarraNashville: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], lugares: [.pais(.estadosUnidos)])),
        .guitarraDeDoceCuerdas: FichaDeEncordado(
            cuerdasPorOrden: [2, 2, 2, 2, 2, 2], trastes: .cromaticos,
            datos: DatosDelCatalogo(estilos: [.folclore, .popRock], referencias: [.sadie1984]),
            octavas: [0: [0, 1], 1: [0, 1], 2: [0, 1], 3: [0, 1]]),
        .bajoElectrico: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(
                estilos: [.popRock, .jazz], referencias: [.sadie1984], anio: 1951, lugares: [.pais(.estadosUnidos)])),
        .bajoDeCincoCuerdas: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(
                estilos: [.popRock, .jazz], referencias: [.sadie1984], lugares: [.pais(.estadosUnidos)])),
        .ukelele: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], lugares: [.pais(.estadosUnidos)])),
        .ukeleleBariton: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], lugares: [.pais(.estadosUnidos)])),
        .mandolina: FichaDeEncordado(
            cuerdasPorOrden: [2, 2, 2, 2], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], lugares: [.pais(.italia)])),
        .mandola: FichaDeEncordado(
            cuerdasPorOrden: [2, 2, 2, 2], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], lugares: [.pais(.italia)])),
        .bandurria: FichaDeEncordado(
            cuerdasPorOrden: [2, 2, 2, 2, 2, 2], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], lugares: [.pais(.espana)])),
        .laud: FichaDeEncordado(
            cuerdasPorOrden: [2, 2, 2, 2, 2, 2], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], lugares: [.pais(.espana)])),
        .laudRenacentista: FichaDeEncordado(
            cuerdasPorOrden: [1, 2, 2, 2, 2, 2], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], tradicion: .renacimiento)),
        .vihuela: FichaDeEncordado(
            cuerdasPorOrden: [2, 2, 2, 2, 2, 2], trastes: .cromaticos,
            datos: DatosDelCatalogo(
                referencias: [.sadie1984], documentada: .milan1536, tradicion: .renacimiento, lugares: [.pais(.espana)])
        ),
        .ud: FichaDeEncordado(
            cuerdasPorOrden: [1, 2, 2, 2, 2, 2], trastes: .sinTrastes,
            datos: DatosDelCatalogo(referencias: [.sadie1984], tradicion: .mundoArabe)),
        .buzuki: FichaDeEncordado(
            cuerdasPorOrden: [2, 2, 2, 2], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], tradicion: .grecia), octavas: [0: [0, 1], 1: [0, 1]]),
        .charango: FichaDeEncordado(
            cuerdasPorOrden: [2, 2, 2, 2, 2], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], tradicion: .andes), octavas: [2: [0, -1]]),
        .cuatroVenezolano: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], lugares: [.pais(.venezuela)])),
        .tresCubano: FichaDeEncordado(
            cuerdasPorOrden: [2, 2, 2], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], lugares: [.pais(.cuba)])),
        .guitarraPortuguesa: FichaDeEncordado(
            cuerdasPorOrden: [2, 2, 2, 2, 2, 2], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], lugares: [.pais(.portugal)]),
            octavas: [0: [0, 1], 1: [0, 1], 2: [0, 1]]),
        .balalaica: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], tradicion: .europa, lugares: [.pais(.rusia)])),
        .banjo: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(
                estilos: [.folclore, .jazz], referencias: [.sadie1984], lugares: [.pais(.estadosUnidos)]),
            cuerdasCortas: [0: 5]),
        .dulcemele: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1], trastes: .diatonicos,
            datos: DatosDelCatalogo(estilos: [.folclore], referencias: [.sadie1984], lugares: [.pais(.estadosUnidos)]),
            trastesDeLaOctava: [0, 2, 4, 5, 7, 9, 10, 11], mediosTrastes: [11]),
        .pipa: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1], trastes: .cromaticos,
            datos: DatosDelCatalogo(referencias: [.sadie1984], tradicion: .china)),
        .violin: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1], trastes: .sinTrastes,
            datos: DatosDelCatalogo(
                estilos: [.clasica, .folclore], referencias: [.sadie1984], lugares: [.pais(.italia)])),
        .viola: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1], trastes: .sinTrastes,
            datos: DatosDelCatalogo(estilos: [.clasica], referencias: [.sadie1984], lugares: [.pais(.italia)])),
        .violonchelo: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1], trastes: .sinTrastes,
            datos: DatosDelCatalogo(estilos: [.clasica], referencias: [.sadie1984], lugares: [.pais(.italia)])),
        .contrabajo: FichaDeEncordado(
            cuerdasPorOrden: [1, 1, 1, 1], trastes: .sinTrastes,
            datos: DatosDelCatalogo(estilos: [.clasica, .jazz], referencias: [.sadie1984])),
    ]

    /// Su ficha, sin el capo; `nil` si no es de `todos`.
    package var ficha: FichaDeEncordado? { Encordado.fichas[sinCapo] }

    /// Las cuerdas de cada orden, de la de arriba a la de abajo: [2, 2, 2, 2] en la mandolina, [1, 2, 2, 2, 2, 2] en el
    /// ud. Uno por cuerda en los que no son del catálogo.
    public var cuerdasPorOrden: [Int] { ficha?.cuerdasPorOrden ?? Array(repeating: 1, count: numeroDeCuerdas) }

    /// Cuántas cuerdas tiene de verdad, contando las de cada orden: 8 en la mandolina, 12 en la bandurria.
    public var cuerdasReales: Int { cuerdasPorOrden.reduce(0, +) }

    /// Las alturas de las cuerdas de un orden al aire, por su índice en `afinacion`: dos Re4 en la mandolina; Mi5 y
    /// Mi4 en el tercer orden del charango, que va en octavas. Vacío si no existe.
    ///
    ///     Encordado.guitarraDeDoceCuerdas.alturasDelOrden(0)   // Mi2 Mi3
    public func alturasDelOrden(_ cuerda: Int) -> [Altura] {
        guard afinacion.indices.contains(cuerda) else { return [] }
        let alAire = afinacion[cuerda]
        let octavas = ficha?.octavas[cuerda] ?? Array(repeating: 0, count: cuerdasPorOrden[cuerda])
        return octavas.map { Altura(pasosDeQuinta: alAire.pasosDeQuinta, pasosDeOctava: alAire.pasosDeOctava + $0) }
    }

    /// Si los órdenes de alguna cuerda van en octavas, como en el buzuki o la guitarra de doce cuerdas.
    public var tieneOrdenesEnOctavas: Bool { !(ficha?.octavas.isEmpty ?? true) }

    /// Si una cuerda tiene ese traste, en semitonos desde la cuerda al aire (o desde el capo), en un mástil de
    /// `numeroDeTrastes`: en el dulcémele, solo los de su escala (0, 2, 4, 5, 7, 9, 10, 11 y 12 en la primera
    /// octava); en la quinta del banjo, cinco menos que en las demás.
    public func tieneTraste(_ traste: Int, enCuerda cuerda: Int, de numeroDeTrastes: Int) -> Bool {
        let faltan = ficha?.cuerdasCortas[cuerda] ?? 0
        guard traste >= 0, traste <= numeroDeTrastes - faltan else { return false }
        guard let deLaOctava = ficha?.trastesDeLaOctava else { return true }
        return deLaOctava.contains((traste + capo) % 12)
    }

    /// Sus trastes; cromáticos en los que no son del catálogo.
    public var trastes: TrastesDeEncordado { ficha?.trastes ?? .cromaticos }

    /// Dónde se lee: el New Grove de los instrumentos en todos, y la obra que lo documenta si la tiene.
    public var referencias: [Referencia] { ficha?.datos.referencias ?? [] }

    /// La tradición de la que es: el mundo árabe en el ud, los Andes en el charango; `nil` en los occidentales.
    public var tradicion: Tradicion? { ficha?.datos.tradicion }

    /// En qué estilos se usa, de más a menos importante: el blues en las afinaciones abiertas, la clásica en el
    /// violín.
    public var estilos: [Estilo] { ficha?.datos.estilos ?? [] }

    /// Los lugares de donde viene: España en la guitarra y la bandurria, Italia en la mandolina y el violín, Cuba en el
    /// tres.
    public var lugaresDeOrigen: [Lugar] { ficha?.datos.lugaresDeOrigen ?? [] }

    /// Los países de donde viene, con los que contienen sus lugares.
    public var paisesDeOrigen: [Pais] { ficha?.datos.paisesDeOrigen ?? [] }

    /// Los continentes de donde viene.
    public var continentesDeOrigen: [Continente] { ficha?.datos.continentesDeOrigen ?? [] }

    /// El año de la obra que lo documenta (1536 en la vihuela, por «El Maestro» de Milán) o el que se da (1951 en el
    /// bajo eléctrico, el del Precision Bass de Fender); `nil` si no se sabe.
    public var anioDeOrigen: Int? { ficha?.datos.anioDeOrigen }

    /// La época de su año.
    public var epocaDeOrigen: Epoca? { ficha?.datos.epocaDeOrigen }
}
