import Foundation
import Testing

@testable import Elementos
@testable import Formatos
@testable import PartituraArmonia
@testable import Teoria

// Los microtonos en las partituras: los desvíos de cada nota, cómo los escribe cada formato y los signos del
// pentagrama.

@Suite struct MicrotonosEnPartiturasTests {
    @Test func desviosDeUnEvento() throws {
        let mi: Evento = "Mi♭4(50¢):4"
        #expect(mi.alturas == ["Mi♭4"])
        #expect(mi.notas == [Evento.NotaDelEvento("Mi♭4", desvio: 50)])
        #expect(mi.notas[0].texto(en: .inglesASCII) == "Eb4(50c)" && mi.notas[0].description == "Mi♭4(50¢)")
        #expect(mi.esMicrotonal)
        #expect(mi.texto == "Mi♭4(50¢):4")
        #expect(Evento("Mib4(50c):4") == mi)
        #expect(mi.texto(en: .inglesASCII) == "Eb4(50c):4")
        // En un acorde, cada nota con el suyo; se redondean a la centésima de cent.
        let acorde: Evento = "Do4+Si4(-15.094¢):2"
        #expect(acorde.notas.map(\.desvio) == [0, -15.09])
        #expect(acorde.notas[0].desvio == 0 && acorde.notas[1].desvio == -15.09)
        #expect(acorde.texto == "Do4+Si4(-15.09¢):2")
        // Sin desvíos, nada cambia.
        #expect(Evento(notas: [Evento.NotaDelEvento("Do4", desvio: -0.001)], duracion: .negra) == Evento("Do4:4"))
        #expect(Evento("Do4:4").notas == [Evento.NotaDelEvento("Do4")])
        #expect(!Evento("Do4:4").esMicrotonal)
        #expect(throws: ErrorDeLectura.self) { try Evento(leyendo: "Mi4(mucho¢):4") }
        // Como mucho un semitono arriba o abajo: unos cents enormes no cabían en un Int al escribirlos (lo encontró
        // el fuzzer de los lectores).
        #expect(try Evento(leyendo: "Mi4(-100¢):4").notas.map(\.desvio) == [-100])
        #expect(throws: ErrorDeLectura.self) { try Evento(leyendo: "Mi4(100.5¢):4") }
        let enorme = "Mi4(50" + String(repeating: "3", count: 114) + "¢):4"
        #expect(throws: ErrorDeLectura.self) { try Evento(leyendo: enorme) }
        // Escrita desde código, una nota así no detiene el programa.
        let absurda = Evento(notas: [Evento.NotaDelEvento("Mi4", desvio: 1e300)], duracion: .negra)
        #expect(!absurda.description.isEmpty)
        #expect(EscritorMusicXML.NotaEscrita.alter(0, 1e300).contains("e+"))
        // Se conservan al transportar, al partir en compases y al cambiar de duración.
        #expect(mi.transponer(.segundaMayor).notas == [Evento.NotaDelEvento("Fa4", desvio: 50)])
        let voz = try Voz(leyendo: "Do4:2 Mi♭4(50¢):1", compas: "3/4")
        #expect(voz.compases.flatMap { $0 }.dropFirst().allSatisfy { $0.notas.map(\.desvio) == [50] })
        #expect(voz.grafia.flatMap { $0 }.dropFirst().allSatisfy { $0.notas.map(\.desvio) == [50] })
        #expect(voz.aumentar(2).eventos[1].notas.map(\.desvio) == [50])
        #expect(voz.retrogradar().eventos[0].notas.map(\.desvio) == [50])
    }

