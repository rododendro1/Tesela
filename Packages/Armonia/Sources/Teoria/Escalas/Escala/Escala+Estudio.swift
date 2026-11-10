import Elementos

// Para estudiar una escala: las secuencias con que se practica (por terceras, en grupos, en arpegios), los modos
// sobre la misma tónica y con las mismas notas, la comparación con otra escala, las escalas bebop y pentatónicas
// sobre un acorde, la digitación de piano y lo que cambia de una escala a la siguiente en una progresión.

// MARK: - Secuencias

/// Una secuencia de estudio: desde cada grado de la escala, un mismo dibujo de grados.
public enum SecuenciaDeEscala: String, Hashable, Sendable, CaseIterable, CustomStringConvertible, Codable {
    /// Do Mi, Re Fa, Mi Sol…
    case terceras
    /// Do Fa, Re Sol, Mi La…
    case cuartas
    /// Do Re Mi, Re Mi Fa, Mi Fa Sol…
    case gruposDeTres
    /// Do Re Mi Fa, Re Mi Fa Sol…
    case gruposDeCuatro
    /// La tríada de cada grado: Do Mi Sol, Re Fa La…
    case triadas
    /// La cuatriada de cada grado: Do Mi Sol Si, Re Fa La Do…
    case cuatriadas

    /// Los grados que se tocan desde cada uno, contados desde él: `[0, 2]` en terceras, `[0, 1, 2]` en grupos de
    /// tres.
    public var pasos: [Int] {
        switch self {
        case .terceras: return [0, 2]
        case .cuartas: return [0, 3]
        case .gruposDeTres: return [0, 1, 2]
        case .gruposDeCuatro: return [0, 1, 2, 3]
        case .triadas: return [0, 2, 4]
        case .cuatriadas: return [0, 2, 4, 6]
        }
    }

    public var description: String { nombre }
}

extension SecuenciaDeEscala: Nombrable {
    /// «por terceras», «en grupos de tres», «en tríadas»; «in thirds», «in groups of three», «in triads».
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .terceras: return TextosDeTeoria.en(notacion, \.secuenciaTerceras)
        case .cuartas: return TextosDeTeoria.en(notacion, \.secuenciaCuartas)
        case .gruposDeTres: return TextosDeTeoria.en(notacion, \.secuenciaGruposDeTres)
        case .gruposDeCuatro: return TextosDeTeoria.en(notacion, \.secuenciaGruposDeCuatro)
        case .triadas: return TextosDeTeoria.en(notacion, \.secuenciaTriadas)
        case .cuatriadas: return TextosDeTeoria.en(notacion, \.secuenciaCuatriadas)
        }
    }
}

extension Escala {
    /// La escala tocada en una secuencia de estudio, desde la tónica en `octava` y a lo largo de `octavas` octavas,
    /// subiendo o bajando (con la forma descendente de la escala, si la tiene), y acabando en la tónica.
    ///
    ///     Escala(.do).secuencia(.terceras).prefix(6)   // [Do4, Mi4, Re4, Fa4, Mi4, Sol4]
    ///
    /// Vacío en una escala de menos de tres notas.
    public func secuencia(
        _ secuencia: SecuenciaDeEscala, octava: Int = 4, octavas: Int = 1, sentido: SentidoDelIntervalo = .ascendente
    ) -> [Altura] {
        let forma = sentido == .ascendente ? tipo : tipo.formaDescendente
        let n = forma.intervalos.count
        guard n >= 3 else { return [] }
        let octavas = max(1, octavas)
        // La escala desde dos octavas por debajo hasta dos por encima de las pedidas, para los dibujos que se salen.
        var alturas: [Altura] = []
        for o in 0..<(octavas + 4) {
            let base = Altura(tonica, octava: octava - 2 + o)
            alturas += forma.intervalos.map { base + $0 }
        }
        let desde = 2 * n
        let pasos = n * octavas
        func indice(_ i: Int) -> Int { sentido == .ascendente ? desde + i : desde + pasos - i }
        var resultado = (0..<pasos).flatMap { i in secuencia.pasos.map { alturas[indice(i + $0)] } }
        resultado.append(alturas[indice(pasos)])
        return resultado
    }
}

// MARK: - Modos

extension TipoDeEscala {
    /// Los siete modos de la escala mayor del más brillante al más oscuro: lidio, jónico, mixolidio, dórico, eólico,
    /// frigio y locrio. Cada uno baja una nota del anterior.
    public static let modosPorBrillo: [TipoDeEscala] = [
        .lidio, .mayor, .mixolidio, .dorico, .menorNatural, .frigio, .locrio,
    ]
}

