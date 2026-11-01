import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

@Suite struct EscalaTests {
    @Test func testNotas() {
        #expect(Escala(.re).notas.map(\.nombre) == ["Re", "Mi", "Fa♯", "Sol", "La", "Si", "Do♯"])
        #expect(Escala("Fa mayor").notas.map(\.nombre) == ["Fa", "Sol", "La", "Si♭", "Do", "Re", "Mi"])
        #expect(Escala("La menor armónica").grado(7) == Nota("Sol#"))
        #expect(Escala("Re dórico").notas == Escala(.do).rotacion(2).notas)
        #expect(Escala(.do).rotacion(5).tipo == .mixolidio)
    }

    @Test func armadura() {
        #expect(Escala(.do).armadura == 0)
        #expect(Escala("Re mayor").armadura == 2)
        #expect(Escala("Mib mayor").armadura == -3)
        #expect(Escala("Fa# mayor").armadura == 6)
        #expect(Escala("Do menor").armadura == -3)
        #expect(Escala("Mi dórico").armadura == 2)
        #expect(Escala("La menor armónica").armadura == nil)
    }

    @Test func relativas() {
        #expect(Tonalidad(.do).relativa == Tonalidad(.la, .menor))
        #expect(Tonalidad("Sol menor").relativa == Tonalidad(Nota("Sib")))
    }

    @Test func armonizacionMayor() {
        let e = Escala(.do)
        #expect(e.armonizar().map { $0?.cifrado } == ["Do", "Rem", "Mim", "Fa", "Sol", "Lam", "Si°"])
        #expect(e.cifradosRomanos() == ["I", "ii", "iii", "IV", "V", "vi", "vii°"])
        #expect(e.cifradosRomanos(cuatriadas: true) == ["Imaj7", "ii7", "iii7", "IVmaj7", "V7", "vi7", "viiø7"])
    }

    @Test func armonizacionMenor() {
        let armonica = Escala(.la, .menorArmonica)
        #expect(armonica.cifradosRomanos() == ["i", "ii°", "♭III+", "iv", "V", "♭VI", "vii°"])
        #expect(
            armonica.cifradosRomanos(cuatriadas: true) == [
                "i(maj7)", "iiø7", "♭III+maj7", "iv7", "V7", "♭VImaj7", "vii°7",
            ])
        #expect(armonica.acorde(grado: 5, cuatriada: true)?.cifrado == "Mi7")

        let melodica = Escala(.la, .menorMelodica)
        #expect(
            melodica.cifradosRomanos(cuatriadas: true) == ["i(maj7)", "ii7", "♭III+maj7", "IV7", "V7", "viø7", "viiø7"])
    }

    @Test func notasConOctava() {
        #expect(
            Escala("Sol mayor").alturas(octava: 3).map(\.description) == [
                "Sol3", "La3", "Si3", "Do4", "Re4", "Mi4", "Fa♯4", "Sol4",
            ])
    }

    @Test func igualdadDeTiposDeEscala() {
        let jonico = TipoDeEscala(nombre: "jónico", intervalos: TipoDeEscala.mayor.intervalos.reversed())
        #expect(jonico == .mayor)
        #expect(Set([jonico, TipoDeEscala.mayor]).count == 1)
        #expect(TipoDeEscala.mayor != .lidio)
        #expect(Escala(.do, jonico) == Escala(.do))
    }

    @Test func menorMelodicaDescendente() {
        #expect(TipoDeEscala.menorMelodica.formaDescendente == .menorNatural)
        #expect(
            Escala("La menor melódica").alturas(octava: 4, sentido: .descendente).map(\.description) == [
                "La5", "Sol5", "Fa5", "Mi5", "Re5", "Do5", "Si4", "La4",
            ])
        #expect(Escala("La menor melódica").alturas(octava: 4)[5].description == "Fa♯5")
    }

    @Test func cifradoRomanoConReferencia() {
        let armonica = Escala(.la, .menorArmonica)
        #expect(armonica.cifradosRomanos(referencia: .menorNatural) == ["i", "ii°", "III+", "iv", "V", "VI", "♯vii°"])
    }
}

@Suite struct EscalasAdicionalesTests {
    @Test func modosDeLasMenores() {
        let armonica = Escala(.la, .menorArmonica)
        #expect(armonica.rotacion(2).tipo == .locrioSextaNatural)
        #expect(armonica.rotacion(3).tipo == .jonicoAumentado)
        #expect(armonica.rotacion(4).tipo == .doricoCuartaAumentada)
        #expect(armonica.rotacion(5).tipo == .frigioDominante)
        #expect(armonica.rotacion(6).tipo == .lidioSegundaAumentada)
        #expect(armonica.rotacion(7).tipo == .ultralocrio)
        let melodica = Escala(.la, .menorMelodica)
        #expect(melodica.rotacion(2).tipo == .doricoSegundaMenor)
        #expect(melodica.rotacion(3).tipo == .lidioAumentado)
        #expect(melodica.rotacion(4).tipo == .lidioDominante)
        #expect(melodica.rotacion(5).tipo == .mixolidioSextaMenor)
        #expect(melodica.rotacion(6).tipo == .locrioSegundaNatural)
        #expect(melodica.rotacion(7).tipo == .alterada)
        #expect(melodica.rotacion(7).nombre == "Sol♯ alterada")
    }

    @Test func lecturaDeNombres() {
        #expect(Escala("Mi frigio dominante") == Escala(.mi, .frigioDominante))
        #expect(Escala("E phrygian dominant") == Escala(.mi, .frigioDominante))
        #expect(Escala("Do jónico ♯5").tipo == .jonicoAumentado)
        #expect(Escala("Do jonico #5").tipo == .jonicoAumentado)
        #expect(Escala("G altered").tipo == .alterada)
        #expect(Escala("Sol superlocrio").tipo == .alterada)
        #expect(Escala("Do mayor armónica").notas.map(\.nombre) == ["Do", "Re", "Mi", "Fa", "Sol", "La♭", "Si"])
        #expect(Escala("C bebop").notas.count == 8)
        #expect(Escala("Re bebop dórico").notas.map(\.nombre) == ["Re", "Mi", "Fa", "Fa♯", "Sol", "La", "Si", "Do"])
    }

    @Test func funcionesDeGrado() {
        #expect(Escala(.do).nombreDeGrado(1) == .tonica)
        #expect(Escala(.do).nombreDeGrado(5) == .dominante)
        #expect(Escala(.do).nombreDeGrado(7) == .sensible)
        #expect(Escala(.la, .menorNatural).nombreDeGrado(7) == .subtonica)
        #expect(Escala(.la, .menorArmonica).nombreDeGrado(7) == .sensible)
        #expect(Escala(.do).nombreDeGrado(de: .fa) == .subdominante)
        #expect(Escala(.do).nombreDeGrado(de: "Fa#") == nil)
        #expect(Escala(.do, .pentatonicaMayor).nombreDeGrado(1) == nil)
        #expect(NombreDeGrado.superdominante.nombre(en: .inglesASCII) == "submediant")
    }

