import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria
@testable import ArmoniaTrastes

@Suite struct MastilYPartituraTests {
    let guitarra = Mastil(.guitarra)

    @Test func laTablaturaCuentaLasCuerdasDesdeArriba() {
        let doDe5 = PosicionEnElMastil(cuerda: 1, traste: 3)
        let tablatura = Tablatura(guitarra, posiciones: [0: [doDe5]])
        #expect(tablatura.cuerdas == 6)
        #expect(tablatura.notas[0] == [Tablatura.Pulsacion(cuerda: 4, traste: 3)])
    }

    @Test func unaDigitacionConSuCifradoYSuTablatura() throws {
        let digitacion = try Digitacion(leyendo: "x32010", en: guitarra)
        let partitura = digitacion.partitura(de: Acorde("Do"))
        #expect(partitura.pentagramas.count == 1)
        let pentagrama = partitura.pentagramas[0]
        #expect(pentagrama.cuerdas == 6)
        let linea = pentagrama.voces[0]
        #expect(linea.cifrados == [.cero: Acorde("Do")])
        #expect(linea.voz.eventos.count == 1 && linea.voz.eventos[0].duracion == .redonda)
        #expect(linea.voz.eventos[0].alturas == digitacion.alturas)
        // El Do3 de la 5.ª cuerda, en la línea 4 desde arriba.
        #expect(linea.pulsaciones[.cero]?.first == Tablatura.Pulsacion(cuerda: 4, traste: 3))
        #expect(linea.pulsaciones[.cero]?.count == 5)
        #expect(partitura.encabezado.tema == .progresion([Acorde("Do")]))
    }

    @Test func variasDigitacionesUnaDetrasDeOtra() throws {
        let digitaciones = [
            try Digitacion(leyendo: "x32010", en: guitarra), try Digitacion(leyendo: "320003", en: guitarra),
        ]
        let partitura = Digitacion.partitura(digitaciones, acordes: [Acorde("Do"), Acorde("Sol")], titulo: "I–V")
        let linea = partitura.pentagramas[0].voces[0]
        #expect(linea.voz.eventos.count == 2 && linea.pulsaciones.count == 2)
        #expect(linea.cifrados.count == 2 && partitura.encabezado.titulo == "I–V")
        // Sin acordes, sin cifrados.
        #expect(Digitacion.partitura(digitaciones).pentagramas[0].voces[0].cifrados.isEmpty)
    }

    @Test func lasNotasSeEscribenComoEnElAcorde() throws {
        // Fa7 en el primer traste: el Mi♭ suena en la 4.ª cuerda, traste 1, y no se escribe Re♯.
        let digitacion = try Digitacion(leyendo: "131211", en: guitarra)
        let alturas = digitacion.partitura(de: Acorde("Fa7")).pentagramas[0].voces[0].voz.eventos[0].alturas
        #expect(alturas.map(\.midi) == digitacion.alturas.map(\.midi))
        #expect(alturas.contains { $0.nota == Nota(.mi, -1) })
        #expect(!alturas.contains { $0.nota == Nota(.re, 1) })
    }

    @Test func unaPosicionDeLaEscalaConRitmo() throws {
        let escala = Escala(.do, .mayor)
        let posicion = try #require(guitarra.posicionesCAGED(de: escala).first)
        let partitura = posicion.partitura(de: escala, figura: .corchea)
        #expect(partitura.ritmo && partitura.encabezado.tema == .escala(escala))
        let linea = partitura.pentagramas[0].voces[0]
        #expect(partitura.pentagramas[0].cuerdas == 6)
        #expect(linea.voz.eventos.count == posicion.posiciones.count)
        #expect(linea.pulsaciones.count == posicion.posiciones.count)
        #expect(!posicion.partitura(de: escala).ritmo)
    }

    @Test func unArpegioConSusDedos() throws {
        let acorde = Acorde("Do")
        let arpegio = try #require(guitarra.arpegiosCAGED(de: acorde).first)
        let partitura = arpegio.partitura(de: acorde, figura: .corchea)
        #expect(partitura.ritmo && partitura.encabezado.tema == .acorde(acorde))
        let linea = partitura.pentagramas[0].voces[0]
        #expect(linea.pulsaciones.count == arpegio.posiciones.count)
        #expect(linea.digitos.count == arpegio.dedos.filter { $0 > 0 }.count)
    }
}
