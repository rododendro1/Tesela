import Armonia
import Foundation
import Testing

@testable import Exposicion

@Suite struct PresentacionDeRitmoTests {
    /// La ficha y las medidas de la clave de son, escritas.
    @Test func claveDeSon() throws {
        let notacion = Notacion.compacta(.espanol)
        let clave = RitmoPresentado(.claveDeSon, en: notacion)
        #expect(clave.nombre == "clave de son")
        #expect(clave.compas == "4/4")
        #expect(clave.patron == "x..x..x...x.x...")
        let ficha = clave.ficha(en: notacion)
        #expect(ficha.map(\.valor) == ["líneas de tiempo", "clave 3-2", "x..x..x...x.x...", "4 + 4 + 4 + 4", "4/4"])
        let datos = clave.datos(en: notacion)
        #expect(datos.first == DatoPresentado(nombre: "Pulsos · golpes · fuertes", valor: "16 · 5 · 5"))
        #expect(datos.contains(DatoPresentado(nombre: "Intervalos", valor: "[3, 3, 4, 2, 4]")))
        #expect(datos.contains(DatoPresentado(nombre: "Vector de distancias", valor: "[0, 1, 2, 2, 0, 3, 2, 0]")))
        #expect(!datos.contains { $0.nombre == "Propiedades" })
        let json = try JSONEncoder().encode(clave)
        #expect(try JSONDecoder().decode(RitmoPresentado.self, from: json) == clave)
    }

    /// Las propiedades salen solo si las tiene: el tresillo es euclídeo; el shiko, profundo.
    @Test func propiedades() {
        let notacion = Notacion.compacta(.ingles)
        let tresillo = RitmoPresentado(.tresillo, en: notacion).datos(en: notacion)
        #expect(tresillo.contains { $0.valor.contains("Euclidean") })
        let shiko = RitmoPresentado(.shiko, en: notacion).datos(en: notacion)
        #expect(shiko.contains { $0.valor.contains("deep") })
    }

    /// Las distancias, solo cuando se pueden medir.
    @Test func relacion() {
        let notacion = Notacion.compacta(.espanol)
        let rumba = RelacionEntreRitmosPresentada(.claveDeSon, con: .claveDeRumba, en: notacion)
        #expect(rumba.con == "clave de rumba")
        #expect(rumba.datos(en: notacion).map(\.valor) == ["2", "1"])
        let tresillo = RelacionEntreRitmosPresentada(.claveDeSon, con: .tresillo, en: notacion)
        #expect(tresillo.distanciaDeHamming == nil && tresillo.datos(en: notacion).isEmpty)
    }
}
