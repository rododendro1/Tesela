import Foundation
import Hexagonos
import XCTest

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

// Lo que viene de fuera (un fichero MIDI o MusicXML, un teclado en UIL) puede estar dañado o hecho a mala fe. Estas
// pruebas leen ficheros buenos estropeados al azar (bytes cambiados, cortados, repetidos o insertados) y casos
// extremos escritos a mano: la lectura tiene que acabar, con una pieza o con un error, sin detener el programa ni
// colgarse, y lo que sale de una pieza leída (sus acordes y su análisis) también. Las semillas son fijas, así que
// un fallo se repite siempre igual.

final class ImportacionAlAzarTests: XCTestCase {
    private static let casosPorSemilla = 300

    /// Ficheros buenos de los que se parte: los que escribe la biblioteca, en MIDI y en MusicXML.
    private func semillas() throws -> [Data] {
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa2 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8~ Mi4:4 Sol4+Si4:2", compas: "3/4")
        return [
            coral.midi(
                duracion: .blanca, compas: Compas(3, 2), tonalidad: Tonalidad(.do), tempo: Tempo(72),
                titulo: "Cadencia"),
            analisis.midi(),
            Data(
                coral.musicXML(
                    duracion: .blanca, compas: Compas(3, 2), tonalidad: Tonalidad(.do),
                    titulo: "Cadencia"
                ).utf8),
            Data(analisis.musicXML().utf8),
            Data(voz.musicXML().utf8),
        ]
    }

    /// Lee los datos y, si salen notas, todo lo que las apps sacan de ellas. Devuelve si se pudo leer.
    @discardableResult
    private func leer(_ datos: Data) -> Bool {
        guard let pieza = try? PiezaImportada(leyendo: datos) else { return false }
        _ = pieza.duracion
        _ = pieza.tonalidadEstimada
        _ = pieza.acordes()
        _ = pieza.analisis()
        _ = pieza.notas.map(\.altura.nombre)
        return true
    }

    /// Un fichero estropeado: de una a ocho operaciones al azar sobre los bytes.
    private func estropear(_ datos: Data, _ azar: inout GeneradorConSemilla) -> Data {
        var bytes = [UInt8](datos)
        for _ in 0..<Int.random(in: 1...8, using: &azar) where !bytes.isEmpty {
            let i = Int.random(in: 0..<bytes.count, using: &azar)
            switch Int.random(in: 0..<6, using: &azar) {
            case 0: // un byte cualquiera
                bytes[i] = UInt8.random(in: 0...255, using: &azar)
            case 1: // un bit cambiado
                bytes[i] ^= 1 << UInt8.random(in: 0..<8, using: &azar)
            case 2: // un valor extremo
                bytes[i] = [0x00, 0x7F, 0x80, 0xFF].randomElement(using: &azar)!
            case 3: // cortado
                bytes.removeSubrange(i...)
            case 4: // un trozo repetido
                let fin = min(bytes.count, i + Int.random(in: 1...64, using: &azar))
                bytes.insert(contentsOf: bytes[i..<fin], at: fin)
            default: // bytes insertados
                bytes.insert(
                    contentsOf: (0..<Int.random(in: 1...8, using: &azar)).map { _ in
                        UInt8.random(in: 0...255, using: &azar)
                    }, at: i)
            }
        }
        return Data(bytes)
    }

    func testLosFicherosEstropeadosNoDetienenLaLectura() throws {
        var azar = GeneradorConSemilla(semilla: 1880)
        for semilla in try semillas() {
            XCTAssertTrue(leer(semilla), "la semilla sin estropear se lee")
            for _ in 0..<Self.casosPorSemilla { leer(estropear(semilla, &azar)) }
        }
    }

    func testBytesAlAzarNoDetienenLaLectura() {
        var azar = GeneradorConSemilla(semilla: 31)
        for _ in 0..<500 {
            let largo = Int.random(in: 0...256, using: &azar)
            var bytes = (0..<largo).map { _ in UInt8.random(in: 0...255, using: &azar) }
            // La mitad, con la cabecera de un MIDI para que se lea más allá de ella.
            if Bool.random(using: &azar) { bytes = Array("MThd".utf8) + [0, 0, 0, 6, 0, 1, 0, 2, 1, 0xE0] + bytes }
            XCTAssertFalse(leer(Data(bytes)) && bytes.isEmpty)
        }
    }

