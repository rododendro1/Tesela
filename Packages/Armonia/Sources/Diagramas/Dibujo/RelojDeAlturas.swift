import Elementos
import Foundation
import Teoria

/// Un reloj de cents: el círculo cromático con cada nota en el ángulo de sus cents (1200 dan la vuelta), y no en una
/// de las doce horas. Sirve para las escalas con microtonos: en Re Bayātī, el Mi𝄳 cae entre Mi♭ y Mi. Las doce
/// horas temperadas quedan en gris como referencia, el borde lleva una rayita en cada paso del sistema (los 24
/// cuartos de tono, las 53 comas, los 72 moria, los 22 śruti) y cada nota que se aparta de su nota temperada lleva
/// un arquito desde ella.
///
///     let reloj = RelojDeAlturas(escala: Escala(.re, .bayati))!
///     reloj.posiciones                         // [200, 350, 500, 700, 900, 1000, 0]: Mi𝄳 a 350 cents de Do
///     reloj.divisiones.count                   // 24
///     let svg = reloj.svg(opciones: .init(titulo: "Re Bayātī"))
///
/// ``RelojDeClasesDeAltura`` es el de doce horas, para las escalas temperadas.
public struct RelojDeAlturas: Hashable, Sendable {
    /// Una nota del reloj: dónde cae, su nota temperada y cómo se rotula.
    public struct Marca: Hashable, Sendable {
        /// Los cents desde Do, de 0 a 1200 (sin el 1200).
        public let cents: Double
        /// Los cents de su nota temperada, si se aparta de ella: el arquito va de ahí a `cents`. `nil` si no se
        /// aparta, o si no tiene nota temperada.
        public let temperada: Double?
        /// El nombre que se escribe junto a la nota: «Mi𝄳».
        public let rotulo: String

        /// Una nota en esos cents (reducidos a una octava), que se aparta de `temperada` si se da y no es la misma.
        public init(cents: Double, temperada: Double? = nil, rotulo: String) {
            let reducidos = RelojDeAlturas.reducir(cents)
            self.cents = reducidos
            self.temperada = temperada.map(RelojDeAlturas.reducir).flatMap {
                abs(RelojDeAlturas.diferencia($0, reducidos)) < 1e-6 ? nil : $0
            }
            self.rotulo = rotulo
        }
    }

    /// Las notas, en el orden en que se dieron (el de la escala, desde la tónica).
    public let marcas: [Marca]
    /// Los cents de la tónica, que lleva el borde naranja, si hay.
    public let tonica: Double?
    /// Las rayitas del borde, en cents desde Do: un paso del sistema cada una. Vacío, ninguna.
    public let divisiones: [Double]
    /// Si se dibujan, en gris, las doce horas temperadas (no en el círculo de quintas de un temperamento, donde no
    /// caen en su sitio).
    public let horas: Bool

    /// Un reloj con esas notas, la tónica en esos cents y las rayitas en esos otros (todo reducido a una octava), con
    /// las doce horas temperadas o sin ellas.
    public init(marcas: [Marca], tonica: Double? = nil, divisiones: [Double] = [], horas: Bool = true) {
        self.marcas = marcas
        self.tonica = tonica.map(Self.reducir)
        self.divisiones = Array(Set(divisiones.map(Self.reducir))).sorted()
        self.horas = horas
    }

    /// El reloj de la versión microtonal de una escala (la de su teoría de hoy, o `afinacion`), con las rayitas de
    /// su sistema y cada nota nombrada en `notacion`; `nil` si la escala no tiene microtonos. La tónica es el primer
    /// grado, que puede ser un microtono: Sīkāh empieza en Mi𝄳.
    ///
    ///     RelojDeAlturas(escala: Escala("Do mayor"))   // nil
    public init?(
        escala: Escala, afinacion: TipoDeEscalaMicrotonal? = nil, sentido: SentidoDelIntervalo = .ascendente,
        notacion: Notacion = .compacta(.espanol)
    ) {
        guard let notas = escala.notasMicrotonales(sentido: sentido, afinacion: afinacion), let primera = notas.first
        else { return nil }
        // Los cents de las notas se cuentan desde la tónica temperada; los del reloj, desde Do.
        let desdeDo = Double(100 * escala.tonica.claseDeAltura)
        let sistema = primera.sistema
        let marcas = notas.map { nota in
            Marca(
                cents: desdeDo + nota.cents, temperada: Double(100 * nota.temperada.claseDeAltura),
                rotulo: nota.nombre(en: notacion))
        }
        self.init(
            marcas: marcas, tonica: desdeDo + primera.cents,
            divisiones: Self.divisiones(de: sistema).map { desdeDo + $0 })
    }

