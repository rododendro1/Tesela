import ArmoniaNucleo
import ArmoniaTeoria

// Lo que dibuja un pentagrama en SVG: escalas, acordes y arpegios. El dibujo está en `PentagramaSVG.swift`.

extension Escala {
    /// La escala en un pentagrama, como SVG: `Escala("Re dórico").svgPentagrama()`, que es
    /// `partitura(octava:…).svg(opciones:)`. Si la escala tiene microtonos (`TipoDeEscala.microtonal`), sus notas
    /// llevan los signos de Bravura: el medio bemol de un maqam, el koron de un dastgāh, las comas de
    /// Arel-Ezgi-Uzdilek de un makam, los moria de un echos bizantino (con los signos de Wyschnegradsky) o la flecha
    /// de Helmholtz-Ellis de un śruti.
    ///
    /// - Parameters:
    ///   - octava: la octava de la tónica.
    ///   - octavas: cuántas octavas sube (y baja) la escala: 2, de la tónica de `octava` a la de dos octavas más
    ///     arriba.
    ///   - sentido: si se da, solo la subida o la bajada; si es `nil`, la subida y, en las escalas que bajan con
    ///     otras notas (la menor melódica), también la bajada.
    ///   - digitacion: si se da una mano, el dedo de cada nota al piano encima (`digitacionDePiano(_:)`; al bajar, los
    ///     mismos dedos al revés).
    ///   - opciones: clave, armadura, notación, título, tamaño y color.
    public func svgPentagrama(
        octava: Int = 4, octavas: Int = 1, sentido: SentidoDelIntervalo? = nil, digitacion: Mano? = nil,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        partitura(octava: octava, octavas: octavas, sentido: sentido, digitacion: digitacion).svg(opciones: opciones)
    }

    /// La partitura de la escala, la que dibuja `svgPentagrama(octava:…)`: en redondas y sin ritmo
    /// (``Partitura/dibujaElRitmo``) o, con `ritmo: .uniforme(…)`, con ritmo (``Partitura/Ritmo``). Con
    /// su armadura (``Partitura/Pentagrama/armadura``), los intervalos contados desde su tónica
    /// (``Partitura/Linea/tonica``), los microtonos de una escala microtonal con su sistema
    /// (``Evento/NotaDelEvento/sistema``) y, con `digitacion`, el dedo de cada nota al piano. Su título es el nombre de la escala (``Encabezado/tema``),
    /// en la notación con que se dibuja o se exporta.
    ///
    ///     Escala("Re dórico").partitura().musicXML()                 // en ArmoniaFormatos
    ///     Escala("Re dórico").partitura(ritmo: .uniforme(.corchea)).svg()   // en corcheas
    public func partitura(
        octava: Int = 4, octavas: Int = 1, sentido: SentidoDelIntervalo? = nil, digitacion: Mano? = nil,
        ritmo: Partitura.Ritmo = .libre
    ) -> Partitura {
        let alturas = alturasMicrotonales(octava: octava, octavas: octavas, sentido: sentido)
        var dedos: [Int: [Int]] = [:]
        if let digitacion {
            let subida = digitacionDePiano(digitacion, octava: octava, octavas: octavas).dedos
            let deLaMano: [Int]
            switch sentido {
            case .ascendente: deLaMano = subida
            case .descendente: deLaMano = subida.reversed()
            case nil: deLaMano = alturas.count > subida.count ? subida + subida.reversed().dropFirst() : subida
            }
            for (columna, dedo) in zip(alturas.indices, deLaMano) { dedos[columna] = [dedo] }
        }
        return Partitura.tocada(
            alturas.map { Evento.NotaDelEvento($0) }, tema: .escala(self), ritmo: ritmo,
            porEvento: Partitura.AnotacionesPorEvento(dedos: dedos), acorde: nil, tonica: tonica,
            armadura: notasDeLaArmadura)
    }

    /// La escala tocada en una secuencia de estudio (`secuencia(_:octava:octavas:sentido:)`), con ritmo: de dos en
    /// dos, en corcheas; de tres en tres, en tresillos de corcheas; de cuatro en cuatro, en semicorcheas. Así cada
    /// grupo dura un pulso y va unido por su barra. La última nota, la tónica, es una negra. Es
    /// `partitura(secuencia:…).svg(opciones:)`.
    ///
    ///     Escala(.do).svgPentagrama(secuencia: .terceras)   // Do Mi, Re Fa, Mi Sol… en corcheas
    public func svgPentagrama(
        secuencia: SecuenciaDeEscala, octava: Int = 4, octavas: Int = 1, sentido: SentidoDelIntervalo = .ascendente,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        partitura(secuencia: secuencia, octava: octava, octavas: octavas, sentido: sentido).svg(opciones: opciones)
    }

