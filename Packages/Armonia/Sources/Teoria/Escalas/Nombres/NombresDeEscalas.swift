// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos

// MARK: - Nombres de los tipos de escala
//
// Un idioma por fichero: `NombresDeEscalas+Catalan.swift`, `…+Ingles.swift`… Cada uno da el nombre de cada tipo
// del catálogo occidental y, si los tiene, sus otros nombres (alias) y otras formas de escribirlos (variantes: el
// femenino, otra transliteración); los dos se leen igual. Las escalas de otras
// tradiciones (Kafi, Hitzaz, Hirajoshi…) llevan casi todas un nombre propio que se escribe igual en todos los
// idiomas, y no tienen fila: sin ella, una escala conserva su nombre original. Solo la llevan, al final del fichero,
// las que se traducen o se transcriben en ese idioma (las andinas, los tetracordos y las harmoniai griegas, el mayor
// y el menor de las etíopes; en ruso y en griego, casi todas), con `.tradicional(.kafi, "…")`, que nombra la
// escala por su miembro de `TipoDeEscala` (si se renombra o se quita, no compila). El español sale del propio
// catálogo (`TipoDeEscala.nombre`, `alias` y `variantes`). Un idioma nuevo es un fichero más y su fila en `traducidos`.
//
// Las escalas occidentales se buscan por tipo; las tradicionales, por su identidad (`TipoDeEscala.identidad`, la del
// tipo al que apunta la fila), porque `TipoDeEscala` se compara por sus intervalos y Āsāvarī sería la escala menor
// natural.

