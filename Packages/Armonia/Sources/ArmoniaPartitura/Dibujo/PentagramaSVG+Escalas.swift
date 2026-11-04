import ArmoniaNucleo
import ArmoniaTeoria

// Lo que dibuja un pentagrama en SVG: escalas, acordes y arpegios. El dibujo está en `PentagramaSVG.swift`.

extension Escala {
    /// La escala en un pentagrama, como SVG: `Escala("Re dórico").svgPentagrama()`. Si la escala tiene microtonos
    /// (`TipoDeEscala.microtonal`), sus notas llevan los signos de Bravura: el medio bemol de un maqam, el koron de un
    /// dastgāh, las comas de Arel-Ezgi-Uzdilek de un makam, los moria de un echos bizantino (con los signos de
    /// Wyschnegradsky) o la flecha de Helmholtz-Ellis de un śruti.
    ///
    /// - Parameters:
    ///   - octava: la octava de la tónica.
    ///   - octavas: cuántas octavas sube (y baja) la escala: 2, de la tónica de `octava` a la de dos octavas más
    ///     arriba.
    ///   - sentido: si se da, solo la subida o la bajada; si es `nil`, la subida y, en las escalas que bajan con
    ///     otras notas (la menor melódica), también la bajada.
    ///   - digitacion: si se da una mano, el dedo de cada nota al piano encima (`digitacionDePiano(_:)`; al bajar, los
    ///     mismos dedos al revés).
    ///   - opciones: clave, armadura, notación, tamaño y color.
    public func svgPentagrama(
        octava: Int = 4, octavas: Int = 1, sentido: SentidoDelIntervalo? = nil, digitacion: Mano? = nil,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        let alturas = alturasMicrotonales(octava: octava, octavas: octavas, sentido: sentido)
        let armadura = opciones.armadura.notas(propia: notasDeLaArmadura)
        // Los microtonos, con su signo: el medio bemol de un maqam, el koron de un dastgāh, las comas de un makam, los
        // moria de un echos, la flecha de un śruti.
        let microtonos = alturas.map { [PentagramaSVG.Microtono.de(Evento.Nota($0), notacion: opciones.notacion)] }
        var dibujo = PentagramaSVG(
            columnas: alturas.map { [$0.altura] }, armadura: armadura, cifrado: nil,
            titulo: nombre(en: opciones.notacion), opciones: opciones, microtonos: microtonos,
            referencias: [0: PentagramaSVG.Referencia(tonica)]
        )
        if let digitacion {
            let subida = digitacionDePiano(digitacion, octava: octava, octavas: octavas).dedos
            let dedos: [Int]
            switch sentido {
            case .ascendente: dedos = subida
            case .descendente: dedos = subida.reversed()
            case nil: dedos = alturas.count > subida.count ? subida + subida.reversed().dropFirst() : subida
            }
            for (columna, dedo) in zip(alturas.indices, dedos) { dibujo.digitos[columna] = [dedo] }
        }
        return dibujo.svg()
    }

    /// La escala tocada en una secuencia de estudio (`secuencia(_:octava:octavas:sentido:)`), con ritmo: de dos en
    /// dos, en corcheas; de tres en tres, en tresillos de corcheas; de cuatro en cuatro, en semicorcheas. Así cada
    /// grupo dura un pulso y va unido por su barra. La última nota, la tónica, es una negra.
    ///
    ///     Escala(.do).svgPentagrama(secuencia: .terceras)   // Do Mi, Re Fa, Mi Sol… en corcheas
    public func svgPentagrama(
        secuencia: SecuenciaDeEscala, octava: Int = 4, octavas: Int = 1, sentido: SentidoDelIntervalo = .ascendente,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        tocada(
            en: self.secuencia(secuencia, octava: octava, octavas: octavas, sentido: sentido),
            titulo: nombre(en: opciones.notacion) + " · " + secuencia.nombre(en: opciones.notacion),
            figura: Escala.figura(deGruposDe: secuencia.pasos.count), digitos: [:], tablatura: nil,
            opciones: opciones, sentido: sentido)
    }

