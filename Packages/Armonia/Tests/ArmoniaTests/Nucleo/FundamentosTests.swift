import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

@Suite struct NotaTests {
    @Test func lineaDeQuintas() {
        #expect(Nota(pasosDeQuinta: 0).nombre == "Do")
        #expect(Nota(pasosDeQuinta: -1).nombre == "Fa")
        #expect(Nota(pasosDeQuinta: 5).nombre == "Si")
        #expect(Nota(pasosDeQuinta: 6).nombre == "Fa♯")
        #expect(Nota(pasosDeQuinta: -2).nombre == "Si♭")
        #expect(Nota(pasosDeQuinta: -9).nombre == "Si♭♭")
        #expect(Nota(pasosDeQuinta: 13).nombre == "Fa♯♯")
    }

    @Test func letraYAlteracion() {
        #expect(Nota(.fa, 1).pasosDeQuinta == 6)
        #expect(Nota(.mi, -1).pasosDeQuinta == -3)
        #expect(Nota(pasosDeQuinta: -3).natural == .mi)
        #expect(Nota(pasosDeQuinta: -3).alteracion == -1)
    }

    @Test func analisisDeTexto() {
        #expect(Nota("Sib") == Nota(.si, -1))
        #expect(Nota("fa#") == Nota(.fa, 1))
        #expect(Nota("Solx") == Nota(.sol, 2))
        #expect(Nota("Mi♭♭") == Nota(.mi, -2))
        #expect(Nota("Bb") == Nota(.si, -1))
        #expect(Nota("C#") == Nota(.do, 1))
        #expect(Nota(texto: "Xa") == nil)
    }

    @Test func enarmonia() {
        let faSostenido = Nota("Fa#")
        let solBemol = Nota("Solb")
        #expect(faSostenido != solBemol)
        #expect(faSostenido.esEnarmonica(de: solBemol))
        #expect(faSostenido.claseDeAltura == 6)
        #expect(Nota("Mi#").enarmonicaMasSimple == .fa)
        #expect(Nota("Dob").enarmonicaMasSimple == .si)
    }

    @Test func intervaloEntreNombres() {
        #expect(Nota.do.intervalo(hasta: .mi) == .terceraMayor)
        #expect(Nota.mi.intervalo(hasta: .do) == .sextaMenor)
        #expect(Nota.si.intervalo(hasta: .fa) == .quintaDisminuida)
        #expect(Nota.fa.intervalo(hasta: .si) == .cuartaAumentada)
        #expect((Nota.re + .terceraMayor) == Nota("Fa#"))
    }
}

@Suite struct AlteracionTests {
    @Test func valoresYNombres() throws {
        #expect(Alteracion.sostenido.semitonos == 1)
        #expect(Alteracion.dobleBemol == -2)
        #expect(Alteracion(3).nombre == "triple sostenido")
        #expect(Alteracion(-2).nombre == "doble bemol")
        #expect(Alteracion(-5).nombre == "5 bemoles")
        #expect(Alteracion.natural.nombre == "natural")
        #expect(Alteracion(2).nombre(en: .inglesASCII) == "double sharp")
        #expect(Alteracion(-1).nombre(en: .inglesASCII) == "flat")
        #expect(Alteracion(2).simbolo == "♯♯")
        #expect(Alteracion(-2).simboloASCII == "bb")
        #expect(Alteracion(3).simboloCompacto == "𝄪♯")
        #expect(Alteracion(-2).simboloCompacto == "𝄫")
        #expect(Alteracion.natural.simboloCompacto == "♮")
        #expect(Tipografia.allCases.map { Alteracion(-2).simbolo(en: $0) } == ["♭♭", "bb", "𝄫"])
        #expect(Tipografia.allCases.map { Alteracion(3).simbolo(en: $0) } == ["♯♯♯", "###", "𝄪♯"])
        #expect(Tipografia.allCases.map { Alteracion.natural.simbolo(en: $0) } == ["", "", "♮"])
        for tipografia in Tipografia.allCases {
            for n in -4...4 where n != 0 {
                #expect(try (Alteracion(leyendo: Alteracion(n).simbolo(en: tipografia))) == Alteracion(n))
            }
        }
        #expect(Notacion.espanolUnicode.tipografia == .unicode)
        #expect(Notacion.inglesASCII.tipografia == .ascii)
        #expect(Notacion.espanolASCII.tipografia == .ascii)
        #expect(Notacion.frances.tipografia == .unicode)
        #expect(Alteracion(-2).numeroDeSignos == 2)
        #expect(Alteracion.sostenido.pasosDeQuinta == 7)
        #expect(Alteracion.bemol.esBemol)
        #expect(Alteracion.natural.esNatural)
        #expect((Alteracion.sostenido + .sostenido) == .dobleSostenido)
        #expect(-Alteracion.sostenido == .bemol)
        #expect(Alteracion.bemol < .natural)
    }

