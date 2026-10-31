import Armonia
import ArmoniaPresentacion

// MARK: - Errores de uso de las partituras (`orden` es «musicxml», «mei» o «midi»)

extension ErrorDeUso {
    /// Los textos de los errores de las partituras, en los catorce idiomas.
    enum TextosDePartituras {
        static func faltaTipoDePartitura(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4"
            return TextosDeCLI.traduccion { $0.faltaTipoDePartitura(ejemplo, orden) }
        }

        static func instrumentoMIDI() -> Traduccion {
            return TextosDeCLI.traduccion(\.instrumentoMIDI)
        }

        static func marcasSoloMusicXML() -> Traduccion {
            return TextosDeCLI.traduccion(\.marcasSoloMusicXML)
        }

        static func faltaValor(_ opcion: String) -> Traduccion {
            return TextosDeCLI.traduccion { $0.faltaValor(opcion) }
        }

        static func tempoMalEscrito() -> Traduccion {
            return TextosDeCLI.traduccion(\.tempoMalEscrito)
        }

        static func faltanNotasDeLaMelodia(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4"
            return TextosDeCLI.traduccion { $0.faltanNotasDeLaMelodia(ejemplo, orden) }
        }

        static func marcasSoloCoral() -> Traduccion {
            return TextosDeCLI.traduccion(\.marcasSoloCoral)
        }

        static func duracionSoloCoral() -> Traduccion {
            return TextosDeCLI.traduccion(\.duracionSoloCoral)
        }

        static func claveDesconocida(_ clave: String) -> Traduccion {
            let claves = "(sol, fa, do1, do2, do3, do4, sol8b, sol8a, fa3)"
            return TextosDeCLI.traduccion { $0.claveDesconocida(clave, claves) }
        }

        static func faltanAcordesDelCoral(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4"
            return TextosDeCLI.traduccion { $0.faltanAcordesDelCoral(ejemplo, orden) }
        }

        static func soloParaMelodia(_ opcion: String) -> Traduccion {
            return TextosDeCLI.traduccion { $0.soloParaMelodia(opcion) }
        }

        static func soloParaArpegios(_ opcion: String) -> Traduccion {
            return TextosDeCLI.traduccion { $0.soloParaArpegios(opcion) }
        }

        static func archivoSoloParaAcordes() -> Traduccion {
            return TextosDeCLI.traduccion(\.archivoSoloParaAcordes)
        }

        static func ventanaSinArchivo() -> Traduccion {
            return TextosDeCLI.traduccion(\.ventanaSinArchivo)
        }

        static func faltanAcordesDeLaProgresion(orden: String) -> Traduccion {
            let ejemplo = "armonia \(orden) acordes Do Lam Re7 Sol7 Do"
            return TextosDeCLI.traduccion { $0.faltanAcordesDeLaProgresion(ejemplo, orden) }
        }

        static func acordesConCifradosYAnalisis() -> Traduccion {
            return TextosDeCLI.traduccion(\.acordesConCifradosYAnalisis)
        }

        static func tipoDePartituraDesconocido(_ tipo: String) -> Traduccion {
            return TextosDeCLI.traduccion { $0.tipoDePartituraDesconocido(tipo) }
        }
    }
}
