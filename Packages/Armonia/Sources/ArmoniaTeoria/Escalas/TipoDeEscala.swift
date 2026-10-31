import ArmoniaNucleo
import Foundation

// MARK: - TipoDeEscala

/// Estructura interválica de una escala, medida desde la tónica.
///
/// Dos tipos son iguales cuando tienen el mismo contenido (los mismos intervalos al subir y al
/// bajar), sin importar el nombre: `TipoDeEscala.mayor == TipoDeEscala(nombre: "jónico", intervalos: …)`.
/// Para comparar también el nombre, `esIdentico(a:)`; para ver con qué otros nombres se conoce
/// una escala, `equivalentes`.
///
/// Algunas escalas suben y bajan con notas distintas (la menor melódica, el dromos Rast, muchos
/// ragas): `intervalos` es la forma ascendente e `intervalosDescendentes`, la descendente.
public struct TipoDeEscala: Sendable, Codable {
    public let nombre: String
    /// Intervalos ascendentes simples desde la tónica, ordenados (empieza por el unísono).
    public let intervalos: [Intervalo]
    /// Intervalos de la forma descendente, si es distinta de la ascendente (también ordenados
    /// de grave a agudo); `nil` si la escala baja con las mismas notas con que sube.
    public let intervalosDescendentes: [Intervalo]?
    /// Otros nombres, escritos correctamente (con diacríticos, ♯/♭…). Las grafías simplificadas
    /// («dorico», «lidio #5») no se guardan: salen de `aliasNormalizados`.
    public let alias: [String]

    /// Nombre y alias en forma normalizada (`normalizar`: sin diacríticos ni mayúsculas, `#`/`b`), sin
    /// repetidos. Es lo que se compara al buscar por nombre.
    public var aliasNormalizados: [String] {
        var vistos = Set<String>()
        return ([nombre] + alias).map(TipoDeEscala.normalizar).filter { vistos.insert($0).inserted }
    }

    // «descenso» es el nombre que tenía `intervalosDescendentes`: se conserva al codificar.
    private enum CodingKeys: String, CodingKey {
        case nombre, intervalos, alias
        case intervalosDescendentes = "descenso"
    }

    /// Los intervalos se reducen a la octava, se pasan a ascendentes y se ordenan,
    /// de modo que el mismo contenido da siempre el mismo tipo. `intervalosDescendentes` solo se guarda si
    /// es distinto de `intervalos`.
    public init(nombre: String, intervalos: [Intervalo], intervalosDescendentes: [Intervalo]? = nil, alias: [String] = []) {
        self.nombre = nombre
        let subida = TipoDeEscala.ordenar(intervalos)
        let bajada = intervalosDescendentes.map(TipoDeEscala.ordenar)
        self.intervalos = subida
        self.intervalosDescendentes = bajada == subida ? nil : bajada
        self.alias = alias
    }

    package static func ordenar(_ intervalos: [Intervalo]) -> [Intervalo] {
        var unicos: [Intervalo] = []
        for i in intervalos.map({ Intervalo.simpleAscendente(pasosDeQuinta: $0.pasosDeQuintaConSigno) })
        where !unicos.contains(i) {
            unicos.append(i)
        }
        if !unicos.contains(.unisono) { unicos.append(.unisono) }
        return unicos.sorted { ($0.pasos, $0.semitonos) < ($1.pasos, $1.semitonos) }
    }

    // MARK: Dirección

    /// ¿Baja con notas distintas de las que sube?
    public var esDireccional: Bool { intervalosDescendentes != nil }

    /// Forma que se usa al descender (la menor melódica baja como menor natural). Si la escala
    /// no es direccional, ella misma.
    public var formaDescendente: TipoDeEscala {
        guard let intervalosDescendentes else { return self }
        return TipoDeEscala(nombre: "\(nombre) (descendente)", intervalos: intervalosDescendentes)
    }

    /// Forma que se usa al ascender, como escala no direccional.
    public var formaAscendente: TipoDeEscala {
        guard esDireccional else { return self }
        return TipoDeEscala(nombre: "\(nombre) (ascendente)", intervalos: intervalos)
    }

    /// Intervalos que aparecen al subir o al bajar: en la menor melódica, la 6ª y la 7ª mayores
    /// y menores.
    public var intervalosEnAmbasDirecciones: [Intervalo] {
        TipoDeEscala.ordenar(intervalos + (intervalosDescendentes ?? []))
    }

    // MARK: Identidad

