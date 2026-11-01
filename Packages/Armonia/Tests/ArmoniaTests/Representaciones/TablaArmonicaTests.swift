import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

@Suite struct TablaArmonicaTests {
    private func punto(_ a: Int, _ b: Int) -> PuntoDeLaRed { PuntoDeLaRed(quintas: a, terceras: b) }

    @Test func notas() {
        let tabla = TablaArmonica(Acorde("Do"))
        #expect(tabla.colocacion == .notas)
        #expect(tabla.puntos == Tonnetz(Acorde("Do")).puntos)
        #expect(tabla.triadas.map(\.acorde) == [Acorde("Do")])
        #expect("\(tabla)" == "Do (0, 0) · Mi (0, 1) · Sol (1, 0)")
        #expect(TablaArmonica(Escala(.re, .dorico)).esConexo)
        #expect(TablaArmonica(ConjuntoDeClases([0, 3, 7])).colocacion == .clasesDeAltura)
        // La forma es la misma en todas las tonalidades: transportar es desplazar los hexágonos.
        let forma = { (tabla: TablaArmonica) -> [PuntoDeLaRed] in
            tabla.puntos.map {
                self.punto($0.quintas - tabla.puntos[0].quintas, $0.terceras - tabla.puntos[0].terceras)
            }
        }
        for tonica in [Nota.re, Nota(.mi, .bemol), Nota(.fa, .sostenido), .si] {
            #expect(
                forma(TablaArmonica(Acorde(tonica, Acorde("Domaj7").tipo))) == forma(TablaArmonica(Acorde("Domaj7"))),
                "\(tonica)")
        }
    }

    @Test func alturas() {
        #expect(TablaArmonica.midi(de: punto(0, 0)) == 60)
        #expect(TablaArmonica.midi(de: punto(1, 0)) == 67) // una quinta arriba
        #expect(TablaArmonica.midi(de: punto(0, 1)) == 64) // una tercera mayor arriba
        #expect(TablaArmonica.midi(de: punto(1, -1)) == 63) // una tercera menor arriba
        let abierta = TablaArmonica([Altura("Do3"), Altura("Sol3"), Altura("Mi4"), Altura("Si4")])
        #expect(abierta.colocacion == .alturas)
        #expect(abierta.puntos.map(TablaArmonica.midi) == [48, 55, 64, 71])
        // Do4, Mi4 y Sol4 son una tríada; Do3, Mi4 y Sol4 no: en la tabla suenan las alturas.
        #expect(TablaArmonica([Altura("Do4"), Altura("Mi4"), Altura("Sol4")]).triadas.count == 1)
        #expect(TablaArmonica([Altura("Do3"), Altura("Mi4"), Altura("Sol4")]).triadas.count == 0)
        // Las enarmónicas comparten hexágono.
        #expect(TablaArmonica([Altura("Fa#4"), Altura("Solb4")]).puntos.count == 1)
        #expect("\(TablaArmonica([Altura("Do4"), Altura("Sol4")]))" == "Do4 (0, 0) · Sol4 (1, 0)")
        // Cualquier altura se puede colocar.
        for midi in 21...108 {
            #expect(TablaArmonica([Altura(midi: midi)]).puntos.map(TablaArmonica.midi) == [midi])
        }
    }

    @Test func sVG() throws {
        for tabla in [
            TablaArmonica(Escala(.re, .dorico)), TablaArmonica(ConjuntoDeClases([0, 4, 7])),
            TablaArmonica([Altura("Do3"), Altura("Sol3"), Altura("Mi4")]), TablaArmonica([Nota]()),
        ] {
            let raiz = try #require(ElementoXML.leer(tabla.svg()))
            #expect(raiz.nombre == "svg")
            #expect(!(raiz.todos("polygon").isEmpty))
        }
        let raiz = try #require(ElementoXML.leer(TablaArmonica(Acorde("Domaj7")).svg(margen: 1)))
        let marcadas = raiz.todos("text").filter { $0.atributos["font-weight"] == "bold" }.map(\.texto)
        #expect(Set(marcadas) == ["Do", "Mi", "Sol", "Si"])
        // Dos tríadas, Do y Mim: dos puntos, naranja y azul.
        #expect(raiz.todos("circle").map { $0.atributos["fill"] } == ["#f6b26b", "#8fb8e8"])
        // El contorno: cuatro hexágonos en rombo tienen 24 lados, menos 2 × 5 compartidos.
        #expect(raiz.todos("line").filter { $0.atributos["stroke-width"] == "3" }.count == 14)
        // Con alturas, los nombres llevan octava.
        let alturas = try #require(ElementoXML.leer(TablaArmonica([Altura("Do4"), Altura("Mib4")]).svg()))
        #expect(alturas.todos("text").contains { $0.texto == "Mi♭4" && $0.atributos["font-weight"] == "bold" })
        let ingles = try #require(ElementoXML.leer(TablaArmonica(Acorde("Re")).svg(notacion: .inglesASCII)))
        #expect(ingles.todos("text").contains { $0.texto == "F#" })
    }

    @Test func tituloYLeyenda() throws {
        func leyenda(_ raiz: ElementoXML) -> [String] {
            raiz.todos("g").filter { $0.atributos["class"] == "leyenda" }.flatMap { $0.todos("text").map(\.texto) }
        }
        let acorde = try #require(ElementoXML.leer(TablaArmonica(Acorde("Domaj7")).svg()))
        #expect(acorde.todos("title").first?.texto == "Domaj7")
        #expect(leyenda(acorde) == ["nota", "fundamental", "contorno de la forma", "tríada mayor", "tríada menor"])
        let escala = try #require(ElementoXML.leer(TablaArmonica(Escala(.re, .dorico)).svg()))
        #expect(escala.todos("title").first?.texto == "Re dórico")
        #expect(leyenda(escala)[1] == "tónica")
        let alturas = try #require(
            ElementoXML.leer(TablaArmonica([Altura("Do3"), Altura("Sol3")]).svg(notacion: .inglesASCII)))
        #expect(alturas.todos("title").first?.texto == "C3 · G3")
        #expect(leyenda(alturas) == ["pitch (every key)", "first note", "outline of the shape"])
        #expect(try leyenda(#require(ElementoXML.leer(TablaArmonica(Acorde("Do")).svg(leyenda: false)))).isEmpty)
        // En catalán, gallego y euskera, el título y la leyenda también.
        let euskera = try #require(ElementoXML.leer(TablaArmonica(Escala(.re, .dorico)).svg(notacion: .euskera)))
        #expect(euskera.todos("title").first?.texto == "re doriarra")
        #expect(leyenda(euskera)[1] == "tonika")
        let catalan = try #require(ElementoXML.leer(TablaArmonica(Acorde("Domaj7")).svg(notacion: .catalan)))
        #expect(leyenda(catalan) == ["nota", "fonamental", "contorn de la forma", "tríada major", "tríada menor"])
        let tabla = try #require(TablaArmonica(ciclo: .hexatonico, desde: "Do"))
        let ciclo = try #require(ElementoXML.leer(tabla.svg(notacion: .gallego)))
        #expect(leyenda(ciclo).contains("fundamental do primeiro acorde"))
    }

    @Test func recorrido() throws {
        let tabla = try #require(TablaArmonica(recorrido: ["Do", "Lam", "Fa"]))
        #expect(tabla.recorrido.map(\.acorde) == [Acorde("Do"), Acorde("Lam"), Acorde("Fa")])
        #expect(tabla.puntos == Tonnetz(recorrido: ["Do", "Lam", "Fa"])!.puntos)
        #expect(TablaArmonica(recorrido: ["Do", "Sol7"]) == nil)
        let camino = try #require(TablaArmonica(caminoDesde: "Do", hasta: "Mibm"))
        #expect(camino.recorrido.map(\.acorde) == [Acorde("Do"), Acorde("Dom"), Acorde("Mib"), Acorde("Mibm")])
        #expect(TablaArmonica(caminoDesde: "Do", hasta: "Sol7") == nil)
        // El dibujo: dos flechas, del vértice de Do al de Lam y de este al de Fa, y el título.
        let raiz = try #require(ElementoXML.leer(tabla.svg()))
        #expect(raiz.todos("line").filter { $0.atributos["marker-end"] != nil }.count == 2)
        #expect(raiz.todos("title").first?.texto == "Do –R→ Lam –L→ Fa")
        let leyenda = raiz.todos("g").filter { $0.atributos["class"] == "leyenda" }.flatMap {
            $0.todos("text").map(\.texto)
        }
        #expect(leyenda.last == "paso del recorrido (P, L, R)")
        #expect(leyenda.contains("fundamental del primer acorde"))
        // Las flechas empiezan en el vértice común de los tres hexágonos de la tríada: a la
        // distancia del radio de cada uno de sus centros.
        let primera = try #require(raiz.todos("line").first { $0.atributos["marker-end"] != nil })
        let paso = 72.0
        let coseno = 0.8660254037844386
        let vertices = Tonnetz.Triada(Acorde("Do"))!.vertices
        let cx = vertices.map { Double($0.terceras) * coseno * paso }.reduce(0, +) / 3
        let cy = vertices.map { -(Double($0.quintas) + Double($0.terceras) / 2) * paso }.reduce(0, +) / 3
        for v in vertices {
            let d =
                ((Double(v.terceras) * coseno * paso - cx) * (Double(v.terceras) * coseno * paso - cx)
                + (-(Double(v.quintas) + Double(v.terceras) / 2) * paso - cy)
                    * (-(Double(v.quintas) + Double(v.terceras) / 2) * paso - cy))
                .squareRoot()
            #expect(abs(d - (paso / (2 * coseno))) <= 0.001)
        }
        let x1 = try #require(Double(primera.atributos["x1"] ?? ""))
        let y1 = try #require(Double(primera.atributos["y1"] ?? ""))
        #expect(((x1 - cx) * (x1 - cx) + (y1 - cy) * (y1 - cy)).squareRoot() < (paso * 0.15))
    }
    @Test func ciclo() throws {
        let tabla = try #require(TablaArmonica(ciclo: .hexatonico, desde: "Do"))
        let tonnetz = try #require(Tonnetz(ciclo: .hexatonico, desde: "Do"))
        #expect(tabla.puntos == tonnetz.puntos)
        #expect(tabla.recorrido.count == 7)
        #expect(tabla.description == tonnetz.description)
        let raiz = try #require(ElementoXML.leer(tabla.svg()))
        #expect(raiz.todos("title").first?.texto == "Do –P→ Dom –L→ La♭ –P→ La♭m –L→ Mi –P→ Mim –L→ Do")
        #expect(raiz.todos("line").filter { $0.atributos["marker-end"] != nil }.count == 6)
        // Los hexágonos se llaman como en las tríadas del ciclo: Do♭ en La♭m, nunca Fa♭.
        let textos = raiz.todos("text").map(\.texto)
        #expect(textos.contains("Do♭"))
        #expect(!(textos.contains("Fa♭") || textos.contains { $0.contains("♭♭") }))
        #expect(TablaArmonica(ciclo: .octatonico, desde: "Do")?.recorrido.count == 9)
        #expect(TablaArmonica(ciclo: .lr, desde: "Do7") == nil)
    }
}
