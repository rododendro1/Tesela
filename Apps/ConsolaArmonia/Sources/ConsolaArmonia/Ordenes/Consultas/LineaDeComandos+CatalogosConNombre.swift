import Armonia
import Exposicion

// MARK: - Consultas: los catálogos de acordes y de progresiones

extension LineaDeComandos {
    // MARK: Progresiones

    /// Las progresiones que pide `progresiones [<texto>] [--en <tonalidad>] [--epoca <época>]` y la tónica sobre la que
    /// se realizan. Con un nombre exacto, solo esa; si no, las que lo contienen (todas, sin texto); con `--epoca`,
    /// solo las de esa época, de origen o de uso.
    static func progresionesPedidas(_ textos: [String], _ notacion: Notacion) throws -> (
        progresiones: [ProgresionConNombre], tonica: Nota
    ) {
        var argumentos = Argumentos(textos)
        // `--en` lleva una nota (`--en La`) o una tonalidad (`--en La menor`), de la que vale la tónica.
        var tonica = Nota.do
        if let texto = try argumentos.valorConPalabras(.en, siFalta: .faltaTonalidadTrasEn) {
            tonica =
                try (try? Nota(leyendo: texto, enLaOrden: notacion))
                ?? Tonalidad(leyendo: texto, enLaOrden: notacion).tonica
        }
        // `--epoca barroco`: las de una época, de origen o de uso, como en `escalas`.
        var epocas: [Epoca] = []
        if let texto = try argumentos.valor(.epoca) { epocas = try self.epocas(leyendo: texto, notacion) }
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        let halladas =
            ProgresionConNombre.buscar(nombre: texto).map { [$0] } ?? ProgresionConNombre.buscar(conteniendo: texto)
        return (halladas.filter { epocas.isEmpty || $0.epocas.contains(where: epocas.contains) }, tonica)
    }

    /// `progresiones [<texto>] [--en <tonalidad>]`: cada progresión del catálogo, o las que tienen el texto en el
    /// nombre o en un alias en algún idioma, con su cifrado romano y sus acordes sobre Do, o sobre la tónica de
    /// `--en`, en el modo de la progresión.
    ///
    ///     cadencia andaluza: i VII VI V · Lam Sol Fa Mi
    static func progresiones(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (halladas, tonica) = try progresionesPedidas(textos, notacion)
        guard !halladas.isEmpty else { return ninguno(.ningunaProgresion, notacion) }
        let lineas = halladas.map { progresion in
            let acordes = progresion.acordes(sobre: tonica).map { $0.cifrado(en: notacion) }
            return "\(progresion.nombre(en: notacion)): \(progresion.cifrado) · " + acordes.joined(separator: " ")
        }
        return bien(lineas.joined(separator: "\n"))
    }

    struct ProgresionJSON: Encodable {
        let nombre: String
        let cifrado: String
        let modo: String
        let acordes: [String]
        let estilos: [String]
        /// El año de la obra que la documenta, y las claves de su época de origen y de las de uso.
        let anio: Int?
        let epoca: String?
        let epocasDeUso: [String]
    }

    /// `progresiones [<texto>] [--en <tonalidad>] --json`: las mismas progresiones, con su modo y sus estilos.
    static func progresionesJSON(_ textos: [String], _ notacion: Notacion) throws -> [ProgresionJSON] {
        let (halladas, tonica) = try progresionesPedidas(textos, notacion)
        return halladas.map { progresion in
            ProgresionJSON(
                nombre: progresion.nombre(en: notacion), cifrado: progresion.cifrado,
                modo: progresion.modo.nombre(en: notacion),
                acordes: progresion.acordes(sobre: tonica).map { $0.cifrado(en: notacion) },
                estilos: progresion.estilos.map { $0.nombre(en: notacion) }, anio: progresion.anioDeOrigen,
                epoca: progresion.epocaDeOrigen?.rawValue, epocasDeUso: progresion.epocasDeUso.map(\.rawValue))
        }
    }

