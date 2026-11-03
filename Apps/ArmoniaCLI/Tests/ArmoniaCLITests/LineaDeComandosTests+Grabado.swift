import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

// Las pruebas de `grabar`: con un ejecutor que no ejecuta nada y apunta lo que se le pide, y con el de verdad, que
// solo se prueba con `/bin/sh`, porque LilyPond y rsvg-convert no tienen por qué estar instalados.

/// Un ejecutor que hace como que el programa ha grabado: escribe «GRABADO» en el fichero que tocaba.
private final class EjecutorFalso: EjecutorDeProcesos, @unchecked Sendable {
    struct Llamada {
        let ruta: String
        let argumentos: [String]
        /// Lo que Tesela escribió para el programa (el último argumento).
        let fuente: String
    }

    let instalados: Set<String>
    let codigo: Int32
    let agotado: Bool
    private let cerrojo = NSLock()
    private var apuntadas: [Llamada] = []

    init(instalados: Set<String> = ["lilypond", "rsvg-convert"], codigo: Int32 = 0, agotado: Bool = false) {
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

    func ejecutar(_ ruta: String, _ argumentos: [String], en carpeta: URL) throws -> ResultadoDeProceso {
        let fuente = try String(contentsOf: carpeta.appendingPathComponent(argumentos.last!), encoding: .utf8)
        cerrojo.lock()
        apuntadas.append(Llamada(ruta: ruta, argumentos: argumentos, fuente: fuente))
        cerrojo.unlock()
        guard codigo == 0, !agotado else {
            return ResultadoDeProceso(codigo: codigo, error: "aviso\nerror: algo falló\n", agotado: agotado)
        }
        // LilyPond pone la extensión a lo que va tras `-o`; rsvg-convert escribe en el fichero de `--output`.
        let nombre: String
        if let o = argumentos.firstIndex(of: "-o") {
            let ext = argumentos.contains("--png") ? "png" : argumentos.contains("-dbackend=svg") ? "svg" : "pdf"
            nombre = argumentos[o + 1] + "." + ext
        } else {
            nombre = argumentos[argumentos.firstIndex(of: "--output")! + 1]
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
            "grabar acorde Do", "grabar nube Do", "grabar grabar coral Do", "grabar musicxml coral Do --motor propio",
            "grabar coral --foo 1", "grabar acorde Do --motor lilypond",
        ] {
            let resultado = grabado(orden, con: falso)
            #expect(resultado.codigo == 2, Comment(rawValue: orden))
            #expect(resultado.error.hasPrefix("armonia: "), Comment(rawValue: orden))
        }
        #expect(falso.llamadas.isEmpty)
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
        let bien = try EjecutorDelSistema().ejecutar(sh, ["-c", "echo \"$0\" > hecho.txt", "a b"], en: carpeta)
        #expect(bien == ResultadoDeProceso(codigo: 0))
        let hecho = try String(contentsOf: carpeta.appendingPathComponent("hecho.txt"), encoding: .utf8)
        #expect(hecho == "a b\n")
        let mal = try EjecutorDelSistema().ejecutar(sh, ["-c", "echo uy >&2; exit 3"], en: carpeta)
        #expect(mal.codigo == 3)
        #expect(mal.error == "uy\n")
        let lento = try EjecutorDelSistema(limite: 0.2).ejecutar(sh, ["-c", "sleep 5"], en: carpeta)
        #expect(lento.agotado)
    }
}
