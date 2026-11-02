import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

// Los microtonos en las partituras: los desvíos de cada nota, cómo los escribe cada formato y los signos del
// pentagrama.

@Suite struct MicrotonosEnPartiturasTests {
    @Test func desviosDeUnEvento() throws {
        let mi: Evento = "Mi♭4(50¢):4"
        #expect(mi.alturas == ["Mi♭4"])
        #expect(mi.desvios == [50])
        #expect(mi.esMicrotonal)
        #expect(mi.texto == "Mi♭4(50¢):4")
        #expect(Evento("Mib4(50c):4") == mi)
        #expect(mi.texto(en: .inglesASCII) == "Eb4(50c):4")
        // En un acorde, cada nota con el suyo; se redondean a la centésima de cent.
        let acorde: Evento = "Do4+Si4(-15.094¢):2"
        #expect(acorde.desvios == [0, -15.09])
        #expect(acorde.desvio(0) == 0 && acorde.desvio(1) == -15.09)
        #expect(acorde.texto == "Do4+Si4(-15.09¢):2")
        // Sin desvíos, nada cambia.
        #expect(Evento(alturas: ["Do4"], duracion: .negra, desvios: [0]).desvios == [])
        #expect(Evento("Do4:4").desvios == [])
        #expect(!Evento("Do4:4").esMicrotonal)
        #expect(throws: ErrorDeLectura.self) { try Evento(leyendo: "Mi4(mucho¢):4") }
        // Se conservan al transportar, al partir en compases y al cambiar de duración.
        #expect(mi.transponer(.segundaMayor).desvios == [50])
        let voz = try Voz(leyendo: "Do4:2 Mi♭4(50¢):1", compas: "3/4")
        #expect(voz.compases.flatMap { $0 }.dropFirst().allSatisfy { $0.desvios == [50] })
        #expect(voz.grafia.flatMap { $0 }.dropFirst().allSatisfy { $0.desvios == [50] })
        #expect(voz.aumentar(2).eventos[1].desvios == [50])
        #expect(voz.retrogradar().eventos[0].desvios == [50])
    }

    @Test func escalaComoVoz() {
        let voz = Escala(.re, .bayati).voz()
        #expect(voz.eventos.count == 8)
        #expect(voz.eventos.map(\.duracion).allSatisfy { $0 == .negra })
        #expect(voz.eventos[1].alturas == ["Mi♭4"])
        #expect(voz.eventos.map { $0.desvio(0) } == [0, 50, 0, 0, 0, 0, 0, 0])
        // Rāst baja con Si♭: la voz sube con Si𝄳 y baja con Si♭.
        let rast = Escala(.do, .maqamRast).voz()
        #expect(rast.eventos.count == 15)
        #expect(rast.eventos[6].desvio(0) == -50 && rast.eventos[8].desvio(0) == 0)
        #expect(Escala(.do, .maqamRast).voz(sentido: .descendente).eventos.first?.alturas == ["Do5"])
        // Sīkāh empieza y acaba en Mi𝄳: las dos tónicas se apartan.
        let sikah = Escala(.mi, .sikah).voz()
        #expect(sikah.eventos.first?.desvio(0) == -50 && sikah.eventos.last?.desvio(0) == -50)
        #expect(sikah.musicXML().contains("<alter>-0.5</alter>"))
        // Sin microtonos, sin desvíos.
        #expect(Escala(.do, .mayor).voz().eventos.allSatisfy { !$0.esMicrotonal })
    }

