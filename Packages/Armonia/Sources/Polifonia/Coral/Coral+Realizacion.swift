import Elementos
import Teoria

// Realización a cuatro voces: escribir una sucesión de acordes como coral (bajo, tenor, contralto y
// soprano) sin faltas de conducción.

extension Coral {
    /// Escribe los acordes a cuatro voces, con el bajo del cifrado (Sol7/Si lleva Si en el bajo) y
    /// sin ninguna falta de las que comprueba ``faltas``: el resultado siempre ``esCorrecta``.
    ///
    ///     let coral = try Coral(realizando: ["Do", "Fa", "Sol7", "Do"])
    ///     coral.esCorrecta                // true
    ///     coral.voz(0).map(\.nota)        // [Do, Fa, Sol, Do]
    ///
    /// Entre todas las disposiciones posibles busca la sucesión que mueve menos las voces (en
    /// semitonos, como `conduccionMinima(hasta:)`, pero con alturas), con estas preferencias:
    ///
    /// - Todas las notas del acorde, salvo la quinta justa, que puede faltar (duplicando la
    ///   fundamental). Se duplica antes la fundamental que la quinta, y esta antes que la tercera
    ///   (en las tríadas disminuidas, la tercera). Nunca la sensible ni la séptima.
    /// - La sensible sube a la tónica, sobre todo en el soprano, y la séptima baja por grado conjunto.
    /// - La nota común de una séptima disminuida de nota común (el Do de Re♯°7 → Do) se queda en su voz.
    /// - Sin soprano dado, el soprano se queda cerca del centro de su tesitura.
    ///
    /// - Parameters:
    ///   - soprano: la melodía del soprano, una altura por acorde, si está fijada. Cada nota tiene
    ///     que ser del acorde y estar en la tesitura del soprano (Do4–Sol5).
    ///   - tonalidad: para saber cuál es la sensible; si no se da, la que mejor explique los acordes.
    /// - Throws: ``ErrorDeRealizacion``: si no hay acordes (`sinNotas`), si el soprano no tiene una nota por
    ///   acorde, si una de sus notas no es del acorde o se sale de su tesitura, si un acorde tiene más de cuatro
    ///   notas obligatorias o ninguna disposición sin faltas, o si no hay manera de enlazarlos sin faltas.
    public init(realizando acordes: [Acorde], soprano: [Altura]? = nil, en tonalidad: Tonalidad? = nil)
        throws(ErrorDeRealizacion)
    {
        guard !acordes.isEmpty else { throw ErrorDeRealizacion.sinNotas }
        if let soprano, soprano.count != acordes.count {
            throw ErrorDeRealizacion.sopranoDeOtraLongitud(notas: soprano.count, acordes: acordes.count)
        }
        let tonalidad = tonalidad ?? (try? AnalisisArmonico.analizar(acordes))?.tonalidad
        let sensible = tonalidad?.escalaDeReferencia.grado(7)
        let tonica = tonalidad?.tonica
        let dominantes = acordes.map { acorde in tonalidad.map { Cadencia.esDominante($0.analizar(acorde)) } ?? false }

        let opciones = acordes.indices.map { i in
            Coral.disposiciones(de: acordes[i], soprano: soprano?[i], sensible: sensible)
        }
        if let i = opciones.firstIndex(where: \.isEmpty) {
            throw Coral.motivoSinDisposicion(acordes[i], soprano: soprano?[i], acorde: i)
        }

        // El camino de disposiciones de menor coste.
        let mejor = MejoresCaminos.buscar(
            estados: opciones.map(\.count), inicio: { opciones[0][$0].coste },
            paso: { i, a, b in
                Coral.costeDePaso(
                    de: opciones[i - 1][a].alturas, a: opciones[i][b].alturas, septima: acordes[i - 1].septima,
                    sensible: dominantes[i - 1] ? sensible : nil, tonica: tonica,
                    notaComun: Coral.notaComun(de: acordes[i - 1], a: acordes[i])
                ).map { $0 + opciones[i][b].coste }
            }
        ).first
        guard let camino = mejor,
            let coral = try? Coral(camino.estados.enumerated().map { opciones[$0.offset][$0.element].alturas })
        else { throw ErrorDeRealizacion.sinEnlaceSinFaltas }
        self = coral
    }

    /// Por qué un acorde no tiene ninguna disposición a cuatro voces (``disposiciones(de:soprano:sensible:)`` vacía).
    package static func motivoSinDisposicion(_ acorde: Acorde, soprano: Altura?, acorde i: Int) -> ErrorDeRealizacion {
        var notas = acorde.notas
        if !notas.contains(acorde.bajo) { notas.append(acorde.bajo) }
        let quinta = acorde.quinta.flatMap { $0 == acorde.fundamental + .quintaJusta ? $0 : nil }
        if notas.filter({ $0 != quinta }).count > 4 { return .demasiadasNotas(acorde: i) }
        if let soprano, !notas.contains(soprano.nota) { return .notaAjena(acorde: i) }
        if let soprano, !tesituras[3].contains(soprano.midi) { return .sopranoFueraDeTesitura(acorde: i) }
        return .sinDisposicion(acorde: i)
    }

    // MARK: Auxiliares