    // MARK: MIDI hecho a mano

    /// Un MIDI de formato 0 con una pista de los eventos dados y `divisiones` pulsos por negra.
    private func midi(divisiones: UInt16, _ eventos: [UInt8]) -> Data {
        let pista = eventos + [0x00, 0xFF, 0x2F, 0x00]
        let largo = [24, 16, 8, 0].map { UInt8(pista.count >> $0 & 0xFF) }
        return Data(
            Array("MThd".utf8) + [0, 0, 0, 6, 0, 0, 0, 1, UInt8(divisiones >> 8), UInt8(divisiones & 0xFF)]
                + Array("MTrk".utf8) + largo + pista)
    }

    /// Una cantidad de longitud variable de MIDI.
    private func variable(_ valor: Int) -> [UInt8] {
        var bytes = [UInt8(valor & 0x7F)]
        var resto = valor >> 7
        while resto > 0 {
            bytes.insert(UInt8(resto & 0x7F) | 0x80, at: 0)
            resto >>= 7
        }
        return bytes
    }

    func testUnaNotaLarguisimaConUnaDivisionRara() throws {
        // 32 749 pulsos por negra (un primo) y una nota de 2^27 pulsos: más de 100 000 negras. Las ventanas de los
        // acordes se alargan para no pasar de 100 000, y su suma no puede desbordar las fracciones.
        let datos = midi(
            divisiones: 32_749,
            [0x00, 0x90, 60, 100, 0x00, 0x90, 64, 100, 0x00, 0x90, 67, 100]
                + variable((1 << 28) - 1) + [0x80, 60, 0, 0x00, 0x80, 64, 0, 0x00, 0x80, 67, 0])
        let pieza = try PiezaImportada(leyendo: datos)
        XCTAssertEqual(pieza.notas.count, 3)
        XCTAssertEqual(pieza.acordes().map(\.cifrado), ["Do"])
    }

    func testMuchasNotasLargasSeguidas() throws {
        // Cuarenta notas de 2^27 pulsos una detrás de otra: la pieza dura años, pero se lee en poco tiempo.
        var eventos: [UInt8] = []
        for i in 0..<40 {
            let clave = UInt8(48 + i % 24)
            eventos += [0x00, 0x90, clave, 100] + variable((1 << 27) + i) + [0x80, clave, 0]
        }
        let pieza = try PiezaImportada(leyendo: midi(divisiones: 32_749, eventos))
        XCTAssertEqual(pieza.notas.count, 40)
        _ = pieza.acordes()
        _ = pieza.analisis()
    }

    func testMilesDeNotasAbiertasALaVez() throws {
        // Todas las teclas de los 16 canales, sin soltar: las notas acaban con la pista.
        var eventos: [UInt8] = []
        for canal in 0..<16 where canal != 9 {
            for clave in 0..<128 { eventos += [0x00, 0x90 | UInt8(canal), UInt8(clave), 1] }
        }
        eventos += [0x60, 0xB0, 0, 0]
        let pieza = try PiezaImportada(leyendo: midi(divisiones: 96, eventos))
        XCTAssertEqual(pieza.notas.count, 15 * 128)
        _ = pieza.acordes()
    }

    // MARK: MusicXML hecho a mano

    /// Una parte de MusicXML con los compases dados.
    private func musicXML(_ compases: String, divisiones: Int = 1, partes: Int = 1) -> Data {
        let parte = { (i: Int) in
            "<part id=\"P\(i)\"><measure number=\"1\"><attributes><divisions>\(divisiones)</divisions></attributes>"
                + compases + "</measure></part>"
        }
        return Data(
            ("<score-partwise version=\"4.0\"><part-list>"
                + (1...partes).map { "<score-part id=\"P\($0)\"><part-name/></score-part>" }.joined()
                + "</part-list>" + (1...partes).map(parte).joined() + "</score-partwise>").utf8)
    }

    private func nota(
        _ paso: String, octava: String, duracion: String, alter: String = "0",
        acorde: Bool = false
    ) -> String {
        "<note>" + (acorde ? "<chord/>" : "") + "<pitch><step>\(paso)</step><alter>\(alter)</alter>"
            + "<octave>\(octava)</octave></pitch><duration>\(duracion)</duration></note>"
    }

