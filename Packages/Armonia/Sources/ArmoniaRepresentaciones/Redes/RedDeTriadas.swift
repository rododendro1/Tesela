import ArmoniaNucleo
import ArmoniaTeoria

/// Lo que comparten el ``Tonnetz`` y la ``TablaArmonica``: las dos colocan las mismas cosas (unas notas, un acorde,
/// una escala, un conjunto de clases de altura, un recorrido de tríadas, el camino más corto entre dos y un ciclo
/// neorriemanniano) y las dibujan en SVG. Con él, quien ofrece las dos redes escribe una sola vez cómo se pasa de lo
/// que se pide a la red, y elige la red con su tipo:
///
///     func dibujo<Red: RedDeTriadas>(_: Red.Type, de acordes: [Acorde]) -> String? {
///         Red(recorrido: acordes)?.svg(opciones: OpcionesDeDiagrama(), margen: nil, leyenda: true)
///     }
///     dibujo(Tonnetz.self, de: ["Do", "Lam", "Fa"])
///     dibujo(TablaArmonica.self, de: ["Do", "Lam", "Fa"])
public protocol RedDeTriadas: Hashable, Sendable {
    /// Coloca las notas con su ortografía.
    init(_ notas: [Nota])
    /// Las notas del acorde.
    init(_ acorde: Acorde)
    /// Las notas de la escala.
    init(_ escala: Escala)
    /// Las clases de altura, en la red de doce notas.
    init(_ conjunto: ConjuntoDeClasesDeAltura)
    /// Un recorrido de tríadas mayores y menores, cada una junto a la anterior; `nil` si algún acorde no lo es.
    init?(recorrido acordes: [Acorde])
    /// El camino más corto por P, L y R entre dos tríadas; `nil` si alguna no es mayor o menor.
    init?(caminoDesde origen: Acorde, hasta destino: Acorde)
    /// Un ciclo neorriemanniano desde una tríada; `nil` si no es mayor o menor.
    init?(ciclo: CicloNeorriemanniano, desde acorde: Acorde)

    /// El dibujo en SVG: ver `Tonnetz.svg(opciones:margen:leyenda:)` y `TablaArmonica.svg(opciones:margen:leyenda:)`.
    func svg(opciones: OpcionesDeDiagrama, margen: Int?, leyenda: Bool) -> String
}

extension Tonnetz: RedDeTriadas {}
extension TablaArmonica: RedDeTriadas {}