    /// Mismo contenido y mismo nombre: Kāfī y dórico son iguales (`==`), pero no idénticos.
    public func esIdentico(a otro: TipoDeEscala) -> Bool { self == otro && nombre == otro.nombre }

    /// Otras escalas del catálogo (`todos` y `tradicionales`) con el mismo contenido y otro
    /// nombre: para la mayor, Bilāval, Dhīraśaṅkarābharaṇam y Qīngyuè.
    public var equivalentes: [TipoDeEscala] {
        (TipoDeEscala.todos + TipoDeEscala.tradicionales).filter { $0 == self && $0.nombre != nombre }
    }

    /// Rotación de la escala empezando en el grado `grado` (1 = la propia escala).
    /// Si la rotación coincide con un tipo conocido, devuelve ese tipo.
    public func rotacion(_ grado: Int) -> TipoDeEscala {
        let n = intervalos.count
        let desde = modulo(grado - 1, n)
        let nuevos = (0..<n).map { i in
            Intervalo.simpleAscendente(
                pasosDeQuinta: intervalos[(desde + i) % n].pasosDeQuinta - intervalos[desde].pasosDeQuinta)
        }
        if desde == 0 { return self }
        let candidato = TipoDeEscala(nombre: "\(nombre), modo \(desde + 1)", intervalos: nuevos)
        return TipoDeEscala.todos.first { $0 == candidato }
            ?? TipoDeEscala.todos.first { $0.intervalos == candidato.intervalos } ?? candidato
    }
}

extension TipoDeEscala: Hashable {
    public static func == (a: TipoDeEscala, b: TipoDeEscala) -> Bool {
        a.intervalos == b.intervalos && a.intervalosDescendentes == b.intervalosDescendentes
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(intervalos)
        hasher.combine(intervalosDescendentes)
    }
}

extension TipoDeEscala: Nombrable {}

extension TipoDeEscala: CustomStringConvertible {
    public var description: String { nombre }
}

// Más escalas, búsqueda de escalas, armaduras, círculo de quintas y funciones de grado.

// Las escalas adicionales (modos derivados, exóticas, hexatónicas, Messiaen, jazz…) están en
// `Occidentales/TipoDeEscala+Modos.swift` y `+Exoticas.swift`, y las de otras tradiciones, en `Tradiciones/`.

extension Escala {
    /// El hexacordo natural, sobre Do (Do Re Mi Fa Sol La).
    public static let hexacordoNatural = Escala(.do, .hexacordo)
    /// El hexacordo duro, sobre Sol (Sol La Si Do Re Mi), con el si «cuadrado».
    public static let hexacordoDuro = Escala(.sol, .hexacordo)
    /// El hexacordo blando, sobre Fa (Fa Sol La Si♭ Do Re), con el si «redondo».
    public static let hexacordoBlando = Escala(.fa, .hexacordo)
}

// MARK: - Idiomas

extension TipoDeEscala {
    /// Nombre en español ("dórico"), inglés ("dorian"), catalán ("dòric"), gallego ("dórico"),
    /// euskera ("doriarra"), portugués ("dórico"), francés ("dorien"), italiano ("dorico"), alemán
    /// ("dorisch"), occitano ("dorian"), ruso ("дорийский"), griego ("δώριος"), aragonés ("dórico") o
    /// asturiano ("dóricu"). Un tipo
    /// sin nombre conocido en ese idioma (como un modo de una escala propia) usa su nombre español.
    public func nombre(en notacion: Notacion) -> String {
        // El español es el del propio tipo (un tipo propio puede coincidir en intervalos con uno del catálogo).
        if notacion.textos == .espanol { return nombre }
        // Los nombres propios de otras tradiciones (Kafi, Hitzaz…) son los mismos en todos los idiomas, salvo
        // los que se traducen (las escalas andinas, los tetracordos…): se buscan por su nombre, no por el tipo.
        return NombresDeEscalas.de(notacion.textos).nombre(de: self) ?? nombre
    }
}

extension TipoDeEscala {
    // MARK: Tipos predefinidos

