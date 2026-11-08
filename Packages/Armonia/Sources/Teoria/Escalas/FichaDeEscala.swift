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
///         estilos: [.clasica, .jazz])
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
/// `EstiloDeEscala.tipos`, `RegionDeEscala.tipos` y `TipoDeEscalaMicrotonal.catalogo`. La tradición no va en la ficha:
/// la da su lista en `TipoDeEscala.listasTradicionales`, o es la occidental en las de `TipoDeEscala.todos`. Los nombres
/// en otros idiomas tampoco: están en `Nombres/`. El estilo de las escalas de la India no se escribe: lo da su
/// categoría.
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

        package init(
            _ sistema: SistemaMicrotonal, pasos: [Int], pasosDescendentes: [Int]? = nil, fuente: FuenteTeorica? = nil
        ) {
            self.sistema = sistema
            self.pasos = pasos
            self.pasosDescendentes = pasosDescendentes
            self.fuente = fuente
        }
    }

    /// En qué estilos se usa, en el orden de `EstiloDeEscala.allCases`: los escritos en la declaración o, si no los
    /// hay, el que da la categoría (`EstiloDeEscala.de(_:)`).
    package let estilos: [EstiloDeEscala]
    /// De qué regiones viene, en el orden de `RegionDeEscala.allCases`.
    package let regiones: [RegionDeEscala]
    /// La categoría en su tradición; `nil` en las occidentales.
    package let categoria: CategoriaTradicional?
    /// La escala madre de la que sale (el mēḷa de un janya, el thāṭ de un rāga, el grāma de una mūrchanā, el laras
    /// de un pathet), por su identidad; `nil` si no tiene una clara.
    package let padre: IdentidadDeEscala?
    /// Las versiones microtonales: la primera, la de su teoría de hoy; las demás, de otros autores (con `fuente`).
    package let afinaciones: [Afinacion]
    /// El teórico que definió la escala (los géneros de Ptolomeo, los colores de Aristóxeno…); `nil` en las demás.
    package let fuente: FuenteTeorica?

    package init(
        estilos: [EstiloDeEscala] = [], regiones: [RegionDeEscala] = [], categoria: CategoriaTradicional? = nil,
        padre: IdentidadDeEscala? = nil, afinaciones: [Afinacion] = [], fuente: FuenteTeorica? = nil
    ) {
        let estilos = estilos.isEmpty ? (categoria.flatMap(EstiloDeEscala.de).map { [$0] } ?? []) : estilos
        self.estilos = EstiloDeEscala.allCases.filter { estilos.contains($0) }
        self.regiones = RegionDeEscala.allCases.filter { regiones.contains($0) }
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

    /// La escala del catálogo con la misma identidad, su tradición y sus versiones microtonales.
    package typealias EntradaDelCatalogo = (
        tipo: TipoDeEscala, tradicion: Tradicion?, afinaciones: [TipoDeEscalaMicrotonal]
    )

    /// Identidad → escala del catálogo. Si dos escalas tuvieran la misma identidad, vale la primera de `catalogo`; si
    /// una estuviera en dos listas de `listasTradicionales`, vale la tradición de la primera. Las de `occidentales` que
    /// no están en ninguna lista son de la tradición occidental.
    package static let delCatalogo: [IdentidadDeEscala: EntradaDelCatalogo] = {
        var tradiciones: [IdentidadDeEscala: Tradicion] = [:]
        for lista in listasTradicionales {
            for tipo in lista.tipos where tradiciones[tipo.identidad] == nil {
                tradiciones[tipo.identidad] = lista.tradicion
            }
        }
        for tipo in occidentales where tradiciones[tipo.identidad] == nil { tradiciones[tipo.identidad] = .occidental }
        var tabla: [IdentidadDeEscala: EntradaDelCatalogo] = [:]
        for tipo in catalogo where tabla[tipo.identidad] == nil {
            let afinaciones = tipo.ficha.afinaciones.map {
                TipoDeEscalaMicrotonal(
                    tipo, $0.sistema, pasos: $0.pasos, pasosDescendentes: $0.pasosDescendentes, fuente: $0.fuente)
            }
            tabla[tipo.identidad] = (tipo: tipo, tradicion: tradiciones[tipo.identidad], afinaciones: afinaciones)
        }
        return tabla
    }()

    /// Una copia con estos estilos: para las escalas del catálogo que salen de una función (las cromáticas).
    package func con(estilos: [EstiloDeEscala]) -> TipoDeEscala {
        TipoDeEscala(
            nombre: nombre, intervalos: intervalos, intervalosDescendentes: intervalosDescendentes, alias: alias,
            variantes: variantes, ficha: FichaDeEscala(estilos: estilos))
    }
}
