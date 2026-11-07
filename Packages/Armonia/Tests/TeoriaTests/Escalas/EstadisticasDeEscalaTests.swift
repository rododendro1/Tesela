import Testing

@testable import Elementos
@testable import Teoria

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

    /// Desde Do mayor, bajando una nota cada vez, los modos de la mayor hasta el locrio; subiendo, el lidio.
    @Test func escaleraDeBrillo() throws {
        let escalera = Escala(.do).escaleraDeBrillo()
        let i = escalera.posicion
        #expect(escalera.peldanos[i] == Escala(.do))
        try #require(i >= 5 && i + 1 < escalera.peldanos.count, Comment(rawValue: "\(escalera.peldanos)"))
        let modos = escalera.peldanos[(i - 5)...(i + 1)]
        #expect(
            modos.map(\.tipo.nombre) == ["locrio", "frigio", "menor natural", "dórico", "mixolidio", "mayor", "lidio"])
        #expect(modos.allSatisfy { $0.tonica == .do })
        let brillos = modos.map(\.estadisticas.brilloPorQuintas)
        #expect(brillos == brillos.sorted() && Set(brillos).count == brillos.count, Comment(rawValue: "\(brillos)"))
        // Una subida por peldaño: de mayor a lidio, el Fa sube a Fa♯; de mixolidio a mayor, el Si♭ a Si.
        #expect(escalera.subidas.count == escalera.peldanos.count - 1)
        #expect(escalera.subidas[i].desde == .fa && escalera.subidas[i].hasta == Nota(.fa, .sostenido))
        #expect(escalera.subidas[i - 1].desde == Nota(.si, .bemol) && escalera.subidas[i - 1].hasta == .si)
        #expect(escalera.subidas.indices.allSatisfy { escalera.subidas[$0].escala == escalera.peldanos[$0 + 1] })
        // Las vecinas por brillo: el lidio, la más habitual de las más brillantes; el mixolidio, de las más oscuras.
        let vecinas = Escala(.do).vecinasPorBrillo()
        #expect(vecinas.masBrillantes.first?.escala == Escala(.do, .lidio))
        #expect(vecinas.masOscuras.first?.escala == Escala(.do, .mixolidio))
        #expect(Escala(.do).escaleraDeBrillo(maximo: 1).peldanos.count == 3)
    }

    /// El mapa de brillo de las de siete notas: ordenado de la más oscura a la más brillante, sin repetidas, y con
    /// el mayor enlazado al lidio (el Fa sube a Fa♯) y al mixolidio (el Si♭ sube a Si).
    @Test func mapaDeBrillo() throws {
        let mapa = Escala.mapaDeBrillo()
        let brillos = mapa.escalas.map(\.estadisticas.brilloPorQuintas)
        #expect(brillos == brillos.sorted(), Comment(rawValue: "\(brillos)"))
        #expect(mapa.escalas.allSatisfy { $0.tipo.numeroDeNotas == 7 && $0.tonica == .do })
        let conjuntos = mapa.escalas.map { Set($0.notas.map(\.claseDeAltura)) }
        #expect(Set(conjuntos).count == conjuntos.count)
        let mayor = try #require(mapa.escalas.firstIndex(of: Escala(.do)))
        let lidio = try #require(mapa.escalas.firstIndex(of: Escala(.do, .lidio)))
        let mixolidio = try #require(mapa.escalas.firstIndex(of: Escala(.do, .mixolidio)))
        let haciaElLidio = mapa.enlaces.first { $0.oscura == mayor && $0.brillante == lidio }
        #expect(haciaElLidio?.desde == .fa && haciaElLidio?.hasta == Nota(.fa, .sostenido))
        let desdeElMixolidio = mapa.enlaces.first { $0.oscura == mixolidio && $0.brillante == mayor }
        #expect(desdeElMixolidio?.desde == Nota(.si, .bemol) && desdeElMixolidio?.hasta == .si)
        // Nunca entre una escala y sí misma, y la nota que sube lo hace un semitono.
        #expect(mapa.enlaces.allSatisfy { $0.oscura != $0.brillante })
        #expect(mapa.enlaces.allSatisfy { ($0.hasta.claseDeAltura - $0.desde.claseDeAltura + 12) % 12 == 1 })
        // Las de cinco notas, sobre Re.
        let pentatonicas = Escala.mapaDeBrillo(tonica: .re, numeroDeNotas: 5)
        #expect(pentatonicas.escalas.contains(Escala(.re, .pentatonicaMayor)))
        #expect(pentatonicas.escalas.allSatisfy { $0.tipo.numeroDeNotas == 5 })
    }

    /// Sin intervalos, la escala se queda en la tónica: una sola nota, monotónica, con un paso de una octava.
    @Test func escalaDeUnaNota() {
        let sola = Escala(.do, TipoDeEscala(nombre: "vacía", intervalos: [])).estadisticas
        #expect(sola.numeroDeNotas == 1)
        #expect(sola.cardinal == .monotonica)
        #expect(sola.brilloPorQuintas == 0)
        #expect(sola.pasos == [12])
    }
}
