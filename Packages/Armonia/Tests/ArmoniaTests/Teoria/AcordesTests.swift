import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

@Suite struct AcordeTests {
    @Test func notas() {
        #expect(Acorde(.do, .mayor).notas == [.do, .mi, .sol])
        #expect(Acorde("Sol7").notas.map(\.nombre) == ["Sol", "Si", "Re", "Fa"])
        #expect(Acorde("Fa#m7b5").notas.map(\.nombre) == ["Fa♯", "La", "Do", "Mi"])
        #expect(Acorde("Mib°7").notas.map(\.nombre) == ["Mi♭", "Sol♭", "Si♭♭", "Re♭♭"])
        #expect(Acorde("Do6/9").notas.map(\.nombre) == ["Do", "Mi", "Sol", "La", "Re"])
        #expect(Acorde("Do6/9").bajo == .do)
        #expect(Acorde("Rem11").notas.count == 6)
    }

    @Test func cifrado() {
        #expect(Acorde("Rem7").cifrado == "Rem7")
        #expect(Acorde("Dm7").cifrado == "Rem7")
        #expect(Acorde("G7(b9,#11)").cifrado == "Sol7(♭9,♯11)")
        #expect(Acorde("Sol7/Si").inversion == 1)
        #expect(Acorde("Sol7/Si").bajo == .si)
        #expect(Acorde("Sol7/Si").cifrado == "Sol7/Si")
        #expect(Acorde("Do6/9/Mi").cifrado == "Do6/9/Mi")
        #expect(Acorde(texto: "Doxyz") == nil)
    }

    @Test func nombreDeLaInversion() {
        #expect(Acorde.nombreDeLaInversion(0, en: .espanolCompacto) == "estado fundamental")
        #expect(Acorde.nombreDeLaInversion(1, en: .inglesASCII) == "first inversion")
        #expect(Acorde.nombreDeLaInversion(6, en: .espanolCompacto) == "sexta inversión")
        #expect(Acorde.nombreDeLaInversion(2, en: .aleman) == "zweite Umkehrung")
        #expect(Acorde.nombreDeLaInversion(7, en: .espanolCompacto) == "inversión 7")
        #expect(Acorde.nombreDeLaInversion(7, en: .aleman) == "7. Umkehrung")
        #expect(Acorde("Sol7/Si").nombre(en: .frances).hasSuffix(", premier renversement"))
    }

    @Test func bajoAjeno() {
        let acorde = Acorde("Do/Re")
        #expect(acorde.tieneBajoAjeno)
        #expect(acorde.inversion == nil)
        #expect(acorde.cifrado == "Do/Re")
        #expect(acorde.posicionCerrada(octava: 3).map(\.description) == ["Re3", "Do4", "Mi4", "Sol4"])
        #expect(acorde.transponer(.segundaMayor).cifrado == "Re/Mi")
    }

    @Test func disposicion() {
        #expect(Acorde("Do/Mi").posicionCerrada(octava: 4).map(\.description) == ["Mi4", "Sol4", "Do5"])
        #expect(Acorde("Do9").posicionCerrada(octava: 3).map(\.description) == ["Do3", "Mi3", "Sol3", "Si♭3", "Re4"])
    }

    @Test func identificacion() {
        #expect(Acorde.identificar([.mi, .sol, .do]).first == Acorde(.do, .mayor, inversion: 1))

        let ambiguo = Acorde.identificar([Nota.la, .do, .mi, .sol]).map(\.cifrado)
        #expect(ambiguo.first == "Lam7")
        #expect(ambiguo.contains("Do6/La"))

        let porAltura = Acorde.identificar([Altura("Fa4"), Altura("Si3"), Altura("Re4"), Altura("Sol3")])
        #expect(porAltura.first?.cifrado == "Sol7")

        // La ortografía importa: Do–Mi–Sol♯ es Do aumentado; Do–Mi–La♭ es La♭ aumentado sobre Do.
        #expect(Acorde.identificar([.do, .mi, Nota("Sol#")]).first == Acorde(.do, .aumentado))
        #expect(Acorde.identificar([.do, .mi, Nota("Lab")]).first == Acorde(Nota("Lab"), .aumentado, inversion: 1))
    }

