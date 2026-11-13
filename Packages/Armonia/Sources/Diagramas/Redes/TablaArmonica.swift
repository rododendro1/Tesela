import Elementos
import Foundation
import Hexagonos
import Teoria

// La tabla armónica (Harmonic Table): la disposición de notas en hexágonos de teclados
// isomórficos como el C-Thru AXiS. Hacia arriba, una quinta justa; en diagonal hacia arriba a la
// derecha, una tercera mayor; en diagonal hacia arriba a la izquierda, una tercera menor.
//
// Es el dual del Tonnetz: la misma red, con cada nota en un hexágono en lugar de un punto, de
// modo que una tríada son tres hexágonos que se tocan en un vértice. Por eso usa sus mismas
// coordenadas, (a, b) = a quintas y b terceras mayores, y su misma colocación. Además puede
// colocar alturas, como en el instrumento: el hexágono (a, b) suena 7a + 4b semitonos por encima
// de Do4, y cada altura está en un sitio concreto (afinación igual, sin ortografía).
//
// Los hexágonos se colocan y se dibujan con el paquete `Hexagonos` (Tonnetz+Hexagonos.swift): son
// hexágonos planos, en la rejilla del Tonnetz girada 120°.

/// Unas notas, un acorde, una escala, un conjunto de clases de altura o unas alturas en la tabla
/// armónica.
///
///     TablaArmonica(Acorde("Do")).svg()                   // tres hexágonos con un vértice común
///     TablaArmonica([Altura("Do3"), Altura("Sol3"), Altura("Mi4")]).svg()   // una disposición abierta
///
/// La forma de un acorde o una escala es la misma en todas las tonalidades: transportar es mover
/// la forma.
public struct TablaArmonica: Hashable, Sendable {
    /// Cómo se colocaron las notas.
    public enum Colocacion: Hashable, Sendable {
        /// Notas con su ortografía, como en el Tonnetz.
        case notas
        /// Clases de altura: la tabla se repite como un toro.
        case clasesDeAltura
        /// Alturas con octava: cada hexágono es una altura, como en el instrumento.
        case alturas
    }

    /// Los hexágonos de las notas, en el orden en que se dieron (sin repetir).
    public let puntos: [PuntoDeLaRed]
    public let colocacion: Colocacion
    /// Las alturas dadas, con la colocación `.alturas`.
    public let alturas: [Altura]
    /// De dónde salen las notas, para el título del dibujo.
    package var origen: OrigenDelDibujo?
    /// Las tríadas de un recorrido, en orden (`init(recorrido:)`); vacío si no lo es.
    public private(set) var recorrido: [Tonnetz.Triada] = []
    /// En un ciclo, el nombre de cada hexágono y las tríadas con su ortografía, como en el Tonnetz.
    package var nombres: [PuntoDeLaRed: Nota] = [:]
    package var acordesDelRecorrido: [Acorde] = []

    /// Las notas como en el Tonnetz, con los nombres de un ciclo si lo es.
    var comoTonnetz: Tonnetz {
        var tonnetz = Tonnetz(puntos: puntos, tieneOrtografia: colocacion == .notas, recorrido: [])
        tonnetz.nombres = nombres
        return tonnetz
    }

    /// Un recorrido de tríadas mayores y menores, colocado como en el Tonnetz: cada una, junto a
    /// la anterior. `svg()` dibuja una flecha de tríada en tríada, entre los vértices donde se
    /// tocan sus tres hexágonos. `nil` si algún acorde no es una tríada mayor o menor.
    ///
    ///     TablaArmonica(recorrido: ["Do", "Lam", "Fa", "Rem"])
    public init?(recorrido acordes: [Acorde]) {
        guard let tonnetz = Tonnetz(recorrido: acordes) else { return nil }
        puntos = tonnetz.puntos
        colocacion = .notas
        alturas = []
        recorrido = tonnetz.recorrido
    }

