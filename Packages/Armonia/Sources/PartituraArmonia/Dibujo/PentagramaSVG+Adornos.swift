import Elementos
import Foundation
import Teoria

// Lo que se coloca con las columnas ya puestas: los arcos de los semitonos, las marcas de octava, los dedos y la
// tablatura.

extension PentagramaSVG {
    /// Las articulaciones de cada columna, del lado de la cabeza (encima si la plica va hacia abajo o no hay plica,
    /// debajo si va hacia arriba), en los espacios del pentagrama; y los ornamentos y el calderón, encima de todo.
    /// Con dos voces, las de la de arriba van encima y las de la de abajo, debajo.
    func dibujarLasArticulaciones(_ colocadas: [ColumnaColocada], plicasArriba: [Bool?], en lienzo: inout Lienzo) {
        let porColumna = articulaciones.sorted { $0.key < $1.key }
        for (columna, suyas) in porColumna where colocadas.indices.contains(columna) {
            let colocada = colocadas[columna]
            let k = colocada.lugares.indices.first { !colocada.lugares[$0].isEmpty } ?? 0
            let lugares = colocada.lugares.indices.contains(k) ? colocada.lugares[k] : []
            let centro = colocada.x + colocada.anchoDeLaCabeza / 2
            let plicaArriba = plicasArriba.indices.contains(columna) ? plicasArriba[columna] : nil
            func y(_ lugar: Int) -> Double { PentagramaSVG.y(deLugar: lugar, pentagrama: k) }
            func poner(_ glifo: Glifo, base: Double) {
                let x = PentagramaSVG.n(centro - glifo.ancho / 2)
                lienzo.notas.append(
                    elemento("path").con("transform", "translate(\(x) \(PentagramaSVG.n(base)))")
                        .con("d", glifo.trazado).vacio)
                lienzo.minimoY = min(lienzo.minimoY, base + glifo.arriba)
                lienzo.maximoY = max(lienzo.maximoY, base + glifo.abajo)
            }

            // Las de la cabeza, cada una en un espacio (dentro del pentagrama) y la siguiente, un espacio más allá.
            let encima = plicasHaciaArriba ?? !(plicaArriba ?? false)
            var lugar = encima ? (lugares.max() ?? 4) + 2 : (lugares.min() ?? 4) - 2
            var arriba = lugares.max().map { y($0) - 0.5 } ?? y(8)
            var abajo = lugares.min().map { y($0) + 0.5 } ?? y(0)
            let deLaCabeza = lugares.isEmpty ? [] : suyas.filter { !$0.esOrnamento && $0 != .calderon }
            for articulacion in deLaCabeza {
                if lugar % 2 == 0, (0...8).contains(lugar) { lugar += encima ? 1 : -1 }
                let glifo = PentagramaSVG.glifo(de: articulacion, encima: encima)
                let base = y(lugar) - (glifo.arriba + glifo.abajo) / 2
                poner(glifo, base: base)
                arriba = min(arriba, base + glifo.arriba)
                abajo = max(abajo, base + glifo.abajo)
                lugar += encima ? 2 : -2
            }

            // Los ornamentos y el calderón, fuera del pentagrama y de la plica.
            let fuera = suyas.filter { $0.esOrnamento || $0 == .calderon }
            guard !fuera.isEmpty else { continue }
            let largo = PentagramaSVG.largoDeLaPlica + 0.5
            if plicasHaciaArriba ?? true {
                var tope = min(arriba, y(8))
                if plicaArriba == true, let alto = lugares.max() { tope = min(tope, y(alto) - largo) }
                tope -= 0.5
                for articulacion in fuera {
                    let glifo = PentagramaSVG.glifo(de: articulacion, encima: true)
                    poner(glifo, base: tope - glifo.abajo)
                    tope += glifo.arriba - glifo.abajo - 0.3
                }
            } else {
                var piso = max(abajo, y(0))
                if plicaArriba == false, let bajo = lugares.min() { piso = max(piso, y(bajo) + largo) }
                piso += 0.5
                for articulacion in fuera {
                    let glifo = PentagramaSVG.glifo(de: articulacion, encima: false)
                    poner(glifo, base: piso - glifo.arriba)
                    piso += glifo.abajo - glifo.arriba + 0.3
                }
            }
        }
    }

