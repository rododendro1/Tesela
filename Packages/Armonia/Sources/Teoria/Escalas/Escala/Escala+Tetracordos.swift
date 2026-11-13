import Elementos

// Las divisiones de una escala en tetracordos: cuatro notas seguidas que abarcan una cuarta justa, unidos (el último
// de uno es el primero del siguiente) o separados por un solo grado. La mayor es dos tetracordos tono-tono-semitono
// separados por un tono (Do Re Mi Fa | Sol La Si Do); la dórica, dos tono-semitono-tono. Cada tetracordo lleva los
// nombres de los fragmentos del catálogo que tienen esas cuatro notas: el tetracordo diatónico griego, los ajnas
// árabes y los çeşni turcos.

/// Cuatro grados seguidos de una escala que abarcan una cuarta justa: Do Re Mi Fa en Do mayor.
public struct Tetracordo: Hashable, Sendable {
    /// El grado de la escala por el que empieza, desde 0.
    public let grado: Int
    /// Los intervalos desde su primera nota: unísono, los dos de en medio y la cuarta justa.
    public let intervalos: [Intervalo]

    /// Un tetracordo que empieza en `grado` con esos intervalos.
    public init(grado: Int, intervalos: [Intervalo]) {
        self.grado = grado
        self.intervalos = intervalos
    }

    /// Los fragmentos del catálogo con esas cuatro notas, en el orden del catálogo: para tono-tono-semitono, el
    /// jins ʿAjam y el Çârgâh dörtlüsü; para semitono-tono-tono, el tetracordo diatónico, el jins Kurd y el Kürdî
    /// dörtlüsü. Vacío si ninguno tiene esas notas. Los microtonales no cuentan, porque solo se parecen.
    public var fragmentos: [TipoDeEscala] {
        TipoDeEscala.fragmentosDeCuarta.filter { $0.cuatroPrimeras == intervalos }.map(\.tipo)
    }

    /// Las notas del tetracordo desde su primera nota.
    public func notas(desde primera: Nota) -> [Nota] { intervalos.map { primera + $0 } }
}

/// Una forma de partir una octava de escala en tetracordos y grados sueltos, de grave a agudo.
public struct DivisionEnTetracordos: Hashable, Sendable {
    /// Un trozo de la división: un tetracordo o el paso de un grado al siguiente que separa dos.
    public enum Pieza: Hashable, Sendable {
        case tetracordo(Tetracordo)
        /// El intervalo entre dos grados seguidos que no está en ningún tetracordo, desde el grado `desde`.
        case separacion(desde: Int, Intervalo)
    }

    public let piezas: [Pieza]

    /// Los tetracordos de la división, de grave a agudo.
    public var tetracordos: [Tetracordo] {
        piezas.compactMap { pieza in
            guard case .tetracordo(let tetracordo) = pieza else { return nil }
            return tetracordo
        }
    }

    /// ¿Están separados (disjuntos) los dos tetracordos, con un grado suelto entre ellos?
    public var esDisjunta: Bool {
        guard let primera = piezas.first, let ultima = piezas.last, case .tetracordo = primera,
            case .tetracordo = ultima
        else { return false }
        return piezas.count > 2
    }
}

extension TipoDeEscala {
    /// Un fragmento del catálogo y sus intervalos hasta la cuarta justa.
    struct FragmentoDeCuarta: Sendable {
        let tipo: TipoDeEscala
        let cuatroPrimeras: [Intervalo]
    }

    /// Los tetracordos, ajnas y çeşni temperados del catálogo que llegan a la cuarta justa en su cuarta nota. Un
    /// pentacordo cuenta por sus cuatro primeras notas solo si su tradición no tiene un tetracordo con ellas: el jins
    /// ʿAjam, que no lo tiene, sí; el Çârgâh beşlisi, que tiene el Çârgâh dörtlüsü, no.
    static let fragmentosDeCuarta: [FragmentoDeCuarta] = {
        let categorias: Set<CategoriaTradicional> = [.tetracordo, .jins, .cesni]
        let candidatos = tradicionales.filter { tipo in
            guard let categoria = tipo.categoria, categorias.contains(categoria) else { return false }
            return tipo.afinacionPropia == nil && tipo.intervalos.count >= 4 && tipo.intervalos[3] == .cuartaJusta
        }
        return candidatos.compactMap { tipo in
            let cuatro = Array(tipo.intervalos.prefix(4))
            let tieneTetracordo = candidatos.contains {
                $0.intervalos.count == 4 && $0.intervalos == cuatro && $0.tradicion == tipo.tradicion
            }
            guard tipo.intervalos.count == 4 || !tieneTetracordo else { return nil }
            return FragmentoDeCuarta(tipo: tipo, cuatroPrimeras: cuatro)
        }
    }()

