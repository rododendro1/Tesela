import Armonia
import Foundation

/// Un coral a cuatro voces tal como lo enseñan la app y la línea de comandos: las propuestas de
/// armonización, si se armoniza una melodía, un acorde por fila con sus alturas, los avisos y los
/// ficheros para exportar.
public struct CoralPresentado: Hashable, Sendable {
    public struct Fila: Hashable, Sendable {
        /// El cifrado americano, o "–" si las notas no forman un acorde conocido.
        public let cifrado: String
        /// El cifrado romano, o "" si no se ha analizado.
        public let grado: String
        /// Las alturas de grave a agudo («Do3 Mi4 Sol4 Do5»).
        public let voces: String
    }

    /// La tonalidad, o "" al revisar.
    public let titulo: String
    /// Las armonizaciones de la melodía, de mejor a peor; vacío si no se armoniza.
    public let propuestas: [String]
    public let filas: [Fila]
    /// Las faltas de conducción, o por qué no hay coral.
    public let avisos: [Aviso]
    public let ficheros: [FicheroParaExportar]
    /// El coral a cuatro voces, para «Escuchar»; en silencio si no hay coral.
    public internal(set) var sonido: Escucha = .silencio

    /// Por qué no hay coral, o cómo ha ido la revisión. `texto(en:)` lo escribe en el idioma de la notación.
    public enum Aviso: Hashable, Sendable {
        /// Alguna nota de la melodía no está en ningún acorde de la tonalidad.
        case sinArmonizacion
        /// La melodía no lleva octavas, así que solo se armoniza, sin escribirla a cuatro voces.
        case faltanOctavas
        /// Hay armonización, pero ningún coral a cuatro voces sin faltas con la melodía en el soprano.
        case sinCoralParaLaMelodia
        /// Los acordes no se pueden escribir a cuatro voces sin faltas.
        case sinRealizacion
        /// La revisión no ha encontrado faltas.
        case sinFaltasDeConduccion
        /// Una falta de conducción (quintas paralelas, cruzamiento…).
        case falta(FaltaDeConduccion)

        public func texto(en notacion: Notacion) -> String {
            if case .falta(let problema) = self { return problema.descripcion(en: notacion) }
            return traduccion(notacion)?.en(notacion) ?? ""
        }

        /// Los textos de los avisos fijos; las faltas las describe el motor.
        private func traduccion(_ notacion: Notacion) -> Traduccion? {
            let nombre = { (nota: Nota, octava: Int) in Altura(nota, octava: octava).nombre(en: notacion) }
            switch self {
            case .sinArmonizacion:
                return TextosDeApps.traduccion(\.sinArmonizacion)
            case .faltanOctavas:
                let ejemplo = [nombre(.mi, 4), nombre(.re, 4), nombre(.do, 4)].joined(separator: " ")
                return TextosDeApps.traduccion { $0.faltanOctavas(ejemplo) }
            case .sinCoralParaLaMelodia:
                let (grave, agudo) = (nombre(.do, 4), nombre(.sol, 5))
                return TextosDeApps.traduccion { $0.sinCoralParaLaMelodia(grave, agudo) }
            case .sinRealizacion:
                return TextosDeApps.traduccion(\.sinRealizacion)
            case .falta:
                return nil
            case .sinFaltasDeConduccion:
                return TextosDeApps.traduccion(\.sinFaltasDeConduccion)
            }
        }
    }
}

/// La parte de la vista de corales que no es dibujo, y la salida de `armonia armonizar`, `realizar` y
/// `revisar`. No usa SwiftUI, así que se prueba en Linux.
public enum PresentacionDeCoral {
    public enum Tarea: String, CaseIterable, Identifiable, Hashable, Sendable {
        case armonizar = "Armonizar"
        case realizar = "Realizar"
        case revisar = "Revisar"
        public var id: Self { self }

        /// Qué se escribe en el campo de texto.
        public var indicacion: String {
            switch self {
            case .armonizar: return "Melodía (Mi4 Fa4 Re4 Do4, sin octavas o con ritmo: Mi4:4 Re4:8)"
            case .realizar: return "Acordes (Do Fa Sol7 Do)"
            case .revisar: return "Voces de grave a agudo (Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4)"
            }
        }

        /// Un texto de ejemplo para empezar.
        public var ejemplo: String {
            switch self {
            case .armonizar: return "Mi4 Fa4 Re4 Do4"
            case .realizar: return "Do Fa Sol7 Do"
            case .revisar: return "Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4, La2 Do4 Mi4 Do5"
            }
        }

