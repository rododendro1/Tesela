import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria
@testable import ArmoniaTrastes

@Suite struct MastilTests {
    @Test func alturasAlAireDeLaGuitarra() {
        let mastil = Mastil(.guitarra)
        let midis = (0..<6).map { mastil.midi(en: PosicionEnElMastil(cuerda: $0, traste: 0)) }
        #expect(midis == [40, 45, 50, 55, 59, 64]) // Mi2 La2 Re3 Sol3 Si3 Mi4
    }

    @Test func alturaEnUnTraste() {
        let mastil = Mastil(.guitarra)
        // Cuerda de La, traste 3: Do3.
        #expect(mastil.altura(en: PosicionEnElMastil(cuerda: 1, traste: 3)) == Altura(.do, octava: 3))
        // Cuerda de Mi grave, traste 1: Fa2.
        #expect(mastil.altura(en: PosicionEnElMastil(cuerda: 0, traste: 1)) == Altura(.fa, octava: 2))
    }

    @Test func bemolesSiSePide() {
        let mastil = Mastil(.guitarra)
        let posicion = PosicionEnElMastil(cuerda: 1, traste: 1) // Si♭2 / La♯2
        #expect(mastil.altura(en: posicion, preferirBemoles: true).nota.nombre == "Si♭")
        #expect(mastil.altura(en: posicion).nota.nombre == "La♯")
    }

    @Test func posicionesDeUnaAltura() {
        let mastil = Mastil(.guitarra, trastes: 12)
        // El Mi4 suena al aire en la cuerda aguda, en el traste 5 de la Si y en el 9 de la Sol;
        // en las demás cuerdas está más allá del traste 12.
        let posiciones = mastil.posiciones(de: Altura(.mi, octava: 4))
        #expect(
            posiciones == [
                PosicionEnElMastil(cuerda: 5, traste: 0), PosicionEnElMastil(cuerda: 4, traste: 5),
                PosicionEnElMastil(cuerda: 3, traste: 9),
            ])
    }

    @Test func posicionesDeUnaNotaEnCualquierOctava() {
        let mastil = Mastil(.guitarra, trastes: 12)
        // Mi: 0 y 12 en las dos cuerdas de Mi, 7 en La, 2 en Re, 9 en Sol y 5 en Si.
        #expect(mastil.posiciones(de: Nota.mi).count == 8)
    }

    @Test func enarmonicosDanLasMismasPosiciones() {
        let mastil = Mastil(.guitarra)
        #expect(mastil.posiciones(de: Nota("Fa#")) == mastil.posiciones(de: Nota("Solb")))
    }

    @Test func posicionesFueraDelMastilNoExisten() {
        let mastil = Mastil(.guitarra, trastes: 12)
        #expect(!mastil.contiene(PosicionEnElMastil(cuerda: 6, traste: 0)))
        #expect(!mastil.contiene(PosicionEnElMastil(cuerda: 0, traste: 13)))
        #expect(mastil.contiene(PosicionEnElMastil(cuerda: 0, traste: 12)))
    }

    @Test func escalaEnUnRangoDeTrastes() {
        let mastil = Mastil(.guitarra)
        let doMayor = Escala(.do, .mayor)
        let primera = mastil.posiciones(de: doMayor, trastes: 0...4)
        #expect(!primera.isEmpty)
        #expect(primera.allSatisfy { (0...4).contains($0.traste) })
        // Todas suenan una nota de la escala.
        let clases = Set(doMayor.notas.map(\.claseDeAltura))
        #expect(primera.allSatisfy { clases.contains(Mastil.clase(mastil.midi(en: $0))) })
    }

    @Test func otrosEncordados() {
        #expect(Encordado.bajoElectrico.numeroDeCuerdas == 4)
        #expect(Encordado.guitarraDeSieteCuerdas.numeroDeCuerdas == 7)
        #expect(Encordado.guitarraEnReGrave.cuerdas.first == Altura(.re, octava: 2))
        // El ukelele es reentrante: la primera cuerda (Sol4) está más aguda que la segunda (Do4).
        #expect(Encordado.ukelele.cuerdas[0].midi > Encordado.ukelele.cuerdas[1].midi)
    }

    @Test func posicionesFueraDelMastilSinDetenerElPrograma() {
        let mastil = Mastil(.guitarra, trastes: 12)
        #expect(mastil.midiSiExiste(en: PosicionEnElMastil(cuerda: 0, traste: 13)) == nil)
        #expect(mastil.midiSiExiste(en: PosicionEnElMastil(cuerda: 6, traste: 0)) == nil)
        #expect(mastil.midiSiExiste(en: PosicionEnElMastil(cuerda: -1, traste: 0)) == nil)
        #expect(mastil.alturaSiExiste(en: PosicionEnElMastil(cuerda: 0, traste: -1)) == nil)
        #expect(mastil.midiSiExiste(en: PosicionEnElMastil(cuerda: 0, traste: 0)) == Altura(.mi, octava: 2).midi)
        let tercer = PosicionEnElMastil(cuerda: 1, traste: 3)
        #expect(mastil.alturaSiExiste(en: tercer) == mastil.altura(en: tercer))
        #expect(mastil.midiSiExiste(en: tercer) == mastil.midi(en: tercer))
    }

    @Test func unNumeroNegativoDeTrastesSeTomaComoCero() {
        let mastil = Mastil(.guitarra, trastes: -5)
        #expect(mastil.trastes == 0)
        // Solo cuerdas al aire: el Mi está en la primera cuerda (Mi2) y en la última (Mi4).
        #expect(mastil.posiciones(de: Nota.mi).map(\.cuerda) == [0, 5])
    }
}

