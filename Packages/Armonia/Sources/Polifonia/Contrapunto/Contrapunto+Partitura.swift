import Elementos
import Partituras
import Teoria

// La partitura de un contrapunto de especies (`Contrapunto`), de la que sale cualquier formato con Formatos: las dos
// voces, cada una en su pentagrama, con la de arriba encima. Las voces se nombran en latín, como en el Gradus ad
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

extension Contrapunto {
    /// El contrapunto en dos pentagramas, cada voz en el suyo (la de arriba encima) con su nombre latino
    /// («Cantus firmus» y «Contrapunctus», como en el Gradus ad Parnassum de Fux) y la clave que necesite menos
    /// líneas adicionales. La parte se llama como las dos voces («Cantus firmus · Contrapunctus»). Si el encabezado
    /// no da tonalidad, ninguna, como en los ejemplos modales de Fux; si no da instrumento, el coro (52).
    ///
    ///     let ejercicio = try Contrapunto(cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "La4 La4 Sol4 Fa4",
    ///                                     especie: .primera)
    ///     let xml = ejercicio.partitura(encabezado: Encabezado(titulo: "Primera especie")).musicXML()
    public func partitura(encabezado: Encabezado = Encabezado()) -> Partitura {
        let lineas = vocesDeArribaAbajo
        var cabecera = encabezado
        cabecera.nombreDeLaParte = lineas.map(\.nombre).joined(separator: " · ")
        cabecera.instrumento = encabezado.instrumento ?? 52
        return Partitura(
            pentagramas: lineas.map { Partitura.Pentagrama(voces: [Partitura.Linea($0.voz, nombre: $0.nombre)]) },
            encabezado: cabecera, compas: contrapunto.compas, anacrusa: .cero)
    }
}