    @Test func lectura() throws {
        let casos: [(String, Int)] = [
            ("#", 1), ("♯", 1), ("x", 2), ("𝄪", 2), ("##", 2), ("#x", 3), ("b", -1),
            ("bb", -2), ("𝄫", -2), ("♭♭♭", -3), ("", 0), ("♮", 0), ("n", 0),
            ("sostenido", 1), ("doble bemol", -2), ("Triple Sharp", 3), ("natural", 0),
        ]
        for (texto, semitonos) in casos {
            #expect(Alteracion(texto: texto)?.semitonos == semitonos, Comment(rawValue: texto))
        }
        do {
            _ = try Alteracion(leyendo: "#?")
            Issue.record("Se esperaba un error")
        } catch {
            #expect((error as? ErrorDeLectura)?.motivo == .alteracionNoReconocida("?"))
            #expect((error as? ErrorDeLectura)?.posicion == 1)

        }
        let literal: Alteracion = "bb"
        #expect(literal == -2)
        for n in -4...4 {
            let a = Alteracion(n)
            for notacion in Notacion.allCases {
                #expect(Alteracion(texto: a.texto(en: notacion)) == a, "\(n) \(notacion)")
            }
        }
    }

    @Test func enLosNombresDeNota() {
        #expect(Nota(.fa, .sostenido) == Nota("Fa#"))
        #expect(Nota(.si, -2).nombre == "Si♭♭")
        #expect(Nota("Mibb").alteracion == .dobleBemol)
        #expect(Nota.re.alteracion == .natural)
        #expect(Clave.sol.posicion(de: "Fa#4").alteracion == .sostenido)
        #expect(Clave.sol.altura(lugar: 4, alteracion: .bemol) == Altura("Sib4"))
    }
}

@Suite struct AlturaTests {
    @Test func coordenadasYMidi() {
        #expect(Altura.doCentral.midi == 60)
        #expect(Altura("La4") == Altura(pasosDeQuinta: 3, pasosDeOctava: -1))
        #expect(Altura("La4").midi == 69)
        #expect(Altura("Re4") == Altura(pasosDeQuinta: 2, pasosDeOctava: -1))
        #expect(Altura("Sib3").midi == 58)
        #expect(Altura("Do-1").midi == 0)
    }

    @Test func octavaCientifica() {
        #expect(Altura("Dob4").midi == 59)
        #expect(Altura("Dob4").octava == 4)
        #expect(Altura("Si#3").midi == 60)
        #expect(Altura("Si#3").octava == 3)
        #expect(Altura("Si3").description == "Si3")
        #expect(Altura("Si#3") < Altura("Do4"))
    }

    @Test func desdeMidi() {
        #expect(Altura(midi: 61).description == "Do♯4")
        #expect(Altura(midi: 61, preferirBemoles: true).description == "Re♭4")
        #expect(Altura(midi: 65).description == "Fa4")
        #expect(Altura(midi: 71, preferirBemoles: true).description == "Si4")
        for midi in 0...127 {
            #expect(Altura(midi: midi).midi == midi)
            #expect(Altura(midi: midi, preferirBemoles: true).midi == midi)
        }
    }

    @Test func frecuencias() {
        #expect(abs(Altura("La4").frecuencia() - (440)) <= 1e-9)
        #expect(abs(Altura("La5").frecuencia() - (880)) <= 1e-9)
        #expect(abs(Altura("Mi5").frecuencia(en: TemperamentoRegular.pitagorico) - (660)) <= 1e-9)
        #expect(abs(Altura("Do4").frecuencia(en: TemperamentoRegular.pitagorico) - (440 * 16 / 27)) <= 1e-9)
    }

    @Test func transposicion() {
        #expect((Altura("Do4") + .novenaMayor) == Altura("Re5"))
        #expect((Altura("Do4") - .terceraMenor) == Altura("La3"))
        #expect((Altura("Re5") - Altura("Do4")) == .novenaMayor)
    }

    @Test func octavaCientificaYNombreDeNota() {
        let la4: Altura = "La4"
        #expect(la4.octava == 4)
        #expect(la4.pasosDeOctava == -1) // la coordenada, que no es la octava científica
        #expect(la4.nota == .la)
        #expect(Altura("Si#3").octava == 3)
        #expect(Altura(.do, octava: 5).octava == 5)
    }
}

