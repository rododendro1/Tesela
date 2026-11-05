// MARK: - Lo que se quiso escribir
//
// Ante una orden o una opción desconocida, la conocida que más se le parece: `armonia acordee Do` propone «acorde» y
// `armonia digitaciones Sol7 --limte 3`, «--limite». Se propone una sola, y solo si está cerca: a una o dos letras
// cambiadas, quitadas, añadidas o cambiadas de sitio (una en las de cuatro letras o menos), o si lo escrito es el
// principio de una sola de ellas. Valen también para los valores de `--idioma` y `--escritura`.

extension LineaDeComandos {
    /// Los nombres de todas las órdenes, sin los de la ayuda que empiezan por `-`.
    static var nombresDeLasOrdenes: [String] { ordenes.flatMap(nombres(de:)) }

    /// Las opciones de la orden en curso y las generales, o las de todas las órdenes si no hay ninguna en curso.
    static var opcionesConocidas: [String] {
        if let enCurso = OrdenEnCurso.actual { return opciones(de: enCurso.orden) + opcionesGenerales }
        var todas: [String] = []
        for opcion in ordenes.flatMap(opciones(de:)) + opcionesGenerales where !todas.contains(opcion) {
            todas.append(opcion)
        }
        return todas
    }

    /// El candidato que más se parece a `texto`, si está cerca; `nil` si ninguno lo está o si `texto` ya es uno.
    static func propuesta(para texto: String, entre candidatos: [String]) -> String? {
        let escrito = texto.lowercased()
        guard !candidatos.contains(escrito) else { return nil }
        let largo = escrito.trimmingPrefix("--").count
        let maximo = largo <= 4 ? 1 : 2
        // A igual distancia, la que empieza como lo escrito o con la que empieza lo escrito: «eus» → «eu», no «es».
        var mejor: (candidato: String, distancia: Int, prefijo: Bool)?
        for candidato in candidatos {
            let d = distancia(escrito, candidato)
            guard d <= maximo else { continue }
            let prefijo = candidato.hasPrefix(escrito) || escrito.hasPrefix(candidato)
            if let actual = mejor, d > actual.distancia || (d == actual.distancia && (actual.prefijo || !prefijo)) {
                continue
            }
            mejor = (candidato, d, prefijo)
        }
        if let mejor { return mejor.candidato }
        // «tonal» → «tonalidad», si no empieza así ninguna otra.
        let empiezan = candidatos.filter { $0.hasPrefix(escrito) }
        return largo >= 3 && empiezan.count == 1 ? empiezan[0] : nil
    }

    /// Cuántas letras hay que cambiar, quitar, añadir o cambiar de sitio con la de al lado para pasar de un texto a
    /// otro (la distancia de Damerau-Levenshtein restringida).
    static func distancia(_ a: String, _ b: String) -> Int {
        let a = Array(a)
        let b = Array(b)
        guard !a.isEmpty else { return b.count }
        guard !b.isEmpty else { return a.count }
        var d = [[Int]](repeating: [Int](repeating: 0, count: b.count + 1), count: a.count + 1)
        for i in 0...a.count { d[i][0] = i }
        for j in 0...b.count { d[0][j] = j }
        for i in 1...a.count {
            for j in 1...b.count {
                let coste = a[i - 1] == b[j - 1] ? 0 : 1
                d[i][j] = min(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + coste)
                if i > 1, j > 1, a[i - 1] == b[j - 2], a[i - 2] == b[j - 1] {
                    d[i][j] = min(d[i][j], d[i - 2][j - 2] + 1)
                }
            }
        }
        return d[a.count][b.count]
    }
}
