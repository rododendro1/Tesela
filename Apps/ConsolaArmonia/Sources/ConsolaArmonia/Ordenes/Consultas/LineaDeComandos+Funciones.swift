import Armonia
import Exposicion

// MARK: - Consultas: el catálogo de funciones de nota

extension LineaDeComandos {
    /// Los valores de `funciones --familia`, en español y en inglés.
    static let nombresDeLasFamiliasDeFuncion: [(familia: FamiliaDeFuncionDeNota, espanol: String, ingles: String)] = [
        (.grado, "grado", "degree"), (.gregoriana, "gregoriana", "gregorian"), (.india, "india", "indian"),
        (.maqam, "maqam", "maqam"), (.blues, "blues", "blues"), (.adorno, "adorno", "ornament"),
        (.notaExtrana, "nota-extrana", "nonchord-tone"),
    ]

    /// Las funciones que pide `funciones [<texto>] [--familia <familia>] [--estadisticas]` y si se quiere su ficha.
    /// Con un nombre exacto, solo esa; si no, las que lo contienen (todas, sin texto), de la familia de `--familia`.
    static func funcionesPedidas(_ textos: [String], _ notacion: Notacion) throws -> (
        funciones: [FuncionDeNota], ficha: Bool
    ) {
        var argumentos = Argumentos(textos)
        var familia: FamiliaDeFuncionDeNota?
        if let texto = try argumentos.valorConPalabras(.familia) {
            let clave = claveDeBusqueda(texto)
            let hallada = nombresDeLasFamiliasDeFuncion.first { fila in
                [fila.espanol, fila.ingles, fila.familia.nombre(en: notacion)].map(claveDeBusqueda).contains(clave)
            }
            guard let elegida = hallada?.familia else { throw ErrorDeUso.familiaDeFuncionDesconocida(texto) }
            familia = elegida
        }
        let ficha = argumentos.quitarMarca(.estadisticas)
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        let halladas = FuncionDeNota.buscar(nombre: texto).map { [$0] } ?? FuncionDeNota.buscar(conteniendo: texto)
        return (halladas.filter { familia == nil || $0.familia == familia }, ficha)
    }

    /// `funciones [<texto>] [opciones]`: cada función del catálogo, o las que tienen el texto en el nombre o en un
    /// alias en algún idioma, con su familia y, si lo tiene, su intervalo desde la tónica. Con `--estadisticas`,
    /// debajo de cada una, su ficha.
    ///
    ///     dominante: grados de la escala · 5J
    static func funciones(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (halladas, ficha) = try funcionesPedidas(textos, notacion)
        guard !halladas.isEmpty else {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + Mensaje.ningunaFuncion.texto(en: notacion) + "\n", codigo: 1)
        }
        let lineas = halladas.flatMap { funcion -> [String] in
            let presentada = FuncionDeNotaPresentada(funcion, en: notacion)
            let linea =
                presentada.nombre + ": "
                + ([presentada.familia] + [presentada.intervalo].compactMap { $0 })
                .joined(separator: " · ")
            guard ficha else { return [linea] }
            return [linea] + presentada.ficha(en: notacion).map { "  " + $0.nombre + ": " + $0.valor }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// `funciones [<texto>] [opciones] --json`: las mismas funciones, con toda su ficha.
    static func funcionesJSON(_ textos: [String], _ notacion: Notacion) throws -> [FuncionDeNotaPresentada] {
        try funcionesPedidas(textos, notacion).funciones.map { FuncionDeNotaPresentada($0, en: notacion) }
    }
}
