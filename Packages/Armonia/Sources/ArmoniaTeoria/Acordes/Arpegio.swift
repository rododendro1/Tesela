import ArmoniaNucleo
import Foundation

// MARK: - Arpegio

/// Un acorde tocado nota a nota: el acorde, el orden en que se recorre y cuántas octavas abarca.
///
/// No es un tipo de escala. Sus notas son las del acorde (con su ortografía y su bajo), así que se leen, se
/// transportan y se nombran como el acorde; lo que añade es el recorrido: el patrón (o uno propio por grados),
/// la nota por la que empieza, las tensiones que se suman por encima y las notas cromáticas que llevan a cada una.
///
///     Arpegio(Acorde("Do7")).alturas(octava: 4)                        // [Do4, Mi4, Sol4, Si♭4, Do5]
///     Arpegio(Acorde("Do"), patron: .alberti).alturas(octava: 3)       // [Do3, Sol3, Mi3, Sol3]
///     Arpegio(Acorde("Do"), inicio: 1).alturas(octava: 4)              // [Mi4, Sol4, Do5, Mi5]
///     Arpegio(Acorde("Do7"), tensiones: [9]).alturas(octava: 4)        // [Do4, Mi4, Sol4, Si♭4, Re5, Do6]
///     Arpegio(Acorde("Do"), grados: [1, 5, 3, 8]).alturas(octava: 4)   // [Do4, Sol4, Mi4, Do5]
///     Escala("Re dórico").arpegio(grado: 1, cuatriada: true)           // el arpegio de Rem7
public struct Arpegio: Hashable, Sendable {
    /// El orden en que se recorren las notas.
    public enum Patron: String, CaseIterable, Hashable, Sendable, Codable {
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

    /// Las notas cromáticas que llevan a cada nota del arpegio, como en las líneas de bebop.
    public enum Aproximacion: String, CaseIterable, Hashable, Sendable, Codable {
        /// Un semitono por debajo: Re♯–Mi.
        case desdeAbajo
        /// Un semitono por encima: Fa–Mi.
        case desdeArriba
        /// Rodeándola: un semitono por encima, otro por debajo y la nota (Fa–Re♯–Mi).
        case encierro
    }

    public let acorde: Acorde
    public let patron: Patron
    /// Cuántas octavas abarca (al menos una). Con tensiones, cada vuelta ocupa las octavas que hagan falta.
    public let octavas: Int
    /// Si el recorrido acaba en la nota inicial una octava (o `octavas`) más arriba: Do–Mi–Sol–**Do**.
    public let conOctava: Bool
    /// La nota del acorde por la que empieza, contando desde el bajo en posición cerrada: 0 es el bajo; en Do, 1
    /// empieza por Mi (Mi–Sol–Do) y 2 por Sol. Las de antes suben una octava.
    public let inicio: Int
    /// Las tensiones que se tocan por encima de las notas del acorde, de entre 9, 11 y 13, en ese orden. Las que el
    /// acorde ya tiene (la 9 de Do9) no se repiten; las demás salen de su escala (``nota(delGrado:)``).
    public let tensiones: [Int]
    /// Un recorrido propio, por grados sobre la fundamental: `[1, 5, 3, 8]` es Do–Sol–Mi–Do en Do; 9, 11 y 13 son
    /// las tensiones y 10 o 12, la tercera y la quinta una octava más arriba. Si no está vacío, manda sobre
    /// `patron`, `inicio`, `tensiones` y `conOctava`.
    public let grados: [Int]
    /// Las notas cromáticas que llevan a cada nota, o `nil` si no las hay.
    public let aproximacion: Aproximacion?

    /// El arpegio de un acorde con ese patrón, empezando por la nota `inicio` y abarcando `octavas`.
    public init(
        _ acorde: Acorde, patron: Patron = .ascendente, octavas: Int = 1, conOctava: Bool = true,
        inicio: Int = 0, tensiones: [Int] = [], aproximacion: Aproximacion? = nil
    ) {
        let cuantas = acorde.notasDesdeElBajo.count
        self.init(
            acorde: acorde, patron: patron, octavas: octavas, conOctava: conOctava,
            inicio: cuantas > 0 ? ((inicio % cuantas) + cuantas) % cuantas : 0,
            tensiones: Array(Set(tensiones.filter { [9, 11, 13].contains($0) })).sorted(), grados: [],
            aproximacion: aproximacion)
    }

