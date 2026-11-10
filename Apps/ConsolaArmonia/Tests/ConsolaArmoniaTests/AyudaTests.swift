import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

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

    // MARK: Las opciones declaradas

    /// Las opciones que nombran los textos de una entrada, en español y en inglés, sin las generales: `--` seguido de
    /// letras y guiones («--patron», «--ida-y-vuelta»), en el orden en que salen.
    static func opcionesNombradas(en entrada: L.EntradaDeAyuda) -> [String] {
        var vistas: [String] = []
        for idioma in [Idioma.espanol, .ingles] {
            let texto = [entrada.sintaxis, entrada.descripcion, entrada.notas ?? entrada.descripcion]
                .map { $0.texto(en: idioma) }.joined(separator: " ")
            var actual = ""
            for caracter in texto + " " {
                if caracter.isLetter || caracter == "-" {
                    actual.append(caracter)
                    continue
                }
                let opcion = actual.hasSuffix("-") ? String(actual.dropLast()) : actual
                if opcion.hasPrefix("--"), opcion.count > 2, opcion.dropFirst(2).first?.isLetter == true,
                    !vistas.contains(opcion), !L.opcionesGenerales.contains(opcion)
                {
                    vistas.append(opcion)
                }
                actual = ""
            }
        }
        return vistas
    }

    /// Cada entrada de la ayuda declara las opciones que explica, ni más ni menos: una opción nueva en la ayuda se
    /// declara también, y así se completa y se propone.
    @Test func cadaEntradaDeclaraLasOpcionesQueExplica() {
        for orden in L.ordenes {
            for entrada in orden.ayuda {
                let declaradas = entrada.opciones.flatMap(\.nombres)
                let comentario = Comment(rawValue: orden.nombres[0])
                #expect(Set(declaradas) == Set(Self.opcionesNombradas(en: entrada)), comentario)
                #expect(Set(declaradas).count == declaradas.count, comentario)
            }
        }
    }

    /// Una orden tiene las opciones de su ayuda, salvo las partituras, que comparten las de `musicxml` (MIDI, sin la
    /// clave ni las marcas), y `grabar`, que suma las de la partitura que graba.
    @Test func lasOpcionesDeCadaOrden() {
        func buscar(_ nombre: String) -> L.Orden { L.ordenes.first { $0.nombres.contains(nombre) }! }
        #expect(buscar("acorde").opciones.contains("--disposiciones"))
        #expect(buscar("acorde").opciones.contains("--voicings"))
        #expect(buscar("mei").opciones == buscar("musicxml").opciones)
        #expect(buscar("mei").opciones.contains("--titulo"))
        #expect(buscar("midi").opciones.contains("--programa"))
        #expect(!buscar("midi").opciones.contains("--clave"))
        #expect(buscar("grabar").opciones.contains("--motor"))
        #expect(buscar("grabar").opciones.contains("--titulo"))
        for orden in L.ordenes { #expect(Set(orden.opciones).count == orden.opciones.count) }
    }

    /// Las órdenes que admiten `--json` son las que lo declaran.
    @Test func lasOrdenesConJSON() {
        let conJSON = L.ordenes.filter { $0.json != nil }.map { $0.nombres[0] }
        #expect(
            conJSON == [
                "acorde", "identificar", "arpegio", "intervalo", "escala", "escalas", "tradiciones", "progresiones",
                "ritmos", "temperamentos",
                "acordes", "tonalidad",
                "conjunto", "serie", "analizar", "armonizar", "realizar", "revisar", "contrapunto", "transponer",
                "rearmonizar", "motores", "vecinos", "camino-parsimonioso", "conduccion-minima", "plr",
                "digitaciones", "posiciones",
            ])
    }
}

extension AyudaTests {
    /// Ninguna orden acepta una opción que no conoce: cada ejemplo de la ayuda, con una opción inventada al final, es
    /// un error de uso que la nombra.
    @Test func ningunaOrdenAceptaUnaOpcionInventada() {
        for orden in L.ordenes where !orden.nombres.contains("ayuda") {
            for entrada in orden.ayuda {
                guard let ejemplo = entrada.ejemplo?.texto(en: .espanol), ejemplo.hasPrefix("armonia ") else {
                    continue
                }
                // Sin «armonia» ni lo que se redirige a un fichero.
                var palabras = ejemplo.split(separator: " ").map(String.init).dropFirst()
                if let i = palabras.firstIndex(where: { $0.hasPrefix(">") || $0 == "|" || $0 == "<" }) {
                    palabras = palabras[..<i]
                }
                let resultado = L.ejecutar(Array(palabras) + ["--opcion-inventada"])
                #expect(resultado.codigo == 2, Comment(rawValue: ejemplo))
                #expect(resultado.error.contains("--opcion-inventada"), Comment(rawValue: ejemplo))
            }
        }
    }
}
