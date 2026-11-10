import Elementos

// MARK: - LecturaDeCifrado

/// La lectura de un cifrado sin fundamental ("m7(♭5)", "7(b9,#11)", "13sus4", "6/9", "(add9)", "7alt",
/// "maj9(omit5)"…), parte a parte. ``leer()`` recorre el texto y apunta lo que dice cada parte (los signos y los
/// paréntesis, `add` y `omit`, `sus`, la calidad, las tensiones alteradas y el número), y ``conjunto()`` lo
/// convierte en un conjunto de quintas (`ClasificacionDeAcorde.conjunto(desde:)`), tras comprobar que no se
/// contradice.
struct LecturaDeCifrado {
    /// El texto entero, para situar los errores.
    let original: String
    /// Lo que falta por leer.
    var resto: Substring

    // La calidad.
    var menor = false
    var disminuido = false
    var semidisminuido = false
    var aumentado = false
    var septimaMayor = false
    /// Δ sin número es maj7.
    var deltaImplicaSeptima = false
    var seisNueve = false
    var alterado = false

    // El número y lo que se añade, se altera o se quita.
    var numero: Int?
    var posicionDelNumero: Int?
    var sus: Int?
    /// Las tensiones y quintas escritas: ♭9, ♯11, ♭5, o un número entre paréntesis.
    var explicitas: [Int] = []
    var anadidas: [Int] = []
    var omitidos: [Int] = []

    // Los paréntesis.
    var enParentesis = false
    var parentesisAbierto: Substring?
    /// Si lo anterior fue maj (o Δ, o M): "maj(9)" es maj9, no maj con la novena entre paréntesis.
    var despuesDeMaj = false

    init(_ lector: Lector) {
        original = lector.texto
        resto = lector.resto
    }

    // MARK: Leer

    /// Lee todo el texto, una parte tras otra.
    mutating func leer() throws {
        while !resto.isEmpty {
            let inicio = resto
            let previoMaj = despuesDeMaj
            despuesDeMaj = false
            let leida =
                try leerSignos(previoMaj: previoMaj) || leerAnadidasYOmitidas() || leerSus() || leerCalidad()
                || leerTensionAlterada() || leerSignoDeCalidad() || leerNumero(previoMaj: previoMaj)
            if !leida { throw fallo(.simboloNoReconocido(inicio.fragmentoParaError), en: inicio) }
        }
        // Un paréntesis sin cerrar ("Do7(b9") no se da por bueno.
        if enParentesis, let abierto = parentesisAbierto {
            throw fallo(.simboloNoReconocido("("), en: abierto)
        }
    }

    /// Los espacios, las comas y los paréntesis, que no cambian lo que viene detrás de maj.
    private mutating func leerSignos(previoMaj: Bool) throws -> Bool {
        let inicio = resto
        if consumir(" ") || consumir(",") {
            despuesDeMaj = previoMaj
            return true
        }
        if consumir("(") {
            // Sin paréntesis anidados: "Do7((9)" no es un cifrado.
            if enParentesis { throw fallo(.simboloNoReconocido("("), en: inicio) }
            enParentesis = true
            parentesisAbierto = inicio
            despuesDeMaj = previoMaj
            return true
        }
        if consumir(")") {
            guard enParentesis else { throw fallo(.simboloNoReconocido(")"), en: inicio) }
            enParentesis = false
            return true
        }
        return false
    }

    /// `add9`, `add♭13`; `omit5`, `no3`.
    private mutating func leerAnadidasYOmitidas() throws -> Bool {
        let inicio = resto
        if consumir("omit") || consumir("no") {
            guard let numeroLeido = leerCifras() else {
                throw fallo(.simboloNoReconocido(inicio.fragmentoParaError), en: inicio)
            }
            guard ClasificacionDeAcorde.gradosOmitibles.contains(numeroLeido) else {
                throw fallo(.gradoNoOmitible(numeroLeido), en: inicio)
            }
            omitidos.append(numeroLeido)
            return true
        }
        if consumir("add") {
            anadidas.append(try leerTension(desde: resto))
            return true
        }
        return false
    }

    /// `sus`, `sus4` y `sus2`.
    private mutating func leerSus() -> Bool {
        guard consumir("sus") else { return false }
        if consumir("2") {
            sus = 2
        } else {
            _ = consumir("4")
            sus = -1
        }
        return true
    }

