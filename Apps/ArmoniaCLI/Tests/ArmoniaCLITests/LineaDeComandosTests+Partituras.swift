import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

// Las pruebas de las partituras: MIDI, MusicXML y MEI.

extension LineaDeComandosTests {
    @Test func mIDI() throws {
        func datos(_ orden: String) throws -> [UInt8] {
            let resultado = LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
            #expect(resultado.codigo == 0, Comment(rawValue: resultado.error))
            #expect(resultado.salida == "")
            return [UInt8](try #require(resultado.datos, Comment(rawValue: orden)))
        }
        let melodia = try datos(
            "midi melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4 --tempo 90 --titulo Escala --programa 40")
        #expect(Array(melodia.prefix(4)) == Array("MThd".utf8))
        #expect(melodia.count > 60)
        // El instrumento: cambio de programa 40 (violín) en la pista de la voz.
        #expect(zip(melodia, melodia.dropFirst()).first { $0 == (0xC0, 40) } != nil)
        // Seis «M»: la cabecera MThd y cinco pistas MTrk.
        #expect(
            try (datos("midi coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --duracion 2").filter { $0 == 0x4D }.count) == 6)
        #expect(try !(datos("midi acordes Do Lam Re7 Sol7 Do --tempo 80").isEmpty))
        #expect(LineaDeComandos.ejecutar(["musicxml", "melodia", "Do4:4"]).datos == nil)
        for orden in [
            "midi", "midi melodia", "midi melodia Do4:4 --clave fa", "midi coral Do3 Do5 --cifrados",
            "midi melodia Do4:4 --programa 200", "midi melodia Do4:4 --programa piano",
            "midi melodia Do4:4 --instrumento 40",
            "musicxml melodia Do4:4 --instrumento 3",
        ] {
            let resultado = LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
            #expect(resultado.codigo == 2, Comment(rawValue: orden))
            #expect(resultado.datos == nil, Comment(rawValue: orden))
        }
    }