    @Test func signos() {
        #expect(SignoMicrotonal(semitonos: -1, desvio: 50) == .cuartos(-1))
        #expect(SignoMicrotonal(semitonos: 0, desvio: 50) == .cuartos(1))
        #expect(SignoMicrotonal(semitonos: -1, desvio: -50) == .cuartos(-3))
        #expect(SignoMicrotonal(semitonos: 1, desvio: 50) == .cuartos(3))
        #expect(SignoMicrotonal(semitonos: -1, desvio: 50, persa: true) == .koron)
        #expect(SignoMicrotonal(semitonos: 0, desvio: 50, persa: true) == .sori)
        #expect(SignoMicrotonal(semitonos: 0, desvio: -15.09) == .comas(-1))
        #expect(SignoMicrotonal(semitonos: 1, desvio: -13.21) == .comas(4))
        #expect(SignoMicrotonal(semitonos: -1, desvio: 13.21) == .comas(-4))
        #expect(SignoMicrotonal(semitonos: 0, desvio: 0) == nil)
        #expect(SignoMicrotonal.comas(-1).smufl == "accidentalKomaFlat")
        #expect(SignoMicrotonal.comas(5).smufl == "accidentalKucukMucennebSharp")
        #expect(SignoMicrotonal.cuartos(-1).mei == "1qf" && SignoMicrotonal.comas(8).mei == "bms")
        #expect(SignoMicrotonal.comas(4).lilypond == nil && SignoMicrotonal.cuartos(3).lilypond == "isih")
        // Un número exacto de moria, con los signos de Wyschnegradsky; MEI no los tiene.
        #expect(SignoMicrotonal(semitonos: 0, desvio: -100.0 / 3) == .moria(-2))
        #expect(SignoMicrotonal(semitonos: 1, desvio: -100.0 / 3) == .moria(4))
        #expect(SignoMicrotonal.moria(-2).smufl == "accidentalWyschnegradsky2TwelfthsFlat")
        #expect(SignoMicrotonal.moria(8).musicXML.smufl == "accidentalWyschnegradsky8TwelfthsSharp")
        #expect(SignoMicrotonal.moria(-2).mei == nil && SignoMicrotonal.moria(-2).lilypond == nil)
        #expect(SignoMicrotonal.flecha(semitonos: -1, comas: 1).smufl == "accidentalFlatOneArrowUp")
        #expect(SignoMicrotonal.flecha(semitonos: 0, comas: -1).smufl == "accidentalNaturalOneArrowDown")
        #expect(EscritorMusicXML.NotaEscrita.alter(-1, 50) == "-0.5")
        #expect(EscritorMusicXML.NotaEscrita.alter(1, 0) == "1")
    }

    @Test func formatos() {
        let bayati = Escala(.re, .bayati).voz()
        let musicXML = bayati.musicXML()
        #expect(musicXML.contains("<alter>-0.5</alter>"))
        #expect(musicXML.contains("<accidental>quarter-flat</accidental>"))
        #expect(bayati.mei().contains("accid=\"1qf\""))
        #expect(bayati.lilyPond().contains("eeh'"))
        #expect(bayati.abc().contains("_/E"))
        // Las comas: el `alter` exacto y el glifo SMuFL en MusicXML; los signos de Arel-Ezgi-Uzdilek en MEI.
        let rast = Escala(.sol, .rastMakami).voz(sentido: .ascendente)
        #expect(rast.musicXML().contains("<alter>-0.1509</alter>"))
        #expect(rast.musicXML().contains("<accidental smufl=\"accidentalKomaFlat\">other</accidental>"))
        #expect(rast.mei().contains("accid=\"kf\"") && rast.mei().contains("accid=\"bs\""))
        // Los moria de un echos: el `alter` exacto y el signo de Wyschnegradsky.
        let protos = Escala(.re, .echosProtos).voz(sentido: .ascendente).musicXML()
        #expect(protos.contains("<alter>-0.3333</alter>"))
        #expect(protos.contains("smufl=\"accidentalWyschnegradsky2TwelfthsFlat\""))
        // LilyPond no tiene nombres para las comas: la nota temperada.
        #expect(rast.lilyPond().contains("fis'"))
        // Sin microtonos, como antes.
        let mayor = Escala(.do, .mayor).voz()
        #expect(!mayor.musicXML().contains("<accidental"))
    }

