import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

// Lo que atraviesa todo el motor: literales, Codable, convenciones de nombres y nombres
// anteriores. Lo de cada área está en su archivo (FundamentosTests, AcordesTests…).

@Suite struct ComodidadesTests {
    @Test func literales() {
        let nota: Nota = "Fa#"
        let alta: Altura = "Sib3"
        let intervalo: Intervalo = "3M"
        let acorde: Acorde = "Sol7/Si"
        let tipo: TipoDeAcorde = "m7(b5)"
        let escala: Escala = "Re dórico"
        #expect(nota == Nota(.fa, 1))
        #expect(alta.midi == 58)
        #expect(intervalo == .terceraMayor)
        #expect(acorde.bajo == .si)
        #expect(tipo == .semidisminuido)
        #expect(escala.tipo == .dorico)
        #expect((Nota.re + "3M") == "Fa#")
        #expect(Acorde(.do, "7(b9)").cifrado == "Do7(♭9)")
    }

    @Test func codable() throws {
        let codificador = JSONEncoder()
        let decodificador = JSONDecoder()

        let acordes: [Acorde] = ["Sol7(b9)/Si", "Fa#m7b5", "Do/Re", "Mib6/9"]
        let datosAcordes = try codificador.encode(acordes)
        #expect(try (decodificador.decode([Acorde].self, from: datosAcordes)) == acordes)
        #expect(String(decoding: datosAcordes, as: UTF8.self).contains("Fa♯m7(♭5)"))

        let notas: [Altura] = ["Do4", "Fa#3", "Sibb-1"]
        #expect(try (decodificador.decode([Altura].self, from: codificador.encode(notas))) == notas)

        let intervalos: [Intervalo] = ["3M", "-5d", "9m", "4AA"]
        #expect(try (decodificador.decode([Intervalo].self, from: codificador.encode(intervalos))) == intervalos)

        let escalas = [Escala("Re dórico"), Escala(.do, TipoDeEscala.pentatonicaMayor.rotacion(2))]
        #expect(try (decodificador.decode([Escala].self, from: codificador.encode(escalas))) == escalas)

        #expect(throws: (any Error).self) { try decodificador.decode([Acorde].self, from: Data("[\"Doxyz\"]".utf8)) }
    }
}

@Suite struct TerminologiaTests {
    @Test func convencionVerbal() {
        // Operaciones: infinitivo.
        #expect(Acorde("Do7").invertir(1).cifrado == "Do7/Mi")
        #expect(Acorde("Do").cambiarBajo(.re).cifrado == "Do/Re")
        #expect(TipoDeAcorde.dominanteSeptima.anadir(.novenaMenor)?.cifrado == "7(♭9)")
        #expect(TipoDeAcorde.dominanteNovena.quitar(.quintaJusta)?.cifrado == "9(omit5)")
        #expect(abs(TemperamentoRegular.igual.afinar(frecuenciaDelLa4: 415).frecuencia(de: "La4") - (415)) <= 1e-9)
        #expect(ConjuntoDeClases([0, 4]).unir(con: [7]) == [0, 4, 7])
        #expect(ConjuntoDeClases([0, 4, 7]).intersecar(con: [4, 5]) == [4])
        // Valores derivados con nombre propio: sustantivo o adjetivo.
        #expect(Intervalo.terceraMayor.inversion == .sextaMenor)
        #expect(Nota("Dob").enarmonicaMasSimple == .si)
        #expect(Intervalo.novenaMayor.simple == .segundaMayor)
    }

    @Test func terminosMusicales() {
        // «Menor es mejor» se llama coste.
        let costes = Acorde.candidatos([.mi, .sol, .do]).map(\.coste)
        #expect(costes == costes.sorted())
        #expect(Acorde.candidatos([.do, .mi, .sol]).first?.coste == 0)
        // Número de Forte, aunque el valor sea texto.
        #expect(Acorde("Do°7").numeroDeForte == "4-28")
        #expect(ConjuntoDeClases([0, 1, 4, 6]).numeroDeForte == "4-Z15")
        // Temperamentos iguales con cualquier número de divisiones; 12 es `.igual`.
        #expect(abs(TemperamentoRegular.igual(divisiones: 12).quinta - (TemperamentoRegular.igual.quinta)) <= 1e-9)
        #expect(
            abs(TemperamentoRegular.igual(divisiones: 19, frecuenciaDelLa4: 415).frecuencia(de: "La4") - (415)) <= 1e-9)
        // Posición cerrada.
        #expect(Acorde("Sol7/Si").posicionCerrada(octava: 3).map(\.description) == ["Si3", "Re4", "Fa4", "Sol4"])
        // Escalas que contienen unas notas.
        #expect(Escala.identificar([.do, .mi, .sol, .si, "Fa#"]).contains(Escala(.sol)))
        // Lugar en el pentagrama.
        #expect(Clave.doEnTercera.posicion(de: "Do4").lugar == 4)
        #expect(PosicionEnPentagrama(lugar: 9).descripcion == "encima de la 5.ª línea")
    }

    @Test func candidatoGenerico() {
        // Acordes y tonalidades comparten el mismo tipo de lectura, ordenada por coste.
        let acordes = Acorde.candidatos([.do, .mi, "Sib"])
        #expect(acordes.first?.valor == Acorde("Do7"))
        #expect(acordes.first?.coste == 1)
        #expect(acordes.first?.omitidas == [.sol])
        #expect(acordes.map(\.coste) == acordes.map(\.coste).sorted())

        let tonalidades = Tonalidad.candidatos(midi: [60, 62, 64, 65, 67, 69, 71, 72])
        #expect(tonalidades.first?.valor == Tonalidad(.do))
        #expect(tonalidades.map(\.coste) == tonalidades.map(\.coste).sorted())
        #expect(tonalidades.map(\.correlacion) == tonalidades.map(\.correlacion).sorted(by: >))
        if let mejor = tonalidades.first {
            #expect(abs(mejor.correlacion + mejor.coste - (1)) <= 1e-12)
        }
    }

    @Test func nombresDeTipos() {
        let tipo: TipoDeAcorde = "m7"
        let escala: TipoDeEscala = .dorico
        let nombre: Nota = "Fa#"
        let calidad: CalidadDeIntervalo = Intervalo.terceraMenor.calidad
        #expect(tipo.estructura.calidadDeTriada == .menor)
        #expect(tipo.estructura.componentes.map(\.papel).first == PapelEnAcorde.fundamental)
        #expect(escala.nombre == "dórico")
        #expect(nombre.nombre == "Fa♯")
        #expect(calidad == .menor)
        #expect(Acorde("Do7").cifrado(estilo: EstiloDeCifrado.inglesASCII) == "C7")
        // La rotación de una escala (sus modos) no se confunde con el modo de una tonalidad.
        #expect(Escala(.do).rotacion(2) == Escala(.re, .dorico))
        #expect(TipoDeEscala.mayor.rotacion(6) == .menorNatural)
        #expect(Tonalidad("La menor").modo == .menor)
        // Todos los tipos con nombre lo tienen también como texto.
        #expect(Altura("Fa#4").nombre == "Fa♯₄")
    }
}