/// Los nombres de los tipos de escala en un idioma.
package struct NombresDeEscalas: Sendable {
    /// Una fila de un fichero de idioma: el tipo, su nombre y los alias y las variantes con que también se lee.
    package struct Fila: Sendable {
        let tipo: TipoDeEscala?
        /// La escala tradicional de la fila (la `identidad` de su tipo); `nil` en las occidentales.
        let tradicional: IdentidadDeEscala?
        /// La categoría (rāga, dromos…) a la que da nombre una fila `.categoria`; `nil` en las demás.
        let categoria: CategoriaTradicional?
        let nombre: String
        let alias: [String]
        let variantes: [String]

        /// Un tipo occidental del catálogo.
        init(_ tipo: TipoDeEscala, _ nombre: String, alias: [String] = [], variantes: [String] = []) {
            self.tipo = tipo
            self.categoria = nil
            self.tradicional = nil
            self.nombre = nombre
            self.alias = alias
            self.variantes = variantes
        }

        private init(tradicional tipo: TipoDeEscala, nombre: String, alias: [String], variantes: [String]) {
            self.tipo = tipo
            self.categoria = nil
            self.tradicional = tipo.identidad
            self.nombre = nombre
            self.alias = alias
            self.variantes = variantes
        }

        private init(categoria: CategoriaTradicional, nombre: String) {
            self.tipo = nil
            self.categoria = categoria
            self.tradicional = nil
            self.nombre = nombre
            self.alias = []
            self.variantes = []
        }

        /// El nombre de una categoría de escala (`CategoriaTradicional`) en este idioma.
        static func categoria(_ categoria: CategoriaTradicional, _ nombre: String) -> Fila {
            Fila(categoria: categoria, nombre: nombre)
        }

        /// Una escala de otra tradición; sin segundo nombre se escribe como el original.
        static func tradicional(
            _ tipo: TipoDeEscala, _ traducido: String? = nil, alias: [String] = [], variantes: [String] = []
        ) -> Fila {
            Fila(tradicional: tipo, nombre: traducido ?? tipo.nombre, alias: alias, variantes: variantes)
        }
    }

    /// Nombre, alias y variantes de un tipo en este idioma.
    package struct Entrada: Sendable {
        package let nombre: String
        package let alias: [String]
        package let variantes: [String]
    }

    /// Tipo occidental → su nombre y sus alias. Si un tipo está dos veces, vale la primera fila.
    package let porTipo: [TipoDeEscala: Entrada]

    /// Escala tradicional (por su `identidad`) → su nombre y sus alias en este idioma.
    package let tradicionales: [IdentidadDeEscala: Entrada]

    /// Clase de escala → su nombre en este idioma.
    package let categorias: [CategoriaTradicional: String]

    /// Nombres, alias y variantes normalizados → tipo, para leerlos en este idioma. Un nombre gana a un alias o a
    /// una variante; entre nombres o entre los demás, gana el primero.
    package let indice: [String: TipoDeEscala]

    init(_ listadas: [Fila]) {
        // Las tradicionales sin fila (los mēḷa) conservan su nombre original, y sus alias y sus variantes (otras
        // transliteraciones, su escritura original: «Hicaz», «ትዝታ»), salvo los que están en español.
        let conFila = Set(listadas.compactMap(\.tradicional))
        var vistas = Set<IdentidadDeEscala>()
        let filas = listadas + TipoDeEscala.tradicionales
            .filter { !conFila.contains($0.identidad) && vistas.insert($0.identidad).inserted }
            .map {
                Fila.tradicional(
                    $0, alias: $0.alias.filter { !NombresDeEscalas.aliasEnEspanol.contains($0) },
                    variantes: $0.variantes.filter { !NombresDeEscalas.aliasEnEspanol.contains($0) })
            }
        var porTipo: [TipoDeEscala: Entrada] = [:]
        var tradicionales: [IdentidadDeEscala: Entrada] = [:]
        var categorias: [CategoriaTradicional: String] = [:]
        for fila in filas {
            if let categoria = fila.categoria, categorias[categoria] == nil { categorias[categoria] = fila.nombre }
            let entrada = Entrada(nombre: fila.nombre, alias: fila.alias, variantes: fila.variantes)
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
            for alias in fila.alias + fila.variantes where indice[TipoDeEscala.normalizar(alias)] == nil {
                indice[TipoDeEscala.normalizar(alias)] = tipo
            }
        }
        // Los nombres en cirílico o en griego se leen también transliterados: «dorijskij», «dórios», «dorios».
        for fila in filas {
            guard let tipo = fila.tipo else { continue }
            for nombre in [fila.nombre] + fila.alias + fila.variantes {
                for escrito in [Transliteracion.latina(nombre), Transliteracion.ascii(nombre)] {
                    let clave = TipoDeEscala.normalizar(escrito)
                    if indice[clave] == nil { indice[clave] = tipo }
                }
            }
        }
        self.init(porTipo: porTipo, tradicionales: tradicionales, categorias: categorias, indice: indice)
    }

    private init(
        porTipo: [TipoDeEscala: Entrada], tradicionales: [IdentidadDeEscala: Entrada],
        categorias: [CategoriaTradicional: String], indice: [String: TipoDeEscala]
    ) {
        self.porTipo = porTipo
        self.tradicionales = tradicionales
        self.categorias = categorias
        self.indice = indice
    }

    /// Los mismos nombres en una grafía: en ruso y en griego, transliterados («dorijskij», «dórios»). El índice no
    /// cambia: ya lee todas.
    private func en(_ grafia: Grafia) -> NombresDeEscalas {
        func escrito(_ texto: String) -> String { Transliteracion.texto(texto, en: grafia) }
        func escrita(_ entrada: Entrada) -> Entrada {
            Entrada(
                nombre: escrito(entrada.nombre), alias: entrada.alias.map(escrito),
                variantes: entrada.variantes.map(escrito))
        }
        return NombresDeEscalas(
            porTipo: porTipo.mapValues(escrita), tradicionales: tradicionales.mapValues(escrita),
            categorias: categorias.mapValues(escrito), indice: indice)
    }

    /// El nombre de una categoría de escala en este idioma, o `nil` si el fichero no lo da.
    package func nombre(de categoria: CategoriaTradicional) -> String? { categorias[categoria] }

    /// El nombre de un tipo en este idioma, o `nil` si no lo tiene (un modo de una escala propia, por ejemplo).
    package func nombre(de tipo: TipoDeEscala) -> String? {
        // Primero por identidad: Āsāvarī es igual (por sus intervalos) a la escala menor natural.
        tradicionales[tipo.identidad]?.nombre ?? porTipo[tipo]?.nombre
    }

    /// Los nombres de cada idioma, que se calculan la primera vez que se piden (cada `static let` lo hace por su
    /// cuenta): leer «re dórico» no calcula los del ruso ni los del húngaro.
    private static let porIdioma = Traducido<@Sendable () -> NombresDeEscalas>(
        { espanol }, { ingles }, ca: { catalan }, gl: { gallego }, eu: { euskera }, pt: { portugues },
        fr: { frances }, it: { italiano }, de: { aleman }, el: { griego }, ru: { ruso }, hu: { hungaro },
        sv: { sueco })

    /// Los nombres en un idioma.
    package static func de(_ idioma: Idioma) -> NombresDeEscalas { porIdioma.texto(en: idioma)() }

    /// Los nombres en el idioma de los textos de una notación y en su grafía (`Notacion.grafiaDeLosTextos`).
    package static func de(_ notacion: Notacion) -> NombresDeEscalas {
        switch notacion.grafiaDeLosTextos {
        case .original: return de(notacion.textos)
        case .transliterada: return transliterados[notacion.textos]
        case .ascii: return enASCII[notacion.textos]
        }
    }

    private static let transliterados = TablaPerezosa<Idioma, NombresDeEscalas> { de($0).en(.transliterada) }
    private static let enASCII = TablaPerezosa<Idioma, NombresDeEscalas> { de($0).en(.ascii) }

    /// Los alias de las escalas de otras tradiciones que están escritos en español («modo gregoriano 1», «hexacordo
    /// duro», «balinesa»): una escala sin fila en un idioma hereda los demás, pero no estos.
    static let aliasEnEspanol: Set<String> = [
        // Los modos gregorianos y los de Glareano.
        "protus auténtico", "deuterus auténtico", "tritus auténtico", "tetrardus auténtico",
        "modo gregoriano 1", "modo gregoriano 2", "modo gregoriano 3", "modo gregoriano 4",
        "modo gregoriano 5", "modo gregoriano 6", "modo gregoriano 7", "modo gregoriano 8",
        "hipodórico", "hipofrigio", "hipolidio", "hipomixolidio", "hipoeólico", "hipojónico",
        "modo 1 de Zarlino", "modo 2 de Zarlino", "modo 3 de Zarlino", "modo 4 de Zarlino", "modo 5 de Zarlino",
        "modo 6 de Zarlino", "modo 7 de Zarlino", "modo 8 de Zarlino", "modo 9 de Zarlino", "modo 10 de Zarlino",
        "modo 11 de Zarlino", "modo 12 de Zarlino",
        "modo de Glareano 9", "modo de Glareano 10", "modo de Glareano 11", "modo de Glareano 12",
        "modo 9", "modo 10", "modo 11", "modo 12",
        // Los hexacordos.
        "hexacordo natural", "hexacordo duro", "hexacordo blando",
        // Los shadd de Ṣafī al-Dīn.
        "Abū Salīk de Ṣafī al-Dīn", "Nawā de Ṣafī al-Dīn", "Rāst de Ṣafī al-Dīn", "ʿUshshāq de Ṣafī al-Dīn",
        // Europa, África y Asia.
        "escala istriana", "podhalana", "escala podhalana", "equipentatónica de Uganda", "equiheptatónica chopi",
        "balinesa", "camboyana", "jemer", "tailandesa", "arpa birmana", "birmana", "doce lü",
    ]

    /// El español sale del catálogo: el nombre de cada tipo, sus alias y sus variantes.
    static let espanol = NombresDeEscalas(
        TipoDeEscala.occidentales.map { Fila($0, $0.nombre, alias: $0.alias, variantes: $0.variantes) }
            + TipoDeEscala.tradicionales.map { Fila.tradicional($0, alias: $0.alias, variantes: $0.variantes) }
            + CategoriaTradicional.allCases.map { Fila.categoria($0, $0.nombre) })
}

