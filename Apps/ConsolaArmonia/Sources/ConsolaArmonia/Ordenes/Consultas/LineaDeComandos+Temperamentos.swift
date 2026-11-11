import Armonia
import Exposicion

// MARK: - Consultas: el catálogo de temperamentos

extension LineaDeComandos {
    /// Los valores de `temperamentos --familia`, en español y en inglés.
    static let nombresDeLasFamiliasDeTemperamento: [(familia: FamiliaDeTemperamento, espanol: String, ingles: String)] =
        [
            (.regular, "regular", "regular"), (.circular, "circular", "circular"), (.justa, "justa", "just"),
            (.divisionesIguales, "divisiones-iguales", "equal-divisions"),
            (.tradicional, "tradicional", "traditional"),
        ]

    /// Los temperamentos que pide `temperamentos [<texto>] [--familia <familia>] [--estadisticas]` y si se quieren
    /// sus medidas. Con un nombre exacto, solo ese; si no, los que lo contienen (todos, sin texto), de la familia de
    /// `--familia`.
    static func temperamentosPedidos(_ textos: [String], _ notacion: Notacion) throws -> (
        temperamentos: [TemperamentoConNombre], estadisticas: Bool
    ) {
        var argumentos = Argumentos(textos)
        var familia: FamiliaDeTemperamento?
        if let texto = try argumentos.valorConPalabras(.familia) {
            let clave = claveDeBusqueda(texto)
            let hallada = nombresDeLasFamiliasDeTemperamento.first { fila in
                [fila.espanol, fila.ingles, fila.familia.nombre(en: notacion)].map(claveDeBusqueda).contains(clave)
            }
            guard let elegida = hallada?.familia else { throw ErrorDeUso.familiaDeTemperamentoDesconocida(texto) }
            familia = elegida
        }
        let estadisticas = argumentos.quitarMarca(.estadisticas)
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        let hallados =
            TemperamentoConNombre.buscar(nombre: texto).map { [$0] } ?? TemperamentoConNombre.buscar(conteniendo: texto)
        return (hallados.filter { familia == nil || $0.familia == familia }, estadisticas)
    }

    /// `temperamentos [<texto>] [opciones]`: cada temperamento del catálogo, o los que tienen el texto en el nombre o
    /// en un alias en algún idioma, con sus pasos por octava, su quinta y quién lo propuso. Con `--estadisticas`,
    /// debajo de cada uno, su ficha y lo que se mide de él.
    ///
    ///     mesotónico de 1/4 de coma: 12 · 696.578 (Pietro Aron, 1523)
    static func temperamentos(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(textos)
        if argumentos.quitarMarca(.reloj) { return try relojDelTemperamento(&argumentos, notacion) }
        let (hallados, estadisticas) = try temperamentosPedidos(textos, notacion)
        guard !hallados.isEmpty else {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + Mensaje.ningunTemperamento.texto(en: notacion) + "\n", codigo: 1)
        }
        let lineas = hallados.flatMap { temperamento -> [String] in
            let presentado = TemperamentoPresentado(temperamento, en: notacion)
            var linea = presentado.nombre + ": \(presentado.pasosPorOctava)"
            if let quinta = presentado.quinta {
                linea += " · " + Redondeo.texto(quinta)
            }
            let origen = [presentado.autor, presentado.anio.map(String.init)].compactMap { $0 }
            if !origen.isEmpty { linea += " (" + origen.joined(separator: ", ") + ")" }
            guard estadisticas else { return [linea] }
            return [linea]
                + (presentado.ficha(en: notacion) + presentado.datos(en: notacion)).map {
                    "  " + $0.nombre + ": " + $0.valor
                }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// `temperamentos <texto> --reloj [--quintas] [--colores]`: el primer temperamento que se encuentre, en un reloj
    /// de cents (SVG); con `--quintas`, de quinta en quinta, si su quinta recorre todos sus pasos.
    static func relojDelTemperamento(_ argumentos: inout Argumentos, _ notacion: Notacion) throws -> ResultadoDeOrden {
        let quintas = argumentos.quitarMarca(.quintas)
        let colores = argumentos.quitarMarca(.colores)
        let (hallados, _) = try temperamentosPedidos(argumentos.restantes, notacion)
        guard let temperamento = hallados.first else {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + Mensaje.ningunTemperamento.texto(en: notacion) + "\n", codigo: 1)
        }
        guard
            let svg = TemperamentoPresentado.reloj(de: temperamento, quintas: quintas, colores: colores, en: notacion)
        else { throw ErrorDeUso.sinCirculoDeQuintas(temperamento.nombre(en: notacion)) }
        return bien(svg.trimmingCharacters(in: "\n"))
    }

    /// `temperamentos [<texto>] [opciones] --json`: los mismos temperamentos, con todo lo que se mide de ellos.
    static func temperamentosJSON(_ textos: [String], _ notacion: Notacion) throws -> [TemperamentoPresentado] {
        try temperamentosPedidos(textos, notacion).temperamentos.map { TemperamentoPresentado($0, en: notacion) }
    }
}
