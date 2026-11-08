import Foundation
import Testing

@testable import Elementos
@testable import Teoria

@Suite struct EscalaTests {
    @Test func testNotas() {
        #expect(Escala(.re).notas.map(\.nombre) == ["Re", "Mi", "Fa♯", "Sol", "La", "Si", "Do♯"])
        #expect(Escala("Fa mayor").notas.map(\.nombre) == ["Fa", "Sol", "La", "Si♭", "Do", "Re", "Mi"])
        #expect(Escala("La menor armónica").grado(7) == Nota("Sol#"))
        #expect(Escala("Re dórico").notas == Escala(.do).modo(grado: 2).notas)
        #expect(Escala(.do).modo(grado: 5).tipo == .mixolidio)
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

    /// Los nombres de la menor de los conservatorios españoles: bachiana, dórica y antigua.
    @Test func losNombresDeConservatorioDeLaMenor() {
        #expect((try? TipoDeEscala(leyendo: "menor bachiana"))?.nombre == "menor melódica de jazz")
        #expect((try? TipoDeEscala(leyendo: "bachiana"))?.nombre == "menor melódica de jazz")
        #expect((try? TipoDeEscala(leyendo: "de Bach"))?.nombre == "menor melódica de jazz")
        #expect((try? TipoDeEscala(leyendo: "menor dórica"))?.nombre == "dórico")
        #expect((try? TipoDeEscala(leyendo: "menor antigua"))?.nombre == "menor natural")
        #expect(Escala("La bachiana").tipo == .menorMelodicaJazz)
    }
}

@Suite struct EscalasAdicionalesTests {
    @Test func modosDeLasMenores() {
        let armonica = Escala(.la, .menorArmonica)
        #expect(armonica.modo(grado: 2).tipo == .locrioSextaNatural)
        #expect(armonica.modo(grado: 3).tipo == .jonicoAumentado)
        #expect(armonica.modo(grado: 4).tipo == .doricoCuartaAumentada)
        #expect(armonica.modo(grado: 5).tipo == .frigioDominante)
        #expect(armonica.modo(grado: 6).tipo == .lidioSegundaAumentada)
        #expect(armonica.modo(grado: 7).tipo == .ultralocrio)
        let melodica = Escala(.la, .menorMelodica)
        #expect(melodica.modo(grado: 2).tipo == .doricoSegundaMenor)
        #expect(melodica.modo(grado: 3).tipo == .lidioAumentado)
        #expect(melodica.modo(grado: 4).tipo == .lidioDominante)
        #expect(melodica.modo(grado: 5).tipo == .mixolidioSextaMenor)
        #expect(melodica.modo(grado: 6).tipo == .locrioSegundaNatural)
        #expect(melodica.modo(grado: 7).tipo == .alterada)
        #expect(melodica.modo(grado: 7).nombre == "Sol♯ alterada")
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
        #expect(NombreDeGrado.superdominante.nombre(en: .ascii(.ingles)) == "submediant")
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
        let porNombre = Escala.identificar(notas: [.do, .mi, .sol, .si, "Fa#"])
        // Primero la que tiene exactamente esas notas; luego, la de menos notas de más.
        #expect(porNombre.first == Escala(.do, .pentatonicaLidia))
        #expect(porNombre.dropFirst().first == Escala(.sol))
        #expect(porNombre.contains(Escala(.mi, .menorNatural)))
        #expect(porNombre.contains(Escala(.re, .mixolidio)))
        #expect(!porNombre.contains(Escala(.do)))
        #expect(porNombre.allSatisfy { escala in [Nota.do, .mi, .sol, .si, "Fa#"].allSatisfy { escala.contiene($0) } })

        // Con Sol♭ en lugar de Fa♯, la ortografía descarta Sol mayor.
        #expect(!(Escala.identificar(notas: [.do, .mi, .sol, .si, "Solb"]).contains(Escala(.sol))))

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
        #expect(jazz.nombre(en: .ascii(.ingles)) == "jazz minor")
        #expect(TipoDeEscala.menorMelodica.nombre(en: .ascii(.ingles)) == "melodic minor")
        #expect(Escala("La menor melódica ascendente").tipo == jazz)
        #expect(Escala("A jazz minor").tipo == jazz)
        #expect(
            Escala(.la, jazz).alturas(octava: 4, sentido: .descendente).map(\.description) == [
                "La5", "Sol♯5", "Fa♯5", "Mi5", "Re5", "Do5", "Si4", "La4",
            ])
        // Sus modos vuelven a ella.
        #expect(TipoDeEscala.alterada.modo(grado: 2) == jazz)
        #expect(jazz.modo(grado: 7) == .alterada)
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
        #expect(melodica.conjuntoDeClasesDeAltura.numeroDeForte == "7-34")
        // La búsqueda de escalas tiene en cuenta las dos direcciones…
        #expect(Escala.identificar(notas: [.la, .sol, "Sol#"], tipos: [.menorMelodica]).contains(melodica))
        #expect(
            Escala.identificar(clasesDeAltura: [9, 7, 8], tipos: [.menorMelodica])
                .contains { $0.notasEnAmbasDirecciones.map(\.claseDeAltura).contains(7) })
        #expect(
            !(Escala.identificar(notas: [.la, .sol, "Sol#"], tipos: [.menorMelodicaJazz]).contains(
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
        #expect(TipoDeEscala.janyas.count == 20)
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
        // La menor melódica (sube con 6ª y 7ª mayores, baja como la natural) solo tiene las notas del dórico con
        // ficta del Renacimiento, que sube con Si y Do♯ y baja con Si♭ y Do.
        #expect(TipoDeEscala.menorMelodica.equivalentes.map(\.nombre) == ["dórico con ficta"])
        // La búsqueda por índice da lo mismo que antes: los nombres habituales primero.
        #expect((try? TipoDeEscala(leyendo: "Dorian"))?.nombre == "dórico")
        #expect((try? TipoDeEscala(leyendo: "jazz minor"))?.nombre == "menor melódica de jazz")
        #expect(
            throws: ErrorDeLecturaDeTeoria(
                texto: "inexistente", posicion: nil, motivo: .tipoDeEscalaNoReconocido("inexistente"))
        ) { try TipoDeEscala(leyendo: "inexistente") }
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
        #expect(notas(.prometeoNapolitano) == "Do Re♭ Mi Fa♯ La Si♭")
        #expect(notas(.tritonoDeDosSemitonos) == "Do Re♭ Re Fa♯ Sol La♭")
        #expect(notas(.hexatonicaDeArmonicos) == "Do Mi♭ Mi Fa Sol La")
        #expect(notas(.bebopLocrio) == "Do Re♭ Mi♭ Fa Sol♭ Sol La♭ Si♭")
        #expect(notas(.bebopLidio) == "Do Re Mi Fa♯ Sol Sol♯ La Si")
        #expect(notas(.pentatonicaMayorTerceraMenor) == "Do Re Mi♭ Sol La")
        #expect(notas(.pentatonicaMenorSextaMenor) == "Do Mi♭ Fa Sol La♭")
        #expect(TipoDeEscala.pentatonicaMayorTerceraMenor.equivalentes.contains { $0.esIdentico(a: .kumoijoshi) })
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
            #expect(TipoDeEscala.mayorArmonica.modo(grado: i + 1).esIdentico(a: modo), Comment(rawValue: modo.nombre))
        }
        // Las disminuidas suenan como rotaciones la una de la otra (la ortografía cambia).
        #expect(
            TipoDeEscala.disminuida.modo(grado: 2).intervalos.map(\.semitonos)
                == TipoDeEscala.disminuidaSemitonoTono.intervalos.map(\.semitonos))

        // Nombres en inglés y alias.
        #expect(Escala("E hungarian minor").tipo == .menorHungara)
        #expect(Escala("C double harmonic").tipo.nombre == "doble armónica")
        #expect(Escala(.do, .enigmatica).nombre(en: .ascii(.ingles)) == "C enigmatic")
        #expect(Escala("G half-whole diminished").tipo == .disminuidaSemitonoTono)
        #expect(Escala("Mi española").tipo == .frigioDominante)
        #expect(Escala("Do modo 1 de Messiaen").tipo == .tonosEnteros)
        #expect(Escala("Do modo 2 de Messiaen").tipo == .disminuidaSemitonoTono)
        #expect(Escala("Do gitana menor").tipo == .menorHungara)
        #expect(Escala("Do Skriabin").tipo == .prometeo)
        #expect(Escala("Do Prometeo napolitano").tipo == .prometeoNapolitano)
        #expect(Escala("Do de Verdi").tipo == .enigmatica)
        #expect(Escala("Do Stravinski").tipo == .disminuidaSemitonoTono)

        // Con el mismo contenido que escalas de otras tradiciones.
        #expect(TipoDeEscala.dobleArmonica == .bhairav)
        #expect(TipoDeEscala.menorHungara == .niavent)
        #expect(TipoDeEscala.egipcia == .shang)
        #expect(TipoDeEscala.occidentales.count == Set(TipoDeEscala.occidentales).count) // sin repetidos en el catálogo
        #expect(
            Escala.identificar(notas: ["Do", "Re♭", "Mi", "Fa", "Sol", "La♭", "Si"]).contains(
                Escala(.do, .dobleArmonica)))
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
        #expect(TipoDeEscala.cromatica(ventana: .masSimple) == .cromatica)
        #expect(TipoDeEscala.cromatica(ventana: .bemoles) == .cromaticaConCincoBemoles)
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
        #expect((try? Escala(leyendo: "Do cromática con dos bemoles")) == Escala(.do, .cromaticaConDosBemoles))
        #expect((try? Escala(leyendo: "Re cromatica -1..10")) == Escala(.re, .cromaticaConCincoSostenidos))
        #expect((try? Escala(leyendo: "Re cromática −6…5")) == Escala(.re, .cromaticaConCincoBemoles))
        #expect((try? Escala(leyendo: "Do cromática con cuatro bemoles")) == Escala(.do, .cromatica))
        #expect((try? Escala(leyendo: "C chromatic with one flat")) == Escala(.do, .cromaticaConUnBemol))
        for tipo in seis {
            #expect(TipoDeEscala.occidentales.contains(tipo), Comment(rawValue: tipo.nombre))
            for idioma in Idioma.allCases {
                let notacion = Notacion.delIdioma(idioma)
                let escala = Escala(Nota("Fa#"), tipo)
                #expect(
                    (try? Escala(leyendo: escala.nombre(en: notacion))) == escala,
                    "\(idioma): \(escala.nombre(en: notacion))")
            }
        }
        // Las seis tienen nombres distintos en cada idioma.
        for idioma in Idioma.allCases {
            let nombres = seis.map {
                $0.nombre(en: Notacion.delIdioma(idioma))
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
        #expect(Escala(.do, .messiaen3).nombre(en: .ascii(.ingles)) == "C Messiaen mode 3")
        #expect(Escala(.mi, .flamenca).nombre(en: .ascii(.ingles)) == "E flamenco")
        #expect(TipoDeEscala.occidentales.count == Set(TipoDeEscala.occidentales).count)
    }

    @Test func modosDeLaDobleArmonicaYDeLasNapolitanas() {
        func modos(
            _ base: TipoDeEscala, _ esperados: [TipoDeEscala], sourceLocation: SourceLocation = #_sourceLocation
        ) {
            for (i, modo) in esperados.enumerated() {
                #expect(
                    base.modo(grado: i + 1).esIdentico(a: modo),
                    "\(base.nombre) \(i + 1): \(base.modo(grado: i + 1).nombre)",
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
        #expect(notas(Escala(.do, .ultrafrigio)) == "Do Re♭ Mi♭ Fa♭ Sol La♭ Si𝄫")
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
        #expect(Escala(.do, .bluesDeNueveNotas).nombre(en: .ascii(.ingles)) == "C nine tone blues")
        // Alias de escalas que ya estaban.
        #expect(Escala("Do mayor melódica").tipo == .mixolidioSextaMenor)
        #expect(Escala("Sol dominante b9 b13").tipo == .frigioDominante)
        #expect(TipoDeEscala.occidentales.count == Set(TipoDeEscala.occidentales).count)
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

    @Test func makamlarMugamYMaqamatAproximados() {
        func notas(_ tipo: TipoDeEscala, _ tonica: Nota = .do) -> String {
            Escala(tonica, tipo).notas.map(\.description).joined(separator: " ")
        }
        // Maqamat y dastgāh con cuartos de tono, aproximados.
        #expect(notas(.maqamRast) == "Do Re Mi Fa Sol La Si")
        #expect(Escala(.do, TipoDeEscala.maqamRast.formaDescendente).notas.last?.description == "Si♭")
        #expect(TipoDeEscala.maqamRast == .rast)
        #expect(notas(.bayati, .re) == "Re Mi♭ Fa Sol La Si♭ Do")
        #expect(notas(.saba, .re) == "Re Mi♭ Fa Sol♭ La Si♭ Do")
        #expect(TipoDeEscala.suznak == .mayorArmonica)
        #expect(TipoDeEscala.sur == .frigio)
        #expect(TipoDeEscala.rastPanjgah == .mixolidio)
        #expect(TipoDeEscala.husayni == .frigio)
        #expect(TipoDeEscala.nayruz == .menorNatural)
        #expect(TipoDeEscala.sikah == .frigio)
        #expect(TipoDeEscala.iraq == .locrio)
        #expect(TipoDeEscala.jiharkah == .mayor)
        #expect(TipoDeEscala.bayateTork == .mixolidio)
        #expect(TipoDeEscala.bayateEsfahan == .menorArmonica)
        #expect(TipoDeEscala.abuAta == .locrio && TipoDeEscala.segah == .locrio)
        #expect(notas(.huzam, .mi) == "Mi Fa Sol La♭ Si Do Re")
        // Makamlar.
        #expect(notas(.rastMakami, .sol) == "Sol La Si Do Re Mi Fa♯")
        #expect(TipoDeEscala.rastMakami.esDireccional)
        #expect(notas(.hicazMakami, .la) == "La Si♭ Do♯ Re Mi Fa♯ Sol")
        #expect(TipoDeEscala.hicazMakami.formaDescendente.intervalos == TipoDeEscala.frigioDominante.intervalos)
        #expect(TipoDeEscala.hicazkarMakami == .dobleArmonica)
        #expect(TipoDeEscala.kurdiMakami == .frigio)
        #expect(TipoDeEscala.buselikMakami == .menorNatural)
        #expect(TipoDeEscala.cargahMakami == .mayor)
        #expect(TipoDeEscala.nihavendMakami.formaAscendente == .menorArmonica)
        #expect(TipoDeEscala.ussakMakami == .menorNatural)
        #expect(TipoDeEscala.segahMakami == .frigio)
        #expect(TipoDeEscala.suzinakMakami == .mayorArmonica)
        #expect(TipoDeEscala.karcigarMakami == .kartzigar && TipoDeEscala.nikrizMakami == .nikriz)
        #expect(TipoDeEscala.neveserMakami == .niavent)
        #expect(TipoDeEscala.huseyniMakami.formaAscendente == .dorico)
        #expect(TipoDeEscala.huseyniMakami.formaDescendente.intervalos == TipoDeEscala.menorNatural.intervalos)
        // Mugam: Rast, Şur y Segah tienen ocho notas (una por debajo de la tónica y otra por encima).
        #expect(notas(.rastMugami) == "Do Re Mi Fa Sol La Si♭ Si")
        #expect(notas(.surMugami, .sol) == "Sol La Si♭ Do Re Mi♭ Mi Fa")
        #expect(notas(.segahMugami, .mi) == "Mi Fa Sol La Si♭ Si Do Re")
        #expect(TipoDeEscala.cahargahMugami == .dobleArmonica)
        // Se leen con sus letras turcas y azerbaiyanas y sin ellas (la ı sin punto como i).
        for (texto, nombre) in [
            ("Sol Rast makamı", "Rast makamı"), ("La hicaz makami", "Hicaz makamı"),
            ("Sol nihavend makami", "Nihâvend makamı"), ("Do Çârgâh makamı", "Çârgâh makamı"),
            ("Do cargah makami", "Çârgâh makamı"), ("Sol makam Rast", "Rast makamı"),
            ("Do Rast muğamı", "Rast muğamı"), ("Sol sur mugami", "Şur muğamı"), ("Mi mugam Segah", "Segah muğamı"),
            ("Do maqam rast", "maqām Rāst"), ("Re bayati", "Bayātī"), ("Re Saba", "Ṣabā"), ("Re Šur", "Šur"),
            ("Re shur", "Šur"), ("Do rast panjgah", "Rāst-Panjgāh"),
        ] {
            #expect((try? Escala(leyendo: texto))?.tipo.nombre == nombre, Comment(rawValue: texto))
        }
        // «Rast» sola sigue siendo el dromos.
        #expect((try? Escala(leyendo: "Re rast"))?.tipo.nombre == "Rast")
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
            #expect(hungara.modo(grado: i + 2).tipo.nombre == tipo.nombre)
            #expect(notas(Escala(hungara.grado(i + 2), tipo)) == esperado)
        }
        // Pentatónicas.
        #expect(notas(Escala(.do, .pentatonicaMixolidia)) == "Do Mi Fa Sol Si♭")
        #expect(notas(Escala(.do, .pentatonicaLidia)) == "Do Mi Fa♯ Sol Si")
        #expect(notas(Escala(.do, .pentatonicaEscocesa)) == "Do Re Fa Sol La")
        #expect(Escala(.do, .pentatonicaMayor).modo(grado: 4).tipo.nombre == "pentatónica escocesa")
        #expect(TipoDeEscala.egipcia.equivalentes.contains { $0.nombre == "Sléndro" })
        #expect(TipoDeEscala.pentatonicaLidia.equivalentes.contains { $0.nombre == "Amṛtavarṣiṇī" })
        #expect(TipoDeEscala.egipcia.equivalentes.contains { $0.nombre == "Megh" })
        // Otras.
        #expect(notas(Escala(.do, .mayorRumana)) == "Do Re♭ Mi Fa♯ Sol La Si♭")
        #expect(Set(Escala(.re, .hexatonicaMenorDeDosTriadas).notas) == Set(Acorde("Rem").notas + Acorde("Mim").notas))
        #expect(notas(Escala(.do, .sivaranjani)) == "Do Re Mi♭ Sol La")
        #expect(notas(Escala(.do, .kalavati)) == "Do Mi Sol La Si♭")
        #expect(notas(Escala(.do, .revati)) == "Do Re♭ Fa Sol Si♭")
        #expect(notas(Escala(.do, .candrakauns)) == "Do Mi♭ Fa La♭ Si")
        #expect(TipoDeEscala.occidentales.count == Set(TipoDeEscala.occidentales).count)
        // Nombres de compositor y otros alias.
        for (texto, nombre) in [
            ("La de Liszt", "menor húngara"), ("Do Rimski-Kórsakov", "disminuida semitono-tono"),
            ("Do de Debussy", "tonos enteros"), ("Do Weitzmann", "aumentada"),
            ("Do nordestina", "lidio dominante"), ("Do hindú", "mixolidio ♭6"),
            ("Do escocesa", "pentatónica escocesa"), ("Do superlocrio ♮6", "superlocrio ♮6"),
            ("C Romanian major", "mayor rumana"), ("Do Shivaranjani", "Śivarañjanī"),
            ("Do Chandrakauns", "Candrakauns"), ("Do Amritavarshini", "Amṛtavarṣiṇī"),
        ] {
            #expect((try? Escala(leyendo: texto))?.tipo.nombre == nombre, Comment(rawValue: texto))
        }
    }

    @Test func modosGregorianos() throws {
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

        #expect(try ModoGregoriano(leyendo: "hipofrigio").numero == 4)
        #expect(try ModoGregoriano(leyendo: "Tritus Plagal").numero == 6)
        #expect(try ModoGregoriano(leyendo: "modo 7").numero == 7)
        #expect(try ModoGregoriano(leyendo: "hipodorico").numero == 2)
        #expect(throws: ErrorDeLecturaDeTeoria.self) { try ModoGregoriano(leyendo: "eólico") }
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
            #expect((try? Escala(leyendo: texto))?.tipo.nombre == "Gōng", Comment(rawValue: texto))
        }
        #expect(Escala("Sol zhi").tipo.nombre == "Zhǐ")
        #expect(Escala("Mi jiao").tipo.nombre == "Jué")
        #expect(Escala("Do yayue").tipo.nombre == "Yǎyuè")
        #expect(Escala(.la, .yu).nombre(en: .ascii(.ingles)) == "A Yǔ")
        #expect(TipoDeEscala.pentatonicaMayor.equivalentes.contains { $0.nombre == "Gōng" })
    }

    /// Los doce lü, por sanfen sunyi desde huángzhōng: once quintas pitagóricas, con los sostenidos.
    @Test func losDoceLu() throws {
        #expect(TipoDeEscala.lus.map(\.nombre) == ["Shí'èr lǜ", "Yánglǜ", "Yīnlǜ"])
        #expect(TipoDeEscala.shierLu.tradicion == .china)
        #expect(TipoDeEscala.shierLu.categoria == .afinacion)
        #expect(TipoDeEscala.shierLu.fuente == .lushiChunqiu)
        #expect(
            Escala(.do, .shierLu).notas.map(\.description)
                == ["Do", "Do♯", "Re", "Re♯", "Mi", "Mi♯", "Fa♯", "Sol", "Sol♯", "La", "La♯", "Si"])
        // Cada lü, a un número de quintas de huángzhōng: zhònglǚ, a once, no vuelve a Fa (la coma pitagórica).
        let quinta = 1200 * log2(1.5)
        let pitagoricos = TipoDeEscala.shierLu.intervalos.map { intervalo -> Int in
            let cents = (Double(intervalo.pasosDeQuinta) * quinta).truncatingRemainder(dividingBy: 1200)
            return Int((cents < 0 ? cents + 1200 : cents).rounded())
        }
        let afinaciones = TipoDeEscala.shierLu.afinaciones
        #expect(afinaciones.map(\.fuente) == [nil, "Zhu Zaiyu, 1584"])
        #expect(afinaciones[0].pasos == pitagoricos)
        #expect(afinaciones[0].pasos[5] - 498 == 24)
        #expect(afinaciones[1].desvios.allSatisfy { $0 == 0 })
        // Las dos mitades: tonos enteros con un paso de 180 cents.
        for tipo in [TipoDeEscala.yanglu, .yinlu] {
            let semitonos = Set(TipoDeEscala.tonosEnteros.intervalos.map(\.semitonos))
            #expect(Set(tipo.intervalos.map(\.semitonos)) == semitonos, Comment(rawValue: tipo.nombre))
            let pasos = try #require(tipo.microtonal).pasos + [1200]
            let saltos = zip(pasos.dropFirst(), pasos).map { $0 - $1 }
            #expect(saltos.sorted() == [180, 204, 204, 204, 204, 204], Comment(rawValue: tipo.nombre))
        }
        #expect(
            Escala(Nota(.do, .sostenido), .yinlu).notas.map(\.description) == ["Do♯", "Re♯", "Mi♯", "Sol", "La", "Si"])
        #expect((try? Escala(leyendo: "Do 十二律"))?.tipo.nombre == "Shí'èr lǜ")
        #expect((try? Escala(leyendo: "Do 六律"))?.tipo.nombre == "Yánglǜ")
        #expect((try? Escala(leyendo: "Do 六吕"))?.tipo.nombre == "Yīnlǜ")
        // En ruso y griego, transcritos; en los demás idiomas, en pinyin.
        let ruso = Notacion.compacta(.espanol).conTextos(en: .ruso)
        #expect(TipoDeEscala.shierLu.nombre(en: ruso) == "Шиэр люй")
        #expect(TipoDeEscala.yinlu.nombre(en: Notacion.compacta(.espanol).conTextos(en: .griego)) == "Γινλιου")
        #expect(TipoDeEscala.yanglu.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "Yánglǜ")
    }

    /// Los modos con musica ficta del Renacimiento y la musica recta, en tres mesotónicos y en la afinación justa de
    /// Ramos de Pareja.
    @Test func elRenacimiento() throws {
        #expect(
            TipoDeEscala.escalasRenacentistas.map(\.nombre) == [
                "dórico con ficta", "mixolidio con ficta", "lidio con si bemol", "musica recta",
            ])
        #expect(TipoDeEscala.escalasRenacentistas.allSatisfy { $0.tradicion == .renacimiento })
        #expect(TipoDeEscala.doricoConFicta.afinacionSugerida == .mesotonico)
        let dorico = Escala(.re, .doricoConFicta)
        #expect(dorico.notas.map(\.description) == ["Re", "Mi", "Fa", "Sol", "La", "Si", "Do♯"])
        #expect(
            dorico.notas(sentido: .descendente).map(\.description) == ["Re", "Mi", "Fa", "Sol", "La", "Si♭", "Do"])
        #expect(
            Escala(.do, .musicaRecta).notas.map(\.description) == ["Do", "Re", "Mi", "Fa", "Sol", "La", "Si♭", "Si"])
        #expect(TipoDeEscala.lidioConSiBemol.intervalos == TipoDeEscala.mayor.intervalos)
        // Cada afinación, la de su mesotónico: ¼ de coma (Aron), 2/7 (Zarlino) y ⅓ (Salinas), al cent.
        let temperamentos = [4.0, 3.5, 3.0].map { TemperamentoRegular.mesotonico(fraccionDeComa: $0) }
        for tipo in TipoDeEscala.escalasRenacentistas {
            let ramos: [String?] = tipo == .mixolidioConFicta ? [] : ["Ramos de Pareja, 1482"]
            #expect(tipo.afinaciones.map(\.fuente) == [nil, "Zarlino, 1558", "Salinas, 1577"] + ramos)
            for (afinacion, temperamento) in zip(tipo.afinaciones, temperamentos) {
                for sentido in [SentidoDelIntervalo.ascendente, .descendente] {
                    let pares = zip(afinacion.cents(sentido: sentido), afinacion.intervalos(sentido: sentido))
                    for (cents, intervalo) in pares {
                        #expect(abs(cents - temperamento.cents(de: intervalo)) <= 0.5, Comment(rawValue: tipo.nombre))
                    }
                }
            }
        }
        // Ramos: las razones de su monocordio desde Do (10/9, 5/4, 4/3, 3/2, 5/3, 16/9, 15/8), tomadas desde la final.
        let razones: [Double] = [1, 10 / 9, 5 / 4, 4 / 3, 3 / 2, 5 / 3, 16 / 9, 15 / 8]
        let recta = try #require(TipoDeEscala.musicaRecta.afinaciones.last)
        for (cents, razon) in zip(recta.cents(sentido: .ascendente), razones) {
            #expect(abs(cents - 1200 * log2(razon)) <= 0.5)
        }
        // En el dórico, la cuarta Re–Sol es la del lobo, 27/20; el Do♯ es 135/128 sobre Do.
        let doricoDeRamos = try #require(TipoDeEscala.doricoConFicta.afinaciones.last)
        #expect(doricoDeRamos.cents(sentido: .ascendente)[3] == 520)
        #expect(abs(doricoDeRamos.cents(sentido: .ascendente)[6] - 1200 * log2(135.0 / 64 / (10.0 / 9))) <= 0.5)
        // Zarlino numera los doce modos desde Do.
        #expect((try? TipoDeEscala(leyendo: "modo 1 de Zarlino"))?.nombre == "ionicus")
        #expect((try? TipoDeEscala(leyendo: "modo 3 de Zarlino"))?.nombre == "protus authenticus")
        #expect((try? TipoDeEscala(leyendo: "modo 12 de Zarlino"))?.nombre == "hypoaeolius")
    }

    /// Los tres géneros de Vicentino, en diesis de sus 31 partes: 3 + 5 + 5, 3 + 2 + 8 y 1 + 2 + 10.
    @Test func losGenerosDeVicentino() throws {
        #expect(TipoDeEscala.generosDeVicentino.allSatisfy { $0.tradicion == .renacimiento && $0.fuente == .vicentino })
        #expect(TipoDeEscala.generosDeVicentino.allSatisfy { $0.categoria == .tetracordo })
        let notas = TipoDeEscala.generosDeVicentino.map { Escala(.mi, $0).notas.map(\.description) }
        #expect(notas == [["Mi", "Fa", "Sol", "La"], ["Mi", "Fa", "Fa♯", "La"], ["Mi", "Fa♭", "Fa", "La"]])
        let diesis = 1200.0 / 31
        for (tipo, partes) in zip(TipoDeEscala.generosDeVicentino, [[0, 3, 8, 13], [0, 3, 5, 13], [0, 1, 3, 13]]) {
            let cents = try #require(tipo.microtonal).cents
            for (c, p) in zip(cents, partes) {
                #expect(abs(c - Double(p) * diesis) <= 0.5, Comment(rawValue: tipo.nombre))
            }
        }
        let ingles = Notacion.compacta(.espanol).conTextos(en: .ingles)
        #expect(TipoDeEscala.tetracordoEnarmonicoDeVicentino.nombre(en: ingles) == "Vicentino's enharmonic tetrachord")
        #expect(TipoDeEscala.doricoConFicta.nombre(en: ingles) == "Dorian with ficta")
        #expect(TipoDeEscala.musicaRecta.nombre(en: ingles) == "musica recta")
    }

    /// Las chinas suenan por sanfen sunyi: cada nota, a un número de quintas pitagóricas de gōng.
    @Test func lasChinasPorSanfenSunyi() throws {
        #expect(TipoDeEscala.chinas.allSatisfy { $0.microtonal != nil })
        #expect(try #require(TipoDeEscala.gong.microtonal).pasos == [0, 204, 408, 702, 906])
        #expect(try #require(TipoDeEscala.qingyue.microtonal).desvios[3] == 22)
        #expect(TipoDeEscala.tradicionales(fuente: .guanzi) == [.gong, .shang, .jue, .zhi, .yu])
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
        #expect(Set(TipoDeEscala.in.equivalentes.map(\.nombre)) == ["Miyakobushi", "Ambassäl", "Pélog pathet nem"])
        // Con macrones, sin ellos y en japonés.
        for (texto, nombre) in [
            ("Do Hirajōshi", "Hirajōshi"), ("Do hirajoshi", "Hirajōshi"), ("Do 平調子", "Hirajōshi"),
            ("Do Ryūkyū", "Ryūkyū"), ("Do ryukyu", "Ryūkyū"), ("Do okinawa", "Ryūkyū"),
            ("Re min'yō", "Min'yō"), ("Re minyo", "Min'yō"), ("Re yo", "Yō"), ("Mi in", "In"),
            ("Mi miyako-bushi", "Miyakobushi"), ("Do kumoi", "Kumoijōshi"), ("Do 岩戸", "Iwato"),
        ] {
            #expect((try? Escala(leyendo: texto))?.tipo.nombre == nombre, Comment(rawValue: texto))
        }
        #expect(Escala(.do, .hirajoshi).nombre(en: .ascii(.ingles)) == "C Hirajōshi")
        #expect(!(TipoDeEscala.occidentales.contains { $0.nombre == "Hirajōshi" }))
    }

    @Test func harmoniaiMakamlarMaqamatPathetYRagasNuevos() {
        func notas(_ tipo: TipoDeEscala, _ tonica: Nota = .do) -> String {
            Escala(tonica, tipo).notas.map(\.description).joined(separator: " ")
        }
        // Las siete harmoniai son las siete especies de octava de la escala de Mi a Mi.
        #expect(TipoDeEscala.harmoniaMixolidia == .locrio)
        #expect(TipoDeEscala.harmoniaHipolidia == .lidio)
        #expect(TipoDeEscala.harmoniaHipofrigia == .mixolidio)
        #expect(TipoDeEscala.harmoniaHipodoria == .menorNatural)
        #expect(notas(.tetracordoEnarmonico, .mi) == "Mi Fa♭ Fa La")
        // Makamlar: varios son las notas de otro makam en otra perde.
        #expect(TipoDeEscala.mahurMakami == .mayor && TipoDeEscala.acemasiranMakami == .mayor)
        #expect(TipoDeEscala.sultaniyegahMakami == .nihavendMakami)
        #expect(notas(.sultaniyegahMakami, .re) == "Re Mi Fa Sol La Si♭ Do♯")
        #expect(TipoDeEscala.sedarabanMakami == .dobleArmonica && TipoDeEscala.zirguleliHicazMakami == .dobleArmonica)
        #expect(TipoDeEscala.humayunMakami == .frigioDominante)
        #expect(notas(.uzzalMakami, .la) == "La Si♭ Do♯ Re Mi Fa♯ Sol")
        #expect(TipoDeEscala.uzzalMakami.intervalos == TipoDeEscala.hicazMakami.intervalos)
        // Maqamat sin cuartos de tono.
        #expect(notas(.atharKurd) == "Do Re♭ Mi♭ Fa♯ Sol La♭ Si")
        #expect(TipoDeEscala.maqamNikriz == .nikriz && TipoDeEscala.maqamNikriz.categoria == .maqam)
        #expect(TipoDeEscala.lami == .locrio)
        #expect(TipoDeEscala.sabaZamzam == .saba)
        // Pathet y modos de Bali, cada grado del pélog de nueve partes iguales redondeado desde su tónica.
        #expect(TipoDeEscala.pelogLima == .pelog)
        #expect(notas(.pelogNem, .sol) == "Sol La♭ Do Re Mi♭")
        #expect(notas(.pelogBarang, .la) == "La Si♭ Re Mi Sol♯")
        #expect(TipoDeEscala.pelogSunaren == .pelog && TipoDeEscala.pelogTembung == .pelog)
        // El sléndro, equidistante: los tres pathet tienen los mismos intervalos.
        #expect(TipoDeEscala.slendroSanga == .slendro && TipoDeEscala.slendroManyura == .slendro)
        #expect(TipoDeEscala.slendroNem == .egipcia)
        // Rāgas: los cuatro suben y bajan en línea recta.
        #expect(notas(.lalit) == "Do Re♭ Mi Fa Fa♯ La♭ Si")
        #expect(TipoDeEscala.mohanakalyani.formaAscendente.intervalos == TipoDeEscala.mohanam.intervalos)
        #expect(notas(.mohanakalyani.formaDescendente) == "Do Re Mi Fa♯ Sol La Si")
        #expect(notas(.saveri) == "Do Re♭ Fa Sol La♭")
        #expect(notas(.nata) == "Do Re♯ Mi Fa Sol La♯ Si")
        #expect(notas(.nata.formaDescendente) == "Do Re♯ Fa Sol Si")
        // Se leen por su nombre, con sus letras y sin ellas, y la sexta disminuida de Barry Harris es el bebop.
        for (texto, nombre) in [
            ("Re Sultaniyegah makami", "Sultânîyegâh makamı"), ("La makam Uzzal", "Uzzâl makamı"),
            ("Re Sedaraban makami", "Şedaraban makamı"), ("Do Athar Kurd", "Āthār Kurd"),
            ("Do maqam Nikriz", "maqām Nikrīz"), ("Re Saba Zamzam", "Ṣabā Zamzam"), ("Do Tembung", "Pélog tembung"),
            ("Do Slendro manyura", "Sléndro pathet manyura"), ("Do Mohanakalyani", "Mohanakalyāṇi"),
            ("Do Lalit", "Lalit"), ("Si harmonia mixolidia", "harmonía mixolidia"),
        ] {
            #expect((try? Escala(leyendo: texto))?.tipo.nombre == nombre, Comment(rawValue: texto))
        }
        #expect(Escala("Do sexta disminuida").tipo == .bebopMayor)
        #expect(Escala("C minor sixth diminished").tipo == .bebopMenorMelodica)
    }

    @Test func afinacionesBabilonicas() {
        func notas(_ tipo: TipoDeEscala, _ tonica: Nota = .do) -> String {
            Escala(tonica, tipo).notas.map(\.description).joined(separator: " ")
        }
        // En la reconstrucción de Kilmer con escalas descendentes, cada afinación es uno de los siete modos diatónicos.
        #expect(TipoDeEscala.isartu == .mayor)
        // Su versión microtonal, pitagórica: el tritono del lidio es de 612 cents y el del locrio, de 588.
        #expect(TipoDeEscala.isartu.microtonal?.cents == [0, 204, 408, 498, 702, 906, 1110])
        #expect(TipoDeEscala.qablitu.microtonal?.cents == [0, 204, 408, 612, 702, 906, 1110])
        #expect(TipoDeEscala.nisTuhri.microtonal?.cents == [0, 90, 294, 498, 588, 792, 996])
        #expect(TipoDeEscala.mesopotamicas.allSatisfy { $0.microtonal?.sistema == .razones })
        #expect(TipoDeEscala.kitmu == .mixolidio)
        #expect(TipoDeEscala.embubu == .dorico)
        #expect(TipoDeEscala.pitu == .menorNatural)
        #expect(TipoDeEscala.nidQabli == .frigio)
        #expect(TipoDeEscala.nisTuhri == .locrio)
        #expect(TipoDeEscala.qablitu == .lidio)
        #expect(notas(.nidQabli, .mi) == "Mi Fa Sol La Si Do Re")
        // En el orden de UET VII 74, cada una baja un semitono una sola nota de la anterior (y qablītu, la tónica).
        let lista = TipoDeEscala.mesopotamicas
        for (anterior, siguiente) in zip(lista, lista.dropFirst()) {
            let a = Set(Escala(.do, anterior).notas.map(\.claseDeAltura))
            let b = Set(Escala(.do, siguiente).notas.map(\.claseDeAltura))
            // De nīš tuḫri a qablītu baja la cuerda de la tónica: qablītu queda sobre Si.
            let bajada = siguiente == .qablitu ? 11 : 0
            let traspuesta = Set(b.map { ($0 + bajada) % 12 })
            #expect(a.subtracting(traspuesta).count == 1, Comment(rawValue: siguiente.nombre))
        }
        // Se encuentran con o sin diacríticos, con la mimación y con la lectura antigua de nīš tuḫri.
        for (texto, nombre) in [
            ("isartu", "išartu"), ("ishartu", "išartu"), ("išartum", "išartu"), ("nid qabli", "nīd qabli"),
            ("nis gabari", "nīš tuḫri"), ("nish tuhri", "nīš tuḫri"), ("qablitum", "qablītu"), ("embubu", "embūbu"),
        ] {
            #expect((try? TipoDeEscala(leyendo: texto))?.nombre == nombre, Comment(rawValue: texto))
        }
        #expect((try? Escala(leyendo: "Re pitu"))?.tipo.nombre == "pītu")
        #expect(!(TipoDeEscala.occidentales.contains { $0.nombre == "išartu" }))
    }

    @Test func gramaMurchanaYGenerosGriegos() {
        // Los grāma y las mūrchanā se encuentran sin diacríticos y en devanagari.
        #expect((try? TipoDeEscala(leyendo: "shadja grama"))?.nombre == "ṣaḍja-grāma")
        #expect((try? TipoDeEscala(leyendo: "Suddhasadja"))?.nombre == "Śuddhaṣaḍjā")
        #expect((try? TipoDeEscala(leyendo: "सौवीरी"))?.nombre == "Sauvīrī")
        #expect((try? TipoDeEscala(leyendo: "tetracordo pitagórico"))?.nombre == "tetracordo diatónico ditónico")
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

    /// Los colores de Aristóxeno, en doceavos de tono, y los adwār de Ṣafī al-Dīn, pitagóricos.
    @Test func aristoxenoYSafiAlDin() throws {
        #expect(TipoDeEscala.coloresDeAristoxeno.allSatisfy { $0.tradicion == .greciaAntigua })
        #expect(TipoDeEscala.coloresDeAristoxeno.allSatisfy { $0.categoria == .tetracordo })
        #expect(TipoDeEscala.tetracordoCromaticoBlandoDeAristoxeno.microtonal?.desvios == [0, -33, 33, 0])
        #expect(TipoDeEscala.tetracordoCromaticoHemiolico.microtonal?.desvios == [0, -25, -50, 0])
        #expect(try TipoDeEscala(leyendo: "cromático tónico") == .tetracordoCromatico)
        #expect(TipoDeEscala.adwar.allSatisfy { $0.tradicion == .mundoArabe && $0.categoria == .maqam })
        #expect(TipoDeEscala.shaddNawa == .menorNatural)
        #expect(TipoDeEscala.shaddRast.microtonal?.desvios == [0, 4, -16, -2, 2, -18, -4])
        #expect((try? TipoDeEscala(leyendo: "Rast de Safi al-Din"))?.nombre == "shadd Rāst")
    }

    /// El folklore europeo: tres escalas populares, dos instrumentos de afinación natural y el canto georgiano, con
    /// sus cents.
    @Test func elFolkloreEuropeo() throws {
        #expect(TipoDeEscala.tradicionales(tradicion: .europa) == TipoDeEscala.europeas)
        #expect(TipoDeEscala.europeas.allSatisfy { $0.categoria == .escala })
        #expect(TipoDeEscala.doricoUcraniano == .doricoCuartaAumentada)
        #expect(TipoDeEscala.podhalanska == .lidioDominante)
        #expect(TipoDeEscala.pentatonicaHungara == .pentatonicaMenor)
        #expect(TipoDeEscala.gaitaEscocesa == .mixolidio)
        // El nombre gana al alias: «dórico ucraniano» es ya la escala europea, igual que el dórico ♯4.
        let ucraniano = try TipoDeEscala(leyendo: "dórico ucraniano")
        #expect(ucraniano.nombre == "dórico ucraniano" && ucraniano.tradicion == .europa)
        #expect((try? TipoDeEscala(leyendo: "Podhale"))?.nombre == "podhalańska")
        #expect((try? TipoDeEscala(leyendo: "Alphorn"))?.nombre == "cuerno alpino")
        let alpino = Escala("Do cuerno alpino").notas.map(\.nombre)
        #expect(alpino == ["Do", "Re", "Mi", "Fa♯", "Sol", "La♭", "Si♭", "Si"])
        // El 11.º armónico, 49 cents bajo Fa♯; la 7ª natural de la gaita, 31 bajo Si♭.
        #expect(TipoDeEscala.cuernoAlpino.microtonal?.desvios[3] == -49)
        #expect(TipoDeEscala.gaitaEscocesa.microtonal?.desvios[6] == -31)
        #expect(TipoDeEscala.mixolidio.microtonal == nil)
        // El canto georgiano: la segunda, 37 cents baja; la tercera, neutra, 32 sobre Mi♭.
        #expect(TipoDeEscala.georgiana == .dorico)
        #expect(TipoDeEscala.georgiana.microtonal?.desvios == [0, -37, 32, 9, -7, -32, 18])
        #expect((try? TipoDeEscala(leyendo: "Svaneti"))?.nombre == "georgiana")
        #expect(TipoDeEscala.georgiana.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "Georgian")
        #expect(Tradicion.europa.nombre == "Folklore europeo")
        #expect(Escala(.do, .istriana).notas.map(\.description).joined(separator: " ") == "Do Re♭ Mi♭ Fa♭ Sol♭ La𝄫")
        #expect(TipoDeEscala.istriana.subtradicion == .istria && Subtradicion.istria.nombre == "Istria")
        #expect(Subtradicion.istria.nombre(en: Notacion.compacta(.espanol).conTextos(en: .aleman)) == "Istrien")
        #expect(Tradicion.europa.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "European folk")
    }

    /// Vietnam, Brasil y el arpa birmana.
    @Test func vietnamBrasilYMyanmar() {
        #expect(
            TipoDeEscala.tradicionales(tradicion: .vietnam).map(\.nombre) == [
                "Bắc", "Vọng cổ", "Hò mái nhì", "Sa mạc", "Dân ca",
            ])
        #expect(TipoDeEscala.hoMaiNhi == .bac && !TipoDeEscala.hoMaiNhi.esIdentico(a: .bac))
        #expect(TipoDeEscala.saMac.microtonal?.cents == [0, 338, 504, 699, 1026])
        #expect(TipoDeEscala.danCa == .pentatonicaMayorTerceraMenor)
        #expect(TipoDeEscala.bac.microtonal?.cents == [0, 189, 501, 698, 891])
        #expect((try? TipoDeEscala(leyendo: "hoi oan"))?.nombre == "Vọng cổ")
        #expect(TipoDeEscala.tradicionales(tradicion: .brasil).count == 3)
        #expect(TipoDeEscala.lidioNordestino == .lidioDominante)
        #expect((try? TipoDeEscala(leyendo: "nordestina"))?.nombre == "lidio dominante")
        #expect(TipoDeEscala.saung.tradicion == .sudesteAsiatico && TipoDeEscala.saung.clase == .afinacion)
        #expect(TipoDeEscala.saung.microtonal?.desvios == [0, -18, -36, -9, -27])
        #expect(Tradicion.vietnam.nombre(en: Notacion.compacta(.espanol).conTextos(en: .portugues)) == "Vietname")
        #expect(Tradicion.brasil.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "Brazil")
    }
}

