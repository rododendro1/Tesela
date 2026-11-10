import Elementos
import Foundation

// Las escalas y sus afinaciones.
//
// Una escala de otra tradición suena con sus microtonos (`AfinacionDeEscala`, de `TipoDeEscala.afinaciones`); una
// escala de doce notas se puede medir en un temperamento histórico (`Escala.cents(en:)`), que depende de la tónica
// cuando el temperamento es circular o justo. Cada tradición sugiere el suyo (`Tradicion.temperamentoSugerido`), y
// cada estilo de una escala occidental, también (`Estilo.temperamentoSugerido`).

// MARK: - Una escala microtonal como afinación

/// Una afinación que hace sonar una escala con sus microtonos: cada nota de la escala se aparta de la temperada lo
/// que dice su versión microtonal, y las demás suenan en temperamento igual.
///
///     let bayati = Escala(.re, .bayati).afinacion()!
///     bayati.desviacion(de: "Mib4")   // 50: el Mi𝄳 de Bayātī
///     bayati.desviacion(de: "Mi4")    // 0: no es de la escala
///
/// Una nota se busca primero por su nombre (Mi♭) y después por su altura (Re♯, la misma tecla), en cualquier octava.
public struct AfinacionDeEscala: SistemaDeAfinacion, Hashable {
    public let escala: Escala
    /// La versión microtonal con que suena: `escala.tipo.microtonal` u otra de `escala.tipo.afinaciones`.
    public let microtonal: TipoDeEscalaMicrotonal
    public let sentido: SentidoDelIntervalo
    public let frecuenciaDelLa4: Double
    private let desvioPorNota: [Nota: Double]
    private let desvioPorClase: [Int: Double]

    /// `nil` si la escala no tiene versión microtonal, o si `microtonal` es de otra escala temperada.
    public init?(
        _ escala: Escala, microtonal: TipoDeEscalaMicrotonal? = nil, sentido: SentidoDelIntervalo = .ascendente,
        frecuenciaDelLa4: Double = 440
    ) {
        guard let microtonal = microtonal ?? escala.tipo.microtonal, microtonal.temperada == escala.tipo else {
            return nil
        }
        self.escala = escala
        self.microtonal = microtonal
        self.sentido = sentido
        self.frecuenciaDelLa4 = frecuenciaDelLa4
        let notas = microtonal.intervalos(sentido: sentido).map { escala.tonica + $0 }
        let desvios = microtonal.desvios(sentido: sentido)
        desvioPorNota = Dictionary(zip(notas, desvios), uniquingKeysWith: { primero, _ in primero })
        desvioPorClase = Dictionary(
            zip(notas.map(\.claseDeAltura), desvios), uniquingKeysWith: { primero, _ in primero })
    }

    /// Cents que se aparta la nota de la temperada: el desvío de su grado, o 0 si no es de la escala.
    public func desvio(de nota: Nota) -> Double {
        desvioPorNota[nota] ?? desvioPorClase[nota.claseDeAltura] ?? 0
    }

    public func frecuencia(de nota: Altura) -> Double {
        nota.frecuencia(frecuenciaDelLa4: frecuenciaDelLa4) * pow(2, desvio(de: nota.nota) / 1200)
    }
}

extension Escala {
    /// La afinación con que suena la escala con sus microtonos (`nil` si su tipo no tiene versión microtonal): la de
    /// `tipo.microtonal`, u otra de `tipo.afinaciones` si se da `microtonal`.
    ///
    ///     Escala(.re, .bayati).afinacion(la4: 442)
    ///     Escala(.re, .echosProtos).afinacion(microtonal: TipoDeEscala.echosProtos.afinaciones[1])   // Chrysanthos
    public func afinacion(
        la4: Double = 440, microtonal: TipoDeEscalaMicrotonal? = nil, sentido: SentidoDelIntervalo = .ascendente
    ) -> AfinacionDeEscala? {
        AfinacionDeEscala(self, microtonal: microtonal, sentido: sentido, frecuenciaDelLa4: la4)
    }

    /// Cents de cada grado desde la tónica en una afinación histórica.
    @available(*, deprecated, message: "Usa cents(con:), con un TemperamentoConNombre")
    public func cents(en afinacion: AfinacionHistorica, sentido: SentidoDelIntervalo = .ascendente) -> [Double] {
        cents(con: afinacion.temperamento, sentido: sentido) ?? []
    }

