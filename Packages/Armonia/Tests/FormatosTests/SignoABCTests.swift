import Testing

@testable import Elementos
@testable import Formatos

/// El troceado de una línea de música de ABC, antes de interpretarla (`SignoABC.trocear(_:)`).
@Suite struct SignoABCTests {
    private func nota(
        _ natural: NotaNatural, _ octava: Int, _ numerador: Int = 1, _ denominador: Int = 1, cents: Double? = nil
    ) -> SignoABC.NotaEscrita {
        SignoABC.NotaEscrita(
            cents: cents, natural: natural, octava: octava,
            longitud: SignoABC.Longitud(numerador: numerador, denominador: denominador))
    }

    @Test func notasYSilencios() {
        #expect(
            SignoABC.trocear("^C2 _e/ =B,3/2 z c'' % comentario d")
                == [
                    .nota(nota(.do, 4, 2, cents: 100)), .nota(nota(.mi, 5, 1, 2, cents: -100)),
                    .nota(nota(.si, 3, 3, 2, cents: 0)), .silencio(SignoABC.Longitud(numerador: 1, denominador: 1)),
                    .nota(nota(.do, 7)),
                ])
        // Los cuartos de tono: `^/` es medio sostenido; `^3/2`, tres cuartos de tono.
        #expect(SignoABC.trocear("^/D ^3/2E") == [.nota(nota(.re, 4, cents: 50)), .nota(nota(.mi, 4, cents: 150))])
        // Una octava imposible no es una nota.
        #expect(SignoABC.trocear("c''''''''''''''''").isEmpty)
    }

    @Test func barrasCampoYAcorde() {
        #expect(
            SignoABC.trocear("|: C :|2 [K:D] [1 [\"^Do\"C-E!>!G]2 Z3")
                == [
                    .barra("|:", casillas: nil), .nota(nota(.do, 4)), .barra(":|", casillas: "2"), .campo("K", "D"),
                    .barra("[", casillas: "1"), .anotacion("^Do"), .decoracion(">"),
                    .acorde(
                        [nota(.do, 4), nota(.mi, 4), nota(.sol, 4)], ligadas: true,
                        longitud: SignoABC.Longitud(numerador: 2, denominador: 1)),
                    .compasesDeSilencio(3),
                ])
    }

    @Test func adornosIrregularesYPuntillo() {
        #expect(
            SignoABC.trocear("{gA}B (3:2:3CDE (F) G>>A .B-B +fermata+")
                == [
                    .adornos([nota(.sol, 5), nota(.la, 4)]), .nota(nota(.si, 4)), .irregular([3, 2, 3]),
                    .nota(nota(.do, 4)), .nota(nota(.re, 4)), .nota(nota(.mi, 4)), .nota(nota(.fa, 4)),
                    .nota(nota(.sol, 4)), .puntillo(largo: true, veces: 2), .nota(nota(.la, 4)), .staccato,
                    .nota(nota(.si, 4)), .ligadura, .nota(nota(.si, 4)), .decoracion("fermata"),
                ])
    }
}
