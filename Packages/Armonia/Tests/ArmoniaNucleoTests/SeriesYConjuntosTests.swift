import Foundation
import Testing

@testable import ArmoniaNucleo

@Suite struct LecturaDeConjuntosTests {
    private func leer(_ texto: String) throws -> ConjuntoDeClases { try ConjuntoDeClases(leyendo: texto) }

    @Test func formasDeEscribirlos() throws {
        let mayor: ConjuntoDeClases = [0, 4, 7]
        for texto in ["[0, 4, 7]", "{0 4 7}", "(0,4,7)", "0 4 7", "0,4,7", " [ 7 , 4 , 0 ] ", "047", "740", "0 4 7 0"] {
            #expect(try leer(texto) == mayor, "\(texto)")
        }
        #expect(try leer("01t") == [0, 1, 10])
        #expect(try leer("[t, e]") == [10, 11])
        #expect(try leer("T E") == [10, 11])
        #expect(try leer("10 11") == [10, 11])
        #expect(try leer("0 4 E") == [0, 4, 11])
        // Con ceros delante o de más de 11, una cifra por clase.
        #expect(try leer("012") == [0, 1, 2])
        #expect(try leer("12") == [1, 2])
        #expect(try leer("[]") == ConjuntoDeClases([Int]()))
    }

    @Test func conNotas() throws {
        #expect(try leer("Do Mi Sol") == [0, 4, 7])
        #expect(try leer("C E G") == [0, 4, 7])
        #expect(try leer("[Sib, Re, Fa]") == [10, 2, 5])
        #expect(try leer("Fa# La Do#") == [6, 9, 1])
    }

    @Test func numerosDeForte() throws {
        #expect(try leer("3-11") == [0, 3, 7])
        #expect(try leer("4-Z15") == [0, 1, 4, 6])
        #expect(try leer("4-z15") == [0, 1, 4, 6])
        #expect(try leer("4-15") == [0, 1, 4, 6])
        #expect(try leer(" 7-35 ").numeroDeForte == "7-35")
        #expect(try leer("12-1").cardinalidad == 12)
        // Todos los de la tabla se leen y dan su número.
        for (prima, numero) in ConjuntoDeClases.tablaForte {
            #expect(try leer(numero).formaPrima == prima, "\(numero)")
        }
    }

    @Test func errores() {
        func motivo(_ texto: String) -> (ErrorDeLectura.Motivo, Int?)? {
            do {
                _ = try leer(texto)
                return nil
            } catch let error as ErrorDeLectura {
                return (error.motivo, error.posicion)
            } catch {
                return nil
            }
        }
        #expect(motivo("")?.0 == .textoVacio)
        #expect(motivo("3-13")?.0 == .numeroDeForteDesconocido("3-13"))
        #expect(motivo("  3-13")?.1 == 2)
        #expect(motivo("[0, 4, 7")?.0 == .faltaElCierre("]"))
        #expect(motivo("[0, 4, 7] 9")?.0 == .caracteresSobrantes("9"))
        #expect(motivo("0 4 x")! == (.claseDeAlturaNoValida("x"), 4))
        #expect(motivo("0 Mi")! == (.claseDeAlturaNoValida("Mi"), 2))
        #expect(motivo("0 4 ]")?.0 == .caracteresSobrantes("]"))
        #expect(motivo(",")?.0 == .claseDeAlturaNoValida(","))
    }

    @Test func mensajes() {
        let error = ErrorDeLectura(texto: "x", posicion: nil, motivo: .claseDeAlturaNoValida("x"))
        #expect(error.explicacion.contains("«x» no es una clase de altura"))
        #expect(error.explicacion(en: .inglesASCII).contains("is neither a pitch class"))
        let serie = ErrorDeLectura(
            texto: "x", posicion: nil, motivo: .serieNoDodecafonica(faltan: [3, 7], repetidas: [1]))
        #expect(
            serie.explicacion
                == "una serie dodecafónica tiene las doce clases de altura, cada una una vez: faltan 3, 7; se repiten 1"
        )
        #expect(
            ErrorDeLectura(texto: "x", posicion: nil, motivo: .serieNoDodecafonica(faltan: [], repetidas: []))
                .explicacion
                == "una serie dodecafónica tiene las doce clases de altura, cada una una vez")
        for idioma in Idioma.allCases {
            let textos = TextosDeNucleo.traducidos.texto(en: idioma)
            for texto in [
                textos.claseDeAlturaNoValida("x"), textos.numeroDeForteDesconocido("x"), textos.faltaElCierre("x"),
                textos.serieNoDodecafonica, textos.faltanEnLaSerie("x"), textos.repetidasEnLaSerie("x"),
            ] {
                #expect(!texto.isEmpty, "\(idioma)")
            }
        }
    }
}

