import Elementos

// MARK: - Ficha de una escala del catálogo

/// Lo que el catálogo sabe de una escala además de su nombre y sus intervalos: sus subtradiciones (los estilos en que
/// se usa y las regiones de donde viene), su categoría (las de otras tradiciones), su escala madre (`padre`) y sus
/// versiones microtonales.
///
/// Se escribe en la declaración de la escala, con el resto de sus datos:
///
///     public static let dorico = TipoDeEscala(
///         nombre: "dórico", intervalos: […], alias: ["menor dórica"], variantes: ["dórica"],
///         estilos: [.jazz, .clasica])
///     public static let mohanam = TipoDeEscala(
///         nombre: "Mohanam", intervalos: […], categoria: .janya, padre: .melakarta(28))
///     public static let pelogTembung = TipoDeEscala(nombre: "Pélog tembung", intervalos: […], categoria: .pathet,
///         regiones: [.bali], afinaciones: [.init(.razones, pasos: […])])
///     public static let rastMakami = TipoDeEscala(nombre: "Rast makamı", intervalos: […], categoria: .makam)
///
/// Que el nombre ya lleve la palabra de su categoría («Rast makamı») no se escribe: se deduce del nombre
/// (`TipoDeEscala.llevaLaCategoria`), para que `nombreCompleto` no la repita.
///
/// De ahí salen `TipoDeEscala.estilos`, `regiones`, `categoria`, `padre`, `microtonal` y `afinaciones`, y
/// `Estilo.tipos`, `RegionDeEscala.tipos` y `TipoDeEscalaMicrotonal.catalogo`. La tradición (`tradicion`) se
/// deduce de la categoría, de las subtradiciones o de la fuente, y solo se escribe en las que no la dan
/// (`tradicion: .japon, categoria: .escala`); cada lista de `TipoDeEscala.listasTradicionales` tiene solo escalas de
/// la suya. Los nombres en otros idiomas no van en la ficha: están en `Nombres/`. El estilo de las escalas de la India
/// no se escribe: lo da su categoría.
///
/// Las propiedades públicas no leen la ficha del valor, sino la de la escala del catálogo con su misma `identidad`:
/// un tipo leído de un fichero o escrito a mano con el nombre y las notas de Bayātī tiene sus microtonos, y una escala
/// propia que se llame «Kafi» pero suene distinto no es el thāṭ.
package struct FichaDeEscala: Sendable {
    /// Una versión microtonal, sin la escala temperada (que es la de la ficha): los argumentos de
    /// `TipoDeEscalaMicrotonal` salvo el primero.
    package struct Afinacion: Sendable {
        let sistema: SistemaMicrotonal
        let pasos: [Int]
        let pasosDescendentes: [Int]?
        let fuente: FuenteTeorica?
        let referencias: [Referencia]

        package init(
            _ sistema: SistemaMicrotonal, pasos: [Int], pasosDescendentes: [Int]? = nil, fuente: FuenteTeorica? = nil,
            referencias: [Referencia] = []
        ) {
            self.sistema = sistema
            self.pasos = pasos
            self.pasosDescendentes = pasosDescendentes
            self.fuente = fuente
            self.referencias = referencias
        }
    }

    /// En qué estilos occidentales se usa, de más a menos importante: el primero es su uso principal.
    package let estilos: [Estilo]
    /// En qué corrientes de sus estilos se usa, de más a menos importante (el jazz modal en el dórico).
    package let corrientes: [Corriente]
    /// En qué escuelas de otra tradición se usa, en el orden de `Escuela.allCases`: las escritas en la declaración o,
    /// si no las hay, la que da la categoría (`Escuela.de(_:)`).
    package let escuelas: [Escuela]
    /// De qué regiones viene, en el orden de `RegionDeEscala.allCases`.
    package let regiones: [RegionDeEscala]
    /// La tradición: la que se escribe en la declaración o, si no, la de su categoría (un rāga es de la India), la de
    /// sus subtradiciones (un estilo occidental, una región) o la de su fuente. `nil` solo en `vacia`.
    package let tradicion: Tradicion?
    /// La categoría en su tradición; `nil` en las occidentales.
    package let categoria: CategoriaTradicional?
    /// La escala madre de la que sale (el mēḷa de un janya, el thāṭ de un rāga, el grāma de una mūrchanā, el laras
    /// de un pathet), por su identidad; `nil` si no tiene una clara.
    package let padre: IdentidadDeEscala?
    /// Las versiones microtonales: la primera, la de su teoría de hoy; las demás, de otros autores (con `fuente`).
    package let afinaciones: [Afinacion]
    /// El teórico que definió la escala (los géneros de Ptolomeo, los colores de Aristóxeno…); `nil` en las demás.
    package let fuente: FuenteTeorica?
    /// Dónde se lee la escala, además de las obras de su lista en `listasTradicionales` y la de su fuente.
    package let referencias: [Referencia]
    /// La obra más antigua que da la escala, con su año: de ahí sale su época de origen.
    package let documentada: Referencia?

    package init(
        tradicion: Tradicion? = nil, estilos: [Estilo] = [], corrientes: [Corriente] = [], escuelas: [Escuela] = [],
        regiones: [RegionDeEscala] = [],
        categoria: CategoriaTradicional? = nil,
        padre: IdentidadDeEscala? = nil, afinaciones: [Afinacion] = [], fuente: FuenteTeorica? = nil,
        referencias: [Referencia] = [], documentada: Referencia? = nil
    ) {
        self.referencias = referencias
        self.documentada = documentada
        self.estilos = Estilo.sinRepetir(estilos)
        var vistas = Set<Corriente>()
        self.corrientes = corrientes.filter { vistas.insert($0).inserted }
        let escuelas = escuelas.isEmpty ? (categoria.flatMap(Escuela.de).map { [$0] } ?? []) : escuelas
        self.escuelas = Escuela.allCases.filter { escuelas.contains($0) }
        self.regiones = RegionDeEscala.allCases.filter { regiones.contains($0) }
        self.tradicion =
            tradicion ?? categoria?.tradicion ?? (estilos.isEmpty ? nil : .occidental) ?? escuelas.first?.tradicion
            ?? regiones.first?.tradicion
            ?? fuente?.tradicion
        self.categoria = categoria
        self.padre = padre
        self.afinaciones = afinaciones
        self.fuente = fuente
    }

    /// La de un tipo que no es del catálogo (o que no tiene más datos).
    package static let vacia = FichaDeEscala()
}

