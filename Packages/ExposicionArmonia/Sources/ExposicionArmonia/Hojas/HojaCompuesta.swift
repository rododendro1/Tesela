import Armonia
import Foundation

// MARK: - Una hoja hecha de secciones

/// Una hoja de estudio hecha de secciones, que se escribe igual en SVG, en páginas A4 para imprimir, y en HTML: la de
/// todas las hojas de `HojaDeEstudio`. Arriba van el título, las notas, los nombres originales y los subtítulos, con
/// un dibujo a la derecha si lo lleva; debajo, las secciones, cada una con su título y sus piezas: datos («nombre:
/// valor»), líneas de texto, tablas, listas, el carácter, dibujos y, en las comparaciones, lo de cada escala o
/// progresión en su color.
struct HojaCompuesta {
    /// El color de un texto en una comparación: lo de la primera (el origen), lo de la segunda (el destino), lo
    /// común a las dos o, en gris, lo que acompaña.
    enum Tono: String {
        case origen, destino, comun, suave

        /// Su color en SVG.
        var color: String {
            switch self {
            case .origen: PresentacionDeEstudioDeEscala.ColorDeLaComparacion.origen
            case .destino: PresentacionDeEstudioDeEscala.ColorDeLaComparacion.destino
            case .comun: PresentacionDeEstudioDeEscala.ColorDeLaComparacion.comun
            case .suave: "#888888"
            }
        }

        /// Su clase en HTML, que le da el color en la hoja de estilo.
        var clase: String { self == .suave ? "sub" : rawValue }
    }

    /// Un elemento de una lista: una etiqueta delante (el grado, el brillo, el nombre de una escala) y su texto,
    /// resaltado si es el de partida.
    struct Elemento {
        let etiqueta: String?
        let texto: String
        var resaltado = false
    }

    /// Una celda de una tabla marcada: su texto, su tono, en negrita o no y con el fondo resaltado si es lo que
    /// cambia.
    struct Celda {
        let texto: String
        var tono: Tono? = nil
        var negrita = false
        var resaltada = false
    }

    /// Lo que va dentro de una sección.
    enum Pieza {
        /// Un dato por línea, «nombre: valor», partido si no cabe.
        case datos([DatoPresentado])
        /// Líneas de texto sueltas.
        case lineas([String])
        /// Líneas de texto en gris: las notas de una secuencia, los avisos, lo que se mueve en total.
        case apartes([String])
        /// Líneas en negrita: el resumen de una comparación.
        case destacado([String])
        /// El título de una parte de la sección: una secuencia, un paso de la conducción, una modulación.
        case subtitulo(String)
        /// Una tabla, una fila por elemento, con las columnas alineadas y la primera en negrita. Una fila de una sola
        /// celda en una tabla de varias columnas es la cabecera de un tramo (una modulación).
        case tabla([[String]])
        /// Una tabla con cada celda marcada: su color, en negrita o con el fondo resaltado. En HTML, una fila con
        /// todas resaltadas es una fila que cambia.
        case tablaMarcada([[Celda]])
        /// La leyenda de los colores: un punto del color delante de cada texto.
        case leyenda([(texto: String, tono: Tono)])
        /// Una lista, como mucho `porFila` elementos en cada línea del SVG (los que quepan; en HTML, como quepan),
        /// con la clase de la lista.
        case lista([Elemento], porFila: Int, clase: String?)
        /// Los acordes de los grados, en columnas: el grado, el acorde y su función.
        case grados([(grado: String, acorde: String, funcion: String)])
        /// Lo que dicen las fuentes del carácter (en HTML, con sus palabras entre comillas), lo que mide un estudio y
        /// la sonoridad calculada.
        case caracter([Caracter], medidas: [MedidaDelAfecto], sonoridad: Sonoridad?)
        /// Un dibujo SVG, en `fraccion` del ancho de la sección (de lado a lado con 1).
        case dibujo(String, fraccion: Double)
        /// Varios dibujos con su título encima (o sin él, si está vacío), `porFila` en cada fila.
        case dibujos([(titulo: String, svg: String)], porFila: Int)

