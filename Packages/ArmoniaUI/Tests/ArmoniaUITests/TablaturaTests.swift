import Armonia
import Foundation
import XCTest

@testable import ArmoniaPresentacion

/// Las tablaturas en MusicXML: cuerda y traste de cada nota, la afinación y el capo.
final class TablaturaTests: XCTestCase {
    func testLasDigitacionesConCapo() throws {
        let mastil = Mastil(Encordado.guitarra.conCapo(2), trastes: 13)
        let acordes = [Acorde("Re"), Acorde("La")]
        let formas = acordes.compactMap { mastil.digitaciones(de: $0, limite: 1).first }
        XCTAssertEqual(formas.count, 2)
        let xml = PresentacionDeTablatura.musicXML(digitaciones: formas, acordes: acordes, titulo: "Con capo")
        XCTAssertTrue(xml.contains("<sign>TAB</sign>"))
        XCTAssertTrue(xml.contains("<capo>2</capo>"))
        XCTAssertTrue(xml.contains("<staff-lines>6</staff-lines>"))
        // La afinación es la de las cuerdas al aire, sin el capo: la línea 1 es el Mi2 grave.
        let primeraCuerda = "<staff-tuning line=\"1\"><tuning-step>E</tuning-step><tuning-octave>2</tuning-octave>"
        XCTAssertTrue(xml.contains(primeraCuerda))
        XCTAssertTrue(xml.contains("<words>Re</words>"))
        // x32010: la cuerda 5 (La) en el traste 3, desde el capo.
        XCTAssertTrue(xml.contains("<string>5</string><fret>3</fret>"))
        XCTAssertEqual(xml.components(separatedBy: "<measure ").count - 1, 2)
        // Se lee con las notas que suenan.
        let pieza = try PiezaImportada(musicXML: Data(xml.utf8))
        XCTAssertEqual(pieza.titulo, "Con capo")
        XCTAssertEqual(pieza.notas.prefix(5).map(\.altura.midi), [50, 54, 57, 62, 66])
        XCTAssertEqual(Set(pieza.notas.map(\.duracion)), [.redonda])
    }

    func testUnArpegioEnElMastil() throws {
        let mastil = Mastil(.guitarra, trastes: 12)
        let acorde = Acorde("Sib")
        let posicion = try XCTUnwrap(mastil.arpegios(de: acorde).first)
        let xml = PresentacionDeTablatura.musicXML(arpegio: posicion, acorde: acorde, titulo: "Arpegio")
        XCTAssertFalse(xml.contains("<capo>"))
        let pieza = try PiezaImportada(musicXML: Data(xml.utf8))
        XCTAssertEqual(pieza.notas.map(\.altura.midi), posicion.alturas.map(\.midi))
        XCTAssertTrue(pieza.notas.allSatisfy { $0.duracion == .corchea })
        // Con la ortografía del acorde: Si♭ y no La♯.
        XCTAssertFalse(pieza.notas.contains { $0.altura.nota == Nota.la.sostenido })
        // Ocho corcheas por compás; el último se completa con un silencio.
        let compases = (posicion.posiciones.count + 7) / 8
        XCTAssertEqual(xml.components(separatedBy: "<measure ").count - 1, compases)
        XCTAssertEqual(xml.contains("<rest/>"), posicion.posiciones.count % 8 != 0)
    }

    func testLaOrtografiaEscrita() {
        let siBemol = PresentacionDeTablatura.escrita(Altura(midi: 70), ortografia: [Nota.si.bemol])
        XCTAssertEqual(siBemol.nota, Nota.si.bemol)
        XCTAssertEqual(siBemol.midi, 70)
        XCTAssertEqual(PresentacionDeTablatura.escrita(Altura(midi: 60), ortografia: [Nota.si.sostenido]).octava, 3)
        XCTAssertEqual(PresentacionDeTablatura.escrita(Altura(midi: 60), ortografia: []).midi, 60)
    }

    func testUnaEscalaEnElMastilYLasFiguras() throws {
        let mastil = Mastil(.guitarra, trastes: 12)
        let escala = Escala(.fa, .mayor)
        let posicion = try XCTUnwrap(mastil.posicionesCAGED(de: escala).first)
        let corcheas = PresentacionDeTablatura.musicXML(posicion: posicion, escala: escala, titulo: "Fa mayor")
        let pieza = try PiezaImportada(musicXML: Data(corcheas.utf8))
        XCTAssertEqual(pieza.notas.map(\.altura.midi), posicion.posiciones.map { mastil.altura(en: $0).midi })
        // Con la ortografía de la escala: Si♭ y no La♯.
        XCTAssertFalse(pieza.notas.contains { $0.altura.nota == Nota.la.sostenido })
        // Sin la escala, las notas se escriben como salen.
        let sinEscala = PresentacionDeTablatura.musicXML(posicion: posicion, titulo: "Posición")
        XCTAssertTrue(sinEscala.contains("<type>eighth</type>"))
        for (figura, tipo) in [
            (Figura.cuadrada, "whole"), (.redonda, "whole"), (.blanca, "half"), (.negra, "quarter"),
            (.semicorchea, "16th"),
        ] {
            let xml = PresentacionDeTablatura.musicXML(posicion: posicion, figura: figura, titulo: "Figuras")
            XCTAssertTrue(xml.contains("<type>\(tipo)</type>"), "\(figura)")
        }
        XCTAssertEqual(PresentacionDeTablatura.ticks(.cuadrada), 32)
        let arpegio = try XCTUnwrap(mastil.arpegios(de: Acorde("Do")).first)
        let sinAcorde = PresentacionDeTablatura.musicXML(arpegio: arpegio, figura: .negra, titulo: "Do")
        XCTAssertTrue(sinAcorde.contains("<type>quarter</type>"))
    }

    func testSinDigitacionesSinAcordesYConAlteraciones() throws {
        // Sin digitaciones, un compás de silencio; el título se escapa.
        let vacia = PresentacionDeTablatura.musicXML(digitaciones: [], titulo: "Do & <Re> \"Mi\"")
        XCTAssertTrue(vacia.contains("<rest/>"))
        XCTAssertTrue(vacia.contains("Do &amp; &lt;Re&gt; &quot;Mi&quot;"))
        // Una afinación con alteraciones (Fa♯ y Si♭) y una digitación sin cuerdas pisadas.
        let encordado = Encordado(
            nombre: "rara", cuerdas: [Altura(Nota.fa.sostenido, octava: 2), Altura(Nota.si.bemol, octava: 2)])
        let mastil = Mastil(encordado, trastes: 12)
        let muda = Digitacion(mastil: mastil, trastes: [nil, nil])
        let tocada = Digitacion(mastil: mastil, trastes: [0, 1])
        let xml = PresentacionDeTablatura.musicXML(digitaciones: [muda, tocada], titulo: "Rara")
        XCTAssertTrue(xml.contains("<tuning-alter>1</tuning-alter>"))
        XCTAssertTrue(xml.contains("<tuning-alter>-1</tuning-alter>"))
        XCTAssertTrue(xml.contains("<rest/>"))
        XCTAssertFalse(xml.contains("<words>"))
        XCTAssertTrue(xml.contains("<chord/>"))
        XCTAssertEqual(xml.components(separatedBy: "<measure ").count - 1, 2)
    }
}
