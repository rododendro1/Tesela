import Testing

@testable import Elementos
@testable import Teoria

/// Lo que dicen de las escalas las teorías (Myhill, Rothenberg, Gamer, Hanson, Messiaen, Balzano…), en
/// `EstadisticasDeEscala`.
@Suite struct MedidasDeEscalaTests {
    let mayor = Escala(.do, .mayor).estadisticas
    let menorArmonica = Escala(.do, .menorArmonica).estadisticas
    let pentatonica = Escala(.do, .pentatonicaMayor).estadisticas
    let tonosEnteros = Escala(.do, .tonosEnteros).estadisticas
    let disminuida = Escala(.do, .disminuida).estadisticas

    @Test func myhillYBienFormadas() {
        #expect(mayor.propiedadDeMyhill)
        #expect(pentatonica.propiedadDeMyhill)
        #expect(!menorArmonica.propiedadDeMyhill)
        // La mayor y la pentatónica, cadenas de cuartas; la de tonos enteros, de tonos, con un solo paso.
        #expect(mayor.generador == 5)
        #expect(pentatonica.generador == 5)
        #expect(tonosEnteros.generador == 2)
        #expect(menorArmonica.generador == nil)
        #expect(mayor.bienFormada && pentatonica.bienFormada && tonosEnteros.bienFormada)
        #expect(!menorArmonica.bienFormada)
    }

    @Test func propiedadDeRothenberg() {
        // La mayor es propia pero no estrictamente: la cuarta aumentada y la quinta disminuida miden lo mismo.
        #expect(mayor.propiedadDeRothenberg == .propia)
        #expect(mayor.ambiguedades == 1)
        #expect(mayor.contradicciones == 0)
        #expect(pentatonica.propiedadDeRothenberg == .estrictamentePropia)
        #expect(pentatonica.estabilidad == 1)
        #expect(menorArmonica.estabilidad < mayor.estabilidad)
        // Do Re♭ Re Mi♭ Sol: la segunda Mi♭–Sol (4 semitonos) es mayor que la tercera Do–Re (2).
        #expect(MedidasDeEscala.rothenberg([0, 1, 2, 3, 7]).propiedad == .impropia)
        #expect(mayor.anchuraDelEspectro == 1)
        #expect(pentatonica.cocienteDeIgualdad == 1)
    }

    @Test func profundaYHanson() {
        #expect(mayor.profunda)
        #expect(!pentatonica.profunda)
        #expect(mayor.analisisDeHanson == "p⁶m³n⁴s⁵d²t")
        #expect(tonosEnteros.analisisDeHanson == "m⁶s⁶t³")
        #expect(mayor.consonanciaDiadica > menorArmonica.consonanciaDiadica)
        #expect(mayor.entropiaIntervalica == 2.398)
    }

    @Test func fourierYUniformidad() {
        #expect(tonosEnteros.equilibrada)
        #expect(disminuida.equilibrada)
        #expect(!mayor.equilibrada)
        #expect(tonosEnteros.magnitudesDeFourier[5] == 6)
        #expect(tonosEnteros.distanciaALaUniformidad == 0)
        #expect(mayor.distanciaALaUniformidad == 0.756)
        #expect(mayor.triadasContenidas == TriadasContenidas(mayores: 3, menores: 3, disminuidas: 1, aumentadas: 0))
    }

    @Test func simetriasMessiaenYForte() {
        #expect(tonosEnteros.modoDeMessiaen == 1)
        #expect(disminuida.modoDeMessiaen == 2)
        #expect(mayor.modoDeMessiaen == nil)
        #expect(mayor.simetricaPorInversion)
        #expect(!menorArmonica.simetricaPorInversion)
        #expect(mayor.complemento == "5-35")
        #expect(mayor.parejaZ == nil)
        #expect(mayor.unicidad)
        #expect(!tonosEnteros.unicidad)
        #expect(mayor.simplicidad)
        #expect(mayor.imperfecciones == 1)
        #expect(Escala(.do, .menorMelodica).estadisticas.imperfecciones == 3)
    }

    @Test func armonizacionPorGrados() {
        #expect(mayor.triadasPorGrados == ["", "m", "m", "", "", "m", "°"])
        #expect(mayor.cuatriadasPorGrados == ["maj7", "m7", "m7", "maj7", "7", "m7", "ø7"])
        #expect(menorArmonica.triadasPorGrados?[2] == "+")
        #expect(pentatonica.triadasPorGrados == nil)
    }

    @Test func combinatoriedadHexacordal() {
        #expect(tonosEnteros.combinatoriedad?.tipo == "F")
        #expect(mayor.combinatoriedad == nil)
        let hexacordo = ConjuntoDeClasesDeAltura([0, 1, 2, 3, 4, 5])
        #expect(MedidasDeEscala.combinatoriedad(hexacordo)?.tipo == "A")
        #expect(MedidasDeEscala.combinatoriedad(hexacordo)?.transposiciones == [6])
    }

    @Test func parsimoniaYAfinacion() {
        // Fa → Fa♯ da Sol mayor; Si → Si♭, Fa mayor.
        #expect(mayor.parsimonia == 2)
        #expect(mayor.gradoDeSuavidad == 11)
        #expect(mayor.limiteImpar == 45)
        #expect(pentatonica.alturaDeTenney < mayor.alturaDeTenney)
        #expect(mayor.rugosidadMedia < Escala(.do, .cromatica).estadisticas.rugosidadMedia)
        #expect(mayor.entropiaArmonica > 0)
    }

    @Test func perfilTonalSensibleYTetracordos() {
        #expect(mayor.perfilMayor == 0.756)
        #expect(mayor.perfilMayor > mayor.perfilMenor)
        #expect(menorArmonica.perfilMenor > menorArmonica.perfilMayor)
        #expect(mayor.conSensible)
        #expect(!Escala(.do, .mixolidio).estadisticas.conSensible)
        #expect(mayor.tetracordosIguales)
        #expect(!menorArmonica.tetracordosIguales)
    }
}