    /// El camino más corto por P, L y R entre dos tríadas: `TablaArmonica(caminoDesde: "Do", hasta: "Mibm")`.
    public init?(caminoDesde origen: Acorde, hasta destino: Acorde) {
        guard let tonnetz = Tonnetz(caminoDesde: origen, hasta: destino) else { return nil }
        puntos = tonnetz.puntos
        colocacion = .notas
        alturas = []
        recorrido = tonnetz.recorrido
    }

    /// Un ciclo neorriemanniano en la tabla armónica, como `Tonnetz(ciclo:desde:)`: la banda de
    /// tríadas de la de partida a la misma, con los nombres de `Acorde.ciclo(_:)`.
    ///
    ///     TablaArmonica(ciclo: .octatonico, desde: "Do")
    public init?(ciclo: CicloNeorriemanniano, desde acorde: Acorde) {
        guard let tonnetz = Tonnetz(ciclo: ciclo, desde: acorde) else { return nil }
        puntos = tonnetz.puntos
        colocacion = .notas
        alturas = []
        recorrido = tonnetz.recorrido
        nombres = tonnetz.nombres
        acordesDelRecorrido = tonnetz.acordesDelRecorrido
        origen = tonnetz.origen
    }

    /// Coloca las notas con su ortografía, como `Tonnetz(_:)`.
    public init(_ notas: [Nota]) {
        puntos = Tonnetz(notas).puntos
        colocacion = .notas
        alturas = []
        origen = .notas(notas.reduce(into: []) { if !$0.contains($1) { $0.append($1) } })
    }

    /// Las notas del acorde en la tabla armónica.
    public init(_ acorde: Acorde) {
        self.init(acorde.notas)
        origen = .acorde(acorde)
    }
    /// Las notas de la escala en la tabla armónica.
    public init(_ escala: Escala) {
        self.init(escala.notas)
        origen = .escala(escala)
    }

    /// Coloca las clases de altura en la tabla de doce notas, como `Tonnetz(_:)`.
    public init(_ conjunto: ConjuntoDeClasesDeAltura) {
        puntos = Tonnetz(conjunto).puntos
        colocacion = .clasesDeAltura
        alturas = []
        origen = .conjunto(conjunto)
    }

    /// Coloca las alturas como en el instrumento: cada una en un hexágono que suena a esa altura,
    /// en la disposición más compacta, como en el Tonnetz. Las alturas enarmónicas comparten hexágono.
    public init(_ alturas: [Altura]) {
        var vistas: [Altura] = []
        for altura in alturas where !vistas.contains(where: { $0.midi == altura.midi }) { vistas.append(altura) }
        puntos = Tonnetz.colocar(vistas.map(\.midi)) { midi, filas in
            // Los puntos con 7a + 4b = midi − 60: uno de cada siete columnas, así que se amplían
            // las que se buscan para que siempre haya alguno.
            ((filas.lowerBound - 3)...(filas.upperBound + 3)).compactMap { b in
                let resto = midi - 60 - 4 * b
                return modulo(resto, 7) == 0 ? PuntoDeLaRed(quintas: resto / 7, terceras: b) : nil
            }
        }
        colocacion = .alturas
        self.alturas = vistas
        origen = .alturas(vistas)
    }

    /// El número MIDI del hexágono, como en el instrumento: Do4 (60) en (0, 0).
    public static func midi(de punto: PuntoDeLaRed) -> Int { 60 + 7 * punto.quintas + 4 * punto.terceras }

    /// Las tríadas mayores y menores completas: tres hexágonos que se tocan en un vértice.
    public var triadas: [Tonnetz.Triada] {
        comoTonnetz.triadas
    }

    /// ¿Están todas las notas unidas por hexágonos vecinos?
    public var esConexo: Bool { comoTonnetz.esConexo }
}

extension TablaArmonica: CustomStringConvertible {
    /// "Do (0, 0) · Mi (0, 1) · Sol (1, 0)"; con alturas, "Do4 (0, 0) · …".
    public var description: String {
        switch colocacion {
        case .notas, .clasesDeAltura: return comoTonnetz.description
        case .alturas:
            return zip(alturas, puntos).map { "\($0.0) \($0.1)" }.joined(separator: " · ")
        }
    }
}
