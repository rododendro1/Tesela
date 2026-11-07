import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

// Las pruebas de `grabar` y `motores`: con un ejecutor que no ejecuta nada y apunta lo que se le pide, y con el de
// verdad, que solo se prueba con `/bin/sh`, porque LilyPond, MuseScore y los demás no tienen por qué estar instalados.

/// Un ejecutor que hace como que el programa ha grabado: escribe «GRABADO» en el fichero que tocaba, o en la salida
/// estándar si no se le dice ninguno (`guido2svg`). A `--version` responde «Falso 1.0».
private final class EjecutorFalso: EjecutorDeProcesos, @unchecked Sendable {
    struct Llamada {
        let ruta: String
        let argumentos: [String]
        /// Lo que se escribió para el programa (el último argumento).
        let fuente: String
        let limite: TimeInterval
    }

    let instalados: Set<String>
    let codigo: Int32
    let agotado: Bool
    private let cerrojo = NSLock()
    private var apuntadas: [Llamada] = []

    init(
        instalados: Set<String> = ["lilypond", "mscore", "verovio", "guido2svg", "rsvg-convert"], codigo: Int32 = 0,
        agotado: Bool = false
    ) {
        self.instalados = instalados
        self.codigo = codigo
        self.agotado = agotado
    }

    var llamadas: [Llamada] {
        cerrojo.lock()
        defer { cerrojo.unlock() }
        return apuntadas
    }

    func buscar(_ programa: String) -> String? { instalados.contains(programa) ? "/falso/" + programa : nil }

    func ejecutar(
        _ ruta: String, _ argumentos: [String], en carpeta: URL, limite: TimeInterval
    ) throws -> ResultadoDeProceso {
        let version = argumentos == ["--version"]
        let fuente =
            version ? "" : try String(contentsOf: carpeta.appendingPathComponent(argumentos.last!), encoding: .utf8)
        cerrojo.lock()
        apuntadas.append(Llamada(ruta: ruta, argumentos: argumentos, fuente: fuente, limite: limite))
        cerrojo.unlock()
        guard codigo == 0, !agotado else {
            return ResultadoDeProceso(codigo: codigo, error: "aviso\nerror: algo falló\n", agotado: agotado)
        }
        if version { return ResultadoDeProceso(codigo: 0, salida: Data("\nFalso 1.0\nmás\n".utf8)) }
        // LilyPond pone la extensión a lo que va tras `-o`; MuseScore y Verovio escriben en el fichero de `-o`, y
        // rsvg-convert en el de `--output`.
        let nombre: String
        if let o = argumentos.firstIndex(of: "-o") {
            let ext = argumentos.contains("--png") ? "png" : argumentos.contains("-dbackend=svg") ? "svg" : "pdf"
            nombre = argumentos[o + 1].contains(".") ? argumentos[o + 1] : argumentos[o + 1] + "." + ext
        } else if let output = argumentos.firstIndex(of: "--output") {
            nombre = argumentos[output + 1]
        } else {
            return ResultadoDeProceso(codigo: 0, salida: Data("GRABADO".utf8))
        }
        try Data("GRABADO".utf8).write(to: carpeta.appendingPathComponent(nombre))
        return ResultadoDeProceso(codigo: 0)
    }
}

extension LineaDeComandosTests {
    /// Lo que da una orden con el ejecutor falso.
    private func grabado(_ orden: String, con ejecutor: EjecutorFalso) -> ResultadoDeOrden {
        LineaDeComandos.$ejecutor.withValue(ejecutor) {
            LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
        }
    }

    @Test func grabarUnaPartituraConLilyPond() throws {
        let falso = EjecutorFalso()
        let pdf = grabado("grabar coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados", con: falso)
        #expect(pdf.codigo == 0, Comment(rawValue: pdf.error))
        #expect(pdf.datos == Data("GRABADO".utf8))
        let llamada = try #require(falso.llamadas.first)
        #expect(llamada.ruta == "/falso/lilypond")
        #expect(llamada.argumentos.contains("--pdf"))
        #expect(llamada.argumentos.suffix(3) == ["-o", "grabado", "grabado.ly"])
        // El `.ly` es el de `armonia lilypond`, con las mismas opciones.
        let ly = salida("lilypond coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados")
        #expect(llamada.fuente == ly)
        // En SVG sale como texto; en inglés, con `engrave` y `--format`.
        let svg = grabado("engrave chorale C3 E4 G4 C5 --format svg --ingles", con: falso)
        #expect(svg.salida == "GRABADO\n")
        #expect(svg.datos == nil)
        #expect(falso.llamadas.last?.argumentos.contains("-dbackend=svg") == true)
        let png = grabado("grabar melodia Do4:4 Re4:4 --motor lilypond --formato png", con: falso)
        #expect(png.datos == Data("GRABADO".utf8))
        #expect(falso.llamadas.last?.argumentos.contains("--png") == true)
    }

