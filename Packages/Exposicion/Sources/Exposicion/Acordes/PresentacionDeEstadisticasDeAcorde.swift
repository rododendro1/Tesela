import Armonia

// MARK: - Lo que se mide de un acorde, escrito

/// Lo que se mide de un acorde (`EstadisticasDeAcorde`), escrito en la notación para la consola y las apps: un dato
/// por fila, una tabla para comparar varios y el resumen de un catálogo. Es el hermano de
/// `PresentacionDeEstudioDeEscala.estadisticas(de:en:)`.
public enum PresentacionDeEstadisticasDeAcorde {
    /// Un dato por fila: el número de notas con su cardinal, las tensiones, el brillo por quintas, la amplitud en
    /// quintas, el vector interválico, la forma prima, el número de Forte, las transposiciones distintas, el ámbito
    /// (en los acordes con nombre) y los rasgos (si tiene alguno); y después las medidas de las teorías de acordes:
    /// la consonancia de Huron, el grupo y la fundamental de Hindemith, la fundamental de Parncutt, los intervalos
    /// entre voces, el gradus de Euler, los coeficientes de Fourier, la distancia a la uniformidad, las tríadas que
    /// contiene, la tensión y la modalidad de Cook, las rugosidades de Sethares, Vassilakis y Hutchinson y Knopoff, la
    /// fusión tonal, la altura de Tenney, los límites impar y primo, la armonicidad, la entropía armónica, la
    /// fundamental virtual, la pareja Z y el complemento, y la disposición. Con `sobre`, las fundamentales se escriben como
    /// notas sobre esa; sin ella, como intervalos desde la nota de referencia.
    ///
    ///     let datos = PresentacionDeEstadisticasDeAcorde.estadisticas(
    ///         TipoDeAcorde.dominanteSeptima.estadisticas, en: .compacta(.espanol))
    ///     datos.map(\.valor)   // ["4 (tétrada)", "0", "+0.75", "6", "[0, 1, 2, 1, 1, 1]", "(0, 2, 5, 8)", "4-27",
    ///                          //  "12", "anhemitónico (sin semitonos) · con tritono"]
    public static func estadisticas(
        _ estadisticas: EstadisticasDeAcorde, sobre: Nota? = nil, en notacion: Notacion
    ) -> [DatoPresentado] {
        MedidaDeAcorde.todas.compactMap { medida in
            guard let nombre = medida.titulo(en: notacion),
                let valor = medida.texto(de: estadisticas, sobre: sobre, en: notacion)
            else { return nil }
            return DatoPresentado(nombre: nombre, valor: valor)
        }
    }

    /// La disposición de sus voces, y si deja los intervalos anchos abajo: «Cerrada · intervalos anchos abajo (serie
    /// armónica)», «Drop 2», «Abierta».
    public static func disposicion(_ estadisticas: EstadisticasDeAcorde, en notacion: Notacion) -> String {
        let nombre =
            estadisticas.disposicionDeVoces.disposicion?.nombre(en: notacion) ?? notacion.texto(\.disposicionAbierta)
        return estadisticas.disposicionDeVoces.respetaLaSerieArmonica
            ? nombre + " · " + notacion.texto(\.serieArmonica) : nombre
    }

    /// Las tríadas que contiene, con los símbolos del cifrado, que no cambian de idioma: «M 1 · m 1 · ° 1 · + 0».
    public static func triadas(_ triadas: TriadasContenidas) -> String {
        "M \(triadas.mayores) · m \(triadas.menores) · ° \(triadas.disminuidas) · + \(triadas.aumentadas)"
    }

    /// Los rasgos que tiene, separados por « · »: «no se lee por terceras · con tritono · simétrico por inversión»;
    /// vacío si no tiene ninguno.
    public static func rasgos(_ estadisticas: EstadisticasDeAcorde, en notacion: Notacion) -> String {
        [
            estadisticas.porTerceras ? nil : notacion.texto(\.noPorTerceras),
            estadisticas.anhemitonico ? notacion.texto(\.anhemitonico) : nil,
            estadisticas.conTritono ? notacion.texto(\.conTritono) : nil,
            estadisticas.simetricoPorInversion ? notacion.texto(\.simetricoPorInversion) : nil,
        ].compactMap { $0 }.joined(separator: " · ")
    }

    /// Varios acordes del catálogo en una tabla, uno por fila: el nombre, las notas sobre Do, el número de notas, el
    /// brillo por quintas, el vector interválico, el número de Forte, la consonancia de Huron, el grupo de Hindemith y
    /// los rasgos.
    ///
    ///     let tabla = PresentacionDeEstadisticasDeAcorde.tablaDeEstadisticas(
    ///         [.mayor, .dominanteSeptima], en: .compacta(.espanol))
    ///     tabla.filas[1][3]   // "+0.75"
    public static func tablaDeEstadisticas(
        _ acordes: [AcordeConNombre], en notacion: Notacion
    ) -> (encabezados: [String], filas: [[String]]) {
        let medidas = columnasDeLaTabla.compactMap(MedidaDeAcorde.medida)
        let encabezados =
            [notacion.texto(\.acorde), notacion.texto(\.notas)] + medidas.compactMap { $0.titulo(en: notacion) }
        let filas = acordes.map { acorde -> [String] in
            let estadisticas = acorde.estadisticas
            return [
                acorde.nombre(en: notacion),
                acorde.notas(sobre: .do).map { $0.nombre(en: notacion) }.joined(separator: " "),
            ] + medidas.map { $0.texto(de: estadisticas, en: notacion) ?? "—" }
        }
        return (encabezados, filas)
    }

