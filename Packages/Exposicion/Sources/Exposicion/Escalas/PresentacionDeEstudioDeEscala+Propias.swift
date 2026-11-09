import Armonia

/// La escala en las doce tonalidades, de quinta en quinta, como hoja de estudio: cada tonalidad con sus notas y su
/// pentagrama, y todas seguidas para escucharlas y exportarlas.
public struct HojaDeEstudioPresentada: Hashable, Sendable {
    /// «Do mayor por terceras en las doce tonalidades».
    public let titulo: String
    /// Una por tonalidad, con su título («Sol mayor»), sus notas y su pentagrama.
    public let tonalidades: [SecuenciaPresentada]
    /// Las doce seguidas.
    public let sonido: Escucha
    public let ficheros: [FicheroParaExportar]
}

extension PresentacionDeEstudioDeEscala {
    // MARK: Escalas vecinas

    /// Las escalas que salen de esta moviendo una nota un semitono, cada una con el cambio: «Fa → Fa♯».
    ///
    ///     PresentacionDeEstudioDeEscala.vecinas(de: Escala(.do), en: .compacta(.espanol))
    ///         .first { $0.nombre == "Do lidio" }?.detalle   // "Fa → Fa♯"
    public static func vecinas(de escala: Escala, en notacion: Notacion) -> [EscalaConDetallePresentada] {
        escala.vecinas().map { vecina in
            EscalaConDetallePresentada(
                escala: vecina.escala, nombre: vecina.escala.nombre(en: notacion),
                detalle: vecina.desde.nombre(en: notacion) + " → " + vecina.hasta.nombre(en: notacion),
                sonido: .escala(vecina.escala))
        }
    }

    // MARK: Escalas parecidas

    /// Las escalas que comparten más notas con esta, de la que menos cambia a la que más, cada una con cuántas
    /// comparte, las que se van (−) y las que llegan (+): «Notas comunes: 6 · −Fa · +Fa♯».
    ///
    ///     PresentacionDeEstudioDeEscala.parecidas(a: Escala(.do), en: .compacta(.espanol))
    ///         .first { $0.nombre == "Do lidio" }?.detalle   // "Notas comunes: 6 · −Fa · +Fa♯"
    public static func parecidas(a escala: Escala, en notacion: Notacion) -> [EscalaConDetallePresentada] {
        escala.masParecidas().map { parecida in
            func lista(_ signo: String, _ notas: [Nota]) -> String? {
                notas.isEmpty ? nil : signo + notas.map { $0.nombre(en: notacion) }.joined(separator: " ")
            }
            let partes = [
                notacion.texto(\.notasComunes) + ": \(parecida.comunes.count)", lista("−", parecida.quitadas),
                lista("+", parecida.anadidas),
            ]
            return EscalaConDetallePresentada(
                escala: parecida.escala, nombre: parecida.escala.nombre(en: notacion),
                detalle: partes.compactMap { $0 }.joined(separator: " · "), sonido: .escala(parecida.escala))
        }
    }

    // MARK: El reloj

    /// La escala en un reloj de doce horas (SVG), en el círculo cromático o en el de quintas, con el nombre de
    /// cada nota; las que no son de la escala, con el nombre más sencillo. La tónica lleva el borde naranja.
    public static func reloj(
        de escala: Escala, orden: RelojDeClasesDeAltura.Orden = .cromatico, en notacion: Notacion
    ) -> String {
        // Las doce clases con el nombre más sencillo; encima, las de la escala como las escribe ella.
        let doce = ConjuntoDeClasesDeAltura.nombresDeLasClases(en: notacion)
        var rotulos = Dictionary(uniqueKeysWithValues: doce.enumerated().map { ($0.offset, $0.element) })
        for nota in escala.notas { rotulos[nota.claseDeAltura] = nota.nombre(en: notacion) }
        let circulo = notacion.texto { orden == .cromatico ? $0.circuloCromatico : $0.circuloDeQuintas }
        let reloj = RelojDeClasesDeAltura(
            clases: escala.notas.map(\.claseDeAltura), tonica: escala.tonica.claseDeAltura, orden: orden)
        return reloj.svg(rotulos: rotulos, opciones: .init(titulo: escala.nombre(en: notacion) + " · " + circulo))
    }

    // MARK: Las doce tonalidades

    /// La escala (o una secuencia de ella) en las doce tonalidades, de quinta en quinta desde la suya, en corcheas:
    /// las que empiezan de Do a Fa♯ desde la octava 4; las demás, desde la 3, para no subir demasiado.
    public static func enLasDoceTonalidades(
        _ escala: Escala, secuencia: SecuenciaDeEscala? = nil, en notacion: Notacion
    ) -> HojaDeEstudioPresentada {
        var titulo = escala.nombre(en: notacion)
        if let secuencia { titulo += " " + secuencia.nombre(en: notacion) }
        titulo += " · " + notacion.texto(\.enLasDoceTonalidades)
        var todas: [Altura] = []
        let tonalidades = escala.enLasDoceTonalidades.map { transportada in
            let octava = transportada.tonica.claseDeAltura <= 6 ? 4 : 3
            let alturas =
                secuencia.map { transportada.secuencia($0, octava: octava) } ?? transportada.alturas(octava: octava)
            todas += alturas
            let nombre = transportada.nombre(en: notacion)
            return SecuenciaPresentada(
                titulo: nombre, notas: PresentacionDeCoral.voces(alturas, notacion),
                sonido: Escucha.voz(Voz(alturas.map { Evento($0, .corchea) })).conTonica(transportada.tonica),
                pentagrama: PentagramaPresentado(alturas.map { [$0] }, titulo: nombre, en: notacion),
                ficheros: [])
        }
        let presentado = PresentacionDeArpegios.presentar(
            Voz(todas.map { Evento($0, .corchea) }), nombre: titulo, tonalidad: nil, tempo: nil, swing: false,
            tonica: escala.tonica)
        return HojaDeEstudioPresentada(
            titulo: titulo, tonalidades: tonalidades, sonido: presentado.sonido, ficheros: presentado.ficheros)
    }
}
