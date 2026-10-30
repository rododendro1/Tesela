import Armonia
import ArmoniaPresentacion

// MARK: - Errores de uso de las órdenes neorriemannianas

extension ErrorDeUso {
    /// Los textos de los errores de las órdenes neorriemannianas, en los catorce idiomas.
    enum TextosDeNeorriemann {
        static func vocesFueraDeRango() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.vocesFueraDeRango)
        }

        static func unAcordeDeVecinos() -> Traduccion {
            let ejemplo = "armonia vecinos Sol7"
            return TextosDeCLI.traducidos.map { $0.unAcordeDeVecinos(ejemplo) }
        }

        static func vecinosSinFamilia() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.vecinosSinFamilia)
        }

        static func dosAcordesDeCamino() -> Traduccion {
            let ejemplo = "armonia conduccion-parsimoniosa Sol7 Rem7"
            return TextosDeCLI.traducidos.map { $0.dosAcordesDeCamino(ejemplo) }
        }

        static func caminoSinConexion() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.caminoSinConexion)
        }

        static func faltanPasosDePLR() -> Traduccion {
            let ejemplo = "armonia plr Do PLR"
            return TextosDeCLI.traducidos.map { $0.faltanPasosDePLR(ejemplo) }
        }

        static func plrSoloTriadas(camino: Bool) -> Traduccion {
            let ejemplo = "armonia plr " + (camino ? "Do Mibm" : "Do PLR")
            return TextosDeCLI.traducidos.map { $0.plrSoloTriadas(ejemplo, camino) }
        }
    }
}
