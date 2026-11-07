import Elementos
import Teoria

// Contrapunto de especies a tres y cuatro voces (Fux, Gradus ad Parnassum, libro II): un cantus firmus en redondas
// y dos o tres voces más, cada una de su especie. Cada voz cumple con el cantus las reglas de dos voces
// (`Contrapunto`), con lo que cambia al haber más:
//
// - El principio y el final se miden desde el bajo (la voz más grave que suena): cada voz forma con él una
//   consonancia perfecta o una tercera.
// - Una cuarta, o una quinta disminuida o una cuarta aumentada, entre dos voces que no son el bajo es consonante.
// - Las quintas y las octavas directas solo cuentan entre las voces extremas (la más aguda y la más grave).
// - El bajo puede llegar a la última nota saltando; las demás voces, por grado conjunto.
// - Entre cada par de voces, también entre las que se añaden: ni quintas ni octavas paralelas, ni unísonos en parte
//   fuerte (salvo en el primer compás y en el último), ni disonancias en parte fuerte, ni cruces.

/// Una falta de un contrapunto a varias voces y las voces que la cometen.
public struct FaltaEntreVoces: Hashable, Sendable, CustomStringConvertible {
    public let falta: FaltaDeContrapunto
    /// 0 es el cantus firmus; 1, 2… las demás voces, en el orden de `ContrapuntoAVariasVoces.voces`.
    public let voces: [Int]

    /// Una falta entre esas voces (contadas desde 0, de la más grave a la más aguda), que se guardan ordenadas.
    public init(falta: FaltaDeContrapunto, voces: [Int]) {
        self.falta = falta
        self.voces = voces.sorted()
    }

    public var description: String { falta.description }
}

/// Un contrapunto de especies a tres o más voces: un cantus firmus y varias voces, cada una de su especie.
///
///     let ejercicio = try ContrapuntoAVariasVoces(
///         cantusFirmus: "Re4 Fa4 Mi4 Re4",
///         voces: [("La4 La4 Sol4 La4", .primera), ("Re3 Re3 Do3 Re3", .primera)])
///     ejercicio.faltas.map(\.falta.tipo)   // las faltas de cada voz con el cantus y entre ellas
public struct ContrapuntoAVariasVoces: Hashable, Sendable {
    public let cantusFirmus: [Altura]
    /// Cada voz que se añade, con su especie, contra el cantus.
    public let voces: [Contrapunto]

    /// Lanza el error de `Contrapunto(cantusFirmus:contrapunto:especie:)` si alguna voz no dura una redonda por
    /// cada nota del cantus, y `ErrorDeLectura` (`.textoVacio`) si no hay ninguna voz.
    public init(cantusFirmus: [Altura], voces: [(eventos: [Evento], especie: Contrapunto.Especie)]) throws {
        let leidas = try voces.map {
            try Contrapunto(cantusFirmus: cantusFirmus, contrapunto: $0.eventos, especie: $0.especie)
        }
        guard !leidas.isEmpty else { throw ErrorDeLectura(texto: "", posicion: nil, motivo: .textoVacio) }
        self.cantusFirmus = cantusFirmus
        self.voces = leidas
    }

    /// Lee el cantus y cada voz como `Contrapunto(cantusFirmus:contrapunto:especie:)`.
    public init(cantusFirmus: String, voces: [(contrapunto: String, especie: Contrapunto.Especie)]) throws {
        let leidas = try voces.map {
            try Contrapunto(cantusFirmus: cantusFirmus, contrapunto: $0.contrapunto, especie: $0.especie)
        }
        guard let primera = leidas.first else {
            throw ErrorDeLectura(texto: "", posicion: nil, motivo: .textoVacio)
        }
        self.cantusFirmus = primera.cantusFirmus
        self.voces = leidas
    }

    /// `true` si no hay ninguna falta.
    public var esCorrecto: Bool { faltas.isEmpty }

    // MARK: Las voces en el tiempo

