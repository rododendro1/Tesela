import Armonia

/// Un arpegio, o una progresión arpegiada, como lo ofrecen las apps: la voz con su ritmo, cómo suena y sus
/// ficheros para exportar (MusicXML, MEI y MIDI).
public struct ArpegioPresentado: Hashable, Sendable {
    public let voz: Voz
    public let sonido: Sonido
    public let ficheros: [FicheroParaExportar]
}

/// La parte de los arpegios de las apps que no es dibujo. No usa SwiftUI, así que se prueba en Linux.
public enum PresentacionDeArpegios {
    /// Un arpegio en corcheas desde la octava 4, como en el pentagrama de la pestaña de acordes.
    ///
    ///     let arpegio = PresentacionDeArpegios.arpegio(Arpegio(Acorde("Do"), patron: .alberti),
    ///                                                 notacion: .espanolUnicode)
    ///     arpegio.ficheros.map(\.formato)   // [.musicXML, .mei, .midi]
    public static func arpegio(_ arpegio: Arpegio, notacion: Notacion) -> ArpegioPresentado {
        let voz = Voz(arpegio, figura: .corchea, octava: 4)
        return presentar(
            voz, nombre: arpegio.nombre(en: notacion), tonalidad: nil,
            tonica: arpegio.acorde.fundamental)
    }

    /// Una progresión arpegiada: cada acorde dura una blanca, en corcheas, y el patrón se repite hasta
    /// llenarla. La tonalidad, si se da, pone la armadura de las partituras.
    public static func progresion(
        _ acordes: [Acorde], patron: Arpegio.Patron, tonalidad: Tonalidad?,
        notacion: Notacion
    ) -> ArpegioPresentado? {
        guard !acordes.isEmpty else { return nil }
        let voz = Voz(arpegiando: acordes, patron: patron, figura: .corchea, porAcorde: .blanca)
        let nombre = "Progresión arpegiada (\(patron.nombre(en: notacion)))"
        return presentar(voz, nombre: nombre, tonalidad: tonalidad, tonica: tonalidad?.tonica)
    }

    private static func presentar(_ voz: Voz, nombre: String, tonalidad: Tonalidad?, tonica: Nota?) -> ArpegioPresentado
    {
        ArpegioPresentado(
            voz: voz,
            sonido: Sonido.voz(voz).conTonica(tonica),
            ficheros: [
                .musicXML(voz.musicXML(tonalidad: tonalidad, titulo: nombre), nombre: nombre),
                .mei(voz.mei(tonalidad: tonalidad, titulo: nombre), nombre: nombre),
                .midi(voz.midi(tonalidad: tonalidad, titulo: nombre), nombre: nombre),
            ])
    }
}
