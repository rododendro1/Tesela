import Elementos
import Foundation

// MARK: - Microtonos
//
// La capa microtonal de las escalas de otras tradiciones. Cada escala sigue siendo un `TipoDeEscala` de doce
// notas, con el que funciona todo lo demás (armonizar, el mástil, el Tonnetz…). Algunas tienen además una
// versión microtonal, `TipoDeEscala.microtonal`: dónde cae cada grado en la teoría de su tradición, medido en
// los pasos de su sistema (cuartos de tono o comas) desde la tónica temperada. Cada grado se aparta de su nota
// temperada medio semitono como mucho, y conserva su letra: Mi𝄳 se aproxima a Mi o a Mi♭, nunca a Re♯. También la
// tónica puede apartarse: Sīkāh empieza en Mi𝄳, y se escribe sobre Mi.
//
// Los sistemas: los cuartos de tono árabes, el koron persa, las 53 comas turcas, los 72 moria de la salmodia
// bizantina, los 22 śruti indios, que no son iguales: cada uno es una razón justa, y los cents de cualquier otra razón
// justa (los géneros de Arquitas y de Ptolomeo) o de una octava en partes iguales (el gamelan, los xilófonos
// africanos, la música de Tailandia y Camboya).

/// Con qué teoría se mide una escala microtonal: cuántos pasos tiene la octava y cómo se escriben.
public enum SistemaMicrotonal: String, Sendable, Codable, CaseIterable {
    /// 24 cuartos de tono por octava, la teoría árabe moderna: Mi𝄳 (medio bemol) y Fa𝄲 (medio sostenido).
    case cuartosDeTono
    /// Las 53 comas de Arel-Ezgi-Uzdilek, la teoría turca: la nota pitagórica y las comas que se aparta de ella
    /// (Si⁻¹, una koma baja).
    case comas53
    /// La notación persa de Vaziri: el koron baja un cuarto de tono y el sori lo sube. Unicode no tiene sus
    /// signos, así que se escriben como el medio bemol y el medio sostenido (𝄳, 𝄲).
    case persa
    /// Los 72 moria de la octava de la Comisión Patriarcal de Constantinopla (1881), la teoría de la salmodia
    /// bizantina: el tono mayor tiene 12, el menor 10 y el menor de todos 8. Se escriben con los moria que se
    /// apartan de la nota temperada (Mi⁻², dos moria bajo Mi; un morio es la sexta parte de un semitono).
    case moria72
    /// Los 22 śruti de la música india, cada uno una razón justa: de 1/1 a 256/243, 16/15, 10/9, 9/8… y 243/128.
    /// Cada nota es la pitagórica o se aparta de ella una coma sintónica (81/80), y se escribe con la flecha de
    /// Helmholtz-Ellis: Mi↓ (5/4, una coma bajo el Mi pitagórico de 81/64), Re♭↑ (16/15).
    case sruti
    /// Cents cualesquiera (1200 por octava): las razones justas de los géneros de Arquitas y de Ptolomeo (28/27,
    /// 8/7…) y de los grāma que no están entre los 22 śruti, y las octavas partidas en partes iguales que no son doce
    /// (el pélog en nueve, el sléndro y el amadinda en cinco, el timbila y el piphat en siete). Se escriben con los
    /// cents que se apartan de la nota temperada: Fa(−37¢).
    case razones

    /// Pasos por octava: 24, 53, 24, 72, 22 o 1200.
    public var pasosPorOctava: Int {
        switch self {
        case .cuartosDeTono, .persa: 24
        case .comas53: 53
        case .moria72: 72
        case .sruti: 22
        case .razones: 1200
        }
    }

    /// Tamaño de `pasos` pasos del sistema, en cents. En el de los śruti, los cents del śruti (que no son iguales).
    public func cents(de pasos: Int) -> Double {
        guard self == .sruti else { return Double(pasos) * 1200 / Double(pasosPorOctava) }
        let octavas = pasos >= 0 ? pasos / 22 : (pasos - 21) / 22
        return 1200 * Double(octavas) + SistemaMicrotonal.centsDeLosSruti[pasos - 22 * octavas]
    }

    /// Las razones de los 22 śruti desde Sa: entre dos seguidos hay un limma (256/243), una coma sintónica (81/80)
    /// o un semitono menor (25/24).
    public static let razonesDeLosSruti: [RazonDeFrecuencias] = [
        .init(1, 1), .init(256, 243), .init(16, 15), .init(10, 9), .init(9, 8), .init(32, 27), .init(6, 5), .init(5, 4),
        .init(81, 64), .init(4, 3), .init(27, 20), .init(45, 32), .init(729, 512), .init(3, 2), .init(128, 81),
        .init(8, 5), .init(5, 3), .init(27, 16), .init(16, 9), .init(9, 5), .init(15, 8), .init(243, 128),
    ]