@Suite struct DigitacionTests {
    private let guitarra = Mastil(.guitarra)

    @Test func doMayorAbierto() throws {
        let formas = guitarra.digitaciones(de: try Acorde(leyendo: "Do"), limite: 100)
        #expect(
            formas.map(\.tablatura).contains("x32010"),
            Comment(rawValue: formas.map(\.tablatura).joined(separator: " ")))
    }

    @Test func miMenorAbierto() throws {
        let formas = guitarra.digitaciones(de: try Acorde(leyendo: "Mim"), limite: 100)
        #expect(formas.map(\.tablatura).contains("022000"))
    }

    @Test func elBajoEsLaNotaMasGrave() throws {
        // En Do/Mi la nota más grave es Mi, no Do.
        let acorde = try Acorde(leyendo: "Do/Mi")
        let formas = guitarra.digitaciones(de: acorde, limite: 50)
        #expect(!formas.isEmpty)
        for forma in formas {
            let grave = try #require(forma.alturas.map(\.midi).min())
            #expect(Mastil.clase(grave) == Nota.mi.claseDeAltura, Comment(rawValue: forma.tablatura))
        }
    }

    @Test func todasLasFormasTocanElAcordeEntero() throws {
        let acorde = try Acorde(leyendo: "Sol7")
        let clases = Set(acorde.notas.map(\.claseDeAltura))
        for forma in guitarra.digitaciones(de: acorde) {
            let tocadas = Set(forma.alturas.map { $0.nota.claseDeAltura })
            #expect(tocadas == clases, Comment(rawValue: forma.tablatura))
            #expect(forma.abertura <= 4, Comment(rawValue: forma.tablatura))
            #expect(forma.cuerdasQueSuenan >= 4, Comment(rawValue: forma.tablatura))
        }
    }

    @Test func lasCuerdasQueSuenanSonSeguidas() throws {
        for forma in guitarra.digitaciones(de: try Acorde(leyendo: "La7"), limite: 100) {
            let suenan = forma.trastes.map { $0 != nil }
            let primera = try #require(suenan.firstIndex(of: true))
            let ultima = try #require(suenan.lastIndex(of: true))
            #expect(suenan[primera...ultima].allSatisfy { $0 }, Comment(rawValue: forma.tablatura))
        }
    }

    @Test func elLimiteSeRespeta() throws {
        #expect(guitarra.digitaciones(de: try Acorde(leyendo: "Do"), limite: 3).count <= 3)
    }

    @Test func cifraConTrastesAltos() {
        let forma = Digitacion(mastil: guitarra, trastes: [nil, 10, 12, 12, 11, 10])
        #expect(forma.tablatura == "x-10-12-12-11-10")
        #expect(forma.abertura == 3)
        #expect(forma.posicion == 10)
    }

    @Test func ukeleleDoMayor() throws {
        // Do mayor en el ukelele soprano: 0003.
        let ukelele = Mastil(.ukelele, trastes: 12)
        let formas = ukelele.digitaciones(de: try Acorde(leyendo: "Do"), limite: 100)
        #expect(
            formas.map(\.tablatura).contains("0003"), Comment(rawValue: formas.map(\.tablatura).joined(separator: " ")))
    }
}

