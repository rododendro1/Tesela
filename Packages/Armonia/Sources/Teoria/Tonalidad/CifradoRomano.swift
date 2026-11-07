import Elementos

// Lectura del cifrado romano: el camino inverso de `Tonalidad.analizar(_:)`. Lee los cifrados que escribe el
// análisis («ii65», «V7/V», «♭VI», «♭II6», «subV7/ii», «Ger+6») y da sus acordes en la tonalidad.

extension Tonalidad {
    /// El acorde de un cifrado romano en esta tonalidad, escrito como lo escribe ``analizar(_:)``.
    ///
    /// - El numeral da el grado y, en mayúsculas o minúsculas, si la tríada es mayor o menor: «IV», «ii». Detrás
    ///   va la calidad como en un cifrado de acorde: «°», «ø7», «+», «7», «maj7», «°7».
    /// - Una alteración delante (`♭`, `b`, `♯`, `#`) mueve la fundamental respecto del grado de la escala (en
    ///   menor, de la natural): «♭VII», «♭VI». Sin ella, en menor el 6.º y el 7.º se elevan en los acordes
    ///   disminuidos: «vii°7» en La menor es Sol♯°7, y «VII», Sol.
    /// - Las inversiones, en cifras de bajo continuo: «6» y «64» en las tríadas, «65», «43» y «42» (o «2») en las
    ///   cuatríadas.
    /// - Tras una barra, el grado del que el acorde es dominante, sensible o sustituto: «V7/V», «vii°7/ii»,
    ///   «subV7/ii». Se pueden encadenar: «V/V/V».
    /// - «N» y «N6» son la sexta napolitana; «It+6», «Fr+6» y «Ger+6», las sextas aumentadas sobre el 6.º
    ///   rebajado.
    ///
    /// Lanza `ErrorDeLectura` (`.textoVacio`) si no hay nada que leer y `ErrorDeLecturaDeTeoria` si el cifrado no se
    /// lee (`.cifradoRomanoNoValido`) o lo que va tras la barra no es una tríada mayor o menor en estado fundamental
    /// (`.destinoNoTonicalizable`), en el carácter donde empieza lo que falla (sin contar los espacios).
    ///
    ///     try Tonalidad(.do).acorde(romano: "ii65")          // Rem7/Fa
    ///     try Tonalidad(.do).acorde(romano: "V7/V")          // Re7
    ///     try Tonalidad(.la, .menor).acorde(romano: "vii°7") // Sol♯°7
    public func acorde(romano texto: String) throws -> Acorde {
        let cifrado = String(texto.filter { !$0.isWhitespace })
        guard !cifrado.isEmpty else { throw ErrorDeLectura(texto: texto, posicion: nil, motivo: .textoVacio) }
        return try leerCifradoRomano(cifrado, desde: 0, en: cifrado)
    }

    /// Los acordes de una sucesión de cifrados romanos separados por espacios (o por `-`, `–` o `|`):
    /// «I vi ii65 V7 I». Lanza como ``acorde(romano:)``, con el error en su carácter del texto entero.
    ///
    ///     try Tonalidad(.do).acordes(romanos: "I V7/V V7 I")   // [Do, Re7, Sol7, Do]
    public func acordes(romanos texto: String) throws -> [Acorde] {
        var acordes: [Acorde] = []
        var actual = ""
        var posicion = 0
        func cerrar() throws {
            defer { actual = "" }
            guard !actual.isEmpty else { return }
            acordes.append(try leerCifradoRomano(actual, desde: posicion - actual.count, en: texto))
        }
        for caracter in texto {
            if caracter.isWhitespace || "-–—|".contains(caracter) {
                try cerrar()
            } else {
                actual.append(caracter)
            }
            posicion += 1
        }
        try cerrar()
        guard !acordes.isEmpty else { throw ErrorDeLectura(texto: texto, posicion: nil, motivo: .textoVacio) }
        return acordes
    }

    // MARK: Lectura

    /// Un cifrado sin espacios que es un trozo de `completo` y empieza en su carácter `inicio`: los errores se sitúan
    /// en `completo`. Lo que va tras la primera barra es el grado de destino, y el resto se lee en su tonalidad.
    private func leerCifradoRomano(_ cifrado: String, desde inicio: Int, en completo: String) throws -> Acorde {
        if let barra = cifrado.firstIndex(of: "/") {
            let izquierda = String(cifrado[..<barra])
            let derecha = String(cifrado[cifrado.index(after: barra)...])
            guard !izquierda.isEmpty, !derecha.isEmpty else {
                throw ErrorDeLecturaDeTeoria(
                    texto: completo, posicion: inicio + izquierda.count, motivo: .cifradoRomanoNoValido(cifrado))
            }
            let inicioDelDestino = inicio + izquierda.count + 1
            let destino = try leerCifradoRomano(derecha, desde: inicioDelDestino, en: completo)
            let calidad = destino.tipo.estructura.calidadDeTriada
            guard destino.inversion == 0, calidad == .mayor || calidad == .menor else {
                throw ErrorDeLecturaDeTeoria(
                    texto: completo, posicion: inicioDelDestino, motivo: .destinoNoTonicalizable(derecha))
            }
            return try Tonalidad(destino.fundamental, calidad == .menor ? .menor : .mayor)
                .leerCifradoRomano(izquierda, desde: inicio, en: completo)
        }
        let posible: Acorde?
        switch cifrado {
        case "N": posible = Acorde(tonica + .segundaMenor, .mayor)
        case "N6": posible = Acorde(tonica + .segundaMenor, .mayor, inversion: 1)
        case "It+6", "It6": posible = sextaAumentada("(#6,omit5)")
        case "Fr+6", "Fr6": posible = sextaAumentada("(#6,#11,omit5)")
        case "Ger+6", "Ger6", "Al+6": posible = sextaAumentada("(#6)")
        default: posible = leerRomano(cifrado)
        }
        guard let leido = posible else {
            throw ErrorDeLecturaDeTeoria(texto: completo, posicion: inicio, motivo: .cifradoRomanoNoValido(cifrado))
        }
        return leido
    }

