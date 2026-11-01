import Armonia
import Foundation
import Testing

@testable import ArmoniaPresentacion

// Lo que suena al pulsar «Escuchar». No usa AVFoundation: se ejecuta también en Linux.

@Suite struct EscuchaTests {
    @Test func unAcordeSuenaDesdeSuBajoEnPosicionCerrada() throws {
        let sonido = Escucha.acorde(try Acorde(leyendo: "Sol7/Si"))
        #expect(sonido.notas.map(\.midi) == [59, 62, 65, 67])
        #expect(try Escucha.acorde(Acorde(leyendo: "Do")).notas.map(\.midi) == [48, 52, 55])
        // Arpegiado: cada nota empieza después de la anterior, y todas terminan a la vez.
        #expect(sonido.notas.map(\.inicio) == sonido.notas.map(\.inicio).sorted())
        #expect(Set(sonido.notas.map { ($0.inicio + $0.duracion).rounded(toPlaces: 6) }).count == 1)
    }

    @Test func unArpegioSuenaNotaANotaEnElOrdenDelPatron() throws {
        let alberti = Escucha.arpegio(Arpegio(try Acorde(leyendo: "Do"), patron: .alberti))
        #expect(alberti.notas.map(\.midi) == [48, 55, 52, 55])
        #expect(alberti.tonica == .do)
        // Una detrás de otra, sin solaparse.
        for (nota, siguiente) in zip(alberti.notas, alberti.notas.dropFirst()) {
            #expect((nota.inicio + nota.duracion) <= siguiente.inicio)
        }
        #expect(try Escucha.arpegio(Arpegio(Acorde(leyendo: "Do7"))).notas.map(\.midi) == [48, 52, 55, 58, 60])
    }

    @Test func loQueSuenaEnCadaMomento() throws {
        let arpegio = Escucha.arpegio(Arpegio(try Acorde(leyendo: "Do")))
        #expect(arpegio.inicios == [0, 0.25, 0.5, 0.75])
        #expect(arpegio.paso(en: -0.1) == nil)
        #expect(arpegio.paso(en: 0) == 0)
        #expect(arpegio.paso(en: 0.3) == 1)
        #expect(arpegio.paso(en: 0.8) == 3)
        #expect(arpegio.paso(en: 5) == nil)
        // En una progresión, cada acorde es un paso aunque tenga varias notas.
        let progresion = Escucha.acordes([try Acorde(leyendo: "Do"), try Acorde(leyendo: "Sol7")])
        #expect(progresion.inicios == [0, 1])
        #expect(progresion.paso(en: 1.2) == 1)
    }

    @Test func unaEscalaSubeHastaLaOctava() throws {
        let sonido = Escucha.escala(try Escala(leyendo: "Re dórico"))
        #expect(sonido.notas.map(\.midi) == [62, 64, 65, 67, 69, 71, 72, 74])
    }