    /// Las disposiciones a cuatro voces de un acorde que no tienen faltas por sí solas, con lo que
    /// cuesta cada una por sus duplicaciones, sus omisiones y la altura del soprano.
    package static func disposiciones(de acorde: Acorde, soprano: Altura?, sensible: Nota?) -> [(
        alturas: [Altura], coste: Double
    )] {
        var notas = acorde.notas
        if !notas.contains(acorde.bajo) { notas.append(acorde.bajo) }
        let quinta = acorde.quinta.flatMap { $0 == acorde.fundamental + .quintaJusta ? $0 : nil }
        let obligatorias = notas.filter { $0 != quinta }
        guard obligatorias.count <= 4 else { return [] }
        if let soprano, !notas.contains(soprano.nota) { return [] }

        func alturas(_ voz: Int) -> [Altura] {
            notas.flatMap { nota in (1...6).map { Altura(nota, octava: $0) } }
                .filter { tesituras[voz].contains($0.midi) }
                .sorted { $0.midi < $1.midi }
        }
        let bajos = (1...4).map { Altura(acorde.bajo, octava: $0) }.filter { tesituras[0].contains($0.midi) }
        let tenores = alturas(1)
        let contraltos = alturas(2)
        let sopranos = soprano.map { [$0] } ?? alturas(3)
        let disminuida = acorde.tipo.estructura.calidadDeTriada == .disminuida

        var resultado: [(alturas: [Altura], coste: Double)] = []
        for bajo in bajos {
            for tenor in tenores where tenor.midi > bajo.midi {
                for contralto in contraltos where (0...12).contains(contralto.midi - tenor.midi) {
                    for tiple in sopranos where (0...12).contains(tiple.midi - contralto.midi) {
                        let voces = [bajo, tenor, contralto, tiple]
                        var falta = false
                        faltas(en: voces) { _, _ in falta = true }
                        guard !falta else { continue }
                        let escritas = voces.map(\.nota)
                        guard obligatorias.allSatisfy(escritas.contains) else { continue }
                        // Un unísono entre voces superiores se admite, pero cuesta.
                        var coste = contralto == tenor || tiple == contralto ? 1.0 : 0
                        if let quinta, !escritas.contains(quinta) { coste += 1.5 }
                        // Las duplicaciones.
                        for nota in Set(escritas) {
                            let veces = escritas.filter { $0 == nota }.count
                            guard veces > 1 else { continue }
                            if nota == sensible || nota == acorde.septima || acorde.tensiones.contains(nota) {
                                falta = true
                                break
                            }
                            let porVez: Double
                            switch acorde.papel(de: nota) {
                            case .fundamental?: porVez = disminuida ? 0.5 : 0
                            case .quinta?: porVez = disminuida ? 1.5 : 0.5
                            case .tercera?: porVez = disminuida ? 0 : 1
                            default: porVez = 1
                            }
                            coste += porVez * Double(veces - 1)
                        }
                        guard !falta else { continue }
                        // El soprano, cerca del centro de su tesitura (Mi4–Re5).
                        if soprano == nil { coste += 0.2 * Double(max(0, 64 - tiple.midi, tiple.midi - 74)) }
                        resultado.append((voces, coste))
                    }
                }
            }
        }
        return resultado
    }

    /// La nota que una séptima disminuida de nota común comparte con el acorde mayor al que va, y que se queda en su
    /// voz: el Do de Re♯°7 → Do; `nil` si el paso no es ese.
    package static func notaComun(de acorde: Acorde, a siguiente: Acorde) -> Nota? {
        guard acorde.tipo == .disminuidoSeptima, siguiente.tipo.esMayor else { return nil }
        return acorde.notas.first { $0.esEnarmonica(de: siguiente.fundamental) }
    }

    /// Lo que cuesta pasar de una disposición a otra, o `nil` si el paso tiene alguna falta.
    /// `septima` es la del primer acorde, si la tiene; `sensible`, solo si el primero es de dominante;
    /// `notaComun`, la que se queda quieta (ver ``notaComun(de:a:)``).
    package static func costeDePaso(
        de anterior: [Altura], a siguiente: [Altura], septima: Nota?, sensible: Nota?, tonica: Nota?,
        notaComun: Nota? = nil
    ) -> Double? {
        var falta = false
        faltas(de: anterior, a: siguiente) { _, _ in falta = true }
        guard !falta else { return nil }
        var coste = 0.5 * Double(abs(siguiente[0].midi - anterior[0].midi))
        for v in 1..<4 { coste += Double(abs(siguiente[v].midi - anterior[v].midi)) }
        for v in 0..<4 {
            let movimiento = siguiente[v].midi - anterior[v].midi
            // La sensible sube a la tónica (si el acorde siguiente la tiene).
            if let sensible, let tonica, anterior[v].nota == sensible, siguiente.contains(where: { $0.nota == tonica }),
                !(movimiento == 1 && siguiente[v].nota == tonica)
            {
                coste += v == 3 ? 4 : 1.5
            }
            // La séptima baja por grado conjunto (o se queda).
            if let septima, anterior[v].nota == septima, !(-2...0).contains(movimiento) {
                coste += 3
            }
            // La nota común se queda.
            if let notaComun, anterior[v].nota == notaComun, movimiento != 0 { coste += 3 }
        }
        return coste
    }
}
