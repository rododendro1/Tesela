import Armonia
import Hexagonos

/// Las redes en que la app Tonnetz dibuja unas notas: el Tonnetz, la tabla armónica y varios teclados
/// isomórficos (Wicki-Hayden, Jankó, el acordeón cromático, Gerhard y Park), más uno que el usuario describe en el
/// formato UIL, y los teclados de cuadrícula (en cuartas, en terceras, en quintas, Wicki-Hayden, tonos enteros, el
/// Tonnetz de Euler, las demás filas del LinnStrument y la secuencial), más uno con los ejes que escribe el usuario.
/// Cada teclado es una fila más con el nombre del de `TecladoIsomorfico.todos` o `TecladoCuadrado.todos`: su dibujo y
/// su nombre en cada idioma los da el motor. No usa SwiftUI, así que se prueba en Linux.
public enum RedDeNotas: String, CaseIterable, Identifiable, Hashable, Sendable {
    case tonnetz = "Tonnetz"
    case tablaArmonica = "Tabla armónica"
    case wickiHayden = "Wicki-Hayden"
    case janko = "Jankó"
    case wickiHaydenEspejo = "Wicki-Hayden (espejo)"
    case wickiHaydenPlano = "Wicki-Hayden (plano)"
    case acordeonC = "Acordeón C"
    case acordeonB = "Acordeón B"
    case gerhard = "Gerhard"
    case park = "Park"
    /// Un teclado descrito en el formato UIL (`2,7,5;R30M`), que se puede girar de 30° en 30° y reflejar: ver ``AjusteUIL``.
    case uil = "UIL"
    case cuadriculaEnCuartas = "Cuadrícula en cuartas"
    case cuadriculaEnTercerasMayores = "Cuadrícula en terceras mayores"
    case cuadriculaEnQuintas = "Cuadrícula en quintas"
    case wickiHaydenCuadrado = "Wicki-Hayden (cuadrícula)"
    case cuadriculaDeTonosEnteros = "Cuadrícula de tonos enteros"
    case tonnetzDeEuler = "Tonnetz de Euler"
    case cuadriculaEnTercerasMenores = "Cuadrícula en terceras menores"
    case cuadriculaEnTritonos = "Cuadrícula en tritonos"
    case cuadriculaEnOctavas = "Cuadrícula en octavas"
    case cuadriculaSecuencial = "Cuadrícula secuencial"
    /// Un teclado de cuadrícula con los ejes que escribe el usuario (`1,5`): ver ``AjusteCuadrado``.
    case cuadriculaPersonalizada = "H,V"

    public var id: Self { self }

    /// El nombre de la red en el idioma de los textos: «Tabla armónica», «Harmonic table»… El de un teclado es el
    /// que le da el motor (`TecladoIsomorfico.nombre(en:)`).
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .tonnetz, .uil, .cuadriculaPersonalizada: return rawValue
        case .tablaArmonica: return TecladoIsomorfico.tablaArmonica.nombre(en: notacion)
        default: return teclado?.nombre(en: notacion) ?? tecladoCuadrado?.nombre(en: notacion) ?? rawValue
        }
    }

    /// El teclado isomórfico de la red, el de `TecladoIsomorfico.todos` que se llama como ella; `nil` en el Tonnetz y
    /// la tabla, que tienen su propio dibujo, en `.uil`, cuyo teclado depende del ``AjusteUIL`` (ver
    /// ``PresentacionDeRedes/teclado(de:uil:)``), y en los de cuadrícula (ver ``tecladoCuadrado``).
    public var teclado: TecladoIsomorfico? {
        switch self {
        case .tonnetz, .tablaArmonica, .uil: return nil
        default: return TecladoIsomorfico.todos.first { $0.nombre == rawValue }
        }
    }

    /// El teclado de cuadrícula de la red, el de `TecladoCuadrado.todos` que se llama como ella; `nil` en las demás y
    /// en `.cuadriculaPersonalizada`, cuyo teclado depende del ``AjusteCuadrado`` (ver
    /// ``AjusteCuadrado/teclado(de:escala:)``).
    public var tecladoCuadrado: TecladoCuadrado? {
        TecladoCuadrado.todos.first { $0.nombre == rawValue }
    }

    /// ¿Es un teclado de cuadrícula, uno de los de `TecladoCuadrado.todos` o el personalizado?
    public var esCuadricula: Bool { self == .cuadriculaPersonalizada || tecladoCuadrado != nil }
}

