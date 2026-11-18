import Armonia
import Foundation

// MARK: - El reloj de los rāgas
//
// Las veinticuatro horas en un círculo, la medianoche arriba y el mediodía abajo, partidas en los ocho prahar de tres
// horas (`MomentoDelDia`), y en cada uno los rāgas que se tocan en él según The Raga Guide (Bor 1999). Solo los de la
// India: los pathet javaneses tienen su parte de la noche, pero en el wayang, no en un reloj de rāgas.

/// El reloj de los rāgas en SVG: `armonia reloj ragas` lo escribe, y la hoja de una escala no lo lleva.
public enum PresentacionDelRelojDeLosRagas {
    /// Cada prahar con sus rāgas, en el orden del día desde la medianoche; vacío el que no tiene ninguno.
    ///
    ///     PresentacionDelRelojDeLosRagas.ragasPorMomento(en: .compacta(.espanol))
    ///         .first { $0.momento == .anochecer }?.ragas   // ["Yaman", "Bhūpālī"]
    public static func ragasPorMomento(en notacion: Notacion) -> [(momento: MomentoDelDia, ragas: [String])] {
        let indios = TipoDeEscala.conCaracter.filter { $0.tradicion == .india }
        return MomentoDelDia.allCases.sorted { $0.horaDeInicio < $1.horaDeInicio }.map { momento in
            (momento, indios.filter { $0.momentos.contains(momento) }.map { $0.nombre(en: notacion) })
        }
    }

    /// El reloj en SVG: los ocho prahar como sectores, con su nombre y su hora de inicio por fuera, y sus rāgas
    /// dentro.
    ///
    ///     let svg = PresentacionDelRelojDeLosRagas.svg(en: .compacta(.espanol))
    ///     svg.contains("Yaman")   // true
    public static func svg(en notacion: Notacion) -> String {
        let ancho = 560.0
        let centro = (x: ancho / 2, y: ancho / 2 + 20)
        let radio = 220.0
        let html = Hoja.html
        // El ángulo de una hora, en radianes, con la medianoche arriba y en el sentido de las agujas del reloj.
        func punto(hora: Double, radio r: Double) -> (x: Double, y: Double) {
            let angulo = hora / 24 * 2 * Double.pi
            return (centro.x + r * sin(angulo), centro.y - r * cos(angulo))
        }
        func numero(_ valor: Double) -> String { String(format: "%.1f", valor) }
        var piezas: [String] = [
            "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 \(Int(ancho)) \(Int(ancho + 40))\""
                + " font-family=\"Helvetica, Arial, sans-serif\">",
            "<rect width=\"100%\" height=\"100%\" fill=\"#ffffff\"/>",
            "<text x=\"\(numero(centro.x))\" y=\"24\" text-anchor=\"middle\" font-size=\"18\" font-weight=\"bold\""
                + " fill=\"#222222\">" + html(notacion.texto(\.relojDeLosRagas)) + "</text>",
            "<circle cx=\"\(numero(centro.x))\" cy=\"\(numero(centro.y))\" r=\"\(numero(radio))\" fill=\"#fbf7ee\""
                + " stroke=\"#555555\" stroke-width=\"1.5\"/>",
        ]
        for (momento, ragas) in ragasPorMomento(en: notacion) {
            let inicio = Double(momento.horaDeInicio)
            // El borde del sector y la hora en que empieza, por fuera.
            let borde = punto(hora: inicio, radio: radio)
            piezas.append(
                "<line x1=\"\(numero(centro.x))\" y1=\"\(numero(centro.y))\" x2=\"\(numero(borde.x))\""
                    + " y2=\"\(numero(borde.y))\" stroke=\"#bbbbbb\"/>")
            let hora = punto(hora: inicio, radio: radio + 16)
            piezas.append(
                "<text x=\"\(numero(hora.x))\" y=\"\(numero(hora.y + 4))\" text-anchor=\"middle\" font-size=\"12\""
                    + " fill=\"#555555\">\(momento.horaDeInicio):00</text>")
            // El nombre del prahar cerca del borde, y sus rāgas hacia el centro.
            let medio = inicio + 1.5
            let rotulo = punto(hora: medio, radio: radio - 22)
            piezas.append(
                "<text x=\"\(numero(rotulo.x))\" y=\"\(numero(rotulo.y + 4))\" text-anchor=\"middle\" font-size=\"11\""
                    + " font-style=\"italic\" fill=\"#8a5a00\">" + html(momento.nombre(en: notacion)) + "</text>")
            let sitio = punto(hora: medio, radio: radio * 0.55)
            let primera = sitio.y - Double(ragas.count - 1) * 8
            for (i, raga) in ragas.enumerated() {
                piezas.append(
                    "<text x=\"\(numero(sitio.x))\" y=\"\(numero(primera + Double(i) * 16 + 4))\""
                        + " text-anchor=\"middle\" font-size=\"13\" fill=\"#222222\">" + html(raga) + "</text>")
            }
        }
        piezas.append(
            "<text x=\"\(numero(centro.x))\" y=\"\(numero(ancho + 32))\" text-anchor=\"middle\" font-size=\"11\""
                + " fill=\"#555555\">Bor 1999</text>")
        piezas.append("</svg>")
        return piezas.joined(separator: "\n") + "\n"
    }
}
