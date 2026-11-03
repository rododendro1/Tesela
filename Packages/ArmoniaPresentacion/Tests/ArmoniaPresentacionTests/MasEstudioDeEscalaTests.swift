import Armonia
import Testing

@testable import ArmoniaPresentacion

// Buscar escalas por sus notas, la simetría, las líneas de notas guía, el mástil y el teclado de piano.
@Suite struct MasEstudioDeEscalaTests {
    let notacion = Notacion.espanolCompacto

    @Test func buscarEscalasPorSusNotas() throws {
        let notas: [Nota] = [.do, .mi, .sol, .si, try Nota(leyendo: "Fa#")]
        let escalas = PresentacionDeEstudioDeEscala.escalas(conLasNotas: notas, notacion: notacion)
        #expect(escalas.count == 10)
        let primera = try #require(escalas.first)
        #expect(primera.nombre == "Do pentatónica lidia")
        #expect(primera.ademas == "")
        #expect(escalas.contains { $0.ademas == "además: Re, La" })
        let dos = PresentacionDeEstudioDeEscala.escalas(conLasNotas: notas, limite: 2, notacion: .inglesASCII)
        #expect(dos.count == 2)
        // Sin ortografía, de un mástil: Fa♯ en el teclado, 78 en MIDI.
        let deClases = PresentacionDeEstudioDeEscala.escalas(conLasClases: [60, 64, 67, 71, 78], notacion: notacion)
        #expect(deClases.first?.nombre == "Do pentatónica lidia")
        // De una pieza: Re Mi Fa Sol La Si Do Re, en Re menor.
        let notasDeLaPieza = [62, 64, 65, 67, 69, 71, 72, 74].enumerated().map { i, midi in
            NotaDeLaPieza(altura: Altura(midi: midi), inicio: .negra * i, duracion: .negra)
        }
        let pieza = PiezaImportada(tonalidad: Tonalidad(.re, .menor), notas: notasDeLaPieza)
        let deLaPieza = PresentacionDeEstudioDeEscala.escalas(de: pieza, notacion: notacion)
        #expect(deLaPieza.first?.nombre == "Re dórico")
        #expect(deLaPieza.first?.sonido.notas.isEmpty == false)
    }

    @Test func simetria() throws {
        let tonosEnteros = try #require(
            PresentacionDeEstudioDeEscala.simetria(de: Escala(.do, .tonosEnteros), notacion: notacion))
        #expect(tonosEnteros.resumen == "Se repite cada 2 semitonos: 2 transposiciones distintas")
        #expect(tonosEnteros.tonicas.hasPrefix("Do, Re, Mi"))
        #expect(tonosEnteros.ciclos.count == 2)
        let disminuida = try #require(
            PresentacionDeEstudioDeEscala.simetria(de: Escala(.do, .disminuidaSemitonoTono), notacion: notacion))
        #expect(disminuida.tonicas == "Do, Mi♭, Fa♯, La")
        #expect(disminuida.ciclos.contains { $0.detalle == "Do7 · Mi♭7 · Fa♯7 · La7" })
        #expect(PresentacionDeEstudioDeEscala.simetria(de: Escala(.do), notacion: notacion) == nil)
        #expect(PresentacionDeEstudioDeEscala.simetria(de: Escala(.do, .cromatica), notacion: notacion) == nil)
    }

    @Test func lineasDeNotasGuia() {
        let acordes = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
        let lineas = PresentacionDeEstudioDeEscala.lineasDeNotasGuia(
            acordes, tonalidad: Tonalidad(.do), notacion: notacion)
        #expect(lineas.map(\.titulo) == ["Desde la tercera", "Desde la séptima"])
        #expect(lineas.map(\.notas) == ["Fa₄ Fa₄ Mi₄", "Do₄ Si₃ Si₃"])
        #expect(lineas[0].ficheros.count == 5)
        #expect(lineas[0].sonido.notas.count == 3)
        let sinTonalidad = PresentacionDeEstudioDeEscala.lineasDeNotasGuia(acordes, notacion: .inglesASCII)
        #expect(sinTonalidad.map(\.titulo) == ["From the third", "From the seventh"])
        #expect(PresentacionDeEstudioDeEscala.lineasDeNotasGuia([], notacion: notacion).isEmpty)
    }

    @Test func formasDeLaPentatonica() {
        let formas = PresentacionDeEstudioDeEscala.formasPentatonicas(
            de: Escala(.la, .pentatonicaMenor), notacion: notacion)
        #expect(formas.count == 5)
        #expect(formas[0].titulo == "Forma 1 · Trastes 5–8")
        #expect(formas[0].comunes == "comparte con la forma 2: 6:8 5:7 4:7 3:7 2:8 1:8")
        #expect(formas[4].comunes.hasPrefix("comparte con la forma 1: "))
        #expect(formas[0].tablatura.count == 6)
        #expect(formas[0].tablatura.last == "Mi |--5--8-------------------------------")
        #expect(formas[0].fichero.nombre.hasPrefix("Forma 1"))
        #expect(formas[0].sonido.notas.count == 12)
        #expect(PresentacionDeEstudioDeEscala.formasPentatonicas(de: Escala(.do), notacion: notacion).isEmpty)
    }

    @Test func secuenciaEnLasPosiciones() {
        let caged = PresentacionDeEstudioDeEscala.secuenciaEnLasPosiciones(
            Escala(.do), .terceras, caged: true, notacion: notacion)
        #expect(caged.count == 5)
        #expect(caged[0].titulo == "Forma C · Trastes 0–4")
        #expect(caged[0].comunes.isEmpty)
        #expect(caged[0].notas.count == caged[0].sonido.notas.count)
        let porCuerda = PresentacionDeEstudioDeEscala.secuenciaEnLasPosiciones(
            Escala(.do), .gruposDeTres, caged: false, sentido: .descendente, notacion: .inglesASCII)
        #expect(porCuerda.count >= 6)
        #expect(porCuerda[0].titulo == "Frets 0–5")
        #expect(porCuerda[0].notas.count == 48)
    }

    @Test func tablatura() {
        let mastil = Mastil(.guitarra)
        let notas = [PosicionEnElMastil(cuerda: 2, traste: 0), PosicionEnElMastil(cuerda: 3, traste: 12)]
        let lineas = PresentacionDeEstudioDeEscala.tablatura(notas, en: mastil, notacion: notacion)
        #expect(lineas.count == 6)
        #expect(lineas[2] == "Sol|----12-")
        #expect(lineas[3] == "Re |--0----")
    }

    @Test func teclado() {
        let doMayor = PresentacionDeEstudioDeEscala.teclado(de: Escala(.do), notacion: notacion)
        #expect(doMayor.contains("<title>Do mayor</title>"))
        #expect(doMayor.contains(">Sol</text>"))
        #expect(doMayor.components(separatedBy: "<circle").count - 1 == 8)
        let dosOctavas = PresentacionDeEstudioDeEscala.teclado(de: Escala(.do), octavas: 2, notacion: notacion)
        #expect(dosOctavas.components(separatedBy: "<circle").count - 1 == 15)
        let derecha = PresentacionDeEstudioDeEscala.teclado(de: Escala(.re), mano: .derecha, notacion: notacion)
        #expect(derecha.contains("<title>Re mayor · Mano derecha</title>"))
        #expect(derecha.contains(">5</text>"))
        let izquierda = PresentacionDeEstudioDeEscala.teclado(
            de: Escala(.re), mano: .izquierda, octavas: 2, notacion: .inglesASCII)
        #expect(izquierda.contains("Left hand"))
    }
}
