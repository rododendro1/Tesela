import ArmoniaNucleo

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
    public enum Armadura {
        /// La de la escala, si es diatónica (la mayor, el dórico…); las demás escalas y los acordes, sin armadura.
        case automatica
        /// Ninguna: cada alteración se escribe delante de su nota.
        case ninguna
    }

    /// La clave; si es `nil`, la de sol o la de fa, la que necesite menos líneas adicionales (con `pentagramas` en
    /// `.doble`, la clave no cuenta: van las dos).
    public var clave: Clave?
    public var armadura: Armadura
    /// Un pentagrama o dos (el de sol y el de fa): por defecto, dos solo si el rango lo pide.
    public var pentagramas: Pentagramas
    /// Cómo se escriben los nombres (en el título y en las etiquetas) y el cifrado.
    public var notacion: Notacion
    /// Si se escribe el nombre de cada nota debajo del pentagrama.
    public var nombresDeLasNotas: Bool
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

    public init(
        clave: Clave? = nil, armadura: Armadura = .automatica, pentagramas: Pentagramas = .automatico,
        notacion: Notacion = .espanolCompacto,
        nombresDeLasNotas: Bool = false, tamano: Double = 10, color: String = "currentColor",
        marcaDeOctava: Bool = true, anchoDeLosCaracteres: Double = 1,
        disposicionDelAcorde: Disposicion = .automatica
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
    }
}