    @Test func armaduras() {
        #expect(Escala("Re mayor").notasDeLaArmadura == ["Fa#", "Do#"])
        #expect(Escala("Mib mayor").notasDeLaArmadura == ["Sib", "Mib", "Lab"])
        #expect(Escala(.do).notasDeLaArmadura == [])
        #expect(Escala("Do# mayor").notasDeLaArmadura?.last == "Si#")
        #expect(Escala(.la, .menorArmonica).notasDeLaArmadura == nil)

        #expect(Escala(armadura: 3) == Escala(.la))
        #expect(Escala(armadura: -2, tipo: .menorNatural) == Escala(.sol, .menorNatural))
        #expect(Escala(armadura: 0, tipo: .dorico) == Escala(.re, .dorico))
        #expect(Escala(armadura: 0, tipo: .menorArmonica) == nil)
    }

    @Test func circuloDeQuintasYRelaciones() {
        let circulo = Escala.circuloDeQuintas()
        #expect(circulo.count == 15)
        #expect(circulo.first?.nombre == "Do♭ mayor")
        #expect(circulo.last?.nombre == "Do♯ mayor")
        #expect(circulo.map { $0.armadura! } == Array(-7...7))
        #expect(Escala.circuloDeQuintas(.menorNatural)[7] == Escala(.la, .menorNatural))

        #expect(Escala(.do).distancia(hasta: Escala(.sol)) == 1)
        #expect(Escala(.do).distancia(hasta: Escala(.la, .menorNatural)) == 0)
        #expect(Escala(.do).distancia(hasta: Escala("Fa# mayor")) == 6)
        #expect(Escala(.do).distancia(hasta: Escala(.do, .menorArmonica)) == nil)

        #expect(Escala("Do# mayor").enarmonicaMasSimple.nombre == "Re♭ mayor")
        #expect(Escala("Fa# mayor").enarmonicaMasSimple.nombre == "Fa♯ mayor")
        #expect(Escala("Solb mayor").enarmonicaMasSimple.nombre == "Sol♭ mayor")
        #expect(Escala("La# menor").enarmonicaMasSimple.nombre == "Si♭ menor natural")

        #expect(
            Set(Tonalidad(.do).vecinas) == [
                Tonalidad(.sol), Tonalidad(.fa), Tonalidad(.la, .menor), Tonalidad(.mi, .menor), Tonalidad(.re, .menor),
            ])
    }

    @Test func escalasContenedoras() {
        let porNombre = Escala.identificar([.do, .mi, .sol, .si, "Fa#"])
        // Primero la que tiene exactamente esas notas; luego, la de menos notas de más.
        #expect(porNombre.first == Escala(.do, .pentatonicaLidia))
        #expect(porNombre.dropFirst().first == Escala(.sol))
        #expect(porNombre.contains(Escala(.mi, .menorNatural)))
        #expect(porNombre.contains(Escala(.re, .mixolidio)))
        #expect(!porNombre.contains(Escala(.do)))
        #expect(porNombre.allSatisfy { escala in [Nota.do, .mi, .sol, .si, "Fa#"].allSatisfy { escala.contiene($0) } })

        // Con Sol♭ en lugar de Fa♯, la ortografía descarta Sol mayor.
        #expect(!(Escala.identificar([.do, .mi, .sol, .si, "Solb"]).contains(Escala(.sol))))

        let porAltura = Escala.identificar(clasesDeAltura: [0, 4, 7, 11, 6])
        #expect(porAltura.first == Escala(.do, .pentatonicaLidia))
        #expect(porAltura.dropFirst().first == Escala(.sol))
        #expect(porAltura.contains(Escala(.mi, .menorNatural)))
        #expect(Escala.identificar(clasesDeAltura: [0, 1, 2, 3], tipos: [.mayor]) == [])
    }
}

