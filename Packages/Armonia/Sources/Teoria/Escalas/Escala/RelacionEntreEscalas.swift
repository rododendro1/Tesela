import Elementos

// MARK: - Lo que separa a dos escalas

/// Lo que separa a dos escalas: las quintas entre sus colecciones, las notas que cambian, la conducción mínima de
/// Tymoczko de una a otra y lo que se parecen sus contenidos (`RelacionEntreConjuntos`).
///
///     let relacion = Escala(.do, .mayor).relacion(con: Escala(.sol, .mayor))
///     relacion.distanciaEnQuintas      // 1
///     relacion.notasQueCambian         // 1: Fa → Fa♯
///     relacion.conduccion?.semitonosMovidos   // 1
public struct RelacionEntreEscalas: Hashable, Sendable {
    public let origen: Escala
    public let destino: Escala
    /// Las quintas que hay del centro de una al de la otra (la media de los pasos de quinta de sus notas): 1 de Do
    /// mayor a Sol mayor, 0 a La menor, 3 a Do menor. Es la distancia por el círculo de quintas de sus armaduras,
    /// y vale también para las escalas sin armadura.
    public let distanciaEnQuintas: Double
    /// Las notas de la segunda que no suenan en la primera.
    public let notasQueCambian: Int
    /// La conducción con menos semitonos de las notas de una a las de la otra (Tymoczko), o `nil` si tienen distinto
    /// número de notas y son demasiadas para probarlas todas.
    public let conduccion: ConduccionMinima?
    /// Lo que se parecen sus clases de altura: Fourier, Isaacson, Morris y Forte.
    public let conjunto: RelacionEntreConjuntos
}

extension Escala {
    /// Lo que la separa de otra escala (`RelacionEntreEscalas`).
    public func relacion(con otra: Escala) -> RelacionEntreEscalas {
        func centro(_ escala: Escala) -> Double {
            let notas = escala.notas
            return notas.isEmpty ? 0 : Double(notas.map(\.pasosDeQuinta).reduce(0, +)) / Double(notas.count)
        }
        let propias = Set(notas.map(\.claseDeAltura))
        let nuevas = Set(otra.notas.map(\.claseDeAltura)).subtracting(propias)
        return RelacionEntreEscalas(
            origen: self, destino: otra,
            distanciaEnQuintas: abs(centro(otra) - centro(self)),
            notasQueCambian: nuevas.count, conduccion: ConduccionMinima.entre(notas, otra.notas),
            conjunto: conjuntoDeClasesDeAltura.relacion(con: otra.conjuntoDeClasesDeAltura))
    }
}

extension ConduccionMinima {
    /// La conducción con menos semitonos de unas notas a otras, como ``Acorde/conduccionMinima(hasta:)``. Si son
    /// tantas como tantas, basta probar los giros de las dos ordenadas por su altura (en el círculo, la mejor
    /// conducción no cruza las voces); si no, se prueban todas las formas de duplicar, y `nil` si son demasiadas.
    static func entre(_ origen: [Nota], _ destino: [Nota]) -> ConduccionMinima? {
        var a: [Nota] = []
        var b: [Nota] = []
        for n in origen where !a.contains(where: { $0.claseDeAltura == n.claseDeAltura }) { a.append(n) }
        for n in destino where !b.contains(where: { $0.claseDeAltura == n.claseDeAltura }) { b.append(n) }
        guard !a.isEmpty, !b.isEmpty else { return ConduccionMinima(movimientos: []) }
        var mejor = ElMejor<[MovimientoDeVoz], (Int, Int)>(por: <)
        func proponer(_ movimientos: [MovimientoDeVoz]) {
            let coste = (
                movimientos.reduce(0) { $0 + abs($1.semitonos) }, movimientos.filter { $0.semitonos != 0 }.count
            )
            mejor.proponer(movimientos, coste: coste)
        }
        if a.count == b.count {
            let x = a.sorted { $0.claseDeAltura < $1.claseDeAltura }
            let y = b.sorted { $0.claseDeAltura < $1.claseDeAltura }
            for giro in y.indices {
                proponer(x.indices.map { MovimientoDeVoz(desde: x[$0], hasta: y[($0 + giro) % y.count]) })
            }
        } else {
            let (grande, pequeno) = a.count > b.count ? (a, b) : (b, a)
            var combinaciones = 1
            for _ in grande {
                combinaciones *= pequeno.count
                if combinaciones > 1_000_000 { return nil }
            }
            var eleccion = [Int](repeating: 0, count: grande.count)
            func probar(_ i: Int) {
                if i == grande.count {
                    guard Set(eleccion).count == pequeno.count else { return }
                    proponer(
                        grande.indices.map {
                            a.count > b.count
                                ? MovimientoDeVoz(desde: grande[$0], hasta: pequeno[eleccion[$0]])
                                : MovimientoDeVoz(desde: pequeno[eleccion[$0]], hasta: grande[$0])
                        })
                    return
                }
                for j in pequeno.indices {
                    eleccion[i] = j
                    probar(i + 1)
                }
            }
            probar(0)
        }
        // En el orden de las notas de la primera.
        let ordenados = (mejor.valor ?? []).enumerated().sorted {
            ((a.firstIndex(of: $0.element.desde) ?? 0), $0.offset) < (
                (a.firstIndex(of: $1.element.desde) ?? 0), $1.offset
            )
        }.map(\.element)
        return ConduccionMinima(movimientos: ordenados)
    }
}
