import Elementos

// La relación escala-acorde del jazz: qué es cada nota de una escala sobre un acorde (nota del acorde, tensión
// disponible o nota a evitar) y de qué escala es modo cada escala (Re dórico, modo 2 de Do mayor).

// MARK: - PapelEnLaEscala

/// Lo que es una nota de una escala sobre un acorde, como en la teoría acorde-escala del jazz.
public enum PapelEnLaEscala: Hashable, Sendable, CaseIterable, CustomStringConvertible {
    /// Una nota del propio acorde.
    case delAcorde
    /// Una nota que se puede sostener sobre el acorde sin chocar con él: la 9, la ♯11, la 13…
    case tension
    /// Una nota que choca con el acorde si se sostiene: la que está un semitono por encima de una nota del acorde
    /// (el fa sobre Do7M en jónico), salvo la ♭9 y la ♭13 de un acorde de dominante, y la tercera mayor de un
    /// acorde sus4. Se usa de paso.
    case aEvitar

    public var description: String { nombre }
}

extension PapelEnLaEscala: Nombrable {
    /// «nota del acorde», «tensión», «nota a evitar»; «chord tone», «tension», «avoid note».
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .delAcorde: return TextosDeTeoria.en(notacion, \.papelNotaDelAcorde)
        case .tension: return TextosDeTeoria.en(notacion, \.papelTensionDisponible)
        case .aEvitar: return TextosDeTeoria.en(notacion, \.papelNotaAEvitar)
        }
    }
}

// MARK: - NotaSobreElAcorde

/// Una nota de una escala vista desde un acorde: qué es sobre él y qué grado ocupa desde su fundamental.
///
///     let notas = Escala(.do, .mayor).notas(sobre: Acorde("Do7M"))
///     notas.map(\.cifra)    // ["1", "9", "3", "11", "5", "13", "7"]
///     notas[3].papel        // .aEvitar (el fa, un semitono por encima del mi)
public struct NotaSobreElAcorde: Hashable, Sendable, CustomStringConvertible {
    /// La nota, escrita como en el acorde si es suya (aunque la escala la escriba de otra forma) y como en la
    /// escala si no.
    public let nota: Nota
    public let papel: PapelEnLaEscala
    /// El grado sobre la fundamental, como en los cifrados de jazz: «1», «♭3», «5», «7» para las notas del acorde;
    /// «9», «♭9», «♯9», «11», «♯11», «13», «♭13» para las demás (las 2.ª, 4.ª y 6.ª, una octava más arriba).
    public let cifra: String

    public var description: String { "\(nota.nombre) (\(cifra))" }
}

extension Escala {
    /// Si la escala tiene todas las notas del acorde, sin importar cómo se escriban (Fa♭ vale por Mi).
    public func contiene(acorde: Acorde) -> Bool {
        acorde.notas.allSatisfy { contieneEnarmonico($0) }
    }

    /// Las notas de la escala, en su orden, con lo que es cada una sobre el acorde: nota del acorde, tensión
    /// disponible o nota a evitar. Las notas del acorde que no están en la escala no salen.
    ///
    ///     Escala(.re, .dorico).notas(sobre: Acorde("Rem7")).filter { $0.papel == .tension }.map(\.cifra)
    ///     // ["9", "11", "13"]
    public func notas(sobre acorde: Acorde) -> [NotaSobreElAcorde] {
        let raiz = acorde.fundamental
        let propias = acorde.componentes
        let clases = Set(acorde.notas.map(\.claseDeAltura))
        let estructura = acorde.estructura
        let esDominante = estructura.tercera == .terceraMayor && estructura.septima == .septimaMenor
        let esSus4 = estructura.tercera == nil && estructura.suspension == .cuartaJusta
        func semitonos(_ nota: Nota) -> Int { modulo(nota.claseDeAltura - raiz.claseDeAltura, 12) }
        let tercera = acorde.tercera.map(semitonos)
        let quinta = acorde.quinta.map(semitonos)

        return notas.map { nota in
            if let propia = propias.first(where: { $0.nota.esEnarmonica(de: nota) }) {
                let cifra = Escala.cifra(propia.intervalo, numero: Escala.numero(de: propia.papel, propia.intervalo))
                return NotaSobreElAcorde(nota: propia.nota, papel: .delAcorde, cifra: cifra)
            }
            let s = semitonos(nota)
            let intervalo = raiz.intervalo(hasta: nota)
            // Un semitono por encima de una nota del acorde: choca con ella.
            var aEvitar = clases.contains(modulo(nota.claseDeAltura - 1, 12))
            if esDominante && (s == 1 || s == 8) { aEvitar = false }
            if esSus4 && s == 4 { aEvitar = true }
            // La 2.ª, la 4.ª y la 6.ª se cuentan una octava más arriba (9, 11, 13). Una 3.ª o una 5.ª que no son
            // las del acorde se leen como tensiones: la 3.ª menor de un acorde mayor es la ♯9; una 5.ª por debajo
            // de la del acorde, la ♯11, y por encima, la ♭13.
            var ordinal = intervalo.numeroSimple
            var numero = ordinal
            let bajoLaTercera = tercera.map { s < $0 } ?? false
            let bajoLaQuinta = quinta.map { s < $0 } ?? false
            let sobreLaQuinta = quinta.map { s > $0 } ?? false
            switch ordinal {
            case 2, 4, 6:
                numero = ordinal + 7
            case 3 where bajoLaTercera:
                (ordinal, numero) = (2, 9)
            case 5 where bajoLaQuinta:
                (ordinal, numero) = (4, 11)
            case 5 where sobreLaQuinta:
                (ordinal, numero) = (6, 13)
            default:
                break
            }
            let cifra = Escala.cifra(semitonos: s, numero: numero, ordinal: ordinal)
            return NotaSobreElAcorde(nota: nota, papel: aEvitar ? .aEvitar : .tension, cifra: cifra)
        }
    }