    /// Las rayitas de un sistema desde su primer paso: los pasos de la octava, o ninguna en el de cents
    /// cualesquiera (`razones`), que tendría 1200.
    public static func divisiones(de sistema: SistemaMicrotonal) -> [Double] {
        guard sistema != .razones else { return [] }
        return (0..<sistema.pasosPorOctava).map(sistema.cents(de:))
    }

    /// Los cents de las notas, en el orden de `marcas`.
    public var posiciones: [Double] { marcas.map(\.cents) }

    // MARK: Temperamentos

    /// Los pasos de un temperamento del catálogo, desde Do. En los de doce notas, cada tecla con su nombre (Do, Do♯,
    /// Re, Mi♭…) y un arquito desde su hora del temperamento igual: las de Werckmeister III, apartándose unos cents.
    /// En los demás (19, 31, 53 pasos…), cada paso con su número, si son 31 o menos.
    ///
    ///     RelojDeAlturas(temperamento: .divisiones31).marcas.count   // 31
    public init(temperamento: TemperamentoConNombre, notacion: Notacion = .compacta(.espanol)) {
        let pasos = temperamento.pasos
        let marcas: [Marca]
        if pasos.count == 12 {
            marcas = pasos.enumerated().map { i, cents in
                Marca(cents: cents, temperada: Double(100 * i), rotulo: Self.teclas[i].nombre(en: notacion))
            }
        } else {
            marcas = pasos.enumerated().map { i, cents in
                Marca(cents: cents, rotulo: pasos.count <= 31 ? String(i) : "")
            }
        }
        self.init(marcas: marcas, tonica: 0)
    }

    /// El círculo de quintas de un temperamento del catálogo, de quinta en quinta desde Do, si lo tiene: los de doce
    /// notas con todas las quintas iguales (el igual, el pitagórico, los mesotónicos), con el nombre de cada tecla, y
    /// las octavas partidas en partes iguales cuya quinta las recorre todas (19, 22, 31, 41 y las 53 comas), con el
    /// número de cada paso si son 31 o menos. `nil` en los demás: los circulares y la justa, de quintas desiguales, y
    /// los 22 śruti, que no son iguales; en los 24 cuartos de tono o los 72 moria, la quinta (14 o 42 pasos) solo pasa
    /// por las doce teclas.
    ///
    ///     RelojDeAlturas(quintasDe: .divisiones19)?.marcas[1].rotulo   // "11": la quinta, de 11 pasos
    ///     RelojDeAlturas(quintasDe: .cuartosDeTono)                   // nil
    public init?(quintasDe temperamento: TemperamentoConNombre, notacion: Notacion = .compacta(.espanol)) {
        guard let pasosDeLaQuinta = Self.pasosDeLaQuinta(de: temperamento) else { return nil }
        let n = temperamento.pasosPorOctava
        let marcas = (0..<n).map { k in
            let paso = (k * pasosDeLaQuinta) % n
            let rotulo = n == 12 ? Self.teclas[paso].nombre(en: notacion) : n <= 31 ? String(paso) : ""
            return Marca(cents: Double(k) * 1200 / Double(n), rotulo: rotulo)
        }
        self.init(marcas: marcas, tonica: 0, horas: false)
    }

    /// Cuántos pasos de su octava tiene la quinta de un temperamento, si va de quinta en quinta por todos ellos: 7 en
    /// los regulares de doce notas, 11 en el de 19, 31 en las 53 comas; `nil` si no tiene una sola quinta o si su círculo
    /// de quintas se cierra antes (14 de 24, 42 de 72).
    public static func pasosDeLaQuinta(de temperamento: TemperamentoConNombre) -> Int? {
        // Los sistemas de pasos iguales (cuartos de tono, 53 comas, 72 moria) tienen la quinta más cercana a la pura.
        let iguales: Set<SistemaMicrotonal> = [.cuartosDeTono, .persa, .comas53, .moria72]
        let deUnSistema = temperamento.sistemaMicrotonal.map(iguales.contains) == true ? 1200 * log2(1.5) : nil
        guard let quinta = temperamento.quinta ?? deUnSistema else { return nil }
        let n = temperamento.pasosPorOctava
        if n == 12 { return 7 }
        let pasos = Int((quinta * Double(n) / 1200).rounded())
        func mcd(_ a: Int, _ b: Int) -> Int { b == 0 ? a : mcd(b, a % b) }
        return mcd(pasos, n) == 1 ? pasos : nil
    }

