import Elementos

// Las disposiciones de un acorde que se usan en el piano y en el jazz: cerrada, drop 2, drop 3, drop 2 y 4, la
// «shell» (fundamental, tercera y séptima) y las notas guía (tercera y séptima), y la conducción de una progresión
// con la menor suma de movimientos de las voces.

/// Cómo se reparten las notas de un acorde entre las voces.
///
/// Las cuatro primeras parten de cuatro notas (`Acorde.notasParaDisponer`) en posición cerrada, todas dentro de una
/// octava, y bajan una octava alguna de las voces, contadas desde la más aguda:
///
/// - `cerrada`: ninguna (Do Mi Sol Si);
/// - `drop2`: la segunda (Sol Do Mi Si: del Do Mi Sol Si cerrado, el Sol baja una octava);
/// - `drop3`: la tercera (Mi Do Sol Si);
/// - `drop24`: la segunda y la cuarta (Do Sol Mi Si, con el Do y el Sol bajados).
///
/// Las otras dos son de tres y dos voces: `shell` es el bajo con la tercera y la séptima encima (en los dos órdenes),
/// y `notasGuia`, solo la tercera y la séptima.
///
/// `sinFundamentalA` y `sinFundamentalB` son las disposiciones de piano sin fundamental (*rootless*) de Bill Evans:
/// tercera, quinta, séptima y novena (la A) o séptima, novena, tercera y quinta (la B); en un acorde de dominante, la
/// 13.ª va en lugar de la quinta (Sol7: Si Mi Fa La y Fa La Si Mi). La novena y la 13.ª, si el acorde no las tiene,
/// salen de su escala (``Arpegio/nota(delGrado:)``). `dosManos` pone la fundamental y la séptima en la mano
/// izquierda y la tercera, la quinta (o la 13.ª) y la novena en la derecha: Do Si♭ Mi La Re en Do7.
///
/// `cuartal` son cuatro notas por cuartas (justas, o alguna aumentada), como en el jazz modal: Re Sol Do Fa para
/// Rem7, Fa Si Mi La para Sol7. Salen de la escala de siete notas del acorde con menos notas
/// a evitar (`Acorde.escalasCompatibles(entre:)`), llevan sus notas guía y ninguna nota a evitar.
public enum DisposicionDeAcorde: String, CaseIterable, Hashable, Sendable {
    case cerrada
    case drop2
    case drop3
    case drop24
    case shell
    case notasGuia
    case cuartal
    case sinFundamentalA
    case sinFundamentalB
    case dosManos

    /// Cuántas voces tiene: 4, salvo la shell (3), las notas guía (2) y la de dos manos (5).
    public var voces: Int {
        switch self {
        case .shell: return 3
        case .notasGuia: return 2
        case .dosManos: return 5
        default: return 4
        }
    }

    /// Las voces que bajan una octava desde la posición cerrada, contadas desde la más aguda (0).
    var vocesQueBajan: [Int] {
        switch self {
        case .drop2: return [1]
        case .drop3: return [2]
        case .drop24: return [1, 3]
        default: return []
        }
    }

    /// El ámbito por omisión: de Do3 a Sol5, el de la mano izquierda y el centro del piano.
    public static let ambito: ClosedRange<Int> = 48...79
}

extension Acorde {
    /// Las notas que se disponen (cuatro como mucho), ordenadas hacia arriba desde la fundamental. Un acorde de más
    /// de cuatro notas se queda con la tercera, la séptima (o la sexta) y las tensiones (la 13.ª, la 9.ª y la 11.ª,
    /// por ese orden) y, si cabe, la fundamental y la quinta. Las de menos de cuatro (una tríada) se doblan al
    /// disponerlas: Do Mi Sol Do.
    ///
    ///     Acorde("Do").notasParaDisponer        // [Do, Mi, Sol]
    ///     Acorde("Sol13").notasParaDisponer     // [La, Si, Mi, Fa]: 9, 3, 13 y 7
    public var notasParaDisponer: [Nota] {
        var unicas: [Nota] = []
        for nota in notas where !unicas.contains(nota) { unicas.append(nota) }
        if unicas.count > 4 {
            var elegidas: [Nota] = []
            func anadir(_ candidatas: [Nota]) {
                for nota in candidatas where elegidas.count < 4 && !elegidas.contains(nota) { elegidas.append(nota) }
            }
            anadir(notas(conPapel: .tercera) + notas(conPapel: .suspension))
            anadir(notas(conPapel: .septima) + notas(conPapel: .sexta))
            for numero in [13, 9, 11] { anadir(notas(conPapel: .tension(numero))) }
            anadir([fundamental])
            anadir(quinta.map { [$0] } ?? [])
            unicas = unicas.filter { elegidas.contains($0) }
        }
        return unicas.sorted { Acorde.distancia(fundamental, $0) < Acorde.distancia(fundamental, $1) }
    }

