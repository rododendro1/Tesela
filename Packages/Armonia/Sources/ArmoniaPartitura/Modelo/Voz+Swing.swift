import ArmoniaNucleo

// El swing y las polirritmias.
//
// Con swing, cada par de corcheas (o de la figura que se elija) se toca desigual: la primera más larga y la segunda
// más corta, en la proporción que se pida (2:1, como un tresillo de negra y corchea, es la del jazz). `conSwing(_:)`
// cambia lo que dura cada evento para que suene así, y lo hace con fracciones exactas: en 2:1 salen figuras de
// tresillo y en 3:1, corcheas con puntillo y semicorcheas, que se escriben y se exportan como las demás.
//
// Una polirritmia (3 contra 2, 4 contra 3…) son dos pulsaciones que reparten el mismo tramo en partes iguales.
// `Polirritmia` da los ataques de cada una, el ritmo que resulta de oírlas juntas y las dos voces para tocarlas.

/// Cómo se reparte cada par de figuras con swing: la primera dura `largo` partes y la segunda `corto`.
///
///     let voz = try Voz(leyendo: "Do4:8 Re4:8 Mi4:8 Fa4:8 Sol4:2")
///     voz.conSwing(.ternario).ritmo     // negra y corchea de tresillo en cada par
public struct Swing: Hashable, Sendable, Codable {
    /// La figura que se toca desigual, a pares (la corchea, si no se pide otra).
    public let unidad: Duracion
    public let largo: Int
    public let corto: Int

    /// `nil` si la unidad no es positiva o alguna parte no está entre 1 y 64.
    public init?(unidad: Duracion = .corchea, largo: Int, corto: Int) {
        guard unidad > .cero, (1...64).contains(largo), (1...64).contains(corto) else { return nil }
        self.unidad = unidad
        self.largo = largo
        self.corto = corto
    }

    private init(_ largo: Int, _ corto: Int) {
        self.unidad = .corchea
        self.largo = largo
        self.corto = corto
    }

    /// 2:1, el swing del jazz: negra y corchea de tresillo.
    public static let ternario = Swing(2, 1)
    /// 3:1, el ritmo con puntillo: corchea con puntillo y semicorchea.
    public static let conPuntillo = Swing(3, 1)
    /// 1:1, sin swing.
    public static let recto = Swing(1, 1)

    /// Dónde cae, con swing, el momento `t` (desde el principio de un par de figuras).
    func momento(_ t: Duracion) -> Duracion {
        let par = unidad * 2
        // Los pares enteros que caben antes de `t` (t no es negativo).
        let pares = (t.numerador * par.denominador) / (t.denominador * par.numerador)
        let resto = t - par * pares
        let partes = largo + corto
        // La primera figura se estira hasta `largo` partes del par y la segunda ocupa lo que queda.
        if resto <= unidad { return par * pares + resto * 2 * largo / partes }
        return par * pares + par * largo / partes + (resto - unidad) * 2 * corto / partes
    }
}

extension Voz {
    /// La voz tocada con swing: cada par de figuras de la unidad del swing, desde el comienzo de cada compás, dura lo
    /// mismo, pero la primera se alarga y la segunda se acorta. Las notas que empiezan o acaban fuera de esos puntos
    /// se mueven en proporción; la voz dura lo mismo.
    ///
    ///     let voz = try Voz(leyendo: "Do4:8 Re4:8 Mi4:4")
    ///     voz.conSwing().ritmo == [Duracion(1, 6), Duracion(1, 12), .negra]   // true
    public func conSwing(_ swing: Swing = .ternario) -> Voz {
        // La anacrusa empieza a mitad del compás: los pares se cuentan desde el compás entero.
        let origen = anacrusa > .cero ? compas.duracion - anacrusa : .cero
        var nuevos: [Evento] = []
        var posicion = origen
        for evento in eventos {
            let fin = posicion + evento.duracion
            let duracion = swing.momento(fin) - swing.momento(posicion)
            nuevos.append(evento.con(duracion: duracion, ligada: evento.ligada))
            posicion = fin
        }
        return Voz(nuevos, compas: compas, anacrusa: anacrusa)
    }
}

/// Dos pulsaciones que reparten el mismo tramo (un compás, si no se pide otro): `primera` partes iguales contra
/// `segunda`.
///
///     let tresContraDos = Polirritmia(3, contra: 2)!
///     tresContraDos.resultante() == [Duracion(1, 3), Duracion(1, 6), Duracion(1, 6), Duracion(1, 3)]   // true
public struct Polirritmia: Hashable, Sendable, Codable {
    public let primera: Int
    public let segunda: Int

    /// `nil` si alguna pulsación no está entre 1 y 64.
    public init?(_ primera: Int, contra segunda: Int) {
        guard (1...64).contains(primera), (1...64).contains(segunda) else { return nil }
        self.primera = primera
        self.segunda = segunda
    }

    /// Los ataques de cada pulsación en un tramo de `ciclo`, desde 0.
    public func ataques(ciclo: Duracion = .redonda) -> (primera: [Duracion], segunda: [Duracion]) {
        ((0..<primera).map { ciclo * $0 / primera }, (0..<segunda).map { ciclo * $0 / segunda })
    }

    /// El ritmo de las dos juntas: lo que va de cada ataque, de una u otra, al siguiente.
    public func resultante(ciclo: Duracion = .redonda) -> [Duracion] {
        let (a, b) = ataques(ciclo: ciclo)
        let todos = Set(a + b).sorted()
        return todos.indices.map { i in (i + 1 < todos.count ? todos[i + 1] : ciclo) - todos[i] }
    }

    /// Las dos voces que la tocan durante `compases` compases de `compas`, cada una en su altura: la primera
    /// pulsación arriba y la segunda abajo.
    ///
    ///     let voces = Polirritmia(3, contra: 2)!.voces()
    ///     voces[0].ritmo == [Duracion(1, 3), Duracion(1, 3), Duracion(1, 3)]   // true
    public func voces(
        compas: Compas = .compasillo, compases: Int = 1, alturas: (Altura, Altura) = ("Do5", "Do4")
    ) -> [Voz] {
        let ciclo = compas.duracion
        let veces = max(1, compases)
        let arriba = (0..<(primera * veces)).map { _ in Evento(alturas.0, ciclo / primera) }
        let abajo = (0..<(segunda * veces)).map { _ in Evento(alturas.1, ciclo / segunda) }
        return [Voz(arriba, compas: compas), Voz(abajo, compas: compas)]
    }
}
