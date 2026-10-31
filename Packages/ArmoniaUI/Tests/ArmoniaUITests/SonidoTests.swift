import Armonia
import Foundation
import XCTest

@testable import ArmoniaPresentacion

// Lo que suena al pulsar «Escuchar». No usa AVFoundation: se ejecuta también en Linux.

final class SonidoTests: XCTestCase {
    func testUnAcordeSuenaDesdeSuBajoEnPosicionCerrada() throws {
        let sonido = Sonido.acorde(try Acorde(leyendo: "Sol7/Si"))
        XCTAssertEqual(sonido.notas.map(\.midi), [59, 62, 65, 67])
        XCTAssertEqual(Sonido.acorde(try Acorde(leyendo: "Do")).notas.map(\.midi), [48, 52, 55])
        // Arpegiado: cada nota empieza después de la anterior, y todas terminan a la vez.
        XCTAssertEqual(sonido.notas.map(\.inicio), sonido.notas.map(\.inicio).sorted())
        XCTAssertEqual(Set(sonido.notas.map { ($0.inicio + $0.duracion).rounded(toPlaces: 6) }).count, 1)
    }

    func testUnArpegioSuenaNotaANotaEnElOrdenDelPatron() throws {
        let alberti = Sonido.arpegio(Arpegio(try Acorde(leyendo: "Do"), patron: .alberti))
        XCTAssertEqual(alberti.notas.map(\.midi), [48, 55, 52, 55])
        XCTAssertEqual(alberti.tonica, .do)
        // Una detrás de otra, sin solaparse.
        for (nota, siguiente) in zip(alberti.notas, alberti.notas.dropFirst()) {
            XCTAssertLessThanOrEqual(nota.inicio + nota.duracion, siguiente.inicio)
        }
        XCTAssertEqual(Sonido.arpegio(Arpegio(try Acorde(leyendo: "Do7"))).notas.map(\.midi), [48, 52, 55, 58, 60])
    }

    func testUnaEscalaSubeHastaLaOctava() throws {
        let sonido = Sonido.escala(try Escala(leyendo: "Re dórico"))
        XCTAssertEqual(sonido.notas.map(\.midi), [62, 64, 65, 67, 69, 71, 72, 74])
    }

    func testLosCambiosVanEnOrdenYTerminanAntesDeEmpezar() {
        let sonido = Sonido(notas: [
            Sonido.NotaMIDI(midi: 60, inicio: 0, duracion: 1),
            Sonido.NotaMIDI(midi: 60, inicio: 1, duracion: 1),
        ])
        XCTAssertEqual(sonido.cambios.map(\.tiempo), [0, 1, 1, 2])
        XCTAssertEqual(sonido.cambios.map(\.esInicio), [true, false, true, false])
        XCTAssertEqual(sonido.duracion, 2)
        // Fuera del rango MIDI o sin duración, no suena.
        XCTAssertTrue(
            Sonido(notas: [
                Sonido.NotaMIDI(midi: 200, inicio: 0, duracion: 1),
                Sonido.NotaMIDI(midi: 60, inicio: 0, duracion: 0),
            ]).notas.isEmpty)
    }