    /// La partitura de la escala tocada en una secuencia de estudio, con el ritmo de `svgPentagrama(secuencia:…)` y,
    /// de título, el nombre de la escala y el de la secuencia («Do mayor · por terceras»:
    /// ``Encabezado/Tema/secuencia(_:de:)``), en la notación con que se dibuja o se exporta.
    public func partitura(
        secuencia: SecuenciaDeEscala, octava: Int = 4, octavas: Int = 1, sentido: SentidoDelIntervalo = .ascendente
    ) -> Partitura {
        partitura(
            tocadaEn: self.secuencia(secuencia, octava: octava, octavas: octavas, sentido: sentido), titulo: nil,
            tema: .secuencia(secuencia, de: self), ritmo: .uniforme(Escala.figura(deGruposDe: secuencia.pasos.count)),
            porEvento: Partitura.AnotacionesPorEvento(), tablatura: nil, sentido: sentido)
    }

    /// La partitura de la escala tocada en unas alturas cualesquiera (las de una posición del mástil, una
    /// secuencia…): escritas con sus notas (el La♯ que da el mástil, como Si♭ si la escala lo tiene), con su
    /// armadura (``Partitura/Pentagrama/armadura``) y los intervalos contados desde su tónica
    /// (``Partitura/Linea/tonica``). Con `ritmo: .uniforme(…)`, con ritmo (``Partitura/Ritmo``);
    /// sin él, en redondas y sin ritmo (``Partitura/dibujaElRitmo``). Lo que se anota en cada nota va en `porEvento`, por su
    /// índice desde 0 (los dedos, los grados, los cifrados…), y las pulsaciones son las de `tablatura` si `porEvento`
    /// no trae las suyas. Si no se da `titulo`, el de la partitura es el nombre de la escala (``Encabezado/tema``),
    /// en la notación con que se dibuja o se exporta. Las notas de una escala microtonal llevan su microtono, con
    /// su sistema (``Evento/NotaDelEvento/sistema``): el de la subida y, las que solo están al bajar, el de la bajada.
    ///
    ///     let posicion = [Altura("La2"), Altura("Do3"), Altura("Re3"), Altura("Mi3")]
    ///     Escala(.la, .pentatonicaMenor).partitura(tocadaEn: posicion, ritmo: .uniforme(.corchea)).musicXML()
    ///     Escala(.do).partitura(tocadaEn: ["Do4", "Re4"], porEvento: .init(dedos: [0: [1], 1: [3]])).svg()
    public func partitura(
        tocadaEn alturas: [Altura], titulo: String? = nil, ritmo: Partitura.Ritmo = .libre,
        porEvento: Partitura.AnotacionesPorEvento = Partitura.AnotacionesPorEvento(), tablatura: Tablatura? = nil
    ) -> Partitura {
        partitura(
            tocadaEn: alturas, titulo: titulo, tema: .escala(self), ritmo: ritmo, porEvento: porEvento,
            tablatura: tablatura, sentido: nil)
    }

    /// Como `partitura(tocadaEn:…)`, con los microtonos de la subida o de la bajada, según `sentido`; si es `nil`,
    /// los de la subida y, los de las notas que solo están al bajar, los de la bajada.
    private func partitura(
        tocadaEn alturas: [Altura], titulo: String?, tema: Encabezado.Tema, ritmo: Partitura.Ritmo,
        porEvento: Partitura.AnotacionesPorEvento, tablatura: Tablatura?, sentido: SentidoDelIntervalo?
    ) -> Partitura {
        Partitura.tocada(
            notasTocadas(en: Altura.reescritas(alturas, con: notas), sentido: sentido),
            titulo: titulo, tema: tema, ritmo: ritmo, porEvento: porEvento, tablatura: tablatura, acorde: nil,
            tonica: tonica, armadura: notasDeLaArmadura)
    }

    /// La escala tocada en unas alturas cualesquiera (las de una posición del mástil, una secuencia…), con su
    /// armadura, escritas con sus notas (el La♯ que da el mástil, como Si♭ si la escala lo tiene) y los intervalos
    /// contados desde su tónica: `partitura(tocadaEn:…).svg(opciones:)`, con el nombre de la escala en
    /// `opciones.notacion`. Las notas de una escala microtonal llevan además su microtono, con el signo de su sistema.
    public func svgPentagrama(
        tocadaEn alturas: [Altura], titulo: String? = nil, ritmo: Partitura.Ritmo = .libre,
        porEvento: Partitura.AnotacionesPorEvento = Partitura.AnotacionesPorEvento(), tablatura: Tablatura? = nil,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        partitura(tocadaEn: alturas, titulo: titulo, ritmo: ritmo, porEvento: porEvento, tablatura: tablatura)
            .svg(opciones: opciones)
    }