    public static let mayor = TipoDeEscala(
        nombre: "mayor",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
                     .quintaJusta, .sextaMayor, .septimaMayor],
        alias: ["jónico", "jónica"])
    public static let dorico = TipoDeEscala(
        nombre: "dórico",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
                     .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["dórica"])
    public static let frigio = TipoDeEscala(
        nombre: "frigio",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
                     .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["frigia"])
    public static let lidio = TipoDeEscala(
        nombre: "lidio",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
                     .quintaJusta, .sextaMayor, .septimaMayor],
        alias: ["lidia"])
    public static let mixolidio = TipoDeEscala(
        nombre: "mixolidio",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
                     .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["mixolidia"])
    public static let menorNatural = TipoDeEscala(
        nombre: "menor natural",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
                     .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["menor", "eólico", "eólica"])
    public static let locrio = TipoDeEscala(
        nombre: "locrio",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
                     .quintaDisminuida, .sextaMenor, .septimaMenor],
        alias: ["locria"])
    public static let menorArmonica = TipoDeEscala(
        nombre: "menor armónica",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
                     .quintaJusta, .sextaMenor, .septimaMayor])
    /// Sube con la 6ª y la 7ª mayores y baja como la menor natural.
    public static let menorMelodica = TipoDeEscala(
        nombre: "menor melódica",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
                     .quintaJusta, .sextaMayor, .septimaMayor],
        intervalosDescendentes: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
                   .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["menor melódica clásica"])
    /// La menor melódica tal como se usa en el jazz: con la 6ª y la 7ª mayores también al bajar.
    /// Es el mismo contenido que el melakarta 23 (Gaurīmanoharī), y la escala madre de los modos
    /// de la menor melódica (dórico ♭2, lidio aumentado, lidio dominante, alterada…).
    public static let menorMelodicaJazz = TipoDeEscala(
        nombre: "menor melódica de jazz",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
                     .quintaJusta, .sextaMayor, .septimaMayor],
        alias: ["menor de jazz", "menor melódica ascendente"])
    public static let pentatonicaMayor = TipoDeEscala(
        nombre: "pentatónica mayor",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        alias: ["pentatónica"])
    public static let pentatonicaMenor = TipoDeEscala(
        nombre: "pentatónica menor",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor])
    public static let blues = TipoDeEscala(
        nombre: "blues",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .cuartaAumentada,
                     .quintaJusta, .septimaMenor])
    public static let tonosEnteros = TipoDeEscala(
        nombre: "tonos enteros",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
                     .quintaAumentada, .sextaAumentada],
        alias: ["hexatónica", "modo 1 de Messiaen", "aumentada auxiliar", "de Debussy", "Debussy"])
    public static let disminuida = TipoDeEscala(
        nombre: "disminuida tono-semitono",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
                     .quintaDisminuida, .sextaMenor, .sextaMayor, .septimaMayor],
        alias: ["disminuida", "octatónica", "modo 2 de Messiaen inverso", "disminuida auxiliar"])
}

// El catálogo de búsqueda: `todos` (el orden decide qué escala gana al identificar), `buscar(nombre:)`
// y los índices por nombre. Las escalas de otras tradiciones están en `tradicionales`.

extension TipoDeEscala {
    public static let todos: [TipoDeEscala] = [
        .mayor, .dorico, .frigio, .lidio, .mixolidio, .menorNatural, .locrio,
        .menorArmonica, .menorMelodica, .menorMelodicaJazz, .mayorArmonica,
        .locrioSextaNatural, .jonicoAumentado, .doricoCuartaAumentada, .frigioDominante,
        .lidioSegundaAumentada, .ultralocrio,
        .doricoSegundaMenor, .lidioAumentado, .lidioDominante, .mixolidioSextaMenor,
        .locrioSegundaNatural, .alterada,
        .pentatonicaMayor, .pentatonicaMenor, .blues, .tonosEnteros, .disminuida,
        .bebopDominante, .bebopMayor, .bebopDorico,
        .doricoQuintaDisminuida, .frigioCuartaDisminuida, .lidioTerceraMenor, .mixolidioSegundaMenor,
        .lidioAumentadoSegundaAumentada, .locrioSeptimaDisminuida,
        .dobleArmonica, .menorHungara, .mayorHungara, .napolitanaMenor, .napolitanaMayor,
        .enigmatica, .persa, .mayorLocria, .lidioMenor, .prometeo,
        .disminuidaSemitonoTono, .aumentada, .bluesMayor, .egipcia, .cromatica,
        .cromaticaConCincoBemoles, .cromaticaConTresBemoles, .cromaticaConDosBemoles, .cromaticaConUnBemol,
        .cromaticaConCincoSostenidos,
        .bebopMenorMelodica, .bebopMenorArmonica, .flamenca, .petrushka,
        .messiaen3, .messiaen4, .messiaen5, .messiaen6, .messiaen7,
        .lidioSegundaSextaAumentadas, .ultrafrigio, .oriental, .jonicoSegundaQuintaAumentadas, .locrioTerceraSeptimaDisminuidas,
        .lidioAumentadoSextaAumentada, .lidioDominanteAumentado, .locrioSegundaNaturalCuartaDisminuida, .superlocrioTerceraDisminuida,
        .lidioSextaAumentada, .mixolidioAumentado, .eolicoCuartaAumentada, .locrioDominante, .jonicoSegundaAumentada,
        .ultralocrioTerceraDisminuida,
        .pentatonicaDominante, .pentatonicaMenorSexta, .pentatonicaMayorSextaMenor, .pentatonicaMenorQuintaDisminuida,
        .bluesDeNueveNotas, .bluesMenorConSegunda, .hexacordo, .argelina,
        .jonicoSinCuarta, .mixolidioSinTercera, .doricoSinSexta, .eolicoSinSegunda, .hexatonicaDeDosTriadas,
        .hexatonicaMenorDeDosTriadas, .mayorRumana,
        .ultralocrioSextaDisminuida, .menorArmonicaQuintaDisminuida, .superlocrioSextaNatural,
        .menorMelodicaQuintaAumentada, .doricoSegundaMenorCuartaAumentada, .lidioAumentadoTerceraAumentada,
        .pentatonicaMixolidia, .pentatonicaLidia, .pentatonicaEscocesa,
    ]

