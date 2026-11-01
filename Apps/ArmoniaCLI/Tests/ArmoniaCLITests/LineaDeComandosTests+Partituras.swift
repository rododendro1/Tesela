import Armonia
import Foundation
import XCTest

@testable import ArmoniaCLI

// Las pruebas de las partituras: MIDI, MusicXML y MEI.

extension LineaDeComandosTests {
    func testMIDI() throws {
        func datos(_ orden: String) throws -> [UInt8] {
            let resultado = LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
            XCTAssertEqual(resultado.codigo, 0, resultado.error)
            XCTAssertEqual(resultado.salida, "")
            return [UInt8](try XCTUnwrap(resultado.datos, orden))
        }
        let melodia = try datos(
            "midi melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4 --tempo 90 --titulo Escala --programa 40")
        XCTAssertEqual(Array(melodia.prefix(4)), Array("MThd".utf8))
        XCTAssertTrue(melodia.count > 60)
        // El instrumento: cambio de programa 40 (violín) en la pista de la voz.
        XCTAssertNotNil(zip(melodia, melodia.dropFirst()).first { $0 == (0xC0, 40) })
        // Seis «M»: la cabecera MThd y cinco pistas MTrk.
        XCTAssertEqual(
            try datos("midi coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --duracion 2").filter { $0 == 0x4D }.count, 6)
        XCTAssertFalse(try datos("midi acordes Do Lam Re7 Sol7 Do --tempo 80").isEmpty)
        XCTAssertNil(LineaDeComandos.ejecutar(["musicxml", "melodia", "Do4:4"]).datos)
        for orden in [
            "midi", "midi melodia", "midi melodia Do4:4 --clave fa", "midi coral Do3 Do5 --cifrados",
            "midi melodia Do4:4 --programa 200", "midi melodia Do4:4 --programa piano",
            "midi melodia Do4:4 --instrumento 40",
            "musicxml melodia Do4:4 --instrumento 3",
        ] {
            let resultado = LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
            XCTAssertEqual(resultado.codigo, 2, orden)
            XCTAssertNil(resultado.datos, orden)
        }
    }

    func testMusicXML() {
        let melodia = salida(
            "musicxml melodia Sol4:4 Do5:2 Re5:4 Mi5:2 --compas 3/4 --anacrusa 4 --tonalidad Sol mayor --tempo 60 4. --titulo Mi canción --clave sol8b"
        )
        XCTAssertTrue(melodia.hasPrefix("<?xml"))
        XCTAssertTrue(melodia.hasSuffix("</score-partwise>\n"))
        for fragmento in [
            "<work-title>Mi canción</work-title>", "<fifths>1</fifths>", "<beats>3</beats>",
            "<measure number=\"0\" implicit=\"yes\">", "<beat-unit-dot/>", "<per-minute>60</per-minute>",
            "<clef-octave-change>-1</clef-octave-change>",
        ] {
            XCTAssertTrue(melodia.contains(fragmento), fragmento)
        }
        let coral = salida(
            "musicxml coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4, Do3 Mi4 Sol4 Do5 --duracion 2 --compas 3/2")
        for fragmento in [
            "<staves>2</staves>", "<type>half</type>", "<beats>3</beats>", "<beat-type>2</beat-type>",
            "<voice>4</voice>", "<staff>2</staff>",
        ] {
            XCTAssertTrue(coral.contains(fragmento), fragmento)
        }
        let acordes = salida("musicxml acordes Do Lam Re7 Sol7 Do --duracion 4 --titulo Progresión")
        for fragmento in [
            "<harmony print-frame=\"no\">", "<kind text=\"7\">dominant</kind>", "<text>V7/V</text>",
            "<words>Do mayor:</words>", "<type>quarter</type>",
        ] {
            XCTAssertTrue(acordes.contains(fragmento), fragmento)
        }
        XCTAssertTrue(salida("musicxml acordes Am Dm E7 Am --ingles").contains("<words>A minor:</words>"))
        XCTAssertTrue(salida("musicxml acordes Re Sol La7 Re --tonalidad Sol mayor").contains("<text>V</text>"))
        let analizado = salida("musicxml coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados --analisis")
        XCTAssertTrue(analizado.contains("<harmony") && analizado.contains("<lyric"))
        let soloCifrados = salida("musicxml coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados")
        XCTAssertTrue(soloCifrados.contains("<harmony") && !soloCifrados.contains("<lyric"))
        XCTAssertEqual(LineaDeComandos.leerClave("do en tercera"), .doEnTercera)
        XCTAssertEqual(LineaDeComandos.leerClave("Clave de Fa"), .fa)
        XCTAssertEqual(LineaDeComandos.leerClave("bass"), .fa)
        XCTAssertEqual(LineaDeComandos.leerClave("baritone clef"), .faEnTercera)
        XCTAssertNil(LineaDeComandos.leerClave("re"))

        for orden in [
            "musicxml", "musicxml partitura Do4:4", "musicxml melodia", "musicxml coral",
            "musicxml melodia Do4:4 --color rojo", "musicxml melodia Do4:4 --compas",
            "musicxml melodia Do4:4 --tempo rápido", "musicxml melodia Do4:4 --clave re",
            "musicxml melodia Do4:4 --duracion 2", "musicxml coral Do3 Do5 --clave fa",
            "musicxml melodia Do4:4 --cifrados", "musicxml acordes", "musicxml acordes Do Sol --analisis",
            "musicxml acordes Do Sol --clave fa",
        ] {
            let resultado = LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
            XCTAssertEqual(resultado.codigo, 2, orden)
            XCTAssertEqual(resultado.salida, "", orden)
        }
        for orden in [
            "musicxml melodia Do4:3", "musicxml melodia Do4:4 --compas 3/5", "musicxml coral Do3 Mi4, Sol2",
            "musicxml acordes Do Hm",
        ] {
            XCTAssertEqual(LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo, 1, orden)
        }
    }