    /// Cada altura como nota de la escala: con el microtono y el sistema que tiene esa nota en la escala, si lo
    /// tiene (el de la subida o el de la bajada, según `sentido`; si es `nil`, el de la subida y, las que solo están
    /// al bajar, el de la bajada), y si no, temperada.
    private func notasTocadas(en alturas: [Altura], sentido: SentidoDelIntervalo?) -> [Evento.NotaDelEvento] {
        guard tipo.microtonal != nil else { return alturas.map { Evento.NotaDelEvento($0) } }
        var porEvento: [Nota: Evento.NotaDelEvento] = [:]
        for tramo in sentido.map({ [$0] }) ?? [.ascendente, .descendente] {
            for altura in alturasMicrotonales(octava: 4, sentido: tramo) where porEvento[altura.altura.nota] == nil {
                porEvento[altura.altura.nota] = Evento.NotaDelEvento(altura)
            }
        }
        return alturas.map { porEvento[$0.nota]?.con(altura: $0) ?? Evento.NotaDelEvento($0) }
    }

    /// La figura con que un grupo de `notas` dura un pulso de negra: corcheas, tresillos de corcheas o semicorcheas.
    static func figura(deGruposDe notas: Int) -> Duracion {
        switch notas {
        case ...2: return .corchea
        case 3: return Duracion.corchea.grupoIrregular(3, en: 2)
        default: return .semicorchea
        }
    }
}

extension Acorde {
    /// El acorde en un pentagrama, como SVG: `Acorde("Sol7").svgPentagrama()`, que es
    /// `partitura(octava:posicion:).svg(opciones:)` con la posición de `maquetacion.posicionDelAcorde` y,
    /// si `cifrado` es `false`, sin el cifrado encima (`marcas.cifrados`).
    public func svgPentagrama(
        octava: Int = 4, cifrado conCifrado: Bool = true,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        var suyas = opciones
        suyas.marcas.cifrados = opciones.marcas.cifrados && conCifrado
        return partitura(octava: octava, posicion: opciones.maquetacion.posicionDelAcorde).svg(opciones: suyas)
    }

    /// La partitura del acorde, en una redonda y sin ritmo (``Partitura/dibujaElRitmo``): las notas apiladas desde el bajo,
    /// en posición cerrada y a partir de `octava` (el bajo, en la primera octava en que su nota alcanza el Do de esa
    /// octava), con el cifrado encima. Los acordes muy extensos y la posición `.abierta` ponen el bajo una octava
    /// más grave y el resto encima, y con eso suelen pasar al pentagrama doble. Sin armadura, salvo la de
    /// `.tonalidad` en las opciones. Su título es el cifrado (``Encabezado/tema``), en la notación con que se dibuja
    /// o se exporta.
    ///
    ///     Acorde("Sol7").partitura().musicXML()   // en ArmoniaFormatos
    public func partitura(octava: Int = 4, posicion: OpcionesDePentagrama.Posicion = .automatica) -> Partitura {
        let cerrada = Altura.posicionCerrada(notasDesdeElBajo, desde: Altura(.do, octava: octava).midi)
        let abierta: Bool
        switch posicion {
        case .cerrada: abierta = false
        case .abierta: abierta = true
        case .automatica:
            let ambito = cerrada.map(\.midi).extremosOSi(noHay: 0...0)
            abierta = ambito.upperBound - ambito.lowerBound >= 17
        }
        var alturas = cerrada
        if abierta, let bajo = notasDesdeElBajo.first, notasDesdeElBajo.count > 1 {
            alturas =
                Altura.posicionCerrada([bajo], desde: Altura(.do, octava: octava - 1).midi)
                + Altura.posicionCerrada(
                    Array(notasDesdeElBajo.dropFirst()), desde: Altura(.do, octava: octava).midi)
        }
        return Partitura.tocada(
            juntas: [alturas.map { Evento.NotaDelEvento($0) }], tema: .acorde(self), acorde: self, tonica: nil,
            armadura: nil)
    }
}

extension Arpegio {
    /// El arpegio en un pentagrama, como SVG: `Arpegio("Do7").svgPentagrama()`, que es
    /// `partitura(octava:).svg(opciones:)` con el cifrado del acorde solo si `cifrado` es `true`
    /// (`marcas.cifrados`).
    public func svgPentagrama(
        octava: Int = 4, cifrado conCifrado: Bool = false, opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        var suyas = opciones
        suyas.marcas.cifrados = opciones.marcas.cifrados && conCifrado
        return partitura(octava: octava).svg(opciones: suyas)
    }

