import Armonia
import Foundation
import Testing

@testable import ArmoniaPresentacion

/// Las tablaturas en MusicXML: cuerda y traste de cada nota, la afinación y el capo.
@Suite struct TablaturaTests {
    @Test func lasDigitacionesConCapo() throws {
        let mastil = Mastil(Encordado.guitarra.conCapo(2), trastes: 13)
        let acordes = [Acorde("Re"), Acorde("La")]
        let formas = acordes.compactMap { mastil.digitaciones(de: $0, limite: 1).first }
        #expect(formas.count == 2)
        let xml = PresentacionDeTablatura.musicXML(digitaciones: formas, acordes: acordes, titulo: "Con capo")
        #expect(xml.contains("<sign>TAB</sign>"))
        #expect(xml.contains("<capo>2</capo>"))
        #expect(xml.contains("<staff-lines>6</staff-lines>"))
        // La afinación es la de las cuerdas al aire, sin el capo: la línea 1 es el Mi2 grave.
        let primeraCuerda = "<staff-tuning line=\"1\"><tuning-step>E</tuning-step><tuning-octave>2</tuning-octave>"
        #expect(xml.contains(primeraCuerda))
        #expect(xml.contains("<words>Re</words>"))
        // x32010: la cuerda 5 (La) en el traste 3, desde el capo.
        #expect(xml.contains("<string>5</string><fret>3</fret>"))
        #expect((xml.components(separatedBy: "<measure ").count - 1) == 2)
        // Se lee con las notas que suenan.
        let pieza = try PiezaImportada(musicXML: Data(xml.utf8))
        #expect(pieza.titulo == "Con capo")
        #expect(pieza.notas.prefix(5).map(\.altura.midi) == [50, 54, 57, 62, 66])
        #expect(Set(pieza.notas.map(\.duracion)) == [.redonda])
    }

    @Test func unArpegioEnElMastil() throws {
        let mastil = Mastil(.guitarra, trastes: 12)
        let acorde = Acorde("Sib")
        let posicion = try #require(mastil.arpegios(de: acorde).first)
        let xml = PresentacionDeTablatura.musicXML(arpegio: posicion, acorde: acorde, titulo: "Arpegio")
        #expect(!xml.contains("<capo>"))
        let pieza = try PiezaImportada(musicXML: Data(xml.utf8))
        #expect(pieza.notas.map(\.altura.midi) == posicion.alturas.map(\.midi))
        #expect(pieza.notas.allSatisfy { $0.duracion == .corchea })
        // Con la ortografía del acorde: Si♭ y no La♯.
        #expect(!(pieza.notas.contains { $0.altura.nota == Nota.la.sostenido }))
        // Ocho corcheas por compás; el último se completa con un silencio.
        let compases = (posicion.posiciones.count + 7) / 8
        #expect((xml.components(separatedBy: "<measure ").count - 1) == compases)
        #expect(xml.contains("<rest/>") == (posicion.posiciones.count % 8 != 0))
    }

    @Test func laOrtografiaEscrita() {
        let siBemol = PresentacionDeTablatura.escrita(Altura(midi: 70), ortografia: [Nota.si.bemol])
        #expect(siBemol.nota == Nota.si.bemol)
        #expect(siBemol.midi == 70)
        #expect(PresentacionDeTablatura.escrita(Altura(midi: 60), ortografia: [Nota.si.sostenido]).octava == 3)
        #expect(PresentacionDeTablatura.escrita(Altura(midi: 60), ortografia: []).midi == 60)
    }

    @Test func unaEscalaEnElMastilYLasFiguras() throws {
        let mastil = Mastil(.guitarra, trastes: 12)
        let escala = Escala(.fa, .mayor)
        let posicion = try #require(mastil.posicionesCAGED(de: escala).first)
        let corcheas = PresentacionDeTablatura.musicXML(posicion: posicion, escala: escala, titulo: "Fa mayor")
        let pieza = try PiezaImportada(musicXML: Data(corcheas.utf8))
        #expect(pieza.notas.map(\.altura.midi) == posicion.posiciones.map { mastil.altura(en: $0).midi })
        // Con la ortografía de la escala: Si♭ y no La♯.
        #expect(!(pieza.notas.contains { $0.altura.nota == Nota.la.sostenido }))
        // Sin la escala, las notas se escriben como salen.
        let sinEscala = PresentacionDeTablatura.musicXML(posicion: posicion, titulo: "Posición")
        #expect(sinEscala.contains("<type>eighth</type>"))
        for (figura, tipo) in [
            (Figura.cuadrada, "whole"), (.redonda, "whole"), (.blanca, "half"), (.negra, "quarter"),
            (.semicorchea, "16th"),
        ] {
            let xml = PresentacionDeTablatura.musicXML(posicion: posicion, figura: figura, titulo: "Figuras")
            #expect(xml.contains("<type>\(tipo)</type>"), "\(figura)")
        }
        #expect(PresentacionDeTablatura.ticks(.cuadrada) == 32)
        let arpegio = try #require(mastil.arpegios(de: Acorde("Do")).first)
        let sinAcorde = PresentacionDeTablatura.musicXML(arpegio: arpegio, figura: .negra, titulo: "Do")
        #expect(sinAcorde.contains("<type>quarter</type>"))
    }

    @Test func sinDigitacionesSinAcordesYConAlteraciones() throws {
        // Sin digitaciones, un compás de silencio; el título se escapa.
        let vacia = PresentacionDeTablatura.musicXML(digitaciones: [], titulo: "Do & <Re> \"Mi\"")
        #expect(vacia.contains("<rest/>"))
        #expect(vacia.contains("Do &amp; &lt;Re&gt; &quot;Mi&quot;"))
        // Una afinación con alteraciones (Fa♯ y Si♭) y una digitación sin cuerdas pisadas.
        let encordado = Encordado(
            nombre: "rara", cuerdas: [Altura(Nota.fa.sostenido, octava: 2), Altura(Nota.si.bemol, octava: 2)])
        let mastil = Mastil(encordado, trastes: 12)
        let muda = Digitacion(mastil: mastil, trastes: [nil, nil])
        let tocada = Digitacion(mastil: mastil, trastes: [0, 1])
        let xml = PresentacionDeTablatura.musicXML(digitaciones: [muda, tocada], titulo: "Rara")
        #expect(xml.contains("<tuning-alter>1</tuning-alter>"))
        #expect(xml.contains("<tuning-alter>-1</tuning-alter>"))
        #expect(xml.contains("<rest/>"))
        #expect(!xml.contains("<words>"))
        #expect(xml.contains("<chord/>"))
        #expect((xml.components(separatedBy: "<measure ").count - 1) == 2)
    }
}
