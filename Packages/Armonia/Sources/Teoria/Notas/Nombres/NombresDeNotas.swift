// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos

// MARK: - Nombres de las notas del catálogo
//
// Un idioma por fichero, como los de los acordes, los ritmos y los temperamentos: `NombresDeNotas+Catalan.swift`,
// `…+Ingles.swift`… Cada uno da el nombre de los diapasones y de las notas de referencia, que nombra por su miembro
// (`.init(.doCentral, "…")`: si se renombra o se quita, no compila) y, si los tiene, sus alias y sus variantes. Las
// posiciones guidonianas y las notas de las tradiciones se llaman igual en todos los idiomas (`generadas`). El español
// sale del propio catálogo. Que cada fichero dé todas las notas lo comprueban las pruebas (`NotaConNombreTests`).

/// Los nombres de las notas del catálogo en los trece idiomas.
package enum NombresDeNotas {
    /// La tabla de un idioma.
    package typealias Tabla = NombresDelCatalogo<NotaConNombre>

    /// Los nombres en los trece idiomas.
    package static let traducidos = Traducido<Tabla>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)

    /// Los nombres en un idioma.
    package static func de(_ idioma: Idioma) -> Tabla { traducidos.texto(en: idioma) }

    /// El español sale del catálogo: el nombre de cada nota, sus alias y sus variantes.
    static let espanol = Tabla.delCatalogo

    /// Nombre, alias o variante normalizados → la nota, en cualquier idioma.
    static let indice = Tabla.indice(de: traducidos)

    /// Una tabla con las filas escritas del idioma y detrás las de las notas que se llaman igual en todos: las
    /// posiciones guidonianas y las de las tradiciones, con sus alias y sus variantes. En griego (`enGriego`), las
    /// cuerdas del sistema perfecto se nombran en su grafía (μέση), con la transliterada de alias.
    static func tabla(_ escritas: [Tabla.Fila], enGriego: Bool = false) -> Tabla {
        let escritasYa = Set(NotaConNombre.escritas)
        let generadas = NotaConNombre.catalogo.filter { !escritasYa.contains($0) }.map { nota -> Tabla.Fila in
            if enGriego, nota.familia == .griega, let original = nota.alias.first {
                return Tabla.Fila(nota, original, alias: [nota.nombre], variantes: nota.variantes)
            }
            return Tabla.Fila(nota, nota.nombre, alias: nota.alias, variantes: nota.variantes)
        }
        return Tabla(escritas + generadas)
    }
}

extension NotaConNombre: ElementoDelCatalogo {
    package static var nombresTraducidos: Traducido<NombresDeNotas.Tabla> { NombresDeNotas.traducidos }
    package static var indiceDeNombres: [String: NotaConNombre] { NombresDeNotas.indice }
}