@Suite struct SerieDodecafonicaTests {
    /// La de la Suite lírica de Berg (Fa Mi Do La Sol Re La♭ Re♭ Mi♭ Sol♭ Si♭ Si), transportada a Do.
    private let berg = SerieDodecafonica([0, 11, 7, 4, 2, 9, 3, 8, 10, 1, 5, 6])!
    /// La de la Suite para piano, op. 25, de Schoenberg (Mi Fa Sol Re♭ Sol♭ Mi♭ La♭ Re Si Do La Si♭).
    private let schoenberg = SerieDodecafonica([4, 5, 7, 1, 6, 3, 8, 2, 11, 0, 9, 10])!

    @Test func creacion() throws {
        #expect(SerieDodecafonica([0, 1, 2]) == nil)
        #expect(SerieDodecafonica([0, 0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]) == nil)
        #expect(SerieDodecafonica([12, 23, 19, 16, 14, 21, 15, 20, 22, 13, 17, 18]) == berg)
        #expect(SerieDodecafonica(notas: [.fa, .mi, .do]) == nil)
        #expect(berg.description == "0 e 7 4 2 9 3 8 t 1 5 6")
        #expect(try SerieDodecafonica(leyendo: berg.description) == berg)
        #expect(try SerieDodecafonica(leyendo: "0e742 938t156") == berg)
        #expect(try SerieDodecafonica(leyendo: "[0, 11, 7, 4, 2, 9, 3, 8, 10, 1, 5, 6]") == berg)
        let conNotas = try SerieDodecafonica(leyendo: "Fa Mi Do La Sol Re La♭ Re♭ Mi♭ Sol♭ Si♭ Si")
        #expect(conNotas == berg.original(5))
    }

    @Test func erroresAlLeer() {
        do {
            _ = try SerieDodecafonica(leyendo: "0 1 1 3 4 5 6 7 8 9 t")
            Issue.record("Se ha leído una serie sin el 2 ni el 11")
        } catch let error as ErrorDeLectura {
            #expect(error.motivo == .serieNoDodecafonica(faltan: [2, 11], repetidas: [1]))
        } catch {
            Issue.record("\(error)")
        }
        #expect(throws: ErrorDeLectura.self) { try SerieDodecafonica(leyendo: "0 1 x") }
    }

    @Test func formas() {
        #expect(berg.original(0) == berg)
        #expect(berg.original(5).clases.first == 5)
        #expect(berg.inversion(0).clases == [0, 1, 5, 8, 10, 3, 9, 4, 2, 11, 7, 6])
        #expect(berg.retrogrado(0).clases == [6, 5, 1, 10, 8, 3, 9, 2, 4, 7, 11, 0])
        #expect(berg.retrogrado(3).clases.last == 3)
        #expect(berg.retrogradoDeLaInversion(0).clases == berg.inversion(0).clases.reversed())
        #expect(berg.transponer(.terceraMayor) == berg.original(4))
        #expect(FormaDeSerie(.retrogradoDeLaInversion, 7).description == "RI7")
        #expect(FormaDeSerie(.original, -1) == FormaDeSerie(.original, 11))
        #expect(FormaDeSerie.todas.count == 48)
        #expect(berg.formas.count == 48)
    }

    @Test func identificarYSimetrias() {
        #expect(schoenberg.identificar(schoenberg) == [FormaDeSerie(.original, 4)])
        #expect(schoenberg.identificar(schoenberg.retrogradoDeLaInversion(9)) == [.init(.retrogradoDeLaInversion, 9)])
        #expect(schoenberg.numeroDeFormasDistintas == 48)
        // La de Berg es simétrica: su retrógrado es la original a un tritono.
        #expect(berg.identificar(berg.retrogrado(0)) == [.init(.original, 6), .init(.retrogrado, 0)])
        #expect(berg.numeroDeFormasDistintas == 24)
        let otra = SerieDodecafonica([0, 2, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11])!
        #expect(berg.identificar(otra).isEmpty)
    }

