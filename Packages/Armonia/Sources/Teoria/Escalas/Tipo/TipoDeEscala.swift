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
    /// La clave fija de una escala del catálogo: «dorico», «kafi», «pelog-lima». Sale de su nombre en español, pero
    /// no cambia si el nombre cambia, así que es lo que guarda el JSON y lo que la identifica (`identidad`). `nil` en
    /// las que no son del catálogo: las propias, sus modos y sus formas ascendente y descendente.
    public var clave: String? { caja.clave }
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
    /// Lo demás que el catálogo sabe de la escala (estilos, regiones, categoría, mēḷa, microtonos), escrito en su
    /// declaración. No se codifica ni cuenta para `==`, y las propiedades públicas no lo leen de aquí sino de la
    /// escala del catálogo con la misma identidad (`datosDelCatalogo`).
    package var datos: DatosDeEscala { caja.datos }
    /// Los datos, guardados aparte y compartidos entre las copias: así un `TipoDeEscala` ocupa unos 50 bytes y no
    /// unos 330. Sin optimizar, cada fila de las listas de nombres (`Nombres/`) construye en la pila su tipo, y con
    /// los datos dentro las del ruso y el griego llegaron a desbordar la pila de un hilo secundario (512 KB).
    private let caja: CajaDeDatos

    /// Nombre, alias y variantes en forma normalizada (`normalizar`: sin diacríticos ni mayúsculas, `#`/`b`), sin
    /// repetidos. Es lo que se compara al buscar por nombre.
    package var aliasNormalizados: [String] {
        var vistos = Set<String>()
        return ([nombre] + alias + variantes).map(TipoDeEscala.normalizar).filter { vistos.insert($0).inserted }
    }

    // «descenso» es el nombre que tenía `intervalosDescendentes`: se conserva al codificar.
    private enum CodingKeys: String, CodingKey {
        case nombre, clave, intervalos, alias, variantes
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
            variantes: variantes, clave: nil, datos: nil)
    }

    /// Una escala occidental del catálogo, con sus estilos, las regiones de donde viene (las populares: la flamenca,
    /// de Andalucía), si las tiene, sus versiones microtonales y, si no es un modo, su clase (el hexacordo es un
    /// `.fragmento`).
    package init(
        nombre: String, intervalos: [Intervalo], intervalosDescendentes: [Intervalo]? = nil, alias: [String] = [],
        variantes: [String] = [], estilos: [Estilo], corrientes: [Corriente] = [], regiones: [RegionDeEscala] = [],
        afinaciones: [DatosDeEscala.Afinacion] = [], documentada: Referencia? = nil, clase: ClaseDeEscala? = nil,
        clave: String? = nil
    ) {
        self.init(
            nombre: nombre, intervalos: intervalos, intervalosDescendentes: intervalosDescendentes, alias: alias,
            variantes: variantes, clave: clave,
            datos: DatosDeEscala(
                estilos: estilos, corrientes: corrientes, regiones: regiones, afinaciones: afinaciones,
                documentada: documentada, clase: clase))
    }

    /// Una escala de otra tradición, con su categoría y, si los tiene, sus estilos (si no los da la categoría), sus
    /// regiones, el teórico que la definió (`fuente`), la escala madre de la que sale (`padre`: el mēḷa de un
    /// janya, el thāṭ de un rāga indostánico…) y sus versiones microtonales. La tradición se escribe solo si no la
    /// dan la categoría, los estilos, las regiones ni la fuente (`tradicion: .japon, categoria: .escala`).
    package init(
        nombre: String, intervalos: [Intervalo], intervalosDescendentes: [Intervalo]? = nil, alias: [String] = [],
        variantes: [String] = [], tradicion: Tradicion? = nil, categoria: CategoriaTradicional,
        escuelas: [Escuela] = [], regiones: [RegionDeEscala] = [], fuente: FuenteTeorica? = nil,
        padre: TipoDeEscala? = nil,
        afinaciones: [DatosDeEscala.Afinacion] = [], referencias: [Referencia] = [], documentada: Referencia? = nil,
        clave: String? = nil
    ) {
        self.init(
            nombre: nombre, intervalos: intervalos, intervalosDescendentes: intervalosDescendentes, alias: alias,
            variantes: variantes, clave: clave,
            datos: DatosDeEscala(
                tradicion: tradicion, escuelas: escuelas, regiones: regiones, categoria: categoria,
                padre: padre?.identidad,
                afinaciones: afinaciones,
                fuente: fuente, referencias: referencias, documentada: documentada))
    }

    /// Las del catálogo (las que traen `datos`) tienen clave: la que se les da o, si no, la de su nombre
    /// (`claveDeNombre(_:)`). Si se cambia el nombre de una, se le da la clave que tenía, que las pruebas guardan.
    init(
        nombre: String, intervalos: [Intervalo], intervalosDescendentes: [Intervalo]?, alias: [String],
        variantes: [String], clave: String? = nil, datos: DatosDeEscala?
    ) {
        self.nombre = nombre
        let subida = TipoDeEscala.ordenar(intervalos)
        let bajada = intervalosDescendentes.map(TipoDeEscala.ordenar)
        self.intervalos = subida
        self.intervalosDescendentes = bajada == subida ? nil : bajada
        self.alias = alias
        self.variantes = variantes
        caja = datos.map { CajaDeDatos($0, clave: clave ?? TipoDeEscala.claveDeNombre(nombre)) } ?? .vacia
    }

    /// Las escalas guardadas antes de que hubiera `variantes` se leen sin ellas, y las guardadas antes de que hubiera
    /// `clave`, sin ella: se reconocen, como antes, por su nombre y sus intervalos (`identidad`).
    public init(from decoder: any Decoder) throws {
        let datos = try decoder.container(keyedBy: CodingKeys.self)
        nombre = try datos.decode(String.self, forKey: .nombre)
        intervalos = try datos.decode([Intervalo].self, forKey: .intervalos)
        intervalosDescendentes = try datos.decodeIfPresent([Intervalo].self, forKey: .intervalosDescendentes)
        alias = try datos.decode([String].self, forKey: .alias)
        variantes = try datos.decodeIfPresent([String].self, forKey: .variantes) ?? []
        caja = try datos.decodeIfPresent(String.self, forKey: .clave).map { CajaDeDatos(.vacia, clave: $0) } ?? .vacia
    }

    public func encode(to encoder: any Encoder) throws {
        var datos = encoder.container(keyedBy: CodingKeys.self)
        try datos.encode(nombre, forKey: .nombre)
        try datos.encodeIfPresent(clave, forKey: .clave)
        try datos.encode(intervalos, forKey: .intervalos)
        try datos.encodeIfPresent(intervalosDescendentes, forKey: .intervalosDescendentes)
        try datos.encode(alias, forKey: .alias)
        try datos.encode(variantes, forKey: .variantes)
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

    /// Qué escala es, y no solo qué notas tiene: con ella se buscan su tradición, su categoría, sus estilos, sus
    /// afinaciones y sus nombres en otros idiomas. Kāfī y el dórico tienen el mismo contenido y distinta identidad.
    /// La de una escala del catálogo es su `clave`. Una sin clave que se llama y suena como una del catálogo (una
    /// escrita a mano, o guardada antes de que hubiera claves) es esa; si no, es una escala propia.
    package var identidad: IdentidadDeEscala {
        if let clave { return .delCatalogo(clave) }
        let propia = IdentidadDeEscala.Propia(
            nombre: nombre, intervalos: intervalos, intervalosDescendentes: intervalosDescendentes)
        return TipoDeEscala.clavesPorNombreYContenido[propia].map(IdentidadDeEscala.delCatalogo) ?? .propia(propia)
    }

    /// El nombre y el contenido de cada escala del catálogo → su clave. Si dos se llamaran y sonaran igual, vale la
    /// primera de `catalogo`.
    private static let clavesPorNombreYContenido: [IdentidadDeEscala.Propia: String] = {
        var tabla: [IdentidadDeEscala.Propia: String] = [:]
        for tipo in catalogo {
            guard let clave = tipo.clave else { continue }
            let propia = IdentidadDeEscala.Propia(
                nombre: tipo.nombre, intervalos: tipo.intervalos, intervalosDescendentes: tipo.intervalosDescendentes)
            if tabla[propia] == nil { tabla[propia] = clave }
        }
        return tabla
    }()

    /// La clave que sale de un nombre: sin tildes ni mayúsculas, con guiones entre las palabras y sin apóstrofos ni
    /// puntos, como `normalizar`: «Rast makamı» → «rast-makami», «lidio ♯5» → «lidio-#5», «ʿAjam» → «ajam».
    package static func claveDeNombre(_ nombre: String) -> String {
        normalizar(nombre).replacingOccurrences(of: "ə", with: "e").filter { !"'’ʿʾ.".contains($0) }
            .split(separator: " ").joined(separator: "-")
    }

    /// Otras escalas del catálogo (`catalogo`, en su orden) con el mismo contenido y otro
    /// nombre: para la mayor, Bilāval, Dhīraśaṅkarābharaṇam y Qīngyuè.
    public var equivalentes: [TipoDeEscala] {
        TipoDeEscala.catalogo.filter { $0 == self && $0.nombre != nombre }
    }

    /// El modo que empieza en el grado `grado` (1 = la propia escala): la rotación de sus intervalos al subir.
    /// Si la rotación es una escala del catálogo (con las mismas notas al subir y al bajar), devuelve esa, la primera
    /// de `catalogo`: el segundo modo de la mayor es el dórico, y el de una pentatónica china, otra pentatónica china.
    ///
    ///     TipoDeEscala.mayor.modo(grado: 6)   // .menorNatural
    public func modo(grado: Int) -> TipoDeEscala {
        let n = intervalos.count
        let desde = modulo(grado - 1, n)
        if desde == 0 { return self }
        let nuevos = (0..<n).map { i in
            Intervalo.simpleAscendente(
                pasosDeQuinta: intervalos[(desde + i) % n].pasosDeQuinta - intervalos[desde].pasosDeQuinta)
        }
        let candidato = TipoDeEscala(nombre: "\(nombre), modo \(desde + 1)", intervalos: nuevos)
        return TipoDeEscala.delCatalogo(con: candidato.contenido) ?? candidato
    }

    // MARK: Contenido

    /// Lo que suena de una escala, sin su nombre: sus intervalos al subir y al bajar. Es lo que compara `==`, así que
    /// un `Set<TipoDeEscala>` junta Kāfī y el dórico; para guardar escalas distintas aunque suenen igual, `identidad`
    /// (o `clave`, en las del catálogo); para dejarlo claro al juntarlas por cómo suenan, `contenido`.
    ///
    ///     Set([TipoDeEscala.kafi, .dorico].map(\.contenido)).count   // 1
    public struct Contenido: Hashable, Sendable {
        /// Los intervalos al subir, ordenados (`TipoDeEscala.intervalos`).
        public let intervalos: [Intervalo]
        /// Los de bajar, si son otros (`TipoDeEscala.intervalosDescendentes`).
        public let intervalosDescendentes: [Intervalo]?
    }

    /// Sus intervalos al subir y al bajar, sin el nombre: lo que compara `==`.
    public var contenido: Contenido {
        Contenido(intervalos: intervalos, intervalosDescendentes: intervalosDescendentes)
    }

    /// La primera escala de `catalogo` con ese contenido, si la hay.
    package static func delCatalogo(con contenido: Contenido) -> TipoDeEscala? { porContenido[contenido] }

    /// Contenido → la primera escala de `catalogo` que suena así.
    private static let porContenido: [Contenido: TipoDeEscala] = {
        var tabla: [Contenido: TipoDeEscala] = [:]
        for tipo in catalogo where tabla[tipo.contenido] == nil { tabla[tipo.contenido] = tipo }
        return tabla
    }()
}

