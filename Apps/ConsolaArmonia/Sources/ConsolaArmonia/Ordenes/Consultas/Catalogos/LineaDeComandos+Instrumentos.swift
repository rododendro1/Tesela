import Armonia
import ExposicionArmonia

// MARK: - Consultas: el catálogo de instrumentos de cuerda

extension LineaDeComandos {
    /// Lo que deja `instrumentos --familia`: los de una familia o los de unos trastes.
    enum FamiliaDeInstrumento: Hashable {
        case familia(FamiliaDeEncordado)
        case trastes(TrastesDeEncordado)

        /// Si el instrumento es de esta familia o tiene estos trastes.
        func cumple(_ encordado: Encordado) -> Bool {
            switch self {
            case .familia(let familia): return encordado.familia == familia
            case .trastes(let trastes): return encordado.trastes == trastes
            }
        }

        /// Su nombre en la notación: «guitarras», «sin trastes».
        func nombre(en notacion: Notacion) -> String {
            switch self {
            case .familia(let familia): return familia.nombre(en: notacion)
            case .trastes(let trastes): return trastes.nombre(en: notacion)
            }
        }
    }

    /// Los valores de `instrumentos --familia`, en español y en inglés: las familias y después los trastes.
    static let nombresDeLasFamiliasDeInstrumento: [(familia: FamiliaDeInstrumento, espanol: String, ingles: String)] = [
        (.familia(.guitarras), "guitarras", "guitars"), (.familia(.bajos), "bajos", "basses"),
        (.familia(.guitarrasPequenas), "guitarras-pequenas", "small-guitars"),
        (.familia(.laudes), "laudes", "lutes"), (.familia(.banjosYCitaras), "banjos-y-citaras", "banjos-and-zithers"),
        (.familia(.cuerdaFrotada), "cuerda-frotada", "bowed-strings"),
        (.trastes(.cromaticos), "cromaticos", "chromatic"), (.trastes(.diatonicos), "diatonicos", "diatonic"),
        (.trastes(.sinTrastes), "sin-trastes", "fretless"),
    ]

    /// Los valores de `instrumentos --agrupar` que no son los de `escalas`: por su familia.
    static let agruparPorFamilia = ["familia", "family"]

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

    /// Los instrumentos que pide `instrumentos [<texto>] [--familia <familia|trastes>] [--lugar <lugar>]
    /// [--agrupar <forma>] [--estadisticas]`, si se quiere su ficha y cómo se agrupan (`porFamilia` con
    /// `--agrupar familia`). Con un nombre exacto, solo ese; si no, los que lo
    /// contienen en el nombre en algún idioma (todos, sin texto).
    static func instrumentosPedidos(_ textos: [String], _ notacion: Notacion) throws -> (
        instrumentos: [Encordado], ficha: Bool, agrupacion: AgrupacionDeEscalas?, porFamilia: Bool
    ) {
        var argumentos = Argumentos(textos)
        var familia: FamiliaDeInstrumento?
        if let texto = try argumentos.valorConPalabras(.familia) {
            let clave = claveDeBusqueda(texto)
            let hallada = nombresDeLasFamiliasDeInstrumento.first { fila in
                [fila.espanol, fila.ingles, fila.familia.nombre(en: notacion)].map(claveDeBusqueda).contains(clave)
            }
            guard let elegida = hallada?.familia else { throw ErrorDeUso.familiaDeInstrumentoDesconocida(texto) }
            familia = elegida
        }
        var lugar = LugarDelCatalogo()
        if let texto = try argumentos.valor(.lugar) { lugar.lugares = try lugares(leyendo: texto, notacion) }
        var porFamilia = false
        if let texto = try argumentos.valor(.agrupar) {
            if agruparPorFamilia.contains(claveDeBusqueda(texto)) {
                porFamilia = true
            } else {
                lugar.agrupacion = try agrupacion(leyendo: texto)
            }
        }
        let ficha = argumentos.quitarMarca(.estadisticas)
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        let exacto = texto.isEmpty ? nil : try? Encordado(leyendo: texto)
        let hallados = exacto.map { [$0] } ?? Encordado.buscar(conteniendo: texto)
        let pedidos = hallados.filter { encordado in
            familia?.cumple(encordado) != false && lugar.cumple(encordado.lugaresDeOrigen)
        }
        return (pedidos, ficha, lugar.agrupacion, porFamilia)
    }

    /// `instrumentos [<texto>] [opciones]`: cada instrumento de cuerda del catálogo, o los que tienen el texto en el
    /// nombre, con su afinación y sus cuerdas. Con `--estadisticas`, debajo de cada uno, su ficha.
    ///
    ///     mandolina: Sol3 Re4 La4 Mi5 · 4 órdenes, 8 cuerdas
    static func instrumentos(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (hallados, ficha, agrupacion, porFamilia) = try instrumentosPedidos(textos, notacion)
        guard !hallados.isEmpty else {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + Mensaje.ningunInstrumento.texto(en: notacion) + "\n", codigo: 1)
        }
        func lineas(_ encordado: Encordado) -> [String] {
            let presentado = EncordadoPresentado(encordado, en: notacion)
            let linea =
                presentado.nombre + ": " + presentado.afinacion.joined(separator: " ") + " · "
                + presentado.cuerdas(en: notacion)
            guard ficha else { return [linea] }
            return [linea] + presentado.ficha(en: notacion).map { "  " + $0.nombre + ": " + $0.valor }
        }
        guard !porFamilia else {
            // Por familia, en el orden de `FamiliaDeEncordado`: «guitarras (12)» y sus instrumentos sangrados.
            let grupos = FamiliaDeEncordado.allCases.compactMap { familia -> [String]? in
                let suyos = hallados.filter { $0.familia == familia }
                guard !suyos.isEmpty else { return nil }
                return ["\(familia.nombre(en: notacion)) (\(suyos.count))"] + suyos.flatMap(lineas).map { "  " + $0 }
            }
            return bien(grupos.joined().joined(separator: "\n"))
        }
        let todas = lineasAgrupadas(
            de: hallados, agrupadas: agrupacion, en: notacion, epoca: \.epocaDeOrigen, paises: \.paisesDeOrigen,
            continentes: \.continentesDeOrigen, lineas: lineas)
        return bien(todas.joined(separator: "\n"))
    }

    /// `instrumentos [<texto>] [opciones] --json`: los mismos instrumentos, con toda su ficha.
    static func instrumentosJSON(_ textos: [String], _ notacion: Notacion) throws -> [EncordadoPresentado] {
        try instrumentosPedidos(textos, notacion).instrumentos.map { EncordadoPresentado($0, en: notacion) }
    }
}
