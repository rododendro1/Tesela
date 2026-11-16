import Foundation
import Testing

@testable import ConsolaArmonia

// `--lugar` y `--agrupar` en `ritmos` y `temperamentos`, y `--epoca` en `temperamentos`.

extension LineaDeComandosTests {
    /// `ritmos --lugar`: los de un lugar o de uno que lo contiene; con `--agrupar`, por país, continente o época.
    @Test func ritmosPorLugar() {
        let cubanos = salida("ritmos --lugar cuba")
        #expect(cubanos.hasPrefix("tresillo: x..x..x. · 4/4\n"), Comment(rawValue: cubanos))
        #expect(cubanos.contains("\nclave de son: ") && !cubanos.contains("soleá"))
        let andaluces = salida("ritmos --lugar andalucia --agrupar pais")
        #expect(andaluces.hasPrefix("España (7)\n  soleá: "), Comment(rawValue: andaluces))
        #expect(salida("ritmos --estilo flamenco --agrupar continente").hasPrefix("Europa (7)\n"))
        let porEpoca = salida("ritmos --lugar cuba --agrupar epoca")
        #expect(porEpoca.hasPrefix("Barroco · 1600–1750 (1)\n  habanera: "), Comment(rawValue: porEpoca))
        #expect(porEpoca.contains("\nsin época (6)\n  tresillo: "))
        #expect(salida("rhythms --group-by country --ingles").hasPrefix("Spain (7)\n"))
        let lugar = resultado("ritmos", "--lugar", "marte")
        #expect(
            lugar.codigo == 2 && lugar.error.contains("no es un lugar del catálogo"), Comment(rawValue: lugar.error))
        let agrupar = resultado("ritmos", "--agrupar", "nada")
        #expect(agrupar.codigo == 2 && agrupar.error.contains("no es una forma de agrupar"))
    }

    /// `temperamentos --lugar`, `--epoca` y `--agrupar`: los que no tienen lugar ni época van al final.
    @Test func temperamentosPorLugarYEpoca() {
        let alemanes = salida("temperamentos --lugar alemania")
        #expect(alemanes.contains("\nWerckmeister IV: 12 (Andreas Werckmeister, 1691)\n"), Comment(rawValue: alemanes))
        #expect(alemanes.contains("\nKellner: ") && !alemanes.contains("Vallotti"))
        let barrocos = salida("temperamentos --epoca barroco")
        #expect(barrocos.contains("\n43 divisiones iguales: 43 · 697.674 (Joseph Sauveur, 1701)\n"))
        #expect(!barrocos.contains("Kellner"))
        let porPais = salida("temperamentos --agrupar pais")
        #expect(porPais.hasPrefix("España (1)\n  mesotónico de 1/3 de coma: "), Comment(rawValue: porPais))
        #expect(porPais.contains("\nReino Unido (3)\n  Young: "))
        let porContinente = salida("temperamentos --agrupar continente")
        #expect(porContinente.hasPrefix("Europa ("), Comment(rawValue: porContinente))
        #expect(porContinente.contains("\nsin lugar (3)\n  mesotónico de 1/5 de coma: "))
        let porEpoca = salida("temperamentos --agrupar epoca")
        #expect(porEpoca.hasPrefix("Renacimiento · 1400–1600 ("), Comment(rawValue: porEpoca))
        #expect(porEpoca.contains("\nsin época ("))
        #expect(salida("temperaments --place germany --ingles").hasPrefix("1/6 comma meantone: 12"))
        let agrupar = resultado("temperamentos", "--agrupar", "nada")
        #expect(agrupar.codigo == 2 && agrupar.error.contains("(continente, pais, epoca)"))
    }
}
