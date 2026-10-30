// Los mensajes de `ErrorDeLectura` al leer las escalas y los modos, en los catorce idiomas de los textos.
// El resto, en `ErrorDeLectura+Idiomas.swift`.

extension ErrorDeLectura {
    enum TextosDeEscalas {
        static func modoNoReconocido(_ nombre: String) -> Traduccion {
            return TextosDeNucleo.traducidos.map { $0.modoNoReconocido(nombre) }
        }

        static func tipoDeEscalaNoReconocido(_ nombre: String) -> Traduccion {
            return nombre.isEmpty
                ? TextosDeNucleo.traducidos.map(\.faltaElTipoDeEscala)
                : TextosDeNucleo.traducidos.map { $0.tipoDeEscalaNoReconocido(nombre) }
        }
    }
}
