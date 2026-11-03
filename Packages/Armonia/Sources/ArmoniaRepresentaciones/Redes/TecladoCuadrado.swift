import ArmoniaNucleo
import Foundation
import Hexagonos

// Los teclados isomórficos de cuadrícula: botones cuadrados en filas y columnas, como los de los controladores de
// pads (LinnStrument, Launchpad, Push). Igual que en los hexagonales, cada dirección sube siempre el mismo intervalo,
// así que un acorde o una escala tiene la misma forma en todas las tonalidades.
//
// Cada teclado se define por sus dos ejes: H, los semitonos que sube un paso hacia la derecha, y V, los que sube un
// paso hacia arriba. Las diagonales suben H + V (arriba a la derecha) y V − H (arriba a la izquierda). Cuartas
// (LinnStrument, Launchpad y Push por defecto): H 1, V 5; terceras mayores (Push): H 1, V 4; quintas (LinnStrument,
// como el violín): H 1, V 7; Wicki-Hayden en cuadrícula: H 2, V 5, con la quinta en la diagonal; tonos enteros, como
// Jankó: H 2, V 1; el Tonnetz de Euler: H 7, V 4, con las quintas en horizontal y las terceras mayores en vertical.
//
// Los hexagonales están en `TecladoIsomorfico`, sobre la rejilla del paquete `Hexagonos`; estos no la necesitan: una
// casilla es una columna y una fila, y se dibuja como un cuadrado.

/// Una casilla de un teclado de cuadrícula: la columna crece hacia la derecha y la fila, hacia arriba. La `(0, 0)` es
/// la del origen del teclado.
public struct CasillaCuadrada: Hashable, Sendable, CustomStringConvertible {
    public let columna: Int
    public let fila: Int

    public init(columna: Int, fila: Int) {
        self.columna = columna
        self.fila = fila
    }

    public static let origen = CasillaCuadrada(columna: 0, fila: 0)

    /// Las casillas de un rectángulo, fila a fila de abajo arriba y, en cada fila, de izquierda a derecha.
    ///
    ///     CasillaCuadrada.rectangulo(columnas: 0...1, filas: 0...1).count   // 4
    public static func rectangulo(columnas: ClosedRange<Int>, filas: ClosedRange<Int>) -> [CasillaCuadrada] {
        filas.flatMap { fila in columnas.map { CasillaCuadrada(columna: $0, fila: fila) } }
    }

    public var description: String { "(\(columna), \(fila))" }
}

/// Un teclado isomórfico de cuadrícula, definido por sus ejes H y V: la casilla `(columna, fila)` suena
/// `midiDelOrigen + semitonosEnH · columna + semitonosEnV · fila`.
///
///     let teclado = TecladoCuadrado.cuartas
///     teclado.midi(en: .origen)                                       // 60
///     teclado.midi(en: CasillaCuadrada(columna: 2, fila: 1))          // 67
///     teclado.semitonosEnDiagonal                                     // 6
///
/// `svg(_:)` lo dibuja con el nombre de cada nota y las teclas negras del piano en gris, como `TecladoIsomorfico`.
public struct TecladoCuadrado: Hashable, Sendable {
    public let nombre: String
    /// H: los semitonos que sube un paso hacia la derecha (negativos si baja).
    public let semitonosEnH: Int
    /// V: los semitonos que sube un paso hacia arriba (negativos si baja).
    public let semitonosEnV: Int
    /// El número MIDI de la casilla `(0, 0)`.
    public let midiDelOrigen: Int

    public init(nombre: String, semitonosEnH: Int, semitonosEnV: Int, midiDelOrigen: Int = 60) {
        self.nombre = nombre
        self.semitonosEnH = semitonosEnH
        self.semitonosEnV = semitonosEnV
        self.midiDelOrigen = midiDelOrigen
    }

    /// En cuartas (H 1, V 5): cada fila es la escala cromática y la de encima empieza una cuarta justa más arriba, como
    /// las cuerdas de un bajo. Es la disposición por defecto del LinnStrument y la «4ths» del Launchpad y del Push.
    public static let cuartas = TecladoCuadrado(nombre: "Cuadrícula en cuartas", semitonosEnH: 1, semitonosEnV: 5)

    /// En terceras mayores (H 1, V 4): las filas suben de tercera mayor en tercera mayor; la «3rds» del Push. Cada tres
    /// filas, la octava.
    public static let tercerasMayores = TecladoCuadrado(
        nombre: "Cuadrícula en terceras mayores", semitonosEnH: 1, semitonosEnV: 4)

    /// En quintas (H 1, V 7): las filas suben de quinta en quinta, como las cuerdas del violín, la viola o el
    /// violonchelo. Una de las del LinnStrument.
    public static let quintas = TecladoCuadrado(nombre: "Cuadrícula en quintas", semitonosEnH: 1, semitonosEnV: 7)

