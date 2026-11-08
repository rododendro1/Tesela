import Armonia

// MARK: - La ayuda
//
// La ayuda de `armonia` en los trece idiomas de los textos, montada a partir de una tabla de órdenes:
// cada orden tiene su sintaxis, su descripción, un ejemplo y, si hace falta, unas notas, cada cosa
// en los trece idiomas (`Traduccion` no compila si falta alguno). Las columnas se calculan: la
// sintaxis va en la columna 2, la descripción en la 31 y el ejemplo en la 69. Una sintaxis que no
// cabe en su columna deja la descripción en la línea siguiente, y un ejemplo que no cabe al final
// de la descripción va en una línea propia. La descripción y las notas se cortan solas, por palabras, a
// `anchoDeLaDescripcion`: en los textos, cada "\n" empieza un párrafo («--escalas: …», «opciones: …»).
//
// Cada orden (`Orden`, en LineaDeComandos.swift) lleva sus entradas de la ayuda. Las órdenes están en
// Ayuda+Consultas.swift, Ayuda+Armonizacion.swift y los demás Ayuda+*.swift, uno por cada LineaDeComandos+*.swift,
// con sus nombres, lo que hacen y su ayuda; aquí quedan la cabecera, el pie y la propia ayuda.

extension LineaDeComandos {
    /// Una orden de la ayuda. La sintaxis lleva una línea por cada forma de escribir la orden; la descripción y
    /// las notas, un párrafo por línea (separados por "\n"), que `ajustar` corta a `anchoDeLaDescripcion`.
    struct EntradaDeAyuda: Sendable {
        /// Una línea por cada forma de escribir la orden.
        let sintaxis: Traduccion
        let descripcion: Traduccion
        /// Se escribe al final de la descripción, en la columna de los ejemplos.
        var ejemplo: Traduccion? = nil
        /// Líneas que siguen al ejemplo, en la columna de la descripción. Un texto vacío es que no hay.
        var notas: Traduccion? = nil
        /// Las opciones que explica la entrada, sin las generales: las de su orden (`Orden.opciones`). Sus nombres
        /// son los que nombran sus textos (`AyudaTests`).
        var opciones: [OpcionDeOrden] = []
    }

    static let columnaDeLaSintaxis = 2
    static let columnaDeLaDescripcion = 31
    static let columnaDelEjemplo = 69
    /// Lo que ocupa una línea de la descripción o de las notas: hasta la columna anterior a la del ejemplo, para que
    /// quepa detrás.
    static let anchoDeLaDescripcion = columnaDelEjemplo - columnaDeLaDescripcion - 1

    /// Los párrafos del texto (uno por línea) cortados por palabras a `ancho`. Una palabra más larga que `ancho` va
    /// sola en su línea; un párrafo vacío, una línea vacía.
    static func ajustar(_ texto: String, ancho: Int = anchoDeLaDescripcion) -> [String] {
        var lineas: [String] = []
        for parrafo in texto.components(separatedBy: "\n") {
            var actual = ""
            for palabra in parrafo.split(separator: " ") {
                if !actual.isEmpty, actual.count + 1 + palabra.count > ancho {
                    lineas.append(actual)
                    actual = ""
                }
                actual += (actual.isEmpty ? "" : " ") + palabra
            }
            lineas.append(actual)
        }
        return lineas
    }

    /// La ayuda completa en un idioma.
    static func textoDeAyuda(en idioma: Idioma, grafia: Grafia = .original) -> String {
        let ordenes = ordenesDeLaAyuda.flatMap { lineas(de: $0, en: idioma, grafia: grafia) }
        let cabecera = cabeceraDeLaAyuda.texto(en: idioma, grafia: grafia)
        return ([cabecera] + ordenes + ["", pieDeLaAyuda.texto(en: idioma, grafia: grafia)])
            .joined(separator: "\n")
    }

