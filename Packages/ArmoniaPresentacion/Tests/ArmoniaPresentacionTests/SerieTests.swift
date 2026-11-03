import Armonia
import Foundation
import Testing

@testable import ArmoniaPresentacion

// La vista de la serie dodecafónica de la app de armonía.
@Suite struct PresentacionDeSerieTests {
    /// La serie de la Suite lírica de Berg, en P5.
    let berg = PresentacionDeSerie.ejemplo

    @Test func losDatosDeLaSerieDeBerg() throws {
        let presentada = try PresentacionDeSerie.presentar(
            berg, forma: FormaDeSerie(.original, 5), notacion: .espanolCompacto)
        #expect(presentada.serie == "5 4 0 9 7 2 8 1 3 6 t e")
        let datos = Dictionary(uniqueKeysWithValues: presentada.datos.map { ($0.titulo, $0.valor) })
        #expect(datos["Notas"]?.hasPrefix("Fa Mi Do La Sol Re") == true)
        #expect(datos["Intervalos"] == "11 8 9 10 7 6 5 2 3 4 1 (De todos los intervalos)")
        #expect(datos["Hexacordos"] == "6-32 · 6-32")
        #expect(datos["Formas combinatorias"]?.split(separator: " ").contains("R5") == true)
        #expect(presentada.formasDistintas == "48 formas distintas")
    }

    @Test func laMatrizConSusFormas() throws {
        let presentada = try PresentacionDeSerie.presentar(
            berg, forma: FormaDeSerie(.original, 5), notacion: .espanolCompacto)
        #expect(presentada.matriz.count == 12)
        #expect(presentada.matriz.allSatisfy { Set($0) == Set(0..<12) })
        #expect(presentada.matriz[0] == [5, 4, 0, 9, 7, 2, 8, 1, 3, 6, 10, 11])
        #expect(presentada.formasDeLasFilas[0] == FormaDeSerie(.original, 5))
        #expect(presentada.formasDeLasColumnas[0] == FormaDeSerie(.inversion, 5))
        #expect(presentada.formasDeLasColumnas[1] == FormaDeSerie(.inversion, 4))
        #expect(presentada.nombresDeLasClases.count == 12)
        #expect(presentada.nombresDeLasClases[0] == "Do")
        #expect(presentada.descripcion(deLaFila: 0).hasPrefix("P5: Fa Mi Do"))
        #expect(SeriePresentada.cifra(10) == "t")
        #expect(SeriePresentada.cifra(11) == "e")
        #expect(SeriePresentada.cifra(7) == "7")
    }

    @Test func laFormaElegidaSeResaltaSeEscuchaYSeExporta() throws {
        let original = try PresentacionDeSerie.presentar(
            berg, forma: FormaDeSerie(.original, 5), notacion: .espanolCompacto)
        #expect(original.clasesDeLaForma == [5, 4, 0, 9, 7, 2, 8, 1, 3, 6, 10, 11])
        #expect((0..<12).allSatisfy { original.estaEnLaForma(fila: 0, columna: $0) })
        #expect(!original.estaEnLaForma(fila: 1, columna: 0))
        #expect(original.sonido.notas.map(\.midi) == original.clasesDeLaForma.map { 60 + $0 })
        #expect(original.ficheros.count == 5)
        #expect(original.pentagrama.svg.contains("<svg"))

        let inversion = try PresentacionDeSerie.presentar(
            berg, forma: FormaDeSerie(.inversion, 5), notacion: .espanolCompacto)
        #expect(inversion.clasesDeLaForma == [5, 6, 10, 1, 3, 8, 2, 9, 7, 4, 0, 11])
        #expect((0..<12).allSatisfy { inversion.estaEnLaForma(fila: $0, columna: 0) })
        #expect(!inversion.estaEnLaForma(fila: 0, columna: 1))

        let retrogrado = try PresentacionDeSerie.presentar(
            berg, forma: FormaDeSerie(.retrogrado, 5), notacion: .espanolCompacto)
        #expect(retrogrado.clasesDeLaForma == original.clasesDeLaForma.reversed())
        #expect(retrogrado.estaEnLaForma(fila: 0, columna: 3))
    }

    @Test func unaSerieQueNoEsDodecafonicaNoSeLee() {
        #expect(throws: ErrorDeLectura.self) {
            try PresentacionDeSerie.presentar("0 1 2", forma: FormaDeSerie(.original, 0), notacion: .espanolCompacto)
        }
        #expect(throws: ErrorDeLectura.self) {
            try PresentacionDeSerie.presentar(
                "0 1 2 3 4 5 6 7 8 9 t t", forma: FormaDeSerie(.original, 0), notacion: .espanolCompacto)
        }
    }

    @Test func enOtroIdioma() throws {
        let presentada = try PresentacionDeSerie.presentar(
            berg, forma: FormaDeSerie(.original, 5), notacion: .inglesASCII)
        #expect(presentada.datos.map(\.titulo).contains("Hexachords"))
        #expect(presentada.formasDistintas == "48 distinct forms")
        #expect(presentada.nombresDeLasClases[0] == "C")
        #expect(
            PresentacionDeSerie.indicacion(en: .espanolCompacto) == "Serie (5 4 0 9 7 2 8 1 3 6 t e, o Fa Mi Do La…)")
        #expect(PresentacionDeSerie.indicacion(en: .inglesASCII) == "Row (5 4 0 9 7 2 8 1 3 6 t e, or F E C A…)")
    }
}
