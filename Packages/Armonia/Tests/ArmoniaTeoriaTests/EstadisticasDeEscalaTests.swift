import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// El cardinal de las escalas (pentatónica, heptatónica…) y lo que se mide de ellas (`EstadisticasDeEscala`).
@Suite struct EstadisticasDeEscalaTests {
    @Test func cardinal() {
        #expect(TipoDeEscala.mayor.numeroDeNotas == 7)
        #expect(TipoDeEscala.mayor.cardinal == .heptatonica)
        #expect(TipoDeEscala.pentatonicaMayor.cardinal == .pentatonica)
        #expect(TipoDeEscala.tonosEnteros.cardinal == .hexatonica)
        #expect(TipoDeEscala.disminuida.cardinal == .octatonica)
        #expect(TipoDeEscala.bebopDominante.cardinal == .octatonica)
        #expect(TipoDeEscala.cromatica.cardinal == .dodecatonica)
        #expect(CardinalDeEscala(numeroDeNotas: 3) == .tritonica)
        #expect(CardinalDeEscala(numeroDeNotas: 1) == .monotonica)
        #expect(CardinalDeEscala(numeroDeNotas: 0) == nil)
        #expect(CardinalDeEscala(numeroDeNotas: 22) == nil)
        #expect(CardinalDeEscala.allCases.map(\.numeroDeNotas) == Array(1...12))
        #expect(CardinalDeEscala.pentatonica < .heptatonica)
    }

    @Test func nombresDelCardinal() {
        #expect(CardinalDeEscala.pentatonica.nombre == "pentatónica")
        #expect(CardinalDeEscala.octatonica.nombre(en: .inglesASCII) == "octatonic")
        #expect(CardinalDeEscala.tritonica.nombre == "tritónica")
        #expect(CardinalDeEscala.hexatonica.nombre(en: .delIdioma(.aleman)) == "Hexatonik")
        // Todos tienen nombre, distinto, en cada idioma.
        for idioma in Idioma.allCases {
            let nombres = CardinalDeEscala.allCases.map { $0.nombre(en: .delIdioma(idioma)) }
            #expect(Set(nombres).count == nombres.count, Comment(rawValue: "\(idioma)"))
            #expect(nombres.allSatisfy { !$0.isEmpty }, Comment(rawValue: "\(idioma)"))
        }
    }

    @Test func escalasPorNumeroDeNotas() {
        let pentatonicas = TipoDeEscala.todos(numeroDeNotas: 5)
        #expect(pentatonicas.contains(.pentatonicaMayor))
        #expect(pentatonicas.contains(.pentatonicaMenor))
        #expect(!pentatonicas.contains(.mayor))
        #expect(pentatonicas.allSatisfy { $0.cardinal == .pentatonica })
        #expect(TipoDeEscala.todos(numeroDeNotas: 7).contains(.lidio))
    }

    @Test func brilloPorQuintas() {
        #expect(Escala(.do).estadisticas.brilloPorQuintas == 2)
        #expect(Escala(.do, .lidio).estadisticas.brilloPorQuintas == 3)
        #expect(Escala(.re, .dorico).estadisticas.brilloPorQuintas == 0)
        #expect(Escala(.si, .locrio).estadisticas.brilloPorQuintas == -3)
        #expect(Escala(.do, .pentatonicaMayor).estadisticas.brilloPorQuintas == 2)
        #expect(Escala(.la, .pentatonicaMenor).estadisticas.brilloPorQuintas == -1)
        // En los siete modos de la mayor, es el brillo de siempre más 2.
        for tipo in TipoDeEscala.modosPorBrillo {
            let estadisticas = Escala(.mi, tipo).estadisticas
            let esperado = estadisticas.brillo.map { Double($0 + 2) }
            #expect(esperado == estadisticas.brilloPorQuintas, Comment(rawValue: tipo.nombre))
        }
        // Del más brillante al más oscuro.
        let quintas = TipoDeEscala.modosPorBrillo.map { Escala(.do, $0).estadisticas.brilloPorQuintas }
        #expect(quintas == quintas.sorted(by: >))
        #expect(Escala(.do, .pentatonicaMayor).estadisticas.brillo == nil)
    }

    @Test func intervalosYReparto() {
        let mayor = Escala(.do).estadisticas
        #expect(mayor.numeroDeNotas == 7)
        #expect(mayor.pasos == [2, 2, 1, 2, 2, 2, 1])
        #expect(mayor.vectorIntervalico == [2, 5, 4, 3, 6, 1])
        #expect(!mayor.anhemitonica)
        #expect(!mayor.cohemitonica)
        #expect(mayor.transposicionesDistintas == 12)
        #expect(mayor.numeroDeForte == "7-35")
        #expect(mayor.maximamenteRegular)
        #expect(!mayor.aproximada)
        // Los pasos van desde la tónica, sea cual sea.
        #expect(Escala(.la, .menorNatural).estadisticas.pasos == [2, 1, 2, 2, 1, 2, 2])

        let pentatonica = Escala(.do, .pentatonicaMayor).estadisticas
        #expect(pentatonica.anhemitonica)
        #expect(pentatonica.maximamenteRegular)
        #expect(pentatonica.pasos == [2, 2, 3, 2, 3])

        let tonosEnteros = Escala(.do, .tonosEnteros).estadisticas
        #expect(tonosEnteros.anhemitonica && tonosEnteros.maximamenteRegular)
        #expect(tonosEnteros.transposicionesDistintas == 2)

        let disminuida = Escala(.do, .disminuida).estadisticas
        #expect(disminuida.maximamenteRegular)
        #expect(disminuida.transposicionesDistintas == 3)
        #expect(disminuida.vectorIntervalico[5] == 4)

        let armonica = Escala(.la, .menorArmonica).estadisticas
        #expect(!armonica.maximamenteRegular)
        #expect(!armonica.cohemitonica)

        #expect(Escala(.do, .bebopDominante).estadisticas.cohemitonica)
        #expect(Escala(.do, .cromatica).estadisticas.cohemitonica)
        #expect(Escala(.do, .cromatica).estadisticas.pasos == Array(repeating: 1, count: 12))
    }

    @Test func escalaVacia() {
        let vacia = Escala(.do, TipoDeEscala(nombre: "vacía", intervalos: [])).estadisticas
        #expect(vacia.numeroDeNotas == 0)
        #expect(vacia.cardinal == nil)
        #expect(vacia.brilloPorQuintas == 0)
        #expect(vacia.pasos.isEmpty)
    }
}
