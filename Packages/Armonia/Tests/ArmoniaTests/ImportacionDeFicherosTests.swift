import Foundation
import XCTest

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

// Ficheros escritos a mano como los dejan otros programas, no como los escribe la biblioteca: un MIDI de
// formato 1 con la pista de tempo aparte, uno de formato 0 con varios canales, y un MusicXML con la cabecera,
// los pentagramas y las voces de MuseScore. Así la lectura no se prueba solo contra nuestra propia escritura.

final class ImportacionDeFicherosTests: XCTestCase {
    private func nombres(_ pieza: PiezaImportada) -> [String] { pieza.notas.map(\.altura.nombre) }

    // MARK: MIDI

    /// La cabecera de un fichero MIDI estándar.
    private func cabecera(formato: UInt8, pistas: UInt8, divisiones: UInt16) -> [UInt8] {
        Array("MThd".utf8) + [0, 0, 0, 6, 0, formato, 0, pistas, UInt8(divisiones >> 8), UInt8(divisiones & 0xFF)]
    }

    /// Un bloque con su etiqueta y su largo.
    private func bloque(_ etiqueta: String, _ datos: [UInt8]) -> [UInt8] {
        let n = datos.count
        let largo = [24, 16, 8, 0].map { UInt8(n >> $0 & 0xFF) }
        return Array(etiqueta.utf8) + largo + datos
    }

    private func pista(_ eventos: [UInt8]) -> [UInt8] { bloque("MTrk", eventos + [0x00, 0xFF, 0x2F, 0x00]) }

    private func texto(_ tipo: UInt8, _ cadena: String) -> [UInt8] {
        let bytes = Array(cadena.utf8)
        return [0x00, 0xFF, tipo, UInt8(bytes.count)] + bytes
    }

    func testUnMIDIDeFormato1ConLaPistaDeTempoAparte() throws {
        // Lo que exportan los secuenciadores: la primera pista solo lleva el título, el tempo, el compás y la
        // armadura; cada instrumento va en su pista, con su nombre, y la percusión en el canal 10.
        let tempo = pista(
            texto(0x03, "Minueto") + [
                0x00, 0xF0, 0x05, 0x7E, 0x7F, 0x09, 0x01, 0xF7, // sistema exclusivo (GM encendido)
                0x00, 0xFF, 0x51, 0x03, 0x07, 0xA1, 0x20, // negra = 500 000 µs: 120
                0x00, 0xFF, 0x58, 0x04, 0x03, 0x02, 0x18, 0x08, // 3/4
                0x00, 0xFF, 0x59, 0x02, 0x01, 0x00, // un sostenido, mayor
            ])
        // La melodía, en el canal 1, con estado en curso y las notas cerradas con velocidad 0.
        let melodia = pista(
            texto(0x03, "Piano") + [
                0x00, 0xC0, 0x00, // programa
                0x00, 0xB0, 0x07, 0x64, // volumen
                0x00, 0x90, 0x43, 0x50, // Sol4
                0x60, 0x43, 0x00,
                0x00, 0x42, 0x50, // Fa♯4
                0x60, 0x42, 0x00,
                0x00, 0x43, 0x50, // Sol4
                0x60, 0x43, 0x00,
                0x00, 0xE0, 0x00, 0x40, // inflexión, en el centro
            ])
        // El bajo, en el canal 2, cerrado con «note off».
        let bajo = pista(
            texto(0x03, "Bajo") + [
                0x00, 0x91, 0x2B, 0x50, // Sol2
                0x82, 0x20, 0x81, 0x2B, 0x40, // tres negras (288 pulsos) después
            ])
        let percusion = pista([
            0x00, 0x99, 0x24, 0x64, // bombo
            0x60, 0x24, 0x00,
        ])
        let datos =
            cabecera(formato: 1, pistas: 4, divisiones: 96)
            + bloque("XFIH", [1, 2, 3]) // un bloque que no es de MIDI: se salta
            + tempo + melodia + bajo + percusion
        let pieza = try PiezaImportada(leyendo: Data(datos))

        XCTAssertEqual(pieza.titulo, "Minueto") // no "Piano": el nombre de una pista no es el título
        XCTAssertEqual(pieza.tempo, Tempo(120))
        XCTAssertEqual(pieza.compas, Compas(3, 4))
        XCTAssertEqual(pieza.tonalidad, Tonalidad(.sol))
        // La armadura da la ortografía: Fa♯, no Sol♭.
        XCTAssertEqual(nombres(pieza), ["Sol2", "Sol4", "Fa♯4", "Sol4"])
        XCTAssertEqual(pieza.notas.map(\.inicio), [.cero, .cero, .negra, .blanca])
        XCTAssertEqual(pieza.notas.map(\.duracion), [Duracion(3, 4), .negra, .negra, .negra])
        // La melodía sale antes en el fichero: es la parte 0.
        XCTAssertEqual(pieza.notas.map(\.parte), [1, 0, 0, 0])
        XCTAssertEqual(pieza.duracion, Duracion(3, 4))
    }

