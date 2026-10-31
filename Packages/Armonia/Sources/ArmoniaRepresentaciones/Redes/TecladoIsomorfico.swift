import ArmoniaNucleo
import Foundation
import Hexagonos

// Los teclados isomórficos: botones hexagonales en los que cada dirección sube siempre el mismo
// intervalo, así que un acorde o una escala tiene la misma forma en todas las tonalidades. La tabla
// armónica es uno de ellos; Wicki-Hayden (concertinas, apps como Musix), Jankó, el acordeón cromático, Gerhard y
// Park, otros.
//
// Cada teclado es una pareja de generadores: los tres vecinos de un hexágono suben `a`, `b` y `a − b` semitonos
// (o `a + b`, según la orientación), y las otras tres direcciones, lo contrario. Tabla armónica: 7, 4 y 3;
// Wicki-Hayden: 2, 5 y 7; acordeón cromático: 3, 2 y 1; Jankó: 2, 1 y 1; Gerhard: 4, 3 y 1; Park: 5, 3 y 2.
// Bosanquet-Wilson, en 12 notas, da los mismos intervalos que Jankó (el tono y los dos semitonos coinciden).
//
// Cualquier teclado se puede escribir y leer en el formato UIL (Unified Isomorphic Layout, Park y Gerhard, 2013),
// y girar de 30° en 30° o reflejar: ver `FormatoUIL`.

/// Un teclado isomórfico sobre una rejilla hexagonal: la casilla `(q, r)` suena
/// `midiDelOrigen + semitonosEnQ · q + semitonosEnR · r`.
///
///     let teclado = TecladoIsomorfico.wickiHayden
///     teclado.midi(en: .origen)                                    // 60
///     teclado.semitonos(hacia: .qMasRMenos)                        // 7
///     teclado.casillas(de: 67, en: FormasDeMapa.hexagono(radio: 3))  // [(q: 1, r: -1)]
///
/// `svg(_:)` lo dibuja con el nombre de cada nota y las teclas negras del piano en gris.
public struct TecladoIsomorfico: Hashable, Sendable {
    public let nombre: String
    /// Cómo se colocan los hexágonos: los intervalos de cada dirección dependen de ella al dibujar.
    public let orientacion: Orientacion
    /// Los semitonos que sube un paso de `q` (la dirección `qMasSMenos`).
    public let semitonosEnQ: Int
    /// Los semitonos que sube un paso de `r` (la dirección `rMasSMenos`).
    public let semitonosEnR: Int
    /// El número MIDI de la casilla `(0, 0)`.
    public let midiDelOrigen: Int

    public init(
        nombre: String, orientacion: Orientacion, semitonosEnQ: Int, semitonosEnR: Int,
        midiDelOrigen: Int = 60
    ) {
        self.nombre = nombre
        self.orientacion = orientacion
        self.semitonosEnQ = semitonosEnQ
        self.semitonosEnR = semitonosEnR
        self.midiDelOrigen = midiDelOrigen
    }

    /// La tabla armónica (C-Thru AXiS), en las casillas de `TablaArmonica.coordenada(de:)`: hexágonos
    /// planos con la quinta justa hacia arriba, la tercera mayor arriba a la derecha y la tercera menor
    /// arriba a la izquierda. Es el preset 3 del Lumatone («Harmonic Mode»).
    public static let tablaArmonica = TecladoIsomorfico(
        nombre: "Tabla armónica", orientacion: .plana,
        semitonosEnQ: -3, semitonosEnR: -7)

    /// Wicki-Hayden: hexágonos puntiagudos con un tono hacia la derecha, una quinta justa arriba a la
    /// derecha y una cuarta justa arriba a la izquierda.
    public static let wickiHayden = TecladoIsomorfico(
        nombre: "Wicki-Hayden", orientacion: .puntiaguda,
        semitonosEnQ: 2, semitonosEnR: -5)

    /// Jankó: hexágonos puntiagudos con un tono hacia la derecha y un semitono en las dos diagonales de
    /// la derecha; cada fila es una escala de tonos enteros. En 12 notas es también Bosanquet-Wilson, el preset 1 del
    /// Lumatone («Classic Mode», y el 4, «Multi-Instrumental Mode», con colores por canal).
    public static let janko = TecladoIsomorfico(
        nombre: "Jankó", orientacion: .puntiaguda,
        semitonosEnQ: 2, semitonosEnR: 1)

    /// Wicki-Hayden en espejo (para zurdos o para quien lo ha aprendido al revés): la quinta justa sube a la
    /// izquierda y la cuarta justa a la derecha. Como un teclado consistente no puede subir a la vez la cuarta a la
    /// derecha y el tono a la derecha, el tono queda hacia la izquierda.
    public static let wickiHaydenEspejo = TecladoIsomorfico(
        nombre: "Wicki-Hayden (espejo)", orientacion: .puntiaguda,
        semitonosEnQ: -2, semitonosEnR: -7)