    /// La partitura del arpegio, en redondas y sin ritmo (``Partitura/dibujaElRitmo``) o, con `ritmo: .uniforme(…)`, con ritmo
    /// (``Partitura/Ritmo``): cada nota, en el orden del patrón y a partir de `octava`
    /// (la del bajo), con las alteraciones que le hagan falta (sin armadura, salvo la de una tonalidad:
    /// `OpcionesDePentagrama(armadura: .tonalidad(…))`) y el cifrado del acorde encima de la primera. Su título es
    /// el nombre del arpegio (``Encabezado/tema``), en la notación con que se dibuja o se exporta.
    ///
    ///     Arpegio(Acorde("Do7")).partitura().musicXML()                         // en ArmoniaFormatos
    ///     Arpegio(Acorde("Do7")).partitura(ritmo: .uniforme(.corchea)).svg()   // en corcheas
    public func partitura(octava: Int = 4, ritmo: Partitura.Ritmo = .libre) -> Partitura {
        Partitura.tocada(
            alturas(octava: octava).map { Evento.NotaDelEvento($0) }, tema: .arpegio(self), ritmo: ritmo,
            acorde: acorde, tonica: nil, armadura: nil)
    }
}

extension Acorde {
    /// La partitura del acorde arpegiado en unas alturas cualesquiera (las de una posición del mástil), escritas con
    /// sus notas (Si♭, no La♯, en Do7) y con el cifrado encima de la primera, si `porEvento` no le da otro. Con
    /// `ritmo: .uniforme(…)`, con ritmo (``Partitura/Ritmo``); sin él, en redondas y sin ritmo (``Partitura/dibujaElRitmo``).
    /// Lo que se anota en cada nota va en `porEvento`, por su índice desde 0, y las pulsaciones son las de `tablatura`
    /// si `porEvento` no trae las suyas. Si no se da `titulo`, el de la partitura es el cifrado (``Encabezado/tema``),
    /// en la notación con que se dibuja o se exporta.
    ///
    ///     let porEvento = Partitura.AnotacionesPorEvento(dedos: [0: [2], 1: [1], 2: [3]])
    ///     Acorde("Do").partitura(arpegiadoEn: ["Do3", "Mi3", "Sol3"], porEvento: porEvento).svg()
    public func partitura(
        arpegiadoEn alturas: [Altura], titulo: String? = nil, ritmo: Partitura.Ritmo = .libre,
        porEvento: Partitura.AnotacionesPorEvento = Partitura.AnotacionesPorEvento(), tablatura: Tablatura? = nil
    ) -> Partitura {
        Partitura.tocada(
            Altura.reescritas(alturas, con: notas).map { Evento.NotaDelEvento($0) },
            titulo: titulo, tema: .acorde(self), ritmo: ritmo, porEvento: porEvento, tablatura: tablatura,
            acorde: self,
            tonica: nil, armadura: nil)
    }

    /// El acorde arpegiado en unas alturas cualesquiera, en un pentagrama:
    /// `partitura(arpegiadoEn:…).svg(opciones:)`, con el cifrado (y el título) en `opciones.notacion`.
    public func svgPentagrama(
        arpegiadoEn alturas: [Altura], ritmo: Partitura.Ritmo = .libre,
        porEvento: Partitura.AnotacionesPorEvento = Partitura.AnotacionesPorEvento(), tablatura: Tablatura? = nil,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        partitura(arpegiadoEn: alturas, ritmo: ritmo, porEvento: porEvento, tablatura: tablatura)
            .svg(opciones: opciones)
    }
}

extension Altura {
    /// Las alturas escritas con las notas dadas cuando suenan igual: el La♯3 del mástil, como Si♭3 en Do7. Las que no
    /// están entre las notas se quedan como estaban. Si dos notas suenan igual, la primera. El número MIDI no cambia:
    /// el Do4, con Si♯, es el Si♯3.
    ///
    ///     Altura.reescritas(["Do4", "La#3"], con: Acorde("Do7").notas)   // [Do4, Si♭3]
    public static func reescritas(_ alturas: [Altura], con notas: [Nota]) -> [Altura] {
        alturas.map { altura in
            guard let nota = notas.first(where: { $0.claseDeAltura == altura.nota.claseDeAltura }) else {
                return altura
            }
            let octavas = (altura.octava - 1)...(altura.octava + 1)
            return octavas.map { Altura(nota, octava: $0) }.first { $0.midi == altura.midi } ?? altura
        }
    }
}
