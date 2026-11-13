import Armonia
import Foundation

// MARK: - Partituras: MusicXML, MEI, LilyPond, GUIDO, ABC y MIDI

extension LineaDeComandos {
    /// `musicxml melodia …`, `mei melodia …`, `lilypond melodia …`, `guido melodia …`, `abc melodia …` y
    /// `midi melodia …`: las mismas opciones, salvo la clave y las marcas (no en MIDI) y el instrumento (solo MIDI).
    /// Además de una melodía, se exporta un coral, unos acordes, sus arpegios o una escala (`musicxml escala Re
    /// bayati`, con sus microtonos).
    ///
    /// Es el índice: lee las opciones (`OpcionesDePartitura`), con los acordes de `--archivo` si los hay, escribe la
    /// música del tipo que se pide y la da en el formato.
    static func partitura(
        _ argumentos: [String], _ contexto: ContextoDeOrden, formato: FormatoDePartitura
    ) throws -> ResultadoDeOrden {
        guard let tipo = argumentos.first?.lowercased() else {
            throw ErrorDeUso.faltaTipoDePartitura(orden: formato.rawValue)
        }
        var partitura = try OpcionesDePartitura(Array(argumentos.dropFirst()), tipo: tipo, formato: formato, contexto)
        try partitura.leerElArchivo(contexto)
        let datos: Data
        switch tipo {
        case "melodia", "melodía", "melody": datos = try partitura.melodia()
        case "coral", "chorale": datos = try partitura.coral()
        case _ where OpcionesDePartitura.tiposDeAcordes.contains(tipo): datos = try partitura.acordes()
        case _ where OpcionesDePartitura.tiposDeArpegios.contains(tipo): datos = try partitura.arpegios()
        case "escala", "scale": datos = try partitura.escala()
        default: throw ErrorDeUso.tipoDePartituraDesconocido(tipo)
        }
        return salida(formato, datos)
    }

    /// La partitura que da `exportar(como:…)`: el MIDI, tal cual, y los formatos de texto, sin el salto de línea del
    /// final.
    private static func salida(_ formato: FormatoDePartitura, _ datos: Data) -> ResultadoDeOrden {
        guard formato.esTexto else { return binario(datos) }
        return bien(String(decoding: datos, as: UTF8.self).trimmingCharacters(in: "\n"))
    }

    /// "sol", "fa", "do3", "do en tercera", "clave de fa", "treble", "bass", "alto"…
    static func leerClave(_ texto: String) -> Clave? {
        let abreviaturas: [String: Clave] = [
            "sol": .sol, "fa": .fa, "do1": .doEnPrimera, "do2": .doEnSegunda, "do3": .doEnTercera,
            "do4": .doEnCuarta, "sol8b": .solOctavaBaja, "sol8a": .solOctavaAlta, "fa3": .faEnTercera,
            "g": .sol, "f": .fa, "treble": .sol, "bass": .fa, "alto": .doEnTercera, "tenor": .doEnCuarta,
        ]
        let limpio = texto.lowercased()
        if let clave = abreviaturas[limpio] { return clave }
        return Clave.allCases.first { clave in
            [clave.nombre, clave.nombre(en: .ascii(.ingles))].contains { nombre in
                nombre == limpio || nombre.hasPrefix("clave de ") && String(nombre.dropFirst(9)) == limpio
            }
        }
    }
}
