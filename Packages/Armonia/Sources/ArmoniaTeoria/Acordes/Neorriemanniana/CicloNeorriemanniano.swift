import ArmoniaNucleo
import Foundation

// Los ciclos neorriemannianos: alternando dos de las transformaciones P, L y R se vuelve a la
// tríada de partida, recorriendo en el Tonnetz una banda de triángulos (`Tonnetz(ciclo:desde:)`).
//
//   hexatónico (P, L): seis tríadas, Do – Dom – La♭ – La♭m – Mi – Mim (Cohn, 1996);
//   octatónico (P, R): ocho, Do – Dom – Mi♭ – Mi♭m – Sol♭ – Fa♯m – La – Lam;
//   LR (L, R): las veinticuatro, por quintas, Do – Mim – Sol – Sim – Re…
//
// Con ortografía, el ciclo no se cierra: tras seis pasos del hexatónico, Do llega a Re𝄫. Por
// eso cada tríada se escribe con la ortografía más sencilla (Mi, no Fa♭; Fa♯m, no Sol♭m) y la
// última es la de partida. En el dibujo, la banda sigue recta y los puntos llevan el nombre de
// la primera tríada del ciclo que los toca.

/// Un ciclo de tríadas que se cierra alternando dos transformaciones neorriemannianas.
///
///     Acorde("Do").ciclo(.hexatonico)    // [Do, Dom, La♭, La♭m, Mi, Mim, Do]
///     Tonnetz(ciclo: .octatonico, desde: "Do").svg()
public enum CicloNeorriemanniano: String, CaseIterable, Hashable, Sendable, CustomStringConvertible {
    /// P y L: seis tríadas, que se reparten las seis notas de una escala hexatónica.
    case hexatonico
    /// P y R: ocho tríadas, con las notas de una escala octatónica.
    case octatonico
    /// L y R: las veinticuatro tríadas mayores y menores, avanzando por quintas.
    case lr

    /// Las dos transformaciones que se alternan, empezando por la primera.
    public var transformaciones: [TransformacionNeorriemanniana] {
        switch self {
        case .hexatonico: return [.p, .l]
        case .octatonico: return [.p, .r]
        case .lr: return [.l, .r]
        }
    }

    /// Cuántas tríadas distintas tiene: 6, 8 o 24.
    public var longitud: Int {
        switch self {
        case .hexatonico: return 6
        case .octatonico: return 8
        case .lr: return 24
        }
    }

    /// "ciclo hexatónico", "ciclo octatónico" o "ciclo LR".
    public var nombre: String {
        switch self {
        case .hexatonico: return "ciclo hexatónico"
        case .octatonico: return "ciclo octatónico"
        case .lr: return "ciclo LR"
        }
    }

    /// "hexatonic cycle", "octatonic cycle" o "LR cycle".
    public var nombreEnIngles: String {
        switch self {
        case .hexatonico: return "hexatonic cycle"
        case .octatonico: return "octatonic cycle"
        case .lr: return "LR cycle"
        }
    }

    /// En los quince idiomas de los textos: "ciclo hexatónico", "hexatonic cycle", "cicle hexatònic",
    /// "ciclo hexatónico", "ziklo hexatonikoa".
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .hexatonico:
            return TextosDeTeoria.en(notacion, \.cicloHexatonico)
        case .octatonico:
            return TextosDeTeoria.en(notacion, \.cicloOctatonico)
        case .lr:
            return TextosDeTeoria.en(notacion, \.cicloLR)
        }
    }

    public var description: String { nombre }

    /// Lee "hexatónico", "hexatonico", "hexatonic", "octatónico", "octatonic", "LR"… o el ciclo
    /// por sus transformaciones ("PL", "PR", "LR").
    /// Si no es ninguno, lanza `ErrorDeLecturaDeTeoria` con los que sí (`.nombreNoReconocido`).
    public init(leyendo texto: String) throws {
        let limpio = texto.claveDeBusqueda
            .replacingOccurrences(of: "ciclo ", with: "").replacingOccurrences(of: " cycle", with: "")
            .trimmingCharacters(in: .whitespaces)
        switch limpio {
        case "hexatonico", "hexatonic", "pl", "lp": self = .hexatonico
        case "octatonico", "octatonic", "pr", "rp": self = .octatonico
        case "lr", "rl": self = .lr
        default:
            let opciones = Self.allCases.map(\.rawValue)
            throw ErrorDeLecturaDeTeoria(
                texto: texto, posicion: nil, motivo: .nombreNoReconocido(texto, opciones: opciones))
        }
    }
}
extension Acorde {
    /// Las tríadas de un ciclo desde esta, hasta volver a ella (que se repite al final), cada
    /// una con la ortografía más sencilla; `nil` si no es una tríada mayor o menor.
    ///
    ///     Acorde("Do").ciclo(.hexatonico)    // [Do, Dom, La♭, La♭m, Mi, Mim, Do]
    public func ciclo(_ ciclo: CicloNeorriemanniano) -> [Acorde]? {
        let inicio = enEstadoFundamental
        guard inicio.transformar(.p) != nil else { return nil }
        var triadas = [inicio]
        var actual = inicio
        while triadas.count <= ciclo.longitud {
            guard let siguiente = actual.transformar(ciclo.transformaciones[(triadas.count - 1) % 2]) else {
                return nil
            }
            actual = triadas.count == ciclo.longitud ? inicio : siguiente.triadaSencilla
            triadas.append(actual)
        }
        return triadas
    }

    /// La misma tríada escrita como su enarmónica (la fundamental, doce quintas más allá) si
    /// tiene dobles alteraciones o si la enarmónica lleva al menos dos alteraciones menos: Fa♭
    /// pasa a Mi y Sol♭m (con Si𝄫) a Fa♯m, pero La♭m sigue siendo La♭m.
    package var triadaSencilla: Acorde {
        func alteraciones(_ acorde: Acorde) -> Int { acorde.notas.map { abs($0.alteracion.semitonos) }.reduce(0, +) }
        func conDobles(_ acorde: Acorde) -> Bool { acorde.notas.contains { abs($0.alteracion.semitonos) > 1 } }
        let enarmonicas = [-12, 12].map { Acorde(Nota(pasosDeQuinta: fundamental.pasosDeQuinta + $0), tipo) }
        // La de menos alteraciones; a igualdad, la primera.
        let mejor = alteraciones(enarmonicas[1]) < alteraciones(enarmonicas[0]) ? enarmonicas[1] : enarmonicas[0]
        if conDobles(self) && !conDobles(mejor) || alteraciones(mejor) <= alteraciones(self) - 2 { return mejor }
        return self
    }
}
