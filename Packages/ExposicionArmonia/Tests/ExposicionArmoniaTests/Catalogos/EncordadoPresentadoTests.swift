import Armonia
import Foundation
import Testing

@testable import ExposicionArmonia

@Suite struct EncordadoPresentadoTests {
    /// El charango, con sus órdenes dobles, el tercero en octavas, y su ficha.
    @Test func charango() throws {
        let notacion = Notacion.compacta(.espanol)
        let charango = EncordadoPresentado(.charango, en: notacion)
        #expect(charango.nombre == "charango" && charango.alias.isEmpty)
        #expect(charango.ordenes == 5 && charango.cuerdasReales == 10 && charango.cuerdasPorOrden == [2, 2, 2, 2, 2])
        #expect(charango.ordenesEnOctavas == ["3": ["Mi₅", "Mi₄"]])
        #expect(charango.trastesId == "cromaticos" && charango.reentrante)
        #expect(charango.cuerdas(en: notacion) == "5 órdenes, 10 cuerdas")
        #expect(charango.familia == "ukeleles y guitarras pequeñas" && charango.familiaId == "guitarrasPequenas")
        let ficha = charango.ficha(en: notacion)
        #expect(ficha[0] == DatoPresentado(nombre: "Familia", valor: "ukeleles y guitarras pequeñas"))
        #expect(ficha.contains(DatoPresentado(nombre: "Órdenes en octavas", valor: "3: Mi₅ Mi₄")), "\(ficha)")
        #expect(ficha.contains(DatoPresentado(nombre: "Trastes", valor: "cromáticos")))
        let json = try JSONEncoder().encode(charango)
        #expect(try JSONDecoder().decode(EncordadoPresentado.self, from: json) == charango)
    }

    /// La guitarra, de una cuerda por orden, sin octavas; el dulcémele, diatónico; el ud, sin trastes.
    @Test func guitarraDulcemeleYUd() {
        let notacion = Notacion.compacta(.espanol)
        let guitarra = EncordadoPresentado(.guitarra, en: notacion)
        #expect(guitarra.cuerdas(en: notacion) == "6" && guitarra.ordenesEnOctavas.isEmpty)
        #expect(!guitarra.ficha(en: notacion).contains { $0.nombre == "Órdenes en octavas" })
        #expect(EncordadoPresentado(.dulcemele, en: notacion).trastes == "diatónicos")
        let ud = EncordadoPresentado(.ud, en: .compacta(.ingles))
        let inventado = EncordadoPresentado(Encordado(nombre: "x", afinacion: [Altura(.do, octava: 3)]), en: notacion)
        #expect(inventado.familia == nil && inventado.ficha(en: notacion)[0].nombre == "Afinación")
        #expect(ud.trastes == "fretless" && ud.cuerdas(en: .compacta(.ingles)) == "6 courses, 11 strings")
    }
}

@Suite struct OrnamentoPresentadoTests {
    /// El grupeto, solo y sobre Re4 en Do mayor, y fuera de la escala.
    @Test func grupeto() throws {
        let notacion = Notacion.compacta(.espanol)
        let solo = OrnamentoPresentado(.grupeto, en: notacion)
        #expect(solo.nombre == "grupeto" && solo.pasos == [1, 0, -1, 0] && solo.alturas == nil)
        #expect(solo.textoDeLosPasos == "+1 0 −1 0")
        #expect(!solo.ficha(en: notacion).contains { $0.nombre == "Suena" })
        let sobreRe = OrnamentoPresentado(.grupeto, sobre: Altura(.re, octava: 4), escala: Escala(.do), en: notacion)
        #expect(sobreRe.alturas == ["Mi₄", "Re₄", "Do₄", "Re₄"])
        #expect(sobreRe.ficha(en: notacion)[1] == DatoPresentado(nombre: "Suena", valor: "Mi₄ Re₄ Do₄ Re₄"))
        let fuera = OrnamentoPresentado(
            .grupeto, sobre: Altura(Nota(.re, .sostenido), octava: 4), escala: Escala(.do), en: notacion)
        #expect(fuera.alturas == nil)
        let json = try JSONEncoder().encode(sobreRe)
        #expect(try JSONDecoder().decode(OrnamentoPresentado.self, from: json) == sobreRe)
        #expect(OrnamentoPresentado(.schleifer, en: notacion).textoDeLosPasos == "−2 −1 0")
    }
}