    func testUnMIDIDeFormato0ConVariosCanalesYSinArmadura() throws {
        // Una sola pista con dos canales mezclados: los acordes en el 1, el bajo en el 2. Sin armadura, la
        // ortografía sale de la tonalidad que mejor explica las notas.
        let eventos: [UInt8] = [
            0x00, 0x91, 0x2D, 0x50, // La2
            0x00, 0x90, 0x3C, 0x50, // Do4
            0x00, 0x40, 0x50, // Mi4, con el estado en curso
            0x78, 0x81, 0x2D, 0x40, // una negra (120 pulsos) después
            0x00, 0x80, 0x3C, 0x40,
            0x00, 0x40, 0x40,
            0x00, 0x91, 0x28, 0x50, // Mi2
            0x00, 0x90, 0x3E, 0x50, // Re4
            0x00, 0x44, 0x50, // Sol♯4
            0x00, 0x47, 0x50, // Si4
            0x78, 0x91, 0x28, 0x00, // las cuatro, cerradas con velocidad 0
            0x00, 0x90, 0x3E, 0x00,
            0x00, 0x44, 0x00,
            0x00, 0x47, 0x00,
            0x00, 0x91, 0x2D, 0x50, // La2
            0x00, 0x90, 0x3C, 0x50, // Do4
            0x00, 0x40, 0x50, // Mi4
            0x78, 0x91, 0x2D, 0x00,
            0x00, 0x90, 0x3C, 0x00,
            0x00, 0x40, 0x00,
        ]
        let pieza = try PiezaImportada(midi: Data(cabecera(formato: 0, pistas: 1, divisiones: 120) + pista(eventos)))
        XCTAssertNil(pieza.titulo)
        XCTAssertNil(pieza.tonalidad)
        XCTAssertNil(pieza.compas)
        XCTAssertNil(pieza.tempo)
        XCTAssertEqual(pieza.tonalidadEstimada, Tonalidad(.la, .menor))
        XCTAssertEqual(nombres(pieza), ["La2", "Do4", "Mi4", "Mi2", "Re4", "Sol♯4", "Si4", "La2", "Do4", "Mi4"])
        XCTAssertEqual(Set(pieza.notas.map(\.duracion)), [.negra])
        // Los dos canales de la misma pista son dos partes.
        XCTAssertEqual(Set(pieza.notas.map(\.parte)), [0, 1])
        XCTAssertEqual(pieza.acordes().map(\.cifrado), ["Lam", "Mi7", "Lam"])
    }

    func testLasNotasRepetidasYLasQueNoSeCierran() throws {
        let eventos: [UInt8] = [
            0x00, 0xFF, 0x59, 0x02, 0x00, 0x00, // Do mayor
            0x00, 0x90, 0x3C, 0x64, // Do4
            0x3C, 0x3C, 0x64, // otra vez Do4, sin cerrar la anterior: la cierra
            0x3C, 0x80, 0x3C, 0x00,
            0x00, 0x90, 0x40, 0x64, // Mi4, que no se cierra: dura hasta el final de la pista
            0x00, 0x99, 0x26, 0x64, // caja, en el canal 10: no cuenta
            // Una blanca después, velocidad 0 sin ninguna nota abierta: no hace nada.
            0x81, 0x70, 0x90, 0x3C, 0x00,
        ]
        let pieza = try PiezaImportada(midi: Data(cabecera(formato: 0, pistas: 1, divisiones: 120) + pista(eventos)))
        XCTAssertEqual(nombres(pieza), ["Do4", "Do4", "Mi4"])
        XCTAssertEqual(pieza.notas.map(\.inicio), [.cero, .corchea, .negra])
        XCTAssertEqual(pieza.notas.map(\.duracion), [.corchea, .corchea, .blanca])
    }

