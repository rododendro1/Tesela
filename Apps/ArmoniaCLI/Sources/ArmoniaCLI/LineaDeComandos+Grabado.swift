import Armonia
import Foundation

// `armonia grabar`: la partitura o el dibujo en PDF, SVG o PNG, con un programa externo. Tesela escribe lo que ya
// sabe exportar (el `.ly` de `armonia lilypond`, el SVG de `armonia pentagrama`…) en una carpeta temporal, el motor
// lo convierte allí y la orden devuelve el fichero que deja, como `armonia midi` devuelve el MIDI.
//
//     armonia grabar coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 > coral.pdf
//     armonia grabar pentagrama escala Re dórico --formato png > dorico.png

extension LineaDeComandos {
    /// Quien encuentra y ejecuta los programas externos; las pruebas ponen otro con `$ejecutor.withValue(_:)`.
    @TaskLocal public static var ejecutor: any EjecutorDeProcesos = EjecutorDelSistema()

    /// Lo que sale de `armonia grabar`.
    enum FormatoDeGrabado: String, CaseIterable {
        case pdf, svg, png
    }

    /// Quien graba: LilyPond, a partir del `.ly`, o el dibujo SVG de Tesela, que `rsvg-convert` pasa a PDF o PNG.
    enum MotorDeGrabado: CaseIterable {
        case lilypond, propio

        /// `--motor lilypond`, `--motor propio` (u `own`, o `rsvg`).
        init?(nombre: String) {
            switch nombre.lowercased() {
            case "lilypond": self = .lilypond
            case "propio", "own", "rsvg", "rsvg-convert": self = .propio
            default: return nil
            }
        }

        /// El programa que se ejecuta para un formato; `nil` si no hace falta ninguno (el SVG propio).
        func programa(para formato: FormatoDeGrabado) -> String? {
            switch self {
            case .lilypond: return "lilypond"
            case .propio: return formato == .svg ? nil : "rsvg-convert"
            }
        }

        /// La extensión del fichero que escribe Tesela para el motor.
        var entrada: String {
            switch self {
            case .lilypond: return "ly"
            case .propio: return "svg"
            }
        }

        /// Los argumentos con que se llama al programa para convertir `grabado.<entrada>`. LilyPond pone la
        /// extensión a lo que da `-o`; rsvg-convert escribe en el fichero que se le da.
        func argumentos(para formato: FormatoDeGrabado) -> [String] {
            let fuente = "grabado." + entrada
            switch self {
            case .lilypond:
                let salida: [String]
                switch formato {
                case .pdf: salida = ["--pdf"]
                case .svg: salida = ["-dbackend=svg"]
                case .png: salida = ["--png", "-dresolution=150"]
                }
                return ["--loglevel=ERROR", "-dno-point-and-click"] + salida + ["-o", "grabado", fuente]
            case .propio:
                let zoom = formato == .png ? ["--zoom", "2"] : []
                return ["--format", formato.rawValue] + zoom + ["--output", "grabado." + formato.rawValue, fuente]
            }
        }

        /// Los nombres que puede tener lo que deja el programa: `grabado.pdf` o, si LilyPond hizo varias páginas en
        /// SVG o PNG, la primera (`grabado-page1.png`, o `grabado-1.svg` según la versión).
        func salidas(para formato: FormatoDeGrabado) -> [String] {
            let ext = formato.rawValue
            return ["grabado.\(ext)", "grabado-page1.\(ext)", "grabado-1.\(ext)"]
        }
    }

    /// Los tipos de partitura de `armonia musicxml`, `lilypond`…: lo que se graba con LilyPond si no se dice otro
    /// motor. Lo demás es una orden de dibujo (`pentagrama`, `tonnetz`…), que se graba con el dibujo propio.
    static let tiposDePartitura: Set = [
        "melodia", "melodía", "melody", "coral", "chorale", "acordes", "progresion", "progresión", "chords",
        "arpegios", "arpegio", "arpeggios", "arpeggio", "escala", "scale",
    ]