extension DigitacionTests {
    @Test func comprobandoLosTrastes() {
        let guitarra = Mastil(.guitarra)
        #expect(Digitacion(comprobando: [nil, 3, 2, 0, 1, 0], en: guitarra) != nil)
        #expect(Digitacion(comprobando: [nil, 3, 2, 0, 1], en: guitarra) == nil) // falta una cuerda
        #expect(Digitacion(comprobando: [nil, 3, 2, 0, 1, -1], en: guitarra) == nil) // traste negativo
        #expect(Digitacion(comprobando: [nil, 3, 2, 0, 1, 25], en: guitarra) == nil) // más allá del último (24)
    }

    @Test func leyendoLaCifra() {
        let guitarra = Mastil(.guitarra)
        #expect(Digitacion(leyendo: "x32010", en: guitarra)?.tablatura == "x32010")
        #expect(Digitacion(leyendo: "X32010", en: guitarra)?.tablatura == "x32010")
        #expect(Digitacion(leyendo: "x-10-12-12-11-10", en: guitarra)?.tablatura == "x-10-12-12-11-10")
        #expect(Digitacion(leyendo: "x3201", en: guitarra) == nil) // faltan cuerdas
        #expect(Digitacion(leyendo: "x32a10", en: guitarra) == nil) // «a» no es un traste
        #expect(Digitacion(leyendo: "x-10--12-12-11-10", en: guitarra) == nil) // hueco vacío
        #expect(Digitacion(leyendo: "", en: guitarra) == nil)
    }

    @Test func laCifraVuelveALaMismaDigitacion() throws {
        let guitarra = Mastil(.guitarra)
        for cifrado in ["Do", "Sol7/Si", "Rem7", "Fa"] {
            for forma in guitarra.digitaciones(de: try Acorde(leyendo: cifrado), limite: 20) {
                #expect(Digitacion(leyendo: forma.tablatura, en: guitarra) == forma, Comment(rawValue: forma.tablatura))
            }
        }
    }

    @Test func lasNotasSeEscribenComoElAcorde() throws {
        let acorde = try Acorde(leyendo: "Sib")
        let forma = try #require(Mastil(.guitarra).digitaciones(de: acorde, limite: 1).first)
        let nombres = forma.notas(para: acorde).map { $0.nombre(en: .espanolUnicode) }
        #expect(nombres.count == forma.cuerdasQueSuenan)
        #expect(nombres.contains("Si♭"), Comment(rawValue: nombres.joined(separator: " ")))
        #expect(!nombres.contains("La♯"), Comment(rawValue: nombres.joined(separator: " ")))
    }
}

@Suite struct EncordadoNombreTests {
    @Test func buscarUnInstrumentoPorNombre() {
        #expect(Encordado(nombre: "Guitarra") == .guitarra)
        #expect(Encordado(nombre: "UKULELE") == .ukelele)
        #expect(Encordado(nombre: "bajo de 5 cuerdas") == .bajoDeCincoCuerdas)
        #expect(Encordado(nombre: "Drop-D") == .guitarraEnReGrave)
        #expect(Encordado(nombre: "guitarra en re grave") == .guitarraEnReGrave)
        #expect(Encordado(nombre: "mandolin") == .mandolina)
    }

    @Test func buscarUnInstrumentoEnOtroIdioma() {
        #expect(Encordado(nombre: "guitare") == .guitarra)
        #expect(Encordado(nombre: "Gitarre") == .guitarra)
        #expect(Encordado(nombre: "гитара") == .guitarra)
        #expect(Encordado(nombre: "bandolim") == .mandolina)
        #expect(Encordado(nombre: "baix de cinc cordes") == .bajoDeCincoCuerdas)
    }

    @Test func todosSeEncuentranPorSuNombreEnCadaIdioma() {
        for encordado in Encordado.todos {
            for nombre in encordado.traduccion?.todos ?? [] {
                #expect(Encordado(nombre: nombre) == encordado, Comment(rawValue: nombre))
            }
        }
    }

    @Test func unNombreDesconocidoNoEsNingunInstrumento() {
        #expect(Encordado(nombre: "arpa") == nil)
        #expect(Encordado(nombre: "") == nil)
    }

    @Test func todosSeEncuentranPorSuNombre() {
        for encordado in Encordado.todos {
            #expect(Encordado(nombre: encordado.nombre) == encordado, Comment(rawValue: encordado.nombre))
        }
    }
}

