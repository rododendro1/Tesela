import Armonia
import Exposicion

// MARK: - Consultas: el catálogo de notas

extension LineaDeComandos {
    /// Los valores de `notas --familia`, en español y en inglés.
    static let nombresDeLasFamiliasDeNota: [(familia: FamiliaDeNota, espanol: String, ingles: String)] = [
        (.diapason, "diapason", "pitch-standard"), (.referencia, "referencia", "reference"),
        (.guidoniana, "guidoniana", "guidonian"), (.arabe, "arabe", "arabic"), (.turca, "turca", "turkish"),
        (.griega, "griega", "greek"),
    ]

    /// Las notas que pide `notas [<texto>] [--familia <familia>] [--estadisticas]` y si se quiere su ficha. Con un
    /// nombre exacto, solo esa; si no, las que lo contienen (todas, sin texto), de la familia de `--familia`.
    static func notasPedidas(_ textos: [String], _ notacion: Notacion) throws -> (
        notas: [NotaConNombre], ficha: Bool
    ) {
        var argumentos = Argumentos(textos)
        var familia: FamiliaDeNota?
        if let texto = try argumentos.valorConPalabras(.familia) {
            let clave = claveDeBusqueda(texto)
            let hallada = nombresDeLasFamiliasDeNota.first { fila in
                [fila.espanol, fila.ingles, fila.familia.nombre(en: notacion)].map(claveDeBusqueda).contains(clave)
            }
            guard let elegida = hallada?.familia else { throw ErrorDeUso.familiaDeNotaDesconocida(texto) }
            familia = elegida
        }
        let ficha = argumentos.quitarMarca(.estadisticas)
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        let halladas = NotaConNombre.buscar(nombre: texto).map { [$0] } ?? NotaConNombre.buscar(conteniendo: texto)
        return (halladas.filter { familia == nil || $0.familia == familia }, ficha)
    }

    /// `notas [<texto>] [opciones]`: cada nota del catálogo, o las que tienen el texto en el nombre o en un alias en
    /// algún idioma, con su altura y su frecuencia. Con `--estadisticas`, debajo de cada una, su ficha.
    ///
    ///     La 415: La₄ · 415 Hz
    static func notas(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (halladas, ficha) = try notasPedidas(textos, notacion)
        guard !halladas.isEmpty else {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + Mensaje.ningunaNota.texto(en: notacion) + "\n", codigo: 1)
        }
        let lineas = halladas.flatMap { nota -> [String] in
            let presentada = NotaPresentada(nota, en: notacion)
            let datos = presentada.ficha(en: notacion)
            let hercios = datos.first { $0.nombre == notacion.texto(\.frecuenciaDeLaNota) }?.valor ?? ""
            let linea = presentada.nombre + ": " + presentada.altura + " · " + hercios
            guard ficha else { return [linea] }
            return [linea] + datos.map { "  " + $0.nombre + ": " + $0.valor }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// `notas [<texto>] [opciones] --json`: las mismas notas, con toda su ficha.
    static func notasJSON(_ textos: [String], _ notacion: Notacion) throws -> [NotaPresentada] {
        try notasPedidas(textos, notacion).notas.map { NotaPresentada($0, en: notacion) }
    }
}
