import ArmoniaElementos
import ArmoniaPartitura
import ArmoniaTeoria

// Del mástil a la partitura: lo que se toca en él, con sus notas en el pentagrama y la tablatura debajo.

extension Tablatura {
    /// La tablatura de un mástil, con lo que se pulsa en cada nota (o acorde) por su índice: una línea por cuerda,
    /// con las cuerdas contadas como en el mástil (0 es la más grave), y la afinación y el capo del instrumento.
    ///
    ///     let doDe5 = PosicionEnElMastil(cuerda: 1, traste: 3)   // el Do3, en la 5.ª cuerda
    ///     Tablatura(Mastil(.guitarra), posiciones: [0: [doDe5]]).pulsaciones[0]?.first?.cuerda   // 1
    public init(_ mastil: Mastil, posiciones: [Int: [PosicionEnElMastil]]) {
        let encordado = mastil.encordado
        self.init(
            numeroDeCuerdas: encordado.numeroDeCuerdas,
            pulsaciones: posiciones.mapValues { $0.map { Pulsacion(cuerda: $0.cuerda, traste: $0.traste) } },
            afinacion: encordado.sinCapo.afinacion, capo: encordado.capo > 0 ? encordado.capo : nil)
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
            return Altura.reescritas(digitacion.alturas, con: acorde.notas)
        }
        var posiciones: [Int: [PosicionEnElMastil]] = [:]
        for (i, digitacion) in digitaciones.enumerated() { posiciones[i] = digitacion.posiciones }
        let tablatura = digitaciones.first.map { Tablatura($0.mastil, posiciones: posiciones) }
        let cifrados = suyos.compactMap { $0 }
        // Los cifrados, solo si se saben todos.
        let todos = cifrados.count == suyos.count
        let porEvento = Partitura.AnotacionesPorEvento(cifrados: todos ? .enOrden(cifrados) : [:])
        return Partitura(acordes: columnas, titulo: titulo, porEvento: porEvento, tablatura: tablatura)
    }
}

extension EscalaEnElMastil {
    /// La posición en una partitura: sus notas en el orden en que se tocan, con la tablatura debajo. Con la escala
    /// (`escala` o, si no se da, ``escala``), escritas con su ortografía y su armadura
    /// (`Escala.partitura(tocadaEn:titulo:ritmo:porEvento:tablatura:)`); sin ella, como las da el mástil. Con
    /// `ritmo: .uniforme(…)`, con ritmo.
    ///
    ///     let posiciones = Mastil(.guitarra).posicionesCAGED(de: Escala("Sol mayor"))
    ///     posiciones[0].partitura(ritmo: .uniforme(.corchea)).musicXML()   // en ArmoniaFormatos
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
    /// cifrado encima (`Acorde.partitura(arpegiadoEn:titulo:ritmo:porEvento:tablatura:)`); sin él, como las da el
    /// mástil. Con `ritmo: .uniforme(…)`, con ritmo.
    public func partitura(
        de acorde: Acorde? = nil, titulo: String? = nil, ritmo: Partitura.Ritmo = .libre
    ) -> Partitura {
        var porEvento = Partitura.AnotacionesPorEvento()
        for (i, dedo) in dedos.enumerated() where dedo > 0 { porEvento.dedos[i] = [dedo] }
        let tablatura = Tablatura(mastil, unaPorNota: posiciones)
        guard let acorde = acorde ?? self.acorde else {
            return Partitura.tocadaEnElMastil(
                alturas, titulo: titulo, ritmo: ritmo, porEvento: porEvento, tablatura: tablatura)
        }
        return acorde.partitura(
            arpegiadoEn: alturas, titulo: titulo, ritmo: ritmo, porEvento: porEvento, tablatura: tablatura)
    }
}

extension Partitura {
    /// Unas alturas del mástil, una tras otra, sin escala ni acorde que las escriba: con lo que se anota en cada una y
    /// la tablatura (sus pulsaciones, si `porEvento` no trae las suyas).
    fileprivate static func tocadaEnElMastil(
        _ alturas: [Altura], titulo: String?, ritmo: Ritmo, porEvento: AnotacionesPorEvento = AnotacionesPorEvento(),
        tablatura: Tablatura
    ) -> Partitura {
        let eventos = alturas.indices.map {
            Evento(alturas: [alturas[$0]], duracion: ritmo.duracion(de: $0, entre: alturas.count))
        }
        let voz = Voz(eventos)
        var anotaciones = porEvento
        if anotaciones.pulsaciones.isEmpty { anotaciones.pulsaciones = tablatura.pulsaciones }
        let linea = Linea(voz, porEvento: anotaciones)
        return Partitura(
            pentagramas: [Pentagrama(voces: [linea], tablatura: tablatura)], encabezado: Encabezado(titulo: titulo),
            dibujaElRitmo: ritmo != .libre)
    }
}