    /// Wicki-Hayden en cuadrícula (H 2, V 5): un tono hacia la derecha y una cuarta justa hacia arriba, así que la
    /// quinta justa queda en la diagonal de arriba a la derecha. Es el Wicki-Hayden hexagonal con las filas sin
    /// desplazar, como se toca en los controladores de pads.
    public static let wickiHaydenCuadrado = TecladoCuadrado(
        nombre: "Wicki-Hayden (cuadrícula)", semitonosEnH: 2, semitonosEnV: 5)

    /// De tonos enteros (H 2, V 1): cada fila es una escala de tonos enteros y la de encima, la otra, un semitono más
    /// arriba, como en el teclado de Jankó.
    public static let tonosEnteros = TecladoCuadrado(
        nombre: "Cuadrícula de tonos enteros", semitonosEnH: 2, semitonosEnV: 1)

    /// El Tonnetz de Euler (H 7, V 4): quintas justas hacia la derecha y terceras mayores hacia arriba, como en su
    /// *Speculum musicum* (1773). Una tríada mayor es una «L» de tres casillas, y la tercera menor queda en la
    /// diagonal de arriba a la izquierda (V − H = −3: baja una tercera menor).
    public static let tonnetzDeEuler = TecladoCuadrado(
        nombre: "Tonnetz de Euler", semitonosEnH: 7, semitonosEnV: 4)

    /// Los teclados de cuadrícula con nombre, en el orden en que los ofrecen las apps. Un teclado nuevo va aquí y en
    /// `traduccion`.
    public static let todos: [TecladoCuadrado] = [
        .cuartas, .tercerasMayores, .quintas, .wickiHaydenCuadrado, .tonosEnteros, .tonnetzDeEuler,
    ]

    /// Los semitonos que sube la diagonal de arriba a la derecha: H + V.
    public var semitonosEnDiagonal: Int { semitonosEnH + semitonosEnV }

    /// Los semitonos que sube la diagonal de arriba a la izquierda: V − H.
    public var semitonosEnAntidiagonal: Int { semitonosEnV - semitonosEnH }

    /// ¿Aparecen las doce notas? Solo si H y V no comparten divisor con 12: con H 2 y V 4, por ejemplo, solo suenan
    /// las seis notas de una escala de tonos enteros.
    public var esCompleto: Bool { maximoComunDivisor(maximoComunDivisor(semitonosEnH, semitonosEnV), 12) == 1 }

    /// El número MIDI de una casilla.
    public func midi(en casilla: CasillaCuadrada) -> Int {
        midiDelOrigen + semitonosEnH * casilla.columna + semitonosEnV * casilla.fila
    }

    /// La altura de una casilla (en afinación igual, sin ortografía: con sostenidos o con bemoles).
    public func altura(en casilla: CasillaCuadrada, preferirBemoles: Bool = false) -> Altura {
        Altura(midi: midi(en: casilla), preferirBemoles: preferirBemoles)
    }

    /// Las casillas de `region` que suenan a ese número MIDI.
    public func casillas(de midi: Int, en region: some Sequence<CasillaCuadrada>) -> [CasillaCuadrada] {
        region.filter { self.midi(en: $0) == midi }
    }

    /// Las casillas de `region` que suenan a esa altura (las enarmónicas cuentan igual).
    public func casillas(de altura: Altura, en region: some Sequence<CasillaCuadrada>) -> [CasillaCuadrada] {
        casillas(de: altura.midi, en: region)
    }

    // MARK: Giros y espejo

    /// El teclado girado un cuarto de vuelta en sentido horario: lo que subía hacia arriba sube hacia la derecha, y lo
    /// que subía hacia la derecha, hacia abajo (H pasa a ser V, y V, −H). Cuatro giros dan la vuelta entera.
    public func girado(nombre: String? = nil) -> TecladoCuadrado {
        TecladoCuadrado(
            nombre: nombre ?? "\(self.nombre) ↻90°", semitonosEnH: semitonosEnV, semitonosEnV: -semitonosEnH,
            midiDelOrigen: midiDelOrigen)
    }

    /// El teclado girado `cuartos` cuartos de vuelta en sentido horario, en antihorario si son negativos.
    public func girado(cuartos: Int) -> TecladoCuadrado {
        let vueltas = modulo(cuartos, 4)
        guard vueltas > 0 else { return self }
        var teclado = self
        for _ in 0..<vueltas { teclado = teclado.girado(nombre: teclado.nombre) }
        return TecladoCuadrado(
            nombre: "\(nombre) ↻\(vueltas * 90)°", semitonosEnH: teclado.semitonosEnH,
            semitonosEnV: teclado.semitonosEnV, midiDelOrigen: midiDelOrigen)
    }

    /// El teclado reflejado como en un espejo vertical: lo que subía hacia la derecha sube hacia la izquierda.
    public var reflejado: TecladoCuadrado {
        TecladoCuadrado(
            nombre: "\(nombre) ⇋", semitonosEnH: -semitonosEnH, semitonosEnV: semitonosEnV,
            midiDelOrigen: midiDelOrigen)
    }

    // MARK: Dibujo

    /// El centro de una casilla en el dibujo, con casillas de `lado` píxeles: la `(0, 0)` en el origen, la columna
    /// hacia la derecha y la fila hacia arriba (y hacia abajo en SVG, así que la y baja).
    public static func centro(de casilla: CasillaCuadrada, lado: Double) -> Punto {
        Punto(x: Double(casilla.columna) * lado, y: -Double(casilla.fila) * lado)
    }

