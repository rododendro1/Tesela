import ArmoniaNucleo

// La forma de una melodía: sus frases, las letras que dicen cuáles se parecen (A A′ B A) y los motivos que se
// repiten. Es una estimación con reglas sencillas, como las de agrupamiento de Lerdahl y Jackendoff:
//
// - Una frase acaba antes de un silencio o en una nota que dura más que la anterior y que la siguiente (contando
//   hasta donde empieza la siguiente nota), y dura al menos `minimo` (un compás, si no se pide otra cosa).
// - Dos frases con los mismos intervalos y el mismo ritmo llevan la misma letra, aunque estén transportadas; si
//   coinciden en la mitad o más de sus pasos (intervalo y ritmo), son una variante (A′); si no, una letra nueva.
// - Un motivo es un trozo de al menos `minimo` notas que vuelve, igual o transportado, sin pisarse con otra vez
//   suya. Se dan los más largos: un trozo de uno que ya está no cuenta, salvo que aparezca también en otro sitio.
//
// En un acorde cuenta la nota más aguda, y una nota ligada a la siguiente cuenta una vez, con las dos duraciones.

/// Una frase de una voz: un tramo de sus eventos, con los silencios que la cierran.
public struct Frase: Hashable, Sendable {
    /// Los índices de sus eventos en `Voz.eventos`.
    public let eventos: Range<Int>
    /// Dónde empieza y dónde acaba, desde el principio de la voz.
    public let inicio: Duracion
    public let fin: Duracion

    public var duracion: Duracion { fin - inicio }
}

/// Un motivo que se repite en una voz: sus intervalos y su ritmo, y dónde aparece.
public struct MotivoMelodico: Hashable, Sendable {
    /// Los semitonos de cada nota a la siguiente.
    public let intervalos: [Int]
    /// Lo que va del comienzo de cada nota al de la siguiente (sin la última nota, que puede durar lo que sea).
    public let ritmo: [Duracion]
    /// El evento en que empieza cada aparición, en orden.
    public let apariciones: [Int]
    /// Los semitonos que está transportada cada aparición respecto a la primera (0 la primera).
    public let transposiciones: [Int]
    /// Si alguna aparición sigue justo a la anterior a otra altura: una progresión (secuencia).
    public let esSecuencia: Bool

    /// Cuántas notas tiene.
    public var notas: Int { intervalos.count + 1 }
}

extension Voz {
    /// Una nota de la melodía de la voz: el evento en que empieza, cuándo, la altura MIDI más aguda y lo que suena
    /// (con sus ligadas).
    private struct NotaDeLaForma {
        let evento: Int
        let inicio: Duracion
        let midi: Int
        var duracion: Duracion
    }

    /// Las notas de la melodía, con las ligadas unidas a la que empieza.
    private var notasDeLaForma: [NotaDeLaForma] {
        var notas: [NotaDeLaForma] = []
        var posicion = Duracion.cero
        var ligadaDesde: [Altura] = []
        for (i, evento) in eventos.enumerated() {
            defer {
                posicion = posicion + evento.duracion
                ligadaDesde = evento.ligada ? evento.alturas : []
            }
            guard let aguda = evento.alturas.map(\.midi).max() else { continue }
            if !ligadaDesde.isEmpty, evento.alturas == ligadaDesde, !notas.isEmpty {
                notas[notas.count - 1].duracion = notas[notas.count - 1].duracion + evento.duracion
            } else {
                notas.append(NotaDeLaForma(evento: i, inicio: posicion, midi: aguda, duracion: evento.duracion))
            }
        }
        return notas
    }

