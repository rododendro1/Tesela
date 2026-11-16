import Elementos
import Teoria

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
    public let afinacion: [Altura]
    /// El traste en que va el capo (la cejilla móvil que se pinza en el mástil), o 0 si no lleva.
    public let capo: Int

    /// Un instrumento con ese nombre y esas cuerdas al aire, de la 0 (la más grave en el mástil) en adelante, sin
    /// cejilla.
    public init(nombre: String, afinacion: [Altura]) {
        self.init(nombre: nombre, afinacion: afinacion, capo: 0)
    }

    private init(nombre: String, afinacion: [Altura], capo: Int) {
        self.nombre = nombre
        self.afinacion = afinacion
        self.capo = capo
    }

    /// El mismo instrumento con el capo en un traste: cada cuerda suena `traste` semitonos más aguda y los
    /// trastes se cuentan desde el capo, como los cuenta quien toca. `Encordado.guitarra.conCapo(2)` toca la
    /// forma de Do (`x32010`) y suena Re. Con 0, o un número negativo, sin capo.
    ///
    ///     Encordado.guitarra.conCapo(2).afinacion.first?.midi   // 42: Fa♯2
    public func conCapo(_ traste: Int) -> Encordado {
        let base = sinCapo
        let traste = max(0, traste)
        let afinacion = base.afinacion.map { Altura(midi: $0.midi + traste) }
        return Encordado(nombre: base.nombre, afinacion: afinacion, capo: traste)
    }

    /// El instrumento sin capo, con sus cuerdas al aire.
    public var sinCapo: Encordado {
        guard capo > 0 else { return self }
        // Las cuerdas de un instrumento conocido, con su ortografía; las demás, a partir de su número MIDI.
        let alAire =
            Encordado.todos.first { $0.nombre == nombre && $0.numeroDeCuerdas == numeroDeCuerdas }?.afinacion
            ?? afinacion.map { Altura(midi: $0.midi - capo) }
        return Encordado(nombre: nombre, afinacion: alAire, capo: 0)
    }

    public var numeroDeCuerdas: Int { afinacion.count }

    /// El número tradicional de la cuerda con ese índice en `afinacion`: la 1.ª es la de abajo (el Mi agudo de la
    /// guitarra) y la última, la de arriba.
    ///
    ///     Encordado.guitarra.numeroTradicional(deCuerda: 0)   // 6: el Mi grave
    ///     Encordado.ukelele.numeroTradicional(deCuerda: 0)    // 4: el Sol
    public func numeroTradicional(deCuerda indice: Int) -> Int { numeroDeCuerdas - indice }

    /// `true` si alguna cuerda suena más grave que la anterior en el mástil: el ukelele, cuya cuerda de Sol
    /// (la de arriba, la 4.ª) es más aguda que la de Do (la 3.ª). En estos instrumentos la nota más grave de un
    /// acorde no tiene por qué ser su raíz.
    public var esReentrante: Bool {
        zip(afinacion, afinacion.dropFirst()).contains { $0.midi > $1.midi }
    }

    // MARK: Afinaciones habituales

    /// Guitarra estándar: Mi2 La2 Re3 Sol3 Si3 Mi4.
    public static let guitarra = Encordado(
        nombre: "guitarra",
        afinacion: [
            Altura(.mi, octava: 2), Altura(.la, octava: 2), Altura(.re, octava: 3),
            Altura(.sol, octava: 3), Altura(.si, octava: 3), Altura(.mi, octava: 4),
        ])

    /// Guitarra de siete cuerdas, con el Si1 grave.
    public static let guitarraDeSieteCuerdas = Encordado(
        nombre: "guitarra de siete cuerdas",
        afinacion: [Altura(.si, octava: 1)] + Encordado.guitarra.afinacion)

    /// Guitarra en Re (drop D): Re2 La2 Re3 Sol3 Si3 Mi4.
    public static let guitarraEnReGrave = Encordado(
        nombre: "guitarra en re grave",
        afinacion: [Altura(.re, octava: 2)] + Encordado.guitarra.afinacion.dropFirst())

    /// Guitarra en re abierto (open D): Re2 La2 Re3 Fa♯3 La3 Re4, un acorde de Re al aire.
    public static let guitarraEnReAbierto = Encordado(
        nombre: "guitarra en re abierto",
        afinacion: [
            Altura(.re, octava: 2), Altura(.la, octava: 2), Altura(.re, octava: 3),
            Altura(Nota(.fa, .sostenido), octava: 3), Altura(.la, octava: 3), Altura(.re, octava: 4),
        ])

    /// Guitarra en sol abierto (open G): Re2 Sol2 Re3 Sol3 Si3 Re4, un acorde de Sol al aire.
    public static let guitarraEnSolAbierto = Encordado(
        nombre: "guitarra en sol abierto",
        afinacion: [
            Altura(.re, octava: 2), Altura(.sol, octava: 2), Altura(.re, octava: 3),
            Altura(.sol, octava: 3), Altura(.si, octava: 3), Altura(.re, octava: 4),
        ])

    /// Guitarra en DADGAD: Re2 La2 Re3 Sol3 La3 Re4, un Re con cuarta suspendida al aire.
    public static let guitarraDADGAD = Encordado(
        nombre: "guitarra en DADGAD",
        afinacion: [
            Altura(.re, octava: 2), Altura(.la, octava: 2), Altura(.re, octava: 3),
            Altura(.sol, octava: 3), Altura(.la, octava: 3), Altura(.re, octava: 4),
        ])

    /// Bajo de cuatro cuerdas: Mi1 La1 Re2 Sol2.
    public static let bajoElectrico = Encordado(
        nombre: "bajo",
        afinacion: [Altura(.mi, octava: 1), Altura(.la, octava: 1), Altura(.re, octava: 2), Altura(.sol, octava: 2)])

    /// Bajo de cinco cuerdas: Si0 Mi1 La1 Re2 Sol2.
    public static let bajoDeCincoCuerdas = Encordado(
        nombre: "bajo de cinco cuerdas",
        afinacion: [Altura(.si, octava: 0)] + Encordado.bajoElectrico.afinacion)

    /// Ukelele soprano: Sol4 Do4 Mi4 La4 (cuerda reentrante).
    public static let ukelele = Encordado(
        nombre: "ukelele",
        afinacion: [Altura(.sol, octava: 4), Altura(.do, octava: 4), Altura(.mi, octava: 4), Altura(.la, octava: 4)])

    /// Mandolina, afinada en quintas: Sol3 Re4 La4 Mi5.
    public static let mandolina = Encordado(
        nombre: "mandolina",
        afinacion: [Altura(.sol, octava: 3), Altura(.re, octava: 4), Altura(.la, octava: 4), Altura(.mi, octava: 5)])

    /// Guitarra en do abierto (open C): Do2 Sol2 Do3 Sol3 Do4 Mi4, un acorde de Do al aire.
    public static let guitarraEnDoAbierto = Encordado(
        nombre: "guitarra en do abierto",
        afinacion: [
            Altura(.do, octava: 2), Altura(.sol, octava: 2), Altura(.do, octava: 3), Altura(.sol, octava: 3),
            Altura(.do, octava: 4), Altura(.mi, octava: 4),
        ])

    /// Guitarra en do grave (drop C): Do2 Sol2 Do3 Fa3 La3 Re4, la de re grave un tono más baja.
    public static let guitarraEnDoGrave = Encordado(
        nombre: "guitarra en do grave",
        afinacion: [
            Altura(.do, octava: 2), Altura(.sol, octava: 2), Altura(.do, octava: 3), Altura(.fa, octava: 3),
            Altura(.la, octava: 3), Altura(.re, octava: 4),
        ])

    /// Guitarra en mi abierto (open E): Mi2 Si2 Mi3 Sol♯3 Si3 Mi4, un acorde de Mi al aire, la del blues con slide.
    public static let guitarraEnMiAbierto = Encordado(
        nombre: "guitarra en mi abierto",
        afinacion: [
            Altura(.mi, octava: 2), Altura(.si, octava: 2), Altura(.mi, octava: 3),
            Altura(Nota(.sol, .sostenido), octava: 3), Altura(.si, octava: 3), Altura(.mi, octava: 4),
        ])

    /// Guitarra en afinación Nashville: las cuatro cuerdas graves, una octava más agudas (Mi3 La3 Re4 Sol4 Si3 Mi4),
    /// como las cuerdas finas de la guitarra de doce cuerdas.
    public static let guitarraNashville = Encordado(
        nombre: "guitarra Nashville",
        afinacion: [
            Altura(.mi, octava: 3), Altura(.la, octava: 3), Altura(.re, octava: 4), Altura(.sol, octava: 4),
            Altura(.si, octava: 3), Altura(.mi, octava: 4),
        ])

    /// Guitarra de doce cuerdas: seis órdenes dobles afinados como la guitarra (Mi2 La2 Re3 Sol3 Si3 Mi4), los cuatro
    /// graves en octavas y los dos agudos al unísono (`alturasDelOrden(_:)`).
    public static let guitarraDeDoceCuerdas = Encordado(
        nombre: "guitarra de doce cuerdas",
        afinacion: [
            Altura(.mi, octava: 2), Altura(.la, octava: 2), Altura(.re, octava: 3), Altura(.sol, octava: 3),
            Altura(.si, octava: 3), Altura(.mi, octava: 4),
        ])

    /// Ukelele barítono: Re3 Sol3 Si3 Mi4, las cuatro cuerdas agudas de la guitarra.
    public static let ukeleleBariton = Encordado(
        nombre: "ukelele barítono",
        afinacion: [Altura(.re, octava: 3), Altura(.sol, octava: 3), Altura(.si, octava: 3), Altura(.mi, octava: 4)])

    /// Mandola: Do3 Sol3 Re4 La4, en quintas como la mandolina y una quinta más grave; cuatro órdenes dobles.
    public static let mandola = Encordado(
        nombre: "mandola",
        afinacion: [Altura(.do, octava: 3), Altura(.sol, octava: 3), Altura(.re, octava: 4), Altura(.la, octava: 4)])

    /// Bandurria: Sol♯3 Do♯4 Fa♯4 Si4 Mi5 La5, en cuartas; seis órdenes dobles.
    public static let bandurria = Encordado(
        nombre: "bandurria",
        afinacion: [
            Altura(Nota(.sol, .sostenido), octava: 3), Altura(Nota(.do, .sostenido), octava: 4),
            Altura(Nota(.fa, .sostenido), octava: 4), Altura(.si, octava: 4), Altura(.mi, octava: 5),
            Altura(.la, octava: 5),
        ])

    /// Laúd español: Sol♯2 Do♯3 Fa♯3 Si3 Mi4 La4, la bandurria una octava más grave; seis órdenes dobles.
    public static let laud = Encordado(
        nombre: "laúd",
        afinacion: [
            Altura(Nota(.sol, .sostenido), octava: 2), Altura(Nota(.do, .sostenido), octava: 3),
            Altura(Nota(.fa, .sostenido), octava: 3), Altura(.si, octava: 3), Altura(.mi, octava: 4),
            Altura(.la, octava: 4),
        ])

    /// Laúd renacentista de seis órdenes, en Sol: Sol2 Do3 Fa3 La3 Re4 Sol4; la prima, sencilla.
    public static let laudRenacentista = Encordado(
        nombre: "laúd renacentista",
        afinacion: [
            Altura(.sol, octava: 2), Altura(.do, octava: 3), Altura(.fa, octava: 3), Altura(.la, octava: 3),
            Altura(.re, octava: 4), Altura(.sol, octava: 4),
        ])

    /// Vihuela de mano, en Sol como el laúd: Sol2 Do3 Fa3 La3 Re4 Sol4. De 1536 es «El Maestro» de Luis Milán, el
    /// primer libro para vihuela.
    public static let vihuela = Encordado(
        nombre: "vihuela de mano",
        afinacion: [
            Altura(.sol, octava: 2), Altura(.do, octava: 3), Altura(.fa, octava: 3), Altura(.la, octava: 3),
            Altura(.re, octava: 4), Altura(.sol, octava: 4),
        ])

    /// Ud árabe, sin trastes: Do2 Fa2 La2 Re3 Sol3 Do4, cinco órdenes dobles y el bordón sencillo.
    public static let ud = Encordado(
        nombre: "ud",
        afinacion: [
            Altura(.do, octava: 2), Altura(.fa, octava: 2), Altura(.la, octava: 2), Altura(.re, octava: 3),
            Altura(.sol, octava: 3), Altura(.do, octava: 4),
        ])

    /// Buzuki griego de cuatro órdenes (tetrájordo): Do3 Fa3 La3 Re4.
    public static let buzuki = Encordado(
        nombre: "buzuki",
        afinacion: [Altura(.do, octava: 3), Altura(.fa, octava: 3), Altura(.la, octava: 3), Altura(.re, octava: 4)])

    /// Charango andino: Sol4 Do5 Mi5 La4 Mi5 (cuerda reentrante); cinco órdenes dobles.
    public static let charango = Encordado(
        nombre: "charango",
        afinacion: [
            Altura(.sol, octava: 4), Altura(.do, octava: 5), Altura(.mi, octava: 5), Altura(.la, octava: 4),
            Altura(.mi, octava: 5),
        ])

    /// Cuatro venezolano: La3 Re4 Fa♯4 Si3 (cuerda reentrante).
    public static let cuatroVenezolano = Encordado(
        nombre: "cuatro venezolano",
        afinacion: [
            Altura(.la, octava: 3), Altura(.re, octava: 4), Altura(Nota(.fa, .sostenido), octava: 4),
            Altura(.si, octava: 3),
        ])

    /// Tres cubano: Sol3 Do4 Mi4, tres órdenes dobles.
    public static let tresCubano = Encordado(
        nombre: "tres cubano",
        afinacion: [Altura(.sol, octava: 3), Altura(.do, octava: 4), Altura(.mi, octava: 4)])

    /// Guitarra portuguesa, en la afinación de Lisboa: Re3 La3 Si3 Mi4 La4 Si4; seis órdenes dobles.
    public static let guitarraPortuguesa = Encordado(
        nombre: "guitarra portuguesa",
        afinacion: [
            Altura(.re, octava: 3), Altura(.la, octava: 3), Altura(.si, octava: 3), Altura(.mi, octava: 4),
            Altura(.la, octava: 4), Altura(.si, octava: 4),
        ])

    /// Balalaica prima: Mi4 Mi4 La4, dos cuerdas al unísono y una cuarta más arriba.
    public static let balalaica = Encordado(
        nombre: "balalaica",
        afinacion: [Altura(.mi, octava: 4), Altura(.mi, octava: 4), Altura(.la, octava: 4)])

    /// Banjo de cinco cuerdas en sol abierto: Sol4 Re3 Sol3 Si3 Re4; la quinta, corta y aguda (reentrante).
    public static let banjo = Encordado(
        nombre: "banjo de cinco cuerdas",
        afinacion: [
            Altura(.sol, octava: 4), Altura(.re, octava: 3), Altura(.sol, octava: 3), Altura(.si, octava: 3),
            Altura(.re, octava: 4),
        ])

    /// Dulcémele de los Apalaches, de trastes diatónicos: Re3 La3 Re4.
    public static let dulcemele = Encordado(
        nombre: "dulcémele de los Apalaches",
        afinacion: [Altura(.re, octava: 3), Altura(.la, octava: 3), Altura(.re, octava: 4)])

    /// Pipa china: La2 Re3 Mi3 La3.
    public static let pipa = Encordado(
        nombre: "pipa",
        afinacion: [Altura(.la, octava: 2), Altura(.re, octava: 3), Altura(.mi, octava: 3), Altura(.la, octava: 3)])

    /// Violín, sin trastes y en quintas: Sol3 Re4 La4 Mi5.
    public static let violin = Encordado(
        nombre: "violín",
        afinacion: [Altura(.sol, octava: 3), Altura(.re, octava: 4), Altura(.la, octava: 4), Altura(.mi, octava: 5)])

    /// Viola, sin trastes y en quintas: Do3 Sol3 Re4 La4.
    public static let viola = Encordado(
        nombre: "viola",
        afinacion: [Altura(.do, octava: 3), Altura(.sol, octava: 3), Altura(.re, octava: 4), Altura(.la, octava: 4)])

    /// Violonchelo, sin trastes y en quintas: Do2 Sol2 Re3 La3, la viola una octava más grave.
    public static let violonchelo = Encordado(
        nombre: "violonchelo",
        afinacion: [Altura(.do, octava: 2), Altura(.sol, octava: 2), Altura(.re, octava: 3), Altura(.la, octava: 3)])

    /// Contrabajo, sin trastes y en cuartas: Mi1 La1 Re2 Sol2, las mismas alturas que el bajo.
    public static let contrabajo = Encordado(
        nombre: "contrabajo",
        afinacion: [Altura(.mi, octava: 1), Altura(.la, octava: 1), Altura(.re, octava: 2), Altura(.sol, octava: 2)])

    /// Todos los instrumentos del catálogo: las guitarras y sus afinaciones, los bajos, los ukeleles, las mandolinas,
    /// los laúdes, los de otras tradiciones y la familia del violín. Su ficha (sus órdenes, sus trastes, de dónde
    /// vienen y dónde se leen) está en `Encordado+Catalogo.swift`.
    public static let todos: [Encordado] = [
        .guitarra, .guitarraEnReGrave, .guitarraEnReAbierto, .guitarraEnSolAbierto, .guitarraDADGAD,
        .guitarraDeSieteCuerdas, .guitarraEnDoAbierto, .guitarraEnDoGrave, .guitarraEnMiAbierto, .guitarraNashville,
        .guitarraDeDoceCuerdas,
        .bajoElectrico, .bajoDeCincoCuerdas, .ukelele,
        .ukeleleBariton, .mandolina, .mandola, .bandurria, .laud, .laudRenacentista, .vihuela, .ud, .buzuki, .charango,
        .cuatroVenezolano, .tresCubano, .guitarraPortuguesa, .balalaica, .banjo, .dulcemele, .pipa, .violin, .viola,
        .violonchelo, .contrabajo,
    ]
}

