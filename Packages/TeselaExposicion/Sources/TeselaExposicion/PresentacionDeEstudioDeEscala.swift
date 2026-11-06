import Armonia

/// Una escala tocada en una secuencia de estudio, en corcheas: sus notas, cómo suena, el pentagrama y los ficheros
/// para exportar (MusicXML, MEI, LilyPond, ABC y MIDI).
public struct SecuenciaPresentada: Hashable, Sendable {
    /// «Do mayor por terceras».
    public let titulo: String
    /// «Do₄ Mi₄ Re₄ Fa₄…».
    public let notas: String
    public let sonido: Escucha
    public let pentagrama: PentagramaPresentado
    public let ficheros: [FicheroParaExportar]
}

/// La digitación de piano de una mano, nota a nota.
public struct DigitacionDePianoPresentada: Hashable, Sendable {
    /// «Mano derecha».
    public let mano: String
    /// «Do Re Mi Fa Sol La Si Do».
    public let notas: String
    /// «1 2 3 1 2 3 4 5», debajo de las notas.
    public let dedos: String
}

/// Un modo de una escala: su nombre, cuánto más brillante u oscuro es que el mayor y lo que cambia respecto a la
/// escala de partida.
public struct ModoPresentado: Hashable, Sendable {
    public let escala: Escala
    public let nombre: String
    /// «+1», «0», «-2»; vacío si la escala no tiene siete notas.
    public let brillo: String
    /// Los grados que cambian respecto a la escala de partida, si tienen la misma tónica: «4: Fa → Fa♯».
    public let cambios: String
    public let sonido: Escucha
}

/// Dos escalas comparadas, como lo enseñan las apps y la línea de comandos.
public struct ComparacionDeEscalasPresentada: Hashable, Sendable {
    public let comparacion: ComparacionDeEscalas
    /// «Do, Re, Mi…», o «ninguna».
    public let comunes: String
    /// «Solo en Do mayor: Fa», o vacío.
    public let soloEnOrigen: String
    public let soloEnDestino: String
    /// Un grado por línea: «4: Fa → Fa♯».
    public let cambios: [String]
    /// «1 alteraciones de diferencia», si las dos son diatónicas.
    public let distancia: String?
    /// Una escala y después la otra.
    public let sonido: Escucha
}

/// Una escala bebop o pentatónica sobre un acorde: su nombre, lo que aporta y cómo suena.
public struct EscalaSobreElAcordePresentada: Hashable, Sendable {
    public let escala: Escala
    public let nombre: String
    /// En una bebop, la nota de paso y el recorrido bajando: «nota de paso: Si · Do Si Si♭ La Sol Fa Mi Re»; en una
    /// pentatónica, sus tensiones: «9 · 13».
    public let detalle: String
    public let sonido: Escucha
}

/// La parte de la pestaña de escalas para estudiarlas (secuencias, digitación de piano, modos, comparación) y las
/// escalas sobre un acorde. No usa SwiftUI, así que se prueba en Linux.
///
///     let terceras = PresentacionDeEstudioDeEscala.secuencia(Escala(.do), .terceras, en: .espanolCompacto)
///     terceras.titulo   // "Do mayor por terceras"
public enum PresentacionDeEstudioDeEscala {
    /// La escala en una secuencia desde la octava 4, a lo largo de `octavas` octavas, subiendo o bajando.
    public static func secuencia(
        _ escala: Escala, _ secuencia: SecuenciaDeEscala, octavas: Int = 1,
        sentido: SentidoDelIntervalo = .ascendente, en notacion: Notacion
    ) -> SecuenciaPresentada {
        let alturas = escala.secuencia(secuencia, octavas: octavas, sentido: sentido)
        let titulo = escala.nombre(en: notacion) + " " + secuencia.nombre(en: notacion)
        let presentado = PresentacionDeArpegios.presentar(
            Voz(alturas.map { Evento($0, .corchea) }), nombre: titulo, tonalidad: nil, tempo: nil, swing: false,
            tonica: escala.tonica)
        return SecuenciaPresentada(
            titulo: titulo, notas: PresentacionDeCoral.voces(alturas, notacion), sonido: presentado.sonido,
            pentagrama: PentagramaPresentado(alturas.map { [$0] }, titulo: titulo, notacion: notacion),
            ficheros: presentado.ficheros)
    }

    /// La digitación de piano de las dos manos, la derecha primero.
    public static func digitaciones(
        _ escala: Escala, octavas: Int = 1, en notacion: Notacion
    ) -> [DigitacionDePianoPresentada] {
        Mano.allCases.map { mano in
            let digitacion = escala.digitacionDePiano(mano, octavas: octavas)
            return DigitacionDePianoPresentada(
                mano: notacion.texto { mano == .derecha ? $0.manoDerecha : $0.manoIzquierda },
                notas: digitacion.alturas.map { $0.nota.nombre(en: notacion) }.joined(separator: " "),
                dedos: digitacion.dedos.map(String.init).joined(separator: " "))
        }
    }

    /// Los siete modos de la mayor sobre la tónica de la escala, del más brillante al más oscuro, con lo que cambia
    /// cada uno respecto a ella.
    public static func modosParalelos(de escala: Escala, en notacion: Notacion) -> [ModoPresentado] {
        escala.modosParalelos.map { presentar($0, desde: escala, notacion: notacion) }
    }

