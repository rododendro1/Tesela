import Foundation

#if canImport(FoundationXML)
    import FoundationXML
#endif

/// Un elemento XML leído con `XMLParser`, para comprobar lo que se exporta.
public final class ElementoXML {
    public let nombre: String
    public let atributos: [String: String]
    public var hijos: [ElementoXML] = []
    public var texto = ""

    public init(nombre: String, atributos: [String: String]) {
        self.nombre = nombre
        self.atributos = atributos
    }

    public subscript(_ nombre: String) -> ElementoXML? { hijos.first { $0.nombre == nombre } }
    public func todos(_ nombre: String) -> [ElementoXML] { hijos.filter { $0.nombre == nombre } }
    /// Todos los descendientes con ese nombre, en orden.
    public func buscar(_ nombre: String) -> [ElementoXML] {
        hijos.flatMap { ($0.nombre == nombre ? [$0] : []) + $0.buscar(nombre) }
    }
    public var entero: Int? { Int(texto.trimmingCharacters(in: .whitespacesAndNewlines)) }

    /// `nil` si el texto no es XML bien formado.
    public static func leer(_ texto: String) -> ElementoXML? {
        final class Lector: NSObject, XMLParserDelegate {
            var pila: [ElementoXML] = [ElementoXML(nombre: "#documento", atributos: [:])]
            func parser(
                _ parser: XMLParser, didStartElement nombre: String, namespaceURI: String?,
                qualifiedName: String?, attributes: [String: String] = [:]
            ) {
                let elemento = ElementoXML(nombre: nombre, atributos: attributes)
                pila.last!.hijos.append(elemento)
                pila.append(elemento)
            }
            func parser(
                _ parser: XMLParser, didEndElement nombre: String, namespaceURI: String?,
                qualifiedName: String?
            ) {
                pila.removeLast()
            }
            func parser(_ parser: XMLParser, foundCharacters texto: String) { pila.last!.texto += texto }
        }
        let parser = XMLParser(data: Data(texto.utf8))
        let lector = Lector()
        parser.delegate = lector
        guard parser.parse() else { return nil }
        return lector.pila.first?.hijos.first
    }
}
