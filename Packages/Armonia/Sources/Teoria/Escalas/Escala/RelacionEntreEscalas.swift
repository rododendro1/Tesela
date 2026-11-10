import Elementos

// MARK: - Lo que separa a dos escalas

/// Lo que separa a dos escalas: las notas que comparten y las que solo están en una, los grados que cambian, las
/// quintas entre sus colecciones, la conducción mínima de Tymoczko de una a otra y lo que se parecen sus contenidos
/// (`RelacionEntreConjuntos`).
///
///     let relacion = Escala(.do, .mayor).relacion(con: Escala(.sol, .mayor))
///     relacion.distanciaEnQuintas      // 1
///     relacion.notasQueCambian         // 1: Fa → Fa♯
///     relacion.conduccion?.semitonosMovidos   // 1
///     Escala(.do).relacion(con: Escala(.do, .lidio)).cambios.map(\.hasta)   // [Fa♯]
public struct RelacionEntreEscalas: Hashable, Sendable {
    public let origen: Escala
    public let destino: Escala
    /// Las notas de `origen` que también están en `destino`, aunque se escriban de otra forma.
    public let comunes: [Nota]
    /// Las notas de `origen` que no suenan en `destino`.
    public let soloEnOrigen: [Nota]
    /// Las notas de `destino` que no suenan en `origen`.
    public let soloEnDestino: [Nota]
    /// Los grados que cambian, si las dos tienen la misma tónica y el mismo número de notas; si no, vacío.
    public let cambios: [CambioDeGrado]
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
        let suyas = Set(otra.notas.map(\.claseDeAltura))
        var cambios: [CambioDeGrado] = []
        if tonica.claseDeAltura == otra.tonica.claseDeAltura && notas.count == otra.notas.count {
            for (i, (desde, hasta)) in zip(notas, otra.notas).enumerated()
            where desde.claseDeAltura != hasta.claseDeAltura {
                cambios.append(CambioDeGrado(grado: i + 1, desde: desde, hasta: hasta))
            }
        }
        return RelacionEntreEscalas(
            origen: self, destino: otra, comunes: notas.filter { suyas.contains($0.claseDeAltura) },
            soloEnOrigen: notas.filter { !suyas.contains($0.claseDeAltura) },
            soloEnDestino: otra.notas.filter { !propias.contains($0.claseDeAltura) }, cambios: cambios,
            distanciaEnQuintas: abs(centro(otra) - centro(self)),
            notasQueCambian: suyas.subtracting(propias).count, conduccion: ConduccionMinima.entre(notas, otra.notas),
            conjunto: conjuntoDeClasesDeAltura.relacion(con: otra.conjuntoDeClasesDeAltura))
    }
}