    @Test func escalaComoVoz() {
        let voz = Escala(.re, .bayati).voz()
        #expect(voz.eventos.count == 8)
        #expect(voz.eventos.map(\.duracion).allSatisfy { $0 == .negra })
        #expect(voz.eventos[1].alturas == ["Mi♭4"])
        #expect(voz.eventos.map { $0.notas[0].desvio } == [0, 50, 0, 0, 0, 0, 0, 0])
        // Rāst baja con Si♭: la voz sube con Si𝄳 y baja con Si♭.
        let rast = Escala(.do, .maqamRast).voz()
        #expect(rast.eventos.count == 15)
        #expect(rast.eventos[6].notas[0].desvio == -50 && rast.eventos[8].notas[0].desvio == 0)
        #expect(Escala(.do, .maqamRast).voz(sentido: .descendente).eventos.first?.alturas == ["Do5"])
        // Sīkāh empieza y acaba en Mi𝄳: las dos tónicas se apartan.
        let sikah = Escala(.mi, .sikah).voz()
        #expect(sikah.eventos.first?.notas[0].desvio == -50 && sikah.eventos.last?.notas[0].desvio == -50)
        #expect(sikah.partitura().musicXML().contains("<alter>-0.5</alter>"))
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
        let musicXML = bayati.partitura().musicXML()
        #expect(musicXML.contains("<alter>-0.5</alter>"))
        #expect(musicXML.contains("<accidental>quarter-flat</accidental>"))
        #expect(bayati.partitura().mei().contains("accid=\"1qf\""))
        #expect(bayati.partitura().lilyPond().contains("eeh'"))
        #expect(bayati.partitura().abc().contains("_/E"))
        // Las comas: el `alter` exacto y el glifo SMuFL en MusicXML; los signos de Arel-Ezgi-Uzdilek en MEI.
        let rast = Escala(.sol, .rastMakami).voz(sentido: .ascendente)
        #expect(rast.partitura().musicXML().contains("<alter>-0.1509</alter>"))
        #expect(rast.partitura().musicXML().contains("<accidental smufl=\"accidentalKomaFlat\">other</accidental>"))
        #expect(rast.partitura().mei().contains("accid=\"kf\"") && rast.partitura().mei().contains("accid=\"bs\""))
        // Los moria de un echos: el `alter` exacto y el signo de Wyschnegradsky.
        let protos = Escala(.re, .echosProtos).voz(sentido: .ascendente).partitura().musicXML()
        #expect(protos.contains("<alter>-0.3333</alter>"))
        #expect(protos.contains("smufl=\"accidentalWyschnegradsky2TwelfthsFlat\""))
        // LilyPond no tiene nombres para las comas: la nota temperada.
        #expect(rast.partitura().lilyPond().contains("fis'"))
        // Sin microtonos, como antes.
        let mayor = Escala(.do, .mayor).voz()
        #expect(!mayor.partitura().musicXML().contains("<accidental"))
    }

