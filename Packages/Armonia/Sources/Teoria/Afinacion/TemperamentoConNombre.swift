import Elementos
import Foundation

// MARK: - TemperamentoConNombre

/// Un temperamento o un sistema de afinación del catálogo: los regulares (el igual, el pitagórico, los mesotónicos),
/// los circulares del Barroco, la afinación justa, las octavas partidas en partes iguales (19, 22, 31, 41) y los
/// sistemas de otras tradiciones (los cuartos de tono árabes, el koron persa, las 53 comas turcas, los 72 moria
/// bizantinos, los 22 śruti). Cada uno da los cents de cada paso de su octava y, si afina las doce notas, su
/// `SistemaDeAfinacion`.
///
///     TemperamentoConNombre.mesotonicoCuartoDeComa.quinta            // 696.578…
///     TemperamentoConNombre.comas53.pasosPorOctava                   // 53
///     TemperamentoConNombre.buscar(nombre: "quarter-comma meantone") // .mesotonicoCuartoDeComa
///
/// Los nombres en los otros idiomas están en `Afinacion/Nombres/`, un fichero por idioma. Dos temperamentos son
/// iguales si se llaman igual.
public struct TemperamentoConNombre: Sendable {
    /// El nombre en español: «mesotónico de 1/4 de coma».
    public let nombre: String
    /// Otros nombres, escritos correctamente.
    public let alias: [String]
    /// Otras formas de escribir el nombre o uno de los alias, que no son otro nombre.
    public let variantes: [String]
    /// La familia: regular, circular, justa, de divisiones iguales o de una tradición.
    public let familia: FamiliaDeTemperamento
    /// Quién lo propuso o lo describió: «Andreas Werckmeister».
    public let autor: String?
    /// Cómo se afina.
    package let construccion: ConstruccionDeTemperamento
    /// Dónde se lee.
    package let ficha: FichaDelCatalogo

    package init(
        nombre: String, construccion: ConstruccionDeTemperamento, familia: FamiliaDeTemperamento,
        autor: String? = nil, anio: Int? = nil, alias: [String] = [], variantes: [String] = [],
        referencias: [Referencia] = []
    ) {
        self.nombre = nombre
        self.construccion = construccion
        self.familia = familia
        self.autor = autor
        self.alias = alias
        self.variantes = variantes
        ficha = FichaDelCatalogo(referencias: referencias, anio: anio)
    }

    // MARK: Propiedades

    /// Dónde se lee.
    public var referencias: [Referencia] { ficha.referencias }

    /// Los cents de cada paso de la octava desde el primero, de menor a mayor: los doce de las teclas del piano desde
    /// Do (Do, Do♯, Re, Mi♭, Mi, Fa, Fa♯, Sol, Sol♯, La, Si♭, Si) en los de doce notas, y los del sistema en los
    /// demás.
    public var pasos: [Double] {
        switch construccion {
        case .regular(let quinta): return Self.teclas(quinta: quinta)
        case .circular(let temperamento): return temperamento.clases
        case .justa:
            let justa = AfinacionJusta(tonica: .do)
            let doCuatro = justa.frecuencia(de: Altura(.do, octava: 4))
            return Self.alturasDeLasTeclas.map { 1200 * log2(justa.frecuencia(de: $0) / doCuatro) }
        case .divisiones(let n): return (0..<n).map { 1200 * Double($0) / Double(n) }
        case .sistema(let sistema): return (0..<sistema.pasosPorOctava).map { sistema.cents(de: $0) }
        }
    }

    /// Los pasos de la octava: 12, 19, 24, 53…
    public var pasosPorOctava: Int { pasos.count }

    /// El tamaño de la quinta en cents en los regulares y en los de divisiones iguales (el paso más cercano a la
    /// quinta pura); `nil` en los demás, que tienen quintas de varios tamaños.
    public var quinta: Double? {
        switch construccion {
        case .regular(let quinta): return quinta
        case .divisiones(let n): return TemperamentoRegular.igual(divisiones: n).quinta
        case .circular, .justa, .sistema: return nil
        }
    }

    /// La afinación de las notas, con el La4 dado y, en la justa, sobre la tónica; `nil` en los sistemas de otras
    /// tradiciones, que no afinan notas sino los grados de sus escalas (`AfinacionPropia`). Con un
    /// ``TemperamentoQueAfina`` no hace falta mirar si es `nil`.
    public func afinacion(tonica: Nota = .do, frecuenciaDelLa4: Double = 440) -> (any SistemaDeAfinacion)? {
        switch construccion {
        case .regular(let quinta):
            return TemperamentoRegular(nombre: nombre, quinta: quinta, frecuenciaDelLa4: frecuenciaDelLa4)
        case .circular(let temperamento): return temperamento.afinar(frecuenciaDelLa4: frecuenciaDelLa4)
        case .justa: return AfinacionJusta(tonica: tonica, frecuenciaDelLa4: frecuenciaDelLa4)
        case .divisiones(let n): return TemperamentoRegular.igual(divisiones: n, frecuenciaDelLa4: frecuenciaDelLa4)
        case .sistema: return nil
        }
    }

    /// `true` si distingue las notas enarmónicas (Sol♯ de La♭): el pitagórico, los mesotónicos, la justa y las
    /// octavas partidas en otro número de partes que doce; no el igual ni los circulares, que tocan las doce teclas
    /// del piano. `false` también en los sistemas de otras tradiciones, que no afinan notas.
    public var distingueEnarmonicas: Bool {
        guard let afinacion = afinacion() else { return false }
        return abs(afinacion.cents(desde: "Sol#4", hasta: "Lab4")) > 1e-6
    }

