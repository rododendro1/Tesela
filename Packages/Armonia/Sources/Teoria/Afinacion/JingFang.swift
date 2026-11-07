import Elementos
import Foundation

// MARK: - Jing Fang: la cadena de sesenta quintas
//
// Jing Fang (京房, 77–37 a. C.) siguió el sanfen sunyi de los doce lü (`TipoDeEscala.shierLu`) más allá de la
// duodécima quinta, que no vuelve a huángzhōng («往而不返»), hasta sesenta: «中吕上生执始，执始下生去灭，上下相生，终于
// 南事，六十律毕矣» (Hou Hanshu, «Lüli zhi»): de zhònglǚ, la undécima quinta, sale zhíshǐ, y la cadena acaba en
// nánshì. Observó que la quinta 53 casi vuelve al punto de partida: 53 quintas justas son 31 octavas y unos 3,6 cents,
// la coma que siglos después se llamó de Mercator. Por eso 53 comas dividen tan bien la octava, y por eso las usa la
// teoría turca (`SistemaMicrotonal.comas53`), con la quinta en 31.
//
// Sesenta notas por octava no caben en una escala del catálogo, que va de doce en doce con desvíos: aquí están como
// dato, con su relación con las 53 comas.

/// La cadena de sesenta quintas justas de Jing Fang, desde huángzhōng (Do).
public enum JingFang {
    /// Los lü de la cadena: sesenta.
    public static let numeroDeLus = 60

    /// La quinta que casi vuelve a huángzhōng: la 53.
    public static let quintaQueVuelve = 53

    /// Los cents del lü que está a `quintas` quintas justas (3/2) de huángzhōng, dentro de la octava (de 0 a 1200).
    ///
    ///     JingFang.cents(deLaQuinta: 1)    // 701.955 (línzhōng)
    ///     JingFang.cents(deLaQuinta: 53)   // 3.615 (la coma de Mercator)
    public static func cents(deLaQuinta quintas: Int) -> Double {
        let total = Double(quintas) * centsDeLaQuinta
        return total - 1200 * (total / 1200).rounded(.down)
    }

    /// Los cents de los sesenta lü, en el orden en que salen (huángzhōng, línzhōng, tàicù…).
    public static var cadena: [Double] { (0..<numeroDeLus).map { cents(deLaQuinta: $0) } }

    /// Lo que la quinta 53 se pasa de huángzhōng: la coma de Mercator, unos 3,615 cents.
    public static var comaDeMercator: Double { cents(deLaQuinta: quintaQueVuelve) }

    /// El paso de las 53 comas que corresponde al lü: cada quinta son 31 comas. La quinta 12 cae en la coma 1 (la
    /// pitagórica) y la 53, en la 0.
    public static func pasoEnLas53Comas(deLaQuinta quintas: Int) -> Int {
        modulo(31 * quintas, SistemaMicrotonal.comas53.pasosPorOctava)
    }

    /// Lo que se aparta el lü de su paso de las 53 comas, en cents: muy poco, porque 53 comas son casi 53 quintas.
    public static func desvioDeLas53Comas(deLaQuinta quintas: Int) -> Double {
        let paso = 1200 / Double(SistemaMicrotonal.comas53.pasosPorOctava)
        var desvio = cents(deLaQuinta: quintas) - Double(pasoEnLas53Comas(deLaQuinta: quintas)) * paso
        if desvio > 600 { desvio -= 1200 }
        return desvio
    }

    /// El nombre del lü, si las fuentes lo dan: los doce primeros, como en `SistemaDeNombres.luChinos`; zhíshǐ
    /// (执始), la quinta 12, y nánshì (南事), la 59, la última. Los demás, `nil`.
    public static func nombre(deLaQuinta quintas: Int, grafia: Grafia = .transliterada) -> String? {
        switch quintas {
        case 0..<12: return SistemaDeNombres.luChinos.nombre(de: Nota(pasosDeQuinta: quintas), grafia: grafia)
        case 12: return ["执始", "zhíshǐ", "zhishi"][indice(grafia)]
        case 59: return ["南事", "nánshì", "nanshi"][indice(grafia)]
        default: return nil
        }
    }

    private static let centsDeLaQuinta = 1200 * log2(1.5)

    private static func indice(_ grafia: Grafia) -> Int {
        switch grafia {
        case .original: return 0
        case .transliterada: return 1
        case .ascii: return 2
        }
    }
}
