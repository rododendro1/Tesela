// Los mensajes de `ErrorDeLectura` al leer los cifrados de los acordes, en los catorce idiomas de los textos.
// El resto, en `ErrorDeLectura+Idiomas.swift`.

extension ErrorDeLectura {
    enum TextosDeAcordes {
        static func simboloNoReconocido(_ simbolo: String) -> Traduccion {
            return TextosDeNucleo.traducidos.map { $0.simboloNoReconocido(simbolo) }
        }

        static func tensionNoValida(_ tension: String) -> Traduccion {
            return TextosDeNucleo.traducidos.map { $0.tensionNoValida(tension) }
        }

        static func numeroDeAcordeNoValido(_ numero: Int) -> Traduccion {
            return TextosDeNucleo.traducidos.map { $0.numeroDeAcordeNoValido(numero) }
        }

        static func numeroRepetido(_ numero: Int) -> Traduccion {
            return TextosDeNucleo.traducidos.map { $0.numeroRepetido(numero) }
        }

        static func calidadesIncompatibles(_ valor: CalidadesIncompatibles) -> Traduccion {
            switch valor {
            case .disminuidoYSemidisminuido:
                return TextosDeNucleo.traducidos.map(\.disminuidoYSemidisminuido)
            case .quintaConCalidad:
                return TextosDeNucleo.traducidos.map(\.quintaConCalidad)
            }
        }

        static func gradoNoOmitible(_ grado: Int) -> Traduccion {
            return grado == 1
                ? TextosDeNucleo.traducidos.map(\.fundamentalNoOmitible)
                : TextosDeNucleo.traducidos.map { $0.gradoNoOmitible(grado) }
        }

        static func acordeNoInterpretable(_ rechazo: RechazoDeAcorde, en notacion: Notacion) -> Traduccion {
            switch rechazo {
            case .faltaLaFundamental:
                return TextosDeNucleo.traducidos.map(\.faltaLaFundamental)
            case .intervaloSinPapel(let intervalo):
                return TextosDeNucleo.traducidos.map { $0.intervaloSinPapel(intervalo, notacion) }
            case .terceraMayorYMenor:
                return TextosDeNucleo.traducidos.map(\.terceraMayorYMenor)
            case .variasSeptimas:
                return TextosDeNucleo.traducidos.map(\.variasSeptimas)
            case .septimaDisminuidaFueraDelDisminuido:
                return TextosDeNucleo.traducidos.map(\.septimaDisminuidaFueraDelDisminuido)
            case .noEsPorTerceras:
                return TextosDeNucleo.traducidos.map(\.noEsPorTerceras)
            }
        }

        static func bajoNoValido(_ bajo: String) -> Traduccion {
            return TextosDeNucleo.traducidos.map { $0.bajoNoValido(bajo) }
        }

        static func idiomasMezclados(_ nombre: String) -> Traduccion {
            return TextosDeNucleo.traducidos.map { $0.idiomasMezclados(nombre) }
        }
    }
}
