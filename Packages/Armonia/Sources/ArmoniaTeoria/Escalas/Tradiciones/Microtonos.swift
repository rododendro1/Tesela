import ArmoniaNucleo
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
// bizantina y los 22 śruti indios, que no son iguales: cada uno es una razón justa.

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

    /// Pasos por octava: 24, 53, 24, 72 o 22.
    public var pasosPorOctava: Int {
        switch self {
        case .cuartosDeTono, .persa: 24
        case .comas53: 53
        case .moria72: 72
        case .sruti: 22
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
    public static let razonesDeLosSruti: [(numerador: Int, denominador: Int)] = [
        (1, 1), (256, 243), (16, 15), (10, 9), (9, 8), (32, 27), (6, 5), (5, 4), (81, 64), (4, 3), (27, 20),
        (45, 32), (729, 512), (3, 2), (128, 81), (8, 5), (5, 3), (27, 16), (16, 9), (9, 5), (15, 8), (243, 128),
    ]

    static let centsDeLosSruti: [Double] = razonesDeLosSruti.map {
        1200 * log2(Double($0.numerador) / Double($0.denominador))
    }
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

    /// Cuánto se aparta cada grado de la nota que escribe en su sistema: en cuartos de tono o en moria respecto de
    /// la nota temperada (y entonces la letra con su alteración y el medio signo dicen la nota), en comas respecto
    /// de la nota pitagórica en el de 53 comas, o en comas sintónicas respecto de la pitagórica en el de los śruti.
    func ajustes(sentido: SentidoDelIntervalo) -> [Int] {
        switch sistema {
        case .cuartosDeTono, .persa:
            return desvios(sentido: sentido).map { Int(($0 / 50).rounded()) }
        case .moria72:
            return desvios(sentido: sentido).map { Int(($0 * 72 / 1200).rounded()) }
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
    /// sobre la temperada (moria72) o comas sintónicas sobre la pitagórica (śruti).
    public let ajuste: Int
    /// Cents desde la tónica temperada (la de `Escala.tonica`).
    public let cents: Double

    /// Nombre con el signo de su sistema: «Mi𝄳», «Si♭𝄳», «Si⁻¹» (una koma bajo Si), «Mi⁻²» (dos moria bajo Mi),
    /// «Mi↓» (una coma sintónica bajo el Mi pitagórico). En ASCII, «Miqb», «Siq#», «Si(-1)», «Mi(-2)» y «Mi(-1)».
    public func nombre(en notacion: Notacion = .espanolCompacto) -> String {
        switch sistema {
        case .cuartosDeTono, .persa:
            let base = temperada.natural.nombre(en: notacion)
            let silaba = notacion.idiomaDeLasNotas.reglas.alteraciones == .palabras ? base.conMayusculaInicial : base
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
    /// Las escalas con versión microtonal: los maqamat, los dastgāh y los makamlar que se aproximan, los dromoi, los
    /// echoi bizantinos y los thāṭ indios (con Yaman).
    ///
    /// Los maqamat van en cuartos de tono, como en la teoría árabe moderna; los dastgāh, en la notación de
    /// Vaziri (el koron, un cuarto de tono bajo); los makamlar, en las comas de Arel-Ezgi-Uzdilek; los echoi, en los
    /// moria de la Comisión Patriarcal; los thāṭ, en los 22 śruti, con razones justas. Son las
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
        TipoDeEscalaMicrotonal(.segah, .persa, pasos: [-1, 2, 6, 9, 12, 16, 20]),
        TipoDeEscalaMicrotonal(.nava, .persa, pasos: [0, 4, 6, 10, 14, 17, 20]),
        TipoDeEscalaMicrotonal(.bayateTork, .persa, pasos: [0, 4, 8, 10, 14, 18, 21]),
        TipoDeEscalaMicrotonal(.afshari, .persa, pasos: [0, 4, 7, 10, 14, 17, 20]),
        TipoDeEscalaMicrotonal(.dashti, .persa, pasos: [0, 3, 6, 10, 14, 16, 20]),
        TipoDeEscalaMicrotonal(.abuAta, .persa, pasos: [0, 3, 6, 10, 13, 16, 20]),
        TipoDeEscalaMicrotonal(.bayateEsfahan, .persa, pasos: [0, 4, 6, 10, 14, 17, 22]),
        // Con la tónica en un cuarto de tono, escritas sobre la nota temperada: Sīkāh en Mi es Mi𝄳 Fa Sol La Si𝄳.
        TipoDeEscalaMicrotonal(.sikah, .cuartosDeTono, pasos: [-1, 2, 6, 10, 13, 16, 20]),
        TipoDeEscalaMicrotonal(.huzam, .cuartosDeTono, pasos: [-1, 2, 6, 8, 14, 16, 20]),
        TipoDeEscalaMicrotonal(.iraq, .cuartosDeTono, pasos: [-1, 2, 6, 9, 12, 16, 20]),
        TipoDeEscalaMicrotonal(.rahatAlArwah, .cuartosDeTono, pasos: [-1, 2, 6, 8, 14, 16, 20]),
        TipoDeEscalaMicrotonal(.bayatiShuri, .cuartosDeTono, pasos: [0, 3, 6, 10, 12, 18, 20]),
        TipoDeEscalaMicrotonal(.jiharkah, .cuartosDeTono, pasos: [0, 4, 8, 10, 14, 18, 21]),
        // Dromoi, todos. Ousák y Sabáh, con la segunda neutra de Bayātī y de Ṣabā, en cuartos de tono (la segâh de
        // Uşşak, una koma bajo Mi, no cabe en su Mi♭). Los demás, en comas, con las perdes de Arel-Ezgi-Uzdilek: los
        // que tienen las notas de un makam, con las de ese makam (Hicaz, Hicazkâr, Suzinak, Nev'eser, Nikriz,
        // Karcığar, Rast); los que solo existen en Grecia, con sus mismos tetracordos: la segunda aumentada de 12 o
        // 13 comas entre dos semitonos de 4 o 5, como en Hicaz, la cuarta aumentada de Nikriz y lo demás pitagórico.
        TipoDeEscalaMicrotonal(.ousak, .cuartosDeTono, pasos: [0, 3, 6, 10, 14, 16, 20]),
        TipoDeEscalaMicrotonal(.sabah, .cuartosDeTono, pasos: [0, 3, 6, 8, 14, 16, 20]),
        TipoDeEscalaMicrotonal(.hitzaz, .comas53, pasos: [0, 5, 17, 22, 31, 35, 44]),
        TipoDeEscalaMicrotonal(.hitzazkiar, .comas53, pasos: [0, 5, 17, 22, 31, 36, 48]),
        // Pireótikos: Hicaz con la cuarta aumentada de Nikriz y un tetracordo Hicaz en la quinta.
        TipoDeEscalaMicrotonal(.pireotikos, .comas53, pasos: [0, 5, 17, 26, 31, 36, 48]),
        // Tabahaniótikos, como Suzinak: un pentacordo Rast y un tetracordo Hicaz.
        TipoDeEscalaMicrotonal(.tabahaniotikos, .comas53, pasos: [0, 9, 17, 22, 31, 36, 48]),
        // Niavént, como Nev'eser: un pentacordo Nikriz y un tetracordo Hicaz.
        TipoDeEscalaMicrotonal(.niavent, .comas53, pasos: [0, 9, 13, 26, 31, 36, 48]),
        // Nikríz: un pentacordo Nikriz y un tetracordo Bûselik.
        TipoDeEscalaMicrotonal(.nikriz, .comas53, pasos: [0, 9, 13, 26, 31, 40, 44]),
        // Kartzigár, como Karcığar: un tetracordo Uşşak y un pentacordo Hicaz en la cuarta.
        TipoDeEscalaMicrotonal(.kartzigar, .comas53, pasos: [0, 8, 13, 22, 27, 39, 44]),
        // Houzám y Sengáh: la segunda aumentada de 13 comas, y dos semitonos de 4 y 5 hasta la cuarta.
        TipoDeEscalaMicrotonal(.houzam, .comas53, pasos: [0, 13, 17, 22, 31, 40, 49]),
        TipoDeEscalaMicrotonal(.sengah, .comas53, pasos: [0, 13, 17, 22, 31, 36, 48]),
        // Tsingánikos: un tetracordo Hicaz y otro en la cuarta.
        TipoDeEscalaMicrotonal(.tsinganikos, .comas53, pasos: [0, 5, 17, 22, 27, 39, 44]),
        TipoDeEscalaMicrotonal(
            .rast, .comas53, pasos: [0, 9, 17, 22, 31, 40, 48], pasosDescendentes: [0, 9, 17, 22, 31, 40, 44]),
        // Kiourdí sube como Kartzigár y baja como Uşşak; Houseïní sube como Rast al bajar y baja como Bûselik.
        TipoDeEscalaMicrotonal(
            .kiourdi, .comas53, pasos: [0, 8, 13, 22, 27, 39, 44], pasosDescendentes: [0, 8, 13, 22, 31, 35, 44]),
        TipoDeEscalaMicrotonal(
            .houseini, .comas53, pasos: [0, 9, 17, 22, 31, 40, 44], pasosDescendentes: [0, 9, 13, 22, 31, 35, 44]),
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
        // Hüzzam, desde la segâh; Saba, Karcığar, Suzinak, Nikriz y Nev'eser, con las perdes de sus dromoi.
        TipoDeEscalaMicrotonal(.huzzamMakami, .comas53, pasos: [-1, 4, 13, 18, 30, 35, 44]),
        TipoDeEscalaMicrotonal(.sabaMakami, .comas53, pasos: [0, 8, 13, 18, 31, 35, 44]),
        TipoDeEscalaMicrotonal(.karcigarMakami, .comas53, pasos: [0, 8, 13, 22, 27, 39, 44]),
        TipoDeEscalaMicrotonal(.suzinakMakami, .comas53, pasos: [0, 9, 17, 22, 31, 36, 48]),
        TipoDeEscalaMicrotonal(.nikrizMakami, .comas53, pasos: [0, 9, 13, 26, 31, 40, 44]),
        TipoDeEscalaMicrotonal(.neveserMakami, .comas53, pasos: [0, 9, 13, 26, 31, 36, 48]),
        // Echoi bizantinos (moria de la Comisión Patriarcal, desde Ni = Do: Pa 12, Vou 22, Ga 30, Di 42, Ke 54, Zo 64).
        // Los diatónicos, con Vou y Zo dos moria bajo Mi y Si; el segundo, cromático blando (8, 14, 8); el plagal del
        // segundo, cromático duro (6, 20, 4). El varýs y el légetos empiezan en Zo y en Vou: su primer paso es −2.
        TipoDeEscalaMicrotonal(.echosProtos, .moria72, pasos: [0, 10, 18, 30, 42, 52, 60]),
        TipoDeEscalaMicrotonal(.echosPlagiosProtos, .moria72, pasos: [0, 10, 18, 30, 40, 48, 60]),
        TipoDeEscalaMicrotonal(.echosDefteros, .moria72, pasos: [0, 8, 22, 30, 42, 50, 64]),
        TipoDeEscalaMicrotonal(.echosPlagiosDefteros, .moria72, pasos: [0, 6, 26, 30, 42, 48, 68]),
        TipoDeEscalaMicrotonal(.echosVarys, .moria72, pasos: [-2, 6, 18, 28, 36, 48, 60]),
        TipoDeEscalaMicrotonal(.echosTetartos, .moria72, pasos: [0, 12, 22, 30, 42, 52, 60]),
        TipoDeEscalaMicrotonal(.echosPlagiosTetartos, .moria72, pasos: [0, 12, 22, 30, 42, 54, 64]),
        TipoDeEscalaMicrotonal(.echosLegetos, .moria72, pasos: [-2, 6, 18, 30, 40, 48, 60]),
        // Thāṭ y Yaman (los 22 śruti, por su número desde Sa: 0 = 1/1, 3 = 10/9, 7 = 5/4, 9 = 4/3, 13 = 3/2…). Los
        // de grado natural siguen el ṣaḍja-grāma de Bharata, el modelo de E. J. Arnold: Kāfī es Sa Re(10/9) ga(32/27)
        // ma Pa Dha(5/3) ni(16/9); Khamāj sube ga a Ga(5/4), Bilāval también ni a Ni(15/8) y Kalyāṇ, ma a Ma(45/32).
        // Los rāgas con ati-komal (Bhairav, Bhairavī, Toḍī) llevan el re y el dha pitagóricos (256/243, 128/81);
        // Toḍī, como lo miden Bel y otros (Ga 32/27, Ma 45/32, Ni 243/128); Mārvā y Pūrvī, el re de 16/15.
        TipoDeEscalaMicrotonal(.bilaval, .sruti, pasos: [0, 3, 7, 9, 13, 16, 20]),
        TipoDeEscalaMicrotonal(.kalyan, .sruti, pasos: [0, 3, 7, 11, 13, 16, 20]),
        TipoDeEscalaMicrotonal(.yaman, .sruti, pasos: [0, 3, 7, 11, 13, 16, 20]),
        TipoDeEscalaMicrotonal(.khamaj, .sruti, pasos: [0, 3, 7, 9, 13, 16, 18]),
        TipoDeEscalaMicrotonal(.kafi, .sruti, pasos: [0, 3, 5, 9, 13, 16, 18]),
        TipoDeEscalaMicrotonal(.asavari, .sruti, pasos: [0, 3, 5, 9, 13, 14, 18]),
        TipoDeEscalaMicrotonal(.bhairavi, .sruti, pasos: [0, 1, 5, 9, 13, 14, 18]),
        TipoDeEscalaMicrotonal(.bhairav, .sruti, pasos: [0, 1, 7, 9, 13, 14, 20]),
        TipoDeEscalaMicrotonal(.marva, .sruti, pasos: [0, 2, 7, 11, 13, 16, 20]),
        TipoDeEscalaMicrotonal(.purvi, .sruti, pasos: [0, 2, 7, 11, 13, 15, 20]),
        TipoDeEscalaMicrotonal(.todi, .sruti, pasos: [0, 1, 5, 11, 13, 14, 21]),
    ]

    /// Nombre de la escala temperada → su versión microtonal.
    static let porNombre: [String: TipoDeEscalaMicrotonal] = Dictionary(
        catalogo.map { ($0.temperada.nombre, $0) }, uniquingKeysWith: { primera, _ in primera })
}
