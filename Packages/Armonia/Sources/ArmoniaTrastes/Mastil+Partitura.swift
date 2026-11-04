import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria

// Del mástil a la partitura: lo que se toca en él, con sus notas en el pentagrama y la tablatura debajo.

extension Tablatura {
    /// La tablatura de un mástil, con lo que se pulsa en cada nota (o acorde) por su índice, como lo da el mástil:
    /// una línea por cuerda y las cuerdas contadas como en `PosicionEnElMastil` (0 es la más grave).
    ///
    ///     let doDe5 = PosicionEnElMastil(cuerda: 1, traste: 3)   // el Do3, en la 5.ª cuerda
    ///     Tablatura(Mastil(.guitarra), posiciones: [0: [doDe5]]).notas[0]?.first?.cuerda   // 4
    public init(_ mastil: Mastil, posiciones: [Int: [PosicionEnElMastil]]) {
        self.init(
            cuerdas: mastil.encordado.numeroDeCuerdas,
            desdeLaGrave: posiciones.mapValues { $0.map { ($0.cuerda, $0.traste) } })
    }
}

extension Digitacion {
    /// La digitación en una partitura: el acorde que suena, en una redonda, con su tablatura debajo. Con `acorde`,
    /// escrito con sus notas (Si♭, no La♯, en Do7), con el cifrado encima y, sin `titulo`, titulado con él.
    ///
    ///     let mastil = Mastil(.guitarra)
    ///     try Digitacion(leyendo: "x32010", en: mastil).partitura(de: Acorde("Do")).musicXML()   // en ArmoniaFormatos
    public func partitura(de acorde: Acorde? = nil, titulo: String? = nil) -> Partitura {
        Digitacion.partitura([self], acordes: acorde.map { [$0] } ?? [], titulo: titulo)
    }

    /// Unas digitaciones, una detrás de otra (una redonda cada una), con la tablatura debajo. Si se dan los acordes
    /// (uno por digitación), las notas se escriben con su ortografía y los cifrados van encima; sin `titulo`, la
    /// partitura se titula con ellos.
    public static func partitura(
        _ digitaciones: [Digitacion], acordes: [Acorde] = [], titulo: String? = nil
    ) -> Partitura {
        let columnas = digitaciones.enumerated().map { i, digitacion in
            guard i < acordes.count else { return digitacion.alturas }
            return zip(digitacion.alturas, digitacion.notas(para: acordes[i])).map { Altura.escrita($0, con: $1) }
        }
        var posiciones: [Int: [PosicionEnElMastil]] = [:]
        for (i, digitacion) in digitaciones.enumerated() { posiciones[i] = digitacion.posiciones }
        let tablatura = digitaciones.first.map { Tablatura($0.mastil, posiciones: posiciones) }
        return Partitura(
            acordes: columnas, titulo: titulo, cifrados: Array(acordes.prefix(digitaciones.count)),
            tablatura: tablatura)
    }
}

extension EscalaEnElMastil {
    /// La posición en una partitura: las notas de `escala` en el orden en que se tocan, escritas con su ortografía
    /// y su armadura, con la tablatura debajo (`Escala.partitura(tocadaEn:titulo:figura:digitos:tablatura:)`). Con
    /// `figura`, con ritmo.
    ///
    ///     let posiciones = Mastil(.guitarra).posicionesCAGED(de: Escala("Sol mayor"))
    ///     posiciones[0].partitura(de: Escala("Sol mayor"), figura: .corchea).musicXML()   // en ArmoniaFormatos
    public func partitura(de escala: Escala, titulo: String? = nil, figura: Duracion? = nil) -> Partitura {
        escala.partitura(
            tocadaEn: alturas, titulo: titulo, figura: figura, tablatura: Tablatura(mastil, posiciones: porNota))
    }

    /// Cada posición, por el índice de su nota.
    private var porNota: [Int: [PosicionEnElMastil]] {
        Dictionary(uniqueKeysWithValues: posiciones.enumerated().map { ($0.offset, [$0.element]) })
    }
}

extension ArpegioEnElMastil {
    /// El arpegio en una partitura: las notas de `acorde` en el orden en que se tocan, escritas con su ortografía,
    /// con el cifrado encima, los dedos (``dedos``) y la tablatura debajo
    /// (`Acorde.partitura(arpegiadoEn:titulo:figura:digitos:tablatura:)`). Con `figura`, con ritmo.
    public func partitura(de acorde: Acorde, titulo: String? = nil, figura: Duracion? = nil) -> Partitura {
        var digitos: [Int: [Int]] = [:]
        for (i, dedo) in dedos.enumerated() where dedo > 0 { digitos[i] = [dedo] }
        let porNota = Dictionary(uniqueKeysWithValues: posiciones.enumerated().map { ($0.offset, [$0.element]) })
        return acorde.partitura(
            arpegiadoEn: alturas, titulo: titulo, figura: figura, digitos: digitos,
            tablatura: Tablatura(mastil, posiciones: porNota))
    }
}

extension Altura {
    /// La altura escrita con `nota` si suena igual (el La♯3 del mástil como Si♭3); si no, como estaba.
    fileprivate static func escrita(_ altura: Altura, con nota: Nota) -> Altura {
        let octavas = (altura.octava - 1)...(altura.octava + 1)
        return octavas.map { Altura(nota, octava: $0) }.first { $0.midi == altura.midi } ?? altura
    }
}
