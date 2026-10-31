import ArmoniaNucleo
import Foundation

// Análisis genérico de acordes en coordenadas de quintas.
//
// Un tipo de acorde es un conjunto de desplazamientos en quintas respecto a la
// fundamental. Cada desplazamiento tiene un único papel posible, porque la
// ortografía lo fija (la 9ª aumentada es +9 quintas y la 3ª menor −3, aunque suenen igual):
//
//   tercera:  −3 (m)  4 (M)
//   quinta:    1 (J) −6 (d)  8 (A)
//   séptima:  −2 (m)  5 (M) −9 (d, solo en °7)
//   2ª / 9ª:  −5 (♭9) 2 (9)  9 (♯9)
//   4ª / 11ª: −1 (11) 6 (♯11)
//   6ª / 13ª: −4 (♭13) 3 (13 o sexta) 10 (♯6, solo como sexta aumentada)
//
// A partir de ese análisis se generan el cifrado, la disposición de intervalos y una
// penalización que mide lo "rebuscado" de una lectura (para ordenar candidatos).
// La estructura pública (`EstructuraDeAcorde`) se construye a partir de este análisis.

package struct ClasificacionDeAcorde: Hashable, Sendable {
    package var tercera: Int?
    package var quintasDelAcorde: [Int] = []
    package var septima: Int?
    package var segundas: [Int] = []
    package var cuartas: [Int] = []
    package var sextas: [Int] = []

    /// Todas las posiciones que puede ocupar una nota de acorde (además de la fundamental).
    package static let posicionesValidas: Set<Int> = [-3, 4, 1, -6, 8, -2, 5, -9, -5, 2, 9, -1, 6, -4, 3, 10]

    /// `nil` si el conjunto no se puede interpretar como acorde por terceras.
    /// `motivoDeRechazo(_:)` explica por qué.
    package init?(_ conjunto: Set<Int>) {
        guard ClasificacionDeAcorde.motivoDeRechazo(conjunto) == nil else { return nil }
        for intervalo in conjunto.sorted() where intervalo != 0 {
            switch intervalo {
            case -3, 4: tercera = intervalo
            case 1, -6, 8: quintasDelAcorde.append(intervalo)
            case -2, 5, -9: septima = intervalo
            case -5, 2, 9: segundas.append(intervalo)
            case -1, 6: cuartas.append(intervalo)
            default: sextas.append(intervalo) // −4, 3, 10
            }
        }
    }

    /// Explicación de por qué un conjunto no es un acorde interpretable, o `nil` si lo es.
    package static func motivoDeRechazo(_ conjunto: Set<Int>) -> ErrorDeLectura.RechazoDeAcorde? {
        guard conjunto.contains(0) else { return .faltaLaFundamental }
        for intervalo in conjunto.sorted() where intervalo != 0 && !posicionesValidas.contains(intervalo) {
            return .intervaloSinPapel(Intervalo.simpleAscendente(pasosDeQuinta: intervalo))
        }
        if conjunto.isSuperset(of: [-3, 4]) { return .terceraMayorYMenor }
        if conjunto.intersection([-2, 5, -9]).count > 1 { return .variasSeptimas }
        if conjunto.contains(-9),
            !(conjunto.contains(-3) && conjunto.intersection([1, -6, 8]) == [-6])
        {
            return .septimaDisminuidaFueraDelDisminuido
        }
        return nil
    }

    // MARK: Papeles

    package var sus4: Bool { tercera == nil && cuartas.contains(-1) }
    package var sus2: Bool { tercera == nil && !sus4 && segundas.contains(2) }
    /// Sexta añadida (acorde de sexta, sin séptima).
    package var sexta: Bool { septima == nil && sextas.contains(3) }
    /// Sexta aumentada sobre la fundamental (La♭–Fa♯): la de los acordes de sexta aumentada
    /// italiana, francesa y alemana. Va siempre dentro de la octava, como la sexta añadida.
    package var sextaAumentada: Bool { sextas.contains(10) }
    package var disminuido: Bool { tercera == -3 && quintasDelAcorde == [-6] }
    package var aumentado: Bool { tercera == 4 && quintasDelAcorde == [8] }
    package var potencia: Bool {
        tercera == nil && !sus4 && !sus2 && quintasDelAcorde == [1] && septima == nil
            && segundas.isEmpty && cuartas.isEmpty && sextas.isEmpty
    }

    /// Notas que actúan como tensiones (no como sus ni como sexta).
    package var tensiones: [Int] {
        var resultado = segundas + cuartas + sextas
        if sus4 { resultado.removeAll { $0 == -1 } }
        if sus2 { resultado.removeAll { $0 == 2 } }
        if sexta { resultado.removeAll { $0 == 3 } }
        resultado.removeAll { $0 == 10 }
        return resultado
    }

    // MARK: Disposición

    /// Intervalos desde la fundamental: notas del acorde simples, tensiones compuestas.
    package var intervalos: [Intervalo] {
        var simples: [Int] = [0]
        if let tercera { simples.append(tercera) }
        if sus4 { simples.append(-1) }
        if sus2 { simples.append(2) }
        simples += quintasDelAcorde
        if sexta { simples.append(3) }
        if sextaAumentada { simples.append(10) }
        if let septima { simples.append(septima) }
        let base = simples.map { Intervalo.simpleAscendente(pasosDeQuinta: $0) }
        let compuestas = tensiones.map { Intervalo.simpleAscendente(pasosDeQuinta: $0) + .octava }
        return (base + compuestas).sorted { ($0.pasos, $0.semitonos) < ($1.pasos, $1.semitonos) }
    }

    /// Cuanto más alta, menos probable es esta lectura del acorde.
    package var penalizacion: Double {
        var total = 0.0
        for tension in tensiones { total += [2, -1, 3].contains(tension) ? 0.5 : 1.5 }
        for intervalo in quintasDelAcorde where intervalo != 1 {
            total += (disminuido || aumentado) ? 0.5 : 1.5
        }
        if quintasDelAcorde.count > 1 { total += 1 }
        if quintasDelAcorde.isEmpty { total += 1.5 }
        if tercera == nil { total += (sus4 || sus2 || potencia) ? 0.5 : 2.5 }
        if sexta { total += 0.5 }
        if sextaAumentada { total += 1.5 }
        return total
    }
}

