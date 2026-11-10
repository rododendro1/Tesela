import Armonia
import Exposicion

// MARK: - Consultas: el catálogo de ritmos

extension LineaDeComandos {
    /// Los valores de `ritmos --familia`, en español y en inglés.
    static let nombresDeLasFamiliasDeRitmo: [(familia: FamiliaDeRitmo, espanol: String, ingles: String)] = [
        (.lineaDeTiempo, "linea-de-tiempo", "timeline"), (.flamenco, "flamenco", "flamenco"), (.tala, "tala", "tala"),
        (.iqa, "iqa", "iqa"), (.aksak, "aksak", "aksak"), (.modoRitmico, "modo-ritmico", "rhythmic-mode"),
        (.danza, "danza", "dance"),
    ]

    /// Lo que pide `ritmos`: los ritmos, si se quieren sus medidas y con qué ritmo se comparan.
    struct PedidoDeRitmos {
        let ritmos: [RitmoConNombre]
        let estadisticas: Bool
        let comparado: RitmoConNombre?
    }

    /// Los ritmos que pide `ritmos [<texto>] [--familia <familia>] [--estadisticas] [--comparar <ritmo>]`. Con un
    /// nombre exacto, solo ese; si no, los que lo contienen (todos, sin texto), de la familia de `--familia`.
    static func ritmosPedidos(_ textos: [String], _ notacion: Notacion) throws -> PedidoDeRitmos {
        var argumentos = Argumentos(textos)
        var familia: FamiliaDeRitmo?
        if let texto = try argumentos.valorConPalabras(.familia) {
            familia = try familiaDeRitmo(leyendo: texto, notacion)
        }
        var comparado: RitmoConNombre?
        if let texto = try argumentos.valorConPalabras(.comparar) {
            guard let ritmo = RitmoConNombre.buscar(nombre: texto) else { throw ErrorDeUso.ritmoDesconocido(texto) }
            comparado = ritmo
        }
        let estadisticas = argumentos.quitarMarca(.estadisticas)
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        let hallados = RitmoConNombre.buscar(nombre: texto).map { [$0] } ?? RitmoConNombre.buscar(conteniendo: texto)
        return PedidoDeRitmos(
            ritmos: hallados.filter { familia == nil || $0.familia == familia }, estadisticas: estadisticas,
            comparado: comparado)
    }

    /// La familia de `--familia`: su clave en español o en inglés, o su nombre en la notación.
    static func familiaDeRitmo(leyendo texto: String, _ notacion: Notacion) throws -> FamiliaDeRitmo {
        let clave = claveDeBusqueda(texto)
        let hallada = nombresDeLasFamiliasDeRitmo.first { fila in
            [fila.espanol, fila.ingles, fila.familia.nombre(en: notacion)].map(claveDeBusqueda).contains(clave)
        }
        guard let familia = hallada?.familia else { throw ErrorDeUso.familiaDeRitmoDesconocida(texto) }
        return familia
    }

    /// `ritmos [<texto>] [opciones]`: cada ritmo del catálogo, o los que tienen el texto en el nombre o en un alias en
    /// algún idioma, con su patrón y su compás. Con `--estadisticas`, debajo de cada uno, su ficha y lo que se mide de
    /// él; con `--comparar`, sus distancias a otro.
    ///
    ///     clave de son: x..x..x...x.x... · 4/4
    static func ritmos(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let pedido = try ritmosPedidos(textos, notacion)
        guard !pedido.ritmos.isEmpty else {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + Mensaje.ningunRitmo.texto(en: notacion) + "\n", codigo: 1)
        }
        let lineas = pedido.ritmos.flatMap { ritmo -> [String] in
            let presentado = RitmoPresentado(ritmo, en: notacion)
            var lineas = ["\(presentado.nombre): \(presentado.patron) · \(presentado.compas)"]
            if pedido.estadisticas {
                lineas += (presentado.ficha(en: notacion) + presentado.datos(en: notacion)).map {
                    "  " + $0.nombre + ": " + $0.valor
                }
            }
            if let comparado = pedido.comparado {
                let relacion = RelacionEntreRitmosPresentada(ritmo, con: comparado, en: notacion)
                lineas += relacion.datos(en: notacion).map { "  \($0.nombre) (\(relacion.con)): \($0.valor)" }
            }
            return lineas
        }
        return bien(lineas.joined(separator: "\n"))
    }

    struct RitmoJSON: Encodable {
        let ritmo: RitmoPresentado
        /// Con `--comparar`: las distancias al otro ritmo.
        let relacion: RelacionEntreRitmosPresentada?
    }

    /// `ritmos [<texto>] [opciones] --json`: los mismos ritmos, con todo lo que se mide de ellos.
    static func ritmosJSON(_ textos: [String], _ notacion: Notacion) throws -> [RitmoJSON] {
        let pedido = try ritmosPedidos(textos, notacion)
        return pedido.ritmos.map { ritmo in
            RitmoJSON(
                ritmo: RitmoPresentado(ritmo, en: notacion),
                relacion: pedido.comparado.map { RelacionEntreRitmosPresentada(ritmo, con: $0, en: notacion) })
        }
    }
}
