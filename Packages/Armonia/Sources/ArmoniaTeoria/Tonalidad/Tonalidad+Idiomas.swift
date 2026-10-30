import ArmoniaNucleo
// Nombres de los modos y de las tonalidades en cada idioma. El resto de nombres que dependen del idioma, en `Fundamentos/Nota+Idiomas.swift` y `Fundamentos/Intervalo+Idiomas.swift`.

// MARK: - Tonalidad.Modo

extension Tonalidad.Modo {
    public var nombre: String { self == .mayor ? "mayor" : "menor" }

    public func nombre(en notacion: Notacion) -> String {
        switch notacion.idiomaDeLasNotas {
        case .espanol: return nombre
        case .ingles: return self == .mayor ? "major" : "minor"
        case .catalan: return self == .mayor ? "major" : "menor"
        case .gallego: return self == .mayor ? "maior" : "menor"
        case .euskera: return self == .mayor ? "maiorra" : "minorra"
        case .portugues: return self == .mayor ? "maior" : "menor"
        case .frances: return self == .mayor ? "majeur" : "mineur"
        case .occitano: return self == .mayor ? "major" : "menor"
        case .italiano: return self == .mayor ? "maggiore" : "minore"
        case .aleman: return self == .mayor ? "Dur" : "Moll"
        case .griego: return self == .mayor ? "μείζονα" : "ελάσσονα"
        case .ruso: return self == .mayor ? "мажор" : "минор"
        case .asturiano, .aragones: return nombre
        }
    }
}

// MARK: - Tonalidad

extension Tonalidad {
    /// "La menor" en español, "A minor" en inglés, "a-Moll" en alemán (con la tónica en minúscula
    /// si es menor), "la mineur" en francés, "la minore" en italiano, "ля минор" en ruso, "λα ελάσσονα"
    /// en griego.
    public func nombre(en notacion: Notacion) -> String {
        guard notacion.idiomaDeLasNotas == .aleman else { return "\(tonica.nombre(en: notacion)) \(modo.nombre(en: notacion))" }
        let nombreTonica = tonica.nombre(en: .aleman)
        return (modo == .menor ? nombreTonica.lowercased() : nombreTonica) + "-" + modo.nombre(en: .aleman)
    }
}

extension Tonalidad {
    /// La tonalidad como lugar, en los idiomas de los textos: "en Do mayor", "in C major",
    /// "en do major", "en do maior", "em dó maior", "en do majeur", "in do maggiore", "in C-Dur",
    /// "σε ντο μείζονα", en ruso con el preposicional ("в до мажоре") y, en euskera, con el inesivo:
    /// "do maiorrean".
    package func lugar(en notacion: Notacion) -> String {
        let completo = self.nombre(en: notacion)
        switch notacion.textos {
        case .espanol, .catalan, .gallego, .asturiano, .aragones, .frances, .occitano: return "en " + completo
        case .portugues: return "em " + completo
        case .ingles, .italiano, .aleman: return "in " + completo
        case .griego: return "σε " + completo
        case .ruso:
            // En preposicional: "в до мажоре", "в ля миноре".
            let declinado = completo.hasSuffix("мажор") || completo.hasSuffix("минор") ? completo + "е" : completo
            return "в " + declinado
        case .euskera: return Tonalidad.declinar(completo, "ean")
        }
    }

    /// En euskera los nombres acaban en "maiorra" o "minorra": el caso sustituye a la "a" del artículo
    /// ("do maiorra" → "do maiorrean", "do maiorretik", "do maiorrera").
    package static func declinar(_ nombre: String, _ sufijo: String) -> String {
        nombre.hasSuffix("a") ? String(nombre.dropLast()) + sufijo : nombre + sufijo
    }
}
