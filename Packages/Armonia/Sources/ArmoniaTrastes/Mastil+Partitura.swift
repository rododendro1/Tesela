import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria

// Del mástil a la partitura: lo que se toca en él, con sus notas en el pentagrama y la tablatura debajo.

extension Tablatura {
    /// La tablatura de un mástil, con lo que se pulsa en cada nota (o acorde) por su índice: una línea por cuerda,
    /// con las cuerdas contadas como en el mástil (0 es la más grave).
    ///
    ///     let doDe5 = PosicionEnElMastil(cuerda: 1, traste: 3)   // el Do3, en la 5.ª cuerda
    ///     Tablatura(Mastil(.guitarra), posiciones: [0: [doDe5]]).notas[0]?.first?.cuerda   // 1
    public init(_ mastil: Mastil, posiciones: [Int: [PosicionEnElMastil]]) {
        self.init(
            cuerdas: mastil.encordado.numeroDeCuerdas,
            notas: posiciones.mapValues { $0.map { Pulsacion(cuerda: $0.cuerda, traste: $0.traste) } })
    }

    /// Una nota por posición, en orden.
    init(_ mastil: Mastil, unaPorNota posiciones: [PosicionEnElMastil]) {
        self.init(mastil, posiciones: Dictionary(uniqueKeysWithValues: posiciones.enumerated().map { ($0, [$1]) }))
    }
}

extension Digitacion {
    /// La digitación en una partitura: el acorde que suena, en una redonda, con su tablatura debajo. Con el acorde
    /// (`acorde` o, si no se da, ``acorde``), escrito con sus notas (Si♭, no La♯, en Do7), con el cifrado encima y,
    /// sin `titulo`, titulado con él.
    ///
    ///     let mastil = Mastil(.guitarra)
    ///     mastil.digitaciones(de: Acorde("Do"))[0].partitura().musicXML()   // en ArmoniaFormatos
    public func partitura(de acorde: Acorde? = nil, titulo: String? = nil) -> Partitura {
        Digitacion.partitura([self], acordes: [acorde ?? self.acorde].compactMap { $0 }, titulo: titulo)
    }

    /// Unas digitaciones, una detrás de otra (una redonda cada una), con la tablatura debajo. Cada una se escribe con
    /// la ortografía de su acorde: el de `acordes` (uno por digitación, en orden) o, si no se da, el suyo
    /// (``acorde``). Si se saben los de todas, los cifrados van encima y, sin `titulo`, la partitura se titula con
    /// ellos.
    public static func partitura(
        _ digitaciones: [Digitacion], acordes: [Acorde] = [], titulo: String? = nil
    ) -> Partitura {
        let suyos = digitaciones.indices.map { i in i < acordes.count ? acordes[i] : digitaciones[i].acorde }
        let columnas = zip(digitaciones, suyos).map { digitacion, acorde in
            guard let acorde else { return digitacion.alturas }
            return zip(digitacion.alturas, digitacion.notas(para: acorde)).map { Altura.escrita($0, con: $1) }
        }
        var posiciones: [Int: [PosicionEnElMastil]] = [:]
        for (i, digitacion) in digitaciones.enumerated() { posiciones[i] = digitacion.posiciones }
        let tablatura = digitaciones.first.map { Tablatura($0.mastil, posiciones: posiciones) }
        let cifrados = suyos.compactMap { $0 }
        return Partitura(
            acordes: columnas, titulo: titulo, cifrados: cifrados.count == suyos.count ? cifrados : [],
            tablatura: tablatura)
    }
}

extension EscalaEnElMastil {
    /// La posición en una partitura: sus notas en el orden en que se tocan, con la tablatura debajo. Con la escala
    /// (`escala` o, si no se da, ``escala``), escritas con su ortografía y su armadura
    /// (`Escala.partitura(tocadaEn:titulo:ritmo:digitos:tablatura:)`); sin ella, como las da el mástil. Con
    /// `ritmo: .figura(…)`, con ritmo.
    ///
    ///     let posiciones = Mastil(.guitarra).posicionesCAGED(de: Escala("Sol mayor"))
    ///     posiciones[0].partitura(ritmo: .figura(.corchea)).musicXML()   // en ArmoniaFormatos
    public func partitura(
        de escala: Escala? = nil, titulo: String? = nil, ritmo: Partitura.Ritmo = .libre
    ) -> Partitura {
        let tablatura = Tablatura(mastil, unaPorNota: posiciones)
        guard let escala = escala ?? self.escala else {
            return Partitura.tocadaEnElMastil(alturas, titulo: titulo, ritmo: ritmo, tablatura: tablatura)
        }
        return escala.partitura(tocadaEn: alturas, titulo: titulo, ritmo: ritmo, tablatura: tablatura)
    }
}

extension ArpegioEnElMastil {
    /// El arpegio en una partitura: sus notas en el orden en que se tocan, con los dedos (``dedos``) encima y la
    /// tablatura debajo. Con el acorde (`acorde` o, si no se da, ``acorde``), escritas con su ortografía y con el
    /// cifrado encima (`Acorde.partitura(arpegiadoEn:titulo:ritmo:digitos:tablatura:)`); sin él, como las da el
    /// mástil. Con `ritmo: .figura(…)`, con ritmo.
    public func partitura(
        de acorde: Acorde? = nil, titulo: String? = nil, ritmo: Partitura.Ritmo = .libre
    ) -> Partitura {
        var digitos: [Int: [Int]] = [:]
        for (i, dedo) in dedos.enumerated() where dedo > 0 { digitos[i] = [dedo] }
        let tablatura = Tablatura(mastil, unaPorNota: posiciones)
        guard let acorde = acorde ?? self.acorde else {
            return Partitura.tocadaEnElMastil(
                alturas, titulo: titulo, ritmo: ritmo, digitos: digitos, tablatura: tablatura)
        }
        return acorde.partitura(
            arpegiadoEn: alturas, titulo: titulo, ritmo: ritmo, digitos: digitos, tablatura: tablatura)
    }
}

extension Partitura {
    /// Unas alturas del mástil, una tras otra, sin escala ni acorde que las escriba: con lo que se anota en cada una y
    /// la tablatura.
    fileprivate static func tocadaEnElMastil(
        _ alturas: [Altura], titulo: String?, ritmo: Ritmo, digitos: [Int: [Int]] = [:], tablatura: Tablatura
    ) -> Partitura {
        let eventos = alturas.indices.map {
            Evento(alturas: [alturas[$0]], duracion: ritmo.duracion(de: $0, entre: alturas.count))
        }
        let voz = Voz(eventos)
        let linea = Linea(voz, porNota: AnotacionesPorNota(digitos: digitos, pulsaciones: tablatura.notas))
        var partitura = Partitura(linea, cuerdas: tablatura.cuerdas, encabezado: Encabezado(titulo: titulo))
        partitura.ritmo = ritmo != .libre
        return partitura
    }
}

extension Altura {
    /// La altura escrita con `nota` si suena igual (el La♯3 del mástil como Si♭3); si no, como estaba.
    fileprivate static func escrita(_ altura: Altura, con nota: Nota) -> Altura {
        let octavas = (altura.octava - 1)...(altura.octava + 1)
        return octavas.map { Altura(nota, octava: $0) }.first { $0.midi == altura.midi } ?? altura
    }
}