    @Test func musicXML() {
        let melodia = salida(
            "musicxml melodia Sol4:4 Do5:2 Re5:4 Mi5:2 --compas 3/4 --anacrusa 4 --tonalidad Sol mayor --tempo 60 4. --titulo Mi canción --clave sol8b"
        )
        #expect(melodia.hasPrefix("<?xml"))
        #expect(melodia.hasSuffix("</score-partwise>\n"))
        for fragmento in [
            "<work-title>Mi canción</work-title>", "<fifths>1</fifths>", "<beats>3</beats>",
            "<measure number=\"0\" implicit=\"yes\">", "<beat-unit-dot/>", "<per-minute>60</per-minute>",
            "<clef-octave-change>-1</clef-octave-change>",
        ] {
            #expect(melodia.contains(fragmento), Comment(rawValue: fragmento))
        }
        let coral = salida(
            "musicxml coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4, Do3 Mi4 Sol4 Do5 --duracion 2 --compas 3/2")
        for fragmento in [
            "<staves>2</staves>", "<type>half</type>", "<beats>3</beats>", "<beat-type>2</beat-type>",
            "<voice>4</voice>", "<staff>2</staff>",
        ] {
            #expect(coral.contains(fragmento), Comment(rawValue: fragmento))
        }
        let acordes = salida("musicxml acordes Do Lam Re7 Sol7 Do --duracion 4 --titulo Progresión")
        for fragmento in [
            "<harmony print-frame=\"no\">", "<kind text=\"7\">dominant</kind>", "<text>V7/V</text>",
            "<words>Do mayor:</words>", "<type>quarter</type>",
        ] {
            #expect(acordes.contains(fragmento), Comment(rawValue: fragmento))
        }
        #expect(salida("musicxml acordes Am Dm E7 Am --ingles").contains("<words>A minor:</words>"))
        #expect(salida("musicxml acordes Re Sol La7 Re --tonalidad Sol mayor").contains("<text>V</text>"))
        let analizado = salida("musicxml coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados --analisis")
        #expect(analizado.contains("<harmony") && analizado.contains("<lyric"))
        let soloCifrados = salida("musicxml coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados")
        #expect(soloCifrados.contains("<harmony") && !soloCifrados.contains("<lyric"))
        #expect(LineaDeComandos.leerClave("do en tercera") == .doEnTercera)
        #expect(LineaDeComandos.leerClave("Clave de Fa") == .fa)
        #expect(LineaDeComandos.leerClave("bass") == .fa)
        #expect(LineaDeComandos.leerClave("baritone clef") == .faEnTercera)
        #expect(LineaDeComandos.leerClave("re") == nil)

        for orden in [
            "musicxml", "musicxml partitura Do4:4", "musicxml melodia", "musicxml coral",
            "musicxml melodia Do4:4 --color rojo", "musicxml melodia Do4:4 --compas",
            "musicxml melodia Do4:4 --tempo rápido", "musicxml melodia Do4:4 --clave re",
            "musicxml melodia Do4:4 --duracion 2", "musicxml coral Do3 Do5 --clave fa",
            "musicxml melodia Do4:4 --cifrados", "musicxml acordes", "musicxml acordes Do Sol --analisis",
            "musicxml acordes Do Sol --clave fa",
        ] {
            let resultado = LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
            #expect(resultado.codigo == 2, Comment(rawValue: orden))
            #expect(resultado.salida == "", Comment(rawValue: orden))
        }
        for orden in [
            "musicxml melodia Do4:3", "musicxml melodia Do4:4 --compas 3/5", "musicxml coral Do3 Mi4, Sol2",
            "musicxml acordes Do Hm",
        ] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 1,
                Comment(rawValue: orden))
        }
    }

    @Test func mEI() {
        let melodia = salida(
            "mei melodia Sol4:4 Do5:2 Re5:4 Mi5:2 --compas 3/4 --anacrusa 4 --tonalidad Sol mayor --tempo 60 4. --titulo Mi canción --clave sol8b"
        )
        #expect(melodia.hasPrefix("<?xml"))
        #expect(melodia.hasSuffix("</mei>\n"))
        for fragmento in [
            "<title>Mi canción</title>", "keysig=\"1s\"", "meter.count=\"3\"",
            "<measure n=\"0\" metcon=\"false\">", "mm.dots=\"1\"", "mm=\"60\"",
            "clef.dis=\"8\" clef.dis.place=\"below\"",
        ] {
            #expect(melodia.contains(fragmento), Comment(rawValue: fragmento))
        }
        let coral = salida(
            "mei coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4, Do3 Mi4 Sol4 Do5 --duracion 2 --compas 3/2 --cifrados --analisis"
        )
        for fragmento in [
            "<staffGrp symbol=\"brace\" bar.thru=\"true\">", "meter.unit=\"2\"", "<layer n=\"2\">",
            "<staff n=\"2\">", "stem.dir=\"down\"", ">Sol</harm>", "<syl>V</syl>", ">Do mayor:</dir>",
        ] {
            #expect(coral.contains(fragmento), Comment(rawValue: fragmento))
        }
        let acordes = salida("mei acordes Am Dm E7 Am --ingles --duracion 4")
        for fragmento in [">E7</harm>", ">A minor:</dir>", "<chord ", "dur=\"4\""] {
            #expect(acordes.contains(fragmento), Comment(rawValue: fragmento))
        }
        for orden in [
            "mei", "mei partitura Do4:4", "mei melodia", "mei melodia Do4:4 --programa 3",
            "mei melodia Do4:4 --cifrados", "mei acordes Do Sol --analisis", "mei coral Do3 Do5 --clave fa",
        ] {
            let resultado = LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
            #expect(resultado.codigo == 2, Comment(rawValue: orden))
            #expect(resultado.salida == "", Comment(rawValue: orden))
        }
        #expect(
            LineaDeComandos.ejecutar(["midi", "coral", "Do3", "Do5", "--cifrados"]).error.contains(
                "MusicXML, MEI, LilyPond y ABC"))
    }

    @Test func lilyPondYABC() {
        let melodia = salida(
            "lilypond melodia Sol4:4 Do5:2 Re5:4 Mi5:2 --compas 3/4 --anacrusa 4 --tonalidad Sol mayor --tempo 60 4. --titulo Mi canción --clave sol8b"
        )
        #expect(melodia.hasPrefix("\\version \"2.24.0\""))
        for fragmento in [
            "title = \"Mi canción\"", "\\clef \"treble_8\" \\key g \\major \\time 3/4 \\tempo 4. = 60 \\partial 4",
            "c''2 d''4 |",
        ] {
            #expect(melodia.contains(fragmento), Comment(rawValue: fragmento))
        }
        let coral = salida(
            "lilypond coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4, Do3 Mi4 Sol4 Do5 --duracion 2 --compas 3/2 --cifrados --analisis"
        )
        for fragmento in ["\\new PianoStaff", "\\voiceTwo", "^\\markup \"Sol\"", "\"Do mayor:\" \"I\" \"T\""] {
            #expect(coral.contains(fragmento), Comment(rawValue: fragmento))
        }
        let abc = salida("abc acordes Am Dm E7 Am --ingles --duracion 4 --titulo Menor")
        for fragmento in ["X:1\nT:Menor\n", "K:Am\n", "\"^E7\"[E^GBd]", "\"_A minor:\""] {
            #expect(abc.contains(fragmento), Comment(rawValue: fragmento))
        }
        #expect(salida("abc arpegios Do Sol7 --patron alberti").contains("V:1 clef="))
        for orden in ["lilypond", "abc partitura Do4:4", "abc melodia", "lilypond melodia Do4:4 --programa 3"] {
            let resultado = LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
            #expect(resultado.codigo == 2, Comment(rawValue: orden))
        }
    }

    @Test func arpegiosComoPartitura() throws {
        func notas(_ xml: String) -> Int { xml.components(separatedBy: "<pitch>").count - 1 }
        // Do: Do Mi Sol Do; Sol7: Sol Si Re Fa Sol.
        let sencillo = salida("musicxml arpegios Do Sol7")
        #expect(notas(sencillo) == 9)
        #expect(sencillo.contains("<type>eighth</type>"))
        // Cuatro acordes de blanca en corcheas: cuatro notas cada uno.
        let alberti = salida("musicxml arpegios Do Lam Fa Sol7 --patron alberti --duracion 2 --titulo Alberti")
        #expect(notas(alberti) == 16)
        #expect(alberti.contains("<work-title>Alberti</work-title>"))
        #expect(salida("musicxml arpegios Do --figura 16").contains("<type>16th</type>"))
        #expect(
            salida("musicxml arpegios Do Sol7 --patron ida y vuelta")
                == salida("musicxml arpeggios Do Sol7 --pattern up-down"))
        #expect(salida("mei arpegios Do Sol7 --patron descendente").hasSuffix("</mei>\n"))
        let midi = LineaDeComandos.ejecutar(["midi", "arpegios", "Do", "Sol7", "--programa", "24"])
        #expect(midi.codigo == 0, Comment(rawValue: midi.error))
        #expect(try Array(#require(midi.datos).prefix(4)) == Array("MThd".utf8))

        for orden in [
            "musicxml arpegios", "musicxml arpegios Do --patron zigzag", "musicxml arpegios Do --cifrados",
            "musicxml arpegios Do --clave fa", "musicxml melodia Do4:4 --patron alberti",
            "musicxml acordes Do Sol --figura 8", "midi coral Do3 Do5 --patron alberti",
        ] {
            let resultado = LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
            #expect(resultado.codigo == 2, Comment(rawValue: orden))
            #expect(resultado.salida == "", Comment(rawValue: orden))
        }
        #expect(LineaDeComandos.ejecutar(["musicxml", "acordes", "Do", "--figura", "8"]).error.contains("«arpegios»"))
        for orden in ["musicxml arpegios Do --figura 0/4", "musicxml arpegios Do Hm", "midi arpegios Do --figura 3"] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 1,
                Comment(rawValue: orden))
        }
    }

    /// `--archivo`: los acordes de un fichero, con lo que dura cada uno.
    @Test func partituraDeUnArchivo() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do")
        let duraciones: [Duracion] = [.blanca, .negra, .negra, .redonda]
        let midi = try fichero(analisis.midi(duraciones: duraciones, titulo: "Coral"), extension: "mid")
        let xml = try fichero(Data(analisis.musicXML(duraciones: duraciones).utf8), extension: "musicxml")
        // El ritmo armónico del fichero pasa a la partitura, y su título y su tempo (el MIDI lo lleva siempre)
        // también.
        let conTempo = analisis.musicXML(duraciones: duraciones, tempo: Tempo(120), titulo: "Coral")
        let esperado = conTempo.trimmingCharacters(in: .newlines) + "\n"
        #expect(salida("musicxml acordes --archivo " + midi) == esperado)
        #expect(salida("musicxml chords --file " + midi) == esperado)
        let sinTempo = analisis.musicXML(duraciones: duraciones, titulo: "Coral").trimmingCharacters(in: .newlines)
        #expect(salida("musicxml acordes --archivo \(xml) --titulo Coral") == (sinTempo + "\n"))
        // `--duracion` manda sobre el ritmo del fichero.
        #expect(
            salida("musicxml acordes --archivo \(xml) --duracion 2 --titulo T")
                == salida("musicxml acordes Do Fa Sol7 Do --duracion 2 --titulo T"))
        #expect(salida("mei acordes --archivo " + xml).hasSuffix("</mei>\n"))
        let datos = LineaDeComandos.ejecutar(["midi", "acordes", "--archivo", xml])
        #expect(datos.codigo == 0, Comment(rawValue: datos.error))
        #expect(datos.datos == analisis.midi(duraciones: duraciones))
        // Arpegiados: Do (blanca, 4 corcheas), Fa y Sol7 (negra, 2 cada uno) y Do (redonda, 8).
        let arpegios = salida("musicxml arpegios --archivo " + midi)
        #expect((arpegios.components(separatedBy: "<pitch>").count - 1) == 16)
        // La ventana de una negra (4) es la de omisión en 4/4.
        #expect(salida("musicxml arpegios --archivo \(midi) --ventana 4") == arpegios)

        func resultado(_ orden: String) -> ResultadoDeOrden {
            LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
        }
        #expect(resultado("musicxml acordes Do --archivo " + midi).codigo == 2)
        #expect(resultado("musicxml acordes --archivo /no/existe.mid").codigo == 2)
        #expect(
            resultado("musicxml coral --archivo " + midi).error
                == "armonia: --archivo es solo para «acordes» y «arpegios»\nPrueba «armonia ayuda».\n")
        #expect(
            resultado("musicxml acordes Do --ventana 1").error
                == "armonia: --ventana va con --archivo\nPrueba «armonia ayuda».\n")
        let melodia = try fichero(Voz(leyendo: "Do4:4 Re4:4 Mi4:4").midi(), extension: "mid")
        #expect(resultado("musicxml acordes --archivo " + melodia).codigo == 2)
        let texto = try fichero(Data("hola".utf8), extension: "mid")
        #expect(resultado("musicxml acordes --archivo " + texto).codigo == 1)
    }
}
