// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos

// MARK: - Nombres de los ritmos del catálogo
//
// Un idioma por fichero, como los de los acordes y las progresiones: `NombresDeRitmos+Catalan.swift`, `…+Ingles.swift`…
// Cada uno da el nombre de cada ritmo de `RitmoConNombre.catalogo`, que nombra por su miembro (`.init(.claveDeSon,
// "…")`: si se renombra o se quita, no compila) y, si los tiene, sus alias y sus variantes. El español sale del propio
// catálogo. Los nombres de los tāla, los iqa'at y los usul se escriben igual en todos los idiomas, como los de las
// escalas de otras tradiciones. Que cada fichero dé todos los ritmos lo comprueban las pruebas (`RitmoConNombreTests`).

/// Los nombres de los ritmos del catálogo en los trece idiomas.
package enum NombresDeRitmos {
    /// La tabla de un idioma.
    package typealias Tabla = NombresDelCatalogo<RitmoConNombre>

    /// Los nombres en los trece idiomas.
    package static let traducidos = Traducido<Tabla>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)

    /// Los nombres en un idioma.
    package static func de(_ idioma: Idioma) -> Tabla { traducidos.texto(en: idioma) }

    /// El español sale del catálogo: el nombre de cada ritmo, sus alias y sus variantes.
    static let espanol = Tabla.delCatalogo

    /// Nombre, alias o variante normalizados → el ritmo, en cualquier idioma.
    static let indice = Tabla.indice(de: traducidos)
}

extension RitmoConNombre: ElementoDelCatalogo {
    package static var nombresTraducidos: Traducido<NombresDeRitmos.Tabla> { NombresDeRitmos.traducidos }
    package static var indiceDeNombres: [String: RitmoConNombre] { NombresDeRitmos.indice }
}
