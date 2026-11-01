import XCTest

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

final class ContrapuntoTests: XCTestCase {
    /// El cantus firmus en re de Fux.
    private let cantusDeFux = "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4"

    private func tipos(
        _ cantus: String, _ contrapunto: String,
        _ especie: Contrapunto.Especie
    ) throws -> [FaltaDeContrapunto.Tipo] {
        try Contrapunto(cantusFirmus: cantus, contrapunto: contrapunto, especie: especie).faltas.map(\.tipo)
    }

    func testElEjemploDeFuxEsCorrecto() throws {
        let ejercicio = try Contrapunto(
            cantusFirmus: cantusDeFux,
            contrapunto: "La4 La4 Sol4 La4 Si4 Do5 Do5 Si4 Re5 Do#5 Re5", especie: .primera)
        XCTAssertTrue(ejercicio.contrapuntoArriba)
        XCTAssertEqual(ejercicio.faltas, [])
        XCTAssertEqual(ejercicio.informe(), "Especie 1, con el contrapunto encima del cantus firmus\nSin faltas.")
        XCTAssertEqual(
            ejercicio.informe(en: .inglesASCII), "Species 1, counterpoint above the cantus firmus\nNo faults.")
    }

    func testPrimeraEspecie() throws {
        // Do–Sol y Re–La: quintas paralelas; al final, Sol4 → Do5 salta en vez de ir por grado.
        let faltas = try Contrapunto(
            cantusFirmus: "Do4 Re4 Mi4 Do4", contrapunto: "Sol4 La4 Sol4 Do5", especie: .primera
        ).faltas
        XCTAssertTrue(faltas.contains(FaltaDeContrapunto(tipo: .quintasParalelas, compases: 0...1)), "\(faltas)")
        XCTAssertTrue(faltas.contains(FaltaDeContrapunto(tipo: .finalSinGradoConjunto, compases: 2...3)), "\(faltas)")
        XCTAssertEqual(
            FaltaDeContrapunto(tipo: .quintasParalelas, compases: 0...1).description,
            "Quintas paralelas (compases 1 → 2)")
        XCTAssertEqual(
            FaltaDeContrapunto(tipo: .unisono, compases: 2...2).descripcion(en: .inglesASCII),
            "Unison in the middle (bar 3)")
        // Empieza en tercera y acaba en quinta.
        let mal = try tipos("Do4 Re4 Do4", "Mi4 Fa4 Sol4", .primera)
        XCTAssertTrue(mal.contains(.comienzoImperfecto), "\(mal)")
        XCTAssertTrue(mal.contains(.finalImperfecto), "\(mal)")
        // Una cuarta contra el cantus es disonancia; un unísono en medio, una falta.
        XCTAssertTrue(try tipos("Do4 Re4 Do4", "Do5 Sol4 Do5", .primera).contains(.disonanciaEnParteFuerte))
        XCTAssertTrue(try tipos("Do4 Re4 Mi4 Re4 Do4", "Do5 Si4 Mi4 Si4 Do5", .primera).contains(.unisono))
        // Debajo del cantus, la quinta no vale para empezar.
        let debajo = try Contrapunto(cantusFirmus: "Sol4 La4 Sol4", contrapunto: "Do4 Fa4 Sol3", especie: .primera)
        XCTAssertFalse(debajo.contrapuntoArriba)
        XCTAssertTrue(debajo.faltas.map(\.tipo).contains(.comienzoImperfecto))
    }

    func testSaltos() throws {
        // Re4 → Do#5: séptima mayor; Fa4 → Re5: sexta mayor.
        XCTAssertFalse(try tipos("Re4 Mi4 Re4", "La4 Sol4 Re5", .primera).contains(.saltoNoMelodico))
        XCTAssertTrue(Contrapunto.esSaltoNoMelodico("Re4".intervaloHasta("Do#5"), ascendente: true))
        XCTAssertTrue(Contrapunto.esSaltoNoMelodico("Fa4".intervaloHasta("Re5"), ascendente: true))
        XCTAssertTrue(Contrapunto.esSaltoNoMelodico("Fa4".intervaloHasta("Si4"), ascendente: true)) // tritono
        // Sexta menor que sube.
        XCTAssertFalse(Contrapunto.esSaltoNoMelodico("Mi4".intervaloHasta("Do5"), ascendente: true))
        XCTAssertTrue(Contrapunto.esSaltoNoMelodico("Do5".intervaloHasta("Mi4"), ascendente: false)) // y que baja
        // Un salto de quinta que sigue subiendo no se compensa.
        XCTAssertTrue(try tipos("Re4 Mi4 Fa4 Mi4 Re4", "Re5 Sol4 Re5 Mi5 Re5", .primera).contains(.saltoSinCompensar))
    }