    /// La partitura de la escala tocada en unas alturas cualesquiera (las de una posición del mástil, una
    /// secuencia…): escritas con sus notas (el La♯ que da el mástil, como Si♭ si la escala lo tiene), con su
    /// armadura (``Partitura/Pentagrama/armadura``) y los intervalos contados desde su tónica
    /// (``Partitura/Linea/tonica``). Con `figura`, con ritmo (la última nota, una negra si la figura es más corta);
    /// sin ella, en redondas y sin ritmo (``Partitura/ritmo``). `digitos` y `tablatura` van por nota, contando desde
    /// 0. Si no se da `titulo`, el nombre de la escala. Las notas de una escala microtonal llevan su microtono, con
    /// su sistema (``Evento/Nota/sistema``): el de la subida y, las que solo están al bajar, el de la bajada.
    ///
    ///     let posicion = [Altura("La2"), Altura("Do3"), Altura("Re3"), Altura("Mi3")]
    ///     Escala(.la, .pentatonicaMenor).partitura(tocadaEn: posicion, figura: .corchea).musicXML()
    public func partitura(
        tocadaEn alturas: [Altura], titulo: String? = nil, figura: Duracion? = nil, digitos: [Int: [Int]] = [:],
        tablatura: Tablatura? = nil
    ) -> Partitura {
        partitura(
            tocadaEn: alturas, titulo: titulo, figura: figura, digitos: digitos, tablatura: tablatura, sentido: nil)
    }

    /// Como `partitura(tocadaEn:…)`, con los microtonos de la subida o de la bajada, según `sentido`; si es `nil`,
    /// los de la subida y, los de las notas que solo están al bajar, los de la bajada.
    private func partitura(
        tocadaEn alturas: [Altura], titulo: String?, figura: Duracion?, digitos: [Int: [Int]], tablatura: Tablatura?,
        sentido: SentidoDelIntervalo?
    ) -> Partitura {
        Partitura.tocada(
            notasTocadas(en: Altura.reescritas(alturas, con: notas), sentido: sentido),
            titulo: titulo ?? nombre(en: .espanolCompacto), figura: figura, digitos: digitos, tablatura: tablatura,
            acorde: nil, tonica: tonica, armadura: notasDeLaArmadura)
    }

    /// La escala tocada en unas alturas cualesquiera (las de una posición del mástil, una secuencia…), con su
    /// armadura, escritas con sus notas (el La♯ que da el mástil, como Si♭ si la escala lo tiene) y los intervalos
    /// contados desde su tónica: `partitura(tocadaEn:…).svg(opciones:)`, con el nombre de la escala en
    /// `opciones.notacion`. Las notas de una escala microtonal llevan además su microtono, con el signo de su sistema.
    public func svgPentagrama(
        tocadaEn alturas: [Altura], titulo: String? = nil, figura: Duracion? = nil, digitos: [Int: [Int]] = [:],
        tablatura: Tablatura? = nil, opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        tocada(
            en: alturas, titulo: titulo, figura: figura, digitos: digitos, tablatura: tablatura, opciones: opciones,
            sentido: nil)
    }

    /// Como `svgPentagrama(tocadaEn:…)`, con los microtonos de la subida o de la bajada, según `sentido`.
    private func tocada(
        en alturas: [Altura], titulo: String?, figura: Duracion?, digitos: [Int: [Int]], tablatura: Tablatura?,
        opciones: OpcionesDePentagrama, sentido: SentidoDelIntervalo?
    ) -> String {
        partitura(
            tocadaEn: alturas, titulo: titulo ?? nombre(en: opciones.notacion), figura: figura, digitos: digitos,
            tablatura: tablatura, sentido: sentido
        ).svg(opciones: opciones)
    }

