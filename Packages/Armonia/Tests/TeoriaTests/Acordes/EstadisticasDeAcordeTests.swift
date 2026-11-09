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

    // MARK: Las teorías de acordes

    @Test func consonanciaDeHuron() {
        #expect(TipoDeAcorde.mayor.estadisticas.consonanciaDiadica == 2.22)
        #expect(TipoDeAcorde.menor.estadisticas.consonanciaDiadica == 2.22)
        #expect(TipoDeAcorde.dominanteSeptima.estadisticas.consonanciaDiadica == 1.779)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.consonanciaDiadica == 1.47)
        // Más consonante la tríada que la séptima, y la séptima que el cluster de Petrushka.
        #expect(
            AcordeConNombre.petrushka.estadisticas.consonanciaDiadica
                < TipoDeAcorde.dominanteSeptima.estadisticas.consonanciaDiadica)
    }

    @Test func gruposDeHindemith() throws {
        #expect(TipoDeAcorde.mayor.estadisticas.grupoDeHindemith == .i1)
        #expect(TipoDeAcorde.menor.estadisticas.grupoDeHindemith == .i1)
        #expect(try Acorde(leyendo: "Do/Mi").estadisticas.grupoDeHindemith == .i2)
        #expect(TipoDeAcorde.dominanteSeptima.estadisticas.grupoDeHindemith == .iia)
        #expect(try Acorde(leyendo: "Sol7/Si").estadisticas.grupoDeHindemith == .iib2)
        #expect(TipoDeAcorde.dominanteNovena.estadisticas.grupoDeHindemith == .iib1)
        #expect(TipoDeAcorde.mayorSeptimaMayor.estadisticas.grupoDeHindemith == .iii1)
        #expect(TipoDeAcorde.semidisminuido.estadisticas.grupoDeHindemith == .iib2)
        #expect(TipoDeAcorde.aumentado.estadisticas.grupoDeHindemith == .v)
        #expect(AcordeConNombre.porCuartas.estadisticas.grupoDeHindemith == .v)
        #expect(TipoDeAcorde.disminuido.estadisticas.grupoDeHindemith == .vi)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.grupoDeHindemith == .vi)
        #expect(AcordeConNombre.tristan.estadisticas.grupoDeHindemith == .iib2)
        #expect([.iv1, .iv2].contains(AcordeConNombre.petrushka.estadisticas.grupoDeHindemith))
        #expect(GrupoDeHindemith.iib1.description == "II b 1")
        #expect(GrupoDeHindemith.iv1.conTritono && !GrupoDeHindemith.iii1.conTritono)
    }

    @Test func fundamentalDeHindemith() throws {
        #expect(TipoDeAcorde.mayor.estadisticas.fundamentalDeHindemith == .unisono)
        #expect(try Acorde(leyendo: "Do/Mi").estadisticas.fundamentalDeHindemith == .unisono)
        // La semidisminuida, como una menor con sexta: Mi♭ en Do Mi♭ Sol♭ Si♭.
        #expect(TipoDeAcorde.semidisminuido.estadisticas.fundamentalDeHindemith == .terceraMenor)
        // El de Tristán, por su cuarta Re♯–Sol♯: Sol♯ sobre Fa.
        let tristan = try #require(AcordeConNombre.tristan.estadisticas.fundamentalDeHindemith)
        let solSostenido = try Nota(leyendo: "Sol#")
        #expect(Nota.fa + tristan == solSostenido)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.fundamentalDeHindemith == nil)
        #expect(TipoDeAcorde.aumentado.estadisticas.fundamentalDeHindemith == nil)
    }

    @Test func intervalosEntreVoces() throws {
        #expect(TipoDeAcorde.mayor.estadisticas.intervalosEntreVoces == [4, 3])
        #expect(TipoDeAcorde.dominanteNovena.estadisticas.intervalosEntreVoces == [4, 3, 3, 4])
        #expect(AcordeConNombre.tristan.estadisticas.intervalosEntreVoces == [6, 4, 5])
        #expect(try Acorde(leyendo: "Do/Mi").estadisticas.intervalosEntreVoces == [3, 5])
    }

    @Test func gradusSuavitatis() {
        #expect(TipoDeAcorde.potencia.estadisticas.gradoDeSuavidad == 3)
        #expect(TipoDeAcorde.mayor.estadisticas.gradoDeSuavidad == 7)
        #expect(TipoDeAcorde.menor.estadisticas.gradoDeSuavidad == 7)
        #expect(TipoDeAcorde.dominanteSeptima.estadisticas.gradoDeSuavidad == 11)
        #expect(
            TipoDeAcorde.disminuidoSeptima.estadisticas.gradoDeSuavidad
                > TipoDeAcorde.dominanteSeptima.estadisticas.gradoDeSuavidad)
    }

    /// Todo el catálogo se mide sin detenerse, y los indeterminados no tienen fundamental.
    @Test func todoElCatalogo() {
        for acorde in AcordeConNombre.catalogo {
            let medidas = acorde.estadisticas
            #expect(medidas.intervalosEntreVoces.allSatisfy { $0 > 0 }, Comment(rawValue: acorde.nombre))
            #expect(medidas.grupoDeHindemith.indeterminado == (medidas.fundamentalDeHindemith == nil))
            #expect(medidas.gradoDeSuavidad >= 1)
        }
    }

    @Test func fourier() {
        let aumentado = TipoDeAcorde.aumentado.estadisticas.magnitudesDeFourier
        #expect(aumentado.count == 6)
        #expect(aumentado[2] == 3)
        #expect(aumentado[5] == 3)
        #expect(aumentado[0] == 0)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.magnitudesDeFourier[3] == 4)
        // La tríada mayor se parece más a la diatónica (|f5|) que al cluster (|f1|).
        let mayor = TipoDeAcorde.mayor.estadisticas.magnitudesDeFourier
        #expect(mayor[4] > mayor[0])
    }

    @Test func fundamentalDeParncutt() {
        let mayor = TipoDeAcorde.mayor.estadisticas
        #expect(mayor.fundamentalDeParncutt == .unisono)
        #expect(mayor.prominenciasDeParncutt.map(\.peso) == [18, 10, 10])
        // En la menor con séptima gana la tercera: La Do Mi Sol se oye sobre Do.
        let menorSeptima = TipoDeAcorde.menorSeptima.estadisticas
        #expect(menorSeptima.fundamentalDeParncutt == .terceraMenor)
        #expect(menorSeptima.prominenciasDeParncutt.first?.peso == 18)
    }

    @Test func uniformidad() {
        #expect(TipoDeAcorde.aumentado.estadisticas.distanciaALaUniformidad == 0)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.distanciaALaUniformidad == 0)
        #expect(TipoDeAcorde.mayor.estadisticas.distanciaALaUniformidad == 0.816)
        #expect(TipoDeAcorde.menor.estadisticas.distanciaALaUniformidad == 0.816)
    }

    @Test func triadasContenidas() {
        let novena = TipoDeAcorde.dominanteNovena.estadisticas.triadasContenidas
        #expect(novena == TriadasContenidas(mayores: 1, menores: 1, disminuidas: 1, aumentadas: 0))
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.triadasContenidas.disminuidas == 4)
        #expect(AcordeConNombre.petrushka.estadisticas.triadasContenidas.mayores == 2)
    }

    @Test func tensionYModalidadDeCook() {
        #expect(TipoDeAcorde.mayor.estadisticas.tensionDeCook == 0.062)
        #expect(TipoDeAcorde.aumentado.estadisticas.tensionDeCook == 1)
        #expect(TipoDeAcorde.disminuido.estadisticas.tensionDeCook == 1)
        #expect(TipoDeAcorde.mayor.estadisticas.modalidadDeCook == 1.558)
        #expect(TipoDeAcorde.menor.estadisticas.modalidadDeCook == -1.558)
        #expect(TipoDeAcorde.aumentado.estadisticas.modalidadDeCook == 0)
    }

    @Test func rugosidadDeSethares() throws {
        let mayor = TipoDeAcorde.mayor.estadisticas.rugosidad
        #expect(mayor > 0)
        #expect(mayor < AcordeConNombre.mu.estadisticas.rugosidad)
        #expect(mayor < AcordeConNombre.petrushka.estadisticas.rugosidad)
        // Un `Acorde` suena en su posición cerrada en la cuarta octava: Do4 Mi4 Sol4, como el tipo.
        #expect(try Acorde(leyendo: "Do").estadisticas.rugosidad == mayor)
    }
}
