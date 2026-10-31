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
// Nombres de los arpegios y de sus patrones en los catorce idiomas de los textos (`Traduccion`).

// MARK: - Arpegio

extension Arpegio {
    /// «Arpegio de Do mayor», «C major arpeggio», «Arpège de Do majeur», «C-Dur-Arpeggio», «Арпеджио до мажор».
    public func nombre(en notacion: Notacion) -> String {
        let acorde = self.acorde.nombre(en: notacion)
        let plantilla = Traduccion(
            "Arpegio de {}", "{} arpeggio", ca: "Arpegi de {}", gl: "Arpexo de {}",
            ast: "Arpexu de {}", an: "Arpechio de {}", eu: "{} arpegioa",
            pt: "Arpejo de {}", fr: "Arpège de {}", oc: "Arpegi de {}",
            it: "Arpeggio di {}", de: "Arpeggio: {}",
            el: "Αρπέζ {}", ru: "Арпеджио {}"
        ).en(notacion)
        return plantilla.replacingOccurrences(of: "{}", with: acorde)
    }

    public var nombre: String { nombre(en: .espanolUnicode) }

    /// Lee «arpegio Dom7», «Dom7 arpeggio», «Arpège de Do» o solo el cifrado: se quitan las palabras «arpegio»
    /// (en cualquier idioma) y las preposiciones que las acompañan, y el resto es un cifrado de acorde.
    /// El patrón es el ascendente, de una octava.
    public init(leyendo texto: String) throws {
        let palabras: Set<String> = [
            "arpegio", "arpeggio", "arpegi", "arpexo", "arpexu", "arpechio", "arpegioa", "arpejo", "arpege",
            "αρπεζ", "арпеджио", "de", "di", "of", "d'",
        ]
        func sinAcentos(_ s: String) -> String {
            s.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
        }
        let resto = texto.split(separator: " ").filter { !palabras.contains(sinAcentos(String($0))) }
            .joined(separator: " ")
        self.init(try Acorde(leyendo: resto.isEmpty ? texto : resto))
    }
}

// MARK: - Patron

extension Arpegio.Patron {
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    public var nombre: String { nombre(en: .espanolUnicode) }

    private var traduccion: Traduccion {
        switch self {
        case .ascendente:
            return Traduccion(
                "ascendente", "ascending", ca: "ascendent", gl: "ascendente", ast: "ascendente",
                an: "ascendent", eu: "igoera", pt: "ascendente", fr: "ascendant", oc: "ascendent",
                it: "ascendente", de: "aufwärts", el: "ανιούσα", ru: "восходящий")
        case .descendente:
            return Traduccion(
                "descendente", "descending", ca: "descendent", gl: "descendente", ast: "descendente",
                an: "descendent", eu: "jaitsiera", pt: "descendente", fr: "descendant", oc: "descendent",
                it: "discendente", de: "abwärts", el: "κατιούσα", ru: "нисходящий")
        case .idaYVuelta:
            return Traduccion(
                "de ida y vuelta", "up and down", ca: "d'anada i tornada", gl: "de ida e volta",
                ast: "d'ida y vuelta", an: "d'ida y tornada", eu: "joan-etorria", pt: "de ida e volta",
                fr: "aller-retour", oc: "d'anada e de tornada", it: "andata e ritorno",
                de: "auf und ab", el: "πάνω-κάτω", ru: "вверх и вниз")
        case .alberti:
            return Traduccion(
                "bajo de Alberti", "Alberti bass", ca: "baix d'Alberti", gl: "baixo de Alberti",
                ast: "baxu d'Alberti", an: "baixo d'Alberti", eu: "Albertiren baxua",
                pt: "baixo de Alberti", fr: "basse d'Alberti", oc: "bassa d'Alberti",
                it: "basso albertino", de: "Albertibass", el: "μπάσο Alberti", ru: "альбертиев бас")
        case .quebrado:
            return Traduccion(
                "quebrado", "broken", ca: "trencat", gl: "quebrado", ast: "quebráu", an: "trencau",
                eu: "hautsia", pt: "quebrado", fr: "brisé", oc: "trencat", it: "spezzato",
                de: "gebrochen", el: "σπαστό", ru: "ломаный")
        case .bajaYSube:
            return Traduccion(
                "de bajada y subida", "down and up", ca: "de baixada i pujada", gl: "de baixada e subida",
                ast: "de baxada y subida", an: "de baixada y puyada", eu: "jaitsi-igoa",
                pt: "de descida e subida", fr: "descente-montée", oc: "de davalada e de montada",
                it: "discesa e salita", de: "ab und auf", el: "κάτω-πάνω", ru: "вниз и вверх")
        }
    }
}