    @Test func sextasAumentadas() throws {
        let italiana = try Acorde(leyendo: "Lab(#6,omit5)")
        #expect(italiana.notas == ["La♭", "Do", "Fa♯"])
        #expect(italiana.tipo.nombre == "sexta aumentada italiana")
        #expect(italiana.tipo.estructura.papel(de: .sextaAumentada) == .sexta)
        #expect(Acorde.identificar(["La♭", "Do", "Fa♯"] as [Nota]).first?.description == "La♭(♯6,omit5)")
        #expect(Acorde.identificar(["La♭", "Do", "Mi♭", "Fa♯"] as [Nota]).first?.description == "La♭(♯6)")
        #expect(
            Acorde.identificar(["La♭", "Do", "Mi♭", "Fa♯"] as [Nota]).first?.tipo.nombre(en: .inglesASCII)
                == "German augmented sixth")
        let francesa = Acorde.identificar(["La♭", "Do", "Re", "Fa♯"] as [Nota])
        #expect(
            francesa.contains { $0.description == "La♭(♯6,♯11,omit5)" && $0.tipo.nombre == "sexta aumentada francesa" })
    }

    @Test func identificacionTolerante() {
        // Quinta omitida.
        let sinQuinta = Acorde.candidatos([.do, .mi, Nota("Sib")]).first
        #expect(sinQuinta?.valor.cifrado == "Do7")
        #expect(sinQuinta?.omitidas == [.sol])

        // Notas duplicadas.
        #expect(Acorde.identificar([.do, .mi, .sol, .do, .mi]).first?.cifrado == "Do")

        // Tensiones alteradas.
        #expect(Acorde.identificar([.do, .mi, Nota("Sib"), Nota("Reb")]).first?.cifrado == "Do7(♭9)")

        // Bajo ajeno al acorde.
        let conBajo = Acorde.identificar([.re, .do, .mi, .sol]).map(\.cifrado)
        #expect(conBajo.contains("Do/Re"))

        // Los costes salen ordenados.
        let costes = Acorde.candidatos([.re, .do, .mi, .sol]).map(\.coste)
        #expect(costes == costes.sorted())

        #expect(Acorde.identificar([.do, Nota("Do#")]).isEmpty)
    }

    @Test func transposicion() {
        #expect(Acorde("Sol7").transponer(.cuartaJusta).cifrado == "Do7")
        #expect(Acorde("Rem").transponer(.segundaMenor).cifrado == "Mi♭m")
    }
}

@Suite struct TipoDeAcordeTests {
    @Test func cifradoGenerativo() {
        let casos: [(String, String)] = [
            ("", ""), ("M", ""), ("m", "m"), ("min", "m"), ("dim", "°"), ("aug", "+"),
            ("5", "5"), ("sus", "sus4"), ("sus2", "sus2"),
            ("7", "7"), ("maj7", "maj7"), ("M7", "maj7"), ("Δ", "maj7"), ("7M", "maj7"),
            ("m7", "m7"), ("-7", "m7"), ("m7b5", "m7(♭5)"), ("ø", "m7(♭5)"),
            ("dim7", "°7"), ("°7", "°7"), ("mMaj7", "m(maj7)"), ("m(maj7)", "m(maj7)"),
            ("+7", "+7"), ("7#5", "+7"), ("7b5", "7(♭5)"), ("+maj7", "+maj7"),
            ("6", "6"), ("m6", "m6"), ("6/9", "6/9"), ("69", "6/9"), ("m6/9", "m6/9"),
            ("9", "9"), ("maj9", "maj9"), ("m9", "m9"), ("m(maj9)", "m(maj9)"),
            ("11", "11"), ("m11", "m11"), ("13", "13"), ("m13", "m13"), ("maj13", "maj13"),
            ("7sus4", "7sus4"), ("9sus4", "9sus4"), ("13sus4", "13sus4"),
            ("add9", "(add9)"), ("add2", "(add9)"), ("madd9", "m(add9)"), ("sus4add9", "sus4(add9)"),
            ("m(add♭13)", "m(add♭13)"),
            ("7(b9)", "7(♭9)"), ("7b9", "7(♭9)"), ("7-9", "7(♭9)"), ("7+9", "7(♯9)"),
            ("7b9#11", "7(♭9,♯11)"), ("7(♭9, ♯11)", "7(♭9,♯11)"), ("maj7#11", "maj7(♯11)"),
            ("13(b9)", "13(♭9)"), ("7alt", "7(♭9,♯9,♯11,♭13)"),
            ("7(omit5)", "7(omit5)"), ("7no3", "7(omit3)"), ("m(omit5)", "m(omit5)"),
        ]
        for (entrada, esperado) in casos {
            guard let tipo = TipoDeAcorde(texto: entrada) else {
                Issue.record("No se pudo leer «\(entrada)»")
                continue
            }
            #expect(tipo.cifrado == esperado, "«\(entrada)»")
            // Lo que se genera se vuelve a leer igual.
            #expect(TipoDeAcorde(texto: tipo.cifrado) == tipo, "ida y vuelta de «\(entrada)»")
        }
    }

