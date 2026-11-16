import Elementos

// MARK: - El carácter de los acordes, las progresiones y los ritmos
//
// Lo que dicen las fuentes de cada uno, por catálogo, y solo de los que tienen una fuente. El de las escalas está en
// `TipoDeEscala+Caracter.swift`. Van por el nombre: es del acorde del catálogo, no de cualquiera con sus notas.

extension AcordeConNombre {
    /// Cada acorde con lo que dicen de él sus fuentes. Zarlino y Rameau describen las tríadas por su tercera: la mayor
    /// alegra y la menor entristece.
    package static let caracteres: [(acorde: AcordeConNombre, caracter: [Caracter])] = [
        (.mayor, [.init([.alegre], referencia: .zarlino1558), .init([.alegre, .festivo], referencia: .rameau1722)]),
        (.menor, [.init([.triste], referencia: .zarlino1558), .init([.tierno, .lastimero], referencia: .rameau1722)]),
    ]

    private static let caracterPorNombre = Caracter.tabla(caracteres.map { ($0.acorde.nombre, $0.caracter) })

    /// Lo que dicen las fuentes de su carácter, en orden cronológico; vacío si ninguna dice nada.
    ///
    ///     AcordeConNombre.mayor.caracter.map(\.referencia)   // [.zarlino1558, .rameau1722]
    public var caracter: [Caracter] { AcordeConNombre.caracterPorNombre[nombre] ?? [] }
}

extension ProgresionConNombre {
    /// Cada progresión con lo que dicen de ella sus fuentes: el tetracordo descendente es el emblema del lamento
    /// (Rosand), y la folía, la chacona y el pasacalle son danzas antes que bajos (Hudson).
    package static let caracteres: [(progresion: ProgresionConNombre, caracter: [Caracter])] = [
        (.bajoDeLamento, [.init([.lastimero], ocasion: .lamento, referencia: .rosand1979)]),
        (.lamentoCromatico, [.init([.lastimero], ocasion: .lamento, referencia: .rosand1979)]),
        (.folia, [.init(ocasion: .danza, referencia: .hudson1982)]),
        (.chacona, [.init(ocasion: .danza, referencia: .hudsonChaconne1982)]),
        (.passacaglia, [.init(ocasion: .danza, referencia: .hudsonPassacaglia1982)]),
    ]

    private static let caracterPorNombre = Caracter.tabla(caracteres.map { ($0.progresion.nombre, $0.caracter) })

    /// Lo que dicen las fuentes de su carácter, en orden cronológico; vacío si ninguna dice nada.
    ///
    ///     ProgresionConNombre.bajoDeLamento.ocasiones   // [.lamento]
    public var caracter: [Caracter] { ProgresionConNombre.caracterPorNombre[nombre] ?? [] }
}

extension RitmoConNombre {
    /// Cada ritmo con lo que dicen de él sus fuentes: los tres compases de doce tiempos del flamenco, en Fernández.
    package static let caracteres: [(ritmo: RitmoConNombre, caracter: [Caracter])] = [
        (.solea, [.init([.grave, .solemne], referencia: .fernandez2004)]),
        (.seguiriya, [.init([.lastimero, .grave], referencia: .fernandez2004)]),
        (.buleria, [.init([.festivo, .alegre], ocasion: .danza, referencia: .fernandez2004)]),
    ]

    private static let caracterPorNombre = Caracter.tabla(caracteres.map { ($0.ritmo.nombre, $0.caracter) })

    /// Lo que dicen las fuentes de su carácter, en orden cronológico; vacío si ninguna dice nada.
    ///
    ///     RitmoConNombre.seguiriya.afectos   // [.lastimero, .grave]
    public var caracter: [Caracter] { RitmoConNombre.caracterPorNombre[nombre] ?? [] }
}

extension TemperamentoConNombre {
    /// Ningún temperamento tiene carácter: el de las tonalidades que da un temperamento irá con las tonalidades.
    public var caracter: [Caracter] { [] }
}

extension NotaConNombre {
    /// Ninguna nota tiene carácter.
    public var caracter: [Caracter] { [] }
}

extension FuncionDeNota {
    /// Ninguna función tiene carácter.
    public var caracter: [Caracter] { [] }
}

extension OrnamentoConNombre {
    /// Ningún ornamento tiene carácter.
    public var caracter: [Caracter] { [] }
}

extension Caracter {
    /// Nombre → lo que dicen sus fuentes, en orden cronológico (por `anio`; los que no lo tienen, al final).
    package static func tabla(_ filas: [(String, [Caracter])]) -> [String: [Caracter]] {
        var tabla: [String: [Caracter]] = [:]
        for (nombre, caracter) in filas { tabla[nombre, default: []] += caracter }
        return tabla.mapValues(enOrdenCronologico)
    }

    /// Los caracteres por su año, y los del mismo año en el orden en que vienen.
    package static func enOrdenCronologico(_ lista: [Caracter]) -> [Caracter] {
        lista.enumerated().sorted { ($0.element.anio ?? .max, $0.offset) < ($1.element.anio ?? .max, $1.offset) }
            .map(\.element)
    }
}

extension Caracter {
    /// Los pares de fuentes que no coinciden en nada: las dos dan afectos y ninguno es el mismo. En Fa mayor,
    /// Charpentier («furieux et emporté», colérico) y Schubart («complaisance & calm», sereno). Van en el orden de la
    /// lista, el primero de cada par antes que el segundo.
    ///
    ///     Caracter.discrepancias(Tonalidad(.fa).caracter).count   // 1
    ///     Caracter.discrepancias(Tonalidad(Nota(.si, .bemol), .menor).caracter).count   // 0: los dos, sombrío
    public static func discrepancias(_ lista: [Caracter]) -> [(Caracter, Caracter)] {
        var pares: [(Caracter, Caracter)] = []
        for (i, primero) in lista.enumerated() where !primero.afectos.isEmpty {
            for segundo in lista[(i + 1)...] where !segundo.afectos.isEmpty {
                if Set(primero.afectos).isDisjoint(with: segundo.afectos) { pares.append((primero, segundo)) }
            }
        }
        return pares
    }
}