    static let centsDeLosSruti: [Double] = razonesDeLosSruti.map(\.cents)
}

/// Una escala con microtonos: su aproximación de doce notas (`temperada`) y la posición de cada grado en los
/// pasos de su `sistema`, contados desde la tónica temperada. La tónica misma puede caer fuera de su nota
/// temperada: en Sīkāh, sobre Mi, el primer paso es −1 (Mi𝄳, un cuarto de tono bajo).
///
///     TipoDeEscala.bayati.microtonal?.cents        // [0, 150, 300, 500, 700, 800, 1000]
///     TipoDeEscala.bayati.microtonal?.desvios      // [0, 50, 0, 0, 0, 0, 0]: Mi𝄳 es Mi♭ + 50 cents
public struct TipoDeEscalaMicrotonal: Hashable, Sendable {
    /// La escala de doce notas a la que se aproxima.
    public let temperada: TipoDeEscala
    public let sistema: SistemaMicrotonal
    /// Posición de cada grado al subir, en pasos del sistema desde la tónica temperada (uno por cada intervalo
    /// de `temperada`, en el mismo orden; el primero, 0 salvo que la tónica sea un microtono).
    public let pasos: [Int]
    /// Lo mismo al bajar, si la escala baja con otras notas; `nil` si baja como sube.
    public let pasosDescendentes: [Int]?
    /// De quién es esta afinación, cuando la escala tiene más de una: el autor y el año («Chrysanthos, 1832»), que
    /// no se traducen. `nil` en la primera, la de su teoría de hoy, que dice ya su `sistema`.
    public let fuente: String?

    /// Una escala con microtonos; si `pasosDescendentes` es igual que `pasos`, se guarda `nil`.
    public init(
        _ temperada: TipoDeEscala, _ sistema: SistemaMicrotonal, pasos: [Int], pasosDescendentes: [Int]? = nil,
        fuente: String? = nil
    ) {
        self.temperada = temperada
        self.sistema = sistema
        self.pasos = pasos
        self.pasosDescendentes = pasosDescendentes == pasos ? nil : pasosDescendentes
        self.fuente = fuente
    }

    /// Los pasos en un sentido.
    public func pasos(sentido: SentidoDelIntervalo) -> [Int] {
        sentido == .ascendente ? pasos : pasosDescendentes ?? pasos
    }

    /// Los intervalos temperados en un sentido.
    public func intervalos(sentido: SentidoDelIntervalo) -> [Intervalo] {
        sentido == .ascendente ? temperada.intervalos : temperada.intervalosDescendentes ?? temperada.intervalos
    }

    /// Cents de cada grado desde la tónica temperada.
    public func cents(sentido: SentidoDelIntervalo = .ascendente) -> [Double] {
        pasos(sentido: sentido).map(sistema.cents(de:))
    }

    /// Cents de cada grado al subir.
    public var cents: [Double] { cents() }

    /// Cuánto se aparta cada grado de su nota temperada, en cents (Mi𝄳 sobre Mi♭: +50).
    public func desvios(sentido: SentidoDelIntervalo = .ascendente) -> [Double] {
        zip(cents(sentido: sentido), intervalos(sentido: sentido)).map { $0 - Double(100 * $1.semitonos) }
    }

    /// Los desvíos al subir.
    public var desvios: [Double] { desvios() }

    /// ¿Hay un paso por grado en los dos sentidos, y ninguno se aparta más de medio semitono de su nota temperada?
    public var esCoherente: Bool {
        for sentido in [SentidoDelIntervalo.ascendente, .descendente] {
            guard pasos(sentido: sentido).count == intervalos(sentido: sentido).count else { return false }
            if desvios(sentido: sentido).contains(where: { abs($0) > 50 }) { return false }
        }
        return true
    }

