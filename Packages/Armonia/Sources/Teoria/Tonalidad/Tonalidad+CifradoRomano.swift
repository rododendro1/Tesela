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
    /// Lanza `ErrorDeLecturaDeTeoria`: `.elementos(.textoVacio)` si no hay nada que leer y, si el cifrado no se
    /// lee (`.cifradoRomanoNoValido`) o lo que va tras la barra no es una tríada mayor o menor en estado fundamental
    /// (`.destinoNoTonicalizable`), en el carácter donde empieza lo que falla (sin contar los espacios).
    ///
    ///     try Tonalidad(.do).acorde(romano: "ii65")          // Rem7/Fa
    ///     try Tonalidad(.do).acorde(romano: "V7/V")          // Re7
    ///     try Tonalidad(.la, .menor).acorde(romano: "vii°7") // Sol♯°7
    public func acorde(romano texto: String) throws(ErrorDeLecturaDeTeoria) -> Acorde {
        let cifrado = String(texto.filter { !$0.isWhitespace })
        guard !cifrado.isEmpty else {
            throw ErrorDeLecturaDeTeoria(texto: texto, posicion: nil, motivo: .elementos(.textoVacio))
        }
        return try leerCifradoRomano(cifrado, desde: 0, en: cifrado)
    }

    /// Los acordes de una sucesión de cifrados romanos separados por espacios (o por `-`, `–` o `|`):
    /// «I vi ii65 V7 I». Lanza como ``acorde(romano:)``, con el error en su carácter del texto entero.
    ///
    ///     try Tonalidad(.do).acordes(romanos: "I V7/V V7 I")   // [Do, Re7, Sol7, Do]
    public func acordes(romanos texto: String) throws(ErrorDeLecturaDeTeoria) -> [Acorde] {
        var acordes: [Acorde] = []
        var actual = ""
        var posicion = 0
        func cerrar() throws(ErrorDeLecturaDeTeoria) {
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
        guard !acordes.isEmpty else {
            throw ErrorDeLecturaDeTeoria(texto: texto, posicion: nil, motivo: .elementos(.textoVacio))
        }
        return acordes
    }

    /// El acorde de un cifrado romano en esta tonalidad: ``acorde(romano:)`` con su texto. Lanza
    /// `ErrorDeLecturaDeTeoria` (`.destinoNoTonicalizable`) si su destino no es una tríada mayor o menor.
    ///
    ///     try Tonalidad(.do).acorde(Tonalidad(.do).analizar(Acorde("Re7")).romano)   // Re7
    public func acorde(_ romano: CifradoRomano) throws(ErrorDeLecturaDeTeoria) -> Acorde {
        try acorde(romano: romano.description)
    }

    // MARK: Lectura

    /// Un cifrado sin espacios que es un trozo de `completo` y empieza en su carácter `inicio`: los errores se sitúan
    /// en `completo`. Lo que va tras la primera barra es el grado de destino, y el resto se lee en su tonalidad.
    private func leerCifradoRomano(_ cifrado: String, desde inicio: Int, en completo: String)
        throws(ErrorDeLecturaDeTeoria) -> Acorde
    {
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
        guard let leido = CifradoRomano.leerSinBarra(cifrado), let acorde = acorde(sinDestino: leido) else {
            throw ErrorDeLecturaDeTeoria(texto: completo, posicion: inicio, motivo: .cifradoRomanoNoValido(cifrado))
        }
        return acorde
    }

    /// El acorde de un cifrado sin destino en esta tonalidad, o `nil` si su calidad no es un tipo de acorde.
    private func acorde(sinDestino romano: CifradoRomano) -> Acorde? {
        switch romano.numeral {
        case .sextaAumentada(let sexta):
            let cifrado =
                switch sexta {
                case .italiana: "(#6,omit5)"
                case .francesa: "(#6,#11,omit5)"
                case .alemana: "(#6)"
                }
            guard let tipo = try? TipoDeAcorde(leyendo: cifrado) else { return nil }
            return Acorde(tonica + .sextaMenor, tipo)
        case .sustitutoTritonal, .grado:
            break
        }
        // La calidad: la del numeral (mayor o menor) y lo que la sigue.
        var mayuscula = true
        if case .grado(_, _, let enMayusculas) = romano.numeral { mayuscula = enMayusculas }
        let calidad = romano.calidad == "(add6)" ? "6" : romano.calidad
        let disminuido = calidad.first.map { "°ºoøØ".contains($0) } ?? false || calidad.hasPrefix("dim")
        let simbolo = mayuscula || disminuido ? calidad : "m" + calidad
        guard let tipo = try? TipoDeAcorde(leyendo: simbolo), romano.inversion < tipo.intervalos.count else {
            return nil
        }

        // La fundamental: el grado de la escala (en menor, la natural), con su alteración.
        let pasos: Int
        switch romano.numeral {
        case .grado(let grado, let alteracion, _):
            var delGrado = escala.grado(grado).pasosDeQuinta
            let elevado = modo == .menor && (grado == 6 || grado == 7)
            if alteracion == 0, elevado, tipo.estructura.calidadDeTriada == .disminuida { delGrado += 7 }
            pasos = delGrado + 7 * alteracion
        default:
            pasos = (tonica + .segundaMenor).pasosDeQuinta
        }
        return Acorde(Nota(pasosDeQuinta: pasos), tipo, inversion: romano.inversion)
    }
}

// MARK: - La lectura del cifrado, por sus partes