        /// Si no tiene nada que escribir.
        var vacia: Bool {
            switch self {
            case .datos(let datos): datos.isEmpty
            case .lineas(let lineas), .apartes(let lineas), .destacado(let lineas): lineas.isEmpty
            case .subtitulo(let texto): texto.isEmpty
            case .tabla(let filas): filas.isEmpty
            case .tablaMarcada(let filas): filas.isEmpty
            case .leyenda(let leyenda): leyenda.isEmpty
            case .lista(let elementos, _, _): elementos.isEmpty
            case .grados(let grados): grados.isEmpty
            case .caracter(let caracter, let medidas, let sonoridad):
                caracter.isEmpty && medidas.isEmpty && sonoridad == nil
            case .dibujo(let svg, _): svg.isEmpty
            case .dibujos(let dibujos, _): dibujos.isEmpty
            }
        }
    }

    /// Una sección: su título (ninguno, si está vacío) con su color si lo lleva, sus piezas, su clase en HTML y las
    /// secciones que van a su derecha, en una columna de `anchoAlLado` (el reloj, al lado de las estadísticas). Una
    /// sección sin piezas, o con piezas vacías, no se escribe; si es la de la izquierda, las de su lado ocupan su
    /// sitio.
    struct Seccion {
        let titulo: String
        var piezas: [Pieza]
        var clase: String? = nil
        var alLado: [Seccion] = []
        var tono: Tono? = nil
        var anchoAlLado = HojaCompuesta.anchoAlLado
    }

    let titulo: String
    /// Un segundo título, debajo y en el color del destino: la progresión con que se compara la primera.
    var otroTitulo: String? = nil
    var subtitulos: [String] = []
    /// Las notas, debajo del título (en HTML, en una lista).
    var notas: [String] = []
    /// Los nombres en su idioma y su escritura: 陽音階 (Yō onkai).
    var originales: [NombreOriginalPresentado] = []
    /// Un dibujo a la derecha del título (en HTML, debajo): el pentagrama de un acorde.
    var dibujoDelEncabezado: String? = nil
    let secciones: [Seccion]

    /// El ancho de la columna de las secciones de al lado, si no se da otro, y del dibujo del encabezado.
    static let anchoAlLado = 170.0

    /// Las secciones que tienen algo, sin las piezas vacías.
    private var conAlgo: [Seccion] {
        func filtrada(_ seccion: Seccion) -> Seccion {
            var copia = seccion
            copia.piezas = seccion.piezas.filter { !$0.vacia }
            copia.alLado = seccion.alLado.map(filtrada).filter { !$0.piezas.isEmpty }
            return copia
        }
        return secciones.map(filtrada).filter { !$0.piezas.isEmpty || !$0.alLado.isEmpty }
    }

    // MARK: En SVG

    /// Un trozo de la hoja que no se parte entre dos páginas (una línea, una fila de una tabla, un dibujo): lo que
    /// dibuja, desde dónde empieza en su sección y su alto. Con `conElSiguiente`, va en la misma página que el que le
    /// sigue: el título de una sección, con lo primero de ella.
    private struct Bloque {
        var cuerpo: [String] = []
        var desde = 0.0
        var alto = 0.0
        var conElSiguiente = false
    }

    /// Lo que va escribiendo una sección: el cuerpo del bloque abierto, por dónde va (`y`, lo alto de lo que queda
    /// libre) y los bloques que ha cerrado.
    private struct Escritor {
        var bloques: [Bloque] = []
        var cuerpo: [String] = []
        var y = 0.0
        var desde = 0.0

