import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

@Suite struct ArgumentosTests {
    @Test func marcas() {
        var argumentos = Argumentos(["Sol7", "--diagrama", "Do", "--diagram"])
        let quitada = argumentos.quitarMarca("--diagrama", "--diagram")
        #expect(quitada)
        #expect(argumentos.restantes == ["Sol7", "Do"])
        let ausente = argumentos.quitarMarca("--completo")
        #expect(!ausente)
    }

    @Test func opciones() {
        var argumentos = Argumentos(["Sol7", "--instrument", "ukelele", "--limite"])
        #expect(argumentos.quitarOpcion("--instrumento", "--instrument") == .valor("ukelele"))
        #expect(argumentos.quitarOpcion("--limite", "--limit") == .sinValor(nombre: "limite"))
        #expect(argumentos.quitarOpcion("--dedos") == .ausente)
        #expect(argumentos.restantes == ["Sol7"])
        // Otra opción no es un valor.
        var seguidas = Argumentos(["--language", "--textos", "es"])
        #expect(seguidas.quitarOpcion("--idioma", "--language") == .sinValor(nombre: "language"))
        #expect(seguidas.opcionDesconocida == "--textos")
    }

    @Test func valores() throws {
        var argumentos = Argumentos(["Sol7", "--instrument", "ukelele", "--comparar", "Do", "lidio", "--limite"])
        #expect(try argumentos.valor("--instrumento", "--instrument") == "ukelele")
        #expect(try argumentos.valor("--dedos") == nil)
        #expect(try argumentos.valorConPalabras("--comparar", "--compare") == "Do lidio")
        #expect(argumentos.restantes == ["Sol7", "--limite"])
        // Sin valor, `faltaValor` con el nombre que se escribió, o el error que se pida.
        var copia = argumentos
        let sinNada = fallo { _ = try copia.valor("--limite", "--limit") }
        #expect(sinNada == "faltaValor(\"limite\")")
        copia = argumentos
        let elPedido = fallo { _ = try copia.valor("--limite", "--limit", siFalta: .faltaLimite) }
        #expect(elPedido == "faltaLimite")
        copia = argumentos
        let sinPalabras = fallo { _ = try copia.valorConPalabras("--limite") }
        #expect(sinPalabras == "faltaValor(\"limite\")")
        #expect(copia.restantes == ["Sol7"])
    }

    /// El error de uso que lanza `leer`, escrito como su caso, o `nil` si no lanza ninguno.
    private func fallo(_ leer: () throws -> Void) -> String? {
        do {
            try leer()
            return nil
        } catch {
            return "\(error)"
        }
    }

    @Test func numeros() {
        var argumentos = Argumentos(["Sol7", "--voces", "2"])
        #expect(argumentos.quitarNumero("--voces", "--voices", en: 1...2, porDefecto: 1) == 2)
        #expect(argumentos.quitarNumero("--voces", "--voices", en: 1...2, porDefecto: 1) == 1)
        #expect(argumentos.restantes == ["Sol7"])
        var fuera = Argumentos(["--voces", "3"])
        #expect(fuera.quitarNumero("--voces", en: 1...2, porDefecto: 1) == nil)
        var sinNumero = Argumentos(["--voces"])
        #expect(sinNumero.quitarNumero("--voces", en: 1...2, porDefecto: 1) == nil)
    }

    @Test func laTonalidadSeLlevaElResto() throws {
        var argumentos = Argumentos(["Do", "Fa", "Sol7", "--en", "La", "menor"])
        #expect(try (argumentos.quitarTonalidad()) == .some(Tonalidad(.la, .menor)))
        #expect(argumentos.unidos == "Do Fa Sol7")
        var sinTonalidad = Argumentos(["Do"])
        #expect(try (sinTonalidad.quitarTonalidad()) == .some(nil))
        var alFinal = Argumentos(["Do", "--in"])
        #expect(try (alFinal.quitarTonalidad()) == nil)
    }

    @Test func lasOpcionesConTextoTomanHastaLaSiguiente() {
        var argumentos = Argumentos([
            "Do", "Re", "--Titulo", "Mi", "canción", "--análisis", "Fa", "--pattern", "alberti", "--tempo",
        ])
        let (opciones, marcas) = argumentos.quitarOpcionesConTexto(
            marcas: ["analisis": "analisis", "análisis": "analisis"], alias: [("pattern", "patron")])
        #expect(opciones == ["titulo": "Mi canción", "patron": "alberti", "tempo": ""])
        #expect(marcas == ["analisis"])
        #expect(argumentos.restantes == ["Do", "Re", "Fa"])
    }
}
