import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria
import Foundation

// La exportación de un contrapunto de especies (`Contrapunto`): las dos voces en MusicXML, MEI, LilyPond, GUIDO, ABC
// y MIDI, cada una en su pentagrama, con la de arriba encima. Las voces se nombran en latín, como en el Gradus ad
// Parnassum de Fux: «Cantus firmus» y «Contrapunctus».

extension Contrapunto {
    /// El nombre de la voz del cantus firmus en la partitura y en el MIDI.
    public static let nombreDelCantus = "Cantus firmus"
    /// El nombre de la voz del contrapunto en la partitura y en el MIDI.
    public static let nombreDelContrapunto = "Contrapunctus"

    /// El cantus firmus como voz: una redonda por compás.
    public var vozDelCantus: Voz {
        Voz(cantusFirmus.map { Evento($0, .redonda) }, compas: contrapunto.compas)
    }

    /// Las dos voces de arriba abajo, con su nombre: el contrapunto encima si va por encima del cantus.
    package var vocesDeArribaAbajo: [(voz: Voz, nombre: String)] {
        let cantus = (voz: vozDelCantus, nombre: Contrapunto.nombreDelCantus)
        let contrapunto = (voz: self.contrapunto, nombre: Contrapunto.nombreDelContrapunto)
        return contrapuntoArriba ? [contrapunto, cantus] : [cantus, contrapunto]
    }
}