    /// Cents de cada grado desde la tónica en un temperamento del catálogo, como `TipoDeEscalaMicrotonal.cents`.
    /// Depende de la tónica: en Werckmeister III, Do mayor y Re♭ mayor no miden lo mismo; en la justa, la tónica es
    /// la de la escala. `nil` en los sistemas de otras tradiciones, que no afinan notas.
    ///
    ///     Escala(.do, .mayor).cents(con: .afinacionJusta)          // 0, 203,9, 386,3, 498, 702, 884,4, 1088,3
    ///     Escala(.re, .protusAuthenticus).cents(con: .pitagorico)   // 0, 203,9, 294,1, 498, 702, 905,9, 996,1
    public func cents(
        con temperamento: TemperamentoConNombre, sentido: SentidoDelIntervalo = .ascendente
    ) -> [Double]? {
        guard let afinada = temperamento.afinacion(tonica: tonica) else { return nil }
        let forma = sentido == .ascendente ? self : Escala(tonica, tipo.formaDescendente)
        let alturas = forma.alturas(octava: 4).dropLast()
        guard let primera = alturas.first else { return [] }
        return alturas.map { afinada.cents(desde: primera, hasta: $0) }
    }
}

// MARK: - La afinación de cada tradición

extension Tradicion {
    /// El temperamento histórico que mejor le va a la tradición, para oír sus escalas de doce notas cuando no tienen
    /// versión microtonal: el pitagórico en el canto gregoriano, la Grecia antigua, Mesopotamia y China, que afinan
    /// por quintas puras; la justa en la India, cuyos śruti son razones de 2, 3 y 5; el mesotónico en el
    /// Renacimiento, el de su polifonía. `nil` en las demás, que tienen sus microtonos o no se ajustan a ninguno, y en
    /// la occidental, en la que depende de la escala (`TipoDeEscala.temperamentoSugerido`).
    public var temperamentoSugerido: TemperamentoConNombre? {
        switch self {
        case .gregoriano, .greciaAntigua, .mesopotamia, .china: return .pitagorico
        case .india: return .afinacionJusta
        case .renacimiento: return .mesotonicoCuartoDeComa
        case .occidental, .grecia, .mundoArabe, .persia, .turquia, .azerbaiyan, .japon, .corea, .etiopia, .indonesia,
            .klezmer,
            .andes, .bizancio, .africa, .sudesteAsiatico, .europa, .vietnam, .brasil:
            return nil
        }
    }

    @available(*, deprecated, renamed: "temperamentoSugerido")
    public var afinacionSugerida: AfinacionHistorica? {
        temperamentoSugerido.flatMap { sugerido in AfinacionHistorica.allCases.first { $0.temperamento == sugerido } }
    }
}

extension Estilo {
    /// El temperamento que mejor le va a un estilo occidental: en la música clásica, un buen temperamento
    /// (Werckmeister III), en el que cada tonalidad suena con su color; en los demás, el igual, porque modulan a
    /// cualquier tonalidad o, como las escalas simétricas, lo necesitan para repetirse. `nil` en los de otras
    /// tradiciones, que toman el de su tradición (`Tradicion.temperamentoSugerido`).
    public var temperamentoSugerido: TemperamentoConNombre? {
        switch self {
        case .clasica: return .werckmeisterIII
        case .jazz, .blues, .sigloXX, .popular, .sintetica: return .temperamentoIgual
        case .carnatica, .indostanica, .indiaAntigua, .gagaku: return nil
        }
    }

    @available(*, deprecated, renamed: "temperamentoSugerido")
    public var afinacionSugerida: AfinacionHistorica? {
        temperamentoSugerido.flatMap { sugerido in AfinacionHistorica.allCases.first { $0.temperamento == sugerido } }
    }
}

extension TipoDeEscala {
    /// El temperamento sugerido: el de su tradición (`Tradicion.temperamentoSugerido`); en las occidentales, el
    /// mesotónico en los modos y el hexacordo, los de la polifonía del Renacimiento, y si no, el de su primer estilo
    /// (`Estilo.temperamentoSugerido`). `nil` si no tiene tradición.
    ///
    ///     TipoDeEscala.dorico.temperamentoSugerido         // .mesotonicoCuartoDeComa
    ///     TipoDeEscala.mayor.temperamentoSugerido          // .werckmeisterIII
    ///     TipoDeEscala.tonosEnteros.temperamentoSugerido   // .temperamentoIgual
    public var temperamentoSugerido: TemperamentoConNombre? {
        guard let tradicion else { return nil }
        guard tradicion == .occidental else { return tradicion.temperamentoSugerido }
        if TipoDeEscala.renacentistas.contains(identidad) { return .mesotonicoCuartoDeComa }
        return estilos.first?.temperamentoSugerido
    }

    @available(*, deprecated, renamed: "temperamentoSugerido")
    public var afinacionSugerida: AfinacionHistorica? {
        temperamentoSugerido.flatMap { sugerido in AfinacionHistorica.allCases.first { $0.temperamento == sugerido } }
    }

    /// Los modos de la polifonía del Renacimiento y el hexacordo de la solmisación.
    private static let renacentistas: Set<IdentidadDeEscala> = Set(
        [TipoDeEscala.dorico, .frigio, .lidio, .mixolidio, .hexacordo].map(\.identidad))
}
