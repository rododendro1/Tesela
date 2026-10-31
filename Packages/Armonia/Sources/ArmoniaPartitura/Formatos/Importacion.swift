import ArmoniaNucleo
import ArmoniaTeoria
import Foundation

// Importación de partituras: ficheros MIDI estándar (LecturaMIDI.swift) y MusicXML, sin comprimir
// (LecturaMusicXML.swift) o comprimido (.mxl, LecturaMXL.swift), leídos como una lista de notas con su
// comienzo y su duración.
//
// De ahí salen los acordes que suenan (`acordes(ventana:)`) y su análisis armónico. La reducción
// a acordes es una estimación: la pieza se corta en ventanas de un pulso, en cada una se pesan las
// clases de altura por lo que suenan y se elige la lectura que mejor explica las de más peso,
// dejando fuera, si hace falta, las notas breves (de paso, bordaduras, apoyaturas). Las ventanas
// seguidas con el mismo acorde se funden en uno.
//
// Se queda fuera, por ahora: la percusión, las repeticiones y los
// saltos (da capo, coda), y los instrumentos transpositores de MIDI (que ya suenan en su altura).

/// Una nota de una pieza importada: su altura, cuándo empieza y cuánto dura, contado en redondas
/// desde el principio de la pieza, y la parte (pista o pentagrama) de la que viene.
public struct NotaDeLaPieza: Hashable, Sendable {
    public let altura: Altura
    public let inicio: Duracion
    public let duracion: Duracion
    /// La parte de la pieza, contando desde 0: la pista y el canal en MIDI, la parte en MusicXML.
    public let parte: Int

    public init(altura: Altura, inicio: Duracion, duracion: Duracion, parte: Int = 0) {
        self.altura = altura
        self.inicio = inicio
        self.duracion = duracion
        self.parte = parte
    }

    /// Cuándo termina.
    public var fin: Duracion { inicio + duracion }
}

/// Una pieza leída de un fichero MIDI o MusicXML.
///
///     let pieza = try PiezaImportada(leyendo: Data(contentsOf: URL(fileURLWithPath: "coral.mid")))
///     pieza.tonalidad                 // la de la armadura del fichero, si la tiene
///     pieza.acordes().map(\.cifrado)  // ["Do", "Sol7/Re", "Do/Mi", …]
///     pieza.analisis()?.cifrados      // ["I", "V43", "I6", …]
public struct PiezaImportada: Hashable, Sendable {
    public let titulo: String?
    /// La tonalidad que da la armadura del fichero; `nil` si no tiene.
    public let tonalidad: Tonalidad?
    public let compas: Compas?
    public let tempo: Tempo?
    /// Las notas, ordenadas por su comienzo y, a igual comienzo, de grave a agudo.
    public let notas: [NotaDeLaPieza]

    public init(
        titulo: String? = nil, tonalidad: Tonalidad? = nil, compas: Compas? = nil, tempo: Tempo? = nil,
        notas: [NotaDeLaPieza]
    ) {
        self.titulo = titulo
        self.tonalidad = tonalidad
        self.compas = compas
        self.tempo = tempo
        self.notas = notas.sorted { ($0.inicio, $0.altura.midi, $0.parte) < ($1.inicio, $1.altura.midi, $1.parte) }
    }

    /// Lee un fichero MIDI estándar o MusicXML, comprimido o no, según lo que contenga (no según su extensión).
    /// Lanza `ErrorDeImportacion` si no es ninguno de los dos, está dañado o no tiene notas.
    public init(leyendo datos: Data) throws {
        let inicio = [UInt8](datos.prefix(4))
        if inicio == Array("MThd".utf8) {
            try self.init(midi: datos)
        } else if inicio == [0x50, 0x4B, 0x03, 0x04] {
            try self.init(mxl: datos) // un zip: MusicXML comprimido (.mxl)
        } else if String(decoding: datos.prefix(1024), as: UTF8.self).contains("<") {
            try self.init(musicXML: datos)
        } else {
            throw ErrorDeImportacion.formatoDesconocido
        }
    }

    /// Lo que dura la pieza: hasta que termina la última nota.
    public var duracion: Duracion { notas.map(\.fin).max() ?? .cero }

    /// La tonalidad de la armadura o, si el fichero no la da, la que mejor explica las notas
    /// (pesadas por lo que duran).
    public var tonalidadEstimada: Tonalidad? {
        tonalidad
            ?? Tonalidad.identificar(
                midi: notas.map(\.altura.midi),
                duraciones: notas.map(\.duracion.enRedondas)
            ).first
    }

