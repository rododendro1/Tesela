import ArmoniaNucleo
import ArmoniaTeoria

// Arpegios como voces: un arpegio, o una progresión arpegiada, con su ritmo. Como son una `Voz`, se dibujan,
// suenan y se exportan (MusicXML, MEI, MIDI) igual que cualquier melodía.

extension Voz {
    /// El arpegio nota a nota, cada una de `figura`, a partir de `octava` (la del bajo).
    ///
    ///     let voz = Voz(Arpegio(Acorde("Do7"), patron: .idaYVuelta), figura: .semicorchea)
    ///     voz.eventos.count             // 9: Do Mi Sol Si♭ Do Si♭ Sol Mi Do
    ///     let datos = voz.partitura(encabezado: Encabezado(titulo: "Arpegio de Do7")).midi()
    ///
    /// Detiene el programa si `figura` no es positiva, como `Duracion(_:_:)` con un denominador 0.
    public init(_ arpegio: Arpegio, figura: Duracion = .corchea, octava: Int = 4, compas: Compas = .compasillo) {
        precondition(figura > .cero, "la figura de un arpegio tiene que durar algo")
        self.init(arpegio.alturas(octava: octava).map { Evento($0, figura) }, compas: compas)
    }

    /// Una progresión arpegiada: el arpegio de cada acorde, con el mismo patrón, uno detrás de otro.
    ///
    ///     let acordes = try ["Do", "Lam", "Fa", "Sol7"].map { try Acorde(leyendo: $0) }
    ///     let voz = Voz(arpegiando: acordes, patron: .alberti, porAcorde: .blanca)
    ///     voz.eventos.count   // 16: cuatro corcheas por acorde
    ///
    /// - Parameters:
    ///   - figura: lo que dura cada nota.
    ///   - porAcorde: lo que dura cada acorde. Si se da, el patrón se repite (o se corta) hasta llenarlo, y
    ///     si no cabe un número entero de notas, la última se alarga; si es `nil`, cada acorde suena una vez
    ///     su patrón entero.
    ///   - octava: la del bajo del primer acorde. El de cada uno de los siguientes se pone en la octava que
    ///     lo deja más cerca del primero, para que la mano no salte de un extremo a otro.
    ///   - tensiones, aproximacion: como en ``Arpegio``, para todos los acordes.
    ///   - enlazados: si cada arpegio, después del primero, empieza por la nota de su acorde más cercana a la
    ///     última del anterior (en Do–Fa, el de Fa empieza por Do), en lugar de por su bajo.
    ///
    /// Detiene el programa si `figura` no es positiva.
    public init(
        arpegiando acordes: [Acorde], patron: Arpegio.Patron = .ascendente, octavas: Int = 1,
        conOctava: Bool = true, figura: Duracion = .corchea, porAcorde: Duracion? = nil,
        octava: Int = 3, compas: Compas = .compasillo, tensiones: [Int] = [],
        aproximacion: Arpegio.Aproximacion? = nil, enlazados: Bool = false
    ) {
        precondition(figura > .cero, "la figura de un arpegio tiene que durar algo")
        let eventos = Voz.arpegiar(
            acordes, duraciones: acordes.map { _ in porAcorde },
            como: Recorrido(patron, octavas, conOctava, tensiones, aproximacion), figura: figura, octava: octava,
            enlazados: enlazados)
        self.init(eventos, compas: compas)
    }

