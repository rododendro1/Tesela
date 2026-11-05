import ArmoniaNucleo
import ArmoniaTeoria
import Foundation

// Las escalas y sus afinaciones.
//
// Una escala de otra tradición suena con sus microtonos (`AfinacionDeEscala`, de `TipoDeEscala.afinaciones`); una
// escala de doce notas se puede medir en un temperamento histórico (`Escala.cents(en:)`), que depende de la tónica
// cuando el temperamento es circular o justo. Cada tradición sugiere el suyo (`Tradicion.afinacionSugerida`).

// MARK: - Una escala microtonal como afinación

/// Una afinación que hace sonar una escala con sus microtonos: cada nota de la escala se aparta de la temperada lo
/// que dice su versión microtonal, y las demás suenan en temperamento igual.
///
///     let bayati = Escala(.re, .bayati).afinacion()!
///     bayati.desviacion(de: "Mib4")   // 50: el Mi𝄳 de Bayātī
///     bayati.desviacion(de: "Mi4")    // 0: no es de la escala
///
/// Una nota se busca primero por su nombre (Mi♭) y después por su altura (Re♯, la misma tecla), en cualquier octava.
public struct AfinacionDeEscala: Afinacion, Hashable {
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

    /// Cents de cada grado desde la tónica en una afinación histórica, como `TipoDeEscalaMicrotonal.cents`. Depende
    /// de la tónica: en Werckmeister III, Do mayor y Re♭ mayor no miden lo mismo; en la justa, la tónica es la de
    /// la escala.
    ///
    ///     Escala(.do, .mayor).cents(en: .justa)                    // 0, 203,9, 386,3, 498, 702, 884,4, 1088,3
    ///     Escala(.re, .protusAuthenticus).cents(en: .pitagorico)   // 0, 203,9, 294,1, 498, 702, 905,9, 996,1
    public func cents(en afinacion: AfinacionHistorica, sentido: SentidoDelIntervalo = .ascendente) -> [Double] {
        let afinada = afinacion.afinacion(tonica: tonica)
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
    /// por quintas puras; la justa en la India, cuyos śruti son razones de 2, 3 y 5. `nil` en las demás, que tienen
    /// sus microtonos o no se ajustan a ninguno.
    public var afinacionSugerida: AfinacionHistorica? {
        switch self {
        case .gregoriano, .greciaAntigua, .mesopotamia, .china: return .pitagorico
        case .india: return .justa
        case .grecia, .mundoArabe, .persia, .turquia, .azerbaiyan, .japon, .corea, .etiopia, .indonesia, .klezmer,
            .andes, .bizancio, .africa, .sudesteAsiatico, .europa, .vietnam, .brasil:
            return nil
        }
    }
}

extension TipoDeEscala {
    /// El temperamento sugerido por su tradición (`Tradicion.afinacionSugerida`); `nil` en las escalas occidentales.
    public var afinacionSugerida: AfinacionHistorica? { tradicion?.afinacionSugerida }
}
