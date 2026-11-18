import Foundation
import Testing

@testable import Elementos
@testable import Teoria
@testable import Trastes

/// La ficha de cada instrumento del catálogo (`Encordado+Catalogo.swift`).
@Suite struct EncordadoDelCatalogoTests {
    /// Cada encordado de `todos` tiene ficha, con una cifra de cuerdas por orden y una referencia.
    @Test func cadaInstrumentoTieneFicha() {
        #expect(Set(Encordado.todos).count == Encordado.todos.count)
        #expect(Set(Encordado.fichas.keys) == Set(Encordado.todos))
        for encordado in Encordado.todos {
            #expect(encordado.ficha != nil, "\(encordado)")
            #expect(encordado.cuerdasPorOrden.count == encordado.numeroDeCuerdas, "\(encordado)")
            #expect(encordado.cuerdasPorOrden.allSatisfy { (1...3).contains($0) }, "\(encordado)")
            #expect(!encordado.referencias.isEmpty, "\(encordado)")
        }
        // Las obras que solo citan los encordados (`ReferenciasTests.citadasPorLosEncordados`), y que están en el
        // catálogo de obras.
        let citadas = Set(Encordado.todos.flatMap(\.referencias).map(\.clave))
        #expect(citadas == ["sadie1984", "milan1536"])
        #expect(citadas.isSubset(of: Set(Referencia.catalogo.map(\.clave))))
    }

    /// Las cuerdas reales, los trastes y el origen de algunos.
    /// Los otros nombres con los que se busca, que encuentran el instrumento.
    @Test func otrosNombres() {
        #expect(Encordado.ukelele.otrosNombres == ["ukelele soprano", "ukulele", "ukulele soprano"])
        #expect(Encordado.guitarraDeSieteCuerdas.otrosNombres.contains("seven string guitar"))
        for encordado in Encordado.todos {
            #expect(encordado.otrosNombres.allSatisfy { Encordado.buscar(nombre: $0) == encordado }, "\(encordado)")
        }
    }

    @Test func fichas() {
        #expect(Encordado.guitarra.cuerdasReales == 6 && Encordado.guitarra.trastes == .cromaticos)
        #expect(Encordado.mandolina.cuerdasReales == 8)
        #expect(Encordado.bandurria.cuerdasReales == 12)
        #expect(Encordado.ud.cuerdasReales == 11 && Encordado.ud.trastes == .sinTrastes)
        #expect(Encordado.ud.tradicion == .mundoArabe)
        #expect(Encordado.violin.trastes == .sinTrastes)
        #expect(Encordado.dulcemele.trastes == .diatonicos)
        #expect(Encordado.charango.tradicion == .andes && Encordado.charango.cuerdasReales == 10)
        #expect(Encordado.tresCubano.paisesDeOrigen == [.cuba])
        #expect(Encordado.tresCubano.continentesDeOrigen == [.america])
        #expect(Encordado.vihuela.anioDeOrigen == 1536)
        #expect(Encordado.bajoElectrico.anioDeOrigen == 1951)
        #expect(Encordado.bajoElectrico.epocaDeOrigen == .sigloXX)
        #expect(Encordado.violin.estilos.first == .clasica)
        #expect(Encordado.tresCubano.lugaresDeOrigen == [.pais(.cuba)])
        #expect(Encordado.mandolina.conCapo(2).cuerdasReales == 8)
    }

    /// El violín y la viola van por quintas, el contrabajo por cuartas.
    @Test func afinaciones() {
        #expect(Encordado.violin.afinacion.map(\.midi) == [55, 62, 69, 76])
        #expect(Encordado.viola.afinacion.map(\.midi) == [48, 55, 62, 69])
        #expect(Encordado.violonchelo.afinacion.map(\.midi) == [36, 43, 50, 57])
        #expect(Encordado.contrabajo.afinacion.map(\.midi) == [28, 33, 38, 43])
    }
}