    func testElAnalisisYElCoralSuenan() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Fa Sol7 Do", notacion: .espanolUnicode)
        XCTAssertEqual(Set(analisis.sonido.notas.map(\.inicio)), [0, 1, 2, 3])
        let coral = try PresentacionDeCoral.presentar(.realizar, "Do Fa Sol7 Do", notacion: .espanolUnicode)
        XCTAssertEqual(coral.sonido.notas.count, 16)
        let sinOctavas = try PresentacionDeCoral.presentar(.armonizar, "Mi Re Do", notacion: .espanolUnicode)
        XCTAssertTrue(sinOctavas.sonido.notas.isEmpty)
    }

    func testSeAfinaEnElTemperamentoElegido() throws {
        // Cada nota guarda su ortografía: en el mesotónico, Sol♯ y La♭ no suenan igual.
        let mi = Sonido.acorde(try Acorde(leyendo: "Mi"))
        XCTAssertEqual(mi.notas.map(\.altura), ["Mi3", "Sol#3", "Si3"])
        XCTAssertEqual(mi.tonica, .mi)
        let fa = Sonido.acorde(try Acorde(leyendo: "Fam"))
        XCTAssertEqual(fa.notas.map(\.altura), ["Fa3", "Lab3", "Do4"])
        let solSostenido = mi.afinado(en: .mesotonico).notas[1].desviacion
        let laBemol = fa.afinado(en: .mesotonico).notas[1].desviacion
        XCTAssertEqual(solSostenido - laBemol, -41.06, accuracy: 0.01) // la diesis menor
        // Sin elegir otro, suena en el temperamento igual.
        XCTAssertTrue(mi.notas.allSatisfy { $0.desviacion == 0 })
        XCTAssertTrue(mi.afinado(en: .igual).notas.allSatisfy { abs($0.desviacion) < 1e-9 })
        // La justa, sobre la tónica: la del acorde, la de la escala o, si no se sabe, Do.
        let justa = Sonido.acorde(try Acorde(leyendo: "Do")).afinado(en: .justa).notas.map {
            ($0.desviacion * 100).rounded() / 100
        }
        XCTAssertEqual(justa, [0, -13.69, 1.96])
        XCTAssertEqual(Sonido.escala(try Escala(leyendo: "Re mayor")).tonica, .re)
        XCTAssertNil(Sonido.coral([["Do4"]]).tonica)
        XCTAssertEqual(
            Sonido.coral([["Mi4"]]).conTonica(.do).afinado(en: .justa).notas[0].desviacion, -13.69, accuracy: 0.01)
        // Los cambios llevan la afinación y la nota a la que se refieren.
        let cambios = Sonido.acorde(try Acorde(leyendo: "Do")).afinado(en: .justa).cambios
        XCTAssertEqual(cambios.filter(\.esInicio).map(\.nota), [0, 1, 2])
        XCTAssertEqual(cambios.first { $0.nota == 1 && !$0.esInicio }?.desviacion ?? 0, -13.69, accuracy: 0.01)
    }

    func testElAnalisisYElCoralSuenanEnSuTonalidad() throws {
        XCTAssertEqual(
            try PresentacionDeAnalisis.analizar("Re Sol La7 Re", notacion: .espanolUnicode).sonido.tonica, .re)
        XCTAssertEqual(
            try PresentacionDeCoral.presentar(.realizar, "Re Sol La7 Re", notacion: .espanolUnicode).sonido.tonica, .re)
    }

    func testUnaVozSuenaConSuRitmo() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:8 -:8 Mi4:2~ Mi4:4")
        let sonido = Sonido.voz(voz, tempo: Tempo(60))
        // El silencio calla y la ligada no vuelve a empezar: Mi4 dura blanca y negra.
        XCTAssertEqual(sonido.notas.map(\.midi), [60, 62, 64])
        XCTAssertEqual(sonido.notas.map(\.inicio), [0, 1, 2])
        XCTAssertEqual(sonido.notas.map { $0.duracion.rounded(toPlaces: 6) }, [0.95, 0.475, 2.85])
    }

    func testUnaMelodiaConRitmoSeArmonizaYElCoralSuenaConEse() throws {
        let coral = try PresentacionDeCoral.presentar(
            .armonizar, "Mi4:2 Re4:4 Do4:4", tonalidad: "Do mayor",
            notacion: .espanolUnicode)
        XCTAssertEqual(coral.filas.count, 3)
        XCTAssertEqual(coral.sonido.notas.count, 12)
        let negra = 60 / 72.0
        XCTAssertEqual(
            Set(coral.sonido.notas.map { $0.inicio.rounded(toPlaces: 6) }),
            Set([0, 2 * negra, 3 * negra].map { $0.rounded(toPlaces: 6) }))
        // Sin ritmo, cada acorde dura lo mismo.
        let sinRitmo = try PresentacionDeCoral.presentar(
            .armonizar, "Mi4 Re4 Do4", tonalidad: "Do mayor",
            notacion: .espanolUnicode)
        XCTAssertEqual(Set(sinRitmo.sonido.notas.map(\.inicio)), [0, 1, 2])
    }

    func testUnaNotaSola() {
        XCTAssertEqual(Sonido.nota(60).notas.map(\.midi), [60])
        XCTAssertEqual(Sonido.nota(60, duracion: 2).duracion, 2)
        XCTAssertEqual(Sonido.nota(Altura(midi: 69)).notas.map(\.midi), [69])
        XCTAssertEqual(Sonido.silencio.duracion, 0)
        // Sin tónica se afina sobre Do: el Do queda igual y el Mi baja en la justa.
        let afinado = Sonido(notas: [.init(midi: 60, inicio: 0, duracion: 1), .init(midi: 64, inicio: 0, duracion: 1)])
            .afinado(en: .justa)
        XCTAssertEqual(afinado.notas[0].desviacion, 0, accuracy: 1e-9)
        XCTAssertEqual(afinado.notas[1].desviacion, -13.7, accuracy: 0.1)
    }
}

extension Double {
    fileprivate func rounded(toPlaces lugares: Int) -> Double {
        let factor = pow(10, Double(lugares))
        return (self * factor).rounded() / factor
    }
}
