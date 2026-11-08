import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

@Suite struct ArgumentosTests {
    @Test func marcas() {
        var argumentos = Argumentos(["Sol7", "--diagrama", "Do", "--diagram"])
        let quitada = argumentos.quitarMarca(.diagrama)
        #expect(quitada)
        #expect(argumentos.restantes == ["Sol7", "Do"])
        let ausente = argumentos.quitarMarca(.completo)
        #expect(!ausente)
    }

    @Test func conTildesOSinEllas() {
        var argumentos = Argumentos(["Do", "--estadísticas", "--límite", "3", "--simetría"])
        let estadisticas = argumentos.quitarMarca(.estadisticas)
        #expect(estadisticas)
        let limite = argumentos.quitarOpcion(.limite)
        #expect(limite == .valor("3"))
        // Lo que no se conoce se dice como se escribió.
        #expect(argumentos.opcionDesconocida == "--simetría")
        #expect(Argumentos.sinTildes("--conducción-mínima") == "--conduccion-minima")
        #expect(Argumentos.sinTildes("--pequeño") == "--pequeño")
        #expect(OpcionDeOrden.vecinas.seEscribe("--neighbours"))
    }

    @Test func opciones() {
        var argumentos = Argumentos(["Sol7", "--instrument", "ukelele", "--limite"])
        #expect(argumentos.quitarOpcion(.instrumento) == .valor("ukelele"))
        #expect(argumentos.quitarOpcion(.limite) == .sinValor(nombre: "limite"))
        #expect(argumentos.quitarOpcion(.dedosDeLaDigitacion) == .ausente)
        #expect(argumentos.restantes == ["Sol7"])
        // Otra opción no es un valor.
        var seguidas = Argumentos(["--language", "--textos", "es"])
        #expect(seguidas.quitarOpcion(.idioma) == .sinValor(nombre: "language"))
        #expect(seguidas.opcionDesconocida == "--textos")
    }

    @Test func valores() throws {
        var argumentos = Argumentos(["Sol7", "--instrument", "ukelele", "--comparar", "Do", "lidio", "--limite"])
        #expect(try argumentos.valor(.instrumento) == "ukelele")
        #expect(try argumentos.valor(.dedosDeLaDigitacion) == nil)
        #expect(try argumentos.valorConPalabras(.comparar) == "Do lidio")
        #expect(argumentos.restantes == ["Sol7", "--limite"])
        // Sin valor, `faltaValor` con el nombre que se escribió, o el error que se pida.
        var copia = argumentos
        let sinNada = fallo { _ = try copia.valor(.limite) }
        #expect(sinNada == ErrorDeUso.faltaValor("limite").description)
        copia = argumentos
        let elPedido = fallo { _ = try copia.valor(.limite, siFalta: .faltaLimite) }
        #expect(elPedido == ErrorDeUso.faltaLimite.description)
        copia = argumentos
        let sinPalabras = fallo { _ = try copia.valorConPalabras(.limite) }
        #expect(sinPalabras == ErrorDeUso.faltaValor("limite").description)
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
        #expect(argumentos.quitarNumero(.voces, en: 1...2, porDefecto: 1) == 2)
        #expect(argumentos.quitarNumero(.voces, en: 1...2, porDefecto: 1) == 1)
        #expect(argumentos.restantes == ["Sol7"])
        var fuera = Argumentos(["--voces", "3"])
        #expect(fuera.quitarNumero(.voces, en: 1...2, porDefecto: 1) == nil)
        var sinNumero = Argumentos(["--voces"])
        #expect(sinNumero.quitarNumero(.voces, en: 1...2, porDefecto: 1) == nil)
    }

    @Test func laTonalidadSeLlevaElResto() throws {
        var argumentos = Argumentos(["Do", "Fa", "Sol7", "--en", "La", "menor"])
        #expect(try (argumentos.quitarTonalidad(en: .compacta(.espanol))) == .some(Tonalidad(.la, .menor)))
        #expect(argumentos.unidos == "Do Fa Sol7")
        var sinTonalidad = Argumentos(["Do"])
        #expect(try (sinTonalidad.quitarTonalidad(en: .compacta(.espanol))) == .some(nil))
        var alFinal = Argumentos(["Do", "--in"])
        #expect(try (alFinal.quitarTonalidad(en: .compacta(.espanol))) == nil)
        // Hasta la siguiente opción, que se queda.
        var conOtra = Argumentos(["Do", "--en", "La", "menor", "--escalas"])
        #expect(try (conOtra.quitarTonalidad(en: .compacta(.espanol))) == .some(Tonalidad(.la, .menor)))
        #expect(conOtra.restantes == ["Do", "--escalas"])
        var vacia = Argumentos(["Do", "--en", "--escalas"])
        #expect(try (vacia.quitarTonalidad(en: .compacta(.espanol))) == nil)
    }

    @Test func lasOpcionesQueSobran() throws {
        var argumentos = Argumentos(["Do", "--diagrama", "--inventada"])
        let diagrama = argumentos.quitarMarca(.diagrama)
        #expect(diagrama)
        #expect(throws: ErrorDeUso.self) { try argumentos.sinOpcionesDesconocidas() }
        #expect(throws: ErrorDeUso.self) { try argumentos.leidos }
        #expect(try Argumentos(["Do", "-m3"]).leidos == ["Do", "-m3"])
    }

    @Test func lasOpcionesConTextoTomanHastaLaSiguiente() throws {
        var argumentos = Argumentos([
            "Do", "Re", "--Titulo", "Mi", "canción", "--análisis", "Fa", "--pattern", "alberti", "--tempo",
        ])
        let (opciones, marcas) = try argumentos.quitarOpcionesConTexto([
            .titulo, .analisis, .patronDePartitura, .tempo,
        ])
        #expect(opciones == ["titulo": "Mi canción", "patron": "alberti", "tempo": ""])
        #expect(marcas == ["analisis"])
        #expect(argumentos.restantes == ["Do", "Re", "Fa"])
        var conOtra = Argumentos(["Do", "--clave", "fa"])
        #expect(throws: ErrorDeUso.self) { try conOtra.quitarOpcionesConTexto([.titulo]) }
    }
}
