import Armonia
import Testing

@testable import Exposicion

// Los títulos de las secciones de la hoja de una escala y de las redes de notas, que enseñan las apps.

@Suite struct NombresDeLasSeccionesTests {
    @Test func cadaSeccionDeLaHojaTieneSuTitulo() {
        let nombres = SeccionDeLaHoja.allCases.map { $0.nombre(en: .compacta(.espanol)) }
        #expect(nombres.first == "Pentagrama")
        #expect(Set(nombres).count == SeccionDeLaHoja.allCases.count)
        #expect(nombres.allSatisfy { !$0.isEmpty })
    }

    @Test func cadaRedTieneSuNombre() {
        for notacion in [Notacion.compacta(.espanol), .ascii(.ingles)] {
            let nombres = RedDeNotas.allCases.map { $0.nombre(en: notacion) }
            #expect(Set(nombres).count == RedDeNotas.allCases.count)
            #expect(nombres.allSatisfy { !$0.isEmpty })
        }
    }
}
