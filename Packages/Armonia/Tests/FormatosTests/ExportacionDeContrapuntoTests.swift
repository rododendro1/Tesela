import Foundation
import Testing

@testable import Elementos
@testable import Formatos
@testable import PartituraArmonia
@testable import Teoria

@Suite struct ExportacionDeContrapuntoTests {
    /// El primer ejemplo de Fux, nota contra nota, con el contrapunto encima.
    private let primera = try! Contrapunto(
        cantusFirmus: "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4",
        contrapunto: "La4 La4 Sol4 La4 Si4 Do5 Do5 Si4 Re5 Do#5 Re5", especie: .primera)

    /// Segunda especie con el contrapunto debajo y un silencio de blanca al principio.
    private let segunda = try! Contrapunto(
        cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "-:2 Re3 Re3 La3 Do4 Sol3 Re3:1", especie: .segunda)

    /// Las notas como (MIDI, comienzo en redondas), en orden.
    private func notas(_ pieza: PiezaImportada) -> [[Double]] {
        pieza.notas.map { [Double($0.altura.midi), $0.inicio.enRedondas] }
    }

    private func esperadas(_ ejercicio: Contrapunto) -> [[Double]] {
        var todas: [[Double]] = []
        for voz in [ejercicio.vozDelCantus, ejercicio.contrapunto] {
            var inicio = Duracion.cero
            for evento in voz.eventos {
                for altura in evento.alturas { todas.append([Double(altura.midi), inicio.enRedondas]) }
                inicio = inicio + evento.duracion
            }
        }
        return todas.sorted { ($0[1], $0[0]) < ($1[1], $1[0]) }
    }

    @Test func lasVocesVanDeArribaAbajo() {
        #expect(primera.vocesDeArribaAbajo.map(\.nombre) == ["Contrapunctus", "Cantus firmus"])
        #expect(segunda.vocesDeArribaAbajo.map(\.nombre) == ["Cantus firmus", "Contrapunctus"])
        #expect(primera.vozDelCantus.eventos.count == 11)
        #expect(primera.vozDelCantus.eventos.allSatisfy { $0.duracion == .redonda })
    }

    @Test(arguments: ["musicXML", "mei", "abc", "midi"])
    func seLeeComoSeEscribio(formato: String) throws {
        for ejercicio in [primera, segunda] {
            let datos: Data
            switch formato {
            case "musicXML":
                datos = Data(ejercicio.partitura(encabezado: Encabezado(titulo: "Contrapunto")).musicXML().utf8)
            case "mei": datos = Data(ejercicio.partitura(encabezado: Encabezado(titulo: "Contrapunto")).mei().utf8)
            case "abc": datos = Data(ejercicio.partitura(encabezado: Encabezado(titulo: "Contrapunto")).abc().utf8)
            default: datos = ejercicio.partitura(encabezado: Encabezado(titulo: "Contrapunto")).midi()
            }
            let pieza = try PiezaImportada(leyendo: datos)
            #expect(notas(pieza) == esperadas(ejercicio), "\(formato)")
        }
    }

    @Test func musicXMLEnDosPentagramasConSuClave() {
        let xml = segunda.partitura().musicXML()
        #expect(xml.contains("<staves>2</staves>"))
        // El cantus, arriba, en clave de sol; el contrapunto, abajo, en clave de fa.
        #expect(xml.contains("<clef number=\"1\">\n          <sign>G</sign>"))
        #expect(xml.contains("<clef number=\"2\">\n          <sign>F</sign>"))
        // Sin armadura, como los ejemplos de Fux.
        #expect(xml.contains("<fifths>0</fifths>"))
    }

    @Test func lilyPondConLasDosVoces() {
        let ly = primera.partitura(encabezado: Encabezado(titulo: "Fux")).lilyPond()
        #expect(ly.contains("Fux"))
        #expect(ly.components(separatedBy: "\\clef").count == 3)
    }
}
