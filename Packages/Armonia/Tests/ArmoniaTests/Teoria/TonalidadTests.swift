import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

@Suite struct TonalidadTests {
    private func escrito(_ escala: Escala, _ midi: [Int]) -> [String] {
        escala.ortografiar(midi: midi).map(\.nota.nombre)
    }

    @Test func ortografiaCromaticaSegunLaDireccion() {
        let doMayor = Escala(.do)
        #expect(escrito(doMayor, [60, 61, 62]) == ["Do", "Do♯", "Re"])
        #expect(escrito(doMayor, [62, 61, 60]) == ["Re", "Re♭", "Do"])
        #expect(escrito(doMayor, [67, 68, 69]) == ["Sol", "Sol♯", "La"])
        #expect(escrito(doMayor, [69, 68, 67]) == ["La", "La♭", "Sol"])
        #expect(escrito(doMayor, [69, 70, 71]) == ["La", "La♯", "Si"])
        #expect(escrito(doMayor, [71, 70, 69]) == ["Si", "Si♭", "La"])
        #expect(escrito(doMayor, [60, 61, 61, 62]) == ["Do", "Do♯", "Do♯", "Re"])
    }

    @Test func ortografiaSinContexto() {
        let doMayor = Escala(.do)
        // Cada nota por separado (sin nota siguiente que indique dirección).
        #expect([61, 63, 66, 68, 70].map { escrito(doMayor, [$0])[0] } == ["Do♯", "Mi♭", "Fa♯", "La♭", "Si♭"])
        // En una línea ascendente suben con sostenido (la última, sin siguiente, vuelve a Si♭).
        #expect(escrito(doMayor, [61, 63, 66, 68, 70]) == ["Do♯", "Re♯", "Fa♯", "Sol♯", "Si♭"])
        #expect(escrito(Escala(.fa), [70]) == ["Si♭"])
        #expect(escrito(Escala(.la, .menorNatural), [68]) == ["Sol♯"])
        #expect(escrito(Escala(.la, .menorArmonica), [68]) == ["Sol♯"])
        #expect(escrito(Escala("Fa# mayor"), [65, 60]) == ["Mi♯", "Si♯"])
        #expect(Altura(midi: 70, escala: Escala(.fa)).description == "Si♭4")
        #expect(Escala(.do).ortografiar(midi: [60, 61, 62]).map(\.midi) == [60, 61, 62])
    }

    @Test func deteccionDeTonalidad() {
        let doMayor = Tonalidad.candidatos(midi: [60, 62, 64, 65, 67, 69, 71, 72])
        #expect(doMayor.count == 24)
        #expect(doMayor.first?.valor == Tonalidad(.do))
        #expect(doMayor.map(\.correlacion) == doMayor.map(\.correlacion).sorted(by: >))

        let laMenor = Tonalidad.candidatos(midi: [69, 71, 72, 74, 76, 77, 80, 81, 69, 76, 69])
        #expect(laMenor.first?.valor == Tonalidad(.la, .menor))

        #expect(Tonalidad.candidatos(midi: [61, 63, 65, 66, 68, 70, 72, 73]).first?.valor.nombre == "Re♭ mayor")
        #expect(Tonalidad.candidatos(midi: [66, 68, 70, 71, 73, 75, 77, 78]).first?.valor.nombre == "Fa♯ mayor")
        let solBemol: [Nota] = ["Solb", "Lab", "Sib", "Dob", "Reb", "Mib", "Fa"]
        #expect(Tonalidad.candidatos(notas: solBemol).first?.valor.nombre == "Sol♭ mayor")

        let ponderada = Tonalidad.candidatos(
            midi: [60, 64, 67, 72, 67, 64, 60],
            duraciones: [2, 1, 1, 2, 1, 1, 2])
        #expect(ponderada.first?.valor == Tonalidad(.do))
        #expect(Tonalidad.candidatos(midi: []).isEmpty)
    }
}

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
            #expect((error as? ErrorDeLectura)?.motivo == .modoNoReconocido("dórico"))

        }
        for tonalidad in Tonalidad.circuloDeQuintas() + Tonalidad.circuloDeQuintas(.menor) {
            for notacion in Notacion.allCases {
                #expect(
                    Tonalidad(texto: tonalidad.texto(en: notacion)) == tonalidad,
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
