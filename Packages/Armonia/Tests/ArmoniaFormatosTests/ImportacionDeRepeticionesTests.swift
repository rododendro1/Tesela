import Foundation
import Testing

@testable import ArmoniaFormatos
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura

/// Las repeticiones, los saltos y las notas de adorno al importar MusicXML, MEI y ABC.
@Suite struct ImportacionDeRepeticionesTests {
    /// Cada nota como «altura inicio», con el inicio en redondas.
    private func tocadas(_ pieza: PiezaImportada) -> [String] {
        pieza.notas.map { "\($0.altura) \($0.inicio.numerador)/\($0.inicio.denominador)" }
    }

    /// Un MusicXML de una parte en 4/4, con una redonda en cada compás y lo que se pida antes y después de ella.
    private func musicXML(_ compases: [(antes: String, nota: String, despues: String)]) -> Data {
        let medidas = compases.enumerated().map { i, compas in
            """
            <measure number="\(i + 1)">\(i == 0 ? "<attributes><divisions>1</divisions></attributes>" : "")
            \(compas.antes)
            <note><pitch><step>\(compas.nota)</step><octave>4</octave></pitch><duration>4</duration></note>
            \(compas.despues)</measure>
            """
        }
        return Data(
            """
            <score-partwise version="4.0"><part-list><score-part id="P1"/></part-list><part id="P1">
            \(medidas.joined(separator: "\n"))
            </part></score-partwise>
            """.utf8)
    }

    @Test func unaRepeticionConCasillasEnMusicXML() throws {
        let finDeLaPrimera = "<ending number=\"1\" type=\"stop\"/><repeat direction=\"backward\"/>"
        let xml = musicXML([
            ("<barline location=\"left\"><repeat direction=\"forward\"/></barline>", "C", ""),
            (
                "<barline location=\"left\"><ending number=\"1\" type=\"start\"/></barline>", "D",
                "<barline location=\"right\">\(finDeLaPrimera)</barline>"
            ),
            (
                "<barline location=\"left\"><ending number=\"2\" type=\"start\"/></barline>", "E",
                "<barline location=\"right\"><ending number=\"2\" type=\"discontinue\"/></barline>"
            ),
            ("", "F", ""),
        ])
        let pieza = try PiezaImportada(musicXML: xml)
        #expect(tocadas(pieza) == ["Do4 0/1", "Re4 1/1", "Do4 2/1", "Mi4 3/1", "Fa4 4/1"])
    }

    @Test func unaRepeticionDeTresVecesYUnDaCapo() throws {
        let tres = musicXML([
            ("", "C", "<barline location=\"right\"><repeat direction=\"backward\" times=\"3\"/></barline>"),
            ("", "D", ""),
        ])
        #expect(tocadas(try PiezaImportada(musicXML: tres)) == ["Do4 0/1", "Do4 1/1", "Do4 2/1", "Re4 3/1"])
        // D.C. al Fine: se vuelve al principio y se acaba en el fine.
        let daCapo = musicXML([
            ("", "C", ""),
            ("<direction><direction-type><words>Fine</words></direction-type></direction>", "D", ""),
            ("", "E", "<direction><direction-type><words>D.C. al Fine</words></direction-type></direction>"),
        ])
        let pieza = try PiezaImportada(musicXML: daCapo)
        #expect(tocadas(pieza) == ["Do4 0/1", "Re4 1/1", "Mi4 2/1", "Do4 3/1", "Re4 4/1"])
        #expect(pieza.duracion == Duracion(5))
    }

    @Test func sinRepeticionesNoCambiaNada() throws {
        let xml = musicXML([("", "C", ""), ("", "D", "")])
        #expect(tocadas(try PiezaImportada(musicXML: xml)) == ["Do4 0/1", "Re4 1/1"])
    }

    @Test func lasNotasDeAdornoVanAparte() throws {
        let adorno = "<note><grace slash=\"yes\"/><pitch><step>G</step><octave>4</octave></pitch></note>"
        let xml = musicXML([(adorno, "C", "")])
        let pieza = try PiezaImportada(musicXML: xml)
        #expect(tocadas(pieza) == ["Do4 0/1"])
        #expect(pieza.notasDeAdorno.map(\.altura) == [Altura("Sol4")])
        #expect(pieza.notasDeAdorno.map(\.duracion) == [.cero])
        #expect(pieza.notasDeAdorno.map(\.inicio) == [.cero])
    }