        /// Si admite una tonalidad («en Sol mayor»); si no se da, se estima.
        public var usaTonalidad: Bool { self != .revisar }
    }

    /// Hace la tarea con el texto y, si no está vacía, la tonalidad («La menor»).
    public static func presentar(
        _ tarea: Tarea, _ texto: String, tonalidad: String = "", propuestas: Int = 3,
        notacion: Notacion
    ) throws -> CoralPresentado {
        let dada = tonalidad.trimmingCharacters(in: .whitespaces)
        let leida: Tonalidad? = try dada.isEmpty ? nil : Tonalidad(leyendo: dada)
        switch tarea {
        case .armonizar: return try armonizar(texto, en: leida, propuestas: propuestas, notacion: notacion)
        case .realizar: return try realizar(texto, en: leida, notacion: notacion)
        case .revisar: return try revisar(texto, notacion: notacion)
        }
    }

    /// Las mejores armonizaciones de una melodía y, si las notas llevan octava, el coral a cuatro voces
    /// con la melodía en el soprano.
    public static func armonizar(
        _ texto: String, en tonalidad: Tonalidad?, propuestas: Int = 3,
        notacion: Notacion
    ) throws -> CoralPresentado {
        let partes = texto.split(whereSeparator: \.isWhitespace).map(String.init)
        guard !partes.isEmpty else { throw ErrorDeLectura(texto: texto, posicion: nil, motivo: .textoVacio) }
        // Con ritmo («Mi4:4 Re4:8»), la voz: se armonizan sus notas (la más aguda si una es un acorde) y el
        // coral suena con su ritmo.
        let voz = try partes.contains { $0.contains(":") } ? Voz(leyendo: partes.joined(separator: " ")) : nil
        let alturas =
            voz.map { voz in
                Escucha.notas(de: voz, tempo: Escucha.tempo).compactMap { $0.alturas.max { $0.midi < $1.midi } }
            } ?? partes.compactMap { Altura(texto: $0) }
        guard !alturas.isEmpty || voz == nil else {
            throw ErrorDeLectura(texto: texto, posicion: nil, motivo: .textoVacio)
        }
        let conOctavas = voz != nil || alturas.count == partes.count
        let notas = try conOctavas ? alturas.map(\.nota) : partes.map { try Nota(leyendo: $0) }
        guard let tonalidad = tonalidad ?? Tonalidad.candidatos(notas: notas).first?.valor else {
            throw ErrorDeLectura(texto: texto, posicion: nil, motivo: .textoVacio)
        }
        let candidatos = tonalidad.armonizar(melodia: notas, propuestas: propuestas)
        var avisos: [CoralPresentado.Aviso] = []
        if candidatos.isEmpty { avisos.append(.sinArmonizacion) }

        var filas: [CoralPresentado.Fila] = []
        var ficheros: [FicheroParaExportar] = []
        var sonido = Escucha.silencio
        if !conOctavas {
            avisos.append(.faltanOctavas)
        } else if let armonizada = tonalidad.armonizarACuatroVoces(alturas) {
            filas = self.filas(armonizada.armonizacion.analisis, armonizada.coral, notacion)
            ficheros = self.ficheros(armonizada.coral, tonalidad, notacion, nombre: "Armonización")
            sonido =
                (voz.map { Escucha.coral(armonizada.coral.acordes, conElRitmoDe: $0) }
                ?? Escucha.coral(armonizada.coral.acordes))
                .conTonica(tonalidad.tonica)
        } else {
            avisos.append(.sinCoralParaLaMelodia)
        }
        return CoralPresentado(
            titulo: tonalidad.nombre(en: notacion),
            propuestas: candidatos.map { $0.valor.texto(en: notacion) },
            filas: filas, avisos: avisos, ficheros: ficheros, sonido: sonido)
    }

    /// Los acordes escritos a cuatro voces, sin faltas de conducción.
    public static func realizar(_ texto: String, en tonalidad: Tonalidad?, notacion: Notacion) throws -> CoralPresentado
    {
        let analisis = try AnalisisArmonico.analizar(leyendo: texto, en: tonalidad)
        let titulo = analisis.tonalidad.nombre(en: notacion)
        guard let voces = Coral.realizar(analisis.acordes.map(\.acorde), en: analisis.tonalidad) else {
            return CoralPresentado(
                titulo: titulo, propuestas: [], filas: [],
                avisos: [.sinRealizacion],
                ficheros: [])
        }
        return CoralPresentado(
            titulo: titulo, propuestas: [], filas: filas(analisis, voces, notacion), avisos: [],
            ficheros: ficheros(voces, analisis.tonalidad, notacion, nombre: "Coral"),
            sonido: Escucha.coral(voces.acordes).conTonica(analisis.tonalidad.tonica))
    }

