import Elementos
import Teoria

// Una línea melódica sobre una progresión, como la que improvisaría un músico de jazz: corcheas por la escala de cada
// acorde, con una nota guía en el primer tiempo y una nota cromática que lleva a la nota guía del acorde siguiente.
// Es determinista: la misma progresión da siempre la misma línea.

extension Voz {
    /// Un fraseo en corcheas sobre una progresión, un compás por acorde: empieza cada compás en una nota guía del
    /// acorde (la tercera o la séptima, la más cercana a la anterior, como ``Acorde/lineaDeNotasGuia(_:desde:octava:)``),
    /// sigue por grados de su escala (la del acorde en la tonalidad, ``Tonalidad/escalaDelAcorde(_:siguiente:)``)
    /// hacia la nota guía del siguiente y llega a ella por semitono desde la última corchea, del lado del que viene.
    /// El último acorde, su nota guía en una redonda (lo que dure el compás).
    ///
    ///     let acordes = try ["Rem7", "Sol7", "Do7M"].map { try Acorde(leyendo: $0) }
    ///     let voz = Voz(fraseando: acordes)
    ///     voz.eventos.count   // 17: ocho corcheas por compás y la nota final
    ///
    /// - Parameters:
    ///   - tonalidad: la de las escalas; si es `nil`, la que mejor explica los acordes, y si no hay ninguna, la mayor
    ///     de la fundamental de cada acorde.
    ///   - octava: la de la primera nota guía.
    public init(
        fraseando acordes: [Acorde], tonalidad: Tonalidad? = nil, compas: Compas = .compasillo, octava: Int = 4
    ) {
        let guias = Acorde.lineaDeNotasGuia(acordes, desde: .tercera, octava: octava)
        let tonalidad = tonalidad ?? AnalisisArmonico.analizar(acordes)?.tonalidad
        // Corcheas por compás: al menos dos (la nota guía y la de aproximación).
        let cociente = compas.duracion / .corchea
        let porCompas = max(2, cociente.numerador / cociente.denominador)
        var eventos: [Evento] = []
        for (i, acorde) in acordes.enumerated() {
            guard i + 1 < acordes.count else {
                eventos.append(Evento(guias[i], compas.duracion))
                break
            }
            let siguiente = acordes[i + 1]
            let escala = tonalidad?.escalaDelAcorde(acorde, siguiente: siguiente) ?? Escala(acorde.fundamental, .mayor)
            let compasDeLaLinea = Self.frase(
                desde: guias[i], hacia: guias[i + 1], por: escala, notas: porCompas)
            eventos += compasDeLaLinea.map { Evento($0, .corchea) }
            // Si el compás no se llena de corcheas (5/8, 7/8…), la última se alarga.
            let sobra = compas.duracion - .corchea * porCompas
            if sobra > .cero, let ultima = eventos.popLast() {
                eventos.append(Evento(ultima.alturas[0], .corchea + sobra))
            }
        }
        self.init(eventos, compas: compas)
    }

    /// Las notas de un compás: `inicio`, grados de la escala hasta el de antes de la aproximación y, al final, la nota
    /// a un semitono del destino. Si sobran corcheas, la línea se aleja primero del destino y vuelve; si faltan, salta
    /// más de un grado.
    static func frase(desde inicio: Altura, hacia destino: Altura, por escala: Escala, notas: Int) -> [Altura] {
        // La aproximación, del lado de donde se viene: por debajo si se sube, por arriba si se baja.
        let sube = destino.midi >= inicio.midi
        let paso = sube ? destino.midi - 1 : destino.midi + 1
        // Con el nombre que le da la escala si es suya; si no, con sostenido al subir y con bemol al bajar.
        let aproximacion =
            escala.notas.lazy.compactMap { Altura($0, midi: paso) }.first
            ?? Altura(midi: paso, ventana: sube ? .sostenidos : .bemoles)
        guard notas > 2 else { return Array([inicio, aproximacion].prefix(notas)) }
        // Las alturas de la escala alrededor de la línea, de grave a agudo.
        let grave = min(inicio.midi, destino.midi) - 12
        let aguda = max(inicio.midi, destino.midi) + 12
        let alturas = ((grave / 12 - 2)...(aguda / 12)).flatMap { octava in
            escala.notas.map { Altura($0, octava: octava) }
        }.filter { (grave...aguda).contains($0.midi) }.sorted { $0.midi < $1.midi }
        guard !alturas.isEmpty else { return [inicio] + Array(repeating: inicio, count: notas - 2) + [aproximacion] }
        func indice(_ midi: Int) -> Int {
            alturas.indices.min { abs(alturas[$0].midi - midi) < abs(alturas[$1].midi - midi) } ?? 0
        }
        let desde = indice(inicio.midi)
        // El grado de antes de la aproximación: el de la escala más cercano a ella por el lado de donde se viene.
        let antes = sube ? alturas.lastIndex { $0.midi < paso } : alturas.firstIndex { $0.midi > paso }
        let hasta = antes ?? desde
        // Las corcheas de en medio: de `desde` (sin contarla) a `hasta`.
        let huecos = notas - 2
        let sentido = hasta >= desde ? 1 : -1
        let grados = abs(hasta - desde)
        var indices: [Int] = []
        if grados >= huecos {
            // Faltan corcheas: saltos, repartidos.
            indices = (1...huecos).map { desde + sentido * (grados * $0 / huecos) }
        } else {
            // Sobran: primero se aleja del destino y luego vuelve a él. Si sobra un número impar, la vuelta empieza
            // con un salto de tercera, para llegar a tiempo.
            let sobran = huecos - grados
            let ida = (sobran + 1) / 2
            var actual = desde
            for _ in 0..<ida {
                actual -= sentido
                indices.append(actual)
            }
            if sobran % 2 == 1 {
                actual += 2 * sentido
                indices.append(actual)
            }
            while actual != hasta {
                actual += actual < hasta ? 1 : -1
                indices.append(actual)
            }
        }
        let limitados = indices.prefix(huecos).map { alturas[min(max($0, 0), alturas.count - 1)] }
        return [inicio] + limitados + [aproximacion]
    }
}
