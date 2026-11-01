import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

@Suite struct AnalisisArmonicoTests {
    private func cifrados(
        _ texto: String, en tonalidad: Tonalidad? = nil,
        sourceLocation: SourceLocation = #_sourceLocation
    ) -> [String] {
        do {
            return try AnalisisArmonico.analizar(leyendo: texto, en: tonalidad).cifrados
        } catch {
            Issue.record("«\(texto)»: \(error)", sourceLocation: sourceLocation)
            return []
        }
    }

    private func tonalidad(_ texto: String) -> Tonalidad? {
        try? AnalisisArmonico.analizar(leyendo: texto).tonalidad
    }

    @Test func diatonicos() {
        #expect(cifrados("Do Fa Sol7 Do") == ["I", "IV", "V7", "I"])
        #expect(cifrados("Rem7 Sol7 Domaj7") == ["ii7", "V7", "Imaj7"])
        #expect(cifrados("Re La Sim Fa#m Sol Re Sol La") == ["I", "V", "vi", "iii", "IV", "I", "IV", "V"])
        #expect(cifrados("Do Sim° Do") == ["I", "vii°", "I"])
        #expect(cifrados("Do Sim7(b5) Do") == ["I", "viiø7", "I"])
    }

    @Test func menor() {
        // En menor, la sensible es propia: V y vii° son diatónicos, sin alteración en el numeral.
        #expect(cifrados("Lam Rem Mi7 Lam") == ["i", "iv", "V7", "i"])
        #expect(cifrados("Sim7(b5) Mi7 Lam") == ["iiø7", "V7", "i"])
        #expect(cifrados("Lam Sol#°7 Lam") == ["i", "vii°7", "i"])
        #expect(cifrados("Lam Fa Do Sol") == ["i", "VI", "III", "VII"])
        #expect(tonalidad("Lam Fa Do Sol") == Tonalidad(.la, .menor))
    }

    @Test func inversiones() {
        #expect(cifrados("Do Fa/La Sol7/Si Do") == ["I", "IV6", "V65", "I"])
        #expect(cifrados("Do/Sol Sol7/Re Do/Mi", en: Tonalidad(.do)) == ["I64", "V43", "I6"])
        #expect(cifrados("Sol7/Fa Do/Mi", en: Tonalidad(.do)) == ["V42", "I6"])
        // La sexta añadida no se confunde con la primera inversión.
        #expect(cifrados("Mim6 Do6 Fa6/La Lam", en: Tonalidad(.do)) == ["iii(add6)", "I(add6)", "IV(add6)643", "vi"])
        #expect(cifrados("Mim Mim/Sol", en: Tonalidad(.do)) == ["iii", "iii6"])
        // Invertidos, con todos los intervalos sobre el bajo.
        #expect(cifrados("Fa6/La Fa6/Do Fa6/Re", en: Tonalidad(.do)) == ["IV(add6)643", "IV(add6)642", "IV(add6)753"])
        #expect(cifrados("Dosus4/Fa Do(add9)/Mi", en: Tonalidad(.do)) == ["Isus452", "I(add9)763"])
        #expect(cifrados("Sim7(b5)/Re Mi7 Lam", en: Tonalidad(.la, .menor)) == ["iiø65", "V7", "i"])
    }

    @Test func dominantesSecundarias() {
        #expect(cifrados("Do Lam Re7 Sol7 Do") == ["I", "vi", "V7/V", "V7", "I"])
        #expect(cifrados("Do La7 Rem Sol7 Do") == ["I", "V7/ii", "ii", "V7", "I"])
        #expect(cifrados("Do Do7 Fa Sol Do") == ["I", "V7/IV", "IV", "V", "I"])
        #expect(cifrados("Do Mi Lam Sol Do") == ["I", "V/vi", "vi", "V", "I"])
        #expect(cifrados("Do Re7/Fa# Sol", en: Tonalidad(.do)) == ["I", "V65/V", "V"])

        let analisis = try! AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        #expect(analisis.acordes[2].categoria == .dominanteSecundaria(de: 5))
        #expect(analisis.acordes[2].funcion == .dominante)
        #expect(analisis.acordes[2].grado == 2)
    }

    @Test func sensiblesSecundarias() {
        #expect(cifrados("Do Fa#°7 Sol Do") == ["I", "vii°7/V", "V", "I"])
        #expect(cifrados("Do Do#° Rem Sol Do") == ["I", "vii°/ii", "ii", "V", "I"])
        let analisis = try! AnalisisArmonico.analizar(leyendo: "Do Fa#°7 Sol Do")
        #expect(analisis.acordes[1].categoria == .sensibleSecundaria(de: 5))
    }

    @Test func napolitanaYPrestamos() {
        #expect(cifrados("Do Reb/Fa Sol7 Do") == ["I", "♭II6", "V7", "I"])
        #expect(cifrados("Lam Sib/Re Mi7 Lam") == ["i", "♭II6", "V7", "i"])
        #expect(cifrados("Do Fam Do") == ["I", "iv", "I"])
        #expect(cifrados("Do Lab Sib Do") == ["I", "♭VI", "♭VII", "I"])
        #expect(cifrados("Do Mib Fa Do") == ["I", "♭III", "IV", "I"])
        #expect(tonalidad("Do Lab Sib Do") == Tonalidad(.do))
        // Tercera de picardía: el I mayor al final de una obra en menor.
        let picardia = try! AnalisisArmonico.analizar(leyendo: "Lam Rem/Fa Mi7 La")
        #expect(picardia.tonalidad == Tonalidad(.la, .menor))
        #expect(picardia.cifrados == ["i", "iv6", "V7", "I"])
        #expect(picardia.acordes[3].categoria == .prestamo)
        #expect(picardia.acordes[3].funcion == .tonica)
    }