// MARK: - Lectura de cifrados

extension ClasificacionDeAcorde {
    /// Quintas de la versión natural de cada grado de tensión o de la quinta.
    package static let gradoNatural: [Int: Int] = [2: 2, 9: 2, 4: -1, 11: -1, 6: 3, 13: 3, 5: 1]
    package static let gradosOmitibles: Set<Int> = [3, 5, 7, 2, 9, 4, 11, 6, 13]

    /// Convierte un cifrado sin fundamental ("m7(♭5)", "7(b9,#11)", "13sus4", "6/9",
    /// "(add9)", "7alt", "maj9(omit5)"…) en un conjunto de quintas.
    /// Lee lo que queda en `lector`; las posiciones de error se cuentan en su texto completo.
    package static func conjunto(desde lector: Lector) throws -> Set<Int> {
        let original = lector.texto
        var resto = lector.resto
        var menor = false
        var disminuido = false
        var semidisminuido = false
        var aumentado = false
        var septimaMayor = false
        var deltaImplicaSeptima = false
        var seisNueve = false
        var alterado = false
        var numero: Int?
        var posicionDelNumero: Int?
        var sus: Int?
        var explicitas: [Int] = []
        var anadidas: [Int] = []
        var omitidos: [Int] = []
        var enParentesis = false
        var parentesisAbierto: Substring?
        var despuesDeMaj = false

        func fallo(_ motivo: ErrorDeLectura.Motivo, en fragmento: Substring?) -> ErrorDeLectura {
            ErrorDeLectura(texto: original, posicion: fragmento?.posicionEnOrigen, motivo: motivo)
        }
        func consumir(_ prefijo: String) -> Bool {
            guard resto.hasPrefix(prefijo) else { return false }
            resto = resto.dropFirst(prefijo.count)
            return true
        }
        func leerNumero() -> Int? {
            let digitos = resto.cifrasIniciales
            guard let numeroLeido = Int(digitos) else { return nil }
            resto = resto.dropFirst(digitos.count)
            return numeroLeido
        }
        /// Tensión con alteración obligatoria: b9, ♯11, -5, +5…
        /// Con b/♭/#/♯, un grado que no existe es un error; con -/+ (que también
        /// significan menor y aumentado) simplemente no se reconoce.
        func leerAlterada() throws -> Int? {
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
            guard let numeroLeido = Int(digitos), let base = gradoNatural[numeroLeido] else {
                if signo { return nil }
                throw fallo(.tensionNoValida(resto.fragmentoParaError), en: resto)
            }
            if caracter == "-" && ![5, 9, 13].contains(numeroLeido) { return nil }
            if caracter == "+" && ![5, 9, 11].contains(numeroLeido) { return nil }
            resto = tras.dropFirst(digitos.count)
            return base + 7 * alteracion
        }
        /// Tensión con alteración opcional: 9, b9, #11, 13…
        func leerTension(desde inicio: Substring) throws -> Int {
            if let alterada = try leerAlterada() { return alterada }
            guard let numeroLeido = leerNumero(), let base = gradoNatural[numeroLeido] else {
                throw fallo(.tensionNoValida(inicio.fragmentoParaError), en: inicio)
            }
            return base
        }

        while !resto.isEmpty {
            let inicio = resto
            let previoMaj = despuesDeMaj
            despuesDeMaj = false
            if consumir(" ") || consumir(",") {
                despuesDeMaj = previoMaj
                continue
            }
            if consumir("(") {
                // Sin paréntesis anidados: "Do7((9)" no es un cifrado.
                if enParentesis { throw fallo(.simboloNoReconocido("("), en: inicio) }
                enParentesis = true
                parentesisAbierto = inicio
                despuesDeMaj = previoMaj
                continue
            }
            if consumir(")") {
                guard enParentesis else { throw fallo(.simboloNoReconocido(")"), en: inicio) }
                enParentesis = false
                continue
            }
            if consumir("6/9") || consumir("69") {
                seisNueve = true
                continue
            }
            if consumir("maj") || consumir("Maj") || consumir("MA") {
                septimaMayor = true
                despuesDeMaj = true
                continue
            }
            if consumir("Δ") || consumir("∆") {
                septimaMayor = true
                deltaImplicaSeptima = true
                despuesDeMaj = true
                continue
            }
            if consumir("min") {
                menor = true
                continue
            }
            if consumir("M") {
                septimaMayor = true
                despuesDeMaj = true
                continue
            }
            if consumir("omit") || consumir("no") {
                guard let numeroLeido = leerNumero() else {
                    throw fallo(.simboloNoReconocido(inicio.fragmentoParaError), en: inicio)
                }
                guard gradosOmitibles.contains(numeroLeido) else {
                    throw fallo(.gradoNoOmitible(numeroLeido), en: inicio)
                }
                omitidos.append(numeroLeido)
                continue
            }
            if consumir("dim") || consumir("°") || consumir("º") || consumir("o") {
                disminuido = true
                continue
            }
            if consumir("ø") || consumir("Ø") {
                semidisminuido = true
                continue
            }
            if consumir("add") {
                let tension = try leerTension(desde: resto)
                anadidas.append(tension)
                continue
            }
            if consumir("alt") {
                alterado = true
                continue
            }
            if consumir("sus") {
                if consumir("2") {
                    sus = 2
                } else {
                    _ = consumir("4")
                    sus = -1
                }
                continue
            }
            if let alterada = try leerAlterada() {
                explicitas.append(alterada)
                continue
            }
            if consumir("aug") || consumir("+") {
                aumentado = true
                continue
            }
            if consumir("m") || consumir("-") {
                menor = true
                continue
            }
            if let numeroLeido = leerNumero() {
                if enParentesis && !previoMaj && numeroLeido != 6 && numeroLeido != 7 {
                    guard let base = gradoNatural[numeroLeido] else {
                        throw fallo(.tensionNoValida("\(numeroLeido)"), en: inicio)
                    }
                    explicitas.append(base)
                } else {
                    guard numero == nil else { throw fallo(.numeroRepetido(numeroLeido), en: inicio) }
                    numero = numeroLeido
                    posicionDelNumero = inicio.posicionEnOrigen
                }
                continue
            }
            throw fallo(.simboloNoReconocido(inicio.fragmentoParaError), en: inicio)
        }
        // Un paréntesis sin cerrar ("Do7(b9") no se da por bueno.
        if enParentesis, let abierto = parentesisAbierto {
            throw fallo(.simboloNoReconocido("("), en: abierto)
        }

        if disminuido && semidisminuido {
            throw fallo(.calidadesIncompatibles(.disminuidoYSemidisminuido), en: nil)
        }
        var tercera: Int? = (menor || disminuido || semidisminuido) ? -3 : 4
        var quintas: Set<Int> = (disminuido || semidisminuido) ? [-6] : (aumentado ? [8] : [1])
        var septima: Int?
        var sexta = false
        var tensiones: Set<Int> = []

        var numeroEfectivo = numero
        if numeroEfectivo == nil && (deltaImplicaSeptima || semidisminuido || alterado) { numeroEfectivo = 7 }
        switch numeroEfectivo {
        case nil:
            break
        case 2?:
            tensiones.insert(2)
        case 5?:
            guard !menor, !disminuido, !semidisminuido, !aumentado else {
                throw fallo(.calidadesIncompatibles(.quintaConCalidad), en: nil)
            }
            tercera = nil
        case 6?:
            sexta = true
        case 7?, 9?, 11?, 13?:
            septima = septimaMayor ? 5 : (disminuido ? -9 : -2)
            let grado = numeroEfectivo ?? 7
            if grado >= 9 { tensiones.insert(2) }
            if grado == 11 { tensiones.insert(-1) }
            if grado == 13 {
                tensiones.insert(3)
                if tercera == -3 { tensiones.insert(-1) }
            }
        case let otro?:
            throw ErrorDeLectura(
                texto: original, posicion: posicionDelNumero,
                motivo: .numeroDeAcordeNoValido(otro))
        }
        if seisNueve {
            sexta = true
            tensiones.insert(2)
        }
        if alterado {
            tensiones.subtract([2, -1, 3])
            tensiones.formUnion([-5, 9, 6, -4])
        }

        let quintasExplicitas = explicitas.filter { modulo(4 * $0, 7) == 4 }
        if !quintasExplicitas.isEmpty { quintas = Set(quintasExplicitas) }
        // Una alteración explícita (♭9, ♯11, ♭13) sustituye a la natural que implicaba
        // el número; "add" y las naturales explícitas solo añaden.
        for tension in explicitas {
            switch modulo(4 * tension, 7) {
            case 1 where tension != 2: tensiones.remove(2)
            case 3 where tension != -1: tensiones.remove(-1)
            case 5 where tension != 3: tensiones.remove(3)
            default: break
            }
        }
        for tension in explicitas + anadidas {
            if modulo(4 * tension, 7) == 4 {
                if anadidas.contains(tension) { quintas.insert(tension) }
            } else {
                tensiones.insert(tension)
            }
        }
        if let sus {
            tercera = nil
            tensiones.insert(sus)
        }
        for grado in omitidos {
            switch grado {
            case 3: tercera = nil
            case 5: quintas = []
            case 7: septima = nil
            case 2, 9: tensiones.subtract([-5, 2, 9])
            case 4, 11: tensiones.subtract([-1, 6])
            default:
                tensiones.subtract([-4, 3, 10])
                sexta = false // 6, 13
            }
        }

        var conjunto: Set<Int> = [0]
        if let tercera { conjunto.insert(tercera) }
        conjunto.formUnion(quintas)
        if let septima { conjunto.insert(septima) }
        if sexta { conjunto.insert(3) }
        conjunto.formUnion(tensiones)
        return conjunto
    }
}

