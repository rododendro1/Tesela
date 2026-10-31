import Armonia
import ArmoniaPresentacion

// MARK: - Errores de uso de las digitaciones

extension ErrorDeUso {
    /// Los textos de los errores de las digitaciones, en los catorce idiomas.
    enum TextosDeTrastes {
        /// La orden de ejemplo de los mensajes: en español y en inglés.
        private static let digitaciones = (
            "armonia digitaciones Sol7/Si --instrumento ukelele", "armonia fingerings G7/B --instrument ukulele"
        )
        private static var d: String { digitaciones.0 }

        static func faltaInstrumento() -> Traduccion {
            return TextosDeCLI.traduccion { $0.faltaInstrumento(d, digitaciones) }
        }

        static func instrumentoDesconocido(_ nombre: String) -> Traduccion {
            // Los nombres conocidos, en el idioma del mensaje (se aceptan en cualquiera de los catorce).
            let conocidos = Encordado.todos.map { Mensaje.instrumento($0).traduccion }
            let lista = { (idioma: Notacion) in conocidos.map { $0.en(idioma) }.joined(separator: ", ") }
            return TextosDeCLI.traduccion { $0.instrumentoDesconocido(nombre, lista) }
        }

        static func faltaLimite() -> Traduccion {
            return TextosDeCLI.traduccion(\.faltaLimite)
        }

        static func limiteFueraDeRango() -> Traduccion {
            return TextosDeCLI.traduccion(\.limiteFueraDeRango)
        }

        static func faltanDedos() -> Traduccion {
            return TextosDeCLI.traduccion(\.faltanDedos)
        }

        static func dedosFueraDeRango() -> Traduccion {
            return TextosDeCLI.traduccion(\.dedosFueraDeRango)
        }

        static func faltaTraste() -> Traduccion {
            return TextosDeCLI.traduccion(\.faltaTraste)
        }

        static func trasteFueraDeRango() -> Traduccion {
            return TextosDeCLI.traduccion(\.trasteFueraDeRango)
        }

        static func faltaCifradoDeDigitaciones() -> Traduccion {
            return TextosDeCLI.traduccion { $0.faltaCifradoDeDigitaciones(d, digitaciones) }
        }

        static func faltaEscalaDePosiciones() -> Traduccion {
            return TextosDeCLI.traduccion(\.faltaEscalaDePosiciones)
        }

        static func capoFueraDeRango() -> Traduccion {
            return TextosDeCLI.traduccion(\.capoFueraDeRango)
        }
    }
}