    @Test func cifradosNoValidos() {
        for texto in ["xyz", "7(b3)", "dimø", "7 9", "add", "omit"] {
            #expect(TipoDeAcorde(texto: texto) == nil, Comment(rawValue: texto))
        }
    }

    @Test func idaYVueltaDeLosPredefinidos() {
        for tipo in TipoDeAcorde.todos {
            #expect(TipoDeAcorde(texto: tipo.cifrado) == tipo, Comment(rawValue: tipo.nombre))
        }
    }

    @Test func igualdadPorContenido() {
        #expect(TipoDeAcorde("add2") == TipoDeAcorde("add9"))
        #expect(
            TipoDeAcorde(intervalos: [.unisono, .terceraMayor, .quintaJusta, .segundaMayor]) == .mayorNovenaAnadida)
        #expect(TipoDeAcorde("m7b5") == .semidisminuido)
        #expect(Set([TipoDeAcorde("Δ"), TipoDeAcorde("maj7"), TipoDeAcorde.mayorSeptimaMayor]).count == 1)
        #expect(TipoDeAcorde.mayorSexta != TipoDeAcorde.menorSeptima)
    }

    @Test func disposicionYNombres() {
        #expect(TipoDeAcorde("9").intervalos == [.unisono, .terceraMayor, .quintaJusta, .septimaMenor, .novenaMayor])
        #expect(TipoDeAcorde("7(b9,#11)").tensiones == [.novenaMenor, .undecimaAumentada])
        #expect(TipoDeAcorde("7(b9)").nombre == "séptima con novena menor")
        #expect(TipoDeAcorde("7(b9,#11)").nombre == "acorde 7(♭9,♯11)")
        #expect(TipoDeAcorde.dominanteSeptima.anadir(.novenaMayor) == .dominanteNovena)
        #expect(TipoDeAcorde.dominanteNovena.quitar(.quintaJusta)?.cifrado == "9(omit5)")
    }

    @Test func constantesDeTipoDeAcorde() {
        let cifrados: [(TipoDeAcorde, String)] = [
            (.dominanteSeptima, "7"), (.mayorSeptimaMayor, "maj7"), (.menorSeptima, "m7"),
            (.menorSeptimaMayor, "m(maj7)"), (.sus4Septima, "7sus4"), (.mayorSexta, "6"), (.menorSexta, "m6"),
            (.mayorSextaNovena, "6/9"), (.dominanteNovena, "9"), (.mayorSeptimaMayorNovena, "maj9"),
            (.menorSeptimaNovena, "m9"), (.mayorNovenaAnadida, "(add9)"), (.dominanteUndecima, "11"),
            (.menorSeptimaUndecima, "m11"), (.dominanteDecimotercera, "13"),
        ]
        for (tipo, cifrado) in cifrados {
            #expect(tipo == TipoDeAcorde(texto: cifrado), Comment(rawValue: cifrado))
            #expect(TipoDeAcorde.todos.contains(tipo), Comment(rawValue: cifrado))
        }
        #expect(TipoDeAcorde.todos.count == Set(TipoDeAcorde.todos).count)
    }
}

@Suite struct EstructuraTests {
    @Test func estructuraDeTipo() {
        let e = TipoDeAcorde("13(b9)").estructura
        #expect(e.tercera == .terceraMayor)
        #expect(e.quintasDelAcorde == [.quintaJusta])
        #expect(e.septima == .septimaMenor)
        #expect(e.tensiones == [.novenaMenor, .decimoterceraMayor])
        #expect(e.calidadDeTriada == .mayor)
        #expect(e.suspension == nil)
        #expect(e.sexta == nil)
        #expect(e.papel(de: .novenaMenor) == .tension(9))
        #expect(e.papel(de: .segundaMenor) == .tension(9))
        #expect(e.papel(de: .cuartaJusta) == nil)
    }

