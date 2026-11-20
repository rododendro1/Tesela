import Elementos
import Teoria

// Escalas por posiciones: las digitaciones de una escala en franjas del mástil que la mano recorre sin
// desplazarse (o casi), en los dos sistemas habituales en la guitarra: tres notas por cuerda y CAGED.

/// Las cinco formas del sistema CAGED, por los acordes abiertos de la guitarra cuya forma toma la mano: Do, La,
/// Sol, Mi y Re (C, A, G, E y D en cifrado americano, que es como se llaman en todos los idiomas).
public enum FormaCAGED: String, CaseIterable, Hashable, Sendable {
    case c = "C"
    case a = "A"
    case g = "G"
    case e = "E"
    case d = "D"

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
///     let posiciones = Mastil(.guitarra, numeroDeTrastes: 15).posicionesCAGED(de: Escala(.do, .mayor))
///     posiciones.map(\.forma)      // [C, A, G, E, D]
///     posiciones.map(\.rangoDeTrastes)    // [0...4, 2...6, 5...9, 7...11, 9...13]
public struct EscalaEnElMastil: Hashable, Sendable {
    public let mastil: Mastil
    /// Los trastes que abarca la mano (el 0 es la cuerda al aire).
    public let rangoDeTrastes: ClosedRange<Int>
    /// Las notas, cuerda a cuerda de la grave a la aguda y, en cada una, de traste en traste; en las cajas de un
    /// instrumento cuyas cuerdas no van de grave a aguda (``Mastil/posicionesPorCajas(de:ancho:)``), en el orden en
    /// que suenan.
    public let posiciones: [PosicionEnElMastil]
    /// La forma CAGED de la posición; `nil` en las de tres (o dos) notas por cuerda.
    public let forma: FormaCAGED?
    /// La escala que se toca, si se sabe: la que se dio a ``Mastil/posicionesCAGED(de:ancho:)``,
    /// ``Mastil/posicionesPorCuerda(de:notasPorCuerda:)`` o ``Mastil/posicionesPorCajas(de:ancho:)``. Con ella,
    /// ``partitura(de:titulo:ritmo:)`` escribe sus notas.
    public let escala: Escala?

    public init(
        mastil: Mastil, rangoDeTrastes: ClosedRange<Int>, posiciones: [PosicionEnElMastil], forma: FormaCAGED? = nil,
        escala: Escala? = nil
    ) {
        self.mastil = mastil
        self.rangoDeTrastes = rangoDeTrastes
        self.posiciones = posiciones
        self.forma = forma
        self.escala = escala
    }

    /// Las alturas en el orden en que se tocan al subir.
    public var alturas: [Altura] { posiciones.map { mastil.altura(en: $0) } }
}

extension Mastil {
    /// La escala con el mismo número de notas en cada cuerda (tres por omisión en las de seis o más notas, dos
    /// en las demás, como las pentatónicas), subiendo desde cada una de sus notas en la cuerda más grave: una
    /// posición por grado, de la más baja a la más alta. Solo se dan las que caben en el mástil.
    ///
    ///     let posiciones = Mastil(.guitarra, numeroDeTrastes: 15).posicionesPorCuerda(de: Escala(.sol, .mayor))
    ///     posiciones.count               // 7
    ///     posiciones[0].rangoDeTrastes          // 0...5
    ///     posiciones[0].posiciones.count // 18: tres por cuerda
    ///
    /// Si las cuerdas no van de grave a aguda (el Sol agudo del ukelele, el charango, el banjo de cinco cuerdas),
    /// no se puede subir cuerda a cuerda: se dan las posiciones por cajas de trastes,
    /// ``posicionesPorCajas(de:ancho:)``.
    public func posicionesPorCuerda(de escala: Escala, notasPorCuerda: Int? = nil) -> [EscalaEnElMastil] {
        if encordado.esReentrante { return posicionesPorCajas(de: escala) }
        let clases = Set(escala.notas.map(\.claseDeAltura))
        let cuerdas = encordado.afinacion.map(\.midi)
        guard !clases.isEmpty, let grave = cuerdas.first else { return [] }
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
            guard let menor = usados.min(), let mayor = usados.max(), posiciones.allSatisfy(contiene) else {
                continue
            }
            resultado.append(
                EscalaEnElMastil(mastil: self, rangoDeTrastes: menor...mayor, posiciones: posiciones, escala: escala))
        }
        return resultado
    }

