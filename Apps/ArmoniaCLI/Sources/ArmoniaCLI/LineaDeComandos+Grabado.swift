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
    /// para PDF o PNG su SVG pasa también por `rsvg-convert`. Lo que distingue a cada uno está en su `ficha`: un
    /// motor nuevo es un caso más y su ficha.
    enum MotorDeGrabado: String, CaseIterable {
        case lilypond, musescore, verovio, guido, propio

        /// Todo lo de un motor: cómo se pide, su programa, lo que lee y cómo se le llama.
        struct Ficha {
            /// Cómo se escribe en `--motor`, en minúsculas.
            let nombres: [String]
            /// Los nombres que puede tener su programa; el primero da la variable de entorno (`ARMONIA_MSCORE`).
            let programas: [String]
            /// La partitura que lee; `nil` el propio, que graba un dibujo.
            let partitura: FormatoDePartitura?
            /// Si `programa --version` dice su versión.
            let tieneVersion: Bool
            /// Si solo da SVG: para PDF o PNG, su SVG pasa por `rsvg-convert`.
            let soloSVG: Bool
            /// Sus argumentos y los ficheros que puede dejar, para grabar en un formato (en SVG, si `soloSVG`);
            /// ningún fichero si escribe en la salida estándar. Lee `grabado.<extensión de su partitura>`.
            let llamada: (_ formato: FormatoDeGrabado) -> (argumentos: [String], salidas: [String])
        }

        /// Lo que dejan LilyPond y MuseScore: `grabado.pdf` o, si hacen varias páginas en SVG o PNG, la primera
        /// (`grabado-page1.png` o `grabado-1.svg`, según el programa y la versión).
        private static func paginas(_ formato: FormatoDeGrabado) -> [String] {
            let ext = formato.rawValue
            return ["grabado.\(ext)", "grabado-page1.\(ext)", "grabado-1.\(ext)"]
        }

        var ficha: Ficha {
            switch self {
            case .lilypond:
                // LilyPond pone la extensión a lo que da `-o`.
                return Ficha(
                    nombres: ["lilypond"], programas: ["lilypond"], partitura: .lilyPond, tieneVersion: true,
                    soloSVG: false
                ) { formato in
                    let salida: [String]
                    switch formato {
                    case .pdf: salida = ["--pdf"]
                    case .svg: salida = ["-dbackend=svg"]
                    case .png: salida = ["--png", "-dresolution=150"]
                    }
                    let opciones = ["--loglevel=ERROR", "-dno-point-and-click"] + salida
                    return (opciones + ["-o", "grabado", "grabado.ly"], Self.paginas(formato))
                }
            case .musescore:
                // MuseScore se instala con varios nombres según la versión y el sistema, y escribe en el fichero que
                // se le da.
                return Ficha(
                    nombres: ["musescore", "mscore"],
                    programas: ["mscore", "musescore", "mscore4portable", "musescore4", "mscore3"],
                    partitura: .musicXML, tieneVersion: true, soloSVG: false
                ) { formato in
                    let resolucion = formato == .png ? ["-r", "150"] : []
                    let salida = "grabado." + formato.rawValue
                    return (resolucion + ["-o", salida, "grabado.musicxml"], Self.paginas(formato))
                }
            case .verovio:
                return Ficha(
                    nombres: ["verovio"], programas: ["verovio"], partitura: .mei, tieneVersion: true, soloSVG: true
                ) { _ in (["-o", "grabado.svg", "grabado.mei"], ["grabado.svg", "grabado_001.svg"]) }
            case .guido:
                // `guido2svg` escribe en la salida estándar y no entiende `--version`.
                return Ficha(
                    nombres: ["guido", "guido2svg"], programas: ["guido2svg"], partitura: .guido, tieneVersion: false,
                    soloSVG: true
                ) { _ in (["grabado.gmn"], []) }
            case .propio:
                return Ficha(
                    nombres: ["propio", "own", "rsvg", "rsvg-convert"], programas: ["rsvg-convert"], partitura: nil,
                    tieneVersion: true, soloSVG: false
                ) { _ in ([], []) }
            }
        }

        /// `--motor lilypond`, `musescore` (o `mscore`), `verovio`, `guido` (o `guido2svg`) y `propio` (u `own`, o
        /// `rsvg`).
        init?(nombre: String) {
            let buscado = nombre.lowercased()
            guard let motor = Self.allCases.first(where: { $0.ficha.nombres.contains(buscado) }) else { return nil }
            self = motor
        }

        /// Los nombres que puede tener su programa.
        var programas: [String] { ficha.programas }

        /// La partitura que lee; `nil` el propio, que graba un dibujo.
        var partitura: FormatoDePartitura? { ficha.partitura }

        /// Si `programa --version` dice su versión.
        var tieneVersion: Bool { ficha.tieneVersion }

        /// Los programas que se ejecutan, uno tras otro, para grabar en un formato; ninguno para el SVG propio.
        func pasos(para formato: FormatoDeGrabado) -> [PasoDeGrabado] {
            guard let partitura = ficha.partitura else { return formato == .svg ? [] : [Self.rsvg(formato)] }
            let directo = !ficha.soloSVG || formato == .svg
            let (argumentos, salidas) = ficha.llamada(directo ? formato : .svg)
            let propio = PasoDeGrabado(
                programas: programas, entrada: partitura.extensionDeFichero, argumentos: argumentos, salidas: salidas)
            return directo ? [propio] : [propio, Self.rsvg(formato)]
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
        if let texto = try entrada.valor("--motor", "--engine") {
            guard let elegido = MotorDeGrabado(nombre: texto) else { return uso(.motorDesconocido(texto), notacion) }
            motor = elegido
        }
        var formato = FormatoDeGrabado.pdf
        if let texto = try entrada.valor("--formato", "--format") {
            guard let elegido = FormatoDeGrabado(rawValue: texto.lowercased()) else {
                return uso(.formatoDeGrabadoDesconocido(texto), notacion)
            }
            formato = elegido
        }
        let resto = entrada.restantes
        guard let primera = resto.first?.lowercased() else { return uso(.faltaLoQueSeGraba, notacion) }
        // `grabar midi …`: `midi` (como musicxml, mei…) ya escribe la partitura; se graba lo que va detrás de ella.
        if ordenesDePartituras.contains(where: { $0.nombres.contains(primera) }) {
            return uso(.grabarUnaPartitura(primera), notacion)
        }
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
