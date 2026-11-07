import Foundation
import Partituras

// Las repeticiones y los saltos de una partitura importada, desplegados en el orden en que se tocan.
//
// Cada lector apunta, compás a compás (del primer pentagrama o la primera voz), dónde empieza y lo que lleva en sus
// barras: el principio y el final de una repetición (con cuántas veces se toca), las casillas (primera vez, segunda
// vez…), el segno, la coda, el «al coda», el fine, el da capo y el dal segno. Después, las notas de cada compás se
// copian tantas veces como se toca, una detrás de otra.
//
// Se toca como es costumbre: una repetición sin principio vuelve al principio de la pieza o al final de la repetición
// anterior; en cada vuelta, solo las casillas con ese número; tras un da capo o un dal segno no se repite nada, se
// toman las últimas casillas y el fine acaba la pieza y el «al coda» salta a la coda.

/// Lo que se lee de un compás para desplegar las repeticiones.
struct CompasLeido: Hashable {
    var inicio: Duracion
    var abreRepeticion = false
    /// Las veces que se toca el tramo que se cierra aquí (2 en una repetición normal); `nil` si no se cierra ninguno.
    var cierraRepeticion: Int?
    /// Los números de las casillas a las que pertenece: [1] en la de primera vez; vacío si no está en ninguna.
    var casillas: Set<Int> = []
    var segno = false
    var coda = false
    /// «Al coda»: tras el da capo o el dal segno, de aquí se salta a la coda.
    var alCoda = false
    var fine = false
    var daCapo = false
    var dalSegno = false

    init(inicio: Duracion) {
        self.inicio = inicio
    }

    /// Si lleva algo que cambia el orden.
    var tieneMarcas: Bool {
        abreRepeticion || cierraRepeticion != nil || !casillas.isEmpty || segno || coda || alCoda || fine || daCapo
            || dalSegno
    }
}

extension CompasLeido {
    /// Lo que dice una indicación escrita: «D.C. al Fine», «D.S. al Coda», «Fine», «To Coda».
    mutating func leer(indicacion texto: String) {
        let normalizado = texto.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines.union(.punctuationCharacters))
        let sinPuntos = normalizado.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: " ", with: "")
        if sinPuntos.hasPrefix("dc") || sinPuntos.hasPrefix("dacapo") {
            daCapo = true
        } else if sinPuntos.hasPrefix("ds") || sinPuntos.hasPrefix("dalsegno") {
            dalSegno = true
        } else if sinPuntos == "fine" {
            fine = true
        } else if ["tocoda", "alcoda", "alacoda"].contains(sinPuntos) {
            alCoda = true
        }
    }

    /// El orden en que se tocan los compases, por su índice. Si no hay ninguna marca, cada uno una vez.
    static func orden(de compases: [CompasLeido]) -> [Int] {
        let n = compases.count
        guard compases.contains(where: \.tieneMarcas) else { return Array(0..<n) }
        // Tras un salto, de cada grupo de casillas seguidas solo se toca el compás con el número más alto del grupo.
        var ultimaDelGrupo = [Int](repeating: 0, count: n)
        var i = 0
        while i < n {
            guard !compases[i].casillas.isEmpty else {
                i += 1
                continue
            }
            var fin = i
            while fin < n, !compases[fin].casillas.isEmpty { fin += 1 }
            let mayor = compases[i..<fin].compactMap { $0.casillas.max() }.max() ?? 0
            for k in i..<fin { ultimaDelGrupo[k] = mayor }
            i = fin
        }

        var orden: [Int] = []
        var veces: [Int: Int] = [:] // las veces que ya se ha tocado el tramo que se cierra en cada compás
        var inicioDelTramo = 0
        var vuelta = 1
        var volviendo = false
        var trasSalto = false
        i = 0
        // Como mucho, diez veces cada compás de media: unas marcas mal puestas no dan un bucle sin fin.
        while i < n, orden.count < 10 * n + 1_000 {
            let compas = compases[i]
            if compas.abreRepeticion && !volviendo && !trasSalto {
                inicioDelTramo = i
                vuelta = 1
            }
            // Al acabar las casillas empieza otro tramo.
            if compas.casillas.isEmpty, i > 0, !compases[i - 1].casillas.isEmpty, !volviendo, !compas.abreRepeticion {
                inicioDelTramo = i
                vuelta = 1
            }
            volviendo = false
            if !compas.casillas.isEmpty {
                let suena = trasSalto ? compas.casillas.contains(ultimaDelGrupo[i]) : compas.casillas.contains(vuelta)
                if !suena {
                    i += 1
                    continue
                }
            }
            orden.append(i)
            if trasSalto && compas.fine { break }
            if let total = compas.cierraRepeticion, !trasSalto {
                let hechas = veces[i, default: 1]
                if hechas < total {
                    veces[i] = hechas + 1
                    vuelta = hechas + 1
                    i = inicioDelTramo
                    volviendo = true
                    continue
                }
                inicioDelTramo = i + 1
            }
            if trasSalto && compas.alCoda, let coda = compases.indices.first(where: { $0 > i && compases[$0].coda }) {
                i = coda
                continue
            }
            if !trasSalto && (compas.daCapo || compas.dalSegno) {
                trasSalto = true
                i = compas.daCapo ? 0 : (compases.indices.first { compases[$0].segno } ?? 0)
                continue
            }
            i += 1
        }
        return orden
    }

    /// Las notas en el orden en que se tocan: las de cada compás (las que empiezan en él), desplazadas a donde suena.
    /// `fin` es donde acaba el último compás.
    static func desplegar(_ notas: [NotaDeLaPieza], compases: [CompasLeido], fin: Duracion) -> [NotaDeLaPieza] {
        guard compases.contains(where: \.tieneMarcas) else { return notas }
        let inicios = compases.map(\.inicio)
        let finales = Array(inicios.dropFirst()) + [max(fin, inicios.last ?? .cero)]
        // Las notas de cada compás.
        var porCompas = [[NotaDeLaPieza]](repeating: [], count: compases.count)
        for nota in notas {
            // El último compás que empieza antes de la nota (o en el mismo momento).
            var bajo = 0
            var alto = inicios.count
            while bajo < alto {
                let medio = (bajo + alto) / 2
                if inicios[medio] <= nota.inicio { bajo = medio + 1 } else { alto = medio }
            }
            porCompas[max(0, bajo - 1)].append(nota)
        }
        var resultado: [NotaDeLaPieza] = []
        var ahora = inicios.first ?? .cero
        for i in orden(de: compases) {
            let desplazamiento = ahora - inicios[i]
            // Como mucho, cuatro millones de notas, aunque un compás enorme se repita cien veces.
            guard resultado.count + porCompas[i].count <= 4_000_000 else { break }
            for nota in porCompas[i] {
                resultado.append(nota.con(inicio: nota.inicio + desplazamiento))
            }
            ahora = ahora + (finales[i] - inicios[i])
        }
        return resultado
    }
}

extension NotaDeLaPieza {
    /// La misma nota en otro momento.
    func con(inicio: Duracion) -> NotaDeLaPieza {
        NotaDeLaPieza(
            altura: altura, inicio: inicio, duracion: duracion, parte: parte, desvio: desvio, sistema: sistema,
            ajuste: ajuste, dinamica: dinamica, articulaciones: articulaciones, pentagrama: pentagrama, voz: voz)
    }
}
