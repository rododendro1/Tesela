import ArmoniaNucleo
import ArmoniaTeoria

// Arpegios como voces: un arpegio, o una progresión arpegiada, con su ritmo. Como son una `Voz`, se dibujan,
// suenan y se exportan (MusicXML, MEI, MIDI) igual que cualquier melodía.

extension Voz {
    /// El arpegio nota a nota, cada una de `figura`, a partir de `octava` (la del bajo).
    ///
    ///     let voz = Voz(Arpegio(Acorde("Do7"), patron: .idaYVuelta), figura: .semicorchea)
    ///     voz.eventos.count             // 9: Do Mi Sol Si♭ Do Si♭ Sol Mi Do
    ///     let datos = voz.midi(titulo: "Arpegio de Do7")
    ///
    /// Detiene el programa si `figura` no es positiva.
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
    ///
    /// Detiene el programa si `figura` no es positiva.
    public init(
        arpegiando acordes: [Acorde], patron: Arpegio.Patron = .ascendente, octavas: Int = 1,
        conOctava: Bool = true, figura: Duracion = .corchea, porAcorde: Duracion? = nil,
        octava: Int = 3, compas: Compas = .compasillo
    ) {
        let eventos = Voz.arpegiar(
            acordes, duraciones: acordes.map { _ in porAcorde }, patron: patron, octavas: octavas,
            conOctava: conOctava, figura: figura, octava: octava)
        self.init(eventos, compas: compas)
    }

    /// Lo mismo, con lo que dura cada acorde (el ritmo armónico de una pieza importada, por ejemplo): el patrón se
    /// repite hasta llenarlo.
    ///
    /// Detiene el programa si `figura` no es positiva o si no hay una duración por acorde.
    public init(
        arpegiando acordes: [Acorde], duraciones: [Duracion], patron: Arpegio.Patron = .ascendente,
        octavas: Int = 1, conOctava: Bool = true, figura: Duracion = .corchea, octava: Int = 3,
        compas: Compas = .compasillo
    ) {
        precondition(duraciones.count == acordes.count, "hace falta una duración por acorde")
        let eventos = Voz.arpegiar(
            acordes, duraciones: duraciones, patron: patron, octavas: octavas,
            conOctava: conOctava, figura: figura, octava: octava)
        self.init(eventos, compas: compas)
    }

    /// Los eventos de una progresión arpegiada; una duración `nil` (o que no es positiva) es el patrón entero.
    private static func arpegiar(
        _ acordes: [Acorde], duraciones: [Duracion?], patron: Arpegio.Patron, octavas: Int,
        conOctava: Bool, figura: Duracion, octava: Int
    ) -> [Evento] {
        precondition(figura > .cero, "la figura de un arpegio tiene que durar algo")
        var eventos: [Evento] = []
        let referencia = acordes.first.map { Altura($0.bajo, octava: octava).midi } ?? 0
        for (acorde, porAcorde) in zip(acordes, duraciones) {
            let distancia = { (candidata: Int) in abs(Altura(acorde.bajo, octava: candidata).midi - referencia) }
            let suya = ((octava - 1)...(octava + 1)).min(by: { distancia($0) < distancia($1) }) ?? octava
            let alturas = Arpegio(acorde, patron: patron, octavas: octavas, conOctava: conOctava).alturas(octava: suya)
            guard !alturas.isEmpty else { continue }
            guard let porAcorde, porAcorde > .cero else {
                eventos += alturas.map { Evento($0, figura) }
                continue
            }
            // Cuántas notas caben (al menos una) y lo que sobra, que alarga la última.
            let cociente = porAcorde / figura
            let notas = max(1, cociente.numerador / cociente.denominador)
            let ultima = porAcorde - figura * (notas - 1)
            for i in 0..<notas {
                eventos.append(Evento(alturas[i % alturas.count], i == notas - 1 ? ultima : figura))
            }
        }
        return eventos
    }
}
