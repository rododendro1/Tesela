import Elementos
import Foundation
import Teoria

// MARK: - El retículo de la entonación justa

/// El retículo de Euler y Fokker de la entonación justa de 5 límites: cada nota es un punto `(quintas, terceras)`, a
/// tantas quintas justas (3/2) y terceras mayores justas (5/4) de la tónica. Una nota escrita tiene muchos puntos (Re
/// es 9/8, dos quintas, o 10/9, una tercera bajo dos quintas menos cuatro), que suenan a una coma sintónica (81/80) de
/// distancia.
///
/// Una progresión se pone en el retículo acorde a acorde: cada fundamental, en el punto de su nota más cercano a la
/// fundamental anterior, y las notas de cada acorde, en los puntos más cercanos a su fundamental (la tercera mayor
/// encima, la quinta a la derecha). Así suena una progresión cantada en justa, y por eso deriva: en Do–Lam–Rem–Sol–Do,
/// el último Do está una coma más bajo que el primero.
///
///     let reticulo = ReticuloJusto([Acorde("Do"), Acorde("Lam"), Acorde("Rem"), Acorde("Sol"), Acorde("Do")])
///     reticulo.acordes.map(\.fundamental)   // (0, 0), (−1, 1), (−2, 1), (−3, 1), (−4, 1)
///     reticulo.deriva                       // −21.506: la coma sintónica
public struct ReticuloJusto: Hashable, Sendable {
    /// Un punto del retículo: tantas quintas justas y tantas terceras mayores justas desde la tónica.
    public struct Punto: Hashable, Sendable, CustomStringConvertible {
        public let quintas: Int
        public let terceras: Int

        public init(quintas: Int, terceras: Int) {
            self.quintas = quintas
            self.terceras = terceras
        }

        /// La razón desde la tónica, dentro de la octava (de 1 a 2): (1, 0) es 3/2 y (−1, 1), 5/3.
        public var razon: RazonDeFrecuencias {
            var numerador = pow(3, Double(max(quintas, 0))) * pow(5, Double(max(terceras, 0)))
            var denominador = pow(3, Double(max(-quintas, 0))) * pow(5, Double(max(-terceras, 0)))
            while numerador >= 2 * denominador { denominador *= 2 }
            while numerador < denominador { numerador *= 2 }
            return RazonDeFrecuencias(numerador, denominador)
        }

        /// Los cents desde la tónica, dentro de la octava.
        public var cents: Double { razon.cents }

        /// Los semitonos de la nota en temperamento igual, de 0 a 11.
        var semitonos: Int { modulo(7 * quintas + 4 * terceras, 12) }

        /// Cuánto se aparta de su nota en temperamento igual, en cents, de −600 a 600: (−1, 1), el La de 5/3, está
        /// 15,64 cents bajo el La temperado.
        public var desvio: Double {
            var desvio = cents - Double(100 * semitonos)
            if desvio > 600 { desvio -= 1200 }
            if desvio < -600 { desvio += 1200 }
            return desvio
        }

        /// Lo que se ve en el retículo: una quinta vale lo que una tercera.
        func distancia(a otro: Punto) -> Double {
            let (q, t) = (Double(quintas - otro.quintas), Double(terceras - otro.terceras))
            return (q * q + t * t).squareRoot()
        }

        public var description: String { "(\(quintas), \(terceras))" }
    }

    /// Un acorde de la progresión en el retículo.
    public struct AcordeEnElReticulo: Hashable, Sendable {
        public let acorde: Acorde
        /// El punto de su fundamental.
        public let fundamental: Punto
        /// Los puntos de sus notas, en el orden de `acorde.notas`.
        public let notas: [Punto]
    }

    /// La nota del punto (0, 0): la fundamental del primer acorde, si no se da otra.
    public let tonica: Nota
    public let acordes: [AcordeEnElReticulo]

    /// Una progresión en el retículo. La primera fundamental va en el punto de su nota más cercano a la tónica.
    public init(_ acordes: [Acorde], tonica: Nota? = nil) {
        let tonica = tonica ?? acordes.first?.fundamental ?? .do
        self.tonica = tonica
        var anterior = Punto(quintas: 0, terceras: 0)
        var puestos: [AcordeEnElReticulo] = []
        for acorde in acordes {
            let fundamental = Self.punto(de: acorde.fundamental, desde: tonica, cercaDe: anterior)
            let notas = acorde.notas.map { Self.punto(de: $0, desde: tonica, cercaDe: fundamental) }
            puestos.append(AcordeEnElReticulo(acorde: acorde, fundamental: fundamental, notas: notas))
            anterior = fundamental
        }
        self.acordes = puestos
    }

