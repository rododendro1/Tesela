import Elementos

// MARK: - El carácter de los acordes, las progresiones y los ritmos
//
// Lo que dicen las fuentes de cada uno, por catálogo, y solo de los que tienen una fuente. El de las escalas está en
// `TipoDeEscala+Caracter.swift`. Van por el nombre: es del acorde del catálogo, no de cualquiera con sus notas.

extension AcordeConNombre {
    /// Cada acorde con lo que dicen de él sus fuentes. Zarlino y Rameau describen las tríadas por su tercera: la mayor
    /// alegra y la menor entristece.
    package static let caracteres: [(acorde: AcordeConNombre, caracter: [Caracter])] = [
        (.mayor, [.init([.alegre], fuente: .zarlino1558), .init([.alegre, .festivo], fuente: .rameau1722)]),
        (.menor, [.init([.triste], fuente: .zarlino1558), .init([.tierno, .lastimero], fuente: .rameau1722)]),
    ]

    private static let caracterPorNombre = Caracter.tabla(caracteres.map { ($0.acorde.nombre, $0.caracter) })

    /// Lo que dicen las fuentes de su carácter, en orden cronológico; vacío si ninguna dice nada.
    ///
    ///     AcordeConNombre.mayor.caracter.map(\.fuente)   // [.zarlino1558, .rameau1722]
    public var caracter: [Caracter] { AcordeConNombre.caracterPorNombre[nombre] ?? [] }
}

extension ProgresionConNombre {
    /// Cada progresión con lo que dicen de ella sus fuentes: el tetracordo descendente es el emblema del lamento
    /// (Rosand), y la folía, la chacona y el pasacalle son danzas antes que bajos (Hudson).
    package static let caracteres: [(progresion: ProgresionConNombre, caracter: [Caracter])] = [
        (.bajoDeLamento, [.init([.lastimero], ocasion: .lamento, fuente: .rosand1979)]),
        (.lamentoCromatico, [.init([.lastimero], ocasion: .lamento, fuente: .rosand1979)]),
        (.folia, [.init(ocasion: .danza, fuente: .hudson1982)]),
        (.chacona, [.init(ocasion: .danza, fuente: .hudsonChaconne1982)]),
        (.passacaglia, [.init(ocasion: .danza, fuente: .hudsonPassacaglia1982)]),
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
        (.solea, [.init([.grave, .solemne], fuente: .fernandez2004)]),
        (.seguiriya, [.init([.lastimero, .grave], fuente: .fernandez2004)]),
        (.buleria, [.init([.festivo, .alegre], ocasion: .danza, fuente: .fernandez2004)]),
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
