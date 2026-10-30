import ArmoniaNucleo
// Nombres de los papeles en el acorde y de las calidades de tríada en los catorce idiomas de los textos (`Traduccion`). El resto de nombres que dependen del idioma, en `Fundamentos/Nota+Idiomas.swift` y `Fundamentos/Intervalo+Idiomas.swift`.

// MARK: - PapelEnAcorde

extension PapelEnAcorde {
    public var nombre: String { nombre(en: .espanolUnicode) }

    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .fundamental: return TextosDeTeoria.traducidos.map(\.papelFundamental)
        case .tercera: return TextosDeTeoria.traducidos.map(\.papelTercera)
        case .suspension: return TextosDeTeoria.traducidos.map(\.papelSuspension)
        case .quinta: return TextosDeTeoria.traducidos.map(\.papelQuinta)
        case .sexta: return TextosDeTeoria.traducidos.map(\.papelSexta)
        case .septima: return TextosDeTeoria.traducidos.map(\.papelSeptima)
        case .tension(9):
            return TextosDeTeoria.traducidos.map(\.papelNovena)
        case .tension(11):
            return TextosDeTeoria.traducidos.map(\.papelUndecima)
        case .tension(13):
            return TextosDeTeoria.traducidos.map(\.papelDecimotercera)
        case .tension(let n):
            return TextosDeTeoria.traducidos.map { $0.papelTension(n) }
        }
    }
}

// MARK: - CalidadDeTriada

extension CalidadDeTriada {
    public var nombre: String { nombre(en: .espanolUnicode) }

    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .mayor: return TextosDeTeoria.traducidos.map(\.triadaMayor)
        case .menor: return TextosDeTeoria.traducidos.map(\.triadaMenor)
        case .disminuida: return TextosDeTeoria.traducidos.map(\.triadaDisminuida)
        case .aumentada: return TextosDeTeoria.traducidos.map(\.triadaAumentada)
        case .suspendida: return TextosDeTeoria.traducidos.map(\.triadaSuspendida)
        case .potencia: return TextosDeTeoria.traducidos.map(\.triadaDeQuinta)
        case .sinTercera:
            return TextosDeTeoria.traducidos.map(\.triadaSinTercera)
        }
    }
}