// MARK: - Afinaciones que comparten varias escalas

extension FichaDeEscala.Afinacion {
    /// Cinco partes iguales de 240 cents: el sléndro y sus pathet, y el amadinda de Buganda.
    static let equipentatonica = Self(.razones, pasos: [0, 240, 480, 720, 960])
    /// Siete partes iguales de unos 171 cents: el timbila chopi, el piphat tailandés y el pinpeat camboyano.
    static let equiheptatonica = Self(.razones, pasos: [0, 171, 343, 514, 686, 857, 1029])
    /// El pélog de nueve partes de 133 cents en las notas 1 2 3 5 6: selisir y los modos y pathet con sus intervalos.
    static let pelogSelisir = Self(.razones, pasos: [0, 133, 267, 667, 800])
}

// MARK: - Búsqueda por identidad

extension TipoDeEscala {
    /// La ficha de la escala del catálogo con la misma `identidad` (`FichaDeEscala.vacia` si no es del catálogo).
    package var fichaDelCatalogo: FichaDeEscala { TipoDeEscala.delCatalogo[identidad]?.tipo.ficha ?? .vacia }

    /// La escala del catálogo con la misma identidad, sus versiones microtonales y sus referencias.
    package struct EntradaDelCatalogo: Sendable {
        package let tipo: TipoDeEscala
        package let afinaciones: [TipoDeEscalaMicrotonal]
        package let referencias: [Referencia]
    }

    /// Identidad → escala del catálogo. Si dos escalas tuvieran la misma identidad, vale la primera de `catalogo`.
    package static let delCatalogo: [IdentidadDeEscala: EntradaDelCatalogo] = {
        var deSuLista: [IdentidadDeEscala: [Referencia]] = [:]
        for lista in listasTradicionales {
            for tipo in lista.tipos { deSuLista[tipo.identidad, default: []] += lista.referencias }
        }
        for (obra, tipos) in referenciasOccidentales {
            for tipo in tipos { deSuLista[tipo.identidad, default: []].append(obra) }
        }
        var tabla: [IdentidadDeEscala: EntradaDelCatalogo] = [:]
        for tipo in catalogo where tabla[tipo.identidad] == nil {
            let afinaciones = tipo.ficha.afinaciones.map {
                TipoDeEscalaMicrotonal(
                    tipo, $0.sistema, pasos: $0.pasos, pasosDescendentes: $0.pasosDescendentes, fuente: $0.fuente,
                    referencias: $0.referencias)
            }
            let referencias = Referencia.unicas(
                tipo.ficha.referencias + [tipo.ficha.documentada, tipo.ficha.fuente?.referencia].compactMap { $0 }
                    + (deSuLista[tipo.identidad] ?? []) + afinaciones.flatMap(\.referencias))
            tabla[tipo.identidad] = EntradaDelCatalogo(tipo: tipo, afinaciones: afinaciones, referencias: referencias)
        }
        return tabla
    }()

    /// Dónde se lee la escala: las obras que cita su declaración, la que la documenta, la de su fuente, las de su lista y las de sus
    /// afinaciones, sin repetir; en las occidentales, las de `referenciasOccidentales`. Vacío en las propias y en las
    /// occidentales sintéticas.
    ///
    ///     TipoDeEscala.bayati.referencias.map(\.cita)   // ["Maqam World", "Touma 1996", "Farraj & Abu Shumays 2019"]
    ///     TipoDeEscala.lidioDominante.referencias.map(\.cita)   // ["Levine 1995", "Persichetti 1961", "Lendvai 1971", "Tymoczko 2011"]
    public var referencias: [Referencia] { TipoDeEscala.delCatalogo[identidad]?.referencias ?? [] }

    /// La obra más antigua que da la escala, con su año (`Referencia.anio`), si se sabe: la menor húngara, el libro de
    /// Liszt sobre la música gitana de Hungría (1859); los echoi, el Theōrētikon de Chrysanthos (1832). De ahí sale
    /// su época de origen, por delante de las demás reglas (`epocaDeOrigen`). `nil` en las demás. Por su identidad.
    ///
    ///     TipoDeEscala.menorHungara.documentada?.anio   // 1859
    public var documentada: Referencia? { fichaDelCatalogo.documentada }

    /// Una copia con estos estilos: para las escalas del catálogo que salen de una función (las cromáticas).
    package func con(estilos: [Estilo]) -> TipoDeEscala {
        TipoDeEscala(
            nombre: nombre, intervalos: intervalos, intervalosDescendentes: intervalosDescendentes, alias: alias,
            variantes: variantes, ficha: FichaDeEscala(estilos: estilos))
    }
}