        /// Cierra el bloque abierto y empieza otro.
        mutating func cerrar(conElSiguiente: Bool = false) {
            guard !cuerpo.isEmpty else { return }
            bloques.append(Bloque(cuerpo: cuerpo, desde: desde, alto: y - desde, conElSiguiente: conElSiguiente))
            cuerpo = []
            desde = y
        }
    }

    /// La hoja en SVG, en páginas A4 una debajo de otra: el encabezado arriba y las secciones debajo. Una sección de
    /// hasta media página que no cabe en lo que queda de una empieza en la siguiente; una más larga se parte entre
    /// línea y línea o entre dibujo y dibujo, sin dejar su título ni el de una parte solo al final de una página. Con
    /// más de una página, cada una lleva su número abajo; la raíz dice cuántas hay en `data-paginas`, para
    /// `HojaDeEstudio.paginas(deUnSVG:)`.
    func svg(en notacion: Notacion) -> String {
        let margen = Hoja.margen
        let util = Hoja.ancho - 2 * margen
        var secciones = [[encabezado(ancho: util)]]
        for seccion in conAlgo {
            guard !seccion.alLado.isEmpty else {
                secciones.append(bloques(seccion, x: margen, ancho: util, notacion))
                continue
            }
            // Las de su lado van con el primer bloque de la sección, que se pega a los que le siguen hasta llegar a
            // su alto; lo de debajo puede pasar a otra página.
            let lado = seccion.anchoAlLado
            let x = seccion.piezas.isEmpty ? margen : margen + util - lado
            let derecha = Self.juntos(Self.apilados(seccion.alLado.map { bloques($0, x: x, ancho: lado, notacion) }))
            var izquierda = seccion.piezas.isEmpty ? [] : bloques(seccion, x: margen, ancho: util - lado - 12, notacion)
            guard !izquierda.isEmpty else {
                secciones.append([derecha])
                continue
            }
            izquierda[0].cuerpo += derecha.cuerpo
            var cubierto = 0.0
            for i in izquierda.indices {
                cubierto += izquierda[i].alto
                if cubierto >= derecha.alto { break }
                if i == izquierda.count - 1 {
                    izquierda[i].alto += derecha.alto - cubierto
                } else {
                    izquierda[i].conElSiguiente = true
                }
            }
            secciones.append(izquierda)
        }
        // Las secciones, en las páginas.
        let pagina = Hoja.altoDeLaPagina
        var cuerpo: [String] = []
        var numero = 0
        var y = margen
        func cabe(_ alto: Double) -> Bool {
            y + alto <= Double(numero) * pagina + pagina - margen || y == Double(numero) * pagina + margen
        }
        func saltar() {
            numero += 1
            y = Double(numero) * pagina + margen
        }
        for bloques in secciones {
            let alto = bloques.reduce(0) { $0 + $1.alto }
            if !cabe(alto) && alto <= (pagina - 2 * margen) / 2 { saltar() }
            var grupo: [Bloque] = []
            for (i, bloque) in bloques.enumerated() {
                grupo.append(bloque)
                guard !bloque.conElSiguiente || i == bloques.count - 1 else { continue }
                if !cabe(grupo.reduce(0) { $0 + $1.alto }) { saltar() }
                for bloque in grupo {
                    cuerpo.append("<g transform=\"translate(0,\(Hoja.numero(y - bloque.desde)))\">")
                    cuerpo += bloque.cuerpo
                    cuerpo.append("</g>")
                    y += bloque.alto
                }
                grupo = []
            }
        }
        let paginas = numero + 1
        if paginas > 1 {
            for i in 0..<paginas {
                let base = Double(i) * pagina + pagina - 20
                cuerpo.append(
                    "<text x=\"\(Hoja.numero(Hoja.ancho / 2))\" y=\"\(Hoja.numero(base))\" font-size=\"9\" "
                        + "fill=\"#777777\" text-anchor=\"middle\">\(i + 1) / \(paginas)</text>")
            }
        }
        return Hoja.hojaSVG(ancho: Hoja.ancho, alto: Double(paginas) * pagina, cuerpo, paginas: paginas)
    }

