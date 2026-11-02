import ArmoniaNucleo
import ArmoniaTeoria

/// Las cuerdas de un instrumento con trastes y la altura de cada una al aire.
///
/// Las cuerdas se numeran desde la más grave: la cuerda 0 de la guitarra es el Mi2. En los
/// instrumentos con cuerda reentrante (el ukelele) el orden es el de las cuerdas en el mástil,
/// no el de las alturas.
public struct Encordado: Hashable, Sendable {
    public let nombre: String
    /// Altura al aire de cada cuerda, en el orden en que están en el mástil: primero la de arriba (la más grave
    /// en la guitarra, que es la sexta en la numeración tradicional) y al final la de abajo (la primera). Con
    /// capo, la que suena con el capo puesto: el traste 0 es el del capo.
    public let cuerdas: [Altura]
    /// El traste en que va el capo (la cejilla móvil que se pinza en el mástil), o 0 si no lleva.
    public let capo: Int

    public init(nombre: String, cuerdas: [Altura]) {
        self.init(nombre: nombre, cuerdas: cuerdas, capo: 0)
    }

    private init(nombre: String, cuerdas: [Altura], capo: Int) {
        self.nombre = nombre
        self.cuerdas = cuerdas
        self.capo = capo
    }

    /// El mismo instrumento con el capo en un traste: cada cuerda suena `traste` semitonos más aguda y los
    /// trastes se cuentan desde el capo, como los cuenta quien toca. `Encordado.guitarra.conCapo(2)` toca la
    /// forma de Do (`x32010`) y suena Re. Con 0, o un número negativo, sin capo.
    ///
    ///     Encordado.guitarra.conCapo(2).cuerdas.first?.midi   // 42: Fa♯2
    public func conCapo(_ traste: Int) -> Encordado {
        let base = sinCapo
        let traste = max(0, traste)
        let cuerdas = base.cuerdas.map { Altura(midi: $0.midi + traste) }
        return Encordado(nombre: base.nombre, cuerdas: cuerdas, capo: traste)
    }

    /// El instrumento sin capo, con sus cuerdas al aire.
    public var sinCapo: Encordado {
        guard capo > 0 else { return self }
        // Las cuerdas de un instrumento conocido, con su ortografía; las demás, a partir de su número MIDI.
        let alAire =
            Encordado.todos.first { $0.nombre == nombre && $0.numeroDeCuerdas == numeroDeCuerdas }?.cuerdas
            ?? cuerdas.map { Altura(midi: $0.midi - capo) }
        return Encordado(nombre: nombre, cuerdas: alAire, capo: 0)
    }

    public var numeroDeCuerdas: Int { cuerdas.count }

    /// El número tradicional de la cuerda con ese índice en `cuerdas`: la 1.ª es la de abajo (el Mi agudo de la
    /// guitarra) y la última, la de arriba.
    ///
    ///     Encordado.guitarra.numeroTradicional(deCuerda: 0)   // 6: el Mi grave
    ///     Encordado.ukelele.numeroTradicional(deCuerda: 0)    // 4: el Sol
    public func numeroTradicional(deCuerda indice: Int) -> Int { numeroDeCuerdas - indice }

    /// `true` si alguna cuerda suena más grave que la anterior en el mástil: el ukelele, cuya cuerda de Sol
    /// (la de arriba, la 4.ª) es más aguda que la de Do (la 3.ª). En estos instrumentos la nota más grave de un
    /// acorde no tiene por qué ser su raíz.
    public var esReentrante: Bool {
        zip(cuerdas, cuerdas.dropFirst()).contains { $0.midi > $1.midi }
    }

    // MARK: Afinaciones habituales

    /// Guitarra estándar: Mi2 La2 Re3 Sol3 Si3 Mi4.
    public static let guitarra = Encordado(
        nombre: "guitarra",
        cuerdas: [
            Altura(.mi, octava: 2), Altura(.la, octava: 2), Altura(.re, octava: 3),
            Altura(.sol, octava: 3), Altura(.si, octava: 3), Altura(.mi, octava: 4),
        ])

    /// Guitarra de siete cuerdas, con el Si1 grave.
    public static let guitarraDeSieteCuerdas = Encordado(
        nombre: "guitarra de siete cuerdas",
        cuerdas: [Altura(.si, octava: 1)] + Encordado.guitarra.cuerdas)

    /// Guitarra en Re (drop D): Re2 La2 Re3 Sol3 Si3 Mi4.
    public static let guitarraEnReGrave = Encordado(
        nombre: "guitarra en re grave",
        cuerdas: [Altura(.re, octava: 2)] + Encordado.guitarra.cuerdas.dropFirst())

    /// Bajo de cuatro cuerdas: Mi1 La1 Re2 Sol2.
    public static let bajoElectrico = Encordado(
        nombre: "bajo",
        cuerdas: [Altura(.mi, octava: 1), Altura(.la, octava: 1), Altura(.re, octava: 2), Altura(.sol, octava: 2)])

