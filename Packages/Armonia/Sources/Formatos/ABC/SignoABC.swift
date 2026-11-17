import Elementos

// El troceado de una línea de música de ABC en sus signos, sin interpretarlos: qué nota, qué barra o qué decoración
// se escribe, pero no qué altura suena (eso depende de la armadura y de las alteraciones del compás) ni cuánto dura
// (depende de la unidad, `L:`). Lo que significa cada signo lo decide `LectorABC` (LecturaABC.swift), en orden, porque
// un campo en medio de la línea (`[K:D]`, `[L:1/8]`) cambia cómo se leen los signos que vienen detrás.

/// Un signo de una línea de música de ABC.
enum SignoABC: Equatable {
    /// Lo que multiplica a la unidad (`L:`): `3/2` → 3/2, `/` → 1/2, nada → 1.
    struct Longitud: Equatable {
        var numerador: Int
        var denominador: Int
    }

    /// Una nota como se escribe: sus alteraciones (en cents; `nil` si no lleva, `0` si es un becuadro), su letra, su
    /// octava (`C` es la 4.ª, `c` la 5.ª, y cada `'` o `,` sube o baja una) y su longitud.
    struct NotaEscrita: Equatable {
        var cents: Double?
        var natural: NotaNatural
        var octava: Int
        var longitud: Longitud
    }

    /// Un texto entre comillas (`"^Do7"`), sin ellas.
    case anotacion(String)
    /// Una decoración (`!trill!`, `+fermata+`), sin sus signos.
    case decoracion(String)
    /// El punto de staccato (`.`).
    case staccato
    /// Notas de adorno (`{gAB}`).
    case adornos([NotaEscrita])
    /// Una ligadura (`-`) detrás de una nota o un acorde.
    case ligadura
    /// Un grupo irregular: `(3` → [3], `(3:2:3` → [3, 2, 3].
    case irregular([Int])
    /// Ritmo con puntillo: `>` (la primera, larga) o `<`, una, dos o tres veces.
    case puntillo(largo: Bool, veces: Int)
    /// Una barra (`|`, `:|`, `|:`, `||`, `[|`…), con las casillas que empiezan tras ella (`1`, `1,3`, `1-2`).
    case barra(String, casillas: String?)
    /// Un campo en medio de la música: `[K:D]` → («K», «D»).
    case campo(Character, String)
    /// Un acorde (`[CEG]2`): sus notas, si se ligan dentro (`[C-E-G]`) y la longitud de detrás del corchete. Las
    /// anotaciones y decoraciones de dentro van antes, como signos sueltos.
    case acorde([NotaEscrita], ligadas: Bool, longitud: Longitud)
    /// Un silencio (`z`, `x`) de una longitud.
    case silencio(Longitud)
    /// Compases enteros de silencio: `Z4` → 4, `Z` → 1.
    case compasesDeSilencio(Int)
    /// Una nota.
    case nota(NotaEscrita)

    /// Los signos de una línea de música, hasta el final o hasta un comentario (`%`). Lo que no es ningún signo
    /// (espacios, ligaduras de expresión, caracteres que no se conocen) no cuenta.
    static func trocear(_ linea: String) -> [SignoABC] {
        var troceado = Troceado(Array(linea.unicodeScalars))
        return troceado.trocear()
    }
}

/// Recorre una línea de música carácter a carácter.
private struct Troceado {
    let c: [Unicode.Scalar]
    var i = 0
    var signos: [SignoABC] = []

    init(_ c: [Unicode.Scalar]) { self.c = c }

    mutating func trocear() -> [SignoABC] {
        while i < c.count {
            let ch = c[i]
            switch ch {
            case "%":
                return signos
            case "\"":
                signos.append(.anotacion(entre("\"")))
            case "!", "+":
                signos.append(.decoracion(entre(ch)))
            case ".":
                signos.append(.staccato)
                i += 1
            case "{":
                adornos()
            case "-":
                signos.append(.ligadura)
                i += 1
            case "(":
                irregular()
            case ">", "<":
                var n = 0
                while i < c.count, c[i] == ch, n < 3 {
                    n += 1
                    i += 1
                }
                signos.append(.puntillo(largo: ch == ">", veces: n))
            case "|", ":":
                barra()
            case "[":
                corchete()
            case "z", "x":
                i += 1
                signos.append(.silencio(longitud()))
            case "Z", "X":
                compasesDeSilencio()
            default:
                if let nota = nota() { signos.append(.nota(nota)) } else { i += 1 }
            }
        }
        return signos
    }