    /// Las escalas con las mismas notas que empiezan en cada grado.
    public static func modosRelativos(de escala: Escala, en notacion: Notacion) -> [ModoPresentado] {
        escala.modosRelativos.map { presentar($0, desde: escala, notacion: notacion) }
    }

    static func presentar(_ modo: Escala, desde escala: Escala, notacion: Notacion) -> ModoPresentado {
        let brillo = modo.brillo.map { $0 > 0 ? "+\($0)" : "\($0)" }
        return ModoPresentado(
            escala: modo, nombre: modo.nombre(en: notacion), brillo: brillo ?? "",
            cambios: cambios(escala.comparar(con: modo), notacion).joined(separator: ", "),
            sonido: .escala(modo))
    }

    /// Esta escala y otra: notas comunes, las que solo están en una, los grados que cambian y la distancia en el
    /// círculo de quintas.
    ///
    ///     let lidio = PresentacionDeEstudioDeEscala.comparar(
    ///         Escala(.do), con: Escala(.do, .lidio), en: .espanolCompacto)
    ///     lidio.cambios   // ["4: Fa → Fa♯"]
    public static func comparar(
        _ escala: Escala, con otra: Escala, en notacion: Notacion
    ) -> ComparacionDeEscalasPresentada {
        let comparacion = escala.comparar(con: otra)
        func lista(_ notas: [Nota]) -> String { notas.map { $0.nombre(en: notacion) }.joined(separator: ", ") }
        func solo(_ en: Escala, _ notas: [Nota]) -> String {
            notas.isEmpty ? "" : notacion.texto { $0.soloEn(en.nombre(en: notacion)) } + ": " + lista(notas)
        }
        let ambas = (escala.alturas(octava: 4) + otra.alturas(octava: 4)).map { Evento($0, .corchea) }
        return ComparacionDeEscalasPresentada(
            comparacion: comparacion,
            comunes: comparacion.comunes.isEmpty ? notacion.texto(\.ningunaNotaComun) : lista(comparacion.comunes),
            soloEnOrigen: solo(escala, comparacion.soloEnOrigen),
            soloEnDestino: solo(otra, comparacion.soloEnDestino),
            cambios: cambios(comparacion, notacion),
            distancia: comparacion.distanciaEnQuintas.map { n in notacion.texto { $0.alteracionesDeDiferencia(n) } },
            sonido: Escucha.voz(Voz(ambas)))
    }

    private static func cambios(_ comparacion: ComparacionDeEscalas, _ notacion: Notacion) -> [String] {
        comparacion.cambios.map {
            "\($0.grado): " + $0.desde.nombre(en: notacion) + " → " + $0.hasta.nombre(en: notacion)
        }
    }

    /// Las escalas bebop que encajan con el acorde, con su nota de paso y el recorrido bajando.
    public static func bebop(sobre acorde: Acorde, en notacion: Notacion) -> [EscalaSobreElAcordePresentada] {
        acorde.escalasBebop.map { bebop in
            let paso = notacion.texto { $0.notaDePaso(bebop.notaDePaso.nombre(en: notacion)) }
            let recorrido = bebop.recorrido.map { $0.nombre(en: notacion) }.joined(separator: " ")
            return EscalaSobreElAcordePresentada(
                escala: bebop.escala, nombre: bebop.escala.nombre(en: notacion), detalle: paso + " · " + recorrido,
                sonido: .escala(bebop.escala))
        }
    }

    /// Las pentatónicas sin notas a evitar sobre el acorde, con las tensiones que suma cada una.
    public static func pentatonicas(sobre acorde: Acorde, en notacion: Notacion) -> [EscalaSobreElAcordePresentada] {
        acorde.pentatonicas.map { pentatonica in
            EscalaSobreElAcordePresentada(
                escala: pentatonica.escala, nombre: pentatonica.escala.nombre(en: notacion),
                detalle: pentatonica.tensiones.joined(separator: " · "), sonido: .escala(pentatonica.escala))
        }
    }
}

extension AnalisisPresentado {
    /// Para cada acorde del análisis, las notas de su escala que cambian respecto a la del acorde anterior y sus
    /// notas guía: «cambian: Fa♯ · notas guía: Si, Fa». Sin escala, solo las notas guía.
    public func cambiosDeEscala(en notacion: Notacion) -> [String] {
        let escalas = tramos.flatMap(\.filas).map { $0.escala?.escala }
        var anterior: Escala?
        var resultado: [String] = []
        for (acorde, escala) in zip(acordes, escalas) {
            var partes: [String] = []
            if let escala, let anterior {
                let cambian = escala.cambios(desde: anterior).map { $0.nombre(en: notacion) }
                if !cambian.isEmpty { partes.append(notacion.texto { $0.cambian(cambian.joined(separator: ", ")) }) }
            }
            let guias = acorde.notasGuia.map { $0.nombre(en: notacion) }.joined(separator: ", ")
            partes.append(notacion.texto { $0.notasGuia(guias) })
            resultado.append(partes.joined(separator: " · "))
            if let escala { anterior = escala }
        }
        return resultado
    }
}
