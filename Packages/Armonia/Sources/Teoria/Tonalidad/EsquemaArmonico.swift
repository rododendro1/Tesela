import Elementos

// Esquemas armónicos: las progresiones del catálogo (`ProgresionConNombre.catalogo`) que se reconocen en cualquier
// tonalidad. Las del jazz y el blues y las secuencias y esquemas del barroco y el galante tienen reglas propias, que
// admiten sus variantes (el ii–V que no resuelve, el turnaround desde el iii, las quintas descendentes de cualquier
// largo, el blues con el IV en el segundo compás…); las demás de tres acordes o más se reconocen por sus grados.

// MARK: - EsquemaArmonico

/// Una progresión del catálogo encontrada en una progresión: cuál es, dónde está y hacia qué tónica va.
///
///     let esquemas = EsquemaArmonico.buscar(en: ["Rem7", "Sol7", "Do7M"])
///     esquemas.map(\.tipo)       // [.iiVI]
///     esquemas[0].tonica         // Do
///     esquemas[0].description    // "ii–V–I (acordes 1 → 3)"
///
/// Se reconocen por el movimiento de las fundamentales y el tipo de los acordes, sin mirar la tonalidad: un
/// ii–V–I secundario (Mim7–La7–Rem7 en Do) cuenta igual, con Re de tónica.
public struct EsquemaArmonico: Hashable, Sendable, CustomStringConvertible {
    /// Los esquemas son las progresiones del catálogo.
    @available(*, deprecated, renamed: "ProgresionConNombre")
    public typealias Tipo = ProgresionConNombre

    /// La progresión del catálogo: `.iiVI`, `.turnaround`, `.andaluza`…
    public let tipo: ProgresionConNombre
    /// Índice, desde 0, del primer acorde del esquema.
    public let inicio: Int
    /// Cuántos acordes ocupa.
    public let longitud: Int
    /// La tónica a la que va (o de la que parte, en el blues, el turnaround, la romanesca, el canon y el monte).
    public let tonica: Nota

    /// Los índices de sus acordes.
    public var indices: Range<Int> { inicio..<(inicio + longitud) }

    /// "ii–V–I (acordes 1 → 3)". Los acordes se cuentan desde 1.
    public var description: String { descripcion(en: .compacta(.espanol)) }

    public func descripcion(en notacion: Notacion) -> String {
        let lugar = TextosDeTeoria.en(notacion) { $0.cadenciaEnLosAcordes("\(inicio + 1) → \(inicio + longitud)") }
        return "\(tipo.nombre(en: notacion)) (\(lugar))"
    }
}

// MARK: - Reconocimiento