    /// La calidad escrita con letras o con su signo: `6/9`, `maj`, `Δ`, `min`, `M`, `dim`, `°`, `ø`, `alt`, `aug`,
    /// `m`. El `+` y el `-` van después de las tensiones alteradas (`+5`, `-9`), en ``leerSignoDeCalidad()``.
    private mutating func leerCalidad() -> Bool {
        if consumir("6/9") || consumir("69") {
            seisNueve = true
        } else if consumir("maj") || consumir("Maj") || consumir("MA") {
            septimaMayor = true
            despuesDeMaj = true
        } else if consumir("Δ") || consumir("∆") {
            septimaMayor = true
            deltaImplicaSeptima = true
            despuesDeMaj = true
        } else if consumir("min") {
            menor = true
        } else if consumir("M") {
            septimaMayor = true
            despuesDeMaj = true
        } else if consumir("dim") || consumir("°") || consumir("º") || consumir("o") {
            disminuido = true
        } else if consumir("ø") || consumir("Ø") {
            semidisminuido = true
        } else if consumir("alt") {
            alterado = true
        } else if consumir("aug") {
            aumentado = true
        } else if consumir("m") {
            menor = true
        } else {
            return false
        }
        return true
    }

    /// Una tensión o una quinta alterada: `♭9`, `♯11`, `-5`, `+5`.
    private mutating func leerTensionAlterada() throws -> Bool {
        guard let alterada = try leerAlterada() else { return false }
        explicitas.append(alterada)
        return true
    }

    /// `+` (aumentado) y `-` (menor), cuando no son la alteración de una tensión.
    private mutating func leerSignoDeCalidad() -> Bool {
        if consumir("+") {
            aumentado = true
        } else if consumir("-") {
            menor = true
        } else {
            return false
        }
        return true
    }

    /// El número del acorde (`7`, `9`, `13`) o, entre paréntesis y no detrás de maj, una tensión natural: `7(9)`.
    private mutating func leerNumero(previoMaj: Bool) throws -> Bool {
        let inicio = resto
        guard let numeroLeido = leerCifras() else { return false }
        if enParentesis && !previoMaj && numeroLeido != 6 && numeroLeido != 7 {
            guard let base = ClasificacionDeAcorde.gradoNatural[numeroLeido] else {
                throw fallo(.tensionNoValida("\(numeroLeido)"), en: inicio)
            }
            explicitas.append(base)
        } else {
            guard numero == nil else { throw fallo(.numeroRepetido(numeroLeido), en: inicio) }
            numero = numeroLeido
            posicionDelNumero = inicio.posicionEnOrigen
        }
        return true
    }

    // MARK: Lo más pequeño

    private func fallo(_ motivo: ErrorDeLecturaDeTeoria.Motivo, en fragmento: Substring?) -> ErrorDeLecturaDeTeoria {
        ErrorDeLecturaDeTeoria(texto: original, posicion: fragmento?.posicionEnOrigen, motivo: motivo)
    }

    private mutating func consumir(_ prefijo: String) -> Bool {
        guard resto.hasPrefix(prefijo) else { return false }
        resto = resto.dropFirst(prefijo.count)
        return true
    }

    private mutating func leerCifras() -> Int? {
        let digitos = resto.cifrasIniciales
        guard let numeroLeido = Int(digitos) else { return nil }
        resto = resto.dropFirst(digitos.count)
        return numeroLeido
    }

    /// Tensión con alteración obligatoria: b9, ♯11, -5, +5…
    /// Con b/♭/#/♯, un grado que no existe es un error; con -/+ (que también
    /// significan menor y aumentado) simplemente no se reconoce.
    private mutating func leerAlterada() throws -> Int? {
        // La cuarta doble aumentada de la sexta suiza: 𝄪11, ##11 o ♯♯11.
        for doble in ["𝄪", "##", "♯♯", "#♯", "♯#"] where resto.hasPrefix(doble) {
            let tras = resto.dropFirst(doble.count)
            guard tras.cifrasIniciales == "11" else {
                throw fallo(.tensionNoValida(resto.fragmentoParaError), en: resto)
            }
            resto = tras.dropFirst(2)
            return -1 + 14
        }
        guard let caracter = resto.first else { return nil }
        let alteracion: Int
        switch caracter {
        case "b", "♭", "-": alteracion = -1
        case "#", "♯", "+": alteracion = 1
        default: return nil
        }
        let tras = resto.dropFirst()
        let digitos = tras.cifrasIniciales
        let signo = caracter == "-" || caracter == "+"
        guard let numeroLeido = Int(digitos), let base = ClasificacionDeAcorde.gradoNatural[numeroLeido] else {
            if signo { return nil }
            throw fallo(.tensionNoValida(resto.fragmentoParaError), en: resto)
        }
        if caracter == "-" && ![5, 9, 13].contains(numeroLeido) { return nil }
        if caracter == "+" && ![5, 9, 11].contains(numeroLeido) { return nil }
        resto = tras.dropFirst(digitos.count)
        return base + 7 * alteracion
    }