/// Los datos y la clave de un `TipoDeEscala`, en el montón. Son inmutables, así que compartirlos entre copias y entre
/// hilos es seguro.
private final class CajaDeDatos: Sendable {
    let datos: DatosDeEscala
    let clave: String?
    init(_ datos: DatosDeEscala, clave: String?) {
        self.datos = datos
        self.clave = clave
    }
    /// La de las escalas sin datos ni clave (las propias, las leídas de JSON sin clave): una sola para todas.
    static let vacia = CajaDeDatos(.vacia, clave: nil)
}

/// La identidad de un `TipoDeEscala` (`TipoDeEscala.identidad`): la clave de una escala del catálogo, o el nombre y
/// el contenido de una propia. Dos tipos con los mismos intervalos son iguales (`==`); solo son la misma escala si
/// además tienen la misma identidad. Es la clave de las tablas que dicen algo de una escala concreta: una escala
/// propia que se llame «Kafi» pero suene distinto no es el thāṭ, y Āsāvarī no es la escala menor natural.
package enum IdentidadDeEscala: Hashable, Sendable {
    case delCatalogo(String)
    case propia(Propia)

    /// Lo que identifica a una escala que no es del catálogo: su nombre y su contenido.
    package struct Propia: Hashable, Sendable {
        let nombre: String
        let intervalos: [Intervalo]
        let intervalosDescendentes: [Intervalo]?
    }
}

