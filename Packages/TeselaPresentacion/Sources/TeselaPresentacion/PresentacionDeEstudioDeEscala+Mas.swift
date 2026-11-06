import Armonia

/// Una escala que contiene unas notas, con las que añade.
public struct EscalaEncontrada: Hashable, Sendable {
    public let escala: Escala
    public let nombre: String
    /// Las notas de la escala que no estaban: «además: Fa, La»; vacío si no añade ninguna.
    public let ademas: String
    public let sonido: Escucha
}

/// Lo que tiene de simétrica una escala: cada cuánto se repite, desde qué notas y los acordes que se repiten.
public struct SimetriaPresentada: Hashable, Sendable {
    /// «Se repite cada 3 semitonos: 3 transposiciones distintas».
    public let resumen: String
    /// «Do, Mi♭, Fa♯, La».
    public let tonicas: String
    /// Un ciclo por tipo de acorde: el nombre del tipo y los acordes, «Do7 · Mi♭7 · Fa♯7 · La7».
    public let ciclos: [EscalaSobreElAcordePresentada]
}

/// Una posición de una escala en el mástil, con su tablatura y cómo suena: una forma de la pentatónica (con las notas
/// que comparte con la siguiente) o una secuencia de estudio tocada sin salir de la posición.
public struct PosicionPresentada: Hashable, Sendable {
    /// «Forma 1 · Trastes 5–8», «Forma C · Trastes 0–4».
    public let titulo: String
    public let posicion: EscalaEnElMastil
    /// Las notas en el orden en que se tocan.
    public let notas: [PosicionEnElMastil]
    /// Una línea por cuerda, de la aguda a la grave: «Mi |-5--8-----…».
    public let tablatura: [String]
    /// En las formas de la pentatónica, «comparte con la forma 2: 6:8 5:7 …»; vacío en las demás.
    public let comunes: String
    public let sonido: Escucha
    /// La tablatura en MusicXML.
    public let fichero: FicheroParaExportar
}

extension PresentacionDeEstudioDeEscala {
    // MARK: Buscar escalas por sus notas

    /// Las escalas que contienen unas notas, de más a menos probable, con las que añade cada una.
    ///
    ///     let escalas = PresentacionDeEstudioDeEscala.escalas(conLasNotas: [.do, .mi, .sol, .si, Nota("Fa#")],
    ///         en: .espanolCompacto)
    ///     escalas.first?.nombre   // "Do pentatónica lidia"
    public static func escalas(
        conLasNotas notas: [Nota], limite: Int = 10, en notacion: Notacion
    ) -> [EscalaEncontrada] {
        encontradas(Escala.identificar(notas: notas), clases: Set(notas.map(\.claseDeAltura)), limite, notacion)
    }

    /// Las escalas que contienen unas clases de altura (las de un mástil o un teclado MIDI, sin ortografía), cada
    /// una escrita con la tónica que da menos alteraciones.
    public static func escalas(
        conLasClases clases: [Int], limite: Int = 10, en notacion: Notacion
    ) -> [EscalaEncontrada] {
        let enLaOctava = Set(clases.map { ($0 % 12 + 12) % 12 })
        return encontradas(Escala.identificar(clasesDeAltura: clases), clases: enLaOctava, limite, notacion)
    }

    /// Las escalas que contienen las notas de una pieza (una melodía en MIDI, MusicXML, MEI o ABC), sin las que
    /// apenas suenan, de más a menos probable.
    public static func escalas(
        de pieza: PiezaImportada, limite: Int = 10, en notacion: Notacion
    ) -> [EscalaEncontrada] {
        encontradas(pieza.escalas(), clases: Set(pieza.clasesDeAltura()), limite, notacion)
    }

    private static func encontradas(
        _ escalas: [Escala], clases: Set<Int>, _ limite: Int, _ notacion: Notacion
    ) -> [EscalaEncontrada] {
        escalas.prefix(limite).map { escala in
            let nuevas = escala.notas.filter { !clases.contains($0.claseDeAltura) }.map { $0.nombre(en: notacion) }
            return EscalaEncontrada(
                escala: escala, nombre: escala.nombre(en: notacion),
                ademas: nuevas.isEmpty ? "" : notacion.texto { $0.ademas(nuevas.joined(separator: ", ")) },
                sonido: .escala(escala))
        }
    }

