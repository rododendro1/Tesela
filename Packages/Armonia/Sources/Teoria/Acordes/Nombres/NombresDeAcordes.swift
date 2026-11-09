// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos

// MARK: - Nombres de los acordes del catálogo
//
// Un idioma por fichero, como los de las progresiones: `NombresDeAcordes+Catalan.swift`, `…+Ingles.swift`… Cada uno
// da el nombre de cada acorde de `AcordeConNombre.catalogo`, que nombra por su miembro (`.init(.dominanteSeptima,
// "…")`: si se renombra o se quita, no compila) y, si los tiene, sus otros nombres (alias) y otras formas de
// escribirlos (variantes). El español sale del propio catálogo. La tabla de cada idioma es un `NombresDelCatalogo`
// (`Textos/NombresDelCatalogo.swift`); un idioma nuevo es un fichero más y su fila en `traducidos`. Que cada fichero
// dé todos los acordes lo comprueban las pruebas (`AcordeConNombreTests`).

/// Los nombres de los acordes del catálogo en los trece idiomas.
package enum NombresDeAcordes {
    /// La tabla de un idioma.
    package typealias Tabla = NombresDelCatalogo<AcordeConNombre>

    /// Los nombres en los trece idiomas.
    package static let traducidos = Traducido<Tabla>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)

    /// Los nombres en un idioma.
    package static func de(_ idioma: Idioma) -> Tabla { traducidos.texto(en: idioma) }

    /// El español sale del catálogo: el nombre de cada acorde, sus alias y sus variantes.
    static let espanol = Tabla.delCatalogo

    /// Nombre, alias o variante normalizados → el acorde, en cualquier idioma.
    static let indice = Tabla.indice(de: traducidos)
}

extension AcordeConNombre: ElementoDelCatalogo {
    package static var nombresTraducidos: Traducido<NombresDeAcordes.Tabla> { NombresDeAcordes.traducidos }
    package static var indiceDeNombres: [String: AcordeConNombre] { NombresDeAcordes.indice }
}
