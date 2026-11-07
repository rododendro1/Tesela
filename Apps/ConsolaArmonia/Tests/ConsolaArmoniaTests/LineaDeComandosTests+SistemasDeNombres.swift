import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

// Las pruebas de `--sistema` y `--grafia`: los nombres de nota de otras tradiciones.

extension LineaDeComandosTests {
    /// Un sistema fijo escribe todas las notas de la orden, y los textos siguen en el idioma de `--idioma`.
    @Test func unSistemaFijoEnTodaLaOrden() {
        #expect(salida("escala Re dórico --sistema bizantino").contains("notas: Pa Vou Ga Di Ke Zo Ni"))
        #expect(salida("escala Re dórico --sistema bizantino --grafia original").contains("Πα Βου Γα Δι Κε Ζω Νη"))
        #expect(salida("acorde Sol7/Si --sistema japones --grafia original").hasPrefix("ト7/ロ"))
        #expect(salida("acorde Do7 --sistema lu --grafia original --idioma eu").contains("notak: 黄钟 姑洗 林钟 无射"))
        #expect(salida("acorde Fa#7 --system byzantine --script ascii").hasPrefix("Ga#7"))
        #expect(
            salida("acorde Sol7 --sistema Bizantino --grafía Original")
                == salida("acorde Sol7 --sistema bizantino --grafia original"))
    }

    /// Las notas se leen también en el sistema elegido.
    @Test func seLeeEnElSistema() {
        #expect(salida("acorde Ga♯7 --sistema bizantino") == salida("acorde Fa#7 --sistema bizantino"))
        #expect(salida("escala Pa dórico --sistema bizantino") == salida("escala Re dórico --sistema bizantino"))
    }

    /// Un sistema móvil nombra los grados de `escala`, desde su tónica; en las demás órdenes es un error de uso.
    @Test func unSistemaMovilEnLaEscala() {
        #expect(salida("escala Re dórico --sistema sargam").contains("sargam: Sā Re ga ma Pa Dha ni"))
        #expect(salida("escala Do mayor --sistema sargam --grafia original").contains("sargam: सा रे ग म प ध नि"))
        #expect(salida("escala Sol mayor --sistema jianpu").contains("jianpu: 1 2 3 4 5 6 7"))
        // Las notas siguen como estaban.
        #expect(salida("escala Re dórico --sistema sargam").contains("notas: Re Mi Fa Sol La Si Do"))
        let acorde = resultado("acorde", "Do", "--sistema", "sargam")
        #expect(acorde.codigo == 2)
        #expect(acorde.error.contains("«sargam»"))
    }

    @Test func sistemaOGrafiaQueNoSeConocen() {
        let sistema = resultado("escala", "Do", "mayor", "--sistema", "bizantin")
        #expect(sistema.codigo == 2)
        #expect(sistema.error.contains("«bizantino»"))
        let grafia = resultado("escala", "Do", "mayor", "--sistema", "bizantino", "--grafia", "griega")
        #expect(grafia.codigo == 2)
        #expect(grafia.error.contains("original"))
        #expect(resultado("acorde", "Do", "--sistema").codigo == 2)
    }

    /// Las dos opciones son generales: se completan y salen en la ayuda en los trece idiomas.
    @Test func lasOpcionesDelSistemaSonGenerales() {
        #expect(LineaDeComandos.opcionesGenerales.contains("--sistema"))
        #expect(LineaDeComandos.opcionesGenerales.contains("--script"))
        for idioma in Idioma.allCases {
            let ayuda = salida("ayuda --todo --idioma \(idioma.codigo)")
            #expect(ayuda.contains(idioma == .ingles ? "--system" : "--sistema"), Comment(rawValue: idioma.codigo))
        }
    }
}