extension ClasificacionDeAcorde {
    // MARK: Cifrado

    package static let etiquetas: [Int: String] = [
        1: "5", -6: "♭5", 8: "♯5", 10: "♯6", -5: "♭9", 2: "9", 9: "♯9", -1: "11", 6: "♯11", -4: "♭13", 3: "13",
    ]
    package static let ordenEtiquetas = [1, -6, 8, 10, -5, 2, 9, -1, 6, -4, 3]

    package var simbolo: String { simbolo(estilo: .predeterminado) }

    /// Genera el cifrado. Todo lo que se pone entre paréntesis (alteraciones de la quinta,
    /// tensiones, adiciones y omisiones) va en un único grupo: "m(add9)", "7(♭9,♯11)".
    package func simbolo(estilo: EstiloDeCifrado) -> String {
        if potencia { return "5" }

        let textoMenor = estilo.menor.rawValue
        var restantes = Set(tensiones)
        var alteradasQuinta = Set(quintasDelAcorde.filter { $0 != 1 })
        // Si conviven la quinta justa y una alterada, la justa también se escribe: (5,♭5).
        if !alteradasQuinta.isEmpty && quintasDelAcorde.contains(1) { alteradasQuinta.insert(1) }
        var prefijo = ""
        var numero = ""
        let sufijoSus = sus4 ? "sus4" : (sus2 ? "sus2" : "")
        var omisiones: [String] = []
        if tercera == nil && !sus4 && !sus2 { omisiones.append("omit3") }
        if quintasDelAcorde.isEmpty { omisiones.append("omit5") }

        if disminuido && (septima == nil || septima == -9) {
            prefijo = estilo.disminuido.rawValue
            alteradasQuinta = []
            if septima == -9 { numero = "7" }
        } else if disminuido && septima == -2 && estilo.semidisminuido == .barrado {
            prefijo = "ø"
            alteradasQuinta = []
        } else if aumentado {
            prefijo = estilo.aumentado.rawValue
            alteradasQuinta = []
        } else if tercera == -3 {
            prefijo = textoMenor
        }

        if let septima, septima != -9 {
            // El número sube a 11 o 13 aunque la 9ª (o la 11ª en el menor) esté alterada:
            // 13(♭9) = 7 + ♭9 + 13. La versión natural queda absorbida por el número,
            // salvo que conviva con su alterada (entonces se escriben ambas: 13(♭9,9)).
            var numeroDelAcorde = 7
            let menor = tercera == -3
            let hayNovena = !restantes.isDisjoint(with: [-5, 2, 9])
            let hayUndecima = !restantes.isDisjoint(with: [-1, 6])
            let rivales: [Int: Set<Int>] = [2: [-5, 9], -1: [6], 3: [-4]]
            func absorber(_ tension: Int) {
                if restantes.isDisjoint(with: rivales[tension] ?? []) { restantes.remove(tension) }
            }
            if hayNovena && restantes.contains(3) && (!menor || hayUndecima) {
                numeroDelAcorde = 13
                absorber(2)
                absorber(3)
                if menor && restantes.contains(-1) { absorber(-1) }
            } else if hayNovena && restantes.contains(-1) {
                numeroDelAcorde = 11
                absorber(2)
                absorber(-1)
            } else if restantes.contains(2) && restantes.isDisjoint(with: [-5, 9]) {
                numeroDelAcorde = 9
                restantes.remove(2)
            }
            if septima == 5 {
                let textoMaj = estilo.septimaMayor.rawValue
                numero = prefijo == textoMenor ? "(\(textoMaj)\(numeroDelAcorde))" : "\(textoMaj)\(numeroDelAcorde)"
            } else {
                numero = "\(numeroDelAcorde)"
            }
        } else if sexta {
            if restantes.contains(2) && restantes.isDisjoint(with: [-5, 9]) {
                numero = "6/9"
                restantes.remove(2)
            } else {
                numero = "6"
            }
        }

        // "+9" o "+11" se leerían como ♯9 o ♯11; en ese caso se escribe "aug".
        if prefijo == "+" && (numero.hasPrefix("9") || numero.hasPrefix("11")) { prefijo = "aug" }

        var grupo: [String] = []
        for intervalo in ClasificacionDeAcorde.ordenEtiquetas {
            guard let etiqueta = ClasificacionDeAcorde.etiquetas[intervalo] else { continue }
            if alteradasQuinta.contains(intervalo) || (intervalo == 10 && sextaAumentada) {
                grupo.append(etiqueta)
            } else if restantes.contains(intervalo) {
                grupo.append(septima != nil || sexta || sextaAumentada ? etiqueta : "add" + etiqueta)
            }
        }
        grupo += omisiones
        var resultado =
            prefijo + numero + sufijoSus
            + (grupo.isEmpty ? "" : "(" + grupo.joined(separator: ",") + ")")
        if estilo.tensionesEnASCII {
            resultado = resultado.replacingOccurrences(of: "♭", with: "b")
                .replacingOccurrences(of: "♯", with: "#")
        }
        return resultado
    }
}