    /// Un arpegio con un recorrido propio por grados sobre la fundamental (los menores que 1 no cuentan), que se
    /// repite `octavas` veces, cada vez más arriba.
    public init(_ acorde: Acorde, grados: [Int], octavas: Int = 1, aproximacion: Aproximacion? = nil) {
        self.init(
            acorde: acorde, patron: .ascendente, octavas: octavas, conOctava: false, inicio: 0, tensiones: [],
            grados: grados.filter { $0 >= 1 }, aproximacion: aproximacion)
    }

    private init(
        acorde: Acorde, patron: Patron, octavas: Int, conOctava: Bool, inicio: Int, tensiones: [Int],
        grados: [Int], aproximacion: Aproximacion?
    ) {
        self.acorde = acorde
        self.patron = patron
        self.octavas = max(1, octavas)
        self.conOctava = conOctava
        self.inicio = inicio
        self.tensiones = tensiones
        self.grados = grados
        self.aproximacion = aproximacion
    }

    /// Las notas, con octava, a partir de `octava` (la del bajo del acorde, en posición cerrada; la de la
    /// fundamental en un recorrido por grados), en el orden del patrón y con sus notas de aproximación.
    public func alturas(octava: Int = 4) -> [Altura] {
        let recorrido = grados.isEmpty ? recorridoDelPatron(octava: octava) : recorridoPorGrados(octava: octava)
        guard let aproximacion else { return recorrido }
        return recorrido.flatMap { nota -> [Altura] in
            switch aproximacion {
            case .desdeAbajo: return [nota - Intervalo.segundaMenor, nota]
            case .desdeArriba: return [nota + Intervalo.segundaMenor, nota]
            case .encierro: return [nota + Intervalo.segundaMenor, nota - Intervalo.segundaMenor, nota]
            }
        }
    }