    /// Los bloques de varias secciones, una debajo de otra, con las de debajo bajadas lo que ocupan las de encima.
    private static func apilados(_ secciones: [[Bloque]]) -> [Bloque] {
        var y = 0.0
        return secciones.flatMap { bloques in
            let bajados = bloques.map { bloque in
                Bloque(
                    cuerpo: ["<g transform=\"translate(0,\(Hoja.numero(y)))\">"] + bloque.cuerpo + ["</g>"],
                    desde: bloque.desde + y, alto: bloque.alto)
            }
            y += bloques.reduce(0) { $0 + $1.alto }
            return bajados
        }
    }

    /// Los bloques de una sección en uno solo.
    private static func juntos(_ bloques: [Bloque]) -> Bloque {
        Bloque(
            cuerpo: bloques.flatMap(\.cuerpo), desde: bloques.first?.desde ?? 0,
            alto: bloques.reduce(0) { $0 + $1.alto })
    }

    /// El encabezado, en un bloque: el título (y el otro, si lo hay), partido si no cabe, y debajo las notas, los
    /// nombres originales y los subtítulos; a la derecha, el dibujo, sin que el texto se meta en él.
    private func encabezado(ancho util: Double) -> Bloque {
        let margen = Hoja.margen
        var cuerpo: [String] = []
        var altoDelDibujo = 0.0
        if let dibujo = dibujoDelEncabezado {
            let lado = Self.anchoAlLado
            altoDelDibujo = Hoja.incrustar(dibujo, x: margen + util - lado, y: 0, ancho: lado, en: &cuerpo)
        }
        let ancho = dibujoDelEncabezado == nil ? util : util - Self.anchoAlLado - 12
        var y = 0.0
        let titulos: [(texto: String, tono: Tono?)] = [(titulo, nil), (otroTitulo ?? "", .destino)]
        for (texto, tono) in titulos {
            for linea in Hoja.partir(texto, ancho: ancho, tamano: 22, negrita: true) {
                cuerpo.append(
                    Hoja.texto(linea, x: margen, y: y + 22, tamano: 22, negrita: true, color: tono?.color ?? "#222222"))
                y += 28
            }
        }
        let originales = originales.map { $0.texto + ($0.lectura.map { " (" + $0 + ")" } ?? "") }
        let debajo = [notas.joined(separator: " "), originales.joined(separator: " · ")] + subtitulos
        for subtitulo in debajo {
            for linea in Hoja.partir(subtitulo, ancho: ancho, tamano: 13) {
                y += 17
                cuerpo.append(Hoja.texto(linea, x: margen, y: y, tamano: 13, color: "#555555"))
            }
        }
        return Bloque(cuerpo: cuerpo, alto: max(y, altoDelDibujo) + 12)
    }