@Suite struct IntervaloTests {
    @Test func coordenadas() {
        #expect(Intervalo.quintaJusta.pasosDeQuinta == 1)
        #expect(Intervalo.quintaJusta.pasosDeOctava == 0)
        #expect(Intervalo.segundaMayor.pasosDeQuinta == 2)
        #expect(Intervalo.segundaMayor.pasosDeOctava == -1)
        #expect(Intervalo.terceraMenor.pasosDeQuinta == -3)
        #expect(Intervalo.terceraMenor.pasosDeOctava == 2)
        #expect(Intervalo.octava.pasosDeQuinta == 0)
        #expect(Intervalo.octava.pasosDeOctava == 1)
    }

    @Test func semitonosYCalidad() {
        let esperados: [(Intervalo, Int, String)] = [
            (.unisono, 0, "1J"), (.segundaMenor, 1, "2m"), (.segundaMayor, 2, "2M"),
            (.terceraMenor, 3, "3m"), (.terceraMayor, 4, "3M"), (.cuartaJusta, 5, "4J"),
            (.cuartaAumentada, 6, "4A"), (.quintaDisminuida, 6, "5d"), (.quintaJusta, 7, "5J"),
            (.sextaMenor, 8, "6m"), (.sextaMayor, 9, "6M"), (.septimaDisminuida, 9, "7d"),
            (.septimaMenor, 10, "7m"), (.septimaMayor, 11, "7M"), (.octava, 12, "8J"),
            (.novenaMayor, 14, "9M"), (.decimoterceraMayor, 21, "13M"),
        ]
        for (intervalo, semitonos, abreviatura) in esperados {
            #expect(intervalo.semitonos == semitonos, Comment(rawValue: abreviatura))
            #expect(intervalo.abreviatura == abreviatura)
            #expect(Intervalo(texto: abreviatura) == intervalo)
        }
    }

    @Test func multiplesAlteraciones() {
        let dobleAumentada = Intervalo(numero: 4, calidad: .aumentada(2))!
        #expect(dobleAumentada.semitonos == 7)
        #expect(dobleAumentada.calidad.nombre == "doble aumentada")
        #expect(Intervalo(numero: 5, calidad: .mayor) == nil)
        #expect(Intervalo(numero: 3, calidad: .justa) == nil)
    }

    @Test func direccion() {
        let i = Altura("Mi4").intervalo(hasta: Altura("Do4"))
        #expect(i.sentido == .descendente)
        #expect(i.ascendente == .terceraMayor)
        #expect(i.semitonosConSigno == -4)
        #expect(i == -Intervalo.terceraMayor)
        #expect(Intervalo("-3M") == i)
    }

    @Test func inversionYReduccion() {
        #expect(Intervalo.terceraMayor.inversion == .sextaMenor)
        #expect(Intervalo.cuartaAumentada.inversion == .quintaDisminuida)
        #expect(Intervalo.segundaMenor.inversion == .septimaMayor)
        #expect(Intervalo.unisono.inversion == .octava)
        #expect(Intervalo.octava.inversion == .unisono)
        #expect(Intervalo.novenaMayor.simple == .segundaMayor)
        #expect(Intervalo.novenaMayor.esCompuesto)
        #expect(!Intervalo.octava.esCompuesto)
    }

    @Test func aritmetica() {
        #expect((Intervalo.terceraMayor + .terceraMenor) == .quintaJusta)
        #expect((Intervalo.quintaJusta - .terceraMayor) == .terceraMenor)
        #expect((Intervalo.cuartaJusta + .quintaJusta) == .octava)
        #expect((Intervalo.quintaJusta - .octava) == -Intervalo.cuartaJusta)
        #expect((2 * Intervalo.quintaJusta) == .novenaMayor)
        #expect(Intervalo.cuartaAumentada.esEnarmonico(de: .quintaDisminuida))
    }

    @Test func intervalosComparables() {
        #expect(
            [Intervalo.quintaJusta, .terceraMayor, .quintaDisminuida, .cuartaAumentada].sorted() == [
                .terceraMayor, .cuartaAumentada, .quintaDisminuida, .quintaJusta,
            ])
        #expect(-Intervalo.segundaMayor < .unisono)
        #expect(Intervalo.septimaMayor < .octava)
    }
}

