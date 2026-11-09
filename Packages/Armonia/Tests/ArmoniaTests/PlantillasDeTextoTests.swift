import Testing

@testable import Diagramas
@testable import Elementos
@testable import Formatos
@testable import Partituras
@testable import Polifonia
@testable import Teoria
@testable import Trastes

@Suite struct PlantillasDeTextoTests {
    @Test func seRellenanLosHuecos() {
        let plantilla: Plantilla = "no se puede leer «{1}» (carácter {2})"
        #expect(plantilla("Do#x", 4) == "no se puede leer «Do#x» (carácter 4)")
        #expect(plantilla.huecos == [1, 2])
        // En otro orden, repetido, o sin valor: el que falta se deja como está.
        #expect(Plantilla("{2} de {1}, {2}")("a", "b") == "b de a, b")
        #expect(Plantilla("{1} y {3}")("a") == "a y {3}")
        #expect(Plantilla("{1} y {3}").huecos == [1, 3])
        // Llaves que no son huecos.
        #expect(Plantilla("{x} {} {1")("a") == "{x} {} {1")
        #expect(Plantilla("{x} {} {1").huecos == [])
        #expect(Plantilla("sin huecos")() == "sin huecos")
        #expect("\(Plantilla("{1}"))" == "{1}")
    }

    /// Los huecos de cada plantilla, por idioma: los de los trece tienen que ser los del español.
    private func comprobar<Textos: TextosTraducidos>(_ tipo: Textos.Type) -> Int {
        // Una plantilla sola o una lista de ellas (`conPuntillos`).
        func plantillas(_ idioma: Idioma) -> [(String, Plantilla)] {
            Mirror(reflecting: Textos.traducidos.texto(en: idioma)).children.flatMap { hijo in
                let suyas = (hijo.value as? Plantilla).map { [$0] } ?? (hijo.value as? [Plantilla]) ?? []
                return suyas.map { (hijo.label ?? "", $0) }
            }
        }
        let espanol = plantillas(.espanol)
        for idioma in Idioma.allCases {
            for ((nombre, suya), (_, enEspanol)) in zip(plantillas(idioma), espanol) {
                #expect(suya.huecos == enEspanol.huecos, "\(Textos.self).\(nombre) en \(idioma)")
                #expect(!enEspanol.huecos.isEmpty, "\(Textos.self).\(nombre) no tiene huecos")
            }
        }
        return espanol.count
    }

    @Test func cadaIdiomaTieneLosHuecosDelEspanol() {
        let cuantas = [
            comprobar(TextosDeElementos.self), comprobar(TextosDeTeoria.self), comprobar(TextosDeDiagramas.self),
            comprobar(TextosDePartituras.self), comprobar(TextosDePolifonia.self), comprobar(TextosDeFormatos.self),
            comprobar(TextosDeTrastes.self),
        ]
        #expect(cuantas.reduce(0, +) == 61)
    }
}