    @Test func napolitanaInvertida() {
        #expect(cifrados("Do Reb Sol7 Do") == ["I", "♭II", "V7", "I"])
        #expect(cifrados("Do Reb/Lab Sol7 Do") == ["I", "♭II64", "V7", "I"])
        #expect(cifrados("Lam Sib/Re Mi7 Lam", en: Tonalidad(.la, .menor)) == ["i", "♭II6", "V7", "i"])
    }

    @Test func sextasAumentadas() {
        #expect(cifrados("Do Lab(#6,omit5) Sol Do") == ["I", "It+6", "V", "I"])
        #expect(cifrados("Do Lab(#6,#11,omit5) Sol Do") == ["I", "Fr+6", "V", "I"])
        #expect(cifrados("Do Lab(#6) Do/Sol Sol7 Do") == ["I", "Ger+6", "I64", "V7", "I"])
        #expect(cifrados("Lam Fa(#6,omit5) Mi Lam") == ["i", "It+6", "V", "i"])
        // La francesa escrita desde el Re (Re7(♭5) con La♭ en el bajo) es el mismo acorde.
        #expect(cifrados("Do Fa Re7(b5)/Lab Sol Do") == ["I", "IV", "Fr+6", "V", "I"])
        // La alemana escrita como La♭7 solo lo es si va a la dominante.
        #expect(cifrados("Do Lab7 Sol Do") == ["I", "Ger+6", "V", "I"])
        #expect(cifrados("Do Lab7 Do", en: Tonalidad(.do)) == ["I", "♭VI7", "I"])
        let analisis = try! AnalisisArmonico.analizar(leyendo: "Do Lab(#6) Sol Do")
        #expect(analisis.acordes[1].categoria == .sextaAumentada)
        #expect(analisis.acordes[1].funcion == .subdominante)
        // Las comas de dentro del paréntesis no separan acordes.
        #expect(cifrados("Do7(b9,#11), Fa", en: Tonalidad(.fa)) == ["V7(♭9,♯11)", "I"])
    }

    @Test func cromaticos() {
        let analisis = Tonalidad(.do).analizar(["Do", "Fa#", "Do"])
        #expect(analisis.cifrados == ["I", "♯IV", "I"])
        #expect(analisis.acordes[1].categoria == .cromatico)
        #expect(analisis.acordes[1].funcion == nil)
    }

    @Test func funciones() {
        let analisis = try! AnalisisArmonico.analizar(leyendo: "Do Lam Rem Sol7 Mim Sim° Do")
        #expect(analisis.funciones == [.tonica, .tonica, .subdominante, .dominante, .tonica, .dominante, .tonica])
        #expect(analisis.funciones.map { $0!.abreviatura }.joined() == "TTSDTDT")
        #expect(FuncionTonal.subdominante.nombre(en: .inglesASCII) == "subdominant")
    }

    @Test func deteccionDeTonalidad() {
        #expect(tonalidad("Do Fa Sol7 Do") == Tonalidad(.do))
        #expect(tonalidad("Sol Re/Fa# Mim Do Re7 Sol") == Tonalidad(.sol))
        #expect(tonalidad("Am | Dm | E7 | Am") == Tonalidad(.la, .menor))
        #expect(tonalidad("Sol7 Do") == Tonalidad(.do))
        #expect(tonalidad("Fa Sol Lam") == Tonalidad(.la, .menor))
        #expect(tonalidad("Mib Lab Sib7 Mib") == Tonalidad(Nota(.mi, .bemol)))
    }

    @Test func textoYNotaciones() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "C, F, G7, C")
        #expect("\(analisis)" == "I–IV–V7–I en Do mayor")
        #expect(analisis.nombre(en: .inglesASCII) == "I–IV–V7–I in C major")
        #expect(try (AnalisisArmonico.analizar(leyendo: "Do–Fa–Sol7–Do").cifrados) == ["I", "IV", "V7", "I"])
        #expect(
            try (AnalisisArmonico.analizar(leyendo: "Lam | Rem | Mi7 | Lam", en: "La menor").cifrados) == [
                "i", "iv", "V7", "i",
            ])
    }

    @Test func errores() throws {
        do {
            _ = try AnalisisArmonico.analizar(leyendo: "Do Fa Hm Do")
            Issue.record("Se esperaba un error")
        } catch {
            let error = error as? ErrorDeLectura
            #expect(error?.texto == "Do Fa Hm Do")
            #expect(error?.posicion == 6)
            guard case .notaNoReconocida? = error?.motivo else {
                Issue.record("\(String(describing: error))")
                return
            }

        }
        do {
            _ = try AnalisisArmonico.analizar(leyendo: "  | ")
            Issue.record("Se esperaba un error")
        } catch {
            guard case .textoVacio? = (error as? ErrorDeLectura)?.motivo else {
                Issue.record("\(error)")
                return
            }

        }
        #expect(AnalisisArmonico.analizar([]) == nil)
    }

    /// La progresión transportada se analiza igual en la tonalidad transportada.
    @Test func transposicion() {
        let progresion: [Acorde] = ["Do", "Lam", "Re7", "Sol7", "Do", "Fam", "Reb", "Sol7", "Do"]
        let original = Tonalidad(.do).analizar(progresion).cifrados
        for tonica in Escala.circuloDeQuintas().map(\.tonica) {
            let intervalo = Nota.do.intervalo(hasta: tonica)
            let transportada = progresion.map { $0 + intervalo }
            #expect(Tonalidad(tonica).analizar(transportada).cifrados == original, "\(tonica)")
        }
    }
}
