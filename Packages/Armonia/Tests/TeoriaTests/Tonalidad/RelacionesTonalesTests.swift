import Testing

@testable import Elementos
@testable import Teoria

/// El espacio tonal de Lerdahl, el ajuste de Krumhansl, la función probable y las relaciones entre acordes, escalas y
/// los acordes de una progresión.
@Suite struct RelacionesTonalesTests {
    let doMayor = Tonalidad(.do)

    func acorde(_ cifrado: String) throws -> Acorde { try Acorde(leyendo: cifrado) }

    @Test func distanciaDeLerdahl() throws {
        // Los valores de Lerdahl (Tonal Pitch Space, tabla 2.5): I→V 5, I→IV 5, I→vi 7, I→ii 8, IV→V 8.
        let pares = [("Do", "Sol", 5), ("Do", "Fa", 5), ("Do", "Lam", 7), ("Do", "Rem", 8), ("Fa", "Sol", 8)]
        for (x, y, distancia) in pares {
            #expect(doMayor.distanciaDeLerdahl(de: try acorde(x), a: try acorde(y)) == distancia)
        }
        // La♭ mayor no es de Do: se mide en Mi♭ mayor, a tres quintas.
        #expect(doMayor.distanciaDeLerdahl(de: try acorde("Do"), a: try acorde("Lab")) == 14)
        let doFaSolDo = try ["Do", "Fa", "Sol", "Do"].map(acorde)
        #expect(doMayor.tensionDeLerdahl(doFaSolDo).map(\.secuencial) == [0, 5, 8, 5])
        #expect(doMayor.tensionDeLerdahl(doFaSolDo).map(\.desdeLaTonica) == [0, 5, 5, 0])
    }

    @Test func ajusteDeKrumhansl() throws {
        #expect(doMayor.ajuste(de: try acorde("Do")) == 0.834)
        #expect(try acorde("Sol7").ajustesTonales.first?.tonalidad == Tonalidad(.sol))
        #expect(try acorde("Lam").ajustesTonales.count == 24)
        #expect(Tonalidad.todas.count == 24)
        #expect(Tonalidad.todas.first == doMayor)
    }

    @Test func funcionProbable() throws {
        let funciones: [(String, FuncionTonal?)] = [
            ("Do", .tonica), ("Lam", .tonica), ("Mim", .tonica), ("Domaj7", .tonica), ("Fa", .subdominante),
            ("Rem7", .subdominante), ("Fam", .subdominante), ("Sol7", .dominante), ("Si°", .dominante),
            ("Reb7", .dominante), ("Fa#", nil),
        ]
        for (cifrado, funcion) in funciones { #expect(doMayor.funcionProbable(de: try acorde(cifrado)) == funcion) }
        #expect(Tonalidad(.la, .menor).funcionProbable(de: try acorde("Mi7")) == .dominante)
    }

    @Test func entreAcordes() throws {
        let relacion = try acorde("Sol7").relacion(con: try acorde("Do"))
        #expect(relacion.conduccion.semitonosMovidos == 4)
        #expect(relacion.conduccion.desplazamientoEuclideo == 2.449)
        #expect(relacion.conduccion.desplazamientoMaximo == 2)
        #expect(relacion.distanciaEnElTonnetz == nil)
        #expect(relacion.tonalidad == doMayor)
        #expect(relacion.distanciaDeLerdahl == 5)
        #expect(relacion.conjunto.distanciaDeFourier == 1.585)
        let hexatonica = try acorde("Do").relacion(con: try acorde("Lab"))
        #expect(hexatonica.distanciaEnElTonnetz == 2)
        #expect(hexatonica.conjunto.distanciaDeFourier == 0)
    }

    @Test func escalasDelCatalogo() throws {
        let escalas = try acorde("Do7").escalasDelCatalogo
        #expect(escalas.count > TipoDeEscala.deJazz.count)
        #expect(escalas.allSatisfy { $0.contiene(acorde: try! acorde("Do7")) })
    }

    @Test func entreEscalas() {
        let mayor = Escala(.do, .mayor)
        let aSol = mayor.relacion(con: Escala(.sol, .mayor))
        #expect(aSol.distanciaEnQuintas == 1)
        #expect(aSol.notasQueCambian == 1)
        #expect(aSol.conduccion?.semitonosMovidos == 1)
        #expect(mayor.relacion(con: Escala(.la, .menorNatural)).distanciaEnQuintas == 0)
        #expect(mayor.relacion(con: Escala(.do, .menorNatural)).distanciaEnQuintas == 3)
        // De siete a cinco notas: Fa baja a Mi y Si sube a Do.
        let pentatonica = mayor.relacion(con: Escala(.do, .pentatonicaMayor))
        #expect(pentatonica.conduccion?.semitonosMovidos == 2)
        #expect(pentatonica.conjunto.asimilitudDeMorris == 0.355)
        // De siete a doce notas, demasiadas formas de duplicar.
        #expect(mayor.relacion(con: Escala(.do, .cromatica)).conduccion == nil)
    }

    @Test func progresion() throws {
        let diatonica = doMayor.estadisticas(de: try ["Do", "Fa", "Sol7", "Do"].map(acorde))
        #expect(diatonica.movimientos == [3, 5, 4])
        #expect(diatonica.movimientoTotal == 12)
        #expect(diatonica.movimientoMedio == 4)
        #expect(diatonica.tensionMedia == 6)
        #expect(diatonica.funciones == [.tonica, .subdominante, .dominante, .tonica])
        #expect(diatonica.notasNuevas == [0, 2, 3, 2])
        #expect(diatonica.cromatismo == 0)
        let cromatica = doMayor.estadisticas(de: try ["Do", "Lab", "Reb7", "Do"].map(acorde))
        #expect(cromatica.notasFueraDeLaTonalidad == [0, 2, 2, 0])
        #expect(cromatica.cromatismo == 0.308)
        let progresion = try #require(ProgresionConNombre.buscar(nombre: "ii-V-I"))
        #expect(progresion.estadisticas(en: doMayor).acordes.count == 3)
    }
}
