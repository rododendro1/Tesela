import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// La tradición, los estilos, las escuelas y las regiones de cada escala, las listas de `listasTradicionales` y sus
/// nombres.
@Suite struct TradicionTests {
    /// Las listas de `listasTradicionales` reparten todas las escalas de otras tradiciones, cada una en la suya, y
    /// cada una dice en su declaración su categoría, su versión microtonal y, si la tiene, su escala madre.
    @Test func lasListasRepartenLasTradicionales() {
        var vistas = Set<String>()
        for lista in TipoDeEscala.listasTradicionales {
            for tipo in lista.tipos {
                #expect(vistas.insert(tipo.nombre).inserted, "\(tipo.nombre) está en dos listas")
                #expect(tipo.tradicion == lista.tradicion, Comment(rawValue: tipo.nombre))
                #expect(tipo.estilos.isEmpty, Comment(rawValue: tipo.nombre))
                for escuela in tipo.escuelas {
                    #expect(escuela.tradicion == lista.tradicion, Comment(rawValue: tipo.nombre))
                }
                #expect(tipo.ficha.categoria != nil, Comment(rawValue: tipo.nombre))
                #expect(tipo.categoria == tipo.ficha.categoria, Comment(rawValue: tipo.nombre))
                #expect(lista.tradicion != .occidental, Comment(rawValue: tipo.nombre))
                if let padre = tipo.ficha.padre {
                    // El padre es una escala del catálogo.
                    #expect(tipo.padre?.identidad == padre, Comment(rawValue: tipo.nombre))
                }
            }
        }
        #expect(vistas.count == TipoDeEscala.tradicionales.count)
        // Cada tradición, salvo la occidental, tiene al menos una lista.
        #expect(
            Set(TipoDeEscala.listasTradicionales.map(\.tradicion)) == Set(Tradicion.allCases).subtracting([.occidental])
        )
        // Las occidentales no tienen categoría, y su tradición es la occidental.
        for tipo in TipoDeEscala.occidentales {
            #expect(tipo.ficha.categoria == nil && tipo.ficha.padre == nil, Comment(rawValue: tipo.nombre))
            #expect(tipo.tradicion == .occidental, Comment(rawValue: tipo.nombre))
        }
        #expect(TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta]).tradicion == nil)
    }

    /// La tradición de la ficha casa con todo lo que la dice: su categoría, sus estilos y regiones, su fuente y las de
    /// sus afinaciones. Y cada escala del catálogo tiene una.
    @Test func laTradicionDeLaFichaCasaConSusDatos() {
        for tipo in TipoDeEscala.catalogo {
            let nombre = Comment(rawValue: tipo.nombre)
            let tradicion = tipo.ficha.tradicion
            #expect(tradicion != nil, nombre)
            if let deLaCategoria = tipo.ficha.categoria?.tradicion { #expect(deLaCategoria == tradicion, nombre) }
            if !tipo.estilos.isEmpty { #expect(tradicion == .occidental, nombre) }
            for escuela in tipo.escuelas { #expect(escuela.tradicion == tradicion, nombre) }
            if let fuente = tipo.ficha.fuente { #expect(fuente.tradicion == tradicion, nombre) }
            for afinacion in tipo.ficha.afinaciones {
                if let fuente = afinacion.fuente { #expect(fuente.tradicion == tradicion, nombre) }
            }
        }
        #expect(CategoriaTradicional.maqam.tradicion == .mundoArabe)
        #expect(CategoriaTradicional.escala.tradicion == nil)
        #expect(TipoDeEscala.hirajoshi.tradicion == .japon)
        #expect(TipoDeEscala.ionicus.tradicion == .gregoriano)
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

    /// Cada tradición tiene nombre en los trece idiomas, y en español es también su `nombre`.
    @Test func losNombresDeLasTradicionesSeTraducen() {
        for tradicion in Tradicion.allCases {
            #expect(tradicion.nombre(en: .compacta(.espanol)) == tradicion.nombre)
            for idioma in Idioma.allCases {
                #expect(
                    !tradicion.nombre(en: Notacion.compacta(.espanol).conTextos(en: idioma)).isEmpty,
                    Comment(rawValue: "\(tradicion) en \(idioma)"))
            }
        }
        #expect(Tradicion.japon.nombre(en: Notacion.compacta(.espanol).conTextos(en: .euskera)) == "Japonia")
        #expect(Tradicion.mundoArabe.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "Arab world")
    }

    /// Las escuelas y las regiones: las de la declaración, o la escuela que da la categoría (en la India).
    @Test func lasEscuelasYLasRegiones() {
        #expect(TipoDeEscala.mohanam.escuelas == [.carnatica])
        #expect(TipoDeEscala.melakarta(15)?.escuelas == [.carnatica])
        #expect(TipoDeEscala.kafi.escuelas == [.indostanica])
        #expect(TipoDeEscala.pelogTembung.regiones == [.bali])
        #expect(TipoDeEscala.pelogLima.regiones == [.java])
        #expect(TipoDeEscala.gaitaEscocesa.regiones == [.escocia])
        // El sléndro se toca en Java y en Bali.
        #expect(TipoDeEscala.slendro.regiones == [.java, .bali])
        #expect(TipoDeEscala.mayor.regiones.isEmpty)
        #expect(TipoDeEscala.dorico.estilos == [.jazz, .clasica])
        #expect(TipoDeEscala.hitzaz.escuelas.isEmpty && TipoDeEscala.hitzaz.regiones.isEmpty)
        #expect(Escuela.gagaku.tradicion == .japon)
        let mia = TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta])
        #expect(mia.estilos.isEmpty && mia.escuelas.isEmpty && mia.regiones.isEmpty)
        #expect(RegionDeEscala.java.tipos.count == 7)
        #expect(TipoDeEscala.degung.regiones == [.sunda] && RegionDeEscala.sunda.tradicion == .indonesia)
        #expect(RegionDeEscala.bali.tipos.count == 4)
        // Toda escala de la India tiene escuela, y cada estilo, cada escuela y cada región tiene alguna escala.
        for tipo in TipoDeEscala.tradicionales(tradicion: .india) {
            #expect(!tipo.escuelas.isEmpty, Comment(rawValue: tipo.nombre))
        }
        for estilo in Estilo.allCases { #expect(!estilo.tipos.isEmpty, "\(estilo)") }
        for escuela in Escuela.allCases {
            #expect(!escuela.tipos.isEmpty, "\(escuela)")
            #expect(escuela.tipos.allSatisfy { $0.tradicion == escuela.tradicion }, "\(escuela)")
        }
        for region in RegionDeEscala.allCases { #expect(!region.tipos.isEmpty, "\(region)") }
        #expect(Escuela.carnatica.nombre == "Carnática")
        #expect(Escuela.carnatica.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "Carnatic")
        #expect(RegionDeEscala.java.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ruso)) == "Ява")
    }

    /// Cada estilo, escuela y región tiene nombre en los trece idiomas y se codifica por su nombre de caso.
    @Test func losEstilosLasEscuelasYLasRegionesSeTraducenYSeCodifican() throws {
        let nombrables: [any Nombrable] = Estilo.allCases + Escuela.allCases + RegionDeEscala.allCases
        for nombrable in nombrables {
            #expect(nombrable.nombre(en: .compacta(.espanol)) == nombrable.nombre)
            for idioma in Idioma.allCases {
                #expect(
                    !nombrable.nombre(en: Notacion.compacta(.espanol).conTextos(en: idioma)).isEmpty,
                    Comment(rawValue: "\(nombrable) en \(idioma)"))
            }
        }
        for estilo in Estilo.allCases { #expect(Estilo(rawValue: estilo.rawValue) == estilo) }
        for region in RegionDeEscala.allCases { #expect(RegionDeEscala(rawValue: region.rawValue) == region) }
        let estilos = try JSONEncoder().encode(Estilo.allCases)
        #expect(String(decoding: estilos, as: UTF8.self).contains("\"deCompositor\""))
        let escuelas = try JSONEncoder().encode(Escuela.allCases)
        #expect(String(decoding: escuelas, as: UTF8.self).contains("\"indostanica\""))
        #expect(try JSONDecoder().decode([Estilo].self, from: estilos) == Estilo.allCases)
    }
}