/// Lo que el usuario escribe y toca para el teclado UIL: el texto, cuántos giros de 30° se le dan encima y si se refleja.
///
///     var ajuste = AjusteUIL(texto: "2,7,5;R30M")
///     ajuste.giros = -1                                  // −30°: el Wicki-Hayden plano
///     ajuste.teclado?.uil?.descripcion                   // "2,7,5;R0M"
public struct AjusteUIL: Hashable, Sendable {
    /// El texto UIL, p. ej. `2,7,5;R30M`.
    public var texto: String
    /// Los giros de 30° en sentido horario que se suman al `R` del texto (negativos, en antihorario).
    public var giros: Int
    /// Si se refleja el teclado después de girarlo.
    public var espejo: Bool

    /// Un teclado hexagonal escrito en UIL, girado `giros` doceavos de vuelta y en espejo si se pide.
    public init(texto: String = "2,7,5;R30M", giros: Int = 0, espejo: Bool = false) {
        self.texto = texto
        self.giros = giros
        self.espejo = espejo
    }

    /// El teclado resultante; `nil` si el texto no es un UIL válido de 12 notas.
    public var teclado: TecladoIsomorfico? {
        guard let base = try? FormatoUIL(leyendo: texto).teclado(nombre: "UIL") else { return nil }
        let girado = base.rotado(doceavos: giros, nombre: base.nombre)
        return espejo ? girado.reflejado : girado
    }

    /// El texto UIL del teclado resultante, ya girado y reflejado: `2,7,5;R0M`.
    public var resultado: String? { teclado?.uil?.descripcion }

    /// Los teclados de la Tabla 1 del artículo, para elegir uno y rellenar el texto.
    public static let conocidos: [(nombre: String, texto: String)] = FormatoUIL.conocidos.map {
        (nombre: $0.nombre, texto: $0.formato.descripcion)
    }
}

/// Lo que el usuario elige para los teclados de cuadrícula: los ejes del personalizado, el giro de 90° en 90°, el
/// espejo, la rejilla del controlador, la nota de la casilla de origen y si se toca en tono (solo las notas de la
/// escala).
///
///     var ajuste = AjusteCuadrado(texto: "1,5")
///     ajuste.giros = 1                                              // un cuarto de vuelta
///     ajuste.teclado(de: .cuadriculaPersonalizada)?.ejes            // "5,-1"
///     ajuste.rejilla = .launchpad                                   // el Do2 en la esquina
public struct AjusteCuadrado: Hashable, Sendable {
    /// Los ejes del teclado personalizado, «H,V»: `1,5`.
    public var texto: String
    /// Los cuartos de vuelta en sentido horario (negativos, en antihorario).
    public var giros: Int
    /// Si se refleja el teclado después de girarlo.
    public var espejo: Bool
    /// Las casillas que se dibujan. Al cambiarla, la nota de origen vuelve a la suya (`origen` a `nil`).
    public var rejilla: RejillaDeControlador {
        didSet { if rejilla != oldValue { origen = nil } }
    }
    /// El número MIDI de la casilla `(0, 0)`; `nil` para el de la rejilla (`RejillaDeControlador.origenPorDefecto`).
    public var origen: Int?
    /// Si solo suenan las notas de la escala que se dibuja, como en el modo In Key del Push (ver
    /// `TecladoCuadrado.enTono(_:)`). Sin escala, no cambia nada.
    public var enTono: Bool

    /// Un ajuste; por defecto, el teclado «1,5» sin girar ni reflejar, en la rejilla `.ventana`.
    public init(
        texto: String = "1,5", giros: Int = 0, espejo: Bool = false, rejilla: RejillaDeControlador = .ventana,
        origen: Int? = nil, enTono: Bool = false
    ) {
        self.texto = texto
        self.giros = giros
        self.espejo = espejo
        self.rejilla = rejilla
        self.origen = origen
        self.enTono = enTono
    }

    /// El número MIDI de la casilla de origen: el elegido o el de la rejilla.
    public var midiDelOrigen: Int { origen ?? rejilla.origenPorDefecto }