    /// Las medidas de `tablaDeEstadisticas(_:en:)`, por su clave.
    static let columnasDeLaTabla = [
        "numeroDeNotas", "brilloPorQuintas", "vectorIntervalico", "numeroDeForte", "consonanciaDiadica",
        "grupoDeHindemith", "rasgos",
    ]

    /// Cuántos acordes hay de cada número de notas, de cada estilo y por terceras o no.
    ///
    ///     let resumen = PresentacionDeEstadisticasDeAcorde.resumen(
    ///         [.mayor, .menor, .dominanteSeptima, .petrushka], en: .compacta(.espanol))
    ///     resumen.total                          // 4
    ///     resumen.porNumeroDeNotas.map(\.nombre) // ["3 (tríada)", "4 (tétrada)", "6 (héxada)"]
    ///     resumen.noPorTerceras                  // 1
    public static func resumen(_ acordes: [AcordeConNombre], en notacion: Notacion) -> ResumenDeAcordesPresentado {
        let numeros = Dictionary(grouping: acordes, by: \.numeroDeNotas)
        let porNumero = numeros.keys.sorted().map { n in
            let cardinal = CardinalDeAcorde(numeroDeNotas: n).map { " (" + $0.nombre(en: notacion) + ")" } ?? ""
            return ResumenDeAcordesPresentado.Recuento(nombre: "\(n)" + cardinal, acordes: numeros[n]?.count ?? 0)
        }
        var porEstilo = Estilo.allCases.compactMap { estilo -> ResumenDeAcordesPresentado.Recuento? in
            let cuantos = acordes.filter { $0.estilos.contains(estilo) }.count
            return cuantos == 0 ? nil : .init(nombre: estilo.nombre(en: notacion), acordes: cuantos)
        }
        let sinEstilo = acordes.filter(\.estilos.isEmpty).count
        if sinEstilo > 0 { porEstilo.append(.init(nombre: notacion.texto(\.sinEstilo), acordes: sinEstilo)) }
        let porTerceras = acordes.filter { $0.tipo != nil }.count
        return ResumenDeAcordesPresentado(
            total: acordes.count, porNumeroDeNotas: porNumero, porEstilo: porEstilo, porTerceras: porTerceras,
            noPorTerceras: acordes.count - porTerceras)
    }

}

/// Lo que se mide de un acorde, para `--json`: el valor de cada medida de `MedidaDeAcorde.todas` que va al JSON, con
/// su clave (`numeroDeNotas`, `cardinal`, `brilloPorQuintas` redondeado a dos decimales, `consonanciaDiadica`…). Las
/// que el acorde no tiene no salen.
///
///     let datos = EstadisticasDeAcordePresentadas(TipoDeAcorde.mayor.estadisticas, en: .compacta(.espanol))
///     datos["numeroDeForte"]   // .texto("3-11")
public struct EstadisticasDeAcordePresentadas: Hashable, Sendable, Encodable {
    /// Los valores por su clave.
    public let valores: [String: ValorDeMedida]

    /// El valor de la medida de esa clave.
    public subscript(clave: String) -> ValorDeMedida? { valores[clave] }

    public init(_ medidas: EstadisticasDeAcorde, sobre: Nota? = nil, en notacion: Notacion) {
        var valores: [String: ValorDeMedida] = [:]
        for medida in MedidaDeAcorde.todas {
            valores[medida.clave] = medida.valor(de: medidas, sobre: sobre, en: notacion)
        }
        self.valores = valores
    }

    public func encode(to encoder: any Encoder) throws {
        var contenedor = encoder.singleValueContainer()
        try contenedor.encode(valores)
    }
}

/// El resumen de unos acordes del catálogo (`PresentacionDeEstadisticasDeAcorde.resumen(_:en:)`): cuántos hay, de
/// cada número de notas, de cada estilo y por terceras o no.
public struct ResumenDeAcordesPresentado: Hashable, Sendable, Codable {
    /// Un grupo y cuántos acordes tiene: «4 (tétrada)», 20.
    public struct Recuento: Hashable, Sendable, Codable {
        public let nombre: String
        public let acordes: Int
    }

    public let total: Int
    /// De menos notas a más.
    public let porNumeroDeNotas: [Recuento]
    /// En el orden de `Estilo`, solo los que tienen alguno, y al final los que no tienen estilo. Un acorde de dos
    /// estilos cuenta en los dos.
    public let porEstilo: [Recuento]
    public let porTerceras: Int
    public let noPorTerceras: Int
}