    /// La escala por cajas de trastes, como se enseña en los instrumentos cuyas cuerdas no van de grave a aguda (el
    /// ukelele con el Sol agudo): cada caja es una franja de `ancho` trastes, uno por dedo, que empieza un traste por
    /// debajo de cada nota de la escala en la cuerda más grave (o al aire, si la nota está en los primeros trastes),
    /// con todas las notas de la escala que caen dentro. Las notas van en el orden en que suenan, de la más grave a la
    /// más aguda, y las que suenan igual en dos cuerdas, una vez: en la cuerda en la que se pisa más abajo. Solo se
    /// dan las cajas que llevan todas las notas de la escala, de la más baja a la más alta.
    ///
    ///     let cajas = Mastil(.ukelele, numeroDeTrastes: 12).posicionesPorCajas(de: Escala(.do, .mayor))
    ///     cajas[0].rangoDeTrastes      // 0...3
    ///     cajas[0].alturas             // Do4 Re4 Mi4 Fa4 Sol4 La4 Si4 Do5
    public func posicionesPorCajas(de escala: Escala, ancho: Int = 4) -> [EscalaEnElMastil] {
        let clases = Set(escala.notas.map(\.claseDeAltura))
        guard !clases.isEmpty, !encordado.afinacion.isEmpty else { return [] }
        let ancho = max(1, ancho)
        // La cuerda más grave, que no siempre es la primera.
        let grave = encordado.afinacion.indices.min { encordado.afinacion[$0].midi < encordado.afinacion[$1].midi } ?? 0
        let alAire = encordado.afinacion[grave].midi
        var inicios: [Int] = []
        for traste in trastes(deCuerda: grave) where traste < 12 && clases.contains(Mastil.clase(alAire + traste)) {
            let inicio = max(0, min(traste <= 1 ? 0 : traste - 1, numeroDeTrastes - (ancho - 1)))
            if !inicios.contains(inicio) { inicios.append(inicio) }
        }
        var vistas: Set<[PosicionEnElMastil]> = []
        return inicios.sorted().compactMap { inicio in
            let franja = inicio...min(numeroDeTrastes, inicio + ancho - 1)
            let ordenadas = posiciones(deClases: clases).filter { franja.contains($0.traste) }
                .sorted { (midi(en: $0), $0.traste) < (midi(en: $1), $1.traste) }
            var unicas: [PosicionEnElMastil] = []
            for posicion in ordenadas where unicas.last.map({ midi(en: $0) != midi(en: posicion) }) ?? true {
                unicas.append(posicion)
            }
            guard Set(unicas.map { Mastil.clase(midi(en: $0)) }) == clases, vistas.insert(unicas).inserted else {
                return nil
            }
            return EscalaEnElMastil(mastil: self, rangoDeTrastes: franja, posiciones: unicas, escala: escala)
        }
    }

    /// La escala en las cinco posiciones del sistema CAGED, de la más baja a la más alta: cada una, una franja de
    /// `ancho` trastes alrededor de la tónica tal como cae en la forma de su acorde abierto (en la sexta cuerda
    /// en E y G, en la quinta en A y C, en la cuarta en D). Solo para la guitarra afinada como siempre
    /// (`Encordado.guitarra`); en otro instrumento, vacío. Se dan las que caben en el mástil.
    public func posicionesCAGED(de escala: Escala, ancho: Int = 5) -> [EscalaEnElMastil] {
        guard encordado.afinacion.map(\.midi) == Encordado.guitarra.afinacion.map(\.midi) else { return [] }
        let clases = Set(escala.notas.map(\.claseDeAltura))
        let tonica = escala.tonica.claseDeAltura
        let ancho = max(1, ancho)
        var resultado: [EscalaEnElMastil] = []
        for forma in FormaCAGED.allCases {
            let alAire = encordado.afinacion[forma.cuerdaDeLaTonica].midi
            var desde = Mastil.clase(tonica - alAire) + forma.desdeLaTonica
            if desde < 0 { desde += 12 }
            let franja = desde...(desde + ancho - 1)
            guard franja.upperBound <= numeroDeTrastes else { continue }
            let posiciones = encordado.afinacion.indices.flatMap { cuerda in
                franja.filter { clases.contains(Mastil.clase(encordado.afinacion[cuerda].midi + $0)) }
                    .map { PosicionEnElMastil(cuerda: cuerda, traste: $0) }
            }
            resultado.append(
                EscalaEnElMastil(
                    mastil: self, rangoDeTrastes: franja, posiciones: posiciones, forma: forma, escala: escala))
        }
        return resultado.sorted { $0.rangoDeTrastes.lowerBound < $1.rangoDeTrastes.lowerBound }
    }
}