    func testNumerosDesmesuradosEnMusicXML() {
        let raros = [
            "9999999", "-9999999", "1e300", "-1e300", "nan", "inf", "-0", "", "x", "9223372036854775807",
            "-9223372036854775808", "18446744073709551616",
        ]
        for numero in raros {
            leer(musicXML(nota("C", octava: numero, duracion: "1")))
            leer(musicXML(nota("C", octava: "4", duracion: numero)))
            leer(musicXML(nota("C", octava: "4", duracion: "1", alter: numero)))
            leer(musicXML(nota("C", octava: "4", duracion: "1"), divisiones: 0))
            leer(
                musicXML(
                    "<attributes><divisions>\(numero)</divisions></attributes>"
                        + nota(
                            "C", octava: "4",
                            duracion: "3")))
            leer(
                musicXML(
                    "<attributes><transpose><diatonic>\(numero)</diatonic><chromatic>\(numero)</chromatic>"
                        + "<octave-change>\(numero)</octave-change></transpose></attributes>"
                        + nota("C", octava: "4", duracion: "1")))
            leer(
                musicXML(
                    "<backup><duration>\(numero)</duration></backup><forward><duration>\(numero)</duration>"
                        + "</forward>" + nota("E", octava: "4", duracion: "1")))
            leer(
                musicXML(
                    "<attributes><time><beats>\(numero)</beats><beat-type>\(numero)</beat-type></time>"
                        + "<key><fifths>\(numero)</fifths></key></attributes><sound tempo=\"\(numero)\"/>"
                        + nota("G", octava: "4", duracion: "1")))
        }
    }

    func testUnaPiezaLarguisimaConDivisionesPrimas() throws {
        // Dos partes con divisiones primas distintas y miles de compases de la nota más larga que se admite: las
        // fracciones de los dos pentagramas se combinan sin desbordar.
        let compas = (0..<200).map { i in nota(["C", "E", "G"][i % 3], octava: "4", duracion: "9999999") }.joined()
        var texto = String(decoding: musicXML(compas, divisiones: 99_991), as: UTF8.self)
        texto =
            texto.replacingOccurrences(of: "</score-partwise>", with: "")
            + "<part id=\"P2\"><measure number=\"1\"><attributes><divisions>99989</divisions></attributes>"
            + nota("C", octava: "3", duracion: "9999999") + "</measure></part></score-partwise>"
        let pieza = try PiezaImportada(leyendo: Data(texto.utf8))
        XCTAssertEqual(pieza.notas.count, 201)
        _ = pieza.acordes()
        _ = pieza.analisis()
    }

    func testUnAcordeDeMilNotas() throws {
        let acorde = (0..<1000).map { i in
            nota(["C", "D", "E", "F", "G", "A", "B"][i % 7], octava: "\(i % 10)", duracion: "1", acorde: i > 0)
        }.joined()
        let pieza = try PiezaImportada(leyendo: musicXML(acorde))
        XCTAssertEqual(pieza.notas.count, 1000)
        _ = pieza.acordes()
    }

    func testUnNombreQueNoEsUTF8EsUnXMLDanado() {
        // En Linux, XMLParser detenía el programa con un byte suelto en el nombre de un elemento o de un atributo.
        let error = { (bytes: [UInt8]) -> ErrorDeImportacion? in
            do {
                _ = try PiezaImportada(leyendo: Data(bytes))
                return nil
            } catch { return error as? ErrorDeImportacion }
        }
        XCTAssertEqual(
            error(Array("<score-partwise>\n<pa".utf8) + [0xCB] + Array("rt/></score-partwise>".utf8)),
            .xmlDanado(linea: 2))
        XCTAssertEqual(error(Array("<score-partwise x".utf8) + [0xFF] + Array("=\"1\"/>".utf8)), .xmlDanado(linea: 1))
        XCTAssertEqual(
            error(Array("<score-partwise>".utf8) + [0xE0, 0x80, 0x80] + Array("</score-partwise>".utf8)),
            .xmlDanado(linea: 1))
        XCTAssertEqual(
            error(Array("<score-partwise>".utf8) + [0xED, 0xA0, 0x80] + Array("</score-partwise>".utf8)),
            .xmlDanado(linea: 1))
        XCTAssertNil(PiezaImportada.lineaConUTF8NoValido(Data("<a>Dó ♯ 𝄞</a>".utf8)))
        // Una codificación declarada que no es de un byte por carácter no se salta la comprobación.
        XCTAssertEqual(
            error(
                Array("<?xml version=\"1.0\" encoding=\"U}TF-8\"?>\n<score-partwise><".utf8) + [0xFF]
                    + Array("a/></score-partwise>".utf8)), .xmlDanado(linea: 2))
        // Un fichero en Latin-1 que lo declara se sigue leyendo.
        let latin1 =
            Array("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><score-partwise><work><work-title>Canci".utf8)
            + [0xF3] + Array("n</work-title></work><part-list/><part id=\"P1\"><measure>".utf8)
            + Array(nota("C", octava: "4", duracion: "1").utf8) + Array("</measure></part></score-partwise>".utf8)
        XCTAssertEqual(try PiezaImportada(leyendo: Data(latin1)).titulo, "Canción")
    }