    /// El glifo de una articulación, encima o debajo de la nota.
    static func glifo(de articulacion: Articulacion, encima: Bool) -> Glifo {
        switch articulacion {
        case .staccato: return GlifosSMuFL.staccatoArriba
        case .staccatissimo: return encima ? GlifosSMuFL.staccatissimoArriba : GlifosSMuFL.staccatissimoAbajo
        case .tenuto: return GlifosSMuFL.tenuto
        case .acento: return GlifosSMuFL.acento
        case .marcato: return encima ? GlifosSMuFL.marcatoArriba : GlifosSMuFL.marcatoAbajo
        case .calderon: return encima ? GlifosSMuFL.calderonArriba : GlifosSMuFL.calderonAbajo
        case .trino: return GlifosSMuFL.trino
        case .mordenteSuperior: return GlifosSMuFL.mordenteSuperior
        case .mordenteInferior: return GlifosSMuFL.mordenteInferior
        case .grupeto: return GlifosSMuFL.grupeto
        case .grupetoInvertido: return GlifosSMuFL.grupetoInvertido
        }
    }

    /// Los semitonos: un arco fino encima de cada par de notas seguidas a un semitono.
    func dibujarLosSemitonos(_ notasSueltas: [(x: Double, y: Double, midi: Int)?], en lienzo: inout Lienzo) {
        let n = PentagramaSVG.n
        for i in notasSueltas.indices.dropLast() {
            guard let a = notasSueltas[i], let b = notasSueltas[i + 1], abs(a.midi - b.midi) == 1,
                microtono(i, 0)?.signo == nil, microtono(i + 1, 0)?.signo == nil
            else { continue }
            let alto = min(a.y, b.y) - 1.0
            let curva = alto - 0.9
            let trazado =
                "M\(n(a.x + 0.2)) \(n(a.y - 0.8))"
                + "Q\(n((a.x + b.x) / 2)) \(n(curva)) \(n(b.x - 0.2)) \(n(b.y - 0.8))"
            lienzo.notas.append(
                elemento("path").con("d", trazado).con("fill", "none").con("stroke", opciones.colores.dibujo)
                    .con("stroke-width", "0.12").vacio)
            lienzo.minimoY = min(lienzo.minimoY, (alto + curva) / 2 - 0.1)
        }
    }

    /// La marca 8va (encima) u 8vb (debajo), con su línea de puntos hasta la última nota.
    func dibujarLasMarcasDeOctava(
        _ sistema: Sistema, _ maquetacion: Maquetacion, en lienzo: inout Lienzo
    ) -> [String] {
        var marcas: [String] = []
        for k in sistema.claves.indices where sistema.octavas[k] != 0 {
            guard let inicio = maquetacion.primeraX[k] else { continue }
            let arriba = sistema.octavas[k] > 0
            let y =
                arriba
                ? min(maquetacion.arribaDeLasNotas[k] - 1.5, PentagramaSVG.y(deLugar: 8, pentagrama: k) - 0.8)
                : max(maquetacion.abajoDeLasNotas[k] + 2.6, PentagramaSVG.y(deLugar: 0, pentagrama: k) + 2.0)
            let rotulo = arriba ? "8va" : "8vb"
            let finDelRotulo =
                inicio - 0.3
                + PentagramaSVG.anchoEstimado(
                    rotulo, cuerpoDeLetra: 1.4, proporcion: opciones.maquetacion.anchoDeLosCaracteres)
            let yDeLaLinea = y - 0.45
            let gancho = arriba ? yDeLaLinea + 1.0 : yDeLaLinea - 1.0
            marcas.append(
                elemento("text").con("x", inicio - 0.3).con("y", y).con("font-size", "1.4").con("font-style", "italic")
                    .con("font-family", "sans-serif").con("fill", opciones.colores.dibujo).con("stroke", "none")
                    .conTexto(rotulo)
            )
            // Con una sola columna (un acorde) no hay línea de puntos: solo el rótulo.
            if maquetacion.ultimaX[k] - (finDelRotulo + 0.3) > 1.0 {
                let n = PentagramaSVG.n
                marcas.append(
                    elemento("path").con(
                        "d", "M\(n(finDelRotulo + 0.3)) \(n(yDeLaLinea)) H\(n(maquetacion.ultimaX[k])) V\(n(gancho))"
                    )
                    .con("stroke-dasharray", "0.5 0.35").vacio)
            }
            if arriba {
                lienzo.minimoY = min(lienzo.minimoY, y - 1.2)
            } else {
                lienzo.maximoY = max(lienzo.maximoY, y + 0.3)
            }
        }
        return marcas
    }