    private func recorridoDelPatron(octava: Int) -> [Altura] {
        var base = acorde.posicionCerrada(octava: octava)
        if inicio > 0, inicio < base.count {
            base = Array(base[inicio...]) + base[..<inicio].map { $0 + Intervalo.octava }
        }
        base += alturasDeLasTensiones(encimaDe: base)
        guard let primera = base.first, let ultima = base.last else { return [] }
        // Las octavas que ocupa cada vuelta: una sin tensiones; con ellas, las que hagan falta.
        let vuelta = (ultima.midi - primera.midi) / 12 + 1

        func subida(_ altura: Altura, _ octavas: Int) -> Altura {
            var resultado = altura
            for _ in 0..<octavas { resultado = resultado + Intervalo.octava }
            return resultado
        }
        var sube: [Altura] = []
        for o in 0..<octavas { sube += base.map { subida($0, o * vuelta) } }
        if conOctava { sube.append(subida(primera, octavas * vuelta)) }

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
                let v = o * vuelta
                alberti += [subida(primera, v), subida(ultima, v), subida(base[1], v), subida(ultima, v)]
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

    /// Las tensiones que el acorde no tiene, cada una por encima de la anterior y de la nota más aguda.
    private func alturasDeLasTensiones(encimaDe base: [Altura]) -> [Altura] {
        guard var arriba = base.last else { return [] }
        let suyos = Set(acorde.notas.map { acorde.fundamental.intervalo(hasta: $0).numeroSimple })
        var resultado: [Altura] = []
        for tension in tensiones where !suyos.contains(tension - 7) {
            let nota = self.nota(delGrado: tension - 7)
            var altura = Altura(nota, octava: arriba.octava - 1)
            while altura.midi <= arriba.midi { altura = altura + Intervalo.octava }
            resultado.append(altura)
            arriba = altura
        }
        return resultado
    }

    private func recorridoPorGrados(octava: Int) -> [Altura] {
        let mayor = grados.reduce(1, max)
        let raiz = Altura(acorde.fundamental, octava: octava)
        // Cada vuelta sube las octavas que abarca el recorrido: una hasta el 8, dos hasta el 15.
        let vuelta = max(1, (mayor + 5) / 7)
        var resultado: [Altura] = []
        for o in 0..<octavas {
            for grado in grados {
                let nota = self.nota(delGrado: (grado - 1) % 7 + 1)
                let semitonos = ((nota.claseDeAltura - raiz.nota.claseDeAltura) % 12 + 12) % 12
                let midi = raiz.midi + semitonos + 12 * ((grado - 1) / 7 + o * vuelta)
                resultado.append(Self.altura(nota, midi: midi))
            }
        }
        return resultado
    }

    /// La nota de un grado (de 1 a 7) sobre la fundamental: la del acorde si la tiene (la 3.ª de Dom es Mi♭) y, si
    /// no, la de su escala, la primera de siete notas de ``Acorde/escalasCompatibles(entre:)`` (la que menos notas
    /// a evitar tiene: en Do7, Do lidio dominante, así que la 11 es Fa♯), o la mayor si no encaja ninguna.
    public func nota(delGrado grado: Int) -> Nota {
        let fundamental = acorde.fundamental
        if let propia = acorde.notas.first(where: { fundamental.intervalo(hasta: $0).numeroSimple == grado }) {
            return propia
        }
        let escalas = acorde.escalasCompatibles().filter { $0.notas.count == 7 } + [Escala(fundamental, .mayor)]
        return escalas[0].grado(grado)
    }

    /// La altura de `nota` que suena como `midi`, que tiene que ser de su misma clase de altura.
    static func altura(_ nota: Nota, midi: Int) -> Altura {
        let cerca = Altura(nota, octava: 4)
        return Altura(nota, octava: 4 + (midi - cerca.midi) / 12)
    }

    /// Los nombres de las notas en el orden del patrón y desde la octava 4, con repeticiones.
    public var notas: [Nota] { alturas().map(\.nota) }

    /// El mismo arpegio en otro tono.
    public func transponer(_ intervalo: Intervalo) -> Arpegio {
        Arpegio(
            acorde: acorde.transponer(intervalo), patron: patron, octavas: octavas, conOctava: conOctava,
            inicio: inicio, tensiones: tensiones, grados: grados, aproximacion: aproximacion)
    }

    /// El `inicio` que empieza por una nota del acorde (Mi en Do, o Fa♭, que suena igual), o `nil` si no es suya.
    public static func indice(de nota: Nota, en acorde: Acorde) -> Int? {
        acorde.notasDesdeElBajo.firstIndex { $0.claseDeAltura == nota.claseDeAltura }
    }

    /// El `inicio` que empieza por un grado del acorde sobre su fundamental (3 en Do es Mi; 10, también), o `nil`
    /// si el acorde no lo tiene.
    public static func indice(delGrado grado: Int, en acorde: Acorde) -> Int? {
        guard grado >= 1 else { return nil }
        let simple = (grado - 1) % 7 + 1
        return acorde.notasDesdeElBajo.firstIndex { acorde.fundamental.intervalo(hasta: $0).numeroSimple == simple }
    }

    /// Lee un recorrido por grados: «1 5 3 8», «1-5-3-8» o «1, 5, 3, 8». Lanza `ErrorDeLectura` (`.textoVacio`) si
    /// está vacío y `ErrorDeLecturaDeTeoria` (`.numeroFueraDeRango`, en su carácter) si algo no es un número de 1 a
    /// 22 (tres octavas).
    public static func grados(leyendo texto: String) throws -> [Int] {
        try numeros(leyendo: texto) { parte, posicion in
            guard let grado = Int(parte), (1...22).contains(grado) else {
                throw ErrorDeLecturaDeTeoria(
                    texto: texto, posicion: posicion, motivo: .numeroFueraDeRango(parte, desde: 1, hasta: 22))
            }
            return grado
        }
    }

    /// Lee las tensiones: «9», «9 13», «9,11,13». Lanza `ErrorDeLectura` (`.textoVacio`) si está vacío y
    /// `ErrorDeLecturaDeTeoria` (`.nombreNoReconocido`, en su carácter) si algo no es 9, 11 o 13.
    public static func tensiones(leyendo texto: String) throws -> [Int] {
        try numeros(leyendo: texto) { parte, posicion in
            guard let tension = Int(parte), [9, 11, 13].contains(tension) else {
                throw ErrorDeLecturaDeTeoria(
                    texto: texto, posicion: posicion, motivo: .nombreNoReconocido(parte, opciones: ["9", "11", "13"]))
            }
            return tension
        }
    }

    /// Los números de un texto separados por espacios, comas o guiones, cada uno leído por `leer` con el carácter
    /// donde empieza.
    private static func numeros(leyendo texto: String, _ leer: (String, Int) throws -> Int) throws -> [Int] {
        var numeros: [Int] = []
        var actual = ""
        var inicio = 0
        for (i, caracter) in texto.enumerated() {
            if caracter == " " || caracter == "," || caracter == "-" {
                if !actual.isEmpty { numeros.append(try leer(actual, inicio)) }
                actual = ""
            } else {
                if actual.isEmpty { inicio = i }
                actual.append(caracter)
            }
        }
        if !actual.isEmpty { numeros.append(try leer(actual, inicio)) }
        guard !numeros.isEmpty else { throw ErrorDeLectura(texto: texto, posicion: nil, motivo: .textoVacio) }
        return numeros
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
    /// jazz: Do7 → Do mixolidio…), de las que tienen menos notas a evitar sobre el acorde
    /// (``Escala/notasAEvitar(sobre:)``) a las que más y, a igualdad, en el orden de `tipos`. Por defecto, entre
    /// las de ``TipoDeEscala/deJazz``: Do7(♯11) da primero Do lidio dominante, sin ninguna. Las tensiones cuentan
    /// como la nota que son (la novena, como la segunda), y una nota escrita de otra forma vale (Fa♭ por Mi).
    public func escalasCompatibles(entre tipos: [TipoDeEscala] = TipoDeEscala.deJazz) -> [Escala] {
        let compatibles = tipos.map { Escala(fundamental, $0) }.filter { $0.contiene(acorde: self) }
        let aEvitar = compatibles.map { $0.notasAEvitar(sobre: self).count }
        return compatibles.indices.sorted { a, b in
            aEvitar[a] != aEvitar[b] ? aEvitar[a] < aEvitar[b] : a < b
        }.map { compatibles[$0] }
    }
}

// MARK: - Idiomas
//
// Nombres de los arpegios y de sus patrones en los quince idiomas, en `TextosDeTeoria`.

// MARK: - Arpegio

/// Se codifica con sus campos: el acorde, el patrón, las octavas, el inicio, las tensiones, los grados y la
/// aproximación.
extension Arpegio: Codable {}

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
    /// cualquiera de los quince idiomas («bajo de Alberti», «aller-retour»), sin mirar mayúsculas ni tildes. Si no
    /// es ninguno, lanza `ErrorDeLecturaDeTeoria` con los que sí (`.nombreNoReconocido`).
    public init(leyendo texto: String) throws {
        func clave(_ texto: String) -> String { texto.replacingOccurrences(of: "_", with: " ").claveDeBusqueda }
        let buscado = clave(texto)
        let abreviados: [String: Arpegio.Patron] = [
            "ida y vuelta": .idaYVuelta, "up": .ascendente, "down": .descendente, "up down": .idaYVuelta,
            "baja y sube": .bajaYSube, "down up": .bajaYSube, "broken": .quebrado,
        ]
        func esElBuscado(_ patron: Arpegio.Patron) -> Bool {
            clave(patron.rawValue) == buscado
                || Idioma.allCases.contains { clave(patron.nombre(en: .delIdioma($0))) == buscado }
        }
        guard let leido = abreviados[buscado] ?? Self.allCases.first(where: esElBuscado) else {
            let opciones = Self.allCases.map(\.rawValue)
            throw ErrorDeLecturaDeTeoria(
                texto: texto, posicion: nil, motivo: .nombreNoReconocido(texto, opciones: opciones))
        }
        self = leido
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

// MARK: - Aproximacion

extension Arpegio.Aproximacion {
    /// Lee una aproximación por su nombre en el código (`desdeAbajo`, `desde-abajo`), abreviada (`abajo`,
    /// `arriba`, `below`, `above`, `enclosure`) o como la escribe cualquiera de los quince idiomas, sin mirar
    /// mayúsculas ni tildes. Si no es ninguna, lanza `ErrorDeLecturaDeTeoria` con las que sí (`.nombreNoReconocido`).
    public init(leyendo texto: String) throws {
        func clave(_ texto: String) -> String {
            texto.replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: "-", with: " ").claveDeBusqueda
        }
        let buscado = clave(texto)
        let abreviados: [String: Arpegio.Aproximacion] = [
            "abajo": .desdeAbajo, "arriba": .desdeArriba, "below": .desdeAbajo, "above": .desdeArriba,
            "enclosure": .encierro, "desde abajo": .desdeAbajo, "desde arriba": .desdeArriba,
        ]
        func esElBuscado(_ aproximacion: Arpegio.Aproximacion) -> Bool {
            clave(aproximacion.rawValue) == buscado
                || Idioma.allCases.contains { clave(aproximacion.nombre(en: .delIdioma($0))) == buscado }
        }
        guard let leida = abreviados[buscado] ?? Self.allCases.first(where: esElBuscado) else {
            let opciones = Self.allCases.map(\.rawValue)
            throw ErrorDeLecturaDeTeoria(
                texto: texto, posicion: nil, motivo: .nombreNoReconocido(texto, opciones: opciones))
        }
        self = leida
    }
}

extension Arpegio.Aproximacion: Nombrable {
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .desdeAbajo:
            return TextosDeTeoria.traduccion(\.aproximacionDesdeAbajo)
        case .desdeArriba:
            return TextosDeTeoria.traduccion(\.aproximacionDesdeArriba)
        case .encierro:
            return TextosDeTeoria.traduccion(\.aproximacionEncierro)
        }
    }
}