    func testElementosAnidadosSinFin() {
        // Diez mil elementos abiertos uno dentro de otro, cerrados o no.
        let abiertos = String(repeating: "<a>", count: 10_000)
        XCTAssertFalse(leer(Data(("<score-partwise>" + abiertos).utf8)))
        XCTAssertFalse(
            leer(
                Data(
                    ("<score-partwise>" + abiertos + String(repeating: "</a>", count: 10_000)
                        + "</score-partwise>").utf8)))
    }

    func testLasEntidadesNoSeMultiplican() {
        // «Billion laughs»: entidades que se expanden unas en otras. No se pueden comer la memoria.
        var dtd = "<!DOCTYPE score-partwise [<!ENTITY a0 \"jajajajaja\">"
        for i in 1...9 { dtd += "<!ENTITY a\(i) \"" + String(repeating: "&a\(i - 1);", count: 10) + "\">" }
        dtd += "]>"
        let texto =
            "<?xml version=\"1.0\"?>" + dtd
            + "<score-partwise><work><work-title>&a9;</work-title></work><part-list/></score-partwise>"
        XCTAssertFalse(leer(Data(texto.utf8)))
    }

    // MARK: UIL

    func testTextosUILAlAzar() {
        let buenos = ["2,7,5;R30M", "1,4,3;R30M;T7", "M2,P5,P4;R30M", "9:8,3:2,4:3", "1,3,2;R-90;S0", "♭II,♭III,II"]
        let piezas = [
            "0", "1", "-1", "9223372036854775807", "-9223372036854775808", "4611686018427387904",
            "99999999999999999999", ",", ";", "R", "M", "T", "S", "TET", ":", "0:0", "1:0", "0:1",
            "999999999:1", "1e308", " ", "♭", "♯", "X",
        ]
        var azar = GeneradorConSemilla(semilla: 7)
        func probar(_ texto: String) {
            guard let uil = try? FormatoUIL(leyendo: texto) else { return }
            _ = uil.descripcion
            _ = uil.anguloDelEjeDeAltura
            _ = uil.esCompleto
            _ = try? uil.rotado(grados: Int.random(in: -1000...1000, using: &azar))
            if let teclado = try? uil.teclado() {
                _ = (-3...3).flatMap { q in (-3...3).map { r in teclado.midi(en: CoordenadaAxial(q: q, r: r)) } }
            }
        }
        for _ in 0..<2000 {
            var texto = buenos.randomElement(using: &azar)!
            for _ in 0..<Int.random(in: 1...4, using: &azar) {
                var caracteres = Array(texto)
                let i = Int.random(in: 0...caracteres.count, using: &azar)
                let pieza = Array(piezas.randomElement(using: &azar)!)
                if Bool.random(using: &azar) || caracteres.isEmpty {
                    caracteres.insert(contentsOf: pieza, at: i)
                } else {
                    caracteres.replaceSubrange(i..<min(caracteres.count, i + pieza.count), with: pieza)
                }
                texto = String(caracteres)
            }
            probar(texto)
        }
        // Intervalos enormes: un error, no un desbordamiento al sumarlos.
        XCTAssertThrowsError(try FormatoUIL(leyendo: "9223372036854775807,1,9223372036854775807"))
        XCTAssertThrowsError(try FormatoUIL(leyendo: "-9223372036854775808,0,-9223372036854775808"))
        XCTAssertThrowsError(try FormatoUIL(leyendo: "2,7,5;T9223372036854775807"))
        for a in piezas.prefix(7) {
            for b in piezas.prefix(7) {
                probar("\(a),\(b),\(a)")
                probar("\(a),\(b),\(b);R\(a)M;T\(b)")
            }
        }
    }
}
