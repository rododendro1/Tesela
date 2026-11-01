import Armonia
import Foundation
import Testing

@testable import ArmoniaPresentacion

// «Abrir» en la vista de análisis: de un fichero MIDI o MusicXML a una progresión que se analiza como si se
// hubiera escrito.
@Suite struct ImportacionDeProgresionTests {
    @Test func unFicheroDaSuProgresion() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        #expect(try (ImportacionDeProgresion.progresion(de: analisis.midi())) == "Do Lam Re7 Sol7 Do")
        #expect(try (ImportacionDeProgresion.progresion(de: Data(analisis.musicXML().utf8))) == "Do Lam Re7 Sol7 Do")
    }

    @Test func laProgresionSeAnalizaComoLaEscrita() throws {
        let texto = "Do Fa Sol7 Do Lam Re7 Sol"
        let progresion = try ImportacionDeProgresion.progresion(de: AnalisisArmonico.analizar(leyendo: texto).midi())
        #expect(progresion == texto)
        #expect(
            try (PresentacionDeAnalisis.analizar(progresion, notacion: .espanolCompacto))
                == (PresentacionDeAnalisis.analizar(texto, notacion: .espanolCompacto)))
    }

    @Test func unaMelodiaSolaNoTieneAcordes() throws {
        let melodia = try Voz(leyendo: "Do4:4 Re4:4 Mi4:4").midi()
        do {
            _ = try ImportacionDeProgresion.progresion(de: melodia)
            Issue.record("Se esperaba un error")
        } catch {
            #expect((error as? ErrorDeImportacion) == .sinAcordes)

        }
        do {
            _ = try ImportacionDeProgresion.progresion(de: Data("hola".utf8))
            Issue.record("Se esperaba un error")
        } catch {
            #expect((error as? ErrorDeImportacion) == .formatoDesconocido)

        }
    }

    @Test func losErroresSeExplicanEnLaNotacion() {
        #expect(ErrorDeImportacion.sinAcordes.descripcion(en: .inglesASCII) == "No chords sound in the file.")
    }
}

// El ritmo armónico de una pieza importada: lo siguen la partitura, el MIDI, «Escuchar» y los arpegios.
@Suite struct RitmoArmonicoTests {
    private let duraciones: [Duracion] = [.blanca, .negra, .negra, .redonda]

    private func importada() throws -> ProgresionImportada {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do")
        let datos = analisis.midi(duraciones: duraciones, tempo: Tempo(90), titulo: "Coral")
        return try ImportacionDeProgresion.leer(datos)
    }

    @Test func seLeeElRitmoElCompasYElTempo() throws {
        let leida = try importada()
        #expect(leida.texto == "Do Fa Sol7 Do")
        #expect(leida.ritmo.duraciones == duraciones)
        #expect(leida.ritmo.compas == .compasillo)
        #expect(try abs(#require(leida.ritmo.tempo).negrasPorMinuto - (90)) <= 0.001)
        #expect(leida.titulo == "Coral")
        #expect(ImportacionDeProgresion.extensiones.contains("mxl"))
    }

    @Test func elAnalisisSigueElRitmo() throws {
        let leida = try importada()
        let analisis = try #require(PresentacionDeAnalisis.analizar(leida, notacion: .espanolCompacto))
        #expect(analisis.ritmo == leida.ritmo)
        // Lo mismo que escrita, salvo el ritmo.
        let escrita = try PresentacionDeAnalisis.analizar("Do Fa Sol7 Do", notacion: .espanolCompacto)
        #expect(analisis.titulo == escrita.titulo)
        #expect(analisis.tramos == escrita.tramos)
        #expect(escrita.ritmo == nil)
        #expect(analisis.ficheros != escrita.ficheros)
        // A negra = 90, la blanca dura 4/3 de segundo y la negra 2/3.
        let inicios = Set(analisis.sonido.notas.map { ($0.inicio * 1000).rounded() / 1000 })
        #expect(inicios == [0, 1.333, 2, 2.667])
        // Los arpegios también: 4 + 2 + 2 + 8 corcheas.
        let arpegiada = try #require(analisis.arpegiada(.ascendente, notacion: .espanolCompacto))
        #expect(arpegiada.voz.eventos.count == 16)
        #expect(arpegiada.voz.eventos.reduce(Duracion.cero) { $0 + $1.duracion } == Duracion(2))
    }

    @Test func unRitmoQueNoCuadraNoSeUsa() {
        let acordes = [Acorde("Do"), Acorde("Sol")]
        let cojo = RitmoArmonico(duraciones: [.blanca])
        #expect(PresentacionDeAnalisis.analizar(acordes, ritmo: cojo, notacion: .espanolCompacto)?.ritmo == nil)
        let nulo = RitmoArmonico(duraciones: [.blanca, .cero])
        #expect(PresentacionDeAnalisis.analizar(acordes, ritmo: nulo, notacion: .espanolCompacto)?.ritmo == nil)
        #expect(
            PresentacionDeAnalisis.analizar(acordes, notacion: .espanolCompacto)
                == PresentacionDeAnalisis.analizar(acordes, ritmo: cojo, notacion: .espanolCompacto))
    }

    @Test func sonidoConDuraciones() {
        let sonido = Escucha.acordes([Acorde("Do"), Acorde("Sol")], duraciones: [.blanca, .negra], tempo: Tempo(60))
        #expect(Set(sonido.notas.map(\.inicio)) == [0, 2])
        #expect(sonido.notas.last?.duracion == 0.92)
    }
}
