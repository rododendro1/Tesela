import ArmoniaNucleo
import ArmoniaTeoria

// MARK: - Signos microtonales
//
// Cómo se escribe una nota que se aparta de su nota temperada (`Evento.desvios`): el signo que lleva en cada formato
// y en el pentagrama SVG. Se deduce de los cents: un cuarto de tono es un medio bemol o un medio sostenido (o el
// koron y el sori, en una escala persa); lo demás se aproxima a las comas de 53 por octava de Arel-Ezgi-Uzdilek.

/// El signo de una nota que se aparta de su nota temperada.
package enum SignoMicrotonal: Hashable, Sendable {
    /// Cuartos de tono desde la nota natural, impares: −3 (tres cuartos de bemol), −1 (medio bemol), 1 y 3.
    case cuartos(Int)
    /// Comas (53 por octava) desde la nota natural: ±1 (koma), ±4 (bakiye), ±5 (küçük mücennep) y ±8 (büyük
    /// mücennep).
    case comas(Int)
    /// El koron persa: un cuarto de tono bajo la natural.
    case koron
    /// El sori persa: un cuarto de tono sobre la natural.
    case sori

    /// El signo de una nota escrita con `semitonos` de alteración que suena `desvio` cents más alta; `nil` si no se
    /// aparta, o si lo que se aparta no tiene signo (se escribe entonces la nota temperada). Con `persa`, el medio
    /// bemol y el medio sostenido se escriben como koron y sori.
    package init?(semitonos: Int, desvio: Double, persa: Bool = false) {
        guard abs(desvio) >= 0.5 else { return nil }
        // Redondeado a la centésima, como `Evento.desvios`, para que el pentagrama y los formatos den el mismo signo:
        // en Segâh, el Fa♯ una koma bajo cae justo entre 3 y 4 comas sobre Fa.
        let total = 100 * Double(semitonos) + (desvio * 100).rounded() / 100
        let cuartos = (total / 50).rounded()
        if abs(total / 50 - cuartos) < 0.1 {
            let n = Int(cuartos)
            guard n % 2 != 0, abs(n) <= 3 else { return nil }
            switch n {
            case -1 where persa: self = .koron
            case 1 where persa: self = .sori
            default: self = .cuartos(n)
            }
            return
        }
        let comas = Int((total * 53 / 1200).rounded())
        guard [-8, -5, -4, -1, 1, 4, 5, 8].contains(comas) else { return nil }
        self = .comas(comas)
    }

    /// El glifo de Bravura.
    var glifo: Glifo {
        switch self {
        case .cuartos(-3): GlifosSMuFL.tresCuartosBemol
        case .cuartos(-1): GlifosSMuFL.medioBemol
        case .cuartos(1): GlifosSMuFL.medioSostenido
        case .cuartos: GlifosSMuFL.tresCuartosSostenido
        case .comas(-8): GlifosSMuFL.buyukMucennebBemol
        case .comas(-5): GlifosSMuFL.kucukMucennebBemol
        case .comas(-4): GlifosSMuFL.bakiyeBemol
        case .comas(-1): GlifosSMuFL.komaBemol
        case .comas(1): GlifosSMuFL.komaSostenido
        case .comas(4): GlifosSMuFL.bakiyeSostenido
        case .comas(5): GlifosSMuFL.kucukMucennebSostenido
        case .comas: GlifosSMuFL.buyukMucennebSostenido
        case .koron: GlifosSMuFL.koron
        case .sori: GlifosSMuFL.sori
        }
    }

    /// El nombre SMuFL del glifo: «accidentalKomaFlat».
    package var smufl: String {
        switch self {
        case .cuartos(-3): return "accidentalThreeQuarterTonesFlatZimmermann"
        case .cuartos(-1): return "accidentalQuarterToneFlatStein"
        case .cuartos(1): return "accidentalQuarterToneSharpStein"
        case .cuartos: return "accidentalThreeQuarterTonesSharpStein"
        case .comas(let n):
            let nombre = [1: "Koma", 4: "Bakiye", 5: "KucukMucenneb", 8: "BuyukMucenneb"][abs(n)] ?? "Koma"
            return "accidental" + nombre + (n < 0 ? "Flat" : "Sharp")
        case .koron: return "accidentalKoron"
        case .sori: return "accidentalSori"
        }
    }

    /// El valor de `<accidental>` en MusicXML y, para las comas (que no tienen uno propio), el atributo `smufl`.
    package var musicXML: (valor: String, smufl: String?) {
        switch self {
        case .cuartos(-3): ("three-quarters-flat", nil)
        case .cuartos(-1): ("quarter-flat", nil)
        case .cuartos(1): ("quarter-sharp", nil)
        case .cuartos: ("three-quarters-sharp", nil)
        case .comas: ("other", smufl)
        case .koron: ("koron", nil)
        case .sori: ("sori", nil)
        }
    }

    /// El valor de `accid` en MEI: «1qf», «kf» (koma bemol, de Arel-Ezgi-Uzdilek), «koron».
    package var mei: String {
        switch self {
        case .cuartos(let n): "\(abs(n))q" + (n < 0 ? "f" : "s")
        case .comas(let n): ([1: "k", 4: "b", 5: "km", 8: "bm"][abs(n)] ?? "k") + (n < 0 ? "f" : "s")
        case .koron: "koron"
        case .sori: "sori"
        }
    }

    /// La terminación del nombre en LilyPond (`eh`, `isih`); `nil` para las comas, que se escriben temperadas.
    package var lilypond: String? {
        switch self {
        case .cuartos(-3): "eseh"
        case .cuartos(-1), .koron: "eh"
        case .cuartos(1), .sori: "ih"
        case .cuartos: "isih"
        case .comas: nil
        }
    }

    /// La alteración en ABC (`_/`, `^3/2`); `nil` para las comas, que se escriben temperadas.
    package var abc: String? {
        switch self {
        case .cuartos(-3): "_3/2"
        case .cuartos(-1), .koron: "_/"
        case .cuartos(1), .sori: "^/"
        case .cuartos: "^3/2"
        case .comas: nil
        }
    }
}