    /// Deja `i` detrás del siguiente `fin`, sin contar el carácter en que está.
    mutating func saltar(hasta fin: Unicode.Scalar) {
        i += 1
        while i < c.count, c[i] != fin { i += 1 }
        i += 1
    }

    /// Lo que hay entre el `fin` en que está `i` y el siguiente `fin`, que queda detrás: `!trill!` → «trill».
    mutating func entre(_ fin: Unicode.Scalar) -> String {
        let inicio = i + 1
        saltar(hasta: fin)
        return String(String.UnicodeScalarView(c[inicio..<max(inicio, min(i - 1, c.count))]))
    }

    /// Si el carácter `k` es parte de una barra: `|`, `:`, `]` o el corchete de una casilla (`|[1`).
    func esDeLaBarra(_ k: Int) -> Bool {
        if c[k] == "|" || c[k] == ":" || c[k] == "]" { return true }
        return c[k] == "[" && k > 0 && c[k - 1] == "|" && k + 1 < c.count && Troceado.cifra(c[k + 1]) != nil
    }

    /// `{gAB}`.
    mutating func adornos() {
        i += 1
        var notas: [SignoABC.NotaEscrita] = []
        while i < c.count, c[i] != "}" {
            if let nota = nota() { notas.append(nota) } else { i += 1 }
        }
        i += 1
        signos.append(.adornos(notas))
    }

    /// `(3`, `(3:2`, `(3:2:3`. Sin cifra detrás, el paréntesis es el de una ligadura de expresión, que no cuenta.
    mutating func irregular() {
        i += 1
        guard i < c.count, let p = Troceado.cifra(c[i]) else { return }
        i += 1
        var numeros = [p]
        while numeros.count < 3, i < c.count, c[i] == ":" {
            i += 1
            var n: Int?
            while i < c.count, let d = Troceado.cifra(c[i]) {
                n = (n ?? 0) * 10 + d
                i += 1
                if n! > 100 { break }
            }
            numeros.append(n ?? 0)
        }
        signos.append(.irregular(numeros))
    }

    /// `|`, `||`, `|]`, `:|`, `|:`, `::` y la casilla que empieza detrás: `|1`, `:|2`, `|1,3`, `|1-2`.
    mutating func barra() {
        let inicio = i
        while i < c.count, esDeLaBarra(i) { i += 1 }
        let signo = String(String.UnicodeScalarView(c[inicio..<i]))
        let desde = i
        while i < c.count, Troceado.cifra(c[i]) != nil || (i > desde && (c[i] == "," || c[i] == "-")) {
            i += 1
        }
        let numeros = String(String.UnicodeScalarView(c[desde..<i]))
        signos.append(.barra(signo, casillas: numeros.isEmpty ? nil : numeros))
    }

    /// Lo que empieza con `[`: un campo en medio (`[K:D]`, `[M:3/4]`, `[V:2]`), una casilla (`[1`, `[2`), una barra
    /// gruesa (`[|`) o un acorde (`[CEG]2`).
    mutating func corchete() {
        if i + 2 < c.count, c[i + 2] == ":", c[i + 1].properties.isAlphabetic {
            let letra = Character(c[i + 1])
            var fin = i + 3
            while fin < c.count, c[fin] != "]" { fin += 1 }
            let valor = String(String.UnicodeScalarView(c[(i + 3)..<fin])).trimmingCharacters(in: .whitespaces)
            i = fin + 1
            signos.append(.campo(letra, valor))
        } else if i + 1 < c.count, Troceado.cifra(c[i + 1]) != nil || c[i + 1] == "|" {
            let inicio = i
            i += 1
            while i < c.count, Troceado.cifra(c[i]) != nil || c[i] == "," || c[i] == "-" || c[i] == "|" {
                i += 1
            }
            let leido = String(String.UnicodeScalarView(c[inicio..<i]))
            let numeros = leido.filter { $0.isNumber || $0 == "," || $0 == "-" }
            signos.append(.barra(leido.filter { $0 == "[" || $0 == "|" }, casillas: numeros.isEmpty ? nil : numeros))
        } else {
            acorde()
        }
    }

