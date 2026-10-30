// Los mensajes de `ErrorDeLectura` al leer las notas, las alteraciones, las octavas y los intervalos, en los catorce idiomas de los textos.
// El resto, en `ErrorDeLectura+Idiomas.swift`.

extension ErrorDeLectura {
    enum TextosDeNotas {
        static func notaNoReconocida() -> Traduccion {
            return TextosDeNucleo.traducidos.map(\.notaNoReconocida)
        }

        static func octavaNoValida(_ resto: String) -> Traduccion {
            return resto.isEmpty
                ? TextosDeNucleo.traducidos.map(\.faltaLaOctava)
                : TextosDeNucleo.traducidos.map { $0.octavaNoValida(resto) }
        }

        static func numeroDeIntervaloNoValido(_ resto: String) -> Traduccion {
            return resto.isEmpty
                ? TextosDeNucleo.traducidos.map(\.faltaElNumeroDeIntervalo)
                : TextosDeNucleo.traducidos.map { $0.numeroDeIntervaloNoValido(resto) }
        }

        static func calidadNoValida(_ resto: String) -> Traduccion {
            return resto.isEmpty
                ? TextosDeNucleo.traducidos.map(\.faltaLaCalidad)
                : TextosDeNucleo.traducidos.map { $0.calidadNoValida(resto) }
        }

        static func intervaloInexistente(numero: Int, calidad: CalidadDeIntervalo, en notacion: Notacion) -> Traduccion {
            if numero == 1, case .disminuida = calidad {
                return TextosDeNucleo.traducidos.map(\.unisonoDisminuido)
            }
            let clase = (numero - 1) % 7
            let regla = [0, 3, 4].contains(clase)
                ? TextosDeNucleo.traducidos.map(\.reglaDeLasJustas)
                : TextosDeNucleo.traducidos.map(\.reglaDeLasMayores)
            return TextosDeNucleo.traducidos.map { $0.intervaloInexistente(numero, calidad, notacion, regla) }
        }

        static func alteracionNoReconocida(_ signo: String) -> Traduccion {
            return TextosDeNucleo.traducidos.map { $0.alteracionNoReconocida(signo) }
        }
    }
}
