import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria
@testable import ArmoniaTrastes

/// Lo que se hace con números que pueden venir de fuera: las variantes `init?(comprobando:)` devuelven `nil` en vez
/// de detener el programa, y donde un valor fuera de rango tiene una lectura clara, se toma esa.
@Suite struct EntradasInvalidasTests {
    // MARK: Duración

    @Test func unaDuracionConDenominadorCeroEsNil() {
        #expect(Duracion(comprobando: 3, 0) == nil)
        #expect(Duracion(comprobando: 0, 0) == nil)
    }

    @Test func unaDuracionValidaEsLaMismaQueLaDelInicializadorNormal() {
        #expect(Duracion(comprobando: 3, 8) == Duracion(3, 8))
        #expect(Duracion(comprobando: 6, 16) == Duracion(3, 8))
        #expect(Duracion(comprobando: 0, 5) == Duracion.cero)
    }

    @Test func losPuntillosFueraDeRangoSonNil() {
        #expect(Duracion(comprobando: .negra, puntillos: -1) == nil)
        #expect(Duracion(comprobando: .negra, puntillos: 31) == nil)
        #expect(Duracion(comprobando: .negra, puntillos: 0) == Duracion.negra)
        #expect(Duracion(comprobando: .negra, puntillos: 1) == Duracion(3, 8))
        #expect(Duracion(comprobando: .negra, puntillos: 2) == Duracion(7, 16))
        #expect(Duracion(comprobando: .negra, puntillos: 30) != nil)
    }

    // MARK: Compás

    @Test func unCompasInvalidoEsNil() {
        #expect(Compas(comprobando: 0, 4) == nil)
        #expect(Compas(comprobando: -3, 4) == nil)
        #expect(Compas(comprobando: 3, 0) == nil)
        #expect(Compas(comprobando: 3, 3) == nil) // el denominador no es una potencia de 2
        #expect(Compas(comprobando: 3, 128) == nil) // más de 64
    }

    @Test func unCompasValidoEsElMismoQueElDelInicializadorNormal() {
        #expect(Compas(comprobando: 3, 4) == Compas(3, 4))
        #expect(Compas(comprobando: 6, 8) == Compas(6, 8))
        #expect(Compas(comprobando: 7, 8) == Compas(7, 8))
    }

    @Test func laAgrupacionTieneQueSumarElNumerador() {
        #expect(Compas(comprobando: 6, 8, agrupacion: [3, 3]) == Compas(6, 8, agrupacion: [3, 3]))
        #expect(Compas(comprobando: 7, 8, agrupacion: [2, 2, 3]) == Compas(7, 8))
        #expect(Compas(comprobando: 6, 8, agrupacion: [2, 2]) == nil)
        #expect(Compas(comprobando: 6, 8, agrupacion: [0, 6]) == nil)
        #expect(Compas(comprobando: 6, 8, agrupacion: [-3, 9]) == nil)
    }

    // MARK: Tempo

    @Test func unTempoNoPositivoEsNil() {
        #expect(Tempo(comprobando: 0) == nil)
        #expect(Tempo(comprobando: -60) == nil)
        #expect(Tempo(comprobando: .nan) == nil)
        #expect(Tempo(comprobando: 100, unidad: .cero) == nil)
    }

    @Test func unTempoValidoEsElMismoQueElDelInicializadorNormal() {
        #expect(Tempo(comprobando: 120) == Tempo(120))
        #expect(
            Tempo(comprobando: 60, unidad: Duracion(.negra, puntillos: 1))
                == Tempo(60, unidad: Duracion(.negra, puntillos: 1)))
    }

    // MARK: Base de Hewlett

    @Test func laAlteracionMaximaNegativaSeTomaComoCero() {
        #expect(BaseDeHewlett(alteracionMaxima: -3).alteracionMaxima == 0)
        #expect(BaseDeHewlett(alteracionMaxima: 0).alteracionMaxima == 0)
        #expect(BaseDeHewlett(alteracionMaxima: 2) == BaseDeHewlett.base40)
        #expect(BaseDeHewlett(base: 54)?.alteracionMaxima == 3)
    }
}
