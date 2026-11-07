import Foundation
import Testing

@testable import Elementos
@testable import Formatos
@testable import Partituras
@testable import Polifonia
@testable import Teoria

/// `PiezaImportada.coral()`: un coral leído de un fichero, para revisar su conducción.
@Suite struct CoralImportadoTests {
    /// Do → Re con quintas paralelas entre el bajo y el tenor, y vuelta a Do.
    private let conQuintas = "Do3 Sol3 Mi4 Do5 | Re3 La3 Fa4 Re5 | Do3 Sol3 Mi4 Do5"

    private func nota(_ texto: String, _ inicio: Int, _ duracion: Duracion = .redonda, parte: Int) throws
        -> NotaDeLaPieza
    {
        NotaDeLaPieza(altura: try Altura(leyendo: texto), inicio: Duracion(inicio), duracion: duracion, parte: parte)
    }

    @Test func unCoralEnMusicXMLSeRevisaComoElEscrito() throws {
        let coral = try Coral(leyendo: conQuintas)
        let xml = coral.partitura(duracion: .blanca, encabezado: Encabezado(tonalidad: Tonalidad(.do))).musicXML()
        let leido = try PiezaImportada(leyendo: Data(xml.utf8)).coral()
        #expect(leido.acordes == coral.acordes)
        #expect(leido.faltas == coral.faltas)
        #expect(leido.faltas.contains { $0.tipo == .quintasParalelas })
    }

    @Test func unCoralEnMIDISeRevisaComoElEscrito() throws {
        let coral = try Coral(leyendo: conQuintas)
        let midi = coral.partitura(duracion: .negra).midi()
        let leido = try PiezaImportada(leyendo: midi).coral()
        #expect(leido.acordes == coral.acordes)
        #expect(leido.faltas == coral.faltas)
    }

    @Test func unAcordeCadaVezQueEmpiezaUnaNota() throws {
        // El soprano va en blancas sobre redondas: Do5 Re5 | Mi5 Do5.
        let medio = Duracion.blanca
        let soprano = try [("Do5", Duracion.cero), ("Re5", medio), ("Mi5", Duracion(1)), ("Do5", Duracion(1) + medio)]
            .map { NotaDeLaPieza(altura: try Altura(leyendo: $0.0), inicio: $0.1, duracion: medio, parte: 2) }
        let pieza = PiezaImportada(
            notas: [
                try nota("Do3", 0, parte: 0), try nota("Mi4", 0, parte: 1),
                try nota("Do3", 1, parte: 0), try nota("Sol4", 1, parte: 1),
            ] + soprano)
        let coral = try pieza.coral()
        #expect(
            coral.acordes.map { $0.map(\.nombre) } == [
                ["Do₃", "Mi₄", "Do₅"], ["Do₃", "Mi₄", "Re₅"], ["Do₃", "Sol₄", "Mi₅"], ["Do₃", "Sol₄", "Do₅"],
            ])
    }

    @Test func lasVocesDelFicheroDejanVerLosCruces() throws {
        // El tenor (parte 1) sube por encima del contralto (parte 2) en el segundo acorde.
        let pieza = PiezaImportada(notas: [
            try nota("Do3", 0, parte: 0), try nota("Sol3", 0, parte: 1), try nota("Mi4", 0, parte: 2),
            try nota("Do5", 0, parte: 3),
            try nota("Sol2", 1, parte: 0), try nota("Re4", 1, parte: 1), try nota("Si3", 1, parte: 2),
            try nota("Sol4", 1, parte: 3),
            try nota("Do3", 2, parte: 0), try nota("Sol3", 2, parte: 1), try nota("Mi4", 2, parte: 2),
            try nota("Do5", 2, parte: 3),
        ])
        let coral = try pieza.coral()
        #expect(coral.acordes[1].map(\.nombre) == ["Sol₂", "Re₄", "Si₃", "Sol₄"])
        #expect(coral.faltas.contains { $0.tipo == .cruceDeVoces })
    }

    @Test func unaSolaPistaSeLeeDeGraveAAgudo() throws {
        let pieza = PiezaImportada(notas: [
            try nota("Mi4", 0, parte: 0), try nota("Do3", 0, parte: 0), try nota("Sol4", 0, parte: 0),
            try nota("Re4", 1, parte: 0), try nota("Sol2", 1, parte: 0), try nota("Si3", 1, parte: 0),
        ])
        let coral = try pieza.coral()
        #expect(coral.acordes.map { $0.map(\.nombre) } == [["Do₃", "Mi₄", "Sol₄"], ["Sol₂", "Si₃", "Re₄"]])
    }
}
