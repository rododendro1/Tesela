import Elementos

// MARK: - Lo que se mide de una progresión

/// Lo que se mide de una progresión en una tonalidad: la tensión de Lerdahl acorde a acorde, cuánto se mueven las
/// voces con la conducción mínima, la función probable de cada acorde y lo cromática que es.
///
///     let progresion = Tonalidad(.do).estadisticas(de: [Acorde("Do"), Acorde("Fa"), Acorde("Sol7"), Acorde("Do")])
///     progresion.movimientos       // [3, 5, 4]
///     progresion.cromatismo        // 0: todas sus notas son de Do mayor
public struct EstadisticasDeProgresion: Hashable, Sendable {
    public let tonalidad: Tonalidad
    public let acordes: [Acorde]
    /// La tensión de Lerdahl de cada acorde: desde el anterior y desde la tónica.
    public let tensiones: [TensionDeLerdahl]
    /// Los semitonos que se mueven las voces de cada acorde al siguiente, con la conducción mínima.
    public let movimientos: [Int]
    /// La función probable de cada acorde (``Tonalidad/funcionProbable(de:)``).
    public let funciones: [FuncionTonal?]
    /// Las notas de cada acorde que no estaban en el anterior (el primero, ninguna).
    public let notasNuevas: [Int]
    /// Las notas de cada acorde que no son de la tonalidad (en menor, el 6.º y el 7.º elevados sí lo son).
    public let notasFueraDeLaTonalidad: [Int]

    /// Los semitonos que se mueven las voces en toda la progresión.
    public var movimientoTotal: Int { movimientos.reduce(0, +) }

    /// Lo que se mueven las voces de media en cada cambio de acorde: cuanto menos, más suave.
    public var movimientoMedio: Double {
        movimientos.isEmpty ? 0 : MedidasDeConjunto.redondear(Double(movimientoTotal) / Double(movimientos.count))
    }

    /// La tensión de Lerdahl media desde el acorde anterior, sin contar el primero.
    public var tensionMedia: Double {
        guard tensiones.count > 1 else { return 0 }
        let suma = tensiones.dropFirst().map(\.secuencial).reduce(0, +)
        return MedidasDeConjunto.redondear(Double(suma) / Double(tensiones.count - 1))
    }

    /// La proporción de las notas de sus acordes que no son de la tonalidad, de 0 a 1.
    public var cromatismo: Double {
        let total = acordes.map { Set($0.notasDesdeElBajo.map(\.claseDeAltura)).count }.reduce(0, +)
        return total == 0
            ? 0 : MedidasDeConjunto.redondear(Double(notasFueraDeLaTonalidad.reduce(0, +)) / Double(total))
    }

    public init(_ acordes: [Acorde], en tonalidad: Tonalidad) {
        self.tonalidad = tonalidad
        self.acordes = acordes
        tensiones = tonalidad.tensionDeLerdahl(acordes)
        movimientos = zip(acordes, acordes.dropFirst()).map { $0.conduccionMinima(hasta: $1).semitonosMovidos }
        funciones = acordes.map { tonalidad.funcionProbable(de: $0) }
        let clases = acordes.map { Set($0.notasDesdeElBajo.map(\.claseDeAltura)) }
        notasNuevas = clases.indices.map { $0 == 0 ? 0 : clases[$0].subtracting(clases[$0 - 1]).count }
        let propias = Set(tonalidad.notasPropias.map(\.claseDeAltura))
        notasFueraDeLaTonalidad = clases.map { $0.subtracting(propias).count }
    }
}

extension Tonalidad {
    /// Lo que se mide de una progresión en esta tonalidad (`EstadisticasDeProgresion`).
    public func estadisticas(de acordes: [Acorde]) -> EstadisticasDeProgresion {
        EstadisticasDeProgresion(acordes, en: self)
    }
}

extension ProgresionConNombre {
    /// Lo que se mide de la progresión realizada en una tonalidad (`EstadisticasDeProgresion`).
    public func estadisticas(en tonalidad: Tonalidad) -> EstadisticasDeProgresion {
        EstadisticasDeProgresion(acordes(en: tonalidad), en: tonalidad)
    }
}
