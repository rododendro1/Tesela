import ApoyoDePruebas
import Foundation
import Testing

@testable import Elementos
@testable import Polifonia
@testable import Teoria

@Suite struct ArmonizacionTests {
    // MARK: Acordes para una nota

    @Test func acordesParaUnaNota() {
        let doMayor = Tonalidad(.do)
        #expect(doMayor.acordes(para: .sol).prefix(3).map(\.valor) == ["Sol", "Do", "Sol7"])
        #expect(doMayor.acordes(para: .do).first?.valor == "Do")
        // Ordenados por coste.
        let costes = doMayor.acordes(para: .re).map(\.coste)
        #expect(costes == costes.sorted())
        // Una nota cromática: la dominante secundaria que la tiene.
        #expect(doMayor.acordes(para: "Fa#").map(\.valor).contains("Re7"))
        // Ninguno de la tonalidad tiene La♭: los del modo homónimo (iv y ♭VI).
        #expect(doMayor.acordes(para: "Lab").prefix(2).map(\.valor) == ["Fam", "Lab"])
        // El Do♯ también está en La♯°7/Sol, la disminuida de nota común del V.
        #expect(doMayor.acordes(para: "Do#").map(\.valor) == ["La", "La7", Acorde("La#°7").cambiarInversion(3)])
    }

    /// La séptima disminuida de nota común: sobre la nota común en el bajo, que se queda, y las demás voces por
    /// semitono o por grado hasta el acorde al que adorna.
    @Test func laDisminuidaDeNotaComun() throws {
        let doMayor = Tonalidad(.do)
        let disminuida = Acorde("Re#°7").cambiarInversion(3)
        #expect(disminuida.bajo == .do)
        // El Re♯ de la melodía solo lo tiene ella, y va al I.
        let armonizada = try doMayor.armonizarACuatroVoces(melodia: ["Mi5", "Re#5", "Mi5"])
        #expect(armonizada.armonizacion.acordes == ["Do", disminuida, "Do"])
        #expect(armonizada.armonizacion.cifrados[1].hasPrefix("♯ii°"))
        #expect(armonizada.coral.esCorrecta)
        let voces = (0..<4).map { armonizada.coral.voz($0) }
        // El bajo se queda en el Do, y ninguna voz salta más de un tono para ir y volver.
        #expect(voces[0].map(\.nota) == [.do, .do, .do])
        for voz in voces {
            #expect(zip(voz, voz.dropFirst()).allSatisfy { abs($0.midi - $1.midi) <= 2 }, "\(voz)")
        }
        // Sin pedal, la nota común también se queda en su voz.
        let coral = try Coral(realizando: ["Do", "Re#°7", "Do"], en: doMayor)
        let conElDo = try #require((0..<4).first { coral.voz($0)[1].nota == .do })
        #expect(coral.voz(conElDo)[2] == coral.voz(conElDo)[1])
        #expect(Coral.notaComun(de: "Re#°7", a: "Do") == .do && Coral.notaComun(de: "Sol7", a: "Do") == nil)
    }

    @Test func losPesos() {
        let pesos = PesosDeArmonizacion.habituales
        #expect(pesos.gradosEnMayor.count == 7 && pesos.gradosEnMenor.count == 7)
        #expect(pesos.grado(1, enMayor: true) == 0 && pesos.grado(3, enMayor: false) == 0.6)
        // La cadencia no cuesta; la retrogresión, más que cualquier otro paso entre funciones.
        #expect(pesos.dominanteAlI == 0 && pesos.cadenciaAutentica == 0)
        #expect(pesos.retrogresion > pesos.dominanteAOtraTonica && pesos.retrogresion > pesos.tonicaATonica)
    }

    // MARK: Armonizar

    private func cifrados(_ tonalidad: Tonalidad, _ melodia: String) -> [String] {
        let notas = melodia.split(separator: " ").map { try! Nota(leyendo: String($0)) }
        return tonalidad.armonizar(melodia: notas).first?.valor.cifrados ?? []
    }