    @Test func midiConInflexiones() {
        func contiene(_ bytes: [UInt8], _ trozo: [UInt8]) -> Bool {
            bytes.indices.dropLast(trozo.count - 1).contains { bytes[$0..<($0 + trozo.count)].elementsEqual(trozo) }
        }
        let bytes = [UInt8](Escala(.re, .bayati).voz().partitura().midi())
        func tiene(_ trozo: [UInt8]) -> Bool { contiene(bytes, trozo) }
        // El ámbito de la inflexión (RPN 0 = 2 semitonos), +50 cents antes del Mi𝄳 y la vuelta a 0 en el Fa.
        #expect(tiene([0xB0, 101, 0]) && tiene([0xB0, 6, 2]))
        #expect(tiene([0xE0, 0x00, 0x50]))
        #expect(tiene([0xE0, 0x00, 0x40]))
        // Sin microtonos, ni inflexiones ni RPN.
        let mayor = [UInt8](Escala(.do, .mayor).voz().partitura().midi())
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
        let pieza = try PiezaImportada(midi: voz.partitura().midi())
        #expect(Set(pieza.notas.map(\.parte)) == [0])
        #expect(pieza.notas.map(\.altura.midi) == [60, 64, 67, 62])
        let desvios = pieza.notas.map(\.desvio)
        for (leido, esperado) in zip(desvios, [0, -14, 2, -50] as [Double]) { #expect(abs(leido - esperado) < 0.05) }
        // Las cuatro voces de un coral siguen siendo cuatro partes.
        let coral = try Coral(leyendo: "Do3 Sol3 Mi4 Do5 | Sol2 Sol3 Re4 Si4")
        #expect(Set(try PiezaImportada(midi: coral.partitura().midi()).notas.map(\.parte)) == [0, 1, 2, 3])
    }

    // MARK: En una afinación

    /// Una afinación que lo sube todo lo mismo.
    private struct Subida: SistemaDeAfinacion {
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
        let pieza = try PiezaImportada(midi: voz.partitura().midi(afinacion: Subida(cents: 25)))
        #expect(pieza.notas.map(\.altura.midi) == [60, 64, 67])
        #expect(pieza.notas.allSatisfy { abs($0.desvio - 25) < 0.05 })
        // Sin afinación, como siempre.
        #expect(voz.partitura().midi(afinacion: nil) == voz.partitura().midi())
        let coral = try Coral(leyendo: "Do3 Sol3 Mi4 Do5")
        #expect(coral.partitura().midi(afinacion: Subida(cents: 10)) != coral.partitura().midi())
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
                (Double(evento.alturas[i].midi * 100) + evento.notas[i].desvio, evento.alturas[i].nota.natural)
            }
        }
    }

    private func sonidos(_ pieza: PiezaImportada) -> [(cents: Double, letra: NotaNatural)] {
        pieza.notas.sorted { ($0.inicio, $0.altura.midi) < ($1.inicio, $1.altura.midi) }.map {
            (Double($0.altura.midi * 100) + $0.desvio, $0.altura.nota.natural)
        }
    }

    @Test func elAlterConDecimalesEsUnMicrotono() throws {
        let xml = Escala(.mi, .sikah).voz().partitura().musicXML()
        let pieza = try PiezaImportada(musicXML: Data(xml.utf8))
        // Mi𝄳 (`<alter>-0.5</alter>` sobre E) se lee como Mi♭ y 50 cents: suena igual y conserva la letra.
        #expect(pieza.notas[0].altura == "Mi♭4" && pieza.notas[0].desvio == 50)
        #expect(pieza.notas[1].altura == "Fa4" && pieza.notas[1].desvio == 0)
        let fa = try PiezaImportada(
            musicXML: Data(Voz(leyendo: "Fa4(50¢):4 Re4(-22.64¢):4").partitura().musicXML().utf8))
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
                ? try PiezaImportada(musicXML: Data(voz.partitura().musicXML().utf8))
                : try PiezaImportada(midi: voz.partitura().midi())
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
        let temperada = try PiezaImportada(midi: Voz(leyendo: "Do4:4 Mi4:4").partitura().midi())
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

    // MARK: El sistema de cada nota

    @Test func elSistemaDeUnaNota() throws {
        // El Mi koron de un dastgāh: los mismos cents que el Mi𝄳 de un maqam, con otro signo.
        let koron: Evento = "Mi♭4(50¢,persa,1):4"
        #expect(koron.notas == [Evento.NotaDelEvento("Mi♭4", desvio: 50, sistema: .persa, ajuste: 1)])
        #expect(koron.texto == "Mi♭4(50¢,persa,1):4" && koron.texto(en: .inglesASCII) == "Eb4(50c,persa,1):4")
        #expect(koron.notas[0].signo() == .koron && Evento.NotaDelEvento("Mi♭4", desvio: 50).signo() == .cuartos(-1))
        #expect(koron != "Mi♭4(50¢):4")
        #expect(koron.transponer("2M").notas[0] == Evento.NotaDelEvento("Fa4", desvio: 50, sistema: .persa, ajuste: 1))
        // Una nota que no se aparta no tiene sistema; un sistema que no existe, o sin sus pasos, no se lee.
        #expect(Evento.NotaDelEvento("Mi4", desvio: 0, sistema: .persa, ajuste: 1) == Evento.NotaDelEvento("Mi4"))
        #expect(throws: (any Error).self) { try Evento(leyendo: "Mi♭4(50¢,vaziri,1):4") }
        #expect(throws: (any Error).self) { try Evento(leyendo: "Mi♭4(50¢,persa):4") }
        // Las notas de una escala saben su sistema, y se guardan con él.
        let sur = Escala(.re, .sur).voz()
        #expect(sur.eventos[1].notas == [Evento.NotaDelEvento("Mi♭4", desvio: 50, sistema: .persa, ajuste: 1)])
        #expect(Escala(.do, .bilaval).voz().eventos[2].notas[0].sistema == .sruti)
        #expect(try JSONDecoder().decode(Voz.self, from: JSONEncoder().encode(sur)) == sur)
        #expect(try Evento(leyendo: sur.eventos[1].texto) == sur.eventos[1])
    }

    @Test func losFormatosEscribenElSignoDeSuSistema() {
        // El koron, en MusicXML y en MEI; en LilyPond y en ABC, como el medio bemol.
        let sur = Escala(.re, .sur).voz().partitura()
        #expect(sur.musicXML().contains("<accidental>koron</accidental>"))
        #expect(!sur.musicXML().contains("quarter-flat"))
        #expect(sur.mei().contains("accid=\"koron\""))
        #expect(sur.lilyPond().contains("eeh'") && sur.abc().contains("_/E"))
        // La flecha de un śruti, en MusicXML; MEI no la tiene y escribe la koma que dan los cents.
        let bilaval = Escala(.do, .bilaval).voz().partitura()
        #expect(bilaval.musicXML().contains("smufl=\"accidentalNaturalOneArrowDown\""))
        #expect(bilaval.mei().contains("accid=\"kf\""))
        // Una nota escrita a mano, sin sistema, con el signo de sus cents.
        let maqam = Voz([Evento("Mi♭4", .negra, desvio: 50)]).partitura()
        #expect(maqam.musicXML().contains("<accidental>quarter-flat</accidental>"))
    }

    @Test func laEscalaTocadaLlevaSusMicrotonos() {
        // En el mástil, el Mi♭ de Šur es el Mi koron: la partitura lo lleva, y el dibujo es el de la partitura.
        let sur = Escala(.re, .sur)
        let alturas: [Altura] = ["Re4", "Re♯4", "Fa4"]
        let partitura = sur.partitura(tocadaEn: alturas)
        let eventos = partitura.pentagramas[0].voces[0].voz.eventos
        #expect(eventos[1].notas == [Evento.NotaDelEvento("Mi♭4", desvio: 50, sistema: .persa, ajuste: 1)])
        #expect(eventos[0].notas == [Evento.NotaDelEvento("Re4")] && !eventos[2].esMicrotonal)
        #expect(partitura.musicXML().contains("<accidental>koron</accidental>"))
        let svg = sur.svgPentagrama(tocadaEn: alturas)
        #expect(svg == partitura.svg() && svg.contains(GlifosSMuFL.koron.trazado))
        // Con ritmo, también.
        let conRitmo = sur.svgPentagrama(tocadaEn: alturas, ritmo: .uniforme(.corchea))
        #expect(conRitmo == sur.partitura(tocadaEn: alturas, ritmo: .uniforme(.corchea)).svg())
        #expect(conRitmo.contains(GlifosSMuFL.koron.trazado))
        // Una partitura sin ritmo dibuja los microtonos de sus notas, también los escritos a mano.
        let aMano = Partitura(
            pentagramas: [.init(voces: [.init(Voz([Evento("Mi♭4", .redonda, desvio: 50)]))])], dibujaElRitmo: false)
        #expect(aMano.svg().contains(GlifosSMuFL.medioBemol.trazado))
    }

    // MARK: La importación, con el sistema

    @Test func laImportacionLeeElSistemaDeSuSigno() throws {
        // El Mi koron de Šur vuelve de MusicXML y de MEI como koron, no como medio bemol.
        let sur = Escala(.re, .sur).voz().partitura()
        let koron = Evento.NotaDelEvento("Mi♭4", desvio: 50, sistema: .persa, ajuste: 1)
        for pieza in [
            try PiezaImportada(musicXML: Data(sur.musicXML().utf8)), try PiezaImportada(mei: Data(sur.mei().utf8)),
        ] {
            let mi = try #require(pieza.notas.sorted { $0.inicio < $1.inicio }.dropFirst().first)
            #expect(mi.sistema == .persa && mi.ajuste == 1 && mi.nota == koron && mi.nota.signo() == .koron)
        }
        // Un medio bemol no dice sistema: sus cents bastan.
        let maqam = Voz([Evento("Mi♭4", .negra, desvio: 50)]).partitura()
        let medio = try PiezaImportada(musicXML: Data(maqam.musicXML().utf8)).notas[0]
        #expect(medio.sistema == nil && medio.desvio == 50 && medio.nota.signo() == .cuartos(-1))
        // Las comas de un makam, en MusicXML (el `smufl` de `other`) y en MEI («kf»).
        let rast = Escala(.sol, .rastMakami).voz(sentido: .ascendente).partitura()
        for pieza in [
            try PiezaImportada(musicXML: Data(rast.musicXML().utf8)), try PiezaImportada(mei: Data(rast.mei().utf8)),
        ] {
            #expect(pieza.notas.contains { $0.sistema == .comas53 })
        }
        // Los moria de un echos y las flechas de un śruti, con el signo con que se escribieron.
        let tipos = TipoDeEscala.tradicionales.filter {
            [.persa, .moria72, .sruti].contains($0.microtonal?.sistema)
        }
        #expect(!tipos.isEmpty)
        for tipo in tipos {
            let voz = Escala(.re, tipo).voz()
            let pieza = try PiezaImportada(musicXML: Data(voz.partitura().musicXML().utf8))
            let leidas = pieza.notas.sorted { $0.inicio < $1.inicio }
            let originales = voz.eventos.flatMap(\.notas)
            #expect(leidas.count == originales.count, Comment(rawValue: tipo.nombre))
            for (leida, original) in zip(leidas, originales) {
                guard let signo = original.signo() else { continue }
                // Los cuartos de tono vuelven sin sistema (el de sus cents); los demás signos, con el suyo.
                if case .cuartos = signo {
                    #expect(leida.sistema == nil, Comment(rawValue: tipo.nombre))
                } else {
                    #expect(leida.sistema == original.sistema, Comment(rawValue: tipo.nombre))
                }
                #expect(leida.nota.signo() == signo, Comment(rawValue: tipo.nombre))
            }
        }
    }

    @Test func losSignosDeVuelta() {
        for signo in SignoMicrotonal.todos {
            #expect(SignoMicrotonal(smufl: signo.smufl) == signo)
            #expect(SignoMicrotonal(musicXML: signo.musicXML.valor, smufl: signo.musicXML.smufl) == signo)
            if let mei = signo.mei { #expect(SignoMicrotonal(mei: mei) == signo) }
        }
        #expect(SignoMicrotonal(smufl: "accidentalSharp") == nil)
        #expect(SignoMicrotonal(musicXML: "sharp", smufl: nil) == nil)
        #expect(SignoMicrotonal(musicXML: "other", smufl: nil) == nil && SignoMicrotonal(mei: "s") == nil)
        // El koron dice el sistema persa; la flecha, el de los śruti; un cuarto de tono, ninguno.
        let koron = SignoMicrotonal.koron.sistemaYAjuste(altura: "Mi♭4", desvio: 50)
        #expect(koron?.sistema == .persa && koron?.ajuste == 1)
        let flecha = SignoMicrotonal.flecha(semitonos: 0, comas: -1).sistemaYAjuste(altura: "Mi4", desvio: -14)
        #expect(flecha?.sistema == .sruti && flecha?.ajuste == -1)
        #expect(SignoMicrotonal.cuartos(-1).sistemaYAjuste(altura: "Mi♭4", desvio: 50) == nil)
        // Una koma bajo el Si pitagórico (a +9,8 cents del temperado): una koma bajo, en las de 53.
        let koma = SignoMicrotonal.comas(-1).sistemaYAjuste(altura: "Si3", desvio: -12.8)
        #expect(koma?.sistema == .comas53 && koma?.ajuste == -1)
    }
}