    /// Las frases de la voz, de una duración mínima de `minimo` (un compás, si es `nil`).
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Re4:4 Mi4:2 Re4:4 Mi4:4 Do4:2")
    ///     voz.frases().map(\.eventos)   // [0..<3, 3..<6]
    public func frases(minimo: Duracion? = nil) -> [Frase] {
        let notas = notasDeLaForma
        guard !eventos.isEmpty else { return [] }
        let minimo = minimo ?? compas.duracion
        let total = duracion
        // Lo que va del comienzo de cada nota al de la siguiente (o al final de la voz).
        let pasos = notas.indices.map { k in (k + 1 < notas.count ? notas[k + 1].inicio : total) - notas[k].inicio }
        // Los cortes posibles: tras una nota seguida de un silencio o más larga que sus vecinas.
        var cortes: [Int] = [] // la nota que empieza la frase siguiente
        for k in notas.indices.dropLast() {
            let silencio = notas[k].inicio + notas[k].duracion < notas[k + 1].inicio
            let larga = k > 0 && pasos[k] > pasos[k - 1] && pasos[k] > pasos[k + 1]
            if silencio || larga { cortes.append(k + 1) }
        }
        var frases: [Frase] = []
        var desdeEvento = 0
        var desde = Duracion.cero
        for corte in cortes {
            let inicio = notas[corte].inicio
            guard inicio - desde >= minimo, total - inicio >= minimo else { continue }
            frases.append(Frase(eventos: desdeEvento..<notas[corte].evento, inicio: desde, fin: inicio))
            desdeEvento = notas[corte].evento
            desde = inicio
        }
        frases.append(Frase(eventos: desdeEvento..<eventos.count, inicio: desde, fin: total))
        return frases
    }

    /// La forma: una letra por frase (`frases(minimo:)`), la misma para las que se repiten (aunque estén
    /// transportadas) y con una prima para las variantes.
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Re4:4 Mi4:2 Do4:4 Re4:4 Mi4:2 Sol4:4 Fa4:4 Mi4:2 Do4:4 Re4:4 Do4:2")
    ///     voz.forma()   // ["A", "A", "B", "A′"]
    public func forma(minimo: Duracion? = nil) -> [String] {
        let notas = notasDeLaForma
        let total = duracion
        // Cada frase como sus pasos: el intervalo hasta la nota siguiente de la frase y lo que va hasta ella.
        let pasosDeLasFrases: [[(intervalo: Int, paso: Duracion)]] = frases(minimo: minimo).map { frase in
            let suyas = notas.filter { frase.eventos.contains($0.evento) }
            var pasos: [(intervalo: Int, paso: Duracion)] = []
            for k in suyas.indices.dropLast() {
                let intervalo = suyas[k + 1].midi - suyas[k].midi
                pasos.append((intervalo: intervalo, paso: suyas[k + 1].inicio - suyas[k].inicio))
            }
            // La última nota, con lo que dura hasta el final de la frase (con sus silencios).
            if let ultima = suyas.last { pasos.append((intervalo: 0, paso: min(frase.fin, total) - ultima.inicio)) }
            return pasos
        }
        func iguales(_ a: [(intervalo: Int, paso: Duracion)], _ b: [(intervalo: Int, paso: Duracion)]) -> Bool {
            a.count == b.count && zip(a, b).allSatisfy { $0.intervalo == $1.intervalo && $0.paso == $1.paso }
        }
        func parecidas(_ a: [(intervalo: Int, paso: Duracion)], _ b: [(intervalo: Int, paso: Duracion)]) -> Bool {
            let comunes = zip(a, b).filter { $0.intervalo == $1.intervalo && $0.paso == $1.paso }.count
            return 2 * comunes >= max(a.count, b.count)
        }
        var etiquetas: [String] = []
        // Cada etiqueta que ya se ha dado, con la frase que la estrenó.
        var modelos: [(etiqueta: String, pasos: [(intervalo: Int, paso: Duracion)])] = []
        var variantes: [String: Int] = [:]
        let letras = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        var siguienteLetra = 0
        for pasos in pasosDeLasFrases {
            if let igual = modelos.first(where: { iguales($0.pasos, pasos) }) {
                etiquetas.append(igual.etiqueta)
                continue
            }
            let etiqueta: String
            if let letra = modelos.first(where: { $0.etiqueta.count == 1 && parecidas($0.pasos, pasos) })?.etiqueta {
                variantes[letra, default: 0] += 1
                etiqueta = letra + Voz.prima(variantes[letra]!)
            } else {
                let indice = siguienteLetra
                siguienteLetra += 1
                etiqueta = indice < letras.count ? String(letras[indice]) : "Z\(indice - letras.count + 1)"
            }
            modelos.append((etiqueta, pasos))
            etiquetas.append(etiqueta)
        }
        return etiquetas
    }

