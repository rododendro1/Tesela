import Testing

@testable import Elementos
@testable import Partituras
@testable import Teoria

@Suite struct FraseoTests {
    func acordes(_ cifrados: String...) throws -> [Acorde] { try cifrados.map { try Acorde(leyendo: $0) } }

    @Test func unCompasDeCorcheasPorAcorde() throws {
        let progresion = try acordes("Rem7", "Sol7", "Do7M")
        let voz = Voz(fraseando: progresion)
        #expect(voz.eventos.count == 17)
        #expect(voz.eventos.dropLast().allSatisfy { $0.duracion == .corchea })
        #expect(voz.eventos.last?.duracion == .redonda)
        let alturas = voz.eventos.map { $0.alturas[0] }
        // Cada compás empieza en su nota guía (la de la línea de notas guía) …
        let guias = Acorde.lineaDeNotasGuia(progresion, desde: .tercera, octava: 4)
        #expect([alturas[0], alturas[8], alturas[16]] == guias)
        #expect(guias.map(\.nombre) == ["Fa₄", "Fa₄", "Mi₄"])
        // … y acaba a un semitono de la del compás siguiente.
        #expect(abs(alturas[7].midi - alturas[8].midi) == 1)
        #expect(abs(alturas[15].midi - alturas[16].midi) == 1)
        // Por la escala de cada acorde: Re dórico en el primer compás.
        let dorico = Escala(.re, .dorico).notas
        #expect(alturas[0..<7].allSatisfy { dorico.contains($0.nota) })
        // Siempre la misma.
        #expect(Voz(fraseando: progresion) == voz)
    }

    @Test func enOtroCompasYEnUnaTonalidad() throws {
        let progresion = try acordes("Do", "Lam", "Fa", "Sol7", "Do")
        let voz = Voz(fraseando: progresion, tonalidad: Tonalidad(.do), compas: Compas(3, 4))
        #expect(voz.compas == Compas(3, 4))
        #expect(voz.eventos.count == 4 * 6 + 1)
        #expect(voz.eventos.last?.duracion == Duracion(3, 4))
        // En 5/8 caben cinco corcheas.
        #expect(Voz(fraseando: try acordes("Do", "Sol"), compas: Compas(5, 8)).eventos.count == 6)
    }

    @Test func casosLimite() throws {
        #expect(Voz(fraseando: []).eventos.isEmpty)
        let uno = Voz(fraseando: try acordes("Do7"))
        #expect(uno.eventos.count == 1)
        // En 2/8, la nota guía y la de aproximación.
        let corto = Voz(fraseando: try acordes("Do", "Fa", "Do"), compas: Compas(2, 8))
        #expect(corto.eventos.count == 5)
        // La aproximación lleva el nombre de la escala cuando es suya.
        let frase = Voz.frase(
            desde: Altura(.re, octava: 4), hacia: Altura(.mi, octava: 4), por: Escala(.do, .mayor), notas: 8)
        #expect(frase.count == 8)
        #expect(frase.first == Altura(.re, octava: 4))
        #expect(frase.last?.nombre == "Re♯₄")
        let bajando = Voz.frase(
            desde: Altura(.sol, octava: 4), hacia: Altura(.mi, octava: 4), por: Escala(.do, .mayor), notas: 8)
        #expect(bajando.last == Altura(.fa, octava: 4))
    }
}