    // MARK: Simetría

    /// Cada cuánto se repite la escala, desde qué notas empieza igual y los acordes que se repiten; `nil` si solo se
    /// repite a la octava (o a cada semitono, como la cromática).
    ///
    ///     let simetria = PresentacionDeEstudioDeEscala.simetria(de: Escala(.do, .tonosEnteros),
    ///         en: .espanolCompacto)
    ///     simetria?.resumen   // "Se repite cada 2 semitonos: 2 transposiciones distintas"
    public static func simetria(de escala: Escala, en notacion: Notacion) -> SimetriaPresentada? {
        guard let paso = escala.intervaloDeSimetria, paso >= 2 else { return nil }
        let ciclos = escala.ciclosSimetricos.map { ciclo in
            EscalaSobreElAcordePresentada(
                escala: escala, nombre: ciclo.tipo.nombre(en: notacion),
                detalle: ciclo.acordes.map { $0.cifrado(en: notacion) }.joined(separator: " · "),
                sonido: .acordes(ciclo.acordes))
        }
        return SimetriaPresentada(
            resumen: notacion.texto { $0.repiteCada(paso, escala.transposicionesDistintas) },
            tonicas: escala.tonicasEquivalentes.map { $0.nombre(en: notacion) }.joined(separator: ", "),
            ciclos: ciclos)
    }

    // MARK: Líneas de notas guía

    /// Las dos líneas de notas guía de una progresión, una nota por acorde en blancas: desde la tercera del primer
    /// acorde y desde su séptima. Con su pentagrama, su sonido y los ficheros para exportar.
    public static func lineasDeNotasGuia(
        _ acordes: [Acorde], tonalidad: Tonalidad? = nil, en notacion: Notacion
    ) -> [SecuenciaPresentada] {
        guard !acordes.isEmpty else { return [] }
        return InicioDeNotasGuia.allCases.map { inicio in
            let alturas = Acorde.lineaDeNotasGuia(acordes, desde: inicio)
            let titulo = notacion.texto { inicio == .tercera ? $0.desdeLaTercera : $0.desdeLaSeptima }
            let presentado = PresentacionDeArpegios.presentar(
                Voz(alturas.map { Evento($0, .blanca) }), nombre: titulo, tonalidad: tonalidad, tempo: nil,
                swing: false, tonica: tonalidad?.tonica)
            return SecuenciaPresentada(
                titulo: titulo, notas: PresentacionDeCoral.voces(alturas, notacion), sonido: presentado.sonido,
                pentagrama: PentagramaPresentado(alturas.map { [$0] }, titulo: titulo, notacion: notacion),
                ficheros: presentado.ficheros)
        }
    }

    // MARK: El mástil

    /// Las cinco formas de una pentatónica en la guitarra, desde la tónica, cada una con las notas que comparte con
    /// la siguiente. Vacío si la escala no tiene cinco notas.
    public static func formasPentatonicas(
        de escala: Escala, mastil: Mastil = Mastil(.guitarra, numeroDeTrastes: 15), en notacion: Notacion
    ) -> [PosicionPresentada] {
        let formas = mastil.formasPentatonicas(de: escala)
        return formas.enumerated().map { i, forma in
            let siguiente = (i + 1) % formas.count
            let comunes = forma.notasComunes(con: formas[siguiente]).map {
                "\(mastil.encordado.numeroDeCuerdas - $0.cuerda):\($0.traste)"
            }
            let titulo = notacion.texto { $0.formaNumero(i + 1) } + " · " + rotulo(forma.rangoDeTrastes, notacion)
            return presentar(
                forma, notas: forma.posiciones, titulo: titulo, escala: escala,
                comunes: notacion.texto { $0.comparteCon(siguiente + 1, comunes.joined(separator: " ")) },
                notacion: notacion)
        }
    }

