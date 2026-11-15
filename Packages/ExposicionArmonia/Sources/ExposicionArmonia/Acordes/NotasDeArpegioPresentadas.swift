import Armonia

// Lo que se consulta de un arpegio, sin darle forma: lo mismo para el texto de `armonia arpegio` y para su salida
// `--json`. Sus nombres son las claves del JSON: en español, sin tildes y siempre las mismas, sea cual sea el idioma.
// Lo que suena y se exporta de un arpegio es `ArpegioPresentado`.

/// Un arpegio desde la octava 4: su recorrido, sus notas y las escalas que encajan con su acorde.
///
///     let datos = NotasDeArpegioPresentadas(Arpegio(Acorde("Do"), patron: .ascendente), en: .compacta(.espanol))
///     datos.notas   // ["Do₄", "Mi₄", "Sol₄", "Do₅"]
public struct NotasDeArpegioPresentadas: Hashable, Sendable, Codable {
    /// «Do7 arpegiado».
    public let nombre: String
    public let acorde: String
    /// El nombre del patrón, o los grados del recorrido propio («1-5-3-8»).
    public let recorrido: String
    /// Desde la octava 4, con su octava: «Do4».
    public let notas: [String]
    /// Las mismas, en números MIDI (60 = Do4).
    public let midi: [Int]
    /// Las escalas que encajan con el acorde, de las que tienen menos notas a evitar a las que más.
    public let escalas: [String]

    public init(_ arpegio: Arpegio, en notacion: Notacion) {
        let alturas = arpegio.alturas(octava: 4)
        nombre = arpegio.nombre(en: notacion)
        acorde = arpegio.acorde.cifrado(en: notacion)
        recorrido =
            arpegio.grados.isEmpty
            ? arpegio.patron.nombre(en: notacion) : arpegio.grados.map(String.init).joined(separator: "-")
        notas = alturas.map { $0.nombre(en: notacion) }
        midi = alturas.map(\.midi)
        escalas = arpegio.acorde.escalasCompatibles().map { $0.nombre(en: notacion) }
    }
}
