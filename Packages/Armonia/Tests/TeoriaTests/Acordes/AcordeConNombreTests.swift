import Testing

@testable import Elementos
@testable import Teoria

@Suite struct AcordeConNombreTests {
    /// Cada acorde del catálogo se lee por terceras y tiene un nombre que no se repite.
    @Test func catalogo() {
        let catalogo = AcordeConNombre.catalogo
        #expect(catalogo.count == 31)
        #expect(Set(catalogo.map(\.nombre)).count == catalogo.count)
        #expect(Set(catalogo).count == catalogo.count)
        for acorde in catalogo {
            #expect(acorde.tipo != nil, "\(acorde.nombre)")
            #expect(acorde.intervalos.first == .unisono, "\(acorde.nombre)")
        }
    }

    /// Los tipos predefinidos de `TipoDeAcorde` tienen todos su acorde con nombre, con sus mismas notas.
    @Test func desdeElTipo() throws {
        for tipo in TipoDeAcorde.todos {
            let acorde = try #require(tipo.acordeConNombre, "\(tipo)")
            #expect(acorde.tipo == tipo)
        }
        #expect(TipoDeAcorde.dominanteSeptima.acordeConNombre == .dominanteSeptima)
        #expect(TipoDeAcorde.mayorSextaNovena.acordeConNombre == .mayorSextaNovena)
        #expect(try TipoDeAcorde(leyendo: "7(b9,#11)").acordeConNombre == nil)
        #expect(try TipoDeAcorde(leyendo: "7(b9)").acordeConNombre == .dominanteNovenaMenor)
        #expect(try TipoDeAcorde(leyendo: "m13").acordeConNombre == .menorSeptimaDecimotercera)
    }

    /// Cada fichero de idioma da todos los acordes del catálogo, una sola vez y sin repetir nombres.
    @Test func nombresEnTodosLosIdiomas() {
        let catalogo = AcordeConNombre.catalogo
        for idioma in Idioma.allCases {
            let nombres = NombresDeAcordes.de(idioma)
            #expect(nombres.filas.count == catalogo.count, "\(idioma)")
            #expect(Set(nombres.filas.map(\.acorde)) == Set(catalogo), "\(idioma)")
            let escritos = catalogo.compactMap { nombres.nombre(de: $0) }
            #expect(escritos.count == catalogo.count, "\(idioma)")
            #expect(escritos.allSatisfy { !$0.isEmpty }, "\(idioma)")
            #expect(Set(escritos).count == catalogo.count, "\(idioma)")
        }
    }

    /// El nombre del tipo es el de su acorde con nombre, en cada idioma.
    @Test func nombreDelTipo() {
        for acorde in AcordeConNombre.catalogo {
            for idioma in Idioma.allCases {
                let notacion = Notacion.conPalabras(idioma)
                #expect(acorde.tipo?.nombre(en: notacion) == acorde.nombre(en: notacion), "\(acorde) en \(idioma)")
            }
        }
        #expect(AcordeConNombre.dominanteSeptima.nombre(en: .conPalabras(.ingles)) == "dominant seventh")
        #expect(AcordeConNombre.dominanteSeptima.nombre(en: .conPalabras(.espanol)) == "séptima de dominante")
        #expect(AcordeConNombre.sextaAumentadaAlemana.nombre(en: .conPalabras(.ingles)) == "German augmented sixth")
    }

    /// Un acorde fuera del catálogo no se lee necesariamente por terceras y se llama como se escribió.
    @Test func fueraDelCatalogo() {
        let petrushka = AcordeConNombre(
            nombre: "acorde de Petrushka",
            intervalos: [.terceraMayor, .quintaJusta, .cuartaAumentada + .octava, .sextaMayor + .octava])
        #expect(petrushka.intervalos.first == .unisono)
        #expect(petrushka.nombre(en: .conPalabras(.ingles)) == "acorde de Petrushka")
        #expect(petrushka.estilos.isEmpty)
        #expect(petrushka.notas(sobre: .do).map(\.nombre) == ["Do", "Mi", "Sol", "Fa♯", "La"])
        #expect(AcordeConNombre.dominanteSeptima.notas(sobre: .sol).map(\.nombre) == ["Sol", "Si", "Re", "Fa"])
        #expect(AcordeConNombre.sextaAumentadaItaliana.estilos == [.clasica])
    }
}