extension EsquemaArmonico {
    /// Las progresiones del catálogo que hay en una progresión, en el orden en que empiezan (y, a igualdad, en el
    /// del catálogo). Pueden solaparse: un turnaround lleva dentro un ii–V. Un ii–V no se cuenta si es parte de un
    /// ii–V–I o de un backdoor, ni la romanesca si es el principio del canon de Pachelbel; de las quintas
    /// descendentes se cuenta solo la cadena más larga. Las cadencias de dos acordes no se buscan aquí: las
    /// reconoce `Cadencia.buscar(en:tonalidad:)`, que sabe en qué tonalidad se está.
    ///
    ///     EsquemaArmonico.buscar(en: ["Do7M", "Lam7", "Rem7", "Sol7", "Do7M"]).map(\.tipo)
    ///     // [.turnaround, .quintasDescendentes, .iiVI]
    public static func buscar(en acordes: [Acorde]) -> [EsquemaArmonico] {
        var encontrados: [EsquemaArmonico] = []
        func anotar(_ tipo: ProgresionConNombre, _ inicio: Int, _ longitud: Int, _ tonica: Nota) {
            encontrados.append(EsquemaArmonico(tipo: tipo, inicio: inicio, longitud: longitud, tonica: tonica))
        }
        let n = acordes.count
        func acorde(_ i: Int) -> Acorde? { i < n ? acordes[i] : nil }
        var finDeLasQuintas = 0
        var finDelCanon = 0

        for i in 0..<n {
            let a = acordes[i]
            if let b = acorde(i + 1) {
                let c = acorde(i + 2)
                // Backdoor, ii–V–I y ii–V.
                if let c, esMenor(a), esDominante(b), sube(a, b, 5), esMayor(c) || esMenor(c), sube(b, c, 2) {
                    anotar(.backdoor, i, 3, c.fundamental)
                } else if esMenor(a), esMayor(b), sube(a, b, 5) {
                    if let c, sube(b, c, 5), esMayor(c) || esMenor(c) {
                        anotar(esMenor(c) ? .iiVIMenor : .iiVI, i, 3, c.fundamental)
                    } else {
                        anotar(.iiV, i, 2, b.fundamental + .cuartaJusta)
                    }
                }
            }
            // Turnaround: I–vi–ii–V, i–VI–iiø–V o iii–vi–ii–V, con la V una cuarta por debajo de la tónica.
            if let b = acorde(i + 1), let c = acorde(i + 2), let d = acorde(i + 3), esMayor(d), esMenor(c),
                bajaUnaQuinta(b, c), sube(c, d, 5)
            {
                if esMayor(a), !esDominante(a), sube(a, b, 9) {
                    anotar(.turnaround, i, 4, a.fundamental)
                } else if esMenor(a), sube(a, b, 8) {
                    anotar(.turnaround, i, 4, a.fundamental)
                } else if esMenor(a), sube(a, b, 5) {
                    anotar(.turnaround, i, 4, a.fundamental + .sextaMenor)
                }
            }
            // Blues de 12 compases.
            if i + 12 <= n, esBlues(Array(acordes[i..<(i + 12)])) {
                anotar(esMenor(a) ? .bluesMenor : .blues, i, 12, a.fundamental)
            }
            // Quintas descendentes: la cadena más larga desde aquí, si no está dentro de otra.
            if i >= finDeLasQuintas {
                var fin = i
                while let siguiente = acorde(fin + 1), bajaUnaQuinta(acordes[fin], siguiente) { fin += 1 }
                if fin - i + 1 >= 4 {
                    anotar(.quintasDescendentes, i, fin - i + 1, acordes[fin].fundamental)
                    finDeLasQuintas = fin + 1
                }
            }
            // Canon de Pachelbel y romanesca (en menor, con el VI y el III mayores).
            let canon: [Int] = esMenor(a) ? [0, 7, 8, 3, 5, 0, 5, 7] : [0, 7, 9, 4, 5, 0, 5, 7]
            if i + 8 <= n, fundamentales(acordes[i..<(i + 8)], desde: a) == canon {
                anotar(.pachelbel, i, 8, a.fundamental)
                finDelCanon = i + 8
            } else if i >= finDelCanon, i + 4 <= n,
                fundamentales(acordes[i..<(i + 4)], desde: a) == Array(canon.prefix(4))
            {
                anotar(.romanesca, i, 4, a.fundamental)
            }
            // Monte y fonte: una cadencia (V7–I) y la misma un tono más arriba o más abajo.
            if let b = acorde(i + 1), let c = acorde(i + 2), let d = acorde(i + 3), esDominante(a), esDominante(c),
                sube(a, b, 5), sube(c, d, 5), esMayor(b) || esMenor(b), esMayor(d) || esMenor(d)
            {
                if sube(b, d, 2) || sube(b, d, 1) {
                    anotar(.monte, i, 4, a.fundamental)
                } else if sube(b, d, 10), esMenor(b) {
                    anotar(.fonte, i, 4, d.fundamental)
                }
            }
            // Ponte: dos acordes o más sobre el mismo bajo, uno de ellos su séptima de dominante, que van a la
            // tónica una cuarta por encima.
            if i == 0 || acordes[i - 1].bajo != a.bajo {
                var fin = i
                while let siguiente = acorde(fin + 1), siguiente.bajo == a.bajo { fin += 1 }
                let tramo = acordes[i...fin]
                if fin > i, let resolucion = acorde(fin + 1), sube(acordes[fin], resolucion, 5),
                    tramo.contains(where: { esDominante($0) && $0.fundamental == a.bajo }),
                    tramo.allSatisfy({ $0.fundamental == a.bajo })
                {
                    anotar(.ponte, i, fin - i + 1, resolucion.fundamental)
                }
            }
            // Las demás del catálogo, por sus grados.
            for patron in patrones {
                if let tonica = patron.tonica(en: acordes, desde: i) {
                    anotar(patron.progresion, i, patron.fundamentales.count, tonica)
                }
            }
        }
        // En el orden en que empiezan y, a igualdad, en el del catálogo.
        let orden = Dictionary(
            ProgresionConNombre.catalogo.enumerated().map { ($1, $0) }, uniquingKeysWith: { primero, _ in primero })
        return encontrados.enumerated().sorted { x, y in
            let a = (x.element.inicio, orden[x.element.tipo] ?? 0, x.offset)
            let b = (y.element.inicio, orden[y.element.tipo] ?? 0, y.offset)
            return a < b
        }.map(\.element)
    }

    /// Las progresiones que tienen reglas propias en `buscar(en:)`.
    static let conReglasPropias: Set<ProgresionConNombre> = [
        .iiVI, .iiV, .iiVIMenor, .turnaround, .backdoor, .blues, .bluesMenor, .quintasDescendentes, .romanesca,
        .pachelbel, .monte, .fonte, .ponte,
    ]