    /// Una secuencia de estudio tocada en cada posición de la escala (CAGED o tres notas por cuerda), sin salir de
    /// ella, con su tablatura.
    public static func secuenciaEnLasPosiciones(
        _ escala: Escala, _ secuencia: SecuenciaDeEscala, caged: Bool, sentido: SentidoDelIntervalo = .ascendente,
        mastil: Mastil = Mastil(.guitarra, numeroDeTrastes: 15), en notacion: Notacion
    ) -> [PosicionPresentada] {
        let posiciones = caged ? mastil.posicionesCAGED(de: escala) : mastil.posicionesPorCuerda(de: escala)
        return posiciones.map { posicion in
            let forma = posicion.forma.map { forma in notacion.texto { $0.forma(forma.rawValue) } + " · " } ?? ""
            return presentar(
                posicion, notas: posicion.secuencia(secuencia, sentido: sentido),
                titulo: forma + rotulo(posicion.rangoDeTrastes, notacion), escala: escala, comunes: "",
                notacion: notacion)
        }
    }

    private static func rotulo(_ trastes: ClosedRange<Int>, _ notacion: Notacion) -> String {
        notacion.texto { $0.trastes(trastes.lowerBound, trastes.upperBound) }
    }

    private static func presentar(
        _ posicion: EscalaEnElMastil, notas: [PosicionEnElMastil], titulo: String, escala: Escala, comunes: String,
        notacion: Notacion
    ) -> PosicionPresentada {
        let mastil = posicion.mastil
        let voz = Voz(notas.map { Evento(mastil.altura(en: $0), .corchea) })
        let xml = PresentacionDeTablatura.musicXML(
            posiciones: notas, en: mastil, ortografia: escala.notas, figura: .corchea, titulo: titulo,
            notacion: notacion)
        return PosicionPresentada(
            titulo: titulo, posicion: posicion, notas: notas,
            tablatura: tablatura(notas, en: mastil, notacion: notacion), comunes: comunes,
            sonido: Escucha.voz(voz).conTonica(escala.tonica), fichero: .musicXML(xml, nombre: titulo))
    }

    /// Unas notas en tablatura de texto, una columna por nota y una línea por cuerda, de la aguda a la grave.
    ///
    ///     Mi |----------
    ///     Si |----------
    ///     Sol|-------2--
    ///     Re |-0--2-----
    public static func tablatura(
        _ notas: [PosicionEnElMastil], en mastil: Mastil, notacion: Notacion
    ) -> [String] {
        let nombres = mastil.encordado.afinacion.map { $0.nota.nombre(en: notacion) }
        let ancho = nombres.map(\.count).reduce(0, max)
        return nombres.indices.reversed().map { cuerda in
            let celdas = notas.map { nota -> String in
                guard nota.cuerda == cuerda else { return "--" }
                let traste = String(nota.traste)
                return String(repeating: "-", count: max(0, 2 - traste.count)) + traste
            }
            return nombres[cuerda].padding(toLength: ancho, withPad: " ", startingAt: 0) + "|-"
                + celdas.joined(separator: "-") + "-"
        }
    }

    // MARK: El teclado de piano

    /// La escala dibujada en un teclado de piano (SVG), desde la octava 4: con los dedos de la mano dada o, sin
    /// mano, con el nombre de cada nota. La tónica lleva el borde naranja.
    ///
    ///     let svg = PresentacionDeEstudioDeEscala.teclado(de: Escala(.re), mano: .derecha,
    ///         en: .espanolCompacto)
    public static func teclado(
        de escala: Escala, mano: Mano? = nil, octavas: Int = 1, en notacion: Notacion
    ) -> String {
        let alturas: [Altura]
        var rotulos: [Int: String] = [:]
        var titulo = escala.nombre(en: notacion)
        if let mano {
            let digitacion = escala.digitacionDePiano(mano, octavas: octavas)
            alturas = digitacion.alturas
            for (altura, dedo) in zip(alturas, digitacion.dedos) { rotulos[altura.midi] = String(dedo) }
            titulo += " · " + notacion.texto { mano == .derecha ? $0.manoDerecha : $0.manoIzquierda }
        } else {
            // Las octavas seguidas: la tónica que cierra una abre la siguiente.
            alturas = (0..<max(1, octavas)).flatMap { escala.alturas(octava: 4 + $0) }
            for altura in alturas { rotulos[altura.midi] = altura.nota.nombre(en: notacion) }
        }
        let tonica = escala.tonica.claseDeAltura
        let primeras = Set(alturas.map(\.midi).filter { (($0 % 12) + 12) % 12 == tonica })
        return TecladoDePiano(cubriendo: alturas).svg(
            marcadas: MarcasDeDiagrama(rotulos: rotulos), primeras: primeras, opciones: .init(titulo: titulo))
    }
}
