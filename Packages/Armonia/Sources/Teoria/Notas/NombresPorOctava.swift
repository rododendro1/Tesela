import Elementos
import Foundation

// MARK: - Nombres por octava
//
// Los sistemas que nombran cada altura en su octava, a menudo con microtonos: las notas árabes (Rāst es Do4 y Nawā,
// Sol4; una octava abajo, Sol3 es Yakāh), las perde turcas de Arel-Ezgi-Uzdilek (Rast es Sol4 y Nevâ, Re5; Segâh,
// una koma bajo Si4) y las cuerdas del sistema perfecto griego (de proslambanómenos, La2, a nḗtē hyperbolaíōn, La4).
// No son un `SistemaDeNombres`: el nombre depende de la octava y del microtono, así que se pide con una `Altura` y un
// ajuste en los pasos de su `SistemaDeAlturas`, o con una `NotaMicrotonal` y su octava.
//
// Cada sistema es una tabla de alturas con nombre (`AlturaConNombre`), de la grave a la aguda. Una altura se busca
// por los pasos de su sistema desde Do4 (cuartos de tono, comas o semitonos), así que da igual cómo se escriba: Re♭4
// y Do♯4 son los dos Zīrkūlāh. Si una altura tiene dos nombres, se escribe con el primero (la tríte diezeugménōn, no
// la paranḗtē synēmménōn) y se leen los dos. Las tablas están en `NombresPorOctava+Tablas.swift`.

/// Un sistema que nombra cada altura en su octava: `NombresPorOctava.arabe.nombre(de: Altura(.sol, octava: 4))` es
/// «Nawā».
public enum NombresPorOctava: String, Hashable, Sendable, CaseIterable, Codable {
    /// Las notas árabes, en cuartos de tono, con Rāst en Do4, como se escriben hoy: de Yakāh (Sol3) a Ramal Tūtī
    /// (Sol5), con ʿIrāq, Sīkāh y Awj un cuarto de tono bajo Si y Mi (Si𝄳3, Mi𝄳4, Si𝄳4) y los nombres de las notas
    /// cromáticas (Kurdī es Mi♭4, Ḥijāz, Fa♯4). Grafía original, en árabe (راست); transliterada, con ʿ y macrones
    /// (Rāst); en ASCII, Rast.
    case arabe
    /// Las perde turcas de Arel-Ezgi-Uzdilek, en 53 comas, como se escriben (Rast en Sol4): de Kaba Çârgâh (Do4) a
    /// Tîz Çârgâh (Do6), con las koma y las bakiye de cada perde: Segâh es Si4 una koma bajo; Irak y Eviç, Fa♯ una
    /// koma bajo. Se escriben en turco, que ya usa el alfabeto latino: la grafía original y la transliterada son la
    /// misma (Dügâh), y en ASCII van sin diacríticos (Dugah).
    case turco
    /// Las cuerdas del sistema perfecto mayor de la Grecia antigua, en el género diatónico: de proslambanómenos (La2)
    /// a nḗtē hyperbolaíōn (La4), con mésē en La3, y las tres del tetracordo synēmménōn (tríte synēmménōn es Si♭3).
    /// Grafía original, en griego politónico (μέση); transliterada, con macrones y tilde (mésē); en ASCII, mese.
    case griegoAntiguo

    /// El sistema microtonal de sus ajustes: `.cuartosDeTono` en el árabe, `.comas53` en el turco y ninguno en el
    /// griego, que va en semitonos.
    public var sistemaDeAlturas: SistemaDeAlturas? {
        switch self {
        case .arabe: return .cuartosDeTono
        case .turco: return .comas53
        case .griegoAntiguo: return nil
        }
    }

    /// Las alturas con nombre del sistema, de la grave a la aguda (las que nombran dos veces una altura, detrás).
    public var alturas: [AlturaConNombre] {
        tabla.map { fila in
            AlturaConNombre(sistema: self, altura: fila.altura, ajuste: fila.ajuste, nombres: fila.nombres)
        }
    }

    /// El nombre de una altura, apartada `ajuste` pasos de su sistema (cuartos de tono en el árabe, comas sobre la
    /// pitagórica en el turco; en el griego, 0); `nil` si el sistema no la nombra.
    ///
    ///     NombresPorOctava.arabe.nombre(de: Altura(.mi, octava: 4), ajuste: -1)     // "Sīkāh"
    ///     NombresPorOctava.turco.nombre(de: Altura(.si, octava: 4), ajuste: -1)     // "Segâh"
    ///     NombresPorOctava.griegoAntiguo.nombre(de: Altura(.la, octava: 3))         // "mésē"
    public func nombre(de altura: Altura, ajuste: Int = 0, grafia: Grafia = .transliterada) -> String? {
        let buscados = pasos(de: altura, ajuste: ajuste)
        return alturas.first { pasos(de: $0.altura, ajuste: $0.ajuste) == buscados }?.nombre(en: grafia)
    }