    /// Los dedos, en una fila encima de todo lo demás (debajo del cifrado): en un acorde, el de la nota más aguda
    /// arriba.
    func dibujarLosDedos(_ centros: [Double], en lienzo: inout Lienzo) -> [String] {
        guard !dedos.isEmpty else { return [] }
        var dedosSVG: [String] = []
        let base = lienzo.minimoY - 0.4
        var arribaDeLosDedos = base
        for (columna, deLaColumna) in dedos.sorted(by: { $0.key < $1.key }) where centros.indices.contains(columna) {
            let pares = zip(columnas[columna], deLaColumna).sorted { $0.0.midi < $1.0.midi }
            for (i, par) in pares.filter({ $0.1 > 0 }).enumerated() {
                let y = base - 1.1 * Double(i)
                arribaDeLosDedos = min(arribaDeLosDedos, y)
                dedosSVG.append(
                    elemento("text").con("x", centros[columna]).con("y", y).con("text-anchor", "middle")
                        .con("font-size", PentagramaSVG.letraDeLosDedos).con("font-family", "sans-serif")
                        .conTexto(String(par.1)))
            }
        }
        lienzo.minimoY = min(lienzo.minimoY, arribaDeLosDedos - 1.0)
        return dedosSVG
    }

    /// La tablatura ya colocada: el traste de cada nota y las líneas de las cuerdas, con los huecos que dejan los
    /// números.
    struct TablaturaColocada {
        var textos: [String] = []
        var lineas: [(y: Double, huecos: [(Double, Double)])]
        let arriba: Double
        let abajo: Double
    }

    /// La tablatura, debajo del pentagrama: una línea por cuerda (la más aguda arriba) y el traste de cada nota en su
    /// cuerda, con la línea cortada alrededor del número.
    func colocarLaTablatura(_ centros: [Double], en lienzo: inout Lienzo) -> TablaturaColocada? {
        guard let tablatura, tablatura.numeroDeCuerdas > 0 else { return nil }
        let arriba = lienzo.maximoY + 2.0
        let separacion = PentagramaSVG.separacionDeLaTablatura
        let abajo = arriba + separacion * Double(tablatura.numeroDeCuerdas - 1)
        var colocada = TablaturaColocada(
            lineas: (0..<tablatura.numeroDeCuerdas).map { (arriba + separacion * Double($0), []) }, arriba: arriba,
            abajo: abajo)
        let porColumna = tablatura.pulsaciones.sorted { $0.key < $1.key }
        for (columna, pulsaciones) in porColumna where centros.indices.contains(columna) {
            for pulsacion in pulsaciones where (0..<tablatura.numeroDeCuerdas).contains(pulsacion.cuerda) {
                let linea = pulsacion.linea(de: tablatura.numeroDeCuerdas)
                let texto = String(pulsacion.traste)
                let mitad =
                    PentagramaSVG.anchoEstimado(
                        texto, cuerpoDeLetra: PentagramaSVG.letraDeLaTablatura,
                        proporcion: opciones.maquetacion.anchoDeLosCaracteres) / 2
                let y = colocada.lineas[linea].y
                colocada.lineas[linea].huecos.append(
                    (centros[columna] - mitad - 0.15, centros[columna] + mitad + 0.15))
                colocada.textos.append(
                    elemento("text").con("x", centros[columna]).con("y", y + 0.42).con("text-anchor", "middle")
                        .con("font-size", PentagramaSVG.letraDeLaTablatura).con("font-family", "sans-serif")
                        .conTexto(texto))
            }
        }
        // Lo que va debajo (los nombres, los intervalos, los grados), algo más separado de la última cuerda.
        lienzo.maximoY = abajo + 0.6
        return colocada
    }

    /// «TAB» a la izquierda de la tablatura, en vertical.
    func rotuloDeLaTablatura(_ tablatura: TablaturaColocada) -> [String] {
        let (arriba, abajo) = (tablatura.arriba, tablatura.abajo)
        let letra = min(1.6, (abajo - arriba + 1.0) / 3 * 0.85)
        var rotulo: [String] = []
        for (i, letraDeTab) in ["T", "A", "B"].enumerated() {
            let y = (arriba + abajo) / 2 + letra * 0.36 + Double(i - 1) * letra * 1.05
            rotulo.append(
                elemento("text").con("x", 1.3).con("y", y).con("text-anchor", "middle").con("font-size", letra)
                    .con("font-weight", "bold").con("font-family", "sans-serif").conTexto(letraDeTab))
        }
        return rotulo
    }
}