    /// El punto de una nota más cercano a otro. La nota está a `f` quintas de la tónica en la línea de quintas, así
    /// que sus puntos son (f − 4k, k): cada tercera mayor ocupa el lugar de cuatro quintas y escribe la misma nota.
    static func punto(de nota: Nota, desde tonica: Nota, cercaDe otro: Punto) -> Punto {
        let quintas = nota.pasosDeQuinta - tonica.pasosDeQuinta
        // El mejor k está cerca del que deja la nota a la altura del otro punto.
        let centro = Int((Double(quintas - otro.quintas + 4 * otro.terceras) / 4).rounded())
        let candidatos = ((centro - 3)...(centro + 3)).map { Punto(quintas: quintas - 4 * $0, terceras: $0) }
        // El más cercano; a igual distancia, el de menos terceras.
        return candidatos.min {
            ($0.distancia(a: otro), abs($0.terceras)) < ($1.distancia(a: otro), abs($1.terceras))
        }!
    }

    /// La nota escrita de un punto: la tónica, tantas quintas y tantas terceras mayores más arriba.
    public func nota(de punto: Punto) -> Nota {
        Nota(pasosDeQuinta: tonica.pasosDeQuinta + punto.quintas + 4 * punto.terceras)
    }

    /// Cuánto ha bajado o subido la progresión al volver a la fundamental del primer acorde, en cents (−21,506 en
    /// Do–Lam–Rem–Sol–Do: una coma sintónica); `nil` si el último acorde no tiene la misma fundamental que el primero o
    /// si hay menos de dos.
    public var deriva: Double? {
        guard acordes.count > 1, let primero = acordes.first, let ultimo = acordes.last,
            primero.acorde.fundamental == ultimo.acorde.fundamental
        else { return nil }
        // La misma nota escrita en dos puntos: lo que se apartan, cada uno de su nota temperada.
        return Redondeo.valor(ultimo.fundamental.desvio - primero.fundamental.desvio)
    }
}

// MARK: - El dibujo

