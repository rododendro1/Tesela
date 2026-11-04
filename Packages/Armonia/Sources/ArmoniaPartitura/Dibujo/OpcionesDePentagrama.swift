import ArmoniaNucleo
import ArmoniaTeoria

// Las opciones del pentagrama en SVG (`PentagramaSVG`). El dibujo está en `PentagramaSVG.swift`.

/// Cómo se dibuja un pentagrama.
public struct OpcionesDePentagrama {
    /// Cómo se escriben las notas de un acorde.
    public enum Disposicion {
        /// Cerrada, salvo en los acordes que abarcan más de una octava y media (novenas, oncenas y trecenas), que van
        /// en la abierta.
        case automatica
        /// Todas las notas apiladas desde el bajo, lo más juntas posible.
        case cerrada
        /// El bajo solo, una octava más grave, y el resto en posición cerrada encima: la mano izquierda y la derecha
        /// del piano.
        case abierta
    }

    /// Cuántos pentagramas se usan.
    public enum Pentagramas {
        /// Uno; pero dos (el de sol y el de fa, unidos) si la clave no se fija, las notas pasan a los dos lados del
        /// Do central y con uno harían falta más de tres líneas adicionales.
        case automatico
        /// Uno, en la clave de `clave` o en la más adecuada.
        case simple
        /// Dos, el de sol y el de fa; el Do central y lo de encima van en el de sol.
        case doble
    }

    /// Qué armadura se escribe.
    public enum Armadura: Hashable, Sendable {
        /// La de la escala, si es diatónica (la mayor, el dórico…); las demás escalas, los acordes y los arpegios,
        /// sin armadura.
        case automatica
        /// Ninguna: cada alteración se escribe delante de su nota.
        case ninguna
        /// La de una tonalidad, en cualquier dibujo: el arpegio de Sol7 en Do mayor, sin alteraciones; el de Mi7 en
        /// La menor, con el Sol♯ delante de su nota; la menor armónica en La menor, con el Sol♯ de la escala. Las notas
        /// que la armadura no da llevan su alteración, y las que la contradicen, el becuadro.
        case tonalidad(Tonalidad)

        /// Las notas de la armadura para un dibujo; `propia`, la de la escala que se dibuja, si la tiene.
        func notas(propia: [Nota]? = nil) -> [Nota] {
            switch self {
            case .automatica:
                guard let propia, propia.count <= 7 else { return [] }
                return propia
            case .ninguna: return []
            case .tonalidad(let tonalidad): return tonalidad.notasDeLaArmadura
            }
        }
    }

    /// La clave; si es `nil`, la de sol o la de fa, la que necesite menos líneas adicionales (con `pentagramas` en
    /// `.doble`, la clave no cuenta: van las dos).
    public var clave: Clave?
    /// Qué armadura se escribe: por defecto, la de la escala si es diatónica; con `.tonalidad`, la de esa tonalidad
    /// también en los acordes, los arpegios y las voces.
    public var armadura: Armadura
    /// Un pentagrama o dos (el de sol y el de fa): por defecto, dos solo si el rango lo pide.
    public var pentagramas: Pentagramas
    /// Cómo se escriben los nombres (en el título y en las etiquetas) y el cifrado.
    public var notacion: Notacion
    /// Si se escribe el nombre de cada nota debajo del pentagrama.
    public var nombresDeLasNotas: Bool
    /// Si se escribe debajo de cada nota (y del nombre, si lo lleva) su intervalo desde la tónica de la escala o la
    /// fundamental del acorde: 1, 2, ♭3, ♯4, 5… En un acorde con séptima, la segunda, la cuarta y la sexta se
    /// escriben como tensiones: 9, 11, 13.
    public var intervalosDeLasNotas = false
    /// Si se unen con un arco, encima, las notas seguidas que están a un semitono (Mi–Fa y Si–Do en la mayor).
    public var marcarSemitonos = false
    /// Si las tónicas de la escala (o las fundamentales del acorde) se pintan de `colorDeLaTonica`.
    public var marcarTonica = false
    /// El color de las tónicas marcadas (cualquier color CSS).
    public var colorDeLaTonica = "#1971C2"
    /// Con un acorde que suena (el de una progresión o el de `Voz.svgPentagrama(…, acordes:)`), las notas que no son
    /// suyas en color: las de la tonalidad (notas de paso, bordaduras, apoyaturas…) en `colorDeLasNotasDePaso` y las
    /// demás (cromáticas, con la armadura de una tonalidad) en `colorDeLasCromaticas`.
    public var marcarNotasAjenas = false
    public var colorDeLasNotasDePaso = "#2F9E44"
    public var colorDeLasCromaticas = "#C2255C"
    /// Con una sola clave (sin `clave` ni pentagrama doble), cambia entre la de sol y la de fa cuando las notas se
    /// van a tres o más líneas adicionales, con la clave nueva, más pequeña, delante de la nota.
    public var cambiosDeClave = false
    /// Píxeles por espacio de pentagrama: el pentagrama mide cuatro veces esto de alto.
    public var tamano: Double
    /// Color del dibujo (cualquier color CSS); `currentColor` toma el del texto que lo rodea.
    public var color: String
    /// Si una escala o un acorde muy agudo o muy grave, que con una sola clave llevaría más de tres líneas adicionales, se
    /// escribe una octava más cerca del pentagrama con la marca 8va (u 8vb). Solo con la clave sin fijar y un pentagrama.
    public var marcaDeOctava: Bool
    /// Lo que se multiplica la medida estimada del texto (cifrado y nombres), que sale de una tabla de anchos de
    /// Helvetica y Arial: 1 es lo normal. Sube si la tipografía es más ancha. El texto se escribe con `textLength`, así
    /// que nunca se sale del sitio que se le ha dado, sea cual sea la tipografía.
    public var anchoDeLosCaracteres: Double
    /// Cómo se apilan las notas de un acorde.
    public var disposicionDelAcorde: Disposicion
    /// La columna (contada desde 0) que se pinta en `colorResaltado`: la nota o el acorde que está sonando.
    public var resaltada: Int?
    /// El color de la columna resaltada (cualquier color CSS).
    public var colorResaltado = "#E8590C"
    /// En una voz, cuántos compases van en cada línea (sin contar la anacrusa): con más, la voz se parte en líneas
    /// del mismo ancho, una debajo de otra, cada una con su clave y su armadura. `nil`, todo en una línea.
    public var compasesPorLinea: Int?

    public init(
        clave: Clave? = nil, armadura: Armadura = .automatica, pentagramas: Pentagramas = .automatico,
        notacion: Notacion = .espanolCompacto,
        nombresDeLasNotas: Bool = false, tamano: Double = 10, color: String = "currentColor",
        marcaDeOctava: Bool = true, anchoDeLosCaracteres: Double = 1,
        disposicionDelAcorde: Disposicion = .automatica, intervalosDeLasNotas: Bool = false,
        marcarSemitonos: Bool = false, marcarTonica: Bool = false
    ) {
        self.clave = clave
        self.armadura = armadura
        self.pentagramas = pentagramas
        self.notacion = notacion
        self.nombresDeLasNotas = nombresDeLasNotas
        self.tamano = tamano
        self.color = color
        self.marcaDeOctava = marcaDeOctava
        self.anchoDeLosCaracteres = anchoDeLosCaracteres
        self.disposicionDelAcorde = disposicionDelAcorde
        self.intervalosDeLasNotas = intervalosDeLasNotas
        self.marcarSemitonos = marcarSemitonos
        self.marcarTonica = marcarTonica
    }
}
