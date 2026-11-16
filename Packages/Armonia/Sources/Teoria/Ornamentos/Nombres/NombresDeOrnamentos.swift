// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos

// MARK: - Nombres de los ornamentos del catálogo
//
// Un idioma por fichero, como los de las notas y los temperamentos: `NombresDeOrnamentos+Catalan.swift`,
// `…+Ingles.swift`… Cada uno da el nombre de cada ornamento de `OrnamentoConNombre.catalogo`, que nombra por su miembro
// (`.init(.trino, "…")`: si se renombra o se quita, no compila) y, si los tiene, sus alias y sus variantes. El español
// sale del propio catálogo.

/// Los nombres de los ornamentos del catálogo en los trece idiomas.
package enum NombresDeOrnamentos {
    /// La tabla de un idioma.
    package typealias Tabla = NombresDelCatalogo<OrnamentoConNombre>

    /// Los nombres en los trece idiomas.
    package static let traducidos = Traducido<Tabla>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)

    /// Los nombres en un idioma.
    package static func de(_ idioma: Idioma) -> Tabla { traducidos.texto(en: idioma) }

    /// El español sale del catálogo: el nombre de cada ornamento, sus alias y sus variantes.
    static let espanol = Tabla.delCatalogo

    /// Nombre, alias o variante normalizados → el ornamento, en cualquier idioma.
    static let indice = Tabla.indice(de: traducidos)
}

extension OrnamentoConNombre: ElementoDelCatalogo {
    package static var nombresTraducidos: Traducido<NombresDeOrnamentos.Tabla> { NombresDeOrnamentos.traducidos }
    package static var indiceDeNombres: [String: OrnamentoConNombre] { NombresDeOrnamentos.indice }
}
