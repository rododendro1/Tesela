import Armonia
import ExposicionArmonia
import Foundation

/// Lo que las apps recuerdan entre una vez y otra: lo último escrito en cada pestaña, un historial corto de lo que se
/// ha visto y los favoritos. Se guarda como JSON en los ajustes (`UserDefaults`, en `AjustesDeLasApps.claveDeMemoria`)
/// y no usa SwiftUI, así que se prueba también en Linux. Las vistas la leen al abrirse y la escriben con
/// `recordando(_:en:valido:)`, y `MenuDeRecuerdos` enseña el historial y los favoritos.
///
///     var memoria = MemoriaDeLasApps()
///     memoria.anotar("Sol7/Si", en: .acordes)
///     memoria.ultimo(en: .acordes)                 // "Sol7/Si"
///     memoria.alternarFavorito("Sol7/Si", en: .acordes)
///     memoria.esFavorito("Sol7/Si", en: .acordes)  // true
public struct MemoriaDeLasApps: Codable, Hashable, Sendable {
    /// Dónde se escribió: cada pestaña con un campo que se recuerda.
    public enum Lugar: String, Codable, CaseIterable, Hashable, Sendable {
        /// El cifrado de la pestaña de acordes.
        case acordes
        /// La escala de la pestaña de escalas: su nombre en español («Re dórico») o sus notas.
        case escalas
        /// La progresión de la pestaña de análisis.
        case analisis
        /// La tríada con que empieza el recorrido de Tonnetz.
        case tonnetzRecorrido
        /// El acorde que se dibuja en Tonnetz.
        case tonnetzAcorde
        /// La escala que se dibuja en Tonnetz.
        case tonnetzEscala
    }

    /// Algo escrito en una pestaña.
    public struct Recuerdo: Codable, Hashable, Sendable, Identifiable {
        public let lugar: Lugar
        public let texto: String
        public var id: String { lugar.rawValue + "|" + texto }

        public init(_ texto: String, en lugar: Lugar) {
            self.lugar = lugar
            self.texto = texto
        }
    }

    /// Cuántos recuerdos guarda el historial de cada lugar; los más antiguos se olvidan.
    public static let limiteDelHistorial = 20

    /// Lo último escrito en cada lugar.
    public private(set) var ultimos: [Lugar: String] = [:]
    /// Lo visto, lo más reciente primero y sin repetir, hasta `limiteDelHistorial` por lugar.
    public private(set) var historial: [Recuerdo] = []
    /// Los favoritos, en el orden en que se marcaron.
    public private(set) var favoritos: [Recuerdo] = []

    public init() {}

    /// Lo último escrito en un lugar, o `nil` si no hay nada.
    public func ultimo(en lugar: Lugar) -> String? { ultimos[lugar] }

    /// El historial de un lugar, lo más reciente primero.
    public func historial(de lugar: Lugar) -> [Recuerdo] { historial.filter { $0.lugar == lugar } }

    /// Los favoritos de un lugar.
    public func favoritos(de lugar: Lugar) -> [Recuerdo] { favoritos.filter { $0.lugar == lugar } }

    /// Si el texto es un favorito de ese lugar.
    public func esFavorito(_ texto: String, en lugar: Lugar) -> Bool {
        favoritos.contains(Recuerdo(Self.limpio(texto), en: lugar))
    }

    /// Recuerda el texto como lo último de su lugar y lo pone el primero de su historial (si ya estaba, lo sube). Un
    /// texto vacío o solo con espacios no se recuerda.
    public mutating func anotar(_ texto: String, en lugar: Lugar) {
        let texto = Self.limpio(texto)
        guard !texto.isEmpty else { return }
        ultimos[lugar] = texto
        let recuerdo = Recuerdo(texto, en: lugar)
        historial.removeAll { $0 == recuerdo }
        historial.insert(recuerdo, at: 0)
        let sobran = historial(de: lugar).dropFirst(Self.limiteDelHistorial)
        historial.removeAll { sobran.contains($0) }
    }

