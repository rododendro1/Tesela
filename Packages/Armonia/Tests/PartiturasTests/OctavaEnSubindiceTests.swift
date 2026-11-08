import Foundation
import Testing

@testable import Elementos
@testable import Partituras
@testable import Teoria

/// La octava de las alturas escrita como subíndice (La₄): al escribir, en las notaciones compactas o con
/// `Notacion.conOctavas(.subindices)`, y al leer, siempre.
@Suite struct OctavaEnSubindiceTests {
    private let subindices = Notacion.compacta(.espanol)
    private let cifras = Notacion.compacta(.espanol).conOctavas(.cifras)

    @Test func escribirLaOctava() {
        #expect(EscrituraDeLaOctava.cifras.escribir(4) == "4")
        #expect(EscrituraDeLaOctava.subindices.escribir(4) == "₄")
        #expect(EscrituraDeLaOctava.subindices.escribir(10) == "₁₀")
        #expect(EscrituraDeLaOctava.subindices.escribir(-1) == "₋₁")
        #expect(EscrituraDeLaOctava.conCifras("Si♭₋₁ y La₁₀") == "Si♭-1 y La10")
    }

    @Test func laNotacionGuardaLaEleccion() {
        // Las compactas escriben la octava como subíndice y las demás, con cifras.
        #expect(Notacion.compacta(.espanol).octavas == .subindices)
        #expect(Notacion.compacta(.ingles).octavas == .subindices)
        #expect(Notacion.compacta(.aleman).octavas == .subindices)
        for notacion in [
            Notacion.conPalabras(.espanol), .ascii(.espanol), .conPalabras(.ingles), .ascii(.ingles),
            .conPalabras(.aleman),
            .conPalabras(.frances),
            .conPalabras(.ruso),
        ] {
            #expect(notacion.octavas == .cifras, "\(notacion)")
        }
        #expect(
            Notacion.allCases.filter { $0.octavas == .subindices } == [
                .compacta(.espanol), .compacta(.ingles), .compacta(.catalan), .compacta(.gallego), .compacta(.euskera),
                .compacta(.portugues), .compacta(.frances), .compacta(.italiano), .compacta(.aleman),
                .compacta(.griego), .compacta(.ruso), .compacta(.hungaro), .compacta(.sueco),
            ])
        #expect(Notacion.delIdioma(.espanol).octavas == .subindices)
        #expect(Notacion.delIdioma(.ingles).octavas == .cifras)
        #expect(cifras.octavas == .cifras)
        #expect(cifras.conTextos(en: .ingles).octavas == .cifras)
        #expect(cifras.conTextos(en: .ingles).textos == .ingles)
        #expect(cifras.notacionDeLasNotas == .compacta(.espanol))
        #expect(cifras != .compacta(.espanol))
        #expect(cifras.conOctavas(.subindices) == .compacta(.espanol))
        #expect(Notacion(escritura: .compacta(.espanol), octavas: .cifras) == cifras)
    }

    @Test func nombresConSubindice() {
        #expect(Altura(.la, octava: 4).nombre(en: subindices) == "La₄")
        #expect(Altura(Nota.fa.sostenido, octava: 3).nombre(en: subindices) == "Fa♯₃")
        #expect(Altura(Nota.si.bemol, octava: -1).nombre(en: subindices) == "Si♭₋₁")
        #expect(Altura(Nota.fa.sostenido, octava: 4).nombre(en: .ascii(.ingles).conOctavas(.subindices)) == "F#₄")
        #expect(
            Altura(Nota.fa.sostenido, octava: 4).nombre(en: .conPalabras(.frances).conOctavas(.subindices))
                == "fa dièse ₄")
        #expect(Altura(Nota.fa.sostenido, octava: 4).nombreCompacto(en: subindices) == "Fa♯₄")
        #expect(Altura(Nota.fa.sostenido, octava: 4).nombreCompacto(en: .conPalabras(.espanol)) == "Fa♯4")
        #expect(Altura(Nota.fa.sostenido, octava: 4).nombre(en: .compacta(.ingles)) == "F♯₄")
        #expect(Altura(Nota.fa.sostenido, octava: 4).nombre(en: .compacta(.aleman)) == "Fis₄")
        #expect(Altura(Nota.fa.sostenido, octava: 4).nombre(en: cifras) == "Fa♯4")
        // En las que no son compactas, y en `description` y la codificación, con cifras.
        #expect(Altura(.la, octava: 4).nombre(en: .ascii(.espanol)) == "La4")
        #expect(Altura(.la, octava: 4).nombre(en: .conPalabras(.espanol)) == "La4")
        #expect(Altura(.la, octava: 4).description == "La4")
        #expect(Altura(.la, octava: 4).texto == "La4")
        #expect(Altura(.la, octava: 4).nombreCompleto == "La4")
    }

    @Test func leerSubindices() throws {
        #expect(try (Altura(leyendo: "La₄")) == Altura(.la, octava: 4))
        #expect(try (Altura(leyendo: "Do♯₃")) == Altura(Nota.`do`.sostenido, octava: 3))
        #expect(try (Altura(leyendo: "Si♭₋₁")) == Altura(Nota.si.bemol, octava: -1))
        #expect(try (Altura(leyendo: "C#₅")) == Altura(Nota.`do`.sostenido, octava: 5))
        #expect(try (Altura(leyendo: "ré bémol ₃", en: .conPalabras(.frances))) == Altura(Nota.re.bemol, octava: 3))
        #expect(try (Altura(leyendo: "Fis₄", en: .conPalabras(.aleman))) == Altura(Nota.fa.sostenido, octava: 4))
        #expect(throws: (any Error).self) { try Altura(leyendo: "La₄x") }
        #expect(throws: (any Error).self) { try Altura(leyendo: "La") }
    }

    @Test func idaYVuelta() throws {
        for notacion in [
            subindices, .ascii(.ingles).conOctavas(.subindices), .conPalabras(.aleman).conOctavas(.subindices),
        ] {
            for midi in [21, 47, 60, 61, 70, 108] {
                let altura = Altura(midi: midi)
                #expect(try (Altura(leyendo: altura.nombre(en: notacion), en: notacion)) == altura, "\(notacion)")
            }
        }
    }

    @Test func melodias() throws {
        #expect(try (Evento(leyendo: "Mi₄:4").alturas) == [Altura(.mi, octava: 4)])
    }
}
