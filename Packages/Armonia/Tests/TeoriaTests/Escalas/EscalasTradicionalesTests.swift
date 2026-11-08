import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Las escalas de otras tradiciones: búsqueda, nombres, diacríticos y alias.
@Suite struct EscalasTradicionalesTests {
    @Test func diacriticos() {
        // Nombres indios en AITS (IAST) y griegos con su acento.
        #expect(TipoDeEscala.melakarta(29)?.nombre == "Dhīraśaṅkarābharaṇam")
        #expect(TipoDeEscala.melakarta(56)?.nombre == "Ṣaṇmukhapriyā")
        #expect(TipoDeEscala.melakarta(65)?.nombre == "Mecakalyāṇī")
        #expect(TipoDeEscala.kafi.nombre == "Kāfī")
        #expect(TipoDeEscala.todi.nombre == "Toḍī")
        #expect(TipoDeEscala.pireotikos.nombre == "Pireótikos")
        #expect(Escala(.do, .asavari).nombre == "Do Āsāvarī")
        // La búsqueda no distingue diacríticos ni mayúsculas.
        for texto in ["Do Kafi", "Do kāfī", "Do KAFI", "Do Kāfī"] {
            #expect((try? Escala(leyendo: texto))?.tipo.nombre == "Kāfī", Comment(rawValue: texto))
        }
        #expect(Escala("Do shanmukhapriya").tipo == TipoDeEscala.melakarta(56))
        #expect(Escala("Do Sanmukhapriya").tipo == TipoDeEscala.melakarta(56))
        #expect(Escala("Do dorico") == Escala("Do dórico"))
        #expect(Escala("Re pireotikos") == Escala(.re, .pireotikos))
        // Todas las escalas se vuelven a leer desde su nombre, con diacríticos o sin ellos.
        for tipo in TipoDeEscala.tradicionales {
            #expect((try? TipoDeEscala(leyendo: tipo.nombre))?.nombre == tipo.nombre, Comment(rawValue: tipo.nombre))
        }
    }

    @Test func busquedaYNombres() {
        #expect(Escala("Re hitzaz") == Escala(.re, .hitzaz))
        #expect(Escala("Re Hicaz").tipo.nombre == "Hitzáz")
        // «Hijaz» es el nombre del maqam y gana al alias del dromos.
        #expect(Escala("Re Hijaz").tipo.nombre == "Ḥijāz")
        #expect(Escala("Do Kafi") == Escala(.do, .kafi))
        #expect(Escala("Do melakarta 15").tipo.nombre == "Māyāmālavagauḷa")
        #expect(Escala("Do mayamalavagowla").tipo == .bhairav)
        #expect((try? TipoDeEscala(leyendo: "souzinak"))?.nombre == "Nikríz")
        // Los nombres propios no se traducen…
        #expect(Escala(.re, .hitzaz).nombre(en: .ascii(.ingles)) == "D Hitzáz")
        #expect(Escala(.re, .hitzaz).texto(en: .ascii(.ingles)) == "D Hitzáz")
        // …y las escalas habituales siguen igual: los nombres de siempre van primero.
        #expect((try? TipoDeEscala(leyendo: "mayor"))?.nombre == "mayor")
        #expect(TipoDeEscala.frigioDominante.nombre(en: .ascii(.ingles)) == "phrygian dominant")
        #expect(!(TipoDeEscala.occidentales.contains { $0.nombre == "Hitzáz" }))
    }

    @Test func aliasEnGriegoYEnDevanagari() {
        // Los dromoi, por su nombre en griego, con tilde o sin ella.
        for (texto, nombre) in [
            ("Χιτζάζ", "Hitzáz"), ("χιτζαζ", "Hitzáz"), ("Χιτζαζκιάρ", "Hitzazkiár"),
            ("Ουσάκ", "Ousák"), ("Ραστ", "Rast"),
        ] {
            #expect((try? TipoDeEscala(leyendo: texto))?.nombre == nombre, Comment(rawValue: texto))
        }
        // Las escalas indias, en devanagari. Ahí las marcas cuentan: भैरव y भैरवी son dos rāgas.
        #expect((try? TipoDeEscala(leyendo: "भैरव"))?.nombre == "Bhairav")
        #expect((try? TipoDeEscala(leyendo: "भैरवी"))?.nombre == "Bhairavī")
        #expect((try? TipoDeEscala(leyendo: "यमन"))?.nombre == "Yaman")
        #expect(Escala("Re मोहनम्").tipo.nombre == Escala("Re Mohanam").tipo.nombre)
        // Los 72 mēḷa.
        #expect(TipoDeEscala.nombresDeMelakartaEnDevanagari.count == 72)
        #expect(Set(TipoDeEscala.nombresDeMelakartaEnDevanagari).count == 72)
        for (devanagari, nombre) in zip(TipoDeEscala.nombresDeMelakartaEnDevanagari, TipoDeEscala.nombresDeMelakarta) {
            #expect((try? TipoDeEscala(leyendo: devanagari))?.nombre == nombre, Comment(rawValue: devanagari))
        }
    }