extension TipoDeEscala: Hashable {
    public static func == (a: TipoDeEscala, b: TipoDeEscala) -> Bool { a.contenido == b.contenido }
    public func hash(into hasher: inout Hasher) { hasher.combine(contenido) }
}

// Las escalas adicionales (modos derivados, exóticas, hexatónicas, Messiaen, jazz…) están en
// `Catalogo/TipoDeEscala+Occidental.swift` y `+Occidental+Exoticas.swift`, y las de otras tradiciones, en un fichero
// por tradición en `Catalogo/`.

// MARK: - Idiomas

extension TipoDeEscala {
    /// Nombre en español ("dórico"), inglés ("dorian"), catalán ("dòric"), gallego ("dórico"),
    /// euskera ("doriarra"), portugués ("dórico"), francés ("dorien"), italiano ("dorico"), alemán
    /// ("dorisch"), ruso ("дорийский"), o griego ("δώριος"). Un tipo
    /// sin nombre conocido en ese idioma (como un modo de una escala propia) usa su nombre español.
    public func nombre(en notacion: Notacion) -> String {
        // El español es el del propio tipo (un tipo propio puede coincidir en intervalos con uno del catálogo).
        if notacion.textos == .espanol { return nombre }
        // Los nombres propios de otras tradiciones (Kafi, Hitzaz…) son los mismos en todos los idiomas, salvo
        // los que se traducen (las escalas andinas, los tetracordos…): se buscan por su nombre, no por el tipo.
        return NombresDeEscalas.de(notacion).nombre(de: self) ?? nombre
    }

