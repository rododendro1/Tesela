import Foundation
import Testing

@testable import ArmoniaFormatos
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

@Suite struct FormatoDePartituraTests {
    @Test func extensionesYNombres() {
        #expect(FormatoDePartitura.allCases.map(\.extensionDeFichero) == ["musicxml", "mei", "ly", "gmn", "abc", "mid"])
        #expect(FormatoDePartitura.allCases.map(\.nombre) == ["MusicXML", "MEI", "LilyPond", "GUIDO", "ABC", "MIDI"])
        #expect(FormatoDePartitura.allCases.filter { !$0.esTexto } == [.midi])
        #expect(FormatoDePartitura(rawValue: "lilypond") == .lilyPond)
    }

    @Test func unaVozEnCadaFormatoEsLoQueDaSuFuncion() throws {
        let voz = try Voz(leyendo: "Sol4:4 Do5:2 Re5:8 Mi5:8 Fa#5:4 Sol5:2", compas: "3/4", anacrusa: .negra)
        let tonalidad = Tonalidad(.sol)
        let tempo = Tempo(72)
        func esperado(_ formato: FormatoDePartitura) -> Data {
            switch formato {
            case .musicXML: return Data(voz.musicXML(tonalidad: tonalidad, clave: .sol, tempo: tempo, titulo: "T").utf8)
            case .mei: return Data(voz.mei(tonalidad: tonalidad, clave: .sol, tempo: tempo, titulo: "T").utf8)
            case .lilyPond: return Data(voz.lilyPond(tonalidad: tonalidad, clave: .sol, tempo: tempo, titulo: "T").utf8)
            case .guido: return Data(voz.guido(tonalidad: tonalidad, clave: .sol, tempo: tempo, titulo: "T").utf8)
            case .abc: return Data(voz.abc(tonalidad: tonalidad, clave: .sol, tempo: tempo, titulo: "T").utf8)
            case .midi: return voz.midi(tonalidad: tonalidad, tempo: tempo, titulo: "T", instrumento: 40)
            }
        }
        for formato in FormatoDePartitura.allCases {
            let datos = voz.exportar(
                como: formato, tonalidad: tonalidad, clave: .sol, tempo: tempo, titulo: "T", instrumento: 40)
            #expect(datos == esperado(formato), "\(formato)")
        }
    }

    @Test func unCoralEnCadaFormatoEsLoQueDaSuFuncion() throws {
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        func esperado(_ formato: FormatoDePartitura) -> Data {
            switch formato {
            case .musicXML:
                return Data(coral.musicXML(duracion: .blanca, titulo: "C", cifrados: true, analisis: true).utf8)
            case .mei: return Data(coral.mei(duracion: .blanca, titulo: "C", cifrados: true, analisis: true).utf8)
            case .lilyPond:
                return Data(coral.lilyPond(duracion: .blanca, titulo: "C", cifrados: true, analisis: true).utf8)
            case .guido: return Data(coral.guido(duracion: .blanca, titulo: "C", cifrados: true, analisis: true).utf8)
            case .abc: return Data(coral.abc(duracion: .blanca, titulo: "C", cifrados: true, analisis: true).utf8)
            case .midi: return coral.midi(duracion: .blanca, titulo: "C")
            }
        }
        for formato in FormatoDePartitura.allCases {
            let datos = coral.exportar(como: formato, duracion: .blanca, titulo: "C", cifrados: true, analisis: true)
            #expect(datos == esperado(formato), "\(formato)")
        }
    }

    @Test func unaProgresionEnCadaFormatoEsLoQueDaSuFuncion() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        let duraciones: [Duracion] = [.negra, .negra, .blanca, .blanca, .redonda]
        func esperado(_ formato: FormatoDePartitura) -> Data {
            switch formato {
            case .musicXML: return Data(analisis.musicXML(duraciones: duraciones, titulo: "P").utf8)
            case .mei: return Data(analisis.mei(duraciones: duraciones, titulo: "P").utf8)
            case .lilyPond: return Data(analisis.lilyPond(duraciones: duraciones, titulo: "P").utf8)
            case .guido: return Data(analisis.guido(duraciones: duraciones, titulo: "P").utf8)
            case .abc: return Data(analisis.abc(duraciones: duraciones, titulo: "P").utf8)
            case .midi: return analisis.midi(duraciones: duraciones, titulo: "P")
            }
        }
        for formato in FormatoDePartitura.allCases {
            #expect(analisis.exportar(como: formato, duraciones: duraciones, titulo: "P") == esperado(formato))
            // Con una sola duración, la misma para todos los acordes.
            #expect(
                analisis.exportar(como: formato, duracion: .negra)
                    == analisis.exportar(como: formato, duraciones: Array(repeating: .negra, count: 5)))
        }
    }

    @Test func unContrapuntoEnCadaFormato() throws {
        let ejercicio = try Contrapunto(
            cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "La4 La4 Sol4 La4", especie: .primera)
        #expect(ejercicio.exportar(como: .musicXML, titulo: "F") == Data(ejercicio.musicXML(titulo: "F").utf8))
        #expect(ejercicio.exportar(como: .abc, titulo: "F") == Data(ejercicio.abc(titulo: "F").utf8))
        #expect(ejercicio.exportar(como: .midi, titulo: "F") == ejercicio.midi(titulo: "F"))
        // GUIDO, como los demás: cada voz en su pentagrama, con su nombre.
        let gmn = ejercicio.guido(titulo: "F")
        #expect(ejercicio.exportar(como: .guido, titulo: "F") == Data(gmn.utf8))
        #expect(gmn.contains(#"\title<"F">"#))
        #expect(gmn.contains("\\staff<1>") && gmn.contains("\\staff<2>"))
        #expect(gmn.contains(#"\instr<"Contrapunctus · Cantus firmus">"#))
    }
}