    // MARK: Acordes

    /// Lo que pide `acordes`: los acordes, ya filtrados y ordenados, la nota sobre la que se escriben y si se quiere la
    /// tabla de estadísticas o el resumen. Lo mismo para el texto y para `--json`.
    struct PedidoDeAcordes {
        let acordes: [AcordeConNombre]
        let sobre: Nota
        /// `--estadisticas`: una tabla con lo que se mide de cada uno.
        let estadisticas: Bool
        /// `--resumen`: cuántos hay de cada número de notas, de cada estilo y por terceras.
        let resumen: Bool
    }

    /// Los acordes que pide `acordes [<texto>] [--sobre <nota>] [--notas 4] [--uso jazz] [--epoca barroco]
    /// [--por-terceras] [--no-por-terceras] [--sin-semitonos] [--con-intervalo tritono] [--sin-intervalo 1]
    /// [--orden brillo]`. Con un nombre exacto, solo ese; si no, los que lo contienen (todos, sin texto), con los filtros.
    static func acordesPedidos(_ textos: [String], _ notacion: Notacion) throws -> PedidoDeAcordes {
        var argumentos = Argumentos(textos)
        var sobre = Nota.do
        if let texto = try argumentos.valorConPalabras(.sobre) { sobre = try Nota(leyendo: texto, enLaOrden: notacion) }
        var usos: [Estilo] = []
        if let texto = try argumentos.valor(.uso) { usos = try estilosDeUso(leyendo: texto, notacion) }
        // `--epoca romanticismo`: los de una época, de origen o de uso.
        var epocas: [Epoca] = []
        if let texto = try argumentos.valor(.epoca) { epocas = try self.epocas(leyendo: texto, notacion) }
        // `--notas 4` o `--notas tétrada`: solo los de cuatro notas.
        var numeroDeNotas: Int?
        if let texto = try argumentos.valor(.notas, siFalta: .notasFueraDeRango) {
            numeroDeNotas = try numeroDeNotasDeAcorde(texto, notacion)
        }
        let porTerceras = argumentos.quitarMarca(.porTerceras)
        let noPorTerceras = argumentos.quitarMarca(.noPorTerceras)
        let sinSemitonos = argumentos.quitarMarca(.sinSemitonos)
        var conIntervalo: Int?
        if let texto = try argumentos.valor(.conIntervalo) { conIntervalo = try claseIntervalica(texto) }
        var sinIntervalo: Int?
        if let texto = try argumentos.valor(.sinIntervalo) { sinIntervalo = try claseIntervalica(texto) }
        // `--orden brillo`, `--orden notas` o `--orden consonancia`.
        var orden: OrdenDeAcordes?
        if let texto = try argumentos.valor(.orden) {
            guard let elegido = ordenesDeAcordes[claveDeBusqueda(texto)] else {
                throw ErrorDeUso.ordenDeAcordesDesconocido(texto)
            }
            orden = elegido
        }
        let estadisticas = argumentos.quitarMarca(.estadisticas)
        let resumen = argumentos.quitarMarca(.resumen)
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        let hallados = AcordeConNombre.buscar(nombre: texto).map { [$0] } ?? AcordeConNombre.buscar(conteniendo: texto)
        let elegidos = hallados.filter { acorde in
            let medidas = acorde.estadisticas
            if !usos.isEmpty, !acorde.estilos.contains(where: usos.contains) { return false }
            if !epocas.isEmpty, !acorde.epocas.contains(where: epocas.contains) { return false }
            if let numeroDeNotas, medidas.numeroDeNotas != numeroDeNotas { return false }
            if porTerceras && !medidas.porTerceras { return false }
            if noPorTerceras && medidas.porTerceras { return false }
            if sinSemitonos && !medidas.anhemitonico { return false }
            if let conIntervalo, medidas.vectorIntervalico[conIntervalo - 1] == 0 { return false }
            if let sinIntervalo, medidas.vectorIntervalico[sinIntervalo - 1] > 0 { return false }
            return true
        }
        // Con `--orden`, del más brillante al más oscuro (los que no tienen brillo, al final), de menos a más notas o
        // del más al menos consonante (Huron); a igualdad, en el orden del catálogo.
        var ordenados = elegidos
        if let orden {
            let claves = elegidos.map { acorde -> Double in
                let medidas = acorde.estadisticas
                switch orden {
                case .brillo: return -(medidas.brilloPorQuintas ?? -.infinity)
                case .notas: return Double(medidas.numeroDeNotas)
                case .consonancia: return -medidas.conjunto.consonanciaDiadica
                }
            }
            ordenados = elegidos.indices.sorted { (claves[$0], $0) < (claves[$1], $1) }.map { elegidos[$0] }
        }
        return PedidoDeAcordes(acordes: ordenados, sobre: sobre, estadisticas: estadisticas, resumen: resumen)
    }