extension Encordado {
    /// El instrumento de un nombre, sin distinguir mayúsculas ni tildes: «guitarra», «bajo de cinco cuerdas»,
    /// «ukulele», «drop D»… En cualquiera de los trece idiomas de los textos: «bass», «seven-string guitar»,
    /// «guitare», «bandolim», «гитара». Si no es ninguno, lanza `ErrorDeLecturaDeTeoria` (`.nombreNoReconocido`) con
    /// los nombres de `todos`.
    ///
    ///     try Encordado(leyendo: "ukulele") == .ukelele   // true
    public init(leyendo texto: String) throws {
        let clave = texto.claveDeBusqueda
        guard
            let encontrado = Encordado.alias[clave]
                ?? Encordado.todos.first(where: { encordado in
                    ([encordado.nombre] + (encordado.traduccion?.todos ?? [])).contains { $0.claveDeBusqueda == clave }
                })
        else {
            let opciones = Encordado.todos.map(\.nombre)
            throw ErrorDeLecturaDeTeoria(
                texto: texto, posicion: nil, motivo: .nombreNoReconocido(texto, opciones: opciones))
        }
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
        "open d": .guitarraEnReAbierto, "re abierto": .guitarraEnReAbierto, "open g": .guitarraEnSolAbierto,
        "sol abierto": .guitarraEnSolAbierto, "dadgad": .guitarraDADGAD,
        "bass": .bajoElectrico, "bajo electrico": .bajoElectrico,
        "bajo 5": .bajoDeCincoCuerdas, "bajo5": .bajoDeCincoCuerdas, "bajo de 5 cuerdas": .bajoDeCincoCuerdas,
        "bajo de cinco": .bajoDeCincoCuerdas,
        "ukulele": .ukelele, "ukulele soprano": .ukelele, "ukelele soprano": .ukelele,
        "mandolin": .mandolina,
        "laud espanol": .laud, "laud arabe": .ud, "dulcimer": .dulcemele, "banjo": .banjo, "chelo": .violonchelo,
        "baritone uke": .ukeleleBariton, "guitarra de 12 cuerdas": .guitarraDeDoceCuerdas,
        "12 string guitar": .guitarraDeDoceCuerdas, "tres": .tresCubano, "cuatro": .cuatroVenezolano,
    ]
}

