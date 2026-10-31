import ArmoniaNucleo

// Cadencias: las parejas de acordes que cierran (o dejan en suspenso) una frase tonal.

// MARK: - Cadencia

/// Dos acordes seguidos que forman una cadencia en una tonalidad.
///
///     let analisis = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do")
///     analisis.cadencias[0].tipo          // .autentica
///     analisis.cadencias[0].description   // "Cadencia auténtica V7–I (acordes 3 → 4)"
///
/// Sin la partitura no se sabe dónde acaban las frases, así que cuenta cada pareja que tenga la
/// forma de una cadencia: V–I es auténtica también en mitad de la progresión. La semicadencia, que
/// es solo llegar a la dominante, se reconoce únicamente al final.
public struct Cadencia: Hashable, Sendable, CustomStringConvertible {
    public enum Tipo: Hashable, Sendable, CaseIterable {
        /// De la dominante (V, V7, vii°, vii°7) a la tónica.
        case autentica
        /// De la subdominante (IV, iv) a la tónica.
        case plagal
        /// De la dominante al VI (vi en mayor, VI en menor, o el ♭VI prestado): rota o evitada.
        case rota
        /// Una frase que termina en la dominante (V en estado fundamental), venga de donde venga.
        case semicadencia
    }

    public let tipo: Tipo
    /// Índice del primer acorde de la pareja (el segundo es `acorde + 1`), contado desde 0.
    public let acorde: Int
    /// La tonalidad en la que se lee la cadencia.
    public let tonalidad: Tonalidad
    /// Los dos acordes leídos en `tonalidad`.
    public let acordes: [AcordeAnalizado]

    /// Auténtica con los dos acordes en estado fundamental y la dominante V (no vii°): la cadencia
    /// perfecta. Las demás auténticas son imperfectas.
    public var esPerfecta: Bool {
        tipo == .autentica && acordes[0].grado == 5 && acordes.allSatisfy { $0.acorde.inversion == 0 }
    }

    /// "Cadencia auténtica V7–I (acordes 3 → 4)". Los acordes se cuentan desde 1.
    public var description: String { descripcion(en: .espanolUnicode) }

    public func descripcion(en notacion: Notacion) -> String {
        let pasos = "\(acorde + 1) → \(acorde + 2)"
        let lugar = TextosDeTeoria.en(notacion) { $0.cadenciaEnLosAcordes(pasos) }
        let nombre = tipo.nombre(en: notacion)
        return nombre.conMayusculaInicial
            + " " + acordes.map(\.cifrado).joined(separator: "–") + " (\(lugar))"
    }

    // MARK: Reconocimiento

    /// El tipo de cadencia que forman dos acordes leídos en la misma tonalidad, si forman alguna.
    /// `final` dice si el segundo es el último de la progresión (solo entonces hay semicadencia).
    package static func tipo(_ primero: AcordeAnalizado, _ segundo: AcordeAnalizado, final: Bool) -> Tipo? {
        if esDominante(primero) && esTonica(segundo) { return .autentica }
        if primero.grado == 4, propio(primero), primero.acorde.tipo.esMayor || primero.acorde.tipo.esMenor,
            esTonica(segundo)
        {
            return .plagal
        }
        if esDominante(primero), primero.grado == 5, segundo.grado == 6, propio(segundo),
            segundo.acorde.tipo.esMayor || segundo.acorde.tipo.esMenor
        {
            return .rota
        }
        if final, segundo.grado == 5, segundo.categoria == .diatonico,
            segundo.acorde.tipo.estructura.calidadDeTriada == .mayor,
            segundo.acorde.inversion == 0, !(primero.grado == 5 && primero.categoria == .diatonico)
        {
            return .semicadencia
        }
        return nil
    }

    /// Las cadencias de una sucesión de acordes leídos en una tonalidad.
    package static func buscar(
        en acordes: [AcordeAnalizado], tonalidad: Tonalidad, desde inicio: Int = 0,
        esFinal: Bool = true
    ) -> [Cadencia] {
        guard acordes.count >= 2 else { return [] }
        return (0..<(acordes.count - 1)).compactMap { i in
            let final = esFinal && i + 2 == acordes.count
            guard let tipo = tipo(acordes[i], acordes[i + 1], final: final) else { return nil }
            return Cadencia(
                tipo: tipo, acorde: inicio + i, tonalidad: tonalidad, acordes: [acordes[i], acordes[i + 1]])
        }
    }

    /// Diatónico o prestado del modo homónimo: sin secundarias ni cromatismos.
    private static func propio(_ analizado: AcordeAnalizado) -> Bool {
        analizado.categoria == .diatonico || analizado.categoria == .prestamo
    }

    /// V o V7 (tríada mayor sobre el 5.º grado), o un acorde de sensible (tríada disminuida sobre el 7.º).
    package static func esDominante(_ analizado: AcordeAnalizado) -> Bool {
        guard analizado.categoria == .diatonico else { return false }
        let calidad = analizado.acorde.tipo.estructura.calidadDeTriada
        return (analizado.grado == 5 && calidad == .mayor) || (analizado.grado == 7 && calidad == .disminuida)
    }

    /// I o i (también con tercera de picardía), que no esté en segunda inversión: el I64 cadencial
    /// va a la dominante, no cierra.
    package static func esTonica(_ analizado: AcordeAnalizado) -> Bool {
        analizado.grado == 1 && propio(analizado) && (analizado.acorde.tipo.esMayor || analizado.acorde.tipo.esMenor)
            && analizado.acorde.inversion != 2
    }
}

extension Cadencia.Tipo: Nombrable, CustomStringConvertible {
    /// "cadencia auténtica", "semicadencia".
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .autentica:
            return TextosDeTeoria.en(notacion, \.cadenciaAutentica)
        case .plagal:
            return TextosDeTeoria.en(notacion, \.cadenciaPlagal)
        case .rota:
            return TextosDeTeoria.en(notacion, \.cadenciaRota)
        case .semicadencia:
            return TextosDeTeoria.en(notacion, \.semicadencia)
        }
    }

    public var description: String { nombre }
}

extension AnalisisArmonico {
    /// Las cadencias de la progresión en su tonalidad, en orden.
    ///
    ///     Tonalidad(.do).analizar(["Do", "Lam", "Fa", "Sol"]).cadencias.map(\.tipo)   // [.semicadencia]
    public var cadencias: [Cadencia] { Cadencia.buscar(en: acordes, tonalidad: tonalidad) }
}
