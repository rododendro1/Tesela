import Elementos

// MARK: - Nombres de las progresiones del catálogo
//
// Un idioma por fichero, como los de los acordes: `NombresDeProgresiones+Catalan.swift`, `…+Ingles.swift`… Cada uno da
// el nombre de cada progresión de `ProgresionConNombre.catalogo`, que nombra por su miembro (`.init(.andaluza, "…")`:
// si se renombra o se quita, no compila) y, si los tiene, sus alias y sus variantes. El español sale del propio
// catálogo. Que cada fichero dé todas las progresiones lo comprueban las pruebas (`ProgresionConNombreTests`).

/// Los nombres de las progresiones del catálogo en un idioma.
package struct NombresDeProgresiones: Sendable {
    /// Una fila de un fichero de idioma: la progresión, su nombre y los alias y las variantes con que también se conoce.
    package struct Fila: Sendable {
        let progresion: ProgresionConNombre
        let nombre: String
        let alias: [String]
        let variantes: [String]

        init(_ progresion: ProgresionConNombre, _ nombre: String, alias: [String] = [], variantes: [String] = []) {
            self.progresion = progresion
            self.nombre = nombre
            self.alias = alias
            self.variantes = variantes
        }
    }

    /// Las filas del fichero, en su orden.
    package let filas: [Fila]

    /// Progresión → su fila. Si una progresión está dos veces, vale la primera.
    private let porProgresion: [ProgresionConNombre: Fila]

    init(_ filas: [Fila]) {
        var porProgresion: [ProgresionConNombre: Fila] = [:]
        for fila in filas where porProgresion[fila.progresion] == nil { porProgresion[fila.progresion] = fila }
        self.filas = filas
        self.porProgresion = porProgresion
    }

    /// El nombre de una progresión en este idioma, o `nil` si no es del catálogo.
    package func nombre(de progresion: ProgresionConNombre) -> String? { porProgresion[progresion]?.nombre }

    /// Los alias de una progresión en este idioma.
    package func alias(de progresion: ProgresionConNombre) -> [String] { porProgresion[progresion]?.alias ?? [] }

    /// Los nombres en los trece idiomas.
    package static let traducidos = Traducido<NombresDeProgresiones>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)

    /// Los nombres en un idioma.
    package static func de(_ idioma: Idioma) -> NombresDeProgresiones { traducidos.texto(en: idioma) }

    /// El español sale del catálogo: el nombre de cada progresión, sus alias y sus variantes.
    static let espanol = NombresDeProgresiones(
        ProgresionConNombre.catalogo.map { Fila($0, $0.nombre, alias: $0.alias, variantes: $0.variantes) })

    // MARK: Búsqueda

    /// Un nombre para comparar: minúsculas, sin tildes, ♭ como b y sin espacios, guiones, rayas, apóstrofos ni
    /// puntos («ii–V–I», «ii-V-I» y «II V I» son lo mismo).
    package static func normalizar(_ texto: String) -> String {
        texto.replacingOccurrences(of: "♭", with: "b").replacingOccurrences(of: "♯", with: "#")
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil).lowercased()
            .filter { !" -–—'’.".contains($0) }
    }

    /// Todos los nombres, alias y variantes de una progresión en los trece idiomas, normalizados.
    package static func claves(de progresion: ProgresionConNombre) -> [String] {
        Idioma.allCases.flatMap { idioma -> [String] in
            guard let fila = de(idioma).porProgresion[progresion] else { return [] }
            return ([fila.nombre] + fila.alias + fila.variantes).map(normalizar)
        }
    }

    /// Nombre, alias o variante normalizados → la progresión, en cualquier idioma. Si dos coinciden, vale la del
    /// primer idioma de `Idioma.allCases` que lo tenga (el español y el inglés primero).
    package static let indice: [String: ProgresionConNombre] = {
        var indice: [String: ProgresionConNombre] = [:]
        for idioma in Idioma.allCases {
            for fila in de(idioma).filas {
                for texto in [fila.nombre] + fila.alias + fila.variantes where indice[normalizar(texto)] == nil {
                    indice[normalizar(texto)] = fila.progresion
                }
            }
        }
        return indice
    }()
}
