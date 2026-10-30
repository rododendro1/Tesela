import Armonia
import ArmoniaPresentacion

// MARK: - Errores de uso de las consultas: acordes, notas, escalas, tonalidades y análisis

extension ErrorDeUso {
    /// Los textos de los errores de las consultas: acordes, notas, escalas, tonalidades y análisis, en los catorce idiomas.
    enum TextosDeConsultas {
        static func faltaCifrado() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.faltaCifrado)
        }

        static func faltaCifradoDelArpegio() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.faltaCifradoDelArpegio)
        }

        static func patronDesconocido(_ patron: String) -> Traduccion {
            return TextosDeCLI.traducidos.map { $0.patronDesconocido(patron) }
        }

        static func faltanNotas() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.faltanNotas)
        }

        static func dosNotas() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.dosNotas)
        }

        static func faltaEscala() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.faltaEscala)
        }

        static func faltaTonalidad() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.faltaTonalidad)
        }

        static func faltaTonalidadTrasEn() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.faltaTonalidadTrasEn)
        }

        static func faltanAcordesDelAnalisis() -> Traduccion {
            let ejemplo = "armonia analizar Do Fa Sol7 Do"
            return TextosDeCLI.traducidos.map { $0.faltanAcordesDelAnalisis(ejemplo) }
        }

        static func archivoIlegible(_ nombre: String) -> Traduccion {
            return TextosDeCLI.traducidos.map { $0.archivoIlegible(nombre) }
        }

        static func archivoConAcordes() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.archivoConAcordes)
        }

        static func archivoSinAcordes() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.archivoSinAcordes)
        }
    }
}