    /// Tensión con alteración opcional: 9, b9, #11, 13…
    private mutating func leerTension(desde inicio: Substring) throws -> Int {
        if let alterada = try leerAlterada() { return alterada }
        guard let numeroLeido = leerCifras(), let base = ClasificacionDeAcorde.gradoNatural[numeroLeido] else {
            throw fallo(.tensionNoValida(inicio.fragmentoParaError), en: inicio)
        }
        return base
    }

    // MARK: El conjunto

    /// Las notas del acorde, en quintas desde la fundamental, mientras se calculan.
    private struct Notas {
        var tercera: Int?
        var quintas: Set<Int>
        var septima: Int?
        var sexta = false
        var tensiones: Set<Int> = []

        var conjunto: Set<Int> {
            var conjunto: Set<Int> = [0]
            if let tercera { conjunto.insert(tercera) }
            conjunto.formUnion(quintas)
            if let septima { conjunto.insert(septima) }
            if sexta { conjunto.insert(3) }
            conjunto.formUnion(tensiones)
            return conjunto
        }
    }

    /// El conjunto de quintas de lo leído: la calidad y el número, y después las tensiones, `sus` y `omit`.
    func conjunto() throws -> Set<Int> {
        if disminuido && semidisminuido {
            throw fallo(.calidadesIncompatibles(.disminuidoYSemidisminuido), en: nil)
        }
        var notas = try notasDelNumero()
        anadirLasTensiones(a: &notas)
        if let sus {
            notas.tercera = nil
            notas.tensiones.insert(sus)
        }
        quitarLasOmitidas(de: &notas)
        return notas.conjunto
    }

    /// La tríada de la calidad, con lo que añade el número (la séptima y las tensiones que implica), `6/9` y `alt`.
    private func notasDelNumero() throws -> Notas {
        var notas = Notas(
            tercera: (menor || disminuido || semidisminuido) ? -3 : 4,
            quintas: (disminuido || semidisminuido) ? [-6] : (aumentado ? [8] : [1]))
        var numeroEfectivo = numero
        if numeroEfectivo == nil && (deltaImplicaSeptima || semidisminuido || alterado) { numeroEfectivo = 7 }
        switch numeroEfectivo {
        case nil:
            break
        case 2?:
            notas.tensiones.insert(2)
        case 5?:
            guard !menor, !disminuido, !semidisminuido, !aumentado else {
                throw fallo(.calidadesIncompatibles(.quintaConCalidad), en: nil)
            }
            notas.tercera = nil
        case 6?:
            notas.sexta = true
        case 7?, 9?, 11?, 13?:
            notas.septima = septimaMayor ? 5 : (disminuido ? -9 : -2)
            let grado = numeroEfectivo ?? 7
            if grado >= 9 { notas.tensiones.insert(2) }
            if grado == 11 { notas.tensiones.insert(-1) }
            if grado == 13 {
                notas.tensiones.insert(3)
                if notas.tercera == -3 { notas.tensiones.insert(-1) }
            }
        case let otro?:
            throw ErrorDeLecturaDeTeoria(
                texto: original, posicion: posicionDelNumero, motivo: .numeroDeAcordeNoValido(otro))
        }
        if seisNueve {
            notas.sexta = true
            notas.tensiones.insert(2)
        }
        if alterado {
            notas.tensiones.subtract([2, -1, 3])
            notas.tensiones.formUnion([-5, 9, 6, -4])
        }
        return notas
    }

    /// Las quintas alteradas y las tensiones escritas y añadidas.
    private func anadirLasTensiones(a notas: inout Notas) {
        let quintasExplicitas = explicitas.filter { modulo(4 * $0, 7) == 4 }
        if !quintasExplicitas.isEmpty { notas.quintas = Set(quintasExplicitas) }
        // Una alteración explícita (♭9, ♯11, ♭13) sustituye a la natural que implicaba
        // el número; "add" y las naturales explícitas solo añaden.
        for tension in explicitas {
            switch modulo(4 * tension, 7) {
            case 1 where tension != 2: notas.tensiones.remove(2)
            case 3 where tension != -1: notas.tensiones.remove(-1)
            case 5 where tension != 3: notas.tensiones.remove(3)
            default: break
            }
        }
        for tension in explicitas + anadidas {
            if modulo(4 * tension, 7) == 4 {
                if anadidas.contains(tension) { notas.quintas.insert(tension) }
            } else {
                notas.tensiones.insert(tension)
            }
        }
    }

    /// `omit3`, `omit5`, `no7`…
    private func quitarLasOmitidas(de notas: inout Notas) {
        for grado in omitidos {
            switch grado {
            case 3: notas.tercera = nil
            case 5: notas.quintas = []
            case 7: notas.septima = nil
            case 2, 9: notas.tensiones.subtract([-5, 2, 9])
            case 4, 11: notas.tensiones.subtract([-1, 6])
            default:
                notas.tensiones.subtract([-4, 3, 10])
                notas.sexta = false // 6, 13
            }
        }
    }
}
