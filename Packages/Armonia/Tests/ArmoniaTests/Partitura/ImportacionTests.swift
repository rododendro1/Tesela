import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

@Suite struct ImportacionTests {
    private let cadencia = "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5"

    private func nombres(_ pieza: PiezaImportada) -> [String] { pieza.notas.map(\.altura.nombre) }

    // MARK: Ida y vuelta

    @Test func unCoralEnMIDISeLeeIgual() throws {
        let coral = try Coral(leyendo: cadencia)
        let datos = coral.midi(
            duracion: .blanca, compas: Compas(3, 2), tonalidad: Tonalidad(.do), tempo: Tempo(72),
            titulo: "Cadencia")
        let pieza = try PiezaImportada(leyendo: datos)
        #expect(pieza.titulo == "Cadencia")
        #expect(pieza.tonalidad == Tonalidad(.do))
        #expect(pieza.compas == Compas(3, 2))
        #expect(abs((pieza.tempo?.negrasPorMinuto ?? 0) - (72)) <= 0.01)
        #expect(pieza.notas.count == 12)
        #expect(Array(nombres(pieza).prefix(4)) == ["Do₃", "Mi₄", "Sol₄", "Do₅"])
        #expect(Set(pieza.notas.map(\.duracion)) == [.blanca])
        #expect(pieza.notas.map(\.inicio).max() == Duracion(1))
        #expect(Set(pieza.notas.map(\.parte)).count == 4)
        #expect(pieza.acordes().map(\.cifrado) == ["Do", "Sol", "Do"])
        #expect(pieza.analisis()?.cifrados == ["I", "V", "I"])
    }

    @Test func unCoralEnMusicXMLSeLeeIgualQueEnMIDI() throws {
        let coral = try Coral(leyendo: cadencia)
        let midi = try PiezaImportada(leyendo: coral.midi(duracion: .blanca, tonalidad: Tonalidad(.do)))
        let xml = try PiezaImportada(
            leyendo: Data(
                coral.musicXML(
                    duracion: .blanca, compas: Compas(3, 2),
                    tonalidad: Tonalidad(.do), titulo: "Cadencia"
                ).utf8))
        #expect(xml.titulo == "Cadencia")
        #expect(xml.tonalidad == Tonalidad(.do))
        #expect(xml.compas == Compas(3, 2))
        #expect(nombres(xml) == nombres(midi))
        #expect(xml.notas.map(\.inicio) == midi.notas.map(\.inicio))
        #expect(xml.acordes() == midi.acordes())
    }

