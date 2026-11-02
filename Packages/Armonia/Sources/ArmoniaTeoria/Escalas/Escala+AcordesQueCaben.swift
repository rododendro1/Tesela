import ArmoniaNucleo

// El sentido inverso de la relación escala-acorde: los acordes que caben en una escala, grado a grado, y las
// estructuras superiores (las tríadas de tensiones que se tocan sobre un acorde con esa escala).

extension TipoDeAcorde {
    /// Los tipos que se buscan en una escala: los de ``todos`` (sin el de quinta, que no dice nada de la escala) y,
    /// además, las séptimas de dominante con una tensión alterada (7(♭9), 7(♯9), 7(♯11), 7(♭13)), la séptima mayor
    /// con ♯11, el menor con novena añadida y la sexta menor con novena.
    public static let paraEscalas: [TipoDeAcorde] = {
        let anadidos: [TipoDeAcorde?] = [
            dominanteSeptima.anadir(.novenaMenor), dominanteSeptima.anadir(.novenaAumentada),
            dominanteSeptima.anadir(.undecimaAumentada), dominanteSeptima.anadir(.decimoterceraMenor),
            mayorSeptimaMayor.anadir(.undecimaAumentada), menor.anadir(.novenaMayor),
            menorSexta.anadir(.novenaMayor),
        ]
        var tipos: [TipoDeAcorde] = []
        for tipo in todos.filter({ $0 != .potencia }) + anadidos.compactMap({ $0 }) where !tipos.contains(tipo) {
            tipos.append(tipo)
        }
        return tipos
    }()
}

extension Escala {
    /// Los acordes que caben en la escala sobre un grado (contado desde 1): los de ``TipoDeAcorde/paraEscalas``
    /// con todas sus notas en la escala (aunque se escriban de otra forma), de los de menos notas a los de más.
    /// No solo los de terceras superpuestas: en Do mayor, sobre el 1.º, también Dosus2, Do6, Do6/9 y Do(add9).
    public func acordesQueCaben(grado: Int) -> [Acorde] {
        let raiz = self.grado(grado)
        let acordes = TipoDeAcorde.paraEscalas.map { Acorde(raiz, $0) }.filter { contiene(acorde: $0) }
        return acordes.enumerated().sorted { a, b in
            let (x, y) = (a.element.notas.count, b.element.notas.count)
            return x != y ? x < y : a.offset < b.offset
        }.map(\.element)
    }

    /// ``acordesQueCaben(grado:)`` de cada grado, del 1.º al último.
    public var acordesQueCaben: [[Acorde]] { (1...notas.count).map { acordesQueCaben(grado: $0) } }

    /// Las estructuras superiores de la escala sobre un acorde: las tríadas mayores y menores de la escala, sobre
    /// otra nota que la fundamental, que tienen alguna tensión disponible y ninguna nota a evitar
    /// (``notas(sobre:)``). Primero las que tienen más tensiones: en Do lidio sobre Do7M, Re (9, ♯11 y 13), Sim, Sol
    /// y Lam; en Do mixolidio sobre Do7, Solm y Lam.
    public func estructurasSuperiores(sobre acorde: Acorde) -> [Acorde] {
        let papeles = notas(sobre: acorde)
        func papel(_ nota: Nota) -> PapelEnLaEscala? { papeles.first { $0.nota.esEnarmonica(de: nota) }?.papel }
        var encontradas: [(acorde: Acorde, tensiones: Int)] = []
        for raiz in notas where !raiz.esEnarmonica(de: acorde.fundamental) {
            for tipo in [TipoDeAcorde.mayor, .menor] {
                let triada = Acorde(raiz, tipo)
                let suyos = triada.notas.map(papel)
                guard suyos.allSatisfy({ $0 != nil && $0 != .aEvitar }) else { continue }
                let tensiones = suyos.filter { $0 == .tension }.count
                if tensiones > 0 { encontradas.append((triada, tensiones)) }
            }
        }
        return encontradas.enumerated().sorted { a, b in
            a.element.tensiones != b.element.tensiones ? a.element.tensiones > b.element.tensiones : a.offset < b.offset
        }.map(\.element.acorde)
    }
}
