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
    ///                                                 notacion: .espanolCompacto)
    ///     arpegio.ficheros.map(\.formato)   // [.musicXML, .mei, .lilyPond, .abc, .midi]
    ///
    /// La figura puede ser de tresillo (`Duracion.corchea.grupoIrregular(3, en: 2)`), que las partituras escriben
    /// como tal. El tempo, si se da, va también en las partituras; el swing solo cambia cómo suena.
    public static func arpegio(
        _ arpegio: Arpegio, figura: Duracion = .corchea, tempo: Tempo? = nil, swing: Bool = false,
        notacion: Notacion
    ) -> ArpegioPresentado {
        let voz = Voz(arpegio, figura: figura, octava: 4)
        return presentar(
            voz, nombre: arpegio.nombre(en: notacion), tonalidad: nil, tempo: tempo, swing: swing,
            tonica: arpegio.acorde.fundamental)
    }

    /// Una progresión arpegiada en corcheas (o en la figura que se diga): cada acorde dura una blanca o, si se da
    /// su ritmo armónico (el de una pieza importada), lo que dice; el patrón se repite hasta llenarlo. La
    /// tonalidad, si se da, pone la armadura de las partituras.
    ///
    /// Con `enlazados`, cada arpegio empieza por la nota de su acorde más cercana a la última del anterior. El
    /// tempo, si se da, manda sobre el de la pieza.
    public static func progresion(
        _ acordes: [Acorde], patron: Arpegio.Patron, tonalidad: Tonalidad?,
        ritmo: RitmoArmonico? = nil, figura: Duracion = .corchea, enlazados: Bool = false, tempo: Tempo? = nil,
        swing: Bool = false, notacion: Notacion
    ) -> ArpegioPresentado? {
        guard !acordes.isEmpty else { return nil }
        let voz: Voz
        if let ritmo, ritmo.duraciones.count == acordes.count {
            voz = Voz(
                arpegiando: acordes, duraciones: ritmo.duraciones, patron: patron, figura: figura,
                compas: ritmo.compas, enlazados: enlazados)
        } else {
            voz = Voz(arpegiando: acordes, patron: patron, figura: figura, porAcorde: .blanca, enlazados: enlazados)
        }
        let nombre = "Progresión arpegiada (\(patron.nombre(en: notacion)))"
        return presentar(
            voz, nombre: nombre, tonalidad: tonalidad, tempo: tempo ?? ritmo?.tempo, swing: swing,
            tonica: tonalidad?.tonica)
    }

    static func presentar(
        _ voz: Voz, nombre: String, tonalidad: Tonalidad?, tempo: Tempo?, swing: Bool, tonica: Nota?
    ) -> ArpegioPresentado {
        let suena = Escucha.voz(voz, tempo: tempo ?? Escucha.tempo)
        return ArpegioPresentado(
            voz: voz,
            sonido: (swing ? suena.conSwing(pulso: (tempo ?? Escucha.tempo).segundos(de: .negra)) : suena)
                .conTonica(tonica),
            ficheros: FicheroParaExportar.partituras(nombre: nombre) { formato in
                voz.exportar(como: formato, tonalidad: tonalidad, tempo: tempo, titulo: nombre)
            })
    }
}
