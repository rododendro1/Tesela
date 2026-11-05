// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo

// MARK: - Nombres de los tipos de escala
//
// Un idioma por fichero: `NombresDeEscalas+Catalan.swift`, `…+Ingles.swift`… Cada uno da el nombre de cada tipo
// del catálogo occidental y, si los tiene, las otras formas con que se lee (alias). Las escalas de otras
// tradiciones (Kafi, Hitzaz, Hirajoshi…) llevan casi todas un nombre propio que se escribe igual en todos los
// idiomas, y no tienen fila: sin ella, una escala conserva su nombre original. Solo la llevan, al final del fichero,
// las que se traducen o se transcriben en ese idioma (las andinas, los tetracordos y las harmoniai griegas, el mayor
// y el menor de las etíopes; en ruso y en griego, casi todas), con `.tradicional(.kafi, "…")`, que nombra la
// escala por su miembro de `TipoDeEscala` (si se renombra o se quita, no compila). El español sale del propio
// catálogo (`TipoDeEscala.nombre` y `alias`). Un idioma nuevo es un fichero más y su fila en `traducidos`.
//
// Las escalas occidentales se buscan por tipo; las tradicionales, por su identidad (`TipoDeEscala.identidad`, la del
// tipo al que apunta la fila), porque `TipoDeEscala` se compara por sus intervalos y Āsāvarī sería la escala menor
// natural.

/// Los nombres de los tipos de escala en un idioma.
package struct NombresDeEscalas: Sendable {
    /// Una fila de un fichero de idioma: el tipo, su nombre y los alias con que también se lee.
    package struct Fila: Sendable {
        let tipo: TipoDeEscala?
        /// La escala tradicional de la fila (la `identidad` de su tipo); `nil` en las occidentales.
        let tradicional: IdentidadDeEscala?
        /// La categoría (rāga, dromos…) a la que da nombre una fila `.categoria`; `nil` en las demás.
        let categoria: CategoriaTradicional?
        let nombre: String
        let alias: [String]

        /// Un tipo occidental del catálogo.
        init(_ tipo: TipoDeEscala, _ nombre: String, alias: [String] = []) {
            self.tipo = tipo
            self.categoria = nil
            self.tradicional = nil
            self.nombre = nombre
            self.alias = alias
        }

        private init(tradicional tipo: TipoDeEscala, nombre: String, alias: [String]) {
            self.tipo = tipo
            self.categoria = nil
            self.tradicional = tipo.identidad
            self.nombre = nombre
            self.alias = alias
        }

        private init(categoria: CategoriaTradicional, nombre: String) {
            self.tipo = nil
            self.categoria = categoria
            self.tradicional = nil
            self.nombre = nombre
            self.alias = []
        }

        /// El nombre de una categoría de escala (`CategoriaTradicional`) en este idioma.
        static func categoria(_ categoria: CategoriaTradicional, _ nombre: String) -> Fila {
            Fila(categoria: categoria, nombre: nombre)
        }

        /// Una escala de otra tradición; sin segundo nombre se escribe como el original.
        static func tradicional(_ tipo: TipoDeEscala, _ traducido: String? = nil, alias: [String] = []) -> Fila {
            Fila(tradicional: tipo, nombre: traducido ?? tipo.nombre, alias: alias)
        }
    }

    /// Nombre y alias de un tipo en este idioma.
    package struct Entrada: Sendable {
        package let nombre: String
        package let alias: [String]
    }

    /// Tipo occidental → su nombre y sus alias. Si un tipo está dos veces, vale la primera fila.
    package let porTipo: [TipoDeEscala: Entrada]

    /// Escala tradicional (por su `identidad`) → su nombre y sus alias en este idioma.
    package let tradicionales: [IdentidadDeEscala: Entrada]

    /// Clase de escala → su nombre en este idioma.
    package let categorias: [CategoriaTradicional: String]

    /// Nombres y alias normalizados → tipo, para leerlos en este idioma. Un nombre gana a un alias; entre
    /// nombres o entre alias, gana el primero.
    package let indice: [String: TipoDeEscala]

    init(_ listadas: [Fila]) {
        // Las tradicionales sin fila (los mēḷa) conservan su nombre original.
        let conFila = Set(listadas.compactMap(\.tradicional))
        var vistas = Set<IdentidadDeEscala>()
        let filas = listadas + TipoDeEscala.tradicionales
            .filter { !conFila.contains($0.identidad) && vistas.insert($0.identidad).inserted }
            .map { Fila.tradicional($0) }
        var porTipo: [TipoDeEscala: Entrada] = [:]
        var tradicionales: [IdentidadDeEscala: Entrada] = [:]
        var categorias: [CategoriaTradicional: String] = [:]
        for fila in filas {
            if let categoria = fila.categoria, categorias[categoria] == nil { categorias[categoria] = fila.nombre }
            let entrada = Entrada(nombre: fila.nombre, alias: fila.alias)
            if let tradicional = fila.tradicional {
                if tradicionales[tradicional] == nil { tradicionales[tradicional] = entrada }
            } else if let tipo = fila.tipo, porTipo[tipo] == nil {
                porTipo[tipo] = entrada
            }
        }
        var indice: [String: TipoDeEscala] = [:]
        for fila in filas {
            guard let tipo = fila.tipo else { continue }
            if indice[TipoDeEscala.normalizar(fila.nombre)] == nil { indice[TipoDeEscala.normalizar(fila.nombre)] = tipo }
        }
        for fila in filas {
            guard let tipo = fila.tipo else { continue }
            for alias in fila.alias where indice[TipoDeEscala.normalizar(alias)] == nil {
                indice[TipoDeEscala.normalizar(alias)] = tipo
            }
        }
        self.porTipo = porTipo
        self.tradicionales = tradicionales
        self.categorias = categorias
        self.indice = indice
    }

    /// El nombre de una categoría de escala en este idioma, o `nil` si el fichero no lo da.
    package func nombre(de categoria: CategoriaTradicional) -> String? { categorias[categoria] }

    /// El nombre de un tipo en este idioma, o `nil` si no lo tiene (un modo de una escala propia, por ejemplo).
    package func nombre(de tipo: TipoDeEscala) -> String? {
        // Primero por identidad: Āsāvarī es igual (por sus intervalos) a la escala menor natural.
        tradicionales[tipo.identidad]?.nombre ?? porTipo[tipo]?.nombre
    }

    /// Los nombres en los quince idiomas.
    package static let traducidos = Traducido<NombresDeEscalas>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro)

    /// Los nombres en un idioma.
    package static func de(_ idioma: Idioma) -> NombresDeEscalas { traducidos.texto(en: idioma) }

    /// El español sale del catálogo: el nombre de cada tipo y sus alias.
    static let espanol = NombresDeEscalas(
        TipoDeEscala.todos.map { Fila($0, $0.nombre, alias: $0.alias) }
            + TipoDeEscala.tradicionales.map { Fila.tradicional($0, alias: $0.alias) }
            + CategoriaTradicional.allCases.map { Fila.categoria($0, $0.nombre) })
}