    @Test func calidadesDeTriada() {
        let casos: [(TipoDeAcorde, CalidadDeTriada)] = [
            ("", .mayor), ("m7", .menor), ("°7", .disminuida), ("m7b5", .disminuida),
            ("+maj7", .aumentada), ("7sus4", .suspendida), ("sus2", .suspendida),
            ("5", .potencia), ("7(omit3)", .sinTercera), ("7(b5)", .mayor),
        ]
        for (tipo, calidad) in casos {
            #expect(tipo.estructura.calidadDeTriada == calidad, Comment(rawValue: tipo.cifrado))
        }
        #expect(TipoDeAcorde("7(omit3)").estructura.omiteTercera)
        #expect(TipoDeAcorde("7(omit5)").estructura.omiteQuinta)
        #expect(TipoDeAcorde("7sus4").estructura.suspension == .cuartaJusta)
        #expect(TipoDeAcorde("m6").estructura.sexta == .sextaMayor)
        #expect(TipoDeAcorde("°7").estructura.septima == .septimaDisminuida)
        #expect(
            TipoDeAcorde(pasosDeQuinta: [0, 4, 1, -6])!.estructura.quintasDelAcorde == [
                .quintaDisminuida, .quintaJusta,
            ])
    }

    @Test func componentesDeAcorde() {
        let acorde: Acorde = "Sol7(b9)"
        #expect(acorde.componentes.map(\.papel) == [.fundamental, .tercera, .quinta, .septima, .tension(9)])
        #expect(acorde.componentes.map(\.nota.nombre) == ["Sol", "Si", "Re", "Fa", "La♭"])
        #expect(acorde.tercera == .si)
        #expect(acorde.quinta == .re)
        #expect(acorde.septima == .fa)
        #expect(acorde.tensiones == ["Lab"])
        #expect(acorde.papel(de: "Lab") == .tension(9))
        #expect(acorde.papel(de: .re) == .quinta)
        #expect(acorde.papel(de: .do) == nil)
        #expect(acorde.notas(conPapel: .septima) == [.fa])
        #expect(PapelEnAcorde.tension(11).nombre == "undécima")
        #expect(PapelEnAcorde.tension(13).nombre == "decimotercera")

        let alterado = Acorde(.do, TipoDeAcorde(pasosDeQuinta: [0, 4, 1, -6])!)
        #expect(alterado.quinta == .sol)
        #expect(Acorde("Do5").tercera == nil)
    }
}

@Suite struct EstilosTests {
    @Test func estilosPredefinidos() {
        let dominante: Acorde = "Sib7(b9)/Re"
        #expect(dominante.cifrado == "Si♭7(♭9)/Re")
        #expect(dominante.cifrado(estilo: .espanolASCII) == "Sib7(b9)/Re")
        #expect(dominante.cifrado(estilo: .inglesASCII) == "Bb7(b9)/D")

        #expect(Acorde("Dom7b5").cifrado(estilo: .jazz) == "Cø7")
        #expect(Acorde("Dom9b5").cifrado(estilo: .jazz) == "Cø9")
        #expect(Acorde("Domaj7").cifrado(estilo: .jazz) == "CΔ7")
        #expect(Acorde("Dom(maj7)").cifrado(estilo: .jazz) == "Cm(Δ7)")
        #expect(Acorde("Rem7").cifrado(estilo: .calidadesConPalabras) == "Remin7")
        #expect(Acorde("Si°").cifrado(estilo: .calidadesConPalabras) == "Sidim")
        #expect(Acorde("Fa+").cifrado(estilo: .calidadesConPalabras) == "Faaug")
        #expect(Acorde("Do#m(add9)").cifrado(estilo: .espanolASCII) == "Do#m(add9)")
    }

    @Test func laFundamentalFNoSeConfundeConFa() {
        let estilo = EstiloDeCifrado(notacion: .inglesASCII, aumentado: .aug)
        let acorde = Acorde(.fa, .aumentado)
        #expect(acorde.cifrado(estilo: estilo) == "Faug")
        #expect(Acorde("Faug") == acorde)
        #expect(Acorde("Faaug") == acorde)
    }

    @Test func adicionesEntreParentesis() {
        #expect(TipoDeAcorde.mayorNovenaAnadida.cifrado == "(add9)")
        #expect(Acorde("Do(add9)").cifrado == "Do(add9)")
        #expect(Acorde("Doadd9").cifrado == "Do(add9)")
        #expect(TipoDeAcorde(pasosDeQuinta: [0, -3, 1, -4])!.cifrado == "m(add♭13)")
    }

