import Foundation
import Testing

@testable import Elementos
@testable import Formatos
@testable import Partituras
@testable import Teoria

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
        let xml = voz.partitura().musicXML()
        #expect(xml.contains("<dynamics><p/></dynamics>"))
        #expect(xml.contains("<staccato/>") && xml.contains("<tenuto/>") && xml.contains("<accent/>"))
        #expect(xml.contains("<strong-accent/>") && xml.contains("<fermata type=\"upright\"/>"))
        // La segunda mitad de la nota ligada no repite el sfz.
        #expect(xml.components(separatedBy: "<sfz/>").count == 2)
        #expect(marcas(try PiezaImportada(musicXML: Data(xml.utf8))) == esperadas)
    }

    @Test func mei() throws {
        let mei = voz.partitura().mei()
        #expect(mei.contains("<artic artic=\"stacc\"/>") && mei.contains("<artic artic=\"marc\"/>"))
        #expect(mei.contains(">sfz</dynam>") && mei.contains("fermata=\"above\""))
        #expect(marcas(try PiezaImportada(mei: Data(mei.utf8))) == esperadas)
    }

    @Test func abc() throws {
        let abc = voz.partitura().abc()
        #expect(abc.contains("!p!.C") && abc.contains("!tenuto!D") && abc.contains("!f!!>![EG]"))
        // Delante de las alteraciones: la tonalidad que se deduce puede escribir Fa con becuadro (`=F`).
        #expect(abc.contains("!marcato!F") || abc.contains("!marcato!=F"))
        #expect(abc.contains("!sfz!G"))
        #expect(marcas(try PiezaImportada(abc: abc)) == esperadas)
    }

    @Test func lilyPondYGUIDO() {
        let ly = voz.partitura().lilyPond()
        #expect(ly.contains("c'4-.\\p") && ly.contains("d'4--") && ly.contains("<e' g'>4->\\f"))
        #expect(ly.contains("f'4-^") && ly.contains("g'2~\\sfz") && ly.contains("g'2\\fermata"))
        let gmn = voz.partitura().guido()
        #expect(gmn.contains("\\intens<\"p\"> \\stacc(c1/4)") && gmn.contains("\\ten(d1/4)"))
        #expect(gmn.contains("\\marcato(f1/4)") && gmn.contains("\\fermata("))
    }

    @Test func midiTocaLaDinamica() {
        let bytes = [UInt8](try! Voz(leyendo: "Do4:4 Re4:4{p} Mi4:4{acento} Fa4:4{sfz} Sol4:4").partitura().midi())
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
        let picada = try PiezaImportada(midi: try Voz(leyendo: "Do4:4{staccato} Re4:4").partitura().midi())
        #expect(picada.notas[0].duracion == .corchea)
        #expect(picada.notas[1].duracion == .negra)
    }

    @Test func sinMarcasNoCambiaNada() throws {
        let sencilla = try Voz(leyendo: "Do4:4 Re4:4 Mi4:2")
        #expect(
            !sencilla.partitura().musicXML().contains("<dynamics>")
                && !sencilla.partitura().musicXML().contains("<articulations>"))
        #expect(!sencilla.partitura().mei().contains("<dynam") && !sencilla.partitura().abc().contains("!"))
        let leida = try PiezaImportada(musicXML: Data(sencilla.partitura().musicXML().utf8))
        #expect(marcas(leida).allSatisfy { $0.hasSuffix(" -") })
    }

    // MARK: Ornamentos

    let adornada = try! Voz(
        leyendo: "Do5:4{trino} Re5:4{mordenteSuperior} Mi5:4{mordenteInferior} Fa5:4{grupeto} "
            + "Sol5+Si5:1{grupetoInvertido}")

    private let ornamentos = [
        "Do5 - trino", "Re5 - mordenteSuperior", "Mi5 - mordenteInferior", "Fa5 - grupeto", "Sol5 - grupetoInvertido",
        "Si5 - grupetoInvertido",
    ]

    @Test func ornamentosEnMusicXML() throws {
        let xml = adornada.partitura().musicXML()
        #expect(xml.contains("<ornaments>") && xml.contains("<trill-mark/>") && xml.contains("<inverted-mordent/>"))
        #expect(xml.contains("<mordent/>") && xml.contains("<turn/>") && xml.contains("<inverted-turn/>"))
        #expect(marcas(try PiezaImportada(musicXML: Data(xml.utf8))) == ornamentos)
    }

    @Test func ornamentosEnMEI() throws {
        let mei = adornada.partitura().mei()
        #expect(mei.contains("ornam=\"T\"") && mei.contains("ornam=\"M\"") && mei.contains("ornam=\"m\""))
        #expect(mei.contains("ornam=\"S\"") && mei.contains("ornam=\"s\""))
        #expect(marcas(try PiezaImportada(mei: Data(mei.utf8))) == ornamentos)
    }

    @Test func ornamentosEnABC() throws {
        let abc = adornada.partitura().abc()
        #expect(abc.contains("!trill!") && abc.contains("!uppermordent!") && abc.contains("!lowermordent!"))
        #expect(abc.contains("!turn!") && abc.contains("!invertedturn!"))
        #expect(marcas(try PiezaImportada(abc: abc)) == ornamentos)
    }

    @Test func ornamentosEnLilyPondYGUIDO() {
        let ly = adornada.partitura().lilyPond()
        #expect(ly.contains("\\trill") && ly.contains("\\prall") && ly.contains("\\mordent"))
        #expect(ly.contains("\\turn") && ly.contains("\\reverseturn"))
        let gmn = adornada.partitura().guido()
        #expect(gmn.contains("\\trill(") && gmn.contains("\\mord(") && gmn.contains("\\mord<inverted=\"true\">("))
        #expect(gmn.contains("\\turn(") && gmn.contains("\\turn<inverted=\"true\">("))
    }
}
