import ArmoniaNucleo

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
    /// `nil` si las cifras no se pueden leer o sus notas no forman un acorde.
    ///
    ///     Tonalidad(.do).acorde(sobre: .si, cifras: "65")             // Sol7/Si
    ///     Tonalidad(.la, .menor).acorde(sobre: .mi, cifras: "#")      // Mi
    ///     Tonalidad(.la, .menor).acorde(sobre: .fa, cifras: "6")      // Rem/Fa
    public func acorde(sobre bajo: Nota, cifras: String) -> Acorde? {
        guard let leidas = Tonalidad.leerCifras(cifras) else { return nil }
        let numeros = Tonalidad.completarCifras(Set(leidas.map(\.numero)))
        let notas = numeros.sorted().map { numero in
            var nota = notaDiatonica(numero, sobre: bajo)
            if let alteracion = leidas.last(where: { $0.numero == numero })?.alteracion {
                nota = Tonalidad.alterar(nota, alteracion)
            }
            return nota
        }
        let todas = [bajo] + notas
        let candidatos = Acorde.identificar(todas)
        let exacto = candidatos.first { $0.bajo == bajo && Set($0.notas + [$0.bajo]) == Set(todas) }
        return exacto ?? candidatos.first { $0.bajo == bajo }
    }

    /// Los acordes de un bajo cifrado escrito como notas del bajo separadas por espacios, cada una con sus cifras
    /// detrás de dos puntos: «Do Fa:6 Sol:7 Do», «La Re:6 Mi:# La». `nil` si alguna nota o alguna cifra no se
    /// puede leer o no forma acorde.
    ///
    ///     Tonalidad(.do).acordes(bajoCifrado: "Do Fa Sol:7 Do")         // [Do, Fa, Sol7, Do]
    ///     Tonalidad(.do).acordes(bajoCifrado: "Do Re:43 Mi:6 Fa Sol")   // [Do, Sol7/Re, Do/Mi, Fa, Sol]
    public func acordes(bajoCifrado texto: String) -> [Acorde]? {
        let partes = texto.split(whereSeparator: \.isWhitespace)
        guard !partes.isEmpty else { return nil }
        var acordes: [Acorde] = []
        for parte in partes {
            let campos = parte.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
            guard let bajo = try? Nota(leyendo: String(campos[0])),
                let acorde = acorde(sobre: bajo, cifras: campos.count > 1 ? String(campos[1]) : "")
            else { return nil }
            acordes.append(acorde)
        }
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

    /// Las cifras de un texto como «64», «6/4», «#6», «6+» o «b»; `nil` si tiene algo que no es una cifra. Una
    /// alteración sola es la de la tercera.
    private static func leerCifras(_ texto: String) -> [Cifra]? {
        var cifras: [Cifra] = []
        var pendiente: Int?
        var anteriorSinAlterar = false
        for caracter in texto where !caracter.isWhitespace && caracter != "/" {
            if let digito = caracter.wholeNumberValue {
                guard (1...9).contains(digito) else { return nil }
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
            default: return nil
            }
            // Detrás de una cifra sin alterar, es la suya («6+», «6#»), salvo que venga otra cifra pegada.
            if anteriorSinAlterar, caracter == "+" || pendiente == nil {
                cifras[cifras.count - 1].alteracion = alteracion
                anteriorSinAlterar = false
            } else if pendiente == nil {
                pendiente = alteracion
            } else {
                return nil
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
    /// `nil` si el bajo cifrado no se puede leer o no hay realización sin faltas.
    ///
    ///     let coral = Coral.realizar(bajoCifrado: "Do La:6 Sol:7 Do", en: Tonalidad(.do))!
    ///     coral.voz(0).map(\.nota)   // [Do, La, Sol, Do]
    ///     coral.esCorrecta           // true
    public static func realizar(bajoCifrado: String, en tonalidad: Tonalidad, soprano: [Altura]? = nil) -> Coral? {
        guard let acordes = tonalidad.acordes(bajoCifrado: bajoCifrado) else { return nil }
        return realizar(acordes, soprano: soprano, en: tonalidad)
    }
}
