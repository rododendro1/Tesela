import Testing

@testable import Elementos
@testable import Teoria

/// El cardinal de los acordes (tríada, tétrada…) y lo que se mide de ellos (`EstadisticasDeAcorde`).
@Suite struct EstadisticasDeAcordeTests {
    @Test func cardinal() throws {
        #expect(TipoDeAcorde.potencia.cardinal == .diada)
        #expect(TipoDeAcorde.mayor.cardinal == .triada)
        #expect(TipoDeAcorde.sus4.cardinal == .triada)
        #expect(TipoDeAcorde.dominanteSeptima.numeroDeNotas == 4)
        #expect(TipoDeAcorde.dominanteSeptima.cardinal == .tetrada)
        #expect(TipoDeAcorde.mayorSextaNovena.cardinal == .pentada)
        #expect(TipoDeAcorde.dominanteUndecima.cardinal == .hexada)
        #expect(TipoDeAcorde.dominanteDecimotercera.cardinal == .hexada)
        #expect(try TipoDeAcorde(leyendo: "13(#11)").cardinal == .heptada)
        #expect(CardinalDeAcorde(numeroDeNotas: 1) == nil)
        #expect(CardinalDeAcorde(numeroDeNotas: 9) == nil)
        #expect(CardinalDeAcorde.allCases.map(\.numeroDeNotas) == Array(2...8))
        #expect(CardinalDeAcorde.triada < .tetrada)
    }

    @Test func cardinalDeLosAcordesConNombre() {
        #expect(AcordeConNombre.tristan.cardinal == .tetrada)
        #expect(AcordeConNombre.petrushka.numeroDeNotas == 6)
        #expect(AcordeConNombre.petrushka.cardinal == .hexada)
        #expect(AcordeConNombre.mistico.cardinal == .hexada)
        #expect(AcordeConNombre.alfa.cardinal == .octada)
        #expect(AcordeConNombre.todos(numeroDeNotas: 3).contains(.mayor))
        #expect(AcordeConNombre.todos(numeroDeNotas: 3).allSatisfy { $0.cardinal == .triada })
        // Todo el catálogo tiene nombre de cardinal.
        for acorde in AcordeConNombre.catalogo {
            #expect(acorde.cardinal != nil, Comment(rawValue: "\(acorde.nombre) \(acorde.numeroDeNotas)"))
        }
    }

    @Test func cardinalDelAcordeConBajo() throws {
        #expect(try Acorde(leyendo: "Do").cardinal == .triada)
        #expect(try Acorde(leyendo: "Do/Mi").cardinal == .triada)
        #expect(try Acorde(leyendo: "Do/Re").numeroDeNotas == 4)
        #expect(try Acorde(leyendo: "Do/Re").estadisticas.cardinal == .tetrada)
    }

    @Test func nombresDelCardinal() {
        #expect(CardinalDeAcorde.tetrada.nombre == "tétrada")
        #expect(CardinalDeAcorde.triada.nombre(en: .ascii(.ingles)) == "triad")
        #expect(CardinalDeAcorde.tetrada.nombre(en: .delIdioma(.aleman)) == "Vierklang")
        for idioma in Idioma.allCases {
            let nombres = CardinalDeAcorde.allCases.map { $0.nombre(en: .delIdioma(idioma)) }
            #expect(Set(nombres).count == nombres.count, Comment(rawValue: "\(idioma)"))
            #expect(nombres.allSatisfy { !$0.isEmpty }, Comment(rawValue: "\(idioma)"))
        }
    }

    @Test func tiposPorNumeroDeNotas() {
        let triadas = TipoDeAcorde.todos(numeroDeNotas: 3)
        #expect(triadas == [.mayor, .menor, .disminuido, .aumentado, .sus2, .sus4])
        #expect(TipoDeAcorde.todos(numeroDeNotas: 2) == [.potencia])
    }