// MARK: - Leer un tipo de escala junto a una tónica

extension NombresDeEscalas {
    /// Los nombres de varios idiomas en un solo índice: si dos idiomas escriben igual nombres de tipos distintos,
    /// gana el primero de la lista.
    private static func unidos(_ idiomas: [Idioma]) -> [String: TipoDeEscala] {
        var indice: [String: TipoDeEscala] = [:]
        for idioma in idiomas {
            for (clave, tipo) in de(idioma).indice where indice[clave] == nil { indice[clave] = tipo }
        }
        return indice
    }

    /// Catalán, gallego, euskera, portugués, francés, italiano, occitano, aragonés y asturiano, para leerlos con la
    /// tónica en esas lenguas o en español ("re dòric", "re doriarra", "ré dórico", "ré dorien", "re dorico").
    /// Los occitanos, aragoneses y asturianos que se escriben como en inglés ("dorian") no están: "Re dorian"
    /// mezclaría idiomas.
    static let indicePeninsular: [String: TipoDeEscala] = {
        var indice = unidos([.catalan, .gallego, .euskera, .portugues, .frances, .italiano])
        for idioma in [Idioma.occitano, .aragones, .asturiano] {
            for (clave, tipo) in de(idioma).indice where indice[clave] == nil && TipoDeEscala.indiceInternacional[clave] == nil {
                indice[clave] = tipo
            }
        }
        return indice
    }()

    /// Ruso y griego, con las otras formas de los más comunes ("ре ионийский", "λα αιολικός").
    static let indiceRusoGriego: [String: TipoDeEscala] = unidos([.ruso, .griego])
}

extension TipoDeEscala {
    /// El tipo de escala escrito junto a una tónica en la notación dada ("Fis dorisch", "ре дорийский",
    /// "re dòric"). Con la tónica en inglés se acepta el nombre en inglés o en español; en ruso y griego, el suyo
    /// o el inglés; en alemán y en húngaro, el alemán o el húngaro ("H mayor" no es una escala); en las demás, los de las lenguas
    /// peninsulares y romances o, si no, el español (sin inglés: "Re dorian" mezclaría idiomas).
    package static func buscar(nombre: String, conTonicaEn notacion: Notacion) -> TipoDeEscala? {
        if notacion == .inglesPalabras { return buscar(nombre: nombre, aceptarIngles: true) }
        let normalizado = normalizar(nombre)
        if notacion == .rusoPalabras || notacion == .griegoPalabras {
            return NombresDeEscalas.indiceRusoGriego[normalizado] ?? buscar(nombre: nombre, aceptarIngles: true)
        }
        // En alemán y en húngaro, el suyo o el del otro, que escriben las notas igual (C, H, B): «C dór», «H moll».
        let idioma = notacion.idiomaDeLasNotas
        if idioma == .aleman || idioma == .hungaro {
            let (propio, otro): (Idioma, Idioma) = idioma == .aleman ? (.aleman, .hungaro) : (.hungaro, .aleman)
            return NombresDeEscalas.de(propio).indice[normalizado] ?? NombresDeEscalas.de(otro).indice[normalizado]
        }
        return NombresDeEscalas.indicePeninsular[normalizado] ?? buscar(nombre: nombre, aceptarIngles: false)
    }
}
