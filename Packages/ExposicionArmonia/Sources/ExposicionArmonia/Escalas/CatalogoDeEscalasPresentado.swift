import Armonia

// El catálogo de escalas, sin darle forma: lo mismo para el texto de `armonia escalas` y `tradiciones` y para su
// salida `--json`, así que se calcula en un solo sitio. Sus nombres son las claves del JSON: en español, sin tildes y
// siempre las mismas, sea cual sea el idioma. Lo que es `nil` no sale en el JSON.

/// Una escala del catálogo: su nombre, sus notas desde Do y sus clases, y de dónde y de cuándo es.
///
///     let lidio = EscalaDelCatalogoPresentada(.lidio, en: .compacta(.espanol))
///     lidio.notas              // ["Do", "Re", "Mi", "Fa♯", "Sol", "La", "Si"]
///     lidio.brilloPorQuintas   // 3.0
public struct EscalaDelCatalogoPresentada: Hashable, Sendable, Codable {
    public let nombre: String
    /// El nombre en la escritura de su tradición, si lo tiene.
    public let nombresOriginales: [NombreOriginalPresentado]?
    public let notas: [String]
    public let clases: [Int]
    public let microtonal: Bool
    public let brilloPorQuintas: Double
    /// Las claves de su tradición («occidental» en las habituales), de `--categoria` y de `--fuente`, si las tiene.
    public let tradicion: String?
    public let categoria: String?
    public let fuente: String?
    /// Los nombres de sus lugares de origen y de uso (`TipoDeEscala.lugaresDeOrigen`, `lugaresDeUso`), los códigos
    /// ISO de sus países de origen y las claves de sus continentes de origen.
    public let lugaresDeOrigen: [String]
    public let lugaresDeUso: [String]
    public let paises: [String]
    public let continentes: [String]
    /// Las claves de su época de origen (`TipoDeEscala.epocaDeOrigen`) y de las de uso, su año de origen, la de su
    /// período, las de sus estilos (de más a menos importante), sus corrientes y sus escuelas.
    public let anio: Int?
    public let epoca: String?
    public let epocasDeUso: [String]
    public let periodo: String?
    public let estilos: [String]
    public let corrientes: [String]
    public let escuelas: [String]
    /// Si es un fragmento de menos de una octava, los semitonos que abarca (5 en un tetracordo); `nil` si no.
    public let ambito: Int?
    /// La clave del carácter de su afinación («temperada», «justa», «microtonal», «partes-iguales») y, en las de
    /// partes iguales, cuántas; `nil` si no tiene una propia.
    public let afinacion: String?
    public let partesIguales: Int?

    public init(_ tipo: TipoDeEscala, en notacion: Notacion) {
        let escala = Escala(.do, tipo)
        let originales = NombreOriginalPresentado.de(tipo, en: notacion)
        nombre = tipo.nombre(en: notacion)
        nombresOriginales = originales.isEmpty ? nil : originales
        notas = escala.notas.map { $0.nombre(en: notacion) }
        clases = escala.notas.map(\.claseDeAltura)
        microtonal = tipo.esMicrotonal
        brilloPorQuintas = escala.estadisticas.brilloPorQuintas
        tradicion = tipo.tradicion?.rawValue
        categoria = tipo.categoria?.rawValue
        fuente = tipo.fuente?.rawValue
        lugaresDeOrigen = tipo.lugaresDeOrigen.map { $0.nombre(en: notacion) }
        lugaresDeUso = tipo.lugaresDeUso.map { $0.nombre(en: notacion) }
        paises = tipo.paisesDeOrigen.map(\.codigoISO)
        continentes = tipo.continentesDeOrigen.map(\.rawValue)
        anio = tipo.anioDeOrigen
        epoca = tipo.epocaDeOrigen?.rawValue
        epocasDeUso = tipo.epocasDeUso.map(\.rawValue)
        periodo = tipo.periodo?.rawValue
        estilos = tipo.estilos.map(\.rawValue)
        corrientes = tipo.corrientes.map(\.rawValue)
        escuelas = tipo.escuelas.map(\.rawValue)
        ambito = tipo.ambito?.semitonos
        afinacion = tipo.caracterDeLaAfinacion?.clave
        if case .partesIguales(let partes) = tipo.caracterDeLaAfinacion {
            partesIguales = partes
        } else {
            partesIguales = nil
        }
    }
}

/// Un grupo del catálogo de escalas: «Japón · escala» y sus escalas, en el orden en que se dan.
public struct GrupoDeEscalasPresentado: Hashable, Sendable, Codable {
    public let titulo: String
    public let escalas: [EscalaDelCatalogoPresentada]

    public init(titulo: String, tipos: [TipoDeEscala], en notacion: Notacion) {
        self.titulo = titulo
        escalas = tipos.map { EscalaDelCatalogoPresentada($0, en: notacion) }
    }
}

/// Una tradición del catálogo: cómo se escribe en `--tradicion`, su nombre y cuántas escalas tiene de cada categoría,
/// en el orden de `TipoDeEscala.tradicionales`.
///
///     let japon = TradicionPresentada(.japon, clave: "japon", en: .compacta(.espanol))
///     japon.categorias.first?.clave   // "escala"
public struct TradicionPresentada: Hashable, Sendable, Codable {
    public struct Categoria: Hashable, Sendable, Codable {
        /// «maqam», «raga»…: como se escribe en `--categoria`, siempre igual.
        public let clave: String
        public let nombre: String
        public let escalas: Int
    }

    /// Como se escribe en `--tradicion`, en español: «japon», «mundo-arabe».
    public let clave: String
    public let nombre: String
    /// Todas las de la tradición, de todas sus categorías.
    public let escalas: Int
    public let categorias: [Categoria]

    /// La tradición con su `clave`, que da quien lee `--tradicion`: el motor no la tiene.
    public init(_ tradicion: Tradicion, clave: String, en notacion: Notacion) {
        var cuentas: [(categoria: CategoriaTradicional, escalas: Int)] = []
        for tipo in TipoDeEscala.tradicionales where tipo.tradicion == tradicion {
            guard let categoria = tipo.categoria else { continue }
            if let i = cuentas.firstIndex(where: { $0.categoria == categoria }) {
                cuentas[i].escalas += 1
            } else {
                cuentas.append((categoria, 1))
            }
        }
        self.clave = clave
        nombre = tradicion.nombre(en: notacion)
        categorias = cuentas.map {
            Categoria(clave: $0.categoria.rawValue, nombre: $0.categoria.nombre(en: notacion), escalas: $0.escalas)
        }
        escalas = categorias.map(\.escalas).reduce(0, +)
    }
}
