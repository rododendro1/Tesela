import Armonia

// MARK: - Un ritmo del catálogo, escrito

/// Un ritmo del catálogo y lo que se mide de él (`EstadisticasDeRitmo`), con los nombres de las claves del JSON.
///
///     let clave = RitmoPresentado(.claveDeSon, en: .compacta(.espanol))
///     clave.patron     // "x..x..x...x.x..."
///     clave.compas     // "4/4"
///     clave.euclideo   // false
public struct RitmoPresentado: Hashable, Sendable, Codable {
    /// El nombre en la notación: «clave de son», «son clave»…
    public let nombre: String
    public let familia: String
    /// Un carácter por pulso: `x` fuerte, `o` débil, `.` en silencio.
    public let patron: String
    public let agrupacion: [Int]
    /// El compás de un ciclo: «4/4», «2+2+3/8».
    public let compas: String
    public let pulsos: Int
    public let ataques: Int
    public let fuertes: Int
    public let intervalos: [Int]
    public let vectorDeDistancias: [Int]
    public let euclideo: Bool
    public let profundo: Bool
    public let simetriasPorRotacion: Int
    public let uniformidad: Double
    public let contratiempo: Int
    public let sincopa: Double

    public init(_ ritmo: RitmoConNombre, en notacion: Notacion) {
        let estadisticas = ritmo.estadisticas
        nombre = ritmo.nombre(en: notacion)
        familia = ritmo.familia.nombre(en: notacion)
        patron = ritmo.patron
        agrupacion = ritmo.agrupacion
        compas = ritmo.compas.description
        pulsos = estadisticas.pulsos
        ataques = estadisticas.ataques
        fuertes = estadisticas.fuertes
        intervalos = estadisticas.intervalos
        vectorDeDistancias = estadisticas.vectorDeDistancias
        euclideo = estadisticas.euclideo
        profundo = estadisticas.profundo
        simetriasPorRotacion = estadisticas.simetriasPorRotacion
        uniformidad = estadisticas.uniformidad
        contratiempo = estadisticas.contratiempo
        sincopa = estadisticas.sincopa
    }

    /// La ficha, un dato por fila: la familia, el patrón, la agrupación y el compás.
    public func ficha(en notacion: Notacion) -> [DatoPresentado] {
        [
            DatoPresentado(nombre: notacion.texto(\.familiaDeRitmo), valor: familia),
            DatoPresentado(nombre: notacion.texto(\.patronDeRitmo), valor: patron),
            DatoPresentado(
                nombre: notacion.texto(\.agrupacionDeRitmo),
                valor: agrupacion.map(String.init).joined(separator: " + ")),
            DatoPresentado(nombre: notacion.texto(\.compasDeRitmo), valor: compas),
        ]
    }

    /// Lo que se mide, un dato por fila: los pulsos y los golpes, los intervalos, el vector de distancias, las
    /// propiedades, las simetrías, la uniformidad, el contratiempo y la síncopa.
    public func datos(en notacion: Notacion) -> [DatoPresentado] {
        func lista(_ valores: [Int]) -> String { "[" + valores.map(String.init).joined(separator: ", ") + "]" }
        var datos = [
            DatoPresentado(
                nombre: notacion.texto(\.pulsosGolpesYFuertes), valor: "\(pulsos) · \(ataques) · \(fuertes)"),
            DatoPresentado(nombre: notacion.texto(\.intervalosDeRitmo), valor: lista(intervalos)),
            DatoPresentado(nombre: notacion.texto(\.vectorDeDistancias), valor: lista(vectorDeDistancias)),
        ]
        let propiedades = [
            euclideo ? notacion.texto(\.ritmoEuclideo) : nil, profundo ? notacion.texto(\.ritmoProfundo) : nil,
        ].compactMap { $0 }
        if !propiedades.isEmpty {
            datos.append(
                DatoPresentado(nombre: notacion.texto(\.propiedades), valor: propiedades.joined(separator: " · ")))
        }
        datos += [
            DatoPresentado(nombre: notacion.texto(\.simetriasPorRotacion), valor: "\(simetriasPorRotacion)"),
            DatoPresentado(
                nombre: notacion.texto(\.uniformidadDeRitmo),
                valor: PresentacionDeEstadisticasDeAcorde.decimal(uniformidad)),
            DatoPresentado(nombre: notacion.texto(\.contratiempoDeToussaint), valor: "\(contratiempo)"),
            DatoPresentado(
                nombre: notacion.texto(\.sincopaDeRitmo), valor: PresentacionDeEstadisticasDeAcorde.decimal(sincopa)),
        ]
        return datos
    }
}

/// Lo que separa a dos ritmos de los mismos pulsos: las distancias de Hamming y de intercambio de Toussaint.
public struct RelacionEntreRitmosPresentada: Hashable, Sendable, Codable {
    /// El nombre del segundo ritmo.
    public let con: String
    /// `nil` si tienen distintos pulsos.
    public let distanciaDeHamming: Int?
    /// `nil` si tienen distintos pulsos o golpes.
    public let distanciaDeIntercambio: Int?

    public init(_ ritmo: RitmoConNombre, con otro: RitmoConNombre, en notacion: Notacion) {
        con = otro.nombre(en: notacion)
        distanciaDeHamming = ritmo.distanciaDeHamming(a: otro)
        distanciaDeIntercambio = ritmo.distanciaDeIntercambio(a: otro)
    }

    /// Un dato por cada distancia que se puede medir.
    public func datos(en notacion: Notacion) -> [DatoPresentado] {
        var datos: [DatoPresentado] = []
        if let distanciaDeHamming {
            datos.append(DatoPresentado(nombre: notacion.texto(\.distanciaDeHamming), valor: "\(distanciaDeHamming)"))
        }
        if let distanciaDeIntercambio {
            datos.append(
                DatoPresentado(nombre: notacion.texto(\.distanciaDeIntercambio), valor: "\(distanciaDeIntercambio)"))
        }
        return datos
    }
}
