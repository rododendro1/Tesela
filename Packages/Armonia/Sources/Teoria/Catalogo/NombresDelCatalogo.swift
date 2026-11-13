import Elementos

// MARK: - Nombres de un catálogo en los trece idiomas
//
// Los acordes con nombre y las progresiones con nombre se traducen igual: un fichero por idioma con una fila por
// elemento del catálogo (`.init(.dominanteSeptima, "dominant seventh")`), que lo nombra por su miembro (si se
// renombra o se quita, no compila), y el español sacado del propio catálogo. `NombresDelCatalogo` es la tabla de un
// idioma, y `ElementoDelCatalogo`, lo que comparten los dos tipos para traducirse y buscarse por el nombre. Las
// escalas tienen su propia tabla (`NombresDeEscalas`), porque las de otras tradiciones se buscan por su identidad y
// heredan sus alias.

/// Un elemento de un catálogo con nombres en los trece idiomas: `AcordeConNombre` o `ProgresionConNombre`.
package protocol ElementoDelCatalogo: Hashable, Sendable {
    /// El nombre en español.
    var nombre: String { get }
    /// Otros nombres en español.
    var alias: [String] { get }
    /// Otras formas de escribir el nombre o uno de los alias.
    var variantes: [String] { get }
    /// Todo el catálogo, en su orden.
    static var catalogo: [Self] { get }
    /// Los nombres en cada idioma.
    static var nombresTraducidos: Traducido<NombresDelCatalogo<Self>> { get }
    /// Nombre, alias o variante normalizados (`NombresDelCatalogo.normalizar(_:)`) → el elemento, en cualquier idioma:
    /// `NombresDelCatalogo.indice(de:)`, guardado en un `static let` de cada tipo.
    static var indiceDeNombres: [String: Self] { get }
}

/// Los nombres de los elementos de un catálogo en un idioma.
package struct NombresDelCatalogo<Elemento: ElementoDelCatalogo>: Sendable {
    /// Una fila de un fichero de idioma: el elemento, su nombre y los alias y las variantes con que también se conoce.
    package struct Fila: Sendable {
        package let elemento: Elemento
        package let nombre: String
        package let alias: [String]
        package let variantes: [String]

        init(_ elemento: Elemento, _ nombre: String, alias: [String] = [], variantes: [String] = []) {
            self.elemento = elemento
            self.nombre = nombre
            self.alias = alias
            self.variantes = variantes
        }

        /// El nombre, los alias y las variantes, en ese orden.
        var textos: [String] { [nombre] + alias + variantes }
    }

    /// Las filas del fichero, en su orden.
    package let filas: [Fila]

    /// Elemento → su fila. Si un elemento está dos veces, vale la primera.
    private let porElemento: [Elemento: Fila]

    init(_ filas: [Fila]) {
        var porElemento: [Elemento: Fila] = [:]
        for fila in filas where porElemento[fila.elemento] == nil { porElemento[fila.elemento] = fila }
        self.filas = filas
        self.porElemento = porElemento
    }

    /// El nombre de un elemento en este idioma, o `nil` si no es del catálogo.
    package func nombre(de elemento: Elemento) -> String? { porElemento[elemento]?.nombre }

    /// Los alias de un elemento en este idioma.
    package func alias(de elemento: Elemento) -> [String] { porElemento[elemento]?.alias ?? [] }

    /// Las variantes de un elemento en este idioma.
    package func variantes(de elemento: Elemento) -> [String] { porElemento[elemento]?.variantes ?? [] }

    /// El español, que sale del catálogo: el nombre de cada elemento, sus alias y sus variantes.
    static var delCatalogo: NombresDelCatalogo {
        NombresDelCatalogo(Elemento.catalogo.map { Fila($0, $0.nombre, alias: $0.alias, variantes: $0.variantes) })
    }

    // MARK: Búsqueda

    /// Un nombre para comparar: `String.normalizadoParaBuscar(conEspacios: false)`, sin espacios, guiones, rayas,
    /// apóstrofos ni puntos («ii–V–I», «ii-V-I» y «II V I» son lo mismo).
    package static func normalizar(_ texto: String) -> String { texto.normalizadoParaBuscar(conEspacios: false) }

    /// Nombre, alias o variante normalizados → el elemento, en cualquier idioma. Si dos coinciden, vale el del primer
    /// idioma de `Idioma.allCases` que lo tenga (el español y el inglés primero).
    static func indice(de traducidos: Traducido<NombresDelCatalogo>) -> [String: Elemento] {
        var indice: [String: Elemento] = [:]
        for idioma in Idioma.allCases {
            for fila in traducidos.texto(en: idioma).filas {
                for texto in fila.textos where indice[normalizar(texto)] == nil {
                    indice[normalizar(texto)] = fila.elemento
                }
            }
        }
        return indice
    }
}

extension ElementoDelCatalogo {
    /// Los nombres del catálogo en un idioma.
    package static func nombres(en idioma: Idioma) -> NombresDelCatalogo<Self> { nombresTraducidos.texto(en: idioma) }

    /// Todos los nombres, alias y variantes del elemento en los trece idiomas, normalizados.
    package var claves: [String] {
        Idioma.allCases.flatMap { idioma -> [String] in
            let nombres = Self.nombres(en: idioma)
            guard let nombre = nombres.nombre(de: self) else { return [] }
            return ([nombre] + nombres.alias(de: self) + nombres.variantes(de: self))
                .map(NombresDelCatalogo<Self>.normalizar)
        }
    }

    /// El nombre en el idioma de la notación, y en su grafía. Un elemento fuera del catálogo se llama en todos los
    /// idiomas como se escribió.
    package func nombreTraducido(en notacion: Notacion) -> String {
        notacion.enSuGrafia(Self.nombres(en: notacion.textos).nombre(de: self) ?? nombre)
    }

    /// Los alias en el idioma de la notación, y en su grafía: los del catálogo en español; vacío fuera del catálogo.
    package func aliasTraducidos(en notacion: Notacion) -> [String] {
        Self.nombres(en: notacion.textos).alias(de: self).map(notacion.enSuGrafia)
    }

    /// Las variantes en el idioma de la notación, y en su grafía.
    package func variantesTraducidas(en notacion: Notacion) -> [String] {
        Self.nombres(en: notacion.textos).variantes(de: self).map(notacion.enSuGrafia)
    }

    /// El del catálogo con ese nombre, alias o variante en cualquier idioma, sin mirar mayúsculas, tildes, espacios,
    /// guiones ni rayas.
    package static func buscarNombre(_ nombre: String) -> Self? {
        indiceDeNombres[NombresDelCatalogo<Self>.normalizar(nombre)]
    }

    /// Los del catálogo cuyo nombre, alias o variante contiene el texto en algún idioma, en el orden del catálogo;
    /// todos, si el texto está vacío.
    package static func buscarConteniendo(_ texto: String) -> [Self] {
        let buscado = NombresDelCatalogo<Self>.normalizar(texto)
        guard !buscado.isEmpty else { return catalogo }
        return catalogo.filter { elemento in elemento.claves.contains { $0.contains(buscado) } }
    }
}