    /// El teclado de una red de cuadrícula con este ajuste: girado, reflejado, con su nota de origen y, si se pide y
    /// hay escala, en tono. `nil` si la red no es de cuadrícula o si los ejes del personalizado no se pueden leer.
    public func teclado(de red: RedDeNotas, escala: Escala? = nil) -> TecladoCuadrado? {
        let elegido =
            red == .cuadriculaPersonalizada ? TecladoCuadrado.conEjes(texto, nombre: red.rawValue) : red.tecladoCuadrado
        guard let base = elegido else { return nil }
        let girado = base.rotado(cuartos: giros)
        let colocado = (espejo ? girado.reflejado : girado).conOrigen(midiDelOrigen)
        if enTono, let escala { return colocado.enTono(escala) }
        return colocado
    }

    /// Los ejes del teclado personalizado ya girado y reflejado («5,-1»), o `nil` si no se pueden leer.
    public var resultado: String? { teclado(de: .cuadriculaPersonalizada)?.ejes }
}

/// Lo que se dibuja: un acorde, una escala, un recorrido de tríadas o unas clases de altura sueltas (las que se
/// tocan para identificar un acorde, de 0 = Do a 11 = Si, en el orden en que se tocaron).
public enum ContenidoDeRed: Hashable, Sendable {
    case acorde(Acorde)
    case escala(Escala)
    case recorrido([Acorde])
    case clases([Int])

    /// Las notas, sin repetir, en el orden en que aparecen.
    public var notas: [Nota] {
        let todas: [Nota]
        switch self {
        case .acorde(let acorde): todas = acorde.notas
        case .escala(let escala): todas = escala.notas
        case .recorrido(let acordes): todas = acordes.flatMap(\.notas)
        case .clases(let clases): todas = clases.map { Altura(midi: 60 + $0).nota }
        }
        var vistas = Set<Nota>()
        return todas.filter { vistas.insert($0).inserted }
    }
}

/// Lo que comparten los dibujos de las redes y los teclados, sin SwiftUI: las casillas y los SVG.
public enum PresentacionDeRedes {
    /// Las casillas de los teclados: 12 columnas por 7 filas, con el Do4 hacia el centro.
    public static let casillasDelTeclado: [CoordenadaAxial] =
        FormasDeMapa
        .rectangulo(columnas: 12, filas: 7, .filasImpares)
        .map { $0 + CoordenadaAxial(q: -4, r: -4) }

    /// Las casillas de un teclado de hexágonos planos: 12 columnas por 7 filas, también con el Do4 hacia el centro.
    public static let casillasDelTecladoPlano: [CoordenadaAxial] =
        FormasDeMapa
        .rectangulo(columnas: 12, filas: 7, .columnasImpares)
        .map { $0 + CoordenadaAxial(q: -6, r: -1) }

    /// El teclado de una red: el suyo, o el del ajuste UIL si la red es `.uil`; `nil` en el Tonnetz y la tabla.
    public static func teclado(de red: RedDeNotas, uil: AjusteUIL = AjusteUIL()) -> TecladoIsomorfico? {
        red == .uil ? uil.teclado : red.teclado
    }

    /// Las casillas que se dibujan de un teclado, según cómo estén colocados sus hexágonos.
    public static func casillasDelTeclado(_ teclado: TecladoIsomorfico) -> [CoordenadaAxial] {
        teclado.orientacion == .plana ? casillasDelTecladoPlano : casillasDelTeclado
    }

    /// El lado de las casillas de los teclados en el dibujo.
    static let tamanoDelTeclado = 24.0

    /// Las casillas de los teclados de cuadrícula si no se elige otra rejilla: 12 columnas por 7 filas, con el Do4
    /// hacia el centro (`RejillaDeControlador.ventana`).
    public static let casillasDelTecladoCuadrado = RejillaDeControlador.ventana.casillas

    /// El lado de los cuadrados de los teclados de cuadrícula en el dibujo.
    static let ladoDelTecladoCuadrado = 40.0

    /// La distancia entre dos notas vecinas en el dibujo del Tonnetz o de la tabla: la que usan sus `svg`
    /// por defecto, con más sitio en un recorrido para las flechas. Se fija aquí para saber qué nota se toca.
    static func paso(_ contenido: ContenidoDeRed, en red: RedDeNotas) -> Double {
        var esRecorrido = false
        if case .recorrido(let acordes) = contenido { esRecorrido = acordes.count >= 2 }
        switch red {
        case .tablaArmonica: return esRecorrido ? 72 : 56
        default: return esRecorrido ? 88 : 64
        }
    }

