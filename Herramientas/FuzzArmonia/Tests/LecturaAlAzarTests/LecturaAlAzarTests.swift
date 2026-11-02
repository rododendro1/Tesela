import Foundation
import LecturaAlAzar
import Testing

@Suite struct LecturaAlAzarTests {
    /// Los ficheros de partida tienen que leerse bien: si no, libFuzzer empezaría desde datos que ya fallan y no
    /// llegaría al código de después de la lectura.
    @Test func lasSemillasSeLeen() throws {
        let semillas = try LecturaAlAzar.semillas()
        for (nombre, datos) in semillas {
            let lector = LecturaAlAzar.lectores[Int(datos.first!)]
            #expect(throws: Never.self, "\(nombre)") { try lector.leer(datos.dropFirst()) }
        }
    }

    @Test func cadaLectorTieneSemillas() throws {
        let nombres = Set(try LecturaAlAzar.semillas().map { LecturaAlAzar.lectores[Int($0.datos.first!)].nombre })
        #expect(nombres == Set(LecturaAlAzar.lectores.map(\.nombre)))
        #expect(LecturaAlAzar.lectores.count < 256)
    }

    @Test func losDatosVaciosOEstropeadosNoFallan() {
        LecturaAlAzar.leer(Data())
        for byte in 0..<UInt8(LecturaAlAzar.lectores.count) {
            LecturaAlAzar.leer(Data([byte]))
            LecturaAlAzar.leer(Data([byte, 0xFF, 0x00, 0x80]))
            LecturaAlAzar.leer(Data([byte]) + Data("MThd\u{0}\u{0}\u{0}\u{6}".utf8))
        }
    }
}
