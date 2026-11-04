import Foundation
import Testing

@testable import ArmoniaFormatos
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
        let temperadas = ArchivoMIDI.mensajes(de: [[(60, 0, 480, 0, 80), (64, 0, 480, 0, 80)]], instrumentos: [0])
        #expect(temperadas[0].allSatisfy { [0x90, 0x80].contains($0.1[0]) })
        // Una tras otra, en el canal de la pista: la inflexión, antes de cada una que cambia.
        let seguidas = ArchivoMIDI.mensajes(
            de: [[(60, 0, 480, 0, 80), (62, 480, 960, -50, 80), (64, 960, 1440, -50, 80), (65, 1440, 1920, 0, 80)]],
            instrumentos: [0])[0]
        let inflexiones = seguidas.filter { $0.1[0] & 0xF0 == 0xE0 }
        #expect(inflexiones.map { $0.0 } == [480, 1440])
        #expect(inflexiones[0].1 == [0xE0, 0x00, 0x30])
        #expect(seguidas.allSatisfy { $0.1[0] & 0x0F == 0 })
    }

    // MARK: Un canal por inflexión

    /// Los canales de las notas que empiezan (los mensajes 0x9n) de una pista.
    private func canales(_ mensajes: [(Int, [UInt8])]) -> [UInt8] {
        mensajes.filter { $0.1[0] & 0xF0 == 0x90 }.map { $0.1[0] & 0x0F }
    }

    /// Un acorde con una tercera pura y una quinta pura: cada nota que se aparta distinto, en su canal, con el
    /// instrumento de su pista; la otra pista no se entera.
    @Test func lasNotasQueSeApartanDistintoVanACanalesDistintos() {
        let pistas: [[ArchivoMIDI.NotaMIDI]] = [
            [(60, 0, 960, 0, 80), (64, 0, 960, -13.69, 80), (67, 0, 960, 1.96, 80)],
            [(48, 0, 960, 0, 80)],
        ]
        let mensajes = ArchivoMIDI.mensajes(de: pistas, instrumentos: [52, 0])
        #expect(canales(mensajes[0]) == [0, 2, 3])
        #expect(canales(mensajes[1]) == [1])
        #expect(mensajes[0].contains { $0.1 == [0xC2, 52] } && mensajes[0].contains { $0.1 == [0xC3, 52] })
        #expect(mensajes[0].contains { $0.1 == [0xB2, 6, 2] })
        let inflexiones = mensajes[0].filter { $0.1[0] & 0xF0 == 0xE0 }
        #expect(inflexiones.map { $0.1[0] } == [0xE2, 0xE3])
        #expect(ArchivoMIDI.inflexion(-13.69) == 7631 && ArchivoMIDI.inflexion(1.96) == 8272)
        #expect(mensajes[1].allSatisfy { $0.1[0] & 0x0F == 1 })
    }

    /// Un canal que ya tiene la inflexión y el instrumento se vuelve a usar, sin mandarlos otra vez; si no, el que
    /// lleva más tiempo callado.
    @Test func losCanalesSeVuelvenAUsar() {
        let notas: [ArchivoMIDI.NotaMIDI] = [
            (60, 0, 480, 0, 80), (64, 0, 480, -14, 80), (62, 480, 960, 0, 80), (65, 480, 960, -14, 80),
            (67, 960, 1440, 20, 80), (71, 960, 1440, 30, 80),
        ]
        let pistas = [notas]
        let mensajes = ArchivoMIDI.mensajes(de: pistas, instrumentos: [0])[0]
        // El Fa vuelve al 1, que ya está a −14 cents; el Si, que se aparta distinto, va al que lleva más callado.
        #expect(canales(mensajes) == [0, 1, 0, 1, 0, 2])
        #expect(mensajes.filter { $0.1[0] == 0xE1 }.map { $0.0 } == [0])
        #expect(mensajes.filter { $0.1[0] == 0xE0 }.map { $0.0 } == [960])
        #expect(mensajes.filter { $0.1[0] == 0xE2 }.map { $0.0 } == [960])
        #expect(mensajes.filter { $0.1[0] == 0xC1 }.count == 1)
        // Con dos pistas, la segunda usa el siguiente que no es de ninguna.
        let dos = ArchivoMIDI.mensajes(
            de: [[(60, 0, 480, 0, 80)], [(48, 0, 480, 0, 80), (52, 0, 480, -14, 80)]], instrumentos: [0, 0])
        #expect(canales(dos[1]) == [1, 2])
    }

    /// Sin canales libres, la nota va al de su pista con la inflexión que tenga; nunca al 10.
    @Test func sinCanalesLibres() {
        let acorde: [ArchivoMIDI.NotaMIDI] = (0..<16).map { (60 + $0, 0, 480, Double($0) + 1, 80) }
        let mensajes = ArchivoMIDI.mensajes(de: [acorde], instrumentos: [0])[0]
        let usados = canales(mensajes)
        #expect(Set(usados).count == 15 && !usados.contains(9))
        #expect(usados.last == 0)
        #expect(mensajes.filter { $0.1[0] & 0xF0 == 0xE0 }.count == 15)
    }

    /// Un acorde con microtonos sale por varios canales y vuelve como una sola parte, con sus desvíos.
    @Test func unAcordeMicrotonalVaYVuelve() throws {
        let voz = try Voz(leyendo: "Do4+Mi4(-14¢)+Sol4(2¢):2 Re4(-50¢):2")
        let pieza = try PiezaImportada(midi: voz.midi())
        #expect(Set(pieza.notas.map(\.parte)) == [0])
        #expect(pieza.notas.map(\.altura.midi) == [60, 64, 67, 62])
        let desvios = pieza.notas.map(\.desvio)
        for (leido, esperado) in zip(desvios, [0, -14, 2, -50] as [Double]) { #expect(abs(leido - esperado) < 0.05) }
        // Las cuatro voces de un coral siguen siendo cuatro partes.
        let coral = try Coral(leyendo: "Do3 Sol3 Mi4 Do5 | Sol2 Sol3 Re4 Si4")
        #expect(Set(try PiezaImportada(midi: coral.midi()).notas.map(\.parte)) == [0, 1, 2, 3])
    }

    // MARK: En una afinación

    /// Una afinación que lo sube todo lo mismo.
    private struct Subida: Afinacion {
        let cents: Double
        func frecuencia(de nota: Altura) -> Double { nota.frecuencia() * pow(2, cents / 1200) }
    }

    /// En una afinación, cada nota suena en la tecla temperada más cercana, sin pasar de un semitono, con la
    /// inflexión de lo que falte.
    @Test func elMIDIEnUnaAfinacion() throws {
        let temperado = ArchivoMIDI.sonido("Do4", desvio: 30, afinacion: nil)
        #expect(temperado.clave == 60 && temperado.desvio == 30)
        let alto = ArchivoMIDI.sonido("Do4", desvio: 0, afinacion: Subida(cents: 150))
        #expect(alto.clave == 61 && abs(alto.desvio - 50) < 1e-6)
        let bajo = ArchivoMIDI.sonido("Do4", desvio: 10, afinacion: Subida(cents: -130))
        #expect(bajo.clave == 59 && abs(bajo.desvio + 20) < 1e-6)
        let voz = try Voz(leyendo: "Do4:4 Mi4:4 Sol4:2")
        let pieza = try PiezaImportada(midi: voz.midi(afinacion: Subida(cents: 25)))
        #expect(pieza.notas.map(\.altura.midi) == [60, 64, 67])
        #expect(pieza.notas.allSatisfy { abs($0.desvio - 25) < 0.05 })
        // Sin afinación, como siempre.
        #expect(voz.midi(afinacion: nil) == voz.midi())
        let coral = try Coral(leyendo: "Do3 Sol3 Mi4 Do5")
        #expect(coral.midi(afinacion: Subida(cents: 10)) != coral.midi())
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

    @Test func pentagramaConRitmo() throws {
        // Una escala microtonal en una secuencia de estudio, con ritmo: sus notas siguen llevando el signo.
        let terceras = Escala(.re, .bayati).svgPentagrama(secuencia: .terceras)
        #expect(terceras.contains(GlifosSMuFL.medioBemol.trazado) && terceras.contains("<title>Mi𝄳</title>"))
        #expect(Escala(.re, .sur).svgPentagrama(secuencia: .terceras).contains(GlifosSMuFL.koron.trazado))
        // Una voz con desvíos: la de una escala o una escrita a mano, con los cents en el nombre.
        let bayati = Escala(.re, .bayati).voz().svgPentagrama(titulo: "Bayati")
        #expect(bayati.contains(GlifosSMuFL.medioBemol.trazado))
        let escrita = try Voz(leyendo: "Mi♭4(50¢):4 Re4:4 Fa4(-50¢):2").svgPentagrama(titulo: "A mano")
        #expect(escrita.contains(GlifosSMuFL.medioBemol.trazado) && escrita.contains("(+50¢)</title>"))
        #expect(escrita.contains("(-50¢)</title>"))
        // Sin desvíos, nada cambia.
        let temperada = try Voz(leyendo: "Mi♭4:4 Re4:4").svgPentagrama(titulo: "Temperada")
        #expect(!temperada.contains(GlifosSMuFL.medioBemol.trazado) && !temperada.contains("¢"))
    }

    // MARK: Lectura

    /// Lo que suena de cada nota, en cents desde el Do0, y su letra.
    private func sonidos(_ voz: Voz) -> [(cents: Double, letra: NotaNatural)] {
        voz.eventos.flatMap { evento in
            evento.alturas.indices.map { i in
                (Double(evento.alturas[i].midi * 100) + evento.desvio(i), evento.alturas[i].nota.natural)
            }
        }
    }

    private func sonidos(_ pieza: PiezaImportada) -> [(cents: Double, letra: NotaNatural)] {
        pieza.notas.sorted { ($0.inicio, $0.altura.midi) < ($1.inicio, $1.altura.midi) }.map {
            (Double($0.altura.midi * 100) + $0.desvio, $0.altura.nota.natural)
        }
    }

    @Test func elAlterConDecimalesEsUnMicrotono() throws {
        let xml = Escala(.mi, .sikah).voz().musicXML()
        let pieza = try PiezaImportada(musicXML: Data(xml.utf8))
        // Mi𝄳 (`<alter>-0.5</alter>` sobre E) se lee como Mi♭ y 50 cents: suena igual y conserva la letra.
        #expect(pieza.notas[0].altura == "Mi♭4" && pieza.notas[0].desvio == 50)
        #expect(pieza.notas[1].altura == "Fa4" && pieza.notas[1].desvio == 0)
        let fa = try PiezaImportada(musicXML: Data(Voz(leyendo: "Fa4(50¢):4 Re4(-22.64¢):4").musicXML().utf8))
        #expect(fa.notas.map(\.altura) == ["Fa4", "Re4"])
        #expect(fa.notas.map(\.desvio) == [50, -22.64])
    }

    /// Cada escala con microtonos sale y vuelve igual por MusicXML y por MIDI: la letra en MusicXML, y lo que suena
    /// en los dos (en MIDI, con la precisión de la inflexión de tono: 200/8192 cents).
    @Test(arguments: [true, false])
    func idaYVueltaDeLasEscalasMicrotonales(musicXML: Bool) throws {
        let tipos = TipoDeEscala.tradicionales.filter { $0.microtonal != nil }
        #expect(tipos.count > 20)
        for tipo in tipos {
            let voz = Escala(.re, tipo).voz()
            let pieza =
                musicXML
                ? try PiezaImportada(musicXML: Data(voz.musicXML().utf8)) : try PiezaImportada(midi: voz.midi())
            let esperados = sonidos(voz)
            let leidos = sonidos(pieza)
            #expect(leidos.count == esperados.count, Comment(rawValue: tipo.nombre))
            for (leido, esperado) in zip(leidos, esperados) {
                #expect(abs(leido.cents - esperado.cents) < 0.05, Comment(rawValue: tipo.nombre))
                if musicXML { #expect(leido.letra == esperado.letra, Comment(rawValue: tipo.nombre)) }
            }
        }
    }

    @Test func laInflexionDeTonoEnMIDI() throws {
        // Sin microtonos, sin desvíos.
        let temperada = try PiezaImportada(midi: Voz(leyendo: "Do4:4 Mi4:4").midi())
        #expect(temperada.notas.allSatisfy { $0.desvio == 0 })
        // Con un ámbito de 12 semitonos (RPN 0 = 12), la inflexión máxima es una octava.
        let cabecera: [UInt8] = Array("MThd".utf8) + [0, 0, 0, 6, 0, 0, 0, 1, 1, 224]
        let cuerpo: [UInt8] = [
            0x00, 0xB0, 101, 0, 0x00, 0xB0, 100, 0, 0x00, 0xB0, 6, 12,
            0x00, 0xE0, 0x00, 0x60, // 12288: la mitad de la mitad de arriba, +6 semitonos
            0x00, 0x90, 60, 80, 0x83, 0x60, 0x80, 60, 0,
            0x00, 0xE0, 0x00, 0x40, // de vuelta al centro
            0x00, 0x90, 62, 80, 0x83, 0x60, 0x80, 62, 0,
            0x00, 0xFF, 0x2F, 0x00,
        ]
        let datos = cabecera + Array("MTrk".utf8) + [0, 0, 0, UInt8(cuerpo.count)] + cuerpo
        let pieza = try PiezaImportada(midi: Data(datos))
        #expect(pieza.notas.map(\.desvio) == [600, 0])
    }
}
