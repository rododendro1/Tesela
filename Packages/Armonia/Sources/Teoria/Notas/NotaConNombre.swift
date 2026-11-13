import Elementos
import Foundation

// MARK: - NotaConNombre

/// Una nota con nombre propio del catálogo: los diapasones (el La 440, el La 415 barroco, el Do 256 científico), las
/// notas de referencia (el Do central, las notas extremas del piano y del MIDI), las posiciones de la mano guidoniana
/// (Γ ut, C fa ut…) y las alturas con nombre de otras tradiciones: las notas árabes (Rāst, Sīkāh), las perde turcas
/// (Segâh) y las cuerdas del sistema perfecto griego (mésē). Cada una con su altura, lo que se aparta de la temperada
/// en cents y su frecuencia.
///
///     NotaConNombre.la415.frecuencia                         // 415
///     NotaConNombre.buscar(nombre: "middle C")               // .doCentral
///     NotaConNombre.buscar(nombre: "Sīkāh")?.desvio          // -50
///
/// Los nombres en los otros idiomas están en `Notas/Nombres/`, un fichero por idioma; los de las posiciones y las
/// tradiciones son los mismos en todos (en griego, las cuerdas griegas se escriben en su grafía). Dos notas son
/// iguales si se llaman igual.
public struct NotaConNombre: Sendable {
    /// El nombre en español: «La 440», «Do central», «Sīkāh».
    public let nombre: String
    /// Otros nombres, escritos correctamente: «diapasón barroco», «سيكاه».
    public let alias: [String]
    /// Otras formas de escribir el nombre o uno de los alias, que no son otro nombre: «Sikah».
    public let variantes: [String]
    /// La familia: diapasón, nota de referencia, posición guidoniana, nota árabe, perde turca o cuerda griega.
    public let familia: FamiliaDeNota
    /// La altura como se escribe: La4 en los diapasones, Mi4 en Sīkāh (un cuarto de tono bajo Mi); en las posiciones
    /// guidonianas dobles, la del fa (Si♭).
    public let altura: Altura
    /// Lo que se aparta en cents de `altura` temperada: −50 en Sīkāh; −13,2 en Segâh (Si4 una koma bajo, en comas
    /// de 1200/53 cents sobre la pitagórica); 0 en las demás.
    public let desvio: Double
    /// La frecuencia del La4 con que suena: la del diapasón en los diapasones; 440 en las demás.
    public let frecuenciaDelLa4: Double
    /// La altura con nombre de su tradición (`NombresPorOctava`), en las árabes, las turcas y las griegas.
    public let alturaConNombre: AlturaConNombre?
    /// La posición de la mano guidoniana, en las guidonianas.
    public let posicion: ManoGuidoniana.Posicion?
    /// Dónde se lee.
    package let ficha: FichaDelCatalogo

    package init(
        nombre: String, altura: Altura, familia: FamiliaDeNota, desvio: Double = 0, frecuenciaDelLa4: Double = 440,
        anio: Int? = nil, alias: [String] = [], variantes: [String] = [], alturaConNombre: AlturaConNombre? = nil,
        posicion: ManoGuidoniana.Posicion? = nil, referencias: [Referencia] = []
    ) {
        self.nombre = nombre
        self.altura = altura
        self.familia = familia
        self.desvio = desvio
        self.frecuenciaDelLa4 = frecuenciaDelLa4
        self.alias = alias
        self.variantes = variantes
        self.alturaConNombre = alturaConNombre
        self.posicion = posicion
        ficha = FichaDelCatalogo(referencias: referencias, anio: anio)
    }

    /// Un diapasón: la altura y la frecuencia con que suena (La4 a 415 Hz, Do4 a 256 Hz).
    package static func diapason(
        _ nombre: String, _ altura: Altura, _ frecuencia: Double, anio: Int? = nil, alias: [String] = [],
        variantes: [String] = []
    ) -> NotaConNombre {
        let la = frecuencia * pow(2, Double(Altura(.la, octava: 4).midi - altura.midi) / 12)
        return NotaConNombre(
            nombre: nombre, altura: altura, familia: .diapason, frecuenciaDelLa4: la, anio: anio, alias: alias,
            variantes: variantes, referencias: [.haynes2002])
    }

