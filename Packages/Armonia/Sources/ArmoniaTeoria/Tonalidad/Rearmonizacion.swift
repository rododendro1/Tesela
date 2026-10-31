import ArmoniaNucleo

// MARK: - Rearmonizacion

/// Otra forma de armonizar un acorde de una progresión: cambiarlo por otro que cumple la misma función, o
/// prepararlo con su dominante.
///
///     let progresion = [Acorde("Do"), Acorde("Lam"), Acorde("Rem7"), Acorde("Sol7"), Acorde("Do")]
///     let propuestas = Tonalidad(.do).rearmonizaciones(de: progresion)
///     propuestas.first { $0.recurso == .sustitutoTritonal }?.acordes   // [Re♭7]
///
/// Cada propuesta cambia un solo acorde, el de `posicion`, por `acordes` (uno, o dos si lo prepara su
/// dominante); `aplicar(a:)` da la progresión con el cambio.
public struct Rearmonizacion: Hashable, Sendable {
    /// El recurso armónico de la propuesta.
    public enum Recurso: String, CaseIterable, Hashable, Sendable {
        /// Un acorde de séptima de dominante por el que está a un tritono (Sol7 → Re♭7): comparten la tercera
        /// y la séptima, y el bajo baja por semitonos.
        case sustitutoTritonal
        /// El acorde, precedido de su dominante (Lam → Mi7 Lam): la dominante secundaria lo tonifica.
        case dominanteSecundaria
        /// El acorde del mismo grado en el modo homónimo (Fa → Fam en Do mayor, o Sol → Si♭, el ♭VII, en lugar
        /// de la dominante).
        case prestamoModal
        /// Otro acorde de la tonalidad con la misma función, a una tercera (Do → Lam, Fa → Rem, Sol → Si°).
        case sustitutoDiatonico
    }

    public let recurso: Recurso
    /// El índice, desde 0, del acorde que cambia.
    public let posicion: Int
    /// El acorde que había.
    public let original: Acorde
    /// Lo que va en su lugar: uno o dos acordes.
    public let acordes: [Acorde]

    public init(recurso: Recurso, posicion: Int, original: Acorde, acordes: [Acorde]) {
        self.recurso = recurso
        self.posicion = posicion
        self.original = original
        self.acordes = acordes
    }

    /// La progresión con el cambio. Si `posicion` no está en la progresión, la progresión tal cual.
    public func aplicar(a progresion: [Acorde]) -> [Acorde] {
        guard progresion.indices.contains(posicion) else { return progresion }
        var resultado = progresion
        resultado.replaceSubrange(posicion...posicion, with: acordes)
        return resultado
    }

    /// «Sol7 → Re♭7 (sustituto tritonal)».
    public func descripcion(en notacion: Notacion) -> String {
        let nuevos = acordes.map { $0.cifrado(en: notacion) }.joined(separator: " ")
        return "\(original.cifrado(en: notacion)) → \(nuevos) (\(recurso.nombre(en: notacion)))"
    }
}

// MARK: - Propuestas

extension Tonalidad {
    /// Las rearmonizaciones de cada acorde de una progresión, en el orden de los acordes y, en cada uno, en el
    /// de `Rearmonizacion.Recurso`. Un acorde que no es de la tonalidad solo admite el sustituto tritonal (si es
    /// una séptima de dominante) y su dominante secundaria.
    public func rearmonizaciones(de progresion: [Acorde]) -> [Rearmonizacion] {
        progresion.enumerated().flatMap { i, acorde in
            rearmonizaciones(de: acorde, en: i, anterior: i > 0 ? progresion[i - 1] : nil)
        }
    }

    /// Las rearmonizaciones de un acorde: `posicion` es su índice en la progresión y `anterior`, el acorde
    /// que lo precede, si hay alguno (no se propone una dominante que ya está).
    public func rearmonizaciones(
        de acorde: Acorde, en posicion: Int = 0, anterior: Acorde? = nil
    ) -> [Rearmonizacion] {
        var propuestas: [Rearmonizacion] = []
        func proponer(_ recurso: Rearmonizacion.Recurso, _ acordes: [Acorde]) {
            guard acordes != [acorde] else { return }
            propuestas.append(Rearmonizacion(recurso: recurso, posicion: posicion, original: acorde, acordes: acordes))
        }

        // Sustituto tritonal: solo de las séptimas de dominante (con o sin novena).
        let dominantes: [TipoDeAcorde] = [.dominanteSeptima, .dominanteNovena]
        if dominantes.contains(acorde.tipo) {
            proponer(.sustitutoTritonal, [Acorde(Tonalidad.aUnTritono(de: acorde.fundamental), acorde.tipo)])
        }

        // Dominante secundaria: la séptima de dominante una quinta por encima, delante de un acorde mayor o menor
        // con su quinta justa.
        if acorde.tipo.esMayor || acorde.tipo.esMenor, acorde.tipo.pasosDeQuinta.contains(1) {
            let dominante = Acorde(acorde.fundamental + .quintaJusta, .dominanteSeptima)
            let yaEsta = anterior.map { $0.fundamental == dominante.fundamental && $0.tipo.esMayor } ?? false
            if !yaEsta { proponer(.dominanteSecundaria, [dominante, acorde]) }
        }

        // Préstamo modal y sustituto diatónico: solo de los acordes de la tonalidad.
        if let grado = self.grado(de: acorde) {
            let cuatriada = acorde.tipo.tieneSeptima
            let prestado: Acorde
            if modo == .mayor {
                // Del menor natural. La dominante menor suena débil: en su lugar va el ♭VII (Si♭ en Do mayor).
                prestado = homonima.escala.acorde(grado: grado == 5 ? 7 : grado, cuatriada: cuatriada) ?? acorde
            } else {
                prestado = homonima.acorde(grado: grado, cuatriada: cuatriada)
            }
            proponer(.prestamoModal, [prestado])
            let sustituto = [1: 6, 2: 4, 3: 1, 4: 2, 5: 7, 6: 1, 7: 5][grado] ?? grado
            proponer(.sustitutoDiatonico, [self.acorde(grado: sustituto, cuatriada: cuatriada)])
        }
        return propuestas
    }

    /// El grado (desde 1) de un acorde de la tonalidad, en estado fundamental o invertido; `nil` si no es uno
    /// de los suyos.
    func grado(de acorde: Acorde) -> Int? {
        let fundamental = Acorde(acorde.fundamental, acorde.tipo)
        return (1...7).first { grado in
            [false, true].contains { self.acorde(grado: grado, cuatriada: $0) == fundamental }
        }
    }

    /// La nota a un tritono, escrita con menos alteraciones: Sol → Re♭, Re♭ → Sol.
    static func aUnTritono(de nota: Nota) -> Nota {
        let disminuida = nota + .quintaDisminuida
        let aumentada = nota + .cuartaAumentada
        return aumentada.alteracion.numeroDeSignos < disminuida.alteracion.numeroDeSignos ? aumentada : disminuida
    }
}

// MARK: - Idiomas

extension Rearmonizacion.Recurso: Nombrable {
    /// «sustituto tritonal», «tritone substitution», «Zwischendominante»…
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .sustitutoTritonal:
            return TextosDeTeoria.traduccion(\.sustitutoTritonal)
        case .dominanteSecundaria:
            return TextosDeTeoria.traduccion(\.dominanteSecundaria)
        case .prestamoModal:
            return TextosDeTeoria.traduccion(\.prestamoModal)
        case .sustitutoDiatonico:
            return TextosDeTeoria.traduccion(\.sustitutoDiatonico)
        }
    }
}
