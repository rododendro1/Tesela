import Armonia

// MARK: - Lo que separa a dos acordes, a dos escalas o a los acordes de una progresión, escrito

/// Lo que se parecen dos conjuntos de clases de altura (`RelacionEntreConjuntos`), con los nombres de las claves del
/// JSON.
public struct RelacionEntreConjuntosPresentada: Hashable, Sendable, Codable {
    public let distanciaDeFourier: Double
    public let distanciaIntervalica: Double
    public let asimilitudDeMorris: Double
    /// «R0», «R1» o «R2», si se cumple alguna.
    public let relacionDeForte: String?
    public let relacionRp: Bool

    public init(_ relacion: RelacionEntreConjuntos) {
        distanciaDeFourier = relacion.distanciaDeFourier
        distanciaIntervalica = relacion.distanciaIntervalica
        asimilitudDeMorris = relacion.asimilitudDeMorris
        relacionDeForte = relacion.relacionDeForte?.rawValue
        relacionRp = relacion.relacionRp
    }

    /// Un dato por fila: la distancia de Fourier, la interválica, la asimilitud de Morris y las relaciones de Forte
    /// que se cumplen.
    public func datos(en notacion: Notacion) -> [DatoPresentado] {
        var datos = [
            DatoPresentado(
                nombre: notacion.texto(\.distanciaDeFourier),
                valor: Redondeo.texto(distanciaDeFourier)),
            DatoPresentado(
                nombre: notacion.texto(\.distanciaIntervalica),
                valor: Redondeo.texto(distanciaIntervalica)),
            DatoPresentado(
                nombre: notacion.texto(\.asimilitudDeMorris),
                valor: Redondeo.texto(asimilitudDeMorris)),
        ]
        let forte = [relacionDeForte, relacionRp ? "Rp" : nil].compactMap { $0 }
        if !forte.isEmpty {
            datos.append(
                DatoPresentado(nombre: notacion.texto(\.relacionesDeForte), valor: forte.joined(separator: " · ")))
        }
        return datos
    }
}

/// Lo que separa a dos acordes (`RelacionEntreAcordes`), escrito.
///
///     let relacion = RelacionEntreAcordesPresentada(
///         Acorde("Sol7").relacion(con: Acorde("Do")), en: .compacta(.espanol))
///     relacion.distanciaDeLerdahl   // 5
public struct RelacionEntreAcordesPresentada: Hashable, Sendable, Codable {
    /// El cifrado del segundo acorde.
    public let con: String
    public let semitonosMovidos: Int
    public let desplazamientoEuclideo: Double
    public let desplazamientoMaximo: Int
    public let distanciaEnElTonnetz: Int?
    /// La tonalidad en la que se mide la distancia de Lerdahl.
    public let tonalidad: String
    public let distanciaDeLerdahl: Int
    public let conjunto: RelacionEntreConjuntosPresentada

    public init(_ relacion: RelacionEntreAcordes, en notacion: Notacion) {
        con = relacion.destino.cifrado(en: notacion)
        semitonosMovidos = relacion.conduccion.semitonosMovidos
        desplazamientoEuclideo = relacion.conduccion.desplazamientoEuclideo
        desplazamientoMaximo = relacion.conduccion.desplazamientoMaximo
        distanciaEnElTonnetz = relacion.distanciaEnElTonnetz
        tonalidad = relacion.tonalidad.nombre(en: notacion)
        distanciaDeLerdahl = relacion.distanciaDeLerdahl
        conjunto = RelacionEntreConjuntosPresentada(relacion.conjunto)
    }

    /// Un dato por fila: los tres tamaños de Tymoczko, los pasos en el Tonnetz, la distancia de Lerdahl (con su
    /// tonalidad) y lo que se parecen sus contenidos.
    public func datos(en notacion: Notacion) -> [DatoPresentado] {
        let tamanos =
            "\(semitonosMovidos) · " + Redondeo.texto(desplazamientoEuclideo)
            + " · \(desplazamientoMaximo)"
        var datos = [DatoPresentado(nombre: notacion.texto(\.tamanosDeTymoczko), valor: tamanos)]
        if let pasos = distanciaEnElTonnetz {
            datos.append(DatoPresentado(nombre: notacion.texto(\.pasosEnElTonnetz), valor: "\(pasos)"))
        }
        datos.append(
            DatoPresentado(
                nombre: notacion.texto(\.distanciaDeLerdahl) + " (" + tonalidad + ")", valor: "\(distanciaDeLerdahl)"))
        return datos + conjunto.datos(en: notacion)
    }
}

