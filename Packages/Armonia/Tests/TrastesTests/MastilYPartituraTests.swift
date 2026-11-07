import Testing

@testable import Elementos
@testable import PartituraArmonia
@testable import Teoria
@testable import Trastes

@Suite struct MastilYPartituraTests {
    let guitarra = Mastil(.guitarra)

    @Test func laTablaturaCuentaLasCuerdasComoElMastil() {
        let doDe5 = PosicionEnElMastil(cuerda: 1, traste: 3)
        let tablatura = Tablatura(guitarra, posiciones: [0: [doDe5]])
        #expect(tablatura.numeroDeCuerdas == 6)
        #expect(tablatura.pulsaciones[0] == [Tablatura.Pulsacion(cuerda: 1, traste: 3)])
    }

    @Test func lasPosicionesRecuerdanSuEscalaYSuAcorde() throws {
        let escala = Escala(.do, .mayor)
        #expect(guitarra.posicionesCAGED(de: escala).allSatisfy { $0.escala == escala })
        #expect(guitarra.posicionesPorCuerda(de: escala).allSatisfy { $0.escala == escala })
        let acorde = Acorde("Lam")
        #expect(guitarra.arpegios(de: acorde).allSatisfy { $0.acorde == acorde })
        #expect(guitarra.arpegiosCAGED(de: acorde).allSatisfy { $0.acorde == acorde })
        #expect(guitarra.arpegiosDeUnaNotaPorCuerda(de: acorde).allSatisfy { $0.acorde == acorde })
        let formas = guitarra.digitaciones(de: Acorde("Do"))
        #expect(!formas.isEmpty && formas.allSatisfy { $0.acorde == Acorde("Do") })
        let drop2 = guitarra.disposiciones(de: Acorde("Do7M"), .drop2, cuerdas: [1, 2, 3, 4])
        #expect(!drop2.isEmpty && drop2.allSatisfy { $0.acorde == Acorde("Do7M") })
        // Una digitación es la misma aunque una sepa de qué acorde es y la otra no.
        let leida = try Digitacion(leyendo: "x32010", en: guitarra)
        #expect(leida.acorde == nil && formas.contains(leida))
    }

    @Test func unaDigitacionConSuCifradoYSuTablatura() throws {
        let digitacion = try #require(guitarra.digitaciones(de: Acorde("Do")).first)
        #expect(digitacion.tablatura == "x32010")
        let partitura = digitacion.partitura()
        #expect(partitura.pentagramas.count == 1)
        let pentagrama = partitura.pentagramas[0]
        #expect(pentagrama.numeroDeCuerdas == 6)
        let linea = pentagrama.voces[0]
        #expect(linea.cifrados == [.cero: Acorde("Do")])
        #expect(linea.voz.eventos.count == 1 && linea.voz.eventos[0].duracion == .redonda)
        #expect(linea.voz.eventos[0].alturas == digitacion.alturas)
        // El Do3 de la 5.ª cuerda: la 1 desde la grave.
        #expect(linea.pulsaciones[.cero]?.first == Tablatura.Pulsacion(cuerda: 1, traste: 3))
        #expect(linea.pulsaciones[.cero]?.count == 5)
        #expect(partitura.encabezado.tema == .progresion([Acorde("Do")]))
        // La leída no sabe de qué acorde es: sin cifrado, salvo que se le dé.
        let leida = try Digitacion(leyendo: "x32010", en: guitarra)
        #expect(leida.partitura().pentagramas[0].voces[0].cifrados.isEmpty)
        #expect(leida.partitura(de: Acorde("Do")) == partitura)
    }

