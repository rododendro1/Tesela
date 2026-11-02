// Lo que comparten las pruebas de varios módulos del motor. No depende de él.

/// Generador pseudoaleatorio con semilla fija (SplitMix64): las pruebas al azar fallan siempre
/// igual y se pueden repetir.
public struct GeneradorConSemilla: RandomNumberGenerator {
    private var estado: UInt64
    public init(semilla: UInt64) { estado = semilla }
    public mutating func next() -> UInt64 {
        estado &+= 0x9E37_79B9_7F4A_7C15
        var z = estado
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}
