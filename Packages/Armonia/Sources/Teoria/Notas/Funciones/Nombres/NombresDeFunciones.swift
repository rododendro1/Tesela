// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos

// MARK: - Nombres de las funciones de nota del catálogo
//
// Un idioma por fichero, como los de las notas y los temperamentos: `NombresDeFunciones+Catalan.swift`,
// `…+Ingles.swift`… Cada uno da el nombre de cada función de `FuncionDeNota.catalogo`, que nombra por su miembro
// (`.init(.dominante, "…")`: si se renombra o se quita, no compila) y, si los tiene, sus alias y sus variantes. Los
// grados se llaman como `NombreDeGrado` y las notas extrañas como `NotaExtrana`, y lo comprueban las pruebas. El
// español sale del propio catálogo.

/// Los nombres de las funciones de nota del catálogo en los trece idiomas.
package enum NombresDeFunciones {
    /// La tabla de un idioma.
    package typealias Tabla = NombresDelCatalogo<FuncionDeNota>

    /// Los nombres en los trece idiomas.
    package static let traducidos = Traducido<Tabla>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)

    /// Los nombres en un idioma.
    package static func de(_ idioma: Idioma) -> Tabla { traducidos.texto(en: idioma) }

    /// El español sale del catálogo: el nombre de cada función, sus alias y sus variantes.
    static let espanol = Tabla.delCatalogo

    /// Nombre, alias o variante normalizados → la función, en cualquier idioma.
    static let indice = Tabla.indice(de: traducidos)
}

extension FuncionDeNota: ElementoDelCatalogo {
    package static var nombresTraducidos: Traducido<NombresDeFunciones.Tabla> { NombresDeFunciones.traducidos }
    package static var indiceDeNombres: [String: FuncionDeNota] { NombresDeFunciones.indice }
}
