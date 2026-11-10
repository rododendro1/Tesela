import Elementos

// MARK: - RitmoConNombre

/// Un ritmo del catálogo: un ciclo de pulsos con los que suenan, como lo escribe Toussaint (*The Geometry of Musical
/// Rhythm*, 2013) en la «notación de caja»: `x` es un golpe fuerte (el dum de los iqa'at, la palmada de los tala, el
/// acento del compás flamenco), `o` uno débil (el tek, la onda del khali, los tiempos sin acento) y `.` un pulso que
/// no suena.
///
///     RitmoConNombre.claveDeSon.patron            // "x..x..x...x.x..."
///     RitmoConNombre.claveDeSon.ataques           // [0, 3, 6, 10, 12]
///     RitmoConNombre.claveDeSon.intervalos        // [3, 3, 4, 2, 4]
///     RitmoConNombre.buscar(nombre: "son clave")  // .claveDeSon
///
/// Los nombres en los otros idiomas están en `Ritmos/Nombres/`, un fichero por idioma. Dos ritmos son iguales si se
/// llaman igual y tienen el mismo patrón y la misma agrupación.
public struct RitmoConNombre: Sendable {
    /// El nombre en español: «clave de son».
    public let nombre: String
    /// Otros nombres del ritmo, escritos correctamente.
    public let alias: [String]
    /// Otras formas de escribir el nombre o uno de los alias, que no son otro nombre.
    public let variantes: [String]
    /// Un carácter por pulso: `x` fuerte, `o` débil, `.` en silencio.
    public let patron: String
    /// Cómo se agrupan los pulsos en tiempos: [4, 4, 4, 4] en la clave, [2, 2, 3] en la ruchenitsa, [4, 4, 4, 4] los
    /// vibhāg del tīntāl. Suman ``pulsos``.
    public let agrupacion: [Int]
    /// La figura de cada pulso, por su denominador: 16 si es una semicorchea, 8 una corchea, 4 una negra.
    public let unidad: Int
    /// La familia del ritmo: clave, tala, iqa', usul, aksak…
    public let familia: FamiliaDeRitmo
    /// Dónde se lee el ritmo.
    package let ficha: FichaDelCatalogo

    /// Un ritmo con nombre, del catálogo o fuera de él. Sin agrupación, un solo grupo con todos los pulsos.
    public init(
        nombre: String, patron: String, agrupacion: [Int]? = nil, unidad: Int = 16, familia: FamiliaDeRitmo,
        alias: [String] = [], variantes: [String] = [], referencias: [Referencia] = []
    ) {
        self.nombre = nombre
        self.patron = patron
        self.agrupacion = agrupacion ?? [patron.count]
        self.unidad = unidad
        self.familia = familia
        self.alias = alias
        self.variantes = variantes
        ficha = FichaDelCatalogo(referencias: referencias)
    }

    // MARK: Propiedades

    /// Dónde se lee el ritmo.
    public var referencias: [Referencia] { ficha.referencias }

    /// Los pulsos del ciclo.
    public var pulsos: Int { patron.count }

    /// Lo que suena en cada pulso: `nil` si nada.
    public var golpes: [GolpeDeRitmo?] { patron.map(GolpeDeRitmo.init) }

    /// Los pulsos en que suena, desde 0.
    public var ataques: [Int] { golpes.indices.filter { golpes[$0] != nil } }

    /// Los pulsos que hay de cada ataque al siguiente, dando la vuelta al ciclo: [3, 3, 4, 2, 4] en la clave de son.
    public var intervalos: [Int] {
        let ataques = self.ataques
        guard !ataques.isEmpty else { return [] }
        return ataques.indices.map { i in
            i + 1 < ataques.count ? ataques[i + 1] - ataques[i] : pulsos - ataques[i] + ataques[0]
        }
    }

    /// Los pulsos en que empieza cada tiempo de la agrupación: [0, 4, 8, 12] en la clave.
    public var tiempos: [Int] {
        var inicio = 0
        return agrupacion.map { grupo in
            defer { inicio += grupo }
            return inicio
        }
    }

    /// El nombre en el idioma de la notación, y en su grafía: «clave de son», «son clave»… Un ritmo fuera del
    /// catálogo se llama en todos los idiomas como se escribió.
    public func nombre(en notacion: Notacion) -> String { nombreTraducido(en: notacion) }

    /// El ritmo euclídeo E(k, n) de Bjorklund y Toussaint: `ataques` golpes repartidos lo más uniformemente posible
    /// entre `pulsos`, empezando por uno. E(3, 8) es el tresillo y, girados, E(5, 8) es el cinquillo y E(7, 12), el
    /// bembé.
    ///
    ///     RitmoConNombre.euclideo(ataques: 3, pulsos: 8)   // "x..x..x."
    public static func euclideo(ataques: Int, pulsos: Int) -> String {
        guard pulsos > 0 else { return "" }
        let k = min(max(ataques, 0), pulsos)
        // El de Bresenham: un golpe donde el múltiplo de k pasa de una vuelta de n a la siguiente.
        return String((0..<pulsos).map { i in (i * k) % pulsos < k ? "x" : "." })
    }
}

/// Lo que suena en un pulso de un ritmo.
public enum GolpeDeRitmo: String, Hashable, Sendable, Codable, CaseIterable {
    /// `x`: el dum, la palmada, el acento.
    case fuerte = "x"
    /// `o`: el tek, la onda, el tiempo sin acento.
    case debil = "o"

    init?(_ caracter: Character) { self.init(rawValue: String(caracter)) }
}

