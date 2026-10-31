import ArmoniaNucleo
import ArmoniaTeoria
import Foundation

// Un pentagrama en SVG, para escalas y acordes: redondas sobre cinco líneas, con clave, armadura, alteraciones,
// líneas adicionales y, en los acordes, las segundas desplazadas. No hay ritmo, vigas ni varias voces: para
// partituras completas, el MEI o el MusicXML de `Formatos/` y un motor como Verovio.
//
// Las medidas están en espacios de pentagrama (1 = la distancia entre dos líneas) y el eje y baja, como en SVG:
// la línea de arriba está en y = 0 y la de abajo en y = 4. Los glifos son los de Bravura (`GlifosSMuFL`).

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
        notacion: Notacion = .espanolUnicode,
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

extension Escala {
    /// La escala en un pentagrama, como SVG: `Escala("Re dórico").svgPentagrama()`.
    ///
    /// - Parameters:
    ///   - octava: la octava de la tónica.
    ///   - sentido: si se da, solo la subida o la bajada; si es `nil`, la subida y, en las escalas que bajan con
    ///     otras notas (la menor melódica), también la bajada.
    ///   - opciones: clave, armadura, notación, tamaño y color.
    public func svgPentagrama(
        octava: Int = 4, sentido: SentidoDelIntervalo? = nil,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        let alturas: [Altura]
        switch sentido {
        case .ascendente?: alturas = self.alturas(octava: octava)
        case .descendente?: alturas = self.alturas(octava: octava, sentido: .descendente)
        case nil:
            let subida = self.alturas(octava: octava)
            alturas =
                tipo.esDireccional ? subida + self.alturas(octava: octava, sentido: .descendente).dropFirst() : subida
        }
        var armadura: [Nota] = []
        if opciones.armadura == .automatica, let propia = notasDeLaArmadura, propia.count <= 7 { armadura = propia }
        return PentagramaSVG(
            columnas: alturas.map { [$0] }, armadura: armadura, cifrado: nil,
            titulo: nombre(en: opciones.notacion), opciones: opciones
        ).svg()
    }
}

extension Acorde {
    /// El acorde en un pentagrama, como SVG: `Acorde("Sol7").svgPentagrama()`. Las notas van apiladas desde el bajo,
    /// en posición cerrada y a partir de `octava` (el bajo, en la primera octava en que su nota alcanza el Do de esa
    /// octava), con el cifrado encima. Los acordes muy extensos y `disposicionDelAcorde: .abierta` ponen el bajo una
    /// octava más grave y el resto encima, y con eso suelen pasar al pentagrama doble.
    public func svgPentagrama(
        octava: Int = 4, cifrado conCifrado: Bool = true,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        let cerrada = Exportacion.posicionCerrada(notasDesdeElBajo, desde: Altura(.do, octava: octava).midi)
        let abierta: Bool
        switch opciones.disposicionDelAcorde {
        case .cerrada: abierta = false
        case .abierta: abierta = true
        case .automatica: abierta = (cerrada.last.map(\.midi) ?? 0) - (cerrada.first.map(\.midi) ?? 0) >= 17
        }
        var alturas = cerrada
        if abierta, let bajo = notasDesdeElBajo.first, notasDesdeElBajo.count > 1 {
            alturas =
                Exportacion.posicionCerrada([bajo], desde: Altura(.do, octava: octava - 1).midi)
                + Exportacion.posicionCerrada(
                    Array(notasDesdeElBajo.dropFirst()), desde: Altura(.do, octava: octava).midi)
        }
        let texto = cifrado(en: opciones.notacion)
        return PentagramaSVG(
            columnas: [alturas], armadura: [], cifrado: conCifrado ? texto : nil,
            titulo: texto, opciones: opciones
        ).svg()
    }
}

extension Arpegio {
    /// El arpegio en un pentagrama, como SVG: `Arpegio("Do7").svgPentagrama()`. Cada nota, en el orden del patrón y
    /// a partir de `octava` (la del bajo), va en su columna, con las alteraciones que le hagan falta (no lleva
    /// armadura) y su nombre en un `<title>`; el título de la imagen es el nombre del arpegio.
    public func svgPentagrama(octava: Int = 4, opciones: OpcionesDePentagrama = OpcionesDePentagrama()) -> String {
        PentagramaSVG(
            columnas: alturas(octava: octava).map { [$0] }, armadura: [], cifrado: nil,
            titulo: nombre(en: opciones.notacion), opciones: opciones
        ).svg()
    }
}