    /// El dibujo SVG del contenido en la red; `nil` si un recorrido está vacío.
    public static func svg(
        _ contenido: ContenidoDeRed, en red: RedDeNotas, notacion: Notacion,
        uil: AjusteUIL = AjusteUIL(), cuadrado: AjusteCuadrado = AjusteCuadrado()
    ) -> String? {
        let opciones = OpcionesDeDiagrama(notacion: notacion)
        let sinTitulo = OpcionesDeDiagrama(notacion: notacion, titulo: "")
        if red == .uil && uil.teclado == nil { return nil }
        if red.esCuadricula {
            return svgDeCuadricula(contenido, en: red, notacion: notacion, cuadrado: cuadrado)
        }
        let clases = Set(contenido.notas.map(\.claseDeAltura))
        let marcadas = Set((0...127).filter { clases.contains($0 % 12) })
        // Con bemoles si alguna nota lleva bemol: en la línea de quintas, las que quedan por debajo de Fa (Si♭…).
        let bemoles = contenido.notas.contains { $0.pasosDeQuinta < -1 }
        if let teclado = Self.teclado(de: red, uil: uil) {
            return teclado.svg(
                casillasDelTeclado(teclado), marcadas: MarcasDeDiagrama(marcadas),
                opciones: .init(notacion: notacion, ventana: bemoles ? .bemoles : .sostenidos))
        }
        switch (red, contenido) {
        case (.tablaArmonica, .acorde(let acorde)):
            return TablaArmonica(acorde).svg(opciones: opciones)
        case (.tablaArmonica, .escala(let escala)):
            return TablaArmonica(escala).svg(opciones: opciones)
        case (.tablaArmonica, .recorrido(let acordes)):
            guard let primero = acordes.first else { return nil }
            return (acordes.count >= 2 ? TablaArmonica(recorrido: acordes) : nil)?.svg(opciones: opciones)
                ?? TablaArmonica(primero).svg(opciones: opciones)
        case (_, .acorde(let acorde)):
            return Tonnetz(acorde).svg(opciones: opciones)
        case (_, .escala(let escala)):
            return Tonnetz(escala).svg(opciones: opciones)
        case (_, .recorrido(let acordes)):
            guard let primero = acordes.first else { return nil }
            return (acordes.count >= 2 ? Tonnetz(recorrido: acordes) : nil)?.svg(opciones: opciones)
                ?? Tonnetz(primero).svg(opciones: opciones)
        // Para identificar: con margen de sobra para tocar más notas, aunque aún no haya ninguna, y sin título.
        case (.tablaArmonica, .clases(let clases)):
            return TablaArmonica(ConjuntoDeClasesDeAltura(clases)).svg(opciones: sinTitulo, margen: 3)
        case (_, .clases(let clases)):
            return Tonnetz(ConjuntoDeClasesDeAltura(clases)).svg(opciones: sinTitulo, margen: 3)
        }
    }

    /// La escala del contenido, para tocar en tono; `nil` si no es una escala.
    static func escala(de contenido: ContenidoDeRed) -> Escala? {
        if case .escala(let escala) = contenido { return escala }
        return nil
    }

    /// El dibujo en un teclado de cuadrícula: las notas marcadas en todas las octavas, con su contorno, y la primera
    /// (la tónica de una escala o la fundamental de un acorde) con el borde naranja.
    static func svgDeCuadricula(
        _ contenido: ContenidoDeRed, en red: RedDeNotas, notacion: Notacion, cuadrado: AjusteCuadrado
    ) -> String? {
        guard let teclado = cuadrado.teclado(de: red, escala: escala(de: contenido)) else { return nil }
        let notas = contenido.notas
        let clases = Set(notas.map(\.claseDeAltura))
        let marcadas = Set((0...127).filter { clases.contains($0 % 12) })
        let primeras = Set((0...127).filter { $0 % 12 == notas.first?.claseDeAltura })
        let bemoles = notas.contains { $0.pasosDeQuinta < -1 }
        return teclado.svg(
            cuadrado.rejilla.casillas, marcadas: MarcasDeDiagrama(marcadas), primeras: primeras, contorno: true,
            opciones: .init(notacion: notacion, ventana: bemoles ? .bemoles : .sostenidos))
    }