    /// Una nota de una voz: cuándo empieza (en redondas desde el principio; un compás por redonda), su altura y si se
    /// ataca o viene ligada.
    private struct NotaDeLaVoz {
        let momento: Duracion
        let nota: Altura
        let ataque: Bool
    }

    /// Las notas de cada voz: el cantus en la 0 y las demás después.
    private var lineas: [[NotaDeLaVoz]] {
        let cantus = cantusFirmus.enumerated().map {
            NotaDeLaVoz(momento: Duracion($0.offset), nota: $0.element, ataque: true)
        }
        return [cantus]
            + voces.map { voz in
                voz.sonoridades.map {
                    NotaDeLaVoz(momento: Duracion($0.compas) + $0.inicio, nota: $0.nota, ataque: $0.ataque)
                }
            }
    }

    // MARK: Faltas

    /// Las faltas, ordenadas por compás.
    public var faltas: [FaltaEntreVoces] {
        let lineas = self.lineas
        let ultimo = cantusFirmus.count - 1
        var faltas: [FaltaEntreVoces] = []
        func anotar(_ tipo: FaltaDeContrapunto.Tipo, _ desde: Int, _ hasta: Int?, _ voces: [Int]) {
            let falta = FaltaDeContrapunto(tipo: tipo, compases: desde...(hasta ?? desde))
            let entreVoces = FaltaEntreVoces(falta: falta, voces: voces)
            if !faltas.contains(entreVoces) { faltas.append(entreVoces) }
        }
        /// La nota que suena en la voz `v` en un momento, si suena alguna.
        func suena(_ v: Int, _ momento: Duracion) -> NotaDeLaVoz? { lineas[v].last { $0.momento <= momento } }
        /// El compás de un momento.
        func compas(_ momento: Duracion) -> Int { momento.numerador / momento.denominador }
        /// La voz que va más grave en un momento, de las que suenan.
        func bajo(_ momento: Duracion) -> Int? {
            let suenan = lineas.indices.compactMap { v in suena(v, momento).map { (v, $0.nota.midi) } }
            return suenan.min { $0.1 < $1.1 }?.0
        }
        // Las voces de la más aguda a la más grave, por su altura media.
        let medias = lineas.map { linea in
            linea.isEmpty ? 0 : Double(linea.map(\.nota.midi).reduce(0, +)) / Double(linea.count)
        }
        let porAltura = lineas.indices.sorted { medias[$0] > medias[$1] }
        let extremas: Set<Int> = [porAltura.first ?? 0, porAltura.last ?? 0]
        let momentos = Set(lineas.flatMap { $0.filter(\.ataque).map(\.momento) }).sorted()

        // Cada voz con el cantus: las reglas de dos voces, salvo lo que cambia con más voces.
        let propiasDeDosVoces: Set<FaltaDeContrapunto.Tipo> = [.comienzoImperfecto, .finalImperfecto, .cruceDeVoces]
        for (indice, voz) in voces.enumerated() {
            let linea = indice + 1
            for falta in voz.faltas where !propiasDeDosVoces.contains(falta.tipo) {
                let primerCompas = falta.compases.lowerBound
                switch falta.tipo {
                case .quintasDirectas, .octavasDirectas:
                    guard extremas == [0, linea] else { continue }
                case .finalSinGradoConjunto:
                    // El bajo puede llegar al final saltando (de la dominante a la tónica).
                    guard bajo(Duracion(ultimo)) != linea else { continue }
                case .disonanciaEnParteFuerte:
                    // Una cuarta sobre el cantus no es disonancia si el cantus no es el bajo.
                    let grave = bajo(Duracion(primerCompas))
                    if let nota = suena(linea, Duracion(primerCompas)), grave != 0, grave != linea,
                        Self.consonanteEntreVocesAltas(intervalo(nota.nota, cantusFirmus[primerCompas]))
                    {
                        continue
                    }
                default:
                    break
                }
                anotar(falta.tipo, primerCompas, falta.compases.upperBound, [0, linea])
            }
        }

        // El principio y el final, desde el bajo.
        let extremos: [(Duracion, FaltaDeContrapunto.Tipo)] = [
            (.cero, .comienzoImperfecto), (Duracion(ultimo), .finalImperfecto),
        ]
        for (momento, tipo) in extremos {
            guard let grave = bajo(momento), let notaGrave = suena(grave, momento) else { continue }
            for v in lineas.indices where v != grave {
                guard let nota = suena(v, momento) else { continue }
                let i = intervalo(notaGrave.nota, nota.nota)
                let tercera = i.numeroSimple == 3 && (i.calidad == .mayor || i.calidad == .menor)
                if Contrapunto.perfecta(i) == nil && !tercera { anotar(tipo, compas(momento), nil, [grave, v]) }
            }
        }

        // Cada par de voces.
        for a in lineas.indices {
            for b in lineas.indices where b > a {
                // Los momentos en que atacan las dos a la vez.
                let comunes = momentos.compactMap { momento -> (momento: Duracion, x: Altura, y: Altura)? in
                    guard let x = suena(a, momento), x.ataque, x.momento == momento,
                        let y = suena(b, momento), y.ataque, y.momento == momento
                    else { return nil }
                    return (momento, x.nota, y.nota)
                }
                // Con el cantus, las paralelas, los unísonos y las disonancias ya los cuenta cada voz.
                if a != 0 {
                    for (antes, despues) in zip(comunes, comunes.dropFirst())
                    where antes.x != despues.x && antes.y != despues.y {
                        guard let perfecta = Contrapunto.perfecta(intervalo(antes.x, antes.y)),
                            perfecta == Contrapunto.perfecta(intervalo(despues.x, despues.y))
                        else { continue }
                        let tipo: FaltaDeContrapunto.Tipo = perfecta == 5 ? .quintasParalelas : .octavasParalelas
                        anotar(tipo, compas(antes.momento), compas(despues.momento), [a, b])
                    }
                    for comun in comunes where comun.momento.denominador == 1 {
                        let c = compas(comun.momento)
                        let i = intervalo(comun.x, comun.y)
                        if i.numero == 1 && i.calidad == .justa && c != 0 && c != ultimo {
                            anotar(.unisono, c, nil, [a, b])
                        }
                        let grave = bajo(comun.momento)
                        let conElBajo = grave == a || grave == b
                        let consonante =
                            !Contrapunto.esDisonancia(i) || (!conElBajo && Self.consonanteEntreVocesAltas(i))
                        if !consonante { anotar(.disonanciaEnParteFuerte, c, nil, [a, b]) }
                    }
                }
                // Los cruces: la que va de media más aguda no pasa por debajo de la otra.
                let (alta, baja) = medias[a] >= medias[b] ? (a, b) : (b, a)
                for momento in momentos {
                    guard let x = suena(alta, momento), let y = suena(baja, momento), x.nota.midi < y.nota.midi
                    else { continue }
                    anotar(.cruceDeVoces, compas(momento), nil, [a, b])
                }
            }
        }
        func orden(_ f: FaltaEntreVoces) -> (Int, Int, Int, Int) {
            (f.falta.compases.lowerBound, f.falta.compases.upperBound, f.voces.first ?? 0, f.voces.last ?? 0)
        }
        return faltas.sorted { orden($0) < orden($1) }
    }

    /// El intervalo entre dos alturas, del grave al agudo.
    private func intervalo(_ a: Altura, _ b: Altura) -> Intervalo {
        a.midi <= b.midi ? a.intervalo(hasta: b) : b.intervalo(hasta: a)
    }

    /// La cuarta justa, la cuarta aumentada y la quinta disminuida, que entre dos voces que no son el bajo son
    /// consonantes (en un acorde de sexta).
    private static func consonanteEntreVocesAltas(_ intervalo: Intervalo) -> Bool {
        switch (intervalo.numeroSimple, intervalo.calidad) {
        case (4, .justa), (4, .aumentada), (5, .disminuida): return true
        default: return false
        }
    }
}