    @Test func laGuitarraSeEscribeEnClaveDeSolOctavaBaja() throws {
        // Las notas son las que suenan; la clave las sube una octava al escribirlas.
        let digitacion = try Digitacion(leyendo: "x32010", en: guitarra)
        let pentagrama = digitacion.partitura().pentagramas[0]
        #expect(pentagrama.afinacion == Encordado.guitarra.afinacion && pentagrama.capo == nil)
        #expect(pentagrama.claveDelInstrumento == .solOctavaBaja && pentagrama.claveEscrita == .solOctavaBaja)
        #expect(pentagrama.voces[0].voz.eventos[0].alturas.first == Altura(.do, octava: 3))
        // Con capo, la afinación es la de las cuerdas al aire, sin él.
        let conCapo = Mastil(Encordado.guitarra.conCapo(2))
        let tablatura = Tablatura(conCapo, posiciones: [0: [PosicionEnElMastil(cuerda: 0, traste: 0)]])
        #expect(tablatura.afinacion == Encordado.guitarra.afinacion && tablatura.capo == 2)
        // El bajo (Mi1) no: la que mejor va a sus notas.
        let bajo = Tablatura(Mastil(.bajoElectrico), posiciones: [0: [PosicionEnElMastil(cuerda: 0, traste: 0)]])
        let mi = Partitura.Linea(Voz([Evento(alturas: ["Mi1"], duracion: .redonda)]))
        let enElBajo = Partitura.Pentagrama(voces: [mi], tablatura: bajo)
        #expect(enElBajo.claveDelInstrumento == nil && enElBajo.claveEscrita != .solOctavaBaja)
        // Una clave dada manda.
        #expect(Partitura.Pentagrama(clave: .sol, voces: pentagrama.voces, tablatura: tablatura).claveEscrita == .sol)
    }

    @Test func variasDigitacionesUnaDetrasDeOtra() throws {
        let digitaciones = [
            try Digitacion(leyendo: "x32010", en: guitarra), try Digitacion(leyendo: "320003", en: guitarra),
        ]
        let partitura = Digitacion.partitura(digitaciones, acordes: [Acorde("Do"), Acorde("Sol")], titulo: "I–V")
        let linea = partitura.pentagramas[0].voces[0]
        #expect(linea.voz.eventos.count == 2 && linea.pulsaciones.count == 2)
        #expect(linea.cifrados.count == 2 && partitura.encabezado.titulo == "I–V")
        // Sin acordes, sin cifrados; con los suyos, los de cada una.
        #expect(Digitacion.partitura(digitaciones).pentagramas[0].voces[0].cifrados.isEmpty)
        let suyas = [Acorde("Do"), Acorde("Sol")].compactMap { guitarra.digitaciones(de: $0).first }
        #expect(Digitacion.partitura(suyas).pentagramas[0].voces[0].cifrados.count == 2)
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
        let partitura = posicion.partitura(ritmo: .uniforme(.corchea))
        #expect(partitura.dibujaElRitmo && partitura.encabezado.tema == .escala(escala))
        let linea = partitura.pentagramas[0].voces[0]
        #expect(partitura.pentagramas[0].numeroDeCuerdas == 6)
        #expect(linea.voz.eventos.count == posicion.posiciones.count)
        #expect(linea.pulsaciones.count == posicion.posiciones.count)
        #expect(!posicion.partitura().dibujaElRitmo)
        #expect(posicion.partitura(de: escala) == posicion.partitura())
        // Sin escala, las notas como las da el mástil, con su tablatura.
        let suelta = EscalaEnElMastil(
            mastil: guitarra, rangoDeTrastes: posicion.rangoDeTrastes, posiciones: posicion.posiciones)
        let sinEscala = suelta.partitura(ritmo: .uniforme(.corchea))
        #expect(sinEscala.dibujaElRitmo && sinEscala.encabezado.tema == nil)
        #expect(sinEscala.pentagramas[0].voces[0].voz.eventos.map(\.alturas) == posicion.alturas.map { [$0] })
        #expect(sinEscala.pentagramas[0].voces[0].pulsaciones.count == posicion.posiciones.count)
    }

    @Test func unArpegioConSusDedos() throws {
        let acorde = Acorde("Do")
        let arpegio = try #require(guitarra.arpegiosCAGED(de: acorde).first)
        let partitura = arpegio.partitura(ritmo: .uniforme(.corchea))
        #expect(partitura.dibujaElRitmo && partitura.encabezado.tema == .acorde(acorde))
        let linea = partitura.pentagramas[0].voces[0]
        #expect(linea.pulsaciones.count == arpegio.posiciones.count)
        #expect(linea.dedos.count == arpegio.dedos.filter { $0 > 0 }.count)
        let suelto = ArpegioEnElMastil(
            mastil: guitarra, rangoDeTrastes: arpegio.rangoDeTrastes, posiciones: arpegio.posiciones)
        #expect(suelto.partitura().pentagramas[0].voces[0].cifrados.isEmpty)
        #expect(suelto.partitura(de: acorde) == arpegio.partitura())
    }
}
