import Armonia
import Foundation
import XCTest

@testable import ArmoniaPresentacion

// «Abrir» en la vista de análisis: de un fichero MIDI o MusicXML a una progresión que se analiza como si se
// hubiera escrito.
final class ImportacionDeProgresionTests: XCTestCase {
    func testUnFicheroDaSuProgresion() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        XCTAssertEqual(try ImportacionDeProgresion.progresion(de: analisis.midi()), "Do Lam Re7 Sol7 Do")
        XCTAssertEqual(try ImportacionDeProgresion.progresion(de: Data(analisis.musicXML().utf8)), "Do Lam Re7 Sol7 Do")
    }

    func testLaProgresionSeAnalizaComoLaEscrita() throws {
        let texto = "Do Fa Sol7 Do Lam Re7 Sol"
        let progresion = try ImportacionDeProgresion.progresion(de: AnalisisArmonico.analizar(leyendo: texto).midi())
        XCTAssertEqual(progresion, texto)
        XCTAssertEqual(
            try PresentacionDeAnalisis.analizar(progresion, notacion: .espanolUnicode),
            try PresentacionDeAnalisis.analizar(texto, notacion: .espanolUnicode))
    }

    func testUnaMelodiaSolaNoTieneAcordes() throws {
        let melodia = try Voz(leyendo: "Do4:4 Re4:4 Mi4:4").midi()
        XCTAssertThrowsError(try ImportacionDeProgresion.progresion(de: melodia)) {
            XCTAssertEqual($0 as? ErrorDeImportacion, .sinAcordes)
        }
        XCTAssertThrowsError(try ImportacionDeProgresion.progresion(de: Data("hola".utf8))) {
            XCTAssertEqual($0 as? ErrorDeImportacion, .formatoDesconocido)
        }
    }

    func testLosErroresSeExplicanEnLaNotacion() {
        XCTAssertEqual(ErrorDeImportacion.sinAcordes.descripcion(en: .inglesASCII), "No chords sound in the file.")
    }
}

// El ritmo armónico de una pieza importada: lo siguen la partitura, el MIDI, «Escuchar» y los arpegios.
final class RitmoArmonicoTests: XCTestCase {
    private let duraciones: [Duracion] = [.blanca, .negra, .negra, .redonda]

    private func importada() throws -> ProgresionImportada {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do")
        let datos = analisis.midi(duraciones: duraciones, tempo: Tempo(90), titulo: "Coral")
        return try ImportacionDeProgresion.leer(datos)
    }

    func testSeLeeElRitmoElCompasYElTempo() throws {
        let leida = try importada()
        XCTAssertEqual(leida.texto, "Do Fa Sol7 Do")
        XCTAssertEqual(leida.ritmo.duraciones, duraciones)
        XCTAssertEqual(leida.ritmo.compas, .compasillo)
        XCTAssertEqual(try XCTUnwrap(leida.ritmo.tempo).negrasPorMinuto, 90, accuracy: 0.001)
        XCTAssertEqual(leida.titulo, "Coral")
        XCTAssertTrue(ImportacionDeProgresion.extensiones.contains("mxl"))
    }

    func testElAnalisisSigueElRitmo() throws {
        let leida = try importada()
        let analisis = try XCTUnwrap(PresentacionDeAnalisis.analizar(leida, notacion: .espanolUnicode))
        XCTAssertEqual(analisis.ritmo, leida.ritmo)
        // Lo mismo que escrita, salvo el ritmo.
        let escrita = try PresentacionDeAnalisis.analizar("Do Fa Sol7 Do", notacion: .espanolUnicode)
        XCTAssertEqual(analisis.titulo, escrita.titulo)
        XCTAssertEqual(analisis.tramos, escrita.tramos)
        XCTAssertNil(escrita.ritmo)
        XCTAssertNotEqual(analisis.ficheros, escrita.ficheros)
        // A negra = 90, la blanca dura 4/3 de segundo y la negra 2/3.
        let inicios = Set(analisis.sonido.notas.map { ($0.inicio * 1000).rounded() / 1000 })
        XCTAssertEqual(inicios, [0, 1.333, 2, 2.667])
        // Los arpegios también: 4 + 2 + 2 + 8 corcheas.
        let arpegiada = try XCTUnwrap(analisis.arpegiada(.ascendente, notacion: .espanolUnicode))
        XCTAssertEqual(arpegiada.voz.eventos.count, 16)
        XCTAssertEqual(arpegiada.voz.eventos.reduce(Duracion.cero) { $0 + $1.duracion }, Duracion(2))
    }

    func testUnRitmoQueNoCuadraNoSeUsa() {
        let acordes = [Acorde("Do"), Acorde("Sol")]
        let cojo = RitmoArmonico(duraciones: [.blanca])
        XCTAssertNil(PresentacionDeAnalisis.analizar(acordes, ritmo: cojo, notacion: .espanolUnicode)?.ritmo)
        let nulo = RitmoArmonico(duraciones: [.blanca, .cero])
        XCTAssertNil(PresentacionDeAnalisis.analizar(acordes, ritmo: nulo, notacion: .espanolUnicode)?.ritmo)
        XCTAssertEqual(
            PresentacionDeAnalisis.analizar(acordes, notacion: .espanolUnicode),
            PresentacionDeAnalisis.analizar(acordes, ritmo: cojo, notacion: .espanolUnicode))
    }

    func testSonidoConDuraciones() {
        let sonido = Escucha.acordes([Acorde("Do"), Acorde("Sol")], duraciones: [.blanca, .negra], tempo: Tempo(60))
        XCTAssertEqual(Set(sonido.notas.map(\.inicio)), [0, 2])
        XCTAssertEqual(sonido.notas.last?.duracion, 0.92)
    }
}
