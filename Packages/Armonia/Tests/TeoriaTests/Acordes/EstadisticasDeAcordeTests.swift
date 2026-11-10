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
        #expect(casi(TipoDeAcorde.mayor.estadisticas.conjunto.consonanciaDiadica, 2.22))
        #expect(casi(TipoDeAcorde.menor.estadisticas.conjunto.consonanciaDiadica, 2.22))
        #expect(casi(TipoDeAcorde.dominanteSeptima.estadisticas.conjunto.consonanciaDiadica, 1.779))
        #expect(casi(TipoDeAcorde.disminuidoSeptima.estadisticas.conjunto.consonanciaDiadica, 1.47))
        // Más consonante la tríada que la séptima, y la séptima que el cluster de Petrushka.
        #expect(
            AcordeConNombre.petrushka.estadisticas.conjunto.consonanciaDiadica
                < TipoDeAcorde.dominanteSeptima.estadisticas.conjunto.consonanciaDiadica)
    }

    @Test func gruposDeHindemith() throws {
        #expect(TipoDeAcorde.mayor.estadisticas.disposicionDeVoces.grupoDeHindemith == .i1)
        #expect(TipoDeAcorde.menor.estadisticas.disposicionDeVoces.grupoDeHindemith == .i1)
        #expect(try Acorde(leyendo: "Do/Mi").estadisticas.disposicionDeVoces.grupoDeHindemith == .i2)
        #expect(TipoDeAcorde.dominanteSeptima.estadisticas.disposicionDeVoces.grupoDeHindemith == .iia)
        #expect(try Acorde(leyendo: "Sol7/Si").estadisticas.disposicionDeVoces.grupoDeHindemith == .iib2)
        #expect(TipoDeAcorde.dominanteNovena.estadisticas.disposicionDeVoces.grupoDeHindemith == .iib1)
        #expect(TipoDeAcorde.mayorSeptimaMayor.estadisticas.disposicionDeVoces.grupoDeHindemith == .iii1)
        #expect(TipoDeAcorde.semidisminuido.estadisticas.disposicionDeVoces.grupoDeHindemith == .iib2)
        #expect(TipoDeAcorde.aumentado.estadisticas.disposicionDeVoces.grupoDeHindemith == .v)
        #expect(AcordeConNombre.porCuartas.estadisticas.disposicionDeVoces.grupoDeHindemith == .v)
        #expect(TipoDeAcorde.disminuido.estadisticas.disposicionDeVoces.grupoDeHindemith == .vi)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.disposicionDeVoces.grupoDeHindemith == .vi)
        #expect(AcordeConNombre.tristan.estadisticas.disposicionDeVoces.grupoDeHindemith == .iib2)
        #expect([.iv1, .iv2].contains(AcordeConNombre.petrushka.estadisticas.disposicionDeVoces.grupoDeHindemith))
        #expect(GrupoDeHindemith.iib1.description == "II b 1")
        #expect(GrupoDeHindemith.iv1.conTritono && !GrupoDeHindemith.iii1.conTritono)
    }

    @Test func fundamentalDeHindemith() throws {
        #expect(TipoDeAcorde.mayor.estadisticas.disposicionDeVoces.fundamentalDeHindemith == .unisono)
        #expect(try Acorde(leyendo: "Do/Mi").estadisticas.disposicionDeVoces.fundamentalDeHindemith == .unisono)
        // La semidisminuida, como una menor con sexta: Mi♭ en Do Mi♭ Sol♭ Si♭.
        #expect(TipoDeAcorde.semidisminuido.estadisticas.disposicionDeVoces.fundamentalDeHindemith == .terceraMenor)
        // El de Tristán, por su cuarta Re♯–Sol♯: Sol♯ sobre Fa.
        let tristan = try #require(AcordeConNombre.tristan.estadisticas.disposicionDeVoces.fundamentalDeHindemith)
        let solSostenido = try Nota(leyendo: "Sol#")
        #expect(Nota.fa + tristan == solSostenido)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.disposicionDeVoces.fundamentalDeHindemith == nil)
        #expect(TipoDeAcorde.aumentado.estadisticas.disposicionDeVoces.fundamentalDeHindemith == nil)
    }

    @Test func intervalosEntreVoces() throws {
        #expect(TipoDeAcorde.mayor.estadisticas.disposicionDeVoces.intervalosEntreVoces == [4, 3])
        #expect(TipoDeAcorde.dominanteNovena.estadisticas.disposicionDeVoces.intervalosEntreVoces == [4, 3, 3, 4])
        #expect(AcordeConNombre.tristan.estadisticas.disposicionDeVoces.intervalosEntreVoces == [6, 4, 5])
        #expect(try Acorde(leyendo: "Do/Mi").estadisticas.disposicionDeVoces.intervalosEntreVoces == [3, 5])
    }

    @Test func gradusSuavitatis() {
        #expect(TipoDeAcorde.potencia.estadisticas.afinacion.gradoDeSuavidad == 3)
        #expect(TipoDeAcorde.mayor.estadisticas.afinacion.gradoDeSuavidad == 7)
        #expect(TipoDeAcorde.menor.estadisticas.afinacion.gradoDeSuavidad == 7)
        #expect(TipoDeAcorde.dominanteSeptima.estadisticas.afinacion.gradoDeSuavidad == 11)
        #expect(
            TipoDeAcorde.disminuidoSeptima.estadisticas.afinacion.gradoDeSuavidad
                > TipoDeAcorde.dominanteSeptima.estadisticas.afinacion.gradoDeSuavidad)
    }

    /// Todo el catálogo se mide sin detenerse, y los indeterminados no tienen fundamental.
    @Test func todoElCatalogo() {
        for acorde in AcordeConNombre.catalogo {
            let medidas = acorde.estadisticas
            #expect(
                medidas.disposicionDeVoces.intervalosEntreVoces.allSatisfy { $0 > 0 }, Comment(rawValue: acorde.nombre))
            #expect(
                medidas.disposicionDeVoces.grupoDeHindemith.indeterminado
                    == (medidas.disposicionDeVoces.fundamentalDeHindemith == nil))
            #expect(medidas.afinacion.gradoDeSuavidad >= 1)
        }
    }

    @Test func fourier() {
        let aumentado = TipoDeAcorde.aumentado.estadisticas.conjunto.magnitudesDeFourier
        #expect(aumentado.count == 6)
        #expect(aumentado[2] == 3)
        #expect(aumentado[5] == 3)
        #expect(casi(aumentado[0], 0))
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.conjunto.magnitudesDeFourier[3] == 4)
        // La tríada mayor se parece más a la diatónica (|f5|) que al cluster (|f1|).
        let mayor = TipoDeAcorde.mayor.estadisticas.conjunto.magnitudesDeFourier
        #expect(mayor[4] > mayor[0])
    }

    @Test func fundamentalDeParncutt() {
        let mayor = TipoDeAcorde.mayor.estadisticas
        #expect(mayor.psicoacustica.fundamentalDeParncutt == .unisono)
        #expect(mayor.psicoacustica.prominenciasDeParncutt.map(\.peso) == [18, 10, 10])
        // En la menor con séptima gana la tercera: La Do Mi Sol se oye sobre Do.
        let menorSeptima = TipoDeAcorde.menorSeptima.estadisticas
        #expect(menorSeptima.psicoacustica.fundamentalDeParncutt == .terceraMenor)
        #expect(menorSeptima.psicoacustica.prominenciasDeParncutt.first?.peso == 18)
    }

    @Test func uniformidad() {
        #expect(TipoDeAcorde.aumentado.estadisticas.conjunto.distanciaALaUniformidad == 0)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.conjunto.distanciaALaUniformidad == 0)
        #expect(casi(TipoDeAcorde.mayor.estadisticas.conjunto.distanciaALaUniformidad, 0.816))
        #expect(casi(TipoDeAcorde.menor.estadisticas.conjunto.distanciaALaUniformidad, 0.816))
    }

    @Test func triadasContenidas() {
        let novena = TipoDeAcorde.dominanteNovena.estadisticas.conjunto.triadasContenidas
        #expect(novena == TriadasContenidas(mayores: 1, menores: 1, disminuidas: 1, aumentadas: 0))
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.conjunto.triadasContenidas.disminuidas == 4)
        #expect(AcordeConNombre.petrushka.estadisticas.conjunto.triadasContenidas.mayores == 2)
    }

    @Test func tensionYModalidadDeCook() {
        #expect(casi(TipoDeAcorde.mayor.estadisticas.psicoacustica.tensionDeCook, 0.062))
        #expect(TipoDeAcorde.aumentado.estadisticas.psicoacustica.tensionDeCook == 1)
        #expect(TipoDeAcorde.disminuido.estadisticas.psicoacustica.tensionDeCook == 1)
        #expect(casi(TipoDeAcorde.mayor.estadisticas.psicoacustica.modalidadDeCook, 1.558))
        #expect(casi(TipoDeAcorde.menor.estadisticas.psicoacustica.modalidadDeCook, -1.558))
        #expect(TipoDeAcorde.aumentado.estadisticas.psicoacustica.modalidadDeCook == 0)
    }

    @Test func rugosidadDeSethares() throws {
        let mayor = TipoDeAcorde.mayor.estadisticas.psicoacustica.rugosidad
        #expect(mayor > 0)
        #expect(mayor < AcordeConNombre.mu.estadisticas.psicoacustica.rugosidad)
        #expect(mayor < AcordeConNombre.petrushka.estadisticas.psicoacustica.rugosidad)
        // Un `Acorde` suena en su posición cerrada en la cuarta octava: Do4 Mi4 Sol4, como el tipo.
        #expect(try Acorde(leyendo: "Do").estadisticas.psicoacustica.rugosidad == mayor)
    }

    @Test func afinacionJusta() {
        let mayor = TipoDeAcorde.mayor.estadisticas
        #expect(casi(mayor.afinacion.alturaDeTenney, 3.605))
        #expect(mayor.afinacion.limiteImpar == 5)
        #expect(mayor.afinacion.limitePrimo == 5)
        #expect(casi(mayor.afinacion.armonicidad, 51.1, tolerancia: 0.05))
        let quinta = TipoDeAcorde.potencia.estadisticas
        #expect(casi(quinta.afinacion.alturaDeTenney, 2.585)) // log₂(3·2)
        #expect(quinta.afinacion.limiteImpar == 3)
        #expect(quinta.afinacion.limitePrimo == 3)
        #expect(casi(quinta.afinacion.armonicidad, 66.7, tolerancia: 0.05)) // (3 + 2 − 1)/(3·2)
        // El tritono de la séptima de dominante, 45/32, sube su límite impar.
        #expect(TipoDeAcorde.dominanteSeptima.estadisticas.afinacion.limiteImpar == 45)
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.afinacion.armonicidad < mayor.afinacion.armonicidad)
    }

    @Test func entropiaArmonica() {
        #expect(Psicoacustica.entropiaArmonica(cents: 0) < Psicoacustica.entropiaArmonica(cents: 1200))
        #expect(Psicoacustica.entropiaArmonica(cents: 700) < Psicoacustica.entropiaArmonica(cents: 100))
        let quinta = TipoDeAcorde.potencia.estadisticas.psicoacustica.entropiaArmonica
        let mayor = TipoDeAcorde.mayor.estadisticas.psicoacustica.entropiaArmonica
        #expect(quinta < mayor)
        #expect(mayor < TipoDeAcorde.disminuidoSeptima.estadisticas.psicoacustica.entropiaArmonica)
    }

    @Test func fundamentalVirtualDeTerhardt() {
        #expect(TipoDeAcorde.mayor.estadisticas.psicoacustica.fundamentalVirtual == .unisono)
        #expect(TipoDeAcorde.menor.estadisticas.psicoacustica.fundamentalVirtual == .unisono)
        // La menor séptima se oye como la mayor sexta de su tercera (Do Mi♭ Sol Si♭, Mi♭6), y Do Fa Sol sobre Fa.
        #expect(TipoDeAcorde.menorSeptima.estadisticas.psicoacustica.fundamentalVirtual == .terceraMenor)
        #expect(TipoDeAcorde.sus4.estadisticas.psicoacustica.fundamentalVirtual == .cuartaJusta)
    }

    @Test func fusionTonal() {
        #expect(TipoDeAcorde.potencia.estadisticas.psicoacustica.fusionTonal == 1)
        #expect(casi(TipoDeAcorde.mayor.estadisticas.psicoacustica.fusionTonal, 0.333))
        #expect(TipoDeAcorde.disminuidoSeptima.estadisticas.psicoacustica.fusionTonal == 0)
    }

    @Test func rugosidadesDeVassilakisYHutchinsonKnopoff() {
        let (quinta, mayor, disminuida) = (
            TipoDeAcorde.potencia.estadisticas, TipoDeAcorde.mayor.estadisticas,
            TipoDeAcorde.disminuidoSeptima.estadisticas
        )
        #expect(quinta.psicoacustica.rugosidadDeVassilakis < mayor.psicoacustica.rugosidadDeVassilakis)
        #expect(mayor.psicoacustica.rugosidadDeVassilakis < disminuida.psicoacustica.rugosidadDeVassilakis)
        #expect(quinta.psicoacustica.rugosidadDeHutchinsonKnopoff < mayor.psicoacustica.rugosidadDeHutchinsonKnopoff)
        #expect(
            mayor.psicoacustica.rugosidadDeHutchinsonKnopoff < disminuida.psicoacustica.rugosidadDeHutchinsonKnopoff)
        #expect(disminuida.psicoacustica.rugosidadDeHutchinsonKnopoff < 1)
    }

    @Test func relacionZYComplemento() {
        let hendrix = AcordeConNombre.hendrix.estadisticas
        #expect(hendrix.numeroDeForte == "4-Z15")
        #expect(hendrix.conjunto.parejaZ == "4-Z29")
        #expect(hendrix.conjunto.complemento == "8-Z15")
        #expect(TipoDeAcorde.mayor.estadisticas.conjunto.parejaZ == nil)
        #expect(TipoDeAcorde.mayor.estadisticas.conjunto.complemento == "9-11")
    }

    @Test func disposicion() {
        #expect(TipoDeAcorde.mayor.estadisticas.disposicionDeVoces.disposicion == .cerrada)
        #expect(TipoDeAcorde.dominanteNovena.estadisticas.disposicionDeVoces.disposicion == .drop2)
        #expect(TipoDeAcorde.dominanteUndecima.estadisticas.disposicionDeVoces.disposicion == .drop24)
        #expect(TipoDeAcorde.dominanteDecimotercera.estadisticas.disposicionDeVoces.disposicion == nil)
        // Do7 en drop 2 (Sol abajo) y en drop 3 (Mi abajo).
        #expect(DisposicionDeVoces.disposicion([0, 5, 9, 15]) == .drop2)
        #expect(DisposicionDeVoces.disposicion([0, 8, 15, 18]) == .drop3)
        // La serie armónica: los intervalos anchos abajo.
        #expect(TipoDeAcorde.mayor.estadisticas.disposicionDeVoces.respetaLaSerieArmonica)
        #expect(!TipoDeAcorde.menor.estadisticas.disposicionDeVoces.respetaLaSerieArmonica)
    }
}