    enum OrdenDeAcordes { case brillo, notas, consonancia }

    /// Los valores de `acordes --orden`, en español y en inglés.
    static let ordenesDeAcordes: [String: OrdenDeAcordes] = [
        "brillo": .brillo, "brightness": .brillo, "notas": .notas, "notes": .notas, "consonancia": .consonancia,
        "consonance": .consonancia,
    ]

    /// El número de notas de `acordes --notas`: un número de 1 a 24 o el nombre de un cardinal («tétrada»,
    /// «tetrad»), en español, en inglés o en el idioma de la notación.
    static func numeroDeNotasDeAcorde(_ texto: String, _ notacion: Notacion) throws -> Int {
        if let n = Int(texto) {
            guard (1...24).contains(n) else { throw ErrorDeUso.notasFueraDeRango }
            return n
        }
        let clave = claveDeBusqueda(texto)
        let cardinal = CardinalDeAcorde.allCases.first { candidato in
            [candidato.nombre, candidato.nombre(en: .compacta(.ingles)), candidato.nombre(en: notacion)]
                .map(claveDeBusqueda).contains(clave)
        }
        guard let numeroDeNotas = cardinal?.numeroDeNotas else { throw ErrorDeUso.notasFueraDeRango }
        return numeroDeNotas
    }

