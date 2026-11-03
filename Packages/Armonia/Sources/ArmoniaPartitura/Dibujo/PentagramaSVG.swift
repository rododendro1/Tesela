import ArmoniaNucleo
import ArmoniaTeoria
import Foundation

// Un pentagrama en SVG, para escalas, acordes, arpegios y voces: redondas sobre cinco líneas, con clave, armadura,
// alteraciones, líneas adicionales y, en los acordes, las segundas desplazadas. Con un `Ritmo` (el de una voz), las
// figuras con sus plicas, barras, silencios y compases (`PentagramaSVG+Ritmo.swift`). No hay varias voces en un
// pentagrama ni saltos de línea: para partituras completas, el MEI o el MusicXML de `ArmoniaFormatos` y un motor como
// Verovio.
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
    private func referencia(_ columna: Int) -> Referencia? {
        referencias.filter { $0.key <= columna }.max { $0.key < $1.key }?.value
    }

    /// Una nota microtonal: su signo y su nombre.
    struct Microtono {
        let signo: SignoMicrotonal?
        let nombre: String
    }

    /// Cuerpo de la letra del cifrado y de los nombres de las notas, en espacios de pentagrama.
    private static let letraDelCifrado = 1.9
    private static let letraDeLasEtiquetas = 1.2
    private static let letraDeLosGrados = 1.5
    private static let letraDelBajoCifrado = 1.3
    /// Lo que separa dos cifras del bajo continuo, una encima de otra.
    private static let separacionDelBajoCifrado = 1.2
    private static let letraDeLosDedos = 1.2
    private static let letraDeLaTablatura = 1.2
    /// Lo que separa dos líneas de la tablatura.
    static let separacionDeLaTablatura = 1.3

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
        var microtono: Microtono?
    }

    /// El microtono de la altura `indice` de una columna, si lo tiene.
    private func microtono(_ columna: Int, _ indice: Int) -> Microtono? {
        guard microtonos.indices.contains(columna), microtonos[columna].indices.contains(indice) else { return nil }
        return microtonos[columna][indice]
    }

    /// El nombre de la altura `indice` de una columna: el de su microtono, si lo tiene.
    private func nombreDeLaAltura(_ columna: Int, _ indice: Int) -> String {
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

    /// El color de una nota ajena al acorde que suena (`marcarNotasAjenas`): el de las notas de paso si es de la
    /// tonalidad (o si no hay tonalidad), el de las cromáticas si no; `nil` si es del acorde o no hay acorde.
    private func colorDeNotaAjena(_ nota: Nota, _ columna: Int) -> String? {
        guard opciones.marcarNotasAjenas, let clases = referencia(columna)?.clasesDelAcorde,
            !clases.contains(nota.claseDeAltura)
        else { return nil }
        if case .tonalidad(let tonalidad) = opciones.armadura,
            !tonalidad.notasPropias.map(\.claseDeAltura).contains(nota.claseDeAltura)
        {
            return opciones.colorDeLasCromaticas
        }
        return opciones.colorDeLasNotasDePaso
    }

    // El dibujo se hace en pasadas: primero se decide el sistema (las claves y la marca de octava), después se dibuja
    // el principio (claves, armadura y cifra del compás) y se colocan las columnas de izquierda a derecha, y con eso
    // se sabe dónde va lo demás: los arcos de los semitonos, el ritmo, las marcas de octava, los dedos, la tablatura,
    // las líneas, las barras y los textos. Cada pasada añade lo suyo al `Lienzo` y apunta lo que sube y baja.

    func svg() -> String {
        let sistema = disponerElSistema()
        let claves = sistema.claves
        let doble = sistema.doble
        var lienzo = Lienzo(maximoY: doble ? 4.0 + PentagramaSVG.separacionDelPentagramaDoble : 4.0)
        let vigentes = dibujarElPrincipio(sistema, en: &lienzo)
        let maquetacion = colocarLasColumnas(sistema, vigentes: vigentes, en: &lienzo)
        var final = lienzo.x - maquetacion.ultimaSeparacion + (ritmo == nil ? 0.9 : 2.0)
        if opciones.marcarSemitonos { dibujarLosSemitonos(maquetacion.notasSueltas, en: &lienzo) }
        // Un cifrado de una progresión puede sobresalir por la derecha.
        if let ultimo = maquetacion.cifrados.last { final = max(final, ultimo.x + ultimo.mitad + 0.6) }
        // Las plicas, las barras de unión, las ligaduras y los tresillos.
        if let ritmo {
            let (trazos, arriba, abajo) = trazosDelRitmo(
                ritmo, colocadas: maquetacion.colocadas, pentagramas: claves.count)
            lienzo.notas += trazos
            if arriba.isFinite { lienzo.minimoY = min(lienzo.minimoY, arriba) }
            if abajo.isFinite { lienzo.maximoY = max(lienzo.maximoY, abajo) }
        }
        let marcasDeOctava = dibujarLasMarcasDeOctava(sistema, maquetacion, en: &lienzo)
        let dedos = dibujarLosDedos(maquetacion.centros, en: &lienzo)
        let tablaturaColocada = colocarLaTablatura(maquetacion.centros, en: &lienzo)
        lienzo.notas += dedos + (tablaturaColocada?.textos ?? [])

        // Un cifrado o los nombres de un acorde pueden ser más anchos que el acorde: el pentagrama se alarga a la derecha
        // y, si el texto sobresale por la izquierda, las notas se desplazan.
        let proporcion = opciones.anchoDeLosCaracteres
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
        final = max(final + desplazamiento, centroDelTexto + desplazamiento + anchoDelTexto / 2 + 0.6)

        // Medidas verticales: del punto más alto al más bajo, con las claves, las alteraciones y las notas.
        let minimoY = lienzo.minimoY
        let maximoY = lienzo.maximoY
        let cima = cifrado == nil && maquetacion.cifrados.isEmpty ? minimoY - 0.4 : minimoY - 2.6
        // Debajo, una fila por cada clase de etiqueta: los nombres, los intervalos y los grados.
        let filas = (opciones.nombresDeLasNotas ? 1 : 0) + (maquetacion.intervalos.isEmpty ? 0 : 1)
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

        let color = EscrituraXML.escapar(opciones.color)
        let descripcion = columnas.flatMap { $0 }.map { $0.nombre(en: opciones.notacion) }.joined(separator: ", ")
        let pxAncho = PentagramaSVG.n(ancho * opciones.tamano)
        let pxAlto = PentagramaSVG.n(alto * opciones.tamano)
        return """
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="\(PentagramaSVG.n(-margen)) \(PentagramaSVG.n(cima)) \(PentagramaSVG.n(ancho)) \(PentagramaSVG.n(alto))" width="\(pxAncho)" height="\(pxAlto)" role="img" aria-labelledby="titulo descripcion">
            <title id="titulo">\(EscrituraXML.escapar(titulo))</title>
            <desc id="descripcion">\(EscrituraXML.escapar(descripcion))</desc>
            <g stroke="\(color)" fill="none">
            \(lineas.joined(separator: "\n"))
            </g>
            <g fill="\(color)" stroke="none">
            \(llave)
            \(lienzo.cuerpo.joined(separator: "\n"))
            </g>
            <g transform="translate(\(PentagramaSVG.n(desplazamiento)) 0)">
            <g stroke="\(color)" fill="none">
            \((adicionalesSVG + barrasDeCompasSVG).joined(separator: "\n"))
            </g>
            <g stroke="\(color)" fill="none" stroke-width="0.12">
            \(marcasDeOctava.joined(separator: "\n"))
            </g>
            <g fill="\(color)" stroke="none">
            \(lienzo.notas.joined(separator: "\n"))
            \(textos.joined(separator: "\n"))
            </g>
            </g>
            </svg>
            """
    }

    /// Un elemento con los números del pentagrama (en espacios, con tres decimales como mucho).
    private func elemento(_ nombre: String) -> ElementoSVG { ElementoSVG(nombre, numeros: .hastaTresDecimales) }

    /// Una línea horizontal, del pentagrama o adicional.
    private func linea(desde: Double, hasta: Double, y: Double, grosor: String) -> String {
        elemento("line").con("x1", desde).con("y1", y).con("x2", hasta).con("y2", y).con("stroke-width", grosor)
            .vacio
    }

    private static let doCentral = Altura(.do, octava: 4).midi

    // MARK: - El sistema

    /// Lo que se decide antes de dibujar: las claves de los pentagramas, las octavas que se corre cada uno (la marca
    /// 8va u 8vb) y, con cambios de clave, la clave de cada columna.
    private struct Sistema {
        let claves: [Clave]
        /// `octavas[k]` > 0 escribe las notas del pentagrama `k` esas octavas más graves de lo que suenan (8va,
        /// encima del pentagrama de arriba); < 0, más agudas (8vb, debajo del de abajo).
        let octavas: [Int]
        /// Si cada columna lleva la clave de sol o la de fa según su registro.
        let conCambios: Bool
        let clavesDeLasColumnas: [Clave]

        var doble: Bool { claves.count == 2 }

        /// La clave con que se escribe una columna en el pentagrama `k`.
        func clave(_ columna: Int, _ k: Int) -> Clave {
            clavesDeLasColumnas.indices.contains(columna) ? clavesDeLasColumnas[columna] : claves[k]
        }
    }

    private func disponerElSistema() -> Sistema {
        let claves = clavesDelPentagrama()
        let doble = claves.count == 2
        let doCentral = PentagramaSVG.doCentral
        // Con cambios de clave (una sola clave, sin elegir), cada columna lleva la de sol o la de fa según su registro, y
        // no hace falta la marca de octava.
        let conCambios = opciones.cambiosDeClave && !doble && opciones.clave == nil
        let clavesDeLasColumnas = conCambios ? PentagramaSVG.clavesPorRegistro(columnas, desde: claves[0]) : []
        // Una octava más cerca del pentagrama, con la marca 8va u 8vb, si con la clave elegida harían falta demasiadas
        // líneas adicionales.
        var octavas = [Int](repeating: 0, count: claves.count)
        if opciones.marcaDeOctava, opciones.clave == nil || doble, !conCambios {
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
        return Sistema(
            claves: claves, octavas: octavas, conCambios: conCambios, clavesDeLasColumnas: clavesDeLasColumnas)
    }

    // MARK: - El lienzo y el principio

    /// Lo que se va dibujando, de izquierda a derecha: hasta dónde se ha llegado y lo que sube y baja el dibujo, para
    /// el alto de la imagen.
    private struct Lienzo {
        /// Las claves y las armaduras, que se quedan donde están.
        var cuerpo: [String] = []
        /// Las notas y lo que va con ellas: se desplazan si el texto de encima o de debajo es más ancho.
        var notas: [String] = []
        var x = 0.6
        var minimoY = 0.0
        var maximoY: Double

        mutating func incluir(_ glifo: Glifo, lugar: Int, pentagrama: Int) {
            let y = PentagramaSVG.y(deLugar: lugar, pentagrama: pentagrama)
            minimoY = min(minimoY, y + glifo.arriba)
            maximoY = max(maximoY, y + glifo.abajo)
        }
    }

    /// Las claves, la armadura y la cifra del compás. Devuelve la alteración que da la armadura a cada nota.
    private func dibujarElPrincipio(_ sistema: Sistema, en lienzo: inout Lienzo) -> [NotaNatural: Int] {
        let claves = sistema.claves
        // Claves.
        var anchoDeLasClaves = 0.0
        for (k, clave) in claves.enumerated() {
            let (glifoDeClave, lugarDeClave) = PentagramaSVG.glifoYLugar(de: clave)
            lienzo.incluir(glifoDeClave, lugar: lugarDeClave, pentagrama: k)
            lienzo.cuerpo.append(PentagramaSVG.glifo(glifoDeClave, x: lienzo.x, lugar: lugarDeClave, pentagrama: k))
            anchoDeLasClaves = max(anchoDeLasClaves, glifoDeClave.ancho)
        }
        lienzo.x += anchoDeLasClaves + 1.0

        // Armadura.
        let sostenidos = armadura.first.map { $0.alteracion.semitonos > 0 } ?? true
        var vigentes: [NotaNatural: Int] = [:]
        let glifoDeLaArmadura = sostenidos ? GlifosSMuFL.sostenido : GlifosSMuFL.bemol
        for nota in armadura {
            for (k, clave) in claves.enumerated() {
                let lugar = PentagramaSVG.lugarEnLaArmadura(nota, clave: clave, sostenidos: sostenidos)
                lienzo.incluir(glifoDeLaArmadura, lugar: lugar, pentagrama: k)
                lienzo.cuerpo.append(PentagramaSVG.glifo(glifoDeLaArmadura, x: lienzo.x, lugar: lugar, pentagrama: k))
            }
            lienzo.x += glifoDeLaArmadura.ancho + 0.15
            vigentes[nota.natural] = nota.alteracion.semitonos
        }
        // Un pequeño espacio entre la clave (o la armadura) y la primera nota.
        lienzo.x += armadura.isEmpty ? 0.8 : 0.9
        // La cifra del compás: el numerador entre la 5.ª línea y la 3.ª, el denominador entre la 3.ª y la 1.ª.
        if let ritmo {
            let cifras = ritmo.cifras
            let anchos = cifras.map { $0.map(\.ancho).reduce(0, +) }
            let anchoDeLaCifra = anchos.max() ?? 0
            for (fila, glifos) in cifras.enumerated() {
                var xDeLaCifra = lienzo.x + (anchoDeLaCifra - anchos[fila]) / 2
                for glifo in glifos {
                    for k in claves.indices {
                        let lugar = fila == 0 ? 6 : 2
                        lienzo.incluir(glifo, lugar: lugar, pentagrama: k)
                        lienzo.cuerpo.append(PentagramaSVG.glifo(glifo, x: xDeLaCifra, lugar: lugar, pentagrama: k))
                    }
                    xDeLaCifra += glifo.ancho
                }
            }
            lienzo.x += anchoDeLaCifra + 1.2
        }
        return vigentes
    }

    // MARK: - Las columnas

    /// Dónde ha quedado cada columna y lo que va con ella, para las pasadas que vienen después.
    private struct Maquetacion {
        var etiquetas: [(x: Double, texto: String)] = []
        var intervalos: [(x: Double, texto: String)] = []
        var grados: [(x: Double, texto: String)] = []
        var bajoCifrado: [(x: Double, cifras: [String])] = []
        /// El centro de cada columna, para los dedos y la tablatura.
        var centros: [Double] = []
        var cifrados: [(x: Double, texto: String, mitad: Double)] = []
        /// Para el arco de los semitonos: dónde va la nota de cada columna de una sola nota.
        var notasSueltas: [(x: Double, y: Double, midi: Int)?] = []
        /// El centro de la primera columna, donde va el cifrado.
        var cifradoX: Double?
        /// Por pentagrama: dónde empiezan y acaban sus notas y lo que suben y bajan, para la marca de octava.
        var primeraX: [Double?]
        var ultimaX: [Double]
        var arribaDeLasNotas: [Double]
        var abajoDeLasNotas: [Double]
        var lineasAdicionales: [(pentagrama: Int, lugar: Int, desde: Double, hasta: Double)] = []
        /// Con ritmo: lo que necesitan las plicas y las barras, las barras de compás y lo que se deja detrás de la
        /// última columna.
        var colocadas: [ColumnaColocada] = []
        var barrasDeCompas: [Double] = []
        var ultimaSeparacion = PentagramaSVG.separacionEntreColumnas

        init(pentagramas: Int) {
            primeraX = [Double?](repeating: nil, count: pentagramas)
            ultimaX = [Double](repeating: 0, count: pentagramas)
            arribaDeLasNotas = [Double](repeating: .infinity, count: pentagramas)
            abajoDeLasNotas = [Double](repeating: -.infinity, count: pentagramas)
        }
    }

    /// Las notas, columna a columna. En el pentagrama doble, del Do central para arriba van en el de sol.
    private func colocarLasColumnas(
        _ sistema: Sistema, vigentes: [NotaNatural: Int], en lienzo: inout Lienzo
    ) -> Maquetacion {
        var maquetacion = Maquetacion(pentagramas: sistema.claves.count)
        // Altura diatónica (letra y octava) → alteración vigente: «s1» (un sostenido) o el glifo SMuFL de un microtono.
        var enVigor: [Int: String] = [:]
        var ultimaEtiqueta: (centro: Double, mitad: Double)?
        let resaltadas = ritmo?.resaltadas ?? Set(opciones.resaltada.map { [$0] } ?? [])
        for (columna, alturas) in columnas.enumerated() {
            // Un cambio de clave: la nueva, más pequeña, delante de la columna.
            if sistema.conCambios, columna > 0, sistema.clave(columna, 0) != sistema.clave(columna - 1, 0) {
                let (glifoDeClave, lugarDeClave) = PentagramaSVG.glifoYLugar(de: sistema.clave(columna, 0))
                let escala = PentagramaSVG.escalaDelCambioDeClave
                let y = PentagramaSVG.y(deLugar: lugarDeClave)
                lienzo.minimoY = min(lienzo.minimoY, y + glifoDeClave.arriba * escala)
                lienzo.maximoY = max(lienzo.maximoY, y + glifoDeClave.abajo * escala)
                lienzo.notas.append(
                    elemento("path")
                        .con(
                            "transform",
                            "translate(\(PentagramaSVG.n(lienzo.x)) \(PentagramaSVG.n(y))) scale(\(escala))"
                        )
                        .con("d", glifoDeClave.trazado).vacio)
                lienzo.x += glifoDeClave.ancho * escala + 0.6
            }
            let cabeza = ritmo?.cabeza(columna) ?? GlifosSMuFL.redonda
            let (grupos, anchosDeLasColumnas) = notasDeLaColumna(
                columna, sistema, vigentes: vigentes, enVigor: &enVigor)
            let izquierda =
                anchosDeLasColumnas.reduce(0, +) + PentagramaSVG.huecoEntreColumnasDeAlteraciones
                * Double(max(0, anchosDeLasColumnas.count - 1))
            var xDeLaNota = lienzo.x + izquierda + (anchosDeLasColumnas.isEmpty ? 0 : 0.1)
            let hayDesplazadas = grupos.contains { $0.contains(where: \.desplazada) }
            let puntillos = ritmo?.figuras[columna].puntillos ?? 0
            let silencio = ritmo != nil && alturas.isEmpty ? ritmo?.silencio(columna) : nil
            let ancho =
                (silencio?.glifo.ancho ?? cabeza.ancho * (hayDesplazadas ? 2 : 1))
                + (puntillos > 0 ? 0.2 + 0.5 * Double(puntillos) : 0)
            let textos = textosDeLaColumna(columna)
            // Las etiquetas de las notas no se pisan: si la de esta columna cae demasiado cerca de la anterior, la
            // columna se corre a la derecha.
            if columnas.count > 1, textos.hay, let anterior = ultimaEtiqueta {
                let centroMinimo =
                    anterior.centro + anterior.mitad + textos.mitad + PentagramaSVG.separacionEntreEtiquetas
                xDeLaNota += max(0, centroMinimo - (xDeLaNota + ancho / 2))
            }
            // Lo mismo con los cifrados de una progresión, encima.
            let cifradoDeLaColumna = cifrados[columna]
            let mitadDelCifrado =
                (cifradoDeLaColumna.map {
                    PentagramaSVG.anchoEstimado(
                        $0, cuerpoDeLetra: PentagramaSVG.letraDelCifrado, proporcion: opciones.anchoDeLosCaracteres)
                } ?? 0) / 2
            if cifradoDeLaColumna != nil, let anterior = maquetacion.cifrados.last {
                let centroMinimo = anterior.x + anterior.mitad + mitadDelCifrado + 0.8
                xDeLaNota += max(0, centroMinimo - (xDeLaNota + ancho / 2))
            }

            for (k, notas) in grupos.enumerated() {
                if !notas.isEmpty {
                    if maquetacion.primeraX[k] == nil { maquetacion.primeraX[k] = xDeLaNota }
                    maquetacion.ultimaX[k] = xDeLaNota + ancho
                }
                for nota in notas {
                    let xn = xDeLaNota + (nota.desplazada ? cabeza.ancho : 0)
                    var partes: [String] = []
                    if let alteracion = nota.alteracion {
                        // Cada columna, pegada a la anterior por su borde derecho; la primera, junto a la nota.
                        let anchoDeLasMasCercanas =
                            anchosDeLasColumnas.prefix(nota.columnaDeAlteracion).reduce(0, +)
                            + PentagramaSVG.huecoEntreColumnasDeAlteraciones * Double(nota.columnaDeAlteracion)
                        let xa = xDeLaNota - 0.1 - anchoDeLasMasCercanas - alteracion.ancho
                        lienzo.incluir(alteracion, lugar: nota.lugar, pentagrama: k)
                        partes.append(PentagramaSVG.glifo(alteracion, x: xa, lugar: nota.lugar, pentagrama: k))
                    }
                    lienzo.incluir(cabeza, lugar: nota.lugar, pentagrama: k)
                    let y = PentagramaSVG.y(deLugar: nota.lugar, pentagrama: k)
                    maquetacion.arribaDeLasNotas[k] = min(maquetacion.arribaDeLasNotas[k], y)
                    maquetacion.abajoDeLasNotas[k] = max(maquetacion.abajoDeLasNotas[k], y)
                    partes.append(PentagramaSVG.glifo(cabeza, x: xn, lugar: nota.lugar, pentagrama: k))
                    // Los puntillos, detrás de la cabeza y en un espacio: el de encima, si la nota está en una línea.
                    let lugarDelPuntillo = nota.lugar % 2 == 0 ? nota.lugar + 1 : nota.lugar
                    for p in 0..<puntillos {
                        let xp = xDeLaNota + cabeza.ancho * (hayDesplazadas ? 2 : 1) + 0.25 + 0.5 * Double(p)
                        partes.append(
                            PentagramaSVG.glifo(GlifosSMuFL.puntillo, x: xp, lugar: lugarDelPuntillo, pentagrama: k))
                    }
                    let nombre = nota.microtono?.nombre ?? nota.altura.nombre(en: opciones.notacion)
                    let esTonica =
                        opciones.marcarTonica
                        && referencia(columna).map { $0.nota.claseDeAltura == nota.altura.nota.claseDeAltura } == true
                    let relleno: String? =
                        resaltadas.contains(columna)
                        ? opciones.colorResaltado
                        : colorDeNotaAjena(nota.altura.nota, columna) ?? (esTonica ? opciones.colorDeLaTonica : nil)
                    lienzo.notas.append(
                        elemento("g").con("fill", relleno ?? "", si: relleno != nil)
                            .conHijos(elemento("title").conTexto(nombre) + partes.joined()))
                    for lugar in PentagramaSVG.lugaresDeLasLineasAdicionales(de: nota.lugar) {
                        maquetacion.lineasAdicionales.append((k, lugar, xn - 0.4, xn + cabeza.ancho + 0.4))
                    }
                }
            }
            if let silencio {
                lienzo.incluir(silencio.glifo, lugar: silencio.lugar, pentagrama: 0)
                var partes = [PentagramaSVG.glifo(silencio.glifo, x: xDeLaNota, lugar: silencio.lugar, pentagrama: 0)]
                for p in 0..<puntillos {
                    let xp = xDeLaNota + silencio.glifo.ancho + 0.25 + 0.5 * Double(p)
                    partes.append(PentagramaSVG.glifo(GlifosSMuFL.puntillo, x: xp, lugar: 5, pentagrama: 0))
                }
                lienzo.notas.append(partes.joined())
            }
            if ritmo != nil {
                maquetacion.colocadas.append(
                    ColumnaColocada(
                        x: xDeLaNota, anchoDeLaCabeza: cabeza.ancho, lugares: grupos.map { $0.map(\.lugar) },
                        midis: grupos.map { $0.map(\.altura.midi) }))
            }
            let centro = xDeLaNota + ancho / 2
            if maquetacion.cifradoX == nil { maquetacion.cifradoX = centro }
            if let etiqueta = textos.etiqueta { maquetacion.etiquetas.append((centro, etiqueta)) }
            if let intervalo = textos.intervalo { maquetacion.intervalos.append((centro, intervalo)) }
            if let grado = textos.grado { maquetacion.grados.append((centro, grado)) }
            if !textos.cifrasDelBajo.isEmpty { maquetacion.bajoCifrado.append((centro, textos.cifrasDelBajo)) }
            maquetacion.centros.append(centro)
            if textos.hay { ultimaEtiqueta = (centro, textos.mitad) }
            if let cifradoDeLaColumna { maquetacion.cifrados.append((centro, cifradoDeLaColumna, mitadDelCifrado)) }
            let suelta = grupos.enumerated().filter { !$0.element.isEmpty }
            if alturas.count == 1, let (k, notas) = suelta.first, let nota = notas.first {
                let y = PentagramaSVG.y(deLugar: nota.lugar, pentagrama: k)
                maquetacion.notasSueltas.append((xDeLaNota + cabeza.ancho / 2, y, nota.altura.midi))
            } else {
                maquetacion.notasSueltas.append(nil)
            }
            maquetacion.ultimaSeparacion = ritmo?.separacion(columna) ?? PentagramaSVG.separacionEntreColumnas
            lienzo.x = xDeLaNota + ancho + maquetacion.ultimaSeparacion
            // La barra de compás, en medio del hueco hasta la nota siguiente; las alteraciones dejan de valer.
            if ritmo?.finesDeCompas.contains(columna) == true {
                lienzo.x -= maquetacion.ultimaSeparacion / 2
                maquetacion.barrasDeCompas.append(lienzo.x)
                lienzo.x += 1.2
                enVigor = [:]
            }
        }
        return maquetacion
    }

    /// Las notas de una columna en cada pentagrama, ordenadas por su lugar, con las segundas desplazadas y las
    /// alteraciones que llevan; y lo que mide de ancho cada columna de alteraciones (la más ancha de sus glifos).
    /// `enVigor` es lo que vale en cada línea o espacio, y se actualiza con las alteraciones de la columna.
    private func notasDeLaColumna(
        _ columna: Int, _ sistema: Sistema, vigentes: [NotaNatural: Int], enVigor: inout [Int: String]
    ) -> (grupos: [[NotaColocada]], anchosDeLasColumnas: [Double]) {
        let alturas = columnas[columna]
        let doCentral = PentagramaSVG.doCentral
        // Una nota a la que se liga la de la columna anterior no repite la alteración.
        let ligadaALaAnterior: Set<Int> =
            columna > 0 && ritmo?.ligadas[columna - 1] == true ? Set(columnas[columna - 1].map(\.midi)) : []
        var grupos: [[NotaColocada]] = []
        for k in sistema.claves.indices {
            let delPentagrama = alturas.indices.filter {
                !sistema.doble || (alturas[$0].midi >= doCentral) == (k == 0)
            }
            grupos.append(
                delPentagrama.map { i in
                    let escrita = PentagramaSVG.escrita(alturas[i], octavas: sistema.octavas[k])
                    return NotaColocada(
                        altura: alturas[i], lugar: sistema.clave(columna, k).posicion(de: escrita).lugar,
                        microtono: microtono(columna, i))
                }
                .sorted { ($0.lugar, $0.altura.midi) < ($1.lugar, $1.altura.midi) })
        }
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
                // Un microtono lleva su signo, y la nota siguiente en esa línea vuelve a llevar el suyo.
                let pasos = grupos[k][i].altura.pasos
                guard !ligadaALaAnterior.contains(grupos[k][i].altura.midi) else { continue }
                let signo = grupos[k][i].microtono?.signo
                let propia = signo?.smufl ?? "s\(semitonos)"
                let deLaArmadura = "s\(vigentes[grupos[k][i].altura.nota.natural] ?? 0)"
                guard propia != (enVigor[pasos] ?? deLaArmadura) else { continue }
                enVigor[pasos] = propia
                let glifo = signo?.glifo ?? PentagramaSVG.glifoDeAlteracion(semitonos)
                grupos[k][i].alteracion = glifo
                // Va a la primera columna cuyo último glifo no se le monta por arriba: un bemol baja menos que un
                // sostenido, así que caben más juntos.
                let y = PentagramaSVG.y(deLugar: grupos[k][i].lugar)
                var deLaAlteracion = 0
                while deLaAlteracion < fondoDeLaColumna.count,
                    fondoDeLaColumna[deLaAlteracion] + PentagramaSVG.huecoVerticalEntreAlteraciones > y + glifo.arriba
                { deLaAlteracion += 1 }
                if deLaAlteracion == fondoDeLaColumna.count {
                    fondoDeLaColumna.append(y + glifo.abajo)
                } else {
                    fondoDeLaColumna[deLaAlteracion] = y + glifo.abajo
                }
                grupos[k][i].columnaDeAlteracion = deLaAlteracion
                let anchoDelGlifo = grupos[k][i].alteracion?.ancho ?? 0
                if deLaAlteracion == anchosDeLasColumnas.count {
                    anchosDeLasColumnas.append(anchoDelGlifo)
                } else {
                    anchosDeLasColumnas[deLaAlteracion] = max(anchosDeLasColumnas[deLaAlteracion], anchoDelGlifo)
                }
            }
        }
        return (grupos, anchosDeLasColumnas)
    }

    /// Lo que va debajo de una columna: el nombre de sus notas, su intervalo, su grado y su bajo cifrado.
    private struct TextosDeLaColumna {
        let etiqueta: String?
        let intervalo: String?
        let grado: String?
        let cifrasDelBajo: [String]
        /// La mitad de lo que mide el más ancho de ellos.
        let mitad: Double

        var hay: Bool { etiqueta != nil || intervalo != nil || grado != nil || !cifrasDelBajo.isEmpty }
    }

    private func textosDeLaColumna(_ columna: Int) -> TextosDeLaColumna {
        let alturas = columnas[columna]
        let etiqueta: String? =
            opciones.nombresDeLasNotas && !alturas.isEmpty
            ? (columnas.count == 1
                ? alturas.indices.map { nombreDeLaAltura(columna, $0) }.joined(separator: " ")
                : nombreDeLaAltura(columna, 0))
            : nil
        // El intervalo desde la tónica o la fundamental, debajo del nombre (todas las notas, si es un acorde).
        let intervalo: String? =
            opciones.intervalosDeLasNotas && !alturas.isEmpty
            ? referencia(columna).map { referencia in
                (alturas.count > 1 ? alturas : [alturas[0]]).map { referencia.cifra(de: $0.nota) }
                    .joined(separator: " ")
            } : nil
        let grado = grados[columna]
        let cifrasDelBajo = bajosCifrados[columna] ?? []
        let anchos =
            [etiqueta, intervalo].compactMap { $0 }.map {
                PentagramaSVG.anchoEstimado(
                    $0, cuerpoDeLetra: PentagramaSVG.letraDeLasEtiquetas, proporcion: opciones.anchoDeLosCaracteres)
            }
            + [grado].compactMap { $0 }.map {
                PentagramaSVG.anchoEstimado(
                    $0, cuerpoDeLetra: PentagramaSVG.letraDeLosGrados, proporcion: opciones.anchoDeLosCaracteres)
            }
            + cifrasDelBajo.map {
                PentagramaSVG.anchoEstimado(
                    $0, cuerpoDeLetra: PentagramaSVG.letraDelBajoCifrado, proporcion: opciones.anchoDeLosCaracteres)
            }
        return TextosDeLaColumna(
            etiqueta: etiqueta, intervalo: intervalo, grado: grado, cifrasDelBajo: cifrasDelBajo,
            mitad: anchos.max().map { $0 / 2 } ?? 0)
    }

    // MARK: - Lo que va con las columnas

    /// Los semitonos: un arco fino encima de cada par de notas seguidas a un semitono.
    private func dibujarLosSemitonos(_ notasSueltas: [(x: Double, y: Double, midi: Int)?], en lienzo: inout Lienzo) {
        let n = PentagramaSVG.n
        for i in notasSueltas.indices.dropLast() {
            guard let a = notasSueltas[i], let b = notasSueltas[i + 1], abs(a.midi - b.midi) == 1,
                microtono(i, 0)?.signo == nil, microtono(i + 1, 0)?.signo == nil
            else { continue }
            let alto = min(a.y, b.y) - 1.0
            let curva = alto - 0.9
            let trazado =
                "M\(n(a.x + 0.2)) \(n(a.y - 0.8))"
                + "Q\(n((a.x + b.x) / 2)) \(n(curva)) \(n(b.x - 0.2)) \(n(b.y - 0.8))"
            lienzo.notas.append(
                elemento("path").con("d", trazado).con("fill", "none").con("stroke", opciones.color)
                    .con("stroke-width", "0.12").vacio)
            lienzo.minimoY = min(lienzo.minimoY, (alto + curva) / 2 - 0.1)
        }
    }

    /// La marca 8va (encima) u 8vb (debajo), con su línea de puntos hasta la última nota.
    private func dibujarLasMarcasDeOctava(
        _ sistema: Sistema, _ maquetacion: Maquetacion, en lienzo: inout Lienzo
    ) -> [String] {
        var marcas: [String] = []
        for k in sistema.claves.indices where sistema.octavas[k] != 0 {
            guard let inicio = maquetacion.primeraX[k] else { continue }
            let arriba = sistema.octavas[k] > 0
            let y =
                arriba
                ? min(maquetacion.arribaDeLasNotas[k] - 1.5, PentagramaSVG.y(deLugar: 8, pentagrama: k) - 0.8)
                : max(maquetacion.abajoDeLasNotas[k] + 2.6, PentagramaSVG.y(deLugar: 0, pentagrama: k) + 2.0)
            let rotulo = arriba ? "8va" : "8vb"
            let finDelRotulo =
                inicio - 0.3
                + PentagramaSVG.anchoEstimado(rotulo, cuerpoDeLetra: 1.4, proporcion: opciones.anchoDeLosCaracteres)
            let yDeLaLinea = y - 0.45
            let gancho = arriba ? yDeLaLinea + 1.0 : yDeLaLinea - 1.0
            marcas.append(
                elemento("text").con("x", inicio - 0.3).con("y", y).con("font-size", "1.4").con("font-style", "italic")
                    .con("font-family", "sans-serif").con("fill", opciones.color).con("stroke", "none").conTexto(rotulo)
            )
            // Con una sola columna (un acorde) no hay línea de puntos: solo el rótulo.
            if maquetacion.ultimaX[k] - (finDelRotulo + 0.3) > 1.0 {
                let n = PentagramaSVG.n
                marcas.append(
                    elemento("path").con(
                        "d", "M\(n(finDelRotulo + 0.3)) \(n(yDeLaLinea)) H\(n(maquetacion.ultimaX[k])) V\(n(gancho))"
                    )
                    .con("stroke-dasharray", "0.5 0.35").vacio)
            }
            if arriba {
                lienzo.minimoY = min(lienzo.minimoY, y - 1.2)
            } else {
                lienzo.maximoY = max(lienzo.maximoY, y + 0.3)
            }
        }
        return marcas
    }

    /// Los dedos, en una fila encima de todo lo demás (debajo del cifrado): en un acorde, el de la nota más aguda
    /// arriba.
    private func dibujarLosDedos(_ centros: [Double], en lienzo: inout Lienzo) -> [String] {
        guard !digitos.isEmpty else { return [] }
        var dedosSVG: [String] = []
        let base = lienzo.minimoY - 0.4
        var arribaDeLosDedos = base
        for (columna, dedos) in digitos where centros.indices.contains(columna) {
            let pares = zip(columnas[columna], dedos).sorted { $0.0.midi < $1.0.midi }
            for (i, par) in pares.filter({ $0.1 > 0 }).enumerated() {
                let y = base - 1.1 * Double(i)
                arribaDeLosDedos = min(arribaDeLosDedos, y)
                dedosSVG.append(
                    elemento("text").con("x", centros[columna]).con("y", y).con("text-anchor", "middle")
                        .con("font-size", PentagramaSVG.letraDeLosDedos).con("font-family", "sans-serif")
                        .conTexto(String(par.1)))
            }
        }
        lienzo.minimoY = min(lienzo.minimoY, arribaDeLosDedos - 1.0)
        return dedosSVG
    }

    /// La tablatura ya colocada: el traste de cada nota y las líneas de las cuerdas, con los huecos que dejan los
    /// números.
    private struct TablaturaColocada {
        var textos: [String] = []
        var lineas: [(y: Double, huecos: [(Double, Double)])]
        let arriba: Double
        let abajo: Double
    }

    /// La tablatura, debajo del pentagrama: una línea por cuerda (la más aguda arriba) y el traste de cada nota en su
    /// cuerda, con la línea cortada alrededor del número.
    private func colocarLaTablatura(_ centros: [Double], en lienzo: inout Lienzo) -> TablaturaColocada? {
        guard let tablatura, tablatura.cuerdas > 0 else { return nil }
        let arriba = lienzo.maximoY + 2.0
        let separacion = PentagramaSVG.separacionDeLaTablatura
        let abajo = arriba + separacion * Double(tablatura.cuerdas - 1)
        var colocada = TablaturaColocada(
            lineas: (0..<tablatura.cuerdas).map { (arriba + separacion * Double($0), []) }, arriba: arriba,
            abajo: abajo)
        for (columna, pulsaciones) in tablatura.notas where centros.indices.contains(columna) {
            for pulsacion in pulsaciones where (0..<tablatura.cuerdas).contains(pulsacion.cuerda) {
                let texto = String(pulsacion.traste)
                let mitad =
                    PentagramaSVG.anchoEstimado(
                        texto, cuerpoDeLetra: PentagramaSVG.letraDeLaTablatura,
                        proporcion: opciones.anchoDeLosCaracteres) / 2
                let y = colocada.lineas[pulsacion.cuerda].y
                colocada.lineas[pulsacion.cuerda].huecos.append(
                    (centros[columna] - mitad - 0.15, centros[columna] + mitad + 0.15))
                colocada.textos.append(
                    elemento("text").con("x", centros[columna]).con("y", y + 0.42).con("text-anchor", "middle")
                        .con("font-size", PentagramaSVG.letraDeLaTablatura).con("font-family", "sans-serif")
                        .conTexto(texto))
            }
        }
        // Lo que va debajo (los nombres, los intervalos, los grados), algo más separado de la última cuerda.
        lienzo.maximoY = abajo + 0.6
        return colocada
    }

    /// «TAB» a la izquierda de la tablatura, en vertical.
    private func rotuloDeLaTablatura(_ tablatura: TablaturaColocada) -> [String] {
        let (arriba, abajo) = (tablatura.arriba, tablatura.abajo)
        let letra = min(1.6, (abajo - arriba + 1.0) / 3 * 0.85)
        var rotulo: [String] = []
        for (i, letraDeTab) in ["T", "A", "B"].enumerated() {
            let y = (arriba + abajo) / 2 + letra * 0.36 + Double(i - 1) * letra * 1.05
            rotulo.append(
                elemento("text").con("x", 1.3).con("y", y).con("text-anchor", "middle").con("font-size", letra)
                    .con("font-weight", "bold").con("font-family", "sans-serif").conTexto(letraDeTab))
        }
        return rotulo
    }

    // MARK: - Las líneas y los textos

    /// Las líneas de los pentagramas y de la tablatura y las barras del principio y del final, que no se desplazan
    /// con las notas.
    private func lineasDelSistema(
        pentagramas: Int, tablatura: TablaturaColocada?, barrasDeCompas: [Double], final: Double,
        desplazamiento: Double
    ) -> [String] {
        var lineas: [String] = []
        for k in 0..<pentagramas {
            for i in 0..<5 {
                let y = PentagramaSVG.y(deLugar: 8 - 2 * i, pentagrama: k)
                lineas.append(linea(desde: 0, hasta: final, y: y, grosor: "0.13"))
            }
        }
        // Las líneas de la tablatura, cortadas alrededor de los números (que van corridos con las notas), y sus barras.
        if let tablatura {
            for fila in tablatura.lineas {
                var desde = 0.0
                for hueco in fila.huecos.sorted(by: { $0.0 < $1.0 }) {
                    let (a, b) = (hueco.0 + desplazamiento, hueco.1 + desplazamiento)
                    if a > desde { lineas.append(linea(desde: desde, hasta: a, y: fila.y, grosor: "0.13")) }
                    desde = max(desde, b)
                }
                if final > desde { lineas.append(linea(desde: desde, hasta: final, y: fila.y, grosor: "0.13")) }
            }
            for xDeLaBarra in [0, final] + (ritmo != nil ? [final - 0.25, final - 0.95] : [])
                + barrasDeCompas.map({ $0 + desplazamiento })
            {
                let grosor = ritmo != nil && xDeLaBarra == final - 0.25 ? "0.5" : "0.16"
                lineas.append(
                    elemento("line").con("x1", xDeLaBarra).con("y1", tablatura.arriba).con("x2", xDeLaBarra)
                        .con("y2", tablatura.abajo).con("stroke-width", grosor).vacio)
            }
        }
        // Barra del principio (si hay dos pentagramas, una sola que los une) y barra final.
        let abajoDelSistema = PentagramaSVG.y(deLugar: 0, pentagrama: pentagramas - 1)
        for xDeLaBarra in [0, final] {
            lineas.append(
                elemento("line").con("x1", xDeLaBarra).con("y1", 0).con("x2", xDeLaBarra).con("y2", abajoDelSistema)
                    .con("stroke-width", "0.16").vacio)
        }
        // Con ritmo, al final, la barra doble: fina y gruesa.
        if ritmo != nil {
            lineas.append(
                elemento("line").con("x1", final - 0.25).con("y1", 0).con("x2", final - 0.25)
                    .con("y2", abajoDelSistema).con("stroke-width", "0.5").vacio)
            lineas.append(
                elemento("line").con("x1", final - 0.95).con("y1", 0).con("x2", final - 0.95)
                    .con("y2", abajoDelSistema).con("stroke-width", "0.16").vacio)
        }
        return lineas
    }

    /// Un texto centrado en `x`, estirado o encogido a lo que se calcula que mide.
    private func textoCentrado(_ texto: String, x: Double, y: Double, cuerpoDeLetra: Double) -> String {
        elemento("text").con("x", x).con("y", y).con("text-anchor", "middle").con("font-size", cuerpoDeLetra)
            .con("lengthAdjust", "spacingAndGlyphs")
            .con(
                "textLength",
                PentagramaSVG.anchoEstimado(
                    texto, cuerpoDeLetra: cuerpoDeLetra, proporcion: opciones.anchoDeLosCaracteres)
            )
            .con("font-family", "sans-serif").conTexto(texto)
    }

    /// Los cifrados, encima, y los nombres, los intervalos, los grados y el bajo cifrado, debajo.
    private func textosDelSistema(
        _ maquetacion: Maquetacion, minimoY: Double, maximoY: Double, yDeLosGrados: Double, yDelBajoCifrado: Double
    ) -> [String] {
        var textos: [String] = []
        if let cifrado, let cx = maquetacion.cifradoX {
            let letra = PentagramaSVG.letraDelCifrado
            textos.append(textoCentrado(cifrado, x: cx, y: minimoY - 0.6, cuerpoDeLetra: letra))
        }
        for cifrado in maquetacion.cifrados {
            let letra = PentagramaSVG.letraDelCifrado
            textos.append(textoCentrado(cifrado.texto, x: cifrado.x, y: minimoY - 0.6, cuerpoDeLetra: letra))
        }
        for etiqueta in maquetacion.etiquetas {
            let letra = PentagramaSVG.letraDeLasEtiquetas
            textos.append(textoCentrado(etiqueta.texto, x: etiqueta.x, y: maximoY + 1.6, cuerpoDeLetra: letra))
        }
        let yDeLosIntervalos = maximoY + 1.6 + (opciones.nombresDeLasNotas ? 1.5 : 0)
        for intervalo in maquetacion.intervalos {
            let letra = PentagramaSVG.letraDeLasEtiquetas
            textos.append(textoCentrado(intervalo.texto, x: intervalo.x, y: yDeLosIntervalos, cuerpoDeLetra: letra))
        }
        for grado in maquetacion.grados {
            let letra = PentagramaSVG.letraDeLosGrados
            textos.append(textoCentrado(grado.texto, x: grado.x, y: yDeLosGrados, cuerpoDeLetra: letra))
        }
        for columna in maquetacion.bajoCifrado {
            for (i, cifra) in columna.cifras.enumerated() {
                let y = yDelBajoCifrado + PentagramaSVG.separacionDelBajoCifrado * Double(i)
                let letra = PentagramaSVG.letraDelBajoCifrado
                textos.append(textoCentrado(cifra, x: columna.x, y: y, cuerpoDeLetra: letra))
            }
        }
        return textos
    }
}
