import Elementos

/// Por qué no se puede escribir una sucesión de acordes a cuatro voces, o armonizar una melodía: lo que lanzan
/// ``Coral/init(realizando:soprano:en:)``, ``Coral/init(bajoCifrado:en:soprano:)``, ``Armonizacion/coral(soprano:)`` y
/// ``Tonalidad/armonizarACuatroVoces(melodia:)``. Los acordes y las notas se cuentan desde 0, y el mensaje los cuenta
/// desde 1.
///
///     do {
///         let coral = try Coral(realizando: ["Do", "Sol7", "Do"], soprano: ["Do5", "Re5", "Fa5"])
///     } catch let error as ErrorDeRealizacion {
///         error   // .notaAjena(acorde: 2): «La nota del soprano no es del acorde 3.»
///     }
public enum ErrorDeRealizacion: ErrorDeArmonia, Hashable {
    /// No hay acordes, o la melodía está vacía.
    case sinNotas
    /// El soprano no tiene una nota por acorde.
    case sopranoDeOtraLongitud(notas: Int, acordes: Int)
    /// La nota del soprano no es del acorde.
    case notaAjena(acorde: Int)
    /// La nota del soprano se sale de su tesitura (Do4–Sol5).
    case sopranoFueraDeTesitura(acorde: Int)
    /// El acorde tiene más de cuatro notas que no pueden faltar (todas salvo la quinta justa).
    case demasiadasNotas(acorde: Int)
    /// El acorde no tiene ninguna disposición a cuatro voces sin faltas.
    case sinDisposicion(acorde: Int)
    /// Ningún acorde de la tonalidad (ni de su modo homónimo) tiene esa nota de la melodía.
    case notaSinAcorde(nota: Int)
    /// Cada acorde se puede escribir, pero no hay manera de pasar de uno al siguiente sin faltas.
    case sinEnlaceSinFaltas
    /// El soprano que se da no tiene las notas de la melodía armonizada.
    case otraMelodia

    public func descripcion(en notacion: Notacion) -> String {
        switch self {
        case .sinNotas: return TextosDePolifonia.en(notacion, \.realizacionSinNotas)
        case .sopranoDeOtraLongitud(let notas, let acordes):
            return TextosDePolifonia.en(notacion) { $0.realizacionSopranoDeOtraLongitud(notas, acordes) }
        case .notaAjena(let acorde): return TextosDePolifonia.en(notacion) { $0.realizacionNotaAjena(acorde + 1) }
        case .sopranoFueraDeTesitura(let acorde):
            return TextosDePolifonia.en(notacion) { $0.realizacionSopranoFueraDeTesitura(acorde + 1) }
        case .demasiadasNotas(let acorde):
            return TextosDePolifonia.en(notacion) { $0.realizacionDemasiadasNotas(acorde + 1) }
        case .sinDisposicion(let acorde):
            return TextosDePolifonia.en(notacion) { $0.realizacionSinDisposicion(acorde + 1) }
        case .notaSinAcorde(let nota): return TextosDePolifonia.en(notacion) { $0.realizacionNotaSinAcorde(nota + 1) }
        case .sinEnlaceSinFaltas: return TextosDePolifonia.en(notacion, \.realizacionSinEnlaceSinFaltas)
        case .otraMelodia: return TextosDePolifonia.en(notacion, \.realizacionOtraMelodia)
        }
    }
}
