import ArmoniaNucleo
import ArmoniaTeoria

// Las opciones del pentagrama en SVG (`PentagramaSVG`). El dibujo está en `PentagramaSVG.swift`.
//
// Van en tres grupos: `maquetacion` (claves, pentagramas, líneas, medidas), `marcas` (lo que se escribe o se pinta
// además de las notas) y `colores`. La armadura y la notación van sueltas. Las propiedades sueltas de antes
// (`opciones.color`, `opciones.marcarTonica`…) siguen valiendo: leen y cambian las de su grupo.

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

    /// Dónde y cómo se colocan las notas: las claves, los pentagramas, las líneas y las medidas.
    public struct Maquetacion {
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
        /// Píxeles por espacio de pentagrama: el pentagrama mide cuatro veces esto de alto.
        public var tamano = 10.0
        /// Lo que se multiplica la medida estimada del texto (cifrado y nombres), que sale de una tabla de anchos de
        /// Helvetica y Arial: 1 es lo normal. Sube si la tipografía es más ancha. El texto se escribe con
        /// `textLength`, así que nunca se sale del sitio que se le ha dado, sea cual sea la tipografía.
        public var anchoDeLosCaracteres = 1.0

        public init() {}
    }

    /// Lo que se escribe o se pinta además de las notas.
    public struct Marcas {
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

        public init() {}
    }

    /// Los colores (cualquier color CSS).
    public struct Colores {
        /// El del dibujo; `currentColor` toma el del texto que lo rodea.
        public var dibujo = "currentColor"
        public var tonica = "#1971C2"
        public var notasDePaso = "#2F9E44"
        public var cromaticas = "#C2255C"
        /// El de la nota resaltada.
        public var resaltado = "#E8590C"

        public init() {}
    }

    public var maquetacion = Maquetacion()
    public var marcas = Marcas()
    public var colores = Colores()
    /// Qué armadura se escribe: por defecto, la de la escala si es diatónica; con `.tonalidad`, la de esa tonalidad
    /// también en los acordes, los arpegios y las voces.
    public var armadura: Armadura
    /// Cómo se escriben los nombres (en el título y en las etiquetas) y el cifrado.
    public var notacion: Notacion

    /// Las opciones más usadas de una vez; las demás se cambian después en `maquetacion`, `marcas` y `colores`.
    public init(
        clave: Clave? = nil, armadura: Armadura = .automatica, pentagramas: Pentagramas = .automatico,
        notacion: Notacion = .espanolCompacto,
        nombresDeLasNotas: Bool = false, tamano: Double = 10, color: String = "currentColor",
        marcaDeOctava: Bool = true, anchoDeLosCaracteres: Double = 1,
        disposicionDelAcorde: Disposicion = .automatica, intervalosDeLasNotas: Bool = false,
        marcarSemitonos: Bool = false, marcarTonica: Bool = false
    ) {
        self.armadura = armadura
        self.notacion = notacion
        maquetacion.clave = clave
        maquetacion.pentagramas = pentagramas
        maquetacion.tamano = tamano
        maquetacion.marcaDeOctava = marcaDeOctava
        maquetacion.anchoDeLosCaracteres = anchoDeLosCaracteres
        maquetacion.disposicionDelAcorde = disposicionDelAcorde
        marcas.nombresDeLasNotas = nombresDeLasNotas
        marcas.intervalosDeLasNotas = intervalosDeLasNotas
        marcas.semitonos = marcarSemitonos
        marcas.tonica = marcarTonica
        colores.dibujo = color
    }
}

// Las propiedades sueltas de antes, que leen y cambian las de su grupo.
extension OpcionesDePentagrama {
    /// `maquetacion.clave`.
    public var clave: Clave? {
        get { maquetacion.clave }
        set { maquetacion.clave = newValue }
    }

    /// `maquetacion.pentagramas`.
    public var pentagramas: Pentagramas {
        get { maquetacion.pentagramas }
        set { maquetacion.pentagramas = newValue }
    }

    /// `maquetacion.cambiosDeClave`.
    public var cambiosDeClave: Bool {
        get { maquetacion.cambiosDeClave }
        set { maquetacion.cambiosDeClave = newValue }
    }

    /// `maquetacion.marcaDeOctava`.
    public var marcaDeOctava: Bool {
        get { maquetacion.marcaDeOctava }
        set { maquetacion.marcaDeOctava = newValue }
    }

    /// `maquetacion.disposicionDelAcorde`.
    public var disposicionDelAcorde: Disposicion {
        get { maquetacion.disposicionDelAcorde }
        set { maquetacion.disposicionDelAcorde = newValue }
    }

    /// `maquetacion.compasesPorLinea`.
    public var compasesPorLinea: Int? {
        get { maquetacion.compasesPorLinea }
        set { maquetacion.compasesPorLinea = newValue }
    }

    /// `maquetacion.tamano`.
    public var tamano: Double {
        get { maquetacion.tamano }
        set { maquetacion.tamano = newValue }
    }

    /// `maquetacion.anchoDeLosCaracteres`.
    public var anchoDeLosCaracteres: Double {
        get { maquetacion.anchoDeLosCaracteres }
        set { maquetacion.anchoDeLosCaracteres = newValue }
    }

    /// `marcas.nombresDeLasNotas`.
    public var nombresDeLasNotas: Bool {
        get { marcas.nombresDeLasNotas }
        set { marcas.nombresDeLasNotas = newValue }
    }

    /// `marcas.intervalosDeLasNotas`.
    public var intervalosDeLasNotas: Bool {
        get { marcas.intervalosDeLasNotas }
        set { marcas.intervalosDeLasNotas = newValue }
    }

    /// `marcas.semitonos`.
    public var marcarSemitonos: Bool {
        get { marcas.semitonos }
        set { marcas.semitonos = newValue }
    }

    /// `marcas.tonica`.
    public var marcarTonica: Bool {
        get { marcas.tonica }
        set { marcas.tonica = newValue }
    }

    /// `marcas.notasAjenas`.
    public var marcarNotasAjenas: Bool {
        get { marcas.notasAjenas }
        set { marcas.notasAjenas = newValue }
    }

    /// `marcas.resaltada`.
    public var resaltada: Int? {
        get { marcas.resaltada }
        set { marcas.resaltada = newValue }
    }

    /// `colores.dibujo`.
    public var color: String {
        get { colores.dibujo }
        set { colores.dibujo = newValue }
    }

    /// `colores.tonica`.
    public var colorDeLaTonica: String {
        get { colores.tonica }
        set { colores.tonica = newValue }
    }

    /// `colores.notasDePaso`.
    public var colorDeLasNotasDePaso: String {
        get { colores.notasDePaso }
        set { colores.notasDePaso = newValue }
    }

    /// `colores.cromaticas`.
    public var colorDeLasCromaticas: String {
        get { colores.cromaticas }
        set { colores.cromaticas = newValue }
    }

    /// `colores.resaltado`.
    public var colorResaltado: String {
        get { colores.resaltado }
        set { colores.resaltado = newValue }
    }
}