    @Test func repeticionesYAdornosEnMEI() throws {
        let mei = """
            <mei xmlns="http://www.music-encoding.org/ns/mei" meiversion="5.0">
              <music><body><mdiv><score>
                <scoreDef meter.count="4" meter.unit="4"><staffGrp><staffDef n="1" lines="5"/></staffGrp></scoreDef>
                <section>
                  <measure n="1" left="rptstart">
                    <staff n="1"><layer n="1">
                      <note pname="g" oct="4" dur="8" grace="unacc"/><note pname="c" oct="4" dur="1"/>
                    </layer></staff>
                  </measure>
                  <ending n="1">
                    <measure n="2" right="rptend">
                      <staff n="1"><layer n="1"><note pname="d" oct="4" dur="1"/></layer></staff>
                    </measure>
                  </ending>
                  <ending n="2">
                    <measure n="3">
                      <staff n="1"><layer n="1"><note pname="e" oct="4" dur="1"/></layer></staff>
                    </measure>
                  </ending>
                  <measure n="4"><staff n="1"><layer n="1"><note pname="f" oct="4" dur="1"/></layer></staff></measure>
                </section>
              </score></mdiv></body></music>
            </mei>
            """
        let pieza = try PiezaImportada(mei: Data(mei.utf8))
        #expect(tocadas(pieza) == ["Do4 0/1", "Re4 1/1", "Do4 2/1", "Mi4 3/1", "Fa4 4/1"])
        // El adorno se toca las dos veces.
        #expect(pieza.notasDeAdorno.map(\.inicio) == [.cero, Duracion(2)])
    }

    @Test func repeticionesEnABC() throws {
        let casillas = try PiezaImportada(abc: "X:1\nM:4/4\nL:1/4\nK:C\n|: C4 |1 D4 :|2 E4 || F4 |]\n")
        #expect(tocadas(casillas) == ["Do4 0/1", "Re4 1/1", "Do4 2/1", "Mi4 3/1", "Fa4 4/1"])
        // D.S. al Coda: del cuarto compás al segno y, desde el «al coda», a la coda.
        let alCoda = try PiezaImportada(
            abc: "X:1\nM:4/4\nL:1/4\nK:C\nC4 | !segno! D4 | E4 !dacoda! | F4 !D.S.alcoda! | !coda! G4 |]\n")
        #expect(
            tocadas(alCoda) == [
                "Do4 0/1", "Re4 1/1", "Mi4 2/1", "Fa4 3/1", "Re4 4/1", "Mi4 5/1", "Sol4 6/1",
            ])
        // Una repetición sin principio vuelve al principio; las notas de adorno, aparte.
        let adornos = try PiezaImportada(abc: "X:1\nM:2/4\nL:1/4\nK:C\n{B}c d :| e2 |]\n")
        #expect(tocadas(adornos) == ["Do5 0/1", "Re4 1/4", "Do5 1/2", "Re4 3/4", "Mi4 1/1"])
        #expect(adornos.notasDeAdorno.map(\.altura) == [Altura("Si4"), Altura("Si4")])
    }

    @Test func elOrdenDeLosCompases() {
        func compases(_ marcas: [(inout CompasLeido) -> Void]) -> [CompasLeido] {
            marcas.enumerated().map { i, marca in
                var compas = CompasLeido(inicio: Duracion(i))
                marca(&compas)
                return compas
            }
        }
        // Una repetición sin cerrar no cambia nada.
        #expect(CompasLeido.orden(de: compases([{ $0.abreRepeticion = true }, { _ in }])) == [0, 1])
        // Dos tramos repetidos seguidos.
        let dos = compases([
            { _ in }, { $0.cierraRepeticion = 2 }, { $0.abreRepeticion = true }, { $0.cierraRepeticion = 2 },
        ])
        #expect(CompasLeido.orden(de: dos) == [0, 1, 0, 1, 2, 3, 2, 3])
        // Un dal segno sin segno vuelve al principio, y después no se vuelve a saltar.
        #expect(CompasLeido.orden(de: compases([{ _ in }, { $0.dalSegno = true }])) == [0, 1, 0, 1])
    }
}