    /// Las formas de partir la octava (subiendo) en dos tetracordos y los grados sueltos que quedan, cada uno de un
    /// solo paso. Primero las disjuntas, con el grado suelto en medio (Do Re Mi Fa | Sol La Si Do en la mayor); luego
    /// las que lo tienen arriba y luego abajo. Vacío si no hay ninguna: en las pentatónicas, por ejemplo, no caben
    /// cuatro notas en una cuarta.
    ///
    ///     TipoDeEscala.mayor.divisionesEnTetracordos.first?.tetracordos.map(\.grado)   // [0, 4]
    public var divisionesEnTetracordos: [DivisionEnTetracordos] {
        let n = intervalos.count
        guard n >= 7 else { return [] }
        let quintas = intervalos.map(\.pasosDeQuintaConSigno)
        // El intervalo del grado `i` al `j` (`j` puede ser `n`, la octava de la tónica).
        func intervalo(_ i: Int, _ j: Int) -> Intervalo {
            Intervalo.simpleAscendente(pasosDeQuinta: quintas[j % n] - quintas[i])
        }
        func tetracordo(en i: Int) -> Tetracordo? {
            guard i + 3 <= n, intervalo(i, i + 3) == .cuartaJusta else { return nil }
            return Tetracordo(grado: i, intervalos: [.unisono] + (1...3).map { intervalo(i, i + $0) })
        }
        var divisiones: [DivisionEnTetracordos] = []
        func seguir(desde i: Int, _ piezas: [DivisionEnTetracordos.Pieza], tetracordos: Int) {
            if i == n {
                if tetracordos == 2 { divisiones.append(DivisionEnTetracordos(piezas: piezas)) }
                return
            }
            if tetracordos < 2, let t = tetracordo(en: i) {
                seguir(desde: i + 3, piezas + [.tetracordo(t)], tetracordos: tetracordos + 1)
            }
            seguir(desde: i + 1, piezas + [.separacion(desde: i, intervalo(i, i + 1))], tetracordos: tetracordos)
        }
        seguir(desde: 0, [], tetracordos: 0)
        // Las disjuntas primero; después, las que empiezan por un tetracordo; el resto, en el orden en que salen.
        func orden(_ division: DivisionEnTetracordos) -> Int {
            if division.esDisjunta { return 0 }
            if case .tetracordo = division.piezas.first { return 1 }
            return 2
        }
        return divisiones.enumerated().sorted { (orden($0.element), $0.offset) < (orden($1.element), $1.offset) }
            .map(\.element)
    }
}

extension Escala {
    /// Las formas de partir la escala en tetracordos (`TipoDeEscala.divisionesEnTetracordos`).
    ///
    ///     let dorica = Escala(.re, .dorico)
    ///     dorica.divisionesEnTetracordos.first?.tetracordos.map(dorica.notas(de:))   // [[Re, Mi, Fa, Sol], [La, Si, Do, Re]]
    public var divisionesEnTetracordos: [DivisionEnTetracordos] { tipo.divisionesEnTetracordos }

    /// Las notas de un tetracordo de la escala.
    public func notas(de tetracordo: Tetracordo) -> [Nota] { tetracordo.notas(desde: grado(tetracordo.grado + 1)) }
}

// MARK: - El sistema perfecto griego

/// Los cinco tetracordos del sistema perfecto griego, con sus notas de hoy (el sistema mayor va de La a La, y el
/// menor añade el synēmménōn, unido al mésōn): hypátōn (Si Do Re Mi), mésōn (Mi Fa Sol La), synēmménōn (La Si♭ Do
/// Re), diezeugménōn (Si Do Re Mi, una octava más arriba que el hypátōn) e hyperbolaíōn (Mi Fa Sol La, una octava más
/// arriba que el mésōn). Son todos del género diatónico, semitono-tono-tono de grave a agudo.
public enum TetracordoDelSistemaPerfecto: CaseIterable, Sendable {
    case hypaton, meson, synemmenon, diezeugmenon, hyperbolaion

    /// Sus notas, de grave a agudo.
    public var notas: [Nota] {
        switch self {
        case .hypaton, .diezeugmenon: [.si, .do, .re, .mi]
        case .meson, .hyperbolaion: [.mi, .fa, .sol, .la]
        case .synemmenon: [.la, Nota(.si, .bemol), .do, .re]
        }
    }

    /// El nombre griego, transliterado: «hypátōn», «mésōn»…
    public var nombre: String {
        switch self {
        case .hypaton: "hypátōn"
        case .meson: "mésōn"
        case .synemmenon: "synēmménōn"
        case .diezeugmenon: "diezeugménōn"
        case .hyperbolaion: "hyperbolaíōn"
        }
    }

    /// El nombre griego en su alfabeto: «ὑπάτων», «μέσων»…
    public var nombreEnGriego: String {
        switch self {
        case .hypaton: "ὑπάτων"
        case .meson: "μέσων"
        case .synemmenon: "συνημμένων"
        case .diezeugmenon: "διεζευγμένων"
        case .hyperbolaion: "ὑπερβολαίων"
        }
    }

    /// «tetracordo mésōn», «tetrachord mésōn», «Tetrachord mésōn», «τετράχορδο μέσων»… El nombre griego va igual en
    /// todos los idiomas, salvo en griego, que lo escribe en su alfabeto.
    public func nombre(en notacion: Notacion) -> String {
        let suNombre = notacion.textos == .griego ? nombreEnGriego : nombre
        return TextosDeTeoria.en(notacion) { $0.tetracordoGriego(suNombre) }
    }
}

extension Escala {
    /// Los tetracordos del sistema perfecto griego que tienen las notas de un tetracordo de la escala: mésōn e
    /// hyperbolaíōn para Mi Fa Sol La, synēmménōn para La Si♭ Do Re. Vacío si no es ninguno (Do Re Mi Fa).
    ///
    ///     let frigio = Escala(.mi, .frigio)
    ///     frigio.divisionesEnTetracordos[0].tetracordos.map { frigio.tetracordosGriegos(de: $0) }
    ///     // [[.meson, .hyperbolaion], [.hypaton, .diezeugmenon]]
    public func tetracordosGriegos(de tetracordo: Tetracordo) -> [TetracordoDelSistemaPerfecto] {
        let suyas = notas(de: tetracordo)
        return TetracordoDelSistemaPerfecto.allCases.filter { $0.notas == suyas }
    }
}
