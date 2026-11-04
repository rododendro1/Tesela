import ArmoniaNucleo
import ArmoniaTeoria

// Las opciones del pentagrama en SVG (`PentagramaSVG`). El dibujo está en `PentagramaSVG.swift`.
//
// Van en tres grupos: `maquetacion` (claves, pentagramas, líneas, medidas), `marcas` (lo que se escribe o se pinta
// además de las notas) y `colores`. La armadura y la notación van sueltas.

/// Cómo se dibuja un pentagrama.
public struct OpcionesDePentagrama: Hashable, Sendable {
    /// Cómo se escriben las notas de un acorde.
    public enum Disposicion: Hashable, Sendable {
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
    public enum Pentagramas: Hashable, Sendable {
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

    /// Dónde y cómo se colocan las notas: las claves, los pentagramas, las líneas y las medidas.
    public struct Maquetacion: Hashable, Sendable {
        /// La clave; si es `nil`, la de sol o la de fa, la que necesite menos líneas adicionales (con `pentagramas`
        /// en `.doble`, la clave no cuenta: van las dos).
        public var clave: Clave?
        /// Un pentagrama o dos (el de sol y el de fa): por defecto, dos solo si el rango lo pide.
        public var pentagramas: Pentagramas = .automatico
        /// Con una sola clave (sin `clave` ni pentagrama doble), cambia entre la de sol y la de fa cuando las notas
        /// se van a tres o más líneas adicionales, con la clave nueva, más pequeña, delante de la nota.
        public var cambiosDeClave = false
        /// Si una escala o un acorde muy agudo o muy grave, que con una sola clave llevaría más de tres líneas
        /// adicionales, se escribe una octava más cerca del pentagrama con la marca 8va (u 8vb). Solo con la clave
        /// sin fijar y un pentagrama.
        public var marcaDeOctava = true
        /// Cómo se apilan las notas de un acorde.
        public var disposicionDelAcorde: Disposicion = .automatica
        /// En una voz, cuántos compases van en cada línea (sin contar la anacrusa): con más, la voz se parte en
        /// líneas del mismo ancho, una debajo de otra, cada una con su clave y su armadura. `nil`, todo en una línea.
        public var compasesPorLinea: Int?
        /// Lo que se multiplica la medida estimada del texto (cifrado y nombres), que sale de una tabla de anchos de
        /// Helvetica y Arial: 1 es lo normal. Sube si la tipografía es más ancha. El texto se escribe con
        /// `textLength`, así que nunca se sale del sitio que se le ha dado, sea cual sea la tipografía.
        public var anchoDeLosCaracteres = 1.0

        /// La maquetación con lo que se dé; lo demás, por omisión.
        public init(
            clave: Clave? = nil, pentagramas: Pentagramas = .automatico, cambiosDeClave: Bool = false,
            marcaDeOctava: Bool = true, disposicionDelAcorde: Disposicion = .automatica, compasesPorLinea: Int? = nil,
            anchoDeLosCaracteres: Double = 1
        ) {
            self.clave = clave
            self.pentagramas = pentagramas
            self.cambiosDeClave = cambiosDeClave
            self.marcaDeOctava = marcaDeOctava
            self.disposicionDelAcorde = disposicionDelAcorde
            self.compasesPorLinea = compasesPorLinea
            self.anchoDeLosCaracteres = anchoDeLosCaracteres
        }
    }

    /// Lo que se escribe o se pinta además de las notas.
    public struct Marcas: Hashable, Sendable {
        /// El nombre de cada nota, debajo del pentagrama.
        public var nombresDeLasNotas = false
        /// Debajo de cada nota (y del nombre, si lo lleva), su intervalo desde la tónica de la escala o la
        /// fundamental del acorde: 1, 2, ♭3, ♯4, 5… En un acorde con séptima, la segunda, la cuarta y la sexta se
        /// escriben como tensiones: 9, 11, 13.
        public var intervalosDeLasNotas = false
        /// Un arco, encima, entre las notas seguidas que están a un semitono (Mi–Fa y Si–Do en la mayor).
        public var semitonos = false
        /// Las tónicas de la escala (o las fundamentales del acorde), en `Colores.tonica`.
        public var tonica = false
        /// Con un acorde que suena (el de una progresión o los cifrados de una `Partitura.Linea`), las notas que no
        /// son suyas en color: las de la tonalidad (notas de paso, bordaduras, apoyaturas…) en `Colores.notasDePaso`
        /// y las demás (cromáticas, con la armadura de una tonalidad) en `Colores.cromaticas`.
        public var notasAjenas = false
        /// La columna (contada desde 0) que se pinta en `Colores.resaltado`: la nota o el acorde que está sonando.
        public var resaltada: Int?
        /// Los cifrados de los acordes, encima (los de la partitura, ``Partitura/Linea/cifrados``). Sin ellos, los
        /// acordes siguen contando para los intervalos y las notas ajenas.
        public var cifrados = true