    /// Cuánto se aparta cada grado de la nota que escribe en su sistema: en cuartos de tono o en moria respecto de
    /// la nota temperada (y entonces la letra con su alteración y el medio signo dicen la nota), en comas respecto
    /// de la nota pitagórica en el de 53 comas, o en comas sintónicas respecto de la pitagórica en el de los śruti.
    func ajustes(sentido: SentidoDelIntervalo) -> [Int] {
        switch sistema {
        case .cuartosDeTono, .persa:
            return desvios(sentido: sentido).map { Int(($0 / 50).rounded()) }
        case .moria72:
            return desvios(sentido: sentido).map { Int(($0 * 72 / 1200).rounded()) }
        case .razones:
            return desvios(sentido: sentido).map { Int($0.rounded()) }
        case .sruti:
            return zip(cents(sentido: sentido), intervalos(sentido: sentido)).map { cents, intervalo in
                // La nota pitagórica, a quintas justas (3/2) de la tónica: Mi, cuatro quintas sobre Do, a 81/64.
                let quinta = 1200 * log2(1.5)
                var pitagorica = (Double(intervalo.pasosDeQuinta) * quinta).truncatingRemainder(dividingBy: 1200)
                if pitagorica < 0 { pitagorica += 1200 }
                var diferencia = cents - pitagorica
                if diferencia > 600 { diferencia -= 1200 }
                if diferencia < -600 { diferencia += 1200 }
                return Int((diferencia / (1200 * log2(81.0 / 80))).rounded())
            }
        case .comas53:
            return zip(pasos(sentido: sentido), intervalos(sentido: sentido)).map { pasos, intervalo in
                // La nota pitagórica está a 31 comas por quinta: Mi, cuatro quintas sobre Do, a 18.
                let pitagorica = ((intervalo.pasosDeQuinta * 31) % 53 + 53) % 53
                var ajuste = pasos - pitagorica
                if ajuste > 26 { ajuste -= 53 }
                if ajuste < -26 { ajuste += 53 }
                return ajuste
            }
        }
    }
}

// MARK: - Notas microtonales

/// Una nota de una escala microtonal: su nota temperada, el sistema en que se escribe y cuánto se aparta (en
/// cuartos de tono de la temperada, o en comas de la pitagórica en el sistema de 53 comas).
public struct NotaMicrotonal: Hashable, Sendable {
    /// La nota de la aproximación de doce notas.
    public let temperada: Nota
    public let sistema: SistemaMicrotonal
    /// Cuartos de tono sobre la nota temperada (−1: medio bemol más), comas sobre la pitagórica (comas53), moria
    /// sobre la temperada (moria72), comas sintónicas sobre la pitagórica (śruti) o cents sobre la temperada
    /// (razones).
    public let ajuste: Int
    /// Cents desde la tónica temperada (la de `Escala.tonica`).
    public let cents: Double

    /// Nombre con el signo de su sistema: «Mi𝄳», «Si♭𝄳», «Si⁻¹» (una koma bajo Si), «Mi⁻²» (dos moria bajo Mi),
    /// «Mi↓» (una coma sintónica bajo el Mi pitagórico), «Fa(−37¢)» (37 cents bajo Fa). En ASCII, «Miqb», «Siq#»,
    /// «Si(-1)», «Mi(-2)», «Mi(-1)» y «Fa(-37c)».
    /// El nombre en español: «Mi𝄳».
    public var nombre: String { nombre(en: .compacta(.espanol)) }

    public func nombre(en notacion: Notacion) -> String {
        NotaMicrotonal.nombre(temperada, sistema: sistema, ajuste: ajuste, en: notacion)
    }

    /// El nombre de la nota temperada que se aparta `ajuste` pasos de `sistema`, como `nombre(en:)`.
    package static func nombre(
        _ temperada: Nota, sistema: SistemaMicrotonal, ajuste: Int, en notacion: Notacion
    ) -> String {
        switch sistema {
        case .cuartosDeTono, .persa:
            let base = temperada.natural.nombre(en: notacion)
            let silaba = notacion.reglasDeLasNotas.alteraciones == .palabras ? base.conMayusculaInicial : base
            let cuartos = 2 * temperada.alteracion.semitonos + ajuste
            let alteracion = Alteracion(cuartos / 2)
            let entera = alteracion.esNatural ? "" : alteracion.simbolo(en: notacion.tipografia)
            switch cuartos % 2 {
            case 1: return silaba + entera + (notacion.usaASCII ? "q#" : "𝄲")
            case -1: return silaba + entera + (notacion.usaASCII ? "qb" : "𝄳")
            default: return silaba + entera
            }
        case .sruti:
            let nombre = temperada.nombre(en: notacion)
            guard ajuste != 0 else { return nombre }
            if notacion.usaASCII { return nombre + "(\(ajuste > 0 ? "+" : "")\(ajuste))" }
            return nombre + String(repeating: ajuste > 0 ? "↑" : "↓", count: abs(ajuste))
        case .razones:
            let nombre = temperada.nombre(en: notacion)
            guard ajuste != 0 else { return nombre }
            if notacion.usaASCII { return nombre + "(\(ajuste > 0 ? "+" : "-")\(abs(ajuste))c)" }
            return nombre + "(\(ajuste > 0 ? "+" : "−")\(abs(ajuste))¢)"
        case .comas53, .moria72:
            let nombre = temperada.nombre(en: notacion)
            guard ajuste != 0 else { return nombre }
            if notacion.usaASCII { return nombre + "(\(ajuste > 0 ? "+" : "")\(ajuste))" }
            let volados: [Character: Character] = [
                "0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴", "5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹",
            ]
            return nombre + (ajuste > 0 ? "⁺" : "⁻") + String(String(abs(ajuste)).map { volados[$0] ?? $0 })
        }
    }
}

