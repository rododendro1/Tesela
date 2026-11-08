// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos

// MARK: - Nombres de los acordes del catálogo
//
// Un idioma por fichero, como los de las escalas: `NombresDeAcordes+Catalan.swift`, `…+Ingles.swift`… Cada uno da el
// nombre de cada acorde de `AcordeConNombre.catalogo`, que nombra por su miembro (`.init(.dominanteSeptima, "…")`: si
// se renombra o se quita, no compila) y, si los tiene, sus otros nombres (alias) y otras formas de escribirlos
// (variantes). El español sale del propio catálogo (`AcordeConNombre.nombre`, `alias` y `variantes`). Un idioma
// nuevo es un fichero más y su fila en `traducidos`. Que cada fichero dé todos los acordes lo comprueban las pruebas
// (`AcordeConNombreTests`).

/// Los nombres de los acordes del catálogo en un idioma.
package struct NombresDeAcordes: Sendable {
    /// Una fila de un fichero de idioma: el acorde, su nombre y los alias y las variantes con que también se conoce.
    package struct Fila: Sendable {
        let acorde: AcordeConNombre
        let nombre: String
        let alias: [String]
        let variantes: [String]

        init(_ acorde: AcordeConNombre, _ nombre: String, alias: [String] = [], variantes: [String] = []) {
            self.acorde = acorde
            self.nombre = nombre
            self.alias = alias
            self.variantes = variantes
        }
    }

    /// Nombre, alias y variantes de un acorde en este idioma.
    package struct Entrada: Sendable {
        package let nombre: String
        package let alias: [String]
        package let variantes: [String]
    }

    /// Las filas del fichero, en su orden.
    package let filas: [Fila]

    /// Acorde → su nombre, sus alias y sus variantes. Si un acorde está dos veces, vale la primera fila.
    package let porAcorde: [AcordeConNombre: Entrada]

    init(_ filas: [Fila]) {
        var porAcorde: [AcordeConNombre: Entrada] = [:]
        for fila in filas where porAcorde[fila.acorde] == nil {
            porAcorde[fila.acorde] = Entrada(nombre: fila.nombre, alias: fila.alias, variantes: fila.variantes)
        }
        self.filas = filas
        self.porAcorde = porAcorde
    }

    /// El nombre de un acorde en este idioma, o `nil` si no es del catálogo.
    package func nombre(de acorde: AcordeConNombre) -> String? { porAcorde[acorde]?.nombre }

    /// Los nombres en los trece idiomas.
    package static let traducidos = Traducido<NombresDeAcordes>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)

    /// Los nombres en un idioma.
    package static func de(_ idioma: Idioma) -> NombresDeAcordes { traducidos.texto(en: idioma) }

    /// El español sale del catálogo: el nombre de cada acorde, sus alias y sus variantes.
    static let espanol = NombresDeAcordes(
        AcordeConNombre.catalogo.map { Fila($0, $0.nombre, alias: $0.alias, variantes: $0.variantes) })
}
