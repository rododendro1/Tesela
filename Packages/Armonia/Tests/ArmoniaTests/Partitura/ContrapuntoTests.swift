import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

@Suite struct ContrapuntoTests {
    /// El cantus firmus en re de Fux.
    private let cantusDeFux = "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4"

    private func tipos(
        _ cantus: String, _ contrapunto: String,
        _ especie: Contrapunto.Especie
    ) throws -> [FaltaDeContrapunto.Tipo] {
        try Contrapunto(cantusFirmus: cantus, contrapunto: contrapunto, especie: especie).faltas.map(\.tipo)
    }

    @Test func elEjemploDeFuxEsCorrecto() throws {
        let ejercicio = try Contrapunto(
            cantusFirmus: cantusDeFux,
            contrapunto: "La4 La4 Sol4 La4 Si4 Do5 Do5 Si4 Re5 Do#5 Re5", especie: .primera)
        #expect(ejercicio.contrapuntoArriba)
        #expect(ejercicio.faltas == [])
        #expect(ejercicio.informe() == "Especie 1, con el contrapunto encima del cantus firmus\nSin faltas.")
        #expect(ejercicio.informe(en: .inglesASCII) == "Species 1, counterpoint above the cantus firmus\nNo faults.")
    }

    @Test func primeraEspecie() throws {
        // Do–Sol y Re–La: quintas paralelas; al final, Sol4 → Do5 salta en vez de ir por grado.
        let faltas = try Contrapunto(
            cantusFirmus: "Do4 Re4 Mi4 Do4", contrapunto: "Sol4 La4 Sol4 Do5", especie: .primera
        ).faltas
        #expect(faltas.contains(FaltaDeContrapunto(tipo: .quintasParalelas, compases: 0...1)), "\(faltas)")
        #expect(faltas.contains(FaltaDeContrapunto(tipo: .finalSinGradoConjunto, compases: 2...3)), "\(faltas)")
        #expect(
            FaltaDeContrapunto(tipo: .quintasParalelas, compases: 0...1).description
                == "Quintas paralelas (compases 1 → 2)")
        #expect(
            FaltaDeContrapunto(tipo: .unisono, compases: 2...2).descripcion(en: .inglesASCII)
                == "Unison in the middle (bar 3)")
        // Empieza en tercera y acaba en quinta.
        let mal = try tipos("Do4 Re4 Do4", "Mi4 Fa4 Sol4", .primera)
        #expect(mal.contains(.comienzoImperfecto), "\(mal)")
        #expect(mal.contains(.finalImperfecto), "\(mal)")
        // Una cuarta contra el cantus es disonancia; un unísono en medio, una falta.
        #expect(try tipos("Do4 Re4 Do4", "Do5 Sol4 Do5", .primera).contains(.disonanciaEnParteFuerte))
        #expect(try tipos("Do4 Re4 Mi4 Re4 Do4", "Do5 Si4 Mi4 Si4 Do5", .primera).contains(.unisono))
        // Debajo del cantus, la quinta no vale para empezar.
        let debajo = try Contrapunto(cantusFirmus: "Sol4 La4 Sol4", contrapunto: "Do4 Fa4 Sol3", especie: .primera)
        #expect(!debajo.contrapuntoArriba)
        #expect(debajo.faltas.map(\.tipo).contains(.comienzoImperfecto))
    }

    @Test func saltos() throws {
        // Re4 → Do#5: séptima mayor; Fa4 → Re5: sexta mayor.
        #expect(try !(tipos("Re4 Mi4 Re4", "La4 Sol4 Re5", .primera).contains(.saltoNoMelodico)))
        #expect(Contrapunto.esSaltoNoMelodico("Re4".intervaloHasta("Do#5"), ascendente: true))
        #expect(Contrapunto.esSaltoNoMelodico("Fa4".intervaloHasta("Re5"), ascendente: true))
        #expect(Contrapunto.esSaltoNoMelodico("Fa4".intervaloHasta("Si4"), ascendente: true)) // tritono
        // Sexta menor que sube.
        #expect(!Contrapunto.esSaltoNoMelodico("Mi4".intervaloHasta("Do5"), ascendente: true))
        #expect(Contrapunto.esSaltoNoMelodico("Do5".intervaloHasta("Mi4"), ascendente: false)) // y que baja
        // Un salto de quinta que sigue subiendo no se compensa.
        #expect(try tipos("Re4 Mi4 Fa4 Mi4 Re4", "Re5 Sol4 Re5 Mi5 Re5", .primera).contains(.saltoSinCompensar))
    }

    @Test func segundaEspecie() throws {
        let correcto = try Contrapunto(
            cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "-:2 La4 Re5 La4 Si4 Do#5 Re5:1",
            especie: .segunda)
        #expect(correcto.faltas == [])
        // Tres notas en un compás; una nota repetida; una disonancia que llega por salto.
        #expect(
            try tipos("Re4 Fa4 Mi4 Re4", "-:2 La4 Re5:4 Do5:4 La4 Si4 Do#5 Re5:1", .segunda).contains(.ritmoDeLaEspecie)
        )
        #expect(try tipos("Re4 Fa4 Mi4 Re4", "-:2 La4 La4 Re5 Si4 Do#5 Re5:1", .segunda).contains(.notaRepetida))
        #expect(
            try tipos("Re4 Fa4 Mi4 Re4", "-:2 La4 Re5 Sol4 Si4 Do#5 Re5:1", .segunda).contains(.disonanciaMalTratada))
    }

    @Test func terceraEspecie() throws {
        let correcto = try Contrapunto(
            cantusFirmus: "Do4 Si3 Do4", contrapunto: "Sol4 La4 Si4 Do5 Re5 Do5 Si4 Re5 Do5:1",
            especie: .tercera)
        #expect(correcto.faltas == [])
        // El Si4 contra Do4 es séptima y llega por salto desde Sol4.
        #expect(
            try tipos("Do4 Si3 Do4", "Sol4 Si4 La4 Do5 Re5 Do5 Si4 Re5 Do5:1", .tercera).contains(.disonanciaMalTratada)
        )
    }

    @Test func cuartaEspecie() throws {
        // Re5 ligado: séptima contra Mi4 que baja a Do#5, sexta. Es la cadencia 7–6.
        let correcto = try Contrapunto(
            cantusFirmus: "Re4 Mi4 Re4", contrapunto: "-:2 Re5:1 Do#5 Re5:1", especie: .cuarta)
        #expect(correcto.faltas == [])
        #expect(correcto.sonoridades.contains { !$0.ataque && $0.compas == 1 })
        // Si baja por salto, el retardo queda mal resuelto.
        #expect(try tipos("Re4 Mi4 Re4", "-:2 Re5:1 Si4 Re5:1", .cuarta).contains(.retardoMalResuelto))
    }

    @Test func lecturaYDuracion() throws {
        do {
            _ = try Contrapunto(cantusFirmus: "Re4 Fa4", contrapunto: "La4", especie: .primera)
            Issue.record("Se esperaba un error")
        } catch {
            guard case .contrapuntoDeOtraDuracion(redondas: 2)? = (error as? ErrorDeLectura)?.motivo else {
                Issue.record("\(error)")
                return
            }

        }
        #expect(throws: (any Error).self) { try Contrapunto(cantusFirmus: "", contrapunto: "La4", especie: .primera) }
        #expect(throws: (any Error).self) {
            try Contrapunto(cantusFirmus: "Re4 Xx", contrapunto: "La4 La4", especie: .primera)
        }
        #expect(Contrapunto(cantusFirmus: [], contrapunto: [], especie: .primera) == nil)
        // Sin duración, cada nota lleva la figura de su especie.
        #expect(
            try (Contrapunto(cantusFirmus: "Re4", contrapunto: "La4 Re5", especie: .segunda).contrapunto.ritmo) == [
                .blanca, .blanca,
            ])
    }

    @Test func todasLasFaltasTienenNombreEnCadaIdioma() {
        for idioma in Idioma.allCases {
            let notacion = Notacion(escritura: EscrituraDeNotas(idioma: idioma, ascii: false))
            let nombres = FaltaDeContrapunto.Tipo.allCases.map { $0.nombre(en: notacion) }
            #expect(Set(nombres).count == nombres.count, "\(idioma)")
            #expect(!nombres.contains(""), "\(idioma)")
        }
    }
}

extension String {
    fileprivate func intervaloHasta(_ otra: String) -> Intervalo {
        try! Altura(leyendo: self).intervalo(hasta: try! Altura(leyendo: otra))
    }
}
