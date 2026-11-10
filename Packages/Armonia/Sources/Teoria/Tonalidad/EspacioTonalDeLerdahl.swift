import Elementos

// MARK: - El espacio tonal de Lerdahl

/// La tensión de un acorde dentro de una progresión, a la manera de Lerdahl (*Tonal Pitch Space*, 2001): la
/// distancia desde el acorde anterior y desde la tónica.
public struct TensionDeLerdahl: Hashable, Sendable, Codable {
    /// La distancia desde el acorde anterior (0 en el primero): la tensión secuencial.
    public let secuencial: Int
    /// La distancia desde la tríada de la tónica: lo lejos que queda el acorde del reposo.
    public let desdeLaTonica: Int
}

extension Tonalidad {
    /// La distancia de Lerdahl de un acorde a otro en esta tonalidad, δ = i + j + k (*Tonal Pitch Space*, cap. 2):
    ///
    /// - **i**, las quintas entre las regiones (las tonalidades en las que cada acorde es diatónico, la más cercana
    ///   a esta si no lo es en ella);
    /// - **j**, las quintas entre sus fundamentales, por el círculo diatónico de la región si las dos están en ella
    ///   y por el cromático si no;
    /// - **k**, las notas nuevas del espacio básico del segundo: la fundamental, la quinta, las notas del acorde y
    ///   la colección diatónica, nivel a nivel.
    ///
    /// Un acorde sin región diatónica (el de séptima disminuida, el aumentado) se mide en esta tonalidad.
    ///
    ///     let doMayor = Tonalidad(.do)
    ///     doMayor.distanciaDeLerdahl(de: Acorde("Do"), a: Acorde("Sol"))    // 5
    ///     doMayor.distanciaDeLerdahl(de: Acorde("Do"), a: Acorde("Rem"))    // 8
    public func distanciaDeLerdahl(de x: Acorde, a y: Acorde) -> Int {
        let regionX = regionDeLerdahl(x)
        let regionY = regionDeLerdahl(y)
        let i = Self.armadurasEntre(regionX.armadura, regionY.armadura)
        let raizX = x.fundamental.claseDeAltura
        let raizY = y.fundamental.claseDeAltura
        // El círculo diatónico de la región del segundo: sus notas por quintas.
        let circulo = regionY.escala.notas.sorted { $0.pasosDeQuinta < $1.pasosDeQuinta }.map(\.claseDeAltura)
        let j: Int
        if let a = circulo.firstIndex(of: raizX), let b = circulo.firstIndex(of: raizY) {
            let d = abs(a - b)
            j = min(d, circulo.count - d)
        } else {
            j = Self.quintasEntre(raizX, raizY)
        }
        let nivelesX = Self.espacioBasico(x, region: regionX)
        let nivelesY = Self.espacioBasico(y, region: regionY)
        let k = zip(nivelesX, nivelesY).map { $1.subtracting($0).count }.reduce(0, +)
        return i + j + k
    }

    /// La tensión de Lerdahl de cada acorde de una progresión en esta tonalidad.
    ///
    ///     Tonalidad(.do).tensionDeLerdahl([Acorde("Do"), Acorde("Fa"), Acorde("Sol"), Acorde("Do")])
    ///         .map(\.secuencial)   // [0, 5, 8, 5]
    public func tensionDeLerdahl(_ acordes: [Acorde]) -> [TensionDeLerdahl] {
        let tonica = acorde(grado: 1)
        return acordes.indices.map { n in
            TensionDeLerdahl(
                secuencial: n == 0 ? 0 : distanciaDeLerdahl(de: acordes[n - 1], a: acordes[n]),
                desdeLaTonica: distanciaDeLerdahl(de: tonica, a: acordes[n]))
        }
    }

    /// La región del acorde: esta tonalidad si sus notas son de ella, y si no la mayor más cercana por quintas
    /// en la que lo son; esta si no hay ninguna.
    func regionDeLerdahl(_ acorde: Acorde) -> Tonalidad {
        let clases = Set(acorde.notasDesdeElBajo.map(\.claseDeAltura))
        if clases.isSubset(of: Set(notasPropias.map(\.claseDeAltura))) { return self }
        let candidatas = Tonalidad.circuloDeQuintas(.mayor).filter {
            clases.isSubset(of: Set($0.escala.notas.map(\.claseDeAltura)))
        }
        return candidatas.min { a, b in
            (Self.armadurasEntre(armadura, a.armadura), abs(a.armadura))
                < (Self.armadurasEntre(armadura, b.armadura), abs(b.armadura))
        } ?? self
    }

    /// Los cuatro niveles del espacio básico que cambian: la fundamental, la fundamental y la quinta, las notas del
    /// acorde y la colección diatónica de su región.
    static func espacioBasico(_ acorde: Acorde, region: Tonalidad) -> [Set<Int>] {
        let raiz = acorde.fundamental.claseDeAltura
        let clases = Set(acorde.notasDesdeElBajo.map(\.claseDeAltura))
        let quinta = modulo(raiz + 7, 12)
        return [
            [raiz], clases.contains(quinta) ? [raiz, quinta] : [raiz], clases,
            Set(region.escala.notas.map(\.claseDeAltura)),
        ]
    }

    /// Las quintas, por el camino más corto del círculo, entre dos armaduras (Do♯ mayor y Re♭ mayor están a 0).
    static func armadurasEntre(_ a: Int, _ b: Int) -> Int {
        let d = modulo(b - a, 12)
        return min(d, 12 - d)
    }

    /// Las quintas, por el camino más corto del círculo, entre dos clases de altura.
    static func quintasEntre(_ a: Int, _ b: Int) -> Int {
        let d = modulo((b - a) * 7, 12)
        return min(d, 12 - d)
    }
}
