import ArmoniaNucleo
import ArmoniaTeoria
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
// Y las demás filas del LinnStrument: terceras menores (1, 3), tritonos (1, 6), octavas (1, 12), y la secuencial del
// Push (1, 8), con las filas de ocho una detrás de otra. Cualquier otro se escribe con sus ejes: `conEjes("2,7")`.
//
// «En tono» (`enTono(_:)`), como el modo In Key del Push, solo suenan las notas de una escala: H y V cuentan grados de
// la escala en lugar de semitonos, y la casilla de origen es la tónica.
//
// Los hexagonales están en `TecladoIsomorfico`, sobre la rejilla del paquete `Hexagonos`; estos no la necesitan: una
// casilla es una columna y una fila, y se dibuja como un cuadrado.

/// Una casilla de un teclado de cuadrícula: la columna crece hacia la derecha y la fila, hacia arriba. La `(0, 0)` es
/// la del origen del teclado.
public struct CasillaCuadrada: Hashable, Sendable, CustomStringConvertible {
    public let columna: Int
    public let fila: Int

    /// La casilla de esa columna (hacia la derecha) y esa fila (hacia arriba), contando desde el origen.
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

/// Las casillas que se dibujan de un teclado de cuadrícula: las de un controlador de pads, con la `(0, 0)` en la
/// esquina de abajo a la izquierda, o una ventana de 12 × 7 alrededor del Do4.
///
///     RejillaDeControlador.launchpad.casillas.count    // 64
///     RejillaDeControlador.launchpad.origenPorDefecto   // 36: Do2 en la esquina
public struct RejillaDeControlador: Hashable, Sendable, Identifiable {
    /// El nombre, con su tamaño: «8 × 8 (Launchpad, Push)».
    public let nombre: String
    public let columnas: ClosedRange<Int>
    public let filas: ClosedRange<Int>
    /// El número MIDI de la casilla `(0, 0)` si no se elige otro.
    public let origenPorDefecto: Int

    public init(nombre: String, columnas: ClosedRange<Int>, filas: ClosedRange<Int>, origenPorDefecto: Int) {
        self.nombre = nombre
        self.columnas = columnas
        self.filas = filas
        self.origenPorDefecto = origenPorDefecto
    }

    public var id: String { nombre }

    /// Las casillas, fila a fila de abajo arriba.
    public var casillas: [CasillaCuadrada] { CasillaCuadrada.rectangulo(columnas: columnas, filas: filas) }

    /// 12 columnas por 7 filas con el Do4 hacia el centro: se ven las doce notas y varias octavas.
    public static let ventana = RejillaDeControlador(
        nombre: "12 × 7", columnas: -5...6, filas: -3...3, origenPorDefecto: 60)

    /// Los 8 × 8 pads del Launchpad y del Push, con el Do2 en la esquina de abajo a la izquierda.
    public static let launchpad = RejillaDeControlador(
        nombre: "8 × 8 (Launchpad, Push)", columnas: 0...7, filas: 0...7, origenPorDefecto: 36)

    /// Las 16 × 8 teclas del LinnStrument 128.
    public static let linnStrument128 = RejillaDeControlador(
        nombre: "16 × 8 (LinnStrument 128)", columnas: 0...15, filas: 0...7, origenPorDefecto: 36)

    /// Las 25 × 8 teclas del LinnStrument (el de 200).
    public static let linnStrument = RejillaDeControlador(
        nombre: "25 × 8 (LinnStrument)", columnas: 0...24, filas: 0...7, origenPorDefecto: 36)

    /// Las rejillas con nombre, en el orden en que las ofrecen las apps.
    public static let todas: [RejillaDeControlador] = [.ventana, .launchpad, .linnStrument128, .linnStrument]

    /// Una rejilla de `columnas` × `filas` con la `(0, 0)` en la esquina, o la de un controlador de ese tamaño.
    /// Detiene el programa si alguna medida no va de 1 a 32 (un error de quien llama); si vienen de fuera,
    /// `init?(comprobando:filas:)` devuelve `nil`.
    ///
    ///     RejillaDeControlador(columnas: 8, filas: 8) == .launchpad   // true
    public init(columnas: Int, filas: Int) {
        precondition((1...32).contains(columnas) && (1...32).contains(filas), "Las medidas van de 1 a 32")
        if let conocida = Self.todas.first(where: { $0.columnas.count == columnas && $0.filas.count == filas }) {
            self = conocida
        } else {
            self.init(
                nombre: "\(columnas) × \(filas)", columnas: 0...(columnas - 1), filas: 0...(filas - 1),
                origenPorDefecto: 36)
        }
    }