    /// El sistema microtonal que es, si es uno.
    public var sistemaMicrotonal: SistemaMicrotonal? {
        guard case .sistema(let sistema) = construccion else { return nil }
        return sistema
    }

    /// El nombre en el idioma de la notación: «mesotónico de 1/4 de coma», «quarter-comma meantone»… Uno fuera del
    /// catálogo se llama en todos los idiomas como se escribió.
    public func nombre(en notacion: Notacion) -> String { nombreTraducido(en: notacion) }

    /// Los otros nombres de el temperamento en el idioma de la notación, como `nombre(en:)`; vacío si no tiene.
    public func alias(en notacion: Notacion) -> [String] { aliasTraducidos(en: notacion) }

    /// Las otras formas de escribir su nombre o un alias en el idioma de la notación; vacío si no tiene.
    public func variantes(en notacion: Notacion) -> [String] { variantesTraducidas(en: notacion) }

    // MARK: Las teclas

    /// Las doce teclas desde Do4, como se afinaban en los temperamentos regulares: de Mi♭ a Sol♯ por quintas.
    static let alturasDeLasTeclas: [Altura] = [
        (NotaNatural.do, 0), (.do, 1), (.re, 0), (.mi, -1), (.mi, 0), (.fa, 0), (.fa, 1), (.sol, 0), (.sol, 1),
        (.la, 0),
        (.si, -1), (.si, 0),
    ].map { Altura(Nota($0.0, Alteracion($0.1)), octava: 4) }

    /// Los cents de las doce teclas con todas las quintas de `quinta`.
    static func teclas(quinta: Double) -> [Double] {
        let regular = TemperamentoRegular(nombre: "", quinta: quinta)
        return alturasDeLasTeclas.map { regular.cents(de: $0) - regular.cents(de: Altura(.do, octava: 4)) }
    }
}

/// Cómo se afina un temperamento del catálogo.
package enum ConstruccionDeTemperamento: Hashable, Sendable {
    /// Todas las quintas de estos cents.
    case regular(Double)
    /// Doce quintas que cierran el círculo.
    case circular(TemperamentoCircular)
    /// La justa de 5 límites (`AfinacionJusta`).
    case justa
    /// La octava en tantas partes iguales.
    case divisiones(Int)
    /// Los pasos de un sistema microtonal.
    case sistema(SistemaMicrotonal)
}

extension TemperamentoConNombre: Hashable {
    public static func == (a: TemperamentoConNombre, b: TemperamentoConNombre) -> Bool { a.nombre == b.nombre }
    public func hash(into hasher: inout Hasher) { hasher.combine(nombre) }
}

extension TemperamentoConNombre: Identifiable {
    /// El nombre en español, que no se repite en el catálogo.
    public var id: String { nombre }
}

extension TemperamentoConNombre: Nombrable, CustomStringConvertible {
    public var description: String { nombre }
}

// MARK: - Búsqueda por nombre

extension TemperamentoConNombre {
    /// El del catálogo con ese nombre, alias o variante en cualquier idioma, sin mirar mayúsculas, tildes, guiones ni
    /// espacios: «mesotónico», «meantone», «53 comas».
    public static func buscar(nombre: String) -> TemperamentoConNombre? { buscarNombre(nombre) }

    /// Los del catálogo cuyo nombre, alias o variante contiene el texto en algún idioma, en el orden del catálogo:
    /// «mesotónico» da los cinco.
    public static func buscar(conteniendo texto: String) -> [TemperamentoConNombre] { buscarConteniendo(texto) }

    /// Los del catálogo de una familia, en su orden.
    public static func todos(de familia: FamiliaDeTemperamento) -> [TemperamentoConNombre] {
        catalogo.filter { $0.familia == familia }
    }
}

extension SistemaMicrotonal {
    /// El sistema del catálogo de temperamentos que es; `nil` en el de cents cualesquiera (`razones`).
    public var temperamento: TemperamentoConNombre? {
        TemperamentoConNombre.catalogo.first { $0.sistemaMicrotonal == self }
    }
}

// MARK: - Familias

/// La familia de un temperamento del catálogo.
public enum FamiliaDeTemperamento: String, Hashable, Sendable, Codable, CaseIterable, Nombrable {
    /// Todas las quintas iguales: el temperamento igual, el pitagórico y los mesotónicos.
    case regular
    /// Los buenos temperamentos del Barroco, de quintas desiguales que cierran el círculo.
    case circular
    /// Las razones de números pequeños: la afinación justa.
    case justa
    /// La octava en partes iguales que no son doce: 19, 22, 31, 41.
    case divisionesIguales
    /// Los sistemas de otras tradiciones: cuartos de tono, koron y sori, 53 comas, 72 moria, 22 śruti.
    case tradicional

    /// «temperamentos regulares», «regular temperaments»…
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .regular: TextosDeTeoria.en(notacion, \.familiaDeTemperamentoRegular)
        case .circular: TextosDeTeoria.en(notacion, \.familiaDeTemperamentoCircular)
        case .justa: TextosDeTeoria.en(notacion, \.familiaDeTemperamentoJusta)
        case .divisionesIguales: TextosDeTeoria.en(notacion, \.familiaDeTemperamentoDivisionesIguales)
        case .tradicional: TextosDeTeoria.en(notacion, \.familiaDeTemperamentoTradicional)
        }
    }
}
