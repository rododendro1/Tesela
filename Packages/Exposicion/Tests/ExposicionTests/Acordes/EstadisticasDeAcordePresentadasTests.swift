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
        #expect(json["grupoDeHindemith"] == .texto("II a"))
        #expect(json["fundamentalDeHindemith"] == .texto("Sol"))
        guard case .lista(let fourier) = json["magnitudesDeFourier"] else {
            Issue.record("sin Fourier")
            return
        }
        #expect(fourier.count == 6)
    }

    @Test func afinacionYDisposicion() throws {
        let sol7 = try Acorde(leyendo: "Sol7")
        let datos = PresentacionDeEstadisticasDeAcorde.estadisticas(sol7.estadisticas, sobre: .sol, en: notacion)
        func valor(_ nombre: String) -> String? { datos.first { $0.nombre == nombre }?.valor }
        #expect(valor("Límite impar (Partch)") == "45")
        #expect(valor("Límite primo (Partch)") == "5")
        #expect(valor("Altura de Tenney") == "6.038")
        #expect(valor("Fundamental virtual (Terhardt)") == "Sol")
        #expect(valor("Complemento (Forte)") == "8-27")
        #expect(valor("Pareja Z (Forte)") == nil)
        #expect(valor("Disposición") == "Cerrada · intervalos anchos abajo (serie armónica)")
        let hendrix = PresentacionDeEstadisticasDeAcorde.estadisticas(
            AcordeConNombre.hendrix.estadisticas, en: notacion)
        #expect(hendrix.first { $0.nombre == "Pareja Z (Forte)" }?.valor == "4-Z29")
        let trece = EstadisticasDeAcordePresentadas(TipoDeAcorde.dominanteDecimotercera.estadisticas, en: notacion)
        #expect(trece["disposicion"] == .texto("Abierta"))
        #expect(trece["respetaLaSerieArmonica"] == .booleano(false))
        #expect(
            EstadisticasDeAcordePresentadas(TipoDeAcorde.dominanteNovena.estadisticas, en: notacion)["disposicion"]
                == .texto("Drop 2"))
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
        #expect(datos["cardinal"] == .texto("tríada"))
        #expect(datos["brilloPorQuintas"] == .decimal(1.67))
        let codificado = try JSONEncoder().encode(datos)
        let texto = String(decoding: codificado, as: UTF8.self)
        #expect(texto.contains("\"numeroDeForte\":\"3-11\""))
        #expect(texto.contains("\"triadasContenidas\":{"))
        // Las que el acorde no tiene no salen, y «rasgos» solo va al texto.
        #expect(datos["parejaZ"] == nil)
        #expect(datos["rasgos"] == nil)
    }

    /// Cada medida se describe una vez: las claves no se repiten, todas van al texto o al JSON, y la lista, la tabla y
    /// el JSON salen de ellas.
    @Test func medidas() throws {
        let claves = MedidaDeAcorde.todas.map(\.clave)
        #expect(Set(claves).count == claves.count)
        #expect(MedidaDeAcorde.todas.allSatisfy { $0.enTexto || $0.vaAlJSON })
        let consonancia = try #require(MedidaDeAcorde.medida("consonanciaDiadica"))
        #expect(consonancia.titulo(en: notacion) == "Consonancia diádica (Huron)")
        #expect(consonancia.texto(de: TipoDeAcorde.mayor.estadisticas, en: notacion) == "2.22")
        #expect(MedidaDeAcorde.medida("cardinal")?.titulo(en: notacion) == nil)
        #expect(MedidaDeAcorde.medida("rasgos")?.valor(de: TipoDeAcorde.mayor.estadisticas, en: notacion) == nil)
        #expect(MedidaDeAcorde.medida("no existe") == nil)
        let datos = PresentacionDeEstadisticasDeAcorde.estadisticas(TipoDeAcorde.mayor.estadisticas, en: notacion)
        let mayor = TipoDeAcorde.mayor.estadisticas
        #expect(
            datos.map(\.nombre)
                == MedidaDeAcorde.todas.filter { $0.texto(de: mayor, en: notacion) != nil }.compactMap {
                    $0.titulo(en: notacion)
                })
        #expect(!datos.contains { $0.nombre == "Pareja Z (Forte)" })
    }

    @Test func valorEnTextoPlano() {
        #expect(ValorDeMedida.enteros([0, 4, 7]).textoPlano == "0 4 7")
        #expect(ValorDeMedida.decimal(2.2222).textoPlano == "2.222")
        #expect(ValorDeMedida.booleano(true).textoPlano == "sí")
        #expect(ValorDeMedida.booleano(false).textoPlano == "no")
        #expect(ValorDeMedida.texto("4-27").textoPlano == "4-27")
        let prominencias = ValorDeMedida.lista([
            .objeto([.init("nota", .texto("Sol")), .init("peso", .entero(20))]),
            .objeto([.init("nota", .texto("Fa")), .init("peso", .entero(11))]),
        ])
        #expect(prominencias.textoPlano == "Sol 20 · Fa 11")
    }
}