    /// Pone una clase de altura entre las elegidas para identificar un acorde, al final, o la quita si ya estaba,
    /// sin cambiar el orden de las demás (la primera es el bajo).
    ///
    ///     PresentacionDeRedes.alternar(64, en: [0, 7])   // [0, 7, 4]
    ///     PresentacionDeRedes.alternar(60, en: [0, 7])   // [7]
    public static func alternar(_ midi: Int, en clases: [Int]) -> [Int] {
        let clase = ((midi % 12) + 12) % 12
        return clases.contains(clase) ? clases.filter { $0 != clase } : clases + [clase]
    }

    /// Los acordes que forman unas clases de altura, la primera como bajo, del más al menos probable.
    ///
    ///     PresentacionDeRedes.acordes(de: [4, 7, 0]).first   // Do/Mi
    public static func acordes(de clases: [Int]) -> [Acorde] {
        Acorde.candidatos(clasesDeAltura: clases).map(\.valor)
    }

    /// La nota que se toca en el dibujo de `svg(_:en:notacion:)`, como número MIDI, o `nil` si el toque no
    /// cae en una nota. `punto` va en las coordenadas del SVG (las de su `viewBox`).
    ///
    /// En el Tonnetz y en la tabla cada nota es una clase de altura, y suena en la octava 4 (de Do4 a Si4);
    /// en un teclado suena la altura de la casilla.
    public static func midi(
        en punto: Punto, de contenido: ContenidoDeRed, enLaRed red: RedDeNotas,
        uil: AjusteUIL = AjusteUIL(), cuadrado: AjusteCuadrado = AjusteCuadrado()
    ) -> Int? {
        if red == .uil && uil.teclado == nil { return nil }
        if let teclado = Self.teclado(de: red, uil: uil) {
            let casilla = Trazado(orientacion: teclado.orientacion, tamano: tamanoDelTeclado).casilla(en: punto)
            guard casillasDelTeclado(teclado).contains(casilla) else { return nil }
            let midi = teclado.midi(en: casilla)
            return (0...127).contains(midi) ? midi : nil
        }
        if red.esCuadricula {
            guard let teclado = cuadrado.teclado(de: red, escala: escala(de: contenido)) else { return nil }
            let casilla = TecladoCuadrado.casilla(en: punto, lado: ladoDelTecladoCuadrado)
            guard cuadrado.rejilla.casillas.contains(casilla) else { return nil }
            let midi = teclado.midi(en: casilla)
            return (0...127).contains(midi) ? midi : nil
        }
        let paso = Self.paso(contenido, en: red)
        switch red {
        case .tablaArmonica:
            return 60 + TablaArmonica.punto(en: punto, paso: paso).claseDeAltura
        default:
            // Solo cerca del círculo de la nota: entre dos notas no suena nada.
            let nota = Tonnetz.punto(en: punto, paso: paso)
            let centro = Tonnetz.trazado(paso: paso).centro(de: nota.coordenada)
            let distancia = ((punto.x - centro.x) * (punto.x - centro.x) + (punto.y - centro.y) * (punto.y - centro.y))
                .squareRoot()
            return distancia <= paso * 0.4 ? 60 + nota.claseDeAltura : nil
        }
    }

    /// El nombre del fichero al exportar el dibujo: «Tonnetz · Dom7».
    public static func nombre(
        _ contenido: ContenidoDeRed, en red: RedDeNotas, notacion: Notacion,
        uil: AjusteUIL = AjusteUIL(), cuadrado: AjusteCuadrado = AjusteCuadrado()
    ) -> String {
        let que: String
        switch contenido {
        case .acorde(let acorde): que = acorde.cifrado(en: notacion)
        case .escala(let escala): que = escala.nombre(en: notacion)
        case .recorrido(let acordes): que = acordes.map { $0.cifrado(en: notacion) }.joined(separator: " ")
        case .clases(let clases):
            que =
                acordes(de: clases).first?.cifrado(en: notacion)
                ?? ContenidoDeRed.clases(clases).notas.map { $0.nombre(en: notacion) }.joined(separator: " ")
        }
        let donde: String
        switch red {
        case .uil: donde = "UIL " + (uil.resultado ?? "")
        case .cuadriculaPersonalizada: donde = "H,V " + (cuadrado.resultado ?? "")
        default: donde = red.nombre(en: notacion)
        }
        return donde + " · " + que
    }
}
