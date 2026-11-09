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
    /// En qué estilos se usa, en el orden de `EstiloDeEscala.allCases`.
    public let estilos: [EstiloDeEscala]
    /// Dónde se lee la progresión.
    public let referencias: [Referencia]

    /// Una progresión con nombre propio, fuera del catálogo.
    public init(
        nombre: String, cifrado: String, modo: Tonalidad.Modo = .mayor, alias: [String] = [], variantes: [String] = [],
        estilos: [EstiloDeEscala] = [], referencias: [Referencia] = []
    ) {
        self.nombre = nombre
        self.cifrado = cifrado
        self.modo = modo
        self.alias = alias
        self.variantes = variantes
        self.estilos = EstiloDeEscala.allCases.filter(estilos.contains)
        self.referencias = referencias
    }

    // MARK: Propiedades

    /// Los grados, uno por acorde: ["ii7", "V7", "Imaj7"].
    public var grados: [String] { cifrado.split(separator: " ").map(String.init) }

    /// La tonalidad de la progresión con esa tónica, en su modo.
    public func tonalidad(sobre tonica: Nota) -> Tonalidad { Tonalidad(tonica, modo) }

    /// Los acordes en una tonalidad, uno por grado. Vacío si su cifrado no se lee (los del catálogo se leen
    /// todos: lo comprueban las pruebas).
    ///
    ///     ProgresionConNombre.monte.acordes(en: Tonalidad(.do))   // [Do7, Fa, Re7, Sol]
    public func acordes(en tonalidad: Tonalidad) -> [Acorde] { (try? tonalidad.acordes(romanos: cifrado)) ?? [] }

    /// Los acordes con esa tónica, en el modo de la progresión.
    public func acordes(sobre tonica: Nota) -> [Acorde] { acordes(en: tonalidad(sobre: tonica)) }

    /// El nombre en el idioma de la notación, y en su grafía: «cadencia andaluza», «Andalusian cadence»,
    /// «andalusische Kadenz»… Una progresión fuera del catálogo se llama en todos los idiomas como se escribió.
    public func nombre(en notacion: Notacion) -> String {
        notacion.enSuGrafia(NombresDeProgresiones.de(notacion.textos).nombre(de: self) ?? nombre)
    }
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

extension ProgresionConNombre: Identifiable {
    /// El nombre en español, que no se repite en el catálogo.
    public var id: String { nombre }
}

extension ProgresionConNombre: Nombrable, CustomStringConvertible {
    public var description: String { nombre }
}

// MARK: - Búsqueda por nombre

extension ProgresionConNombre {
    /// La progresión del catálogo con ese nombre, alias o variante en cualquier idioma, sin mirar mayúsculas,
    /// tildes, guiones ni rayas: «cadencia andaluza», «tetracordo andaluz», «Andalusian cadence», «ii-V-I», «II–V–I».
    public static func buscar(nombre: String) -> ProgresionConNombre? {
        NombresDeProgresiones.indice[NombresDeProgresiones.normalizar(nombre)]
    }

    /// Las del catálogo cuyo nombre, alias o variante contiene el texto en algún idioma (sin mirar mayúsculas ni
    /// tildes), en el orden del catálogo: «cadencia» da todas las cadencias.
    public static func buscar(conteniendo texto: String) -> [ProgresionConNombre] {
        let buscado = NombresDeProgresiones.normalizar(texto)
        guard !buscado.isEmpty else { return catalogo }
        return catalogo.filter { progresion in
            NombresDeProgresiones.claves(de: progresion).contains { $0.contains(buscado) }
        }
    }
}
