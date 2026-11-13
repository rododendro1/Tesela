import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Las escalas de la historia y el folclore europeos: el gregoriano, el Renacimiento, Vicentino y el folclore.
@Suite struct EscalasDeEuropaTests {
    @Test func modosGregorianos() throws {
        #expect(
            ModoGregoriano.todos.map(\.nombreGriego) == [
                "dórico", "hipodórico", "frigio", "hipofrigio", "lidio", "hipolidio", "mixolidio", "hipomixolidio",
            ])
        #expect(ModoGregoriano.todos.map(\.finalis) == [.re, .re, .mi, .mi, .fa, .fa, .sol, .sol])
        #expect(ModoGregoriano.todos.map(\.tenor) == [.la, .fa, .do, .la, .do, .la, .re, .do])
        #expect(ModoGregoriano(0) == nil)
        #expect(ModoGregoriano(9) == nil)

        let primero = ModoGregoriano(1)!
        #expect(primero.esAutentico)
        #expect(primero.maneria == .protus)
        #expect(primero.escala == Escala(.re, .dorico))
        #expect(primero.ambito.map(\.description) == ["Re4", "Mi4", "Fa4", "Sol4", "La4", "Si4", "Do5", "Re5"])
        #expect(primero.description == "modo 1 (protus auténtico, dórico): final Re, tenor La, ámbito Re4–Re5")

