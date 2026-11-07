import ArmoniaElementos

// Bajo cifrado (bajo continuo): un bajo con cifras que dicen qué intervalos suenan sobre él, contados en la
// armadura de la tonalidad, y su realización a cuatro voces.

extension Tonalidad {
    /// El acorde que piden un bajo y sus cifras de bajo continuo, contando los intervalos en la armadura de la
    /// tonalidad (en menor, la natural: la sensible se escribe con su alteración).
    ///
    /// - Las abreviaturas habituales se completan: nada, «5» o «53» es la tríada en estado fundamental; «6», la
    ///   primera inversión; «64», la segunda; «7», la séptima; «65», «43» y «42» (o «2»), sus inversiones; «4», la
    ///   cuarta en vez de la tercera.
    /// - Una alteración (`#`, `♯`, `b`, `♭`, `♮`, `n`) delante o detrás de una cifra altera esa nota; sola, altera
    ///   la tercera. `+` detrás de una cifra la sube medio tono («4+», «6+»).
    /// - Las cifras se escriben juntas («64») o separadas por `/` («6/4»); «8» no añade nada y «9» es la novena,
    ///   que, a diferencia del «2», no quita la tercera.
    ///
    /// Lanza `ErrorDeLecturaDeTeoria` con las cifras como texto: `.cifrasNoValidas` si no se pueden leer (en el
    /// carácter que no se entiende) y `.cifrasSinAcorde` si sus notas no forman un acorde.
    ///
    ///     try Tonalidad(.do).acorde(sobre: .si, cifras: "65")             // Sol7/Si
    ///     try Tonalidad(.la, .menor).acorde(sobre: .mi, cifras: "#")      // Mi
    ///     try Tonalidad(.la, .menor).acorde(sobre: .fa, cifras: "6")      // Rem/Fa
    public func acorde(sobre bajo: Nota, cifras: String) throws -> Acorde {
        let leidas = try Tonalidad.leerCifras(cifras)
        let numeros = Tonalidad.completarCifras(Set(leidas.map(\.numero)))
        let notas = numeros.sorted().map { numero in
            var nota = notaDiatonica(numero, sobre: bajo)
            if let alteracion = leidas.last(where: { $0.numero == numero })?.alteracion {
                nota = Tonalidad.alterar(nota, alteracion)
            }
            return nota
        }
        let todas = [bajo] + notas
        let candidatos = Acorde.identificar(notas: todas)
        let exacto = candidatos.first { $0.bajo == bajo && Set($0.notas + [$0.bajo]) == Set(todas) }
        guard let acorde = exacto ?? candidatos.first(where: { $0.bajo == bajo }) else {
            throw ErrorDeLecturaDeTeoria(texto: cifras, posicion: nil, motivo: .cifrasSinAcorde(cifras))
        }
        return acorde
    }

