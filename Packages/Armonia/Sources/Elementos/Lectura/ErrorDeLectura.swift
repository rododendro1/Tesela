import Foundation

/// Error al leer una nota, una altura, un intervalo, un conjunto de clases, una serie dodecafónica o un idioma, o un
/// texto vacío o con caracteres de más.
///
/// Indica el texto, el carácter donde se detuvo la lectura y el motivo, en los trece idiomas de los
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
    /// Por qué no se pudo leer, con lo que hace falta para explicarlo en cada idioma (`explicacion(en:)`).
    public enum Motivo: MotivoDeLectura {
        case textoVacio
        case notaNoReconocida
        case caracteresSobrantes(String)
        case octavaNoValida(String)
        case numeroDeIntervaloNoValido(String)
        case calidadNoValida(String)
        case intervaloInexistente(numero: Int, calidad: CalidadDeIntervalo)
        case alteracionNoReconocida(String)
        /// Ni una clase de altura (0…11, `t`, `e`) ni un nombre de nota, o clases y notas mezcladas.
        case claseDeAlturaNoValida(String)
        /// Un número con la forma de los de Forte («3-13») que no está en la tabla.
        case numeroDeForteDesconocido(String)
        /// Se abrió un corchete, una llave o un paréntesis y no se cerró.
        case faltaElCierre(String)
        /// Una serie que no tiene las doce clases una vez cada una: las que faltan y las que se repiten.
        case serieNoDodecafonica(faltan: [Int], repetidas: [Int])
        /// Ni el código ni el nombre de uno de los trece idiomas, con los códigos que sí.
        case idiomaNoReconocido(String, opciones: [String])
    }

    public let texto: String
    public let posicion: Int?
    public let motivo: Motivo

    /// El error de leer `texto`, detenido en el carácter `posicion` (desde 0; `nil` si no es en un punto).
    public init(texto: String, posicion: Int?, motivo: Motivo) {
        self.texto = texto
        self.posicion = posicion
        self.motivo = motivo
    }
}

// MARK: - Idiomas
//
// Los mensajes de `ErrorDeLectura` en los trece idiomas de los textos (`Traduccion`): los generales (texto vacío,
// caracteres que sobran) aquí, y los de las notas en TextosDeNotas, una función por motivo, para que un motivo nuevo
// no compile hasta que tiene su texto. Los de los acordes, las escalas y la partitura están en su capa
// (`ErrorDeLecturaDeTeoria`, `ErrorDeLecturaDePartitura`).

extension ErrorDeLectura.Motivo {
    public func explicacion(en notacion: Notacion) -> String {
        explicacionTraducida(notacion).en(notacion)
    }

    /// La explicación en los trece idiomas de los textos. La notación solo hace falta para los
    /// nombres de calidades e intervalos en inglés, que siguen su vocabulario.
    private func explicacionTraducida(_ notacion: Notacion) -> Traduccion {
        typealias TextosDeNotas = ErrorDeLectura.TextosDeNotas
        switch self {
        case .textoVacio:
            return TextosDeElementos.traduccion(\.textoVacio)
        case .notaNoReconocida: return TextosDeNotas.notaNoReconocida()
        case .caracteresSobrantes(let resto):
            return TextosDeElementos.traduccion { $0.caracteresSobrantes(resto) }
        case .octavaNoValida(let resto): return TextosDeNotas.octavaNoValida(resto)
        case .numeroDeIntervaloNoValido(let resto): return TextosDeNotas.numeroDeIntervaloNoValido(resto)
        case .calidadNoValida(let resto): return TextosDeNotas.calidadNoValida(resto)
        case .intervaloInexistente(let numero, let calidad):
            return TextosDeNotas.intervaloInexistente(numero: numero, calidad: calidad, en: notacion)
        case .alteracionNoReconocida(let signo): return TextosDeNotas.alteracionNoReconocida(signo)
        case .claseDeAlturaNoValida(let texto): return TextosDeElementos.traduccion { $0.claseDeAlturaNoValida(texto) }
        case .numeroDeForteDesconocido(let texto):
            return TextosDeElementos.traduccion { $0.numeroDeForteDesconocido(texto) }
        case .faltaElCierre(let signo): return TextosDeElementos.traduccion { $0.faltaElCierre(signo) }
        case .serieNoDodecafonica(let faltan, let repetidas):
            func lista(_ clases: [Int]) -> String { clases.map(String.init).joined(separator: ", ") }
            return TextosDeElementos.traduccion { textos in
                let partes =
                    (faltan.isEmpty ? [] : [textos.faltanEnLaSerie(lista(faltan))])
                    + (repetidas.isEmpty ? [] : [textos.repetidasEnLaSerie(lista(repetidas))])
                return partes.isEmpty
                    ? textos.serieNoDodecafonica
                    : textos.serieNoDodecafonica + textos.dosPuntos + partes.joined(separator: "; ")
            }
        case .idiomaNoReconocido(let nombre, let opciones):
            return TextosDeElementos.traduccion { $0.idiomaNoReconocido(nombre, opciones.joined(separator: ", ")) }
        }
    }
}

// Los mensajes de `ErrorDeLectura` al leer las notas, las alteraciones, las octavas y los intervalos, en los trece idiomas de los textos.

extension ErrorDeLectura {
    enum TextosDeNotas {
        static func notaNoReconocida() -> Traduccion {
            return TextosDeElementos.traduccion(\.notaNoReconocida)
        }

        static func octavaNoValida(_ resto: String) -> Traduccion {
            return resto.isEmpty
                ? TextosDeElementos.traduccion(\.faltaLaOctava)
                : TextosDeElementos.traduccion { $0.octavaNoValida(resto) }
        }

        static func numeroDeIntervaloNoValido(_ resto: String) -> Traduccion {
            return resto.isEmpty
                ? TextosDeElementos.traduccion(\.faltaElNumeroDeIntervalo)
                : TextosDeElementos.traduccion { $0.numeroDeIntervaloNoValido(resto) }
        }

        static func calidadNoValida(_ resto: String) -> Traduccion {
            return resto.isEmpty
                ? TextosDeElementos.traduccion(\.faltaLaCalidad)
                : TextosDeElementos.traduccion { $0.calidadNoValida(resto) }
        }

        static func intervaloInexistente(numero: Int, calidad: CalidadDeIntervalo, en notacion: Notacion) -> Traduccion
        {
            if numero == 1, case .disminuida = calidad {
                return TextosDeElementos.traduccion(\.unisonoDisminuido)
            }
            let clase = (numero - 1) % 7
            let regla =
                [0, 3, 4].contains(clase)
                ? TextosDeElementos.traduccion(\.reglaDeLasJustas)
                : TextosDeElementos.traduccion(\.reglaDeLasMayores)
            return TextosDeElementos.traduccion { $0.intervaloInexistente(numero, calidad, notacion, regla) }
        }

        static func alteracionNoReconocida(_ signo: String) -> Traduccion {
            return TextosDeElementos.traduccion { $0.alteracionNoReconocida(signo) }
        }
    }
}
