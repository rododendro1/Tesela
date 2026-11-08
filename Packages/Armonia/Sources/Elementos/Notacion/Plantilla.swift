/// Un texto con huecos numerados, `{1}`, `{2}`…, que se rellenan con los valores en ese orden:
///
///     let plantilla: Plantilla = "no se puede leer «{1}» (carácter {2})"
///     plantilla("Do#x", 4)   // no se puede leer «Do#x» (carácter 4)
///
/// Así un texto de los ficheros de idioma (`TextosDeX+Espanol.swift`…) es solo texto, sin código, y los
/// huecos se pueden comprobar desde fuera: `Scripts/comprobaciones/comprobar_traducciones.py` avisa si un
/// idioma no tiene los mismos que el español. Un hueco puede repetirse o ir en otro orden (en húngaro o en
/// euskera el orden de las palabras cambia); uno sin valor se deja como está.
public struct Plantilla: Hashable, Sendable, ExpressibleByStringLiteral, CustomStringConvertible {
    /// El texto, con los huecos sin rellenar.
    public let texto: String

    public init(_ texto: String) { self.texto = texto }

    public init(stringLiteral texto: String) { self.init(texto) }

    public var description: String { texto }

    /// El texto con cada `{n}` cambiado por el valor `n`-ésimo, contando desde 1.
    public func callAsFunction(_ valores: any CustomStringConvertible...) -> String {
        rellenada(con: valores.map(\.description))
    }

    /// Lo mismo, con los valores ya escritos.
    public func rellenada(con valores: [String]) -> String {
        var resultado = ""
        var resto = Substring(texto)
        while let abre = resto.firstIndex(of: "{") {
            resultado += resto[..<abre]
            let tras = resto.index(after: abre)
            guard let cierra = resto[tras...].firstIndex(of: "}"), let n = Int(resto[tras..<cierra]),
                valores.indices.contains(n - 1)
            else {
                resultado.append("{")
                resto = resto[tras...]
                continue
            }
            resultado += valores[n - 1]
            resto = resto[resto.index(after: cierra)...]
        }
        return resultado + resto
    }

    /// Los números de los huecos, sin repetir y en orden: `[1, 2]` en «{2} de {1}».
    public var huecos: [Int] {
        var vistos = Set<Int>()
        var resto = Substring(texto)
        while let abre = resto.firstIndex(of: "{") {
            let tras = resto.index(after: abre)
            if let cierra = resto[tras...].firstIndex(of: "}"), let n = Int(resto[tras..<cierra]) {
                vistos.insert(n)
                resto = resto[resto.index(after: cierra)...]
            } else {
                resto = resto[tras...]
            }
        }
        return vistos.sorted()
    }
}

extension Traducido where Valor == Plantilla {
    /// La plantilla en el idioma de los textos de la notación y en su grafía, con los huecos sin tocar.
    public func en(_ notacion: Notacion) -> Plantilla {
        Plantilla(notacion.enSuGrafia(texto(en: notacion.textos).texto))
    }
}

extension Traducido where Valor == [Plantilla] {
    /// Las plantillas en el idioma de los textos de la notación y en su grafía.
    public func en(_ notacion: Notacion) -> [Plantilla] {
        texto(en: notacion.textos).map { Plantilla(notacion.enSuGrafia($0.texto)) }
    }
}