    /// Una sección en SVG, desde `x` y en `ancho`, en bloques: su título, pegado a lo primero, y cada línea, dato,
    /// fila o dibujo de sus piezas.
    private func bloques(_ seccion: Seccion, x: Double, ancho: Double, _ notacion: Notacion) -> [Bloque] {
        var escritor = Escritor()
        /// Un texto en la línea que toca, `dentro` puntos más a la derecha.
        func texto(
            _ contenido: String, dentro: Double = 0, tamano: Double = 11, negrita: Bool = false,
            color: String = "#222222"
        ) {
            escritor.cuerpo.append(
                Hoja.texto(
                    contenido, x: x + dentro, y: escritor.y + 12, tamano: tamano, negrita: negrita, color: color))
            escritor.y += 16
        }
        if !seccion.titulo.isEmpty {
            let lineas = Hoja.partir(seccion.titulo, ancho: ancho, tamano: 14, negrita: true)
            for (i, linea) in lineas.enumerated() {
                escritor.cuerpo.append(
                    Hoja.texto(
                        linea, x: x, y: escritor.y + 12, tamano: 14, negrita: true,
                        color: seccion.tono?.color ?? "#222222"))
                escritor.y += i == lineas.count - 1 ? 20 : 18
            }
            escritor.cerrar(conElSiguiente: true)
        }
        func lineas(_ lineas: [String], negrita: Bool = false, color: String = "#222222") {
            for linea in lineas {
                for parte in Hoja.partir(linea, ancho: ancho, tamano: 11, negrita: negrita) {
                    texto(parte, negrita: negrita, color: color)
                }
                escritor.cerrar()
            }
        }
        func datos(_ datos: [DatoPresentado]) {
            for dato in datos {
                for (i, linea) in Hoja.partir(dato.nombre + ": " + dato.valor, ancho: ancho - 12, tamano: 11)
                    .enumerated()
                {
                    // Las líneas que siguen a la primera, un poco metidas, para que se vea dónde empieza cada dato.
                    texto(linea, dentro: i == 0 ? 0 : 12)
                }
                escritor.cerrar()
            }
        }
        func tabla(_ filas: [[Celda]]) {
            let columnas = filas.map(\.count).max() ?? 0
            // Las cabeceras de los tramos, que ocupan toda la fila, no cuentan para el ancho de las columnas.
            let medidas = filas.filter { $0.count > 1 || columnas == 1 }
            var anchos = (0..<columnas).map { c in
                14
                    + (medidas.map {
                        c < $0.count ? Hoja.anchoDelTexto($0[c].texto, tamano: 11, negrita: $0[c].negrita) : 0
                    }
                    .max() ?? 0)
            }
            // Si no cabe, se estrecha la columna más ancha, hasta 60 puntos, y sus celdas se parten.
            while anchos.reduce(0, +) > ancho, let mayor = anchos.indices.max(by: { anchos[$0] < anchos[$1] }),
                anchos[mayor] > 60
            {
                anchos[mayor] = max(60, anchos[mayor] - (anchos.reduce(0, +) - ancho))
            }
            for fila in filas {
                if fila.count == 1 && columnas > 1 {
                    let antes = escritor.bloques.count
                    lineas([fila[0].texto], negrita: true, color: "#555555")
                    if escritor.bloques.count > antes { escritor.bloques[antes].conElSiguiente = true }
                    continue
                }
                let partidas = fila.enumerated().map { c, celda in
                    Hoja.partir(celda.texto, ancho: anchos[c] - 8, tamano: 11, negrita: celda.negrita)
                }
                let alto = 16 * Double(max(partidas.map(\.count).max() ?? 1, 1))
                var columna = x
                for (c, celda) in fila.enumerated() {
                    if celda.resaltada {
                        escritor.cuerpo.append(
                            "<rect x=\"\(Hoja.numero(columna - 4))\" y=\"\(Hoja.numero(escritor.y))\" "
                                + "width=\"\(Hoja.numero(anchos[c]))\" height=\"\(Hoja.numero(alto))\" "
                                + "fill=\"\(PresentacionDeEstudioDeEscala.ColorDeLaComparacion.cambio)\"/>")
                    }
                    for (i, linea) in partidas[c].enumerated() {
                        escritor.cuerpo.append(
                            Hoja.texto(
                                linea, x: columna, y: escritor.y + 12 + 16 * Double(i), tamano: 11,
                                negrita: celda.negrita, color: celda.tono?.color ?? "#222222"))
                    }
                    columna += anchos[c]
                }
                escritor.y += alto
                escritor.cerrar()
            }
        }
        for pieza in seccion.piezas {
            switch pieza {
            case .datos(let lista):
                datos(lista)
            case .caracter(let caracter, let medidas, let sonoridad):
                datos(Hoja.filasDelCaracter(caracter, medidas: medidas, sonoridad: sonoridad, en: notacion))
            case .lineas(let lista):
                lineas(lista)
            case .apartes(let lista):
                lineas(lista, color: "#555555")
            case .destacado(let lista):
                escritor.y += 4
                lineas(lista, negrita: true)
            case .subtitulo(let contenido):
                escritor.y += 4
                escritor.cuerpo.append(Hoja.texto(contenido, x: x, y: escritor.y + 12, tamano: 11, negrita: true))
                escritor.y += 15
                escritor.cerrar(conElSiguiente: true)
            case .tabla(let filas):
                tabla(filas.map { fila in fila.enumerated().map { Celda(texto: $1, negrita: $0 == 0) } })
            case .tablaMarcada(let filas):
                tabla(filas)
            case .leyenda(let leyenda):
                for (contenido, tono) in leyenda {
                    for (i, linea) in Hoja.partir(contenido, ancho: ancho - 16, tamano: 11).enumerated() {
                        if i == 0 {
                            escritor.cuerpo.append(
                                "<circle cx=\"\(Hoja.numero(x + 5))\" cy=\"\(Hoja.numero(escritor.y + 8))\" r=\"5\" "
                                    + "fill=\"\(tono.color)\"/>")
                        }
                        texto(linea, dentro: 16)
                    }
                    escritor.y += 2
                    escritor.cerrar()
                }
            case .lista(let elementos, let porFila, _):
                // En una lista de uno por línea, el texto tras una raya: «Sol mixolidio — Tensiones: La 9».
                let separador = porFila == 1 ? " — " : " "
                let escritos = elementos.map { elemento in
                    (elemento.resaltado ? "▸ " : "")
                        + [elemento.etiqueta, elemento.texto].compactMap { $0 }
                        .filter { !$0.isEmpty }.joined(separator: separador)
                }
                // En cada línea, los que quepan, `porFila` como mucho.
                var filas: [[String]] = []
                for escrito in escritos {
                    let junta = ((filas.last ?? []) + [escrito]).joined(separator: " · ")
                    if let ultima = filas.last, ultima.count < porFila,
                        Hoja.anchoDelTexto(junta, tamano: 11) <= ancho
                    {
                        filas[filas.count - 1].append(escrito)
                    } else {
                        filas.append([escrito])
                    }
                }
                lineas(filas.map { $0.joined(separator: " · ") })
            case .grados(let grados):
                let columna = ancho / Double(max(grados.count, 1))
                for (i, grado) in grados.enumerated() {
                    let izquierda = x + Double(i) * columna
                    let y = escritor.y
                    escritor.cuerpo.append(Hoja.texto(grado.grado, x: izquierda, y: y + 12, tamano: 12, negrita: true))
                    escritor.cuerpo.append(Hoja.texto(grado.acorde, x: izquierda, y: y + 28, tamano: 12))
                    escritor.cuerpo.append(
                        Hoja.texto(grado.funcion, x: izquierda, y: y + 43, tamano: 9, color: "#666666"))
                }
                escritor.y += 48
                escritor.cerrar()
            case .dibujo(let svg, let fraccion):
                // No más del doble de su ancho, como en HTML, para que un pentagrama corto no salga enorme.
                let natural = Hoja.anchoPropio(svg).map { 2 * $0 } ?? ancho
                let alto = Hoja.incrustar(
                    svg, x: x, y: escritor.y + 6, ancho: min(ancho * fraccion, natural), en: &escritor.cuerpo)
                escritor.y += alto + 4
                escritor.cerrar()
            case .dibujos(let dibujos, let porFila):
                let porFila = max(porFila, 1)
                let separacion = 12.0
                let cada = (ancho - separacion * Double(porFila - 1)) / Double(porFila)
                // Los títulos encima de los dibujos; si no tiene ninguno, los dibujos empiezan arriba.
                let arriba = dibujos.contains { !$0.titulo.isEmpty } ? 18.0 : 6.0
                for inicio in stride(from: 0, to: dibujos.count, by: porFila) {
                    var alto = 0.0
                    for (i, dibujo) in dibujos[inicio..<min(inicio + porFila, dibujos.count)].enumerated() {
                        let izquierda = x + Double(i) * (cada + separacion)
                        if !dibujo.titulo.isEmpty {
                            escritor.cuerpo.append(
                                Hoja.texto(
                                    dibujo.titulo, x: izquierda, y: escritor.y + 13, tamano: 10, color: "#555555"))
                        }
                        let suyo = Hoja.incrustar(
                            dibujo.svg, x: izquierda, y: escritor.y + arriba, ancho: cada, en: &escritor.cuerpo)
                        alto = max(alto, suyo)
                    }
                    escritor.y += arriba + alto + 4
                    escritor.cerrar()
                }
            }
        }
        // Lo que separa la sección de la siguiente, en su último bloque.
        escritor.cerrar()
        if !escritor.bloques.isEmpty { escritor.bloques[escritor.bloques.count - 1].alto += 10 }
        return escritor.bloques
    }

