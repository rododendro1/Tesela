import Foundation
import Testing

@testable import ArmoniaElementos
@testable import ArmoniaTeoria

/// El teórico que definió cada escala (`FuenteTeorica`) y `tradicionales(fuente:)`.
@Suite struct FuenteTeoricaTests {
    @Test func cadaFuenteTieneSusEscalasYSuTradicion() {
        for fuente in FuenteTeorica.allCases {
            let tipos = TipoDeEscala.tradicionales(fuente: fuente)
            #expect(!tipos.isEmpty, Comment(rawValue: fuente.nombre))
            for tipo in tipos { #expect(tipo.tradicion == fuente.tradicion, Comment(rawValue: tipo.nombre)) }
        }
    }

    /// Las listas por autor del catálogo son las de su fuente, en el mismo orden.
    @Test func lasListasDeCadaAutor() {
        #expect(TipoDeEscala.tradicionales(fuente: .aristides) == TipoDeEscala.harmoniaiDeAristides)
        #expect(TipoDeEscala.tradicionales(fuente: .glareano) == TipoDeEscala.modosDeGlareano)
        #expect(TipoDeEscala.tradicionales(fuente: .guido) == TipoDeEscala.hexacordos)
        #expect(TipoDeEscala.tradicionales(fuente: .safiAlDin) == TipoDeEscala.adwar)
        #expect(
            TipoDeEscala.tradicionales(fuente: .aristoxeno)
                == TipoDeEscala.tetracordosGriegos + TipoDeEscala.coloresDeAristoxeno)
        #expect(TipoDeEscala.tradicionales(fuente: .ptolomeo).count == 7)
        #expect(TipoDeEscala.tradicionales(fuente: .arquitas).count == 3)
        #expect(TipoDeEscala.tradicionales(fuente: .didimo).count == 3)
        #expect(TipoDeEscala.tradicionales(fuente: .eratostenes).count == 2)
        // Los géneros de Arquitas, Ptolomeo, Dídimo y Eratóstenes tienen todos un autor.
        for tipo in TipoDeEscala.generosDeArquitasYPtolomeo + TipoDeEscala.generosDeDidimoYEratostenes {
            #expect(tipo.fuente != nil, Comment(rawValue: tipo.nombre))
        }
    }

    @Test func lasQueNoSonDeUnAutor() {
        #expect(TipoDeEscala.harmoniaDoria.fuente == nil)
        #expect(TipoDeEscala.protusAuthenticus.fuente == nil)
        #expect(TipoDeEscala.mayor.fuente == nil)
        #expect(TipoDeEscala.kafi.fuente == nil)
        #expect(TipoDeEscala.tetracordoDiatonicoTenso.fuente == .ptolomeo)
        #expect(TipoDeEscala.ionicus.fuente == .glareano)
        // Una escala propia con el nombre de una del catálogo pero otras notas no tiene su fuente.
        let propia = TipoDeEscala(nombre: "hexacordo duro", intervalos: [.unisono, .terceraMayor])
        #expect(propia.fuente == nil)
    }

    @Test func nombresEnLosQuinceIdiomas() {
        #expect(FuenteTeorica.ptolomeo.nombre == "Ptolomeo")
        #expect(FuenteTeorica.ptolomeo.nombre(en: .inglesASCII) == "Ptolemy")
        #expect(FuenteTeorica.aristoxeno.nombre(en: .compacta(.frances)) == "Aristoxène")
        #expect(FuenteTeorica.arquitas.nombre(en: .compacta(.ruso)) == "Архит")
        for idioma in Idioma.allCases {
            let nombres = FuenteTeorica.allCases.map { $0.nombre(en: .delIdioma(idioma)) }
            #expect(Set(nombres).count == nombres.count, "\(idioma)")
            #expect(nombres.allSatisfy { !$0.isEmpty }, "\(idioma)")
        }
    }

    @Test func seCodificaComoSuCaso() throws {
        let datos = try JSONEncoder().encode(FuenteTeorica.safiAlDin)
        #expect(String(decoding: datos, as: UTF8.self) == "\"safiAlDin\"")
    }
}
