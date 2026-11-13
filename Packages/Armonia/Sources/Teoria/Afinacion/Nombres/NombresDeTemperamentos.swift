// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos

// MARK: - Nombres de los temperamentos del catálogo
//
// Un idioma por fichero, como los de los acordes, las progresiones y los ritmos:
// `NombresDeTemperamentos+Catalan.swift`, `…+Ingles.swift`… Cada uno da el nombre de cada temperamento de
// `TemperamentoConNombre.catalogo`, que nombra por su miembro (`.init(.vallotti, "…")`: si se renombra o se quita, no
// compila) y, si los tiene, sus alias y sus variantes. El español sale del propio catálogo. Que cada fichero dé todos
// los temperamentos lo comprueban las pruebas (`TemperamentoConNombreTests`).

/// Los nombres de los temperamentos del catálogo en los trece idiomas.
package enum NombresDeTemperamentos {
    /// La tabla de un idioma.
    package typealias Tabla = NombresDelCatalogo<TemperamentoConNombre>

    /// Los nombres en los trece idiomas.
    package static let traducidos = Traducido<Tabla>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)

    /// Los nombres en un idioma.
    package static func de(_ idioma: Idioma) -> Tabla { traducidos.texto(en: idioma) }

    /// El español sale del catálogo: el nombre de cada temperamento, sus alias y sus variantes.
    static let espanol = Tabla.delCatalogo

    /// Nombre, alias o variante normalizados → el temperamento, en cualquier idioma.
    static let indice = Tabla.indice(de: traducidos)
}

extension TemperamentoConNombre: ElementoDelCatalogo {
    package static var nombresTraducidos: Traducido<NombresDeTemperamentos.Tabla> { NombresDeTemperamentos.traducidos }
    package static var indiceDeNombres: [String: TemperamentoConNombre] { NombresDeTemperamentos.indice }
}
