import ArmoniaNucleo

// Las escalas propias, escritas por sus notas («Do Re Mi♭ Fa♯ Sol La Si») o por sus pasos en semitonos
// («Do 2-1-3-1-2-2-1»), y las escalas vecinas: las que salen de mover una nota un semitono.

extension TipoDeEscala {
    /// El tipo con estos intervalos desde la tónica: el del catálogo, si lo hay (con su nombre), o uno propio que se
    /// llama por su número de Forte y sus pasos en semitonos, «7-22 (1-3-1-2-1-3-1)».
    ///
    ///     TipoDeEscala.propio([.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor])
    ///     // pentatónica mayor
    public static func propio(_ intervalos: [Intervalo]) -> TipoDeEscala {
        let candidato = TipoDeEscala(nombre: "", intervalos: intervalos)
        if let conocido = TipoDeEscala.catalogo.first(where: { $0 == candidato }) {
            return conocido
        }
        return TipoDeEscala(nombre: nombrePropio(candidato.intervalos.map(\.semitonos)), intervalos: intervalos)
    }

    /// «7-22 (1-3-1-2-1-3-1)»: el número de Forte del conjunto, si lo tiene, y los pasos de una nota a la siguiente
    /// hasta la octava.
    static func nombrePropio(_ semitonos: [Int]) -> String {
        let pasos = zip(semitonos, semitonos.dropFirst() + [12]).map { String($1 - $0) }.joined(separator: "-")
        let forte = ConjuntoDeClases(semitonos).numeroDeForte
        return [forte, "(" + pasos + ")"].compactMap { $0 }.joined(separator: " ")
    }
}

extension Escala {
    /// Una escala escrita por sus notas: la primera es la tónica, y cada nota se escribe como se da. El tipo es el
    /// del catálogo si coincide con alguno («Re Mi Fa Sol La Si Do» es Re dórico); si no, uno propio. `nil` sin
    /// notas.
    ///
    ///     Escala.propia([.do, .re, Nota("Mi♭"), Nota("Fa♯"), .sol, .la, .si])?.nombre
    ///     // "Do 7-22 (2-1-3-1-2-2-1)"
    public static func propia(_ notas: [Nota]) -> Escala? {
        guard let tonica = notas.first else { return nil }
        return Escala(tonica, .propio(notas.map { tonica.intervalo(hasta: $0) }))
    }

    /// Una escala escrita por sus pasos en semitonos desde la tónica: `[2, 2, 1, 2, 2, 2, 1]` es la mayor. Los
    /// pasos tienen que ser positivos y sumar 12, contando el último, el que vuelve a la tónica (también vale sin
    /// él, si suman menos de 12). Las notas se escriben con las menos alteraciones posibles; `nil` si los pasos no
    /// llevan a la octava.
    ///
    ///     Escala.propia(desde: .do, pasos: [2, 2, 3, 2, 3])?.nombre   // "Do pentatónica mayor"
    public static func propia(desde tonica: Nota, pasos: [Int]) -> Escala? {
        guard !pasos.isEmpty, pasos.allSatisfy({ $0 > 0 }) else { return nil }
        var semitonos = [0]
        for paso in pasos { semitonos.append(semitonos[semitonos.count - 1] + paso) }
        // El último paso puede ser el que vuelve a la octava.
        if semitonos.last == 12 { semitonos.removeLast() }
        guard semitonos.allSatisfy({ $0 < 12 }) else { return nil }
        let clases = semitonos.map { modulo(tonica.claseDeAltura + $0, 12) }
        let escritas = ConjuntoDeClases(clases).notas(con: tonica)
        let notas = clases.compactMap { clase in escritas.first { $0.claseDeAltura == clase } }
        return propia([tonica] + notas.dropFirst())
    }

    /// Los pasos en semitonos de una nota a la siguiente, hasta la tónica de arriba: `[2, 2, 1, 2, 2, 2, 1]` en la
    /// mayor.
    public var pasosEnSemitonos: [Int] {
        let semitonos = tipo.intervalos.map(\.semitonos)
        return zip(semitonos, semitonos.dropFirst() + [12]).map { $1 - $0 }
    }

    /// El número de Forte del conjunto de notas de la escala: «7-35» en las diatónicas, «5-35» en las pentatónicas.
    public var numeroDeForte: String? { ConjuntoDeClases(notas: notas).numeroDeForte }

    /// Lee una escala propia: unas notas («Do Re Mi♭ Fa♯ Sol La Si») o una tónica y sus pasos («Do 2-1-3-1-2-2-1»).
    static func leerPropia(_ texto: String) -> Escala? {
        let palabras = texto.split(separator: " ").map(String.init)
        guard palabras.count >= 2, let tonica = try? Nota(leyendo: palabras[0]) else { return nil }
        if palabras.count == 2, palabras[1].contains("-") {
            let pasos = palabras[1].split(separator: "-").map { Int($0) }
            guard pasos.allSatisfy({ $0 != nil }) else { return nil }
            return propia(desde: tonica, pasos: pasos.compactMap { $0 })
        }
        guard let notas = try? palabras.map({ try Nota(leyendo: $0) }) else { return nil }
        return propia(notas)
    }
}

// MARK: - Escalas vecinas

/// Una escala que sale de otra moviendo una nota un semitono: Do lidio sale de Do mayor subiendo el Fa a Fa♯.
public struct EscalaVecina: Hashable, Sendable {
    public let escala: Escala
    /// La nota que se mueve, como se escribe en la escala de partida.
    public let de: Nota
    /// A dónde va, como se escribe en la vecina.
    public let a: Nota

    /// La escala vecina a la que se llega moviendo la nota `de` a `a`.
    public init(escala: Escala, de: Nota, a: Nota) {
        self.escala = escala
        self.de = de
        self.a = a
    }
}

extension Escala {
    /// Las escalas del catálogo que salen de esta moviendo una sola nota un semitono, arriba o abajo: de Do mayor,
    /// Do lidio (Fa → Fa♯), Do mixolidio (Si → Si♭), Do menor melódica (Mi → Mi♭), Do mayor armónica (La → La♭)…
    /// Para cada cambio, la escala con la misma tónica si la hay; si no, la más fácil de escribir. En el orden de las
    /// notas, primero bajando.
    public func vecinas(tipos: [TipoDeEscala] = TipoDeEscala.todos) -> [EscalaVecina] {
        let clases = Set(notas.map(\.claseDeAltura))
        var resultado: [EscalaVecina] = []
        for nota in notas {
            for semitono in [-1, 1] {
                let nueva = modulo(nota.claseDeAltura + semitono, 12)
                guard !clases.contains(nueva) else { continue }
                let buscadas = clases.subtracting([nota.claseDeAltura]).union([nueva])
                // Las escalas con justo esas notas, iguales al subir y al bajar.
                let exactas = Escala.identificar(clasesDeAltura: Array(buscadas), tipos: tipos).filter {
                    !$0.tipo.esDireccional && Set($0.notas.map(\.claseDeAltura)) == buscadas
                }
                let mismaTonica = exactas.first { $0.tonica.claseDeAltura == tonica.claseDeAltura }
                guard let elegida = mismaTonica ?? exactas.first,
                    let a = elegida.notas.first(where: { $0.claseDeAltura == nueva }),
                    !resultado.contains(where: { $0.escala == elegida })
                else { continue }
                resultado.append(EscalaVecina(escala: elegida, de: nota, a: a))
            }
        }
        return resultado
    }
}