    /// La casilla en la que cae un punto del dibujo (en las coordenadas del SVG, las de su `viewBox`).
    public static func casilla(en punto: Punto, lado: Double) -> CasillaCuadrada {
        CasillaCuadrada(columna: Int((punto.x / lado).rounded()), fila: Int((-punto.y / lado).rounded()))
    }

    /// El teclado dibujado en SVG: un cuadrado por casilla con el nombre de su nota y su octava, las teclas negras del
    /// piano en gris y, si se dan, las `marcadas` en el azul de las notas del Tonnetz.
    public func svg(
        _ casillas: [CasillaCuadrada], marcadas: Set<Int> = [], lado: Double = 40, margen: Double = 4,
        notacion: Notacion = .espanolCompacto, preferirBemoles: Bool = false
    ) -> String {
        guard !casillas.isEmpty else {
            return #"<svg xmlns="http://www.w3.org/2000/svg" width="0" height="0"></svg>"#
        }
        let numero = NumerosSVG.hastaTresDecimales.texto
        let centros = casillas.map { Self.centro(de: $0, lado: lado) }
        let minX = centros.map(\.x).min()! - lado / 2 - margen
        let minY = centros.map(\.y).min()! - lado / 2 - margen
        let ancho = centros.map(\.x).max()! + lado / 2 + margen - minX
        let alto = centros.map(\.y).max()! + lado / 2 + margen - minY
        let caja = [minX, minY, ancho, alto].map(numero).joined(separator: " ")
        var lineas = [
            #"<svg xmlns="http://www.w3.org/2000/svg" viewBox="\#(caja)" width="\#(numero(ancho))" height="\#(numero(alto))">"#,
            #"<style>.casilla { stroke: #444; stroke-width: 1; } text { font: \#(numero(lado * 0.3))px sans-serif; text-anchor: middle; dominant-baseline: central; }</style>"#,
        ]
        let negras: Set<Int> = [1, 3, 6, 8, 10]
        for (casilla, centro) in zip(casillas, centros) {
            let midi = self.midi(en: casilla)
            let negra = negras.contains(modulo(midi, 12))
            let color = marcadas.contains(midi) ? DibujoSVG.Color.nota : (negra ? "#bbbbbb" : "#f4f4f4")
            let rectangulo = ElementoSVG("rect", numeros: .hastaTresDecimales).con("class", "casilla")
            let cuadrado = rectangulo.con("x", centro.x - lado / 2).con("y", centro.y - lado / 2)
            lineas.append(cuadrado.con("width", lado).con("height", lado).con("fill", color).vacio)
            let rotulo = altura(en: casilla, preferirBemoles: preferirBemoles).nombreCompacto(en: notacion)
            let texto = ElementoSVG("text", numeros: .hastaTresDecimales).con("x", centro.x).con("y", centro.y)
            lineas.append(texto.conTexto(rotulo))
        }
        lineas.append("</svg>")
        return lineas.joined(separator: "\n")
    }
}

/// El máximo común divisor, siempre positivo (0 con dos ceros).
private func maximoComunDivisor(_ a: Int, _ b: Int) -> Int {
    b == 0 ? abs(a) : maximoComunDivisor(b, a % b)
}

extension TecladoCuadrado: CustomStringConvertible {
    public var description: String {
        "\(nombre): H \(semitonosEnH >= 0 ? "+" : "")\(semitonosEnH), V \(semitonosEnV >= 0 ? "+" : "")\(semitonosEnV)"
    }
}

// MARK: - Idiomas
//
// Los nombres de los teclados en los quince idiomas de los textos, en `Textos/TextosDeRepresentaciones+Espanol.swift`,
// `…+Ingles.swift`…, un fichero por idioma.

extension TecladoCuadrado: Nombrable {
    /// El nombre del teclado en el idioma de los textos: «Cuadrícula en cuartas», «Grid in fourths». El de un teclado
    /// que no es de los de `todos` no cambia.
    public func nombre(en notacion: Notacion) -> String {
        traduccion?.en(notacion) ?? nombre
    }

    /// El nombre en los quince idiomas; `nil` si el teclado no es de los de `todos`.
    package var traduccion: Traduccion? {
        switch self {
        case .cuartas: return TextosDeRepresentaciones.traduccion(\.cuadriculaEnCuartas)
        case .tercerasMayores: return TextosDeRepresentaciones.traduccion(\.cuadriculaEnTercerasMayores)
        case .quintas: return TextosDeRepresentaciones.traduccion(\.cuadriculaEnQuintas)
        case .wickiHaydenCuadrado: return TextosDeRepresentaciones.traduccion(\.wickiHaydenCuadrado)
        case .tonosEnteros: return TextosDeRepresentaciones.traduccion(\.cuadriculaDeTonosEnteros)
        case .tonnetzDeEuler: return TextosDeRepresentaciones.traduccion(\.tonnetzDeEuler)
        default: return nil
        }
    }
}
