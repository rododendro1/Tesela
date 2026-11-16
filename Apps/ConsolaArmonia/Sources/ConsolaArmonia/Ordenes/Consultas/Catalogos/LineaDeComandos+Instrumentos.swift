import Armonia
import ExposicionArmonia

// MARK: - Consultas: el catálogo de instrumentos de cuerda

extension LineaDeComandos {
    /// Los valores de `instrumentos --familia`, por sus trastes, en español y en inglés.
    static let nombresDeLasFamiliasDeInstrumento: [(familia: TrastesDeEncordado, espanol: String, ingles: String)] = [
        (.cromaticos, "cromaticos", "chromatic"), (.diatonicos, "diatonicos", "diatonic"),
        (.sinTrastes, "sin-trastes", "fretless"),
    ]

    /// Los valores de `--familia` de todas las órdenes que la tienen, sin repetir, para completar en la terminal.
    static let nombresDeLasFamilias: [String] = {
        let grupos: [[String]] = [
            nombresDeLasFamiliasDeRitmo.flatMap { [$0.espanol, $0.ingles] },
            nombresDeLasFamiliasDeTemperamento.flatMap { [$0.espanol, $0.ingles] },
            nombresDeLasFamiliasDeNota.flatMap { [$0.espanol, $0.ingles] },
            nombresDeLasFamiliasDeFuncion.flatMap { [$0.espanol, $0.ingles] },
            nombresDeLasFamiliasDeInstrumento.flatMap { [$0.espanol, $0.ingles] },
        ]
        return grupos.joined().reduce(into: [String]()) { if !$0.contains($1) { $0.append($1) } }
    }()

    /// Los instrumentos que pide `instrumentos [<texto>] [--familia <trastes>] [--lugar <lugar>] [--agrupar <forma>]
    /// [--estadisticas]`, si se quiere su ficha y cómo se agrupan. Con un nombre exacto, solo ese; si no, los que lo
    /// contienen en el nombre en algún idioma (todos, sin texto).
    static func instrumentosPedidos(_ textos: [String], _ notacion: Notacion) throws -> (
        instrumentos: [Encordado], ficha: Bool, agrupacion: AgrupacionDeEscalas?
    ) {
        var argumentos = Argumentos(textos)
        var familia: TrastesDeEncordado?
        if let texto = try argumentos.valorConPalabras(.familia) {
            let clave = claveDeBusqueda(texto)
            let hallada = nombresDeLasFamiliasDeInstrumento.first { fila in
                [fila.espanol, fila.ingles, fila.familia.nombre(en: notacion)].map(claveDeBusqueda).contains(clave)
            }
            guard let elegida = hallada?.familia else { throw ErrorDeUso.familiaDeInstrumentoDesconocida(texto) }
            familia = elegida
        }
        let lugar = try lugarDelCatalogo(&argumentos, notacion)
        let ficha = argumentos.quitarMarca(.estadisticas)
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        let exacto = texto.isEmpty ? nil : try? Encordado(leyendo: texto)
        let hallados = exacto.map { [$0] } ?? Encordado.buscar(conteniendo: texto)
        let pedidos = hallados.filter { encordado in
            (familia == nil || encordado.trastes == familia) && lugar.cumple(encordado.lugaresDeOrigen)
        }
        return (pedidos, ficha, lugar.agrupacion)
    }

    /// `instrumentos [<texto>] [opciones]`: cada instrumento de cuerda del catálogo, o los que tienen el texto en el
    /// nombre, con su afinación y sus cuerdas. Con `--estadisticas`, debajo de cada uno, su ficha.
    ///
    ///     mandolina: Sol3 Re4 La4 Mi5 · 4 órdenes, 8 cuerdas
    static func instrumentos(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (hallados, ficha, agrupacion) = try instrumentosPedidos(textos, notacion)
        guard !hallados.isEmpty else {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + Mensaje.ningunInstrumento.texto(en: notacion) + "\n", codigo: 1)
        }
        let lineas = lineasAgrupadas(
            de: hallados, agrupadas: agrupacion, en: notacion, epoca: \.epocaDeOrigen, paises: \.paisesDeOrigen,
            continentes: \.continentesDeOrigen
        ) { encordado -> [String] in
            let presentado = EncordadoPresentado(encordado, en: notacion)
            let linea =
                presentado.nombre + ": " + presentado.afinacion.joined(separator: " ") + " · "
                + presentado.cuerdas(en: notacion)
            guard ficha else { return [linea] }
            return [linea] + presentado.ficha(en: notacion).map { "  " + $0.nombre + ": " + $0.valor }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// `instrumentos [<texto>] [opciones] --json`: los mismos instrumentos, con toda su ficha.
    static func instrumentosJSON(_ textos: [String], _ notacion: Notacion) throws -> [EncordadoPresentado] {
        try instrumentosPedidos(textos, notacion).instrumentos.map { EncordadoPresentado($0, en: notacion) }
    }
}
