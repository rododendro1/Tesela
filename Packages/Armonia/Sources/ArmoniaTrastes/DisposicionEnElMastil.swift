import ArmoniaNucleo
import ArmoniaTeoria

// Las disposiciones de piano y jazz (drop 2, drop 3, shell…) tocadas en la guitarra: cada voz en una cuerda de un
// grupo de cuerdas, como se estudian en los métodos de guitarra de jazz.

extension Mastil {
    /// Los grupos de cuerdas en que se toca una disposición, de los más graves a los más agudos: tantas cuerdas
    /// seguidas como voces tiene (las cuerdas 6-5-4-3, 5-4-3-2 y 4-3-2-1 de la guitarra para un drop 2) y, en el
    /// drop 3, saltando la cuerda que sigue al bajo (6-4-3-2 y 5-3-2-1). Cada grupo da los índices de las cuerdas de
    /// la más grave a la más aguda. Vacío en un instrumento reentrante o si no hay cuerdas para tantas voces.
    ///
    ///     Mastil(.guitarra).gruposDeCuerdas(para: .drop2)   // [[0, 1, 2, 3], [1, 2, 3, 4], [2, 3, 4, 5]]
    public func gruposDeCuerdas(para disposicion: DisposicionDeAcorde) -> [[Int]] {
        let cuerdas = encordado.cuerdas
        guard !encordado.esReentrante else { return [] }
        let orden = cuerdas.indices.sorted { cuerdas[$0].midi < cuerdas[$1].midi }
        let salto = disposicion == .drop3 ? 1 : 0
        let ancho = disposicion.voces + salto
        guard ancho <= orden.count else { return [] }
        return (0...(orden.count - ancho)).map { (inicio: Int) -> [Int] in
            let resto: [Int] = Array(orden[(inicio + 1 + salto)..<(inicio + ancho)])
            return [orden[inicio]] + resto
        }
    }

    /// Las formas de una disposición del acorde en un grupo de cuerdas (de ``gruposDeCuerdas(para:)``), de la más
    /// grave a la más aguda: la voz más grave en la primera cuerda del grupo, la siguiente en la segunda… Las demás
    /// cuerdas no suenan. Solo valen las que caben en el mástil y no abren la mano más de `abertura` trastes entre
    /// el más bajo y el más alto que se pisan.
    ///
    ///     Mastil(.guitarra).disposiciones(de: Acorde("Do7M"), .drop2, cuerdas: [1, 2, 3, 4]).map(\.tablatura)
    ///     // ["x2201x", "x3545x", …]: Si Mi Sol Do, Do Sol Si Mi…
    public func disposiciones(
        de acorde: Acorde, _ disposicion: DisposicionDeAcorde, cuerdas grupo: [Int], abertura: Int = 4
    ) -> [Digitacion] {
        let cuerdas = encordado.cuerdas
        guard grupo.count == disposicion.voces, grupo.allSatisfy({ cuerdas.indices.contains($0) }) else { return [] }
        let alAire = grupo.map { cuerdas[$0].midi }
        let ambito = alAire.reduce(Int.max, min)...(alAire.reduce(Int.min, max) + trastes)
        var resultado: [Digitacion] = []
        for alturas in acorde.disposiciones(disposicion, en: ambito) {
            let forma = zip(alturas, alAire).map { $0.midi - $1 }
            let pisados = forma.filter { $0 > 0 }
            guard forma.allSatisfy({ (0...trastes).contains($0) }),
                pisados.allSatisfy({ traste in pisados.allSatisfy { abs(traste - $0) < max(1, abertura) } })
            else { continue }
            var trastesDeLaForma = [Int?](repeating: nil, count: cuerdas.count)
            for (cuerda, traste) in zip(grupo, forma) { trastesDeLaForma[cuerda] = traste }
            resultado.append(Digitacion(mastil: self, trastes: trastesDeLaForma))
        }
        return resultado
    }
}

extension Digitacion {
    /// El dedo que pisa cada cuerda, en el orden de `trastes`: `nil` en las que no suenan, 0 en las que suenan al
    /// aire y, en las demás, el índice (1) en el traste más bajo y un dedo por traste hasta el meñique (4). Si dos
    /// cuerdas por encima del traste más bajo caen en el mismo dedo, la segunda pasa al siguiente si está libre:
    /// `x3545x` se toca con 1, 3, 2 y 4.
    public var dedosSugeridos: [Int?] {
        let base = posicion
        var usados: Set<Int> = []
        var dedos: [Int?] = []
        for traste in trastes {
            guard let traste, traste > 0 else {
                dedos.append(traste)
                continue
            }
            var dedo = min(4, traste - base + 1)
            if dedo > 1, usados.contains(dedo), dedo < 4, !usados.contains(dedo + 1) { dedo += 1 }
            usados.insert(dedo)
            dedos.append(dedo)
        }
        return dedos
    }
}
