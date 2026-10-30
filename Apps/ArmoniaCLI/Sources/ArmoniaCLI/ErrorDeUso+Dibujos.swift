import Armonia
import ArmoniaPresentacion

// MARK: - Errores de uso de los dibujos (`orden` es «tonnetz» o «tabla»)

extension ErrorDeUso {
    /// Los textos de los errores de los dibujos, en los catorce idiomas.
    enum TextosDeDibujos {
        static func margenFueraDeRango() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.margenFueraDeRango)
        }

        static func faltanNotasDelDibujo(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) Do Mi Sol"
            return TextosDeCLI.traducidos.map { $0.faltanNotasDelDibujo(ejemplo, orden) }
        }

        static func faltaAcordeDelDibujo(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) --acorde Sol7"
            return TextosDeCLI.traducidos.map { $0.faltaAcordeDelDibujo(ejemplo, orden) }
        }

        static func faltaEscalaDelDibujo(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) --escala Re dórico"
            return TextosDeCLI.traducidos.map { $0.faltaEscalaDelDibujo(ejemplo, orden) }
        }

        static func clasesFueraDeRango(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) --clases 0 4 7"
            return TextosDeCLI.traducidos.map { $0.clasesFueraDeRango(ejemplo, orden) }
        }

        static func faltanTriadasDelRecorrido(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) --recorrido Do Lam Fa Rem"
            return TextosDeCLI.traducidos.map { $0.faltanTriadasDelRecorrido(ejemplo, orden) }
        }

        static func cicloMalEscrito(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) --ciclo hexatonico Do"
            return TextosDeCLI.traducidos.map { $0.cicloMalEscrito(ejemplo, orden) }
        }

        static func recorridoSoloTriadas(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) --recorrido Do Lam Fa Rem"
            return TextosDeCLI.traducidos.map { $0.recorridoSoloTriadas(ejemplo, orden) }
        }

        static func caminoSoloTriadas(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) --camino Do Mibm"
            return TextosDeCLI.traducidos.map { $0.caminoSoloTriadas(ejemplo, orden) }
        }

        static func cicloSoloTriadas(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) --ciclo hexatonico Do"
            return TextosDeCLI.traducidos.map { $0.cicloSoloTriadas(ejemplo, orden) }
        }
    }
}
