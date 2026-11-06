import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

// Los nombres de antes (`Obsoletos.swift` de cada módulo) siguen dando lo mismo que los nuevos hasta que se quiten.
// Se usan a propósito, así que estas pruebas compilan con avisos de obsoleto.

@Suite struct ObsoletosTests {
    @available(*, deprecated)
    @Test func lasEscalasOccidentales() {
        #expect(TipoDeEscala.todos == TipoDeEscala.occidentales)
        #expect(TipoDeEscala.todos(uso: .blues) == TipoDeEscala.occidentales(uso: .blues))
    }

    @available(*, deprecated)
    @Test func leerSinError() {
        #expect(Acorde(texto: "Sol7/Si") == Acorde("Sol7/Si"))
        #expect(Acorde(texto: "Do7(b3)") == nil)
    }
}