    /// Los otros nombres del tipo en el idioma de la notación, del más usado al menos: «ionian» para la mayor en
    /// inglés, «menor dórica» para el dórico en español. Vacío si no tiene ninguno en ese idioma o no es del catálogo.
    public func alias(en notacion: Notacion) -> [String] {
        if notacion.textos == .espanol { return alias }
        return entrada(en: notacion)?.alias ?? []
    }

    /// Las otras formas de escribir el nombre o un alias en el idioma de la notación (otro género, otra
    /// transliteración, otra escritura): «dòrica» para el dórico en catalán. Vacío si no tiene ninguna.
    public func variantes(en notacion: Notacion) -> [String] {
        if notacion.textos == .espanol { return variantes }
        return entrada(en: notacion)?.variantes ?? []
    }

    /// La fila del tipo en los nombres del idioma: primero por identidad, como en `nombre(en:)`.
    private func entrada(en notacion: Notacion) -> NombresDeEscalas.Entrada? {
        let nombres = NombresDeEscalas.de(notacion)
        return nombres.tradicionales[identidad] ?? nombres.porTipo[self]
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
        estilos: [.clasica, .jazz])
    public static let dorico = TipoDeEscala(
        nombre: "dórico",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["menor dórica"], variantes: ["dórica"],
        estilos: [.jazz, .clasica], corrientes: [.modal])
    public static let frigio = TipoDeEscala(
        nombre: "frigio",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["frigia"],
        estilos: [.clasica, .jazz], corrientes: [.modal])
    public static let lidio = TipoDeEscala(
        nombre: "lidio",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["lidia"],
        estilos: [.jazz, .clasica], corrientes: [.modal])
    public static let mixolidio = TipoDeEscala(
        nombre: "mixolidio",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["mixolidia"],
        estilos: [.jazz, .clasica], corrientes: [.modal])
    public static let menorNatural = TipoDeEscala(
        nombre: "menor natural",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["menor", "eólico", "menor antigua"], variantes: ["eólica"],
        estilos: [.clasica, .jazz])
    public static let locrio = TipoDeEscala(
        nombre: "locrio",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        variantes: ["locria"],
        estilos: [.jazz, .clasica], corrientes: [.bebop])
    public static let menorArmonica = TipoDeEscala(
        nombre: "menor armónica",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        estilos: [.clasica, .popRock], corrientes: [.metalNeoclasico])
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
        estilos: [.clasica], documentada: .rameau1722)
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
        estilos: [.jazz], corrientes: [.modal])
    public static let pentatonicaMayor = TipoDeEscala(
        nombre: "pentatónica mayor",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        alias: ["pentatónica"],
        estilos: [.folclore, .popRock, .blues], corrientes: [.rock])
    public static let pentatonicaMenor = TipoDeEscala(
        nombre: "pentatónica menor",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        estilos: [.blues, .popRock, .folclore], corrientes: [.rock])
    public static let blues = TipoDeEscala(
        nombre: "blues",
        intervalos: [
            .unisono, .terceraMenor, .cuartaJusta, .cuartaAumentada,
            .quintaJusta, .septimaMenor,
        ],
        estilos: [.blues], afinaciones: [.init(.razones, pasos: [0, 350, 498, 600, 702, 969])])
    public static let tonosEnteros = TipoDeEscala(
        nombre: "tonos enteros",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaAumentada, .sextaAumentada,
        ],
        alias: ["hexatónica", "modo 1 de Messiaen", "de Debussy", "Debussy", "aumentada auxiliar"],
        estilos: [.deCompositor, .jazz], corrientes: [.impresionismo, .bebop], documentada: .glinka1842)
    public static let disminuida = TipoDeEscala(
        nombre: "disminuida tono-semitono",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .sextaMayor, .septimaMayor,
        ],
        alias: ["disminuida", "octatónica", "modo 2 de Messiaen inverso", "disminuida auxiliar"],
        estilos: [.deCompositor, .jazz], documentada: .rimskiKorsakov1867)
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
        .bebopDominante, .bebopMayor, .bebopDorico, .bebopLocrio, .bebopLidio,
        .doricoQuintaDisminuida, .frigioCuartaDisminuida, .lidioTerceraMenor, .mixolidioSegundaMenor,
        .lidioAumentadoSegundaAumentada, .locrioSeptimaDisminuida,
        .dobleArmonica, .menorHungara, .mayorHungara, .napolitanaMenor, .napolitanaMayor,
        .enigmatica, .persa, .mayorLocria, .lidioMenor, .prometeo, .prometeoNapolitano,
        .disminuidaSemitonoTono, .aumentada, .aumentadaSemitonoTercera, .bluesMayor, .egipcia, .cromatica,
        .cromaticaConCincoBemoles, .cromaticaConTresBemoles, .cromaticaConDosBemoles, .cromaticaConUnBemol,
        .cromaticaConCincoSostenidos,
        .bebopMenorMelodica, .bebopMenorArmonica, .flamenca, .petrushka, .petrushkaMenor, .tritonoDeDosSemitonos,
        .hexatonicaDeArmonicos,
        .messiaen3, .tcherepnin, .messiaen4, .messiaen5, .messiaen6, .messiaen7,
        .lidioSegundaSextaAumentadas, .ultrafrigio, .oriental, .jonicoSegundaQuintaAumentadas,
        .locrioTerceraSeptimaDisminuidas,
        .lidioAumentadoSextaAumentada, .lidioDominanteAumentado, .locrioSegundaNaturalCuartaDisminuida,
        .superlocrioTerceraDisminuida,
        .lidioSextaAumentada, .mixolidioAumentado, .eolicoCuartaAumentada, .locrioDominante, .jonicoSegundaAumentada,
        .ultralocrioTerceraDisminuida,
        .pentatonicaDominante, .pentatonicaMenorSexta, .pentatonicaMayorSextaMenor, .pentatonicaMenorQuintaDisminuida,
        .pentatonicaMayorTerceraMenor, .pentatonicaMenorSextaMenor,
        .bluesDeNueveNotas, .bluesMenorConSegunda, .hexacordo, .argelina,
        .jonicoSinCuarta, .mixolidioSinTercera, .doricoSinSexta, .eolicoSinSegunda, .hexatonicaDeDosTriadas,
        .hexatonicaMenorDeDosTriadas, .mayorRumana,
        .ultralocrioSextaDisminuida, .menorArmonicaQuintaDisminuida, .superlocrioSextaNatural,
        .menorMelodicaQuintaAumentada, .doricoSegundaMenorCuartaAumentada, .lidioAumentadoTerceraAumentada,
        .jonicoSegundaMenor, .jonicoQuintaDisminuida, .jonicoSextaAumentada,
        .pentatonicaMixolidia, .pentatonicaLidia, .pentatonicaEscocesa,
    ]

    /// Todas las escalas del catálogo, en el orden en que tienen prioridad: primero las occidentales (`occidentales`,
    /// en su orden) y después las de otras tradiciones (`tradicionales`, en el suyo).
    ///
    /// Cuando dos escalas comparten algo, gana la primera: al buscar por nombre (aunque un nombre gana siempre a un
    /// alias o a una variante: «Hijaz» es el maqam Ḥijāz y no el dromos Hitzáz, que lo tiene de variante), al
    /// nombrar una escala por sus notas (`propio`: Do Re Mi Fa Sol La Si es la mayor y no Bilāval) y en el orden de
    /// `equivalentes`.
    /// `Escala.identificar(notas:tipos:)` busca solo en `occidentales`, salvo que se le pasen otros tipos.
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

    /// La del catálogo con ese nombre, alias o variante en cualquier idioma, sin mirar mayúsculas, tildes ni guiones:
    /// «dórico», «Dorian», «dorisch», «дорийский», «Kafi». Primero el español y el inglés, como `init(leyendo:)`, y
    /// después los otros idiomas, en el orden de `Idioma.allCases`. `nil` si no es ninguna.
    ///
    ///     TipoDeEscala.buscar(nombre: "dorisch")   // .dorico
    public static func buscar(nombre: String) -> TipoDeEscala? {
        if let tipo = buscar(nombre: nombre, aceptarIngles: true) { return tipo }
        let normalizado = normalizar(nombre)
        for idioma in Idioma.allCases {
            if let tipo = NombresDeEscalas.de(idioma).indice[normalizado] { return tipo }
        }
        return nil
    }

    /// Las del catálogo cuyo nombre, alias o variante contiene el texto en algún idioma (sin mirar mayúsculas ni
    /// tildes), en el orden del catálogo; todas, si el texto está vacío.
    ///
    ///     TipoDeEscala.buscar(conteniendo: "bebop")   // las escalas bebop
    public static func buscar(conteniendo texto: String) -> [TipoDeEscala] {
        let buscado = normalizar(texto)
        guard !buscado.isEmpty else { return catalogo }
        let notaciones = Idioma.allCases.map { Notacion.compacta(.espanol).conTextos(en: $0) }
        return catalogo.filter { tipo in
            notaciones.contains { notacion in tipo.nombres(en: notacion).contains { normalizar($0).contains(buscado) } }
        }
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

    /// El nombre como se busca en el catálogo, con un solo espacio entre palabras: `String.normalizadoParaBuscar()`.
    package static func normalizar(_ texto: String) -> String { texto.normalizadoParaBuscar() }
}