    @Test func armonizar() {
        #expect(cifrados(Tonalidad(.do), "Mi Re Do") == ["I", "V", "I"])
        #expect(cifrados(Tonalidad(.do), "Do Re Mi Fa Re Si Do") == ["I", "V", "I", "IV", "ii", "V", "I"])
        #expect(cifrados(Tonalidad(.la, .menor), "Do Si La Sol# La") == ["i", "V", "i", "V", "i"])
        #expect(cifrados(Tonalidad(.sol), "Si La Sol") == ["I", "V", "I"])
    }

    @Test func propuestasOrdenadasYDistintas() {
        let propuestas = Tonalidad(.do).armonizar(melodia: ["Mi", "Re", "Do"], propuestas: 4)
        #expect(propuestas.count == 4)
        #expect(propuestas.map(\.coste) == propuestas.map(\.coste).sorted())
        #expect(Set(propuestas.map(\.valor.acordes)).count == 4)
        #expect(propuestas[0].valor.description == "Do Sol Do (I–V–I)")
        #expect(propuestas[0].valor.texto(en: .ascii(.ingles)) == "C G C (I–V–I)")
        #expect(propuestas[0].valor.melodia == ["Mi", "Re", "Do"])
    }

    @Test func terminaEnCadencia() {
        // Termina en el I precedido de la dominante, o en la dominante si la nota no es del I.
        for melodia in ["Sol La Si Do", "Mi Fa Sol La Sol Fa Mi Re Do", "Do Mi Re Si Do"] {
            let analisis = Tonalidad(.do).armonizar(
                melodia: melodia.split(separator: " ").map { try! Nota(leyendo: String($0)) })[0].valor.analisis
            #expect(analisis.cadencias.last?.tipo == .autentica, Comment(rawValue: melodia))
        }
        let semicadencia = cifrados(Tonalidad(.do), "Do Mi Fa Re")
        #expect(semicadencia.last == "V")
    }

    @Test func secundariaVaASuDestino() {
        // Fa♯ pide Re (V/V), que tiene que ir a Sol.
        let propuesta = Tonalidad(.do).armonizar(melodia: ["Mi", "Fa#", "Sol", "Do"])[0].valor
        #expect(propuesta.cifrados.prefix(3) == ["I", "V/V", "V"])
        for candidato in Tonalidad(.do).armonizar(melodia: ["Mi", "Fa#", "Sol", "Do"], propuestas: 10) {
            for (i, a) in candidato.valor.analisis.acordes.enumerated() {
                if case .dominanteSecundaria(let destino) = a.categoria {
                    #expect(candidato.valor.analisis.acordes[i + 1].grado == destino, "\(candidato.valor)")
                }
            }
        }
    }

    @Test func armonizarVacio() {
        #expect(Tonalidad(.do).armonizar(melodia: []) == [])
        #expect(Tonalidad(.do).armonizar(melodia: ["Do"], propuestas: 0) == [])
        #expect(Tonalidad(.do).armonizar(melodia: ["Do"]).first?.valor.acordes == ["Do"])
    }

    // MARK: Realizar a cuatro voces

