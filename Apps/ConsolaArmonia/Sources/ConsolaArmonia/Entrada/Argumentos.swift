import Armonia
import Foundation

/// Los argumentos de una orden, de los que se van quitando las opciones según se leen. Lo que queda al final
/// (`restantes`) es lo que procesa la orden: notas, cifrados, una escala…
///
///     var argumentos = Argumentos(["Sol7", "--instrumento", "ukelele", "--diagrama"])
///     argumentos.quitarMarca(.diagrama)                       // true
///     argumentos.quitarOpcion(.instrumento)                   // .valor("ukelele")
///     argumentos.restantes                                    // ["Sol7"]
///
/// Cada opción se acepta con su nombre en español y en inglés, como la declara `OpcionDeOrden`, y con tildes o sin
/// ellas: `--estadísticas` se lee como `--estadisticas` (`OpcionDeOrden.seEscribe(_:)`).
struct Argumentos {
    private(set) var restantes: [String]

    init(_ argumentos: [String]) {
        restantes = argumentos
    }

    /// El nombre de una opción o de una orden sin tildes ni diéresis (`--análisis` → `--analisis`), como se
    /// declaran. Solo se quitan los acentos de las vocales: la «ñ» se queda. Los errores dicen lo que se escribió.
    static func sinTildes(_ texto: String) -> String {
        String(
            texto.map { letra in
                let base = String(letra).folding(options: .diacriticInsensitive, locale: nil)
                return "aeiouAEIOU".contains(base) ? Character(base) : letra
            })
    }

    /// Lo que queda, separado por espacios: «Do Fa Sol7 Do».
    var unidos: String { restantes.joined(separator: " ") }

    /// La primera opción (`--algo`, o `-o`) que queda sin leer, que ninguna lectura ha reconocido. Un guion con una
    /// letra que es un intervalo descendente (`-m3`, `-P5`) no es una opción.
    var opcionDesconocida: String? { restantes.first(where: Self.pareceUnaOpcion) }

    /// Lanza `opcionDesconocida` con la primera opción que queda sin leer, si queda alguna. Cada orden lo llama
    /// cuando ha leído las suyas, antes de leer lo que queda (`AyudaTests` comprueba que ninguna se lo salta).
    func sinOpcionesDesconocidas() throws {
        if let desconocida = opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
    }

    /// Lo que queda (`restantes`), si no queda ninguna opción sin leer.
    var leidos: [String] {
        get throws {
            try sinOpcionesDesconocidas()
            return restantes
        }
    }

    static func pareceUnaOpcion(_ texto: String) -> Bool {
        if texto.hasPrefix("--") { return true }
        guard texto.hasPrefix("-"), texto.dropFirst().first?.isLetter == true else { return false }
        return (try? Intervalo(leyendo: texto)) == nil
    }

    /// Una opción con valor, tal como se ha encontrado.
    enum Opcion: Equatable {
        case ausente
        /// Está, pero no la sigue nada o la sigue otra opción. `nombre` es el que se escribió, sin los guiones.
        case sinValor(nombre: String)
        case valor(String)
    }

    /// Quita una marca, una opción sin valor (`--diagrama`), con cualquiera de sus nombres y todas las veces
    /// que aparezca. Dice si estaba.
    mutating func quitarMarca(_ marca: OpcionDeOrden) -> Bool { quitarMarca(marca.leidos) }

    private mutating func quitarMarca(_ nombres: [String]) -> Bool {
        let antes = restantes.count
        restantes.removeAll { nombres.contains(Self.sinTildes($0)) }
        return restantes.count != antes
    }

    /// Quita una opción con valor (`--limite 5`) y su valor.
    mutating func quitarOpcion(_ opcion: OpcionDeOrden) -> Opcion { quitarOpcion(opcion.leidos) }

    /// Quita una opción con valor (`--limite 5`) y da su valor, o `nil` si no está. Si está sin valor, lanza
    /// `siFalta`, o `faltaValor` con el nombre que se escribió.
    ///
    ///     if let texto = try argumentos.valor(.secuencia) { … }
    mutating func valor(_ opcion: OpcionDeOrden, siFalta: ErrorDeUso? = nil) throws -> String? {
        try Self.leer(quitarOpcion(opcion.leidos), siFalta: siFalta)
    }

    /// Como `valor(_:siFalta:)`, con todas las palabras que siguen a la opción (`quitarOpcionConPalabras`).
    mutating func valorConPalabras(_ opcion: OpcionDeOrden, siFalta: ErrorDeUso? = nil) throws -> String? {
        try Self.leer(quitarOpcionConPalabras(opcion.leidos), siFalta: siFalta)
    }

    private static func leer(_ opcion: Opcion, siFalta: ErrorDeUso?) throws -> String? {
        switch opcion {
        case .ausente: return nil
        case .sinValor(let nombre): throw siFalta ?? .faltaValor(nombre)
        case .valor(let texto): return texto
        }
    }