/// El dibujo: columnas de notas (una nota por columna en una escala, todas las de un acorde en una sola).
struct PentagramaSVG {
    let columnas: [[Altura]]
    let armadura: [Nota]
    let cifrado: String?
    let titulo: String
    let opciones: OpcionesDePentagrama

    /// Cuerpo de la letra del cifrado y de los nombres de las notas, en espacios de pentagrama.
    private static let letraDelCifrado = 1.9
    private static let letraDeLasEtiquetas = 1.2

    /// Lo que mide cada carácter, en partes del cuerpo de la letra, en Helvetica y Arial.
    private static let anchosDeLosCaracteres: [Character: Double] = {
        let grupos: [(String, Double)] = [
            ("ijl", 0.222), ("ft", 0.278), ("r", 0.333), ("abdeghnopqu", 0.556), ("ckvxyzs", 0.5), ("m", 0.833),
            ("w", 0.722), ("I", 0.278), ("J", 0.5), ("L", 0.556), ("FTZ", 0.611), ("ABEKPSVXY", 0.667),
            ("CDHNRU", 0.722), ("GOQ", 0.778), ("M", 0.833), ("W", 0.944), ("0123456789#", 0.556),
            (" ./,:;", 0.278), ("()-", 0.333), ("+", 0.584), ("♭♯♮", 0.5), ("°", 0.4),
        ]
        var tabla: [Character: Double] = [:]
        for (letras, ancho) in grupos { for letra in letras { tabla[letra] = ancho } }
        return tabla
    }()

    /// Lo que mide un texto: la suma de sus caracteres (sin tildes; lo que no está en la tabla, el cirílico y el griego,
    /// vale 0,55, o 0,72 si es mayúscula) por el cuerpo de la letra y por `proporcion`.
    static func anchoEstimado(_ texto: String, cuerpoDeLetra: Double, proporcion: Double) -> Double {
        let base = texto.folding(options: .diacriticInsensitive, locale: nil)
        let suma = base.reduce(0.0) { $0 + (anchosDeLosCaracteres[$1] ?? ($1.isUppercase ? 0.72 : 0.55)) }
        return suma * cuerpoDeLetra * proporcion
    }

    private static let anchoDeLaRedonda = GlifosSMuFL.redonda.ancho
    /// Lo que se deja entre dos columnas de alteraciones.
    private static let huecoEntreColumnasDeAlteraciones = 0.12
    /// Lo que como mínimo separa, de arriba abajo, dos alteraciones de la misma columna.
    private static let huecoVerticalEntreAlteraciones = 0.1
    private static let separacionEntreColumnas = 1.5

    /// Una nota ya colocada: dónde va y qué alteración lleva delante.
    private struct NotaColocada {
        let altura: Altura
        let lugar: Int
        var desplazada = false
        var alteracion: Glifo?
        var columnaDeAlteracion = 0
    }

    /// La altura escrita en el pentagrama: `octavas` octavas más grave (o más aguda, si es negativo) de la que suena.
    static func escrita(_ altura: Altura, octavas: Int) -> Altura {
        octavas == 0 ? altura : Altura(altura.nota, octava: altura.octava - octavas)
    }

    /// Lo que separa el pentagrama de arriba del de abajo en el pentagrama doble: la línea de abajo del primero está
    /// en y = 4 y la de arriba del segundo en y = 10.
    static let separacionDelPentagramaDoble = 10.0
    /// Lo que se deja a la izquierda del pentagrama doble para la llave.
    static let margenDeLaLlave = 1.9
    /// A partir de cuántas líneas adicionales se pasa al pentagrama doble, si no se pide otra cosa.
    static let lineasAdicionalesParaElPentagramaDoble = 3
    /// Lo que como mínimo separa dos etiquetas de notas.
    static let separacionEntreEtiquetas = 0.5