    /// Las doce teclas desde Do, como se escriben en los temperamentos: de Mi♭ a Sol♯ por quintas.
    static let teclas: [Nota] = [
        Nota(.do), Nota(.do, .sostenido), Nota(.re), Nota(.mi, .bemol), Nota(.mi), Nota(.fa), Nota(.fa, .sostenido),
        Nota(.sol), Nota(.sol, .sostenido), Nota(.la), Nota(.si, .bemol), Nota(.si),
    ]

    // MARK: Color

    /// El color de unos cents, que da la vuelta al círculo de los colores en una octava: Do rojo, Mi verdoso, Sol♯
    /// azul… Un microtono cae entre los colores de sus dos vecinos.
    ///
    ///     RelojDeAlturas.color(deCents: 400).hexadecimal   // "#36D936": el de 120°, verde
    public static func color(deCents cents: Double) -> ColorRGB {
        ColorRGB(tono: reducir(cents) / 1200 * 360, saturacion: 0.75, brillo: 0.85)
    }

    // MARK: Cuentas

    /// Unos cents en una octava, de 0 a 1200 (sin el 1200).
    static func reducir(_ cents: Double) -> Double {
        let resto = cents.truncatingRemainder(dividingBy: 1200)
        let reducido = resto < 0 ? resto + 1200 : resto
        return reducido >= 1200 - 1e-9 ? 0 : reducido
    }

    /// Lo que hay que andar de `a` a `b` por el lado más corto, en cents, de −600 a 600.
    static func diferencia(_ a: Double, _ b: Double) -> Double {
        var d = reducir(b - a)
        if d > 600 { d -= 1200 }
        return d
    }

    // MARK: Dibujo

    static let lado = 280.0
    static let radio = 100.0
    static let altoDelTitulo = 24.0

    /// El ángulo de unos cents, en radianes, con Do arriba y en el sentido de las agujas.
    static func angulo(cents: Double) -> Double { (cents / 1200 * 2 - 0.5) * Double.pi }

    /// El punto de unos cents a esa distancia del centro.
    static func punto(cents: Double, radio: Double, centro: (x: Double, y: Double)) -> (x: Double, y: Double) {
        let angulo = angulo(cents: cents)
        return (centro.x + radio * cos(angulo), centro.y + radio * sin(angulo))
    }

