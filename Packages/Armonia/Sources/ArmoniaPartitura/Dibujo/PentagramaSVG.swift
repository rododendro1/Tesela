import ArmoniaNucleo
import ArmoniaTeoria
import Foundation

// Un pentagrama en SVG, para escalas, acordes, arpegios y voces: redondas sobre cinco líneas, con clave, armadura,
// alteraciones, líneas adicionales y, en los acordes, las segundas desplazadas. Con un `Ritmo` (el de una voz), las
// figuras con sus plicas, barras, silencios y compases (`PentagramaSVG+Ritmo.swift`). Una voz larga se parte en
// líneas, todas del mismo ancho, y dos voces pueden ir en el mismo pentagrama, una con las plicas hacia arriba y otra
// hacia abajo (`PentagramaSVG+Lineas.swift`). Para partituras completas, con más voces y pentagramas, el MEI o el
// MusicXML de `ArmoniaFormatos` y un motor como Verovio.
//
// Las medidas están en espacios de pentagrama (1 = la distancia entre dos líneas) y el eje y baja, como en SVG:
// la línea de arriba está en y = 0 y la de abajo en y = 4. Los glifos son los de Bravura (`GlifosSMuFL`).

/// El dibujo: columnas de notas (una nota por columna en una escala, todas las de un acorde en una sola).
struct PentagramaSVG {
    let columnas: [[Altura]]
    let armadura: [Nota]
    let cifrado: String?
    let titulo: String
    let opciones: OpcionesDePentagrama
    /// Las notas que se apartan de la temperada (los microtonos de un maqam), por columna y en el orden de sus
    /// alturas: el signo que llevan (o `nil`, si se escribe la temperada) y su nombre (Mi𝄳). Vacío si no hay.
    var microtonos: [[Microtono?]] = []
    /// El ritmo de cada columna; sin él, todas son redondas sin compás.
    var ritmo: Ritmo?
    /// Los cifrados de las demás columnas (los acordes de una progresión), encima de su columna.
    var cifrados: [Int: String] = [:]
    /// La tónica o la fundamental desde la que se cuentan los intervalos de las notas y que se marca, a partir de
    /// cada columna (en una progresión, la de cada acorde).
    var referencias: [Int: Referencia] = [:]
    /// Los grados de una progresión en números romanos (I, V7/V), debajo de su columna, en la última fila.
    var grados: [Int: String] = [:]
    /// Los dedos de cada columna, encima de las notas, uno por nota de la grave a la aguda (0, sin dedo).
    var digitos: [Int: [Int]] = [:]
    /// La tablatura debajo del pentagrama, alineada columna a columna.
    var tablatura: Tablatura?
    /// Las cifras del bajo continuo de cada columna, de arriba abajo («6», «4»), debajo de todo.
    var bajosCifrados: [Int: [String]] = [:]
    /// Las articulaciones, los ornamentos y el calderón de cada columna (con ritmo).
    var articulaciones: [Int: [Articulacion]] = [:]
    /// Las claves de cada pentagrama, si ya se han decidido (las de la voz entera, en una línea de una voz larga).
    var claves: [Clave]?
    /// Si se escribe la cifra del compás (con ritmo): en una voz partida en líneas, solo en la primera.
    var conCifraDeCompas = true
    /// Si acaba en la barra doble final (con ritmo): en una voz partida en líneas, solo la última.
    var conBarraFinal = true
    /// Con dos voces en un pentagrama: `true` en la de arriba (plicas hacia arriba, silencios más altos), `false`
    /// en la de abajo; `nil`, una sola voz, con las plicas según las notas.
    var plicasHaciaArriba: Bool?
    /// Dónde empieza, como pronto, cada columna (su cabeza), para alinear dos voces o estirar una línea.
    var xMinimas: [Double] = []
    /// Dónde va, como pronto, cada barra de compás.
    var barrasMinimas: [Double] = []
    /// Dónde acaba, como pronto, el pentagrama.
    var finalMinimo = 0.0
    /// Lo que se aparta a la derecha cada columna de la segunda de dos voces para no pisar las cabezas de la primera
    /// (si están a una segunda o al unísono).
    var apartes: [Double] = []
    /// Solo las notas y lo que va con ellas, sin las líneas, las claves ni las barras: la segunda voz de un
    /// pentagrama, que se dibuja encima de la primera.
    var soloLasNotas = false

