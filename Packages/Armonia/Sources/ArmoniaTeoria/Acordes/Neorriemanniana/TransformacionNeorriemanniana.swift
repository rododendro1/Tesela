import ArmoniaElementos
import Foundation

// Las transformaciones neorriemannianas: P, L y R cambian una tríada mayor o menor por la que
// comparte con ella dos notas, moviendo la tercera solo un semitono o un tono. En el Tonnetz
// son giros del triángulo sobre uno de sus lados:
//
//   P (homónima): sobre la quinta. Do ↔ Do menor.
//   L (cambio de sensible, Leittonwechsel): sobre la tercera menor. Do ↔ Mi menor.
//   R (relativa): sobre la tercera mayor. Do ↔ La menor.
//
// Las tres son involuciones (aplicadas dos veces, devuelven la tríada) y conservan la
// ortografía: R de Mi♭ es Do menor, no Si♯ menor. N, S y H son las compuestas habituales.

/// P, L o R: el paso de una tríada mayor o menor a una vecina, que en el Tonnetz es el triángulo de al lado.
///
///     Acorde("Do").transformar(.r)                 // Lam
///     try Acorde("Do").transformar(leyendo: "LP")  // Mi
///     Acorde("Do").caminoNeorriemanniano(hasta: "Mibm")   // [.p, .r, .p]
public enum TransformacionNeorriemanniana: String, CaseIterable, Hashable, Sendable, CustomStringConvertible {
    /// Paralela: la tercera sube o baja un semitono (Do ↔ Dom).
    case p = "P"
    /// Cambio de sensible: en mayor, la fundamental baja un semitono (Do → Mim); en menor, la
    /// quinta sube un semitono (Mim → Do).
    case l = "L"
    /// Relativa: en mayor, la quinta sube un tono (Do → Lam); en menor, la fundamental baja un
    /// tono (Lam → Do).
    case r = "R"

    public var description: String { rawValue }

    /// "homónima", "cambio de sensible" o "relativa".
    public var nombre: String {
        switch self {
        case .p: return "homónima"
        case .l: return "cambio de sensible"
        case .r: return "relativa"
        }
    }

    /// N (Nebenverwandt), RLP: Do → Fam. Lleva a la subdominante menor.
    public static let n: [TransformacionNeorriemanniana] = [.r, .l, .p]
    /// S (Slide), LPR: Do → Do♯m. Conserva la tercera y mueve las otras dos un semitono.
    public static let s: [TransformacionNeorriemanniana] = [.l, .p, .r]
    /// H (polo hexatónico), LPL: Do → Sol♯m. Mueve las tres notas un semitono.
    public static let h: [TransformacionNeorriemanniana] = [.l, .p, .l]

    /// Lee una secuencia como "PLR", "P L R", "R·L·P" o "LP-R", que se aplica de izquierda a
    /// derecha; N, S y H se desarrollan en sus tres pasos. Lanza `ErrorDeLecturaDeTeoria` (`.nombreNoReconocido`,
    /// en su carácter) si hay otra cosa, y `ErrorDeLectura` (`.textoVacio`) si no hay ninguna.
    public static func secuencia(leyendo texto: String) throws -> [TransformacionNeorriemanniana] {
        var resultado: [TransformacionNeorriemanniana] = []
        for (posicion, original) in texto.enumerated() {
            switch original.uppercased() {
            case "P": resultado.append(.p)
            case "L": resultado.append(.l)
            case "R": resultado.append(.r)
            case "N": resultado += n
            case "S": resultado += s
            case "H": resultado += h
            case " ", "·", "-", ",", ".", "*", "∘": continue
            default:
                throw ErrorDeLecturaDeTeoria(
                    texto: texto, posicion: posicion,
                    motivo: .nombreNoReconocido(String(original), opciones: ["P", "L", "R", "N", "S", "H"]))
            }
        }
        guard !resultado.isEmpty else { throw ErrorDeLectura(texto: texto, posicion: nil, motivo: .textoVacio) }
        return resultado
    }

    /// La que lleva de una tríada a otra vecina, si la hay: `entre("Do", "Lam")` → `.r`.
    public static func entre(_ origen: Acorde, _ destino: Acorde) -> TransformacionNeorriemanniana? {
        allCases.first { origen.transformar($0).map { $0 == destino.enEstadoFundamental } ?? false }
    }
}
extension Acorde {
    /// Esta tríada en estado fundamental (sin inversión).
    package var enEstadoFundamental: Acorde { Acorde(fundamental, tipo) }

