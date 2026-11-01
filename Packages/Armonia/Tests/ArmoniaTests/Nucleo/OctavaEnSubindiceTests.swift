import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

/// La octava de las alturas escrita como subíndice (La₄): al escribir, con `Notacion.conOctavas(.subindices)`, y al
/// leer, siempre.
@Suite struct OctavaEnSubindiceTests {
    private let subindices = Notacion.espanolUnicode.conOctavas(.subindices)

    @Test func escribirLaOctava() {
        #expect(EscrituraDeLaOctava.cifras.escribir(4) == "4")
        #expect(EscrituraDeLaOctava.subindices.escribir(4) == "₄")
        #expect(EscrituraDeLaOctava.subindices.escribir(10) == "₁₀")
        #expect(EscrituraDeLaOctava.subindices.escribir(-1) == "₋₁")
        #expect(EscrituraDeLaOctava.conCifras("Si♭₋₁ y La₁₀") == "Si♭-1 y La10")
    }

    @Test func laNotacionGuardaLaEleccion() {
        #expect(Notacion.espanolUnicode.octavas == .cifras)
        #expect(subindices.octavas == .subindices)
        #expect(subindices.conTextos(en: .ingles).octavas == .subindices)
        #expect(subindices.conTextos(en: .ingles).textos == .ingles)
        #expect(subindices.notas == .espanolUnicode)
        #expect(subindices != .espanolUnicode)
        #expect(subindices.conOctavas(.cifras) == .espanolUnicode)
    }

    @Test func nombresConSubindice() {
        #expect(Altura(.la, octava: 4).nombre(en: subindices) == "La₄")
        #expect(Altura(Nota.fa.sostenido, octava: 3).nombre(en: subindices) == "Fa♯₃")
        #expect(Altura(Nota.si.bemol, octava: -1).nombre(en: subindices) == "Si♭₋₁")
        #expect(Altura(Nota.fa.sostenido, octava: 4).nombre(en: .inglesASCII.conOctavas(.subindices)) == "F#₄")
        #expect(Altura(Nota.fa.sostenido, octava: 4).nombre(en: .frances.conOctavas(.subindices)) == "fa dièse ₄")
        #expect(Altura(Nota.fa.sostenido, octava: 4).nombreCompacto(en: subindices) == "Fa♯₄")
        #expect(Altura(Nota.fa.sostenido, octava: 4).nombreCompacto(en: .espanol) == "Fa♯4")
        // Sin pedirlo, todo sigue con cifras.
        #expect(Altura(.la, octava: 4).nombre(en: .espanolUnicode) == "La4")
        #expect(Altura(.la, octava: 4).description == "La4")
    }

    @Test func leerSubindices() throws {
        #expect(try (Altura(leyendo: "La₄")) == Altura(.la, octava: 4))
        #expect(try (Altura(leyendo: "Do♯₃")) == Altura(Nota.`do`.sostenido, octava: 3))
        #expect(try (Altura(leyendo: "Si♭₋₁")) == Altura(Nota.si.bemol, octava: -1))
        #expect(try (Altura(leyendo: "C#₅")) == Altura(Nota.`do`.sostenido, octava: 5))
        #expect(try (Altura(leyendo: "ré bémol ₃", en: .frances)) == Altura(Nota.re.bemol, octava: 3))
        #expect(try (Altura(leyendo: "Fis₄", en: .aleman)) == Altura(Nota.fa.sostenido, octava: 4))
        #expect(throws: (any Error).self) { try Altura(leyendo: "La₄x") }
        #expect(throws: (any Error).self) { try Altura(leyendo: "La") }
    }

    @Test func idaYVuelta() throws {
        for notacion in [subindices, .inglesASCII.conOctavas(.subindices), .aleman.conOctavas(.subindices)] {
            for midi in [21, 47, 60, 61, 70, 108] {
                let altura = Altura(midi: midi)
                #expect(try (Altura(leyendo: altura.nombre(en: notacion), en: notacion)) == altura, "\(notacion)")
            }
        }
    }

    @Test func melodiasYCorales() throws {
        #expect(try (Evento(leyendo: "Mi₄:4").alturas) == [Altura(.mi, octava: 4)])
        let coral = try Coral(leyendo: "Do₃ Mi₄ | Re₃ Fa₄")
        #expect(try coral == (Coral(leyendo: "Do3 Mi4 | Re3 Fa4")))
        #expect(coral.texto(en: subindices) == "Do₃ Mi₄ | Re₃ Fa₄")
        #expect(coral.texto(en: .espanolUnicode) == "Do3 Mi4 | Re3 Fa4")
    }
}
