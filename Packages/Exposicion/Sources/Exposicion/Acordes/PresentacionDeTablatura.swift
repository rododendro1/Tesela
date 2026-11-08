import Armonia

/// Tablaturas en MusicXML: digitaciones de acordes y arpegios en el mástil, con la cuerda y el traste de cada
/// nota, la afinación del instrumento y el capo, para abrirlas en MuseScore o Guitar Pro. No usa SwiftUI, así
/// que se prueba en Linux.
///
///     let mastil = Mastil(Encordado.guitarra.conCapo(2))
///     let xml = PresentacionDeTablatura.musicXML(
///         digitaciones: mastil.digitaciones(de: Acorde("Do"), limite: 1), titulo: "Re con capo",
///         en: .compacta(.espanol))
///     xml.contains("<capo>2</capo>")   // true
///
/// Es la partitura del mástil (`Partitura`, con su `Tablatura`) en MusicXML: un pentagrama con las notas (en clave de
/// sol octava baja en la guitarra) y debajo el de tablatura. Los trastes se cuentan desde el capo, como en el mástil
/// (`Encordado.conCapo(_:)`); las cuerdas se numeran como en MusicXML, desde la más aguda.
public enum PresentacionDeTablatura {
    /// Un acorde por compás, en redondas: cada digitación con todas sus cuerdas a la vez. Si se dan los acordes
    /// (uno por digitación), las notas se escriben con su ortografía (Si♭, no La♯) y los cifrados encima.
    public static func musicXML(
        digitaciones: [Digitacion], acordes: [Acorde] = [], titulo: String, en notacion: Notacion
    ) -> String {
        guard let mastil = digitaciones.first?.mastil else {
            return documento(
                Partitura(Partitura.Linea(Voz([.silencio(.redonda)]))), mastil: Mastil(), titulo: titulo,
                notacion: notacion)
        }
        let acordes = digitaciones.indices.map { i in i < acordes.count ? acordes[i] : nil }
        var partitura = Digitacion.partitura(
            digitaciones.map { Digitacion(mastil: $0.mastil, trastes: $0.trastes) }, acordes: [], titulo: titulo)
        // Los cifrados que se dan, y la ortografía de cada uno; las digitaciones sin acorde, como salen.
        var linea = partitura.pentagramas[0].voces[0]
        var porEvento = linea.porEvento
        var eventos = linea.voz.eventos
        for (i, acorde) in acordes.enumerated() {
            guard let acorde, eventos.indices.contains(i) else { continue }
            porEvento.cifrados[i] = acorde
            eventos[i] = Evento(alturas: Altura.reescritas(eventos[i].alturas, con: acorde.notas), duracion: .redonda)
        }
        linea = Partitura.Linea(Voz(eventos), porEvento: porEvento)
        partitura.pentagramas[0].voces = [linea]
        return documento(partitura, mastil: mastil, titulo: titulo, notacion: notacion)
    }

    /// Las notas de un arpegio en una posición, de grave a agudo, en corcheas (o en la figura que se diga), de
    /// cuatro tiempos en cuatro tiempos; el último compás se completa con un silencio.
    public static func musicXML(
        arpegio: ArpegioEnElMastil, acorde: Acorde? = nil, figura: Figura = .corchea, titulo: String,
        en notacion: Notacion
    ) -> String {
        musicXML(
            posiciones: arpegio.posiciones, en: arpegio.mastil, ortografia: acorde?.notas ?? [], figura: figura,
            titulo: titulo, notacion: notacion)
    }

    /// Las notas de una escala en una posición, de grave a agudo, en corcheas (o en la figura que se diga).
    public static func musicXML(
        posicion: EscalaEnElMastil, escala: Escala? = nil, figura: Figura = .corchea, titulo: String,
        en notacion: Notacion
    ) -> String {
        musicXML(
            posiciones: posicion.posiciones, en: posicion.mastil, ortografia: escala?.notas ?? [], figura: figura,
            titulo: titulo, notacion: notacion)
    }

    /// Unas posiciones tocadas una detrás de otra, todas con la misma figura, en compases de 4/4; el último se
    /// completa con un silencio.
    static func musicXML(
        posiciones: [PosicionEnElMastil], en mastil: Mastil, ortografia: [Nota], figura: Figura, titulo: String,
        notacion: Notacion
    ) -> String {
        // De la redonda (una figura más larga no cabe en un compás de 4/4) a la semicorchea.
        let duracion = min(max(figura.duracion, .semicorchea), .redonda)
        let alturas = Altura.reescritas(posiciones.map { mastil.altura(en: $0) }, con: ortografia)
        var eventos = alturas.map { Evento(alturas: [$0], duracion: duracion) }
        // Las que caben en un compás: la duración es 1/n de redonda.
        let porCompas = duracion.denominador / duracion.numerador
        let faltan = (porCompas - posiciones.count % porCompas) % porCompas
        if faltan > 0 { eventos.append(.silencio(duracion * faltan)) }
        if eventos.isEmpty { eventos = [.silencio(.redonda)] }
        let tablatura = Tablatura(
            mastil, posiciones: Dictionary(uniqueKeysWithValues: posiciones.enumerated().map { ($0, [$1]) }))
        let linea = Partitura.Linea(Voz(eventos), porEvento: .init(pulsaciones: tablatura.pulsaciones))
        let partitura = Partitura(pentagramas: [.init(voces: [linea], tablatura: tablatura)])
        return documento(partitura, mastil: mastil, titulo: titulo, notacion: notacion)
    }

    // MARK: El documento

    /// La partitura en MusicXML, con el título y, como nombre de la parte, el del instrumento.
    private static func documento(
        _ partitura: Partitura, mastil: Mastil, titulo: String, notacion: Notacion
    ) -> String {
        var partitura = partitura
        partitura.encabezado = Encabezado(titulo: titulo, nombreDeLaParte: mastil.encordado.titulo(en: notacion))
        partitura.notacion = notacion
        return partitura.musicXML()
    }
}
