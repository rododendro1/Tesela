import Testing

@testable import Elementos
@testable import Teoria

/// Lo que dicen de las escalas las teorías (Myhill, Rothenberg, Gamer, Hanson, Messiaen, Balzano…), en
/// `EstadisticasDeEscala`.
@Suite struct CalculosDeEscalaTests {
    let mayor = Escala(.do, .mayor).estadisticas
    let menorArmonica = Escala(.do, .menorArmonica).estadisticas
    let pentatonica = Escala(.do, .pentatonicaMayor).estadisticas
    let tonosEnteros = Escala(.do, .tonosEnteros).estadisticas
    let disminuida = Escala(.do, .disminuida).estadisticas

    @Test func myhillYBienFormadas() {
        #expect(mayor.intervalosGenericos.propiedadDeMyhill)
        #expect(pentatonica.intervalosGenericos.propiedadDeMyhill)
        #expect(!menorArmonica.intervalosGenericos.propiedadDeMyhill)
        // La mayor y la pentatónica, cadenas de cuartas; la de tonos enteros, de tonos, con un solo paso.
        #expect(mayor.intervalosGenericos.generador == 5)
        #expect(pentatonica.intervalosGenericos.generador == 5)
        #expect(tonosEnteros.intervalosGenericos.generador == 2)
        #expect(menorArmonica.intervalosGenericos.generador == nil)
        #expect(
            mayor.intervalosGenericos.bienFormada && pentatonica.intervalosGenericos.bienFormada
                && tonosEnteros.intervalosGenericos.bienFormada)
        #expect(!menorArmonica.intervalosGenericos.bienFormada)
    }

    @Test func propiedadDeRothenberg() {
        // La mayor es propia pero no estrictamente: la cuarta aumentada y la quinta disminuida miden lo mismo.
        #expect(mayor.intervalosGenericos.propiedadDeRothenberg == .propia)
        #expect(mayor.intervalosGenericos.ambiguedades == 1)
        #expect(mayor.intervalosGenericos.contradicciones == 0)
        #expect(pentatonica.intervalosGenericos.propiedadDeRothenberg == .estrictamentePropia)
        #expect(pentatonica.intervalosGenericos.estabilidad == 1)
        #expect(menorArmonica.intervalosGenericos.estabilidad < mayor.intervalosGenericos.estabilidad)
        // Do Re♭ Re Mi♭ Sol: la segunda Mi♭–Sol (4 semitonos) es mayor que la tercera Do–Re (2).
        #expect(CalculosDeEscala.rothenberg([0, 1, 2, 3, 7]).propiedad == .impropia)
        #expect(mayor.intervalosGenericos.anchuraDelEspectro == 1)
        #expect(pentatonica.intervalosGenericos.cocienteDeIgualdad == 1)
    }

    @Test func profundaYHanson() {
        #expect(mayor.conjunto.profundo)
        #expect(!pentatonica.conjunto.profundo)
        #expect(mayor.conjunto.analisisDeHanson == "p⁶m³n⁴s⁵d²t")
        #expect(tonosEnteros.conjunto.analisisDeHanson == "m⁶s⁶t³")
        #expect(mayor.conjunto.consonanciaDiadica > menorArmonica.conjunto.consonanciaDiadica)
        #expect(casi(mayor.conjunto.entropiaIntervalica, 2.398))
    }

    @Test func fourierYUniformidad() {
        #expect(tonosEnteros.conjunto.equilibrado)
        #expect(disminuida.conjunto.equilibrado)
        #expect(!mayor.conjunto.equilibrado)
        #expect(tonosEnteros.conjunto.magnitudesDeFourier[5] == 6)
        #expect(tonosEnteros.conjunto.distanciaALaUniformidad == 0)
        #expect(casi(mayor.conjunto.distanciaALaUniformidad, 0.756))
        #expect(
            mayor.conjunto.triadasContenidas == TriadasContenidas(mayores: 3, menores: 3, disminuidas: 1, aumentadas: 0)
        )
    }

    @Test func simetriasMessiaenYForte() {
        #expect(tonosEnteros.conjunto.modoDeMessiaen == 1)
        #expect(disminuida.conjunto.modoDeMessiaen == 2)
        #expect(mayor.conjunto.modoDeMessiaen == nil)
        #expect(mayor.conjunto.simetricoPorInversion)
        #expect(!menorArmonica.conjunto.simetricoPorInversion)
        #expect(mayor.conjunto.complemento == "5-35")
        #expect(mayor.conjunto.parejaZ == nil)
        #expect(mayor.conjunto.unicidad)
        #expect(!tonosEnteros.conjunto.unicidad)
        #expect(mayor.conjunto.simplicidad)
        #expect(mayor.conjunto.imperfecciones == 1)
        #expect(Escala(.do, .menorMelodica).estadisticas.conjunto.imperfecciones == 3)
    }

    @Test func armonizacionPorGrados() {
        #expect(mayor.tonal.triadas == [.mayor, .menor, .menor, .mayor, .mayor, .menor, .disminuido])
        #expect(
            mayor.tonal.cuatriadas == [
                .mayorSeptimaMayor, .menorSeptima, .menorSeptima, .mayorSeptimaMayor, .dominanteSeptima, .menorSeptima,
                .semidisminuido,
            ])
        #expect(menorArmonica.tonal.triadas?[2] == .aumentado)
        #expect(pentatonica.tonal.triadas == nil)
    }

    /// Cada acorde de la armonización por grados se lee de su cifrado, en todas las escalas de siete notas del
    /// catálogo.
    @Test func losAcordesPorGradosSonLosDeSuCifrado() throws {
        for tipo in TipoDeEscala.catalogo where tipo.intervalos.count == 7 {
            let clases = Escala(.do, tipo).notas.map(\.claseDeAltura)
            let cifrados = try #require(CalculosDeEscala.armonizacion(clases))
            let tipos = try #require(CalculosDeEscala.acordesPorGrados(clases))
            for (cifrado, acorde) in zip(cifrados.triadas + cifrados.cuatriadas, tipos.triadas + tipos.cuatriadas) {
                #expect((acorde == nil) == (cifrado == "?"), "\(tipo.nombre): \(cifrado)")
            }
        }
    }

    @Test func combinatoriedadHexacordal() {
        #expect(tonosEnteros.conjunto.combinatoriedad?.tipo == "F")
        #expect(mayor.conjunto.combinatoriedad == nil)
        let hexacordo = ConjuntoDeClasesDeAltura([0, 1, 2, 3, 4, 5])
        #expect(EstadisticasDeConjunto.combinatoriedad(hexacordo)?.tipo == "A")
        #expect(EstadisticasDeConjunto.combinatoriedad(hexacordo)?.transposiciones == [6])
    }

    @Test func parsimoniaYAfinacion() {
        // Fa → Fa♯ da Sol mayor; Si → Si♭, Fa mayor.
        #expect(mayor.conjunto.parsimonia == 2)
        #expect(mayor.afinacion.gradoDeSuavidad == 11)
        #expect(mayor.afinacion.limiteImpar == 45)
        #expect(pentatonica.afinacion.alturaDeTenney < mayor.afinacion.alturaDeTenney)
        #expect(mayor.psicoacustica.rugosidadMedia < Escala(.do, .cromatica).estadisticas.psicoacustica.rugosidadMedia)
        #expect(mayor.psicoacustica.entropiaArmonica > 0)
    }

    @Test func perfilTonalSensibleYTetracordos() {
        #expect(casi(mayor.tonal.perfilMayor, 0.756))
        #expect(mayor.tonal.perfilMayor > mayor.tonal.perfilMenor)
        #expect(menorArmonica.tonal.perfilMenor > menorArmonica.tonal.perfilMayor)
        #expect(mayor.tonal.conSensible)
        #expect(!Escala(.do, .mixolidio).estadisticas.tonal.conSensible)
        #expect(mayor.tonal.tetracordosIguales)
        #expect(!menorArmonica.tonal.tetracordosIguales)
    }
}
