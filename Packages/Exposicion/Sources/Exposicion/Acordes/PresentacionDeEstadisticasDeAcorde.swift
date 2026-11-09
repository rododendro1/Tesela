import Armonia

// MARK: - Lo que se mide de un acorde, escrito

/// Lo que se mide de un acorde (`EstadisticasDeAcorde`), escrito en la notación para la consola y las apps: un dato
/// por fila, una tabla para comparar varios y el resumen de un catálogo. Es el hermano de
/// `PresentacionDeEstudioDeEscala.estadisticas(de:en:)`.
public enum PresentacionDeEstadisticasDeAcorde {
    /// Un dato por fila: el número de notas con su cardinal, las tensiones, el brillo por quintas, la amplitud en
    /// quintas, el vector interválico, la forma prima, el número de Forte, las transposiciones distintas, el ámbito
    /// (en los acordes con nombre) y los rasgos (si tiene alguno).
    ///
    ///     let datos = PresentacionDeEstadisticasDeAcorde.estadisticas(
    ///         TipoDeAcorde.dominanteSeptima.estadisticas, en: .compacta(.espanol))
    ///     datos.map(\.valor)   // ["4 (tétrada)", "0", "+0.75", "6", "[0, 1, 2, 1, 1, 1]", "(0, 2, 5, 8)", "4-27",
    ///                          //  "12", "anhemitónico (sin semitonos) · con tritono"]
    public static func estadisticas(_ estadisticas: EstadisticasDeAcorde, en notacion: Notacion) -> [DatoPresentado] {
        func dato(_ campo: (TextosDeApps) -> String, _ valor: String) -> DatoPresentado {
            DatoPresentado(nombre: notacion.texto(campo), valor: valor)
        }
        let cardinal = estadisticas.cardinal.map { " (" + $0.nombre(en: notacion) + ")" } ?? ""
        var datos = [dato(\.numeroDeNotas, "\(estadisticas.numeroDeNotas)" + cardinal)]
        if let tensiones = estadisticas.tensiones { datos.append(dato(\.tensiones, "\(tensiones)")) }
        if let brillo = estadisticas.brilloPorQuintas {
            datos.append(dato(\.brilloPorQuintas, PresentacionDeEstudioDeEscala.conSigno(brillo)))
        }
        datos.append(dato(\.amplitudEnQuintas, "\(estadisticas.amplitudEnQuintas)"))
        datos.append(dato(\.vectorIntervalico, "[" + lista(estadisticas.vectorIntervalico) + "]"))
        datos.append(dato(\.formaPrima, "(" + lista(estadisticas.formaPrima) + ")"))
        if let forte = estadisticas.numeroDeForte { datos.append(dato(\.numeroDeForte, forte)) }
        datos.append(dato(\.transposicionesDistintas, "\(estadisticas.transposicionesDistintas)"))
        if let ambito = estadisticas.ambito { datos.append(dato(\.ambito, "\(ambito)")) }
        let rasgos = self.rasgos(estadisticas, en: notacion)
        if !rasgos.isEmpty { datos.append(dato(\.rasgos, rasgos)) }
        return datos
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
    /// brillo por quintas, el vector interválico, el número de Forte y los rasgos.
    ///
    ///     let tabla = PresentacionDeEstadisticasDeAcorde.tablaDeEstadisticas(
    ///         [.mayor, .dominanteSeptima], en: .compacta(.espanol))
    ///     tabla.filas[1][3]   // "+0.75"
    public static func tablaDeEstadisticas(
        _ acordes: [AcordeConNombre], en notacion: Notacion
    ) -> (encabezados: [String], filas: [[String]]) {
        let encabezados = [
            notacion.texto(\.acorde), notacion.texto(\.notas), notacion.texto(\.numeroDeNotas),
            notacion.texto(\.brilloPorQuintas), notacion.texto(\.vectorIntervalico), notacion.texto(\.numeroDeForte),
            notacion.texto(\.rasgos),
        ]
        let filas = acordes.map { acorde -> [String] in
            let medidas = acorde.estadisticas
            return [
                acorde.nombre(en: notacion),
                acorde.notas(sobre: .do).map { $0.nombre(en: notacion) }.joined(separator: " "),
                "\(medidas.numeroDeNotas)", medidas.brilloPorQuintas.map(PresentacionDeEstudioDeEscala.conSigno) ?? "—",
                "[" + lista(medidas.vectorIntervalico) + "]", medidas.numeroDeForte ?? "—",
                rasgos(medidas, en: notacion).isEmpty ? "—" : rasgos(medidas, en: notacion),
            ]
        }
        return (encabezados, filas)
    }

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

    private static func lista(_ numeros: [Int]) -> String { numeros.map(String.init).joined(separator: ", ") }
}

/// Lo que se mide de un acorde, para `--json`: `EstadisticasDeAcorde` con el cardinal por su nombre y el brillo
/// redondeado a dos decimales.
public struct EstadisticasDeAcordePresentadas: Hashable, Sendable, Codable {
    public let numeroDeNotas: Int
    public let cardinal: String?
    public let porTerceras: Bool
    public let tensiones: Int?
    public let brilloPorQuintas: Double?
    public let amplitudEnQuintas: Int
    public let vectorIntervalico: [Int]
    public let formaPrima: [Int]
    public let numeroDeForte: String?
    public let transposicionesDistintas: Int
    public let simetricoPorInversion: Bool
    public let anhemitonico: Bool
    public let conTritono: Bool
    public let ambito: Int?

    public init(_ medidas: EstadisticasDeAcorde, en notacion: Notacion) {
        numeroDeNotas = medidas.numeroDeNotas
        cardinal = medidas.cardinal?.nombre(en: notacion)
        porTerceras = medidas.porTerceras
        tensiones = medidas.tensiones
        brilloPorQuintas = medidas.brilloPorQuintas.map { ($0 * 100).rounded() / 100 }
        amplitudEnQuintas = medidas.amplitudEnQuintas
        vectorIntervalico = medidas.vectorIntervalico
        formaPrima = medidas.formaPrima
        numeroDeForte = medidas.numeroDeForte
        transposicionesDistintas = medidas.transposicionesDistintas
        simetricoPorInversion = medidas.simetricoPorInversion
        anhemitonico = medidas.anhemitonico
        conTritono = medidas.conTritono
        ambito = medidas.ambito
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
