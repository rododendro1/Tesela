import Foundation
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// La tradición y la subtradición de cada escala, las listas de `listasTradicionales` y sus nombres.
@Suite struct TradicionTests {
    /// Las listas de `listasTradicionales` reparten todas las escalas de otras tradiciones, cada una en la suya, y
    /// cada una dice en su declaración su categoría, su versión microtonal y, los janya, su mēḷa.
    @Test func lasListasRepartenLasTradicionales() {
        var vistas = Set<String>()
        for lista in TipoDeEscala.listasTradicionales {
            for tipo in lista.tipos {
                #expect(vistas.insert(tipo.nombre).inserted, "\(tipo.nombre) está en dos listas")
                #expect(tipo.tradicion == lista.tradicion, Comment(rawValue: tipo.nombre))
                if let subtradicion = tipo.subtradicion {
                    #expect(subtradicion.tradicion == lista.tradicion, Comment(rawValue: tipo.nombre))
                }
                #expect(tipo.ficha.categoria != nil, Comment(rawValue: tipo.nombre))
                #expect(tipo.categoria == tipo.ficha.categoria, Comment(rawValue: tipo.nombre))
                #expect(tipo.ficha.usos.isEmpty, Comment(rawValue: tipo.nombre))
                if let mela = tipo.ficha.mela {
                    #expect(tipo.categoria == .janya, Comment(rawValue: tipo.nombre))
                    #expect(tipo.padre == TipoDeEscala.melakarta(mela), Comment(rawValue: tipo.nombre))
                }
            }
        }
        #expect(vistas.count == TipoDeEscala.tradicionales.count)
        // Cada tradición tiene al menos una lista.
        #expect(Set(TipoDeEscala.listasTradicionales.map(\.tradicion)) == Set(Tradicion.allCases))
        // Las occidentales no tienen categoría ni tradición.
        for tipo in TipoDeEscala.occidentales {
            #expect(tipo.ficha.categoria == nil && tipo.ficha.mela == nil, Comment(rawValue: tipo.nombre))
            #expect(tipo.tradicion == nil, Comment(rawValue: tipo.nombre))
        }
    }

    /// El catálogo son las occidentales y después las de otras tradiciones, y su orden decide quién gana.
    @Test func catalogoConPrioridad() {
        let todas = TipoDeEscala.occidentales + TipoDeEscala.tradicionales
        #expect(TipoDeEscala.catalogo.map(\.nombre) == todas.map(\.nombre))
        #expect(TipoDeEscala.propio(TipoDeEscala.bilaval.intervalos).nombre == "mayor")
        #expect(TipoDeEscala.propio(TipoDeEscala.hiyaz.intervalos).nombre == TipoDeEscala.frigioDominante.nombre)
        #expect((try? TipoDeEscala(leyendo: "Hijaz"))?.nombre == TipoDeEscala.hiyaz.nombre)
        #expect(TipoDeEscala.bilaval.equivalentes.first?.nombre == "mayor")
    }

    /// Cada tradición tiene nombre en los quince idiomas, y en español es también su `nombre`.
    @Test func losNombresDeLasTradicionesSeTraducen() {
        for tradicion in Tradicion.allCases {
            #expect(tradicion.nombre(en: .espanolCompacto) == tradicion.nombre)
            for idioma in Idioma.allCases {
                #expect(
                    !tradicion.nombre(en: Notacion.espanolCompacto.conTextos(en: idioma)).isEmpty,
                    Comment(rawValue: "\(tradicion) en \(idioma)"))
            }
        }
        #expect(Tradicion.japon.nombre(en: Notacion.espanolCompacto.conTextos(en: .euskera)) == "Japonia")
        #expect(Tradicion.mundoArabe.nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles)) == "Arab world")
    }

    /// La subtradición: la de la declaración o la que da la categoría (en la India).
    @Test func laSubtradicion() {
        #expect(TipoDeEscala.mohanam.subtradicion == .carnatica)
        #expect(TipoDeEscala.melakarta(15)?.subtradicion == .carnatica)
        #expect(TipoDeEscala.kafi.subtradicion == .indostanica)
        #expect(TipoDeEscala.pelogTembung.subtradicion == .bali)
        #expect(TipoDeEscala.pelogLima.subtradicion == .java)
        #expect(TipoDeEscala.gaitaEscocesa.subtradicion == .escocia)
        #expect(TipoDeEscala.slendro.subtradicion == nil)
        #expect(TipoDeEscala.hitzaz.subtradicion == nil)
        #expect(TipoDeEscala.mayor.subtradicion == nil)
        #expect(TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta]).subtradicion == nil)
        #expect(TipoDeEscala.tradicionales(subtradicion: .java).count == 6)
        #expect(TipoDeEscala.degung.subtradicion == .sunda && Subtradicion.sunda.tradicion == .indonesia)
        #expect(TipoDeEscala.tradicionales(subtradicion: .bali).count == 3)
        // Toda escala de la India tiene subtradición, y cada subtradición tiene alguna escala.
        for tipo in TipoDeEscala.tradicionales(tradicion: .india) {
            #expect(tipo.subtradicion != nil, Comment(rawValue: tipo.nombre))
        }
        for subtradicion in Subtradicion.allCases {
            #expect(!TipoDeEscala.tradicionales(subtradicion: subtradicion).isEmpty, "\(subtradicion)")
        }
        #expect(Subtradicion.carnatica.nombre == "Carnática")
        #expect(Subtradicion.carnatica.nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles)) == "Carnatic")
        #expect(Subtradicion.java.nombre(en: Notacion.espanolCompacto.conTextos(en: .ruso)) == "Ява")
    }

    /// Cada subtradición tiene nombre en los quince idiomas y se codifica por su nombre de caso.
    @Test func lasSubtradicionesSeTraducenYSeCodifican() throws {
        for subtradicion in Subtradicion.allCases {
            #expect(subtradicion.nombre(en: .espanolCompacto) == subtradicion.nombre)
            for idioma in Idioma.allCases {
                #expect(
                    !subtradicion.nombre(en: Notacion.espanolCompacto.conTextos(en: idioma)).isEmpty,
                    Comment(rawValue: "\(subtradicion) en \(idioma)"))
            }
            #expect(Subtradicion(rawValue: subtradicion.rawValue) == subtradicion)
        }
        let datos = try JSONEncoder().encode(Subtradicion.allCases)
        #expect(String(decoding: datos, as: UTF8.self).contains("\"indostanica\""))
        #expect(try JSONDecoder().decode([Subtradicion].self, from: datos) == Subtradicion.allCases)
    }
}
