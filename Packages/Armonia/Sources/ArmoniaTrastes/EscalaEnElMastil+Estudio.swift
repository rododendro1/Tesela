import ArmoniaElementos
import ArmoniaTeoria

// Para estudiar una escala en el mástil: las secuencias de estudio dentro de una posición y las cinco formas de la
// pentatónica, con las notas que comparte cada una con la siguiente.

extension EscalaEnElMastil {
    /// Las notas de la posición de la grave a la aguda, cada altura una sola vez: si dos cuerdas dan la misma nota
    /// (entre la tercera y la segunda de la guitarra), se toca en la más grave.
    public var recorrido: [PosicionEnElMastil] {
        var resultado: [PosicionEnElMastil] = []
        var ultima = Int.min
        for posicion in posiciones {
            let midi = mastil.altura(en: posicion).midi
            if midi > ultima {
                resultado.append(posicion)
                ultima = midi
            }
        }
        return resultado
    }

    /// Una secuencia de estudio sin salir de la posición: por terceras, en grupos, en tríadas… desde cada nota de la
    /// posición mientras quepa el dibujo entero, subiendo o bajando, hasta la nota más aguda (o la más grave).
    ///
    ///     let posicion = Mastil(.guitarra, numeroDeTrastes: 15).posicionesCAGED(de: Escala(.sol))[0]
    ///     posicion.secuencia(.terceras)   // de dos en dos: Sol Si, La Do, Si Re…
    public func secuencia(
        _ secuencia: SecuenciaDeEscala, sentido: SentidoDelIntervalo = .ascendente
    ) -> [PosicionEnElMastil] {
        let notas = sentido == .descendente ? recorrido.reversed() : recorrido
        let alcance = secuencia.pasos.reduce(0, max)
        guard notas.count > alcance else { return [] }
        var resultado: [PosicionEnElMastil] = []
        for inicio in 0..<(notas.count - alcance) {
            resultado += secuencia.pasos.map { notas[inicio + $0] }
        }
        return resultado
    }

    /// Las notas que esta posición comparte con otra: la misma cuerda y el mismo traste, o doce trastes más arriba o
    /// más abajo (la quinta forma de la pentatónica enlaza con la primera una octava más arriba).
    public func notasComunes(con otra: EscalaEnElMastil) -> [PosicionEnElMastil] {
        posiciones.filter { posicion in
            otra.posiciones.contains { $0.cuerda == posicion.cuerda && modulo($0.traste - posicion.traste, 12) == 0 }
        }
    }
}

extension Mastil {
    /// Las cinco formas de una pentatónica, con dos notas por cuerda: la primera empieza en la tónica en la cuerda
    /// más grave y cada una, en la nota siguiente. Cada forma comparte una nota por cuerda con la siguiente (sus
    /// notas más agudas son las más graves de la otra). Vacío si la escala no tiene cinco notas o el instrumento no
    /// va de grave a agudo.
    ///
    ///     let formas = Mastil(.guitarra, numeroDeTrastes: 15).formasPentatonicas(de: Escala(.la, .pentatonicaMenor))
    ///     formas.map(\.rangoDeTrastes)   // [5...8, 7...10, 9...13, 0...3, 2...5]
    public func formasPentatonicas(de escala: Escala) -> [EscalaEnElMastil] {
        guard Set(escala.notas.map(\.claseDeAltura)).count == 5 else { return [] }
        let formas = posicionesPorCuerda(de: escala, notasPorCuerda: 2)
        let tonica = escala.tonica.claseDeAltura
        guard let desde = formas.firstIndex(where: { primeraClase(de: $0) == tonica }) else { return formas }
        return Array(formas[desde...] + formas[..<desde])
    }

    private func primeraClase(de forma: EscalaEnElMastil) -> Int? {
        forma.posiciones.first.map { Mastil.clase(altura(en: $0).midi) }
    }
}
