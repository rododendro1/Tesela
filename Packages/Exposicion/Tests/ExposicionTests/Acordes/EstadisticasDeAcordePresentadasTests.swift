import Armonia
import Foundation
import Testing

@testable import Exposicion

/// Lo que se mide de un acorde, escrito: un dato por fila, la tabla, el resumen del catálogo y el JSON.
@Suite struct EstadisticasDeAcordePresentadasTests {
    let notacion = Notacion.compacta(.espanol)

    @Test func unDatoPorFila() {
        let datos = PresentacionDeEstadisticasDeAcorde.estadisticas(
            TipoDeAcorde.dominanteSeptima.estadisticas, en: notacion)
        #expect(
            datos.prefix(9).map(\.valor) == [
                "4 (tétrada)", "0", "+0.75", "6", "[0, 1, 2, 1, 1, 1]", "(0, 2, 5, 8)", "4-27", "12",
                "anhemitónico (sin semitonos) · con tritono",
            ])
        #expect(datos.first?.nombre == "Número de notas")
        // El de Petrushka no tiene tensiones ni brillo, pero sí ámbito, y no se lee por terceras.
        let petrushka = PresentacionDeEstadisticasDeAcorde.estadisticas(
            AcordeConNombre.petrushka.estadisticas, en: notacion)
        #expect(!petrushka.contains { $0.nombre == "Brillo por quintas" })
        #expect(!petrushka.contains { $0.nombre == "Tensiones" })
        #expect(petrushka.contains { $0.nombre == "Ámbito (semitonos)" })
        #expect(petrushka.first { $0.nombre == "Rasgos" }?.valor.hasPrefix("no se lee por terceras") == true)
        // En inglés.
        let ingles = PresentacionDeEstadisticasDeAcorde.estadisticas(
            TipoDeAcorde.disminuidoSeptima.estadisticas, en: .ascii(.ingles))
        #expect(ingles.first?.valor == "4 (tetrad)")
        #expect(
            ingles.first { $0.nombre == "Traits" }?.valor
                == "anhemitonic (no semitones) · with a tritone · inversionally symmetric")
        #expect(ingles.first { $0.nombre == "Hindemith group" }?.valor == "VI")
    }

    /// Las medidas de las teorías de acordes, con las fundamentales como notas sobre la dada o como intervalos.
    @Test func teoriasDeAcordes() throws {
        let sol7 = try Acorde(leyendo: "Sol7")
        let datos = PresentacionDeEstadisticasDeAcorde.estadisticas(sol7.estadisticas, sobre: .sol, en: notacion)
        func valor(_ nombre: String) -> String? { datos.first { $0.nombre == nombre }?.valor }
        #expect(valor("Consonancia diádica (Huron)") == "1.779")
        #expect(valor("Grupo de Hindemith") == "II a")
        #expect(valor("Fundamental (Hindemith)") == "Sol")
        #expect(valor("Fundamental (Parncutt)")?.hasPrefix("Sol (") == true)
        #expect(valor("Intervalos entre voces (semitonos)") == "4 3 3")
        #expect(valor("Gradus suavitatis (Euler)") == "11")
        #expect(valor("Tríadas contenidas") == "M 1 · m 0 · ° 1 · + 0")
        #expect(valor("Modalidad (Cook)")?.hasPrefix("+") == true)
        // Sin nota, la fundamental es un intervalo: la tercera menor de la semidisminuida.
        let semidisminuido = PresentacionDeEstadisticasDeAcorde.estadisticas(
            TipoDeAcorde.semidisminuido.estadisticas, en: notacion)
        #expect(semidisminuido.first { $0.nombre == "Fundamental (Hindemith)" }?.valor == "3m")
        let json = EstadisticasDeAcordePresentadas(sol7.estadisticas, sobre: .sol, en: notacion)
        #expect(json.grupoDeHindemith == "II a")
        #expect(json.fundamentalDeHindemith == "Sol")
        #expect(json.magnitudesDeFourier.count == 6)
    }

    @Test func tabla() {
        let tabla = PresentacionDeEstadisticasDeAcorde.tablaDeEstadisticas(
            [.mayor, .dominanteSeptima, .petrushka], en: notacion)
        #expect(tabla.encabezados.count == 9)
        #expect(tabla.filas.allSatisfy { $0.count == 9 })
        #expect(tabla.filas[0][6] == "2.22")
        #expect(tabla.filas[0][7] == "I 1")
        #expect(tabla.filas[0][1] == "Do Mi Sol")
        #expect(tabla.filas[1][3] == "+0.75")
        #expect(tabla.filas[2][3] == "—")
        #expect(tabla.filas[2][5] == "6-30")
    }

    @Test func resumen() {
        let resumen = PresentacionDeEstadisticasDeAcorde.resumen(
            [.mayor, .menor, .dominanteSeptima, .petrushka], en: notacion)
        #expect(resumen.total == 4)
        #expect(resumen.porNumeroDeNotas.map(\.nombre) == ["3 (tríada)", "4 (tétrada)", "6 (héxada)"])
        #expect(resumen.porNumeroDeNotas.map(\.acordes) == [2, 1, 1])
        #expect(resumen.porTerceras == 3)
        #expect(resumen.noPorTerceras == 1)
        #expect(resumen.porEstilo.last?.nombre == "sin estilo")
        #expect(resumen.porEstilo.last?.acordes == 3)
        // Todo el catálogo suma lo que tiene.
        let catalogo = PresentacionDeEstadisticasDeAcorde.resumen(AcordeConNombre.catalogo, en: notacion)
        #expect(catalogo.total == AcordeConNombre.catalogo.count)
        #expect(catalogo.porNumeroDeNotas.map(\.acordes).reduce(0, +) == catalogo.total)
        #expect(catalogo.porTerceras + catalogo.noPorTerceras == catalogo.total)
    }

    @Test func json() throws {
        let datos = EstadisticasDeAcordePresentadas(TipoDeAcorde.mayor.estadisticas, en: notacion)
        #expect(datos.cardinal == "tríada")
        #expect(datos.brilloPorQuintas == 1.67)
        let codificado = try JSONEncoder().encode(datos)
        let texto = String(decoding: codificado, as: UTF8.self)
        #expect(texto.contains("\"numeroDeForte\":\"3-11\""))
    }
}
