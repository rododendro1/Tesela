import Elementos

// MARK: - ProgresionConNombre

/// Una progresión del catálogo: un nombre y sus acordes en cifrado romano, para realizarla en cualquier tonalidad.
///
/// Los acordes se escriben como los lee `Tonalidad.acordes(romanos:)` («ii7 V7 Imaj7», «i VII VI V», «V7/IV IV»),
/// en el modo de la progresión: la cadencia andaluza es «i VII VI V» en menor.
///
///     ProgresionConNombre.iiVI.cifrado                          // "ii7 V7 Imaj7"
///     ProgresionConNombre.iiVI.acordes(sobre: .do)              // [Rem7, Sol7, Domaj7]
///     ProgresionConNombre.andaluza.acordes(sobre: .la)          // [Lam, Sol, Fa, Mi]
///     ProgresionConNombre.andaluza.nombre(en: .conPalabras(.ingles))   // "Andalusian cadence"
///     ProgresionConNombre.buscar(nombre: "Andalusian cadence")  // .andaluza
///
/// Los nombres en los otros idiomas están en `Progresiones/Nombres/`, un fichero por idioma. Dos progresiones son
/// iguales si se llaman igual y tienen el mismo cifrado en el mismo modo; los estilos y las referencias no cuentan.
public struct ProgresionConNombre: Sendable {
    /// El nombre en español: «cadencia andaluza».
    public let nombre: String
    /// Otros nombres de la progresión, escritos correctamente.
    public let alias: [String]
    /// Otras formas de escribir el nombre o uno de los alias, que no son otro nombre.
    public let variantes: [String]
    /// Los acordes en cifrado romano, separados por espacios: «ii7 V7 Imaj7».
    public let cifrado: String
    /// El modo en que se leen los grados: «i VII VI V» es la andaluza en menor.
    public let modo: Tonalidad.Modo
    /// Lo demás que sabe el catálogo de la progresión: sus estilos y sus referencias.
    package let datos: DatosDelCatalogo

    /// Una progresión del catálogo, sin comprobar el cifrado: lo comprueban sus pruebas. Fuera del catálogo se crea con
    /// `init(nombre:leyendo:modo:alias:variantes:estilos:referencias:documentada:)`, que lo lee.
    package init(
        nombre: String, cifrado: String, modo: Tonalidad.Modo = .mayor, alias: [String] = [], variantes: [String] = [],
        estilos: [Estilo] = [], referencias: [Referencia] = [], documentada: Referencia? = nil
    ) {
        self.nombre = nombre
        self.cifrado = cifrado
        self.modo = modo
        self.alias = alias
        self.variantes = variantes
        self.datos = DatosDelCatalogo(estilos: estilos, referencias: referencias, documentada: documentada)
    }

    /// Una progresión con nombre, del catálogo o fuera de él, comprobando que su cifrado se lee en su modo: lanza el
    /// error de `Tonalidad.acordes(romanos:)` si no. Así, una progresión siempre tiene acordes. `documentada` es la
    /// obra más antigua que la da, con su año, y va también entre sus referencias.
    ///
    ///     try ProgresionConNombre(nombre: "mía", leyendo: "I ♭VII IV I")   // bien
    ///     try ProgresionConNombre(nombre: "mía", leyendo: "I X I")          // lanza un error
    public init(
        nombre: String, leyendo cifrado: String, modo: Tonalidad.Modo = .mayor, alias: [String] = [],
        variantes: [String] = [], estilos: [Estilo] = [], referencias: [Referencia] = [],
        documentada: Referencia? = nil
    ) throws {
        _ = try Tonalidad(.do, modo).acordes(romanos: cifrado)
        self.init(
            nombre: nombre, cifrado: cifrado, modo: modo, alias: alias, variantes: variantes, estilos: estilos,
            referencias: referencias, documentada: documentada)
    }

    // MARK: Propiedades

    /// En qué estilos se usa, de más a menos importante: el primero es su uso principal.
    public var estilos: [Estilo] { datos.estilos }

    /// Dónde se lee la progresión, con las obras de su carácter.
    public var referencias: [Referencia] { Referencia.unicas(datos.referencias + caracter.map(\.referencia)) }

    /// La obra más antigua que da la progresión, con su año: Riepel (1755) en el monte, la fonte y el ponte; Ortiz
    /// (1553) en el passamezzo y la folía. `nil` si no se sabe.
    public var documentada: Referencia? { datos.documentada }

    /// Los grados, uno por acorde: ["ii7", "V7", "Imaj7"].
    public var grados: [String] { cifrado.split(separator: " ").map(String.init) }

    /// La tonalidad de la progresión con esa tónica, en su modo.
    public func tonalidad(sobre tonica: Nota) -> Tonalidad { Tonalidad(tonica, modo) }

    /// Los acordes en una tonalidad, uno por grado. El cifrado siempre se lee: el de las del catálogo lo comprueban sus
    /// pruebas, y el de una propia, `init(nombre:leyendo:…)` al crearla.
    ///
    ///     ProgresionConNombre.monte.acordes(en: Tonalidad(.do))   // [Do7, Fa, Re7, Sol]
    public func acordes(en tonalidad: Tonalidad) -> [Acorde] { (try? tonalidad.acordes(romanos: cifrado)) ?? [] }

    /// Los acordes con esa tónica, en el modo de la progresión.
    public func acordes(sobre tonica: Nota) -> [Acorde] { acordes(en: tonalidad(sobre: tonica)) }

    /// El nombre en el idioma de la notación, y en su grafía: «cadencia andaluza», «Andalusian cadence»,
    /// «andalusische Kadenz»… Una progresión fuera del catálogo se llama en todos los idiomas como se escribió.
    public func nombre(en notacion: Notacion) -> String { nombreTraducido(en: notacion) }

    /// Los otros nombres de la progresión en el idioma de la notación, como `nombre(en:)`; vacío si no tiene.
    public func alias(en notacion: Notacion) -> [String] { aliasTraducidos(en: notacion) }

    /// Las otras formas de escribir su nombre o un alias en el idioma de la notación; vacío si no tiene.
    public func variantes(en notacion: Notacion) -> [String] { variantesTraducidas(en: notacion) }
}

extension ProgresionConNombre: Hashable {
    public static func == (a: ProgresionConNombre, b: ProgresionConNombre) -> Bool {
        a.nombre == b.nombre && a.cifrado == b.cifrado && a.modo == b.modo
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(nombre)
        hasher.combine(cifrado)
        hasher.combine(modo)
    }
}

// MARK: - Búsqueda por nombre

extension ProgresionConNombre {
    /// La progresión del catálogo con ese nombre, alias o variante en cualquier idioma, sin mirar mayúsculas,
    /// tildes, guiones ni rayas: «cadencia andaluza», «tetracordo andaluz», «Andalusian cadence», «ii-V-I», «II–V–I».
    public static func buscar(nombre: String) -> ProgresionConNombre? { buscarNombre(nombre) }

    /// Las del catálogo cuyo nombre, alias o variante contiene el texto en algún idioma (sin mirar mayúsculas ni
    /// tildes), en el orden del catálogo: «cadencia» da todas las cadencias.
    public static func buscar(conteniendo texto: String) -> [ProgresionConNombre] { buscarConteniendo(texto) }
}
