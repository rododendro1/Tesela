import ArmoniaNucleo
// Nombres de los grados de la escala en los catorce idiomas de los textos (`Traduccion`). El resto de nombres que dependen del idioma, en `Fundamentos/Nota+Idiomas.swift` y `Fundamentos/Intervalo+Idiomas.swift`.

// MARK: - NombreDeGrado

extension NombreDeGrado {
    public var nombre: String { nombre(en: .espanolUnicode) }

    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .tonica: return TextosDeTeoria.traducidos.map(\.gradoTonica)
        case .supertonica: return TextosDeTeoria.traducidos.map(\.gradoSupertonica)
        case .mediante: return TextosDeTeoria.traducidos.map(\.gradoMediante)
        case .subdominante:
            return TextosDeTeoria.traducidos.map(\.gradoSubdominante)
        case .dominante: return TextosDeTeoria.traducidos.map(\.gradoDominante)
        case .superdominante:
            return TextosDeTeoria.traducidos.map(\.gradoSuperdominante)
        case .sensible: return TextosDeTeoria.traducidos.map(\.gradoSensible)
        case .subtonica: return TextosDeTeoria.traducidos.map(\.gradoSubtonica)
        }
    }
}