    /// Semitonos de `a` a `b` hacia arriba, de 0 a 11.
    static func distancia(_ a: Nota, _ b: Nota) -> Int { ((b.claseDeAltura - a.claseDeAltura) % 12 + 12) % 12 }

    /// Todas las maneras de disponer el acorde con las alturas dentro de `ambito` (números MIDI), de grave a agudo,
    /// sin repetir, ordenadas por su voz más grave y después por la más aguda.
    ///
    ///     Acorde("Do7").disposiciones(.drop2, en: 48...72).first   // [Do3, Sol3, Si♭3, Mi4]
    public func disposiciones(
        _ disposicion: DisposicionDeAcorde, en ambito: ClosedRange<Int> = DisposicionDeAcorde.ambito
    ) -> [[Altura]] {
        var resultado: [[Altura]] = []
        for base in formas(disposicion) {
            guard let grave = base.first?.midi, let agudo = base.last?.midi else { continue }
            // Las octavas en que cabe la forma.
            let desde = Int((Double(ambito.lowerBound - grave) / 12).rounded(.up))
            let hasta = Int((Double(ambito.upperBound - agudo) / 12).rounded(.down))
            guard desde <= hasta else { continue }
            for n in desde...hasta {
                let movida = base.map { $0.octavas(n) }
                if !resultado.contains(movida) { resultado.append(movida) }
            }
        }
        return resultado.sorted { a, b in
            (a.first?.midi ?? 0, a.last?.midi ?? 0) < (b.first?.midi ?? 0, b.last?.midi ?? 0)
        }
    }

    /// Las formas de la disposición en una octava cualquiera, de grave a agudo: una por cada nota que pueda ir en el
    /// bajo de la posición cerrada (o, en la shell y las notas guía, por cada orden de la tercera y la séptima).
    func formas(_ disposicion: DisposicionDeAcorde) -> [[Altura]] {
        switch disposicion {
        case .cuartal:
            return formasCuartales()
        case .sinFundamentalA, .sinFundamentalB, .dosManos:
            return formasSinFundamental(disposicion)
        case .shell, .notasGuia:
            let guias = notasGuia
            guard guias.count == 2 else { return [] }
            // La shell va sobre el bajo; si el bajo es una de las notas guía, sobre la fundamental.
            let grave = guias.contains(self.bajo) ? fundamental : self.bajo
            let bajo: [Nota] = disposicion == .shell ? [grave] : []
            return [guias, Array(guias.reversed())].map { Acorde.apilar(bajo + $0) }
        default:
            let notas = notasParaDisponer
            guard !notas.isEmpty else { return [] }
            var formas: [[Altura]] = []
            for k in notas.indices {
                // La posición cerrada desde la nota k, con cuatro voces: si hay menos notas, se repiten (Do Mi Sol Do).
                var alturas = Acorde.apilar((0..<4).map { notas[(k + $0) % notas.count] })
                for desdeArriba in disposicion.vocesQueBajan {
                    let i = alturas.count - 1 - desdeArriba
                    alturas[i] = alturas[i].octavas(-1)
                }
                alturas.sort { $0.midi < $1.midi }
                if !formas.contains(alturas) { formas.append(alturas) }
            }
            return formas
        }
    }

    /// Las pilas de cuatro notas por cuartas (justas o aumentadas) de la escala de siete notas del acorde con menos
    /// notas a evitar que llevan las notas guía y ninguna nota a evitar.
    private func formasCuartales() -> [[Altura]] {
        let guias = notasGuia
        guard !guias.isEmpty, let escala = escalasCompatibles().first(where: { $0.notas.count == 7 }) else { return [] }
        let evitar = escala.notasAEvitar(sobre: self)
        let notas = escala.notas
        var formas: [[Altura]] = []
        for inicio in notas {
            var pila = [inicio]
            while pila.count < 4, let ultima = pila.last {
                let letra = (ultima.natural.indiceDiatonico + 3) % 7
                guard let siguiente = notas.first(where: { $0.natural.indiceDiatonico == letra }),
                    [5, 6].contains(Acorde.distancia(ultima, siguiente))
                else { break }
                pila.append(siguiente)
            }
            guard pila.count == 4, guias.allSatisfy({ guia in pila.contains { $0.esEnarmonica(de: guia) } }),
                !pila.contains(where: { evitar.contains($0) })
            else { continue }
            let alturas = Acorde.apilar(pila)
            if !formas.contains(alturas) { formas.append(alturas) }
        }
        return formas
    }