    /// «′», «″», «‴» y, desde ahí, tantas «′» como haga falta.
    private static func prima(_ n: Int) -> String {
        switch n {
        case 1: return "′"
        case 2: return "″"
        case 3: return "‴"
        default: return String(repeating: "′", count: n)
        }
    }

    /// Los motivos que se repiten, de al menos `minimo` notas, del más largo al más corto y, a igual largo, por dónde
    /// aparecen primero. Los que solo repiten una nota no cuentan.
    ///
    ///     let voz = try Voz(leyendo: "Do4:8 Re4:8 Mi4:4 Re4:8 Mi4:8 Fa#4:4 Mi4:8 Fa#4:8 Sol#4:2")
    ///     let secuencia = voz.motivos(minimo: 3).first { $0.esSecuencia }
    ///     secuencia?.apariciones        // [0, 3, 6]
    ///     secuencia?.transposiciones    // [0, 2, 4]
    public func motivos(minimo: Int = 4) -> [MotivoMelodico] {
        let notas = notasDeLaForma
        let minimo = max(2, minimo)
        guard notas.count >= 2 * minimo else { return [] }
        let intervalos = notas.indices.dropLast().map { notas[$0 + 1].midi - notas[$0].midi }
        let pasos = notas.indices.dropLast().map { notas[$0 + 1].inicio - notas[$0].inicio }
        var aceptados: [(motivo: MotivoMelodico, comienzos: [Int], largo: Int)] = []
        // De los más largos a los más cortos; `largo` es el número de intervalos.
        for largo in stride(from: notas.count / 2, through: minimo - 1, by: -1) {
            var porClave: [[Int]: [Int]] = [:] // los intervalos y los pasos (numerador y denominador) → comienzos
            var orden: [[Int]] = []
            for inicio in 0...(intervalos.count - largo) {
                let tramo = inicio..<(inicio + largo)
                guard intervalos[tramo].contains(where: { $0 != 0 }) else { continue }
                let clave = Array(intervalos[tramo]) + pasos[tramo].flatMap { [$0.numerador, $0.denominador] }
                if porClave[clave] == nil { orden.append(clave) }
                porClave[clave, default: []].append(inicio)
            }
            for clave in orden {
                // Sin pisarse: cada aparición empieza después de la última nota de la anterior.
                var comienzos: [Int] = []
                for inicio in porClave[clave] ?? [] where comienzos.last.map({ inicio > $0 + largo }) ?? true {
                    comienzos.append(inicio)
                }
                // Las que no están ya dentro de una aparición de un motivo más largo.
                let nuevas = comienzos.filter { inicio in
                    !aceptados.contains { aceptado in
                        aceptado.comienzos.contains { $0 <= inicio && inicio + largo <= $0 + aceptado.largo }
                    }
                }
                guard comienzos.count >= 2, nuevas.count >= 2 else { continue }
                let primera = notas[comienzos[0]].midi
                let seguidas = zip(comienzos, comienzos.dropFirst()).contains { a, b in
                    b == a + largo + 1 && notas[b].midi != notas[a].midi
                }
                let motivo = MotivoMelodico(
                    intervalos: Array(intervalos[comienzos[0]..<(comienzos[0] + largo)]),
                    ritmo: Array(pasos[comienzos[0]..<(comienzos[0] + largo)]),
                    apariciones: comienzos.map { notas[$0].evento },
                    transposiciones: comienzos.map { notas[$0].midi - primera }, esSecuencia: seguidas)
                aceptados.append((motivo, comienzos, largo))
            }
        }
        return aceptados.map(\.motivo)
    }
}