// MARK: - Leer un tipo de escala junto a una tónica

extension NombresDeEscalas {
    /// El tipo con ese nombre (normalizado) en el primero de los idiomas que lo tenga. Se miran en orden, así que solo
    /// se calculan los nombres de los idiomas que hace falta mirar.
    private static func buscar(_ normalizado: String, en idiomas: [Idioma]) -> TipoDeEscala? {
        for idioma in idiomas {
            if let tipo = de(idioma).indice[normalizado] { return tipo }
        }
        return nil
    }

    /// Catalán, gallego, euskera, portugués, francés e italiano, para leerlos con la tónica en esas lenguas o en
    /// español ("re dòric", "re doriarra", "ré dórico", "ré dorien", "re dorico").
    static func peninsular(_ normalizado: String) -> TipoDeEscala? {
        buscar(normalizado, en: [.catalan, .gallego, .euskera, .portugues, .frances, .italiano])
    }

    /// Ruso y griego, con las otras formas de los más comunes ("ре ионийский", "λα αιολικός").
    static func rusoOGriego(_ normalizado: String) -> TipoDeEscala? { buscar(normalizado, en: [.ruso, .griego]) }
}

extension TipoDeEscala {
    /// El tipo de escala escrito junto a una tónica en la notación dada ("Fis dorisch", "ре дорийский",
    /// "re dòric"). Con la tónica en inglés se acepta el nombre en inglés o en español; en ruso y griego, el suyo
    /// o el inglés; en alemán, en húngaro y en sueco, cualquiera de los tres ("H mayor" no es una escala); en las demás, los de las lenguas
    /// peninsulares y romances o, si no, el español (sin inglés: "Re dorian" mezclaría idiomas).
    package static func buscar(nombre: String, conTonicaEn notacion: Notacion) -> TipoDeEscala? {
        if notacion == .conPalabras(.ingles) { return buscar(nombre: nombre, aceptarIngles: true) }
        let normalizado = normalizar(nombre)
        if notacion == .conPalabras(.ruso) || notacion == .conPalabras(.griego) {
            return NombresDeEscalas.rusoOGriego(normalizado) ?? buscar(nombre: nombre, aceptarIngles: true)
        }
        // En alemán, en húngaro y en sueco, el suyo o el de los otros, que escriben las notas igual (C, H, B):
        // «C dór», «H moll».
        let idioma = notacion.idiomaDeLasNotas
        let germanicos: [Idioma] = [.aleman, .hungaro, .sueco]
        if germanicos.contains(idioma) {
            for otro in [idioma] + germanicos.filter({ $0 != idioma }) {
                if let tipo = NombresDeEscalas.de(otro).indice[normalizado] { return tipo }
            }
            return nil
        }
        return NombresDeEscalas.peninsular(normalizado) ?? buscar(nombre: nombre, aceptarIngles: false)
    }
}