@Suite struct IntervalosYConsonanciaTests {
    @Test func unisonoDisminuidoNoExiste() throws {
        #expect(Intervalo(numero: 1, calidad: .disminuida(1)) == nil)
        #expect(Intervalo(texto: "1d") == nil)
        #expect(Intervalo(numero: 8, calidad: .disminuida(1)) != nil)
        do {
            _ = try Intervalo(leyendo: "1d")
            Issue.record("Se esperaba un error")
        } catch {
            #expect("\(error)".contains("unísono aumentado descendente"), "\(error)")

        }
        // De Do a Do♭ hay un unísono aumentado descendente.
        #expect(Altura("Do4").intervalo(hasta: Altura("Dob4")).abreviatura == "-1A")
    }

    @Test func claseIntervalica() {
        let casos: [(Intervalo, Int)] = [
            (.terceraMayor, 4), (.sextaMenor, 4), (.cuartaAumentada, 6), (.quintaDisminuida, 6),
            (.novenaMenor, 1), (.septimaMayor, 1), (.octava, 0), (.unisono, 0), (-Intervalo.terceraMayor, 4),
        ]
        for (intervalo, clase) in casos {
            #expect(intervalo.claseIntervalica == clase, Comment(rawValue: intervalo.nombre))
        }
    }

    @Test func consonancia() {
        let casos: [(Intervalo, Consonancia)] = [
            (.unisono, .perfecta), (.octava, .perfecta), (.quintaJusta, .perfecta), (.cuartaJusta, .perfecta),
            (.terceraMenor, .imperfecta), (.terceraMayor, .imperfecta), (.sextaMenor, .imperfecta),
            (.sextaMayor, .imperfecta), ("10M", .imperfecta), ("12J", .perfecta),
            (.segundaMayor, .disonancia), (.septimaMenor, .disonancia), (.cuartaAumentada, .disonancia),
            (.quintaDisminuida, .disonancia), (.terceraDisminuida, .disonancia),
            (.segundaAumentada, .disonancia), (.unisonoAumentado, .disonancia),
        ]
        for (intervalo, consonancia) in casos {
            #expect(intervalo.consonancia() == consonancia, Comment(rawValue: intervalo.nombre))
        }
        #expect(Intervalo.cuartaJusta.consonancia(cuartaDisonante: true) == .disonancia)
        #expect(Intervalo.sextaMayor.esConsonante)
        #expect(!Intervalo.segundaAumentada.esConsonante)
        #expect(Consonancia.imperfecta.nombre(en: .inglesASCII) == "imperfect consonance")
    }
}

/// Pruebas de los protocolos comunes: cada una recorre varios tipos con el mismo código genérico.
@Suite struct ProtocolosTests {
    private static let notaciones: [Notacion] = [.espanolUnicode, .espanolASCII, .inglesASCII, .inglesUnicode]

    private func comprobarIdaYVuelta<T: RepresentableComoTexto & Equatable>(
        _ valores: [T], sourceLocation: SourceLocation = #_sourceLocation
    ) {
        for valor in valores {
            for notacion in Self.notaciones {
                let texto = valor.texto(en: notacion)
                #expect((try? T(leyendo: texto)) == valor, "«\(texto)»", sourceLocation: sourceLocation)
            }
        }
    }

    @Test func representableComoTexto() {
        comprobarIdaYVuelta((-14...14).map { Nota(pasosDeQuinta: $0) })
        comprobarIdaYVuelta(["Do4", "Fa#3", "Sibb-1", "Si#3", "C#5"] as [Altura])
        comprobarIdaYVuelta([Intervalo.terceraMayor, .quintaDisminuida, -Intervalo.novenaMenor, "4AA", .octava])
        comprobarIdaYVuelta(TipoDeAcorde.todos)
        comprobarIdaYVuelta(["Sol7(b9)/Si", "Fa#m7b5", "Do/Re", "Mib6/9", "Faug", "Sibmaj7#11"] as [Acorde])
        comprobarIdaYVuelta(TipoDeEscala.todos.map { Escala("Fa#", $0) })

        #expect(Acorde("Sib7(b9)/Re").texto(en: .inglesASCII) == "Bb7(b9)/D")
        #expect(Intervalo.terceraMayor.texto(en: .inglesASCII) == "M3")
        #expect(Intervalo.terceraMayor.texto == "3M")
        #expect(Altura("Fa#3").texto == "Fa♯3")
        #expect(Escala("Re dórico").texto(en: .inglesUnicode) == "D dorian")
    }

