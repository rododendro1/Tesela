import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

/// Pruebas exhaustivas: todo lo que el motor escribe debe volver a leerse igual.
/// Recorren el espacio completo de valores en lugar de ejemplos sueltos, así que
/// cualquier cambio en el lector o el generador de texto que rompa un caso se detecta.
@Suite struct IdaYVueltaTests {

    /// Todas las posiciones (en quintas desde la fundamental) que puede ocupar una nota
    /// de un acorde: terceras, quintas, séptimas y tensiones con sus alteraciones.
    static let posicionesDeAcorde = [-3, 4, 1, -6, 8, -2, 5, -9, -5, 2, 9, -1, 6, -4, 3]

    /// Recorre los 2¹⁵ subconjuntos posibles. Los que forman un acorde interpretable
    /// (9.344) deben generar un cifrado que se vuelva a leer como el mismo conjunto.
    @Test func todoCifradoGeneradoSeVuelveALeerIgual() {
        let posiciones = Self.posicionesDeAcorde
        var interpretables = 0
        for mascara in 0..<(1 << posiciones.count) {
            var conjunto: Set<Int> = [0]
            for (i, q) in posiciones.enumerated() where mascara & (1 << i) != 0 {
                conjunto.insert(q)
            }
            guard let tipo = TipoDeAcorde(pasosDeQuinta: conjunto) else { continue }
            interpretables += 1

            let simbolo = tipo.cifrado
            guard let leido = TipoDeAcorde(texto: simbolo) else {
                Issue.record("No se puede leer «\(simbolo)», generado desde \(conjunto.sorted())")
                continue
            }
            #expect(leido.pasosDeQuinta == conjunto, "«\(simbolo)»")

            // La disposición contiene exactamente las notas del conjunto, sin repetir.
            let intervalos = tipo.intervalos
            #expect(intervalos.count == conjunto.count, "«\(simbolo)»")
            #expect(Set(intervalos.map(\.pasosDeQuinta)) == conjunto, "«\(simbolo)»")
            #expect(intervalos.first == .unisono, "«\(simbolo)»")
            #expect(
                zip(intervalos, intervalos.dropFirst()).allSatisfy {
                    ($0.pasos, $0.semitonos) <= ($1.pasos, $1.semitonos)
                }, "«\(simbolo)»: intervalos desordenados")
        }
        #expect(interpretables == 9344)
    }

    static let estilos: [EstiloDeCifrado] = [
        .predeterminado, .espanolASCII, .inglesASCII, .inglesUnicode, .jazz, .calidadesConPalabras,
        EstiloDeCifrado(
            notacion: .inglesASCII, tensionesEnASCII: false, menor: .min, disminuido: .dim, aumentado: .aug,
            septimaMayor: .mayuscula, semidisminuido: .barrado),
    ]

    /// Lo mismo que la prueba anterior, en cada estilo de cifrado.
    @Test func todosLosEstilosSeVuelvenALeerIgual() {
        let posiciones = Self.posicionesDeAcorde
        for estilo in Self.estilos {
            var fallos = 0
            for mascara in 0..<(1 << posiciones.count) {
                var conjunto: Set<Int> = [0]
                for (i, q) in posiciones.enumerated() where mascara & (1 << i) != 0 {
                    conjunto.insert(q)
                }
                guard let tipo = TipoDeAcorde(pasosDeQuinta: conjunto) else { continue }
                let simbolo = tipo.cifrado(estilo: estilo)
                if TipoDeAcorde(texto: simbolo)?.pasosDeQuinta != conjunto {
                    fallos += 1
                    if fallos <= 5 {
                        Issue.record("«\(simbolo)» (\(estilo)) no se vuelve a leer como \(conjunto.sorted())")
                    }
                }
            }
            #expect(fallos == 0, "\(estilo)")
        }
    }

    /// Acordes completos en cada estilo, con fundamentales que ponen a prueba la lectura
    /// (F/Fa, D/Do, dobles alteraciones) y todas las inversiones.
    @Test func acordesCompletosEnTodosLosEstilos() {
        let fundamentales: [Nota] = ["Fa", "Re", "Do", "Fa#", "Sib", "Si", "Mibb", "Sol#"]
        for estilo in Self.estilos {
            for tipo in TipoDeAcorde.todos + ["7(b9,#11)", "m(add9)", "+9", "aug11", "7alt"] {
                for raiz in fundamentales {
                    for inversion in 0..<tipo.intervalos.count {
                        let acorde = Acorde(raiz, tipo, inversion: inversion)
                        let texto = acorde.cifrado(estilo: estilo)
                        #expect(Acorde(texto: texto) == acorde, "«\(texto)»")
                    }
                }
            }
        }
    }

    /// Acordes completos: fundamental + tipo + cada inversión posible + un bajo ajeno.
    @Test func cifradosCompletosConFundamentalYBajo() {
        let fundamentales: [Nota] = ["Do", "Fa#", "Sib", "Mi", "Sol#", "Dobb", "Si#"]
        let tipos: [TipoDeAcorde] =
            TipoDeAcorde.todos
            + ["7(b9,#11)", "13sus4", "m6/9", "7alt", "7(omit5)", "maj7#11", "13(b9)", "+9"]
        for tipo in tipos {
            for raiz in fundamentales {
                for inversion in 0..<tipo.intervalos.count {
                    let acorde = Acorde(raiz, tipo, inversion: inversion)
                    #expect(Acorde(texto: acorde.cifrado) == acorde, Comment(rawValue: acorde.cifrado))
                }
                let ajeno = Acorde(raiz, tipo, bajo: raiz + .segundaMenor)
                #expect(Acorde(texto: ajeno.cifrado) == ajeno, Comment(rawValue: ajeno.cifrado))
            }
        }
    }

    @Test func nombresDeNota() {
        for q in -35...35 {
            let nombre = Nota(pasosDeQuinta: q)
            #expect(Nota(texto: nombre.nombre) == nombre, Comment(rawValue: nombre.nombre))
            #expect(Nota(texto: nombre.nombreASCII) == nombre, Comment(rawValue: nombre.nombreASCII))
            #expect(
                Nota(texto: nombre.nombre(en: .inglesASCII)) == nombre,
                Comment(rawValue: nombre.nombre(en: .inglesASCII)))
            let unicode = nombre.nombre(en: .inglesUnicode)
            #expect(Nota(texto: unicode) == nombre, Comment(rawValue: unicode))
        }
    }

    @Test func notas() {
        for q in -21...21 {
            for o in -15...15 {
                let nota = Altura(pasosDeQuinta: q, pasosDeOctava: o)
                #expect(Altura(texto: nota.nombreCompleto) == nota, Comment(rawValue: nota.nombreCompleto))
                #expect(
                    Altura(texto: nota.nombre(en: .inglesASCII)) == nota,
                    Comment(rawValue: nota.nombre(en: .inglesASCII)))
                #expect(Altura(texto: nota.nombre(en: .inglesUnicode)) == nota)
                #expect(Altura(nota.nota, octava: nota.octava) == nota, Comment(rawValue: nota.nombreCompleto))
            }
        }
    }

    @Test func intervalos() {
        for q in -21...21 {
            for o in -15...15 {
                for sentido in [SentidoDelIntervalo.ascendente, .descendente] {
                    let intervalo = Intervalo(pasosDeQuinta: q, pasosDeOctava: o, sentido: sentido)
                    #expect(
                        Intervalo(texto: intervalo.abreviatura) == intervalo, Comment(rawValue: intervalo.abreviatura))
                    #expect(
                        Intervalo(texto: intervalo.abreviatura(en: .inglesASCII)) == intervalo,
                        Comment(rawValue: intervalo.abreviatura(en: .inglesASCII)))
                    #expect(intervalo.pasos >= 0)
                }
            }
        }
    }

    @Test func codableDeTodosLosTipos() throws {
        let codificador = JSONEncoder()
        let decodificador = JSONDecoder()
        let acordes = TipoDeAcorde.todos.map { Acorde("Fa#", $0, inversion: 1) }
        #expect(try (decodificador.decode([Acorde].self, from: codificador.encode(acordes))) == acordes)
        let escalas = TipoDeEscala.todos.map { Escala("Mib", $0) }
        #expect(try (decodificador.decode([Escala].self, from: codificador.encode(escalas))) == escalas)
    }
}

