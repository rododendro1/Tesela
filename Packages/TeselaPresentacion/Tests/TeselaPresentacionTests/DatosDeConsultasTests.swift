import Armonia
import Foundation
import Testing

@testable import TeselaPresentacion

// Los datos que comparten el texto de `armonia`, su `--json` y las apps.

@Suite struct DatosDeConsultasTests {
    @Test func unAcordeInvertido() {
        let datos = DatosDeAcorde(Acorde("Sol7/Si"), notacion: .espanolCompacto)
        #expect(datos.cifrado == "Sol7/Si")
        #expect(datos.fundamental == "Sol")
        #expect(datos.bajo == "Si")
        #expect(datos.inversion == 1)
        #expect(datos.tieneOtroBajo)
        #expect(datos.clases.count == 4)
        #expect(datos.componentes.count == datos.notas.count)
        #expect(!DatosDeAcorde(Acorde("Do"), notacion: .espanolCompacto).tieneOtroBajo)
    }

    @Test func losAcordesDeUnasNotas() throws {
        let candidatos = try DatosDeCandidato.identificar(["Do", "Mi", "Sol", "Sib"], notacion: .espanolCompacto)
        #expect(candidatos.first?.cifrado == "Do7")
        #expect(candidatos.count <= 5)
        let enIngles = try DatosDeCandidato.identificar(["Do", "Mi", "Sol", "Sib"], limite: 1, notacion: .inglesASCII)
        #expect(enIngles.map(\.cifrado) == ["C7"])
    }

    @Test func unaEscalaConLosAcordesDeSusGrados() throws {
        let datos = DatosDeEscala(try Escala(leyendo: "Re dórico"), notacion: .espanolCompacto)
        #expect(datos.notas.count == 7)
        #expect(datos.acordes?.count == 7)
        #expect(datos.acordes?.first?.cifrado == "Rem7")
    }

    @Test func unConjunto() {
        let datos = DatosDeConjunto(ConjuntoDeClasesDeAltura([0, 4, 7]), notacion: .espanolCompacto)
        #expect(datos.forte == "3-11")
        #expect(datos.formaPrima == [0, 3, 7])
        // El análisis postonal de las apps sale de los mismos datos.
        let presentado = AnalisisPostonalPresentado(datos)
        #expect(presentado == AnalisisPostonalPresentado(clases: [0, 4, 7]))
        #expect(presentado.formaPrima == "(0, 3, 7)")
    }

    @Test func unaSerieComoLaVeLaApp() throws {
        let serie = try SerieDodecafonica(leyendo: "5 4 0 9 7 2 8 1 3 6 t e")
        let datos = DatosDeSerie(serie, notacion: .espanolCompacto)
        #expect(datos.matriz.count == 12)
        #expect(datos.notas.count == 12)
        let presentada = try PresentacionDeSerie.presentar(
            "5 4 0 9 7 2 8 1 3 6 t e", forma: FormaDeSerie(.original, 5), notacion: .espanolCompacto)
        #expect(presentada.matriz == datos.matriz)
        #expect(presentada.datos.first?.valor == datos.notas.joined(separator: " "))
        #expect(presentada.nombresDeLasClases == ConjuntoDeClasesDeAltura.nombresDeLasClases(en: .espanolCompacto))
    }

    @Test func seLeenComoSeEscriben() throws {
        let escala = DatosDeEscala(try Escala(leyendo: "Do mayor"), notacion: .espanolCompacto)
        let datos = try JSONEncoder().encode(escala)
        #expect(try JSONDecoder().decode(DatosDeEscala.self, from: datos) == escala)
        // Lo que es `nil` no sale.
        let pentatonica = DatosDeEscala(try Escala(leyendo: "Do pentatónica mayor"), notacion: .espanolCompacto)
        #expect(pentatonica.acordes == nil)
        #expect(!String(decoding: try JSONEncoder().encode(pentatonica), as: UTF8.self).contains("\"acordes\""))
    }
}