    /// Como `init(columnas:filas:)`, o `nil` si alguna medida no va de 1 a 32.
    public init?(comprobando columnas: Int, filas: Int) {
        guard (1...32).contains(columnas), (1...32).contains(filas) else { return nil }
        self.init(columnas: columnas, filas: filas)
    }
}

/// Un teclado isomórfico de cuadrícula, definido por sus ejes H y V: la casilla `(columna, fila)` suena
/// `midiDelOrigen + semitonosEnH · columna + semitonosEnV · fila`. En tono, H y V cuentan grados de `grados`, la
/// escala, y no semitonos.
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
    /// Los semitonos de cada grado sobre el origen, de 0 a 11 y de menor a mayor: los doce de la escala cromática
    /// (`TecladoCuadrado.cromatica`), o los de una escala en un teclado en tono. Con ellos, H y V cuentan grados.
    public let grados: [Int]

    /// Los doce semitonos: H y V cuentan semitonos.
    public static let cromatica = Array(0..<12)

    /// - Parameter grados: los semitonos de cada grado sobre el origen; se toman de 0 a 11, sin repetir y ordenados,
    ///   y si no queda ninguno, solo el 0.
    public init(
        nombre: String, semitonosEnH: Int, semitonosEnV: Int, midiDelOrigen: Int = 60,
        grados: [Int] = TecladoCuadrado.cromatica
    ) {
        self.nombre = nombre
        self.semitonosEnH = semitonosEnH
        self.semitonosEnV = semitonosEnV
        self.midiDelOrigen = midiDelOrigen
        let limpios = Set(grados.map { modulo($0, 12) }).sorted()
        self.grados = limpios.isEmpty ? [0] : limpios
    }

    /// El teclado de unos ejes escritos «H,V» (`"1,5"`, `"2, 7"`, `"-1 5"`); `nil` si no son dos números enteros de
    /// −127 a 127.
    ///
    ///     TecladoCuadrado.conEjes("2,7")?.semitonosEnV   // 7
    ///     TecladoCuadrado.conEjes("H")                    // nil
    public static func conEjes(_ texto: String, nombre: String? = nil, midiDelOrigen: Int = 60) -> TecladoCuadrado? {
        let separadores = CharacterSet(charactersIn: ",;").union(.whitespaces)
        let partes = texto.components(separatedBy: separadores).filter { !$0.isEmpty }
        guard partes.count == 2, let h = Int(partes[0]), let v = Int(partes[1]),
            (-127...127).contains(h), (-127...127).contains(v)
        else { return nil }
        return TecladoCuadrado(
            nombre: nombre ?? "\(h),\(v)", semitonosEnH: h, semitonosEnV: v, midiDelOrigen: midiDelOrigen)
    }

    /// Los ejes escritos como los lee `conEjes(_:)`: «1,5».
    public var ejes: String { "\(semitonosEnH),\(semitonosEnV)" }

    /// ¿Cuentan H y V semitonos, o grados de una escala (en tono)?
    public var esCromatico: Bool { grados == Self.cromatica }

    /// El mismo teclado con otro número MIDI en la casilla `(0, 0)`.
    public func conOrigen(_ midi: Int) -> TecladoCuadrado {
        TecladoCuadrado(
            nombre: nombre, semitonosEnH: semitonosEnH, semitonosEnV: semitonosEnV, midiDelOrigen: midi,
            grados: grados)
    }