extension Escala {
    /// Cuánto más brillante (+) u oscura (−) es una escala de siete notas que la mayor sobre la misma tónica: los
    /// semitonos que suben o bajan sus grados en total. Lidio +1, jónico 0, dórico −2, locrio −5. `nil` si la escala
    /// no tiene siete notas.
    public var brillo: Int? {
        guard tipo.intervalos.count == 7 else { return nil }
        return tipo.intervalos.map(\.semitonos).reduce(0, +) - 38
    }

    /// Los siete modos de la mayor sobre la misma tónica, del más brillante al más oscuro: los modos paralelos.
    public var modosParalelos: [Escala] { TipoDeEscala.modosPorBrillo.map { Escala(tonica, $0) } }

    /// Las escalas con las mismas notas que empiezan en cada grado: los modos relativos (en Do mayor, Do jónico,
    /// Re dórico, Mi frigio…).
    public var modosRelativos: [Escala] { (1...tipo.intervalos.count).map { modo(grado: $0) } }
}

// MARK: - Comparar dos escalas

/// Un grado que cambia de una escala a otra con la misma tónica: el 4.º, de Fa a Fa♯, de Do mayor a Do lidio.
public struct CambioDeGrado: Hashable, Sendable {
    public let grado: Int
    public let desde: Nota
    public let hasta: Nota
}

/// Dos escalas comparadas: las notas que comparten, las que solo están en una y, si tienen la misma tónica y el
/// mismo número de notas, los grados que cambian.
@available(*, deprecated, message: "Usa RelacionEntreEscalas, de Escala.relacion(con:)")
public struct ComparacionDeEscalas: Hashable, Sendable {
    public let origen: Escala
    public let destino: Escala
    /// Las notas de `origen` que también están en `destino`, aunque se escriban de otra forma.
    public let comunes: [Nota]
    public let soloEnOrigen: [Nota]
    public let soloEnDestino: [Nota]
    /// Vacío si las tónicas o el número de notas son distintos.
    public let cambios: [CambioDeGrado]

    /// Cuántas alteraciones cambian en la armadura, si las dos escalas son diatónicas: de Do mayor a Sol mayor, 1.
    public var distanciaEnQuintas: Int? { origen.distancia(hasta: destino) }
}

extension Escala {
    /// Esta escala y otra: notas comunes, las que solo están en una y los grados que cambian.
    @available(*, deprecated, renamed: "relacion(con:)")
    public func comparar(con otra: Escala) -> ComparacionDeEscalas {
        let relacion = relacion(con: otra)
        return ComparacionDeEscalas(
            origen: self, destino: otra, comunes: relacion.comunes, soloEnOrigen: relacion.soloEnOrigen,
            soloEnDestino: relacion.soloEnDestino, cambios: relacion.cambios)
    }

    /// Las notas de esta escala que no estaban en `anterior`: lo que cambia al pasar de una a otra en una
    /// progresión (de Re dórico a Sol mixolidio, nada; de Do mayor a La frigio dominante, Si♭ y Do♯).
    public func cambios(desde anterior: Escala) -> [Nota] {
        let previas = Set(anterior.notas.map(\.claseDeAltura))
        return notas.filter { !previas.contains($0.claseDeAltura) }
    }
}

// MARK: - Bebop y pentatónicas sobre un acorde

extension TipoDeEscala {
    /// Las escalas bebop: de ocho notas, con una nota cromática de paso para que, bajando en corcheas, las notas
    /// del acorde caigan en las partes fuertes.
    public static let bebop: [TipoDeEscala] = [
        .bebopDominante, .bebopMayor, .bebopDorico, .bebopMenorMelodica, .bebopMenorArmonica,
    ]
}

/// Una escala bebop sobre un acorde: la nota de paso y el recorrido de ocho notas, bajando, con una nota del acorde
/// en cada parte fuerte.
public struct EscalaBebop: Hashable, Sendable {
    public let escala: Escala
    /// La nota cromática que se añade a la escala de siete notas: el Si en Do bebop dominante.
    public let notaDePaso: Nota
    /// Ocho notas bajando desde una nota del acorde; la 1.ª, la 3.ª, la 5.ª y la 7.ª son del acorde.
    public let recorrido: [Nota]
}

/// Una escala pentatónica sobre un acorde, sin notas a evitar: lo que es cada nota sobre él.
public struct PentatonicaSobreElAcorde: Hashable, Sendable {
    public let escala: Escala
    public let notas: [NotaSobreElAcorde]

