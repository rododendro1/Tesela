import ArmoniaNucleo

// MARK: - Uso de una escala occidental

/// En qué música se usa una escala de `TipoDeEscala.todos`. Las notas no lo dicen: la menor melódica de jazz es la
/// «bachiana» de los conservatorios, y el lidio dominante es la acústica de Bartók. Lo dice el repertorio.
///
/// Una escala puede tener varios usos (el dórico es clásico y de jazz; la disminuida, de jazz y del siglo XX), y
/// todas las de `todos` tienen al menos uno. Las de otras tradiciones no tienen: se clasifican por su `Tradicion`.
///
///     TipoDeEscala.alterada.usos          // [.jazz]
///     TipoDeEscala.todos(uso: .blues)     // pentatónica mayor, pentatónica menor, blues, blues mayor…
public enum UsoDeEscala: String, Sendable, Codable, CaseIterable {
    /// La teoría tonal y modal: la escala da la tonalidad y de ella sale la armonía (la mayor, las menores, los modos,
    /// las napolitanas, la cromática, el hexacordo).
    case clasica
    /// El jazz, donde la escala se elige acorde a acorde: los modos de la menor melódica (alterada, lidio dominante,
    /// locrio ♮2…), las bebop, las disminuidas, las pentatónicas del jazz y las de dos tríadas. Los siete modos de la
    /// mayor también, porque son los de los acordes diatónicos.
    case jazz
    /// El blues: las blue notes (♭3, ♭5 y ♭7 sobre un acorde mayor) y las pentatónicas de las que salen.
    case blues
    /// Las escalas simétricas y de compositor del siglo XX: tonos enteros, disminuidas, aumentada, los modos de
    /// Messiaen, Prometeo (Skriabin), Petrushka (Stravinski), la acústica (Bartók) y la cromática.
    case sigloXX
    /// Las que vienen de una música popular, como se conocen en los libros de teoría: la flamenca, la mayor rumana,
    /// la menor húngara, las pentatónicas, las hexatónicas gaélicas.
    case popular
    /// Las que salen de rotar o alterar otra escala, sin un repertorio propio: la mayoría de los modos de la menor
    /// armónica, de la mayor armónica, de la doble armónica y de las napolitanas.
    case sintetica

    /// Las escalas de `todos` de este uso, en su orden.
    public var tipos: [TipoDeEscala] {
        let suyos = Set((UsoDeEscala.tabla[self] ?? []).map(\.identidad))
        return TipoDeEscala.todos.filter { suyos.contains($0.identidad) }
    }

