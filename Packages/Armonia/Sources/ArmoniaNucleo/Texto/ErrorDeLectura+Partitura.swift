// Los mensajes de `ErrorDeLectura` al leer las duraciones, los compases, las voces y el contrapunto, en los catorce idiomas de los textos.
// El resto, en `ErrorDeLectura+Idiomas.swift`.

extension ErrorDeLectura {
    enum TextosDePartitura {
        static func duracionNoValida(_ texto: String) -> Traduccion {
            return TextosDeNucleo.traducidos.map { $0.duracionNoValida(texto) }
        }

        static func compasNoValido(_ texto: String) -> Traduccion {
            return TextosDeNucleo.traducidos.map { $0.compasNoValido(texto) }
        }

        static func vocesDistintas() -> Traduccion {
            return TextosDeNucleo.traducidos.map(\.vocesDistintas)
        }

        static func contrapuntoDeOtraDuracion(redondas: Int) -> Traduccion {
            return TextosDeNucleo.traducidos.map { $0.contrapuntoDeOtraDuracion(redondas) }
        }
    }
}