    @Test func grabarUnDibujoConRsvg() throws {
        let falso = EjecutorFalso()
        // En SVG no hace falta ningún programa: es el dibujo tal cual.
        let svg = grabado("grabar pentagrama escala Re dórico --formato svg", con: falso)
        #expect(svg.salida == salida("pentagrama escala Re dórico"))
        #expect(falso.llamadas.isEmpty)
        let png = grabado("grabar pentagrama escala Re dórico --formato png", con: falso)
        #expect(png.codigo == 0, Comment(rawValue: png.error))
        #expect(png.datos == Data("GRABADO".utf8))
        let llamada = try #require(falso.llamadas.first)
        #expect(llamada.ruta == "/falso/rsvg-convert")
        #expect(llamada.argumentos == ["--format", "png", "--zoom", "2", "--output", "grabado.png", "grabado.svg"])
        #expect(llamada.fuente.hasPrefix("<svg"))
        // Con `--motor propio` dicho, y en PDF, que es lo que sale si no se dice otro formato.
        let pdf = grabado("grabar pentagrama acorde Sol7 --motor propio", con: falso)
        #expect(pdf.datos == Data("GRABADO".utf8))
    }

    @Test func grabarSinElPrograma() {
        let resultado = grabado("grabar acordes Do Sol7 Do", con: EjecutorFalso(instalados: []))
        #expect(resultado.codigo == 1)
        #expect(resultado.error.contains("lilypond"))
        #expect(resultado.error.contains("ARMONIA_LILYPOND"))
        let dibujo = grabado("engrave staff chord G7 --ingles", con: EjecutorFalso(instalados: ["lilypond"]))
        #expect(dibujo.codigo == 1)
        #expect(dibujo.error.contains("ARMONIA_RSVG_CONVERT"))
    }

    @Test func grabarCuandoElProgramaFalla() {
        let fallo = grabado("grabar acordes Do Sol7 Do", con: EjecutorFalso(codigo: 1))
        #expect(fallo.codigo == 1)
        #expect(fallo.error.hasPrefix("armonia: «lilypond» terminó con el código 1:\n"))
        #expect(fallo.error.contains("  error: algo falló\n"))
        let agotado = grabado("grabar acordes Do Sol7 Do --ingles", con: EjecutorFalso(codigo: 15, agotado: true))
        #expect(agotado.codigo == 1)
        #expect(agotado.error.contains("did not finish in time"))
    }

    @Test func grabarMalEscrito() {
        let falso = EjecutorFalso()
        for orden in [
            "grabar", "grabar coral Do --motor", "grabar coral Do --motor foo", "grabar coral Do --formato gif",
            "grabar acorde Do", "grabar nube Do", "grabar grabar coral Do",
            "grabar musicxml melodia Do4:4 --motor propio", "grabar pentagrama acorde Do --motor musescore",
            "motores --foo", "grabar coral Do --motor guido --formato gif",
            "grabar coral --foo 1", "grabar acorde Do --motor lilypond",
        ] {
            let resultado = grabado(orden, con: falso)
            #expect(resultado.codigo == 2, Comment(rawValue: orden))
            #expect(resultado.error.hasPrefix("armonia: "), Comment(rawValue: orden))
        }
        #expect(falso.llamadas.isEmpty)
    }

    @Test func grabarConMuseScore() throws {
        let falso = EjecutorFalso()
        let pdf = grabado("grabar coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados --motor musescore", con: falso)
        #expect(pdf.codigo == 0, Comment(rawValue: pdf.error))
        #expect(pdf.datos == Data("GRABADO".utf8))
        let llamada = try #require(falso.llamadas.first)
        #expect(llamada.ruta == "/falso/mscore")
        #expect(llamada.argumentos == ["-o", "grabado.pdf", "grabado.musicxml"])
        #expect(llamada.limite == 120)
        // El MusicXML es el de `armonia musicxml`.
        #expect(llamada.fuente == salida("musicxml coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados"))
        // Con otro nombre del programa (el de algunas distribuciones de Linux), y en PNG, con su resolución.
        let otro = EjecutorFalso(instalados: ["musescore"])
        let png = grabado("engrave melody C4:4 --engine mscore --format png --ingles", con: otro)
        #expect(png.datos == Data("GRABADO".utf8))
        #expect(otro.llamadas.first?.ruta == "/falso/musescore")
        #expect(otro.llamadas.first?.argumentos == ["-r", "150", "-o", "grabado.png", "grabado.musicxml"])
    }

