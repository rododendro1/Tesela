import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Las escalas de la India: melakartas, thāṭs, rāgas, grāmas y mūrchanās.
@Suite struct EscalasDeLaIndiaTests {
    @Test func melakarta() {
        #expect(TipoDeEscala.melakartas.count == 72)
        #expect(Set(TipoDeEscala.melakartas.map { $0.intervalos.map(\.semitonos) }).count == 72)
        #expect(TipoDeEscala.melakarta(15)?.nombre == "Māyāmālavagauḷa")
        #expect(TipoDeEscala.melakarta(29) == .mayor)
        #expect(TipoDeEscala.melakarta(65) == .lidio)
        #expect(TipoDeEscala.melakarta(22) == .dorico)
        #expect(TipoDeEscala.melakarta(20) == .menorNatural)
        #expect(TipoDeEscala.melakarta(8) == .frigio)
        #expect(TipoDeEscala.melakarta(28) == .mixolidio)
        #expect(TipoDeEscala.melakarta(21) == .menorArmonica)
        // Gaurīmanoharī sube y baja igual; la menor melódica clásica baja como la natural.
        #expect(TipoDeEscala.melakarta(23)?.intervalos == TipoDeEscala.menorMelodica.intervalos)
        #expect(TipoDeEscala.melakarta(23) != .menorMelodica)
        #expect(TipoDeEscala.melakarta(23) == .menorMelodicaJazz)
        #expect(TipoDeEscala.melakarta(0) == nil)
        #expect(TipoDeEscala.melakarta(73) == nil)
        // Mayamalavagowla, el thāṭ Bhairav y el dromos Hitzazkiar son la misma escala.
        #expect(TipoDeEscala.melakarta(15) == .bhairav)
        #expect(TipoDeEscala.melakarta(15) == .hitzazkiar)
        // Ri3 y Ga1, Dha3 y Ni1 con su escritura tradicional.
        #expect(
            Escala(.do, TipoDeEscala.melakarta(1)!).notas.map(\.nombre) == [
                "Do", "Re♭", "Mi𝄫", "Fa", "Sol", "La♭", "Si𝄫",
            ])
        #expect(
            Escala(.do, TipoDeEscala.melakarta(36)!).notas.map(\.nombre) == [
                "Do", "Re♯", "Mi", "Fa", "Sol", "La♯", "Si",
            ])
        #expect(TipoDeEscala.mayor.numeroDeMelakarta == 29)
        #expect(TipoDeEscala.menorArmonica.numeroDeMelakarta == 21)
        #expect(TipoDeEscala.niavent.numeroDeMelakarta == 57)
        #expect(TipoDeEscala.pentatonicaMayor.numeroDeMelakarta == nil)
        #expect(TipoDeEscala.mayorArmonica.numeroDeMelakarta == 27) // Sarasangi
        for n in 1...72 {
            #expect(TipoDeEscala.melakarta(n)?.numeroDeMelakarta == n)
        }
    }

    @Test func thaats() {
        #expect(TipoDeEscala.thaats.count == 10)
        #expect(TipoDeEscala.bilaval == .mayor)
        #expect(TipoDeEscala.kalyan == .lidio)
        #expect(TipoDeEscala.khamaj == .mixolidio)
        #expect(TipoDeEscala.kafi == .dorico)
        #expect(TipoDeEscala.asavari == .menorNatural)
        #expect(TipoDeEscala.bhairavi == .frigio)
        #expect(Escala(.do, .todi).notas.map(\.nombre) == ["Do", "Re♭", "Mi♭", "Fa♯", "Sol", "La♭", "Si"])
        #expect(Escala(.do, .marva).notas.map(\.nombre) == ["Do", "Re♭", "Mi", "Fa♯", "Sol", "La", "Si"])
        #expect(Escala(.do, .purvi).notas.map(\.nombre) == ["Do", "Re♭", "Mi", "Fa♯", "Sol", "La♭", "Si"])
    }

    @Test func ragasDastgahCoreanasAndinasYGriegas() {
        func notas(_ tipo: TipoDeEscala) -> String { Escala(.do, tipo).notas.map(\.description).joined(separator: " ") }
        #expect(notas(.malkauns) == "Do Mi♭ Fa La♭ Si♭")
        #expect(notas(.durga) == "Do Re Fa Sol La")
        #expect(notas(.yaman) == "Do Re Mi Fa♯ Sol La Si")
        #expect(notas(.bagesri) == "Do Mi♭ Fa La Si♭")
        #expect(
            Escala(.do, .bagesri.formaDescendente).notas.map(\.description).joined(separator: " ")
                == "Do Re Mi♭ Fa La Si♭")
        #expect(notas(.des) == "Do Re Fa Sol Si")
        #expect(TipoDeEscala.des.esDireccional)
        #expect(TipoDeEscala.malkauns == .hindolam)
        #expect(TipoDeEscala.bhupali == .pentatonicaMayor)
        #expect(TipoDeEscala.yaman == .kalyan)
        #expect(TipoDeEscala.mahur == .mayor)
        #expect(TipoDeEscala.homayun == .frigioDominante)
        #expect(TipoDeEscala.cahargah == .dobleArmonica)
        #expect(notas(.pyongjo) == "Do Re Fa Sol La")
        #expect(notas(.ujo) == "Do Re Mi Sol La")
        #expect(TipoDeEscala.ujo == .pentatonicaMayor && TipoDeEscala.ujo.tradicion == .corea)
        #expect(notas(.kyemyonjo) == "Do Mi♭ Fa Sol Si♭")
        #expect(notas(.tritonicaAndina) == "Do Mi♭ Sol")
        #expect(TipoDeEscala.andina == .pentatonicaMenor)
        #expect(Escala(.mi, .tetracordoCromatico).notas.map(\.description).joined(separator: " ") == "Mi Fa Sol♭ La")
        #expect(
            Escala(.mi, .harmoniaDoriaCromatica).notas.map(\.description).joined(separator: " ")
                == "Mi Fa Sol♭ La Si Do Re♭")
        #expect(TipoDeEscala.harmoniaDoria == .frigio)
        #expect(TipoDeEscala.harmoniaFrigia == .dorico)
        #expect(TipoDeEscala.harmoniaLidia == .mayor)
        // Gaélicas y de dos tríadas, en el catálogo habitual.
        #expect(notas(.jonicoSinCuarta) == "Do Re Mi Sol La Si")
        #expect(notas(.mixolidioSinTercera) == "Do Re Fa Sol La Si♭")
        #expect(notas(.doricoSinSexta) == "Do Re Mi♭ Fa Sol Si♭")
        #expect(notas(.eolicoSinSegunda) == "Do Mi♭ Fa Sol La♭ Si♭")
        #expect(Set(Escala(.do, .hexatonicaDeDosTriadas).notas) == Set(Acorde("Do").notas + Acorde("Re").notas))
        #expect(TipoDeEscala.occidentales.count == Set(TipoDeEscala.occidentales).count)
        // Nombres.
        for (texto, nombre) in [
            ("Do Bhupali", "Bhūpālī"), ("Do malkauns", "Mālkauns"), ("Do Bageshri", "Bāgeśrī"),
            ("Do Desh", "Deś"), ("Do Chahargah", "Čahārgāh"), ("Do Homayoun", "Homāyun"),
            ("Do Pyeongjo", "P'yŏngjo"), ("Do 계면조", "Kyemyŏnjo"), ("La andina", "pentatónica andina"),
            ("Mi harmonia doria cromatica", "harmonía doria cromática"), ("Do jónico sin 4ª", "jónico sin 4ª"),
            ("C triad pair", "hexatónica de dos tríadas"),
        ] {
            #expect((try? Escala(leyendo: texto))?.tipo.nombre == nombre, Comment(rawValue: texto))
        }
    }

    @Test func gramaMurchanaYGenerosGriegos() {
        // Los grāma y las mūrchanā se encuentran sin diacríticos y en devanagari.
        #expect((try? TipoDeEscala(leyendo: "shadja grama"))?.nombre == "ṣaḍja-grāma")
        #expect((try? TipoDeEscala(leyendo: "Suddhasadja"))?.nombre == "Śuddhaṣaḍjā")
        #expect((try? TipoDeEscala(leyendo: "सौवीरी"))?.nombre == "Sauvīrī")
        #expect((try? TipoDeEscala(leyendo: "tetracordo pitagórico"))?.nombre == "tetracordo diatónico ditónico")
    }

    /// Madhuvantī, Multānī, Hindol y Sohinī, en su forma recta.
    @Test func cuatroRagasMas() {
        func notas(_ intervalos: [Intervalo]) -> String {
            intervalos.map { (Nota.do + $0).description }.joined(separator: " ")
        }
        #expect(notas(TipoDeEscala.madhuvanti.intervalos) == "Do Mi♭ Fa♯ Sol Si")
        #expect(notas(TipoDeEscala.madhuvanti.intervalosDescendentes ?? []) == "Do Re Mi♭ Fa♯ Sol La Si")
        #expect(notas(TipoDeEscala.multani.intervalosDescendentes ?? []) == "Do Re♭ Mi♭ Fa♯ Sol La♭ Si")
        #expect(notas(TipoDeEscala.hindol.intervalos) == "Do Mi Fa♯ La Si")
        #expect(notas(TipoDeEscala.sohini.intervalosDescendentes ?? []) == "Do Re♭ Mi Fa♯ La Si")
        #expect(TipoDeEscala.multani.padre == .todi && TipoDeEscala.sohini.padre == .marva)
        #expect(TipoDeEscala.buscar(nombre: "मुलतानी")?.esIdentico(a: .multani) == true)
        #expect(TipoDeEscala.buscar(nombre: "Sohni")?.esIdentico(a: .sohini) == true)
        #expect(TipoDeEscala.ragasIndostanicos.count == 19)
    }
}
