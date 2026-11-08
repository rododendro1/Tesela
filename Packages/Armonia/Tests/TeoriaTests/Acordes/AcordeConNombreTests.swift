import Testing

@testable import Elementos
@testable import Teoria

@Suite struct AcordeConNombreTests {
    /// Cada acorde del catálogo se lee por terceras y tiene un nombre que no se repite.
    @Test func catalogo() {
        let catalogo = AcordeConNombre.catalogo
        #expect(AcordeConNombre.genericos.count == 31)
        #expect(catalogo == AcordeConNombre.genericos + AcordeConNombre.conNombrePropio)
        #expect(Set(catalogo.map(\.nombre)).count == catalogo.count)
        #expect(Set(catalogo).count == catalogo.count)
        for acorde in catalogo {
            #expect(acorde.intervalos.first == .unisono, "\(acorde.nombre)")
        }
        // Los genéricos se leen todos por terceras; de los de nombre propio, todos menos el de Petrushka.
        for acorde in AcordeConNombre.genericos { #expect(acorde.tipo != nil, "\(acorde.nombre)") }
        let sinTipo = AcordeConNombre.conNombrePropio.filter { $0.tipo == nil }
        #expect(sinTipo == [.petrushka])
        // Los genéricos tienen notas distintas, para que cada uno nombre su tipo.
        #expect(Set(AcordeConNombre.genericos.map(\.pasosDeQuinta)).count == AcordeConNombre.genericos.count)
    }

    /// Las notas de los de nombre propio, tal como se escriben, y la obra donde se leen.
    @Test func conNombrePropio() {
        func notas(_ acorde: AcordeConNombre, _ fundamental: Nota) -> [String] {
            acorde.notas(sobre: fundamental).map(\.nombre)
        }
        #expect(notas(.tristan, .fa) == ["Fa", "Si", "Re♯", "Sol♯"])
        #expect(notas(.mistico, .do) == ["Do", "Fa♯", "Si♭", "Mi", "La", "Re"])
        #expect(notas(.petrushka, .do) == ["Do", "Mi", "Sol", "Fa♯", "La♯", "Do♯"])
        #expect(notas(.farben, .do) == ["Do", "Sol♯", "Si", "Mi", "La"])
        #expect(notas(.soWhat, .mi) == ["Mi", "La", "Re", "Sol", "Si"])
        #expect(notas(.mu, .do) == ["Do", "Re", "Mi", "Sol"])
        #expect(notas(.porCuartas, .do) == ["Do", "Fa", "Si♭", "Mi♭"])
        #expect(AcordeConNombre.hendrix.tipo?.cifrado == "7(♯9,omit5)")
        #expect(AcordeConNombre.mu.tipo == .mayorNovenaAnadida)
        #expect(AcordeConNombre.tristan.referencias == [.rothgeb1995])
        #expect(AcordeConNombre.mistico.referencias.map(\.id) == ["samson1977:156–157"])
        #expect(AcordeConNombre.mistico.alias == ["acorde de Prometeo"])
        #expect(AcordeConNombre.soWhat.estilos == [.jazz])
        #expect(AcordeConNombre.porCuartas.estilos == [.jazz, .sigloXX])
        #expect(AcordeConNombre.tristan.nombre(en: .conPalabras(.ingles)) == "Tristan chord")
        #expect(AcordeConNombre.mistico.nombre(en: .conPalabras(.aleman)) == "mystischer Akkord")
    }

    /// Los de nombre propio no dan nombre a su tipo: el 7(♯9) sin quinta se sigue llamando como antes, pero sabe que es
    /// el de Hendrix.
    @Test func noNombranSuTipo() throws {
        let hendrix = try TipoDeAcorde(leyendo: "7(#9,omit5)")
        #expect(hendrix.acordeConNombre == nil)
        #expect(hendrix.nombre(en: .conPalabras(.espanol)) == "acorde 7(♯9,omit5)")
        #expect(hendrix.acordesConNombre == [.hendrix])
        #expect(try TipoDeAcorde(leyendo: "7(#9)").acordesConNombre.isEmpty)
        #expect(TipoDeAcorde.mayorNovenaAnadida.acordesConNombre == [.mayorNovenaAnadida, .mu])
        #expect(TipoDeAcorde.dominanteSeptima.acordesConNombre == [.dominanteSeptima])
        for acorde in AcordeConNombre.conNombrePropio {
            if let tipo = acorde.tipo { #expect(tipo.acordeConNombre != acorde, "\(acorde.nombre)") }
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
        for acorde in AcordeConNombre.genericos {
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
            nombre: "mi Petrushka",
            intervalos: [.terceraMayor, .quintaJusta, .cuartaAumentada + .octava, .sextaMayor + .octava])
        #expect(petrushka.intervalos.first == .unisono)
        #expect(petrushka.nombre(en: .conPalabras(.ingles)) == "mi Petrushka")
        #expect(petrushka.estilos.isEmpty)
        #expect(petrushka.notas(sobre: .do).map(\.nombre) == ["Do", "Mi", "Sol", "Fa♯", "La"])
        #expect(AcordeConNombre.dominanteSeptima.notas(sobre: .sol).map(\.nombre) == ["Sol", "Si", "Re", "Fa"])
        #expect(AcordeConNombre.sextaAumentadaItaliana.estilos == [.clasica])
    }
}
