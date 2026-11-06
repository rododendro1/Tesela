import ArmoniaNucleo

// MARK: - Ficha de una escala del catálogo

/// Lo que el catálogo sabe de una escala además de su nombre y sus intervalos: en qué música se usa (las
/// occidentales), su categoría y su subtradición (las de otras tradiciones), el mēḷa de un rāga janya y sus versiones
/// microtonales.
///
/// Se escribe en la declaración de la escala, con el resto de sus datos:
///
///     public static let dorico = TipoDeEscala(
///         nombre: "dórico", intervalos: […], alias: ["menor dórica"], variantes: ["dórica"],
///         usos: [.clasica, .jazz])
///     public static let mohanam = TipoDeEscala(nombre: "Mohanam", intervalos: […], categoria: .janya, mela: 28)
///     public static let pelogTembung = TipoDeEscala(nombre: "Pélog tembung", intervalos: […], categoria: .pathet,
///         subtradicion: .bali, afinaciones: [.init(.razones, pasos: […])])
///     public static let rastMakami = TipoDeEscala(nombre: "Rast makamı", intervalos: […], categoria: .makam,
///         llevaLaCategoria: true)
///
/// `llevaLaCategoria` va en las que ya tienen en el nombre la palabra de su categoría, para que `nombreCompleto` no
/// la repita (una prueba lo comprueba contra el nombre).
///
/// De ahí salen `TipoDeEscala.usos`, `categoria`, `subtradicion`, `padre`, `microtonal` y `afinaciones`, y
/// `UsoDeEscala.tipos` y `TipoDeEscalaMicrotonal.catalogo`. La tradición no va en la ficha: la da su lista en
/// `TipoDeEscala.listasTradicionales`. Los nombres en otros idiomas tampoco: están en `Nombres/`. La subtradición de
/// las escalas de la India no se escribe: la da su categoría.
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
        let fuente: String?

        package init(
            _ sistema: SistemaMicrotonal, pasos: [Int], pasosDescendentes: [Int]? = nil, fuente: String? = nil
        ) {
            self.sistema = sistema
            self.pasos = pasos
            self.pasosDescendentes = pasosDescendentes
            self.fuente = fuente
        }
    }

    /// En qué música se usa, en el orden de `UsoDeEscala.allCases`; vacío en las de otras tradiciones.
    package let usos: [UsoDeEscala]
    /// La categoría en su tradición; `nil` en las occidentales.
    package let categoria: CategoriaTradicional?
    /// La subtradición: la escrita en la declaración o, si no la hay, la que da la categoría (`Subtradicion.de(_:)`).
    package let subtradicion: Subtradicion?
    /// El número del mēḷa de un rāga janya; `nil` en las demás escalas y en los janya sin un padre claro.
    package let mela: Int?
    /// Las versiones microtonales: la primera, la de su teoría de hoy; las demás, de otros autores (con `fuente`).
    package let afinaciones: [Afinacion]
    /// ¿Lleva ya el nombre la palabra de su categoría («Rast makamı», «jins Rāst», «échos prótos», «P'yŏngjo»), o
    /// una que la sustituye («shadd ʿUshshāq»)? Entonces `nombreCompleto` no la antepone.
    package let llevaLaCategoria: Bool

    package init(
        usos: [UsoDeEscala] = [], categoria: CategoriaTradicional? = nil, subtradicion: Subtradicion? = nil,
        mela: Int? = nil, afinaciones: [Afinacion] = [], llevaLaCategoria: Bool = false
    ) {
        self.usos = UsoDeEscala.allCases.filter { usos.contains($0) }
        self.categoria = categoria
        self.subtradicion = subtradicion ?? categoria.flatMap(Subtradicion.de)
        self.mela = mela
        self.afinaciones = afinaciones
        self.llevaLaCategoria = llevaLaCategoria
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
    /// una estuviera en dos listas de `listasTradicionales`, vale la tradición de la primera.
    package static let delCatalogo: [IdentidadDeEscala: EntradaDelCatalogo] = {
        var tradiciones: [IdentidadDeEscala: Tradicion] = [:]
        for lista in listasTradicionales {
            for tipo in lista.tipos where tradiciones[tipo.identidad] == nil {
                tradiciones[tipo.identidad] = lista.tradicion
            }
        }
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

    /// Una copia con estos usos: para las escalas del catálogo que salen de una función (las cromáticas).
    package func con(usos: [UsoDeEscala]) -> TipoDeEscala {
        TipoDeEscala(
            nombre: nombre, intervalos: intervalos, intervalosDescendentes: intervalosDescendentes, alias: alias,
            variantes: variantes, ficha: FichaDeEscala(usos: usos))
    }
}
