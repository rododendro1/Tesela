import ArmoniaNucleo

// Las escalas simétricas (la disminuida, la de tonos enteros, la aumentada, los modos de Messiaen): las que
// vuelven a tener las mismas notas al transportarlas menos de una octava. De ahí que tengan pocas transposiciones
// distintas, varias tónicas equivalentes y acordes que se repiten a la misma distancia.

/// Un acorde de una escala simétrica repetido sobre cada tónica equivalente: Do7, Mi♭7, Fa♯7 y La7 en Do
/// disminuida semitono-tono.
public struct CicloSimetrico: Hashable, Sendable {
    public let tipo: TipoDeAcorde
    /// Un acorde por tónica equivalente, de la tónica hacia arriba.
    public let acordes: [Acorde]

    public init(tipo: TipoDeAcorde, acordes: [Acorde]) {
        self.tipo = tipo
        self.acordes = acordes
    }
}

extension TipoDeAcorde {
    /// Los acordes que se buscan en los ciclos de una escala simétrica.
    static let deLosCiclos: [TipoDeAcorde] = [
        .mayor, .menor, .disminuido, .aumentado, .dominanteSeptima, .menorSeptima, .mayorSeptimaMayor,
        .semidisminuido, .disminuidoSeptima, .aumentadoSeptima, .aumentadoSeptimaMayor, .menorSeptimaMayor,
    ]
}

extension Escala {
    /// Los semitonos del menor transporte que deja la escala con las mismas notas: 3 en la disminuida, 2 en la de
    /// tonos enteros, 4 en la aumentada, 6 en los modos 5 a 7 de Messiaen. `nil` si solo vuelve a la octava,
    /// como la mayor.
    ///
    ///     Escala(.do, .disminuida).intervaloDeSimetria   // 3
    public var intervaloDeSimetria: Int? {
        let clases = Set(notas.map(\.claseDeAltura))
        guard !clases.isEmpty else { return nil }
        return (1..<12).first { paso in Set(clases.map { modulo($0 + paso, 12) }) == clases }
    }

    /// Cuántas transposiciones distintas tiene: 3 la disminuida, 2 la de tonos enteros, 12 la mayor.
    public var transposicionesDistintas: Int { intervaloDeSimetria ?? 12 }

    /// Las notas de la escala desde las que se repite igual, empezando por la tónica: Do, Mi♭, Fa♯ y La en Do
    /// disminuida. Solo la tónica si la escala no es simétrica.
    public var tonicasEquivalentes: [Nota] {
        guard let paso = intervaloDeSimetria else { return [tonica] }
        let desde = tonica.claseDeAltura
        return notas.filter { modulo($0.claseDeAltura - desde, paso) == 0 }
    }

    /// Los acordes sobre la tónica que caben en la escala, repetidos sobre cada tónica equivalente: en Do disminuida
    /// semitono-tono, Do Mi♭ Fa♯ La, Do7 Mi♭7 Fa♯7 La7, Do°7…; en tonos enteros, Do+ Re+ Mi+… Vacío si la escala no
    /// es simétrica o se repite a cada semitono (la cromática).
    public var ciclosSimetricos: [CicloSimetrico] {
        guard let paso = intervaloDeSimetria, paso >= 2 else { return [] }
        let tonicas = tonicasEquivalentes
        return TipoDeAcorde.deLosCiclos.compactMap { tipo in
            let acordes = tonicas.map { Acorde($0, tipo) }
            let caben = acordes.allSatisfy { acorde in acorde.notas.allSatisfy { contieneEnarmonico($0) } }
            return caben ? CicloSimetrico(tipo: tipo, acordes: acordes) : nil
        }
    }
}

// MARK: - Líneas de notas guía

/// Por dónde empieza una línea de notas guía.
public enum InicioDeNotasGuia: String, Hashable, Sendable, CaseIterable {
    /// Por la tercera del primer acorde (o su suspensión).
    case tercera
    /// Por la séptima del primer acorde (o su sexta, o su quinta).
    case septima
}

extension Acorde {
    /// Una línea de notas guía sobre una progresión: una nota por acorde, su tercera o su séptima, la que queda más
    /// cerca de la anterior. Así se oye cómo la séptima de un acorde baja a la tercera del siguiente (Fa → Mi en
    /// Sol7 → Do). Empieza en la octava dada; un acorde sin notas guía da su fundamental.
    ///
    ///     Acorde.lineaDeNotasGuia([Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")], desde: .tercera)
    ///     // Fa₄ Fa₄ Mi₄
    public static func lineaDeNotasGuia(
        _ acordes: [Acorde], desde inicio: InicioDeNotasGuia = .tercera, octava: Int = 4
    ) -> [Altura] {
        var linea: [Altura] = []
        for acorde in acordes {
            let guias = acorde.notasGuia.isEmpty ? [acorde.fundamental] : acorde.notasGuia
            guard let anterior = linea.last else {
                let primera = inicio == .tercera ? guias[0] : guias[guias.count - 1]
                linea.append(Altura(primera, octava: octava))
                continue
            }
            let candidatas = guias.map { masCercana($0, a: anterior.midi) }
            // La más cercana; a igual distancia, la primera (la tercera).
            let elegida = candidatas.dropFirst().reduce(candidatas[0]) { mejor, otra in
                abs(otra.midi - anterior.midi) < abs(mejor.midi - anterior.midi) ? otra : mejor
            }
            linea.append(elegida)
        }
        return linea
    }

    /// La altura de la nota más cercana a `midi`; a igual distancia, la de abajo.
    static func masCercana(_ nota: Nota, a midi: Int) -> Altura {
        let alturas = ((midi / 12 - 3)...(midi / 12 + 1)).map { Altura(nota, octava: $0) }
        return alturas.dropFirst().reduce(alturas[0]) { mejor, otra in
            abs(otra.midi - midi) < abs(mejor.midi - midi) ? otra : mejor
        }
    }
}