/// Una altura de una escala, con lo que se aparta de su nota temperada (en cents) y su nota microtonal.
package typealias AlturaMicrotonal = (altura: Altura, desvio: Double, nota: NotaMicrotonal?)

extension Escala {
    /// Las alturas de la escala con lo que se aparta cada una de su nota temperada, en cents, y su nota microtonal
    /// (`nil` si la escala no tiene microtonos), como las escriben el pentagrama y los
    /// formatos: la subida o la bajada y, si `sentido` es `nil`, la subida y, en las escalas que bajan con otras
    /// notas, también la bajada.
    package func alturasMicrotonales(octava: Int, sentido: SentidoDelIntervalo?) -> [AlturaMicrotonal] {
        func tramo(_ sentido: SentidoDelIntervalo) -> [AlturaMicrotonal] {
            let alturas = self.alturas(octava: octava, sentido: sentido)
            // Los desvíos y las notas van grado a grado desde la tónica; la de arriba se aparta como la de abajo
            // (en Sīkāh, las dos son Mi𝄳).
            var desvios = tipo.microtonal?.desvios(sentido: sentido) ?? []
            desvios += [desvios.first ?? 0]
            var notas = (notasMicrotonales(sentido: sentido) ?? []).map { Optional($0) }
            notas += [notas.first ?? nil]
            if sentido == .descendente {
                desvios.reverse()
                notas.reverse()
            }
            var resultado: [AlturaMicrotonal] = []
            for (i, altura) in alturas.enumerated() {
                let desvio = desvios.indices.contains(i) ? desvios[i] : 0
                resultado.append((altura, desvio, notas.indices.contains(i) ? notas[i] : nil))
            }
            return resultado
        }
        if let sentido { return tramo(sentido) }
        let subida = tramo(.ascendente)
        return tipo.esDireccional ? subida + tramo(.descendente).dropFirst() : subida
    }

    /// La escala en negras (o en `duracion`), con sus microtonos si los tiene, para exportarla: en
    /// `Escala("Re Bayātī").voz()`, el Mi𝄳 es un Mi♭4 cincuenta cents más alto.
    ///
    /// - Parameters:
    ///   - octava: la octava de la tónica.
    ///   - sentido: si se da, solo la subida o la bajada; si es `nil`, la subida y, en las escalas que bajan con
    ///     otras notas, también la bajada.
    public func voz(octava: Int = 4, sentido: SentidoDelIntervalo? = nil, duracion: Duracion = .negra) -> Voz {
        let alturas = alturasMicrotonales(octava: octava, sentido: sentido)
        return Voz(alturas.map { Evento($0.altura, duracion, desvio: $0.desvio) })
    }
}
