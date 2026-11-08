import Elementos

// Esquemas armónicos: las progresiones hechas que se reconocen en cualquier tonalidad. Las del jazz (ii–V–I,
// turnaround, backdoor, blues de 12 compases) y las secuencias y esquemas del barroco y el galante (quintas
// descendentes, romanesca, canon de Pachelbel, monte, fonte y ponte).

// MARK: - EsquemaArmonico

/// Un esquema armónico encontrado en una progresión: qué es, dónde está y hacia qué tónica va.
///
///     let esquemas = EsquemaArmonico.buscar(en: ["Rem7", "Sol7", "Do7M"])
///     esquemas.map(\.tipo)       // [.iiVI]
///     esquemas[0].tonica         // Do
///     esquemas[0].description    // "ii–V–I (acordes 1 → 3)"
///
/// Se reconocen por el movimiento de las fundamentales y el tipo de los acordes, sin mirar la tonalidad: un
/// ii–V–I secundario (Mim7–La7–Rem7 en Do) cuenta igual, con Re de tónica.
public struct EsquemaArmonico: Hashable, Sendable, CustomStringConvertible {
    /// Los esquemas que se reconocen.
    public enum Tipo: Hashable, Sendable, CaseIterable, CustomStringConvertible {
        /// Un acorde menor (m7 o ø7), su dominante una cuarta por encima y la resolución otra cuarta por
        /// encima: Rem7–Sol7–Do7M, Siø7–Mi7–Lam.
        case iiVI
        /// Un ii–V que no resuelve en su tónica.
        case iiV
        /// I–vi–ii–V (o iii–vi–ii–V; en menor, i–VI–iiø–V), que vuelve al principio: Do7M–Lam7–Rem7–Sol7.
        case turnaround
        /// La dominante por la puerta de atrás: iv7–♭VII7–I (Fam7–Si♭7–Do7M), un ii–V que resuelve un tono más
        /// arriba.
        case backdoor
        /// El blues de 12 compases, un acorde por compás: I I I I | IV IV I I | V IV I I, con el IV en el
        /// segundo compás y el V en el décimo o el último si se quiere.
        case blues
        /// Una cadena de cuatro acordes o más cuyas fundamentales suben una cuarta (bajan una quinta), justa o
        /// aumentada: Do–Fa–Si°–Mi–Lam–Rem–Sol–Do.
        case quintasDescendentes
        /// Baja una cuarta y sube una segunda, dos veces: I–V–vi–iii (Do–Sol–Lam–Mim; en menor, i–V–VI–III).
        case romanesca
        /// El canon de Pachelbel: I–V–vi–iii–IV–I–IV–V.
        case pachelbel
        /// Monte: la misma cadencia dos veces, un grado más arriba: V7/IV–IV–V7/V–V (Do7–Fa–Re7–Sol).
        case monte
        /// Fonte: la misma cadencia dos veces, un grado más abajo, la primera en menor: V7/ii–ii–V7–I
        /// (La7–Rem–Sol7–Do).
        case fonte
        /// Ponte: la dominante que se mantiene sobre su bajo (V–V7) antes de ir a la tónica: Sol–Sol7–Do.
        case ponte

        public var description: String { nombre }
    }

    public let tipo: Tipo
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

extension EsquemaArmonico.Tipo: Nombrable {
    /// «ii–V–I», «turnaround», «blues de 12 compases», «romanesca»…; «12-bar blues», «Pachelbel's canon»…
    public func nombre(en notacion: Notacion) -> String {
        TextosDeTeoria.en(notacion, \.nombresDeEsquemas)[EsquemaArmonico.Tipo.allCases.firstIndex(of: self)!]
    }
}

// MARK: - Reconocimiento

extension EsquemaArmonico {
    /// Los esquemas de una progresión, en el orden en que empiezan (y, a igualdad, en el de `Tipo`). Pueden
    /// solaparse: un turnaround lleva dentro un ii–V. Un ii–V no se cuenta si es parte de un ii–V–I o de un
    /// backdoor, ni la romanesca si es el principio del canon de Pachelbel; de las quintas descendentes se
    /// cuenta solo la cadena más larga.
    ///
    ///     EsquemaArmonico.buscar(en: ["Do7M", "Lam7", "Rem7", "Sol7", "Do7M"]).map(\.tipo)
    ///     // [.turnaround, .quintasDescendentes, .iiVI]
    public static func buscar(en acordes: [Acorde]) -> [EsquemaArmonico] {
        var encontrados: [EsquemaArmonico] = []
        func anotar(_ tipo: Tipo, _ inicio: Int, _ longitud: Int, _ tonica: Nota) {
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
                        anotar(.iiVI, i, 3, c.fundamental)
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
                anotar(.blues, i, 12, a.fundamental)
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
        }
        return encontrados
    }