    private func comprobarRealizacion(
        _ texto: String, en tonalidad: Tonalidad? = nil,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let acordes = texto.split(separator: " ").map { try! Acorde(leyendo: String($0)) }
        let coral: Coral
        do {
            coral = try Coral(realizando: acordes, en: tonalidad)
        } catch {
            Issue.record("«\(texto)» no se realiza: \(error)", sourceLocation: sourceLocation)
            return
        }
        #expect(coral.faltas == [], Comment(rawValue: texto), sourceLocation: sourceLocation)
        #expect(coral.acordes.count == acordes.count, sourceLocation: sourceLocation)
        for (acorde, voces) in zip(acordes, coral.acordes) {
            let notas = voces.map(\.nota)
            #expect(notas[0] == acorde.bajo, "bajo de \(acorde)", sourceLocation: sourceLocation)
            #expect(
                notas.allSatisfy { acorde.notas.contains($0) || $0 == acorde.bajo }, "\(acorde): \(voces)",
                sourceLocation: sourceLocation)
            for nota in acorde.notas where nota != acorde.quinta {
                #expect(notas.contains(nota), "falta \(nota) en \(acorde): \(voces)", sourceLocation: sourceLocation)
            }
            if let septima = acorde.septima {
                #expect(
                    notas.filter { $0 == septima }.count <= 1, "\(acorde): \(voces)", sourceLocation: sourceLocation)
            }
        }
    }

    @Test func realizar() {
        comprobarRealizacion("Do Fa Sol7 Do")
        comprobarRealizacion("Do Lam Rem Sol7 Do")
        comprobarRealizacion("Do Fa/La Sol7/Si Do")
        comprobarRealizacion("Do Sol7/Fa Do/Mi Fa Sol Do")
        comprobarRealizacion("Do Re7 Sol Do Lam Fa Sol7 Do")
        comprobarRealizacion("Lam Rem/Fa Mi7 Lam")
        comprobarRealizacion("Lam Sol#°7 Lam Sim7(b5) Mi7 Lam")
        comprobarRealizacion("Do Fa Do/Sol Sol7 Do")
        comprobarRealizacion("Sol Do Re7 Sol Mim Do Re Sol")
    }

    @Test func realizarConSoprano() throws {
        let soprano: [Altura] = ["Mi4", "Fa4", "Re4", "Do4"]
        let coral = try Coral(realizando: ["Do", "Fa", "Sol", "Do"], soprano: soprano)
        #expect(coral.voz(3) == soprano)
        #expect(coral.esCorrecta)
        #expect(coral.voz(0).map(\.nota) == ["Do", "Fa", "Sol", "Do"])
        // Do–Rem con el soprano Sol4–La4 obliga a quintas paralelas con el bajo: no hay realización.
        #expect(throws: ErrorDeRealizacion.sinEnlaceSinFaltas) {
            try Coral(realizando: ["Do", "Rem"], soprano: ["Sol4", "La4"])
        }
    }

    @Test func laSensibleSubeEnElSoprano() throws {
        let coral = try Coral(realizando: ["Do", "Sol", "Do"], soprano: ["Mi4", "Si4", "Do5"])
        #expect(coral.esCorrecta)
        // Y no se duplica.
        for voces in coral.acordes {
            #expect(voces.filter { $0.nota == .si }.count <= 1)
        }
    }

    @Test func realizarImposible() {
        #expect(throws: ErrorDeRealizacion.sinNotas) { try Coral(realizando: []) }
        // El soprano no tiene tantas notas, o una no es del acorde, o está fuera de tesitura.
        #expect(throws: ErrorDeRealizacion.sopranoDeOtraLongitud(notas: 1, acordes: 2)) {
            try Coral(realizando: ["Do", "Sol"], soprano: ["Do5"])
        }
        #expect(throws: ErrorDeRealizacion.notaAjena(acorde: 1)) {
            try Coral(realizando: ["Do", "Sol"], soprano: ["Do5", "Do5"])
        }
        #expect(throws: ErrorDeRealizacion.sopranoFueraDeTesitura(acorde: 0)) {
            try Coral(realizando: ["Do", "Sol"], soprano: ["Do6", "Si5"])
        }
        // Más de cuatro notas obligatorias.
        #expect(throws: ErrorDeRealizacion.demasiadasNotas(acorde: 0)) { try Coral(realizando: ["Do7(9,13)"]) }
        // Ninguna disposición sin faltas, aunque la nota es del acorde y está en su tesitura.
        #expect(Coral.motivoSinDisposicion("Do", soprano: "Do5", acorde: 3) == .sinDisposicion(acorde: 3))
    }

    @Test func motivosDeLaRealizacion() {
        let errores: [ErrorDeRealizacion] = [
            .sinNotas, .sopranoDeOtraLongitud(notas: 1, acordes: 2), .notaAjena(acorde: 1),
            .sopranoFueraDeTesitura(acorde: 0), .demasiadasNotas(acorde: 0), .sinDisposicion(acorde: 0),
            .notaSinAcorde(nota: 1), .sinEnlaceSinFaltas, .otraMelodia,
        ]
        #expect(
            ErrorDeRealizacion.notaAjena(acorde: 2).descripcion(en: .compacta(.espanol))
                == "La nota del soprano no es del acorde 3.")
        let ilegible = ErrorDeRealizacion.bajoCifradoIlegible(
            ErrorDeLectura(texto: "", posicion: nil, motivo: .textoVacio))
        #expect(Set(errores + [ilegible, ilegible]).count == errores.count + 1)
        #expect(ilegible != .sinNotas)
        for idioma in Idioma.allCases {
            let textos = errores.map { $0.descripcion(en: .compacta(idioma)) }
            #expect(Set(textos).count == errores.count, "\(idioma)")
            #expect(textos.allSatisfy { !$0.isEmpty && !$0.contains("{") }, "\(idioma)")
        }
    }

    @Test func disposicionesSinFaltas() throws {
        let disposiciones = Coral.disposiciones(de: "Sol7", soprano: nil, sensible: .si)
        #expect(!disposiciones.isEmpty)
        for d in disposiciones {
            #expect(try Coral([d.alturas]).esCorrecta)
            #expect(d.alturas[0].nota == .sol)
            #expect(d.alturas.filter { $0.nota == .si }.count <= 1)
        }
    }

    // MARK: Armonizar a cuatro voces

    @Test func armonizarACuatroVoces() throws {
        let melodia: [Altura] = ["Do5", "Si4", "La4", "Sol4", "Fa4", "Mi4", "Re4", "Do4"]
        let armonizada = try Tonalidad(.do).armonizarACuatroVoces(melodia: melodia)
        #expect(armonizada.coral.voz(3) == melodia)
        #expect(armonizada.coral.esCorrecta)
        #expect(armonizada.armonizacion.melodia == melodia.map(\.nota))
        #expect(armonizada.armonizacion.cifrados.last == "I")
        #expect(throws: ErrorDeRealizacion.sopranoFueraDeTesitura(acorde: 0)) {
            try Tonalidad(.do).armonizarACuatroVoces(melodia: ["Do6", "Si5", "Do6"])
        }
        #expect(throws: ErrorDeRealizacion.sinNotas) { try Tonalidad(.do).armonizarACuatroVoces(melodia: []) }
        #expect(throws: ErrorDeRealizacion.notaSinAcorde(nota: 1)) {
            try Tonalidad(.do).armonizarACuatroVoces(melodia: ["Do5", "Reb5", "Do5"])
        }
    }

    @Test func armonizarMelodiasAlAzar() {
        // Cualquier melodía de la escala en la tesitura del soprano y sin saltos aumentados ni de más
        // de una octava: si sale un coral, no tiene faltas y lleva la melodía arriba. Y casi siempre sale.
        var generador = GeneradorConSemilla(semilla: 8)
        let tonalidad = Tonalidad(.re)
        let alturas = (0..<8).map { Altura(tonalidad.escala.grado($0 + 1), octava: $0 >= 6 ? 5 : 4) }
        var probadas = 0
        var realizadas = 0
        while probadas < 20 {
            let melodia = (0..<Int.random(in: 3...7, using: &generador)).map { _ in
                alturas.randomElement(using: &generador)!
            }
            let saltos = zip(melodia, melodia.dropFirst()).map { $1 - $0 }
            func alterado(_ salto: Intervalo) -> Bool {
                switch salto.calidad {
                case .aumentada, .disminuida: return true
                default: return salto.semitonos > 12
                }
            }
            guard !saltos.contains(where: alterado) else { continue }
            probadas += 1
            guard let armonizada = try? tonalidad.armonizarACuatroVoces(melodia: melodia) else { continue }
            realizadas += 1
            #expect(armonizada.coral.voz(3) == melodia)
            #expect(armonizada.coral.faltas == [], "\(melodia)")
        }
        #expect(realizadas >= 18)
    }
}