@Suite struct EscalasDireccionalesTests {
    @Test func menorMelodica() {
        let melodica = TipoDeEscala.menorMelodica
        #expect(melodica.esDireccional)
        #expect(melodica.formaDescendente == .menorNatural)
        #expect(melodica.formaAscendente.intervalos == melodica.intervalos)
        #expect(!melodica.formaAscendente.esDireccional)
        #expect(melodica.intervalosEnAmbasDirecciones.count == 9)
        #expect(
            Escala(.la, .menorMelodica).alturas(octava: 4, sentido: .descendente).map(\.description) == [
                "La5", "Sol5", "Fa5", "Mi5", "Re5", "Do5", "Si4", "La4",
            ])
        #expect(!TipoDeEscala.mayor.esDireccional)
        #expect(TipoDeEscala.mayor.formaDescendente == .mayor)
        // Un descenso igual a la subida no se guarda.
        #expect(
            TipoDeEscala(
                nombre: "x", intervalos: TipoDeEscala.mayor.intervalos,
                intervalosDescendentes: TipoDeEscala.mayor.intervalos
            ).intervalosDescendentes == nil)
    }

    @Test func menorMelodicaDeJazz() {
        let jazz = TipoDeEscala.menorMelodicaJazz
        #expect(!jazz.esDireccional)
        #expect(jazz.intervalos == TipoDeEscala.menorMelodica.intervalos)
        #expect(jazz != .menorMelodica)
        #expect(jazz == TipoDeEscala.menorMelodica.formaAscendente)
        #expect(jazz.nombre(en: .inglesASCII) == "jazz minor")
        #expect(TipoDeEscala.menorMelodica.nombre(en: .inglesASCII) == "melodic minor")
        #expect(Escala("La menor melódica ascendente").tipo == jazz)
        #expect(Escala("A jazz minor").tipo == jazz)
        #expect(
            Escala(.la, jazz).alturas(octava: 4, sentido: .descendente).map(\.description) == [
                "La5", "Sol♯5", "Fa♯5", "Mi5", "Re5", "Do5", "Si4", "La4",
            ])
        // Sus modos vuelven a ella.
        #expect(TipoDeEscala.alterada.rotacion(2) == jazz)
        #expect(jazz.rotacion(7) == .alterada)
        #expect(Tonalidad(Escala(.la, jazz)) == Tonalidad(.la, .menor))
        #expect(jazz.equivalentes.contains { $0.nombre == "Gaurīmanoharī" })
    }

    @Test func pertenenciaEnAmbasDirecciones() {
        let melodica = Escala(.la, .menorMelodica)
        #expect(melodica.contiene(.sol))
        #expect(melodica.contiene("Sol#"))
        #expect(!melodica.contiene(.sol, sentido: .ascendente))
        #expect(melodica.contiene(.sol, sentido: .descendente))
        #expect(!melodica.contiene("Sol#", sentido: .descendente))
        #expect(melodica.contieneEnarmonico("Lab", sentido: .ascendente))
        #expect(
            melodica.notasEnAmbasDirecciones.map(\.nombre) == [
                "La", "Si", "Do", "Re", "Mi", "Fa", "Fa♯", "Sol", "Sol♯",
            ])
        #expect(melodica.notas(sentido: .descendente).map(\.nombre) == ["La", "Si", "Do", "Re", "Mi", "Fa", "Sol"])
        #expect(melodica.notas(sentido: .ascendente) == melodica.notas)
        // Lo que depende de los grados sigue usando la forma ascendente.
        #expect(melodica.grado(de: "Sol#") == 7)
        #expect(melodica.grado(de: .sol) == nil)
        #expect(melodica.conjuntoDeClases.numeroDeForte == "7-34")
        // La búsqueda de escalas tiene en cuenta las dos direcciones…
        #expect(Escala.identificar([.la, .sol, "Sol#"], tipos: [.menorMelodica]).contains(melodica))
        #expect(
            Escala.identificar(clasesDeAltura: [9, 7, 8], tipos: [.menorMelodica])
                .contains { $0.notasEnAmbasDirecciones.map(\.claseDeAltura).contains(7) })
        #expect(
            !(Escala.identificar([.la, .sol, "Sol#"], tipos: [.menorMelodicaJazz]).contains(
                Escala(.la, .menorMelodicaJazz))))
        // …y la ortografía también: en La menor melódica, el 7 MIDI (Sol) no es cromático.
        #expect(melodica.nombre(claseDeAltura: 7) == .sol)
        #expect(melodica.nombre(claseDeAltura: 8) == Nota("Sol#"))
    }

    @Test func dromoiDireccionales() {
        #expect(Escala(.re, .rast).notas.map(\.nombre) == ["Re", "Mi", "Fa♯", "Sol", "La", "Si", "Do♯"])
        #expect(
            Escala(.re, TipoDeEscala.rast.formaDescendente).notas.map(\.nombre) == [
                "Re", "Mi", "Fa♯", "Sol", "La", "Si", "Do",
            ])
        #expect(TipoDeEscala.rast != .mayor)
        #expect(TipoDeEscala.rast.formaAscendente == .mayor)
        #expect(TipoDeEscala.kiourdi.formaAscendente == .kartzigar)
        #expect(TipoDeEscala.kiourdi.formaDescendente == .menorNatural)
        #expect(TipoDeEscala.houseini.formaAscendente == .mixolidio)
        #expect(Escala("Re kiourdi").tipo.nombre == "Kiourdí")
        #expect(TipoDeEscala.dromoi.count == 15)
    }

    @Test func janyas() {
        #expect(Escala(.do, .mohanam).notas.map(\.nombre) == ["Do", "Re", "Mi", "Sol", "La"])
        #expect(
            Escala(.do, .bilahari).alturas(octava: 4, sentido: .descendente).map(\.description) == [
                "Do5", "Si4", "La4", "Sol4", "Fa4", "Mi4", "Re4", "Do4",
            ])
        #expect(TipoDeEscala.bilahari.melakartasCompatibles == [29])
        #expect(TipoDeEscala.kambhoji.melakartasCompatibles == [28])
        #expect(TipoDeEscala.mohanam.melakartasCompatibles == [28, 29, 64, 65])
        #expect(TipoDeEscala.hindolam.melakartasCompatibles == [8, 20])
        #expect(TipoDeEscala.abhogi.melakartasCompatibles == [22, 23])
        #expect(Escala("Do hamsadhwani") == Escala(.do, .hamsadhvani))
        #expect(TipoDeEscala.janyas.count == 11)
    }

    @Test func identidadYEquivalentes() {
        #expect(TipoDeEscala.kafi == .dorico)
        #expect(!TipoDeEscala.kafi.esIdentico(a: .dorico))
        #expect(TipoDeEscala.kafi.esIdentico(a: .kafi))
        #expect(
            Set(TipoDeEscala.mayor.equivalentes.map(\.nombre)).isSuperset(of: [
                "Bilāval", "Dhīraśaṅkarābharaṇam", "Qīngyuè", "ʿAjam", "Māhur",
            ]))
        #expect(
            Set(TipoDeEscala.hitzazkiar.equivalentes.map(\.nombre)).isSuperset(of: [
                "Bhairav", "Māyāmālavagauḷa", "doble armónica", "Ḥijāzkār",
            ]))
        #expect(TipoDeEscala.menorMelodica.equivalentes.isEmpty)
        // La búsqueda por índice da lo mismo que antes: los nombres habituales primero.
        #expect(TipoDeEscala.buscar(nombre: "Dorian")?.nombre == "dórico")
        #expect(TipoDeEscala.buscar(nombre: "jazz minor")?.nombre == "menor melódica de jazz")
        #expect(TipoDeEscala.buscar(nombre: "inexistente") == nil)
    }
}