    /// Cada altura como nota de la escala: con el microtono y el sistema que tiene esa nota en la escala, si lo
    /// tiene (el de la subida o el de la bajada, según `sentido`; si es `nil`, el de la subida y, las que solo están
    /// al bajar, el de la bajada), y si no, temperada.
    private func notasTocadas(en alturas: [Altura], sentido: SentidoDelIntervalo?) -> [Evento.Nota] {
        guard tipo.microtonal != nil else { return alturas.map { Evento.Nota($0) } }
        var porNota: [Nota: Evento.Nota] = [:]
        for tramo in sentido.map({ [$0] }) ?? [.ascendente, .descendente] {
            for altura in alturasMicrotonales(octava: 4, sentido: tramo) where porNota[altura.altura.nota] == nil {
                porNota[altura.altura.nota] = Evento.Nota(altura)
            }
        }
        return alturas.map { porNota[$0.nota]?.con(altura: $0) ?? Evento.Nota($0) }
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
    /// El acorde en un pentagrama, como SVG: `Acorde("Sol7").svgPentagrama()`. Las notas van apiladas desde el bajo, en
    /// posición cerrada y a partir de `octava` (el bajo, en la primera octava en que su nota alcanza el Do de esa
    /// octava), con el cifrado encima. Los acordes muy extensos y `maquetacion.disposicionDelAcorde = .abierta` ponen
    /// el bajo una octava más grave y el resto encima, y con eso suelen pasar al pentagrama doble. Sin armadura, salvo
    /// la de `.tonalidad`.
    public func svgPentagrama(
        octava: Int = 4, cifrado conCifrado: Bool = true,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        let cerrada = Altura.posicionCerrada(notasDesdeElBajo, desde: Altura(.do, octava: octava).midi)
        let abierta: Bool
        switch opciones.maquetacion.disposicionDelAcorde {
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
        let texto = cifrado(en: opciones.notacion)
        return PentagramaSVG(
            columnas: [alturas], armadura: opciones.armadura.notas(), cifrado: conCifrado ? texto : nil,
            titulo: texto, opciones: opciones, referencias: [0: PentagramaSVG.Referencia(self)]
        ).svg()
    }
}

extension Arpegio {
    /// El arpegio en un pentagrama, como SVG: `Arpegio("Do7").svgPentagrama()`. Cada nota, en el orden del patrón y
    /// a partir de `octava` (la del bajo), va en su columna, con las alteraciones que le hagan falta (sin armadura,
    /// salvo la de una tonalidad: `OpcionesDePentagrama(armadura: .tonalidad(…))`) y su nombre en un `<title>`; el
    /// título de la imagen es el nombre del arpegio. Con `cifrado`, el del acorde va encima de la primera nota.
    public func svgPentagrama(
        octava: Int = 4, cifrado conCifrado: Bool = false, opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        PentagramaSVG(
            columnas: alturas(octava: octava).map { [$0] }, armadura: opciones.armadura.notas(),
            cifrado: conCifrado ? acorde.cifrado(en: opciones.notacion) : nil,
            titulo: nombre(en: opciones.notacion), opciones: opciones,
            referencias: [0: PentagramaSVG.Referencia(acorde)]
        ).svg()
    }
}

extension Acorde {
    /// La partitura del acorde arpegiado en unas alturas cualesquiera (las de una posición del mástil), escritas con
    /// sus notas (Si♭, no La♯, en Do7) y con el cifrado encima de la primera. Con `figura`, con ritmo (la última
    /// nota, una negra si la figura es más corta); sin ella, en redondas y sin ritmo (``Partitura/ritmo``).
    /// `digitos` y `tablatura` van por nota, contando desde 0. Si no se da `titulo`, el cifrado.
    public func partitura(
        arpegiadoEn alturas: [Altura], titulo: String? = nil, figura: Duracion? = nil, digitos: [Int: [Int]] = [:],
        tablatura: Tablatura? = nil
    ) -> Partitura {
        Partitura.tocada(
            Altura.reescritas(alturas, con: notas).map { Evento.Nota($0) },
            titulo: titulo ?? cifrado(en: .espanolCompacto), figura: figura, digitos: digitos, tablatura: tablatura,
            acorde: self, tonica: nil, armadura: nil)
    }

    /// El acorde arpegiado en unas alturas cualesquiera, en un pentagrama:
    /// `partitura(arpegiadoEn:…).svg(opciones:)`, con el cifrado en `opciones.notacion`.
    public func svgPentagrama(
        arpegiadoEn alturas: [Altura], figura: Duracion? = nil, digitos: [Int: [Int]] = [:],
        tablatura: Tablatura? = nil, opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        partitura(
            arpegiadoEn: alturas, titulo: cifrado(en: opciones.notacion), figura: figura, digitos: digitos,
            tablatura: tablatura
        ).svg(opciones: opciones)
    }
}

extension Altura {
    /// Las alturas escritas con las notas dadas cuando suenan igual: el La♯3 del mástil, como Si♭3 en Do7. Las que no
    /// están entre las notas se quedan como estaban.
    static func reescritas(_ alturas: [Altura], con notas: [Nota]) -> [Altura] {
        alturas.map { altura in
            guard let nota = notas.first(where: { $0.claseDeAltura == altura.nota.claseDeAltura }) else {
                return altura
            }
            let octavas = (altura.octava - 1)...(altura.octava + 1)
            return octavas.map { Altura(nota, octava: $0) }.first { $0.midi == altura.midi } ?? altura
        }
    }
}
