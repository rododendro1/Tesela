import Armonia
import Foundation
import Testing

@testable import Exposicion

@Suite struct TemperamentoPresentadoTests {
    /// La ficha y las medidas del mesotónico de ¼ de coma, escritas.
    @Test func mesotonico() throws {
        let notacion = Notacion.compacta(.espanol)
        let meso = TemperamentoPresentado(.mesotonicoCuartoDeComa, en: notacion)
        #expect(meso.nombre == "mesotónico de 1/4 de coma")
        #expect(
            meso.ficha(en: notacion).map(\.valor) == [
                "temperamentos regulares", "Pietro Aron", "mesotónico", "Renacimiento (1523)", "12", "696.578",
            ])
        let datos = meso.datos(en: notacion)
        #expect(datos.contains(DatoPresentado(nombre: "Quinta del lobo", valor: "737.637")))
        #expect(
            datos.contains(DatoPresentado(nombre: "Tercera mayor más pura · más lejana", valor: "386.314 · 427.373")))
        let errores = try #require(datos.first { $0.nombre == "Error de las razones justas" })
        #expect(errores.valor.hasPrefix("3/2: −5.377 · 5/4: 0 · "), Comment(rawValue: errores.valor))
        #expect(datos.contains { $0.nombre == "Desviaciones del igual" && $0.valor.hasPrefix("0 −23.9") })
        let json = try JSONEncoder().encode(meso)
        #expect(try JSONDecoder().decode(TemperamentoPresentado.self, from: json) == meso)
    }

    /// Los de pasos iguales lo dicen, y los que no tienen doce notas no dan quintas ni terceras.
    @Test func pasosIguales() {
        let notacion = Notacion.compacta(.ingles)
        let comas = TemperamentoPresentado(.comas53, en: notacion)
        #expect(comas.quintas == nil && comas.quinta == nil && comas.autor == "Hüseyin Sadettin Arel")
        let datos = comas.datos(en: notacion)
        #expect(datos.first?.valor == "22.642 (equal steps)")
        #expect(datos.count == 2)
        #expect(comas.ficha(en: notacion).count == 4) // con «53 comas» en otros nombres
        let werckmeister = TemperamentoPresentado(.werckmeisterIII, en: notacion).datos(en: notacion)
        #expect(werckmeister.first?.valor == "90.225 · 107.82")
    }

    @Test func reloj() throws {
        let werckmeister = try #require(TemperamentoPresentado.reloj(de: .werckmeisterIII, en: .compacta(.espanol)))
        #expect(werckmeister.contains("<title>Werckmeister III · Círculo cromático</title>"))
        let quintas = try #require(
            TemperamentoPresentado.reloj(de: .divisiones31, quintas: true, colores: true, en: .ascii(.ingles)))
        #expect(quintas.contains("Circle of fifths</title>") && quintas.contains(">18</text>"))
        #expect(TemperamentoPresentado.reloj(de: .vallotti, quintas: true, en: .compacta(.espanol)) == nil)
    }
}