// MARK: - Dedos, cejilla y orden de comodidad

@Suite struct DedosYOrdenTests {
    private let guitarra = Mastil(.guitarra)
    private let ukelele = Mastil(.ukelele)

    private func forma(_ cifra: String) throws -> Digitacion {
        try #require(Digitacion(leyendo: cifra, en: guitarra), Comment(rawValue: cifra))
    }

    // MARK: Dedos y cejilla

    @Test func losDedosDeFormasConocidas() throws {
        let formas: [(String, Int, Int?)] = [
            ("x32010", 3, nil), ("xx0232", 3, nil), ("320003", 3, nil), ("022100", 3, nil),
            ("x02020", 2, nil), ("020100", 2, nil), ("xx3211", 3, nil), ("x32310", 4, nil),
            // Un dedo plano pisa cuerdas seguidas en el traste más bajo.
            ("x02220", 1, nil), ("022000", 1, nil),
            // Cejilla: cuatro cuerdas o más con el índice en el traste más bajo.
            ("133211", 4, 1), ("133111", 3, 1), ("x13331", 4, 1), ("x24432", 4, 2),
        ]
        for (cifra, dedos, cejilla) in formas {
            let digitacion = try forma(cifra)
            #expect(digitacion.dedos == dedos, "dedos de \(cifra)")
            #expect(digitacion.cejilla == cejilla, "cejilla de \(cifra)")
        }
    }

    @Test func sinTrastesPisadosNoHacenFaltaDedos() throws {
        #expect(try (forma("000000").dedos) == 0)
        #expect(try (forma("xx0000").dedos) == 0)
        #expect(try (forma("000000").cejilla) == nil)
    }

    @Test func unaCuerdaAlAireEnMedioImpideLaCejilla() throws {
        // El Re (cuerda 2) al aire: el índice no puede cubrir del Mi al Mi agudo en el traste 1.
        #expect(try (forma("1x0xx1").cejilla) == nil)
        #expect(try (forma("1x0xx1").dedos) == 2)
    }

    @Test func elLimiteDeDedosSeRespeta() throws {
        let acorde = try Acorde(leyendo: "Mim")
        for tope in [4, 2, 1] {
            let formas = guitarra.digitaciones(de: acorde, maximoDeDedos: tope, limite: 200)
            #expect(!formas.isEmpty, "tope \(tope)")
            #expect(formas.allSatisfy { $0.dedos <= tope }, "tope \(tope)")
        }
        // Con menos dedos hay menos formas, y el Mi menor abierto cabe en uno.
        let con1 = guitarra.digitaciones(de: acorde, maximoDeDedos: 1, limite: 200).map(\.tablatura)
        #expect(con1.contains("022000"))
        #expect(con1.count < guitarra.digitaciones(de: acorde, limite: 200).count)
        #expect(guitarra.digitaciones(de: acorde, maximoDeDedos: 0, limite: 200).isEmpty)
    }

    @Test func ningunaFormaPorDefectoNecesitaMasDeCuatroDedos() throws {
        for cifrado in ["Do", "Sol7", "Fa", "Sib", "Rem7", "Fa#m7b5", "Do9"] {
            for forma in guitarra.digitaciones(de: try Acorde(leyendo: cifrado), limite: 200) {
                #expect(forma.dedos <= 4, "\(cifrado) \(forma.tablatura)")
            }
        }
    }

    // MARK: Formas de manual