    /// El reparto: cada uso y sus escalas. Se nombran por su miembro de `TipoDeEscala`, así que una escala que se
    /// renombra o se quita no compila.
    private static let tabla: [UsoDeEscala: [TipoDeEscala]] = [
        .clasica: [
            .mayor, .dorico, .frigio, .lidio, .mixolidio, .menorNatural, .locrio, .menorArmonica, .menorMelodica,
            .mayorArmonica, .napolitanaMenor, .napolitanaMayor, .enigmatica, .cromatica, .cromaticaConCincoBemoles,
            .cromaticaConTresBemoles, .cromaticaConDosBemoles, .cromaticaConUnBemol, .cromaticaConCincoSostenidos,
            .hexacordo,
        ],
        .jazz: [
            .mayor, .dorico, .frigio, .lidio, .mixolidio, .menorNatural, .locrio, .menorMelodicaJazz, .frigioDominante,
            .doricoSegundaMenor, .lidioAumentado, .lidioDominante, .mixolidioSextaMenor, .locrioSegundaNatural,
            .alterada, .tonosEnteros, .disminuida, .disminuidaSemitonoTono, .aumentada, .bebopDominante, .bebopMayor,
            .bebopDorico, .bebopMenorMelodica, .bebopMenorArmonica, .pentatonicaDominante, .pentatonicaMenorSexta,
            .pentatonicaMayorSextaMenor, .pentatonicaMenorQuintaDisminuida, .pentatonicaMixolidia, .pentatonicaLidia,
            .hexatonicaDeDosTriadas, .hexatonicaMenorDeDosTriadas,
        ],
        .blues: [.pentatonicaMayor, .pentatonicaMenor, .blues, .bluesMayor, .bluesDeNueveNotas, .bluesMenorConSegunda],
        .sigloXX: [
            .lidioDominante, .tonosEnteros, .disminuida, .disminuidaSemitonoTono, .aumentada, .prometeo, .cromatica,
            .cromaticaConCincoBemoles, .cromaticaConTresBemoles, .cromaticaConDosBemoles, .cromaticaConUnBemol,
            .cromaticaConCincoSostenidos, .petrushka, .messiaen3, .messiaen4, .messiaen5, .messiaen6, .messiaen7,
        ],
        .popular: [
            .doricoCuartaAumentada, .frigioDominante, .pentatonicaMayor, .pentatonicaMenor, .dobleArmonica,
            .menorHungara, .mayorHungara, .egipcia, .flamenca, .argelina, .jonicoSinCuarta, .mixolidioSinTercera,
            .doricoSinSexta, .eolicoSinSegunda, .mayorRumana, .pentatonicaEscocesa,
        ],
        .sintetica: [
            .locrioSextaNatural, .jonicoAumentado, .lidioSegundaAumentada, .ultralocrio, .doricoQuintaDisminuida,
            .frigioCuartaDisminuida, .lidioTerceraMenor, .mixolidioSegundaMenor, .lidioAumentadoSegundaAumentada,
            .locrioSeptimaDisminuida, .persa, .mayorLocria, .lidioMenor, .lidioSegundaSextaAumentadas, .ultrafrigio,
            .oriental, .jonicoSegundaQuintaAumentadas, .locrioTerceraSeptimaDisminuidas, .lidioAumentadoSextaAumentada,
            .lidioDominanteAumentado, .locrioSegundaNaturalCuartaDisminuida, .superlocrioTerceraDisminuida,
            .lidioSextaAumentada, .mixolidioAumentado, .eolicoCuartaAumentada, .locrioDominante,
            .jonicoSegundaAumentada, .ultralocrioTerceraDisminuida, .ultralocrioSextaDisminuida,
            .menorArmonicaQuintaDisminuida, .superlocrioSextaNatural, .menorMelodicaQuintaAumentada,
            .doricoSegundaMenorCuartaAumentada, .lidioAumentadoTerceraAumentada,
        ],
    ]

    /// El nombre del uso en el idioma de los textos de la notación: «siglo XX», «20th century», «XX. mendea». En
    /// español, también `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los quince idiomas, de los `TextosDeTeoria`. El `switch` no tiene `default`: un uso nuevo no
    /// compila sin el suyo.
    private var traduccion: Traduccion {
        switch self {
        case .clasica: TextosDeTeoria.traduccion(\.usoClasica)
        case .jazz: TextosDeTeoria.traduccion(\.usoJazz)
        case .blues: TextosDeTeoria.traduccion(\.usoBlues)
        case .sigloXX: TextosDeTeoria.traduccion(\.usoSigloXX)
        case .popular: TextosDeTeoria.traduccion(\.usoPopular)
        case .sintetica: TextosDeTeoria.traduccion(\.usoSintetica)
        }
    }
}

extension UsoDeEscala: Nombrable {}

extension TipoDeEscala {
    /// En qué música se usa la escala, en el orden de `UsoDeEscala.allCases`; vacío en las de otras tradiciones y en
    /// las propias. Se busca por su `identidad`, como `tradicion`: Kāfī tiene las notas del dórico, pero no sus usos.
    public var usos: [UsoDeEscala] { TipoDeEscala.usosPorIdentidad[identidad] ?? [] }

    /// Identidad de cada escala de `todos` → sus usos, en el orden de `UsoDeEscala.allCases`.
    private static let usosPorIdentidad: [IdentidadDeEscala: [UsoDeEscala]] = {
        var tabla: [IdentidadDeEscala: [UsoDeEscala]] = [:]
        for uso in UsoDeEscala.allCases {
            for tipo in uso.tipos { tabla[tipo.identidad, default: []].append(uso) }
        }
        return tabla
    }()

    /// Las escalas de `todos` de un uso: `todos(uso: .jazz)` da los modos, las bebop, la alterada…
    public static func todos(uso: UsoDeEscala) -> [TipoDeEscala] { uso.tipos }
}
