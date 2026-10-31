import Armonia
import Hexagonos

/// Las redes en que la app Tonnetz dibuja unas notas: el Tonnetz, la tabla armónica y varios teclados
/// isomórficos (Wicki-Hayden, Jankó, el acordeón cromático, Gerhard y Park), más uno que el usuario describe en el
/// formato UIL.
/// No usa SwiftUI, así que se prueba en Linux.
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

    public var id: Self { self }

    /// El nombre de la red en el idioma de los textos: «Tabla armónica», «Harmonic table»…
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .tonnetz, .wickiHayden, .janko, .gerhard, .park, .uil: return rawValue
        case .wickiHaydenEspejo:
            return Traduccion(
                "Wicki-Hayden (espejo)", "Wicki-Hayden (mirrored)", ca: "Wicki-Hayden (mirall)",
                gl: "Wicki-Hayden (espello)", ast: "Wicki-Hayden (espeyu)", an: "Wicki-Hayden (espello)",
                eu: "Wicki-Hayden (ispilua)", pt: "Wicki-Hayden (espelho)", fr: "Wicki-Hayden (miroir)",
                oc: "Wicki-Hayden (miralh)", it: "Wicki-Hayden (specchio)",
                de: "Wicki-Hayden (gespiegelt)",
                el: "Wicki-Hayden (καθρέφτης)", ru: "Уикки-Хейден (зеркальный)"
            ).en(notacion)
        case .wickiHaydenPlano:
            return Traduccion(
                "Wicki-Hayden (plano)", "Wicki-Hayden (flat-top)", ca: "Wicki-Hayden (pla)",
                gl: "Wicki-Hayden (plano)", ast: "Wicki-Hayden (planu)", an: "Wicki-Hayden (plano)",
                eu: "Wicki-Hayden (laua)", pt: "Wicki-Hayden (plano)", fr: "Wicki-Hayden (plat)",
                oc: "Wicki-Hayden (plan)", it: "Wicki-Hayden (piatto)",
                de: "Wicki-Hayden (flach)",
                el: "Wicki-Hayden (επίπεδο)", ru: "Уикки-Хейден (плоский)"
            ).en(notacion)
        case .acordeonC:
            return Traduccion(
                "Acordeón C", "C-system accordion", ca: "Acordió sistema C", gl: "Acordeón sistema C",
                ast: "Acordeón sistema C", an: "Acordeón sistema C", eu: "C sistemako akordeoia",
                pt: "Acordeão sistema C", fr: "Accordéon système C", oc: "Acordeon sistèma C",
                it: "Fisarmonica sistema C", de: "Akkordeon C-Griff",
                el: "Ακορντεόν συστήματος C", ru: "Аккордеон системы C"
            ).en(notacion)
        case .acordeonB:
            return Traduccion(
                "Acordeón B", "B-system accordion", ca: "Acordió sistema B", gl: "Acordeón sistema B",
                ast: "Acordeón sistema B", an: "Acordeón sistema B", eu: "B sistemako akordeoia",
                pt: "Acordeão sistema B", fr: "Accordéon système B", oc: "Acordeon sistèma B",
                it: "Fisarmonica sistema B", de: "Akkordeon B-Griff",
                el: "Ακορντεόν συστήματος B", ru: "Аккордеон системы B"
            ).en(notacion)
        case .tablaArmonica:
            return Traduccion(
                "Tabla armónica", "Harmonic table", ca: "Taula harmònica", gl: "Táboa harmónica",
                ast: "Tabla armónica", an: "Tabla armónica", eu: "Taula harmonikoa",
                pt: "Tabela harmónica", fr: "Table harmonique", oc: "Taula armonica",
                it: "Tavola armonica", de: "Harmonische Tabelle",
                el: "Αρμονικός πίνακας", ru: "Гармоническая таблица"
            ).en(notacion)
        }
    }

    /// El teclado isomórfico de la red; `nil` en el Tonnetz y la tabla, que tienen su propio dibujo, y en `.uil`,
    /// cuyo teclado depende del ``AjusteUIL`` (ver ``PresentacionDeRedes/teclado(de:uil:)``).
    public var teclado: TecladoIsomorfico? {
        switch self {
        case .tonnetz, .tablaArmonica, .uil: return nil
        case .wickiHayden: return .wickiHayden
        case .janko: return .janko
        case .wickiHaydenEspejo: return .wickiHaydenEspejo
        case .wickiHaydenPlano: return .wickiHaydenPlano
        case .acordeonC: return .acordeonC
        case .acordeonB: return .acordeonB
        case .gerhard: return .gerhard
        case .park: return .park
        }
    }
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

    public init(texto: String = "2,7,5;R30M", giros: Int = 0, espejo: Bool = false) {
        self.texto = texto
        self.giros = giros
        self.espejo = espejo
    }

    /// El teclado resultante; `nil` si el texto no es un UIL válido de 12 notas.
    public var teclado: TecladoIsomorfico? {
        guard let base = try? FormatoUIL(leyendo: texto).teclado(nombre: "UIL") else { return nil }
        let girado = base.rotado(pasos: giros, nombre: base.nombre)
        return espejo ? girado.reflejado : girado
    }

    /// El texto UIL del teclado resultante, ya girado y reflejado: `2,7,5;R0M`.
    public var resultado: String? { teclado?.uil?.descripcion }

    /// Los teclados de la Tabla 1 del artículo, para elegir uno y rellenar el texto.
    public static let conocidos: [(nombre: String, texto: String)] = FormatoUIL.conocidos.map {
        (nombre: $0.nombre, texto: $0.formato.descripcion)
    }
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
        uil: AjusteUIL = AjusteUIL()
    ) -> String? {
        let paso = Self.paso(contenido, en: red)
        if red == .uil && uil.teclado == nil { return nil }
        if let teclado = Self.teclado(de: red, uil: uil) {
            let clases = Set(contenido.notas.map(\.claseDeAltura))
            let marcadas = Set((0...127).filter { clases.contains($0 % 12) })
            // Con bemoles si alguna nota lleva bemol: en la línea de quintas, las que quedan por debajo de Fa (Si♭…).
            let bemoles = contenido.notas.contains { $0.pasosDeQuinta < -1 }
            return teclado.svg(
                casillasDelTeclado(teclado), marcadas: marcadas, tamano: tamanoDelTeclado, notacion: notacion,
                preferirBemoles: bemoles)
        }
        switch (red, contenido) {
        case (.tablaArmonica, .acorde(let acorde)):
            return TablaArmonica(acorde).svg(notacion: notacion, paso: paso)
        case (.tablaArmonica, .escala(let escala)):
            return TablaArmonica(escala).svg(notacion: notacion, paso: paso)
        case (.tablaArmonica, .recorrido(let acordes)):
            guard let primero = acordes.first else { return nil }
            return (acordes.count >= 2 ? TablaArmonica(recorrido: acordes) : nil)?.svg(notacion: notacion, paso: paso)
                ?? TablaArmonica(primero).svg(notacion: notacion, paso: paso)
        case (_, .acorde(let acorde)):
            return Tonnetz(acorde).svg(notacion: notacion, paso: paso)
        case (_, .escala(let escala)):
            return Tonnetz(escala).svg(notacion: notacion, paso: paso)
        case (_, .recorrido(let acordes)):
            guard let primero = acordes.first else { return nil }
            return (acordes.count >= 2 ? Tonnetz(recorrido: acordes) : nil)?.svg(notacion: notacion, paso: paso)
                ?? Tonnetz(primero).svg(notacion: notacion, paso: paso)
        // Para identificar: con margen de sobra para tocar más notas, aunque aún no haya ninguna, y sin título.
        case (.tablaArmonica, .clases(let clases)):
            return TablaArmonica(ConjuntoDeClases(clases)).svg(notacion: notacion, margen: 3, paso: paso, titulo: "")
        case (_, .clases(let clases)):
            return Tonnetz(ConjuntoDeClases(clases)).svg(notacion: notacion, margen: 3, paso: paso, titulo: "")
        }
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
        uil: AjusteUIL = AjusteUIL()
    ) -> Int? {
        if red == .uil && uil.teclado == nil { return nil }
        if let teclado = Self.teclado(de: red, uil: uil) {
            let casilla = Trazado(orientacion: teclado.orientacion, tamano: tamanoDelTeclado).casilla(en: punto)
            guard casillasDelTeclado(teclado).contains(casilla) else { return nil }
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
        uil: AjusteUIL = AjusteUIL()
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
        let donde = red == .uil ? "UIL " + (uil.resultado ?? "") : red.nombre(en: notacion)
        return donde + " · " + que
    }
}