    /// Las notas que suma al acorde como tensiones, con su grado: la 9, la ♯11, la 13.
    public var notasDeTension: [NotaSobreElAcorde] { notas.filter { $0.papel == .tension } }

    /// Las tensiones que suma al acorde, como se cifran: «9», «♯11», «13».
    @available(*, deprecated, message: "Usa notasDeTension, y su cifra o su numero y su alteracion")
    public var tensiones: [String] { notasDeTension.map(\.cifra) }
}

extension Acorde {
    /// Las escalas bebop sobre la fundamental del acorde que, bajando en corcheas desde alguna nota del acorde,
    /// ponen una nota del acorde en cada parte fuerte. En un acorde sin séptima menor, la 6.ª cuenta como nota del
    /// acorde (Do bebop mayor sobre Do7M: Do La Sol Mi en las partes fuertes).
    ///
    ///     Acorde("Do7").escalasBebop.first?.notaDePaso   // Si
    public var escalasBebop: [EscalaBebop] {
        let clases = Set(notas.map(\.claseDeAltura))
        let sexta = estructura.septima == .septimaMenor ? nil : (fundamental + .sextaMayor).claseDeAltura
        func esDelAcorde(_ nota: Nota) -> Bool { clases.contains(nota.claseDeAltura) || nota.claseDeAltura == sexta }
        var resultado: [EscalaBebop] = []
        for tipo in TipoDeEscala.bebop {
            let escala = Escala(fundamental, tipo)
            let notas = escala.notas
            let bajando = [notas[0]] + notas.dropFirst().reversed()
            for inicio in bajando.indices where esDelAcorde(bajando[inicio]) {
                let recorrido = bajando.indices.map { bajando[(inicio + $0) % bajando.count] }
                guard stride(from: 0, to: recorrido.count, by: 2).allSatisfy({ esDelAcorde(recorrido[$0]) }) else {
                    continue
                }
                // La nota de paso: la que no es del acorde y está a un semitono de la anterior y de la siguiente.
                let paso = notas.indices.first { i in
                    let anterior = notas[(i + notas.count - 1) % notas.count]
                    let siguiente = notas[(i + 1) % notas.count]
                    return !esDelAcorde(notas[i]) && modulo(notas[i].claseDeAltura - anterior.claseDeAltura, 12) == 1
                        && modulo(siguiente.claseDeAltura - notas[i].claseDeAltura, 12) == 1
                }
                if let paso {
                    resultado.append(EscalaBebop(escala: escala, notaDePaso: notas[paso], recorrido: recorrido))
                }
                break
            }
        }
        return resultado
    }

    /// Las pentatónicas mayores y menores, sobre cualquier tónica, que no tienen notas a evitar sobre el acorde y
    /// tienen su tercera (si la tiene): de las que suman menos tensiones a las que más. Sobre Do7M, Do, Sol y Re
    /// pentatónica mayor, y La y Mi menor, entre otras.
    public var pentatonicas: [PentatonicaSobreElAcorde] {
        let intervalos: [Intervalo] = [
            .unisono, .segundaMenor, .segundaMayor, .terceraMenor, .terceraMayor, .cuartaJusta, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .sextaMayor, .septimaMenor, .septimaMayor,
        ]
        var resultado: [PentatonicaSobreElAcorde] = []
        for tipo in [TipoDeEscala.pentatonicaMayor, .pentatonicaMenor] {
            for intervalo in intervalos {
                let escala = Escala(fundamental + intervalo, tipo)
                let sobre = escala.notas(sobre: self)
                let conTercera = tercera.map { escala.contieneEnarmonico($0) } ?? true
                if conTercera && sobre.allSatisfy({ $0.papel != .aEvitar }) {
                    resultado.append(PentatonicaSobreElAcorde(escala: escala, notas: sobre))
                }
            }
        }
        return resultado.enumerated().sorted {
            ($0.element.notasDeTension.count, $0.offset) < ($1.element.notasDeTension.count, $1.offset)
        }.map(\.element)
    }
}

// MARK: - Digitación de piano

/// La mano que toca.
public enum Mano: String, Hashable, Sendable, CaseIterable {
    case derecha, izquierda
}

/// Una escala al piano, subiendo, con el dedo de cada nota (1 el pulgar, 5 el meñique). Al bajar se usan los
/// mismos dedos al revés.
public struct DigitacionDePiano: Hashable, Sendable {
    public let mano: Mano
    public let alturas: [Altura]
    public let dedos: [Int]
}