    /// Las formas que un guitarrista espera ver primero, con la quinta opcional (como las pide la aplicación).
    @Test func lasFormasDeManualSonLasPrimeras() throws {
        let manual: [(String, [String])] = [
            ("Do", ["x32010"]), ("Sol", ["320003", "320033"]), ("Re", ["xx0232"]), ("La", ["x02220"]),
            ("Mi", ["022100"]), ("Lam", ["x02210"]), ("Mim", ["022000"]), ("Rem", ["xx0231"]),
            ("Sol7", ["320001"]), ("Do7", ["x32310"]), ("Re7", ["xx0212"]), ("La7", ["x02020"]),
            ("Mi7", ["020100"]), ("Si7", ["x21202"]), ("Lam7", ["x02010"]), ("Mim7", ["020000", "022030"]),
            ("Domaj7", ["x32000"]), ("Famaj7", ["102210", "xx3210"]), ("Solmaj7", ["320002"]),
            ("Resus2", ["xx0230"]), ("Rem7", ["xx0211"]), ("Fam", ["133111"]),
        ]
        for (cifrado, esperadas) in manual {
            let primera = try #require(
                guitarra.digitaciones(de: try Acorde(leyendo: cifrado), exigirQuinta: false, limite: 1).first,
                Comment(rawValue: cifrado))
            #expect(
                esperadas.contains(primera.tablatura), "\(cifrado): sale \(primera.tablatura), se esperaba \(esperadas)"
            )
        }
    }

    /// Otras formas de manual: antes de ellas puede haber alguna más fácil (Mi sus4 como `002200`), pero no muchas.
    @Test func lasDemasFormasDeManualEstanEntreLasPrimeras() throws {
        let manual: [(String, String)] = [
            ("Fa", "133211"), ("Sib", "x13331"), ("Resus4", "xx0233"), ("Lasus4", "x02230"), ("Misus4", "022200"),
            ("Doadd9", "x32030"), ("Sim", "x24432"), ("Fa#m", "244222"), ("Solm", "355333"), ("Dom", "x35543"),
        ]
        for (cifrado, esperada) in manual {
            let primeras = guitarra.digitaciones(de: try Acorde(leyendo: cifrado), exigirQuinta: false, limite: 6).map(
                \.tablatura)
            #expect(primeras.contains(esperada), "\(cifrado): \(primeras), se esperaba \(esperada)")
        }
    }

    @Test func laCercaniaALaCejillaPesaMasQueTenerTodasLasCuerdas() throws {
        // Antes, `8-10-10-0-8-0` (seis cuerdas, en el traste 8) iba por delante de `x32010`.
        let formas = guitarra.digitaciones(de: try Acorde(leyendo: "Do"), limite: 3).map(\.tablatura)
        #expect(formas.first == "x32010", Comment(rawValue: formas.joined(separator: " ")))
    }

    @Test func laQuintaPuedeFaltarSoloSiSePermite() throws {
        let acorde = try Acorde(leyendo: "Do7")
        // El Do7 de manual no tiene la quinta (Sol).
        #expect(!(guitarra.digitaciones(de: acorde, limite: 300).map(\.tablatura).contains("x32310")))
        #expect(guitarra.digitaciones(de: acorde, exigirQuinta: false, limite: 300).map(\.tablatura).contains("x32310"))
    }

    @Test func elMi7AbiertoEsLaPrimeraConLaQuintaOpcional() throws {
        let acorde = try Acorde(leyendo: "Mi7")
        let formas = guitarra.digitaciones(de: acorde, exigirQuinta: false, limite: 5)
        #expect(formas.first?.tablatura == "020100")
    }

    // MARK: Ukelele y otros instrumentos reentrantes

    @Test func queInstrumentosSonReentrantes() {
        #expect(Encordado.ukelele.esReentrante)
        for encordado in [
            Encordado.guitarra, .guitarraDeSieteCuerdas, .guitarraEnReGrave, .bajo, .bajoDeCincoCuerdas, .mandolina,
        ] {
            #expect(!encordado.esReentrante, Comment(rawValue: encordado.nombre))
        }
    }

    @Test func lasFormasBasicasDelUkelele() throws {
        let manual: [(String, String)] = [
            ("Do", "0003"), ("Sol", "0232"), ("Fa", "2010"), ("Lam", "2000"), ("Rem", "2210"),
            ("Re", "2220"), ("La", "2100"), ("Sol7", "0212"), ("Do7", "0001"),
        ]
        for (cifrado, esperada) in manual {
            let primera = try #require(
                ukelele.digitaciones(de: try Acorde(leyendo: cifrado), exigirQuinta: false, limite: 1).first,
                Comment(rawValue: cifrado))
            #expect(primera.tablatura == esperada, Comment(rawValue: cifrado))
        }
        let mim = ukelele.digitaciones(de: try Acorde(leyendo: "Mim"), exigirQuinta: false, limite: 3).map(\.tablatura)
        #expect(mim.contains("0432"), Comment(rawValue: mim.joined(separator: " ")))
    }

    @Test func unAcordeConBajoPropioExigeEseBajoTambienEnElUkelele() throws {
        let formas = ukelele.digitaciones(de: try Acorde(leyendo: "Do/Mi"), limite: 100)
        #expect(!formas.isEmpty)
        for forma in formas {
            let grave = try #require(forma.alturas.map(\.midi).min())
            #expect(Mastil.clase(grave) == Nota.mi.claseDeAltura, Comment(rawValue: forma.tablatura))
        }
        #expect(!(formas.map(\.tablatura).contains("0003"))) // ahí el Do es lo más grave
    }
}