    /// `[CEG]2`, `[C-E-G]`.
    mutating func acorde() {
        i += 1
        var notas: [SignoABC.NotaEscrita] = []
        var ligadas = false
        while i < c.count, c[i] != "]" {
            if let nota = nota() {
                notas.append(nota)
            } else if c[i] == "-" {
                ligadas = true
                i += 1
            } else if c[i] == "\"" {
                signos.append(.anotacion(entre("\"")))
            } else if c[i] == "!" {
                signos.append(.decoracion(entre("!")))
            } else {
                i += 1
            }
        }
        i += 1
        signos.append(.acorde(notas, ligadas: ligadas, longitud: longitud()))
    }

    /// `Z4`, `X`.
    mutating func compasesDeSilencio() {
        i += 1
        var compases = 0
        while i < c.count, let d = Troceado.cifra(c[i]), compases < 10_000 {
            compases = compases * 10 + d
            i += 1
        }
        signos.append(.compasesDeSilencio(max(1, compases)))
    }

    static func cifra(_ c: Unicode.Scalar) -> Int? {
        ("0"..."9").contains(c) ? Int(c.value) - 48 : nil
    }

    /// `3`, `/`, `//`, `3/2`, `/4`.
    mutating func longitud() -> SignoABC.Longitud {
        var numerador = 0
        var hayNumerador = false
        while i < c.count, let d = Troceado.cifra(c[i]), numerador < 10_000 {
            numerador = numerador * 10 + d
            hayNumerador = true
            i += 1
        }
        var denominador = 1
        while i < c.count, c[i] == "/", denominador < 1 << 12 {
            i += 1
            var n = 0
            var hayCifras = false
            while i < c.count, let d = Troceado.cifra(c[i]), n < 10_000 {
                n = n * 10 + d
                hayCifras = true
                i += 1
            }
            denominador *= hayCifras ? max(1, n) : 2
        }
        return SignoABC.Longitud(numerador: hayNumerador ? numerador : 1, denominador: denominador)
    }

    /// Una nota: sus alteraciones, su letra, sus octavas y su longitud; `nil` (sin avanzar) si en `i` no empieza una.
    mutating func nota() -> SignoABC.NotaEscrita? {
        let antes = i
        var cents: Double?
        var alteraciones = 0
        while i < c.count, c[i] == "^" || c[i] == "_" || c[i] == "=", alteraciones < 3 {
            let paso: Double = c[i] == "^" ? 100 : c[i] == "_" ? -100 : 0
            cents = c[i] == "=" ? 0 : (cents ?? 0) + paso
            alteraciones += 1
            i += 1
            // `^/` y `_/`: medio sostenido y medio bemol; `^3/2`: tres cuartos de tono.
            if i < c.count, paso != 0, c[i] == "/" || Troceado.cifra(c[i]) != nil {
                let desde = i
                let fraccion = longitud()
                if i > desde, fraccion.denominador > 1 {
                    cents = (cents ?? 0) - paso + paso * Double(fraccion.numerador) / Double(fraccion.denominador)
                } else {
                    i = desde
                }
            }
        }
        let letras: [Unicode.Scalar] = ["C", "D", "E", "F", "G", "A", "B", "c", "d", "e", "f", "g", "a", "b"]
        guard i < c.count, let indice = letras.firstIndex(of: c[i]), let natural = NotaNatural(rawValue: indice % 7)
        else {
            i = antes
            return nil
        }
        var octava = indice >= 7 ? 5 : 4
        i += 1
        while i < c.count, c[i] == "'" || c[i] == "," {
            octava += c[i] == "'" ? 1 : -1
            i += 1
        }
        guard (-10...20).contains(octava) else {
            i = antes
            return nil
        }
        return SignoABC.NotaEscrita(cents: cents, natural: natural, octava: octava, longitud: longitud())
    }
}
