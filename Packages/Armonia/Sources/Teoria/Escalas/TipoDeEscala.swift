import Elementos
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
/// rāgas): `intervalos` es la forma ascendente e `intervalosDescendentes`, la descendente.
public struct TipoDeEscala: Sendable, Codable {
    public let nombre: String
    /// Intervalos ascendentes simples desde la tónica, ordenados (empieza por el unísono).
    public let intervalos: [Intervalo]
    /// Intervalos de la forma descendente, si es distinta de la ascendente (también ordenados
    /// de grave a agudo); `nil` si la escala baja con las mismas notas con que sube.
    public let intervalosDescendentes: [Intervalo]?
    /// Otros nombres de la escala, escritos correctamente (con diacríticos, ♯/♭…): «jónico» para la mayor,
    /// «bizantina» para la doble armónica. Las grafías simplificadas («dorico», «lidio #5») no se guardan: salen
    /// de `aliasNormalizados`.
    public let alias: [String]
    /// Otras formas de escribir el nombre o uno de los alias, que no son otro nombre: otro género («dórica»), otra
    /// transliteración («Hicaz» por Hitzáz) u otra escritura («Χιτζάζ», «बिलावल»). Se leen igual que los alias.
    public let variantes: [String]
    /// Lo demás que el catálogo sabe de la escala (usos, categoría, subtradición, mēḷa, microtonos), escrito en su
    /// declaración. No se codifica ni cuenta para `==`, y las propiedades públicas no lo leen de aquí sino de la
    /// escala del catálogo con la misma identidad (`fichaDelCatalogo`).
    package let ficha: FichaDeEscala

    /// Nombre, alias y variantes en forma normalizada (`normalizar`: sin diacríticos ni mayúsculas, `#`/`b`), sin
    /// repetidos. Es lo que se compara al buscar por nombre.
    public var aliasNormalizados: [String] {
        var vistos = Set<String>()
        return ([nombre] + alias + variantes).map(TipoDeEscala.normalizar).filter { vistos.insert($0).inserted }
    }

    // «descenso» es el nombre que tenía `intervalosDescendentes`: se conserva al codificar.
    private enum CodingKeys: String, CodingKey {
        case nombre, intervalos, alias, variantes
        case intervalosDescendentes = "descenso"
    }

    /// Los intervalos se reducen a la octava, se pasan a ascendentes y se ordenan,
    /// de modo que el mismo contenido da siempre el mismo tipo. `intervalosDescendentes` solo se guarda si
    /// es distinto de `intervalos`.
    public init(
        nombre: String, intervalos: [Intervalo], intervalosDescendentes: [Intervalo]? = nil, alias: [String] = [],
        variantes: [String] = []
    ) {
        self.init(
            nombre: nombre, intervalos: intervalos, intervalosDescendentes: intervalosDescendentes, alias: alias,
            variantes: variantes, ficha: .vacia)
    }

    /// Una escala occidental del catálogo, con sus usos y, si las tiene, sus versiones microtonales.
    package init(
        nombre: String, intervalos: [Intervalo], intervalosDescendentes: [Intervalo]? = nil, alias: [String] = [],
        variantes: [String] = [], usos: [UsoDeEscala], afinaciones: [FichaDeEscala.Afinacion] = []
    ) {
        self.init(
            nombre: nombre, intervalos: intervalos, intervalosDescendentes: intervalosDescendentes, alias: alias,
            variantes: variantes, ficha: FichaDeEscala(usos: usos, afinaciones: afinaciones))
    }

    /// Una escala de otra tradición, con su categoría y, si los tiene, su subtradición (si no la da la categoría), el
    /// teórico que la definió (`fuente`), el número del mēḷa del que deriva (un rāga janya) y sus versiones
    /// microtonales. La tradición la da su lista en `listasTradicionales`. `llevaLaCategoria` va en las que ya tienen
    /// la palabra de la categoría en el nombre («Rast makamı»), para que `nombreCompleto` no la repita.
    package init(
        nombre: String, intervalos: [Intervalo], intervalosDescendentes: [Intervalo]? = nil, alias: [String] = [],
        variantes: [String] = [], categoria: CategoriaTradicional, llevaLaCategoria: Bool = false,
        subtradicion: Subtradicion? = nil, fuente: FuenteTeorica? = nil, mela: Int? = nil,
        afinaciones: [FichaDeEscala.Afinacion] = []
    ) {
        self.init(
            nombre: nombre, intervalos: intervalos, intervalosDescendentes: intervalosDescendentes, alias: alias,
            variantes: variantes,
            ficha: FichaDeEscala(
                categoria: categoria, subtradicion: subtradicion, mela: mela, afinaciones: afinaciones,
                llevaLaCategoria: llevaLaCategoria, fuente: fuente))
    }

