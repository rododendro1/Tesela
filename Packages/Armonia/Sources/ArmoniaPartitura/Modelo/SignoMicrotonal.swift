import ArmoniaNucleo
import ArmoniaTeoria

// MARK: - Signos microtonales
//
// Cómo se escribe una nota que se aparta de su nota temperada (`Evento.Nota.desvio`): el signo que lleva en cada formato
// y en el pentagrama SVG. Se deduce de los cents: un cuarto de tono es un medio bemol o un medio sostenido (o el
// koron y el sori, en una escala persa); un número exacto de moria (72 por octava), un signo de doceavos de tono de
// Wyschnegradsky; lo demás se aproxima a las comas de 53 por octava de Arel-Ezgi-Uzdilek. Una nota que sabe en qué
// sistema está (`Evento.Nota.sistema`, como las de una escala microtonal) lleva el signo de su sistema: el koron y
// el sori de un dastgāh, los moria de un echos, la flecha de Helmholtz-Ellis de un śruti.

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
    /// Moria (doceavos de tono, 72 por octava) desde la nota natural, con los signos de Wyschnegradsky: ±2, ±4, ±8 y
    /// ±10 (−2: dos moria bajo la natural; 8: un sostenido y dos moria).
    case moria(Int)
    /// La flecha de Helmholtz-Ellis de una coma sintónica (81/80) en una alteración: `flecha(-1, -1)` es un bemol una
    /// coma bajo; `flecha(0, 1)`, un becuadro una coma sobre.
    case flecha(semitonos: Int, comas: Int)

    /// Los moria que tienen signo.
    static let moriaConSigno: Set<Int> = [-10, -8, -4, -2, 2, 4, 8, 10]

    /// El signo de una nota escrita con `semitonos` de alteración que suena `desvio` cents más alta; `nil` si no se
    /// aparta, o si lo que se aparta no tiene signo (se escribe entonces la nota temperada). Con `persa`, el medio
    /// bemol y el medio sostenido se escriben como koron y sori.
    package init?(semitonos: Int, desvio: Double, persa: Bool = false) {
        guard abs(desvio) >= 0.5 else { return nil }
        // Redondeado a la centésima, como `Evento.Nota.desvio`, para que el pentagrama y los formatos den el mismo signo:
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
        // Un número exacto de moria (los de 53 comas nunca lo son: les falta un tercio de cent como poco).
        let moria = total * 72 / 1200
        if abs(moria - moria.rounded()) < 0.01 {
            guard SignoMicrotonal.moriaConSigno.contains(Int(moria.rounded())) else { return nil }
            self = .moria(Int(moria.rounded()))
            return
        }
        let comas = Int((total * 53 / 1200).rounded())
        guard [-8, -5, -4, -1, 1, 4, 5, 8].contains(comas) else { return nil }
        self = .comas(comas)
    }

    /// El signo de una nota escrita en un sistema microtonal, `ajuste` pasos apartada (``NotaMicrotonal/ajuste``):
    /// el koron de un dastgāh, los moria de un echos bizantino, la flecha de un śruti; en los demás, por los cents,
    /// como `init(semitonos:desvio:)`.
    package init?(sistema: SistemaMicrotonal, ajuste: Int, semitonos: Int, desvio: Double) {
        switch sistema {
        case .sruti:
            guard ajuste != 0, abs(ajuste) == 1, (-1...1).contains(semitonos) else { return nil }
            self = .flecha(semitonos: semitonos, comas: ajuste)
        case .moria72:
            guard SignoMicrotonal.moriaConSigno.contains(6 * semitonos + ajuste) else { return nil }
            self = .moria(6 * semitonos + ajuste)
        case .persa: self.init(semitonos: semitonos, desvio: desvio, persa: true)
        case .cuartosDeTono, .comas53, .razones: self.init(semitonos: semitonos, desvio: desvio)
        }
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
        case .moria(-10): GlifosSMuFL.moriaBemol10
        case .moria(-8): GlifosSMuFL.moriaBemol8
        case .moria(-4): GlifosSMuFL.moriaBemol4
        case .moria(-2): GlifosSMuFL.moriaBemol2
        case .moria(2): GlifosSMuFL.moriaSostenido2
        case .moria(4): GlifosSMuFL.moriaSostenido4
        case .moria(8): GlifosSMuFL.moriaSostenido8
        case .moria: GlifosSMuFL.moriaSostenido10
        case .flecha(let semitonos, let comas):
            switch (semitonos, comas < 0) {
            case (..<0, true): GlifosSMuFL.bemolFlechaAbajo
            case (0, true): GlifosSMuFL.becuadroFlechaAbajo
            case (_, true): GlifosSMuFL.sostenidoFlechaAbajo
            case (..<0, false): GlifosSMuFL.bemolFlechaArriba
            case (0, false): GlifosSMuFL.becuadroFlechaArriba
            case (_, false): GlifosSMuFL.sostenidoFlechaArriba
            }
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
        case .moria(let n): return "accidentalWyschnegradsky\(abs(n))Twelfths" + (n < 0 ? "Flat" : "Sharp")
        case .flecha(let semitonos, let comas):
            let alteracion = semitonos < 0 ? "Flat" : semitonos == 0 ? "Natural" : "Sharp"
            return "accidental" + alteracion + "OneArrow" + (comas < 0 ? "Down" : "Up")
        }
    }

    /// El valor de `<accidental>` en MusicXML y, para las comas (que no tienen uno propio), el atributo `smufl`.
    package var musicXML: (valor: String, smufl: String?) {
        switch self {
        case .cuartos(-3): ("three-quarters-flat", nil)
        case .cuartos(-1): ("quarter-flat", nil)
        case .cuartos(1): ("quarter-sharp", nil)
        case .cuartos: ("three-quarters-sharp", nil)
        case .comas, .moria, .flecha: ("other", smufl)
        case .koron: ("koron", nil)
        case .sori: ("sori", nil)
        }
    }

    /// El valor de `accid` en MEI: «1qf», «kf» (koma bemol, de Arel-Ezgi-Uzdilek), «koron»; `nil` para los moria y
    /// las flechas, que MEI no tiene y se escriben temperados.
    package var mei: String? {
        switch self {
        case .cuartos(let n): "\(abs(n))q" + (n < 0 ? "f" : "s")
        case .comas(let n): ([1: "k", 4: "b", 5: "km", 8: "bm"][abs(n)] ?? "k") + (n < 0 ? "f" : "s")
        case .koron: "koron"
        case .sori: "sori"
        case .moria, .flecha: nil
        }
    }

    /// La terminación del nombre en LilyPond (`eh`, `isih`); `nil` para las comas, los moria y las flechas, que se
    /// escriben temperados.
    package var lilypond: String? {
        switch self {
        case .cuartos(-3): "eseh"
        case .cuartos(-1), .koron: "eh"
        case .cuartos(1), .sori: "ih"
        case .cuartos: "isih"
        case .comas, .moria, .flecha: nil
        }
    }

    /// La alteración en ABC (`_/`, `^3/2`); `nil` para las comas, los moria y las flechas, que se escriben
    /// temperados.
    package var abc: String? {
        switch self {
        case .cuartos(-3): "_3/2"
        case .cuartos(-1), .koron: "_/"
        case .cuartos(1), .sori: "^/"
        case .cuartos: "^3/2"
        case .comas, .moria, .flecha: nil
        }
    }
}

