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
    /// contiene, la tensión y la modalidad de Cook y la rugosidad. Con `sobre`, las fundamentales se escriben como
    /// notas sobre esa; sin ella, como intervalos desde la nota de referencia.
    ///
    ///     let datos = PresentacionDeEstadisticasDeAcorde.estadisticas(
    ///         TipoDeAcorde.dominanteSeptima.estadisticas, en: .compacta(.espanol))
    ///     datos.map(\.valor)   // ["4 (tétrada)", "0", "+0.75", "6", "[0, 1, 2, 1, 1, 1]", "(0, 2, 5, 8)", "4-27",
    ///                          //  "12", "anhemitónico (sin semitonos) · con tritono"]
    public static func estadisticas(
        _ estadisticas: EstadisticasDeAcorde, sobre: Nota? = nil, en notacion: Notacion
    ) -> [DatoPresentado] {
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
        func nota(_ intervalo: Intervalo) -> String {
            sobre.map { ($0 + intervalo).nombre(en: notacion) } ?? intervalo.abreviatura(en: notacion)
        }
        datos.append(dato(\.consonanciaDiadica, decimal(estadisticas.consonanciaDiadica)))
        datos.append(dato(\.grupoDeHindemith, estadisticas.grupoDeHindemith.description))
        if let fundamental = estadisticas.fundamentalDeHindemith {
            datos.append(dato(\.fundamentalDeHindemith, nota(fundamental)))
        }
        if !estadisticas.prominenciasDeParncutt.isEmpty {
            let prominencias = estadisticas.prominenciasDeParncutt.map { nota($0.intervalo) + " (\($0.peso))" }
            datos.append(dato(\.fundamentalDeParncutt, prominencias.joined(separator: " · ")))
        }
        if !estadisticas.intervalosEntreVoces.isEmpty {
            datos.append(
                dato(\.intervalosEntreVoces, estadisticas.intervalosEntreVoces.map(String.init).joined(separator: " ")))
        }
        datos.append(dato(\.gradoDeSuavidad, "\(estadisticas.gradoDeSuavidad)"))
        datos.append(
            dato(\.coeficientesDeFourier, estadisticas.magnitudesDeFourier.map(decimal).joined(separator: " · ")))
        datos.append(dato(\.distanciaALaUniformidad, decimal(estadisticas.distanciaALaUniformidad)))
        datos.append(dato(\.triadasContenidas, triadas(estadisticas.triadasContenidas)))
        datos.append(dato(\.tensionDeCook, decimal(estadisticas.tensionDeCook)))
        datos.append(dato(\.modalidadDeCook, PresentacionDeEstudioDeEscala.conSigno(estadisticas.modalidadDeCook)))
        datos.append(dato(\.rugosidad, decimal(estadisticas.rugosidad)))
        return datos
    }

    /// Las tríadas que contiene, con los símbolos del cifrado, que no cambian de idioma: «M 1 · m 1 · ° 1 · + 0».
    public static func triadas(_ triadas: TriadasContenidas) -> String {
        "M \(triadas.mayores) · m \(triadas.menores) · ° \(triadas.disminuidas) · + \(triadas.aumentadas)"
    }

    /// «2.22», «0», «0.062»: sin decimales si es entero y con tres como mucho si no.
    static func decimal(_ valor: Double) -> String {
        let redondeado = (valor * 1000).rounded() / 1000
        return redondeado == redondeado.rounded() ? "\(Int(redondeado))" : "\(redondeado)"
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
        let encabezados = [
            notacion.texto(\.acorde), notacion.texto(\.notas), notacion.texto(\.numeroDeNotas),
            notacion.texto(\.brilloPorQuintas), notacion.texto(\.vectorIntervalico), notacion.texto(\.numeroDeForte),
            notacion.texto(\.consonanciaDiadica), notacion.texto(\.grupoDeHindemith), notacion.texto(\.rasgos),
        ]
        let filas = acordes.map { acorde -> [String] in
            let medidas = acorde.estadisticas
            return [
                acorde.nombre(en: notacion),
                acorde.notas(sobre: .do).map { $0.nombre(en: notacion) }.joined(separator: " "),
                "\(medidas.numeroDeNotas)", medidas.brilloPorQuintas.map(PresentacionDeEstudioDeEscala.conSigno) ?? "—",
                "[" + lista(medidas.vectorIntervalico) + "]", medidas.numeroDeForte ?? "—",
                decimal(medidas.consonanciaDiadica), medidas.grupoDeHindemith.description,
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
    public let consonanciaDiadica: Double
    /// Como lo escribe Hindemith: «II b 1».
    public let grupoDeHindemith: String
    /// Las fundamentales, como intervalos desde la nota de referencia («3m»), o, con `sobre`, como notas.
    public let fundamentalDeHindemith: String?
    public let prominenciasDeParncutt: [Prominencia]
    public let intervalosEntreVoces: [Int]
    public let gradoDeSuavidad: Int
    public let magnitudesDeFourier: [Double]
    public let distanciaALaUniformidad: Double
    public let triadasContenidas: TriadasContenidas
    public let tensionDeCook: Double
    public let modalidadDeCook: Double
    public let rugosidad: Double

    /// Una nota con su peso como fundamental en el modelo de Parncutt.
    public struct Prominencia: Hashable, Sendable, Codable {
        public let nota: String
        public let peso: Int
    }

    public init(_ medidas: EstadisticasDeAcorde, sobre: Nota? = nil, en notacion: Notacion) {
        func nota(_ intervalo: Intervalo) -> String {
            sobre.map { ($0 + intervalo).nombre(en: notacion) } ?? intervalo.abreviatura(en: notacion)
        }
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
        consonanciaDiadica = medidas.consonanciaDiadica
        grupoDeHindemith = medidas.grupoDeHindemith.description
        fundamentalDeHindemith = medidas.fundamentalDeHindemith.map(nota)
        prominenciasDeParncutt = medidas.prominenciasDeParncutt.map {
            Prominencia(nota: nota($0.intervalo), peso: $0.peso)
        }
        intervalosEntreVoces = medidas.intervalosEntreVoces
        gradoDeSuavidad = medidas.gradoDeSuavidad
        magnitudesDeFourier = medidas.magnitudesDeFourier
        distanciaALaUniformidad = medidas.distanciaALaUniformidad
        triadasContenidas = medidas.triadasContenidas
        tensionDeCook = medidas.tensionDeCook
        modalidadDeCook = medidas.modalidadDeCook
        rugosidad = medidas.rugosidad
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