    /// El nombre de una nota microtonal en una octava (la de su nota temperada); `nil` si es de otro sistema
    /// microtonal o el sistema no la nombra. En el árabe valen también las notas en la notación persa, que tiene los
    /// mismos cuartos de tono.
    public func nombre(de nota: NotaMicrotonal, octava: Int, grafia: Grafia = .transliterada) -> String? {
        guard admite(nota.sistema) else { return nil }
        return nombre(de: Altura(nota.temperada, octava: octava), ajuste: nota.ajuste, grafia: grafia)
    }

    /// Lee un nombre en cualquiera de sus grafías, sin importar las mayúsculas, los diacríticos, los espacios ni los
    /// guiones: «Rāst», «rast», «راست»; «Hüseynî Aşîrân», «huseyni asiran»; «ὑπάτη μέσων», «hypate meson».
    public func leer(_ texto: String) throws -> AlturaConNombre {
        let clave = NombresPorOctava.plegar(texto)
        guard !clave.isEmpty else { throw ErrorDeLectura(texto: texto, posicion: nil, motivo: .textoVacio) }
        let encontrada = alturas.first { altura in
            Grafia.allCases.contains { NombresPorOctava.plegar(altura.nombre(en: $0)) == clave }
        }
        guard let altura = encontrada else {
            throw ErrorDeLectura(texto: texto, posicion: 0, motivo: .notaNoReconocida)
        }
        return altura
    }

    /// Si las notas de un sistema microtonal se nombran en este: en el árabe, las de cuartos de tono y las de la
    /// notación persa; en el turco, las de 53 comas.
    func admite(_ microtonal: SistemaDeAlturas) -> Bool {
        switch self {
        case .arabe: return microtonal == .cuartosDeTono || microtonal == .persa
        case .turco: return microtonal == .comas53
        case .griegoAntiguo: return false
        }
    }

    /// Los pasos del sistema desde Do4: cuartos de tono (24 por octava), comas (53, con la quinta pitagórica de 31)
    /// o semitonos.
    func pasos(de altura: Altura, ajuste: Int) -> Int {
        switch self {
        case .arabe: return 2 * (altura.midi - 60) + ajuste
        case .turco: return 31 * altura.pasosDeQuinta + 53 * altura.pasosDeOctava + ajuste
        case .griegoAntiguo: return altura.midi - 60 + ajuste
        }
    }

    /// El texto sin mayúsculas, diacríticos, espacios, guiones ni apóstrofos (la ʿayn de ʿUshayrān), para leer.
    static func plegar(_ texto: String) -> String {
        let plegado = texto.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
        let quitados: Set<Character> = [" ", "-", "‐", "'", "’", "ʿ", "ʾ", "‘"]
        return String(plegado.filter { !quitados.contains($0) }.map { $0 == "ı" ? "i" : $0 })
    }
}

/// Una altura con nombre en un sistema de ``NombresPorOctava``: la nota temperada (en el turco, la pitagórica) con
/// su octava, lo que se aparta de ella en los pasos del sistema y sus nombres.
public struct AlturaConNombre: Hashable, Sendable, CustomStringConvertible {
    public let sistema: NombresPorOctava
    /// La altura temperada (en el turco, la pitagórica, que se escribe con la misma nota).
    public let altura: Altura
    /// Cuartos de tono (árabe) o comas (turco) sobre `altura`: −1 en Sīkāh (Mi𝄳4) y en Segâh (Si4 una koma bajo).
    public let ajuste: Int
    /// Los nombres en las tres grafías: original, transliterada y ASCII.
    let nombres: [String]

    /// El nombre en una grafía: «سيكاه», «Sīkāh», «Sikah».
    public func nombre(en grafia: Grafia = .transliterada) -> String {
        switch grafia {
        case .original: return nombres[0]
        case .transliterada: return nombres[1]
        case .ascii: return nombres[2]
        }
    }

    /// La nota microtonal de la altura, sin su octava (la de `altura.octava`), con los cents desde Do (en el turco,
    /// en comas de 1200/53 cents). `nil` en el griego, que no tiene microtonos.
    public var notaMicrotonal: NotaMicrotonal? {
        guard let microtonal = sistema.sistemaDeAlturas else { return nil }
        let porOctava = microtonal.pasosPorOctava
        let cents = Double(modulo(sistema.pasos(de: altura, ajuste: ajuste), porOctava)) * 1200 / Double(porOctava)
        return NotaMicrotonal(temperada: altura.nota, sistema: microtonal, ajuste: ajuste, cents: cents)
    }

    /// El nombre transliterado y la altura: «Sīkāh (Mi𝄳4)».
    public var description: String {
        let nota = notaMicrotonal?.nombre ?? altura.nota.nombre
        return "\(nombre()) (\(nota)\(altura.octava))"
    }
}
