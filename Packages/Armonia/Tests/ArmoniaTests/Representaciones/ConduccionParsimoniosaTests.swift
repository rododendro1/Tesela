import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

@Suite struct ConduccionParsimoniosaTests {
    private func vecinos(_ cifrado: String, voces: Int = 1) -> [String] {
        Acorde(texto: cifrado)!.vecinosParsimoniosos(voces: voces).map(\.description)
    }

    @Test func vecinosDeSeptimas() {
        #expect(vecinos("Sol7") == ["Sol♯°7 (Sol→Sol♯)", "Solm7 (Si→Si♭)", "Mim7 (Fa→Mi)"])
        #expect(vecinos("Rem7") == ["Fa7 (Re→Mi♭)", "Re7 (Fa→Fa♯)", "Rem7(♭5) (La→La♭)", "Sim7(♭5) (Do→Si)"])
        #expect(vecinos("Sim7b5") == ["Rem7 (Si→Do)", "Sim7 (Fa→Fa♯)", "Si°7 (La→La♭)"])
        // La ortografía: Re♭7 pasa a Re♭m7, no a Do♯m7; Si°7, a Mi7 y no a Fa♭7.
        #expect(vecinos("Reb7") == ["Re°7 (Re♭→Re)", "Re♭m7 (Fa→Fa♭)", "Si♭m7 (Do♭→Si♭)"])
        #expect(vecinos("Sio7").contains("Mi7 (Fa→Mi)"))
        // Las «Power Towers»: cada séptima de dominante tiene 3 vecinos; la menor, 4; la
        // semidisminuida, 3; la disminuida, 8 (cuatro de dominante y cuatro semidisminuidas).
        var cuentas: [TipoDeAcorde: Set<Int>] = [:]
        for n in -7...7 {
            for tipo in TipoDeAcorde.familiaDeSeptimas {
                let pasos = Acorde(Nota(pasosDeQuinta: n), tipo).vecinosParsimoniosos()
                cuentas[tipo, default: []].insert(pasos.count)
                for paso in pasos {
                    #expect(paso.movimientos.count == 1)
                    #expect(abs(paso.movimientos[0].semitonos) == 1)
                    #expect(TipoDeAcorde.familiaDeSeptimas.contains(paso.acorde.tipo))
                    // Las notas que no se mueven siguen sonando.
                    let quedan = Set(Acorde(Nota(pasosDeQuinta: n), tipo).notas.map(\.claseDeAltura))
                        .subtracting([paso.movimientos[0].desde.claseDeAltura])
                    #expect(quedan.isSubset(of: paso.acorde.notas.map(\.claseDeAltura)))
                }
            }
        }
        #expect(cuentas[.dominanteSeptima] == [3])
        #expect(cuentas[.menorSeptima] == [4])
        #expect(cuentas[.semidisminuido] == [3])
        #expect(cuentas[.disminuidoSeptima] == [8])
        #expect(Acorde("Do6").vecinosParsimoniosos().isEmpty)
        #expect(Acorde("Sol7").vecinosParsimoniosos(voces: 3).isEmpty)
    }