    func testUnMIDIConMasPistasDeLasQueTieneNoSeCuelga() throws {
        // La cabecera dice tres pistas, pero el fichero acaba tras la primera.
        let datos = cabecera(formato: 1, pistas: 3, divisiones: 96) + pista([0x00, 0x90, 0x3C, 0x64, 0x60, 0x3C, 0x00])
        let pieza = try PiezaImportada(midi: Data(datos))
        XCTAssertEqual(nombres(pieza), ["Do4"])
    }

    func testUnaPistaCortadaEsUnMIDIDanado() {
        // El largo de la pista dice más bytes de los que hay.
        var datos = cabecera(formato: 0, pistas: 1, divisiones: 96) + pista([0x00, 0x90, 0x3C, 0x64, 0x60, 0x3C, 0x00])
        datos.removeLast(3)
        XCTAssertThrowsError(try PiezaImportada(midi: Data(datos))) { error in
            XCTAssertEqual(error as? ErrorDeImportacion, .midiDanado)
        }
    }

    // MARK: MusicXML

    func testUnMusicXMLComoLoExportaMuseScore() throws {
        // Con la declaración de tipo de documento, la identificación y la maquetación, que no interesan; un piano
        // con dos pentagramas (la mano izquierda vuelve atrás con `<backup>` y avanza con `<forward>`), una
        // ligadura que cruza la barra, un cambio de armadura en el segundo compás (cuenta la primera), un
        // violonchelo con otras divisiones y un compás de silencio, y una parte de percusión.
        let xml = """
            <?xml version="1.0" encoding="UTF-8" standalone="no"?>
            <!DOCTYPE score-partwise PUBLIC "-//Recordare//DTD MusicXML 4.0 Partwise//EN" "http://www.musicxml.org/dtds/partwise.dtd">
            <score-partwise version="4.0">
              <movement-title>Sonatina</movement-title>
              <identification>
                <creator type="composer">Anónimo</creator>
                <encoding><software>MuseScore 4.4.0</software><encoding-date>2026-10-30</encoding-date></encoding>
              </identification>
              <defaults><scaling><millimeters>7</millimeters><tenths>40</tenths></scaling></defaults>
              <part-list>
                <score-part id="P1"><part-name>Piano</part-name>
                  <midi-instrument id="P1-I1"><midi-channel>1</midi-channel><midi-program>1</midi-program></midi-instrument>
                </score-part>
                <score-part id="P2"><part-name>Violonchelo</part-name></score-part>
                <score-part id="P3"><part-name>Caja</part-name></score-part>
              </part-list>
              <part id="P1">
                <measure number="1" width="250">
                  <print><system-layout><system-margins><left-margin>50</left-margin></system-margins></system-layout></print>
                  <attributes>
                    <divisions>4</divisions>
                    <key><fifths>-1</fifths><mode>major</mode></key>
                    <time><beats>4</beats><beat-type>4</beat-type></time>
                    <staves>2</staves>
                    <clef number="1"><sign>G</sign><line>2</line></clef>
                    <clef number="2"><sign>F</sign><line>4</line></clef>
                  </attributes>
                  <direction placement="above">
                    <direction-type><metronome><beat-unit>quarter</beat-unit><per-minute>96</per-minute></metronome></direction-type>
                    <staff>1</staff>
                    <sound tempo="96"/>
                  </direction>
                  <note default-x="80">
                    <pitch><step>F</step><octave>4</octave></pitch>
                    <duration>8</duration><voice>1</voice><type>half</type><stem>up</stem><staff>1</staff>
                  </note>
                  <note default-x="150">
                    <pitch><step>A</step><octave>4</octave></pitch>
                    <duration>8</duration><tie type="start"/><voice>1</voice><type>half</type><stem>up</stem><staff>1</staff>
                    <notations><tied type="start"/></notations>
                  </note>
                  <backup><duration>16</duration></backup>
                  <note default-x="80">
                    <pitch><step>F</step><octave>2</octave></pitch>
                    <duration>16</duration><voice>5</voice><type>whole</type><staff>2</staff>
                  </note>
                  <note default-x="80">
                    <chord/>
                    <pitch><step>C</step><octave>3</octave></pitch>
                    <duration>16</duration><voice>5</voice><type>whole</type><staff>2</staff>
                  </note>
                </measure>
                <measure number="2" width="230">
                  <attributes><key><fifths>0</fifths></key></attributes>
                  <note>
                    <pitch><step>A</step><octave>4</octave></pitch>
                    <duration>4</duration><tie type="stop"/><voice>1</voice><type>quarter</type><staff>1</staff>
                    <notations><tied type="stop"/></notations>
                  </note>
                  <note>
                    <pitch><step>B</step><alter>-1</alter><octave>4</octave></pitch>
                    <duration>4</duration><voice>1</voice><type>quarter</type><accidental>flat</accidental><staff>1</staff>
                  </note>
                  <note>
                    <pitch><step>C</step><octave>5</octave></pitch>
                    <duration>8</duration><voice>1</voice><type>half</type><staff>1</staff>
                  </note>
                  <backup><duration>16</duration></backup>
                  <forward><duration>8</duration><voice>5</voice><staff>2</staff></forward>
                  <note>
                    <pitch><step>C</step><octave>3</octave></pitch>
                    <duration>8</duration><voice>5</voice><type>half</type><staff>2</staff>
                  </note>
                  <barline location="right"><bar-style>light-heavy</bar-style></barline>
                </measure>
              </part>
              <part id="P2">
                <measure number="1">
                  <attributes>
                    <divisions>1</divisions>
                    <key><fifths>-1</fifths></key>
                    <time><beats>4</beats><beat-type>4</beat-type></time>
                    <clef><sign>F</sign><line>4</line></clef>
                  </attributes>
                  <note><rest measure="yes"/><duration>4</duration><voice>1</voice></note>
                </measure>
                <measure number="2">
                  <note><pitch><step>A</step><octave>2</octave></pitch><duration>4</duration><voice>1</voice><type>whole</type></note>
                </measure>
              </part>
              <part id="P3">
                <measure number="1">
                  <attributes><divisions>1</divisions><clef><sign>percussion</sign></clef></attributes>
                  <note>
                    <unpitched><display-step>C</display-step><display-octave>5</display-octave></unpitched>
                    <duration>4</duration><voice>1</voice><type>whole</type>
                  </note>
                </measure>
              </part>
            </score-partwise>
            """
        let pieza = try PiezaImportada(leyendo: Data(xml.utf8))
        XCTAssertEqual(pieza.titulo, "Sonatina")
        XCTAssertEqual(pieza.tonalidad, Tonalidad(armadura: -1))
        XCTAssertEqual(pieza.compas, .compasillo)
        XCTAssertEqual(pieza.tempo, Tempo(96))
        XCTAssertEqual(nombres(pieza), ["Fa2", "Do3", "Fa4", "La4", "La2", "Si♭4", "Do3", "Do5"])
        XCTAssertEqual(
            pieza.notas.map(\.inicio),
            [
                .cero, .cero, .cero, .blanca, .redonda, Duracion(5, 4),
                Duracion(3, 2), Duracion(3, 2),
            ])
        // El La4 ligado dura una blanca y una negra.
        XCTAssertEqual(
            pieza.notas.map(\.duracion),
            [
                .redonda, .redonda, .blanca, Duracion(3, 4), .redonda, .negra,
                .blanca, .blanca,
            ])
        XCTAssertEqual(pieza.notas.map(\.parte), [0, 0, 0, 0, 1, 0, 0, 0])
        XCTAssertEqual(pieza.duracion, Duracion(2))
    }
}