    func testSegundaEspecie() throws {
        let correcto = try Contrapunto(
            cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "-:2 La4 Re5 La4 Si4 Do#5 Re5:1",
            especie: .segunda)
        XCTAssertEqual(correcto.faltas, [])
        // Tres notas en un compás; una nota repetida; una disonancia que llega por salto.
        XCTAssertTrue(
            try tipos("Re4 Fa4 Mi4 Re4", "-:2 La4 Re5:4 Do5:4 La4 Si4 Do#5 Re5:1", .segunda).contains(.ritmoDeLaEspecie)
        )
        XCTAssertTrue(try tipos("Re4 Fa4 Mi4 Re4", "-:2 La4 La4 Re5 Si4 Do#5 Re5:1", .segunda).contains(.notaRepetida))
        XCTAssertTrue(
            try tipos("Re4 Fa4 Mi4 Re4", "-:2 La4 Re5 Sol4 Si4 Do#5 Re5:1", .segunda).contains(.disonanciaMalTratada))
    }

    func testTerceraEspecie() throws {
        let correcto = try Contrapunto(
            cantusFirmus: "Do4 Si3 Do4", contrapunto: "Sol4 La4 Si4 Do5 Re5 Do5 Si4 Re5 Do5:1",
            especie: .tercera)
        XCTAssertEqual(correcto.faltas, [])
        // El Si4 contra Do4 es séptima y llega por salto desde Sol4.
        XCTAssertTrue(
            try tipos("Do4 Si3 Do4", "Sol4 Si4 La4 Do5 Re5 Do5 Si4 Re5 Do5:1", .tercera).contains(.disonanciaMalTratada)
        )
    }

    func testCuartaEspecie() throws {
        // Re5 ligado: séptima contra Mi4 que baja a Do#5, sexta. Es la cadencia 7–6.
        let correcto = try Contrapunto(
            cantusFirmus: "Re4 Mi4 Re4", contrapunto: "-:2 Re5:1 Do#5 Re5:1", especie: .cuarta)
        XCTAssertEqual(correcto.faltas, [])
        XCTAssertTrue(correcto.sonoridades.contains { !$0.ataque && $0.compas == 1 })
        // Si baja por salto, el retardo queda mal resuelto.
        XCTAssertTrue(try tipos("Re4 Mi4 Re4", "-:2 Re5:1 Si4 Re5:1", .cuarta).contains(.retardoMalResuelto))
    }

    func testLecturaYDuracion() throws {
        XCTAssertThrowsError(try Contrapunto(cantusFirmus: "Re4 Fa4", contrapunto: "La4", especie: .primera)) { error in
            guard case .contrapuntoDeOtraDuracion(redondas: 2)? = (error as? ErrorDeLectura)?.motivo else {
                return XCTFail("\(error)")
            }
        }
        XCTAssertThrowsError(try Contrapunto(cantusFirmus: "", contrapunto: "La4", especie: .primera))
        XCTAssertThrowsError(try Contrapunto(cantusFirmus: "Re4 Xx", contrapunto: "La4 La4", especie: .primera))
        XCTAssertNil(Contrapunto(cantusFirmus: [], contrapunto: [], especie: .primera))
        // Sin duración, cada nota lleva la figura de su especie.
        XCTAssertEqual(
            try Contrapunto(cantusFirmus: "Re4", contrapunto: "La4 Re5", especie: .segunda).contrapunto.ritmo,
            [.blanca, .blanca])
    }

    func testTodasLasFaltasTienenNombreEnCadaIdioma() {
        for idioma in Idioma.traducidos {
            let notacion = Notacion(escritura: EscrituraDeNotas(idioma: idioma, ascii: false))
            let nombres = FaltaDeContrapunto.Tipo.allCases.map { $0.nombre(en: notacion) }
            XCTAssertEqual(Set(nombres).count, nombres.count, "\(idioma)")
            XCTAssertFalse(nombres.contains(""), "\(idioma)")
        }
    }
}

extension String {
    fileprivate func intervaloHasta(_ otra: String) -> Intervalo {
        try! Altura(leyendo: self).intervalo(hasta: try! Altura(leyendo: otra))
    }
}
