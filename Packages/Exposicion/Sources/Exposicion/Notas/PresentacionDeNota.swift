import Armonia

// MARK: - Una nota del catálogo, escrita

/// Una nota con nombre del catálogo (`NotaConNombre`), con los nombres de las claves del JSON.
///
///     let la = NotaPresentada(.la415, en: .compacta(.espanol))
///     la.frecuencia   // 415
///     la.altura       // "La4"
public struct NotaPresentada: Hashable, Sendable, Codable {
    /// El nombre en la notación: «Do central», «middle C»…
    public let nombre: String
    public let familia: String
    /// La altura escrita en la notación: «La4», «Mi4».
    public let altura: String
    /// Los cents que se aparta de la altura temperada.
    public let desvio: Double
    /// En hercios.
    public let frecuencia: Double
    /// La frecuencia del La4 con que suena.
    public let frecuenciaDelLa4: Double
    public let midi: Int
    public let anio: Int?
    /// El nombre en su escritura, en las notas árabes y en las cuerdas griegas: «سيكاه», «μέση».
    public let nombreOriginal: String?
    /// Las alturas de la posición, en las guidonianas: «Si♭3 Si3» en «b fa ♮ mi».
    public let alturasDeLaPosicion: [String]?
    /// Las citas de las obras donde se lee.
    public let referencias: [String]

    public init(_ nota: NotaConNombre, en notacion: Notacion) {
        nombre = nota.nombre(en: notacion)
        familia = nota.familia.nombre(en: notacion)
        altura = nota.altura.nombre(en: notacion)
        desvio = nota.desvio
        frecuencia = nota.frecuencia
        frecuenciaDelLa4 = nota.frecuenciaDelLa4
        midi = nota.midi
        anio = nota.anioDeOrigen
        let original = nota.alturaConNombre?.nombre(en: .original)
        nombreOriginal = original == nota.alturaConNombre?.nombre(en: .transliterada) ? nil : original
        alturasDeLaPosicion = nota.posicion.map { $0.alturas.map { $0.nombre(en: notacion) } }
        referencias = nota.referencias.map(\.cita)
    }

    /// Unos hercios con tres decimales como mucho: «415», «261.626».
    static func hercios(_ valor: Double) -> String { Redondeo.texto(valor) + " Hz" }

    /// La ficha, un dato por fila: la familia, la altura, lo que se aparta de la temperada, la frecuencia, el La4 con
    /// que suena, el MIDI, el año, el nombre original y las alturas de la posición, los que tenga.
    public func ficha(en notacion: Notacion) -> [DatoPresentado] {
        var datos = [
            DatoPresentado(nombre: notacion.texto(\.familiaDeLaNota), valor: familia),
            DatoPresentado(nombre: notacion.texto(\.alturaDeLaNota), valor: altura),
        ]
        if desvio != 0 {
            datos.append(
                DatoPresentado(
                    nombre: notacion.texto(\.desvioDeLaNota), valor: TemperamentoPresentado.conSigno(desvio) + " ¢"))
        }
        datos.append(DatoPresentado(nombre: notacion.texto(\.frecuenciaDeLaNota), valor: Self.hercios(frecuencia)))
        if frecuenciaDelLa4 != 440 {
            datos.append(DatoPresentado(nombre: notacion.texto(\.laDeLaNota), valor: Self.hercios(frecuenciaDelLa4)))
        }
        datos.append(DatoPresentado(nombre: notacion.texto(\.midiDeLaNota), valor: "\(midi)"))
        if let anio { datos.append(DatoPresentado(nombre: notacion.texto(\.anioDeLaNota), valor: "\(anio)")) }
        if let nombreOriginal {
            datos.append(DatoPresentado(nombre: notacion.texto(\.nombreOriginalDeLaNota), valor: nombreOriginal))
        }
        if let alturasDeLaPosicion, alturasDeLaPosicion.count > 1 {
            datos.append(
                DatoPresentado(
                    nombre: notacion.texto(\.posicionGuidoniana), valor: alturasDeLaPosicion.joined(separator: " ")))
        }
        return datos
    }
}
