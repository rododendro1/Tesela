import Armonia

/// Un arpegio, o una progresión arpegiada, como lo ofrecen las apps: la voz con su ritmo, cómo suena y sus
/// ficheros para exportar (MusicXML, MEI, LilyPond, ABC y MIDI).
public struct ArpegioPresentado: Hashable, Sendable {
    public let voz: Voz
    public let sonido: Escucha
    public let ficheros: [FicheroParaExportar]
}

/// La parte de los arpegios de las apps que no es dibujo. No usa SwiftUI, así que se prueba en Linux.
public enum PresentacionDeArpegios {
    /// Un arpegio desde la octava 4, en corcheas o en la figura que se diga, como en el pentagrama de la pestaña
    /// de acordes.
    ///
    ///     let arpegio = PresentacionDeArpegios.arpegio(Arpegio(Acorde("Do"), patron: .alberti),
    ///                                                 notacion: .espanolUnicode)
    ///     arpegio.ficheros.map(\.formato)   // [.musicXML, .mei, .lilyPond, .abc, .midi]
    public static func arpegio(
        _ arpegio: Arpegio, figura: Duracion = .corchea, notacion: Notacion
    ) -> ArpegioPresentado {
        let voz = Voz(arpegio, figura: figura, octava: 4)
        return presentar(
            voz, nombre: arpegio.nombre(en: notacion), tonalidad: nil, tempo: nil,
            tonica: arpegio.acorde.fundamental)
    }

    /// Una progresión arpegiada en corcheas (o en la figura que se diga): cada acorde dura una blanca o, si se da
    /// su ritmo armónico (el de una pieza importada), lo que dice; el patrón se repite hasta llenarlo. La
    /// tonalidad, si se da, pone la armadura de las partituras.
    public static func progresion(
        _ acordes: [Acorde], patron: Arpegio.Patron, tonalidad: Tonalidad?,
        ritmo: RitmoArmonico? = nil, figura: Duracion = .corchea, notacion: Notacion
    ) -> ArpegioPresentado? {
        guard !acordes.isEmpty else { return nil }
        let voz: Voz
        if let ritmo, ritmo.duraciones.count == acordes.count {
            voz = Voz(
                arpegiando: acordes, duraciones: ritmo.duraciones, patron: patron, figura: figura,
                compas: ritmo.compas)
        } else {
            voz = Voz(arpegiando: acordes, patron: patron, figura: figura, porAcorde: .blanca)
        }
        let nombre = "Progresión arpegiada (\(patron.nombre(en: notacion)))"
        return presentar(voz, nombre: nombre, tonalidad: tonalidad, tempo: ritmo?.tempo, tonica: tonalidad?.tonica)
    }

    private static func presentar(
        _ voz: Voz, nombre: String, tonalidad: Tonalidad?, tempo: Tempo?, tonica: Nota?
    ) -> ArpegioPresentado {
        ArpegioPresentado(
            voz: voz,
            sonido: Escucha.voz(voz, tempo: tempo ?? Escucha.tempo).conTonica(tonica),
            ficheros: [
                .musicXML(voz.musicXML(tonalidad: tonalidad, tempo: tempo, titulo: nombre), nombre: nombre),
                .mei(voz.mei(tonalidad: tonalidad, tempo: tempo, titulo: nombre), nombre: nombre),
                .lilyPond(voz.lilyPond(tonalidad: tonalidad, tempo: tempo, titulo: nombre), nombre: nombre),
                .abc(voz.abc(tonalidad: tonalidad, tempo: tempo, titulo: nombre), nombre: nombre),
                .midi(voz.midi(tonalidad: tonalidad, tempo: tempo, titulo: nombre), nombre: nombre),
            ])
    }
}
