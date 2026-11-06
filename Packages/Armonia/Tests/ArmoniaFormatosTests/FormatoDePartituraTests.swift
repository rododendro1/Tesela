import Foundation
import Testing

@testable import ArmoniaFormatos
@testable import ArmoniaElementos
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

@Suite struct FormatoDePartituraTests {
    @Test func extensionesYNombres() {
        let formatos = FormatoDePartitura.allCases
        #expect(formatos.map(\.extensionDeFichero) == ["musicxml", "mei", "ly", "gmn", "abc", "mid"])
        #expect(formatos.map(\.nombre) == ["MusicXML", "MEI", "LilyPond", "GUIDO", "ABC", "MIDI"])
        #expect(FormatoDePartitura.allCases.filter { !$0.esTexto } == [.midi])
        #expect(FormatoDePartitura(rawValue: "lilypond") == .lilyPond)
    }

    @Test func unaVozEnCadaFormatoEsLoQueDaSuFuncion() throws {
        let voz = try Voz(leyendo: "Sol4:4 Do5:2 Re5:8 Mi5:8 Fa#5:4 Sol5:2", compas: "3/4", anacrusa: .negra)
        let tonalidad = Tonalidad(.sol)
        let tempo = Tempo(72)
        func esperado(_ formato: FormatoDePartitura) -> Data {
            switch formato {
            case .musicXML:
                return Data(
                    voz.partitura(clave: .sol, encabezado: Encabezado(titulo: "T", tonalidad: tonalidad, tempo: tempo))
                        .musicXML().utf8)
            case .mei:
                return Data(
                    voz.partitura(clave: .sol, encabezado: Encabezado(titulo: "T", tonalidad: tonalidad, tempo: tempo))
                        .mei().utf8)
            case .lilyPond:
                return Data(
                    voz.partitura(clave: .sol, encabezado: Encabezado(titulo: "T", tonalidad: tonalidad, tempo: tempo))
                        .lilyPond().utf8)
            case .guido:
                return Data(
                    voz.partitura(clave: .sol, encabezado: Encabezado(titulo: "T", tonalidad: tonalidad, tempo: tempo))
                        .guido().utf8)
            case .abc:
                return Data(
                    voz.partitura(clave: .sol, encabezado: Encabezado(titulo: "T", tonalidad: tonalidad, tempo: tempo))
                        .abc().utf8)
            case .midi:
                return voz.partitura(
                    encabezado: Encabezado(titulo: "T", tonalidad: tonalidad, tempo: tempo, instrumento: 40)
                ).midi()
            }
        }
        for formato in FormatoDePartitura.allCases {
            let datos = voz.partitura(
                clave: .sol, encabezado: Encabezado(titulo: "T", tonalidad: tonalidad, tempo: tempo, instrumento: 40)
            ).exportar(como: formato)
            #expect(datos == esperado(formato), "\(formato)")
        }
    }

    @Test func unCoralEnCadaFormatoEsLoQueDaSuFuncion() throws {
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        func esperado(_ formato: FormatoDePartitura) -> Data {
            switch formato {
            case .musicXML:
                return Data(
                    coral.partitura(
                        duracion: .blanca, encabezado: Encabezado(titulo: "C"), conCifrados: true, conAnalisis: true
                    ).musicXML().utf8)
            case .mei:
                return Data(
                    coral.partitura(
                        duracion: .blanca, encabezado: Encabezado(titulo: "C"), conCifrados: true, conAnalisis: true
                    ).mei().utf8)
            case .lilyPond:
                return Data(
                    coral.partitura(
                        duracion: .blanca, encabezado: Encabezado(titulo: "C"), conCifrados: true, conAnalisis: true
                    ).lilyPond().utf8)
            case .guido:
                return Data(
                    coral.partitura(
                        duracion: .blanca, encabezado: Encabezado(titulo: "C"), conCifrados: true, conAnalisis: true
                    ).guido().utf8)
            case .abc:
                return Data(
                    coral.partitura(
                        duracion: .blanca, encabezado: Encabezado(titulo: "C"), conCifrados: true, conAnalisis: true
                    ).abc().utf8)
            case .midi: return coral.partitura(duracion: .blanca, encabezado: Encabezado(titulo: "C")).midi()
            }
        }
        for formato in FormatoDePartitura.allCases {
            let datos = coral.partitura(
                duracion: .blanca, encabezado: Encabezado(titulo: "C"), conCifrados: true, conAnalisis: true
            ).exportar(como: formato)
            #expect(datos == esperado(formato), "\(formato)")
        }
    }

    @Test func unaProgresionEnCadaFormatoEsLoQueDaSuFuncion() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        let duraciones: [Duracion] = [.negra, .negra, .blanca, .blanca, .redonda]
        let ritmo = RitmoArmonico(zip(analisis.acordes, duraciones).map { AcordeConDuracion($0.acorde, $1) })
        let partitura = ritmo.partitura(encabezado: Encabezado(titulo: "P"))
        func esperado(_ formato: FormatoDePartitura) -> Data {
            switch formato {
            case .musicXML: return Data(partitura.musicXML().utf8)
            case .mei: return Data(partitura.mei().utf8)
            case .lilyPond: return Data(partitura.lilyPond().utf8)
            case .guido: return Data(partitura.guido().utf8)
            case .abc: return Data(partitura.abc().utf8)
            case .midi: return partitura.midi()
            }
        }
        let negras = ritmo.con(duracion: .negra).partitura()
        for formato in FormatoDePartitura.allCases {
            #expect(partitura.exportar(como: formato) == esperado(formato))
            // Con una sola duración, la misma para todos los acordes.
            #expect(analisis.partitura(duracion: .negra).exportar(como: formato) == negras.exportar(como: formato))
        }
    }

    @Test func unContrapuntoEnCadaFormato() throws {
        let ejercicio = try Contrapunto(
            cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "La4 La4 Sol4 La4", especie: .primera)
        #expect(
            ejercicio.partitura(encabezado: Encabezado(titulo: "F")).exportar(como: .musicXML)
                == Data(ejercicio.partitura(encabezado: Encabezado(titulo: "F")).musicXML().utf8))
        #expect(
            ejercicio.partitura(encabezado: Encabezado(titulo: "F")).exportar(como: .abc)
                == Data(ejercicio.partitura(encabezado: Encabezado(titulo: "F")).abc().utf8))
        #expect(
            ejercicio.partitura(encabezado: Encabezado(titulo: "F")).exportar(como: .midi)
                == ejercicio.partitura(encabezado: Encabezado(titulo: "F")).midi())
        // GUIDO, como los demás: cada voz en su pentagrama, con su nombre.
        let gmn = ejercicio.partitura(encabezado: Encabezado(titulo: "F")).guido()
        #expect(ejercicio.partitura(encabezado: Encabezado(titulo: "F")).exportar(como: .guido) == Data(gmn.utf8))
        #expect(gmn.contains(#"\title<"F">"#))
        #expect(gmn.contains("\\staff<1>") && gmn.contains("\\staff<2>"))
        #expect(gmn.contains(#"\instr<"Contrapunctus · Cantus firmus">"#))
    }
}
