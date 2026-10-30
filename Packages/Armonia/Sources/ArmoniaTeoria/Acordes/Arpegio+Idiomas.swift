import ArmoniaNucleo
import Foundation
// Nombres de los arpegios y de sus patrones en los catorce idiomas de los textos (`Traduccion`).

// MARK: - Arpegio

extension Arpegio {
    /// «Arpegio de Do mayor», «C major arpeggio», «Arpège de Do majeur», «C-Dur-Arpeggio», «Арпеджио до мажор».
    public func nombre(en notacion: Notacion) -> String {
        let acorde = self.acorde.nombre(en: notacion)
        let plantilla = Traduccion("Arpegio de {}", "{} arpeggio", ca: "Arpegi de {}", gl: "Arpexo de {}",
                                   ast: "Arpexu de {}", an: "Arpechio de {}", eu: "{} arpegioa",
                                   pt: "Arpejo de {}", fr: "Arpège de {}", oc: "Arpegi de {}",
                                   it: "Arpeggio di {}", de: "Arpeggio: {}",
                                   el: "Αρπέζ {}", ru: "Арпеджио {}").en(notacion)
        return plantilla.replacingOccurrences(of: "{}", with: acorde)
    }

    public var nombre: String { nombre(en: .espanolUnicode) }

    /// Lee «arpegio Dom7», «Dom7 arpeggio», «Arpège de Do» o solo el cifrado: se quitan las palabras «arpegio»
    /// (en cualquier idioma) y las preposiciones que las acompañan, y el resto es un cifrado de acorde.
    /// El patrón es el ascendente, de una octava.
    public init(leyendo texto: String) throws {
        let palabras: Set<String> = [
            "arpegio", "arpeggio", "arpegi", "arpexo", "arpexu", "arpechio", "arpegioa", "arpejo", "arpege",
            "αρπεζ", "арпеджио", "de", "di", "of", "d'",
        ]
        func sinAcentos(_ s: String) -> String {
            s.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
        }
        let resto = texto.split(separator: " ").filter { !palabras.contains(sinAcentos(String($0))) }
            .joined(separator: " ")
        self.init(try Acorde(leyendo: resto.isEmpty ? texto : resto))
    }
}

// MARK: - Patron

extension Arpegio.Patron {
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    public var nombre: String { nombre(en: .espanolUnicode) }

    private var traduccion: Traduccion {
        switch self {
        case .ascendente:
            return Traduccion("ascendente", "ascending", ca: "ascendent", gl: "ascendente", ast: "ascendente",
                              an: "ascendent", eu: "igoera", pt: "ascendente", fr: "ascendant", oc: "ascendent",
                              it: "ascendente", de: "aufwärts", el: "ανιούσα", ru: "восходящий")
        case .descendente:
            return Traduccion("descendente", "descending", ca: "descendent", gl: "descendente", ast: "descendente",
                              an: "descendent", eu: "jaitsiera", pt: "descendente", fr: "descendant", oc: "descendent",
                              it: "discendente", de: "abwärts", el: "κατιούσα", ru: "нисходящий")
        case .idaYVuelta:
            return Traduccion("de ida y vuelta", "up and down", ca: "d'anada i tornada", gl: "de ida e volta",
                              ast: "d'ida y vuelta", an: "d'ida y tornada", eu: "joan-etorria", pt: "de ida e volta",
                              fr: "aller-retour", oc: "d'anada e de tornada", it: "andata e ritorno",
                              de: "auf und ab", el: "πάνω-κάτω", ru: "вверх и вниз")
        case .alberti:
            return Traduccion("bajo de Alberti", "Alberti bass", ca: "baix d'Alberti", gl: "baixo de Alberti",
                              ast: "baxu d'Alberti", an: "baixo d'Alberti", eu: "Albertiren baxua",
                              pt: "baixo de Alberti", fr: "basse d'Alberti", oc: "bassa d'Alberti",
                              it: "basso albertino", de: "Albertibass", el: "μπάσο Alberti", ru: "альбертиев бас")
        }
    }
}