/// Una tonalidad y lo que encaja en ella un acorde según Krumhansl.
public struct AjusteTonalPresentado: Hashable, Sendable, Codable {
    public let tonalidad: String
    public let correlacion: Double
}

/// Un acorde y una tonalidad: cómo encaja en ella (Krumhansl), qué función hace, en qué tonalidades encaja mejor y qué
/// escalas del catálogo lo contienen.
public struct AcordeEnLaTonalidadPresentado: Hashable, Sendable, Codable {
    public let tonalidad: String
    public let ajusteDeKrumhansl: Double
    /// «tónica», «subdominante» o «dominante», si sus notas dicen alguna.
    public let funcionProbable: String?
    /// Las tres tonalidades en las que mejor encaja.
    public let tonalidadesCercanas: [AjusteTonalPresentado]
    /// Cuántas escalas del catálogo, sobre su fundamental, lo contienen.
    public let numeroDeEscalasDelCatalogo: Int
    /// Las ocho primeras, de las que tienen menos notas a evitar a las que más.
    public let escalasDelCatalogo: [String]

    public init(_ acorde: Acorde, en tonalidad: Tonalidad, notacion: Notacion) {
        self.tonalidad = tonalidad.nombre(en: notacion)
        ajusteDeKrumhansl = tonalidad.ajuste(de: acorde)
        funcionProbable = tonalidad.funcionProbable(de: acorde)?.nombre(en: notacion)
        tonalidadesCercanas = acorde.ajustesTonales.prefix(3).map {
            AjusteTonalPresentado(tonalidad: $0.tonalidad.nombre(en: notacion), correlacion: $0.correlacion)
        }
        let escalas = acorde.escalasDelCatalogo
        numeroDeEscalasDelCatalogo = escalas.count
        escalasDelCatalogo = escalas.prefix(8).map { $0.nombre(en: notacion) }
    }

    /// Un dato por fila: el ajuste, la función, las tonalidades cercanas y las escalas del catálogo.
    public func datos(en notacion: Notacion) -> [DatoPresentado] {
        let decimal = { (valor: Double) in Redondeo.texto(valor) }
        var datos = [DatoPresentado(nombre: notacion.texto(\.ajusteDeKrumhansl), valor: decimal(ajusteDeKrumhansl))]
        if let funcionProbable {
            datos.append(DatoPresentado(nombre: notacion.texto(\.funcionProbable), valor: funcionProbable))
        }
        datos.append(
            DatoPresentado(
                nombre: notacion.texto(\.tonalidadesCercanas),
                valor: tonalidadesCercanas.map { $0.tonalidad + " (" + decimal($0.correlacion) + ")" }
                    .joined(separator: " · ")))
        if numeroDeEscalasDelCatalogo > 0 {
            let resto = numeroDeEscalasDelCatalogo > escalasDelCatalogo.count ? ", …" : ""
            datos.append(
                DatoPresentado(
                    nombre: notacion.texto(\.escalasDelCatalogo),
                    valor: "\(numeroDeEscalasDelCatalogo): " + escalasDelCatalogo.joined(separator: ", ") + resto))
        }
        return datos
    }
}

/// Lo que separa a dos escalas (`RelacionEntreEscalas`), escrito.
public struct RelacionEntreEscalasPresentada: Hashable, Sendable, Codable {
    /// El nombre de la segunda escala.
    public let con: String
    public let distanciaEnQuintas: Double
    public let notasQueCambian: Int
    /// Las voces que se mueven en la conducción mínima, como «Fa→Fa♯ (+1)»; `nil` si no se mueve ninguna o si no se
    /// ha podido calcular.
    public let conduccion: String?
    public let semitonosMovidos: Int?
    public let desplazamientoEuclideo: Double?
    public let desplazamientoMaximo: Int?
    public let conjunto: RelacionEntreConjuntosPresentada

    public init(_ relacion: RelacionEntreEscalas, en notacion: Notacion) {
        con = relacion.destino.nombre(en: notacion)
        distanciaEnQuintas = relacion.distanciaEnQuintas
        notasQueCambian = relacion.notasQueCambian
        // Solo las voces que se mueven: las demás se quedan donde están.
        conduccion = relacion.conduccion.flatMap { conduccion in
            let voces = conduccion.vocesQueSeMueven.map {
                $0.texto(en: notacion) + " (" + ($0.semitonos > 0 ? "+" : "−") + "\(abs($0.semitonos)))"
            }
            return voces.isEmpty ? nil : voces.joined(separator: ", ")
        }
        semitonosMovidos = relacion.conduccion?.semitonosMovidos
        desplazamientoEuclideo = relacion.conduccion?.desplazamientoEuclideo
        desplazamientoMaximo = relacion.conduccion?.desplazamientoMaximo
        conjunto = RelacionEntreConjuntosPresentada(relacion.conjunto)
    }

