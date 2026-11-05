import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

/// La ayuda corta sola sus descripciones y sus notas (`LineaDeComandos.ajustar`): los textos llevan un párrafo por
/// línea, sin cortes a mano.
@Suite struct AyudaTests {
    typealias L = LineaDeComandos

    @Test func ajustarCortaPorPalabras() {
        #expect(L.ajustar("uno dos tres cuatro", ancho: 8) == ["uno dos", "tres", "cuatro"])
        #expect(L.ajustar("primero\n--segundo: otro párrafo", ancho: 40) == ["primero", "--segundo: otro párrafo"])
        #expect(L.ajustar("supercalifragilístico sí", ancho: 5) == ["supercalifragilístico", "sí"])
        #expect(L.ajustar("", ancho: 5) == [""])
    }

    /// Ninguna línea de la descripción ni de las notas pasa de `anchoDeLaDescripcion`, salvo una palabra sola que no
    /// cabe, en ningún idioma.
    @Test func lasDescripcionesCabenEnSuColumna() {
        for idioma in Idioma.allCases {
            for entrada in L.ordenesDeLaAyuda {
                for texto in [entrada.descripcion, entrada.notas].compactMap({ $0?.texto(en: idioma) }) {
                    for linea in L.ajustar(texto) {
                        #expect(
                            linea.count <= L.anchoDeLaDescripcion || !linea.contains(" "),
                            Comment(rawValue: "\(idioma): \(linea)"))
                    }
                }
            }
        }
    }

    /// Los textos no se cortan a mano: un salto de línea solo abre un párrafo, que empieza por una opción con su
    /// explicación («--escalas: …») o por la palabra de las opciones («opciones: …»).
    @Test func losSaltosDeLineaAbrenParrafos() {
        for idioma in Idioma.allCases {
            for entrada in L.ordenesDeLaAyuda {
                for texto in [entrada.descripcion, entrada.notas].compactMap({ $0?.texto(en: idioma) }) {
                    for parrafo in texto.components(separatedBy: "\n").dropFirst() {
                        let primera = parrafo.split(separator: " ").first.map(String.init) ?? ""
                        #expect(primera.hasSuffix(":"), Comment(rawValue: "\(idioma): \(parrafo)"))
                    }
                }
            }
        }
    }
}
