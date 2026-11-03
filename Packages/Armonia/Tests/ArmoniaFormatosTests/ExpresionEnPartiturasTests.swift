import Foundation
import Testing

@testable import ArmoniaFormatos
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

/// La dinámica y las articulaciones en cada formato de partitura, de ida y de vuelta.
@Suite struct ExpresionEnPartiturasTests {
    let voz = try! Voz(
        leyendo: "Do4:4{p,staccato} Re4:4{tenuto} Mi4+Sol4:4{f,acento} Fa4:4{marcato} Sol4:2~{sfz} Sol4:2{calderon}",
        compas: "4/4")

    /// Cada nota como «altura dinámica articulaciones», en orden de comienzo.
    private func marcas(_ pieza: PiezaImportada) -> [String] {
        pieza.notas.map { nota in
            ([nota.altura.description, nota.dinamica?.rawValue ?? "-"] + nota.articulaciones.map(\.rawValue))
                .joined(separator: " ")
        }
    }

    private let esperadas = [
        "Do4 p staccato", "Re4 - tenuto", "Mi4 f acento", "Sol4 f acento", "Fa4 - marcato", "Sol4 sfz",
    ]

    @Test func musicXML() throws {
        let xml = voz.musicXML()
        #expect(xml.contains("<dynamics><p/></dynamics>"))
        #expect(xml.contains("<staccato/>") && xml.contains("<tenuto/>") && xml.contains("<accent/>"))
        #expect(xml.contains("<strong-accent/>") && xml.contains("<fermata type=\"upright\"/>"))
        // La segunda mitad de la nota ligada no repite el sfz.
        #expect(xml.components(separatedBy: "<sfz/>").count == 2)
        #expect(marcas(try PiezaImportada(musicXML: Data(xml.utf8))) == esperadas)
    }

    @Test func mei() throws {
        let mei = voz.mei()
        #expect(mei.contains("<artic artic=\"stacc\"/>") && mei.contains("<artic artic=\"marc\"/>"))
        #expect(mei.contains(">sfz</dynam>") && mei.contains("fermata=\"above\""))
        #expect(marcas(try PiezaImportada(mei: Data(mei.utf8))) == esperadas)
    }

    @Test func abc() throws {
        let abc = voz.abc()
        #expect(abc.contains("!p!.C") && abc.contains("!tenuto!D") && abc.contains("!f!!>![EG]"))
        // Delante de las alteraciones: la tonalidad que se deduce puede escribir Fa con becuadro (`=F`).
        #expect(abc.contains("!marcato!F") || abc.contains("!marcato!=F"))
        #expect(abc.contains("!sfz!G"))
        #expect(marcas(try PiezaImportada(abc: abc)) == esperadas)
    }

    @Test func lilyPondYGUIDO() {
        let ly = voz.lilyPond()
        #expect(ly.contains("c'4-.\\p") && ly.contains("d'4--") && ly.contains("<e' g'>4->\\f"))
        #expect(ly.contains("f'4-^") && ly.contains("g'2~\\sfz") && ly.contains("g'2\\fermata"))
        let gmn = voz.guido()
        #expect(gmn.contains("\\intens<\"p\"> \\stacc(c1/4)") && gmn.contains("\\ten(d1/4)"))
        #expect(gmn.contains("\\marcato(f1/4)") && gmn.contains("\\fermata("))
    }

    @Test func midiTocaLaDinamica() {
        let bytes = [UInt8](try! Voz(leyendo: "Do4:4 Re4:4{p} Mi4:4{acento} Fa4:4{sfz} Sol4:4").midi())
        /// La velocidad con que empieza a sonar cada altura.
        func velocidad(_ clave: UInt8) -> UInt8? {
            for i in 0..<(bytes.count - 2) where bytes[i] == 0x90 && bytes[i + 1] == clave { return bytes[i + 2] }
            return nil
        }
        #expect(velocidad(60) == 80) // sin marca, mf
        #expect(velocidad(62) == 49) // p
        #expect(velocidad(64) == 65) // p y acento
        #expect(velocidad(65) == 112) // sfz
        #expect(velocidad(67) == 49) // vuelve a p
    }

    @Test func elStaccatoSuenaMasCorto() throws {
        let picada = try PiezaImportada(midi: try Voz(leyendo: "Do4:4{staccato} Re4:4").midi())
        #expect(picada.notas[0].duracion == .corchea)
        #expect(picada.notas[1].duracion == .negra)
    }

    @Test func sinMarcasNoCambiaNada() throws {
        let sencilla = try Voz(leyendo: "Do4:4 Re4:4 Mi4:2")
        #expect(!sencilla.musicXML().contains("<dynamics>") && !sencilla.musicXML().contains("<articulations>"))
        #expect(!sencilla.mei().contains("<dynam") && !sencilla.abc().contains("!"))
        let leida = try PiezaImportada(musicXML: Data(sencilla.musicXML().utf8))
        #expect(marcas(leida).allSatisfy { $0.hasSuffix(" -") })
    }
}