    // MARK: Acordes

    /// Los acordes que suenan, en orden, con las ventanas seguidas del mismo acorde fundidas en uno.
    ///
    /// La pieza se corta en ventanas de `ventana` (por omisión, un pulso del compás, o una negra si
    /// no hay compás). En cada una, cada clase de altura pesa lo que suena dentro de la ventana; el
    /// bajo es la nota más grave que suena al empezar (o la más grave de la ventana, si no suena
    /// ninguna). Se prueba el conjunto entero y el que queda al quitar las una o dos clases que
    /// menos pesan, y gana la lectura más probable, penalizada por lo que deja fuera. Las ventanas
    /// en silencio o sin lectura posible no dan acorde.
    ///
    /// Los acordes se escriben en `tonalidadEstimada`.
    public func acordes(ventana: Duracion? = nil) -> [Acorde] {
        acordesConInicio(ventana: ventana).map(\.acorde)
    }

    /// Igual que `acordes(ventana:)`, con el momento en que empieza cada acorde.
    public func acordesConInicio(ventana: Duracion? = nil) -> [(acorde: Acorde, inicio: Duracion)] {
        var paso = ventana ?? compas?.pulso ?? .negra
        guard paso > .cero, !notas.isEmpty else { return [] }
        // Como mucho 100 000 ventanas, aunque una nota dure horas (un fichero dañado, por ejemplo). La ventana se
        // alarga a un múltiplo entero de la de partida: así su denominador no crece y sumarla una y otra vez no
        // desborda las fracciones.
        let maximo = 100_000
        let ventanas = (duracion.enRedondas / paso.enRedondas).rounded(.up)
        if ventanas > Double(maximo) { paso = paso * Int((ventanas / Double(maximo)).rounded(.up)) }
        let tonalidad = tonalidadEstimada
        var resultado: [(acorde: Acorde, inicio: Duracion)] = []
        // Hasta dónde llega lo que ha empezado: las notas anteriores a `primera` ya no suenan.
        var finales: [Duracion] = []
        for nota in notas { finales.append(max(finales.last ?? .cero, nota.fin)) }
        var primera = 0
        var desde = Duracion.cero
        let total = duracion
        while desde < total {
            let hasta = desde + paso
            while primera < notas.count, finales[primera] <= desde { primera += 1 }
            let suenan = notas[primera...].prefix { $0.inicio < hasta }.filter { $0.fin > desde }
            if let acorde = PiezaImportada.acorde(de: suenan, desde: desde, hasta: hasta, tonalidad: tonalidad),
                resultado.last?.acorde != acorde
            {
                resultado.append((acorde, desde))
            }
            desde = hasta
        }
        return resultado
    }

    /// Los acordes con lo que dura cada uno, su ritmo armónico: hasta que empieza el siguiente y, el
    /// último, hasta que acaba la pieza. Lo que suena antes del primer acorde no cuenta.
    ///
    ///     let pieza = try PiezaImportada(leyendo: datos)
    ///     let leidos = pieza.acordesConDuracion()
    ///     let xml = AnalisisArmonico.analizar(leidos.map(\.acorde))?.musicXML(duraciones: leidos.map(\.duracion))
    public func acordesConDuracion(ventana: Duracion? = nil) -> [(acorde: Acorde, duracion: Duracion)] {
        let leidos = acordesConInicio(ventana: ventana)
        let fin = duracion
        return leidos.indices.map { i in
            let hasta = i + 1 < leidos.count ? leidos[i + 1].inicio : fin
            return (leidos[i].acorde, hasta - leidos[i].inicio)
        }
    }

