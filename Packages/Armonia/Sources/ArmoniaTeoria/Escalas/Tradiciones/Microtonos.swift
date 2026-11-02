import ArmoniaNucleo

// MARK: - Microtonos
//
// La capa microtonal de las escalas de otras tradiciones. Cada escala sigue siendo un `TipoDeEscala` de doce
// notas, con el que funciona todo lo demás (armonizar, el mástil, el Tonnetz…). Algunas tienen además una
// versión microtonal, `TipoDeEscala.microtonal`: dónde cae cada grado en la teoría de su tradición, medido en
// los pasos de su sistema (cuartos de tono o comas) desde la tónica temperada. Cada grado se aparta de su nota
// temperada medio semitono como mucho, y conserva su letra: Mi𝄳 se aproxima a Mi o a Mi♭, nunca a Re♯. También la
// tónica puede apartarse: Sīkāh empieza en Mi𝄳, y se escribe sobre Mi.

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

    /// Pasos por octava: 24, 53 o 24.
    public var pasosPorOctava: Int {
        switch self {
        case .cuartosDeTono, .persa: 24
        case .comas53: 53
        }
    }

    /// Tamaño de `pasos` pasos del sistema, en cents.
    public func cents(de pasos: Int) -> Double { Double(pasos) * 1200 / Double(pasosPorOctava) }
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

    public init(
        _ temperada: TipoDeEscala, _ sistema: SistemaMicrotonal, pasos: [Int], pasosDescendentes: [Int]? = nil
    ) {
        self.temperada = temperada
        self.sistema = sistema
        self.pasos = pasos
        self.pasosDescendentes = pasosDescendentes == pasos ? nil : pasosDescendentes
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

    /// Cuánto se aparta cada grado de la nota que escribe en su sistema: en cuartos de tono respecto de la nota
    /// temperada (y entonces la letra con su alteración y el medio signo dicen la nota), o en comas respecto de la
    /// nota pitagórica en el de 53 comas.
    func ajustes(sentido: SentidoDelIntervalo) -> [Int] {
        switch sistema {
        case .cuartosDeTono, .persa:
            return desvios(sentido: sentido).map { Int(($0 / 50).rounded()) }
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
    /// Cuartos de tono sobre la nota temperada (−1: medio bemol más), o comas sobre la pitagórica (comas53).
    public let ajuste: Int
    /// Cents desde la tónica temperada (la de `Escala.tonica`).
    public let cents: Double

    /// Nombre con el signo de su sistema: «Mi𝄳», «Si♭𝄳», «Si⁻¹» (una koma bajo Si). En ASCII, «Miqb», «Siq#» y
    /// «Si(-1)».
    public func nombre(en notacion: Notacion = .espanolCompacto) -> String {
        switch sistema {
        case .cuartosDeTono, .persa:
            let base = temperada.natural.nombre(en: notacion)
            let silaba = notacion.idiomaDeLasNotas.reglas.alteraciones == .palabras ? base.conMayusculaInicial : base
            let cuartos = 2 * temperada.alteracion.semitonos + ajuste
            let entera = Alteracion(cuartos / 2).simbolo(en: notacion.usaASCII ? .ascii : .conSimples)
            switch cuartos % 2 {
            case 1: return silaba + entera + (notacion.usaASCII ? "q#" : "𝄲")
            case -1: return silaba + entera + (notacion.usaASCII ? "qb" : "𝄳")
            default: return silaba + entera
            }
        case .comas53:
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
    public var description: String { nombre() }
}

extension Escala {
    /// La versión microtonal de la escala, si su tipo la tiene: Re Bayātī → Re Mi𝄳 Fa Sol La Si♭ Do.
    public func notasMicrotonales(sentido: SentidoDelIntervalo = .ascendente) -> [NotaMicrotonal]? {
        guard let microtonal = tipo.microtonal else { return nil }
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
    /// La versión microtonal de una escala de otra tradición (`nil` si no tiene). Como `categoria`, se busca por el
    /// nombre y solo vale si los intervalos coinciden: Bayātī la tiene; el frigio, con los mismos intervalos, no.
    public var microtonal: TipoDeEscalaMicrotonal? {
        guard let entrada = TipoDeEscalaMicrotonal.porNombre[nombre], entrada.temperada == self else { return nil }
        return entrada
    }
}

extension TipoDeEscalaMicrotonal {
    /// Las escalas con versión microtonal: los maqamat, los dastgāh y los makamlar que se aproximan, y los dromoi
    /// cuyas notas son las de su maqam o su makam.
    ///
    /// Los maqamat van en cuartos de tono, como en la teoría árabe moderna; los dastgāh, en la notación de
    /// Vaziri (el koron, un cuarto de tono bajo); los makamlar, en las comas de Arel-Ezgi-Uzdilek. Son las
    /// afinaciones teóricas: en la práctica cada intérprete y cada escuela afinan un poco distinto (la segah turca,
    /// por ejemplo, suena más baja que una coma).
    public static let catalogo: [TipoDeEscalaMicrotonal] = [
        // Maqamat (cuartos de tono).
        TipoDeEscalaMicrotonal(
            .maqamRast, .cuartosDeTono, pasos: [0, 4, 7, 10, 14, 18, 21], pasosDescendentes: [0, 4, 7, 10, 14, 18, 20]),
        TipoDeEscalaMicrotonal(.bayati, .cuartosDeTono, pasos: [0, 3, 6, 10, 14, 16, 20]),
        TipoDeEscalaMicrotonal(.saba, .cuartosDeTono, pasos: [0, 3, 6, 8, 14, 16, 20]),
        TipoDeEscalaMicrotonal(.suznak, .cuartosDeTono, pasos: [0, 4, 7, 10, 14, 16, 22]),
        TipoDeEscalaMicrotonal(.husayni, .cuartosDeTono, pasos: [0, 3, 6, 10, 14, 17, 20]),
        TipoDeEscalaMicrotonal(.nayruz, .cuartosDeTono, pasos: [0, 4, 7, 10, 14, 17, 20]),
        // Dastgāh (koron).
        TipoDeEscalaMicrotonal(.sur, .persa, pasos: [0, 3, 6, 10, 14, 16, 20]),
        TipoDeEscalaMicrotonal(.homayun, .persa, pasos: [0, 3, 8, 10, 14, 16, 20]),
        TipoDeEscalaMicrotonal(.cahargah, .persa, pasos: [0, 3, 8, 10, 14, 17, 22]),
        // Con la tónica en un cuarto de tono, escritas sobre la nota temperada: Sīkāh en Mi es Mi𝄳 Fa Sol La Si𝄳.
        TipoDeEscalaMicrotonal(.sikah, .cuartosDeTono, pasos: [-1, 2, 6, 10, 13, 16, 20]),
        TipoDeEscalaMicrotonal(.huzam, .cuartosDeTono, pasos: [-1, 2, 6, 8, 14, 16, 20]),
        TipoDeEscalaMicrotonal(.iraq, .cuartosDeTono, pasos: [-1, 2, 6, 9, 12, 16, 20]),
        // Dromoi: la afinación del maqam o el makam de que vienen, cuando sus notas son las del dromos. Ousák y
        // Sabáh, con la segunda neutra de Bayātī y de Ṣabā, en cuartos de tono; los que vienen de makamlar turcos, en
        // comas.
        TipoDeEscalaMicrotonal(.ousak, .cuartosDeTono, pasos: [0, 3, 6, 10, 14, 16, 20]),
        TipoDeEscalaMicrotonal(.sabah, .cuartosDeTono, pasos: [0, 3, 6, 8, 14, 16, 20]),
        TipoDeEscalaMicrotonal(.hitzaz, .comas53, pasos: [0, 5, 17, 22, 31, 35, 44]),
        TipoDeEscalaMicrotonal(.hitzazkiar, .comas53, pasos: [0, 5, 17, 22, 31, 36, 48]),
        TipoDeEscalaMicrotonal(.kartzigar, .comas53, pasos: [0, 8, 13, 22, 27, 39, 44]),
        TipoDeEscalaMicrotonal(
            .rast, .comas53, pasos: [0, 9, 17, 22, 31, 40, 48], pasosDescendentes: [0, 9, 17, 22, 31, 40, 44]),
        // Makamlar (comas de AEU).
        TipoDeEscalaMicrotonal(
            .rastMakami, .comas53, pasos: [0, 9, 17, 22, 31, 40, 48], pasosDescendentes: [0, 9, 17, 22, 31, 40, 44]),
        TipoDeEscalaMicrotonal(
            .hicazMakami, .comas53, pasos: [0, 5, 17, 22, 31, 39, 44], pasosDescendentes: [0, 5, 17, 22, 30, 35, 44]),
        TipoDeEscalaMicrotonal(.hicazkarMakami, .comas53, pasos: [0, 5, 17, 22, 31, 36, 48]),
        TipoDeEscalaMicrotonal(.ussakMakami, .comas53, pasos: [0, 8, 13, 22, 31, 35, 44]),
        TipoDeEscalaMicrotonal(
            .huseyniMakami, .comas53, pasos: [0, 8, 13, 22, 31, 39, 44], pasosDescendentes: [0, 8, 13, 22, 31, 35, 44]),
        // Segâh, desde la segâh (Si una koma bajo): sobre Si, el primer paso es −1.
        TipoDeEscalaMicrotonal(.segahMakami, .comas53, pasos: [-1, 4, 13, 22, 30, 35, 44]),
    ]

    /// Nombre de la escala temperada → su versión microtonal.
    static let porNombre: [String: TipoDeEscalaMicrotonal] = Dictionary(
        catalogo.map { ($0.temperada.nombre, $0) }, uniquingKeysWith: { primera, _ in primera })
}