    /// Las claves que se usan: una, o sol y fa si el pentagrama es doble.
    private func clavesDelPentagrama() -> [Clave] {
        switch opciones.pentagramas {
        case .doble: return [.sol, .fa]
        case .simple: return [opciones.clave ?? Clave.masAdecuada(para: columnas.flatMap { $0 }) ?? .sol]
        case .automatico:
            let elegida = opciones.clave ?? Clave.masAdecuada(para: columnas.flatMap { $0 }) ?? .sol
            guard opciones.clave == nil else { return [elegida] }
            // Solo si el rango pasa a los dos lados del Do central: si todo está en un lado, el otro pentagrama iría vacío.
            let todas = columnas.flatMap { $0 }
            let doCentral = Altura(.do, octava: 4).midi
            let enLosDosLados = todas.contains { $0.midi < doCentral } && todas.contains { $0.midi >= doCentral }
            let lineas =
                todas.map { PentagramaSVG.lugaresDeLasLineasAdicionales(de: elegida.posicion(de: $0).lugar).count }
                .max() ?? 0
            return enLosDosLados && lineas > PentagramaSVG.lineasAdicionalesParaElPentagramaDoble
                ? [.sol, .fa] : [elegida]
        }
    }

    func svg() -> String {
        let claves = clavesDelPentagrama()
        let color = PentagramaSVG.escapar(opciones.color)
        let resaltado = " fill=\"\(PentagramaSVG.escapar(opciones.colorResaltado))\""
        let doble = claves.count == 2

        // Una octava más cerca del pentagrama, con la marca 8va u 8vb, si con la clave elegida harían falta demasiadas
        // líneas adicionales: `octavas[k]` > 0 escribe las notas del pentagrama `k` una octava más grave de lo que
        // suenan (8va, encima del pentagrama de arriba); < 0, una más aguda (8vb, debajo del de abajo).
        let doCentral = Altura(.do, octava: 4).midi
        var octavas = [Int](repeating: 0, count: claves.count)
        if opciones.marcaDeOctava, opciones.clave == nil || doble {
            for k in claves.indices {
                let suyas = columnas.flatMap { $0 }.filter { !doble || ($0.midi >= doCentral) == (k == 0) }
                func lineas(_ octavas: Int) -> Int {
                    suyas.map {
                        PentagramaSVG.lugaresDeLasLineasAdicionales(
                            de: claves[k].posicion(de: PentagramaSVG.escrita($0, octavas: octavas)).lugar
                        ).count
                    }.max() ?? 0
                }
                let sinMarca = lineas(0)
                guard sinMarca > PentagramaSVG.lineasAdicionalesParaElPentagramaDoble else { continue }
                // Con dos pentagramas, el de arriba solo lleva 8va y el de abajo solo 8vb.
                let candidatas = doble ? (k == 0 ? [1] : [-1]) : [1, -1]
                let mejor = candidatas.min { lineas($0) < lineas($1) } ?? 0
                if lineas(mejor) < sinMarca { octavas[k] = mejor }
            }
        }

        var cuerpo: [String] = [] // las claves y las armaduras
        var notasSVG: [String] = [] // las notas: se desplazan si el texto de encima o de debajo es más ancho
        var x = 0.6
        // Lo que sube y baja el dibujo, para el alto de la imagen.
        var minimoY = 0.0
        var maximoY = doble ? 4.0 + PentagramaSVG.separacionDelPentagramaDoble : 4.0
        func incluir(_ glifo: Glifo, lugar: Int, pentagrama: Int) {
            let y = PentagramaSVG.y(deLugar: lugar, pentagrama: pentagrama)
            minimoY = min(minimoY, y + glifo.arriba)
            maximoY = max(maximoY, y + glifo.abajo)
        }

        // Claves.
        var anchoDeLasClaves = 0.0
        for (k, clave) in claves.enumerated() {
            let (glifoDeClave, lugarDeClave) = PentagramaSVG.glifoYLugar(de: clave)
            incluir(glifoDeClave, lugar: lugarDeClave, pentagrama: k)
            cuerpo.append(PentagramaSVG.glifo(glifoDeClave, x: x, lugar: lugarDeClave, pentagrama: k))
            anchoDeLasClaves = max(anchoDeLasClaves, glifoDeClave.ancho)
        }
        x += anchoDeLasClaves + 1.0

        // Armadura.
        let sostenidos = armadura.first.map { $0.alteracion.semitonos > 0 } ?? true
        var vigentes: [NotaNatural: Int] = [:]
        let glifoDeLaArmadura = sostenidos ? GlifosSMuFL.sostenido : GlifosSMuFL.bemol
        for nota in armadura {
            for (k, clave) in claves.enumerated() {
                let lugar = PentagramaSVG.lugarEnLaArmadura(nota, clave: clave, sostenidos: sostenidos)
                incluir(glifoDeLaArmadura, lugar: lugar, pentagrama: k)
                cuerpo.append(PentagramaSVG.glifo(glifoDeLaArmadura, x: x, lugar: lugar, pentagrama: k))
            }
            x += glifoDeLaArmadura.ancho + 0.15
            vigentes[nota.natural] = nota.alteracion.semitonos
        }
        // Un pequeño espacio entre la clave (o la armadura) y la primera nota.
        x += armadura.isEmpty ? 0.8 : 0.9

        // Notas, columna a columna. En el pentagrama doble, del Do central para arriba van en el de sol.
        var enVigor: [Int: Int] = [:] // altura diatónica (letra y octava) → alteración vigente
        var etiquetas: [(x: Double, texto: String)] = []
        var cifradoX: Double?
        // Por pentagrama: dónde empiezan y acaban sus notas y lo que suben y bajan, para la marca de octava.
        var primeraX = [Double?](repeating: nil, count: claves.count)
        var ultimaX = [Double](repeating: 0, count: claves.count)
        var arribaDeLasNotas = [Double](repeating: .infinity, count: claves.count)
        var abajoDeLasNotas = [Double](repeating: -.infinity, count: claves.count)
        var ultimaEtiqueta: (centro: Double, mitad: Double)?
        var lineasAdicionales: [(pentagrama: Int, lugar: Int, desde: Double, hasta: Double)] = []
        for (columna, alturas) in columnas.enumerated() {
            var grupos: [[NotaColocada]] = []
            for k in claves.indices {
                let delPentagrama = alturas.filter { !doble || ($0.midi >= doCentral) == (k == 0) }
                grupos.append(
                    delPentagrama.map {
                        NotaColocada(
                            altura: $0,
                            lugar: claves[k].posicion(de: PentagramaSVG.escrita($0, octavas: octavas[k])).lugar)
                    }
                    .sorted { ($0.lugar, $0.altura.midi) < ($1.lugar, $1.altura.midi) })
            }
            // Lo que mide de ancho cada columna de alteraciones (la más ancha de sus glifos).
            var anchosDeLasColumnas: [Double] = []
            for k in grupos.indices {
                // Las segundas (y los unísonos con otra alteración) se desplazan a la derecha.
                for i in grupos[k].indices.dropFirst()
                where !grupos[k][i - 1].desplazada && grupos[k][i].lugar - grupos[k][i - 1].lugar <= 1 {
                    grupos[k][i].desplazada = true
                }
                // Alteraciones: las que no da la armadura, en columnas a la izquierda sin pisarse.
                var fondoDeLaColumna: [Double] = [] // hasta dónde baja el último glifo de cada columna
                for i in grupos[k].indices.reversed() {
                    let semitonos = grupos[k][i].altura.nota.alteracion.semitonos
                    // Lo que vale en esa línea o espacio: lo último que se escribió o, si nada, la armadura. Así la
                    // bajada de la menor melódica lleva los becuadros que anulan los ♯ de la subida.
                    let pasos = grupos[k][i].altura.pasos
                    guard semitonos != (enVigor[pasos] ?? vigentes[grupos[k][i].altura.nota.natural] ?? 0) else {
                        continue
                    }
                    enVigor[pasos] = semitonos
                    let glifo = PentagramaSVG.glifoDeAlteracion(semitonos)
                    grupos[k][i].alteracion = glifo
                    // Va a la primera columna cuyo último glifo no se le monta por arriba: un bemol baja menos que un
                    // sostenido, así que caben más juntos.
                    let y = PentagramaSVG.y(deLugar: grupos[k][i].lugar)
                    var columna = 0
                    while columna < fondoDeLaColumna.count,
                        fondoDeLaColumna[columna] + PentagramaSVG.huecoVerticalEntreAlteraciones > y + glifo.arriba
                    { columna += 1 }
                    if columna == fondoDeLaColumna.count {
                        fondoDeLaColumna.append(y + glifo.abajo)
                    } else {
                        fondoDeLaColumna[columna] = y + glifo.abajo
                    }
                    grupos[k][i].columnaDeAlteracion = columna
                    let anchoDelGlifo = grupos[k][i].alteracion?.ancho ?? 0
                    if columna == anchosDeLasColumnas.count {
                        anchosDeLasColumnas.append(anchoDelGlifo)
                    } else {
                        anchosDeLasColumnas[columna] = max(anchosDeLasColumnas[columna], anchoDelGlifo)
                    }
                }
            }
            let izquierda =
                anchosDeLasColumnas.reduce(0, +) + PentagramaSVG.huecoEntreColumnasDeAlteraciones
                * Double(max(0, anchosDeLasColumnas.count - 1))
            var xDeLaNota = x + izquierda + (anchosDeLasColumnas.isEmpty ? 0 : 0.1)
            let hayDesplazadas = grupos.contains { $0.contains(where: \.desplazada) }
            let ancho = PentagramaSVG.anchoDeLaRedonda * (hayDesplazadas ? 2 : 1)
            let etiqueta: String? =
                opciones.nombresDeLasNotas
                ? (columnas.count == 1
                    ? alturas.map { $0.nombre(en: opciones.notacion) }.joined(separator: " ")
                    : alturas[0].nombre(en: opciones.notacion))
                : nil
            // Las etiquetas de las notas no se pisan: si la de esta columna cae demasiado cerca de la anterior, la
            // columna se corre a la derecha.
            let mitadDeLaEtiqueta =
                (etiqueta.map {
                    PentagramaSVG.anchoEstimado(
                        $0, cuerpoDeLetra: PentagramaSVG.letraDeLasEtiquetas, proporcion: opciones.anchoDeLosCaracteres)
                } ?? 0) / 2
            if columnas.count > 1, etiqueta != nil, let anterior = ultimaEtiqueta {
                let centroMinimo =
                    anterior.centro + anterior.mitad + mitadDeLaEtiqueta + PentagramaSVG.separacionEntreEtiquetas
                xDeLaNota += max(0, centroMinimo - (xDeLaNota + ancho / 2))
            }

            for (k, notas) in grupos.enumerated() {
                if !notas.isEmpty {
                    if primeraX[k] == nil { primeraX[k] = xDeLaNota }
                    ultimaX[k] = xDeLaNota + ancho
                }
                for nota in notas {
                    let xn = xDeLaNota + (nota.desplazada ? PentagramaSVG.anchoDeLaRedonda : 0)
                    var partes: [String] = []
                    if let alteracion = nota.alteracion {
                        // Cada columna, pegada a la anterior por su borde derecho; la primera, junto a la nota.
                        let anchoDeLasMasCercanas =
                            anchosDeLasColumnas.prefix(nota.columnaDeAlteracion).reduce(0, +)
                            + PentagramaSVG.huecoEntreColumnasDeAlteraciones * Double(nota.columnaDeAlteracion)
                        let xa = xDeLaNota - 0.1 - anchoDeLasMasCercanas - alteracion.ancho
                        incluir(alteracion, lugar: nota.lugar, pentagrama: k)
                        partes.append(PentagramaSVG.glifo(alteracion, x: xa, lugar: nota.lugar, pentagrama: k))
                    }
                    incluir(GlifosSMuFL.redonda, lugar: nota.lugar, pentagrama: k)
                    arribaDeLasNotas[k] = min(arribaDeLasNotas[k], PentagramaSVG.y(deLugar: nota.lugar, pentagrama: k))
                    abajoDeLasNotas[k] = max(abajoDeLasNotas[k], PentagramaSVG.y(deLugar: nota.lugar, pentagrama: k))
                    partes.append(PentagramaSVG.glifo(GlifosSMuFL.redonda, x: xn, lugar: nota.lugar, pentagrama: k))
                    let nombre = nota.altura.nombre(en: opciones.notacion)
                    let relleno = opciones.resaltada == columna ? resaltado : ""
                    notasSVG.append(
                        "<g\(relleno)><title>\(PentagramaSVG.escapar(nombre))</title>\(partes.joined())</g>")
                    for lugar in PentagramaSVG.lugaresDeLasLineasAdicionales(de: nota.lugar) {
                        lineasAdicionales.append((k, lugar, xn - 0.4, xn + PentagramaSVG.anchoDeLaRedonda + 0.4))
                    }
                }
            }
            let centro = xDeLaNota + ancho / 2
            if cifradoX == nil { cifradoX = centro }
            if let etiqueta {
                etiquetas.append((centro, etiqueta))
                ultimaEtiqueta = (centro, mitadDeLaEtiqueta)
            }
            x = xDeLaNota + ancho + PentagramaSVG.separacionEntreColumnas
        }
        var final = x - PentagramaSVG.separacionEntreColumnas + 0.9

        // La marca 8va (encima) u 8vb (debajo), con su línea de puntos hasta la última nota.
        var marcaSVG: [String] = []
        for k in claves.indices where octavas[k] != 0 {
            guard let inicio = primeraX[k] else { continue }
            let arriba = octavas[k] > 0
            let y =
                arriba
                ? min(arribaDeLasNotas[k] - 1.5, PentagramaSVG.y(deLugar: 8, pentagrama: k) - 0.8)
                : max(abajoDeLasNotas[k] + 2.6, PentagramaSVG.y(deLugar: 0, pentagrama: k) + 2.0)
            let rotulo = arriba ? "8va" : "8vb"
            let finDelRotulo =
                inicio - 0.3
                + PentagramaSVG.anchoEstimado(rotulo, cuerpoDeLetra: 1.4, proporcion: opciones.anchoDeLosCaracteres)
            let yDeLaLinea = y - 0.45
            let gancho = arriba ? yDeLaLinea + 1.0 : yDeLaLinea - 1.0
            marcaSVG.append(
                "<text x=\"\(PentagramaSVG.n(inicio - 0.3))\" y=\"\(PentagramaSVG.n(y))\" font-size=\"1.4\" font-style=\"italic\" font-family=\"sans-serif\" fill=\"\(color)\" stroke=\"none\">\(rotulo)</text>"
            )
            // Con una sola columna (un acorde) no hay línea de puntos: solo el rótulo.
            if ultimaX[k] - (finDelRotulo + 0.3) > 1.0 {
                marcaSVG.append(
                    "<path d=\"M\(PentagramaSVG.n(finDelRotulo + 0.3)) \(PentagramaSVG.n(yDeLaLinea)) H\(PentagramaSVG.n(ultimaX[k])) V\(PentagramaSVG.n(gancho))\" stroke-dasharray=\"0.5 0.35\"/>"
                )
            }
            if arriba { minimoY = min(minimoY, y - 1.2) } else { maximoY = max(maximoY, y + 0.3) }
        }

        // Un cifrado o los nombres de un acorde pueden ser más anchos que el acorde: el pentagrama se alarga a la derecha
        // y, si el texto sobresale por la izquierda, las notas se desplazan.
        let proporcion = opciones.anchoDeLosCaracteres
        let anchoDelTexto = max(
            cifrado.map {
                PentagramaSVG.anchoEstimado($0, cuerpoDeLetra: PentagramaSVG.letraDelCifrado, proporcion: proporcion)
            } ?? 0,
            columnas.count == 1
                ? etiquetas.first.map {
                    PentagramaSVG.anchoEstimado(
                        $0.texto, cuerpoDeLetra: PentagramaSVG.letraDeLasEtiquetas, proporcion: proporcion)
                } ?? 0 : 0)
        let centroDelTexto = cifradoX ?? 0
        let desplazamiento = max(0, anchoDelTexto / 2 + 0.2 - centroDelTexto)
        final = max(final + desplazamiento, centroDelTexto + desplazamiento + anchoDelTexto / 2 + 0.6)

        // Medidas verticales: del punto más alto al más bajo, con las claves, las alteraciones y las notas.
        let cima = cifrado == nil ? minimoY - 0.4 : minimoY - 2.6
        let fondo = opciones.nombresDeLasNotas ? maximoY + 2.4 : maximoY + 0.4
        // En el pentagrama doble, una llave a la izquierda, con el margen que pide.
        let margen = doble ? PentagramaSVG.margenDeLaLlave : 0
        let ancho = final + 0.6 + margen
        let alto = fondo - cima

        var lineas: [String] = []
        for k in claves.indices {
            for i in 0..<5 {
                let y = PentagramaSVG.n(PentagramaSVG.y(deLugar: 8 - 2 * i, pentagrama: k))
                lineas.append(
                    "<line x1=\"0\" y1=\"\(y)\" x2=\"\(PentagramaSVG.n(final))\" y2=\"\(y)\" stroke-width=\"0.13\"/>")
            }
        }
        // Barra del principio (si hay dos pentagramas, una sola que los une) y barra final.
        let abajoDelSistema = PentagramaSVG.y(deLugar: 0, pentagrama: claves.count - 1)
        lineas.append(
            "<line x1=\"0\" y1=\"0\" x2=\"0\" y2=\"\(PentagramaSVG.n(abajoDelSistema))\" stroke-width=\"0.16\"/>")
        lineas.append(
            "<line x1=\"\(PentagramaSVG.n(final))\" y1=\"0\" x2=\"\(PentagramaSVG.n(final))\" y2=\"\(PentagramaSVG.n(abajoDelSistema))\" stroke-width=\"0.16\"/>"
        )
        // La llave de Bravura, estirada de sus 4 espacios a lo que miden los dos pentagramas (14).
        let llave =
            doble
            ? "<path transform=\"translate(\(PentagramaSVG.n(-PentagramaSVG.margenDeLaLlave + 0.3)) \(PentagramaSVG.n(abajoDelSistema))) scale(\(PentagramaSVG.n(abajoDelSistema / 4)))\" d=\"\(GlifosSMuFL.llave.trazado)\"/>"
            : ""
        var adicionalesSVG: [String] = []
        for linea in lineasAdicionales {
            let y = PentagramaSVG.n(PentagramaSVG.y(deLugar: linea.lugar, pentagrama: linea.pentagrama))
            adicionalesSVG.append(
                "<line x1=\"\(PentagramaSVG.n(linea.desde))\" y1=\"\(y)\" x2=\"\(PentagramaSVG.n(linea.hasta))\" y2=\"\(y)\" stroke-width=\"0.16\"/>"
            )
        }

        var textos: [String] = []
        if let cifrado, let cx = cifradoX {
            textos.append(
                "<text x=\"\(PentagramaSVG.n(cx))\" y=\"\(PentagramaSVG.n(minimoY - 0.6))\" text-anchor=\"middle\" font-size=\"\(PentagramaSVG.letraDelCifrado)\" lengthAdjust=\"spacingAndGlyphs\" textLength=\"\(PentagramaSVG.n(PentagramaSVG.anchoEstimado(cifrado, cuerpoDeLetra: PentagramaSVG.letraDelCifrado, proporcion: proporcion)))\" font-family=\"sans-serif\">\(PentagramaSVG.escapar(cifrado))</text>"
            )
        }
        for etiqueta in etiquetas {
            textos.append(
                "<text x=\"\(PentagramaSVG.n(etiqueta.x))\" y=\"\(PentagramaSVG.n(maximoY + 1.6))\" text-anchor=\"middle\" font-size=\"\(PentagramaSVG.letraDeLasEtiquetas)\" lengthAdjust=\"spacingAndGlyphs\" textLength=\"\(PentagramaSVG.n(PentagramaSVG.anchoEstimado(etiqueta.texto, cuerpoDeLetra: PentagramaSVG.letraDeLasEtiquetas, proporcion: proporcion)))\" font-family=\"sans-serif\">\(PentagramaSVG.escapar(etiqueta.texto))</text>"
            )
        }

        let descripcion = columnas.flatMap { $0 }.map { $0.nombre(en: opciones.notacion) }.joined(separator: ", ")
        let pxAncho = PentagramaSVG.n(ancho * opciones.tamano)
        let pxAlto = PentagramaSVG.n(alto * opciones.tamano)
        return """
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="\(PentagramaSVG.n(-margen)) \(PentagramaSVG.n(cima)) \(PentagramaSVG.n(ancho)) \(PentagramaSVG.n(alto))" width="\(pxAncho)" height="\(pxAlto)" role="img" aria-labelledby="titulo descripcion">
            <title id="titulo">\(PentagramaSVG.escapar(titulo))</title>
            <desc id="descripcion">\(PentagramaSVG.escapar(descripcion))</desc>
            <g stroke="\(color)" fill="none">
            \(lineas.joined(separator: "\n"))
            </g>
            <g fill="\(color)" stroke="none">
            \(llave)
            \(cuerpo.joined(separator: "\n"))
            </g>
            <g transform="translate(\(PentagramaSVG.n(desplazamiento)) 0)">
            <g stroke="\(color)" fill="none">
            \(adicionalesSVG.joined(separator: "\n"))
            </g>
            <g stroke="\(color)" fill="none" stroke-width="0.12">
            \(marcaSVG.joined(separator: "\n"))
            </g>
            <g fill="\(color)" stroke="none">
            \(notasSVG.joined(separator: "\n"))
            \(textos.joined(separator: "\n"))
            </g>
            </g>
            </svg>
            """
    }

