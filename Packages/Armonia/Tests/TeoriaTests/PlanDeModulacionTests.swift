import Testing

@testable import Elementos
@testable import Teoria

@Suite struct PlanDeModulacionTests {
    private let doMayor = Tonalidad(.do)

    @Test func porAcordeComun() throws {
        let planes = doMayor.modulaciones(hasta: Tonalidad(.sol))
        let plan = try #require(planes.first)
        #expect(plan.tecnica == .acordeComun)
        #expect(plan.acordes == ["Do", "Fa", "Sol7", "Do", "Lam", "Re7", "Sol"])
        #expect(plan.pivote?.description == "Lam = vi en Do mayor = ii en Sol mayor")
        #expect(plan.pivote?.indice == 4)
        // Lam (ii en Sol) y luego Mim (vi); Do (IV en Sol) es la tónica de partida y no sirve.
        let comunes = planes.filter { $0.tecnica == .acordeComun }.compactMap(\.pivote?.acorde)
        #expect(comunes == [Acorde("Lam"), Acorde("Mim")])
        // La última, la directa.
        #expect(planes.last?.tecnica == .directa)
        #expect(planes.last?.acordes.suffix(3) == ["Lam7", "Re7", "Sol"])
        #expect(planes.last?.pivote == nil)
    }

    @Test func elRecorridoTonalEncuentraLaModulacion() throws {
        let plan = try #require(doMayor.modulaciones(hasta: Tonalidad(.sol)).first)
        let recorrido = try #require(RecorridoTonal(plan.acordes))
        #expect(recorrido.tonalidadDePartida == doMayor)
        #expect(recorrido.tonalidadDeLlegada == Tonalidad(.sol))
    }

    @Test func aTonalidadesMenoresYDesdeMenor() throws {
        let aMim = try #require(doMayor.modulaciones(hasta: Tonalidad(.mi, .menor)).first)
        #expect(aMim.tecnica == .acordeComun)
        #expect(aMim.acordes.suffix(2) == ["Si7", "Mim"])
        let desdeLam = try #require(Tonalidad(.la, .menor).modulaciones(hasta: doMayor).first)
        #expect(desdeLam.acordes.prefix(4) == ["Lam", "Rem", "Mi7", "Lam"])
        #expect(desdeLam.acordes.suffix(2) == ["Sol7", "Do"])
        #expect(desdeLam.pivote?.enLaDeLlegada.cifrado == "ii")
    }

    @Test func porSeptimaDisminuidaEnarmonica() throws {
        // Do mayor y La♭ mayor no comparten tríadas: el Do♯°7 (vii°7/ii) se escribe Sol°7 (vii°7 en La♭).
        let laBemol = Tonalidad(Nota.la.bemol)
        let planes = doMayor.modulaciones(hasta: laBemol)
        #expect(!planes.contains { $0.tecnica == .acordeComun })
        let plan = try #require(planes.first)
        #expect(plan.tecnica == .disminuidaEnarmonica)
        let pivote = try #require(plan.pivote)
        #expect(pivote.acorde == Acorde("Do#°7"))
        #expect(pivote.enLaDeLlegada.acorde == Acorde("Sol°7"))
        #expect(pivote.enLaDePartida.cifrado == "vii°7/ii")
        #expect(pivote.enLaDeLlegada.cifrado == "vii°7")
        #expect(plan.acordes.suffix(3) == ["Lab/Mib", "Mib7", "Lab"])
    }

    @Test func casosLimite() {
        #expect(doMayor.modulaciones(hasta: doMayor).isEmpty)
        // Siempre hay al menos la directa.
        for tonica in [Nota.do, .re, .mi, .fa, .sol, .la, .si, Nota.fa.sostenido, Nota.si.bemol] {
            for modo in [Tonalidad.Modo.mayor, .menor] where Tonalidad(tonica, modo) != doMayor {
                let planes = doMayor.modulaciones(hasta: Tonalidad(tonica, modo))
                #expect(planes.last?.tecnica == .directa)
                #expect(planes.allSatisfy { $0.acordes.last == Tonalidad(tonica, modo).acorde(grado: 1) })
            }
        }
    }

    @Test func descripcion() throws {
        let plan = try #require(doMayor.modulaciones(hasta: Tonalidad(.sol)).first)
        #expect(plan.description == "Do Fa Sol7 Do Lam Re7 Sol (pivote: Lam = vi en Do mayor = ii en Sol mayor)")
    }
}