/// Acordes, escalas y tonalidades se consultan con las mismas etiquetas: `notas:`, `alturas:`, `clasesDeAltura:` y
/// `midi:`.
@Suite struct LasMismasConsultasTests {
    @Test func lasEscalasConAlturasYMidi() {
        let alturas = [Altura("Do4"), Altura("Mi4"), Altura("Sol4"), Altura("Si4"), Altura("Fa#4")]
        #expect(Escala.candidatos(alturas: alturas) == Escala.candidatos(notas: alturas.map(\.nota)))
        #expect(Escala.identificar(alturas: alturas).first == Escala("Do pentatónica lidia"))
        #expect(Escala.candidatos(midi: alturas.map(\.midi)) == Escala.candidatos(clasesDeAltura: [0, 4, 7, 11, 6]))
        #expect(Escala.identificar(midi: [60, 64, 67, 71, 66]).first == Escala("Do pentatónica lidia"))
    }

    @Test func lasTonalidadesConClasesDeAltura() {
        let midi = [69, 71, 72, 74, 76, 77, 80, 81]
        #expect(Tonalidad.candidatos(clasesDeAltura: midi.map { $0 % 12 }) == Tonalidad.candidatos(midi: midi))
        #expect(Tonalidad.candidatos(clasesDeAltura: midi.map { $0 % 12 }).first?.valor == Tonalidad("La menor"))
    }

    @Test func losAcordesConAlturas() {
        #expect(Acorde.identificar(alturas: [Altura("Mi3"), Altura("Sol3"), Altura("Do4")]).first == Acorde("Do/Mi"))
    }
}