    func testMEI() {
        let melodia = salida(
            "mei melodia Sol4:4 Do5:2 Re5:4 Mi5:2 --compas 3/4 --anacrusa 4 --tonalidad Sol mayor --tempo 60 4. --titulo Mi canción --clave sol8b"
        )
        XCTAssertTrue(melodia.hasPrefix("<?xml"))
        XCTAssertTrue(melodia.hasSuffix("</mei>\n"))
        for fragmento in [
            "<title>Mi canción</title>", "keysig=\"1s\"", "meter.count=\"3\"",
            "<measure n=\"0\" metcon=\"false\">", "mm.dots=\"1\"", "mm=\"60\"",
            "clef.dis=\"8\" clef.dis.place=\"below\"",
        ] {
            XCTAssertTrue(melodia.contains(fragmento), fragmento)
        }
        let coral = salida(
            "mei coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4, Do3 Mi4 Sol4 Do5 --duracion 2 --compas 3/2 --cifrados --analisis"
        )
        for fragmento in [
            "<staffGrp symbol=\"brace\" bar.thru=\"true\">", "meter.unit=\"2\"", "<layer n=\"2\">",
            "<staff n=\"2\">", "stem.dir=\"down\"", ">Sol</harm>", "<syl>V</syl>", ">Do mayor:</dir>",
        ] {
            XCTAssertTrue(coral.contains(fragmento), fragmento)
        }
        let acordes = salida("mei acordes Am Dm E7 Am --ingles --duracion 4")
        for fragmento in [">E7</harm>", ">A minor:</dir>", "<chord ", "dur=\"4\""] {
            XCTAssertTrue(acordes.contains(fragmento), fragmento)
        }
        for orden in [
            "mei", "mei partitura Do4:4", "mei melodia", "mei melodia Do4:4 --programa 3",
            "mei melodia Do4:4 --cifrados", "mei acordes Do Sol --analisis", "mei coral Do3 Do5 --clave fa",
        ] {
            let resultado = LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
            XCTAssertEqual(resultado.codigo, 2, orden)
            XCTAssertEqual(resultado.salida, "", orden)
        }
        XCTAssertTrue(
            LineaDeComandos.ejecutar(["midi", "coral", "Do3", "Do5", "--cifrados"]).error.contains("MusicXML y MEI"))
    }

