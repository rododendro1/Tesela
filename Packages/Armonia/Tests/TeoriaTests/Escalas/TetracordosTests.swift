import Testing

@testable import Elementos
@testable import Teoria

/// Las divisiones de una escala en tetracordos y sus nombres.
@Suite struct TetracordosTests {
    /// Las notas de cada pieza: las de un tetracordo o «|» para el grado suelto.
    func piezas(_ escala: Escala, _ division: DivisionEnTetracordos) -> [String] {
        division.piezas.map { pieza in
            switch pieza {
            case .tetracordo(let tetracordo): escala.notas(de: tetracordo).map(\.nombre).joined(separator: " ")
            case .separacion: "|"
            }
        }
    }

    @Test func laMayorSonDosTetracordosSeparadosPorUnTono() throws {
        let mayor = Escala(.do)
        let divisiones = mayor.divisionesEnTetracordos
        #expect(divisiones.count == 2)
        let primera = try #require(divisiones.first)
        #expect(primera.esDisjunta)
        #expect(piezas(mayor, primera) == ["Do Re Mi Fa", "|", "Sol La Si Do"])
        #expect(primera.piezas[1] == .separacion(desde: 3, .segundaMayor))
        #expect(primera.tetracordos.map(\.grado) == [0, 4])
        #expect(primera.tetracordos[0].fragmentos.contains(.jinsAjam))
        #expect(piezas(mayor, divisiones[1]) == ["|", "Re Mi Fa Sol", "Sol La Si Do"])
        #expect(!divisiones[1].esDisjunta)
    }

    @Test func losNombresSalenDeLosFragmentosDelCatalogo() throws {
        let armonica = Escala(.la, .menorArmonica)
        let primera = try #require(armonica.divisionesEnTetracordos.first)
        #expect(piezas(armonica, primera) == ["La Si Do Re", "|", "Mi Fa Sol♯ La"])
        #expect(primera.tetracordos[0].fragmentos.map(\.nombre) == ["jins Nahāwand", "Bûselik dörtlüsü"])
        #expect(primera.tetracordos[1].fragmentos == [.jinsHijaz])
        // Semitono-tono-tono: el tetracordo diatónico griego, el jins Kurd y el Kürdî dörtlüsü; ni los microtonales
        // ni el pentacordo Kürdî beşlisi, que ya tiene su tetracordo.
        let frigio = try #require(Escala(.mi, .frigio).divisionesEnTetracordos.first)
        #expect(
            frigio.tetracordos[0].fragmentos.map(\.nombre) == [
                "tetracordo diatónico", "jins Kurd", "Kürdî dörtlüsü",
            ])
        #expect(frigio.tetracordos[0].fragmentos.allSatisfy { $0.microtonal == nil && $0.intervalos.count == 4 })
    }

    @Test func lasQueEmpiezanPorElGradoSueltoVanAlFinal() {
        let dorica = Escala(.re, .dorico)
        #expect(
            dorica.divisionesEnTetracordos.map { piezas(dorica, $0) } == [
                ["Re Mi Fa Sol", "|", "La Si Do Re"],
                ["Re Mi Fa Sol", "Sol La Si Do", "|"],
                ["|", "Mi Fa Sol La", "La Si Do Re"],
            ])
    }

    @Test func sinTetracordos() {
        #expect(Escala(.do, .pentatonicaMayor).divisionesEnTetracordos.isEmpty)
        #expect(Escala(.do, .tonosEnteros).divisionesEnTetracordos.isEmpty)
        // Un fragmento no llega a la octava.
        #expect(TipoDeEscala.jinsHijaz.divisionesEnTetracordos.isEmpty)
    }

    @Test func todasLasDivisionesLleganALaOctava() {
        for tipo in TipoDeEscala.occidentales + TipoDeEscala.tradicionales {
            for division in tipo.divisionesEnTetracordos {
                #expect(division.tetracordos.count == 2)
                let pasos = division.piezas.reduce(0) { suma, pieza in
                    if case .tetracordo = pieza { return suma + 3 }
                    return suma + 1
                }
                #expect(pasos == tipo.intervalos.count, Comment(rawValue: tipo.nombre))
                #expect(division.tetracordos.allSatisfy { $0.intervalos.last == .cuartaJusta })
            }
        }
    }
}