    @Test func grabarConVerovioYGuido() throws {
        let falso = EjecutorFalso()
        // En SVG, solo Verovio, con el MEI de `armonia mei`.
        let svg = grabado("grabar acordes Do Lam Fa Sol7 --motor verovio --formato svg", con: falso)
        #expect(svg.salida == "GRABADO\n")
        let verovio = try #require(falso.llamadas.first)
        #expect(verovio.ruta == "/falso/verovio")
        #expect(verovio.argumentos == ["-o", "grabado.svg", "grabado.mei"])
        #expect(verovio.fuente == salida("mei acordes Do Lam Fa Sol7"))
        // En PDF, su SVG pasa después por rsvg-convert.
        let pdf = grabado("grabar acordes Do Lam Fa Sol7 --motor verovio", con: falso)
        #expect(pdf.datos == Data("GRABADO".utf8))
        #expect(falso.llamadas.map(\.ruta).suffix(2) == ["/falso/verovio", "/falso/rsvg-convert"])
        #expect(falso.llamadas.last?.argumentos == ["--format", "pdf", "--output", "grabado.pdf", "grabado.svg"])
        #expect(falso.llamadas.last?.fuente == "GRABADO")
        // Guido da el SVG en la salida estándar, a partir del `.gmn` de `armonia guido`.
        let png = grabado("grabar melodia Sol4:4 Do5:2 --motor guido --formato png", con: falso)
        #expect(png.codigo == 0, Comment(rawValue: png.error))
        #expect(png.datos == Data("GRABADO".utf8))
        let guido = try #require(falso.llamadas.dropLast().last)
        #expect(guido.ruta == "/falso/guido2svg")
        #expect(guido.argumentos == ["grabado.gmn"])
        #expect(guido.fuente == salida("guido melodia Sol4:4 Do5:2"))
        #expect(falso.llamadas.last?.fuente == "GRABADO")
        #expect(falso.llamadas.last?.argumentos.contains("--zoom") == true)
        // Sin rsvg-convert no se ejecuta nada: se dice antes.
        let sinRsvg = EjecutorFalso(instalados: ["guido2svg"])
        let fallo = grabado("grabar melodia Sol4:4 --motor guido", con: sinRsvg)
        #expect(fallo.codigo == 1)
        #expect(fallo.error.contains("ARMONIA_RSVG_CONVERT"))
        #expect(sinRsvg.llamadas.isEmpty)
        #expect(grabado("grabar melodia Sol4:4 --motor guido --formato svg", con: sinRsvg).salida == "GRABADO\n")
    }