    /// Las faltas de conducción (quintas y octavas paralelas, cruzamientos…) de unas voces escritas a mano.
    public static func revisar(_ texto: String, notacion: Notacion) throws -> CoralPresentado {
        let coral = try Coral(leyendo: texto)
        let filas = coral.acordes.map { alturas in
            CoralPresentado.Fila(
                cifrado: Acorde.identificar(alturas).first?.cifrado(en: notacion) ?? "–", grado: "",
                voces: voces(alturas, notacion))
        }
        let faltas = coral.faltas.map(CoralPresentado.Aviso.falta)
        return CoralPresentado(
            titulo: "", propuestas: [], filas: filas,
            avisos: faltas.isEmpty ? [.sinFaltasDeConduccion] : faltas,
            ficheros: ficheros(coral, nil, notacion, nombre: "Coral"), sonido: .coral(coral.acordes))
    }

    static func filas(
        _ analisis: AnalisisArmonico, _ coral: Coral,
        _ notacion: Notacion
    ) -> [CoralPresentado.Fila] {
        zip(analisis.acordes, coral.acordes).map { analizado, alturas in
            CoralPresentado.Fila(
                cifrado: analizado.acorde.cifrado(en: notacion), grado: analizado.cifrado,
                voces: voces(alturas, notacion))
        }
    }

    static func voces(_ alturas: [Altura], _ notacion: Notacion) -> String {
        alturas.map { $0.nombre(en: notacion) }.joined(separator: " ")
    }

    /// La partitura en MusicXML y en MEI, con los cifrados encima y el análisis debajo, y el MIDI.
    static func ficheros(
        _ coral: Coral, _ tonalidad: Tonalidad?, _ notacion: Notacion,
        nombre: String
    ) -> [FicheroParaExportar] {
        [
            .musicXML(
                coral.musicXML(
                    tonalidad: tonalidad, titulo: nombre, cifrados: true, analisis: true,
                    notacion: notacion), nombre: nombre),
            .mei(
                coral.mei(
                    tonalidad: tonalidad, titulo: nombre, cifrados: true, analisis: true,
                    notacion: notacion), nombre: nombre),
            .midi(coral.midi(tonalidad: tonalidad, titulo: nombre, notacion: notacion), nombre: nombre),
        ]
    }
}

// MARK: - Idiomas
//
// Los textos de las tareas del coral, que están con los demás textos de las apps en `TextosDeApps`
// (un fichero por idioma en `Textos/`).

extension PresentacionDeCoral.Tarea {
    /// El nombre de la tarea en el selector: «Armonizar», «Harmonize»…
    public func titulo(en notacion: Notacion) -> String {
        let traduccion: Traduccion
        switch self {
        case .armonizar:
            traduccion = TextosDeApps.traduccion(\.armonizar)
        case .realizar:
            traduccion = TextosDeApps.traduccion(\.realizar)
        case .revisar:
            traduccion = TextosDeApps.traduccion(\.revisar)
        }
        return traduccion.en(notacion)
    }

    /// Qué se escribe en el campo de texto, con los ejemplos en la notación.
    public func indicacion(en notacion: Notacion) -> String {
        let traduccion: Traduccion
        switch self {
        case .armonizar:
            let e = notacion.alturasDeEjemplo("Mi4 Fa4 Re4 Do4")
            // Con ritmo: «Mi4:4 Re4:8», con las notas en la notación.
            let r = [("Mi4", 4), ("Re4", 8)].map { notacion.alturasDeEjemplo($0.0) + ":\($0.1)" }
                .joined(separator: " ")
            traduccion = TextosDeApps.traduccion { $0.indicacionArmonizar(e, r) }
        case .realizar:
            let e = ["Do", "Fa", "Sol7", "Do"].map { notacion.cifradoDeEjemplo($0) }.joined(separator: " ")
            traduccion = TextosDeApps.traduccion { "\($0.acordes) (\(e))" }
        case .revisar:
            let e = notacion.alturasDeEjemplo("Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4")
            traduccion = TextosDeApps.traduccion { $0.indicacionRevisar(e) }
        }
        return traduccion.en(notacion)
    }
}