    private mutating func quitarOpcion(_ nombres: [String]) -> Opcion {
        guard let i = restantes.firstIndex(where: { nombres.contains(Self.sinTildes($0)) }) else { return .ausente }
        guard i + 1 < restantes.count, !restantes[i + 1].hasPrefix("--") else {
            return .sinValor(nombre: String(restantes.remove(at: i).dropFirst(2)))
        }
        let valor = restantes[i + 1]
        restantes.removeSubrange(i...(i + 1))
        return .valor(valor)
    }

    /// Quita una opción seguida de varias palabras, hasta la siguiente opción (`--comparar Do lidio`), y da las
    /// palabras unidas por espacios.
    mutating func quitarOpcionConPalabras(_ opcion: OpcionDeOrden) -> Opcion {
        quitarOpcionConPalabras(opcion.leidos)
    }

    private mutating func quitarOpcionConPalabras(_ nombres: [String]) -> Opcion {
        guard let i = restantes.firstIndex(where: { nombres.contains(Self.sinTildes($0)) }) else { return .ausente }
        let fin = restantes[(i + 1)...].firstIndex { $0.hasPrefix("--") } ?? restantes.endIndex
        let palabras = restantes[(i + 1)..<fin]
        let nombre = String(restantes[i].dropFirst(2))
        restantes.removeSubrange(i..<fin)
        return palabras.isEmpty ? .sinValor(nombre: nombre) : .valor(palabras.joined(separator: " "))
    }

    /// Quita una opción con un número (`--voces 2`): `porDefecto` si no está, y `nil` si le falta el número
    /// o no está en `rango`.
    mutating func quitarNumero(_ opcion: OpcionDeOrden, en rango: ClosedRange<Int>, porDefecto: Int) -> Int? {
        let nombres = opcion.leidos
        guard let i = restantes.firstIndex(where: { nombres.contains(Self.sinTildes($0)) }) else { return porDefecto }
        guard i + 1 < restantes.count, let n = Int(restantes[i + 1]), rango.contains(n) else { return nil }
        restantes.removeSubrange(i...(i + 1))
        return n
    }

    /// Quita las opciones al estilo de las partituras, que toman todas las palabras que las siguen hasta la
    /// siguiente opción (`--titulo Mi canción`); las marcas de `conocidas` no toman nada. Cada opción se lee con
    /// cualquiera de sus nombres (`OpcionDeOrden.leidos`), sin distinguir mayúsculas, y se da por el primero, sin
    /// guiones (`titulo`, también si se escribe `--title`); una opción sin palabras detrás tiene `""`. Lo que no sigue a
    /// ninguna opción (lo de delante, o lo que va tras una marca) se queda en `restantes`. Lanza `opcionDesconocida`
    /// con la primera que no está en `conocidas`.
    ///
    ///     var argumentos = Argumentos(["Do", "Re", "--title", "Mi", "canción", "--cifrados"])
    ///     try argumentos.quitarOpcionesConTexto([.titulo, .cifrados])
    ///     // (["titulo": "Mi canción"], ["cifrados"]); restantes: ["Do", "Re"]
    mutating func quitarOpcionesConTexto(_ conocidas: [OpcionDeOrden]) throws
        -> (opciones: [String: String], marcas: Set<String>)
    {
        var porNombre: [String: OpcionDeOrden] = [:]
        for opcion in conocidas {
            for nombre in opcion.leidos { porNombre[nombre.lowercased()] = opcion }
        }
        var opciones: [String: String] = [:]
        var marcas: Set<String> = []
        var quedan: [String] = []
        var actual: String?
        for argumento in restantes {
            if argumento.hasPrefix("--") {
                guard let opcion = porNombre[Self.sinTildes(argumento.lowercased())] else {
                    throw ErrorDeUso.opcionDesconocida(argumento)
                }
                let nombre = String(opcion.nombres[0].dropFirst(2))
                if opcion.llevaValor {
                    actual = nombre
                    opciones[nombre] = ""
                } else {
                    marcas.insert(nombre)
                    actual = nil
                }
            } else if let nombre = actual, let anterior = opciones[nombre] {
                opciones[nombre] = anterior.isEmpty ? argumento : anterior + " " + argumento
            } else {
                quedan.append(argumento)
            }
        }
        restantes = quedan
        return (opciones, marcas)
    }

    /// Quita `--en <tonalidad>` (o `--in`), que va al final y se lleva lo que lo sigue hasta la siguiente opción:
    /// `--en La menor`. `nil` dentro si no está, y `nil` si no lo sigue nada. Lanza un error de lectura si la
    /// tonalidad no se puede leer.
    mutating func quitarTonalidad(en notacion: Notacion) throws -> Tonalidad?? {
        guard let i = restantes.firstIndex(where: OpcionDeOrden.en.nombres.contains) else { return .some(nil) }
        let fin = restantes[(i + 1)...].firstIndex(where: Self.pareceUnaOpcion) ?? restantes.endIndex
        guard i + 1 < fin else { return nil }
        let tonalidad = try Tonalidad(leyendo: restantes[(i + 1)..<fin].joined(separator: " "), enLaOrden: notacion)
        restantes.removeSubrange(i..<fin)
        return .some(tonalidad)
    }
}