    /// Si doce acordes son un blues de 12 compases: I I I I | IV IV I I | V IV I I, con IV en el segundo compás,
    /// V en el décimo y V en el último como variantes.
    static func esBlues(_ acordes: [Acorde]) -> Bool {
        guard acordes.count == 12, let primero = acordes.first, esMayor(primero) || esMenor(primero) else {
            return false
        }
        let posibles: [Set<Int>] = [[0], [0, 5], [0], [0], [5], [5], [0], [0], [7], [5, 7], [0], [0, 7]]
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

// MARK: - Generación

extension EsquemaArmonico.Tipo {
    /// El esquema escrito en una tonalidad, con los acordes de la tonalidad (en menor, la V mayor) y las
    /// séptimas que lleva en el jazz.
    ///
    ///     EsquemaArmonico.Tipo.iiVI.acordes(en: Tonalidad(.do))          // [Rem7, Sol7, Domaj7]
    ///     EsquemaArmonico.Tipo.pachelbel.acordes(en: Tonalidad(.re))     // [Re, La, Sim, Fa♯m, Sol, Re, Sol, La]
    public func acordes(en tonalidad: Tonalidad) -> [Acorde] {
        let t = tonalidad.tonica
        let mayor = tonalidad.modo == .mayor
        func grado(_ n: Int, _ cuatriada: Bool = false) -> Acorde { tonalidad.acorde(grado: n, cuatriada: cuatriada) }
        func dominanteDe(_ nota: Nota) -> Acorde { Acorde(nota + .quintaJusta, .dominanteSeptima) }
        let tonica = Acorde(t, mayor ? .mayorSeptimaMayor : .menorSeptima)
        let ii = Acorde(t + .segundaMayor, mayor ? .menorSeptima : .semidisminuido)
        let v7 = dominanteDe(t)
        switch self {
        case .iiVI:
            return [ii, v7, tonica]
        case .iiV:
            return [ii, v7]
        case .turnaround:
            return [tonica, grado(6, true), ii, v7]
        case .backdoor:
            return [Acorde(t + .cuartaJusta, .menorSeptima), Acorde(t + .septimaMenor, .dominanteSeptima), tonica]
        case .blues:
            let tipo: TipoDeAcorde = mayor ? .dominanteSeptima : .menorSeptima
            let i = Acorde(t, tipo)
            let iv = Acorde(t + .cuartaJusta, tipo)
            return [i, i, i, i, iv, iv, i, i, v7, iv, i, v7]
        case .quintasDescendentes:
            // En menor, con el VII natural (Sol en La menor): la sensible no baja una quinta.
            let vii = mayor ? grado(7) : tonalidad.escala.acorde(grado: 7) ?? grado(7)
            return [1, 4, 7, 3, 6, 2, 5, 1].map { $0 == 7 ? vii : grado($0) }
        case .romanesca:
            return [1, 5, 6, 3].map { grado($0) }
        case .pachelbel:
            return [1, 5, 6, 3, 4, 1, 4, 5].map { grado($0) }
        case .monte:
            let iv = grado(4)
            let v = grado(5)
            return [dominanteDe(iv.fundamental), iv, dominanteDe(v.fundamental), v]
        case .fonte:
            let supertonica = Acorde(t + .segundaMayor, .menor)
            return [dominanteDe(supertonica.fundamental), supertonica, v7, grado(1)]
        case .ponte:
            return [grado(5), v7, grado(1)]
        }
    }
}