    /// Las tensiones disponibles de la escala sobre el acorde, en el orden de la escala.
    public func tensiones(sobre acorde: Acorde) -> [Nota] {
        notas(sobre: acorde).filter { $0.papel == .tension }.map(\.nota)
    }

    /// Las notas a evitar de la escala sobre el acorde: Fa en Do jónico sobre Do7M.
    public func notasAEvitar(sobre acorde: Acorde) -> [Nota] {
        notas(sobre: acorde).filter { $0.papel == .aEvitar }.map(\.nota)
    }

    /// El número con el que se cifra una nota del acorde según su papel: la tensión, como 9, 11 o 13; la
    /// suspensión y la sexta, como su intervalo; las demás, como su intervalo simple.
    private static func numero(de papel: PapelEnAcorde, _ intervalo: Intervalo) -> Int {
        if case .tension(let n) = papel { return n }
        return intervalo.numeroSimple
    }

    private static func cifra(_ intervalo: Intervalo, numero: Int) -> String {
        cifra(
            semitonos: modulo(intervalo.semitonos, 12), numero: numero, ordinal: intervalo.numeroSimple)
    }

    /// «♭9», «♯11», «13», «𝄫7»: la alteración respecto a la 2.ª, 3.ª, 6.ª y 7.ª mayores y a la 1.ª, 4.ª y 5.ª
    /// justas del número simple `ordinal`.
    private static func cifra(semitonos: Int, numero: Int, ordinal: Int) -> String {
        let natural = [0, 2, 4, 5, 7, 9, 11][modulo(ordinal - 1, 7)]
        var diferencia = modulo(semitonos - natural, 12)
        if diferencia > 6 { diferencia -= 12 }
        return (diferencia == 0 ? "" : Alteracion(diferencia).simbolo(en: .conDobles)) + String(numero)
    }
}

// MARK: - ModoDeEscala

/// Una escala como modo de otra: Re dórico es el modo 2 de Do mayor; Do alterada, el modo 7 de Re♭ menor melódica.
public struct ModoDeEscala: Hashable, Sendable, CustomStringConvertible {
    /// La escala de la que sale el modo, sobre su propia tónica.
    public let madre: Escala
    /// El grado de la madre en el que empieza el modo (1 = la propia madre).
    public let grado: Int

    public var description: String { nombre }
}

extension ModoDeEscala: Nombrable {
    /// «modo 2 de Do mayor», «mode 2 of C major», «Do maiorraren 2. modua».
    public func nombre(en notacion: Notacion) -> String {
        let madre = self.madre.nombre(en: notacion)
        return TextosDeTeoria.en(notacion) { $0.modoDe(grado, madre) }
    }
}

extension TipoDeEscala {
    /// Las escalas cuyos modos se nombran como tales en el jazz: la mayor, la menor melódica (la de jazz, igual al
    /// subir y al bajar), la menor armónica y la mayor armónica. ``Escala/escalaMadre`` las busca en este orden.
    public static let familiasDeModos: [TipoDeEscala] = [.mayor, .menorMelodicaJazz, .menorArmonica, .mayorArmonica]
}

extension Escala {
    /// La escala de la que esta es un modo, entre ``TipoDeEscala/familiasDeModos``: Re dórico → modo 2 de Do mayor,
    /// Sol frigio dominante → modo 5 de Do menor armónica, Do alterada → modo 7 de Re♭ menor melódica. La madre de
    /// sí misma es el modo 1 (Do mayor → modo 1 de Do mayor). `nil` si no es modo de ninguna, o si cambia al
    /// bajar (la menor melódica clásica).
    public var escalaMadre: ModoDeEscala? {
        guard !tipo.esDireccional else { return nil }
        for familia in TipoDeEscala.familiasDeModos where familia.intervalos.count == tipo.intervalos.count {
            for grado in 1...familia.intervalos.count where familia.modo(grado: grado) == tipo {
                return ModoDeEscala(madre: Escala(tonica - familia.intervalos[grado - 1], familia), grado: grado)
            }
        }
        return nil
    }
}
