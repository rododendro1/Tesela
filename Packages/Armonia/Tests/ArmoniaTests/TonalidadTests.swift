import Foundation
import Testing

@testable import Armonia
@testable import Diagramas
@testable import Elementos
@testable import Partituras
@testable import Teoria
@testable import Trastes

@Suite struct TonalidadTipoTests {
    let laMenor: Tonalidad = "La menor"

    @Test func escalasYArmadura() {
        #expect(laMenor.escala == Escala(.la, .menorNatural))
        #expect(laMenor.escalaDeReferencia == Escala(.la, .menorArmonica))
        #expect(laMenor.notasPropias.map(\.nombre) == ["La", "Si", "Do", "Re", "Mi", "Fa", "Sol", "Fa♯", "Sol♯"])
        #expect(laMenor.armadura == 0)
        #expect(Tonalidad("Mib mayor").armadura == -3)
        #expect(Tonalidad("Mib mayor").notasDeLaArmadura == ["Sib", "Mib", "Lab"])
        #expect(Tonalidad(armadura: 3) == Tonalidad(.la))
        #expect(Tonalidad(armadura: -2, modo: .menor) == Tonalidad(.sol, .menor))
        #expect(Tonalidad.circuloDeQuintas().count == 15)
        #expect(Tonalidad.circuloDeQuintas(.menor)[7] == laMenor)
    }

    @Test func relaciones() {
        #expect(laMenor.relativa == Tonalidad(.do))
        #expect(laMenor.homonima == Tonalidad(.la))
        #expect(Tonalidad(.do).distancia(hasta: Tonalidad(.mi)) == 4)
        #expect(Tonalidad("Do# mayor").enarmonicaMasSimple == Tonalidad("Reb mayor"))
        #expect(
            Set(laMenor.vecinas) == [
                Tonalidad(.do), Tonalidad(.mi, .menor), Tonalidad(.sol), Tonalidad(.re, .menor), Tonalidad(.fa),
            ])
    }

    @Test func funcionesYArmonia() {
        #expect(laMenor.nombreDeGrado(7) == .sensible)
        #expect(laMenor.nombreDeGrado(de: .sol) == .subtonica)
        #expect(laMenor.nombreDeGrado(de: "Sol#") == .sensible)
        #expect(laMenor.nombreDeGrado(de: "Fa#") == .superdominante)
        #expect(laMenor.nombreDeGrado(de: "Sib") == nil)
        #expect(Tonalidad(.do).nombreDeGrado(de: .si) == .sensible)

        #expect(laMenor.armonizar().map(\.cifrado) == ["Lam", "Si°", "Do", "Rem", "Mi", "Fa", "Sol♯°"])
        #expect(
            laMenor.armonizar(cuatriadas: true).map(\.cifrado) == [
                "Lam7", "Sim7(♭5)", "Domaj7", "Rem7", "Mi7", "Famaj7", "Sol♯°7",
            ])
        #expect(laMenor.cifradosRomanos() == ["i", "ii°", "III", "iv", "V", "VI", "vii°"])
        #expect(laMenor.cifradosRomanos(cuatriadas: true) == ["i7", "iiø7", "IIImaj7", "iv7", "V7", "VImaj7", "vii°7"])
        #expect(Tonalidad(.do).cifradosRomanos() == ["I", "ii", "iii", "IV", "V", "vi", "vii°"])
    }

    @Test func ortografiaEIdentificacion() {
        #expect(laMenor.ortografiar(midi: [69, 68, 69]).map(\.description) == ["La4", "Sol♯4", "La4"])
        #expect(
            laMenor.ortografiar(midi: [76, 77, 78, 80, 81]).map(\.description) == [
                "Mi5", "Fa5", "Fa♯5", "Sol♯5", "La5",
            ])
        #expect(Altura(midi: 68, tonalidad: laMenor).description == "Sol♯4")
        #expect(Acorde.identificar(midi: [60, 64, 68], tonalidad: laMenor).first?.cifrado == "Do+")
        #expect(Acorde.identificar(midi: [66, 70, 73], escala: Escala("Solb mayor")).first?.cifrado == "Sol♭")
        #expect(Tonalidad.candidatos(midi: [69, 71, 72, 74, 76, 77, 80, 81]).first?.valor == laMenor)
    }

    @Test func textoYProtocolos() throws {
        #expect(Tonalidad("A minor") == laMenor)
        #expect(Tonalidad("La menor armónica") == laMenor)
        #expect(laMenor.nombre == "La menor")
        #expect(laMenor.nombre(en: .inglesASCII) == "A minor")
        #expect(Tonalidad(Escala(.la, .menorMelodica)) == laMenor)
        #expect(Tonalidad(Escala(.re, .dorico)) == nil)
        do {
            _ = try Tonalidad(leyendo: "Re dórico")
            Issue.record("Se esperaba un error")
        } catch {
            #expect((error as? ErrorDeLecturaDeTeoria)?.motivo == .modoNoReconocido("dórico"))

        }
        for tonalidad in Tonalidad.circuloDeQuintas() + Tonalidad.circuloDeQuintas(.menor) {
            for notacion in Notacion.allCases {
                #expect(
                    (try? Tonalidad(leyendo: tonalidad.texto(en: notacion))) == tonalidad,
                    Comment(rawValue: tonalidad.texto(en: notacion)))
            }
        }
        let datos = try JSONEncoder().encode([laMenor])
        #expect(String(decoding: datos, as: UTF8.self) == "[\"La menor\"]")
        #expect(try (JSONDecoder().decode([Tonalidad].self, from: datos)) == [laMenor])

        #expect((Tonalidad(.do) + .quintaJusta) == Tonalidad(.sol))
        #expect(laMenor.numeroDeForte == "7-35")
        #expect(InstrumentoDePartitura.trompaEnFa.escritura(de: Tonalidad("Sib mayor")) == Tonalidad(.fa))
    }
}