@Suite struct ConjuntoDeClasesExhaustivoTests {
    /// Los 4096 subconjuntos de las doce clases caen en 224 clases (223 con nombre más el
    /// vacío), y transponer o invertir nunca cambia la clase ni el vector interválico.
    @Test func todosLosSubconjuntos() {
        var nombres = Set<String>()
        for mascara in 0..<(1 << 12) {
            let conjunto = ConjuntoDeClases((0..<12).filter { mascara & (1 << $0) != 0 })
            guard !conjunto.clases.isEmpty else { continue }
            guard let nombre = conjunto.numeroDeForte else {
                Issue.record("Sin nombre de Forte: \(conjunto) → \(conjunto.formaPrima)")
                continue
            }
            nombres.insert(nombre)
            #expect(nombre.hasPrefix("\(conjunto.cardinalidad)-"), Comment(rawValue: nombre))
            let otro = conjunto.transponer(mascara % 12).invertir(mascara % 7)
            #expect(otro.formaPrima == conjunto.formaPrima)
            #expect(otro.vectorIntervalico == conjunto.vectorIntervalico)
            #expect(ConjuntoDeClases(conjunto.formaPrima).formaPrima == conjunto.formaPrima)
        }
        #expect(nombres.count == 223)
        #expect(nombres.filter { $0.contains("Z") }.count == 46)
    }
}

