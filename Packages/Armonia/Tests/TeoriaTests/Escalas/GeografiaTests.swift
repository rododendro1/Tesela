import Testing

@testable import Elementos
@testable import Teoria

@Suite struct GeografiaTests {
    /// Las populares occidentales que vienen de un lugar lo llevan en su declaración.
    @Test func lasPopularesTienenSuRegion() {
        #expect(TipoDeEscala.flamenca.regionesDeOrigen == [.andalucia])
        #expect(TipoDeEscala.mayorRumana.regionesDeOrigen == [.rumania])
        #expect(TipoDeEscala.menorHungara.regionesDeOrigen == [.hungria])
        #expect(TipoDeEscala.mayorHungara.regionesDeOrigen == [.hungria])
        #expect(TipoDeEscala.pentatonicaEscocesa.regionesDeOrigen == [.escocia])
        // Su ficha no cambia: siguen siendo occidentales, sin región.
        #expect(TipoDeEscala.flamenca.regiones.isEmpty && TipoDeEscala.flamenca.tradicion == .occidental)
        #expect(RegionDeEscala.andalucia.tradicion == .europa)
        #expect(RegionDeEscala.andalucia.tipos == [.flamenca])
        #expect(RegionDeEscala.hungria.tipos.contains(.menorHungara))
        #expect(RegionDeEscala.hungria.tipos.contains(.pentatonicaHungara))
        for (tipo, _) in TipoDeEscala.regionesDeLasPopulares {
            #expect(tipo.estilos == [.popular], Comment(rawValue: tipo.nombre))
        }
    }

    /// Las occidentales toman además las regiones de las europeas con sus mismas notas.
    @Test func lasOccidentalesTomanLasDeLasEuropeas() {
        #expect(TipoDeEscala.doricoCuartaAumentada == .doricoUcraniano)
        #expect(TipoDeEscala.doricoCuartaAumentada.regionesDeOrigen == [.ucrania, .rumania])
        #expect(TipoDeEscala.doricoUcraniano.regionesDeOrigen == [.ucrania])
        // Solo las populares: el dórico tiene las notas de la georgiana, y la pentatónica menor las de la húngara.
        #expect(TipoDeEscala.mayor.regionesDeOrigen.isEmpty)
        #expect(TipoDeEscala.dorico.regionesDeOrigen.isEmpty)
        #expect(TipoDeEscala.pentatonicaMenor.regionesDeOrigen.isEmpty)
        #expect(TipoDeEscala.slendro.regionesDeOrigen == [.java, .bali])
    }

    /// La persa, la egipcia, la oriental y las napolitanas no vienen de donde dice su nombre: no tienen región.
    @Test func losNombresGeograficosSinOrigen() {
        for tipo in TipoDeEscala.nombresGeograficosSinOrigen {
            #expect(tipo.nombreGeograficoSinOrigen, Comment(rawValue: tipo.nombre))
            #expect(tipo.regionesDeOrigen.isEmpty, Comment(rawValue: tipo.nombre))
            #expect(TipoDeEscala.occidentales.contains { $0.esIdentico(a: tipo) }, Comment(rawValue: tipo.nombre))
        }
        #expect(!TipoDeEscala.flamenca.nombreGeograficoSinOrigen)
        #expect(!TipoDeEscala(nombre: "persa", intervalos: [.unisono, .quintaJusta]).nombreGeograficoSinOrigen)
    }

    /// Las regiones nuevas tienen nombre en los trece idiomas.
    @Test func nombres() {
        #expect(RegionDeEscala.andalucia.nombre == "Andalucía")
        #expect(RegionDeEscala.rumania.nombre(en: .delIdioma(.aleman)) == "Rumänien")
        for idioma in Idioma.allCases {
            #expect(!RegionDeEscala.andalucia.nombre(en: .delIdioma(idioma)).isEmpty)
            #expect(!RegionDeEscala.rumania.nombre(en: .delIdioma(idioma)).isEmpty)
        }
    }

    /// Las occidentales con región de origen son las seis de `regionesDeLasPopulares`.
    @Test func recuento() {
        let conRegion = TipoDeEscala.occidentales.filter { !$0.regionesDeOrigen.isEmpty }
        #expect(conRegion.map(\.nombre).sorted() == TipoDeEscala.regionesDeLasPopulares.map(\.tipo.nombre).sorted())
    }
}