    /// Las formas sin fundamental (A y B) y la de dos manos, o ninguna si al acorde le falta la tercera (o la
    /// suspensión) o la séptima (o la sexta).
    private func formasSinFundamental(_ disposicion: DisposicionDeAcorde) -> [[Altura]] {
        guard let tercera = self.tercera ?? notas(conPapel: .suspension).first,
            let septima = self.septima ?? notas(conPapel: .sexta).first
        else { return [] }
        let arpegio = Arpegio(self)
        let novena = arpegio.nota(delGrado: 2)
        // En un acorde de dominante (tercera mayor y séptima menor), la 13.ª en lugar de la quinta.
        let dominante = Acorde.distancia(fundamental, tercera) == 4 && Acorde.distancia(fundamental, septima) == 10
        let quinta = dominante ? arpegio.nota(delGrado: 6) : arpegio.nota(delGrado: 5)
        switch disposicion {
        case .sinFundamentalA: return [Acorde.apilar([tercera, quinta, septima, novena])]
        case .sinFundamentalB: return [Acorde.apilar([septima, novena, tercera, quinta])]
        default: return [Acorde.apilar([fundamental, septima, tercera, quinta, novena])]
        }
    }

    /// La tercera (o la suspensión) y la séptima (o la sexta, o si no hay ninguna, la quinta): las notas guía.
    /// Vacío si el acorde no tiene alguna de las dos.
    public var notasGuia: [Nota] {
        guard let tercera = self.tercera ?? notas(conPapel: .suspension).first,
            let septima = self.septima ?? notas(conPapel: .sexta).first ?? quinta
        else { return [] }
        return [tercera, septima]
    }

    /// Las notas una encima de otra, cada una en la primera octava por encima de la anterior, empezando en la
    /// octava 4.
    static func apilar(_ notas: [Nota]) -> [Altura] {
        var alturas: [Altura] = []
        for nota in notas {
            var altura = Altura(nota, octava: 4)
            if let anterior = alturas.last {
                while altura.midi <= anterior.midi { altura = altura.octavas(1) }
                while altura.midi - 12 > anterior.midi { altura = altura.octavas(-1) }
            }
            alturas.append(altura)
        }
        return alturas
    }
}

extension Altura {
    /// La misma nota, `n` octavas más arriba (o más abajo, si `n` es negativo).
    func octavas(_ n: Int) -> Altura { Altura(pasosDeQuinta: pasosDeQuinta, pasosDeOctava: pasosDeOctava + n) }
}

// MARK: - Conducción

extension DisposicionDeAcorde {
    /// Una disposición para cada acorde, con la menor suma de movimientos de las voces (en semitonos, voz a voz de
    /// grave a agudo) de un acorde al siguiente. A igual suma, la primera disposición con la voz más aguda más cerca
    /// del centro del ámbito. `nil` si algún acorde no se puede disponer así en el ámbito (por ejemplo, la shell de un
    /// acorde sin tercera).
    ///
    ///     DisposicionDeAcorde.drop2.conducir([Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")])
    ///     // la séptima de cada acorde baja por grado a la tercera del siguiente
    public func conducir(
        _ acordes: [Acorde], en ambito: ClosedRange<Int> = DisposicionDeAcorde.ambito
    ) -> [[Altura]]? {
        let candidatas = acordes.map { $0.disposiciones(self, en: ambito) }
        guard !candidatas.isEmpty, candidatas.allSatisfy({ !$0.isEmpty }) else { return acordes.isEmpty ? [] : nil }
        let centro = Double(ambito.lowerBound + ambito.upperBound) / 2
        func movimiento(_ a: [Altura], _ b: [Altura]) -> Int {
            zip(a, b).map { abs($0.midi - $1.midi) }.reduce(0, +)
        }
        // coste[i][j]: lo mejor hasta la disposición j del acorde i; desde[i][j], la del acorde anterior.
        var coste: [[Double]] = [
            candidatas[0].map { abs(Double($0.last?.midi ?? 0) - centro) / 100 }
        ]
        var desde: [[Int]] = [Array(repeating: -1, count: candidatas[0].count)]
        for i in 1..<candidatas.count {
            var filaDeCoste: [Double] = []
            var filaDeDesde: [Int] = []
            for actual in candidatas[i] {
                var mejor = (coste: Double.infinity, desde: 0)
                for (k, anterior) in candidatas[i - 1].enumerated() {
                    let total = coste[i - 1][k] + Double(movimiento(anterior, actual))
                    if total < mejor.coste { mejor = (total, k) }
                }
                filaDeCoste.append(mejor.coste)
                filaDeDesde.append(mejor.desde)
            }
            coste.append(filaDeCoste)
            desde.append(filaDeDesde)
        }
        let ultima = coste[coste.count - 1]
        guard var j = ultima.indices.min(by: { ultima[$0] < ultima[$1] }) else { return nil }
        var elegidas: [[Altura]] = []
        for i in stride(from: candidatas.count - 1, through: 0, by: -1) {
            elegidas.append(candidatas[i][j])
            j = desde[i][j]
        }
        return elegidas.reversed()
    }
}