    /// Un cifrado sin barra: alteraciones, numeral (o «subV»), calidad y cifras de la inversión.
    private func leerRomano(_ cifrado: String) -> Acorde? {
        var resto = Substring(cifrado)
        var alteracion = 0
        var alterado = false
        while let primero = resto.first, let paso = Tonalidad.alteracionDelNumeral(primero) {
            alteracion += paso
            alterado = true
            resto.removeFirst()
        }

        // El numeral (o «subV», el sustituto tritonal de la dominante).
        var grado = 5
        var mayuscula = true
        let esSustituto = resto.hasPrefix("subV")
        if esSustituto {
            resto.removeFirst(4)
        } else {
            guard let numeral = Tonalidad.numeralInicial(de: resto) else { return nil }
            resto.removeFirst(numeral.letras)
            grado = numeral.grado
            mayuscula = numeral.mayuscula
        }

        // Las cifras de la inversión, al final; las de las cuatríadas ponen la séptima.
        var calidad = String(resto)
        var inversion = 0
        let cifras: [(texto: String, inversion: Int, septima: Bool)] = [
            ("65", 1, true), ("43", 2, true), ("42", 3, true), ("64", 2, false), ("2", 3, true), ("6", 1, false),
        ]
        if let leidas = cifras.first(where: { calidad.hasSuffix($0.texto) }),
            !calidad.dropLast(leidas.texto.count).hasSuffix("sus"),
            !calidad.dropLast(leidas.texto.count).hasSuffix("add")
        {
            calidad.removeLast(leidas.texto.count)
            inversion = leidas.inversion
            if leidas.septima { calidad += "7" }
        }

        // La calidad: la del numeral (mayor o menor) y lo que la sigue.
        if calidad == "(add6)" { calidad = "6" }
        let disminuido = calidad.first.map { "°ºoøØ".contains($0) } ?? false || calidad.hasPrefix("dim")
        let simbolo = mayuscula || disminuido ? calidad : "m" + calidad
        guard let tipo = try? TipoDeAcorde(leyendo: simbolo), inversion < tipo.intervalos.count else { return nil }

        // La fundamental: el grado de la escala (en menor, la natural), con su alteración.
        var pasos: Int
        if esSustituto {
            pasos = (tonica + .segundaMenor).pasosDeQuinta
        } else {
            pasos = escala.grado(grado).pasosDeQuinta
            let elevado = modo == .menor && (grado == 6 || grado == 7)
            if !alterado, elevado, tipo.estructura.calidadDeTriada == .disminuida { pasos += 7 }
        }
        pasos += 7 * alteracion
        return Acorde(Nota(pasosDeQuinta: pasos), tipo, inversion: inversion)
    }

    /// La sexta aumentada sobre el 6.º rebajado, con el tipo de su cifrado: «(#6,omit5)» la italiana,
    /// «(#6,#11,omit5)» la francesa y «(#6)» la alemana.
    private func sextaAumentada(_ cifrado: String) -> Acorde? {
        guard let tipo = try? TipoDeAcorde(leyendo: cifrado) else { return nil }
        return Acorde(tonica + .sextaMenor, tipo)
    }

    /// −1 para un bemol, +1 para un sostenido; `nil` si el carácter no es una alteración.
    private static func alteracionDelNumeral(_ caracter: Character) -> Int? {
        switch caracter {
        case "♭", "b": return -1
        case "♯", "#": return 1
        default: return nil
        }
    }

    /// El numeral romano con que empieza un texto: su grado, si está en mayúsculas y cuántas letras tiene. Todas
    /// sus letras han de estar en mayúsculas o todas en minúsculas.
    private static func numeralInicial(de texto: Substring) -> (grado: Int, mayuscula: Bool, letras: Int)? {
        let romanos = ["I", "II", "III", "IV", "V", "VI", "VII"]
        // De más largo a más corto, para que «VII» no se lea como «V».
        for romano in romanos.sorted(by: { $0.count > $1.count }) {
            let inicio = String(texto.prefix(romano.count))
            guard inicio.count == romano.count else { continue }
            let mayuscula = inicio == romano
            guard mayuscula || inicio == romano.lowercased() else { continue }
            return (romanos.firstIndex(of: romano)! + 1, mayuscula, romano.count)
        }
        return nil
    }
}
