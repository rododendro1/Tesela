import Armonia
import Testing

@testable import Exposicion

/// Lo que dicen las teorías de una escala, escrito: las filas, los nombres de Rothenberg, los grados y el JSON.
@Suite struct MedidasDeEscalaPresentadasTests {
    let notacion = Notacion.compacta(.espanol)

    @Test func propiedadesDeRothenberg() {
        #expect(PresentacionDeEstudioDeEscala.propiedad(.estrictamentePropia, en: notacion) == "estrictamente propia")
        #expect(PresentacionDeEstudioDeEscala.propiedad(.propia, en: notacion) == "propia")
        #expect(PresentacionDeEstudioDeEscala.propiedad(.impropia, en: notacion) == "impropia")
        #expect(PresentacionDeEstudioDeEscala.propiedad(.propia, en: .compacta(.ingles)) == "proper")
    }

    @Test func gradosEnNumerosRomanos() {
        #expect(PresentacionDeEstudioDeEscala.grados(["", "m", "°", "+", "?"]) == ["I", "ii", "iii°", "IV+", "V?"])
        #expect(
            PresentacionDeEstudioDeEscala.grados(["maj7", "m7", "ø7", "°7", "m(maj7)", "+maj7", "7"])
                == ["Imaj7", "ii7", "iiiø7", "iv°7", "v(maj7)", "VI+maj7", "VII7"])
        #expect(PresentacionDeEstudioDeEscala.grados(Array(repeating: "", count: 8)).last == "8")
    }

    @Test func combinatoriedad() throws {
        let tonosEnteros = try #require(Escala(.do, .tonosEnteros).estadisticas.combinatoriedad)
        #expect(PresentacionDeEstudioDeEscala.combinatoriedad(tonosEnteros).hasSuffix(" (F)"))
    }

    @Test func filasDeOtrasEscalas() {
        let disminuida = PresentacionDeEstudioDeEscala.estadisticas(de: Escala(.do, .disminuida), en: notacion)
        func valor(_ nombre: String) -> String? { disminuida.first { $0.nombre == nombre }?.valor }
        #expect(valor("Modo de transposición limitada (Messiaen)") == "2")
        #expect(valor("Tríadas por grados") == nil)
        #expect(valor("Propiedades")?.contains("equilibrada") == true)
        let cromatica = PresentacionDeEstudioDeEscala.estadisticas(de: Escala(.do, .cromatica), en: notacion)
        #expect(!cromatica.contains { $0.nombre == "Complemento (Forte)" })
    }

    @Test func json() {
        let mayor = MedidasDeEscalaPresentadas(Escala(.do, .mayor).estadisticas, en: notacion)
        #expect(mayor.propiedadDeMyhill)
        #expect(mayor.generador == 5)
        #expect(mayor.bienFormada)
        #expect(mayor.propiedadDeRothenberg == "propia")
        #expect(mayor.ambiguedades == 1)
        #expect(mayor.contradicciones == 0)
        #expect(mayor.profunda)
        #expect(mayor.analisisDeHanson == "p⁶m³n⁴s⁵d²t")
        #expect(mayor.triadasPorGrados == ["I", "ii", "iii", "IV", "V", "vi", "vii°"])
        #expect(mayor.cuatriadasPorGrados?.first == "Imaj7")
        #expect(mayor.complemento == "5-35")
        #expect(mayor.parejaZ == nil)
        #expect(mayor.modoDeMessiaen == nil)
        #expect(mayor.combinatoriedad == nil)
        #expect(mayor.parsimonia == 2)
        #expect(mayor.perfilMayor > mayor.perfilMenor)
        #expect(mayor.conSensible && mayor.tetracordosIguales && mayor.unicidad && mayor.simplicidad)
        #expect(mayor.simetricaPorInversion && !mayor.equilibrada)
        #expect(mayor.magnitudesDeFourier.count == 6)
        #expect(mayor.limiteImpar == 45)
        #expect(mayor.gradoDeSuavidad == 11)
        #expect(mayor.estabilidad > 0.9 && mayor.cocienteDeIgualdad > 0.9 && mayor.anchuraDelEspectro == 1)
        #expect(mayor.consonanciaDiadica > 0 && mayor.distanciaALaUniformidad > 0 && mayor.alturaDeTenney > 0)
        #expect(mayor.entropiaIntervalica > 0 && mayor.entropiaArmonica > 0 && mayor.rugosidadMedia > 0)
        #expect(mayor.triadasContenidas.mayores == 3)
        #expect(mayor.imperfecciones == 1)
    }
}