    @Test func matriz() {
        let matriz = berg.matriz
        #expect(matriz.count == 12 && matriz.allSatisfy { $0.count == 12 })
        #expect(matriz[0] == berg.clases)
        #expect(matriz.map { $0[0] } == berg.inversion(0).clases)
        #expect(matriz[1] == [1, 0, 8, 5, 3, 10, 4, 9, 11, 2, 6, 7])
        // Cada fila es la P de su primera clase; cada columna, la I de su primera clase.
        for i in 0..<12 {
            #expect(matriz[i] == berg.original(matriz[i][0]).clases)
            #expect(matriz.map { $0[i] } == berg.inversion(matriz[0][i]).clases)
        }
        // Un cuadrado latino: cada clase, una vez en cada fila y en cada columna.
        for i in 0..<12 {
            #expect(Set(matriz[i]).count == 12)
            #expect(Set(matriz.map { $0[i] }).count == 12)
        }
        #expect(schoenberg.matriz[0][0] == 4)
    }

    @Test func intervalos() {
        #expect(berg.intervalos == [11, 8, 9, 10, 7, 6, 5, 2, 3, 4, 1])
        #expect(berg.esDeTodosLosIntervalos)
        #expect(!schoenberg.esDeTodosLosIntervalos)
        #expect(SerieDodecafonica(0..<12)!.intervalos == Array(repeating: 1, count: 11))
    }

    @Test func combinatoriedad() {
        #expect(berg.hexacordos.primero.numeroDeForte == "6-32")
        #expect(berg.hexacordos.segundo == berg.hexacordos.primero.complemento)
        #expect(
            berg.formasCombinatorias == [
                .init(.original, 6), .init(.inversion, 5), .init(.retrogrado, 0), .init(.retrogradoDeLaInversion, 11),
            ])
        #expect(berg.esTotalmenteCombinatoria)

        #expect(schoenberg.formasCombinatorias == [.init(.inversion, 11), .init(.retrogrado, 4)])
        #expect(schoenberg.tiposDeCombinatoriedad == [.inversion, .retrogrado])
        #expect(!schoenberg.esTotalmenteCombinatoria)

        let soloR = SerieDodecafonica([7, 6, 2, 3, 4, 9, 10, 11, 1, 0, 5, 8])!
        #expect(soloR.tiposDeCombinatoriedad == [.retrogrado])
        #expect(SerieDodecafonica(0..<12)!.esTotalmenteCombinatoria)
    }

    @Test func codable() throws {
        let datos = try JSONEncoder().encode(berg)
        #expect(String(decoding: datos, as: UTF8.self) == "[0,11,7,4,2,9,3,8,10,1,5,6]")
        #expect(try JSONDecoder().decode(SerieDodecafonica.self, from: datos) == berg)
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(SerieDodecafonica.self, from: Data("[0,1,2]".utf8))
        }
        let forma = try JSONEncoder().encode(FormaDeSerie(.inversion, 3))
        #expect(try JSONDecoder().decode(FormaDeSerie.self, from: forma) == FormaDeSerie(.inversion, 3))
    }
}

@Suite struct SimetriaDeConjuntosTests {
    @Test func notasComunes() {
        let mayor: ConjuntoDeClases = [0, 4, 7]
        #expect(mayor.notasComunes(transponiendo: 0) == 3)
        #expect(mayor.notasComunes(transponiendo: 5) == 1)
        #expect(mayor.notasComunes(invirtiendo: 7) == 2)
        #expect(mayor.vectorDeTransposicion == [3, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0])
        #expect(mayor.vectorDeIndice == [1, 0, 1, 0, 2, 0, 0, 2, 1, 0, 0, 2])
        // El vector de índice da las notas comunes de cada TnI, y el de transposición sale del interválico.
        for clases in [[0, 1, 4, 6], [0, 2, 4, 5, 7, 9, 11], [0, 3, 6, 9], [0, 1, 6, 7], [5]] {
            let conjunto = ConjuntoDeClases(clases)
            #expect(conjunto.vectorDeIndice == (0..<12).map { conjunto.notasComunes(invirtiendo: $0) })
            let iv = conjunto.vectorIntervalico
            for n in 1...5 {
                #expect(conjunto.vectorDeTransposicion[n] == iv[n - 1])
                #expect(conjunto.vectorDeTransposicion[12 - n] == iv[n - 1])
            }
            #expect(conjunto.vectorDeTransposicion[6] == 2 * iv[5])
        }
    }