    /// Wicki-Hayden con hexágonos planos: la quinta justa hacia arriba, un tono arriba a la derecha y una cuarta
    /// justa arriba a la izquierda. Es el mismo teclado girado, con las columnas de quintas en vertical, y el preset 2
    /// del Lumatone («Melodic Mode»).
    public static let wickiHaydenPlano = TecladoIsomorfico(
        nombre: "Wicki-Hayden (plano)", orientacion: .plana,
        semitonosEnQ: -5, semitonosEnR: -7)

    /// El acordeón cromático de botones, sistema C (C-griff): hexágonos planos; cada columna sube de tercera menor
    /// en tercera menor (un acorde de séptima disminuida), y los botones de al lado suben un semitono (arriba a la
    /// derecha) o un tono (arriba a la izquierda).
    public static let acordeonC = TecladoIsomorfico(
        nombre: "Acordeón C", orientacion: .plana,
        semitonosEnQ: -2, semitonosEnR: -3)

    /// El acordeón cromático de botones, sistema B (B-griff): el espejo del sistema C, con el tono arriba a la
    /// derecha y el semitono arriba a la izquierda.
    public static let acordeonB = TecladoIsomorfico(
        nombre: "Acordeón B", orientacion: .plana,
        semitonosEnQ: -1, semitonosEnR: -3)

    /// Gerhard (Park y Gerhard, 2013): hexágonos planos con un semitono hacia arriba, una tercera mayor arriba a la
    /// derecha y una tercera menor abajo a la derecha. Usa los intervalos de la tabla armónica, salvo la quinta, que
    /// cambia por el semitono: cada columna es la escala cromática. En UIL, `1,4,3;R60`.
    public static let gerhard = TecladoIsomorfico(
        nombre: "Gerhard", orientacion: .plana,
        semitonosEnQ: 3, semitonosEnR: -1)

    /// Park (Park y Gerhard, 2013): hexágonos puntiagudos con una cuarta justa hacia la derecha, una tercera menor
    /// arriba a la derecha y un tono abajo a la derecha. Las melodías por grados conjuntos piden poco desplazamiento.
    /// En UIL, `2,5,3;R90M`.
    public static let park = TecladoIsomorfico(
        nombre: "Park", orientacion: .puntiaguda,
        semitonosEnQ: 5, semitonosEnR: 2)

    /// Los teclados con nombre, en el orden en que los ofrecen las apps: la tabla armónica, Wicki-Hayden, Jankó,
    /// Wicki-Hayden en espejo y plano, los dos acordeones, Gerhard y Park. Un teclado nuevo va aquí y, si su nombre
    /// se traduce, en `traduccion`.
    public static let todos: [TecladoIsomorfico] = [
        .tablaArmonica, .wickiHayden, .janko, .wickiHaydenEspejo, .wickiHaydenPlano, .acordeonC, .acordeonB, .gerhard,
        .park,
    ]

    /// El número MIDI de una casilla.
    public func midi(en casilla: CoordenadaAxial) -> Int {
        midiDelOrigen + semitonosEnQ * casilla.q + semitonosEnR * casilla.r
    }

    // MARK: UIL, giros y espejo

    /// El teclado descrito en el formato UIL, p. ej. `2,7,5;R30M` para Wicki-Hayden; `nil` si ningún paso sube
    /// nada (todo a 0).
    public var uil: FormatoUIL? { FormatoUIL(teclado: self) }

    /// El teclado que describe un texto UIL (`2,7,5;R30M`), con la casilla `(0, 0)` en `midiDelOrigen`.
    /// El nombre es el texto normalizado salvo que se dé otro.
    public static func conUIL(_ texto: String, nombre: String? = nil, midiDelOrigen: Int = 60) throws
        -> TecladoIsomorfico
    {
        try FormatoUIL(leyendo: texto).teclado(nombre: nombre, midiDelOrigen: midiDelOrigen)
    }

    /// Los semitonos que sube un paso hacia ese rumbo, en grados en sentido horario desde el norte (0° arriba,
    /// 90° a la derecha), o `nil` si no hay casilla vecina hacia allí: los hexágonos planos solo tienen vecinas
    /// en 0°, 60°, 120°…, y los puntiagudos en 30°, 90°, 150°…
    public func semitonos(rumbo grados: Int) -> Int? {
        let rumbo = modulo(grados, 360)
        return DireccionHexagonal.allCases.first { $0.rumbo(orientacion) == rumbo }.map { semitonos(hacia: $0) }
    }

    /// El teclado girado `doceavos` veces 30° (un doceavo de vuelta) en sentido horario, en antihorario si son
    /// negativos.
    ///
    /// Es el mismo teclado con otra colocación, como el `R` del UIL: cada giro de 60° reparte los mismos
    /// intervalos una dirección más allá, y uno de 30° además cambia la orientación de los hexágonos
    /// (de planos a puntiagudos o al revés). Doce giros dan la vuelta entera.
    public func rotado(doceavos: Int, nombre: String? = nil) -> TecladoIsomorfico {
        let grados = modulo(doceavos * 30, 360)
        if grados == 0 && nombre == nil { return self }
        let nueva = doceavos % 2 == 0 ? orientacion : orientacion.alternada
        return derivado(nombre: nombre ?? "\(self.nombre) ↻\(grados)°", orientacion: nueva) { rumbo in
            self.semitonos(rumbo: rumbo - grados) ?? 0
        }
    }

