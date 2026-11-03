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

    /// Un programa que se ejecuta para grabar: lee `grabado.<entrada>` en la carpeta temporal y deja uno de los
    /// ficheros de `salidas` o, si no tiene ninguno (`guido2svg`), lo escribe en la salida estándar.
    struct PasoDeGrabado: Equatable {
        /// Los nombres que puede tener el programa; el primero da la variable de entorno (`ARMONIA_MSCORE`).
        let programas: [String]
        let entrada: String
        let argumentos: [String]
        let salidas: [String]
    }

    /// Quien graba: LilyPond, MuseScore, Verovio o Guido, a partir de la partitura que Tesela ya sabe exportar, o el
    /// dibujo SVG de Tesela (`propio`), que `rsvg-convert` pasa a PDF o PNG. Verovio y Guido solo dan SVG, así que
    /// para PDF o PNG su SVG pasa también por `rsvg-convert`.
    enum MotorDeGrabado: String, CaseIterable {
        case lilypond, musescore, verovio, guido, propio

        /// `--motor lilypond`, `musescore` (o `mscore`), `verovio`, `guido` (o `guido2svg`) y `propio` (u `own`, o
        /// `rsvg`).
        init?(nombre: String) {
            switch nombre.lowercased() {
            case "lilypond": self = .lilypond
            case "musescore", "mscore": self = .musescore
            case "verovio": self = .verovio
            case "guido", "guido2svg": self = .guido
            case "propio", "own", "rsvg", "rsvg-convert": self = .propio
            default: return nil
            }
        }

        /// Los nombres que puede tener su programa: MuseScore se instala con varios según la versión y el sistema.
        var programas: [String] {
            switch self {
            case .lilypond: return ["lilypond"]
            case .musescore: return ["mscore", "musescore", "mscore4portable", "musescore4", "mscore3"]
            case .verovio: return ["verovio"]
            case .guido: return ["guido2svg"]
            case .propio: return ["rsvg-convert"]
            }
        }

        /// La partitura que lee; `nil` el propio, que graba un dibujo.
        var partitura: Formato? {
            switch self {
            case .lilypond: return .lilyPond
            case .musescore: return .musicXML
            case .verovio: return .mei
            case .guido: return .guido
            case .propio: return nil
            }
        }

        /// Si `programa --version` dice su versión: `guido2svg` no lo entiende.
        var tieneVersion: Bool { self != .guido }

        /// Los programas que se ejecutan, uno tras otro, para grabar en un formato; ninguno para el SVG propio.
        func pasos(para formato: FormatoDeGrabado) -> [PasoDeGrabado] {
            switch self {
            case .lilypond, .musescore: return [paso(para: formato)]
            case .verovio, .guido: return formato == .svg ? [paso(para: .svg)] : [paso(para: .svg), Self.rsvg(formato)]
            case .propio: return formato == .svg ? [] : [Self.rsvg(formato)]
            }
        }

        /// El paso del propio motor. LilyPond pone la extensión a lo que da `-o`; MuseScore y Verovio escriben en el
        /// fichero que se les da, y Guido en la salida estándar. Si LilyPond o MuseScore hacen varias páginas en SVG
        /// o PNG, se queda la primera (`grabado-page1.png` o `grabado-1.svg`, según el programa y la versión).
        private func paso(para formato: FormatoDeGrabado) -> PasoDeGrabado {
            let entrada: String
            let argumentos: [String]
            let ext = formato.rawValue
            var salidas = ["grabado.\(ext)", "grabado-page1.\(ext)", "grabado-1.\(ext)"]
            switch self {
            case .lilypond:
                entrada = "ly"
                let salida: [String]
                switch formato {
                case .pdf: salida = ["--pdf"]
                case .svg: salida = ["-dbackend=svg"]
                case .png: salida = ["--png", "-dresolution=150"]
                }
                argumentos = ["--loglevel=ERROR", "-dno-point-and-click"] + salida + ["-o", "grabado", "grabado.ly"]
            case .musescore:
                entrada = "musicxml"
                let resolucion = formato == .png ? ["-r", "150"] : []
                argumentos = resolucion + ["-o", "grabado.\(ext)", "grabado.musicxml"]
            case .verovio:
                entrada = "mei"
                argumentos = ["-o", "grabado.svg", "grabado.mei"]
                salidas = ["grabado.svg", "grabado_001.svg"]
            case .guido:
                entrada = "gmn"
                argumentos = ["grabado.gmn"]
                salidas = []
            case .propio:
                return Self.rsvg(formato)
            }
            return PasoDeGrabado(programas: programas, entrada: entrada, argumentos: argumentos, salidas: salidas)
        }

        /// `rsvg-convert`, que pasa `grabado.svg` a PDF o PNG (al doble de tamaño, para que no se vea borroso).
        private static func rsvg(_ formato: FormatoDeGrabado) -> PasoDeGrabado {
            let zoom = formato == .png ? ["--zoom", "2"] : []
            let salida = "grabado." + formato.rawValue
            return PasoDeGrabado(
                programas: ["rsvg-convert"], entrada: "svg",
                argumentos: ["--format", formato.rawValue] + zoom + ["--output", salida, "grabado.svg"],
                salidas: [salida])
        }
    }

    /// Los tipos de partitura de `armonia musicxml`, `lilypond`…: lo que se graba con LilyPond si no se dice otro
    /// motor. Lo demás es una orden de dibujo (`pentagrama`, `tonnetz`…), que se graba con el dibujo propio.
    static let tiposDePartitura: Set = [
        "melodia", "melodía", "melody", "coral", "chorale", "acordes", "progresion", "progresión", "chords",
        "arpegios", "arpegio", "arpeggios", "arpeggio", "escala", "scale",
    ]

    /// `grabar <partitura o dibujo> [--motor lilypond|musescore|verovio|guido|propio] [--formato pdf|svg|png]`.
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

        // Lo que Tesela escribe para el motor: la partitura en su formato, o el SVG del dibujo.
        let fuente: ResultadoDeOrden
        if let formatoDePartitura = elegido.partitura {
            fuente = try partitura(resto, notacion, formato: formatoDePartitura)
        } else {
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

    /// El texto de la fuente convertido por los programas del motor, uno tras otro, en una carpeta temporal que se
    /// borra al terminar. Lo que deja cada uno es la entrada del siguiente.
    private static func grabado(
        _ texto: String, con motor: MotorDeGrabado, formato: FormatoDeGrabado, _ notacion: Notacion
    ) throws -> ResultadoDeOrden {
        let pasos = motor.pasos(para: formato)
        guard !pasos.isEmpty else { return bien(texto.trimmingCharacters(in: .newlines)) }
        let ejecutor = Self.ejecutor
        // Antes de ejecutar nada, que estén todos los programas.
        var rutas: [String] = []
        for paso in pasos {
            guard let ruta = buscar(paso.programas, con: ejecutor) else {
                let programa = paso.programas[0]
                let variable = EjecutorDelSistema.variable(de: programa)
                return fallo(TextosDeCLI.en(notacion) { $0.motorNoEncontrado(programa, variable) })
            }
            rutas.append(ruta)
        }
        let gestor = FileManager.default
        let carpeta = gestor.temporaryDirectory.appendingPathComponent("armonia-grabar-\(UUID().uuidString)")
        try gestor.createDirectory(at: carpeta, withIntermediateDirectories: true)
        defer { try? gestor.removeItem(at: carpeta) }
        var datos = Data(texto.utf8)
        for (paso, ruta) in zip(pasos, rutas) {
            try datos.write(to: carpeta.appendingPathComponent("grabado." + paso.entrada))
            let programa = URL(fileURLWithPath: ruta).lastPathComponent
            let resultado = try ejecutor.ejecutar(ruta, paso.argumentos, en: carpeta, limite: 120)
            if resultado.agotado {
                return fallo(TextosDeCLI.en(notacion) { $0.motorSinTerminar(programa) })
            }
            let escrito: Data?
            if paso.salidas.isEmpty {
                escrito = resultado.salida.isEmpty ? nil : resultado.salida
            } else {
                let ficheros = paso.salidas.map { carpeta.appendingPathComponent($0).path }
                escrito = ficheros.lazy.compactMap(gestor.contents(atPath:)).first
            }
            guard resultado.codigo == 0, let convertido = escrito else {
                // Las últimas líneas de lo que dijo el programa, que suelen ser las que explican el error.
                let dicho =
                    resultado.error.isEmpty ? String(decoding: resultado.salida, as: UTF8.self) : resultado.error
                let ultimas = dicho.split(separator: "\n", omittingEmptySubsequences: true).suffix(10)
                let mensaje = TextosDeCLI.en(notacion) { $0.motorFallo(programa, Int(resultado.codigo)) }
                return fallo(([mensaje] + ultimas.map { "  " + $0 }).joined(separator: "\n"))
            }
            datos = convertido
        }
        if formato == .svg { return bien(String(decoding: datos, as: UTF8.self).trimmingCharacters(in: .newlines)) }
        return binario(datos)
    }

    /// `armonia motores`: cada motor de `grabar`, con la ruta de su programa y su versión, o cómo darle la ruta si
    /// no se encuentra.
    static func motores(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        if let sobrante = argumentos.first { return uso(.opcionDesconocida(sobrante), notacion) }
        let ejecutor = Self.ejecutor
        var filas: [(nombre: String, dicho: String)] = []
        for motor in MotorDeGrabado.allCases {
            let nombre = motor == .propio ? TextosDeCLI.en(notacion, \.motorPropio) : motor.rawValue
            guard let ruta = buscar(motor.programas, con: ejecutor) else {
                let variable = EjecutorDelSistema.variable(de: motor.programas[0])
                filas.append((nombre: nombre, dicho: TextosDeCLI.en(notacion) { $0.motorNoInstalado(variable) }))
                continue
            }
            let version = try motor.tieneVersion ? versionDelPrograma(ruta, ejecutor) : nil
            filas.append((nombre: nombre, dicho: ruta + (version.map { " (\($0))" } ?? "")))
        }
        let ancho = (filas.map { $0.nombre.count }.max() ?? 0) + 2
        return bien(
            filas.map { $0.nombre.padding(toLength: ancho, withPad: " ", startingAt: 0) + $0.dicho }
                .joined(separator: "\n"))
    }

    /// La ruta del primero de los programas que esté instalado.
    private static func buscar(_ programas: [String], con ejecutor: any EjecutorDeProcesos) -> String? {
        programas.lazy.compactMap { ejecutor.buscar($0) }.first
    }

    /// La primera línea de lo que dice `programa --version`, si termina bien y pronto.
    private static func versionDelPrograma(_ ruta: String, _ ejecutor: any EjecutorDeProcesos) throws -> String? {
        let gestor = FileManager.default
        let carpeta = gestor.temporaryDirectory.appendingPathComponent("armonia-motores-\(UUID().uuidString)")
        try gestor.createDirectory(at: carpeta, withIntermediateDirectories: true)
        defer { try? gestor.removeItem(at: carpeta) }
        guard let resultado = try? ejecutor.ejecutar(ruta, ["--version"], en: carpeta, limite: 10),
            resultado.codigo == 0, !resultado.agotado
        else { return nil }
        let dicho = String(decoding: resultado.salida, as: UTF8.self) + "\n" + resultado.error
        return dicho.split(separator: "\n").lazy.map { $0.trimmingCharacters(in: .whitespaces) }.first { !$0.isEmpty }
    }

    /// Un error al ejecutar el motor (código 1): no es la orden la que está mal escrita, así que no remite a la ayuda.
    private static func fallo(_ texto: String) -> ResultadoDeOrden {
        ResultadoDeOrden(salida: "", error: "armonia: " + texto + "\n", codigo: 1)
    }
}
