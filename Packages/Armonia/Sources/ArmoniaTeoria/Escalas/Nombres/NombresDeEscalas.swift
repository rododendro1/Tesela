import ArmoniaNucleo

// MARK: - Nombres de los tipos de escala
//
// Un idioma por fichero: `NombresDeEscalas+Catalan.swift`, `…+Ingles.swift`… Cada uno da el nombre de cada tipo
// del catálogo occidental y, si los tiene, las otras formas con que se lee (alias). Las escalas de otras
// tradiciones (Kafi, Hitzaz, Hirajoshi…) van al final de cada fichero, con `.tradicional(.kafi)`, que nombra la
// escala por su miembro de `TipoDeEscala` (si se renombra o se quita, no compila): casi todas llevan un nombre
// propio que se escribe igual en todos los idiomas, y las que no (las andinas, los tetracordos y las harmoniai
// griegas, el mayor y el menor de las etíopes) llevan su traducción. Una escala sin fila (los 72 melakarta) conserva
// su nombre original. El español sale del propio
// catálogo (`TipoDeEscala.nombre` y `alias`). Un idioma nuevo es un fichero más y su fila en `traducidos`.
//
// Las escalas occidentales se buscan por tipo; las tradicionales, por su nombre (el del tipo al que apunta la
// fila), porque `TipoDeEscala` se compara por sus intervalos y Āsāvarī sería la escala menor natural.

/// Los nombres de los tipos de escala en un idioma.
package struct NombresDeEscalas: Sendable {
    /// Una fila de un fichero de idioma: el tipo, su nombre y los alias con que también se lee.
    package struct Fila: Sendable {
        let tipo: TipoDeEscala?
        /// El nombre original de una escala tradicional (el de su tipo); `nil` en las occidentales.
        let clave: String?
        /// La clase de escala (raga, dromos…) a la que da nombre una fila `.clase`; `nil` en las demás.
        let clase: ClaseDeEscala?
        let nombre: String
        let alias: [String]

        /// Un tipo occidental del catálogo.
        init(_ tipo: TipoDeEscala, _ nombre: String, alias: [String] = []) {
            self.tipo = tipo
            self.clase = nil
            self.clave = nil
            self.nombre = nombre
            self.alias = alias
        }

        private init(tradicional tipo: TipoDeEscala, nombre: String, alias: [String]) {
            self.tipo = tipo
            self.clase = nil
            self.clave = tipo.nombre
            self.nombre = nombre
            self.alias = alias
        }

        private init(clase: ClaseDeEscala, nombre: String) {
            self.tipo = nil
            self.clase = clase
            self.clave = nil
            self.nombre = nombre
            self.alias = []
        }

        /// El nombre de una clase de escala (`ClaseDeEscala`) en este idioma.
        static func clase(_ clase: ClaseDeEscala, _ nombre: String) -> Fila {
            Fila(clase: clase, nombre: nombre)
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

    /// Nombre original de una escala tradicional → su nombre y sus alias en este idioma.
    package let tradicionales: [String: Entrada]

    /// Clase de escala → su nombre en este idioma.
    package let clases: [ClaseDeEscala: String]

    /// Nombres y alias normalizados → tipo, para leerlos en este idioma. Un nombre gana a un alias; entre
    /// nombres o entre alias, gana el primero.
    package let indice: [String: TipoDeEscala]

    init(_ listadas: [Fila]) {
        // Las tradicionales sin fila (los melakarta) conservan su nombre original.
        let conFila = Set(listadas.compactMap(\.clave))
        var vistas = Set<String>()
        let filas = listadas + TipoDeEscala.tradicionales
            .filter { !conFila.contains($0.nombre) && vistas.insert($0.nombre).inserted }
            .map { Fila.tradicional($0) }
        var porTipo: [TipoDeEscala: Entrada] = [:]
        var tradicionales: [String: Entrada] = [:]
        var clases: [ClaseDeEscala: String] = [:]
        for fila in filas {
            if let clase = fila.clase, clases[clase] == nil { clases[clase] = fila.nombre }
            let entrada = Entrada(nombre: fila.nombre, alias: fila.alias)
            if let clave = fila.clave {
                if tradicionales[clave] == nil { tradicionales[clave] = entrada }
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
        self.clases = clases
        self.indice = indice
    }

    /// El nombre de una clase de escala en este idioma, o `nil` si el fichero no lo da.
    package func nombre(de clase: ClaseDeEscala) -> String? { clases[clase] }

    /// El nombre de un tipo en este idioma, o `nil` si no lo tiene (un modo de una escala propia, por ejemplo).
    package func nombre(de tipo: TipoDeEscala) -> String? {
        // Primero por nombre: Āsāvarī es igual (por sus intervalos) a la escala menor natural.
        tradicionales[tipo.nombre]?.nombre ?? porTipo[tipo]?.nombre
    }

    /// Los nombres en los catorce idiomas.
    package static let traducidos = Traducido<NombresDeEscalas>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso)

    /// Los nombres en un idioma.
    package static func de(_ idioma: Idioma) -> NombresDeEscalas { traducidos.texto(en: idioma) }

    /// El español sale del catálogo: el nombre de cada tipo y sus alias.
    static let espanol = NombresDeEscalas(
        TipoDeEscala.todos.map { Fila($0, $0.nombre, alias: $0.alias) }
            + TipoDeEscala.tradicionales.map { Fila.tradicional($0, alias: $0.alias) }
            + ClaseDeEscala.allCases.map { Fila.clase($0, $0.nombre) })
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
    /// o el inglés; en alemán, solo el alemán ("H mayor" no es una escala); en las demás, los de las lenguas
    /// peninsulares y romances o, si no, el español (sin inglés: "Re dorian" mezclaría idiomas).
    package static func buscar(nombre: String, conTonicaEn notacion: Notacion) -> TipoDeEscala? {
        if notacion == .ingles { return buscar(nombre: nombre, aceptarIngles: true) }
        let normalizado = normalizar(nombre)
        if notacion == .ruso || notacion == .griego {
            return NombresDeEscalas.indiceRusoGriego[normalizado] ?? buscar(nombre: nombre, aceptarIngles: true)
        }
        if notacion == .aleman { return NombresDeEscalas.de(.aleman).indice[normalizado] }
        return NombresDeEscalas.indicePeninsular[normalizado] ?? buscar(nombre: nombre, aceptarIngles: false)
    }
}