    @Test func unaProgresionExportadaDaSusAcordes() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        for datos in [analisis.midi(), Data(analisis.musicXML().utf8)] {
            let pieza = try PiezaImportada(leyendo: datos)
            #expect(pieza.acordes().map(\.cifrado) == ["Do", "Lam", "Re7", "Sol7", "Do"])
            #expect(pieza.analisis()?.cifrados == ["I", "vi", "V7/V", "V7", "I"])
            #expect(pieza.analisis(en: Tonalidad(.do))?.cifrados == ["I", "vi", "V7/V", "V7", "I"])
        }
    }

    @Test func lasLigadurasUnenLasNotas() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8~ Mi4:4 Sol4+Si4:2", compas: "3/4")
        let esperadas = [
            NotaDeLaPieza(altura: try Altura(leyendo: "Do4"), inicio: .cero, duracion: .negra),
            NotaDeLaPieza(altura: try Altura(leyendo: "Re4"), inicio: .negra, duracion: .corchea),
            NotaDeLaPieza(altura: try Altura(leyendo: "Mi4"), inicio: Duracion(3, 8), duracion: Duracion(3, 8)),
            NotaDeLaPieza(altura: try Altura(leyendo: "Sol4"), inicio: Duracion(3, 4), duracion: .blanca),
            NotaDeLaPieza(altura: try Altura(leyendo: "Si4"), inicio: Duracion(3, 4), duracion: .blanca),
        ]
        let xml = try PiezaImportada(musicXML: Data(voz.musicXML(tonalidad: Tonalidad(.do)).utf8))
        #expect(xml.notas == esperadas)
        let midi = try PiezaImportada(midi: voz.midi(tonalidad: Tonalidad(.do)))
        #expect(midi.notas.map(\.altura) == esperadas.map(\.altura))
        #expect(midi.notas.map(\.inicio) == esperadas.map(\.inicio))
        #expect(midi.notas.map(\.duracion) == esperadas.map(\.duracion))
    }

    // MARK: MusicXML

    @Test func musicXMLConVocesAcordesYTransposicion() throws {
        // Un clarinete en Si♭ (suena un tono por debajo) en Do menor, con una nota de adorno, un
        // acorde, un silencio y una segunda voz que vuelve al principio del compás.
        let xml = """
            <?xml version="1.0" encoding="UTF-8"?>
            <score-partwise version="4.0">
              <work><work-title>Prueba</work-title></work>
              <part-list><score-part id="P1"><part-name>Clarinete</part-name></score-part></part-list>
              <part id="P1">
                <measure number="1">
                  <attributes>
                    <divisions>2</divisions>
                    <key><fifths>-3</fifths><mode>minor</mode></key>
                    <time><beats>3</beats><beat-type>4</beat-type></time>
                    <transpose><diatonic>-1</diatonic><chromatic>-2</chromatic></transpose>
                  </attributes>
                  <sound tempo="72"/>
                  <note><grace/><pitch><step>C</step><octave>5</octave></pitch><type>eighth</type></note>
                  <note><pitch><step>D</step><octave>4</octave></pitch><duration>2</duration><voice>1</voice></note>
                  <note><chord/><pitch><step>F</step><octave>4</octave></pitch><duration>2</duration><voice>1</voice></note>
                  <note><rest/><duration>2</duration><voice>1</voice></note>
                  <note><pitch><step>E</step><alter>-1</alter><octave>4</octave></pitch><duration>2</duration><voice>1</voice></note>
                  <backup><duration>6</duration></backup>
                  <note><pitch><step>G</step><octave>3</octave></pitch><duration>6</duration><voice>2</voice></note>
                </measure>
              </part>
            </score-partwise>
            """
        let pieza = try PiezaImportada(leyendo: Data(xml.utf8))
        #expect(pieza.titulo == "Prueba")
        #expect(pieza.tonalidad == Tonalidad(.do, .menor))
        #expect(pieza.compas == Compas(3, 4))
        #expect(pieza.tempo == Tempo(72))
        #expect(nombres(pieza) == ["Fa₃", "Do₄", "Mi♭₄", "Re♭₄"])
        #expect(pieza.notas.map(\.inicio) == [.cero, .cero, .cero, .blanca])
        #expect(pieza.notas.map(\.duracion) == [Duracion(3, 4), .negra, .negra, .negra])
    }

    @Test func losCompasesSiguenDondeLlegaLaVozMasLarga() throws {
        let xml = """
            <score-partwise version="4.0">
              <part id="P1">
                <measure number="1">
                  <attributes><divisions>1</divisions></attributes>
                  <note><pitch><step>C</step><octave>4</octave></pitch><duration>4</duration></note>
                  <backup><duration>4</duration></backup>
                  <note><pitch><step>E</step><octave>4</octave></pitch><duration>2</duration></note>
                </measure>
                <measure number="2">
                  <note><pitch><step>G</step><octave>4</octave></pitch><duration>4</duration></note>
                </measure>
              </part>
            </score-partwise>
            """
        let pieza = try PiezaImportada(musicXML: Data(xml.utf8))
        #expect(nombres(pieza) == ["Do₄", "Mi₄", "Sol₄"])
        #expect(pieza.notas.map(\.inicio) == [.cero, .cero, .redonda])
    }

    // MARK: Reducción a acordes

    @Test func lasNotasDePasoNoCambianElAcorde() {
        let alturas = ["Do3", "Mi4", "Sol4"].map { try! Altura(leyendo: $0) }
        var notas = alturas.map { NotaDeLaPieza(altura: $0, inicio: .cero, duracion: .negra) }
        notas.append(NotaDeLaPieza(altura: try! Altura(leyendo: "Do5"), inicio: .cero, duracion: .corchea))
        notas.append(NotaDeLaPieza(altura: try! Altura(leyendo: "Re5"), inicio: .corchea, duracion: .corchea))
        let pieza = PiezaImportada(tonalidad: Tonalidad(.do), notas: notas)
        #expect(pieza.acordes().map(\.cifrado) == ["Do"])
    }

    @Test func unBajoAlbertiSeLeeComoUnAcorde() {
        let figura = ["Do3", "Sol3", "Mi3", "Sol3", "Si2", "Sol3", "Re3", "Sol3"].map { try! Altura(leyendo: $0) }
        let notas = figura.enumerated().map {
            NotaDeLaPieza(altura: $1, inicio: Duracion($0, 16), duracion: .semicorchea)
        }
        let pieza = PiezaImportada(tonalidad: Tonalidad(.do), notas: notas)
        #expect(pieza.acordes().map(\.cifrado) == ["Do", "Sol/Si"])
        #expect(pieza.acordesConInicio().map(\.inicio) == [.cero, .negra])
    }

    @Test func unaVentanaMasLargaFundeLosAcordes() {
        let figura = ["Do3", "Sol3", "Mi3", "Sol3", "Do3", "La3", "Fa3", "La3"].map { try! Altura(leyendo: $0) }
        let notas = figura.enumerated().map {
            NotaDeLaPieza(altura: $1, inicio: Duracion($0, 16), duracion: .semicorchea)
        }
        let pieza = PiezaImportada(tonalidad: Tonalidad(.do), notas: notas)
        #expect(pieza.acordes().map(\.cifrado) == ["Do", "Fa/Do"])
        #expect(pieza.acordes(ventana: .blanca).count == 1)
    }

    @Test func sinTonalidadSeEstimaPorLasNotas() {
        let alturas = ["La2", "Do4", "Mi4", "Mi2", "Re4", "Sol#4", "Si4", "La2", "Do4", "Mi4"]
        let notas = alturas.enumerated().map { i, nombre in
            NotaDeLaPieza(
                altura: try! Altura(leyendo: nombre), inicio: Duracion([0, 0, 0, 1, 1, 1, 1, 2, 2, 2][i], 4),
                duracion: .negra)
        }
        let pieza = PiezaImportada(notas: notas)
        #expect(pieza.tonalidad == nil)
        #expect(pieza.tonalidadEstimada == Tonalidad(.la, .menor))
        #expect(pieza.acordes().map(\.cifrado) == ["Lam", "Mi7", "Lam"])
    }

    // MARK: Errores

    private func error(_ datos: Data) -> ErrorDeImportacion? {
        do {
            _ = try PiezaImportada(leyendo: datos)
            return nil
        } catch {
            return error as? ErrorDeImportacion
        }
    }

    @Test func losErroresDicenPorQue() throws {
        let coral = try Coral(leyendo: cadencia).midi()
        #expect(error(Data("hola".utf8)) == .formatoDesconocido)
        #expect(error(Data([0x50, 0x4B, 0x03, 0x04, 0, 0])) == .comprimido)
        #expect(error(coral.prefix(40)) == .midiDanado)
        var smpte = [UInt8](coral)
        smpte[12] = 0xE7
        smpte[13] = 0x28
        #expect(error(Data(smpte)) == .midiConTiempoSMPTE)
        let vacio = ArchivoMIDI(compas: .compasillo, tonalidad: nil, tempo: nil, titulo: nil).datos
        #expect(error(vacio) == .sinNotas)
        guard case .xmlDanado = error(Data("<score-partwise><part>".utf8)) else {
            Issue.record("un XML sin cerrar no está bien formado")
            return
        }
        #expect(error(Data("<score-timewise version=\"4.0\"/>".utf8)) == .noEsMusicXMLPorPartes)
        #expect(error(Data("<score-partwise version=\"4.0\"/>".utf8)) == .sinNotas)
    }

    @Test func losErroresSeExplicanEnCadaIdioma() {
        #expect(ErrorDeImportacion.sinNotas.descripcion(en: .inglesASCII) == "The file has no notes.")
        #expect(ErrorDeImportacion.sinNotas.description == "El fichero no tiene ninguna nota.")
        #expect(
            ErrorDeImportacion.xmlDanado(linea: 3).descripcion(en: .frances)
                == "Le fichier MusicXML est endommagé (ligne 3).")
    }

    // MARK: Auxiliares

    @Test func alturaPorPasosYMIDI() {
        #expect(Altura(pasos: 0, midi: 60) == .doCentral)
        #expect(Altura(pasos: 1, midi: 63).nombre == "Re♯₄")
        #expect(Altura(pasos: 2, midi: 63).nombre == "Mi♭₄")
        #expect(Altura(pasos: -1, midi: 58).nombre == "Si♭₃")
    }
}
