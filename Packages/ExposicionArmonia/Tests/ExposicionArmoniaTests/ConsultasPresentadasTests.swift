import Armonia
import Foundation
import Testing

@testable import ExposicionArmonia

// Los datos que comparten el texto de `armonia`, su `--json` y las apps.

@Suite struct ConsultasPresentadasTests {
    @Test func unAcordeInvertido() {
        let datos = AcordePresentado(Acorde("Sol7/Si"), en: .compacta(.espanol))
        #expect(datos.cifrado == "Sol7/Si")
        #expect(datos.fundamental == "Sol")
        #expect(datos.bajo == "Si")
        #expect(datos.inversion == 1)
        #expect(datos.tieneOtroBajo)
        #expect(datos.clases.count == 4)
        #expect(datos.componentes.count == datos.notas.count)
        #expect(!AcordePresentado(Acorde("Do"), en: .compacta(.espanol)).tieneOtroBajo)
    }

    @Test func losAcordesDeUnasNotas() throws {
        let candidatos = try CandidatoPresentado.identificar(["Do", "Mi", "Sol", "Sib"], en: .compacta(.espanol))
        #expect(candidatos.first?.cifrado == "Do7")
        #expect(candidatos.count <= 5)
        let enIngles = try CandidatoPresentado.identificar(["Do", "Mi", "Sol", "Sib"], limite: 1, en: .ascii(.ingles))
        #expect(enIngles.map(\.cifrado) == ["C7"])
    }

    @Test func unaEscalaConLosAcordesDeSusGrados() throws {
        let datos = EscalaPresentada(try Escala(leyendo: "Re dórico"), en: .compacta(.espanol))
        #expect(datos.notas.count == 7)
        #expect(datos.acordes?.count == 7)
        #expect(datos.acordes?.first?.cifrado == "Rem7")
    }

    @Test func unaTonalidadConSuArmaduraYSusAcordes() throws {
        let datos = TonalidadPresentada(try Tonalidad(leyendo: "Fa mayor"), en: .compacta(.espanol))
        #expect(datos.tonica == "Fa")
        #expect(datos.modo == "mayor")
        #expect(datos.armadura == -1)
        #expect(datos.alteraciones == ["Si♭"])
        #expect(datos.clases.first == 5)
        #expect(datos.relativa == "Re menor")
        #expect(datos.acordes.map(\.grado).count == 7)
        #expect(datos.acordes.first?.cifrado == "Famaj7")
        let menor = TonalidadPresentada(try Tonalidad(leyendo: "La menor"), en: .compacta(.espanol))
        #expect(menor.modo == "menor")
        #expect(menor.armadura == 0 && menor.alteraciones.isEmpty)
    }

    @Test func unIntervaloCompuestoYUnoDescendente() {
        let decima = IntervaloPresentado(Altura(.mi, octava: 5) - Altura(.do, octava: 4), en: .compacta(.espanol))
        #expect(decima.numero == 10)
        #expect(decima.semitonos == 16)
        #expect(!decima.descendente)
        #expect(
            IntervaloPresentado(Altura(.do, octava: 4) - Altura(.sol, octava: 4), en: .compacta(.espanol)).descendente)
    }

    @Test func unArpegioConSuPatronOSuRecorrido() {
        let notacion = Notacion.compacta(.espanol)
        let ascendente = NotasDeArpegioPresentadas(Arpegio(Acorde("Do"), patron: .ascendente), en: notacion)
        #expect(ascendente.acorde == "Do")
        #expect(ascendente.notas.first == "Do₄")
        #expect(ascendente.midi.first == 60)
        #expect(ascendente.notas.count == ascendente.midi.count)
        #expect(ascendente.recorrido == Arpegio.Patron.ascendente.nombre(en: notacion))
        #expect(!ascendente.escalas.isEmpty)
        let propio = NotasDeArpegioPresentadas(Arpegio(Acorde("Do"), grados: [1, 5, 3, 8]), en: notacion)
        #expect(propio.recorrido == "1-5-3-8")
    }

    @Test func unConjunto() {
        let datos = ConjuntoPresentado(ConjuntoDeClasesDeAltura([0, 4, 7]), en: .compacta(.espanol))
        #expect(datos.forte == "3-11")
        #expect(datos.formaPrima == [0, 3, 7])
        // El análisis postonal de las apps sale de los mismos datos.
        let presentado = AnalisisPostonalPresentado(datos)
        #expect(presentado == AnalisisPostonalPresentado(clases: [0, 4, 7]))
        #expect(presentado.formaPrima == "(0, 3, 7)")
    }

    @Test func unaSerieComoLaVeLaApp() throws {
        let serie = try SerieDodecafonica(leyendo: "5 4 0 9 7 2 8 1 3 6 t e")
        let datos = SeriePresentada(serie, en: .compacta(.espanol))
        #expect(datos.matriz.count == 12)
        #expect(datos.notas.count == 12)
        let presentada = try PresentacionDeSerie.presentar(
            "5 4 0 9 7 2 8 1 3 6 t e", forma: FormaDeSerie(.original, 5), en: .compacta(.espanol))
        #expect(presentada.matriz == datos.matriz)
        #expect(presentada.datos.first?.valor == datos.notas.joined(separator: " "))
        #expect(presentada.nombresDeLasClases == ConjuntoDeClasesDeAltura.nombresDeLasClases(en: .compacta(.espanol)))
    }

    @Test func seLeenComoSeEscriben() throws {
        let escala = EscalaPresentada(try Escala(leyendo: "Do mayor"), en: .compacta(.espanol))
        let datos = try JSONEncoder().encode(escala)
        #expect(try JSONDecoder().decode(EscalaPresentada.self, from: datos) == escala)
        // Lo que es `nil` no sale.
        let pentatonica = EscalaPresentada(try Escala(leyendo: "Do pentatónica mayor"), en: .compacta(.espanol))
        #expect(pentatonica.acordes == nil)
        #expect(!String(decoding: try JSONEncoder().encode(pentatonica), as: UTF8.self).contains("\"acordes\""))
    }
}