    /// Lo que se mira de una progresión del catálogo para reconocerla por sus grados: las fundamentales sobre la del
    /// primer acorde, la calidad de cada tríada y, en los acordes invertidos, el bajo sobre la fundamental.
    struct Patron: Sendable {
        let progresion: ProgresionConNombre
        let fundamentales: [Int]
        let calidades: [CalidadDeTriada]
        let bajos: [Int?]
        /// El primer acorde sobre la tónica.
        let deLaTonica: Int

        init?(_ progresion: ProgresionConNombre) {
            let acordes = progresion.acordes(sobre: .do)
            guard let primero = acordes.first else { return nil }
            func sobre(_ a: Nota, _ b: Nota) -> Int { modulo(b.claseDeAltura - a.claseDeAltura, 12) }
            guard let deLaTonica = acordes.firstIndex(where: { $0.fundamental.claseDeAltura == Nota.do.claseDeAltura })
            else { return nil }
            self.progresion = progresion
            fundamentales = acordes.map { sobre(primero.fundamental, $0.fundamental) }
            calidades = acordes.map(\.tipo.estructura.calidadDeTriada)
            bajos = acordes.map { $0.bajo == $0.fundamental ? nil : sobre($0.fundamental, $0.bajo) }
            self.deLaTonica = deLaTonica
        }

        /// La tónica, si la progresión está en `acordes` desde `inicio`.
        func tonica(en acordes: [Acorde], desde inicio: Int) -> Nota? {
            guard inicio + fundamentales.count <= acordes.count else { return nil }
            let primero = acordes[inicio].fundamental
            for k in fundamentales.indices {
                let acorde = acordes[inicio + k]
                guard modulo(acorde.fundamental.claseDeAltura - primero.claseDeAltura, 12) == fundamentales[k],
                    acorde.tipo.estructura.calidadDeTriada == calidades[k]
                else { return nil }
                if let bajo = bajos[k],
                    modulo(acorde.bajo.claseDeAltura - acorde.fundamental.claseDeAltura, 12) != bajo
                {
                    return nil
                }
            }
            return acordes[inicio + deLaTonica].fundamental
        }
    }

    /// Las de tres acordes o más que no tienen reglas propias, en el orden del catálogo.
    static let patrones: [Patron] = ProgresionConNombre.catalogo.filter {
        $0.grados.count >= 3 && !conReglasPropias.contains($0)
    }.compactMap(Patron.init)

    /// Si doce acordes son un blues de 12 compases: I I I I | IV IV I I | V IV I I, con IV en el segundo compás,
    /// V en el décimo y V en el último como variantes; en menor, también con el ♭VI en el noveno.
    static func esBlues(_ acordes: [Acorde]) -> Bool {
        guard acordes.count == 12, let primero = acordes.first, esMayor(primero) || esMenor(primero) else {
            return false
        }
        // En menor, el noveno compás puede ser el ♭VI (i–iv–♭VI–V–i).
        let noveno: Set<Int> = esMenor(primero) ? [7, 8] : [7]
        let posibles: [Set<Int>] = [[0], [0, 5], [0], [0], [5], [5], [0], [0], noveno, [5, 7], [0], [0, 7]]
        let alturas = fundamentales(acordes[...], desde: primero)
        return zip(alturas, posibles).allSatisfy { $1.contains($0) } && alturas.contains(5) && alturas.contains(7)
    }

    // MARK: Auxiliares

    private static func esMenor(_ acorde: Acorde) -> Bool { acorde.tipo.esMenor }
    private static func esMayor(_ acorde: Acorde) -> Bool { acorde.tipo.estructura.calidadDeTriada == .mayor }

    /// Tríada mayor con séptima menor: Sol7, Sol9, Sol7(♭9)…
    private static func esDominante(_ acorde: Acorde) -> Bool {
        esMayor(acorde) && acorde.tipo.estructura.septima == .septimaMenor
    }

    /// Si la fundamental de `b` está `semitonos` por encima de la de `a` (en clases de altura).
    private static func sube(_ a: Acorde, _ b: Acorde, _ semitonos: Int) -> Bool {
        modulo(b.fundamental.claseDeAltura - a.fundamental.claseDeAltura, 12) == semitonos
    }

    /// Si de `a` a `b` la fundamental sube una cuarta (justa o aumentada, como Fa–Si en Do mayor).
    private static func bajaUnaQuinta(_ a: Acorde, _ b: Acorde) -> Bool {
        a.fundamental.intervalo(hasta: b.fundamental).numeroSimple == 4
            && [5, 6].contains(modulo(b.fundamental.claseDeAltura - a.fundamental.claseDeAltura, 12))
    }

    /// Las fundamentales en semitonos sobre la de `primero`, de 0 a 11.
    private static func fundamentales(_ acordes: ArraySlice<Acorde>, desde primero: Acorde) -> [Int] {
        acordes.map { modulo($0.fundamental.claseDeAltura - primero.fundamental.claseDeAltura, 12) }
    }
}
