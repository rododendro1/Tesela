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