    /// El teclado en tono, como el modo In Key del Push: solo suenan las notas de `escala`. Cada eje sube los grados
    /// que caben en sus semitonos (en una escala mayor, la cuarta de V 5 son tres grados y la quinta de V 7, cuatro),
    /// y la casilla de origen es la tónica, en el origen o justo por encima.
    ///
    ///     let enTono = TecladoCuadrado.cuartas.enTono(Escala(.do))
    ///     (enTono.semitonosEnH, enTono.semitonosEnV)   // (1, 3)
    ///     enTono.midi(en: CasillaCuadrada(columna: 0, fila: 1))   // 65: Fa, tres grados por encima de Do
    public func enTono(_ escala: Escala) -> TecladoCuadrado {
        let tonica = escala.tonica.claseDeAltura
        let grados = Set(escala.notas.map { modulo($0.claseDeAltura - tonica, 12) }).sorted()
        /// Los grados que suben `semitonos`: los de cada octava entera, más los que quedan por debajo del resto.
        func pasos(_ semitonos: Int) -> Int {
            let resto = modulo(semitonos, 12)
            let octavas = (semitonos - resto) / 12
            return octavas * grados.count + grados.filter { $0 < resto }.count
        }
        return TecladoCuadrado(
            nombre: "\(nombre) · \(escala.nombre(en: .espanolCompacto))", semitonosEnH: pasos(semitonosEnH),
            semitonosEnV: pasos(semitonosEnV), midiDelOrigen: midiDelOrigen + modulo(tonica - midiDelOrigen, 12),
            grados: grados)
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

    /// En terceras menores (H 1, V 3): las filas suben de tercera menor en tercera menor, y cuatro filas hacen la
    /// octava. Una de las del LinnStrument.
    public static let tercerasMenores = TecladoCuadrado(
        nombre: "Cuadrícula en terceras menores", semitonosEnH: 1, semitonosEnV: 3)

    /// En tritonos (H 1, V 6): cada fila, un tritono por encima de la de abajo; dos filas hacen la octava. Una de las
    /// del LinnStrument.
    public static let tritonos = TecladoCuadrado(nombre: "Cuadrícula en tritonos", semitonosEnH: 1, semitonosEnV: 6)

    /// En octavas (H 1, V 12): todas las filas son la misma escala cromática, una octava más arriba cada una. Una de
    /// las del LinnStrument.
    public static let octavas = TecladoCuadrado(nombre: "Cuadrícula en octavas", semitonosEnH: 1, semitonosEnV: 12)

    /// Secuencial (H 1, V 8): las filas de ocho, una detrás de otra, como la escala cromática escrita en renglones;
    /// la «Sequential» del Push en una rejilla de 8 × 8.
    public static let secuencial = TecladoCuadrado(nombre: "Cuadrícula secuencial", semitonosEnH: 1, semitonosEnV: 8)

    /// Los teclados de cuadrícula con nombre, en el orden en que los ofrecen las apps. Un teclado nuevo va aquí y en
    /// `traduccion`.
    public static let todos: [TecladoCuadrado] = [
        .cuartas, .tercerasMayores, .quintas, .wickiHaydenCuadrado, .tonosEnteros, .tonnetzDeEuler, .tercerasMenores,
        .tritonos, .octavas, .secuencial,
    ]

    /// Los semitonos que sube la diagonal de arriba a la derecha: H + V.
    public var semitonosEnDiagonal: Int { semitonosEnH + semitonosEnV }

    /// Los semitonos que sube la diagonal de arriba a la izquierda: V − H.
    public var semitonosEnAntidiagonal: Int { semitonosEnV - semitonosEnH }

    /// ¿Aparecen todas las notas (las doce, o las de la escala en tono)? Solo si H y V no comparten divisor con el
    /// número de grados: con H 2 y V 4, por ejemplo, solo suenan las seis notas de una escala de tonos enteros.
    public var esCompleto: Bool {
        maximoComunDivisor(maximoComunDivisor(semitonosEnH, semitonosEnV), grados.count) == 1
    }

    /// El número MIDI de una casilla.
    public func midi(en casilla: CasillaCuadrada) -> Int {
        let paso = semitonosEnH * casilla.columna + semitonosEnV * casilla.fila
        let grado = modulo(paso, grados.count)
        let octavas = (paso - grado) / grados.count
        return midiDelOrigen + 12 * octavas + grados[grado]
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

    /// El teclado girado `cuartos` cuartos de vuelta en sentido horario (uno si no se dice), en antihorario si son
    /// negativos, como ``TecladoIsomorfico/rotado(doceavos:nombre:)``. En cada cuarto, lo que subía hacia arriba sube
    /// hacia la derecha, y lo que subía hacia la derecha, hacia abajo (H pasa a ser V, y V, −H). Cuatro dan la vuelta
    /// entera.
    public func rotado(cuartos: Int = 1, nombre: String? = nil) -> TecladoCuadrado {
        let vueltas = modulo(cuartos, 4)
        if vueltas == 0 && nombre == nil { return self }
        var (enH, enV) = (semitonosEnH, semitonosEnV)
        for _ in 0..<vueltas { (enH, enV) = (enV, -enH) }
        return TecladoCuadrado(
            nombre: nombre ?? "\(self.nombre) ↻\(vueltas * 90)°", semitonosEnH: enH, semitonosEnV: enV,
            midiDelOrigen: midiDelOrigen, grados: grados)
    }

    /// El teclado reflejado como en un espejo vertical: lo que subía hacia la derecha sube hacia la izquierda.
    public var reflejado: TecladoCuadrado {
        TecladoCuadrado(
            nombre: "\(nombre) ⇋", semitonosEnH: -semitonosEnH, semitonosEnV: semitonosEnV,
            midiDelOrigen: midiDelOrigen, grados: grados)
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
    ///
    /// - Parameters:
    ///   - marcadas: los números MIDI que se marcan (todas las octavas que se quieran ver); las que llevan rótulo
    ///     lo escriben en lugar del nombre de la nota.
    ///   - primeras: los de la primera nota (la tónica de una escala o la fundamental de un acorde), que llevan
    ///     además el borde naranja de la tabla armónica.
    ///   - contorno: si se dibuja en trazo grueso el contorno de las marcadas: los lados entre una casilla marcada y
    ///     una que no lo está (o que queda fuera del dibujo).
    ///   - margen: el blanco alrededor de las casillas, en píxeles (antes de la escala).
    ///   - opciones: la notación de los nombres, si se prefieren bemoles, el título (ninguno, si no se da) y la
    ///     escala: con 1, cada casilla tiene 40 píxeles de lado (``centro(de:lado:)``).
    public func svg(
        _ casillas: [CasillaCuadrada], marcadas: MarcasDeDiagrama = [], primeras: Set<Int> = [],
        contorno: Bool = false, margen: Double = 4, opciones: OpcionesDeDiagrama = OpcionesDeDiagrama()
    ) -> String {
        let lado = 40 * opciones.escala
        let margen = margen * opciones.escala
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
            let rotulo =
                marcadas.rotulo(de: midi)
                ?? (marcadas.altura(de: midi) ?? altura(en: casilla, preferirBemoles: opciones.preferirBemoles))
                .nombreCompacto(en: opciones.notacion)
            let texto = ElementoSVG("text", numeros: .hastaTresDecimales).con("x", centro.x).con("y", centro.y)
            lineas.append(texto.conTexto(rotulo))
        }
        if let titulo = opciones.titulo, !titulo.isEmpty {
            lineas.insert(ElementoSVG("title").conTexto(titulo), at: 1)
        }
        if contorno { lineas += lineasDelContorno(casillas, marcadas: marcadas.notas, lado: lado) }
        // La primera nota, con borde naranja, encima del contorno.
        for (casilla, centro) in zip(casillas, centros) where primeras.contains(midi(en: casilla)) {
            let borde = ElementoSVG("rect", numeros: .hastaTresDecimales).con("class", "primera")
            let esquina = borde.con("x", centro.x - lado / 2 + 2).con("y", centro.y - lado / 2 + 2)
            let cuadrado = esquina.con("width", lado - 4).con("height", lado - 4).con("fill", "none")
            lineas.append(cuadrado.con("stroke", DibujoSVG.Color.primera).con("stroke-width", "3.5").vacio)
        }
        lineas.append("</svg>")
        return lineas.joined(separator: "\n")
    }

    /// Los lados entre una casilla marcada y una que no lo está, o que no se dibuja: el contorno de las formas.
    private func lineasDelContorno(_ casillas: [CasillaCuadrada], marcadas: Set<Int>, lado: Double) -> [String] {
        let dibujadas = Set(casillas)
        func marcada(_ casilla: CasillaCuadrada) -> Bool {
            dibujadas.contains(casilla) && marcadas.contains(midi(en: casilla))
        }
        var lineas: [String] = []
        let medio = lado / 2
        for casilla in casillas where marcada(casilla) {
            let c = Self.centro(de: casilla, lado: lado)
            // Cada vecina, con los dos extremos del lado que comparten (la fila crece hacia arriba, la y hacia abajo).
            let lados: [(CasillaCuadrada, (Double, Double), (Double, Double))] = [
                (CasillaCuadrada(columna: casilla.columna + 1, fila: casilla.fila), (medio, -medio), (medio, medio)),
                (CasillaCuadrada(columna: casilla.columna - 1, fila: casilla.fila), (-medio, -medio), (-medio, medio)),
                (CasillaCuadrada(columna: casilla.columna, fila: casilla.fila + 1), (-medio, -medio), (medio, -medio)),
                (CasillaCuadrada(columna: casilla.columna, fila: casilla.fila - 1), (-medio, medio), (medio, medio)),
            ]
            for (vecina, desde, hasta) in lados where !marcada(vecina) {
                let linea = ElementoSVG("line", numeros: .hastaTresDecimales).con("class", "contorno")
                let inicio = linea.con("x1", c.x + desde.0).con("y1", c.y + desde.1)
                let fin = inicio.con("x2", c.x + hasta.0).con("y2", c.y + hasta.1)
                lineas.append(fin.con("stroke", "#111111").con("stroke-width", "3").vacio)
            }
        }
        return lineas
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
        case .tercerasMenores: return TextosDeRepresentaciones.traduccion(\.cuadriculaEnTercerasMenores)
        case .tritonos: return TextosDeRepresentaciones.traduccion(\.cuadriculaEnTritonos)
        case .octavas: return TextosDeRepresentaciones.traduccion(\.cuadriculaEnOctavas)
        case .secuencial: return TextosDeRepresentaciones.traduccion(\.cuadriculaSecuencial)
        default: return nil
        }
    }
}
