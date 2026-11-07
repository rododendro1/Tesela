import Foundation

// MARK: - Escritura de SVG
//
// Lo que comparten los dibujos SVG del motor (el Tonnetz, la tabla armónica y el pentagrama): cada elemento se
// escribe con sus atributos en orden, el texto y los valores escapados con `EscrituraXML.escapar` y los números con el
// formato del dibujo. Así el escapado y el redondeo son los mismos en todos, y un dibujo nuevo no los repite.

/// Cómo se escriben los números de un dibujo.
package enum NumerosSVG: Hashable, Sendable {
    /// Siempre con un decimal: «3.0», «-0.5». El de los dibujos de las redes, en píxeles.
    case unDecimal
    /// Con tres decimales como mucho y sin ceros de más: «3», «0.125». El del pentagrama, en espacios.
    case hastaTresDecimales

    package func texto(_ valor: Double) -> String {
        switch self {
        case .unDecimal:
            return String(format: "%.1f", valor)
        case .hastaTresDecimales:
            let redondeado = (valor * 1000).rounded() / 1000
            var texto = "\(redondeado)"
            if texto.hasSuffix(".0") { texto.removeLast(2) }
            return texto == "-0" ? "0" : texto
        }
    }
}

/// Un elemento de SVG con sus atributos, en el orden en que se dan:
///
///     ElementoSVG("circle").con("cx", 10).con("cy", 5).con("fill", "#ffffff").vacio
///     // <circle cx="10.0" cy="5.0" fill="#ffffff"/>
package struct ElementoSVG: Sendable {
    package let nombre: String
    package let numeros: NumerosSVG
    private var atributos = ""

    package init(_ nombre: String, numeros: NumerosSVG = .unDecimal) {
        self.nombre = nombre
        self.numeros = numeros
    }

    /// Con un atributo de texto, escapado.
    package func con(_ atributo: String, _ valor: String) -> ElementoSVG {
        var copia = self
        copia.atributos += " \(atributo)=\"\(EscrituraXML.escapar(valor))\""
        return copia
    }

    /// Con un atributo numérico, en el formato del dibujo.
    package func con(_ atributo: String, _ valor: Double) -> ElementoSVG {
        con(atributo, numeros.texto(valor))
    }

    /// Con una lista de puntos («x,y x,y …»), como la de `points` en un polígono.
    package func con(_ atributo: String, puntos: [(x: Double, y: Double)]) -> ElementoSVG {
        con(atributo, puntos.map { "\(numeros.texto($0.x)),\(numeros.texto($0.y))" }.joined(separator: " "))
    }

    /// Con el atributo solo si `condicion` se cumple.
    package func con(_ atributo: String, _ valor: String, si condicion: Bool) -> ElementoSVG {
        condicion ? con(atributo, valor) : self
    }

    /// Sin contenido: `<circle …/>`.
    package var vacio: String { "<\(nombre)\(atributos)/>" }

    /// La etiqueta de apertura: `<g …>`.
    package var apertura: String { "<\(nombre)\(atributos)>" }

    /// Con un texto, escapado: `<text …>Do</text>`.
    package func conTexto(_ texto: String) -> String { "\(apertura)\(EscrituraXML.escapar(texto))</\(nombre)>" }

    /// Con otros elementos dentro, ya escritos: `<g …>…</g>`.
    package func conHijos(_ hijos: String) -> String { "\(apertura)\(hijos)</\(nombre)>" }
}