@Suite struct EscalasTradicionalesTests {
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
        // Mayamalavagowla, el thaat Bhairav y el dromos Hitzazkiar son la misma escala.
        #expect(TipoDeEscala.melakarta(15) == .bhairav)
        #expect(TipoDeEscala.melakarta(15) == .hitzazkiar)
        // Ri3 y Ga1, Dha3 y Ni1 con su escritura tradicional.
        #expect(
            Escala(.do, TipoDeEscala.melakarta(1)!).notas.map(\.nombre) == [
                "Do", "Re♭", "Mi♭♭", "Fa", "Sol", "La♭", "Si♭♭",
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

    @Test func dromoi() {
        #expect(TipoDeEscala.dromoi.count == 15)
        #expect(Escala(.re, .hitzaz).notas.map(\.nombre) == ["Re", "Mi♭", "Fa♯", "Sol", "La", "Si♭", "Do"])
        #expect(Escala(.re, .pireotikos).notas.map(\.nombre) == ["Re", "Mi♭", "Fa♯", "Sol♯", "La", "Si♭", "Do♯"])
        #expect(Escala(.re, .houzam).notas.map(\.nombre) == ["Re", "Mi♯", "Fa♯", "Sol", "La", "Si", "Do♯"])
        #expect(Escala(.re, .sabah).notas.map(\.nombre) == ["Re", "Mi", "Fa", "Sol♭", "La", "Si♭", "Do"])
        #expect(Escala(.re, .kartzigar).notas.map(\.nombre) == ["Re", "Mi", "Fa", "Sol", "La♭", "Si", "Do"])
        #expect(TipoDeEscala.ousak == .frigio)
        #expect(TipoDeEscala.hitzaz == .frigioDominante)
        #expect(TipoDeEscala.nikriz == .doricoCuartaAumentada)
        #expect(TipoDeEscala.tabahaniotikos == .mayorArmonica)
    }

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
            #expect(Escala(texto: texto)?.tipo.nombre == "Kāfī", Comment(rawValue: texto))
        }
        #expect(Escala("Do shanmukhapriya").tipo == TipoDeEscala.melakarta(56))
        #expect(Escala("Do Sanmukhapriya").tipo == TipoDeEscala.melakarta(56))
        #expect(Escala("Do dorico") == Escala("Do dórico"))
        #expect(Escala("Re pireotikos") == Escala(.re, .pireotikos))
        // Todas las escalas se vuelven a leer desde su nombre, con diacríticos o sin ellos.
        for tipo in TipoDeEscala.tradicionales {
            #expect(TipoDeEscala.buscar(nombre: tipo.nombre)?.nombre == tipo.nombre, Comment(rawValue: tipo.nombre))
        }
    }

    @Test func escalasOccidentalesNuevas() {
        func notas(_ tipo: TipoDeEscala) -> String { Escala(.do, tipo).notas.map(\.description).joined(separator: " ") }
        #expect(notas(.dobleArmonica) == "Do Re♭ Mi Fa Sol La♭ Si")
        #expect(notas(.menorHungara) == "Do Re Mi♭ Fa♯ Sol La♭ Si")
        #expect(notas(.mayorHungara) == "Do Re♯ Mi Fa♯ Sol La Si♭")
        #expect(notas(.napolitanaMenor) == "Do Re♭ Mi♭ Fa Sol La♭ Si")
        #expect(notas(.napolitanaMayor) == "Do Re♭ Mi♭ Fa Sol La Si")
        #expect(notas(.enigmatica) == "Do Re♭ Mi Fa♯ Sol♯ La♯ Si")
        #expect(notas(.persa) == "Do Re♭ Mi Fa Sol♭ La♭ Si")
        #expect(notas(.mayorLocria) == "Do Re Mi Fa Sol♭ La♭ Si♭")
        #expect(notas(.lidioMenor) == "Do Re Mi Fa♯ Sol La♭ Si♭")
        #expect(notas(.prometeo) == "Do Re Mi Fa♯ La Si♭")
        #expect(notas(.disminuidaSemitonoTono) == "Do Re♭ Mi♭ Mi Fa♯ Sol La Si♭")
        #expect(notas(.aumentada) == "Do Mi♭ Mi Sol Sol♯ Si")
        #expect(notas(.bluesMayor) == "Do Re Mi♭ Mi Sol La")
        #expect(notas(.egipcia) == "Do Re Fa Sol Si♭")
        #expect(notas(.cromatica) == "Do Re♭ Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si")
        #expect(Set(Escala(.do, .cromatica).notas.map(\.claseDeAltura)).count == 12)

        // Los modos de la mayor armónica son sus rotaciones.
        let modos: [TipoDeEscala] = [
            .mayorArmonica, .doricoQuintaDisminuida, .frigioCuartaDisminuida, .lidioTerceraMenor,
            .mixolidioSegundaMenor, .lidioAumentadoSegundaAumentada, .locrioSeptimaDisminuida,
        ]
        for (i, modo) in modos.enumerated() {
            #expect(TipoDeEscala.mayorArmonica.rotacion(i + 1).esIdentico(a: modo), Comment(rawValue: modo.nombre))
        }
        // Las disminuidas suenan como rotaciones la una de la otra (la ortografía cambia).
        #expect(
            TipoDeEscala.disminuida.rotacion(2).intervalos.map(\.semitonos)
                == TipoDeEscala.disminuidaSemitonoTono.intervalos.map(\.semitonos))

        // Nombres en inglés y alias.
        #expect(Escala("E hungarian minor").tipo == .menorHungara)
        #expect(Escala("C double harmonic").tipo.nombre == "doble armónica")
        #expect(Escala(.do, .enigmatica).nombre(en: .inglesASCII) == "C enigmatic")
        #expect(Escala("G half-whole diminished").tipo == .disminuidaSemitonoTono)
        #expect(Escala("Mi española").tipo == .frigioDominante)
        #expect(Escala("Do modo 1 de Messiaen").tipo == .tonosEnteros)
        #expect(Escala("Do modo 2 de Messiaen").tipo == .disminuidaSemitonoTono)
        #expect(Escala("Do gitana menor").tipo == .menorHungara)
        #expect(Escala("Do Skriabin").tipo == .prometeo)

        // Con el mismo contenido que escalas de otras tradiciones.
        #expect(TipoDeEscala.dobleArmonica == .bhairav)
        #expect(TipoDeEscala.menorHungara == .niavent)
        #expect(TipoDeEscala.egipcia == .shang)
        #expect(TipoDeEscala.todos.count == Set(TipoDeEscala.todos).count) // sin repetidos en el catálogo
        #expect(
            Escala.identificar(["Do", "Re♭", "Mi", "Fa", "Sol", "La♭", "Si"]).contains(Escala(.do, .dobleArmonica)))
    }

    @Test func cromaticasPorVentanaDeQuintas() {
        func notas(_ tipo: TipoDeEscala, _ tonica: Nota = .do) -> String {
            Escala(tonica, tipo).notas.map(\.description).joined(separator: " ")
        }
        let seis = TipoDeEscala.cromaticasPorQuintas
        #expect(
            seis == [
                .cromaticaConCincoBemoles, .cromaticaConCuatroBemoles, .cromaticaConTresBemoles,
                .cromaticaConDosBemoles, .cromaticaConUnBemol, .cromaticaConCincoSostenidos,
            ])
        #expect(TipoDeEscala.cromatica(desdeLaQuinta: -5) == .cromatica)
        #expect(TipoDeEscala.cromaticaConCuatroBemoles.nombre == "cromática")
        #expect(notas(.cromaticaConCincoBemoles) == "Do Re♭ Re Mi♭ Mi Fa Sol♭ Sol La♭ La Si♭ Si")
        #expect(notas(.cromaticaConDosBemoles) == "Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si")
        #expect(notas(.cromaticaConCincoSostenidos) == "Do Do♯ Re Re♯ Mi Fa Fa♯ Sol Sol♯ La La♯ Si")
        #expect(notas(.cromaticaConCincoSostenidos, .re) == "Re Re♯ Mi Mi♯ Fa♯ Sol Sol♯ La La♯ Si Si♯ Do♯")
        #expect(notas(.cromaticaConCincoBemoles, .re) == "Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si Do Do♯")

        // La regla, no solo los casos: doce clases de altura, desde el unísono, con la escala mayor dentro.
        let mayor = Set(TipoDeEscala.mayor.intervalos)
        for tipo in seis {
            #expect(tipo.intervalos.count == 12, Comment(rawValue: tipo.nombre))
            #expect(Set(tipo.intervalos.map(\.semitonos)) == Set(0..<12), Comment(rawValue: tipo.nombre))
            #expect(tipo.intervalos.first == .unisono, Comment(rawValue: tipo.nombre))
            #expect(mayor.isSubset(of: tipo.intervalos), Comment(rawValue: tipo.nombre))
            // Doce quintas seguidas.
            let quintas = tipo.intervalos.map(\.pasosDeQuinta).sorted()
            #expect(quintas == Array(quintas[0]..<(quintas[0] + 12)), Comment(rawValue: tipo.nombre))
        }
        // Dos vecinas difieren en una sola nota, que pasa de bemol a sostenido: Sol♭, Re♭, La♭, Mi♭ y Si♭.
        let cambian: [(Nota, Nota)] = [
            ("Solb", "Fa#"), ("Reb", "Do#"), ("Lab", "Sol#"), ("Mib", "Re#"), ("Sib", "La#"),
        ]
        for (k, (bemol, sostenido)) in cambian.enumerated() {
            let antes = Set(Escala(.do, seis[k]).notas)
            let despues = Set(Escala(.do, seis[k + 1]).notas)
            #expect(antes.subtracting(despues) == [bemol], "\(k)")
            #expect(despues.subtracting(antes) == [sostenido], "\(k)")
        }

        // Se leen por su nombre y por su ventana.
        #expect(Escala(texto: "Do cromática con dos bemoles") == Escala(.do, .cromaticaConDosBemoles))
        #expect(Escala(texto: "Re cromatica -1..10") == Escala(.re, .cromaticaConCincoSostenidos))
        #expect(Escala(texto: "Re cromática −6…5") == Escala(.re, .cromaticaConCincoBemoles))
        #expect(Escala(texto: "Do cromática con cuatro bemoles") == Escala(.do, .cromatica))
        #expect(Escala(texto: "C chromatic with one flat") == Escala(.do, .cromaticaConUnBemol))
        for tipo in seis {
            #expect(TipoDeEscala.todos.contains(tipo), Comment(rawValue: tipo.nombre))
            for idioma in Idioma.allCases {
                let notacion = Notacion(escritura: EscrituraDeNotas(idioma: idioma, ascii: false))
                let escala = Escala(Nota("Fa#"), tipo)
                #expect(
                    Escala(texto: escala.nombre(en: notacion)) == escala, "\(idioma): \(escala.nombre(en: notacion))")
            }
        }
        // Las seis tienen nombres distintos en cada idioma.
        for idioma in Idioma.allCases {
            let nombres = seis.map {
                $0.nombre(en: Notacion(escritura: EscrituraDeNotas(idioma: idioma, ascii: false)))
            }
            #expect(Set(nombres).count == 6, "\(idioma)")
        }
        // Con una de ellas, cada clase de altura se escribe como dice su ventana.
        #expect(Escala(.do, .cromaticaConCincoSostenidos).nombre(claseDeAltura: 10) == "La#")
        #expect(Escala(.do, .cromaticaConCincoBemoles).nombre(claseDeAltura: 6) == "Solb")
    }

    @Test func messiaenFlamencaBebopYAlias() {
        func notas(_ tipo: TipoDeEscala) -> String { Escala(.do, tipo).notas.map(\.description).joined(separator: " ") }
        #expect(notas(.messiaen3) == "Do Re Mi♭ Mi Fa♯ Sol La♭ Si♭ Si")
        #expect(notas(.messiaen4) == "Do Re♭ Re Fa Fa♯ Sol La♭ Si")
        #expect(notas(.messiaen5) == "Do Re♭ Fa Fa♯ Sol Si")
        #expect(notas(.messiaen6) == "Do Re Mi Fa Fa♯ Sol♯ La♯ Si")
        #expect(notas(.messiaen7) == "Do Re♭ Re Mi♭ Fa Fa♯ Sol La♭ La Si")
        #expect(notas(.flamenca) == "Do Re♭ Mi♭ Mi Fa Sol La♭ Si♭")
        #expect(notas(.petrushka) == "Do Re♭ Mi Fa♯ Sol Si♭")
        #expect(notas(.bebopMenorMelodica) == "Do Re Mi♭ Fa Sol Sol♯ La Si")
        #expect(notas(.bebopMenorArmonica) == "Do Re Mi♭ Fa Sol La♭ Si♭ Si")

        // Transposición limitada: cuántas transposiciones distintas tiene cada modo.
        func transposiciones(_ tipo: TipoDeEscala) -> Int {
            let clases = tipo.intervalos.map { modulo($0.semitonos, 12) }
            return Set((0..<12).map { t in Set(clases.map { modulo($0 + t, 12) }) }).count
        }
        #expect(
            [TipoDeEscala.tonosEnteros, .disminuida, .messiaen3, .messiaen4, .messiaen5, .messiaen6, .messiaen7]
                .map(transposiciones) == [2, 3, 4, 6, 6, 6, 6])
        // Petrushka: los acordes mayores de Do y de Fa♯ (con Re♭ por Do♯ y Si♭ por La♯).
        #expect(
            Set(Escala(.do, .petrushka).notas.map(\.claseDeAltura))
                == Set((Acorde("Do").notas + Acorde("Fa#").notas).map(\.claseDeAltura)))

        // Nombres y alias.
        #expect(Escala("Do modo 3 de Messiaen").tipo == .messiaen3)
        #expect(Escala("Do Tcherepnin").tipo == .messiaen3)
        #expect(Escala("C Messiaen mode 7").tipo == .messiaen7)
        #expect(Escala("Mi andaluza").tipo == .flamenca)
        #expect(Escala("E flamenco").tipo == .flamenca)
        #expect(Escala("Do bebop menor armónica").tipo == .bebopMenorArmonica)
        #expect(Escala("C bebop melodic minor").tipo == .bebopMenorMelodica)
        #expect(Escala("Re menor rumana").tipo == .doricoCuartaAumentada)
        #expect(Escala("D Romanian minor").tipo == .doricoCuartaAumentada)
        #expect(Escala("Mi Freygish").tipo.nombre == "Freygish")
        #expect(Escala("Mi Ahavah Rabbah").tipo == .frigioDominante) // mismo contenido
        #expect(Escala("Do de Bartók").tipo == .lidioDominante)
        #expect(Escala("C overtone").tipo == .lidioDominante)
        #expect(Escala("Do disminuida auxiliar blues").tipo == .disminuidaSemitonoTono)
        #expect(Escala("C auxiliary augmented").tipo == .tonosEnteros)
        #expect(Escala(.do, .messiaen3).nombre(en: .inglesASCII) == "C Messiaen mode 3")
        #expect(Escala(.mi, .flamenca).nombre(en: .inglesASCII) == "E flamenco")
        #expect(TipoDeEscala.todos.count == Set(TipoDeEscala.todos).count)
    }

    @Test func modosDeLaDobleArmonicaYDeLasNapolitanas() {
        func modos(
            _ base: TipoDeEscala, _ esperados: [TipoDeEscala], sourceLocation: SourceLocation = #_sourceLocation
        ) {
            for (i, modo) in esperados.enumerated() {
                #expect(
                    base.rotacion(i + 1).esIdentico(a: modo), "\(base.nombre) \(i + 1): \(base.rotacion(i + 1).nombre)",
                    sourceLocation: sourceLocation)
            }
        }
        modos(
            .dobleArmonica,
            [
                .dobleArmonica, .lidioSegundaSextaAumentadas, .ultrafrigio, .menorHungara, .oriental,
                .jonicoSegundaQuintaAumentadas, .locrioTerceraSeptimaDisminuidas,
            ])
        modos(
            .napolitanaMayor,
            [
                .napolitanaMayor, .lidioAumentadoSextaAumentada, .lidioDominanteAumentado, .lidioMenor,
                .mayorLocria, .locrioSegundaNaturalCuartaDisminuida, .superlocrioTerceraDisminuida,
            ])
        modos(
            .napolitanaMenor,
            [
                .napolitanaMenor, .lidioSextaAumentada, .mixolidioAumentado, .eolicoCuartaAumentada,
                .locrioDominante, .jonicoSegundaAumentada, .ultralocrioTerceraDisminuida,
            ])
        func notas(_ escala: Escala) -> String { escala.notas.map(\.description).joined(separator: " ") }
        #expect(notas(Escala(.do, .oriental)) == "Do Re♭ Mi Fa Sol♭ La Si♭")
        #expect(notas(Escala(.do, .ultrafrigio)) == "Do Re♭ Mi♭ Fa♭ Sol La♭ Si♭♭")
        #expect(Escala("C leading whole tone").tipo == .lidioAumentadoSextaAumentada)
        #expect(Escala("La gitana húngara").tipo == .eolicoCuartaAumentada)
    }

    @Test func pentatonicasBluesYHexacordos() {
        func notas(_ escala: Escala) -> String { escala.notas.map(\.description).joined(separator: " ") }
        #expect(notas(Escala(.do, .pentatonicaDominante)) == "Do Re Mi Sol Si♭")
        #expect(notas(Escala(.do, .pentatonicaMenorSexta)) == "Do Mi♭ Fa Sol La")
        #expect(notas(Escala(.do, .pentatonicaMayorSextaMenor)) == "Do Re Mi Sol La♭")
        #expect(notas(Escala(.do, .pentatonicaMenorQuintaDisminuida)) == "Do Mi♭ Fa Sol♭ Si♭")
        #expect(notas(Escala(.do, .bluesDeNueveNotas)) == "Do Re Mi♭ Mi Fa Sol♭ Sol La Si♭")
        #expect(notas(Escala(.do, .bluesMenorConSegunda)) == "Do Re Mi♭ Fa Sol♭ Sol Si♭")
        #expect(notas(.hexacordoNatural) == "Do Re Mi Fa Sol La")
        #expect(notas(.hexacordoDuro) == "Sol La Si Do Re Mi")
        #expect(notas(.hexacordoBlando) == "Fa Sol La Si♭ Do Re")
        #expect(Escala("Do pentatónica de Coltrane").tipo == .pentatonicaMayorSextaMenor)
        #expect(Escala("C dominant pentatonic").tipo == .pentatonicaDominante)
        #expect(Escala("Sol hexacordo").tipo == .hexacordo)
        #expect(Escala(.do, .bluesDeNueveNotas).nombre(en: .inglesASCII) == "C nine tone blues")
        // Alias de escalas que ya estaban.
        #expect(Escala("Do mayor melódica").tipo == .mixolidioSextaMenor)
        #expect(Escala("Sol dominante b9 b13").tipo == .frigioDominante)
        #expect(TipoDeEscala.todos.count == Set(TipoDeEscala.todos).count)
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
        #expect(notas(.slendro) == "Do Re Fa Sol La")
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
        #expect(Escala(.re, .nahawand).nombre(en: .inglesASCII) == "D Nahāwand")
        // Las tradicionales no entran en las búsquedas de escalas habituales.
        #expect(!(TipoDeEscala.todos.contains { $0.nombre == "Ḥijāz" }))
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
        #expect(TipoDeEscala.todos.count == Set(TipoDeEscala.todos).count)
        // Nombres.
        for (texto, nombre) in [
            ("Do Bhupali", "Bhūpālī"), ("Do malkauns", "Mālkauns"), ("Do Bageshri", "Bāgeśrī"),
            ("Do Desh", "Deś"), ("Do Chahargah", "Čahārgāh"), ("Do Homayoun", "Homāyun"),
            ("Do Pyeongjo", "P'yŏngjo"), ("Do 계면조", "Kyemyŏnjo"), ("La andina", "pentatónica andina"),
            ("Mi harmonia doria cromatica", "harmonía doria cromática"), ("Do jónico sin 4ª", "jónico sin 4ª"),
            ("C triad pair", "hexatónica de dos tríadas"),
        ] {
            #expect(Escala(texto: texto)?.tipo.nombre == nombre, Comment(rawValue: texto))
        }
    }

    @Test func modosDeLaMayorHungaraPentatonicasYAliasDeCompositor() {
        func notas(_ escala: Escala) -> String { escala.notas.map(\.description).joined(separator: " ") }
        // Las rotaciones de la mayor húngara (Do Re♯ Mi Fa♯ Sol La Si♭) dan sus seis modos.
        let hungara = Escala(.do, .mayorHungara)
        let modos: [(TipoDeEscala, String)] = [
            (.ultralocrioSextaDisminuida, "Re♯ Mi Fa♯ Sol La Si♭ Do"),
            (.menorArmonicaQuintaDisminuida, "Mi Fa♯ Sol La Si♭ Do Re♯"),
            (.superlocrioSextaNatural, "Fa♯ Sol La Si♭ Do Re♯ Mi"),
            (.menorMelodicaQuintaAumentada, "Sol La Si♭ Do Re♯ Mi Fa♯"),
            (.doricoSegundaMenorCuartaAumentada, "La Si♭ Do Re♯ Mi Fa♯ Sol"),
            (.lidioAumentadoTerceraAumentada, "Si♭ Do Re♯ Mi Fa♯ Sol La"),
        ]
        for (i, (tipo, esperado)) in modos.enumerated() {
            #expect(hungara.rotacion(i + 2).tipo.nombre == tipo.nombre)
            #expect(notas(Escala(hungara.grado(i + 2), tipo)) == esperado)
        }
        // Pentatónicas.
        #expect(notas(Escala(.do, .pentatonicaMixolidia)) == "Do Mi Fa Sol Si♭")
        #expect(notas(Escala(.do, .pentatonicaLidia)) == "Do Mi Fa♯ Sol Si")
        #expect(notas(Escala(.do, .pentatonicaEscocesa)) == "Do Re Fa Sol La")
        #expect(Escala(.do, .pentatonicaMayor).rotacion(4).tipo.nombre == "pentatónica escocesa")
        #expect(TipoDeEscala.pentatonicaEscocesa.equivalentes.contains { $0.nombre == "Sléndro" })
        #expect(TipoDeEscala.pentatonicaLidia.equivalentes.contains { $0.nombre == "Amṛtavarṣiṇī" })
        #expect(TipoDeEscala.egipcia.equivalentes.contains { $0.nombre == "Megh" })
        // Otras.
        #expect(notas(Escala(.do, .mayorRumana)) == "Do Re♭ Mi Fa♯ Sol La Si♭")
        #expect(Set(Escala(.re, .hexatonicaMenorDeDosTriadas).notas) == Set(Acorde("Rem").notas + Acorde("Mim").notas))
        #expect(notas(Escala(.do, .sivaranjani)) == "Do Re Mi♭ Sol La")
        #expect(notas(Escala(.do, .kalavati)) == "Do Mi Sol La Si♭")
        #expect(notas(Escala(.do, .revati)) == "Do Re♭ Fa Sol Si♭")
        #expect(notas(Escala(.do, .candrakauns)) == "Do Mi♭ Fa La♭ Si")
        #expect(TipoDeEscala.todos.count == Set(TipoDeEscala.todos).count)
        // Nombres de compositor y otros alias.
        for (texto, nombre) in [
            ("La de Liszt", "menor húngara"), ("Do Rimski-Kórsakov", "disminuida semitono-tono"),
            ("Do de Debussy", "tonos enteros"), ("Do Weitzmann", "aumentada"),
            ("Do nordestina", "lidio dominante"), ("Do hindú", "mixolidio ♭6"),
            ("Do escocesa", "pentatónica escocesa"), ("Do superlocrio ♮6", "superlocrio ♮6"),
            ("C Romanian major", "mayor rumana"), ("Do Shivaranjani", "Śivarañjanī"),
            ("Do Chandrakauns", "Candrakauns"), ("Do Amritavarshini", "Amṛtavarṣiṇī"),
        ] {
            #expect(Escala(texto: texto)?.tipo.nombre == nombre, Comment(rawValue: texto))
        }
    }

    @Test func modosGregorianos() {
        #expect(
            ModoGregoriano.todos.map(\.nombreGriego) == [
                "dórico", "hipodórico", "frigio", "hipofrigio", "lidio", "hipolidio", "mixolidio", "hipomixolidio",
            ])
        #expect(ModoGregoriano.todos.map(\.finalis) == [.re, .re, .mi, .mi, .fa, .fa, .sol, .sol])
        #expect(ModoGregoriano.todos.map(\.tenor) == [.la, .fa, .do, .la, .do, .la, .re, .do])
        #expect(ModoGregoriano(0) == nil)
        #expect(ModoGregoriano(9) == nil)

        let primero = ModoGregoriano(1)!
        #expect(primero.esAutentico)
        #expect(primero.maneria == .protus)
        #expect(primero.escala == Escala(.re, .dorico))
        #expect(primero.ambito.map(\.description) == ["Re4", "Mi4", "Fa4", "Sol4", "La4", "Si4", "Do5", "Re5"])
        #expect(primero.description == "modo 1 (protus auténtico, dórico): final Re, tenor La, ámbito Re4–Re5")

        let segundo = ModoGregoriano(2)!
        #expect(!segundo.esAutentico)
        #expect(segundo.escala == primero.escala)
        #expect(segundo.ambito.map(\.description) == ["La3", "Si3", "Do4", "Re4", "Mi4", "Fa4", "Sol4", "La4"])
        #expect(
            ModoGregoriano(8)!.description
                == "modo 8 (tetrardus plagal, hipomixolidio): final Sol, tenor Do, ámbito Re4–Re5")
        for modo in ModoGregoriano.todos {
            #expect(modo.ambito.count == 8)
            #expect(modo.ambito.contains(Altura(modo.finalis, octava: 4)))
        }

        #expect(ModoGregoriano(nombre: "hipofrigio")?.numero == 4)
        #expect(ModoGregoriano(nombre: "Tritus Plagal")?.numero == 6)
        #expect(ModoGregoriano(nombre: "modo 7")?.numero == 7)
        #expect(ModoGregoriano(nombre: "hipodorico")?.numero == 2)
        #expect(ModoGregoriano(nombre: "eólico") == nil)
    }

    @Test func escalasChinas() {
        #expect(
            TipoDeEscala.chinas.map(\.nombre) == ["Gōng", "Shāng", "Jué", "Zhǐ", "Yǔ", "Qīngyuè", "Yǎyuè", "Yànyuè"])
        // Los cinco modos son las rotaciones de la pentatónica: gōng, shāng, jué, zhǐ y yǔ
        // empiezan en Do, Re, Mi, Sol y La.
        let pentatonica = Escala(.do, .gong)
        for (tipo, tonica) in zip([TipoDeEscala.gong, .shang, .jue, .zhi, .yu], [Nota.do, .re, .mi, .sol, .la]) {
            #expect(Set(Escala(tonica, tipo).notas) == Set(pentatonica.notas), Comment(rawValue: tipo.nombre))
        }
        #expect(TipoDeEscala.gong == .pentatonicaMayor)
        #expect(TipoDeEscala.yu == .pentatonicaMenor)
        #expect(TipoDeEscala.qingyue == .mayor)
        #expect(TipoDeEscala.yayue == .lidio)
        #expect(TipoDeEscala.yanyue == .mixolidio)
        #expect(Escala(.re, .zhi).notas.map(\.description) == ["Re", "Mi", "Sol", "La", "Si"])
        // Se leen con tonos, sin ellos y en caracteres chinos; el nombre no se traduce.
        for texto in ["Do Gōng", "Do gong", "Do GONG", "Do 宫", "Do 宮", "C gong"] {
            #expect(Escala(texto: texto)?.tipo.nombre == "Gōng", Comment(rawValue: texto))
        }
        #expect(Escala("Sol zhi").tipo.nombre == "Zhǐ")
        #expect(Escala("Mi jiao").tipo.nombre == "Jué")
        #expect(Escala("Do yayue").tipo.nombre == "Yǎyuè")
        #expect(Escala(.la, .yu).nombre(en: .inglesASCII) == "A Yǔ")
        #expect(TipoDeEscala.pentatonicaMayor.equivalentes.contains { $0.nombre == "Gōng" })
    }

    @Test func escalasJaponesas() {
        #expect(
            TipoDeEscala.japonesas.map(\.nombre) == [
                "Ritsu", "Ryo", "Yō", "Min'yō", "Miyakobushi", "In", "Insen", "Iwato", "Hirajōshi", "Kumoijōshi",
                "Ryūkyū",
                "Akebono", "Kokin-jōshi",
            ])
        func notas(_ tonica: Nota, _ tipo: TipoDeEscala) -> String {
            Escala(tonica, tipo).notas.map(\.description).joined(separator: " ")
        }
        #expect(notas(.do, .hirajoshi) == "Do Re Mi♭ Sol La♭")
        #expect(notas(.do, .kumoijoshi) == "Do Re Mi♭ Sol La")
        #expect(notas(.do, .iwato) == "Do Re♭ Fa Sol♭ Si♭")
        #expect(notas(.do, .insen) == "Do Re♭ Fa Sol Si♭")
        #expect(notas(.mi, .miyakobushi) == "Mi Fa La Si Do")
        #expect(notas(.re, .minyo) == "Re Fa Sol La Do")
        #expect(notas(.do, .ryukyu) == "Do Mi Fa Sol Si")
        #expect(notas(.re, .ritsu) == "Re Mi Sol La Si")
        #expect(notas(.re, .ryo) == "Re Mi Fa♯ La Si")
        // Varias coinciden en notas con otras: in y miyakobushi, yō y ritsu, min'yō y la
        // pentatónica menor, ryo y la mayor.
        #expect(TipoDeEscala.in == .miyakobushi)
        #expect(TipoDeEscala.yo == .ritsu)
        #expect(TipoDeEscala.minyo == .pentatonicaMenor)
        #expect(TipoDeEscala.ryo == .pentatonicaMayor)
        #expect(Set(TipoDeEscala.in.equivalentes.map(\.nombre)) == ["Miyakobushi", "Ambassäl"])
        // Con macrones, sin ellos y en japonés.
        for (texto, nombre) in [
            ("Do Hirajōshi", "Hirajōshi"), ("Do hirajoshi", "Hirajōshi"), ("Do 平調子", "Hirajōshi"),
            ("Do Ryūkyū", "Ryūkyū"), ("Do ryukyu", "Ryūkyū"), ("Do okinawa", "Ryūkyū"),
            ("Re min'yō", "Min'yō"), ("Re minyo", "Min'yō"), ("Re yo", "Yō"), ("Mi in", "In"),
            ("Mi miyako-bushi", "Miyakobushi"), ("Do kumoi", "Kumoijōshi"), ("Do 岩戸", "Iwato"),
        ] {
            #expect(Escala(texto: texto)?.tipo.nombre == nombre, Comment(rawValue: texto))
        }
        #expect(Escala(.do, .hirajoshi).nombre(en: .inglesASCII) == "C Hirajōshi")
        #expect(!(TipoDeEscala.todos.contains { $0.nombre == "Hirajōshi" }))
    }

    @Test func busquedaYNombres() {
        #expect(Escala("Re hitzaz") == Escala(.re, .hitzaz))
        #expect(Escala("Re Hicaz").tipo.nombre == "Hitzáz")
        // «Hijaz» es el nombre del maqam y gana al alias del dromos.
        #expect(Escala("Re Hijaz").tipo.nombre == "Ḥijāz")
        #expect(Escala("Do Kafi") == Escala(.do, .kafi))
        #expect(Escala("Do melakarta 15").tipo.nombre == "Māyāmālavagauḷa")
        #expect(Escala("Do mayamalavagowla").tipo == .bhairav)
        #expect(TipoDeEscala.buscar(nombre: "souzinak")?.nombre == "Nikríz")
        // Los nombres propios no se traducen…
        #expect(Escala(.re, .hitzaz).nombre(en: .inglesASCII) == "D Hitzáz")
        #expect(Escala(.re, .hitzaz).texto(en: .inglesASCII) == "D Hitzáz")
        // …y las escalas habituales siguen igual: los nombres de siempre van primero.
        #expect(TipoDeEscala.buscar(nombre: "mayor")?.nombre == "mayor")
        #expect(TipoDeEscala.frigioDominante.nombre(en: .inglesASCII) == "phrygian dominant")
        #expect(!(TipoDeEscala.todos.contains { $0.nombre == "Hitzáz" }))
    }

    @Test func aliasEnGriegoYEnDevanagari() {
        // Los dromoi, por su nombre en griego, con tilde o sin ella.
        for (texto, nombre) in [
            ("Χιτζάζ", "Hitzáz"), ("χιτζαζ", "Hitzáz"), ("Χιτζαζκιάρ", "Hitzazkiár"),
            ("Ουσάκ", "Ousák"), ("Ραστ", "Rast"),
        ] {
            #expect(TipoDeEscala.buscar(nombre: texto)?.nombre == nombre, Comment(rawValue: texto))
        }
        // Las escalas indias, en devanagari. Ahí las marcas cuentan: भैरव y भैरवी son dos ragas.
        #expect(TipoDeEscala.buscar(nombre: "भैरव")?.nombre == "Bhairav")
        #expect(TipoDeEscala.buscar(nombre: "भैरवी")?.nombre == "Bhairavī")
        #expect(TipoDeEscala.buscar(nombre: "यमन")?.nombre == "Yaman")
        #expect(Escala("Re मोहनम्").tipo.nombre == Escala("Re Mohanam").tipo.nombre)
        // Las 72 melakartas.
        #expect(TipoDeEscala.nombresDeMelakartaEnDevanagari.count == 72)
        #expect(Set(TipoDeEscala.nombresDeMelakartaEnDevanagari).count == 72)
        for (devanagari, nombre) in zip(TipoDeEscala.nombresDeMelakartaEnDevanagari, TipoDeEscala.nombresDeMelakarta) {
            #expect(TipoDeEscala.buscar(nombre: devanagari)?.nombre == nombre, Comment(rawValue: devanagari))
        }
    }
}