    func testArpegiosComoPartitura() throws {
        func notas(_ xml: String) -> Int { xml.components(separatedBy: "<pitch>").count - 1 }
        // Do: Do Mi Sol Do; Sol7: Sol Si Re Fa Sol.
        let sencillo = salida("musicxml arpegios Do Sol7")
        XCTAssertEqual(notas(sencillo), 9)
        XCTAssertTrue(sencillo.contains("<type>eighth</type>"))
        // Cuatro acordes de blanca en corcheas: cuatro notas cada uno.
        let alberti = salida("musicxml arpegios Do Lam Fa Sol7 --patron alberti --duracion 2 --titulo Alberti")
        XCTAssertEqual(notas(alberti), 16)
        XCTAssertTrue(alberti.contains("<work-title>Alberti</work-title>"))
        XCTAssertTrue(salida("musicxml arpegios Do --figura 16").contains("<type>16th</type>"))
        XCTAssertEqual(
            salida("musicxml arpegios Do Sol7 --patron ida y vuelta"),
            salida("musicxml arpeggios Do Sol7 --pattern up-down"))
        XCTAssertTrue(salida("mei arpegios Do Sol7 --patron descendente").hasSuffix("</mei>\n"))
        let midi = LineaDeComandos.ejecutar(["midi", "arpegios", "Do", "Sol7", "--programa", "24"])
        XCTAssertEqual(midi.codigo, 0, midi.error)
        XCTAssertEqual(Array(try XCTUnwrap(midi.datos).prefix(4)), Array("MThd".utf8))

        for orden in [
            "musicxml arpegios", "musicxml arpegios Do --patron zigzag", "musicxml arpegios Do --cifrados",
            "musicxml arpegios Do --clave fa", "musicxml melodia Do4:4 --patron alberti",
            "musicxml acordes Do Sol --figura 8", "midi coral Do3 Do5 --patron alberti",
        ] {
            let resultado = LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
            XCTAssertEqual(resultado.codigo, 2, orden)
            XCTAssertEqual(resultado.salida, "", orden)
        }
        XCTAssertTrue(
            LineaDeComandos.ejecutar(["musicxml", "acordes", "Do", "--figura", "8"]).error.contains("«arpegios»"))
        for orden in ["musicxml arpegios Do --figura 0/4", "musicxml arpegios Do Hm", "midi arpegios Do --figura 3"] {
            XCTAssertEqual(LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo, 1, orden)
        }
    }

    /// `--archivo`: los acordes de un fichero, con lo que dura cada uno.
    func testPartituraDeUnArchivo() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do")
        let duraciones: [Duracion] = [.blanca, .negra, .negra, .redonda]
        let midi = try fichero(analisis.midi(duraciones: duraciones, titulo: "Coral"), extension: "mid")
        let xml = try fichero(Data(analisis.musicXML(duraciones: duraciones).utf8), extension: "musicxml")
        // El ritmo armónico del fichero pasa a la partitura, y su título y su tempo (el MIDI lo lleva siempre)
        // también.
        let conTempo = analisis.musicXML(duraciones: duraciones, tempo: Tempo(120), titulo: "Coral")
        let esperado = conTempo.trimmingCharacters(in: .newlines) + "\n"
        XCTAssertEqual(salida("musicxml acordes --archivo " + midi), esperado)
        XCTAssertEqual(salida("musicxml chords --file " + midi), esperado)
        let sinTempo = analisis.musicXML(duraciones: duraciones, titulo: "Coral").trimmingCharacters(in: .newlines)
        XCTAssertEqual(salida("musicxml acordes --archivo \(xml) --titulo Coral"), sinTempo + "\n")
        // `--duracion` manda sobre el ritmo del fichero.
        XCTAssertEqual(
            salida("musicxml acordes --archivo \(xml) --duracion 2 --titulo T"),
            salida("musicxml acordes Do Fa Sol7 Do --duracion 2 --titulo T"))
        XCTAssertTrue(salida("mei acordes --archivo " + xml).hasSuffix("</mei>\n"))
        let datos = LineaDeComandos.ejecutar(["midi", "acordes", "--archivo", xml])
        XCTAssertEqual(datos.codigo, 0, datos.error)
        XCTAssertEqual(datos.datos, analisis.midi(duraciones: duraciones))
        // Arpegiados: Do (blanca, 4 corcheas), Fa y Sol7 (negra, 2 cada uno) y Do (redonda, 8).
        let arpegios = salida("musicxml arpegios --archivo " + midi)
        XCTAssertEqual(arpegios.components(separatedBy: "<pitch>").count - 1, 16)
        // La ventana de una negra (4) es la de omisión en 4/4.
        XCTAssertEqual(salida("musicxml arpegios --archivo \(midi) --ventana 4"), arpegios)

        func resultado(_ orden: String) -> ResultadoDeOrden {
            LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
        }
        XCTAssertEqual(resultado("musicxml acordes Do --archivo " + midi).codigo, 2)
        XCTAssertEqual(resultado("musicxml acordes --archivo /no/existe.mid").codigo, 2)
        XCTAssertEqual(
            resultado("musicxml coral --archivo " + midi).error,
            "armonia: --archivo es solo para «acordes» y «arpegios»\nPrueba «armonia ayuda».\n")
        XCTAssertEqual(
            resultado("musicxml acordes Do --ventana 1").error,
            "armonia: --ventana va con --archivo\nPrueba «armonia ayuda».\n")
        let melodia = try fichero(Voz(leyendo: "Do4:4 Re4:4 Mi4:4").midi(), extension: "mid")
        XCTAssertEqual(resultado("musicxml acordes --archivo " + melodia).codigo, 2)
        let texto = try fichero(Data("hola".utf8), extension: "mid")
        XCTAssertEqual(resultado("musicxml acordes --archivo " + texto).codigo, 1)
    }
}