@Suite struct IdentificacionPorAlturaExhaustivaTests {
    /// Cada tipo predefinido, sobre las 12 fundamentales y en estado fundamental,
    /// debe identificarse primero desde MIDI (con cualquier ortografía enarmónica de la fundamental).
    @Test func todosLosTiposPredefinidosEnEstadoFundamental() {
        for tipo in TipoDeAcorde.todos {
            for raiz in 0..<12 {
                let midi = tipo.intervalos.map { 48 + raiz + $0.semitonos }
                guard let acorde = Acorde.identificar(midi: midi).first else {
                    Issue.record("Nada para \(tipo.nombre) sobre \(raiz)")
                    continue
                }
                #expect(acorde.tipo == tipo, "\(tipo.nombre) sobre \(raiz): \(acorde.cifrado)")
                #expect(acorde.fundamental.claseDeAltura == raiz, Comment(rawValue: acorde.cifrado))
                #expect(acorde.inversion == 0, Comment(rawValue: acorde.cifrado))
                #expect(acorde.fundamental.alteracion.numeroDeSignos <= 1, Comment(rawValue: acorde.cifrado))
            }
        }
    }
}

/// Ida y vuelta en las numeraciones de Hewlett: toda nota y todo intervalo admitidos se
/// convierten en un número y vuelven igual, y los números de los huecos no dan nada.
@Suite struct BaseDeHewlettExhaustivaTests {
    @Test func idaYVuelta() {
        for base in [BaseDeHewlett.base40, .base54, BaseDeHewlett(alteracionMaxima: 6)] {
            let m = base.alteracionMaxima
            var notas = 0
            for letra in NotaNatural.allCases {
                for alteracion in -m...m {
                    for octava in -1...9 {
                        let nota = Altura(Nota(letra, Alteracion(alteracion)), octava: octava)
                        guard let numero = nota.numero(en: base) else {
                            Issue.record("\(nota) en \(base)")
                            continue
                        }
                        #expect(Altura(numero: numero, en: base) == nota, "\(nota) en \(base)")
                        notas += 1
                    }
                }
            }
            // Cada octava tiene 7·(2m + 1) notas y 5 huecos.
            let validos = (0..<base.base).filter { Altura(numero: 4 * base.base + $0, en: base) != nil }.count
            #expect(validos == (7 * (2 * m + 1)))
            #expect(notas == (7 * (2 * m + 1) * 11))
            for numero in -3 * base.base...3 * base.base {
                if let intervalo = Intervalo(numero: numero, en: base) {
                    #expect(intervalo.numero(en: base) == numero, "\(intervalo) en \(base)")
                }
            }
        }
    }
}