    /// Un dato por fila: la distancia en quintas, las notas que cambian, la conducción mínima con sus tamaños y lo
    /// que se parecen sus contenidos.
    public func datos(en notacion: Notacion) -> [DatoPresentado] {
        var datos = [
            DatoPresentado(
                nombre: notacion.texto(\.distanciaEnQuintas),
                valor: Redondeo.texto(distanciaEnQuintas)),
            DatoPresentado(nombre: notacion.texto(\.notasQueCambian), valor: "\(notasQueCambian)"),
        ]
        if let conduccion {
            datos.append(DatoPresentado(nombre: notacion.texto(\.conduccionMinima), valor: conduccion))
        }
        if let semitonosMovidos, let desplazamientoEuclideo, let desplazamientoMaximo {
            datos.append(
                DatoPresentado(
                    nombre: notacion.texto(\.tamanosDeTymoczko),
                    valor: "\(semitonosMovidos) · " + Redondeo.texto(desplazamientoEuclideo)
                        + " · \(desplazamientoMaximo)"))
        }
        return datos + conjunto.datos(en: notacion)
    }
}

/// Lo que se mide de una progresión (`EstadisticasDeProgresion`), escrito.
///
///     let progresion = EstadisticasDeProgresionPresentadas(
///         Tonalidad(.do).estadisticas(de: [Acorde("Do"), Acorde("Fa"), Acorde("Sol7"), Acorde("Do")]),
///         en: .compacta(.espanol))
///     progresion.funciones   // ["T", "S", "D", "T"]
public struct EstadisticasDeProgresionPresentadas: Hashable, Sendable, Codable {
    public let tonalidad: String
    public let tensionDeLerdahl: [Int]
    public let tensionDesdeLaTonica: [Int]
    public let tensionMedia: Double
    public let movimientos: [Int]
    public let movimientoTotal: Int
    public let movimientoMedio: Double
    /// «T», «S», «D» o «?» si sus notas no dicen ninguna.
    public let funciones: [String]
    public let notasNuevas: [Int]
    public let notasFueraDeLaTonalidad: [Int]
    public let cromatismo: Double

    public init(_ estadisticas: EstadisticasDeProgresion, en notacion: Notacion) {
        tonalidad = estadisticas.tonalidad.nombre(en: notacion)
        tensionDeLerdahl = estadisticas.tensiones.map(\.secuencial)
        tensionDesdeLaTonica = estadisticas.tensiones.map(\.desdeLaTonica)
        tensionMedia = estadisticas.tensionMedia
        movimientos = estadisticas.movimientos
        movimientoTotal = estadisticas.movimientoTotal
        movimientoMedio = estadisticas.movimientoMedio
        funciones = estadisticas.funciones.map { $0?.abreviatura ?? "?" }
        notasNuevas = estadisticas.notasNuevas
        notasFueraDeLaTonalidad = estadisticas.notasFueraDeLaTonalidad
        cromatismo = estadisticas.cromatismo
    }

    /// Un dato por fila, con una cifra por acorde (o por cambio de acorde) en las que van acorde a acorde.
    public func datos(en notacion: Notacion) -> [DatoPresentado] {
        let decimal = { (valor: Double) in Redondeo.texto(valor) }
        func cifras(_ valores: [Int]) -> String { valores.map(String.init).joined(separator: " ") }
        return [
            DatoPresentado(nombre: notacion.texto(\.tensionDeLerdahl), valor: cifras(tensionDeLerdahl)),
            DatoPresentado(nombre: notacion.texto(\.tensionDesdeLaTonica), valor: cifras(tensionDesdeLaTonica)),
            DatoPresentado(nombre: notacion.texto(\.tensionMedia), valor: decimal(tensionMedia)),
            DatoPresentado(
                nombre: notacion.texto(\.movimientoDeLasVoces),
                valor: movimientos.map(String.init).joined(separator: " + ") + " = \(movimientoTotal)"),
            DatoPresentado(nombre: notacion.texto(\.movimientoMedio), valor: decimal(movimientoMedio)),
            DatoPresentado(nombre: notacion.texto(\.funcionesProbables), valor: funciones.joined(separator: " ")),
            DatoPresentado(nombre: notacion.texto(\.notasNuevas), valor: cifras(notasNuevas)),
            DatoPresentado(nombre: notacion.texto(\.notasFueraDeLaTonalidad), valor: cifras(notasFueraDeLaTonalidad)),
            DatoPresentado(nombre: notacion.texto(\.cromatismo), valor: decimal(cromatismo)),
        ]
    }
}