    @Test func ejes() {
        #expect(ConjuntoDeClases([0, 4, 7]).ejesDeSimetria.isEmpty)
        #expect(ConjuntoDeClases([0, 4, 7, 10]).ejesDeSimetria.isEmpty)
        #expect(ConjuntoDeClases([0, 3, 7, 10]).ejesDeSimetria == [EjeDeInversion(indice: 10)])
        #expect(ConjuntoDeClases([0, 3, 7, 10]).ejesDeSimetria.map(\.description) == ["5–11"])
        #expect(ConjuntoDeClases([0, 3, 6, 9]).ejesDeSimetria.map(\.indice) == [0, 3, 6, 9])
        #expect(ConjuntoDeClases([0, 1]).ejesDeSimetria.map(\.description) == ["0½–6½"])
        let eje = EjeDeInversion(indice: 13)
        #expect(eje.indice == 1 && eje.clasesFijas.isEmpty && eje.extremos == [0.5, 6.5])
        #expect(EjeDeInversion(indice: 4).clasesFijas == [2, 8])
        #expect(EjeDeInversion(indice: 11).extremos == [5.5, 11.5])
        #expect(EjeDeInversion(indice: 2) < EjeDeInversion(indice: 3))
        for clases in [[0, 4, 8], [0, 2, 4, 6, 8, 10], [0, 1, 3, 7], [0, 1, 2, 3]] {
            let conjunto = ConjuntoDeClases(clases)
            #expect(conjunto.ejesDeSimetria.count == conjunto.simetriasPorInversion)
            #expect(conjunto.transposicionesQueLoDejanIgual.count == conjunto.simetriasPorTransposicion)
        }
        #expect(ConjuntoDeClases([0, 4, 8]).transposicionesQueLoDejanIgual == [0, 4, 8])
    }
}

@Suite struct OrtografiaDeConjuntosTests {
    private func escribir(_ clases: [Int], con fija: Nota? = nil) -> String {
        ConjuntoDeClases(clases).notas(con: fija).map(\.nombre).joined(separator: " ")
    }

    @Test func laEscrituraMasSencilla() {
        #expect(escribir([0, 4, 7]) == "Do Mi Sol")
        #expect(escribir([0, 3, 7]) == "Do Mi♭ Sol")
        #expect(escribir([2, 6, 9]) == "Re Fa♯ La")
        #expect(escribir([1, 5, 8]) == "Re♭ Fa La♭")
        #expect(escribir([1, 4, 8]) == "Do♯ Mi Sol♯")
        #expect(escribir([0, 4, 7, 10]) == "Do Mi Sol Si♭")
        #expect(escribir([0, 1]) == "Do Re♭")
        #expect(escribir([0, 2, 4, 5, 7, 9, 11]) == "Do Re Mi Fa Sol La Si")
        #expect(escribir([1, 3, 6, 8, 10]) == "Re♭ Mi♭ Sol♭ La♭ Si♭")
        #expect(escribir([6]) == "Fa♯")
        #expect(escribir([10]) == "Si♭")
        #expect(escribir([]) == "")
        #expect(ConjuntoDeClases(0..<12).notas().count == 12)
    }

    @Test func sinRepetirLetra() {
        // Las escalas mayores y sus subconjuntos salen siempre con letras distintas y sin dobles alteraciones.
        let mayor = [0, 2, 4, 5, 7, 9, 11]
        for t in 0..<12 {
            let escala = ConjuntoDeClases(mayor.map { $0 + t })
            let notas = escala.notas()
            #expect(Set(notas.map(\.natural)).count == 7, "\(notas)")
            #expect(notas.allSatisfy { abs($0.alteracion.semitonos) <= 1 }, "\(notas)")
            #expect(notas.map(\.claseDeAltura) == escala.clases)
        }
    }

    @Test func conUnaNotaFija() {
        #expect(escribir([1, 5, 8], con: Nota(.do, .sostenido)) == "Do♯ Mi♯ Sol♯")
        #expect(escribir([0, 4, 7], con: .sol) == "Do Mi Sol")
        #expect(escribir([3, 7, 10], con: Nota(.re, .sostenido)) == "Re♯ Fa𝄪 La♯")
        // Una nota fija que no es del conjunto orienta la escritura pero no se añade.
        #expect(escribir([8], con: Nota(.mi)) == "Sol♯")
        #expect(escribir([8]) == "La♭")
    }
}

@Suite struct NombresDeLasClasesTests {
    @Test func unNombreDistintoPorClase() {
        let nombres = ConjuntoDeClases.nombresDeLasClases(en: .espanolCompacto)
        #expect(nombres.count == 12)
        #expect(Set(nombres).count == 12)
        #expect(nombres[0] == "Do")
        #expect(nombres[7] == "Sol")
        #expect(ConjuntoDeClases.nombresDeLasClases(en: .inglesASCII)[0] == "C")
    }

    @Test func lasCifrasDeUnaSerie() {
        #expect((0..<12).map(SerieDodecafonica.cifra) == ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "t", "e"])
    }
}