    /// Bajo de cinco cuerdas: Si0 Mi1 La1 Re2 Sol2.
    public static let bajoDeCincoCuerdas = Encordado(
        nombre: "bajo de cinco cuerdas",
        cuerdas: [Altura(.si, octava: 0)] + Encordado.bajoElectrico.cuerdas)

    /// Ukelele soprano: Sol4 Do4 Mi4 La4 (cuerda reentrante).
    public static let ukelele = Encordado(
        nombre: "ukelele",
        cuerdas: [Altura(.sol, octava: 4), Altura(.do, octava: 4), Altura(.mi, octava: 4), Altura(.la, octava: 4)])

    /// Mandolina, afinada en quintas: Sol3 Re4 La4 Mi5.
    public static let mandolina = Encordado(
        nombre: "mandolina",
        cuerdas: [Altura(.sol, octava: 3), Altura(.re, octava: 4), Altura(.la, octava: 4), Altura(.mi, octava: 5)])

    public static let todos: [Encordado] = [
        .guitarra, .guitarraEnReGrave, .guitarraDeSieteCuerdas, .bajoElectrico, .bajoDeCincoCuerdas, .ukelele,
        .mandolina,
    ]
}

extension Encordado {
    /// Busca un instrumento por su nombre, sin distinguir mayúsculas ni tildes: «guitarra», «bajo de cinco
    /// cuerdas», «ukulele», «drop D»… En cualquiera de los quince idiomas de los textos: «bass»,
    /// «seven-string guitar», «guitare», «bandolim», «гитара». `nil` si no se conoce.
    public init?(nombre texto: String) {
        let clave = texto.claveDeBusqueda
        guard
            let encontrado = Encordado.alias[clave]
                ?? Encordado.todos.first(where: { encordado in
                    ([encordado.nombre] + (encordado.traduccion?.todos ?? [])).contains { $0.claveDeBusqueda == clave }
                })
        else { return nil }
        self = encontrado
    }

    /// Otras formas de nombrar los instrumentos de `todos` (los nombres de `todos` ya se aceptan).
    private static let alias: [String: Encordado] = [
        "guitar": .guitarra, "seven string guitar": .guitarraDeSieteCuerdas, "drop d guitar": .guitarraEnReGrave,
        "five string bass": .bajoDeCincoCuerdas,
        "guitarra 7": .guitarraDeSieteCuerdas, "guitarra7": .guitarraDeSieteCuerdas,
        "guitarra de 7 cuerdas": .guitarraDeSieteCuerdas, "guitarra de siete": .guitarraDeSieteCuerdas,
        "guitarra en re": .guitarraEnReGrave, "re grave": .guitarraEnReGrave, "drop d": .guitarraEnReGrave,
        "dropd": .guitarraEnReGrave,
        "bass": .bajoElectrico, "bajo electrico": .bajoElectrico,
        "bajo 5": .bajoDeCincoCuerdas, "bajo5": .bajoDeCincoCuerdas, "bajo de 5 cuerdas": .bajoDeCincoCuerdas,
        "bajo de cinco": .bajoDeCincoCuerdas,
        "ukulele": .ukelele, "ukulele soprano": .ukelele, "ukelele soprano": .ukelele,
        "mandolin": .mandolina,
    ]
}

// MARK: - Idiomas
//
// Los nombres de los instrumentos en los quince idiomas de los textos. Los textos están en
// `Textos/TextosDeTrastes+Espanol.swift`, `…+Ingles.swift`…, un fichero por idioma.

extension Encordado: Nombrable {
    /// El nombre del instrumento en el idioma de los textos, en minúscula para ir dentro de una frase:
    /// «guitarra de siete cuerdas», «seven-string guitar». Un encordado que no es de los de `todos` conserva
    /// su nombre.
    public func nombre(en notacion: Notacion) -> String {
        sinCapo.traduccion?.en(notacion) ?? nombre
    }

    /// El nombre para un menú, con mayúscula: «Guitarra de siete cuerdas».
    public func titulo(en notacion: Notacion) -> String {
        let nombre = nombre(en: notacion)
        return nombre.prefix(1).uppercased() + nombre.dropFirst()
    }

    /// El nombre en los quince idiomas; `nil` si el encordado no es de los de `todos`.
    package var traduccion: Traduccion? {
        switch self {
        case .guitarra:
            return TextosDeTrastes.traduccion(\.guitarra)
        case .guitarraEnReGrave:
            return TextosDeTrastes.traduccion(\.guitarraEnReGrave)
        case .guitarraDeSieteCuerdas:
            return TextosDeTrastes.traduccion(\.guitarraDeSieteCuerdas)
        case .bajoElectrico:
            return TextosDeTrastes.traduccion(\.bajo)
        case .bajoDeCincoCuerdas:
            return TextosDeTrastes.traduccion(\.bajoDeCincoCuerdas)
        case .ukelele:
            return TextosDeTrastes.traduccion(\.ukelele)
        case .mandolina:
            return TextosDeTrastes.traduccion(\.mandolina)
        default:
            return nil
        }
    }
}