    @Test func cifradoDelTipoDeAcorde() {
        #expect(TipoDeAcorde.semidisminuido.cifrado == "m7(♭5)")
        #expect(TipoDeAcorde.semidisminuido.cifrado(estilo: .jazz) == "ø7")
        #expect(TipoDeAcorde("7(b9,#11)").cifrado(en: .inglesASCII) == "7(b9,#11)")
        #expect(Acorde("Sib7(b9)/Re").cifrado(en: .inglesASCII) == "Bb7(b9)/D")
    }
}

@Suite struct IdentificacionPorAlturaTests {
    private func primero(_ midi: [Int], tonalidad: Tonalidad? = nil) -> String? {
        Acorde.identificar(midi: midi, tonalidad: tonalidad).first?.cifrado
    }

    @Test func ortografiaSegunElAcorde() {
        #expect(primero([60, 64, 67]) == "Do")
        #expect(primero([60, 64, 68]) == "Do+")
        #expect(primero([60, 63, 66, 69]) == "Do°7")
        #expect(primero([61, 65, 68]) == "Re♭")
        #expect(primero([66, 70, 73]) == "Fa♯")
        #expect(primero([64, 68, 71]) == "Mi")
        #expect(primero([59, 62, 65, 69]) == "Sim7(♭5)")
        #expect(primero([55, 59, 62, 65, 68]) == "Sol7(♭9)")
        #expect(primero([58, 62, 65, 68, 72]) == "Si♭9")
        #expect(primero([60, 64, 70, 73]) == "Do7(♭9)")
        #expect(primero([60, 65, 67]) == "Dosus4")
        #expect(primero([60, 67]) == "Do5")
    }

    @Test func bajoInversionesYDuplicados() {
        #expect(primero([64, 67, 72]) == "Do/Mi")
        #expect(primero([48, 60, 64, 67, 72, 76]) == "Do")
        #expect(primero([57, 60, 64, 67]) == "Lam7")
        let conBajoAjeno = Acorde.identificar(midi: [62, 72, 76, 79]).map(\.cifrado)
        #expect(conBajoAjeno.first == "Re9sus4")
        #expect(conBajoAjeno.contains("Do/Re"))

        let sinQuinta = Acorde.candidatos(midi: [60, 64, 70]).first
        #expect(sinQuinta?.valor.cifrado == "Do7")
        #expect(sinQuinta?.omitidas == [.sol])

        #expect(Acorde.identificar(clasesDeAltura: [4, 7, 0]).first?.cifrado == "Do/Mi")
        #expect(Acorde.identificar(midi: [60, 61]).isEmpty)
        #expect(Acorde.identificar(midi: [60]).isEmpty)
    }

    @Test func tonalidad() {
        #expect(primero([66, 70, 73], tonalidad: Tonalidad("Solb mayor")) == "Sol♭")
        #expect(primero([66, 70, 73], tonalidad: Tonalidad("Si mayor")) == "Fa♯")
        #expect(primero([60, 64, 68], tonalidad: Tonalidad("La menor")) == "Do+")
        #expect(primero([61, 65, 68], tonalidad: Tonalidad("Fa# menor")) == "Do♯")
    }

    @Test func ortografiarMidi() {
        let acorde = Acorde.identificar(midi: [60, 64, 68]).first!
        #expect(acorde.ortografiar(midi: [60, 64, 68]).map(\.description) == ["Do4", "Mi4", "Sol♯4"])
        #expect(
            Acorde("Do°7").ortografiar(midi: [57, 60, 63, 66]).map(\.description) == ["Si♭♭3", "Do4", "Mi♭4", "Sol♭4"])
        #expect(Acorde("Do").ortografiar(midi: [61]).map(\.description) == ["Do♯4"])
        #expect(Altura(Nota("Sol#"), midi: 68)?.description == "Sol♯4")
        #expect(Altura(.la, midi: 68) == nil)
    }

    /// Lo que dice la versión con nombres no cambia al quitar la ortografía, cuando la
    /// ortografía de partida es la habitual.
    @Test func coincideConLaIdentificacionPorNombres() {
        let ejemplos: [[Nota]] = [
            ["Do", "Mi", "Sol"], ["Sol", "Si", "Re", "Fa"], ["La", "Do", "Mi", "Sol"],
            ["Do", "Mib", "Solb", "Sibb"], ["Re", "Fa", "La", "Do"],
        ]
        for nombres in ejemplos {
            let alturas = nombres.map(\.claseDeAltura)
            #expect(
                Acorde.identificar(clasesDeAltura: alturas).first == Acorde.identificar(nombres).first,
                Comment(rawValue: nombres.map(\.nombre).joined(separator: " ")))
        }
    }
}