    /// El reloj en SVG: el círculo con las rayitas del sistema, las doce horas temperadas en gris (con el nombre de
    /// su nota por dentro, en `opciones.notacion`), el polígono de las notas con su rótulo por fuera, el arquito de
    /// las que se apartan de su nota temperada y, encima, el título de `opciones`, si lo hay; `opciones.escala`
    /// cambia el tamaño.
    /// Con `colores`, cada nota lleva el color de sus cents (``color(deCents:)``) en lugar del azul.
    public func svg(opciones: OpcionesDeDiagrama = OpcionesDeDiagrama(), colores: Bool = false) -> String {
        let titulo = opciones.titulo ?? ""
        let arriba = titulo.isEmpty ? 0 : Self.altoDelTitulo
        // Más ancho si el título no cabe («53 comas de Arel-Ezgi-Uzdilek · Círculo de quintas»), a unos 8 px por letra.
        let ancho = max(Self.lado, Double(titulo.count) * 8 + 16)
        let alto = Self.lado + arriba
        let centro = (x: ancho / 2, y: arriba + Self.lado / 2)
        let radio = Self.radio
        func linea(_ texto: String) -> String { "  " + texto + "\n" }
        var svg =
            ElementoSVG("svg").con("xmlns", "http://www.w3.org/2000/svg")
            .con("viewBox", "0 0 \(NumerosSVG.unDecimal.texto(ancho)) \(NumerosSVG.unDecimal.texto(alto))")
            .con("width", ancho * opciones.escala).con("height", alto * opciones.escala)
            .con("font-family", "sans-serif").apertura + "\n"
        if !titulo.isEmpty { svg += linea(ElementoSVG("title").conTexto(titulo)) }
        svg += linea(ElementoSVG("rect").con("width", ancho).con("height", alto).con("fill", "#ffffff").vacio)
        if !titulo.isEmpty {
            svg += linea(
                ElementoSVG("text").con("x", 8.0).con("y", arriba / 2).con("dominant-baseline", "central")
                    .con("font-size", 14.0).con("font-weight", "600").con("fill", "#222222").conTexto(titulo))
        }
        svg += linea(
            ElementoSVG("circle").con("cx", centro.x).con("cy", centro.y).con("r", radio).con("fill", "none")
                .con("stroke", "#cccccc").vacio)
        // Las rayitas del sistema, por fuera del círculo.
        for cents in divisiones {
            let desde = Self.punto(cents: cents, radio: radio, centro: centro)
            let hasta = Self.punto(cents: cents, radio: radio + 5, centro: centro)
            svg += linea(
                ElementoSVG("line").con("x1", desde.x).con("y1", desde.y).con("x2", hasta.x).con("y2", hasta.y)
                    .con("stroke", "#bbbbbb").con("stroke-width", 1.0).vacio)
        }
        // Las doce horas temperadas, en gris, con su nombre por dentro.
        for clase in 0..<(horas ? 12 : 0) {
            let cents = Double(100 * clase)
            let punto = Self.punto(cents: cents, radio: radio, centro: centro)
            svg += linea(
                ElementoSVG("circle").con("cx", punto.x).con("cy", punto.y).con("r", 3.0).con("fill", "#bbbbbb")
                    .con("stroke", "#ffffff").con("stroke-width", 1.0).vacio)
            let rotulo = Self.punto(cents: cents, radio: radio - 16, centro: centro)
            let nombre = opciones.nombresDeLasNotas ? opciones.nombre(de: 60 + clase) : String(clase)
            svg += linea(
                ElementoSVG("text").con("x", rotulo.x).con("y", rotulo.y).con("text-anchor", "middle")
                    .con("dominant-baseline", "central").con("font-size", 10.0).con("fill", "#999999")
                    .conTexto(nombre))
        }
        // El polígono, de nota en nota alrededor del círculo, debajo de los puntos.
        let vertices = marcas.map(\.cents).sorted().map { Self.punto(cents: $0, radio: radio, centro: centro) }
        if vertices.count >= 2 {
            svg += linea(
                ElementoSVG("polygon").con("points", puntos: vertices).con("fill", DibujoSVG.Color.nota)
                    .con("fill-opacity", "0.18").con("stroke", DibujoSVG.Color.nota).con("stroke-width", 2.0).vacio)
        }
        // El arquito de cada nota que se aparta de su nota temperada, un poco por fuera del círculo.
        for marca in marcas {
            guard let temperada = marca.temperada else { continue }
            let desvio = Self.diferencia(temperada, marca.cents)
            let desde = Self.punto(cents: temperada, radio: radio + 9, centro: centro)
            let hasta = Self.punto(cents: marca.cents, radio: radio + 9, centro: centro)
            let numero = NumerosSVG.unDecimal
            let d =
                "M \(numero.texto(desde.x)) \(numero.texto(desde.y)) A \(numero.texto(radio + 9)) "
                + "\(numero.texto(radio + 9)) 0 0 \(desvio > 0 ? 1 : 0) \(numero.texto(hasta.x)) \(numero.texto(hasta.y))"
            svg += linea(
                ElementoSVG("path").con("d", d).con("fill", "none").con("stroke", DibujoSVG.Color.flecha)
                    .con("stroke-width", 2.0).con("stroke-linecap", "round").vacio)
        }
        // Las notas, con su rótulo por fuera; más pequeñas si son muchas, para que no se monten.
        let tamano = min(7, max(3, 0.35 * 2 * Double.pi * radio / Double(max(marcas.count, 1))))
        for marca in marcas {
            let punto = Self.punto(cents: marca.cents, radio: radio, centro: centro)
            let primera = tonica.map { abs(Self.diferencia($0, marca.cents)) < 1e-6 } ?? false
            svg += linea(
                ElementoSVG("circle").con("cx", punto.x).con("cy", punto.y).con("r", tamano)
                    .con("fill", colores ? Self.color(deCents: marca.cents).hexadecimal : DibujoSVG.Color.nota)
                    .con("stroke", primera ? DibujoSVG.Color.primera : "#ffffff")
                    .con("stroke-width", primera ? 3.0 : 1.0).vacio)
            guard !marca.rotulo.isEmpty else { continue }
            let rotulo = Self.punto(cents: marca.cents, radio: radio + 26, centro: centro)
            svg += linea(
                ElementoSVG("text").con("x", rotulo.x).con("y", rotulo.y).con("text-anchor", "middle")
                    .con("dominant-baseline", "central").con("font-size", 12.0).con("font-weight", "600")
                    .con("fill", "#222222").conTexto(marca.rotulo))
        }
        return svg + "</svg>\n"
    }
}