    /// Los acordes de un bajo cifrado escrito como notas del bajo separadas por espacios, cada una con sus cifras
    /// detrás de dos puntos: «Do Fa:6 Sol:7 Do», «La Re:6 Mi:# La». Lanza `ErrorDeLectura` (`.textoVacio`) si no
    /// hay nada que leer, el error de la nota si una no se lee y el de ``acorde(sobre:cifras:)`` si unas cifras no se
    /// leen o no forman acorde, en su carácter del texto entero.
    ///
    ///     try Tonalidad(.do).acordes(bajoCifrado: "Do Fa Sol:7 Do")         // [Do, Fa, Sol7, Do]
    ///     try Tonalidad(.do).acordes(bajoCifrado: "Do Re:43 Mi:6 Fa Sol")   // [Do, Sol7/Re, Do/Mi, Fa, Sol]
    public func acordes(bajoCifrado texto: String) throws -> [Acorde] {
        var acordes: [Acorde] = []
        var actual = ""
        var posicion = 0
        func cerrar() throws {
            defer { actual = "" }
            guard !actual.isEmpty else { return }
            let inicio = posicion - actual.count
            let campos = actual.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
            let bajo: Nota
            do { bajo = try Nota(leyendo: String(campos[0])) } catch let error as any ErrorAlLeer {
                throw error.situado(en: texto, posicion: inicio + (error.posicion ?? 0))
            }
            let cifras = campos.count > 1 ? String(campos[1]) : ""
            do { acordes.append(try acorde(sobre: bajo, cifras: cifras)) } catch let error as any ErrorAlLeer {
                let inicioDeLasCifras = inicio + campos[0].count + 1
                throw error.situado(en: texto, posicion: inicioDeLasCifras + (error.posicion ?? 0))
            }
        }
        for caracter in texto {
            if caracter.isWhitespace {
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

    /// Las cifras de bajo continuo de un acorde, de arriba abajo, como se escriben debajo del bajo: las abreviaturas
    /// habituales («6», «6 4», «7», «6 5», «4 3», «4 2»; nada en la tríada en estado fundamental) y, delante de cada
    /// cifra, la alteración de la nota que la armadura de la tonalidad no da. Una tercera alterada que no se escribe
    /// queda en su alteración sola, abajo. Es lo contrario de ``acorde(sobre:cifras:)``.
    ///
    ///     Tonalidad(.do).cifrasDeBajo(de: Acorde("Sol7/Si"))           // ["6", "5"]
    ///     Tonalidad(.do).cifrasDeBajo(de: Acorde("Do/Sol"))            // ["6", "4"]
    ///     Tonalidad(.la, .menor).cifrasDeBajo(de: Acorde("Mi"))        // ["♯"]
    ///     Tonalidad(.la, .menor).cifrasDeBajo(de: Acorde("Mi7/Re"))    // ["♯4", "2"]
    public func cifrasDeBajo(de acorde: Acorde) -> [String] {
        let bajo = acorde.bajo
        var alteradas: [Int: String] = [:]
        var numeros: Set<Int> = []
        func pasos(_ nota: Nota) -> Int { modulo(nota.natural.indiceDiatonico - bajo.natural.indiceDiatonico, 7) }
        let conTercera = acorde.notas.contains { pasos($0) == 2 }
        for nota in acorde.notas where nota.claseDeAltura != bajo.claseDeAltura {
            var numero = pasos(nota) + 1
            // Una segunda con tercera es la novena.
            if numero == 2 && conTercera { numero = 9 }
            guard numero != 1 else { continue }
            numeros.insert(numero)
            let diatonica = notaDiatonica(numero, sobre: bajo)
            let diferencia = nota.alteracion.semitonos - diatonica.alteracion.semitonos
            if diferencia != 0 { alteradas[numero] = nota.alteracion.semitonos == 0 ? "♮" : diferencia > 0 ? "♯" : "♭" }
        }
        let abreviaturas: [Set<Int>: [Int]] = [
            [3, 5]: [], [3]: [], [5]: [], [3, 6]: [6], [4, 6]: [6, 4], [3, 5, 7]: [7], [3, 7]: [7], [3, 5, 6]: [6, 5],
            [3, 4, 6]: [4, 3], [2, 4, 6]: [4, 2],
        ]
        let escritas = abreviaturas[numeros] ?? numeros.sorted(by: >)
        var cifras = escritas.map { (alteradas[$0] ?? "") + String($0) }
        // Las alteraciones de las notas que no se escriben: la de la tercera, sola; las demás, con su cifra.
        for numero in numeros.subtracting(escritas).sorted(by: >) {
            guard let alteracion = alteradas[numero] else { continue }
            if numero == 3 {
                cifras.append(alteracion)
            } else {
                cifras.append(alteracion + String(numero))
            }
        }
        return cifras
    }

    /// La nota que está `numero` grados por encima del bajo en la armadura de la tonalidad (3 = la tercera).
    private func notaDiatonica(_ numero: Int, sobre bajo: Nota) -> Nota {
        let letra = modulo(bajo.natural.indiceDiatonico + numero - 1, 7)
        return escala.notas.first { $0.natural.indiceDiatonico == letra } ?? bajo
    }

    // MARK: Lectura de las cifras

    /// Una cifra leída: el intervalo sobre el bajo (2…7, o 9) y, si la lleva, su alteración (−1 bemol, 0 becuadro,
    /// +1 sostenido).
    private struct Cifra {
        var numero: Int
        var alteracion: Int?
    }

    /// Las cifras de un texto como «64», «6/4», «#6», «6+» o «b». Una alteración sola es la de la tercera. Lanza
    /// `.cifrasNoValidas` en el carácter que no es una cifra, o en la segunda de dos alteraciones seguidas.
    private static func leerCifras(_ texto: String) throws -> [Cifra] {
        var cifras: [Cifra] = []
        var pendiente: Int?
        var anteriorSinAlterar = false
        for (posicion, caracter) in texto.enumerated() where !caracter.isWhitespace && caracter != "/" {
            let error = ErrorDeLecturaDeTeoria(texto: texto, posicion: posicion, motivo: .cifrasNoValidas(texto))
            if let digito = caracter.wholeNumberValue {
                guard (1...9).contains(digito) else { throw error }
                cifras.append(Cifra(numero: digito, alteracion: pendiente))
                anteriorSinAlterar = pendiente == nil
                pendiente = nil
                continue
            }
            let alteracion: Int
            switch caracter {
            case "#", "♯", "+": alteracion = 1
            case "b", "♭": alteracion = -1
            case "♮", "n": alteracion = 0
            default: throw error
            }
            // Detrás de una cifra sin alterar, es la suya («6+», «6#»), salvo que venga otra cifra pegada.
            if anteriorSinAlterar, caracter == "+" || pendiente == nil {
                cifras[cifras.count - 1].alteracion = alteracion
                anteriorSinAlterar = false
            } else if pendiente == nil {
                pendiente = alteracion
            } else {
                throw error
            }
        }
        if let pendiente { cifras.append(Cifra(numero: 3, alteracion: pendiente)) }
        // El 1 y el 8 (el propio bajo) no añaden nota.
        return cifras.filter { $0.numero != 1 && $0.numero != 8 }
    }

    /// Completa las abreviaturas del bajo continuo: la tercera si no hay segunda, tercera ni cuarta; la quinta si
    /// no hay quinta ni sexta; la sexta con «43» y con la segunda; la cuarta con la segunda.
    private static func completarCifras(_ numeros: Set<Int>) -> Set<Int> {
        var completas = numeros
        if numeros.contains(2) { completas.formUnion([4, 6]) }
        if numeros.contains(4) && numeros.contains(3) { completas.insert(6) }
        if completas.isDisjoint(with: [2, 3, 4]) { completas.insert(3) }
        if completas.isDisjoint(with: [5, 6]) { completas.insert(5) }
        return completas
    }

    /// La nota con la alteración de la cifra: sube o baja medio tono, o queda natural.
    private static func alterar(_ nota: Nota, _ alteracion: Int) -> Nota {
        alteracion == 0 ? Nota(nota.natural) : Nota(pasosDeQuinta: nota.pasosDeQuinta + 7 * alteracion)
    }
}

extension Coral {
    /// Realiza un bajo cifrado a cuatro voces (ver ``Tonalidad/acordes(bajoCifrado:)`` y
    /// ``realizar(_:soprano:en:)``): el bajo lleva las notas dadas, en la octava que mejor conduzca las voces.
    /// Lanza como ``Tonalidad/acordes(bajoCifrado:)`` si el bajo cifrado no se puede leer, y da `nil` si se lee pero
    /// no hay realización sin faltas.
    ///
    ///     let coral = try Coral.realizar(bajoCifrado: "Do La:6 Sol:7 Do", en: Tonalidad(.do))!
    ///     coral.voz(0).map(\.nota)   // [Do, La, Sol, Do]
    ///     coral.esCorrecta           // true
    public static func realizar(bajoCifrado: String, en tonalidad: Tonalidad, soprano: [Altura]? = nil) throws
        -> Coral?
    {
        let acordes = try tonalidad.acordes(bajoCifrado: bajoCifrado)
        return realizar(acordes, soprano: soprano, en: tonalidad)
    }
}