extension ReticuloJusto {
    /// El retículo en SVG: las quintas en horizontal y las terceras en vertical, con las notas de cada punto, los
    /// acordes rellenos, de su color si son mayores o menores, y flechas de fundamental en fundamental. El título
    /// dice la progresión y, si vuelve a su primera fundamental, la deriva.
    public func svg(opciones: OpcionesDeDiagrama = .init(), margen: Int = 1) -> String {
        let notacion = opciones.notacion
        let paso = 70 * opciones.escala
        let puntos = acordes.flatMap { [$0.fundamental] + $0.notas }
        let todos = puntos.isEmpty ? [Punto(quintas: 0, terceras: 0)] : puntos
        let quintas = (todos.map(\.quintas).min()! - margen)...(todos.map(\.quintas).max()! + margen)
        let terceras = (todos.map(\.terceras).min()! - margen)...(todos.map(\.terceras).max()! + margen)
        // Las terceras suben: la fila de más terceras va arriba.
        func x(_ punto: Punto) -> Double { Double(punto.quintas - quintas.lowerBound) * paso + paso / 2 }
        func y(_ punto: Punto) -> Double { Double(terceras.upperBound - punto.terceras) * paso + paso / 2 }
        let ancho = Double(quintas.count) * paso
        let alto = Double(terceras.count) * paso
        var cuerpo = ""
        // Las líneas de quintas y de terceras.
        for t in terceras {
            let a = Punto(quintas: quintas.lowerBound, terceras: t)
            let b = Punto(quintas: quintas.upperBound, terceras: t)
            cuerpo += "  " + Self.linea(x(a), y(a), x(b), y(b), color: "#dddddd") + "\n"
        }
        for q in quintas {
            let a = Punto(quintas: q, terceras: terceras.lowerBound)
            let b = Punto(quintas: q, terceras: terceras.upperBound)
            cuerpo += "  " + Self.linea(x(a), y(a), x(b), y(b), color: "#dddddd") + "\n"
        }
        // Los acordes, rellenos.
        for puesto in acordes {
            let unicos = Array(Set(puesto.notas))
            guard unicos.count > 2 else { continue }
            let cx = unicos.map(x).reduce(0, +) / Double(unicos.count)
            let cy = unicos.map(y).reduce(0, +) / Double(unicos.count)
            let ordenados = unicos.sorted { atan2(y($0) - cy, x($0) - cx) < atan2(y($1) - cy, x($1) - cx) }
            let estructura = puesto.acorde.estructura
            let color =
                estructura.tercera == .terceraMayor
                ? DibujoSVG.Color.mayor : estructura.tercera == .terceraMenor ? DibujoSVG.Color.menor : "#cccccc"
            cuerpo +=
                "  "
                + ElementoSVG("polygon").con("points", puntos: ordenados.map { (x($0), y($0)) }).con("fill", color)
                .con("fill-opacity", "0.45").con("stroke", "#888888").con("stroke-width", "1").vacio + "\n"
        }
        // Los puntos, con su nota y su razón.
        let sonando = Set(puntos)
        let primera = acordes.first?.fundamental
        for t in terceras.reversed() {
            for q in quintas {
                let punto = Punto(quintas: q, terceras: t)
                let marcado = sonando.contains(punto)
                let borde = punto == primera ? DibujoSVG.Color.primera : marcado ? DibujoSVG.Color.nota : "#bbbbbb"
                cuerpo +=
                    "  "
                    + ElementoSVG("circle").con("cx", x(punto)).con("cy", y(punto)).con("r", paso * 0.27)
                    .con("fill", marcado ? DibujoSVG.Color.nota : "#ffffff").con("stroke", borde)
                    .con("stroke-width", punto == primera ? "3" : "1.5").vacio + "\n"
                let color = marcado ? "#ffffff" : "#555555"
                cuerpo +=
                    "  "
                    + ElementoSVG("text").con("x", x(punto)).con("y", y(punto) - paso * 0.05)
                    .con("text-anchor", "middle").con("dominant-baseline", "central").con("font-size", paso * 0.2)
                    .con("fill", color).conTexto(nota(de: punto).nombreCompacto(en: notacion)) + "\n"
                cuerpo +=
                    "  "
                    + ElementoSVG("text").con("x", x(punto)).con("y", y(punto) + paso * 0.15)
                    .con("text-anchor", "middle").con("dominant-baseline", "central").con("font-size", paso * 0.12)
                    .con("fill", color).conTexto(punto.razon.description) + "\n"
            }
        }
        // Las flechas de fundamental en fundamental.
        if acordes.count > 1 {
            let punta = ElementoSVG("path").con("d", "M0,0 L10,5 L0,10 z").con("fill", DibujoSVG.Color.flecha).vacio
            let marcador = ElementoSVG("marker").con("id", "flecha").con("viewBox", "0 0 10 10").con("refX", "9")
                .con("refY", "5").con("markerWidth", "5").con("markerHeight", "5").con("orient", "auto")
            cuerpo += "  " + ElementoSVG("defs").conHijos(marcador.conHijos(punta)) + "\n"
            for (uno, otro) in zip(acordes, acordes.dropFirst()) where uno.fundamental != otro.fundamental {
                // Del borde de un círculo al del otro.
                let (x1, y1, x2, y2) = (x(uno.fundamental), y(uno.fundamental), x(otro.fundamental), y(otro.fundamental))
                let largo = ((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)).squareRoot()
                let recorte = paso * 0.3 / largo
                cuerpo +=
                    "  "
                    + ElementoSVG("line").con("x1", x1 + (x2 - x1) * recorte).con("y1", y1 + (y2 - y1) * recorte)
                    .con("x2", x2 - (x2 - x1) * recorte).con("y2", y2 - (y2 - y1) * recorte)
                    .con("stroke", DibujoSVG.Color.flecha).con("stroke-width", "3").con("marker-end", "url(#flecha)")
                    .vacio + "\n"
            }
        }
        var titulo = opciones.titulo ?? acordes.map { $0.acorde.cifrado(en: notacion) }.joined(separator: " – ")
        if opciones.titulo == nil, let deriva {
            titulo = TextosDeDiagramas.en(notacion) { $0.tituloConDeriva(titulo, Redondeo.texto(deriva)) }
        }
        let leyenda = [
            EntradaDeLeyenda(muestra: .linea("#dddddd", grosor: 2), texto: TextosDeDiagramas.en(notacion, \.leyendaQuintasYTerceras)),
            EntradaDeLeyenda(muestra: .flecha, texto: TextosDeDiagramas.en(notacion, \.leyendaDeFundamentalEnFundamental)),
            EntradaDeLeyenda(
                muestra: .circulo(relleno: DibujoSVG.Color.nota, borde: DibujoSVG.Color.primera),
                texto: DibujoSVG.Texto.fundamentalDelPrimerAcorde.en(notacion)),
        ]
        return DibujoSVG.componer(
            caja: (0, 0, ancho, alto), cuerpo: cuerpo, titulo: titulo, leyenda: acordes.isEmpty ? [] : leyenda,
            paso: paso)
    }

    private static func linea(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, color: String) -> String {
        ElementoSVG("line").con("x1", x1).con("y1", y1).con("x2", x2).con("y2", y2).con("stroke", color)
            .con("stroke-width", "2").vacio
    }
}