extension Escala {
    /// La digitación de la escala al piano para una mano, subiendo desde la tónica en `octava` a lo largo de
    /// `octavas` octavas: los dedos seguidos y el pulgar pasando por debajo (o, en la izquierda, el 3 o el 4 por
    /// encima), sin el pulgar en una tecla negra si se puede evitar, como en los métodos de piano.
    ///
    ///     Escala(.do).digitacionDePiano(.derecha).dedos   // [1, 2, 3, 1, 2, 3, 4, 5]
    ///     Escala(.fa).digitacionDePiano(.derecha).dedos   // [1, 2, 3, 4, 1, 2, 3, 4]
    public func digitacionDePiano(_ mano: Mano, octava: Int = 4, octavas: Int = 1) -> DigitacionDePiano {
        let octavas = max(1, octavas)
        var alturas: [Altura] = []
        for o in 0..<octavas {
            let base = Altura(tonica, octava: octava + o)
            alturas += tipo.intervalos.map { base + $0 }
        }
        alturas.append(Altura(tonica, octava: octava + octavas))
        let negras = alturas.map { [1, 3, 6, 8, 10].contains(modulo($0.midi, 12)) }
        return DigitacionDePiano(mano: mano, alturas: alturas, dedos: Self.dedos(negras: negras, mano: mano))
    }

    /// Los dedos de menor coste: cada paso del pulgar cuesta 1; el pulgar en una tecla negra, 5; empezar sin el
    /// pulgar en la derecha (sin el meñique en la izquierda) o acabar sin el meñique (sin el pulgar), 1.
    static func dedos(negras: [Bool], mano: Mano) -> [Int] {
        let derecha = mano == .derecha
        let infinito = Int.max / 2
        var coste = [[Int]](repeating: [Int](repeating: infinito, count: 6), count: negras.count)
        var previo = [[Int]](repeating: [Int](repeating: 0, count: 6), count: negras.count)
        func pulgar(_ i: Int, _ dedo: Int) -> Int { dedo == 1 && negras[i] ? 5 : 0 }
        for dedo in 1...5 { coste[0][dedo] = (dedo == (derecha ? 1 : 5) ? 0 : 1) + pulgar(0, dedo) }
        let ultima = negras.count - 1
        for i in 1...ultima {
            for dedo in 1...5 where !(derecha && dedo == 5 && i != ultima) {
                for antes in 1...5 where coste[i - 1][antes] < infinito {
                    let seguido = derecha ? dedo == antes + 1 : dedo == antes - 1
                    let cruce = derecha ? (antes, dedo) : (dedo, antes)
                    let pasoDelPulgar = cruce.1 == 1 && (cruce.0 == 3 || cruce.0 == 4)
                    guard seguido || pasoDelPulgar else { continue }
                    var total = coste[i - 1][antes] + (seguido ? 0 : 1) + pulgar(i, dedo)
                    if i == ultima && dedo != (derecha ? 5 : 1) { total += 1 }
                    if total < coste[i][dedo] {
                        coste[i][dedo] = total
                        previo[i][dedo] = antes
                    }
                }
            }
        }
        var dedo = (1...5).reduce(1) { coste[ultima][$1] < coste[ultima][$0] ? $1 : $0 }
        var dedos = [Int](repeating: 0, count: negras.count)
        for i in stride(from: ultima, through: 0, by: -1) {
            dedos[i] = dedo
            dedo = previo[i][dedo]
        }
        return dedos
    }
}

// MARK: - En las doce tonalidades

extension Escala {
    /// La escala en las doce tonalidades, de quinta en quinta desde la suya: Do mayor, Sol mayor, Re mayor… hasta
    /// Fa mayor. Cada una, salvo la primera, con la tónica que da menos alteraciones (Fa♯ mayor, Do♯ menor).
    ///
    ///     Escala(.do).enLasDoceTonalidades.map(\.nombre)   // ["Do mayor", "Sol mayor", …, "Fa mayor"]
    public var enLasDoceTonalidades: [Escala] {
        var escalas = [self]
        for k in 1..<12 {
            let clase = modulo(tonica.claseDeAltura + 7 * k, 12)
            let opciones = Nota.pasosDeQuintaPosibles(deClase: clase).map { Escala(Nota(pasosDeQuinta: $0), tipo) }
            // A igual coste (Sol♭ o Fa♯ mayor), la de sostenidos, que sigue el círculo de quintas.
            escalas.append(
                opciones.dropFirst().reduce(opciones[0]) { $1.costeDeEscritura <= $0.costeDeEscritura ? $1 : $0 })
        }
        return escalas
    }
}
