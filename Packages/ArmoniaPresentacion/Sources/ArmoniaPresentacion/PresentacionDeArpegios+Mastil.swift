import Armonia

/// Cómo se reparte un arpegio por el mástil: en franjas desde la fundamental, en las cinco formas CAGED o con una
/// nota por cuerda, como se toca con barrido.
public enum FormasDeArpegio: String, Hashable, Sendable, CaseIterable {
    /// En franjas de cuatro trastes desde la fundamental en las dos cuerdas más graves.
    case porPosiciones
    /// En las cinco formas CAGED (solo en la guitarra afinada como siempre).
    case caged
    /// Una nota por cuerda, de la grave a la aguda: el arpegio de barrido (*sweep picking*).
    case unaNotaPorCuerda
}

/// Un arpegio en una posición del mástil, con su tablatura, los dedos que pisan cada nota y cómo suena.
public struct ArpegioEnElMastilPresentado: Hashable, Sendable {
    /// «Forma E · Trastes 2–6», «Trastes 5–8».
    public let titulo: String
    public let arpegio: ArpegioEnElMastil
    /// Las notas en el orden en que se tocan: subiendo y, si se pide, bajando después.
    public let notas: [PosicionEnElMastil]
    /// Una línea por cuerda, de la aguda a la grave: «Mi |-----------3--…».
    public let tablatura: [String]
    /// El dedo de cada nota, en el mismo orden: «1 4 3 1 2 1 4» (0 en las cuerdas al aire).
    public let dedos: String
    /// Las notas en corcheas, en el orden en que se tocan.
    public let sonido: Escucha
    /// La tablatura en MusicXML.
    public let fichero: FicheroParaExportar
}

extension PresentacionDeArpegios {
    /// El arpegio de un acorde en cada posición del mástil, de la más baja a la más alta, con su tablatura y sus
    /// dedos. Con `idaYVuelta`, cada posición sube y vuelve a bajar sin repetir la nota de arriba, como se estudia el
    /// barrido.
    ///
    ///     let barrido = PresentacionDeArpegios.enElMastil(
    ///         Acorde("Lam"), formas: .unaNotaPorCuerda, notacion: .espanolCompacto)
    ///     barrido[0].dedos   // "0 0 2 2 1 0": el La menor al aire, de la 6.ª cuerda a la 1.ª
    public static func enElMastil(
        _ acorde: Acorde, formas: FormasDeArpegio = .porPosiciones, idaYVuelta: Bool = false,
        mastil: Mastil = Mastil(.guitarra, trastes: 15), notacion: Notacion
    ) -> [ArpegioEnElMastilPresentado] {
        let arpegios: [ArpegioEnElMastil]
        switch formas {
        case .porPosiciones: arpegios = mastil.arpegios(de: acorde)
        case .caged: arpegios = mastil.arpegiosCAGED(de: acorde)
        case .unaNotaPorCuerda: arpegios = mastil.arpegiosDeUnaNotaPorCuerda(de: acorde)
        }
        return arpegios.map { arpegio in
            let subida = Array(arpegio.posiciones.indices)
            let orden = idaYVuelta ? subida + subida.reversed().dropFirst() : subida
            let notas = orden.map { arpegio.posiciones[$0] }
            let forma = arpegio.forma.map { forma in notacion.texto { $0.forma(forma.rawValue) } + " · " } ?? ""
            let titulo =
                forma + notacion.texto { $0.trastes(arpegio.trastes.lowerBound, arpegio.trastes.upperBound) }
            let voz = Voz(notas.map { Evento(arpegio.mastil.altura(en: $0), .corchea) })
            let xml = PresentacionDeTablatura.musicXML(
                posiciones: notas, en: arpegio.mastil, ortografia: acorde.notas, figura: .corchea,
                titulo: acorde.cifrado(en: notacion) + " · " + titulo, notacion: notacion)
            return ArpegioEnElMastilPresentado(
                titulo: titulo, arpegio: arpegio, notas: notas,
                tablatura: PresentacionDeEstudioDeEscala.tablatura(notas, en: arpegio.mastil, notacion: notacion),
                dedos: orden.map { String(arpegio.dedos[$0]) }.joined(separator: " "),
                sonido: Escucha.voz(voz).conTonica(acorde.fundamental),
                fichero: .musicXML(xml, nombre: acorde.cifrado(en: notacion) + " · " + titulo))
        }
    }
}