    // MARK: Geometría

    /// Altura en el dibujo de una posición del pentagrama: la línea de abajo (lugar 0) está en y = 4.
    static func y(deLugar lugar: Int, pentagrama: Int = 0) -> Double {
        4 - Double(lugar) / 2 + Double(pentagrama) * separacionDelPentagramaDoble
    }

    /// Líneas adicionales que necesita una nota: por debajo, desde el −2 hasta su posición; por encima, desde el 10.
    static func lugaresDeLasLineasAdicionales(de lugar: Int) -> [Int] {
        if lugar <= -2 { return stride(from: -2, through: lugar, by: -2).map { $0 } }
        if lugar >= 10 { return stride(from: 10, through: lugar, by: 2).map { $0 } }
        return []
    }

    /// El glifo de una clave y la posición de su línea de referencia.
    static func glifoYLugar(de clave: Clave) -> (Glifo, Int) {
        switch clave {
        case .sol: return (GlifosSMuFL.claveDeSol, 2)
        case .solOctavaBaja: return (GlifosSMuFL.claveDeSolOctavaBaja, 2)
        case .solOctavaAlta: return (GlifosSMuFL.claveDeSolOctavaAlta, 2)
        case .fa: return (GlifosSMuFL.claveDeFa, 6)
        case .faEnTercera: return (GlifosSMuFL.claveDeFa, 4)
        case .doEnPrimera: return (GlifosSMuFL.claveDeDo, 0)
        case .doEnSegunda: return (GlifosSMuFL.claveDeDo, 2)
        case .doEnTercera: return (GlifosSMuFL.claveDeDo, 4)
        case .doEnCuarta: return (GlifosSMuFL.claveDeDo, 6)
        }
    }