    /// `grabar <partitura o dibujo> [--motor lilypond|propio] [--formato pdf|svg|png]`.
    static func grabar(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var entrada = Argumentos(argumentos)
        var motor: MotorDeGrabado?
        switch entrada.quitarOpcion("--motor", "--engine") {
        case .ausente: break
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let elegido = MotorDeGrabado(nombre: texto) else { return uso(.motorDesconocido(texto), notacion) }
            motor = elegido
        }
        var formato = FormatoDeGrabado.pdf
        switch entrada.quitarOpcion("--formato", "--format") {
        case .ausente: break
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let elegido = FormatoDeGrabado(rawValue: texto.lowercased()) else {
                return uso(.formatoDeGrabadoDesconocido(texto), notacion)
            }
            formato = elegido
        }
        let resto = entrada.restantes
        guard let primera = resto.first?.lowercased() else { return uso(.faltaLoQueSeGraba, notacion) }
        let elegido = motor ?? (tiposDePartitura.contains(primera) ? .lilypond : .propio)

        // Lo que Tesela escribe para el motor: el `.ly` de la partitura o el SVG del dibujo.
        let fuente: ResultadoDeOrden
        switch elegido {
        case .lilypond:
            fuente = try partitura(resto, notacion, formato: .lilyPond)
        case .propio:
            guard primera != "grabar" && primera != "engrave",
                let orden = ordenes.first(where: { $0.nombres.contains(primera) })
            else { return uso(.nadaQueGrabar(primera), notacion) }
            fuente = try orden.ejecutar(Array(resto.dropFirst()), notacion)
            guard fuente.codigo == 0 else { return fuente }
            // Solo un dibujo: el MusicXML de `armonia musicxml` también es XML, pero no es SVG.
            guard fuente.datos == nil, fuente.salida.hasPrefix("<svg") else {
                return uso(.nadaQueGrabar(primera), notacion)
            }
        }
        guard fuente.codigo == 0 else { return fuente }
        return try grabado(fuente.salida, con: elegido, formato: formato, notacion)
    }

    /// El texto de la fuente convertido por el motor en una carpeta temporal, que se borra al terminar.
    private static func grabado(
        _ texto: String, con motor: MotorDeGrabado, formato: FormatoDeGrabado, _ notacion: Notacion
    ) throws -> ResultadoDeOrden {
        guard let programa = motor.programa(para: formato) else {
            return bien(texto.trimmingCharacters(in: .newlines))
        }
        let ejecutor = Self.ejecutor
        guard let ruta = ejecutor.buscar(programa) else {
            let variable = EjecutorDelSistema.variable(de: programa)
            return fallo(TextosDeCLI.en(notacion) { $0.motorNoEncontrado(programa, variable) })
        }
        let gestor = FileManager.default
        let carpeta = gestor.temporaryDirectory.appendingPathComponent("armonia-grabar-\(UUID().uuidString)")
        try gestor.createDirectory(at: carpeta, withIntermediateDirectories: true)
        defer { try? gestor.removeItem(at: carpeta) }
        try Data(texto.utf8).write(to: carpeta.appendingPathComponent("grabado." + motor.entrada))
        let resultado = try ejecutor.ejecutar(ruta, motor.argumentos(para: formato), en: carpeta)
        if resultado.agotado {
            return fallo(TextosDeCLI.en(notacion) { $0.motorSinTerminar(programa) })
        }
        let escrito = motor.salidas(para: formato).lazy
            .compactMap { gestor.contents(atPath: carpeta.appendingPathComponent($0).path) }.first
        guard resultado.codigo == 0, let datos = escrito else {
            // Las últimas líneas de lo que dijo el programa, que suelen ser las que explican el error.
            let ultimas = resultado.error.split(separator: "\n", omittingEmptySubsequences: true).suffix(10)
            let mensaje = TextosDeCLI.en(notacion) { $0.motorFallo(programa, Int(resultado.codigo)) }
            return fallo(([mensaje] + ultimas.map { "  " + $0 }).joined(separator: "\n"))
        }
        if formato == .svg { return bien(String(decoding: datos, as: UTF8.self).trimmingCharacters(in: .newlines)) }
        return binario(datos)
    }

    /// Un error al ejecutar el motor (código 1): no es la orden la que está mal escrita, así que no remite a la ayuda.
    private static func fallo(_ texto: String) -> ResultadoDeOrden {
        ResultadoDeOrden(salida: "", error: "armonia: " + texto + "\n", codigo: 1)
    }
}