    /// La nota desde la que se cuentan los intervalos.
    struct Referencia {
        let nota: Nota
        /// Si es la fundamental de un acorde con séptima: la segunda, la cuarta y la sexta son tensiones (9, 11, 13).
        let conTensiones: Bool
        /// Las clases de altura del acorde, si la referencia es un acorde: las demás notas son ajenas a él.
        var clasesDelAcorde: Set<Int>?

        init(_ nota: Nota, conTensiones: Bool = false) {
            self.nota = nota
            self.conTensiones = conTensiones
        }

        /// La fundamental de un acorde, con tensiones si el acorde tiene séptima.
        init(_ acorde: Acorde) {
            let raiz = acorde.fundamental
            let conSeptima = acorde.notas.contains {
                modulo($0.natural.indiceDiatonico - raiz.natural.indiceDiatonico, 7) == 6
            }
            self.init(raiz, conTensiones: conSeptima)
            clasesDelAcorde = Set((acorde.notas + [acorde.bajo]).map(\.claseDeAltura))
        }

        /// «1», «♭3», «♯11», «𝄫7»: el intervalo simple desde la referencia, con la alteración respecto a la 2.ª, 3.ª,
        /// 6.ª y 7.ª mayores y a la 1.ª, 4.ª y 5.ª justas.
        func cifra(de nota: Nota) -> String {
            let pasos = modulo(nota.natural.indiceDiatonico - self.nota.natural.indiceDiatonico, 7)
            let semitonos = modulo(nota.claseDeAltura - self.nota.claseDeAltura, 12)
            var diferencia = modulo(semitonos - [0, 2, 4, 5, 7, 9, 11][pasos], 12)
            if diferencia > 6 { diferencia -= 12 }
            let numero = conTensiones && [1, 3, 5].contains(pasos) ? pasos + 8 : pasos + 1
            return (diferencia == 0 ? "" : Alteracion(diferencia).simbolo(en: .conDobles)) + String(numero)
        }
    }

    /// La referencia que vale en una columna: la de la última columna en que se fijó.
    func referencia(_ columna: Int) -> Referencia? {
        referencias.filter { $0.key <= columna }.max { $0.key < $1.key }?.value
    }

    /// Una nota microtonal: su signo y su nombre.
    struct Microtono {
        let signo: SignoMicrotonal?
        let nombre: String

        /// El de una nota que se aparta de la temperada (`Evento.Nota.desvio`). Si sabe su sistema, el signo de su
        /// sistema y su nombre (Mi𝄳); si no, el signo que dan los cents y la altura con sus cents («Mi♭₄ (+50¢)»).
        /// `nil` si no se aparta de la temperada.
        static func de(_ nota: Evento.Nota, notacion: Notacion) -> Microtono? {
            guard nota.desvio != 0 else { return nil }
            if let sistema = nota.sistema {
                return Microtono(
                    signo: nota.signo(),
                    nombre: NotaMicrotonal.nombre(
                        nota.altura.nota, sistema: sistema, ajuste: nota.ajuste, en: notacion))
            }
            let cifra = nota.desvio == nota.desvio.rounded() ? String(Int(nota.desvio)) : String(nota.desvio)
            let cents = (nota.desvio > 0 ? "+" : "") + cifra + (notacion.usaASCII ? "c" : "¢")
            return Microtono(signo: nota.signo(), nombre: nota.altura.nombre(en: notacion) + " (" + cents + ")")
        }
    }