    @Test func losCambiosVanEnOrdenYTerminanAntesDeEmpezar() {
        let sonido = Escucha(notas: [
            Escucha.NotaMIDI(midi: 60, inicio: 0, duracion: 1),
            Escucha.NotaMIDI(midi: 60, inicio: 1, duracion: 1),
        ])
        #expect(sonido.cambios.map(\.tiempo) == [0, 1, 1, 2])
        #expect(sonido.cambios.map(\.esInicio) == [true, false, true, false])
        #expect(sonido.duracion == 2)
        // Fuera del rango MIDI o sin duración, no suena.
        #expect(
            Escucha(notas: [
                Escucha.NotaMIDI(midi: 200, inicio: 0, duracion: 1),
                Escucha.NotaMIDI(midi: 60, inicio: 0, duracion: 0),
            ]).notas.isEmpty)
    }

    @Test func elAnalisisYElCoralSuenan() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Fa Sol7 Do", notacion: .espanolUnicode)
        #expect(Set(analisis.sonido.notas.map(\.inicio)) == [0, 1, 2, 3])
        let coral = try PresentacionDeCoral.presentar(.realizar, "Do Fa Sol7 Do", notacion: .espanolUnicode)
        #expect(coral.sonido.notas.count == 16)
        let sinOctavas = try PresentacionDeCoral.presentar(.armonizar, "Mi Re Do", notacion: .espanolUnicode)
        #expect(sinOctavas.sonido.notas.isEmpty)
    }

    @Test func seAfinaEnElTemperamentoElegido() throws {
        // Cada nota guarda su ortografía: en el mesotónico, Sol♯ y La♭ no suenan igual.
        let mi = Escucha.acorde(try Acorde(leyendo: "Mi"))
        #expect(mi.notas.map(\.altura) == ["Mi3", "Sol#3", "Si3"])
        #expect(mi.tonica == .mi)
        let fa = Escucha.acorde(try Acorde(leyendo: "Fam"))
        #expect(fa.notas.map(\.altura) == ["Fa3", "Lab3", "Do4"])
        let solSostenido = mi.afinado(en: .mesotonico).notas[1].desviacion
        let laBemol = fa.afinado(en: .mesotonico).notas[1].desviacion
        #expect(abs(solSostenido - laBemol - (-41.06)) <= 0.01) // la diesis menor
        // Sin elegir otro, suena en el temperamento igual.
        #expect(mi.notas.allSatisfy { $0.desviacion == 0 })
        #expect(mi.afinado(en: .igual).notas.allSatisfy { abs($0.desviacion) < 1e-9 })
        // La justa, sobre la tónica: la del acorde, la de la escala o, si no se sabe, Do.
        let justa = Escucha.acorde(try Acorde(leyendo: "Do")).afinado(en: .justa).notas.map {
            ($0.desviacion * 100).rounded() / 100
        }
        #expect(justa == [0, -13.69, 1.96])
        #expect(try Escucha.escala(Escala(leyendo: "Re mayor")).tonica == .re)
        #expect(Escucha.coral([["Do4"]]).tonica == nil)
        #expect(abs(Escucha.coral([["Mi4"]]).conTonica(.do).afinado(en: .justa).notas[0].desviacion - (-13.69)) <= 0.01)
        // Los cambios llevan la afinación y la nota a la que se refieren.
        let cambios = Escucha.acorde(try Acorde(leyendo: "Do")).afinado(en: .justa).cambios
        #expect(cambios.filter(\.esInicio).map(\.nota) == [0, 1, 2])
        #expect(abs((cambios.first { $0.nota == 1 && !$0.esInicio }?.desviacion ?? 0) - (-13.69)) <= 0.01)
    }

    @Test func elAnalisisYElCoralSuenanEnSuTonalidad() throws {
        #expect(try (PresentacionDeAnalisis.analizar("Re Sol La7 Re", notacion: .espanolUnicode).sonido.tonica) == .re)
        #expect(
            try (PresentacionDeCoral.presentar(.realizar, "Re Sol La7 Re", notacion: .espanolUnicode).sonido.tonica)
                == .re)
    }

    @Test func unaVozSuenaConSuRitmo() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:8 -:8 Mi4:2~ Mi4:4")
        let sonido = Escucha.voz(voz, tempo: Tempo(60))
        // El silencio calla y la ligada no vuelve a empezar: Mi4 dura blanca y negra.
        #expect(sonido.notas.map(\.midi) == [60, 62, 64])
        #expect(sonido.notas.map(\.inicio) == [0, 1, 2])
        #expect(sonido.notas.map { $0.duracion.rounded(toPlaces: 6) } == [0.95, 0.475, 2.85])
    }

    @Test func unaMelodiaConRitmoSeArmonizaYElCoralSuenaConEse() throws {
        let coral = try PresentacionDeCoral.presentar(
            .armonizar, "Mi4:2 Re4:4 Do4:4", tonalidad: "Do mayor",
            notacion: .espanolUnicode)
        #expect(coral.filas.count == 3)
        #expect(coral.sonido.notas.count == 12)
        let negra = 60 / 72.0
        #expect(
            Set(coral.sonido.notas.map { $0.inicio.rounded(toPlaces: 6) })
                == Set([0, 2 * negra, 3 * negra].map { $0.rounded(toPlaces: 6) }))
        // Sin ritmo, cada acorde dura lo mismo.
        let sinRitmo = try PresentacionDeCoral.presentar(
            .armonizar, "Mi4 Re4 Do4", tonalidad: "Do mayor",
            notacion: .espanolUnicode)
        #expect(Set(sinRitmo.sonido.notas.map(\.inicio)) == [0, 1, 2])
    }

    @Test func unaNotaSola() {
        #expect(Escucha.nota(60).notas.map(\.midi) == [60])
        #expect(Escucha.nota(60, duracion: 2).duracion == 2)
        #expect(Escucha.nota(Altura(midi: 69)).notas.map(\.midi) == [69])
        #expect(Escucha.silencio.duracion == 0)
        // Sin tónica se afina sobre Do: el Do queda igual y el Mi baja en la justa.
        let afinado = Escucha(notas: [.init(midi: 60, inicio: 0, duracion: 1), .init(midi: 64, inicio: 0, duracion: 1)])
            .afinado(en: .justa)
        #expect(abs(afinado.notas[0].desviacion - (0)) <= 1e-9)
        #expect(abs(afinado.notas[1].desviacion - (-13.7)) <= 0.1)
    }
}

extension Double {
    fileprivate func rounded(toPlaces lugares: Int) -> Double {
        let factor = pow(10, Double(lugares))
        return (self * factor).rounded() / factor
    }
}
