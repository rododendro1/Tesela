/// Una tecla que se pulsa o se suelta en un teclado MIDI. Aquí solo se leen los mensajes y se lleva la cuenta de
/// lo pulsado, sin CoreMIDI, así que se prueba en Linux; `EntradaMIDI`, en ArmoniaUI, los recibe del sistema.
///
///     CambioMIDI(ump: 0x2090_3C64)   // Do4 (60) pulsado, con velocidad 100
public struct CambioMIDI: Hashable, Sendable {
    public let midi: Int
    public let pulsada: Bool

    public init(midi: Int, pulsada: Bool) {
        self.midi = midi
        self.pulsada = pulsada
    }

    /// Lee una palabra UMP de un mensaje de canal de MIDI 1.0 (tipo 2): «note on» (0x9n) pulsa la nota, salvo con
    /// velocidad 0, que la suelta como «note off» (0x8n). `nil` para cualquier otro mensaje.
    public init?(ump palabra: UInt32) {
        guard palabra >> 28 == 0x2 else { return nil }
        let estado = (palabra >> 16) & 0xF0
        let nota = Int((palabra >> 8) & 0x7F)
        let velocidad = palabra & 0x7F
        switch estado {
        case 0x90: self.init(midi: nota, pulsada: velocidad > 0)
        case 0x80: self.init(midi: nota, pulsada: false)
        default: return nil
        }
    }

    /// Las notas pulsadas tras unos cambios, en el orden en que se pulsaron.
    public static func aplicar(_ cambios: [CambioMIDI], a pulsadas: [Int]) -> [Int] {
        var resultado = pulsadas
        for cambio in cambios {
            resultado.removeAll { $0 == cambio.midi }
            if cambio.pulsada { resultado.append(cambio.midi) }
        }
        return resultado
    }

    /// El acorde que se queda a la vista al tocar: el que se pulsa, aunque luego se suelte, hasta que se empieza
    /// otro con todas las teclas sueltas. Mientras se añaden notas, crece; al soltarlas, no cambia.
    ///
    /// - Parameters:
    ///   - retenido: el acorde que se veía.
    ///   - antes: las teclas pulsadas antes del cambio.
    ///   - ahora: las pulsadas después.
    public static func retener(_ retenido: [Int], antes: [Int], ahora: [Int]) -> [Int] {
        if ahora.isEmpty { return retenido }
        if antes.isEmpty || ahora.count > antes.count { return ahora }
        return retenido
    }

    /// Las clases de altura (0 = Do … 11 = Si) de unas notas MIDI, de la más grave a la más aguda y sin repetir:
    /// la primera es el bajo.
    public static func clases(de notas: [Int]) -> [Int] {
        var clases: [Int] = []
        for nota in notas.sorted() {
            let clase = ((nota % 12) + 12) % 12
            if !clases.contains(clase) { clases.append(clase) }
        }
        return clases
    }
}