extension NotaMicrotonal: CustomStringConvertible {
    public var description: String { nombre }
}

extension Escala {
    /// La versión microtonal de la escala, si su tipo la tiene: Re Bayātī → Re Mi𝄳 Fa Sol La Si♭ Do. Con
    /// `afinacion`, en otra de las de `tipo.afinaciones` (o en una cualquiera de su misma escala temperada).
    public func notasMicrotonales(
        sentido: SentidoDelIntervalo = .ascendente, afinacion: TipoDeEscalaMicrotonal? = nil
    ) -> [NotaMicrotonal]? {
        guard let microtonal = afinacion ?? tipo.microtonal, microtonal.temperada == tipo else { return nil }
        let intervalos = microtonal.intervalos(sentido: sentido)
        let ajustes = microtonal.ajustes(sentido: sentido)
        let cents = microtonal.cents(sentido: sentido)
        return intervalos.indices.map { i in
            NotaMicrotonal(
                temperada: tonica + intervalos[i], sistema: microtonal.sistema, ajuste: ajustes[i], cents: cents[i])
        }
    }
}

// MARK: - Catálogo

extension TipoDeEscala {
    /// La versión microtonal de una escala de otra tradición (`nil` si no tiene). Como `categoria`, se busca por su
    /// `identidad`: Bayātī la tiene; el frigio, con los mismos intervalos, no.
    public var microtonal: TipoDeEscalaMicrotonal? { afinaciones.first }

    /// Todas las versiones microtonales de la escala: la de su teoría de hoy (`microtonal`) y las de otros autores,
    /// cada una con su `fuente`. Los echoi diatónicos tienen dos: en los 72 moria de la Comisión Patriarcal (1881) y
    /// en los 68 de Chrysanthos (1832). Vacío si no tiene ninguna.
    public var afinaciones: [TipoDeEscalaMicrotonal] {
        TipoDeEscala.delCatalogo[identidad]?.afinaciones ?? []
    }
}

extension TipoDeEscalaMicrotonal {
    /// Las escalas con versión microtonal: los maqamat, los dastgāh y los makamlar que se aproximan, los dromoi, los
    /// echoi bizantinos, los thāṭ indios (con Yaman), los grāma y las mūrchanā, y los tetracordos griegos.
    ///
    /// Los maqamat van en cuartos de tono, como en la teoría árabe moderna; los dastgāh, en la notación de
    /// Vaziri (el koron, un cuarto de tono bajo); los makamlar, en las comas de Arel-Ezgi-Uzdilek; los echoi, en los
    /// moria de la Comisión Patriarcal; los thāṭ, en los 22 śruti, con razones justas. Son las
    /// afinaciones teóricas: en la práctica cada intérprete y cada escuela afinan un poco distinto (la segah turca,
    /// por ejemplo, suena más baja que una coma).
    ///
    /// Cada una se declara con su escala (`afinaciones:` en su declaración); aquí van por tradiciones, en el orden de
    /// `Tradicion.allCases` (y en cada una, en el de sus listas), y después las occidentales (`occidentales`).
    public static let catalogo: [TipoDeEscalaMicrotonal] =
        Tradicion.allCases.flatMap { tradicion in
            TipoDeEscala.listasTradicionales.filter { $0.tradicion == tradicion }.flatMap(\.tipos)
        }.flatMap(\.afinaciones) + occidentales

    /// Las versiones microtonales de escalas occidentales, que no son de ninguna tradición: la de blues, con sus
    /// blue notes, como se suelen describir: la tercera neutra, entre la menor y la mayor (350 cents, el Mi𝄳 sobre
    /// Do), y la séptima armónica (7/4, 969 cents, 31 bajo Si♭), con la cuarta y la quinta puras. La ♭5 queda
    /// temperada. Son una aproximación: cada intérprete las entona a su manera, y las desliza.
    public static let occidentales: [TipoDeEscalaMicrotonal] = TipoDeEscala.occidentales.flatMap(\.afinaciones)
}