@Suite struct NombresTraducidosTests {
    @Test func nombresDeLosInstrumentos() {
        #expect(Encordado.todos.map { $0.nombre(en: .espanolUnicode) } == Encordado.todos.map(\.nombre))
        #expect(Encordado.guitarraDeSieteCuerdas.titulo(en: .inglesASCII) == "Seven-string guitar")
        #expect(Encordado.mandolina.nombre(en: .portugues) == "bandolim")
        let propio = Encordado(nombre: "laúd", cuerdas: Encordado.guitarra.cuerdas)
        #expect(propio.nombre(en: .aleman) == "laúd")
    }

    @Test func nombresDeLasTransformaciones() {
        #expect(
            TransformacionNeorriemanniana.allCases.map { $0.nombre(en: .espanolUnicode) }
                == TransformacionNeorriemanniana.allCases.map(\.nombre))
        #expect(TransformacionNeorriemanniana.l.nombre(en: .inglesASCII) == "leading-tone exchange")
        #expect(TransformacionNeorriemanniana.r.nombre(en: .aleman) == "Parallele")
    }
}

@Suite struct ArpegioEnElMastilTests {
    @Test func lasPosicionesDeUnAcorde() {
        let mastil = Mastil(.guitarra, trastes: 12)
        let todas = mastil.posiciones(de: Acorde("Do"))
        #expect(!todas.isEmpty)
        #expect(todas.allSatisfy { [0, 4, 7].contains(Mastil.clase(mastil.midi(en: $0))) })
        let primeras = mastil.posiciones(de: Acorde("Do"), trastes: 0...3)
        #expect(primeras.allSatisfy { (0...3).contains($0.traste) })
        #expect(primeras.count == todas.filter { $0.traste <= 3 }.count)
    }

    @Test func elArpegioPorPosiciones() {
        let mastil = Mastil(.guitarra, trastes: 12)
        let lam = mastil.arpegios(de: Acorde("Lam"))
        // Desde La al aire (5.ª cuerda), desde el La del traste 5 de la 6.ª y desde el del 12 de la 5.ª, que
        // se queda dentro del mástil.
        #expect(lam.map(\.trastes) == [0...3, 4...7, 9...12])
        #expect(lam[0].alturas.map(\.midi) == [40, 45, 48, 52, 57, 60, 64])
        #expect(lam[1].alturas.map(\.midi) == [45, 52, 57, 60, 64, 69])
        #expect(lam[0].posiciones.first == PosicionEnElMastil(cuerda: 0, traste: 0))
        for arpegio in lam {
            // De grave a agudo, sin unísonos y dentro de la franja.
            #expect(arpegio.alturas.map(\.midi) == arpegio.alturas.map(\.midi).sorted())
            #expect(Set(arpegio.alturas.map(\.midi)).count == arpegio.alturas.count)
            #expect(arpegio.posiciones.allSatisfy { arpegio.trastes.contains($0.traste) })
        }
        #expect(mastil.arpegios(de: Acorde("Do")).map(\.trastes) == [2...5, 7...10])
        // En un solo traste no caben las tres notas.
        #expect(mastil.arpegios(de: Acorde("Do"), ancho: 1).isEmpty)
    }
}

@Suite struct EscalaEnElMastilTests {
    @Test func tresNotasPorCuerda() {
        let mastil = Mastil(.guitarra, trastes: 15)
        let posiciones = mastil.posicionesPorCuerda(de: Escala(.sol, .mayor))
        #expect(posiciones.count == 7)
        let primera = posiciones[0]
        #expect(primera.trastes == (0...5))
        #expect(primera.forma == nil)
        #expect(primera.posiciones.count == 18)
        #expect(primera.posiciones.filter { $0.cuerda == 0 }.map(\.traste) == [0, 2, 3])
        #expect(primera.posiciones.filter { $0.cuerda == 4 }.map(\.traste) == [1, 3, 5])
        // Las alturas suben de nota en nota de la escala: Mi2 Fa♯2 Sol2 La2…
        let alturas = primera.alturas
        #expect(alturas.first == Altura(.mi, octava: 2))
        #expect(zip(alturas, alturas.dropFirst()).allSatisfy { $0.midi < $1.midi })
        let clases = Set(Escala(.sol, .mayor).notas.map(\.claseDeAltura))
        for posicion in posiciones {
            #expect(posicion.alturas.allSatisfy { clases.contains($0.nota.claseDeAltura) })
            #expect(posicion.trastes.upperBound <= 15)
        }
        // Las posiciones van de la más baja a la más alta.
        #expect(posiciones.map(\.trastes.lowerBound) == posiciones.map(\.trastes.lowerBound).sorted())
    }