    /// La tríada transformada por P, L o R, en estado fundamental; `nil` si no es una tríada
    /// mayor o menor. Conserva la ortografía: R de Mi♭ es Do menor, no Si♯ menor.
    ///
    ///     Acorde("Do").transformar(.p)    // Dom
    ///     Acorde("Lam").transformar(.l)   // Fa
    public func transformar(_ transformacion: TransformacionNeorriemanniana) -> Acorde? {
        guard tipo == .mayor || tipo == .menor else { return nil }
        // En pasos de quinta: la tercera mayor son cuatro hacia arriba y la menor, tres hacia abajo.
        func triada(_ quintas: Int, _ tipo: TipoDeAcorde) -> Acorde {
            Acorde(Nota(pasosDeQuinta: fundamental.pasosDeQuinta + quintas), tipo)
        }
        switch (transformacion, tipo == .mayor) {
        case (.p, true): return triada(0, .menor)
        case (.p, false): return triada(0, .mayor)
        case (.l, true): return triada(4, .menor) // Do → Mim
        case (.l, false): return triada(-4, .mayor) // Mim → Do
        case (.r, true): return triada(3, .menor) // Do → Lam
        case (.r, false): return triada(-3, .mayor) // Lam → Do
        }
    }

    /// La tríada tras una secuencia, de izquierda a derecha: `transformar([.l, .p])` es P de L.
    public func transformar(_ secuencia: [TransformacionNeorriemanniana]) -> Acorde? {
        secuencia.reduce(Optional(self)) { $0?.transformar($1) }
    }

    /// La tríada tras una secuencia escrita: `transformar(leyendo: "PLR")`, `transformar(leyendo: "N")`. Lanza el
    /// error de `TransformacionNeorriemanniana.secuencia(leyendo:)` si la secuencia no se lee, y da `nil` si el
    /// acorde no es una tríada mayor o menor.
    public func transformar(leyendo secuencia: String) throws -> Acorde? {
        transformar(try TransformacionNeorriemanniana.secuencia(leyendo: secuencia))
    }

    /// La secuencia más corta de P, L y R que lleva de esta tríada a otra (vacía si son la
    /// misma); `nil` si alguno de los acordes no es una tríada mayor o menor. Con ortografía,
    /// Do♯ y Re♭ son destinos distintos; con `enarmonico: true` basta que suenen igual.
    /// A igual longitud, se prefiere P, luego L y luego R al principio del camino.
    ///
    ///     Acorde("Do").caminoNeorriemanniano(hasta: "Lab")    // [.p, .l]: Do → Dom → La♭
    public func caminoNeorriemanniano(
        hasta destino: Acorde, enarmonico: Bool = false
    ) -> [TransformacionNeorriemanniana]? {
        let inicio = enEstadoFundamental
        let meta = destino.enEstadoFundamental
        guard inicio.transformar(.p) != nil, meta.transformar(.p) != nil else { return nil }
        func llega(_ triada: Acorde) -> Bool {
            guard triada.tipo == meta.tipo else { return false }
            return enarmonico
                ? triada.fundamental.claseDeAltura == meta.fundamental.claseDeAltura
                : triada.fundamental == meta.fundamental
        }
        // Por la red de tríadas, que es infinita y conexa: siempre llega.
        return caminoMasCorto(
            desde: inicio, clave: { $0 },
            vecinos: { triada in
                TransformacionNeorriemanniana.allCases.compactMap { t in triada.transformar(t).map { (t, $0) } }
            },
            llega: llega)
    }
}

// MARK: - Idiomas
//
// Los nombres de las transformaciones neorriemannianas en los quince idiomas de los textos (`Traduccion`).

extension TransformacionNeorriemanniana: Nombrable {
    /// El nombre de la transformación en el idioma de los textos: «relativa», «relative».
    public func nombre(en notacion: Notacion) -> String {
        let traduccion: Traduccion
        switch self {
        case .p:
            traduccion = TextosDeTeoria.traduccion(\.homonima)
        case .l:
            traduccion = TextosDeTeoria.traduccion(\.cambioDeSensible)
        case .r:
            traduccion = TextosDeTeoria.traduccion(\.relativa)
        }
        return traduccion.en(notacion)
    }
}
