import ArmoniaNucleo
import ArmoniaTeoria
// Escalas por posiciones: las digitaciones de una escala en franjas del mástil que la mano recorre sin
// desplazarse (o casi), en los dos sistemas habituales en la guitarra: tres notas por cuerda y CAGED.

/// Las cinco formas del sistema CAGED, por los acordes abiertos de la guitarra cuya forma toma la mano: Do, La,
/// Sol, Mi y Re (C, A, G, E y D en cifrado americano, que es como se llaman en todos los idiomas).
public enum FormaCAGED: String, CaseIterable, Hashable, Sendable {
    case c = "C", a = "A", g = "G", e = "E", d = "D"

    /// La cuerda (desde 0, la sexta de la guitarra) en la que la forma tiene la tónica, y dónde empieza la
    /// franja respecto a ella: un traste por debajo, o tres si la tónica cae bajo el meñique (C y G).
    var cuerdaDeLaTonica: Int {
        switch self {
        case .e, .g: return 0
        case .a, .c: return 1
        case .d: return 2
        }
    }

    var desdeLaTonica: Int { self == .c || self == .g ? -3 : -1 }
}

/// Una escala tocada en una posición del mástil.
///
///     let posiciones = Mastil(.guitarra, trastes: 15).posicionesCAGED(de: Escala(.do, .mayor))
///     posiciones.map(\.forma)      // [C, A, G, E, D]
///     posiciones.map(\.trastes)    // [0...4, 2...6, 5...9, 7...11, 9...13]
public struct EscalaEnElMastil: Hashable, Sendable {
    public let mastil: Mastil
    /// Los trastes que abarca la mano (el 0 es la cuerda al aire).
    public let trastes: ClosedRange<Int>
    /// Las notas, cuerda a cuerda de la grave a la aguda y, en cada una, de traste en traste.
    public let posiciones: [PosicionEnElMastil]
    /// La forma CAGED de la posición; `nil` en las de tres (o dos) notas por cuerda.
    public let forma: FormaCAGED?

    public init(mastil: Mastil, trastes: ClosedRange<Int>, posiciones: [PosicionEnElMastil], forma: FormaCAGED? = nil) {
        self.mastil = mastil
        self.trastes = trastes
        self.posiciones = posiciones
        self.forma = forma
    }

    /// Las alturas en el orden en que se tocan al subir.
    public var alturas: [Altura] { posiciones.map { mastil.altura(en: $0) } }
}

extension Mastil {
    /// La escala con el mismo número de notas en cada cuerda (tres por omisión en las de seis o más notas, dos
    /// en las demás, como las pentatónicas), subiendo desde cada una de sus notas en la cuerda más grave: una
    /// posición por grado, de la más baja a la más alta. Solo se dan las que caben en el mástil.
    ///
    ///     let posiciones = Mastil(.guitarra, trastes: 15).posicionesPorCuerda(de: Escala(.sol, .mayor))
    ///     posiciones.count               // 7
    ///     posiciones[0].trastes          // 0...5
    ///     posiciones[0].posiciones.count // 18: tres por cuerda
    ///
    /// Vacío si las cuerdas no van de grave a aguda (un ukelele con el Sol agudo, por ejemplo).
    public func posicionesPorCuerda(de escala: Escala, notasPorCuerda: Int? = nil) -> [EscalaEnElMastil] {
        let clases = Set(escala.notas.map(\.claseDeAltura))
        let cuerdas = encordado.cuerdas.map(\.midi)
        guard !clases.isEmpty, !encordado.esReentrante, let grave = cuerdas.first else { return [] }
        let porCuerda = max(1, notasPorCuerda ?? (clases.count >= 6 ? 3 : 2))
        var resultado: [EscalaEnElMastil] = []
        for inicio in 0..<12 where clases.contains(Mastil.clase(grave + inicio)) {
            var altura = grave + inicio
            var posiciones: [PosicionEnElMastil] = []
            for (cuerda, alAire) in cuerdas.enumerated() {
                for _ in 0..<porCuerda {
                    posiciones.append(PosicionEnElMastil(cuerda: cuerda, traste: altura - alAire))
                    // La nota siguiente de la escala.
                    altura += 1
                    while !clases.contains(Mastil.clase(altura)) { altura += 1 }
                }
            }
            let usados = posiciones.map(\.traste)
            guard let menor = usados.min(), let mayor = usados.max(), menor >= 0, mayor <= trastes else { continue }
            resultado.append(EscalaEnElMastil(mastil: self, trastes: menor...mayor, posiciones: posiciones))
        }
        return resultado
    }

    /// La escala en las cinco posiciones del sistema CAGED, de la más baja a la más alta: cada una, una franja de
    /// `ancho` trastes alrededor de la tónica tal como cae en la forma de su acorde abierto (en la sexta cuerda
    /// en E y G, en la quinta en A y C, en la cuarta en D). Solo para la guitarra afinada como siempre
    /// (`Encordado.guitarra`); en otro instrumento, vacío. Se dan las que caben en el mástil.
    public func posicionesCAGED(de escala: Escala, ancho: Int = 5) -> [EscalaEnElMastil] {
        guard encordado.cuerdas.map(\.midi) == Encordado.guitarra.cuerdas.map(\.midi) else { return [] }
        let clases = Set(escala.notas.map(\.claseDeAltura))
        let tonica = escala.tonica.claseDeAltura
        let ancho = max(1, ancho)
        var resultado: [EscalaEnElMastil] = []
        for forma in FormaCAGED.allCases {
            let alAire = encordado.cuerdas[forma.cuerdaDeLaTonica].midi
            var desde = Mastil.clase(tonica - alAire) + forma.desdeLaTonica
            if desde < 0 { desde += 12 }
            let franja = desde...(desde + ancho - 1)
            guard franja.upperBound <= trastes else { continue }
            let posiciones = encordado.cuerdas.indices.flatMap { cuerda in
                franja.filter { clases.contains(Mastil.clase(encordado.cuerdas[cuerda].midi + $0)) }
                    .map { PosicionEnElMastil(cuerda: cuerda, traste: $0) }
            }
            resultado.append(EscalaEnElMastil(mastil: self, trastes: franja, posiciones: posiciones, forma: forma))
        }
        return resultado.sorted { $0.trastes.lowerBound < $1.trastes.lowerBound }
    }
}