    @Test func midiConInflexiones() {
        func contiene(_ bytes: [UInt8], _ trozo: [UInt8]) -> Bool {
            bytes.indices.dropLast(trozo.count - 1).contains { bytes[$0..<($0 + trozo.count)].elementsEqual(trozo) }
        }
        let bytes = [UInt8](Escala(.re, .bayati).voz().midi())
        func tiene(_ trozo: [UInt8]) -> Bool { contiene(bytes, trozo) }
        // El ámbito de la inflexión (RPN 0 = 2 semitonos), +50 cents antes del Mi𝄳 y la vuelta a 0 en el Fa.
        #expect(tiene([0xB0, 101, 0]) && tiene([0xB0, 6, 2]))
        #expect(tiene([0xE0, 0x00, 0x50]))
        #expect(tiene([0xE0, 0x00, 0x40]))
        // Sin microtonos, ni inflexiones ni RPN.
        let mayor = [UInt8](Escala(.do, .mayor).voz().midi())
        #expect(!contiene(mayor, [0xB0, 101, 0]))
        #expect(ArchivoMIDI.inflexiones(de: [(0, 0), (480, 0)], canal: 0).isEmpty)
        let inflexiones = ArchivoMIDI.inflexiones(de: [(0, 0), (480, -50), (960, -50), (1440, 0)], canal: 1)
        #expect(inflexiones.map { $0.0 } == [0, 0, 0, 0, 480, 1440])
        #expect(inflexiones[4].1 == [0xE1, 0x00, 0x30])
    }

    @Test func pentagrama() {
        let bayati = Escala(.re, .bayati).svgPentagrama()
        #expect(bayati.contains(GlifosSMuFL.medioBemol.trazado))
        #expect(bayati.contains("<title>Mi𝄳</title>"))
        // El koron en un dastgāh; las comas en un makam.
        #expect(Escala(.re, .sur).svgPentagrama().contains(GlifosSMuFL.koron.trazado))
        let rast = Escala(.sol, .rastMakami).svgPentagrama()
        #expect(rast.contains(GlifosSMuFL.komaBemol.trazado))
        #expect(rast.contains(GlifosSMuFL.bakiyeSostenido.trazado))
        #expect(rast.contains("<title>Si⁻¹</title>"))
        // Rāst baja con Si♭: tras el Si𝄳 de la subida, el bemol se vuelve a escribir.
        let maqamRast = Escala(.do, .maqamRast).svgPentagrama()
        #expect(maqamRast.contains(GlifosSMuFL.medioBemol.trazado) && maqamRast.contains(GlifosSMuFL.bemol.trazado))
        #expect(!Escala(.re, .dorico).svgPentagrama().contains(GlifosSMuFL.medioBemol.trazado))
        // Segâh: la tónica, koma bemol; el Fa♯ una koma bajo, bakiye sostenido.
        let segah = Escala(.si, .segahMakami).svgPentagrama()
        #expect(segah.contains(GlifosSMuFL.komaBemol.trazado) && segah.contains(GlifosSMuFL.bakiyeSostenido.trazado))
        #expect(SignoMicrotonal(semitonos: 1, desvio: 30 * 1200 / 53 - 700) == .comas(4))
        // Un echos, con los moria de Wyschnegradsky: Mi y Si dos moria bajos.
        let protos = Escala(.re, .echosProtos).svgPentagrama()
        #expect(protos.contains(GlifosSMuFL.moriaBemol2.trazado) && protos.contains("<title>Mi⁻²</title>"))
        #expect(Escala(.sol, .echosDefteros).svgPentagrama().contains(GlifosSMuFL.moriaBemol4.trazado))
        // Un thāṭ, con la flecha de Helmholtz-Ellis en los śruti que se apartan una coma de los pitagóricos.
        let bilaval = Escala(.do, .bilaval).svgPentagrama()
        #expect(bilaval.contains(GlifosSMuFL.becuadroFlechaAbajo.trazado) && bilaval.contains("<title>Mi↓</title>"))
        #expect(Escala(.do, .purvi).svgPentagrama().contains(GlifosSMuFL.bemolFlechaArriba.trazado))
        #expect(!Escala(.do, .bhairavi).svgPentagrama().contains(GlifosSMuFL.bemolFlechaArriba.trazado))
    }
}
