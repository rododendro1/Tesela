import ArmoniaNucleo
import ArmoniaTeoria
import Foundation

// Lo que se coloca con las columnas ya puestas: los arcos de los semitonos, las marcas de octava, los dedos y la
// tablatura.

extension PentagramaSVG {
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
                elemento("path").con("d", trazado).con("fill", "none").con("stroke", opciones.color)
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
                + PentagramaSVG.anchoEstimado(rotulo, cuerpoDeLetra: 1.4, proporcion: opciones.anchoDeLosCaracteres)
            let yDeLaLinea = y - 0.45
            let gancho = arriba ? yDeLaLinea + 1.0 : yDeLaLinea - 1.0
            marcas.append(
                elemento("text").con("x", inicio - 0.3).con("y", y).con("font-size", "1.4").con("font-style", "italic")
                    .con("font-family", "sans-serif").con("fill", opciones.color).con("stroke", "none").conTexto(rotulo)
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
        guard !digitos.isEmpty else { return [] }
        var dedosSVG: [String] = []
        let base = lienzo.minimoY - 0.4
        var arribaDeLosDedos = base
        for (columna, dedos) in digitos where centros.indices.contains(columna) {
            let pares = zip(columnas[columna], dedos).sorted { $0.0.midi < $1.0.midi }
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
        guard let tablatura, tablatura.cuerdas > 0 else { return nil }
        let arriba = lienzo.maximoY + 2.0
        let separacion = PentagramaSVG.separacionDeLaTablatura
        let abajo = arriba + separacion * Double(tablatura.cuerdas - 1)
        var colocada = TablaturaColocada(
            lineas: (0..<tablatura.cuerdas).map { (arriba + separacion * Double($0), []) }, arriba: arriba,
            abajo: abajo)
        for (columna, pulsaciones) in tablatura.notas where centros.indices.contains(columna) {
            for pulsacion in pulsaciones where (0..<tablatura.cuerdas).contains(pulsacion.cuerda) {
                let texto = String(pulsacion.traste)
                let mitad =
                    PentagramaSVG.anchoEstimado(
                        texto, cuerpoDeLetra: PentagramaSVG.letraDeLaTablatura,
                        proporcion: opciones.anchoDeLosCaracteres) / 2
                let y = colocada.lineas[pulsacion.cuerda].y
                colocada.lineas[pulsacion.cuerda].huecos.append(
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
