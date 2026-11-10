import Elementos
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
//   4ª / 11ª: −1 (11) 6 (♯11) 13 (𝄪11, solo con la sexta aumentada: la sexta suiza)
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
    package static let posicionesValidas: Set<Int> = [-3, 4, 1, -6, 8, -2, 5, -9, -5, 2, 9, -1, 6, 13, -4, 3, 10]

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
            case -1, 6, 13: cuartas.append(intervalo)
            default: sextas.append(intervalo) // −4, 3, 10
            }
        }
    }

    /// Explicación de por qué un conjunto no es un acorde interpretable, o `nil` si lo es.
    package static func motivoDeRechazo(_ conjunto: Set<Int>) -> ErrorDeLecturaDeTeoria.RechazoDeAcorde? {
        guard conjunto.contains(0) else { return .faltaLaFundamental }
        for intervalo in conjunto.sorted() where intervalo != 0 && !posicionesValidas.contains(intervalo) {
            return .intervaloSinPapel(Intervalo.simpleAscendente(pasosDeQuinta: intervalo))
        }
        // La cuarta doble aumentada solo es la de la sexta suiza (La♭ Do Re♯ Fa♯), con la sexta aumentada.
        if conjunto.contains(13), !conjunto.contains(10) {
            return .intervaloSinPapel(Intervalo.simpleAscendente(pasosDeQuinta: 13))
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
    /// "(add9)", "7alt", "maj9(omit5)"…) en un conjunto de quintas, con ``LecturaDeCifrado``.
    /// Lee lo que queda en `lector`; las posiciones de error se cuentan en su texto completo.
    package static func conjunto(desde lector: Lector) throws -> Set<Int> {
        var lectura = LecturaDeCifrado(lector)
        try lectura.leer()
        return try lectura.conjunto()
    }
}

extension ClasificacionDeAcorde {
    // MARK: Cifrado

    package static let etiquetas: [Int: String] = [
        1: "5", -6: "♭5", 8: "♯5", 10: "♯6", -5: "♭9", 2: "9", 9: "♯9", -1: "11", 6: "♯11", 13: "𝄪11", -4: "♭13",
        3: "13",
    ]
    package static let ordenEtiquetas = [1, -6, 8, 10, -5, 2, 9, -1, 6, 13, -4, 3]

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