    /// Busca un tipo por su nombre en español o en inglés, sin distinguir mayúsculas
    /// ni guiones: "dórico", "dorico", "Dorian", "harmonic minor", "whole-tone". También
    /// encuentra las escalas de `tradicionales`: "Kafi", "hitzaz", "melakarta 15".
    public static func buscar(nombre: String) -> TipoDeEscala? {
        buscar(nombre: nombre, aceptarIngles: true)
    }

    /// Como `buscar(nombre:)`; con `aceptarIngles: false` solo acepta los nombres en español
    /// (y los tradicionales), para no mezclar idiomas: "Re dorian" no es una escala.
    package static func buscar(nombre: String, aceptarIngles: Bool) -> TipoDeEscala? {
        let n = TipoDeEscala.normalizar(nombre)
        return indicePorNombre[n] ?? (aceptarIngles ? indiceInternacional[n] : nil)
    }

    /// Nombres y alias normalizados → tipo. Un nombre gana a un alias (Hijaz es el maqam Ḥijāz,
    /// no el dromos Hitzáz, que lo tiene de alias); entre nombres o entre alias, gana el primero
    /// (los de `todos` antes que los de `tradicionales`).
    package static let indicePorNombre: [String: TipoDeEscala] = {
        var indice: [String: TipoDeEscala] = [:]
        for tipo in todos + tradicionales where indice[normalizar(tipo.nombre)] == nil {
            indice[normalizar(tipo.nombre)] = tipo
        }
        for tipo in todos + tradicionales {
            for nombre in tipo.alias where indice[normalizar(nombre)] == nil {
                indice[normalizar(nombre)] = tipo
            }
        }
        return indice
    }()

    /// Nombres ingleses normalizados → tipo (`Escalas/Nombres/NombresDeEscalas+Ingles.swift`).
    package static let indiceInternacional: [String: TipoDeEscala] = NombresDeEscalas.de(.ingles).indice

    /// Nombres de las escalas de otras tradiciones (los de `NombresDeEscalas.tradicionales`, en español).
    package static let nombresTradicionales: Set<String> = Set(tradicionales.map(\.nombre))

    /// Minúsculas, sin diacríticos (dórico → dorico, Kāfī → kafi), ♯/♭ como #/b, sin ♮ ni ordinales
    /// (4ª → 4), «−» como «-», «…» como «..» y con un solo espacio entre palabras. En devanagari no se quitan los signos: las vocales y el virama
    /// son parte de la letra (भैरव y भैरवी son dos ragas).
    package static func normalizar(_ texto: String) -> String {
        let devanagari = texto.unicodeScalars.contains { (0x0900...0x097F).contains($0.value) }
        return texto.replacingOccurrences(of: "♯", with: "#")
            .replacingOccurrences(of: "♭", with: "b")
            .replacingOccurrences(of: "♮", with: "")
            .replacingOccurrences(of: "ª", with: "")
            .replacingOccurrences(of: "−", with: "-")
            .replacingOccurrences(of: "…", with: "..")
            .folding(options: devanagari ? [.caseInsensitive] : [.diacriticInsensitive, .caseInsensitive], locale: nil)
            .lowercased()
            .split(whereSeparator: { $0 == " " || $0 == "-" }).joined(separator: " ")
    }
}
