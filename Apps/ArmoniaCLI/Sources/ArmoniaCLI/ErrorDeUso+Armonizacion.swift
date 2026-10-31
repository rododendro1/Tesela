import Armonia
import ArmoniaPresentacion

// MARK: - Errores de uso de la conducción de voces, la armonización, la realización y el contrapunto

extension ErrorDeUso {
    /// Los textos de los errores de la conducción de voces, la armonización, la realización y el contrapunto, en los catorce idiomas.
    enum TextosDeArmonizacion {
        static func faltanAcordesDeLasVoces() -> Traduccion {
            let ejemplo = "armonia revisar Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4"
            return TextosDeCLI.traduccion { $0.faltanAcordesDeLasVoces(ejemplo) }
        }

        static func dosAcordesDeConduccion() -> Traduccion {
            let ejemplo = "armonia conduccion-minima Sol7 Do"
            return TextosDeCLI.traduccion { $0.dosAcordesDeConduccion(ejemplo) }
        }

        static func faltanNotasDeLaArmonizacion() -> Traduccion {
            let ejemplo = "armonia armonizar Mi4 Re4 Do4"
            return TextosDeCLI.traduccion { $0.faltanNotasDeLaArmonizacion(ejemplo) }
        }

        static func propuestasFueraDeRango() -> Traduccion {
            return TextosDeCLI.traduccion(\.propuestasFueraDeRango)
        }

        static func faltanVocesDelContrapunto() -> Traduccion {
            let ejemplo = "armonia contrapunto Re4 Fa4 Mi4 Re4 / La4 La4 Do#5 Re5"
            let ingles = "armonia counterpoint D4 F4 E4 D4 / A4 A4 C#5 D5"
            return TextosDeCLI.traduccion { $0.faltanVocesDelContrapunto(ejemplo, ingles) }
        }

        static func especieFueraDeRango() -> Traduccion {
            return TextosDeCLI.traduccion(\.especieFueraDeRango)
        }

        static func faltanAcordesDeLaRealizacion() -> Traduccion {
            let ejemplo = "armonia realizar Do Fa Sol7 Do"
            return TextosDeCLI.traduccion { $0.faltanAcordesDeLaRealizacion(ejemplo) }
        }
    }
}