    @Test func septimasConMaj7() {
        // Un maj7 va por la familia ampliada; las demás séptimas, por las «Power Towers».
        #expect(vecinos("Domaj7") == ["Do♯m7(♭5) (Do→Do♯)", "Do7 (Si→Si♭)"])
        #expect(vecinos("Sol7").count == 3)
        let ampliada = Acorde("Sol7").vecinosParsimoniosos(tipos: TipoDeAcorde.familiaDeSeptimasAmpliada)
        #expect(ampliada.map(\.description).contains("Solmaj7 (Fa→Fa♯)"))
        var cuentas: [TipoDeAcorde: Set<Int>] = [:]
        for n in -7...7 {
            for tipo in TipoDeAcorde.familiaDeSeptimasAmpliada {
                let pasos = Acorde(Nota(pasosDeQuinta: n), tipo).vecinosParsimoniosos(
                    tipos: TipoDeAcorde.familiaDeSeptimasAmpliada)
                cuentas[tipo, default: []].insert(pasos.count)
            }
        }
        #expect(cuentas[.dominanteSeptima] == [4])
        #expect(cuentas[.menorSeptima] == [4])
        #expect(cuentas[.semidisminuido] == [4])
        #expect(cuentas[.disminuidoSeptima] == [8])
        #expect(cuentas[.mayorSeptimaMayor] == [2])
        // El camino entre una séptima y un maj7 elige la familia que tiene a los dos.
        #expect(Tonnetz.caminoParsimonioso(desde: "Do7", hasta: "Domaj7")?.map(\.description) == ["Domaj7 (Si♭→Si)"])
        #expect(
            Tonnetz.caminoParsimonioso(desde: "Domaj7", hasta: "Sol7")?.map(\.description) == [
                "Do♯m7(♭5) (Do→Do♯)", "Mim7 (Do♯→Re)", "Sol7 (Mi→Fa)",
            ])
    }

    @Test func dosVoces() {
        // P₂,₀: Sol7 llega a Re♭7, a un tritono, moviendo dos voces (la sustitución tritonal).
        let pasos = Acorde("Sol7").vecinosParsimoniosos(voces: 2)
        #expect(pasos.contains { $0.acorde == Acorde("Reb7") })
        #expect(pasos.allSatisfy { $0.movimientos.count == 2 && $0.movimientos.allSatisfy { abs($0.semitonos) == 1 } })
        // Childs: entre séptimas de dominante y semidisminuidas.
        let childs = Acorde("Sol7").vecinosParsimoniosos(voces: 2, tipos: [.dominanteSeptima, .semidisminuido])
        #expect(Set(childs.map(\.acorde.tipo)) == [.dominanteSeptima, .semidisminuido])
    }

    @Test func triadas() {
        // El «Cube Dance»: cada tríada mayor o menor, 3 vecinos; la aumentada, 6.
        #expect(vecinos("Do") == ["Mim (Do→Si)", "Dom (Mi→Mi♭)", "Do+ (Sol→Sol♯)"])
        #expect(
            vecinos("Doaug") == [
                "Mi (Do→Si)", "Do♯m (Do→Do♯)", "La♭ (Mi→Mi♭)", "Fam (Mi→Fa)", "Do (Sol♯→Sol)", "Lam (Sol♯→La)",
            ])
        // P y L son movimientos de una voz; R no (la quinta sube un tono).
        let vecinosDeDo = Acorde("Do").vecinosParsimoniosos().map(\.acorde)
        #expect(vecinosDeDo.contains(Acorde("Do").transformar(.p)!))
        #expect(vecinosDeDo.contains(Acorde("Do").transformar(.l)!))
        #expect(!vecinosDeDo.contains(Acorde("Do").transformar(.r)!))
    }

    @Test func camino() throws {
        let camino = try #require(Tonnetz.caminoParsimonioso(desde: "Sol7", hasta: "Rem7"))
        #expect(camino.map(\.acorde.cifrado) == ["Sol♯°7", "Sim7(♭5)", "Rem7"])
        #expect(Tonnetz.caminoParsimonioso(desde: "Sol7", hasta: "Reb7", voces: 2)?.map(\.acorde) == [Acorde("Reb7")])
        #expect(Tonnetz.caminoParsimonioso(desde: "Sol7", hasta: "Sol7") == [])
        // Sin ortografía en la meta, y el último paso con la del destino.
        #expect(Tonnetz.caminoParsimonioso(desde: "Do", hasta: "Mibm")?.last?.acorde == Acorde("Mibm"))
        #expect(Tonnetz.caminoParsimonioso(desde: "Do", hasta: "Mibm")?.count == 4)
        #expect(Tonnetz.caminoParsimonioso(desde: "Do", hasta: "Sol7") == nil)
        #expect(Tonnetz.caminoParsimonioso(desde: "Do6", hasta: "Sol7") == nil)
        // Las «Power Towers» están conectadas: de Do7 se llega a las 12 × 3 + 3 séptimas.
        for n in -5...6 {
            for tipo in TipoDeAcorde.familiaDeSeptimas {
                let destino = Acorde(Nota(pasosDeQuinta: n), tipo)
                let camino = try #require(
                    Tonnetz.caminoParsimonioso(desde: "Do7", hasta: destino), Comment(rawValue: destino.cifrado))
                #expect(
                    Set(camino.last?.acorde.notas.map(\.claseDeAltura) ?? Acorde("Do7").notas.map(\.claseDeAltura))
                        == Set(destino.notas.map(\.claseDeAltura)))
                #expect(camino.count <= 6)
            }
        }
    }

    @Test func conduccionMinima() {
        let resolucion = Acorde("Sol7").conduccionMinima(hasta: "Do")
        #expect(resolucion.semitonosMovidos == 4)
        #expect("\(resolucion)" == "Sol→Sol, Si→Do (+1), Re→Do (−2), Fa→Mi (−1): 4 semitonos")
        #expect(resolucion.vocesQueSeMueven.count == 3)
        #expect(Acorde("Rem7").conduccionMinima(hasta: "Sol7").semitonosMovidos == 3)
        #expect(Acorde("Do").conduccionMinima(hasta: "Lam").semitonosMovidos == 2) // R: Sol→La
        #expect(Acorde("Do").conduccionMinima(hasta: "Do").semitonosMovidos == 0)
        #expect(Acorde("Do").conduccionMinima(hasta: "Sol7").movimientos.count == 4)
        #expect(Acorde("Do").conduccionMinima(hasta: "Fa#").semitonosMovidos == 6)
        #expect(
            Acorde("Sol7").conduccionMinima(hasta: "Do").texto(en: .inglesASCII)
                == "G→G, B→C (+1), D→C (−2), F→E (−1): 4 semitones")
        // Simétrica en el total.
        for (a, b) in [("Sol7", "Do"), ("Rem7", "Solmaj7"), ("Do", "Fa#m"), ("Sio7", "Do")] {
            #expect(
                Acorde(texto: a)!.conduccionMinima(hasta: Acorde(texto: b)!).semitonosMovidos
                    == Acorde(texto: b)!.conduccionMinima(hasta: Acorde(texto: a)!).semitonosMovidos, "\(a) \(b)")
        }
        #expect(MovimientoDeVoz(desde: .do, hasta: Nota(.fa, .sostenido)).semitonos == 6)
        #expect(MovimientoDeVoz(desde: .do, hasta: .si).semitonos == -1)
    }
}