    @Test func loQueAportaElProtocolo() throws {
        // init?(_:) y el literal de texto vienen de RepresentableComoTexto.
        #expect(Nota(texto: "Xa") == nil)
        #expect(TipoDeAcorde(texto: "7(b3)") == nil)
        let nota: Nota = "Sol#"
        #expect(nota == Nota(.sol, 1))
        let tipo: TipoDeAcorde = "m7(b5)"
        #expect(tipo == .semidisminuido)

        // Codable también: cada tipo se codifica como su texto español.
        let valores: [Intervalo] = ["3M", "-5d"]
        let datos = try JSONEncoder().encode(valores)
        #expect(String(decoding: datos, as: UTF8.self) == "[\"3M\",\"-5d\"]")
        #expect(try (JSONDecoder().decode([Intervalo].self, from: datos)) == valores)
    }

    @Test func nombrable() {
        let casos: [(any Nombrable, String, String)] = [
            (NotaNatural.re, "Re", "D"),
            (Nota("Fa#"), "Fa♯", "F#"),
            (Altura("Sib3"), "Si♭3", "Bb3"),
            (Intervalo.terceraMayor, "3ª mayor", "major third"),
            (CalidadDeIntervalo.justa, "justa", "perfect"),
            (Consonancia.perfecta, "consonancia perfecta", "perfect consonance"),
            (TipoDeAcorde.dominanteSeptima, "séptima de dominante", "dominant seventh"),
            (Acorde("Sol7/Si"), "Sol séptima de dominante, primera inversión", "G dominant seventh, first inversion"),
            (TipoDeEscala.dorico, "dórico", "dorian"),
            (Escala("Re dórico"), "Re dórico", "D dorian"),
            (NombreDeGrado.dominante, "dominante", "dominant"),
            (Clave.fa, "clave de fa", "bass clef"),
            (InstrumentoDePartitura.trompaEnFa, "trompa en fa", "horn in F"),
            (PapelEnAcorde.tension(9), "novena", "ninth"),
            (CalidadDeTriada.aumentada, "aumentada", "augmented"),
        ]
        for (valor, espanol, ingles) in casos {
            #expect(valor.nombre(en: .espanolUnicode) == espanol)
            #expect(valor.nombre(en: .inglesASCII) == ingles)
            #expect(valor.nombre(en: .inglesASCII) == ingles)
        }
    }

    @Test func transponible() {
        func subirQuinta<T: Transponible>(_ valor: T) -> T { valor + .quintaJusta }

        #expect(subirQuinta(Nota.do) == .sol)
        #expect(subirQuinta(Altura("Do4")) == Altura("Sol4"))
        #expect(subirQuinta(Acorde("Do7")).cifrado == "Sol7")
        #expect(subirQuinta(Escala(.do)) == Escala(.sol))
        #expect(subirQuinta(Melodia(["Do4", "Mi4"])).description == "Sol4 Si4")
        #expect(subirQuinta(ConjuntoDeClases([0, 4, 7])) == [7, 11, 2])

        #expect(Nota.do.secuencia(.quintaJusta, veces: 3) == [.do, .sol, .re, .la])
        #expect(Nota.do.transponer(.quintaJusta, veces: 12) == Nota("Si#"))
        #expect((Escala(.do) - .segundaMayor) == Escala(Nota("Sib")))
        #expect((Acorde("Do/Mi") + .terceraMayor) == Acorde("Mi/Sol#"))
    }

    @Test func conClasesDeAltura() {
        #expect(Acorde("Sol7").numeroDeForte == "4-27")
        #expect(Escala(.re).numeroDeForte == "7-35")
        #expect(Melodia(["Do4", "Mi4", "Sol4"]).numeroDeForte == "3-11")
        #expect(Acorde("Do").vectorIntervalico == [0, 0, 1, 1, 1, 0])
        #expect(Acorde("Do").esDeLaMismaClase(que: Acorde("Lam")))
        #expect(Acorde("Do").esDeLaMismaClase(que: Melodia(["La3", "Do4", "Mi4"])))
        #expect(!(Acorde("Do").esDeLaMismaClase(que: Acorde("Do+"))))
        #expect(Escala(.do).esDeLaMismaClase(que: Escala(.la, .menorNatural)))
        #expect(ConjuntoDeClases([0, 4, 7]).esDeLaMismaClase(que: Acorde("Rem")))
    }

    @Test func losExtremosYElMenor() {
        #expect([3, 1, 2].extremos == (1...3))
        let ninguno: ClosedRange<Int>? = [Int]().extremos
        #expect(ninguno == nil)
        #expect([5].extremosOSi(noHay: 0...0) == (5...5))
        #expect([Int]().extremosOSi(noHay: 0...0) == (0...0))
        #expect([3, -4, 2].menor(siNoHay: 0) { abs($0) < abs($1) } == 2)
        #expect([Int]().menor(siNoHay: 7) { $0 < $1 } == 7)
    }
}