    // MARK: Propiedades

    /// Dónde se lee.
    public var referencias: [Referencia] { ficha.referencias }

    /// La frecuencia en hercios: la de `altura` con el La4 de `frecuenciaDelLa4`, apartada `desvio` cents.
    public var frecuencia: Double { altura.frecuencia(frecuenciaDelLa4: frecuenciaDelLa4) * pow(2, desvio / 1200) }

    /// El número MIDI de la altura temperada más cercana a la que se escribe: 60 en el Do central.
    public var midi: Int { altura.midi }

    /// El nombre en el idioma de la notación: «Do central», «middle C»… Una nota fuera del catálogo se llama en todos
    /// los idiomas como se escribió.
    public func nombre(en notacion: Notacion) -> String { nombreTraducido(en: notacion) }

    /// Los otros nombres de la nota en el idioma de la notación, como `nombre(en:)`; vacío si no tiene.
    public func alias(en notacion: Notacion) -> [String] { aliasTraducidos(en: notacion) }

    /// Las otras formas de escribir su nombre o un alias en el idioma de la notación; vacío si no tiene.
    public func variantes(en notacion: Notacion) -> [String] { variantesTraducidas(en: notacion) }
}

extension NotaConNombre: Hashable {
    public static func == (a: NotaConNombre, b: NotaConNombre) -> Bool { a.nombre == b.nombre }
    public func hash(into hasher: inout Hasher) { hasher.combine(nombre) }
}

// MARK: - Búsqueda por nombre

extension NotaConNombre {
    /// La del catálogo con ese nombre, alias o variante en cualquier idioma, sin mirar mayúsculas, tildes, guiones ni
    /// espacios: «La 440», «A440», «middle C», «Sikah».
    public static func buscar(nombre: String) -> NotaConNombre? { buscarNombre(nombre) }

    /// Las del catálogo cuyo nombre, alias o variante contiene el texto en algún idioma, en el orden del catálogo:
    /// «piano» da las dos del piano.
    public static func buscar(conteniendo texto: String) -> [NotaConNombre] { buscarConteniendo(texto) }

    /// Las del catálogo de una familia, en su orden.
    public static func todas(de familia: FamiliaDeNota) -> [NotaConNombre] {
        catalogo.filter { $0.familia == familia }
    }
}

extension AlturaConNombre {
    /// La nota del catálogo que es.
    public var notaConNombre: NotaConNombre? { NotaConNombre.catalogo.first { $0.alturaConNombre == self } }
}

// MARK: - Familias

/// La familia de una nota del catálogo.
public enum FamiliaDeNota: String, Hashable, Sendable, Codable, CaseIterable, Nombrable {
    /// La altura a la que se afina: el La 440, el La 415 barroco, el Do 256 científico.
    case diapason
    /// Las notas que sirven de referencia: el Do central, las notas extremas del piano y del MIDI.
    case referencia
    /// Las posiciones de la mano guidoniana, de Γ ut a ee la.
    case guidoniana
    /// Las notas árabes, de Yakāh a Ramal Tūtī.
    case arabe
    /// Las perde turcas de Arel-Ezgi-Uzdilek, de Kaba Çârgâh a Tîz Çârgâh.
    case turca
    /// Las cuerdas del sistema perfecto griego, de proslambanómenos a nḗtē hyperbolaíōn.
    case griega

    /// «diapasones», «pitch standards»…
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .diapason: TextosDeTeoria.en(notacion, \.familiaDeNotaDiapason)
        case .referencia: TextosDeTeoria.en(notacion, \.familiaDeNotaReferencia)
        case .guidoniana: TextosDeTeoria.en(notacion, \.familiaDeNotaGuidoniana)
        case .arabe: TextosDeTeoria.en(notacion, \.familiaDeNotaArabe)
        case .turca: TextosDeTeoria.en(notacion, \.familiaDeNotaTurca)
        case .griega: TextosDeTeoria.en(notacion, \.familiaDeNotaGriega)
        }
    }
}
