import Testing

@testable import ArmoniaElementos
@testable import ArmoniaTeoria

@Suite struct EscalaYAcordeTests {
    private func cifras(_ escala: Escala, _ acorde: Acorde, _ papel: PapelEnLaEscala? = nil) -> [String] {
        escala.notas(sobre: acorde).filter { papel == nil || $0.papel == papel }.map(\.cifra)
    }

    // MARK: Papel de cada nota

    @Test func jonicoSobreDo7M() {
        let notas = Escala(.do, .mayor).notas(sobre: Acorde("Do7M"))
        #expect(notas.map(\.cifra) == ["1", "9", "3", "11", "5", "13", "7"])
        #expect(notas.map(\.papel) == [.delAcorde, .tension, .delAcorde, .aEvitar, .delAcorde, .tension, .delAcorde])
        #expect(Escala(.do, .mayor).notasAEvitar(sobre: Acorde("Do7M")) == [.fa])
        // En lidio no hay ninguna: el fa♯ está un tono por encima del mi.
        #expect(Escala(.do, .lidio).notasAEvitar(sobre: Acorde("Do7M")).isEmpty)
        #expect(cifras(Escala(.do, .lidio), Acorde("Do7M"), .tension) == ["9", "♯11", "13"])
    }

    @Test func doricoYEolicoSobreUnAcordeMenor() {
        #expect(cifras(Escala(.re, .dorico), Acorde("Rem7"), .tension) == ["9", "11", "13"])
        #expect(Escala(.re, .dorico).notasAEvitar(sobre: Acorde("Rem7")).isEmpty)
        // En eólico, la ♭13 (el si♭) está un semitono por encima de la quinta.
        #expect(cifras(Escala(.re, .menorNatural), Acorde("Rem7"), .aEvitar) == ["♭13"])
        #expect(cifras(Escala(.re, .menorNatural), Acorde("Rem7"), .delAcorde) == ["1", "♭3", "5", "♭7"])
    }

    @Test func dominantes() {
        // Mixolidio: el do (la 11) choca con el si.
        #expect(Escala(.sol, .mixolidio).notasAEvitar(sobre: Acorde("Sol7")) == [.do])
        #expect(Escala(.sol, .mixolidio).tensiones(sobre: Acorde("Sol7")) == [.la, .mi])
        // La ♭9 y la ♭13 de una dominante son tensiones, aunque estén un semitono por encima de otra nota.
        #expect(cifras(Escala(.sol, .frigioDominante), Acorde("Sol7"), .tension) == ["♭9", "♭13"])
        #expect(cifras(Escala(.sol, .frigioDominante), Acorde("Sol7"), .aEvitar) == ["11"])
        // La disminuida semitono-tono: todas disponibles, con la 3.ª menor leída como ♯9.
        let disminuida = Escala(.do, .disminuidaSemitonoTono)
        #expect(cifras(disminuida, Acorde("Do7")) == ["1", "♭9", "♯9", "3", "♯11", "5", "13", "♭7"])
        #expect(disminuida.notasAEvitar(sobre: Acorde("Do7")).isEmpty)
    }

    @Test func sus4() {
        // Sin tercera en el acorde, la tercera mayor de la escala choca con la cuarta.
        let notas = Escala(.sol, .mixolidio).notas(sobre: Acorde(.sol, .sus4Septima))
        #expect(notas.first { $0.nota == .si }?.papel == .aEvitar)
        #expect(notas.first { $0.nota == .do }?.papel == .delAcorde)
        #expect(notas.first { $0.nota == .do }?.cifra == "4")
    }

    @Test func lasNotasDelAcordeSeEscribenComoEnElAcorde() {
        // La alterada escribe Fa♭; sobre Do7(♯9) es la tercera, Mi.
        let alterada = Escala(.do, .alterada)
        let acorde = Acorde(.do, .dominanteSeptima)
        let notas = alterada.notas(sobre: acorde)
        #expect(notas.contains { $0.nota == .mi && $0.papel == .delAcorde })
        #expect(!alterada.contiene(acorde: acorde)) // no tiene el sol
        #expect(Escala(.do, .mixolidio).contiene(acorde: acorde))
    }

    @Test func nombresDeLosPapeles() {
        #expect(PapelEnLaEscala.aEvitar.nombre(en: .espanolCompacto) == "nota a evitar")
        #expect(PapelEnLaEscala.aEvitar.nombre(en: .inglesASCII) == "avoid note")
        #expect(PapelEnLaEscala.delAcorde.description == "nota del acorde")
        #expect(PapelEnLaEscala.allCases.count == 3)
    }

