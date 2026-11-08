import Foundation
import Testing

@testable import Elementos

@Suite struct NotaTests {
    @Test func lineaDeQuintas() {
        #expect(Nota(pasosDeQuinta: 0).nombre == "Do")
        #expect(Nota(pasosDeQuinta: -1).nombre == "Fa")
        #expect(Nota(pasosDeQuinta: 5).nombre == "Si")
        #expect(Nota(pasosDeQuinta: 6).nombre == "Fa♯")
        #expect(Nota(pasosDeQuinta: -2).nombre == "Si♭")
        #expect(Nota(pasosDeQuinta: -9).nombre == "Si𝄫")
        #expect(Nota(pasosDeQuinta: 13).nombre == "Fa𝄪")
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
        #expect((try? Nota(leyendo: "Xa")) == nil)
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
            #expect((try? Intervalo(leyendo: abreviatura)) == intervalo)
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
        #expect((try? Intervalo(leyendo: "1d")) == nil)
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
        #expect(Consonancia.imperfecta.nombre(en: .ascii(.ingles)) == "imperfect consonance")
    }
}

/// Pruebas de los protocolos comunes: cada una recorre varios tipos con el mismo código genérico.
@Suite struct ProtocolosTests {
    private static let notaciones: [Notacion] = [
        .compacta(.espanol), .ascii(.espanol), .ascii(.ingles), .compacta(.ingles),
    ]
}