    /// El acorde de una ventana, o `nil` si no hay ninguna lectura.
    static func acorde(
        de notas: [NotaDeLaPieza], desde: Duracion, hasta: Duracion,
        tonalidad: Tonalidad?
    ) -> Acorde? {
        guard !notas.isEmpty else { return nil }
        let largo = (hasta - desde).enRedondas
        var pesos: [Int: Double] = [:]
        for nota in notas {
            let solapado = (min(nota.fin, hasta) - max(nota.inicio, desde)).enRedondas
            pesos[modulo(nota.altura.midi, 12), default: 0] += min(1, solapado / largo)
        }
        let alComienzo = notas.filter { $0.inicio <= desde }
        let bajo = modulo((alComienzo.isEmpty ? notas : alComienzo).map(\.altura.midi).min()!, 12)
        // Las demás clases, de más a menos peso (a igual peso, de grave a agudo, para que no dependa del orden).
        let resto = pesos.keys.filter { $0 != bajo }.sorted { (-pesos[$0]!, $0) < (-pesos[$1]!, $1) }

        var mejor: (acorde: Acorde, coste: Double)?
        for quitadas in 0...min(2, resto.count) {
            let quedan = Array(resto.dropLast(quitadas))
            guard quedan.count >= min(2, resto.count) else { break }
            // Quitar una nota que suena toda la ventana cuesta 0,8, más que una tensión (0,5): una corchea
            // de paso en una ventana de negra (0,4) se quita, una novena que dura todo el pulso se queda.
            let penalizacion = resto.suffix(quitadas).map { 0.8 * min(1, pesos[$0]!) }.reduce(0, +)
            guard let candidato = Acorde.candidatos(clasesDeAltura: [bajo] + quedan, tonalidad: tonalidad).first else {
                continue
            }
            let coste = candidato.coste + penalizacion
            if mejor == nil || coste < mejor!.coste { mejor = (candidato.valor, coste) }
        }
        return mejor?.acorde
    }

    // MARK: Análisis

    /// El análisis armónico de los acordes (`acordes(ventana:)`), en `tonalidad` o, si es `nil`, en
    /// la que mejor los explique. `nil` si no suena ningún acorde.
    public func analisis(en tonalidad: Tonalidad? = nil, ventana: Duracion? = nil) -> AnalisisArmonico? {
        let acordes = self.acordes(ventana: ventana)
        guard !acordes.isEmpty else { return nil }
        return tonalidad.map { $0.analizar(acordes) } ?? AnalisisArmonico.analizar(acordes)
    }
}

// MARK: - Errores

/// Por qué no se puede importar un fichero.
public enum ErrorDeImportacion: Error, Hashable, Sendable, CustomStringConvertible {
    /// No es MIDI ni MusicXML.
    case formatoDesconocido
    /// Es un zip, como el MusicXML comprimido (.mxl), pero está dañado, no tiene partitura o usa una compresión
    /// que no se lee (solo DEFLATE, sin cifrar y sin ZIP64).
    case comprimido
    /// El fichero MIDI está cortado o tiene datos que no siguen el formato.
    case midiDanado
    /// El fichero MIDI cuenta el tiempo en fotogramas SMPTE, no en pulsos por negra.
    case midiConTiempoSMPTE
    /// El XML no está bien formado; `linea` es donde se detuvo la lectura.
    case xmlDanado(linea: Int)
    /// El XML no es una partitura MusicXML por partes (`score-partwise`).
    case noEsMusicXMLPorPartes
    /// El fichero se lee, pero no tiene ninguna nota.
    case sinNotas
    /// Tiene notas, pero no suena ningún acorde (una melodía sola, por ejemplo).
    case sinAcordes

    public var description: String { descripcion(en: .espanolUnicode) }

    /// La explicación en el idioma de los textos de la notación.
    public func descripcion(en notacion: Notacion) -> String {
        let textos = TextosDePartitura.traducidos
        switch self {
        case .formatoDesconocido: return textos.map(\.formatoDesconocido).en(notacion)
        case .comprimido: return textos.map(\.musicXMLComprimido).en(notacion)
        case .midiDanado: return textos.map(\.midiDanado).en(notacion)
        case .midiConTiempoSMPTE: return textos.map(\.midiConTiempoSMPTE).en(notacion)
        case .xmlDanado(let linea): return textos.map { $0.xmlDanado(linea) }.en(notacion)
        case .noEsMusicXMLPorPartes: return textos.map(\.noEsMusicXMLPorPartes).en(notacion)
        case .sinNotas: return textos.map(\.sinNotas).en(notacion)
        case .sinAcordes: return textos.map(\.sinAcordes).en(notacion)
        }
    }
}

extension ErrorDeImportacion: LocalizedError {
    public var errorDescription: String? { description }
}

// MARK: - Auxiliares

extension Altura {
    /// La altura con esa distancia diatónica a Do4 (`pasos`) y ese número MIDI: (1, 62) → Re4,
    /// (1, 63) → Re♯4. Sirve para transportar una altura escrita sabiendo cuántos pasos y cuántos
    /// semitonos sube.
    package init(pasos: Int, midi: Int) {
        // pasos = 4q + 7o y midi − 60 = 7q + 12o, con determinante −1: siempre hay solución entera.
        let m = midi - 60
        self.init(pasosDeQuinta: 7 * m - 12 * pasos, pasosDeOctava: 7 * pasos - 4 * m)
    }
}