extension RitmoConNombre: Hashable {
    public static func == (a: RitmoConNombre, b: RitmoConNombre) -> Bool {
        a.nombre == b.nombre && a.patron == b.patron && a.agrupacion == b.agrupacion
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(nombre)
        hasher.combine(patron)
        hasher.combine(agrupacion)
    }
}

extension RitmoConNombre: Identifiable {
    /// El nombre en español, que no se repite en el catálogo.
    public var id: String { nombre }
}

extension RitmoConNombre: Nombrable, CustomStringConvertible {
    public var description: String { nombre }
}

// MARK: - Búsqueda por nombre

extension RitmoConNombre {
    /// El ritmo del catálogo con ese nombre, alias o variante en cualquier idioma, sin mirar mayúsculas, tildes,
    /// guiones ni espacios: «clave de son», «son clave», «tintal», «tīntāl».
    public static func buscar(nombre: String) -> RitmoConNombre? { buscarNombre(nombre) }

    /// Los del catálogo cuyo nombre, alias o variante contiene el texto en algún idioma, en el orden del catálogo:
    /// «clave» da todas las claves.
    public static func buscar(conteniendo texto: String) -> [RitmoConNombre] { buscarConteniendo(texto) }

    /// Los del catálogo de una familia, en su orden.
    public static func todos(de familia: FamiliaDeRitmo) -> [RitmoConNombre] {
        catalogo.filter { $0.familia == familia }
    }
}

// MARK: - Familias

/// La familia de un ritmo del catálogo: de dónde viene y cómo se cuenta.
public enum FamiliaDeRitmo: String, Hashable, Sendable, Codable, CaseIterable, Nombrable {
    /// Las líneas de tiempo del Caribe y del África occidental: el tresillo, las claves, el bembé.
    case lineaDeTiempo
    /// Los compases del flamenco: la soleá, la bulería, la seguiriya.
    case flamenco
    /// Los tāla de la India, con sus vibhāg: tīntāl, ektāl, jhaptāl, rūpak, ādi.
    case tala
    /// Los iqa'at del mundo árabe, con su dum y su tek: maqsum, baladi, saidi.
    case iqa
    /// Los usul de la música turca y los ritmos aksak de los Balcanes, de tiempos desiguales.
    case aksak
    /// Los seis modos rítmicos de la escuela de Notre Dame, de longas y breves.
    case modoRitmico
    /// Las danzas europeas y americanas: el vals, la polonesa, la siciliana, el charleston.
    case danza

    /// «líneas de tiempo», «timelines»…
    public func nombre(en notacion: Notacion) -> String {
        let traduccion: Traduccion
        switch self {
        case .lineaDeTiempo:
            traduccion = Traduccion(
                "líneas de tiempo", "timelines", ca: "línies de temps", gl: "liñas de tempo", eu: "denbora-lerroak",
                pt: "linhas-guia", fr: "lignes de temps", it: "linee del tempo", de: "Timelines",
                el: "ρυθμικές γραμμές", ru: "тайм-лайны", hu: "időminták", sv: "tidslinjer")
        case .flamenco:
            traduccion = Traduccion(
                "compases flamencos", "flamenco compás", ca: "compassos flamencs", gl: "compases flamencos",
                eu: "flamenko konpasak", pt: "compassos flamencos", fr: "compás flamencos", it: "compás del flamenco",
                de: "Flamenco-Compás", el: "κομπάς του φλαμένκο", ru: "компасы фламенко", hu: "flamenco compások",
                sv: "flamencons compás")
        case .tala:
            traduccion = Traduccion(
                "tāla de la India", "Indian tālas", ca: "tāla de l'Índia", gl: "tāla da India", eu: "Indiako tālak",
                pt: "tālas da Índia", fr: "tālas indiens", it: "tāla indiani", de: "indische Tālas",
                el: "ινδικές τάλα", ru: "индийские талы", hu: "indiai tálák", sv: "indiska tālor")
        case .iqa:
            traduccion = Traduccion(
                "iqa'at árabes", "Arabic iqa'at", ca: "iqa'at àrabs", gl: "iqa'at árabes", eu: "iqa'at arabiarrak",
                pt: "iqa'at árabes", fr: "iqa'at arabes", it: "iqa'at arabi", de: "arabische Iqa'at",
                el: "αραβικά ικά", ru: "арабские ика", hu: "arab iqa'at", sv: "arabiska iqa'at")
        case .aksak:
            traduccion = Traduccion(
                "aksak y usul", "aksak and usul", ca: "aksak i usul", gl: "aksak e usul", eu: "aksak eta usul",
                pt: "aksak e usul", fr: "aksak et usul", it: "aksak e usul", de: "Aksak und Usul",
                el: "ακσάκ και ουσούλ", ru: "аксак и усуль", hu: "aksak és usul", sv: "aksak och usul")
        case .modoRitmico:
            traduccion = Traduccion(
                "modos rítmicos", "rhythmic modes", ca: "modes rítmics", gl: "modos rítmicos", eu: "modu erritmikoak",
                pt: "modos rítmicos", fr: "modes rythmiques", it: "modi ritmici", de: "rhythmische Modi",
                el: "ρυθμικοί τρόποι", ru: "ритмические модусы", hu: "ritmikai modusok", sv: "rytmiska modi")
        case .danza:
            traduccion = Traduccion(
                "danzas", "dances", ca: "danses", gl: "danzas", eu: "dantzak", pt: "danças", fr: "danses",
                it: "danze", de: "Tänze", el: "χοροί", ru: "танцы", hu: "táncok", sv: "danser")
        }
        return traduccion.en(notacion)
    }
}