    @Test func etiopesMaqamatIndonesiaYKlezmer() {
        func notas(_ tipo: TipoDeEscala) -> String { Escala(.do, tipo).notas.map(\.description).joined(separator: " ") }
        #expect(notas(.tezetaMayor) == "Do Re Mi Sol La")
        #expect(notas(.tezetaMenor) == "Do Re Mi♭ Sol La♭")
        #expect(notas(.batiMayor) == "Do Mi Fa Sol Si")
        #expect(notas(.batiMenor) == "Do Mi♭ Fa Sol Si♭")
        #expect(notas(.ambassel) == "Do Re♭ Fa Sol La♭")
        #expect(notas(.anchihoye) == "Do Re♭ Fa Sol♭ La")
        #expect(notas(.pelog) == "Do Re♭ Mi♭ Sol La♭")
        #expect(notas(.slendro) == "Do Re Fa Sol Si♭")
        #expect(notas(.akebono) == "Do Re Mi♭ Sol La")
        #expect(notas(.kokinjoshi) == "Do Re♭ Fa Sol Si♭")
        #expect(notas(.adonaiMalakh) == "Do Re Mi♭ Mi Fa Sol La Si♭")
        #expect(notas(.argelina) == "Do Re Mi♭ Fa Fa♯ Sol La♭ Si")
        // Los maqamat temperados y los modos klezmer son escalas que ya había, con otro nombre.
        #expect(TipoDeEscala.hiyaz == .frigioDominante)
        #expect(TipoDeEscala.nahawand == .menorArmonica)
        #expect(TipoDeEscala.kurd == .frigio)
        #expect(TipoDeEscala.ajam == .mayor)
        #expect(TipoDeEscala.hiyazkar == .dobleArmonica)
        #expect(TipoDeEscala.nawaAthar == .menorHungara)
        #expect(TipoDeEscala.freygish == .frigioDominante)
        #expect(TipoDeEscala.misheberakh == .doricoCuartaAumentada)
        #expect(TipoDeEscala.magenAvot == .menorNatural)
        #expect(TipoDeEscala.frigioDominante.equivalentes.map(\.nombre).contains("Ḥijāz"))
        // Con diacríticos y sin ellos, y en su escritura.
        #expect(Escala("Do Təzəta menor").tipo.nombre == "Təzəta menor")
        #expect(Escala("Do Tezeta menor").tipo.nombre == "Təzəta menor")
        #expect(Escala("Do Tizita").tipo.nombre == "Təzəta mayor")
        #expect(Escala("Do anchihoye").tipo.nombre == "Ančihoye")
        #expect(Escala("Re Nahawand").tipo.nombre == "Nahāwand")
        #expect(Escala("Re Ajam").tipo.nombre == "ʿAjam")
        #expect(Escala("Re حجاز").tipo.nombre == "Ḥijāz")
        #expect(Escala("Do pelog").tipo.nombre == "Pélog selisir")
        #expect(Escala("Do slendro").tipo.nombre == "Sléndro")
        #expect(Escala("Do Kokin-joshi").tipo.nombre == "Kokin-jōshi")
        #expect(Escala("Mi gitana española").tipo == .flamenca)
        #expect(Escala("C Algerian").tipo == .argelina)
        #expect(Escala(.re, .nahawand).nombre(en: .ascii(.ingles)) == "D Nahāwand")
        // Las tradicionales no entran en las búsquedas de escalas habituales.
        #expect(!(TipoDeEscala.occidentales.contains { $0.nombre == "Ḥijāz" }))
    }
}