        /// Las marcas que se pidan; ninguna, por omisión.
        public init(
            nombresDeLasNotas: Bool = false, intervalosDeLasNotas: Bool = false, semitonos: Bool = false,
            tonica: Bool = false, notasAjenas: Bool = false, resaltada: Int? = nil, cifrados: Bool = true
        ) {
            self.nombresDeLasNotas = nombresDeLasNotas
            self.intervalosDeLasNotas = intervalosDeLasNotas
            self.semitonos = semitonos
            self.tonica = tonica
            self.notasAjenas = notasAjenas
            self.resaltada = resaltada
            self.cifrados = cifrados
        }
    }

    /// Los colores (cualquier color CSS).
    public struct Colores: Hashable, Sendable {
        /// El del dibujo; `currentColor` toma el del texto que lo rodea.
        public var dibujo = "currentColor"
        public var tonica = "#1971C2"
        public var notasDePaso = "#2F9E44"
        public var cromaticas = "#C2255C"
        /// El de la nota resaltada.
        public var resaltado = "#E8590C"

        /// Los colores que se den; los demás, los de siempre.
        public init(
            dibujo: String = "currentColor", tonica: String = "#1971C2", notasDePaso: String = "#2F9E44",
            cromaticas: String = "#C2255C", resaltado: String = "#E8590C"
        ) {
            self.dibujo = dibujo
            self.tonica = tonica
            self.notasDePaso = notasDePaso
            self.cromaticas = cromaticas
            self.resaltado = resaltado
        }
    }

    public var maquetacion: Maquetacion
    public var marcas: Marcas
    public var colores: Colores
    /// Qué armadura se escribe: por defecto, la de la escala si es diatónica; con `.tonalidad`, la de esa tonalidad
    /// también en los acordes, los arpegios y las voces.
    public var armadura: Armadura
    /// La notación que fijan las opciones; si es `nil`, la de lo que se dibuja (``Partitura/notacion``) o, si no
    /// tiene, la española compacta.
    public var notacionFijada: Notacion?
    /// Cómo se escriben los nombres (en el título y en las etiquetas) y el cifrado: `notacionFijada` o, si no la
    /// hay, la española compacta. Darle un valor la fija.
    public var notacion: Notacion {
        get { notacionFijada ?? .espanolCompacto }
        set { notacionFijada = newValue }
    }
    /// El título: si es `nil`, el de lo que se dibuja (el de la partitura, el nombre de la escala, el cifrado del
    /// acorde); si es "", ninguno.
    public var titulo: String?
    /// El tamaño, como factor del de siempre (10 píxeles por espacio de pentagrama, así que el pentagrama mide 40 de
    /// alto): 2 lo dibuja el doble de grande.
    public var escala: Double

    /// Píxeles por espacio de pentagrama.
    var pixelesPorEspacio: Double { 10 * escala }

    /// Las opciones, por grupos:
    /// `OpcionesDePentagrama(notacion: .inglesASCII, marcas: .init(nombresDeLasNotas: true))`. Sin `notacion`, la de
    /// la partitura que se dibuja (``Partitura/notacion``).
    public init(
        armadura: Armadura = .automatica, notacion: Notacion? = nil, titulo: String? = nil, escala: Double = 1,
        maquetacion: Maquetacion = .init(), marcas: Marcas = .init(), colores: Colores = .init()
    ) {
        self.armadura = armadura
        self.notacionFijada = notacion
        self.titulo = titulo
        self.escala = escala
        self.maquetacion = maquetacion
        self.marcas = marcas
        self.colores = colores
    }
}
