// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos

// MARK: - Nombres de las progresiones del catálogo
//
// Un idioma por fichero, como los de los acordes: `NombresDeProgresiones+Catalan.swift`, `…+Ingles.swift`… Cada uno da
// el nombre de cada progresión de `ProgresionConNombre.catalogo`, que nombra por su miembro (`.init(.andaluza, "…")`:
// si se renombra o se quita, no compila) y, si los tiene, sus alias y sus variantes. El español sale del propio
// catálogo. La tabla de cada idioma es un `NombresDelCatalogo` (`Textos/NombresDelCatalogo.swift`). Que cada fichero
// dé todas las progresiones lo comprueban las pruebas (`ProgresionConNombreTests`).

/// Los nombres de las progresiones del catálogo en los trece idiomas.
package enum NombresDeProgresiones {
    /// La tabla de un idioma.
    package typealias Tabla = NombresDelCatalogo<ProgresionConNombre>

    /// Los nombres en los trece idiomas.
    package static let traducidos = Traducido<Tabla>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)

    /// Los nombres en un idioma.
    package static func de(_ idioma: Idioma) -> Tabla { traducidos.texto(en: idioma) }

    /// El español sale del catálogo: el nombre de cada progresión, sus alias y sus variantes.
    static let espanol = Tabla.delCatalogo

    /// Nombre, alias o variante normalizados → la progresión, en cualquier idioma.
    static let indice = Tabla.indice(de: traducidos)
}

extension ProgresionConNombre: ElementoDelCatalogo {
    package static var nombresTraducidos: Traducido<NombresDeProgresiones.Tabla> { NombresDeProgresiones.traducidos }
    package static var indiceDeNombres: [String: ProgresionConNombre] { NombresDeProgresiones.indice }
}