    // MARK: Escala madre

    @Test func escalaMadre() {
        #expect(Escala(.re, .dorico).escalaMadre == ModoDeEscala(madre: Escala(.do, .mayor), grado: 2))
        #expect(Escala(.do, .mayor).escalaMadre?.grado == 1)
        #expect(Escala(.la, .menorNatural).escalaMadre == ModoDeEscala(madre: Escala(.do, .mayor), grado: 6))
        #expect(
            Escala(.do, .alterada).escalaMadre
                == ModoDeEscala(madre: Escala(Nota(.re, .bemol), .menorMelodicaJazz), grado: 7))
        #expect(
            Escala(.sol, .frigioDominante).escalaMadre == ModoDeEscala(madre: Escala(.do, .menorArmonica), grado: 5))
        #expect(Escala(.re, .lidioDominante).escalaMadre?.madre == Escala(.la, .menorMelodicaJazz))
        // Ni la de tonos enteros ni la menor melódica clásica, que baja como la natural.
        #expect(Escala(.do, .tonosEnteros).escalaMadre == nil)
        #expect(Escala(.la, .menorMelodica).escalaMadre == nil)
    }

    @Test func nombreDelModo() {
        let dorico = Escala(.re, .dorico).escalaMadre
        #expect(dorico?.nombre(en: .espanolCompacto) == "modo 2 de Do mayor")
        #expect(dorico?.nombre(en: .inglesASCII) == "mode 2 of C major")
        #expect(dorico?.description == "modo 2 de Do mayor")
    }

    @Test func enLosQuinceIdiomas() {
        let modo = Escala(.re, .dorico).escalaMadre
        for idioma in Idioma.allCases {
            let notacion = Notacion.delIdioma(idioma)
            let nombre = modo?.nombre(en: notacion) ?? ""
            #expect(nombre.contains("2"), Comment(rawValue: nombre))
            #expect(nombre.contains(Escala(.do, .mayor).nombre(en: notacion)), Comment(rawValue: nombre))
            #expect(Set(PapelEnLaEscala.allCases.map { $0.nombre(en: notacion) }).count == 3)
        }
        let nota = Escala(.do, .mayor).notas(sobre: Acorde("Do7M"))[3]
        #expect(nota.description == "Fa (11)")
    }

    // MARK: Escala en su contexto

    private func escalas(_ acordes: [Acorde], en tonalidad: Tonalidad) -> [String?] {
        tonalidad.analizar(acordes).escalas.map { $0?.nombre }
    }

    @Test func diatonicosEnMayor() {
        #expect(
            escalas(["Rem7", "Sol7", "Do7M", "Lam7", "Mim7", "Fa7M", "Sim7b5"], en: Tonalidad(.do)) == [
                "Re dórico", "Sol mixolidio", "Do mayor", "La menor natural", "Mi frigio", "Fa lidio", "Si locrio",
            ])
    }

    @Test func diatonicosEnMenor() {
        // El V con la sensible sale de la armónica, y el IV con el 6.º elevado, de la melódica.
        #expect(
            escalas(["Lam", "Mi7", "Re7", "Lam"], en: Tonalidad(.la, .menor)) == [
                "La menor natural", "Mi frigio dominante", "Re lidio dominante", "La menor natural",
            ])
    }

    @Test func dominantesSecundarias() {
        // V7/V hacia un acorde mayor: mixolidio; V7/ii hacia uno menor: frigio dominante (mixolidio ♭9 ♭13).
        let analisis = Tonalidad(.do).analizar(["Do", "La7", "Rem7", "Re7", "Sol7", "Do"])
        #expect(analisis.cifrados[1] == "V7/ii")
        #expect(
            analisis.escalas.map { $0?.nombre } == [
                "Do mayor", "La frigio dominante", "Re dórico", "Re mixolidio", "Sol mixolidio", "Do mayor",
            ])
    }

    @Test func prestamoNapolitanaYCromaticos() {
        #expect(escalas(["Do", "Fam", "Do"], en: Tonalidad(.do))[1] == "Fa dórico")
        #expect(escalas(["Do", "Lab", "Do"], en: Tonalidad(.do))[1] == "La♭ lidio")
        #expect(escalas(["Do", "Sib7", "Do"], en: Tonalidad(.do))[1] == "Si♭ lidio dominante")
        #expect(escalas(["Reb", "Sol7", "Do"], en: Tonalidad(.do))[0] == "Re♭ lidio")
        // El sustituto tritonal.
        #expect(escalas(["Rem7", "Reb7", "Do7M"], en: Tonalidad(.do))[1] == "Re♭ lidio dominante")
    }

    @Test func cuandoLaTonalidadNoBasta() {
        // Sol7(♭9) no cabe en Sol mixolidio: de las que lo contienen, la frigio dominante es la que menos notas
        // saca de Do mayor.
        #expect(Tonalidad(.do).escalaDelAcorde(Acorde("Sol7(b9)"))?.nombre == "Sol frigio dominante")
        #expect(Tonalidad(.do).escalaDelAcorde(Acorde("Rem7"), siguiente: Acorde("Sol7"))?.nombre == "Re dórico")
        // La escala propuesta siempre tiene todas las notas del acorde.
        let analisis = Tonalidad(.do).analizar(["Do7M", "Mi7", "Lam7", "Re7", "Rem7", "Sol7(b9)", "Do6"])
        for (analizado, escala) in zip(analisis.acordes, analisis.escalas) {
            #expect(escala?.contiene(acorde: analizado.acorde) == true)
        }
    }

    // MARK: Acordes que caben

    @Test func acordesQueCabenEnUnGrado() {
        let primero = Escala(.do, .mayor).acordesQueCaben(grado: 1)
        let tipos: [TipoDeAcorde] = [
            .mayor, .sus2, .sus4, .mayorSexta, .mayorSeptimaMayor, .mayorSextaNovena, .mayorSeptimaMayorNovena,
            .mayorNovenaAnadida,
        ]
        for tipo in tipos { #expect(primero.contains(Acorde(.do, tipo)), Comment(rawValue: tipo.description)) }
        #expect(!primero.contains(Acorde("Do7"))) // le falta el si♭
        #expect(!primero.contains(Acorde(.do, .potencia)))
        // De los de menos notas a los de más.
        let cuantas = primero.map(\.notas.count)
        #expect(cuantas == cuantas.sorted())
        // Sobre el 5.º, la dominante con sus tensiones diatónicas, pero no las alteradas.
        let quinto = Escala(.do, .mayor).acordesQueCaben(grado: 5)
        #expect(quinto.contains(Acorde("Sol7")) && quinto.contains(Acorde(.sol, .dominanteDecimotercera)))
        #expect(!quinto.contains(Acorde("Sol7(b9)")))
        #expect(Escala(.do, .frigioDominante).acordesQueCaben(grado: 1).contains(Acorde("Do7(b9)")))
        // Uno por grado.
        #expect(Escala(.do, .mayor).acordesQueCaben.count == 7)
        #expect(Escala(.do, .mayor).acordesQueCaben.allSatisfy { !$0.isEmpty })
    }

    @Test func estructurasSuperiores() {
        let lidio = Escala(.do, .lidio).estructurasSuperiores(sobre: Acorde("Do7M"))
        #expect(lidio.map(\.cifrado) == ["Re", "Sim", "Sol", "Lam"])
        let mixolidio = Escala(.do, .mixolidio).estructurasSuperiores(sobre: Acorde("Do7"))
        #expect(mixolidio.map(\.cifrado) == ["Solm", "Lam"])
        // La de tríadas de la disminuida semitono-tono: La y Fa♯ sobre Do7, con la 13, la ♭9 y la ♯11.
        let disminuida = Escala(.do, .disminuidaSemitonoTono).estructurasSuperiores(sobre: Acorde("Do7"))
        #expect(disminuida.contains(Acorde(.la, .mayor)))
        #expect(disminuida.contains(Acorde(Nota(.fa, .sostenido), .mayor)))
        #expect(TipoDeAcorde.paraEscalas.count == Set(TipoDeAcorde.paraEscalas).count)
    }

    @Test func lasEscalasParaAcordes() {
        #expect(TipoDeEscala.paraAcordes.count == Set(TipoDeEscala.paraAcordes).count)
        #expect(TipoDeEscala.paraAcordes.allSatisfy { TipoDeEscala.occidentales.contains($0) })
        #expect(TipoDeEscala.familiasDeModos.first == .mayor)
        #expect(TipoDeEscala.deJazz.starts(with: TipoDeEscala.paraAcordes))
        #expect(TipoDeEscala.deJazz.count == Set(TipoDeEscala.deJazz).count)
    }
}