    // MARK: En HTML

    /// La hoja como página HTML: los datos en listas de definiciones, las tablas en tablas, las listas en listas y los
    /// dibujos como SVG dentro; las secciones de al lado, en una segunda columna. Al imprimirla, ninguna sección se
    /// parte entre dos páginas.
    func html(en notacion: Notacion) -> String {
        var cabecera = "<header><h1>" + Hoja.html(titulo) + "</h1>"
        if let otroTitulo { cabecera += "<h1 class=\"destino\">" + Hoja.html(otroTitulo) + "</h1>" }
        if !originales.isEmpty {
            cabecera +=
                "<p class=\"originales\">" + originales.map(Hoja.nombreOriginalHTML).joined(separator: " · ") + "</p>"
        }
        if !notas.isEmpty {
            cabecera += "<ul class=\"notas\">" + notas.map { "<li>" + Hoja.html($0) + "</li>" }.joined() + "</ul>"
        }
        cabecera += subtitulos.filter { !$0.isEmpty }.map { "<p class=\"sub\">" + Hoja.html($0) + "</p>" }.joined()
        var cuerpo = [cabecera + "</header>"]
        if let dibujo = dibujoDelEncabezado { cuerpo.append(Hoja.figura(dibujo, clase: "pequena")) }
        for seccion in conAlgo {
            if seccion.alLado.isEmpty {
                cuerpo.append(html(seccion, en: notacion))
            } else {
                let columnas = (seccion.piezas.isEmpty ? [] : [seccion]) + seccion.alLado
                let estilo =
                    seccion.anchoAlLado == Self.anchoAlLado
                    ? "" : " style=\"grid-template-columns:1fr \(Hoja.numero(seccion.anchoAlLado))pt\""
                cuerpo.append(
                    "<div class=\"columnas\"" + estilo + ">" + columnas.map { html($0, en: notacion) }.joined()
                        + "</div>")
            }
        }
        let titulos = [titulo] + (otroTitulo.map { [$0] } ?? [])
        return Hoja.paginaHTML(
            titulo: notacion.texto(\.hojaDeEstudio) + " · " + titulos.joined(separator: " → "),
            idioma: notacion.textos.codigo, cuerpo)
    }