    /// El índice de la ayuda (`armonia ayuda`, o `armonia` a secas): la cabecera, una línea por orden con lo que hace,
    /// por grupos, y cómo pedir más. Las descripciones se juntan en una línea y se cortan a `anchoDelIndice`.
    static func indiceDeAyuda(en idioma: Idioma, grafia: Grafia = .original) -> String {
        // Se translitera antes de colocarlo en columnas, porque en griego cambia de largo (θ → th).
        func escrito(_ texto: String) -> String { Transliteracion.texto(texto, en: grafia) }
        let titulos = TextosDeConsola.traduccion(\.gruposDeLaAyuda).texto(en: idioma, grafia: grafia)
        var lineas = [cabeceraDeLaAyuda.texto(en: idioma, grafia: grafia)]
        for (titulo, grupo) in zip(titulos, gruposDeOrdenes) {
            lineas += ["", titulo + ":"]
            var vistas: Set<String> = []
            for orden in grupo {
                guard let primera = orden.ayuda.first, let nombre = nombreEnLaAyuda(primera, en: idioma).map(escrito),
                    vistas.insert(nombre).inserted
                else { continue }
                lineas += lineasDelIndice(nombre, escrito(resumen(primera.descripcion.texto(en: idioma))))
            }
        }
        let pie = TextosDeConsola.traduccion(\.pieDelIndice).texto(en: idioma, grafia: grafia)
        return (lineas + ["", pie]).joined(separator: "\n")
    }

    static let anchoDelIndice = 80
    static let columnaDelResumen = 27

    /// El nombre de la orden como sale en la ayuda en ese idioma: la primera palabra de su sintaxis.
    static func nombreEnLaAyuda(_ entrada: EntradaDeAyuda, en idioma: Idioma) -> String? {
        entrada.sintaxis.texto(en: idioma).split(whereSeparator: { $0 == " " || $0 == "\n" }).first.map(String.init)
    }

    /// La descripción en una línea y sin lo que es de la ayuda completa: sin las líneas de opciones ni paréntesis, y
    /// hasta el primer «;», «:» u opción («--acordes»).
    static func resumen(_ descripcion: String) -> String {
        // Las líneas que explican opciones («--acordes: …», «opciones: …») son de la ayuda completa.
        let propias = descripcion.components(separatedBy: "\n").prefix {
            let linea = $0.trimmingCharacters(in: .whitespaces)
            return !linea.hasPrefix("--") && !(linea.split(separator: " ").first?.hasSuffix(":") ?? false)
        }
        var texto = ""
        var profundidad = 0
        for caracter in propias.joined(separator: " ") {
            if caracter == "(" {
                profundidad += 1
            } else if caracter == ")" {
                profundidad = max(0, profundidad - 1)
            } else if profundidad == 0 {
                texto.append(caracter)
            }
        }
        for corte in [";", ":", " --"] {
            if let rango = texto.range(of: corte) { texto = String(texto[..<rango.lowerBound]) }
        }
        let palabras = texto.split(separator: " ").joined(separator: " ")
            .replacingOccurrences(of: " ,", with: ",").replacingOccurrences(of: " .", with: ".")
        return palabras.isEmpty ? enUnaLinea(descripcion) : palabras
    }

    /// Los párrafos, en una línea.
    static func enUnaLinea(_ texto: String) -> String {
        texto.split(whereSeparator: { $0 == " " || $0 == "\n" }).joined(separator: " ")
    }

    /// El nombre en la columna 2 y el resumen en `columnaDelResumen`, cortado por palabras a `anchoDelIndice`.
    static func lineasDelIndice(_ nombre: String, _ resumen: String) -> [String] {
        let sangria = String(repeating: " ", count: columnaDelResumen)
        var lineas: [String] = []
        var actual = "  " + nombre
        if actual.count >= columnaDelResumen - 1 {
            lineas.append(actual)
            actual = sangria
        } else {
            actual += String(repeating: " ", count: columnaDelResumen - actual.count)
        }
        var vacia = true
        for palabra in resumen.split(separator: " ") {
            if !vacia, actual.count + 1 + palabra.count > anchoDelIndice {
                lineas.append(actual)
                actual = sangria
                vacia = true
            }
            actual += (vacia ? "" : " ") + palabra
            vacia = false
        }
        return lineas + [actual]
    }

    /// La ayuda de una orden: sus entradas, como en la ayuda completa (`armonia ayuda acorde`, `armonia acorde --help`).
    static func ayuda(de orden: Orden, en notacion: Notacion) -> String {
        orden.ayuda.flatMap { lineas(de: $0, en: notacion.textos, grafia: notacion.grafiaDeLosTextos) }
            .joined(separator: "\n")
    }