    init(
        nombre: String, intervalos: [Intervalo], intervalosDescendentes: [Intervalo]?, alias: [String],
        variantes: [String], ficha: FichaDeEscala
    ) {
        self.nombre = nombre
        let subida = TipoDeEscala.ordenar(intervalos)
        let bajada = intervalosDescendentes.map(TipoDeEscala.ordenar)
        self.intervalos = subida
        self.intervalosDescendentes = bajada == subida ? nil : bajada
        self.alias = alias
        self.variantes = variantes
        self.ficha = ficha
    }

    /// Las escalas guardadas antes de que hubiera `variantes` se leen sin ellas.
    public init(from decoder: any Decoder) throws {
        let datos = try decoder.container(keyedBy: CodingKeys.self)
        nombre = try datos.decode(String.self, forKey: .nombre)
        intervalos = try datos.decode([Intervalo].self, forKey: .intervalos)
        intervalosDescendentes = try datos.decodeIfPresent([Intervalo].self, forKey: .intervalosDescendentes)
        alias = try datos.decode([String].self, forKey: .alias)
        variantes = try datos.decodeIfPresent([String].self, forKey: .variantes) ?? []
        ficha = .vacia
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
    public func esIdentico(a otro: TipoDeEscala) -> Bool { identidad == otro.identidad }

    /// Qué escala es, y no solo qué notas tiene: con ella se buscan su tradición, su categoría, sus usos, sus
    /// afinaciones y sus nombres en otros idiomas. Kāfī y el dórico tienen el mismo contenido y distinta identidad.
    package var identidad: IdentidadDeEscala {
        IdentidadDeEscala(nombre: nombre, intervalos: intervalos, intervalosDescendentes: intervalosDescendentes)
    }

    /// Otras escalas del catálogo (`catalogo`, en su orden) con el mismo contenido y otro
    /// nombre: para la mayor, Bilāval, Dhīraśaṅkarābharaṇam y Qīngyuè.
    public var equivalentes: [TipoDeEscala] {
        TipoDeEscala.catalogo.filter { $0 == self && $0.nombre != nombre }
    }

    /// El modo que empieza en el grado `grado` (1 = la propia escala): la rotación de sus intervalos.
    /// Si la rotación coincide con un tipo conocido, devuelve ese tipo.
    public func modo(grado: Int) -> TipoDeEscala {
        let n = intervalos.count
        let desde = modulo(grado - 1, n)
        let nuevos = (0..<n).map { i in
            Intervalo.simpleAscendente(
                pasosDeQuinta: intervalos[(desde + i) % n].pasosDeQuinta - intervalos[desde].pasosDeQuinta)
        }
        if desde == 0 { return self }
        let candidato = TipoDeEscala(nombre: "\(nombre), modo \(desde + 1)", intervalos: nuevos)
        return TipoDeEscala.occidentales.first { $0 == candidato }
            ?? TipoDeEscala.occidentales.first { $0.intervalos == candidato.intervalos } ?? candidato
    }
}

/// La identidad de un `TipoDeEscala` (`TipoDeEscala.identidad`): su nombre y su contenido. Dos tipos con los mismos
/// intervalos son iguales (`==`); solo son la misma escala si además se llaman igual. Es la clave de las tablas que
/// dicen algo de una escala concreta: una escala propia que se llame «Kafi» pero suene distinto no es el thāṭ, y
/// Āsāvarī no es la escala menor natural.
package struct IdentidadDeEscala: Hashable, Sendable {
    let nombre: String
    let intervalos: [Intervalo]
    let intervalosDescendentes: [Intervalo]?
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
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["jónico"], variantes: ["jónica"],
        usos: [.clasica, .jazz])
    public static let dorico = TipoDeEscala(
        nombre: "dórico",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["menor dórica"], variantes: ["dórica"],
        usos: [.clasica, .jazz])
    public static let frigio = TipoDeEscala(
        nombre: "frigio",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["frigia"],
        usos: [.clasica, .jazz])
    public static let lidio = TipoDeEscala(
        nombre: "lidio",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["lidia"],
        usos: [.clasica, .jazz])
    public static let mixolidio = TipoDeEscala(
        nombre: "mixolidio",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["mixolidia"],
        usos: [.clasica, .jazz])
    public static let menorNatural = TipoDeEscala(
        nombre: "menor natural",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["menor", "eólico", "menor antigua"], variantes: ["eólica"],
        usos: [.clasica, .jazz])
    public static let locrio = TipoDeEscala(
        nombre: "locrio",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        variantes: ["locria"],
        usos: [.clasica, .jazz])
    public static let menorArmonica = TipoDeEscala(
        nombre: "menor armónica",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        usos: [.clasica])
    /// Sube con la 6ª y la 7ª mayores y baja como la menor natural.
    public static let menorMelodica = TipoDeEscala(
        nombre: "menor melódica",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["menor melódica clásica"],
        usos: [.clasica])
    /// La menor melódica tal como se usa en el jazz: con la 6ª y la 7ª mayores también al bajar.
    /// En los conservatorios españoles es la «menor bachiana», la que Bach usa al subir y al bajar.
    /// Es el mismo contenido que el mēḷa 23 (Gaurīmanoharī), y la escala madre de los modos
    /// de la menor melódica (dórico ♭2, lidio aumentado, lidio dominante, alterada…).
    public static let menorMelodicaJazz = TipoDeEscala(
        nombre: "menor melódica de jazz",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["menor de jazz", "menor melódica ascendente", "bachiana", "menor bachiana", "de Bach"],
        usos: [.jazz])
    public static let pentatonicaMayor = TipoDeEscala(
        nombre: "pentatónica mayor",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        alias: ["pentatónica"],
        usos: [.blues, .popular])
    public static let pentatonicaMenor = TipoDeEscala(
        nombre: "pentatónica menor",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        usos: [.blues, .popular])
    public static let blues = TipoDeEscala(
        nombre: "blues",
        intervalos: [
            .unisono, .terceraMenor, .cuartaJusta, .cuartaAumentada,
            .quintaJusta, .septimaMenor,
        ],
        usos: [.blues], afinaciones: [.init(.razones, pasos: [0, 350, 498, 600, 702, 969])])
    public static let tonosEnteros = TipoDeEscala(
        nombre: "tonos enteros",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaAumentada, .sextaAumentada,
        ],
        alias: ["hexatónica", "modo 1 de Messiaen", "aumentada auxiliar", "de Debussy", "Debussy"],
        usos: [.jazz, .sigloXX])
    public static let disminuida = TipoDeEscala(
        nombre: "disminuida tono-semitono",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .sextaMayor, .septimaMayor,
        ],
        alias: ["disminuida", "octatónica", "modo 2 de Messiaen inverso", "disminuida auxiliar"],
        usos: [.jazz, .sigloXX])
}

