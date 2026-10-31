import Armonia

// MARK: - La ayuda
//
// La ayuda de `armonia` en los catorce idiomas de los textos, montada a partir de una tabla de órdenes:
// cada orden tiene su sintaxis, su descripción, un ejemplo y, si hace falta, unas notas, cada cosa
// en los catorce idiomas (`Traduccion` no compila si falta alguno). Las columnas se calculan: la
// sintaxis va en la columna 2, la descripción en la 31 y el ejemplo en la 69. Una sintaxis que no
// cabe en su columna deja la descripción en la línea siguiente, y un ejemplo que no cabe al final
// de la descripción va en una línea propia.
//
// Las entradas de las órdenes están en Ayuda+Consultas.swift, Ayuda+Armonizacion.swift y los demás
// Ayuda+*.swift, uno por cada LineaDeComandos+*.swift; aquí quedan la cabecera, el pie y la entrada
// de la propia ayuda.

extension LineaDeComandos {
    /// Una orden de la ayuda. Cada texto puede tener varias líneas (separadas por "\n"), cortadas
    /// a mano en cada idioma.
    struct EntradaDeAyuda: Sendable {
        /// Una línea por cada forma de escribir la orden.
        let sintaxis: Traduccion
        let descripcion: Traduccion
        /// Se escribe al final de la descripción, en la columna de los ejemplos.
        var ejemplo: Traduccion? = nil
        /// Líneas que siguen al ejemplo, en la columna de la descripción. Un texto vacío es que no hay.
        var notas: Traduccion? = nil
    }

    static let columnaDeLaSintaxis = 2
    static let columnaDeLaDescripcion = 31
    static let columnaDelEjemplo = 69

    /// La ayuda completa en un idioma.
    static func textoDeAyuda(en idioma: Idioma) -> String {
        let ordenes = ordenesDeLaAyuda.flatMap { lineas(de: $0, en: idioma) }
        return ([cabeceraDeLaAyuda.texto(en: idioma)] + ordenes + ["", pieDeLaAyuda.texto(en: idioma)])
            .joined(separator: "\n")
    }

    static func lineas(de entrada: EntradaDeAyuda, en idioma: Idioma) -> [String] {
        func columna(_ n: Int) -> String { String(repeating: " ", count: n) }
        func rellenar(_ texto: String, hasta ancho: Int) -> String {
            texto + columna(max(0, ancho - texto.count))
        }
        let sintaxis = entrada.sintaxis.texto(en: idioma).components(separatedBy: "\n")
        var descripcion = entrada.descripcion.texto(en: idioma).components(separatedBy: "\n")[...]
        var lineas = sintaxis.map { columna(columnaDeLaSintaxis) + $0 }
        // La primera línea de la descripción va junto a la sintaxis si queda al menos un espacio.
        if let primera = descripcion.first, let ultima = lineas.last, ultima.count < columnaDeLaDescripcion {
            lineas[lineas.count - 1] = rellenar(ultima, hasta: columnaDeLaDescripcion) + primera
            descripcion = descripcion.dropFirst()
        }
        lineas += descripcion.map { columna(columnaDeLaDescripcion) + $0 }
        if let ejemplo = entrada.ejemplo?.texto(en: idioma), !ejemplo.isEmpty {
            if let ultima = lineas.last, ultima.count < columnaDelEjemplo {
                lineas[lineas.count - 1] = rellenar(ultima, hasta: columnaDelEjemplo) + ejemplo
            } else {
                lineas.append(columna(columnaDelEjemplo) + ejemplo)
            }
        }
        if let notas = entrada.notas?.texto(en: idioma), !notas.isEmpty {
            lineas += notas.components(separatedBy: "\n").map { columna(columnaDeLaDescripcion) + $0 }
        }
        return lineas
    }

    /// Un ejemplo: con los nombres españoles de las órdenes y las notas en español, catalán, gallego,
    /// asturiano, aragonés, euskera, portugués, francés, occitano y italiano, y con los ingleses en
    /// inglés, alemán, griego y ruso.
    static func ejemplo(_ espanol: String, _ ingles: String) -> Traduccion {
        Traduccion(
            espanol, ingles, ca: espanol, gl: espanol, ast: espanol, an: espanol, eu: espanol, pt: espanol,
            fr: espanol, oc: espanol, it: espanol, de: ingles,
            el: ingles, ru: ingles)
    }

    /// Lo que va antes de las órdenes: qué es, cómo se usa y el título de la lista.
    static let cabeceraDeLaAyuda = TextosDeCLI.traducidos.map(\.cabeceraDeLaAyuda)

    /// Lo que sigue a las órdenes, tras una línea en blanco.
    static let pieDeLaAyuda = TextosDeCLI.traducidos.map(\.pieDeLaAyuda)

    static let ordenesDeLaAyuda: [EntradaDeAyuda] =
        ayudaDeConsultas + ayudaDeArmonizacion + ayudaDePartituras
        + ayudaDeDibujos + ayudaDeNeorriemann + ayudaDeTrastes + ayudaDeLaAyuda

    /// La ayuda de la propia ayuda; las demás órdenes están en los archivos Ayuda+*.swift.
    static let ayudaDeLaAyuda: [EntradaDeAyuda] = [
        // ayuda
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisAyuda),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionAyuda))
    ]
}
