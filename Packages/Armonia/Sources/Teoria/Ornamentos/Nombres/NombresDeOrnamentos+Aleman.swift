// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de los ornamentos del catálogo en alemán. Qué es cada campo, en `NombresDeOrnamentos.swift`.

extension NombresDeOrnamentos {
    static let aleman = Tabla([
        .init(.trino, "Triller"),
        .init(.trinoConTerminacion, "Triller mit Nachschlag"),
        .init(.trinoCorto, "Pralltriller"),
        .init(.mordente, "Mordent"),
        .init(.mordenteSuperior, "Schneller"),
        .init(.grupeto, "Doppelschlag"),
        .init(.grupetoInvertido, "umgekehrter Doppelschlag"),
        .init(.apoyaturaSuperior, "Vorschlag von oben"),
        .init(.apoyaturaInferior, "Vorschlag von unten"),
        .init(.schleifer, "Schleifer"),
    ])
}
