import Armonia
import Testing

@testable import ArmoniaPresentacion

// La pestaña de escalas para estudiarlas y las escalas sobre un acorde de la de acordes.
@Suite struct PresentacionDeEstudioDeEscalaTests {
    @Test func unaSecuencia() {
        let terceras = PresentacionDeEstudioDeEscala.secuencia(Escala(.do), .terceras, notacion: .espanolCompacto)
        #expect(terceras.titulo == "Do mayor por terceras")
        #expect(terceras.notas.hasPrefix("Do₄ Mi₄ Re₄ Fa₄"))
        #expect(terceras.sonido.notas.count == 15)
        #expect(terceras.ficheros.count == 5)
        #expect(terceras.pentagrama.svg.contains("<svg"))
        let bajando = PresentacionDeEstudioDeEscala.secuencia(
            Escala(.do), .triadas, octavas: 2, sentido: .descendente, notacion: .inglesASCII)
        #expect(bajando.titulo == "C major in triads")
        #expect(bajando.sonido.notas.count == 43)
    }

    @Test func laDigitacionDePiano() {
        let manos = PresentacionDeEstudioDeEscala.digitaciones(Escala(.do), notacion: .espanolCompacto)
        #expect(manos.map(\.mano) == ["Mano derecha", "Mano izquierda"])
        #expect(manos.map(\.dedos) == ["1 2 3 1 2 3 4 5", "5 4 3 2 1 3 2 1"])
        #expect(manos.first?.notas == "Do Re Mi Fa Sol La Si Do")
    }

    @Test func losModos() throws {
        let paralelos = PresentacionDeEstudioDeEscala.modosParalelos(de: Escala(.do), notacion: .espanolCompacto)
        #expect(paralelos.count == 7)
        let lidio = try #require(paralelos.first)
        #expect(lidio.nombre == "Do lidio")
        #expect(lidio.brillo == "+1")
        #expect(lidio.cambios == "4: Fa → Fa♯")
        #expect(paralelos[1].brillo == "0")
        #expect(paralelos[1].cambios.isEmpty)
        #expect(paralelos[3].brillo == "-2")
        let relativos = PresentacionDeEstudioDeEscala.modosRelativos(
            de: Escala(.do, .pentatonicaMayor), notacion: .espanolCompacto)
        #expect(relativos.count == 5)
        #expect(relativos.allSatisfy { $0.brillo.isEmpty && $0.cambios.isEmpty && !$0.sonido.notas.isEmpty })
    }

    @Test func dosEscalasComparadas() {
        let lidio = PresentacionDeEstudioDeEscala.comparar(
            Escala(.do), con: Escala(.do, .lidio), notacion: .espanolCompacto)
        #expect(lidio.cambios == ["4: Fa → Fa♯"])
        #expect(lidio.soloEnOrigen == "Solo en Do mayor: Fa")
        #expect(lidio.soloEnDestino == "Solo en Do lidio: Fa♯")
        #expect(lidio.distancia == "1 alteraciones de diferencia")
        #expect(lidio.comunes.hasPrefix("Do, Re, Mi"))
        #expect(lidio.sonido.notas.count == 16)
        let lejos = PresentacionDeEstudioDeEscala.comparar(
            Escala(.do), con: Escala("Fa# pentatónica mayor"), notacion: .espanolCompacto)
        #expect(lejos.comunes == "ninguna")
        #expect(lejos.distancia == nil)
        let igual = PresentacionDeEstudioDeEscala.comparar(Escala(.do), con: Escala(.do), notacion: .espanolCompacto)
        #expect(igual.soloEnOrigen.isEmpty && igual.soloEnDestino.isEmpty)
    }

    @Test func escalasSobreUnAcorde() throws {
        let bebop = PresentacionDeEstudioDeEscala.bebop(sobre: Acorde("Do7"), notacion: .espanolCompacto)
        let dominante = try #require(bebop.first)
        #expect(dominante.nombre == "Do bebop dominante")
        #expect(dominante.detalle == "nota de paso: Si · Do Si Si♭ La Sol Fa Mi Re")
        #expect(!dominante.sonido.notas.isEmpty)
        let pentatonicas = PresentacionDeEstudioDeEscala.pentatonicas(
            sobre: Acorde("Do7M"), notacion: .espanolCompacto)
        #expect(pentatonicas.first?.nombre == "Do pentatónica mayor")
        #expect(pentatonicas.first?.detalle == "9 · 13")
    }

    @Test func cambiosDeEscalaEnUnAnalisis() throws {
        let notacion = Notacion.espanolCompacto
        let iiVI = try PresentacionDeAnalisis.analizar("Rem7 Sol7 Do7M", en: Tonalidad(.do), notacion: notacion)
        let guias = ["notas guía: Fa, Do", "notas guía: Si, Fa", "notas guía: Mi, Si"]
        #expect(iiVI.cambiosDeEscala(en: notacion) == guias)
        let secundaria = try PresentacionDeAnalisis.analizar("Do La7 Rem7", en: Tonalidad(.do), notacion: notacion)
        let cambios = secundaria.cambiosDeEscala(en: notacion)
        #expect(cambios[1] == "cambian: Si♭, Do♯ · notas guía: Do♯, Sol")
    }
}
