import ArmoniaNucleo
import Foundation

// MARK: - Arpegio

/// Un acorde tocado nota a nota: el acorde, el orden en que se recorre y cuántas octavas abarca.
///
/// No es un tipo de escala. Sus notas son las del acorde (con su ortografía y su bajo), así que se leen, se
/// transportan y se nombran como el acorde; lo que añade es el recorrido.
///
///     Arpegio(Acorde("Do7")).alturas(octava: 4)                        // [Do4, Mi4, Sol4, Si♭4, Do5]
///     Arpegio(Acorde("Do"), patron: .alberti).alturas(octava: 3)       // [Do3, Sol3, Mi3, Sol3]
///     Escala("Re dórico").arpegio(grado: 1, cuatriada: true)           // el arpegio de Rem7
public struct Arpegio: Hashable, Sendable {
    /// El orden en que se recorren las notas.
    public enum Patron: String, CaseIterable, Hashable, Sendable {
        /// De la más grave a la más aguda.
        case ascendente
        /// De la más aguda a la más grave.
        case descendente
        /// Sube y vuelve a bajar, sin repetir la nota de arriba.
        case idaYVuelta
        /// El bajo de Alberti: grave, aguda, media, aguda (en una tríada, 1-5-3-5). Va por octavas completas y
        /// no añade la nota de la octava.
        case alberti
        /// Por terceras quebradas: cada nota salta a la que va dos más arriba y vuelve a la siguiente
        /// (Do–Sol–Mi–Do en una tríada con su octava).
        case quebrado
        /// Baja desde la nota de arriba y vuelve a subir, sin repetir la de abajo.
        case bajaYSube
    }

    public let acorde: Acorde
    public let patron: Patron
    /// Cuántas octavas abarca (al menos una).
    public let octavas: Int
    /// Si el recorrido acaba en la nota inicial una octava (o `octavas`) más arriba: Do–Mi–Sol–**Do**.
    public let conOctava: Bool

    public init(_ acorde: Acorde, patron: Patron = .ascendente, octavas: Int = 1, conOctava: Bool = true) {
        self.acorde = acorde
        self.patron = patron
        self.octavas = max(1, octavas)
        self.conOctava = conOctava
    }

    /// Las notas, con octava, a partir de `octava` (la del bajo del acorde, en posición cerrada), en el orden
    /// del patrón.
    public func alturas(octava: Int = 4) -> [Altura] {
        let base = acorde.posicionCerrada(octava: octava)
        guard let primera = base.first, let ultima = base.last else { return [] }

        func subida(_ altura: Altura, _ octavas: Int) -> Altura {
            var resultado = altura
            for _ in 0..<octavas { resultado = resultado + Intervalo.octava }
            return resultado
        }
        var sube: [Altura] = []
        for o in 0..<octavas { sube += base.map { subida($0, o) } }
        if conOctava { sube.append(subida(primera, octavas)) }

        switch patron {
        case .ascendente:
            return sube
        case .descendente:
            return sube.reversed()
        case .idaYVuelta:
            return sube + sube.reversed().dropFirst()
        case .alberti:
            guard base.count >= 3 else { return sube }
            var alberti: [Altura] = []
            for o in 0..<octavas {
                alberti += [subida(primera, o), subida(ultima, o), subida(base[1], o), subida(ultima, o)]
            }
            return alberti
        case .quebrado:
            guard sube.count >= 3 else { return sube }
            var quebrado: [Altura] = []
            for i in 0..<(sube.count - 2) { quebrado += [sube[i], sube[i + 2]] }
            return quebrado
        case .bajaYSube:
            return sube.reversed() + sube.dropFirst()
        }
    }

    /// Los nombres de las notas en el orden del patrón y desde la octava 4, con repeticiones.
    public var notas: [Nota] { alturas().map(\.nota) }

    /// El mismo arpegio en otro tono.
    public func transponer(_ intervalo: Intervalo) -> Arpegio {
        Arpegio(acorde.transponer(intervalo), patron: patron, octavas: octavas, conOctava: conOctava)
    }
}

// MARK: - Desde escalas y acordes

extension Escala {
    /// El arpegio del acorde por terceras superpuestas sobre un grado: tríada o cuatríada (`nil` si no forma
    /// un acorde conocido). `Escala("Do mayor").arpegio(grado: 5, cuatriada: true)` es el de Sol7.
    public func arpegio(
        grado: Int = 1, cuatriada: Bool = false, patron: Arpegio.Patron = .ascendente,
        octavas: Int = 1, conOctava: Bool = true
    ) -> Arpegio? {
        acorde(grado: grado, cuatriada: cuatriada).map {
            Arpegio($0, patron: patron, octavas: octavas, conOctava: conOctava)
        }
    }

    /// El arpegio con los grados que se indiquen, contados desde 1, y el primero como fundamental:
    /// `Escala("Do mayor").arpegio(grados: [1, 3, 5, 6])` es el de Do6. `nil` si hay menos de dos
    /// grados o las notas no forman un acorde conocido.
    public func arpegio(
        grados: [Int], patron: Arpegio.Patron = .ascendente, octavas: Int = 1,
        conOctava: Bool = true
    ) -> Arpegio? {
        guard grados.count >= 2 else { return nil }
        let nombres = grados.map { grado($0) }
        let raiz = nombres[0]
        guard let tipo = TipoDeAcorde(pasosDeQuinta: Set(nombres.map { $0.pasosDeQuinta - raiz.pasosDeQuinta })) else {
            return nil
        }
        return Arpegio(Acorde(raiz, tipo), patron: patron, octavas: octavas, conOctava: conOctava)
    }