        let segundo = ModoGregoriano(2)!
        #expect(!segundo.esAutentico)
        #expect(segundo.escala == primero.escala)
        #expect(segundo.ambito.map(\.description) == ["La3", "Si3", "Do4", "Re4", "Mi4", "Fa4", "Sol4", "La4"])
        #expect(
            ModoGregoriano(8)!.description
                == "modo 8 (tetrardus plagal, hipomixolidio): final Sol, tenor Do, ámbito Re4–Re5")
        for modo in ModoGregoriano.todos {
            #expect(modo.ambito.count == 8)
            #expect(modo.ambito.contains(Altura(modo.finalis, octava: 4)))
        }

        #expect(try ModoGregoriano(leyendo: "hipofrigio").numero == 4)
        #expect(try ModoGregoriano(leyendo: "Tritus Plagal").numero == 6)
        #expect(try ModoGregoriano(leyendo: "modo 7").numero == 7)
        #expect(try ModoGregoriano(leyendo: "hipodorico").numero == 2)
        #expect(throws: ErrorDeLecturaDeTeoria.self) { try ModoGregoriano(leyendo: "eólico") }
    }

    /// Los modos con musica ficta del Renacimiento y la musica recta, en tres mesotónicos y en la afinación justa de
    /// Ramos de Pareja.
    @Test func elRenacimiento() throws {
        #expect(
            TipoDeEscala.escalasRenacentistas.map(\.nombre) == [
                "dórico con ficta", "mixolidio con ficta", "lidio con si bemol", "musica recta",
            ])
        #expect(TipoDeEscala.escalasRenacentistas.allSatisfy { $0.tradicion == .renacimiento })
        #expect(TipoDeEscala.doricoConFicta.temperamentoSugerido == .mesotonicoCuartoDeComa)
        let dorico = Escala(.re, .doricoConFicta)
        #expect(dorico.notas.map(\.description) == ["Re", "Mi", "Fa", "Sol", "La", "Si", "Do♯"])
        #expect(
            dorico.notas(sentido: .descendente).map(\.description) == ["Re", "Mi", "Fa", "Sol", "La", "Si♭", "Do"])
        #expect(
            Escala(.do, .musicaRecta).notas.map(\.description) == ["Do", "Re", "Mi", "Fa", "Sol", "La", "Si♭", "Si"])
        #expect(TipoDeEscala.lidioConSiBemol.intervalos == TipoDeEscala.mayor.intervalos)
        // Cada afinación, la de su mesotónico: ¼ de coma (Aron), 2/7 (Zarlino) y ⅓ (Salinas), al cent.
        let temperamentos = [4.0, 3.5, 3.0].map { TemperamentoRegular.mesotonico(fraccionDeComa: $0) }
        for tipo in TipoDeEscala.escalasRenacentistas {
            let ramos: [FuenteTeorica?] = tipo == .mixolidioConFicta ? [] : [.ramosDePareja]
            #expect(tipo.afinaciones.map(\.fuente) == [nil, .zarlino, .salinas] + ramos)
            for (afinacion, temperamento) in zip(tipo.afinaciones, temperamentos) {
                for sentido in [SentidoDelIntervalo.ascendente, .descendente] {
                    let pares = zip(afinacion.cents(sentido: sentido), afinacion.intervalos(sentido: sentido))
                    for (cents, intervalo) in pares {
                        #expect(abs(cents - temperamento.cents(de: intervalo)) <= 0.5, Comment(rawValue: tipo.nombre))
                    }
                }
            }
        }
        // Ramos: las razones de su monocordio desde Do (10/9, 5/4, 4/3, 3/2, 5/3, 16/9, 15/8), tomadas desde la final.
        let razones: [Double] = [1, 10 / 9, 5 / 4, 4 / 3, 3 / 2, 5 / 3, 16 / 9, 15 / 8]
        let recta = try #require(TipoDeEscala.musicaRecta.afinaciones.last)
        for (cents, razon) in zip(recta.cents(sentido: .ascendente), razones) {
            #expect(abs(cents - 1200 * log2(razon)) <= 0.5)
        }
        // En el dórico, la cuarta Re–Sol es la del lobo, 27/20; el Do♯ es 135/128 sobre Do.
        let doricoDeRamos = try #require(TipoDeEscala.doricoConFicta.afinaciones.last)
        #expect(doricoDeRamos.cents(sentido: .ascendente)[3] == 520)
        #expect(abs(doricoDeRamos.cents(sentido: .ascendente)[6] - 1200 * log2(135.0 / 64 / (10.0 / 9))) <= 0.5)
        // Zarlino numera los doce modos desde Do.
        #expect((try? TipoDeEscala(leyendo: "modo 1 de Zarlino"))?.nombre == "ionicus")
        #expect((try? TipoDeEscala(leyendo: "modo 3 de Zarlino"))?.nombre == "protus authenticus")
        #expect((try? TipoDeEscala(leyendo: "modo 12 de Zarlino"))?.nombre == "hypoaeolius")
    }

    /// Los tres géneros de Vicentino, en diesis de sus 31 partes: 3 + 5 + 5, 3 + 2 + 8 y 1 + 2 + 10.
    @Test func losGenerosDeVicentino() throws {
        #expect(TipoDeEscala.generosDeVicentino.allSatisfy { $0.tradicion == .renacimiento && $0.fuente == .vicentino })
        #expect(TipoDeEscala.generosDeVicentino.allSatisfy { $0.categoria == .tetracordo })
        let notas = TipoDeEscala.generosDeVicentino.map { Escala(.mi, $0).notas.map(\.description) }
        #expect(notas == [["Mi", "Fa", "Sol", "La"], ["Mi", "Fa", "Fa♯", "La"], ["Mi", "Fa♭", "Fa", "La"]])
        let diesis = 1200.0 / 31
        for (tipo, partes) in zip(TipoDeEscala.generosDeVicentino, [[0, 3, 8, 13], [0, 3, 5, 13], [0, 1, 3, 13]]) {
            let cents = try #require(tipo.afinacionPropia).cents
            for (c, p) in zip(cents, partes) {
                #expect(abs(c - Double(p) * diesis) <= 0.5, Comment(rawValue: tipo.nombre))
            }
        }
        let ingles = Notacion.compacta(.espanol).conTextos(en: .ingles)
        #expect(TipoDeEscala.tetracordoEnarmonicoDeVicentino.nombre(en: ingles) == "Vicentino's enharmonic tetrachord")
        #expect(TipoDeEscala.doricoConFicta.nombre(en: ingles) == "Dorian with ficta")
        #expect(TipoDeEscala.musicaRecta.nombre(en: ingles) == "musica recta")
    }

    /// El folklore europeo: tres escalas populares, dos instrumentos de afinación natural y el canto georgiano, con
    /// sus cents.
    @Test func elFolkloreEuropeo() throws {
        #expect(TipoDeEscala.tradicionales(tradicion: .europa) == TipoDeEscala.europeas)
        #expect(TipoDeEscala.europeas.allSatisfy { $0.categoria == .escala })
        #expect(TipoDeEscala.doricoUcraniano == .doricoCuartaAumentada)
        #expect(TipoDeEscala.podhalanska == .lidioDominante)
        #expect(TipoDeEscala.pentatonicaHungara == .pentatonicaMenor)
        #expect(TipoDeEscala.gaitaEscocesa == .mixolidio)
        // El nombre gana al alias: «dórico ucraniano» es ya la escala europea, igual que el dórico ♯4.
        let ucraniano = try TipoDeEscala(leyendo: "dórico ucraniano")
        #expect(ucraniano.nombre == "dórico ucraniano" && ucraniano.tradicion == .europa)
        #expect((try? TipoDeEscala(leyendo: "Podhale"))?.nombre == "podhalańska")
        #expect((try? TipoDeEscala(leyendo: "Alphorn"))?.nombre == "cuerno alpino")
        let alpino = Escala("Do cuerno alpino").notas.map(\.nombre)
        #expect(alpino == ["Do", "Re", "Mi", "Fa♯", "Sol", "La♭", "Si♭", "Si"])
        // El 11.º armónico, 49 cents bajo Fa♯; la 7ª natural de la gaita, 31 bajo Si♭.
        #expect(TipoDeEscala.cuernoAlpino.afinacionPropia?.desvios[3] == -49)
        #expect(TipoDeEscala.gaitaEscocesa.afinacionPropia?.desvios[6] == -31)
        #expect(TipoDeEscala.mixolidio.afinacionPropia == nil)
        // El canto georgiano: la segunda, 37 cents baja; la tercera, neutra, 32 sobre Mi♭.
        #expect(TipoDeEscala.georgiana == .dorico)
        #expect(TipoDeEscala.georgiana.afinacionPropia?.desvios == [0, -37, 32, 9, -7, -32, 18])
        #expect((try? TipoDeEscala(leyendo: "Svaneti"))?.nombre == "georgiana")
        #expect(TipoDeEscala.georgiana.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "Georgian")
        #expect(Tradicion.europa.nombre == "Folklore europeo")
        #expect(Escala(.do, .istriana).notas.map(\.description).joined(separator: " ") == "Do Re♭ Mi♭ Fa♭ Sol♭ La𝄫")
        #expect(TipoDeEscala.istriana.regiones == [.istria] && RegionDeEscala.istria.nombre == "Istria")
        #expect(RegionDeEscala.istria.nombre(en: Notacion.compacta(.espanol).conTextos(en: .aleman)) == "Istrien")
        #expect(Tradicion.europa.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "European folk")
    }
}
