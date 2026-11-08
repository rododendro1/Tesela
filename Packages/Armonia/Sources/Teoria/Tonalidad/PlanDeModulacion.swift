import Elementos

// Planificar una modulación: cómo ir de una tonalidad a otra. La inversa de `RecorridoTonal`, que encuentra las
// modulaciones de una progresión; aquí se escriben.

/// Un camino de una tonalidad a otra: una progresión que afirma la de partida con una cadencia (I–IV–V7–I), pasa
/// por un acorde que hace de puente y confirma la de llegada con otra cadencia.
///
///     let plan = Tonalidad(.do).modulaciones(hasta: Tonalidad(.sol))[0]
///     plan.tecnica                  // .acordeComun
///     plan.acordes                  // [Do, Fa, Sol7, Do, Lam, Re7, Sol]
///     plan.pivote?.description      // "Lam = vi en Do mayor = ii en Sol mayor"
public struct PlanDeModulacion: Hashable, Sendable, CustomStringConvertible {
    /// Cómo se pasa de una tonalidad a otra.
    public enum Tecnica: Hashable, Sendable, CaseIterable {
        /// Por un acorde que es de las dos tonalidades: se oye en la de partida y se entiende en la de llegada
        /// (Lam, vi en Do y ii en Sol). Luego, V7–I en la nueva.
        case acordeComun
        /// Por un acorde de séptima disminuida de la de partida que, escrito de otra forma, es el vii°7 de la de
        /// llegada: Do♯°7 (vii°7/ii en Do) suena igual que Sol°7 (vii°7 en La♭). Luego, I64–V7–I en la nueva.
        case disminuidaEnarmonica
        /// Sin puente: el ii–V7–I de la tonalidad nueva justo después de la cadencia de la de partida.
        case directa
    }

    public let tecnica: Tecnica
    public let desde: Tonalidad
    public let hasta: Tonalidad
    /// La progresión entera, de la cadencia de partida a la de llegada.
    public let acordes: [Acorde]
    /// El acorde puente, con su lectura en cada tonalidad (en la disminuida enarmónica, cada lectura escrita a su
    /// manera). `nil` en la modulación directa.
    public let pivote: AcordePivote?

    /// "Do Fa Sol7 Do Lam Re7 Sol (pivote: Lam = vi en Do mayor = ii en Sol mayor)".
    public var description: String { descripcion(en: .compacta(.espanol)) }

    public func descripcion(en notacion: Notacion) -> String {
        let progresion = acordes.map { $0.cifrado(en: notacion) }.joined(separator: " ")
        guard let pivote else { return progresion }
        return progresion + " (" + TextosDeTeoria.en(notacion, \.pivote) + ": " + pivote.descripcion(en: notacion) + ")"
    }
}

extension Tonalidad {
    /// Maneras de modular de esta tonalidad a otra, de la más suave a la más brusca:
    ///
    /// 1. Por cada **acorde común** a las dos tonalidades (tríadas de ``armonizar(cuatriadas:)``), primero los que
    ///    en la nueva son ii o IV (preparan su dominante), luego vi y iii. No sirven la tónica de la partida, ni la
    ///    tónica o la dominante de la llegada, ni las tríadas disminuidas.
    /// 2. Por una **séptima disminuida enarmónica**: el vii°7 de la tonalidad de partida o de uno de sus grados
    ///    (vii°7/ii, vii°7/V…) que suena igual que el vii°7 de la nueva, escrito de otra forma.
    /// 3. La modulación **directa**: el ii–V7–I de la nueva sin puente, que siempre se puede.
    ///
    /// Vacío si las dos tonalidades son la misma.
    ///
    ///     Tonalidad(.do).modulaciones(hasta: Tonalidad(.sol))[0].pivote?.acorde    // Lam
    ///     Tonalidad(.do).modulaciones(hasta: Tonalidad(Nota.la.bemol))[0].tecnica  // .disminuidaEnarmonica
    public func modulaciones(hasta destino: Tonalidad) -> [PlanDeModulacion] {
        guard destino != self else { return [] }
        let partida = [acorde(grado: 1), acorde(grado: 4), acorde(grado: 5, cuatriada: true), acorde(grado: 1)]
        let tonicaNueva = destino.acorde(grado: 1)
        let dominanteNueva = destino.acorde(grado: 5, cuatriada: true)
        var planes: [PlanDeModulacion] = []

        func plan(_ tecnica: PlanDeModulacion.Tecnica, _ puente: (Acorde, Acorde)?, _ llegada: [Acorde])
            -> PlanDeModulacion
        {
            let acordes = partida + (puente.map { [$0.0] } ?? []) + llegada
            let pivote = puente.map { par in
                AcordePivote(
                    indice: partida.count,
                    enLaDePartida: analizar(par.0, siguiente: llegada.first),
                    tonalidadDePartida: self,
                    enLaDeLlegada: destino.analizar(par.1, siguiente: llegada.first),
                    tonalidadDeLlegada: destino)
            }
            return PlanDeModulacion(tecnica: tecnica, desde: self, hasta: destino, acordes: acordes, pivote: pivote)
        }

        // 1. Acordes comunes, por el grado que tienen en la nueva.
        let propios = armonizar()
        for grado in [2, 4, 6, 3] {
            let comun = destino.acorde(grado: grado)
            let calidad = comun.tipo.estructura.calidadDeTriada
            guard calidad == .mayor || calidad == .menor, comun != propios[0],
                propios.contains(comun), comun != tonicaNueva
            else { continue }
            planes.append(plan(.acordeComun, (comun, comun), [dominanteNueva, tonicaNueva]))
        }

        // 2. La séptima disminuida de la nueva, escrita como una de la de partida.
        let sensibleNueva = Acorde(destino.tonica + .septimaMayor, .disminuidoSeptima)
        let clases = Set(sensibleNueva.notas.map(\.claseDeAltura))
        let cuartaYSexta = Acorde(tonicaNueva.fundamental, tonicaNueva.tipo, inversion: 2)
        for grado in 1...6 {
            let objetivo = acorde(grado: grado)
            let calidad = objetivo.tipo.estructura.calidadDeTriada
            guard calidad == .mayor || calidad == .menor else { continue }
            let disminuida = Acorde(objetivo.fundamental + .septimaMayor, .disminuidoSeptima)
            guard Set(disminuida.notas.map(\.claseDeAltura)) == clases,
                Set(disminuida.notas) != Set(sensibleNueva.notas)
            else { continue }
            planes.append(
                plan(.disminuidaEnarmonica, (disminuida, sensibleNueva), [cuartaYSexta, dominanteNueva, tonicaNueva]))
        }

        // 3. Directa.
        let segundo = destino.acorde(grado: 2, cuatriada: true)
        planes.append(plan(.directa, nil, [segundo, dominanteNueva, tonicaNueva]))
        return planes
    }
}