/// Una altura de una escala, con lo que se aparta de su nota temperada (en cents) y su nota microtonal.
package typealias AlturaMicrotonal = (altura: Altura, desvio: Double, nota: NotaMicrotonal?)

extension Escala {
    /// Las alturas de la escala con lo que se aparta cada una de su nota temperada, en cents, y su nota microtonal
    /// (`nil` si la escala no tiene microtonos), como las escriben el pentagrama y los
    /// formatos: la subida o la bajada y, si `sentido` es `nil`, la subida y, en las escalas que bajan con otras
    /// notas, también la bajada. Con `octavas` mayor que 1, la escala sube (y baja) esas octavas desde la tónica de
    /// `octava`.
    package func alturasMicrotonales(
        octava: Int, octavas: Int = 1, sentido: SentidoDelIntervalo?
    ) -> [AlturaMicrotonal] {
        let octavas = max(1, octavas)
        /// Una altura `o` octavas más aguda.
        func subir(_ altura: AlturaMicrotonal, _ o: Int) -> AlturaMicrotonal {
            (Altura(altura.altura.nota, octava: altura.altura.octava + o), altura.desvio, altura.nota)
        }
        // La escala de una octava, repetida: al subir, de la más grave a la más aguda; al bajar, al revés. La nota de
        // llegada (la tónica de arriba o la de abajo) va una sola vez, al final.
        func tramo(_ sentido: SentidoDelIntervalo) -> [AlturaMicrotonal] {
            let una = tramoDeUnaOctava(sentido)
            guard octavas > 1, let llegada = una.last else { return una }
            let orden = sentido == .ascendente ? Array(0..<octavas) : Array((0..<octavas).reversed())
            let repetidas = orden.flatMap { o in una.dropLast().map { subir($0, o) } }
            return repetidas + [subir(llegada, sentido == .ascendente ? octavas - 1 : 0)]
        }
        func tramoDeUnaOctava(_ sentido: SentidoDelIntervalo) -> [AlturaMicrotonal] {
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
    ///   - octavas: cuántas octavas sube (y baja) la escala.
    ///   - sentido: si se da, solo la subida o la bajada; si es `nil`, la subida y, en las escalas que bajan con
    ///     otras notas, también la bajada.
    public func voz(
        octava: Int = 4, octavas: Int = 1, sentido: SentidoDelIntervalo? = nil, duracion: Duracion = .negra
    ) -> Voz {
        let alturas = alturasMicrotonales(octava: octava, octavas: octavas, sentido: sentido)
        return Voz(alturas.map { Evento(notas: [Evento.Nota($0)], duracion: duracion) })
    }
}
