import Armonia

// MARK: - Consultas: los catálogos de acordes y de progresiones

extension LineaDeComandos {
    // MARK: Progresiones

    /// Las progresiones que pide `progresiones [<texto>] [--en <tonalidad>]` y la tónica sobre la que se realizan.
    /// Con un nombre exacto, solo esa; si no, las que lo contienen (todas, sin texto).
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
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        let halladas =
            ProgresionConNombre.buscar(nombre: texto).map { [$0] } ?? ProgresionConNombre.buscar(conteniendo: texto)
        return (halladas, tonica)
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
    }

    /// `progresiones [<texto>] [--en <tonalidad>] --json`: las mismas progresiones, con su modo y sus estilos.
    static func progresionesJSON(_ textos: [String], _ notacion: Notacion) throws -> [ProgresionJSON] {
        let (halladas, tonica) = try progresionesPedidas(textos, notacion)
        return halladas.map { progresion in
            ProgresionJSON(
                nombre: progresion.nombre(en: notacion), cifrado: progresion.cifrado,
                modo: progresion.modo.nombre(en: notacion),
                acordes: progresion.acordes(sobre: tonica).map { $0.cifrado(en: notacion) },
                estilos: progresion.estilos.map { $0.nombre(en: notacion) })
        }
    }

    // MARK: Acordes

    /// Los acordes que pide `acordes [<texto>] [--sobre <nota>]` y la nota sobre la que se escriben. Con un nombre
    /// exacto, solo ese; si no, los que lo contienen (todos, sin texto).
    static func acordesPedidos(_ textos: [String], _ notacion: Notacion) throws -> (
        acordes: [AcordeConNombre], sobre: Nota
    ) {
        var argumentos = Argumentos(textos)
        var sobre = Nota.do
        if let texto = try argumentos.valorConPalabras(.sobre) { sobre = try Nota(leyendo: texto, enLaOrden: notacion) }
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        let hallados = AcordeConNombre.buscar(nombre: texto).map { [$0] } ?? AcordeConNombre.buscar(conteniendo: texto)
        return (hallados, sobre)
    }

    /// `acordes [<texto>] [--sobre <nota>]`: cada acorde del catálogo, o los que tienen el texto en el nombre o en un
    /// alias en algún idioma, con sus notas sobre Do, o sobre la nota de `--sobre`, y, en los genéricos (los que dan
    /// nombre a su tipo), su cifrado.
    ///
    ///     acorde de Tristán: Fa Si Re♯ Sol♯
    ///     séptima de dominante (Do7): Do Mi Sol Si♭
    static func acordesConNombre(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (hallados, sobre) = try acordesPedidos(textos, notacion)
        guard !hallados.isEmpty else { return ninguno(.ningunAcorde, notacion) }
        let lineas = hallados.map { acorde in
            let cifrado = cifradoDelGenerico(acorde, sobre: sobre, notacion).map { " (" + $0 + ")" } ?? ""
            let notas = acorde.notas(sobre: sobre).map { $0.nombre(en: notacion) }
            return acorde.nombre(en: notacion) + cifrado + ": " + notas.joined(separator: " ")
        }
        return bien(lineas.joined(separator: "\n"))
    }

    struct AcordeConNombreJSON: Encodable {
        let nombre: String
        /// El cifrado sobre la nota pedida, en los genéricos (los que dan nombre a su tipo).
        let cifrado: String?
        let notas: [String]
        let estilos: [String]
    }

    /// `acordes [<texto>] [--sobre <nota>] --json`: los mismos acordes, con sus estilos.
    static func acordesConNombreJSON(_ textos: [String], _ notacion: Notacion) throws -> [AcordeConNombreJSON] {
        let (hallados, sobre) = try acordesPedidos(textos, notacion)
        return hallados.map { acorde in
            AcordeConNombreJSON(
                nombre: acorde.nombre(en: notacion), cifrado: cifradoDelGenerico(acorde, sobre: sobre, notacion),
                notas: acorde.notas(sobre: sobre).map { $0.nombre(en: notacion) },
                estilos: acorde.estilos.map { $0.nombre(en: notacion) })
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