    @Test func brilloYAmplitud() {
        #expect(TipoDeAcorde.mayor.estadisticas.brilloPorQuintas == 5.0 / 3)
        #expect(TipoDeAcorde.menor.estadisticas.brilloPorQuintas == -2.0 / 3)
        #expect(TipoDeAcorde.dominanteSeptima.estadisticas.brilloPorQuintas == 0.75)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.brilloPorQuintas == -4.5)
        #expect(AcordeConNombre.petrushka.estadisticas.brilloPorQuintas == nil)
        #expect(TipoDeAcorde.mayor.estadisticas.amplitudEnQuintas == 4)
        #expect(TipoDeAcorde.dominanteSeptima.estadisticas.amplitudEnQuintas == 6)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.amplitudEnQuintas == 9)
        #expect(AcordeConNombre.petrushka.estadisticas.amplitudEnQuintas == 10)
        // Más brillante la mayor que la menor, y la de séptima mayor que la de dominante.
        #expect(
            (TipoDeAcorde.mayorSeptimaMayor.estadisticas.brilloPorQuintas ?? 0)
                > (TipoDeAcorde.dominanteSeptima.estadisticas.brilloPorQuintas ?? 0))
    }

    @Test func intervalosYForte() {
        let mayor = TipoDeAcorde.mayor.estadisticas
        #expect(mayor.vectorIntervalico == [0, 0, 1, 1, 1, 0])
        #expect(mayor.formaPrima == [0, 3, 7])
        #expect(mayor.numeroDeForte == "3-11")
        let dominante = TipoDeAcorde.dominanteSeptima.estadisticas
        #expect(dominante.vectorIntervalico == [0, 1, 2, 1, 1, 1])
        #expect(dominante.numeroDeForte == "4-27")
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.vectorIntervalico == [0, 0, 4, 0, 0, 2])
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.numeroDeForte == "4-28")
        let petrushka = AcordeConNombre.petrushka.estadisticas
        #expect(petrushka.vectorIntervalico == [2, 2, 4, 2, 2, 3])
        #expect(petrushka.numeroDeForte == "6-30")
        #expect(!petrushka.porTerceras)
        #expect(petrushka.tensiones == nil)
    }

    @Test func simetriaYRasgos() {
        #expect(TipoDeAcorde.mayor.estadisticas.transposicionesDistintas == 12)
        #expect(TipoDeAcorde.aumentado.estadisticas.transposicionesDistintas == 4)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.transposicionesDistintas == 3)
        #expect(AcordeConNombre.petrushka.estadisticas.transposicionesDistintas == 6)
        #expect(!TipoDeAcorde.mayor.estadisticas.simetricoPorInversion)
        #expect(!TipoDeAcorde.dominanteSeptima.estadisticas.simetricoPorInversion)
        #expect(TipoDeAcorde.sus4.estadisticas.simetricoPorInversion)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.simetricoPorInversion)
        #expect(TipoDeAcorde.menorSeptima.estadisticas.anhemitonico)
        #expect(!TipoDeAcorde.mayorSeptimaMayor.estadisticas.anhemitonico)
        #expect(!TipoDeAcorde.mayor.estadisticas.conTritono)
        #expect(TipoDeAcorde.dominanteSeptima.estadisticas.conTritono)
        #expect(TipoDeAcorde.dominanteNovena.estadisticas.tensiones == 1)
        #expect(TipoDeAcorde.mayor.estadisticas.tensiones == 0)
    }

    @Test func ambito() {
        #expect(AcordeConNombre.tristan.estadisticas.ambito == 15)
        #expect(AcordeConNombre.mayor.estadisticas.ambito == 7)
        #expect(TipoDeAcorde.mayor.estadisticas.ambito == nil)
    }

    /// Las de un acorde con nombre que da nombre a su tipo son las del tipo, salvo el ámbito.
    @Test func losGenericosMidenComoSuTipo() {
        for acorde in AcordeConNombre.genericos {
            guard let tipo = acorde.tipo else { continue }
            let (a, b) = (acorde.estadisticas, tipo.estadisticas)
            #expect(a.numeroDeNotas == b.numeroDeNotas, Comment(rawValue: acorde.nombre))
            #expect(a.vectorIntervalico == b.vectorIntervalico, Comment(rawValue: acorde.nombre))
            #expect(a.brilloPorQuintas == b.brilloPorQuintas, Comment(rawValue: acorde.nombre))
            #expect(a.ambito != nil)
        }
    }
}