    /// `acordes [<texto>] [opciones]`: cada acorde del catálogo, o los que tienen el texto en el nombre o en un alias
    /// en algún idioma, con sus notas sobre Do, o sobre la nota de `--sobre`, y, en los genéricos (los que dan nombre a
    /// su tipo), su cifrado. Con `--estadisticas`, en una tabla con lo que se mide de cada uno; con `--resumen`,
    /// cuántos hay de cada número de notas, de cada estilo y por terceras.
    ///
    ///     acorde de Tristán: Fa Si Re♯ Sol♯
    ///     séptima de dominante (Do7): Do Mi Sol Si♭
    static func acordesConNombre(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let pedido = try acordesPedidos(textos, notacion)
        guard !pedido.acordes.isEmpty else { return ninguno(.ningunAcorde, notacion) }
        if pedido.resumen {
            return bien(
                describir(resumen: PresentacionDeEstadisticasDeAcorde.resumen(pedido.acordes, en: notacion), notacion))
        }
        if pedido.estadisticas {
            let tabla = PresentacionDeEstadisticasDeAcorde.tablaDeEstadisticas(pedido.acordes, en: notacion)
            return bien(columnas([tabla.encabezados] + tabla.filas))
        }
        let lineas = pedido.acordes.map { acorde in
            let cifrado = cifradoDelGenerico(acorde, sobre: pedido.sobre, notacion).map { " (" + $0 + ")" } ?? ""
            let notas = acorde.notas(sobre: pedido.sobre).map { $0.nombre(en: notacion) }
            return acorde.nombre(en: notacion) + cifrado + ": " + notas.joined(separator: " ")
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// El resumen de `acordes --resumen`, en líneas:
    ///
    ///     Acordes: 58
    ///     Por número de notas:
    ///       3 (tríada): 9
    ///       …
    ///     Por estilo:
    ///       jazz: 3
    ///       …
    ///     Por terceras: 56
    ///     No se lee por terceras: 2
    static func describir(resumen: ResumenDeAcordesPresentado, _ notacion: Notacion) -> String {
        var lineas = [notacion.texto(\.acordes) + ": \(resumen.total)"]
        lineas.append(notacion.texto(\.porNumeroDeNotas) + ":")
        lineas += resumen.porNumeroDeNotas.map { "  " + $0.nombre + ": \($0.acordes)" }
        if !resumen.porEstilo.isEmpty {
            lineas.append(notacion.texto(\.porEstilo) + ":")
            lineas += resumen.porEstilo.map { "  " + $0.nombre + ": \($0.acordes)" }
        }
        lineas.append(notacion.texto(\.porTerceras) + ": \(resumen.porTerceras)")
        if resumen.noPorTerceras > 0 {
            let etiqueta = notacion.texto(\.noPorTerceras)
            lineas.append(etiqueta.prefix(1).uppercased() + etiqueta.dropFirst() + ": \(resumen.noPorTerceras)")
        }
        return lineas.joined(separator: "\n")
    }

    struct AcordeConNombreJSON: Encodable {
        let nombre: String
        /// El cifrado sobre la nota pedida, en los genéricos (los que dan nombre a su tipo).
        let cifrado: String?
        let notas: [String]
        let estilos: [String]
        /// El año de la obra que lo documenta, y las claves de su época de origen y de las de uso.
        let anio: Int?
        let epoca: String?
        let epocasDeUso: [String]
        /// Con `--estadisticas`: lo que se mide del acorde.
        let estadisticas: EstadisticasDeAcordePresentadas?
    }

    /// `acordes [<texto>] [opciones] --json`: los mismos acordes, con sus estilos y, con `--estadisticas`, lo que se
    /// mide de cada uno; con `--resumen`, el resumen (`ResumenDeAcordesPresentado`).
    static func acordesConNombreJSON(_ textos: [String], _ notacion: Notacion) throws -> any Encodable {
        let pedido = try acordesPedidos(textos, notacion)
        if pedido.resumen { return PresentacionDeEstadisticasDeAcorde.resumen(pedido.acordes, en: notacion) }
        return pedido.acordes.map { acorde in
            AcordeConNombreJSON(
                nombre: acorde.nombre(en: notacion), cifrado: cifradoDelGenerico(acorde, sobre: pedido.sobre, notacion),
                notas: acorde.notas(sobre: pedido.sobre).map { $0.nombre(en: notacion) },
                estilos: acorde.estilos.map { $0.nombre(en: notacion) }, anio: acorde.anioDeOrigen,
                epoca: acorde.epocaDeOrigen?.rawValue, epocasDeUso: acorde.epocasDeUso.map(\.rawValue),
                estadisticas: pedido.estadisticas
                    ? EstadisticasDeAcordePresentadas(acorde.estadisticas, en: notacion) : nil)
        }
    }

    /// El cifrado de un acorde genérico sobre una nota: «Do7» para la séptima de dominante. Los de nombre propio no
    /// lo llevan, aunque sus notas se lean por terceras (el de Tristán sería Fa(♯6,♯9,♯11,omit3,omit5)).
    private static func cifradoDelGenerico(_ acorde: AcordeConNombre, sobre: Nota, _ notacion: Notacion) -> String? {
        guard let tipo = acorde.tipo, tipo.acordeConNombre == acorde else { return nil }
        return Acorde(sobre, tipo).cifrado(en: notacion)
    }

    /// Una búsqueda en un catálogo que no da nada: el mensaje y el código 1.
    private static func ninguno(_ mensaje: Mensaje, _ notacion: Notacion) -> ResultadoDeOrden {
        ResultadoDeOrden(salida: "", error: "armonia: " + mensaje.texto(en: notacion) + "\n", codigo: 1)
    }
}