    static func lineas(de entrada: EntradaDeAyuda, en idioma: Idioma, grafia: Grafia = .original) -> [String] {
        func columna(_ n: Int) -> String { String(repeating: " ", count: n) }
        func rellenar(_ texto: String, hasta ancho: Int) -> String {
            texto + columna(max(0, ancho - texto.count))
        }
        let sintaxis = entrada.sintaxis.texto(en: idioma, grafia: grafia).components(separatedBy: "\n")
        var descripcion = ajustar(entrada.descripcion.texto(en: idioma, grafia: grafia))[...]
        var lineas = sintaxis.map { columna(columnaDeLaSintaxis) + $0 }
        // La primera línea de la descripción va junto a la sintaxis si queda al menos un espacio.
        if let primera = descripcion.first, let ultima = lineas.last, ultima.count < columnaDeLaDescripcion {
            lineas[lineas.count - 1] = rellenar(ultima, hasta: columnaDeLaDescripcion) + primera
            descripcion = descripcion.dropFirst()
        }
        lineas += descripcion.map { columna(columnaDeLaDescripcion) + $0 }
        if let ejemplo = entrada.ejemplo?.texto(en: idioma, grafia: grafia), !ejemplo.isEmpty {
            if let ultima = lineas.last, ultima.count < columnaDelEjemplo {
                lineas[lineas.count - 1] = rellenar(ultima, hasta: columnaDelEjemplo) + ejemplo
            } else {
                lineas.append(columna(columnaDelEjemplo) + ejemplo)
            }
        }
        if let notas = entrada.notas?.texto(en: idioma, grafia: grafia), !notas.isEmpty {
            lineas += ajustar(notas).map { columna(columnaDeLaDescripcion) + $0 }
        }
        return lineas
    }

    /// Un ejemplo: con los nombres españoles de las órdenes y las notas en español, catalán, gallego,
    /// euskera, portugués, francés e italiano, y con los ingleses en
    /// inglés, alemán, griego, ruso, húngaro y sueco.
    static func ejemplo(_ espanol: String, _ ingles: String) -> Traduccion {
        Traduccion(
            espanol, ingles, ca: espanol, gl: espanol, eu: espanol, pt: espanol,
            fr: espanol, it: espanol, de: ingles,
            el: ingles, ru: ingles, hu: ingles, sv: ingles)
    }

    /// Lo que va antes de las órdenes: qué es, cómo se usa y el título de la lista.
    static let cabeceraDeLaAyuda = TextosDeConsola.traduccion(\.cabeceraDeLaAyuda)

    /// Lo que sigue a las órdenes, tras una línea en blanco.
    static let pieDeLaAyuda = TextosDeConsola.traduccion(\.pieDeLaAyuda)

    /// Las entradas de todas las órdenes, en el orden de `ordenes`.
    static let ordenesDeLaAyuda: [EntradaDeAyuda] = ordenes.flatMap(\.ayuda)

    /// La propia ayuda y la versión; las demás órdenes están en los archivos Ayuda+*.swift. `ayuda <orden>` y
    /// `ayuda --todo` no llegan aquí: las escribe `ejecutar`.
    static let ordenesDeAyuda: [Orden] = [
        Orden(nombres: ["ayuda", "help", "-h", "--help", "--ayuda"], ayuda: ayudaDeLaAyuda, leeLaEntrada: false) {
            _, contexto in
            bien(indiceDeAyuda(en: contexto.notacion.textos, grafia: contexto.notacion.grafiaDeLosTextos))
        },
        Orden(nombres: ["--version", "version"], ayuda: ayudaDeLaVersion, leeLaEntrada: false) { _, _ in
            bien("armonia " + version)
        },
    ]

    static let ayudaDeLaVersion: [EntradaDeAyuda] = [
        // --version
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisVersion),
            descripcion: TextosDeConsola.traduccion(\.descripcionVersion),
            opciones: [.version])
    ]

    static let ayudaDeLaAyuda: [EntradaDeAyuda] = [
        // ayuda
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisAyuda),
            descripcion: TextosDeConsola.traduccion(\.descripcionAyuda),
            opciones: [.ayuda])
    ]
}