    /// Los arpegios de todos los grados (`nil` si un grado no forma un acorde conocido).
    public func arpegios(cuatriadas: Bool = false) -> [Arpegio?] {
        (1...tipo.intervalos.count).map { arpegio(grado: $0, cuatriada: cuatriadas) }
    }
}

extension Acorde {
    /// El arpegio del acorde.
    public func arpegio(patron: Arpegio.Patron = .ascendente, octavas: Int = 1, conOctava: Bool = true) -> Arpegio {
        Arpegio(self, patron: patron, octavas: octavas, conOctava: conOctava)
    }

    /// Las escalas sobre la fundamental del acorde que contienen todas sus notas (la relación acorde-escala del
    /// jazz: Do7 → Do mixolidio…), de las de menos notas a las de más. Por defecto, entre las del catálogo
    /// (`TipoDeEscala.todos`); las tensiones cuentan como la nota que son (la novena, como la segunda).
    public func escalasCompatibles(entre tipos: [TipoDeEscala] = TipoDeEscala.todos) -> [Escala] {
        let propias = notas
        let compatibles = tipos.map { Escala(fundamental, $0) }.filter { escala in
            propias.allSatisfy { escala.contiene($0) }
        }
        return compatibles.enumerated().sorted { a, b in
            let (x, y) = (a.element.tipo.intervalos.count, b.element.tipo.intervalos.count)
            return x != y ? x < y : a.offset < b.offset
        }.map(\.element)
    }
}

// MARK: - Idiomas
//
// Nombres de los arpegios y de sus patrones en los catorce idiomas, en `TextosDeTeoria`.

// MARK: - Arpegio

extension Arpegio: Nombrable {
    /// «Arpegio de Do mayor», «C major arpeggio», «Arpège de Do majeur», «C-Dur-Arpeggio», «Арпеджио до мажор».
    public func nombre(en notacion: Notacion) -> String {
        let acorde = self.acorde.nombre(en: notacion)
        return TextosDeTeoria.en(notacion) { $0.arpegioDe(acorde) }
    }

    /// Lee «arpegio Dom7», «Dom7 arpeggio», «Arpège de Do» o solo el cifrado: se quitan las palabras «arpegio»
    /// (en cualquier idioma) y las preposiciones que las acompañan, y el resto es un cifrado de acorde.
    /// El patrón es el ascendente, de una octava.
    public init(leyendo texto: String) throws {
        let palabras: Set<String> = [
            "arpegio", "arpeggio", "arpegi", "arpexo", "arpexu", "arpechio", "arpegioa", "arpejo", "arpege",
            "αρπεζ", "арпеджио", "de", "di", "of", "d'",
        ]
        let resto = texto.split(separator: " ").filter { !palabras.contains(String($0).claveDeBusqueda) }
            .joined(separator: " ")
        self.init(try Acorde(leyendo: resto.isEmpty ? texto : resto))
    }
}

// MARK: - Patron

extension Arpegio.Patron {
    /// Lee un patrón por su nombre en el código (`alberti`, `idaYVuelta`), con guiones o guiones bajos
    /// (`ida-y-vuelta`), en inglés abreviado (`up`, `down`, `up-down`, `down-up`, `broken`) o como lo escribe
    /// cualquiera de los catorce idiomas («bajo de Alberti», «aller-retour»), sin mirar mayúsculas ni tildes.
    public init?(leyendo texto: String) {
        func clave(_ texto: String) -> String { texto.replacingOccurrences(of: "_", with: " ").claveDeBusqueda }
        let buscado = clave(texto)
        let abreviados: [String: Arpegio.Patron] = [
            "ida y vuelta": .idaYVuelta, "up": .ascendente, "down": .descendente, "up down": .idaYVuelta,
            "baja y sube": .bajaYSube, "down up": .bajaYSube, "broken": .quebrado,
        ]
        let patron =
            abreviados[buscado]
            ?? Self.allCases.first { patron in
                clave(patron.rawValue) == buscado
                    || Idioma.allCases.contains { clave(patron.nombre(en: .delIdioma($0))) == buscado }
            }
        guard let patron else { return nil }
        self = patron
    }
}

extension Arpegio.Patron: Nombrable {
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .ascendente:
            return TextosDeTeoria.traduccion(\.patronAscendente)
        case .descendente:
            return TextosDeTeoria.traduccion(\.patronDescendente)
        case .idaYVuelta:
            return TextosDeTeoria.traduccion(\.patronIdaYVuelta)
        case .alberti:
            return TextosDeTeoria.traduccion(\.patronAlberti)
        case .quebrado:
            return TextosDeTeoria.traduccion(\.patronQuebrado)
        case .bajaYSube:
            return TextosDeTeoria.traduccion(\.patronBajaYSube)
        }
    }
}
