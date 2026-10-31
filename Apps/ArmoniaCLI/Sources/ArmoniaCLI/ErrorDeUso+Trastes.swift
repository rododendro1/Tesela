import Armonia
import ArmoniaPresentacion

// MARK: - Errores de uso de las digitaciones

extension ErrorDeUso {
    /// Los textos de los errores de las digitaciones, en los catorce idiomas.
    enum TextosDeTrastes {
        /// La orden de ejemplo de los mensajes: en español y en inglés.
        private static let digitaciones = ("armonia digitaciones Sol7/Si --instrumento ukelele", "armonia fingerings G7/B --instrument ukulele")
        private static var d: String { digitaciones.0 }

        static func faltaInstrumento() -> Traduccion {
            return TextosDeCLI.traducidos.map { $0.faltaInstrumento(d, digitaciones) }
        }

        static func instrumentoDesconocido(_ nombre: String) -> Traduccion {
            // Los nombres conocidos, en el idioma del mensaje (se aceptan en cualquiera de los catorce).
            let conocidos = Encordado.todos.map { Mensaje.instrumento($0).traduccion }
            let lista = { (idioma: Notacion) in conocidos.map { $0.en(idioma) }.joined(separator: ", ") }
            return TextosDeCLI.traducidos.map { $0.instrumentoDesconocido(nombre, lista) }
        }

        static func faltaLimite() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.faltaLimite)
        }

        static func limiteFueraDeRango() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.limiteFueraDeRango)
        }

        static func faltanDedos() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.faltanDedos)
        }

        static func dedosFueraDeRango() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.dedosFueraDeRango)
        }

        static func faltaTraste() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.faltaTraste)
        }

        static func trasteFueraDeRango() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.trasteFueraDeRango)
        }

        static func faltaCifradoDeDigitaciones() -> Traduccion {
            return TextosDeCLI.traducidos.map { $0.faltaCifradoDeDigitaciones(d, digitaciones) }
        }

        static func faltaEscalaDePosiciones() -> Traduccion {
            return TextosDeCLI.traducidos.map(\.faltaEscalaDePosiciones)
        }
    }
}