    /// Cuerpo de la letra del cifrado y de los nombres de las notas, en espacios de pentagrama.
    static let letraDelCifrado = 1.9
    static let letraDeLasEtiquetas = 1.2
    static let letraDeLosGrados = 1.5
    static let letraDelBajoCifrado = 1.3
    /// Lo que separa dos cifras del bajo continuo, una encima de otra.
    static let separacionDelBajoCifrado = 1.2
    static let letraDeLosDedos = 1.2
    static let letraDeLaTablatura = 1.2
    /// Lo que separa dos líneas de la tablatura.
    static let separacionDeLaTablatura = 1.3

    /// Lo que mide cada carácter, en partes del cuerpo de la letra, en Helvetica y Arial.
    static let anchosDeLosCaracteres: [Character: Double] = {
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

    /// Lo que se deja entre dos columnas de alteraciones.
    static let huecoEntreColumnasDeAlteraciones = 0.12
    /// Lo que como mínimo separa, de arriba abajo, dos alteraciones de la misma columna.
    static let huecoVerticalEntreAlteraciones = 0.1
    static let separacionEntreColumnas = 1.5

    /// Una nota ya colocada: dónde va y qué alteración lleva delante.
    struct NotaColocada {
        let altura: Altura
        let lugar: Int
        var desplazada = false
        var alteracion: Glifo?
        var columnaDeAlteracion = 0
        var microtono: Microtono?
    }

    /// El microtono de la altura `indice` de una columna, si lo tiene.
    func microtono(_ columna: Int, _ indice: Int) -> Microtono? {
        guard microtonos.indices.contains(columna), microtonos[columna].indices.contains(indice) else { return nil }
        return microtonos[columna][indice]
    }

    /// El nombre de la altura `indice` de una columna: el de su microtono, si lo tiene.
    func nombreDeLaAltura(_ columna: Int, _ indice: Int) -> String {
        microtono(columna, indice)?.nombre ?? columnas[columna][indice].nombre(en: opciones.notacion)
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
    func clavesDelPentagrama() -> [Clave] {
        if let claves { return claves }
        switch opciones.maquetacion.pentagramas {
        case .doble: return [.sol, .fa]
        case .simple: return [opciones.maquetacion.clave ?? Clave.masAdecuada(para: columnas.flatMap { $0 }) ?? .sol]
        case .automatico:
            let elegida = opciones.maquetacion.clave ?? Clave.masAdecuada(para: columnas.flatMap { $0 }) ?? .sol
            guard opciones.maquetacion.clave == nil else { return [elegida] }
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

    /// Lo que encoge la clave de un cambio de clave.
    static let escalaDelCambioDeClave = 0.75

    /// La clave de cada columna, de sol o de fa, cambiando solo cuando la nueva ahorra líneas adicionales y con la que
    /// va harían falta tres o más.
    static func clavesPorRegistro(_ columnas: [[Altura]], desde inicial: Clave) -> [Clave] {
        func lineas(_ alturas: [Altura], _ clave: Clave) -> Int {
            alturas.map { lugaresDeLasLineasAdicionales(de: clave.posicion(de: $0).lugar).count }.max() ?? 0
        }
        var actual: Clave = inicial == .fa ? .fa : .sol
        return columnas.map { alturas in
            guard !alturas.isEmpty else { return actual }
            let otra: Clave = actual == .sol ? .fa : .sol
            if lineas(alturas, actual) >= 3, lineas(alturas, otra) < lineas(alturas, actual) { actual = otra }
            return actual
        }
    }

    /// El color de una nota ajena al acorde que suena (`marcas.notasAjenas`): el de las notas de paso si es de la
    /// tonalidad (o si no hay tonalidad), el de las cromáticas si no; `nil` si es del acorde o no hay acorde.
    func colorDeNotaAjena(_ nota: Nota, _ columna: Int) -> String? {
        guard opciones.marcas.notasAjenas, let clases = referencia(columna)?.clasesDelAcorde,
            !clases.contains(nota.claseDeAltura)
        else { return nil }
        if case .tonalidad(let tonalidad) = opciones.armadura,
            !tonalidad.notasPropias.map(\.claseDeAltura).contains(nota.claseDeAltura)
        {
            return opciones.colores.cromaticas
        }
        return opciones.colores.notasDePaso
    }

    // El dibujo se hace en pasadas: primero se decide el sistema (las claves y la marca de octava), después se dibuja
    // el principio (claves, armadura y cifra del compás) y se colocan las columnas de izquierda a derecha, y con eso
    // se sabe dónde va lo demás: los arcos de los semitonos, el ritmo, las marcas de octava, los dedos, la tablatura,
    // las líneas, las barras y los textos. Cada pasada añade lo suyo al `Lienzo` y apunta lo que sube y baja.

    /// El dibujo terminado: lo que ocupa (en espacios, desde `x` e `y`), lo que dice en texto y sus elementos; y,
    /// para alinear dos voces, dónde ha ido cada columna y cada barra de compás (antes de `desplazamiento`, lo que
    /// se corren las notas si el texto de la primera sobresale) y dónde acaba el pentagrama.
    struct Dibujo {
        let x: Double
        let y: Double
        let ancho: Double
        let alto: Double
        let descripcion: String
        let contenido: String
        var colocadas: [ColumnaColocada] = []
        var barras: [Double] = []
        var desplazamiento = 0.0
        var final = 0.0

        /// Dónde empieza la cabeza de cada columna.
        var columnasX: [Double] { colocadas.map(\.x) }
    }

    func svg() -> String {
        PentagramaSVG.envolver([dibujo()], titulo: titulo, tamano: opciones.maquetacion.tamano)
    }

    /// Uno o más dibujos, uno debajo de otro, en un SVG.
    static func envolver(_ dibujos: [Dibujo], titulo: String, tamano: Double) -> String {
        let separacion = 1.5
        var y = 0.0
        var grupos: [String] = []
        for dibujo in dibujos {
            if dibujos.count == 1 {
                grupos.append(dibujo.contenido)
            } else {
                grupos.append("<g transform=\"translate(0 \(n(y - dibujo.y)))\">\n\(dibujo.contenido)\n</g>")
            }
            y += dibujo.alto + separacion
        }
        let x = dibujos.first?.x ?? 0
        let cima = dibujos.count == 1 ? dibujos[0].y : 0
        let ancho = dibujos.map(\.ancho).max() ?? 0
        let alto = dibujos.map(\.alto).reduce(0, +) + separacion * Double(max(0, dibujos.count - 1))
        let descripcion = dibujos.map(\.descripcion).joined(separator: ", ")
        return """
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="\(n(x)) \(n(cima)) \(n(ancho)) \(n(alto))" width="\(n(ancho * tamano))" height="\(n(alto * tamano))" role="img" aria-labelledby="titulo descripcion">
            <title id="titulo">\(EscrituraXML.escapar(titulo))</title>
            <desc id="descripcion">\(EscrituraXML.escapar(descripcion))</desc>
            \(grupos.joined(separator: "\n"))
            </svg>
            """
    }

    /// El dibujo, sin el `<svg>` que lo envuelve.
    func dibujo() -> Dibujo {
        let sistema = disponerElSistema()
        let claves = sistema.claves
        let doble = sistema.doble
        var lienzo = Lienzo(maximoY: doble ? 4.0 + PentagramaSVG.separacionDelPentagramaDoble : 4.0)
        let vigentes = dibujarElPrincipio(sistema, en: &lienzo)
        let maquetacion = colocarLasColumnas(sistema, vigentes: vigentes, en: &lienzo)
        var final = lienzo.x - maquetacion.ultimaSeparacion + (ritmo == nil ? 0.9 : conBarraFinal ? 2.0 : 1.2)
        if opciones.marcas.semitonos { dibujarLosSemitonos(maquetacion.notasSueltas, en: &lienzo) }
        // Un cifrado de una progresión puede sobresalir por la derecha.
        if let ultimo = maquetacion.cifrados.last { final = max(final, ultimo.x + ultimo.mitad + 0.6) }
        // Las plicas, las barras de unión, las ligaduras y los tresillos.
        if let ritmo {
            let (trazos, arriba, abajo, plicasArriba) = trazosDelRitmo(
                ritmo, colocadas: maquetacion.colocadas, pentagramas: claves.count)
            lienzo.notas += trazos
            if arriba.isFinite { lienzo.minimoY = min(lienzo.minimoY, arriba) }
            if abajo.isFinite { lienzo.maximoY = max(lienzo.maximoY, abajo) }
            dibujarLasArticulaciones(maquetacion.colocadas, plicasArriba: plicasArriba, en: &lienzo)
        }
        let marcasDeOctava = dibujarLasMarcasDeOctava(sistema, maquetacion, en: &lienzo)
        let dedos = dibujarLosDedos(maquetacion.centros, en: &lienzo)
        let tablaturaColocada = colocarLaTablatura(maquetacion.centros, en: &lienzo)
        lienzo.notas += dedos + (tablaturaColocada?.textos ?? [])

        // Un cifrado o los nombres de un acorde pueden ser más anchos que el acorde: el pentagrama se alarga a la derecha
        // y, si el texto sobresale por la izquierda, las notas se desplazan.
        let proporcion = opciones.maquetacion.anchoDeLosCaracteres
        let anchoDelTexto = max(
            cifrado.map {
                PentagramaSVG.anchoEstimado($0, cuerpoDeLetra: PentagramaSVG.letraDelCifrado, proporcion: proporcion)
            } ?? 0,
            cifrados[0].map {
                PentagramaSVG.anchoEstimado($0, cuerpoDeLetra: PentagramaSVG.letraDelCifrado, proporcion: proporcion)
            } ?? 0,
            columnas.count == 1
                ? (maquetacion.etiquetas.prefix(1) + maquetacion.intervalos.prefix(1)).map {
                    PentagramaSVG.anchoEstimado(
                        $0.texto, cuerpoDeLetra: PentagramaSVG.letraDeLasEtiquetas, proporcion: proporcion)
                }.max() ?? 0 : 0)
        let centroDelTexto = maquetacion.cifradoX ?? 0
        let desplazamiento = max(0, anchoDelTexto / 2 + 0.2 - centroDelTexto)
        final = max(final + desplazamiento, centroDelTexto + desplazamiento + anchoDelTexto / 2 + 0.6, finalMinimo)

        // Medidas verticales: del punto más alto al más bajo, con las claves, las alteraciones y las notas.
        let minimoY = lienzo.minimoY
        let maximoY = lienzo.maximoY
        let cima = cifrado == nil && maquetacion.cifrados.isEmpty ? minimoY - 0.4 : minimoY - 2.6
        // Debajo, una fila por cada clase de etiqueta: los nombres, los intervalos y los grados.
        let filas = (opciones.marcas.nombresDeLasNotas ? 1 : 0) + (maquetacion.intervalos.isEmpty ? 0 : 1)
        let yDeLosGrados = maximoY + (filas == 0 ? 2.0 : 2.0 + 1.5 * Double(filas))
        // El bajo cifrado, debajo de los grados (o donde irían), con las cifras una encima de otra.
        let yDelBajoCifrado = maquetacion.grados.isEmpty ? yDeLosGrados - 0.2 : yDeLosGrados + 1.6
        let cifrasPorColumna = maquetacion.bajoCifrado.map(\.cifras.count).max() ?? 0
        let fondo =
            cifrasPorColumna > 0
            ? yDelBajoCifrado + PentagramaSVG.separacionDelBajoCifrado * Double(cifrasPorColumna - 1) + 0.6
            : !maquetacion.grados.isEmpty
                ? yDeLosGrados + 0.6 : filas == 0 ? maximoY + 0.4 : maximoY + 2.4 + 1.5 * Double(filas - 1)
        // En el pentagrama doble, una llave a la izquierda, con el margen que pide.
        let margen = doble ? PentagramaSVG.margenDeLaLlave : 0
        let ancho = final + 0.6 + margen
        let alto = fondo - cima

        let lineas = lineasDelSistema(
            pentagramas: claves.count, tablatura: tablaturaColocada, barrasDeCompas: maquetacion.barrasDeCompas,
            final: final, desplazamiento: desplazamiento)
        let abajoDelSistema = PentagramaSVG.y(deLugar: 0, pentagrama: claves.count - 1)
        // Con ritmo, las barras de compás (corridas con las notas).
        let barrasDeCompasSVG = maquetacion.barrasDeCompas.map {
            elemento("line").con("x1", $0).con("y1", 0).con("x2", $0).con("y2", abajoDelSistema)
                .con("stroke-width", "0.16").vacio
        }
        // La llave de Bravura, estirada de sus 4 espacios a lo que miden los dos pentagramas (14).
        let n = PentagramaSVG.n
        let llave =
            doble
            ? elemento("path")
                .con(
                    "transform",
                    "translate(\(n(-PentagramaSVG.margenDeLaLlave + 0.3)) \(n(abajoDelSistema))) scale(\(n(abajoDelSistema / 4)))"
                )
                .con("d", GlifosSMuFL.llave.trazado).vacio
            : ""
        let adicionalesSVG = maquetacion.lineasAdicionales.map {
            linea(
                desde: $0.desde, hasta: $0.hasta, y: PentagramaSVG.y(deLugar: $0.lugar, pentagrama: $0.pentagrama),
                grosor: "0.16")
        }
        let textos = textosDelSistema(
            maquetacion, minimoY: minimoY, maximoY: maximoY, yDeLosGrados: yDeLosGrados,
            yDelBajoCifrado: yDelBajoCifrado)
        if let tablaturaColocada { lienzo.cuerpo += rotuloDeLaTablatura(tablaturaColocada) }

        let color = EscrituraXML.escapar(opciones.colores.dibujo)
        let descripcion = columnas.flatMap { $0 }.map { $0.nombre(en: opciones.notacion) }.joined(separator: ", ")
        let fondoDelSistema = """
            <g stroke="\(color)" fill="none">
            \(lineas.joined(separator: "\n"))
            </g>
            <g fill="\(color)" stroke="none">
            \(llave)
            \(lienzo.cuerpo.joined(separator: "\n"))
            </g>

            """
        let contenido = """
            \(soloLasNotas ? "" : fondoDelSistema)<g transform="translate(\(PentagramaSVG.n(desplazamiento)) 0)">
            <g stroke="\(color)" fill="none">
            \((adicionalesSVG + (soloLasNotas ? [] : barrasDeCompasSVG)).joined(separator: "\n"))
            </g>
            <g stroke="\(color)" fill="none" stroke-width="0.12">
            \(marcasDeOctava.joined(separator: "\n"))
            </g>
            <g fill="\(color)" stroke="none">
            \(lienzo.notas.joined(separator: "\n"))
            \(textos.joined(separator: "\n"))
            </g>
            </g>
            """
        return Dibujo(
            x: -margen, y: cima, ancho: ancho, alto: alto, descripcion: descripcion, contenido: contenido,
            colocadas: maquetacion.colocadas, barras: maquetacion.barrasDeCompas,
            desplazamiento: desplazamiento, final: final)
    }

    /// Un elemento con los números del pentagrama (en espacios, con tres decimales como mucho).
    func elemento(_ nombre: String) -> ElementoSVG { ElementoSVG(nombre, numeros: .hastaTresDecimales) }

    /// Una línea horizontal, del pentagrama o adicional.
    func linea(desde: Double, hasta: Double, y: Double, grosor: String) -> String {
        elemento("line").con("x1", desde).con("y1", y).con("x2", hasta).con("y2", y).con("stroke-width", grosor)
            .vacio
    }

    static let doCentral = Altura(.do, octava: 4).midi
}
