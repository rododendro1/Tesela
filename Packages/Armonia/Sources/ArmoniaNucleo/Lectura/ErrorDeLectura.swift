import Foundation

/// Error al leer una nota, una altura o un intervalo, o un texto vacío o con caracteres de más.
///
/// Indica el texto, el carácter donde se detuvo la lectura y el motivo, en los quince idiomas de los
/// textos (`Traduccion`). Los cifrados, las escalas y la partitura tienen el suyo en su capa
/// (`ErrorDeLecturaDeTeoria`, `ErrorDeLecturaDePartitura`); todos cumplen `ErrorAlLeer`:
///
///     do {
///         let altura = try Altura(leyendo: "Do#x")
///     } catch let error as ErrorDeLectura {
///         print(error)   // No se puede leer «Do#x» (carácter 3): …
///         error.descripcion(en: .inglesASCII)
///     }
public struct ErrorDeLectura: ErrorAlLeer {
    public enum Motivo: MotivoDeLectura {
        case textoVacio
        case notaNoReconocida
        case caracteresSobrantes(String)
        case octavaNoValida(String)
        case numeroDeIntervaloNoValido(String)
        case calidadNoValida(String)
        case intervaloInexistente(numero: Int, calidad: CalidadDeIntervalo)
        case alteracionNoReconocida(String)
    }

    public let texto: String
    public let posicion: Int?
    public let motivo: Motivo

    public init(texto: String, posicion: Int?, motivo: Motivo) {
        self.texto = texto
        self.posicion = posicion
        self.motivo = motivo
    }
}

// MARK: - Idiomas
//
// Los mensajes de `ErrorDeLectura` en los quince idiomas de los textos (`Traduccion`): los generales (texto vacío,
// caracteres que sobran) aquí, y los de las notas en TextosDeNotas, una función por motivo, para que un motivo nuevo
// no compile hasta que tiene su texto. Los de los acordes, las escalas y la partitura están en su capa
// (`ErrorDeLecturaDeTeoria`, `ErrorDeLecturaDePartitura`).

extension ErrorDeLectura.Motivo {
    public func explicacion(en notacion: Notacion) -> String {
        explicacionTraducida(notacion).en(notacion)
    }

    /// La explicación en los quince idiomas de los textos. La notación solo hace falta para los
    /// nombres de calidades e intervalos en inglés, que siguen su vocabulario.
    private func explicacionTraducida(_ notacion: Notacion) -> Traduccion {
        typealias TextosDeNotas = ErrorDeLectura.TextosDeNotas
        switch self {
        case .textoVacio:
            return TextosDeNucleo.traduccion(\.textoVacio)
        case .notaNoReconocida: return TextosDeNotas.notaNoReconocida()
        case .caracteresSobrantes(let resto):
            return TextosDeNucleo.traduccion { $0.caracteresSobrantes(resto) }
        case .octavaNoValida(let resto): return TextosDeNotas.octavaNoValida(resto)
        case .numeroDeIntervaloNoValido(let resto): return TextosDeNotas.numeroDeIntervaloNoValido(resto)
        case .calidadNoValida(let resto): return TextosDeNotas.calidadNoValida(resto)
        case .intervaloInexistente(let numero, let calidad):
            return TextosDeNotas.intervaloInexistente(numero: numero, calidad: calidad, en: notacion)
        case .alteracionNoReconocida(let signo): return TextosDeNotas.alteracionNoReconocida(signo)
        }
    }
}

// Los mensajes de `ErrorDeLectura` al leer las notas, las alteraciones, las octavas y los intervalos, en los quince idiomas de los textos.

extension ErrorDeLectura {
    enum TextosDeNotas {
        static func notaNoReconocida() -> Traduccion {
            return TextosDeNucleo.traduccion(\.notaNoReconocida)
        }

        static func octavaNoValida(_ resto: String) -> Traduccion {
            return resto.isEmpty
                ? TextosDeNucleo.traduccion(\.faltaLaOctava)
                : TextosDeNucleo.traduccion { $0.octavaNoValida(resto) }
        }

        static func numeroDeIntervaloNoValido(_ resto: String) -> Traduccion {
            return resto.isEmpty
                ? TextosDeNucleo.traduccion(\.faltaElNumeroDeIntervalo)
                : TextosDeNucleo.traduccion { $0.numeroDeIntervaloNoValido(resto) }
        }

        static func calidadNoValida(_ resto: String) -> Traduccion {
            return resto.isEmpty
                ? TextosDeNucleo.traduccion(\.faltaLaCalidad)
                : TextosDeNucleo.traduccion { $0.calidadNoValida(resto) }
        }

        static func intervaloInexistente(numero: Int, calidad: CalidadDeIntervalo, en notacion: Notacion) -> Traduccion
        {
            if numero == 1, case .disminuida = calidad {
                return TextosDeNucleo.traduccion(\.unisonoDisminuido)
            }
            let clase = (numero - 1) % 7
            let regla =
                [0, 3, 4].contains(clase)
                ? TextosDeNucleo.traduccion(\.reglaDeLasJustas)
                : TextosDeNucleo.traduccion(\.reglaDeLasMayores)
            return TextosDeNucleo.traduccion { $0.intervaloInexistente(numero, calidad, notacion, regla) }
        }

        static func alteracionNoReconocida(_ signo: String) -> Traduccion {
            return TextosDeNucleo.traduccion { $0.alteracionNoReconocida(signo) }
        }
    }
}
