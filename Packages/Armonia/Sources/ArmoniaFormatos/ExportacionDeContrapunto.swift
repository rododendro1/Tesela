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

    /// El contrapunto como partitura MusicXML en dos pentagramas, cada voz en el suyo y con su clave (la de sol o
    /// la de fa, la que necesite menos líneas adicionales).
    ///
    ///     let ejercicio = try Contrapunto(cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "La4 La4 Sol4 Fa4",
    ///                                     especie: .primera)
    ///     let xml = ejercicio.musicXML(titulo: "Primera especie")
    ///
    /// - Parameters:
    ///   - tonalidad: da la armadura; si es `nil`, ninguna, como en los ejemplos modales de Fux.
    ///   - tempo: si se da, se escribe la indicación metronómica.
    ///   - titulo: el título de la obra.
    public func musicXML(tonalidad: Tonalidad? = nil, tempo: Tempo? = nil, titulo: String? = nil) -> String {
        Exportacion.documento(EscritorMusicXML.self, de: self, tonalidad: tonalidad, tempo: tempo, titulo: titulo)
    }

    /// El contrapunto como partitura MEI en dos pentagramas, como `musicXML(tonalidad:tempo:titulo:)`.
    public func mei(tonalidad: Tonalidad? = nil, tempo: Tempo? = nil, titulo: String? = nil) -> String {
        Exportacion.documento(EscritorMEI.self, de: self, tonalidad: tonalidad, tempo: tempo, titulo: titulo)
    }

    /// El contrapunto como partitura de LilyPond en dos pentagramas, como `musicXML(tonalidad:tempo:titulo:)`.
    public func lilyPond(tonalidad: Tonalidad? = nil, tempo: Tempo? = nil, titulo: String? = nil) -> String {
        Exportacion.documento(EscritorLilyPond.self, de: self, tonalidad: tonalidad, tempo: tempo, titulo: titulo)
    }

    /// El contrapunto como partitura GMN (GUIDO) en dos pentagramas, como `musicXML(tonalidad:tempo:titulo:)`.
    public func guido(tonalidad: Tonalidad? = nil, tempo: Tempo? = nil, titulo: String? = nil) -> String {
        Exportacion.documento(EscritorGUIDO.self, de: self, tonalidad: tonalidad, tempo: tempo, titulo: titulo)
    }

    /// El contrapunto en ABC, en dos pentagramas, como `musicXML(tonalidad:tempo:titulo:)`.
    public func abc(tonalidad: Tonalidad? = nil, tempo: Tempo? = nil, titulo: String? = nil) -> String {
        Exportacion.documento(EscritorABC.self, de: self, tonalidad: tonalidad, tempo: tempo, titulo: titulo)
    }

    /// El contrapunto como fichero MIDI estándar, con una pista por voz, de arriba abajo.
    ///
    /// - Parameters:
    ///   - tonalidad: la armadura que se escribe en el fichero; si es `nil`, ninguna.
    ///   - tempo: si es `nil`, negra = 120 (el de MIDI por omisión).
    ///   - instrumento: el programa General MIDI de las dos voces (52 = coro «aahs»).
    ///   - afinacion: en la que suenan las notas; si es `nil`, el temperamento igual.
    public func midi(
        tonalidad: Tonalidad? = nil, tempo: Tempo? = nil, titulo: String? = nil, instrumento: Int = 52,
        afinacion: (any Afinacion)? = nil
    ) -> Data {
        let encabezado = Encabezado(titulo: titulo, tonalidad: tonalidad, tempo: tempo, instrumento: instrumento)
        return partitura(encabezado: encabezado).midi(afinacion: afinacion)
    }
}

extension Exportacion {
    /// Un contrapunto en dos pentagramas (ver `Contrapunto.partitura(encabezado:)`).
    package static func documento<Escritor: EscritorDePartitura>(
        _ escritor: Escritor.Type, de ejercicio: Contrapunto, tonalidad: Tonalidad?, tempo: Tempo?, titulo: String?
    ) -> String {
        let encabezado = Encabezado(titulo: titulo, tonalidad: tonalidad, tempo: tempo)
        return documento(escritor, de: ejercicio.partitura(encabezado: encabezado))
    }
}