    /// Una sección en HTML, con su título y su clase.
    private func html(_ seccion: Seccion, en notacion: Notacion) -> String {
        let contenido = seccion.piezas.map { pieza -> String in
            switch pieza {
            case .datos(let datos):
                let filas = datos.map {
                    "<div><dt>" + Hoja.html($0.nombre) + "</dt><dd>" + Hoja.html($0.valor) + "</dd></div>"
                }
                return "<dl>" + filas.joined() + "</dl>"
            case .caracter(let caracter, let medidas, let sonoridad):
                return Hoja.caracterHTML(caracter, medidas: medidas, sonoridad: sonoridad, en: notacion)
            case .lineas(let lineas):
                return lineas.map { "<p>" + Hoja.html($0) + "</p>" }.joined()
            case .apartes(let lineas):
                return lineas.map { "<p class=\"sub\">" + Hoja.html($0) + "</p>" }.joined()
            case .destacado(let lineas):
                return lineas.map { "<p><strong>" + Hoja.html($0) + "</strong></p>" }.joined()
            case .subtitulo(let texto):
                return "<h3>" + Hoja.html(texto) + "</h3>"
            case .tabla(let filas):
                let columnas = filas.map(\.count).max() ?? 0
                return Hoja.tablaHTML(filas.map { (celdas: $0, clase: $0.count == 1 && columnas > 1 ? "tramo" : nil) })
            case .tablaMarcada(let filas):
                return Self.tablaMarcadaHTML(filas)
            case .leyenda(let leyenda):
                let filas = leyenda.map {
                    "<li><span class=\"punto " + $0.tono.clase + "\"></span>" + Hoja.html($0.texto) + "</li>"
                }
                return "<ul class=\"leyenda\">" + filas.joined() + "</ul>"
            case .lista(let elementos, _, let clase):
                let filas = elementos.map { elemento in
                    let texto =
                        (elemento.etiqueta.map { "<span class=\"etiqueta\">" + Hoja.html($0) + "</span> " } ?? "")
                        + Hoja.html(elemento.texto)
                    return elemento.resaltado
                        ? "<li aria-current=\"true\"><strong>" + texto + "</strong></li>" : "<li>" + texto + "</li>"
                }
                return "<ul" + (clase.map { " class=\"" + $0 + "\"" } ?? "") + ">" + filas.joined() + "</ul>"
            case .grados(let grados):
                let filas = grados.map {
                    "<li><strong>" + Hoja.html($0.grado) + "</strong><span>" + Hoja.html($0.acorde) + "</span><small>"
                        + Hoja.html($0.funcion) + "</small></li>"
                }
                return "<ul class=\"grados\">" + filas.joined() + "</ul>"
            case .dibujo(let svg, let fraccion):
                return Hoja.figura(svg, clase: fraccion < 1 ? "pequena" : "ancha")
            case .dibujos(let dibujos, let porFila):
                let figuras = dibujos.map {
                    ($0.titulo.isEmpty ? "" : "<h3>" + Hoja.html($0.titulo) + "</h3>")
                        + Hoja.figura($0.svg, clase: porFila == 1 ? "ancha" : "dibujo")
                }
                guard porFila > 1 else { return figuras.joined() }
                let clase = porFila > 2 ? "digitaciones" : "teclados"
                return "<div class=\"" + clase + "\">" + figuras.map { "<div>" + $0 + "</div>" }.joined() + "</div>"
            }
        }
        return Hoja.seccionHTML(seccion.titulo, contenido.joined(), clase: seccion.clase, tono: seccion.tono?.clase)
    }

    /// Una tabla marcada en HTML: cada celda con las clases de su color, su negrita y su resalte; una fila con todas
    /// resaltadas, con la clase `cambia`.
    private static func tablaMarcadaHTML(_ filas: [[Celda]]) -> String {
        let cuerpo = filas.map { fila -> String in
            let cambia = !fila.isEmpty && fila.allSatisfy(\.resaltada)
            let celdas = fila.map { celda -> String in
                let clases = [
                    celda.tono?.clase, celda.negrita ? "negrita" : nil, celda.resaltada && !cambia ? "resaltada" : nil,
                ].compactMap { $0 }
                return "<td" + (clases.isEmpty ? "" : " class=\"" + clases.joined(separator: " ") + "\"") + ">"
                    + Hoja.html(celda.texto) + "</td>"
            }
            return "<tr" + (cambia ? " class=\"cambia\"" : "") + ">" + celdas.joined() + "</tr>"
        }
        return "<div class=\"tabla\"><table>" + cuerpo.joined() + "</table></div>"
    }
}