    /// El teclado girado esos grados en sentido horario, o `nil` si no son un múltiplo de 30.
    public func rotado(grados: Int, nombre: String? = nil) -> TecladoIsomorfico? {
        grados % 30 == 0 ? rotado(doceavos: grados / 30, nombre: nombre) : nil
    }

    /// El teclado reflejado como en un espejo vertical: lo que subía a la derecha sube a la izquierda.
    public var reflejado: TecladoIsomorfico {
        derivado(nombre: "\(nombre) ⇋", orientacion: orientacion) { rumbo in self.semitonos(rumbo: -rumbo) ?? 0 }
    }

    /// Un teclado con la misma casilla de origen y los intervalos que da `intervalo` para cada rumbo.
    private func derivado(nombre: String, orientacion: Orientacion, intervalo: (Int) -> Int) -> TecladoIsomorfico {
        TecladoIsomorfico(
            nombre: nombre, orientacion: orientacion,
            semitonosEnQ: intervalo(DireccionHexagonal.qMasSMenos.rumbo(orientacion)),
            semitonosEnR: intervalo(DireccionHexagonal.rMasSMenos.rumbo(orientacion)),
            midiDelOrigen: midiDelOrigen)
    }

    /// La altura de una casilla (en afinación igual, sin ortografía: con sostenidos o con bemoles).
    public func altura(en casilla: CoordenadaAxial, preferirBemoles: Bool = false) -> Altura {
        Altura(midi: midi(en: casilla), preferirBemoles: preferirBemoles)
    }

    /// Los semitonos que sube un paso en esa dirección (negativos si baja).
    public func semitonos(hacia direccion: DireccionHexagonal) -> Int {
        semitonosEnQ * direccion.paso.q + semitonosEnR * direccion.paso.r
    }

    /// Las casillas de `region` que suenan a ese número MIDI.
    public func casillas(de midi: Int, en region: some Sequence<CoordenadaAxial>) -> [CoordenadaAxial] {
        region.filter { self.midi(en: $0) == midi }
    }

    /// Las casillas de `region` que suenan a esa altura (las enarmónicas cuentan igual).
    public func casillas(de altura: Altura, en region: some Sequence<CoordenadaAxial>) -> [CoordenadaAxial] {
        casillas(de: altura.midi, en: region)
    }

    /// El teclado dibujado en SVG: un hexágono por casilla con el nombre de su nota y su octava, las teclas
    /// negras del piano en gris y, si se dan, las `marcadas` en el azul de las notas del Tonnetz.
    public func svg(
        _ casillas: [CoordenadaAxial], marcadas: Set<Int> = [], tamano: Double = 24,
        notacion: Notacion = .espanolUnicode, preferirBemoles: Bool = false
    ) -> String {
        let negras: Set<Int> = [1, 3, 6, 8, 10]
        return Trazado(orientacion: orientacion, tamano: tamano).svg(
            casillas,
            relleno: { casilla in
                let midi = self.midi(en: casilla)
                if marcadas.contains(midi) { return DibujoSVG.Color.nota }
                return negras.contains(modulo(midi, 12)) ? "#bbbbbb" : "#f4f4f4"
            },
            rotulo: { casilla in
                let altura = self.altura(en: casilla, preferirBemoles: preferirBemoles)
                return altura.nombreCompacto(en: notacion)
            })
    }
}

extension TecladoIsomorfico: CustomStringConvertible {
    public var description: String {
        "\(nombre): q \(semitonosEnQ >= 0 ? "+" : "")\(semitonosEnQ), r \(semitonosEnR >= 0 ? "+" : "")\(semitonosEnR)"
    }
}

// MARK: - Idiomas
//
// Los nombres de los teclados en los catorce idiomas de los textos. Los textos están en
// `Textos/TextosDeRepresentaciones+Espanol.swift`, `…+Ingles.swift`…, un fichero por idioma.

extension TecladoIsomorfico: Nombrable {
    /// El nombre del teclado en el idioma de los textos: «Tabla armónica», «Harmonic table». Los nombres propios
    /// (Wicki-Hayden, Jankó, Gerhard, Park) y los de un teclado que no es de los de `todos` no cambian.
    public func nombre(en notacion: Notacion) -> String {
        traduccion?.en(notacion) ?? nombre
    }

    /// El nombre en los catorce idiomas; `nil` si es un nombre propio o el teclado no es de los de `todos`.
    package var traduccion: Traduccion? {
        switch self {
        case .tablaArmonica:
            return TextosDeRepresentaciones.traduccion(\.tablaArmonica)
        case .wickiHaydenEspejo:
            return TextosDeRepresentaciones.traduccion(\.wickiHaydenEspejo)
        case .wickiHaydenPlano:
            return TextosDeRepresentaciones.traduccion(\.wickiHaydenPlano)
        case .acordeonC:
            return TextosDeRepresentaciones.traduccion(\.acordeonC)
        case .acordeonB:
            return TextosDeRepresentaciones.traduccion(\.acordeonB)
        default:
            return nil
        }
    }
}
