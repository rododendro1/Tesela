// MARK: - Clase de una escala

/// Qué clase de cosa es una escala, más allá de su categoría: algo que se toca (un rāga, un maqam), la escala madre de
/// la que salen otras, un fragmento de menos de una octava o la afinación de un instrumento. En las de otras
/// tradiciones la da la categoría; en las occidentales solo se escribe si no son un modo (el hexacordo).
public enum ClaseDeEscala: String, Sendable, Codable, CaseIterable {
    /// Un modo o una escala que se toca: rāgas, janya, mūrchanā, dromoi, maqamat, dastgāh, makamlar, mugam, echoi,
    /// shteyger, qenet, pathet, diào, jo, harmoniai y las escalas sin nombre de categoría (japonesas, andinas).
    case modo
    /// Una escala madre de la que salen otras: los mēḷa y los thāṭ, los dos grāma y los laras del gamelan.
    case escalaMadre
    /// Un fragmento de escala de menos de una octava, que no se repite a la octava: los tetracordos y los géneros
    /// griegos, los ajnas, los çeşni, los hexacordos (y el occidental, el de Guido).
    case fragmento
    /// La afinación de un instrumento: las de la lira y el arpa babilónicas.
    case afinacion
}