// MARK: - Idiomas
//
// Los nombres de los instrumentos en los trece idiomas de los textos. Los textos están en
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
        let sinMayuscula = nombre(en: notacion)
        return sinMayuscula.prefix(1).uppercased() + sinMayuscula.dropFirst()
    }

    /// El nombre en los trece idiomas; `nil` si el encordado no es de los de `todos`.
    package var traduccion: Traduccion? {
        switch self {
        case .guitarra:
            return TextosDeTrastes.traduccion(\.guitarra)
        case .guitarraEnReGrave:
            return TextosDeTrastes.traduccion(\.guitarraEnReGrave)
        case .guitarraEnReAbierto:
            return TextosDeTrastes.traduccion(\.guitarraEnReAbierto)
        case .guitarraEnSolAbierto:
            return TextosDeTrastes.traduccion(\.guitarraEnSolAbierto)
        case .guitarraDADGAD:
            return TextosDeTrastes.traduccion(\.guitarraDADGAD)
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
        case .guitarraEnDoAbierto:
            return TextosDeTrastes.traduccion(\.guitarraEnDoAbierto)
        case .guitarraEnDoGrave:
            return TextosDeTrastes.traduccion(\.guitarraEnDoGrave)
        case .guitarraEnMiAbierto:
            return TextosDeTrastes.traduccion(\.guitarraEnMiAbierto)
        case .guitarraNashville:
            return TextosDeTrastes.traduccion(\.guitarraNashville)
        case .guitarraDeDoceCuerdas:
            return TextosDeTrastes.traduccion(\.guitarraDeDoceCuerdas)
        case .ukeleleBariton:
            return TextosDeTrastes.traduccion(\.ukeleleBariton)
        case .mandola:
            return TextosDeTrastes.traduccion(\.mandola)
        case .bandurria:
            return TextosDeTrastes.traduccion(\.bandurria)
        case .laud:
            return TextosDeTrastes.traduccion(\.laud)
        case .laudRenacentista:
            return TextosDeTrastes.traduccion(\.laudRenacentista)
        case .vihuela:
            return TextosDeTrastes.traduccion(\.vihuela)
        case .ud:
            return TextosDeTrastes.traduccion(\.ud)
        case .buzuki:
            return TextosDeTrastes.traduccion(\.buzuki)
        case .charango:
            return TextosDeTrastes.traduccion(\.charango)
        case .cuatroVenezolano:
            return TextosDeTrastes.traduccion(\.cuatroVenezolano)
        case .tresCubano:
            return TextosDeTrastes.traduccion(\.tresCubano)
        case .guitarraPortuguesa:
            return TextosDeTrastes.traduccion(\.guitarraPortuguesa)
        case .balalaica:
            return TextosDeTrastes.traduccion(\.balalaica)
        case .banjo:
            return TextosDeTrastes.traduccion(\.banjo)
        case .dulcemele:
            return TextosDeTrastes.traduccion(\.dulcemele)
        case .pipa:
            return TextosDeTrastes.traduccion(\.pipa)
        case .violin:
            return TextosDeTrastes.traduccion(\.violin)
        case .viola:
            return TextosDeTrastes.traduccion(\.viola)
        case .violonchelo:
            return TextosDeTrastes.traduccion(\.violonchelo)
        case .contrabajo:
            return TextosDeTrastes.traduccion(\.contrabajo)
        default:
            return nil
        }
    }
}