    /// Marca el texto como favorito de su lugar, o lo desmarca si ya lo era.
    public mutating func alternarFavorito(_ texto: String, en lugar: Lugar) {
        let texto = Self.limpio(texto)
        guard !texto.isEmpty else { return }
        let recuerdo = Recuerdo(texto, en: lugar)
        if let indice = favoritos.firstIndex(of: recuerdo) {
            favoritos.remove(at: indice)
        } else {
            favoritos.append(recuerdo)
        }
    }

    /// Olvida el historial de un lugar (los favoritos y lo último se quedan).
    public mutating func borrarHistorial(de lugar: Lugar) {
        historial.removeAll { $0.lugar == lugar }
    }

    /// Sin los espacios de los extremos, y con uno solo entre palabras: «Do  Fa Sol » es «Do Fa Sol».
    static func limpio(_ texto: String) -> String {
        texto.split(whereSeparator: \.isWhitespace).joined(separator: " ")
    }

    // MARK: Guardar y leer

    /// Como se guarda en los ajustes: un JSON en una cadena.
    public var guardada: String {
        let codificador = JSONEncoder()
        codificador.outputFormatting = [.sortedKeys]
        return (try? codificador.encode(self)).map { String(decoding: $0, as: UTF8.self) } ?? ""
    }

    /// La memoria guardada en esa cadena; vacía si la cadena está vacía o no se lee (de otra versión, por ejemplo).
    public init(guardada: String) {
        self = (try? JSONDecoder().decode(Self.self, from: Data(guardada.utf8))) ?? Self()
    }

    /// La memoria guardada en los ajustes.
    public static func cargar(de ajustes: UserDefaults = .standard) -> MemoriaDeLasApps {
        MemoriaDeLasApps(guardada: ajustes.string(forKey: AjustesDeLasApps.claveDeMemoria) ?? "")
    }

    /// Guarda la memoria en los ajustes.
    public func guardar(en ajustes: UserDefaults = .standard) {
        ajustes.set(guardada, forKey: AjustesDeLasApps.claveDeMemoria)
    }

    // MARK: Los lugares de cada app

    /// Lo que se escribe en un lugar, con la notación de la app, para enseñarlo en el menú: el texto tal cual, salvo
    /// las escalas con nombre, que se guardan en español y se enseñan en la notación («Re dórico», «D Dorian»).
    public static func titulo(de recuerdo: Recuerdo, en notacion: Notacion) -> String {
        switch recuerdo.lugar {
        case .escalas, .tonnetzEscala:
            let eleccion = EleccionDeEscala.recordada(recuerdo.texto)
            return eleccion.propia.isEmpty ? eleccion.escala.nombre(en: notacion) : recuerdo.texto
        case .acordes, .analisis, .tonnetzRecorrido, .tonnetzAcorde:
            return recuerdo.texto
        }
    }
}

extension EleccionDeEscala {
    /// Lo que se recuerda de la escala elegida: lo escrito, si se lee, o el nombre en español de la de la tónica y el
    /// tipo, que se vuelve a leer en cualquier notación («Re dórico»).
    public var paraRecordar: String {
        if !propia.isEmpty, (try? Escala(leyendo: propia)) != nil { return propia }
        return escala.nombre(en: .compacta(.espanol))
    }

    /// La elección que da lo recordado: la tónica y el tipo del catálogo si es el nombre de una escala del catálogo,
    /// o lo escrito si no («Do Re Mi Fa♯ Sol La Si»).
    public static func recordada(_ texto: String) -> EleccionDeEscala {
        var eleccion = EleccionDeEscala()
        if let escala = try? Escala(leyendo: texto),
            escala.nombre(en: .compacta(.espanol)) == MemoriaDeLasApps.limpio(texto),
            catalogo.contains(where: {
                $0.nombre(en: .compacta(.espanol)) == escala.tipo.nombre(en: .compacta(.espanol))
            })
        {
            eleccion.elegir(escala)
        } else {
            eleccion.propia = texto
        }
        return eleccion
    }
}
