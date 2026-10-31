import Armonia
import ArmoniaPresentacion

// MARK: - Errores de uso de las consultas: acordes, notas, escalas, tonalidades y análisis

extension ErrorDeUso {
    /// Los textos de los errores de las consultas: acordes, notas, escalas, tonalidades y análisis, en los catorce idiomas.
    enum TextosDeConsultas {
        static func faltaCifrado() -> Traduccion {
            return TextosDeCLI.traduccion(\.faltaCifrado)
        }

        static func faltaCifradoDelArpegio() -> Traduccion {
            return TextosDeCLI.traduccion(\.faltaCifradoDelArpegio)
        }

        static func patronDesconocido(_ patron: String) -> Traduccion {
            return TextosDeCLI.traduccion { $0.patronDesconocido(patron) }
        }

        static func faltanNotas() -> Traduccion {
            return TextosDeCLI.traduccion(\.faltanNotas)
        }

        static func dosNotas() -> Traduccion {
            return TextosDeCLI.traduccion(\.dosNotas)
        }

        static func faltaEscala() -> Traduccion {
            return TextosDeCLI.traduccion(\.faltaEscala)
        }

        static func faltaTonalidad() -> Traduccion {
            return TextosDeCLI.traduccion(\.faltaTonalidad)
        }

        static func faltaTonalidadTrasEn() -> Traduccion {
            return TextosDeCLI.traduccion(\.faltaTonalidadTrasEn)
        }

        static func faltanAcordesDelAnalisis() -> Traduccion {
            let ejemplo = "armonia analizar Do Fa Sol7 Do"
            return TextosDeCLI.traduccion { $0.faltanAcordesDelAnalisis(ejemplo) }
        }

        static func archivoIlegible(_ nombre: String) -> Traduccion {
            return TextosDeCLI.traduccion { $0.archivoIlegible(nombre) }
        }

        static func archivoConAcordes() -> Traduccion {
            return TextosDeCLI.traduccion(\.archivoConAcordes)
        }

        static func archivoSinAcordes() -> Traduccion {
            return TextosDeCLI.traduccion(\.archivoSinAcordes)
        }

        static func faltaTransporte() -> Traduccion {
            let ejemplo = "armonia transponer 2M Do Lam Fa Sol7"
            return TextosDeCLI.traduccion { $0.faltaTransporte(ejemplo) }
        }

        static func faltanAcordesDeLaRearmonizacion() -> Traduccion {
            let ejemplo = "armonia rearmonizar Do Lam Rem7 Sol7"
            return TextosDeCLI.traduccion { $0.faltanAcordesDeLaRearmonizacion(ejemplo) }
        }
    }
}