    @Test func dosNotasPorCuerdaEnLasPentatonicas() {
        let posiciones = Mastil(.guitarra, trastes: 15).posicionesPorCuerda(de: Escala(.la, .pentatonicaMenor))
        #expect(posiciones.count == 5)
        #expect(posiciones.allSatisfy { $0.posiciones.count == 12 })
        let dosPorCuerda = Mastil(.guitarra, trastes: 15).posicionesPorCuerda(
            de: Escala(.sol, .mayor), notasPorCuerda: 2)
        #expect(dosPorCuerda.first?.posiciones.count == 12)
    }

    @Test func cAGED() {
        let mastil = Mastil(.guitarra, trastes: 15)
        let enDo = mastil.posicionesCAGED(de: Escala(.do, .mayor))
        #expect(enDo.map(\.forma) == [.c, .a, .g, .e, .d])
        #expect(enDo.map(\.trastes) == [0...4, 2...6, 5...9, 7...11, 9...13])
        let enSol = mastil.posicionesCAGED(de: Escala(.sol, .mayor))
        #expect(enSol.map(\.forma) == [.g, .e, .d, .c, .a])
        #expect(enSol.map(\.trastes) == [0...4, 2...6, 4...8, 7...11, 9...13])
        // Cada forma lleva las notas de la escala de su franja, y la tónica.
        for posicion in enDo {
            #expect(posicion.posiciones.allSatisfy { posicion.trastes.contains($0.traste) })
            #expect(posicion.alturas.contains { $0.nota.claseDeAltura == Nota.do.claseDeAltura })
        }
        // En un mástil corto no caben todas.
        #expect(Mastil(.guitarra, trastes: 9).posicionesCAGED(de: Escala(.do, .mayor)).count == 3)
    }

    @Test func fueraDeLaGuitarraNoHayPosiciones() {
        #expect(Mastil(.ukelele).posicionesPorCuerda(de: Escala(.do, .mayor)).isEmpty)
        #expect(Mastil(.bajoElectrico).posicionesCAGED(de: Escala(.do, .mayor)).isEmpty)
        #expect(!(Mastil(.bajoElectrico).posicionesPorCuerda(de: Escala(.do, .mayor)).isEmpty))
    }
}

/// El capo: las cuerdas suben y los trastes se cuentan desde él.
@Suite struct CapoTests {
    @Test func elCapoSubeLasCuerdas() {
        let conCapo = Encordado.guitarra.conCapo(2)
        #expect(conCapo.capo == 2)
        #expect(conCapo.cuerdas.map(\.midi) == [42, 47, 52, 57, 61, 66])
        #expect(conCapo.sinCapo == .guitarra)
        #expect(conCapo.conCapo(3).cuerdas.map(\.midi) == [43, 48, 53, 58, 62, 67])
        #expect(Encordado.guitarra.conCapo(0) == .guitarra)
        #expect(Encordado.guitarra.conCapo(-1) == .guitarra)
        // El nombre sigue siendo el del instrumento.
        #expect(conCapo.nombre(en: .inglesASCII) == Encordado.guitarra.nombre(en: .inglesASCII))
    }

    @Test func lasFormasConCapo() throws {
        // Con el capo en el 2, la forma de Do suena Re.
        let mastil = Mastil(Encordado.guitarra.conCapo(2), trastes: 13)
        let re = mastil.digitaciones(de: Acorde("Re"))
        #expect(re.first?.tablatura == "x32010")
        #expect(try (#require(re.first).alturas.map(\.midi)) == [50, 54, 57, 62, 66])
        let arpegios = mastil.arpegios(de: Acorde("Re"))
        #expect(!arpegios.isEmpty)
        let clases = Set(arpegios.flatMap(\.alturas).map { $0.midi % 12 })
        #expect(clases == [2, 6, 9])
    }
}