    /// Lo mismo, siguiendo un ritmo armónico (el de una pieza importada, por ejemplo): el patrón de cada acorde se
    /// repite hasta llenar lo que dura, y la voz va en el compás del ritmo.
    ///
    ///     let ritmo = RitmoArmonico([AcordeConDuracion("Do", .blanca), AcordeConDuracion("Sol", .negra)])
    ///     let voz = Voz(arpegiando: ritmo)
    ///     voz.eventos.count   // 6: cuatro corcheas y dos
    ///
    /// Detiene el programa si `figura` no es positiva.
    public init(
        arpegiando ritmo: RitmoArmonico, patron: Arpegio.Patron = .ascendente, octavas: Int = 1,
        conOctava: Bool = true, figura: Duracion = .corchea, octava: Int = 3, tensiones: [Int] = [],
        aproximacion: Arpegio.Aproximacion? = nil, enlazados: Bool = false
    ) {
        precondition(figura > .cero, "la figura de un arpegio tiene que durar algo")
        let eventos = Voz.arpegiar(
            ritmo.acordes.map(\.acorde), duraciones: ritmo.duraciones,
            como: Recorrido(patron, octavas, conOctava, tensiones, aproximacion), figura: figura, octava: octava,
            enlazados: enlazados)
        self.init(eventos, compas: ritmo.compas)
    }

    /// Cómo se recorre cada acorde de una progresión arpegiada.
    private struct Recorrido {
        let patron: Arpegio.Patron
        let octavas: Int
        let conOctava: Bool
        let tensiones: [Int]
        let aproximacion: Arpegio.Aproximacion?

        init(
            _ patron: Arpegio.Patron, _ octavas: Int, _ conOctava: Bool, _ tensiones: [Int],
            _ aproximacion: Arpegio.Aproximacion?
        ) {
            self.patron = patron
            self.octavas = octavas
            self.conOctava = conOctava
            self.tensiones = tensiones
            self.aproximacion = aproximacion
        }
    }

    /// Los eventos de una progresión arpegiada, cada acorde con el mismo recorrido; una duración `nil` (o que no
    /// es positiva) es el patrón entero.
    private static func arpegiar(
        _ acordes: [Acorde], duraciones: [Duracion?], como molde: Recorrido, figura: Duracion, octava: Int,
        enlazados: Bool
    ) -> [Evento] {
        var eventos: [Evento] = []
        let referencia = acordes.first.map { Altura($0.bajo, octava: octava).midi } ?? 0
        var anterior: Altura?
        for (acorde, porAcorde) in zip(acordes, duraciones) {
            func arpegio(_ inicio: Int) -> Arpegio {
                Arpegio(
                    acorde, patron: molde.patron, octavas: molde.octavas, conOctava: molde.conOctava, inicio: inicio,
                    tensiones: molde.tensiones, aproximacion: molde.aproximacion)
            }
            let alturas: [Altura]
            if enlazados, let anterior {
                // De cada nota de partida y cada octava, la que empieza más cerca de donde acabó el anterior.
                let candidatas = acorde.notasDesdeElBajo.indices.flatMap { inicio in
                    ((octava - 2)...(octava + 1)).map { arpegio(inicio).alturas(octava: $0) }
                }.filter { !$0.isEmpty }
                let distancia = { (notas: [Altura]) in abs(notas[0].midi - anterior.midi) }
                alturas = candidatas.menor(siNoHay: []) { distancia($0) < distancia($1) }
            } else {
                let distancia = { (candidata: Int) in abs(Altura(acorde.bajo, octava: candidata).midi - referencia) }
                let suya = ((octava - 1)...(octava + 1)).menor(siNoHay: octava) { distancia($0) < distancia($1) }
                alturas = arpegio(0).alturas(octava: suya)
            }
            guard !alturas.isEmpty else { continue }
            guard let porAcorde, porAcorde > .cero else {
                eventos += alturas.map { Evento($0, figura) }
                anterior = alturas.last
                continue
            }
            // Cuántas notas caben (al menos una) y lo que sobra, que alarga la última.
            let cociente = porAcorde / figura
            let notas = max(1, cociente.numerador / cociente.denominador)
            let ultima = porAcorde - figura * (notas - 1)
            for i in 0..<notas {
                eventos.append(Evento(alturas[i % alturas.count], i == notas - 1 ? ultima : figura))
            }
            anterior = alturas[(notas - 1) % alturas.count]
        }
        return eventos
    }
}