    @Test func lasFichasDeLosMotores() {
        typealias Motor = LineaDeComandos.MotorDeGrabado
        for motor in Motor.allCases {
            // Cada motor se pide por su nombre y por los demás de su ficha, en mayúsculas o en minúsculas.
            #expect(motor.ficha.nombres.contains(motor.rawValue), "\(motor)")
            for nombre in motor.ficha.nombres { #expect(Motor(nombre: nombre.uppercased()) == motor, "\(nombre)") }
            // El SVG lo graba él solo (o nadie, el propio); a PDF o PNG llega con `rsvg-convert` si solo da SVG.
            #expect(motor.pasos(para: .svg).count == (motor == .propio ? 0 : 1), "\(motor)")
            #expect(motor.pasos(para: .pdf).count == (motor.ficha.soloSVG ? 2 : 1), "\(motor)")
            // Lee la partitura con la extensión de su formato.
            if let partitura = motor.partitura {
                #expect(motor.pasos(para: .png)[0].entrada == partitura.extensionDeFichero, "\(motor)")
            }
        }
        #expect(Motor(nombre: "sibelius") == nil)
        #expect(Motor.lilypond.pasos(para: .png)[0].argumentos.contains("-dresolution=150"))
        #expect(Motor.verovio.pasos(para: .png).map(\.programas[0]) == ["verovio", "rsvg-convert"])
        #expect(Motor.guido.pasos(para: .svg)[0].salidas.isEmpty)
    }

    @Test func exportarAGuido() {
        let melodia = salida("guido melodia Sol4:4 Do5:2 --compas 3/4 --titulo Canción")
        #expect(melodia.hasPrefix("{"))
        #expect(melodia.contains(#"\title<"Canción">"#))
        #expect(melodia.contains("g1/4 c2/2"))
        #expect(salida("guido coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados").contains("\\harmony<"))
        #expect(salida("guido chords C Am F G7 C --ingles").contains(#"\harmony<"G7">"#))
    }

    @Test func losMotores() throws {
        let falso = EjecutorFalso(instalados: ["lilypond", "musescore", "guido2svg", "rsvg-convert"])
        let lista = grabado("motores", con: falso)
        #expect(lista.codigo == 0)
        #expect(
            lista.salida == """
                lilypond   /falso/lilypond (Falso 1.0)
                musescore  /falso/musescore (Falso 1.0)
                verovio    no instalado (o pon su ruta en ARMONIA_VEROVIO)
                guido      /falso/guido2svg
                propio     /falso/rsvg-convert (Falso 1.0)

                """)
        // A `guido2svg` no se le pregunta la versión: no entiende `--version`.
        #expect(falso.llamadas.map(\.ruta) == ["/falso/lilypond", "/falso/musescore", "/falso/rsvg-convert"])
        #expect(falso.llamadas.allSatisfy { $0.argumentos == ["--version"] && $0.limite == 10 })
        let ingles = grabado("engines --ingles", con: EjecutorFalso(instalados: []))
        #expect(ingles.salida.hasPrefix("lilypond   not installed (or set ARMONIA_LILYPOND to its path)\n"))
        #expect(ingles.salida.contains("\nmusescore  not installed (or set ARMONIA_MSCORE to its path)\n"))
        #expect(ingles.salida.contains("\nown        not installed (or set ARMONIA_RSVG_CONVERT to its path)\n"))
        // Si `--version` falla, sin versión.
        let roto = grabado("motores", con: EjecutorFalso(instalados: ["verovio"], codigo: 1))
        #expect(roto.salida.contains("\nverovio    /falso/verovio\n"))
        // En JSON, lo mismo con las claves de siempre.
        let enJSON = grabado("motores --json", con: EjecutorFalso(instalados: ["lilypond", "guido2svg"]))
        let motores = try #require(
            try JSONSerialization.jsonObject(with: Data(enJSON.salida.utf8)) as? [[String: Any]])
        #expect(motores.map { $0["motor"] as? String } == ["lilypond", "musescore", "verovio", "guido", "propio"])
        #expect(motores[0]["ruta"] as? String == "/falso/lilypond" && motores[0]["version"] as? String == "Falso 1.0")
        #expect(motores[1]["instalado"] as? Bool == false && motores[1]["variable"] as? String == "ARMONIA_MSCORE")
        #expect(motores[3]["instalado"] as? Bool == true && motores[3]["version"] == nil)
        #expect(grabado("motores --foo --json", con: EjecutorFalso()).codigo == 2)
    }

    @Test func elEjecutorDelSistema() throws {
        let sh = try #require(EjecutorDelSistema().buscar("sh"))
        #expect(sh.hasSuffix("/sh"))
        // La variable de entorno manda sobre el PATH, y uno que no está no se encuentra.
        let conVariable = EjecutorDelSistema(entorno: ["ARMONIA_RSVG_CONVERT": sh, "PATH": ""])
        #expect(conVariable.buscar("rsvg-convert") == sh)
        #expect(EjecutorDelSistema(entorno: ["PATH": ""]).buscar("armonia-programa-que-no-existe") == nil)
        #expect(EjecutorDelSistema(entorno: ["ARMONIA_LILYPOND": "/no/existe"]).buscar("lilypond") == nil)
        let carpeta = FileManager.default.temporaryDirectory.appendingPathComponent("armonia-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: carpeta) }
        // Sin shell: el argumento con espacios llega entero, y la carpeta es la de trabajo.
        let sistema = EjecutorDelSistema()
        let bien = try sistema.ejecutar(sh, ["-c", "echo \"$0\" > hecho.txt", "a b"], en: carpeta, limite: 120)
        #expect(bien == ResultadoDeProceso(codigo: 0))
        let hecho = try String(contentsOf: carpeta.appendingPathComponent("hecho.txt"), encoding: .utf8)
        #expect(hecho == "a b\n")
        // La salida estándar y la de errores, cada una por su lado.
        let mal = try sistema.ejecutar(sh, ["-c", "echo hola; echo uy >&2; exit 3"], en: carpeta, limite: 120)
        #expect(mal.codigo == 3)
        #expect(mal.salida == Data("hola\n".utf8))
        #expect(mal.error == "uy\n")
        let lento = try sistema.ejecutar(sh, ["-c", "sleep 5"], en: carpeta, limite: 0.2)
        #expect(lento.agotado)
        #if os(Linux)
            // MuseScore, sin pantalla, dibuja con la plataforma `offscreen` de Qt.
            #expect(EjecutorDelSistema.variablesDelPrograma(["PATH": "/bin"])["QT_QPA_PLATFORM"] == "offscreen")
            #expect(EjecutorDelSistema.variablesDelPrograma(["DISPLAY": ":0"])["QT_QPA_PLATFORM"] == nil)
        #endif
    }
}