extension CifradoRomano {
    /// Lee un cifrado romano por sus partes, sin tonalidad: «V65/V», «♭VII», «subV7/ii», «Ger+6», con las mismas
    /// formas que lee ``Tonalidad/acorde(romano:)`` (también «N6», «V2», «It6»). Su texto (`description`) es la
    /// forma de siempre: «N6» es «♭II6», y «V2», «V42». No mira si el destino se puede tonicalizar; eso lo dice la
    /// tonalidad, al dar su acorde.
    ///
    /// Lanza `ErrorDeLecturaDeTeoria`: `.elementos(.textoVacio)` si no hay nada que leer y `.cifradoRomanoNoValido`
    /// en el carácter donde empieza la parte que no se lee.
    ///
    ///     try CifradoRomano(leyendo: "V65/V").inversion   // 1
    public init(leyendo texto: String) throws(ErrorDeLecturaDeTeoria) {
        let cifrado = String(texto.filter { !$0.isWhitespace })
        guard !cifrado.isEmpty else {
            throw ErrorDeLecturaDeTeoria(texto: texto, posicion: nil, motivo: .elementos(.textoVacio))
        }
        self = try CifradoRomano.leer(cifrado, desde: 0, en: cifrado)
    }

    private static func leer(_ cifrado: String, desde inicio: Int, en completo: String) throws(ErrorDeLecturaDeTeoria)
        -> CifradoRomano
    {
        var partes = cifrado.split(separator: "/", omittingEmptySubsequences: false).map(String.init)
        var posiciones: [Int] = []
        var posicion = inicio
        for parte in partes {
            posiciones.append(posicion)
            posicion += parte.count + 1
        }
        // De la última a la primera: cada una es el destino de la anterior.
        var destino: CifradoRomano?
        while let parte = partes.popLast() {
            let posicion = posiciones.removeLast()
            guard !parte.isEmpty, let leido = leerSinBarra(parte) else {
                throw ErrorDeLecturaDeTeoria(
                    texto: completo, posicion: posicion, motivo: .cifradoRomanoNoValido(cifrado))
            }
            destino = CifradoRomano(
                leido.numeral, calidad: leido.calidad, inversion: leido.inversion, cifras: leido.cifras,
                destino: destino)
        }
        guard let leido = destino else {
            throw ErrorDeLecturaDeTeoria(texto: completo, posicion: inicio, motivo: .cifradoRomanoNoValido(cifrado))
        }
        return leido
    }

    /// Un cifrado sin barra, por sus partes: alteraciones, numeral (o «subV», «N», una sexta aumentada), calidad y
    /// cifras de la inversión. `nil` si no empieza por un numeral.
    static func leerSinBarra(_ cifrado: String) -> CifradoRomano? {
        switch cifrado {
        case "N": return CifradoRomano(.grado(2, alteracion: -1, mayuscula: true))
        case "N6": return CifradoRomano(.grado(2, alteracion: -1, mayuscula: true), inversion: 1, cifras: "6")
        case "It+6", "It6": return CifradoRomano(.sextaAumentada(.italiana))
        case "Fr+6", "Fr6": return CifradoRomano(.sextaAumentada(.francesa))
        case "Ger+6", "Ger6", "Al+6": return CifradoRomano(.sextaAumentada(.alemana))
        default: break
        }
        var resto = Substring(cifrado)
        var alteracion = 0
        while let primero = resto.first, let paso = alteracionDelNumeral(primero) {
            alteracion += paso
            resto.removeFirst()
        }

        // El numeral (o «subV», el sustituto tritonal de la dominante).
        let numeral: Numeral
        if resto.hasPrefix("subV") {
            // El sustituto ya está medio tono por encima de su destino: no lleva alteración.
            guard alteracion == 0 else { return nil }
            resto.removeFirst(4)
            numeral = .sustitutoTritonal
        } else {
            guard let inicial = numeralInicial(de: resto) else { return nil }
            resto.removeFirst(inicial.letras)
            numeral = .grado(inicial.grado, alteracion: alteracion, mayuscula: inicial.mayuscula)
        }

        // Las cifras de la inversión, al final; las de las cuatríadas ponen la séptima.
        var calidad = String(resto)
        var inversion = 0
        var cifras = ""
        let posibles: [(texto: String, inversion: Int, septima: Bool)] = [
            ("65", 1, true), ("43", 2, true), ("42", 3, true), ("64", 2, false), ("2", 3, true), ("6", 1, false),
        ]
        if let leidas = posibles.first(where: { calidad.hasSuffix($0.texto) }),
            !calidad.dropLast(leidas.texto.count).hasSuffix("sus"),
            !calidad.dropLast(leidas.texto.count).hasSuffix("add")
        {
            calidad.removeLast(leidas.texto.count)
            inversion = leidas.inversion
            cifras = leidas.texto == "2" ? "42" : leidas.texto
            if leidas.septima { calidad += "7" }
        }
        return CifradoRomano(numeral, calidad: calidad, inversion: inversion, cifras: cifras)
    }

    /// −1 para un bemol, +1 para un sostenido; `nil` si el carácter no es una alteración.
    fileprivate static func alteracionDelNumeral(_ caracter: Character) -> Int? {
        switch caracter {
        case "♭", "b": return -1
        case "♯", "#": return 1
        default: return nil
        }
    }

    /// El numeral romano con que empieza un texto: su grado, si está en mayúsculas y cuántas letras tiene. Todas
    /// sus letras han de estar en mayúsculas o todas en minúsculas.
    fileprivate static func numeralInicial(de texto: Substring) -> (grado: Int, mayuscula: Bool, letras: Int)? {
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
