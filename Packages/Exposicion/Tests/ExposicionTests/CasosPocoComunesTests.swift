import Armonia
import Testing

@testable import Exposicion

// Lo que se enseña en los casos menos corrientes: una escala con microtonos, unas voces sin acorde en un coral, un
// ritmo armónico sin tempo, un contrapunto debajo del cantus.

@Suite struct CasosPocoComunesTests {
    let notacion = Notacion.compacta(.espanol)

    @Test func unaEscalaConMicrotonosAvisaDeQueLaMedidaEsAproximada() throws {
        let escala = try Escala(leyendo: "Re bayati")
        #expect(escala.estadisticas.aproximada)
        let datos = PresentacionDeEstudioDeEscala.estadisticas(de: escala, en: notacion)
        #expect(datos.contains { $0.valor.contains(notacion.texto(\.medidaAproximada)) })
    }

    @Test func unasVocesSinAcordeEnElCoral() throws {
        let coral = try PresentacionDeCoral.presentar(.revisar, "Do3 Do4 Do4 Do5", en: notacion)
        #expect(coral.filas.map(\.cifrado) == ["–"])
    }

    @Test func unRitmoArmonicoSinTempo() throws {
        let acordes = [Acorde("Do"), Acorde("Sol7"), Acorde("Do")]
        let ritmo = RitmoArmonico(acordes.map { AcordeConDuracion($0, .blanca) })
        let analisis = try #require(PresentacionDeAnalisis.analizar(acordes, ritmo: ritmo, notacion: notacion))
        #expect(analisis.ritmo == ritmo)
        #expect(analisis.sonido != .silencio)
    }

    @Test func unContrapuntoDebajoDelCantus() throws {
        let presentado = try PresentacionDeContrapunto.presentar(
            cantus: "Do5 Re5 Mi5 Do5", contrapunto: "Do4 Si3 Do4 Do4", especie: .primera, en: notacion)
        #expect(presentado.filas.count == 4)
        #expect(presentado.filas[0].intervalos == "8")
    }
}