// El catálogo de búsqueda: `occidentales` (el orden decide qué escala gana al identificar), `catalogo` (todas, en el
// orden de prioridad), `init(leyendo:)` y los índices por nombre. Las escalas de otras tradiciones están en
// `tradicionales`.

extension TipoDeEscala {
    /// Las escalas occidentales (las de la música clásica, el jazz, el blues, el siglo XX y la popular), en el orden
    /// en que tienen prioridad al identificar unas notas. Las de otras tradiciones están en `tradicionales`, y todas
    /// juntas, en `catalogo`.
    public static let occidentales: [TipoDeEscala] = [
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
        .lidioSegundaSextaAumentadas, .ultrafrigio, .oriental, .jonicoSegundaQuintaAumentadas,
        .locrioTerceraSeptimaDisminuidas,
        .lidioAumentadoSextaAumentada, .lidioDominanteAumentado, .locrioSegundaNaturalCuartaDisminuida,
        .superlocrioTerceraDisminuida,
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

    /// Todas las escalas del catálogo, en el orden en que tienen prioridad: primero las occidentales (`occidentales`,
    /// en su orden) y después las de otras tradiciones (`tradicionales`, en el suyo).
    ///
    /// Cuando dos escalas comparten algo, gana la primera: al buscar por nombre (aunque un nombre gana siempre a un
    /// alias o a una variante: «Hijaz» es el maqam Ḥijāz y no el dromos Hitzáz, que lo tiene de variante), al
    /// nombrar una escala por sus notas (`propio`: Do Re Mi Fa Sol La Si es la mayor y no Bilāval) y en el orden de
    /// `equivalentes`.
    /// `Escala.identificar` busca solo en `occidentales`, salvo que se le pasen otros tipos.
    public static let catalogo: [TipoDeEscala] = occidentales + tradicionales

    /// El tipo de un nombre en español o en inglés, sin distinguir mayúsculas ni guiones: "dórico", "dorico",
    /// "Dorian", "harmonic minor", "whole-tone". También lee las escalas de `tradicionales`: "Kafi", "hitzaz",
    /// "melakarta 15". Si no es ninguno, lanza `ErrorDeLecturaDeTeoria` (`.tipoDeEscalaNoReconocido`).
    ///
    ///     try TipoDeEscala(leyendo: "Dorian").nombre   // "dórico"
    public init(leyendo nombre: String) throws {
        guard let tipo = TipoDeEscala.buscar(nombre: nombre, aceptarIngles: true) else {
            throw ErrorDeLecturaDeTeoria(texto: nombre, posicion: nil, motivo: .tipoDeEscalaNoReconocido(nombre))
        }
        self = tipo
    }

    /// Como `init(leyendo:)`, devolviendo `nil`; con `aceptarIngles: false` solo acepta los nombres en español
    /// (y los tradicionales), para no mezclar idiomas: "Re dorian" no es una escala.
    package static func buscar(nombre: String, aceptarIngles: Bool) -> TipoDeEscala? {
        let n = TipoDeEscala.normalizar(nombre)
        return indicePorNombre[n] ?? (aceptarIngles ? indiceInternacional[n] : nil)
    }

    /// Nombres, alias y variantes normalizados → tipo. Un nombre gana a un alias o a una variante (Hijaz es el maqam
    /// Ḥijāz, no el dromos Hitzáz, que lo tiene de variante); entre los demás, gana el primero de `catalogo`.
    package static let indicePorNombre: [String: TipoDeEscala] = {
        var indice: [String: TipoDeEscala] = [:]
        for tipo in catalogo where indice[normalizar(tipo.nombre)] == nil {
            indice[normalizar(tipo.nombre)] = tipo
        }
        for tipo in catalogo {
            for nombre in tipo.alias + tipo.variantes where indice[normalizar(nombre)] == nil {
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
    /// (4ª → 4), «−» como «-», «…» como «..», la ı sin punto del turco como i (makamı → makami) y con
    /// un solo espacio entre palabras. En devanagari no se quitan los signos: las vocales y el virama
    /// son parte de la letra (भैरव y भैरवी son dos rāgas).
    package static func normalizar(_ texto: String) -> String {
        let devanagari = texto.unicodeScalars.contains { (0x0900...0x097F).contains($0.value) }
        return texto.replacingOccurrences(of: "♯", with: "#")
            .replacingOccurrences(of: "♭", with: "b")
            .replacingOccurrences(of: "♮", with: "")
            .replacingOccurrences(of: "ª", with: "")
            .replacingOccurrences(of: "−", with: "-")
            .replacingOccurrences(of: "…", with: "..")
            .replacingOccurrences(of: "ı", with: "i")
            .folding(options: devanagari ? [.caseInsensitive] : [.diacriticInsensitive, .caseInsensitive], locale: nil)
            .lowercased()
            .split(whereSeparator: { $0 == " " || $0 == "-" }).joined(separator: " ")
    }
}