    /// Dónde se escribe cada alteración de la armadura: como en la clave de sol (Fa♯ en la 5.ª línea, Si♭ en la 3.ª),
    /// desplazada según la clave. Los sostenidos suben hasta el Sol de encima del pentagrama y los bemoles hasta el Mi
    /// de la 5.ª línea; cada uno, en la octava más alta que no pase de ahí.
    static func lugarEnLaArmadura(_ nota: Nota, clave: Clave, sostenidos: Bool) -> Int {
        let base = clave.alturaDeLaPrimeraLinea.pasos
        var desplazamiento = modulo(Altura(.mi, octava: 4).pasos - base, 7)
        if desplazamiento > 2 { desplazamiento -= 7 }
        let limite = (sostenidos ? 9 : 7) + desplazamiento
        let lugar = Altura(Nota(nota.natural), octava: 4).pasos - base
        return limite - modulo(limite - lugar, 7)
    }

    static func glifoDeAlteracion(_ semitonos: Int) -> Glifo {
        switch semitonos {
        case 0: return GlifosSMuFL.becuadro
        case 1: return GlifosSMuFL.sostenido
        case -1: return GlifosSMuFL.bemol
        case ..<(-1): return GlifosSMuFL.dobleBemol
        default: return GlifosSMuFL.dobleSostenido
        }
    }

    // MARK: Escritura

    /// Un glifo con su origen en `x` y en la altura de una posición del pentagrama.
    static func glifo(_ glifo: Glifo, x: Double, lugar: Int, pentagrama: Int = 0) -> String {
        "<path transform=\"translate(\(n(x)) \(n(y(deLugar: lugar, pentagrama: pentagrama))))\" d=\"\(glifo.trazado)\"/>"
    }

    /// Un número con tres decimales como mucho y sin ceros de más.
    static func n(_ valor: Double) -> String {
        let redondeado = (valor * 1000).rounded() / 1000
        var texto = "\(redondeado)"
        if texto.hasSuffix(".0") { texto.removeLast(2) }
        return texto == "-0" ? "0" : texto
    }

    static func escapar(_ texto: String) -> String {
        texto.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }
}
