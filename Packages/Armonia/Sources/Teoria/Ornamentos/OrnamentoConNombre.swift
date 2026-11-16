import Elementos

// MARK: - OrnamentoConNombre

/// Un ornamento con nombre: el trino, el mordente, el grupeto, las apoyaturas, el Schleifer… Se escribe como los pasos
/// por grados de la escala desde la nota principal (0), en el orden en que suenan, como los dan las tablas de J. S. Bach
/// y de C. P. E. Bach.
///
///     OrnamentoConNombre.mordente.pasos                                       // [0, -1, 0]
///     OrnamentoConNombre.grupeto.alturas(sobre: Altura(.re, octava: 4), en: Escala(.do, .mayor))
///                                                                             // Mi4 Re4 Do4 Re4
///     OrnamentoConNombre.buscar(nombre: "turn")                               // .grupeto
///
/// Los nombres en los otros idiomas están en `Ornamentos/Nombres/`, un fichero por idioma. Dos ornamentos son iguales si
/// se llaman igual.
public struct OrnamentoConNombre: Sendable {
    /// El nombre en español: «trino», «mordente», «grupeto».
    public let nombre: String
    /// Otros nombres, escritos correctamente.
    public let alias: [String]
    /// Otras formas de escribir el nombre o uno de los alias, que no son otro nombre.
    public let variantes: [String]
    /// Los pasos por grados de la escala desde la nota principal, en el orden en que suenan: 1 es la nota de arriba y −1
    /// la de abajo.
    public let pasos: [Int]
    /// Dónde se lee y la obra más antigua que lo da.
    package let datos: DatosDelCatalogo

    package init(
        nombre: String, pasos: [Int], alias: [String] = [], variantes: [String] = [], referencias: [Referencia] = [],
        documentada: Referencia? = nil, estilos: [Estilo] = [.clasica]
    ) {
        self.nombre = nombre
        self.pasos = pasos
        self.alias = alias
        self.variantes = variantes
        datos = DatosDelCatalogo(estilos: estilos, referencias: referencias, documentada: documentada)
    }

    /// Dónde se lee.
    public var referencias: [Referencia] { datos.referencias }

    /// Los estilos en que se usa.
    public var estilos: [Estilo] { datos.estilos }

    /// Las alturas que suenan sobre una nota principal de la escala, por los grados de la escala: el grupeto sobre Re4
    /// en Do mayor es Mi4 Re4 Do4 Re4. `nil` si la nota principal no está en la escala.
    public func alturas(sobre principal: Altura, en escala: Escala) -> [Altura]? {
        let intervalos = escala.tipo.intervalos
        let alcance = (pasos.map(abs).max() ?? 0) / max(intervalos.count, 1) + 1
        let octavas = (principal.octava - alcance - 1)...(principal.octava + alcance + 1)
        let alturas = octavas.flatMap { octava in
            intervalos.map { Altura(escala.tonica, octava: octava) + $0 }
        }
        guard let indice = alturas.firstIndex(of: principal) else { return nil }
        return pasos.map { alturas[indice + $0] }
    }

    /// El nombre en el idioma de la notación: «trino», «trill»… Un ornamento fuera del catálogo se llama en todos los
    /// idiomas como se escribió.
    public func nombre(en notacion: Notacion) -> String { nombreTraducido(en: notacion) }

    /// Los otros nombres del ornamento en el idioma de la notación, como `nombre(en:)`; vacío si no tiene.
    public func alias(en notacion: Notacion) -> [String] { aliasTraducidos(en: notacion) }

    /// Las otras formas de escribir su nombre o un alias en el idioma de la notación; vacío si no tiene.
    public func variantes(en notacion: Notacion) -> [String] { variantesTraducidas(en: notacion) }
}

extension OrnamentoConNombre: Hashable {
    public static func == (a: OrnamentoConNombre, b: OrnamentoConNombre) -> Bool { a.nombre == b.nombre }
    public func hash(into hasher: inout Hasher) { hasher.combine(nombre) }
}

// MARK: - Búsqueda por nombre

extension OrnamentoConNombre {
    /// El del catálogo con ese nombre, alias o variante en cualquier idioma, sin mirar mayúsculas, tildes, guiones ni
    /// espacios: «trino», «turn», «Pralltriller».
    public static func buscar(nombre: String) -> OrnamentoConNombre? { buscarNombre(nombre) }

    /// Los del catálogo cuyo nombre, alias o variante contiene el texto en algún idioma, en el orden del catálogo:
    /// «trino» da los tres trinos.
    public static func buscar(conteniendo texto: String) -> [OrnamentoConNombre] { buscarConteniendo(texto) }
}
