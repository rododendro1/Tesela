import ArmoniaNucleo
import ArmoniaTeoria

// Contrapunto de especies a dos voces, como lo enseña Fux en el Gradus ad Parnassum (1725): un
// cantus firmus en redondas y, encima o debajo, un contrapunto de la especie que se practica.
// Las reglas son las del contrapunto estricto; `FaltaDeContrapunto.Tipo` explica cada una.

// MARK: - FaltaDeContrapunto

/// Una falta de un contrapunto de especies: qué regla se rompe y en qué compases.
///
/// Los compases se cuentan desde 0, uno por nota del cantus firmus. Si la falta es un movimiento,
/// `compases` va del de la primera nota al de la segunda; si no, empieza y acaba en el mismo.
public struct FaltaDeContrapunto: Hashable, Sendable, CustomStringConvertible {
    public enum Tipo: Hashable, Sendable, CaseIterable {
        /// Un compás con un ritmo que no es el de la especie (por ejemplo, tres notas en la segunda).
        case ritmoDeLaEspecie
        /// La primera nota no forma unísono, quinta u octava con el cantus (debajo, solo unísono u octava).
        case comienzoImperfecto
        /// La última nota no forma unísono ni octava con el cantus.
        case finalImperfecto
        /// A la última nota no se llega por grado conjunto.
        case finalSinGradoConjunto
        /// Una disonancia en la parte fuerte del compás que no es un retardo.
        case disonanciaEnParteFuerte
        /// Una disonancia en parte débil que no es de paso (ni, desde la tercera especie, una bordadura),
        /// o cualquier disonancia en parte débil en la cuarta especie.
        case disonanciaMalTratada
        /// Un retardo sin preparar en consonancia o que no resuelve bajando por grado a una consonancia.
        case retardoMalResuelto
        /// Dos quintas justas seguidas con las dos voces en movimiento (en la segunda especie, también
        /// de parte fuerte a parte fuerte).
        case quintasParalelas
        /// Dos octavas (o unísonos) seguidas con las dos voces en movimiento.
        case octavasParalelas
        /// Se llega a una quinta en parte fuerte con las dos voces en el mismo sentido.
        case quintasDirectas
        /// Se llega a una octava (o un unísono) en parte fuerte con las dos voces en el mismo sentido.
        case octavasDirectas
        /// Un unísono en parte fuerte que no es ni el primer compás ni el último.
        case unisono
        /// El contrapunto pasa al otro lado del cantus.
        case cruceDeVoces
        /// Un salto aumentado o disminuido, de séptima, de más de una octava, de sexta mayor o de
        /// sexta menor descendente.
        case saltoNoMelodico
        /// Después de un salto de más de una cuarta, la voz no vuelve en sentido contrario.
        case saltoSinCompensar
        /// La misma nota dos veces seguidas sin ligadura (desde la segunda especie).
        case notaRepetida
    }

    public let tipo: Tipo
    /// Del compás de la primera nota al de la última de la falta, contados desde 0.
    public let compases: ClosedRange<Int>

    public init(tipo: Tipo, compases: ClosedRange<Int>) {
        self.tipo = tipo
        self.compases = compases
    }

    /// "Quintas paralelas (compases 3 → 4)". Los compases se cuentan desde 1.
    public var description: String { descripcion(en: .espanolUnicode) }
}

// MARK: - Contrapunto

/// Un contrapunto de especies a dos voces: un cantus firmus en redondas, una por compás, y un
/// contrapunto encima o debajo, para comprobarlo con las reglas del contrapunto estricto.
///
///     // El primer ejemplo de Fux, nota contra nota sobre su cantus en re.
///     let ejercicio = try Contrapunto(cantusFirmus: "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4",
///                                     contrapunto: "La4 La4 Sol4 La4 Si4 Do5 Do5 Si4 Re5 Do#5 Re5",
///                                     especie: .primera)
///     ejercicio.esCorrecto   // true
///
/// Las especies, en compases de una redonda:
///
/// 1. nota contra nota: una redonda por compás;
/// 2. dos blancas por compás (el primero puede empezar con silencio de blanca);
/// 3. cuatro negras por compás (el primero puede empezar con silencio de negra);
/// 4. síncopas: blancas ligadas de la parte débil a la fuerte siguiente, con retardos;
/// 5. contrapunto florido: las figuras que se quieran, sin silencios después del principio.
///
/// En todas, el último compás es una redonda (en la segunda y la tercera, también el penúltimo
/// puede serlo).
public struct Contrapunto: Hashable, Sendable {
    public enum Especie: Int, Hashable, Sendable, CaseIterable {
        case primera = 1
        case segunda, tercera, cuarta, quinta

        /// La figura de las notas que se escriben sin duración: redonda, blanca, negra, blanca y negra.
        public var figura: Duracion {
            switch self {
            case .primera: return .redonda
            case .segunda, .cuarta: return .blanca
            case .tercera, .quinta: return .negra
            }
        }
    }

    /// Una redonda por compás.
    public let cantusFirmus: [Altura]
    /// En compases de una redonda, tantos como notas tiene el cantus.
    public let contrapunto: Voz
    public let especie: Especie

    /// `nil` si el cantus está vacío o si el contrapunto no dura una redonda por cada nota del cantus.
    public init?(cantusFirmus: [Altura], contrapunto: [Evento], especie: Especie) {
        guard !cantusFirmus.isEmpty,
            contrapunto.map(\.duracion).sumar() == Duracion(cantusFirmus.count)
        else { return nil }
        self.cantusFirmus = cantusFirmus
        self.contrapunto = Voz(contrapunto, compas: Compas(4, 4))
        self.especie = especie
    }

    /// Lee el cantus como alturas separadas por espacios ("Re4 Fa4 Mi4") y el contrapunto como los
    /// eventos de una voz ("-:2 La4:2 Do5:2"), donde una altura sin duración lleva la figura de la
    /// especie: "La4 Do5 Si4" en la segunda especie son tres blancas.
    public init(cantusFirmus: String, contrapunto: String, especie: Especie) throws {
        var cantus: [Altura] = []
        var inicio = 0
        for trozo in cantusFirmus.split(separator: " ", omittingEmptySubsequences: false) {
            defer { inicio += trozo.count + 1 }
            guard !trozo.isEmpty else { continue }
            do { cantus.append(try Altura(leyendo: String(trozo))) } catch let e as ErrorDeLectura {
                throw ErrorDeLectura(texto: cantusFirmus, posicion: inicio + (e.posicion ?? 0), motivo: e.motivo)
            }
        }
        guard !cantus.isEmpty else { throw ErrorDeLectura(texto: cantusFirmus, posicion: nil, motivo: .textoVacio) }
        let figura = especie.figura == .redonda ? "1" : (especie.figura == .blanca ? "2" : "4")
        let eventos = contrapunto.split(separator: " ").map {
            $0.contains(":") ? String($0) : String($0) + ":" + figura
        }
        let voz = try Voz(leyendo: eventos.joined(separator: " "))
        guard let leido = Contrapunto(cantusFirmus: cantus, contrapunto: voz.eventos, especie: especie) else {
            throw ErrorDeLectura(
                texto: contrapunto, posicion: nil, motivo: .contrapuntoDeOtraDuracion(redondas: cantus.count))
        }
        self = leido
    }

    /// `true` si el contrapunto va, de media, por encima del cantus.
    public var contrapuntoArriba: Bool {
        let notas = sonoridades.map(\.nota.midi)
        guard !notas.isEmpty else { return true }
        let media = Double(notas.reduce(0, +)) / Double(notas.count)
        return media >= Double(cantusFirmus.map(\.midi).reduce(0, +)) / Double(cantusFirmus.count)
    }

    /// `true` si no hay ninguna falta.
    public var esCorrecto: Bool { faltas.isEmpty }

    // MARK: Sonoridades

    /// Una nota del contrapunto contra la del cantus de su compás. `ataque` es `false` si viene
    /// ligada de la anterior (la parte fuerte de una síncopa).
    package struct Sonoridad: Hashable {
        package let compas: Int
        package let inicio: Duracion
        package let nota: Altura
        package let cantus: Altura
        package let ataque: Bool

        package var enParteFuerte: Bool { inicio.esCero }

        /// El intervalo entre las dos voces, del grave al agudo.
        package var intervalo: Intervalo {
            nota.midi < cantus.midi ? nota.intervalo(hasta: cantus) : cantus.intervalo(hasta: nota)
        }
    }

    /// Todas las notas del contrapunto, cada una contra la del cantus, en orden.
    package var sonoridades: [Sonoridad] {
        var resultado: [Sonoridad] = []
        var anterior: Evento?
        for (c, eventos) in contrapunto.compases.enumerated() where c < cantusFirmus.count {
            var inicio = Duracion.cero
            for evento in eventos {
                defer {
                    inicio = inicio + evento.duracion
                    anterior = evento
                }
                guard let nota = evento.alturas.first else { continue }
                let ligada = anterior.map { $0.ligada && $0.alturas == evento.alturas } ?? false
                resultado.append(
                    Sonoridad(compas: c, inicio: inicio, nota: nota, cantus: cantusFirmus[c], ataque: !ligada))
            }
        }
        return resultado
    }

    // MARK: Faltas

    /// Todas las faltas, ordenadas por compás.
    public var faltas: [FaltaDeContrapunto] {
        var faltas: [FaltaDeContrapunto] = []
        func anotar(_ tipo: FaltaDeContrapunto.Tipo, _ desde: Int, _ hasta: Int? = nil) {
            let falta = FaltaDeContrapunto(tipo: tipo, compases: desde...(hasta ?? desde))
            if !faltas.contains(falta) { faltas.append(falta) }
        }
        let todas = sonoridades
        let ataques = todas.filter(\.ataque)
        let arriba = contrapuntoArriba
        let ultimo = cantusFirmus.count - 1

        // Ritmo, compás a compás.
        for (c, eventos) in contrapunto.compases.enumerated() where !ritmoValido(eventos, compas: c, ultimo: ultimo) {
            anotar(.ritmoDeLaEspecie, c)
        }

        // Principio y final.
        if let primera = ataques.first {
            let perfecta = Contrapunto.perfecta(primera.intervalo)
            if perfecta == nil || (!arriba && perfecta == 5) { anotar(.comienzoImperfecto, primera.compas) }
        }
        if let ultima = ataques.last {
            if Contrapunto.perfecta(ultima.intervalo) != 8 || ultima.compas != ultimo {
                anotar(.finalImperfecto, ultima.compas)
            }
            if ataques.count > 1, !Contrapunto.esGrado(ataques[ataques.count - 2].nota, ultima.nota) {
                anotar(.finalSinGradoConjunto, ataques[ataques.count - 2].compas, ultima.compas)
            }
        }

        // Cada nota contra el cantus.
        for (k, s) in todas.enumerated() {
            if arriba ? s.nota.midi < s.cantus.midi : s.nota.midi > s.cantus.midi { anotar(.cruceDeVoces, s.compas) }
            let disonante = Contrapunto.esDisonancia(s.intervalo)
            if s.enParteFuerte && s.ataque && s.compas != 0 && s.compas != ultimo
                && s.intervalo.numero == 1 && s.intervalo.calidad == .justa
            {
                anotar(.unisono, s.compas)
            }
            guard disonante else { continue }
            if s.enParteFuerte {
                if !s.ataque && (especie == .cuarta || especie == .quinta) {
                    if !retardoBienTratado(en: k, todas) { anotar(.retardoMalResuelto, s.compas) }
                } else {
                    anotar(.disonanciaEnParteFuerte, s.compas)
                }
            } else if s.ataque {
                if !disonanciaDebilBienTratada(s, ataques) { anotar(.disonanciaMalTratada, s.compas) }
            }
        }

        // De una nota a la siguiente.
        for i in ataques.indices.dropLast() {
            let a = ataques[i]
            let b = ataques[i + 1]
            let salto = a.nota.intervalo(hasta: b.nota)
            let subeElContrapunto = b.nota.midi - a.nota.midi
            if Contrapunto.esSaltoNoMelodico(salto, ascendente: subeElContrapunto > 0) {
                anotar(.saltoNoMelodico, a.compas, b.compas)
            }
            if a.nota == b.nota && especie != .primera { anotar(.notaRepetida, a.compas, b.compas) }
            if salto.numero >= 5 && subeElContrapunto != 0, i + 2 < ataques.count {
                let vuelta = ataques[i + 2].nota.midi - b.nota.midi
                if vuelta == 0 || (vuelta > 0) == (subeElContrapunto > 0) {
                    anotar(.saltoSinCompensar, a.compas, b.compas)
                }
            }
            // Paralelas y directas: solo cuando se mueven las dos voces.
            let subeElCantus = b.cantus.midi - a.cantus.midi
            guard a.compas != b.compas, subeElCantus != 0, subeElContrapunto != 0 else { continue }
            let antes = Contrapunto.perfecta(a.intervalo)
            let despues = Contrapunto.perfecta(b.intervalo)
            if let despues, antes == despues {
                anotar(despues == 5 ? .quintasParalelas : .octavasParalelas, a.compas, b.compas)
            } else if let despues, b.enParteFuerte, (subeElCantus > 0) == (subeElContrapunto > 0) {
                anotar(despues == 5 ? .quintasDirectas : .octavasDirectas, a.compas, b.compas)
            }
        }

        // En la segunda especie, también de parte fuerte a parte fuerte.
        if especie == .segunda {
            let fuertes = ataques.filter(\.enParteFuerte)
            for (a, b) in zip(fuertes, fuertes.dropFirst())
            where b.compas == a.compas + 1 && a.cantus != b.cantus && a.nota != b.nota {
                if let antes = Contrapunto.perfecta(a.intervalo), antes == Contrapunto.perfecta(b.intervalo) {
                    anotar(antes == 5 ? .quintasParalelas : .octavasParalelas, a.compas, b.compas)
                }
            }
        }
        return faltas.sorted {
            ($0.compases.lowerBound, $0.compases.upperBound) < ($1.compases.lowerBound, $1.compases.upperBound)
        }
    }

    /// Si un compás tiene el ritmo de la especie.
    private func ritmoValido(_ eventos: [Evento], compas c: Int, ultimo: Int) -> Bool {
        let duraciones = eventos.map(\.duracion)
        let silencios = eventos.map(\.esSilencio)
        let silencioInicial = c == 0 && silencios.first == true
        // Ningún silencio, salvo el primero del primer compás.
        guard !silencios.enumerated().contains(where: { $0.element && !($0.offset == 0 && silencioInicial) }) else {
            return false
        }
        if c == ultimo { return duraciones == [.redonda] }
        switch especie {
        case .primera:
            return duraciones == [.redonda]
        case .segunda:
            return duraciones == [.blanca, .blanca] || (c == ultimo - 1 && duraciones == [.redonda])
        case .tercera:
            return duraciones == Array(repeating: .negra, count: 4) || (c == ultimo - 1 && duraciones == [.redonda])
        case .cuarta:
            return duraciones == [.blanca, .blanca]
        case .quinta:
            return duraciones.allSatisfy { $0 >= .corchea }
        }
    }

    /// Un retardo (la nota `k`, ligada desde la parte débil anterior) se prepara en consonancia y
    /// resuelve bajando por grado a una consonancia.
    private func retardoBienTratado(en k: Int, _ todas: [Sonoridad]) -> Bool {
        let retardo = todas[k]
        // La preparación: la nota atacada de la que viene ligada.
        guard let preparacion = todas[..<k].last(where: \.ataque), !Contrapunto.esDisonancia(preparacion.intervalo),
            k + 1 < todas.count
        else { return false }
        let resolucion = todas[k + 1]
        return resolucion.ataque && resolucion.compas == retardo.compas
            && resolucion.nota.midi < retardo.nota.midi && Contrapunto.esGrado(retardo.nota, resolucion.nota)
            && !Contrapunto.esDisonancia(resolucion.intervalo)
    }

    /// Una disonancia en parte débil se llega y se deja por grado: en el mismo sentido (nota de paso)
    /// o, desde la tercera especie, también volviendo (bordadura). En la cuarta especie no se admite.
    private func disonanciaDebilBienTratada(_ s: Sonoridad, _ ataques: [Sonoridad]) -> Bool {
        guard especie != .cuarta, especie != .primera,
            let i = ataques.firstIndex(of: s), i > 0, i + 1 < ataques.count
        else { return false }
        let antes = ataques[i - 1].nota
        let despues = ataques[i + 1].nota
        guard Contrapunto.esGrado(antes, s.nota), Contrapunto.esGrado(s.nota, despues) else { return false }
        let mismoSentido = (s.nota.midi - antes.midi > 0) == (despues.midi - s.nota.midi > 0)
        return mismoSentido || especie != .segunda
    }

    // MARK: Auxiliares

    /// 5 si el intervalo es una quinta justa (simple o compuesta), 8 si es una octava justa o un
    /// unísono; `nil` en otro caso.
    package static func perfecta(_ intervalo: Intervalo) -> Int? {
        guard intervalo.calidad == .justa else { return nil }
        switch intervalo.numeroSimple {
        case 5: return 5
        case 1, 8: return 8
        default: return nil
        }
    }

    /// Las consonancias son el unísono, la quinta y la octava justas y las terceras y sextas mayores
    /// y menores (simples o compuestas); a dos voces, la cuarta justa es disonancia.
    package static func esDisonancia(_ intervalo: Intervalo) -> Bool {
        if perfecta(intervalo) != nil { return false }
        let imperfecta =
            [3, 6].contains(intervalo.numeroSimple) && (intervalo.calidad == .mayor || intervalo.calidad == .menor)
        return !imperfecta
    }

    /// `true` si de `a` a `b` hay una segunda mayor o menor.
    package static func esGrado(_ a: Altura, _ b: Altura) -> Bool {
        let intervalo = a.intervalo(hasta: b)
        return intervalo.numero == 2 && (intervalo.calidad == .mayor || intervalo.calidad == .menor)
    }

    package static func esSaltoNoMelodico(_ salto: Intervalo, ascendente: Bool) -> Bool {
        switch salto.calidad {
        case .aumentada, .disminuida: return true
        default: break
        }
        if salto.numero > 8 || salto.numero == 7 { return true }
        if salto.numero == 6 { return salto.calidad == .mayor || !ascendente }
        return false
    }
}

// MARK: - Idiomas
//
// Los textos del contrapunto de especies en los catorce idiomas de los textos (`Traduccion`).

extension FaltaDeContrapunto {
    /// "Quintas paralelas (compases 3 → 4)", "Parallel fifths (bars 3 → 4)". Los compases se cuentan desde 1.
    public func descripcion(en notacion: Notacion) -> String {
        let lugar: Traduccion
        if compases.count == 1 {
            let n = compases.lowerBound + 1
            lugar = TextosDePartitura.traducidos.map { $0.enElCompas(n) }
        } else {
            let pasos = "\(compases.lowerBound + 1) → \(compases.upperBound + 1)"
            lugar = TextosDePartitura.traducidos.map { $0.enLosCompases(pasos) }
        }
        return tipo.nombre(en: notacion) + " " + lugar.en(notacion)
    }
}

extension FaltaDeContrapunto.Tipo: Nombrable, CustomStringConvertible {
    public var nombre: String { nombre(en: .espanolUnicode) }

    public func nombre(en notacion: Notacion) -> String {
        let traduccion: Traduccion
        switch self {
        case .quintasParalelas: return FaltaDeConduccion.Tipo.quintasParalelas.nombre(en: notacion)
        case .octavasParalelas: return FaltaDeConduccion.Tipo.octavasParalelas.nombre(en: notacion)
        case .quintasDirectas: return FaltaDeConduccion.Tipo.quintasDirectas.nombre(en: notacion)
        case .octavasDirectas: return FaltaDeConduccion.Tipo.octavasDirectas.nombre(en: notacion)
        case .cruceDeVoces: return FaltaDeConduccion.Tipo.cruceDeVoces.nombre(en: notacion)
        case .saltoNoMelodico: return FaltaDeConduccion.Tipo.saltoNoMelodico.nombre(en: notacion)
        case .ritmoDeLaEspecie:
            traduccion = TextosDePartitura.traducidos.map(\.ritmoDeLaEspecie)
        case .comienzoImperfecto:
            traduccion = TextosDePartitura.traducidos.map(\.comienzoImperfecto)
        case .finalImperfecto:
            traduccion = TextosDePartitura.traducidos.map(\.finalImperfecto)
        case .finalSinGradoConjunto:
            traduccion = TextosDePartitura.traducidos.map(\.finalSinGradoConjunto)
        case .disonanciaEnParteFuerte:
            traduccion = TextosDePartitura.traducidos.map(\.disonanciaEnParteFuerte)
        case .disonanciaMalTratada:
            traduccion = TextosDePartitura.traducidos.map(\.disonanciaMalTratada)
        case .retardoMalResuelto:
            traduccion = TextosDePartitura.traducidos.map(\.retardoMalResuelto)
        case .unisono:
            traduccion = TextosDePartitura.traducidos.map(\.unisono)
        case .saltoSinCompensar:
            traduccion = TextosDePartitura.traducidos.map(\.saltoSinCompensar)
        case .notaRepetida:
            traduccion = TextosDePartitura.traducidos.map(\.notaRepetida)
        }
        return traduccion.en(notacion)
    }

    public var description: String { nombre }
}

extension Contrapunto {
    /// La especie y dónde va el contrapunto, y una falta por línea (o «Sin faltas.»):
    ///
    ///     Especie 1, con el contrapunto encima del cantus firmus
    ///     Quintas paralelas (compases 1 → 2)
    public func informe(en notacion: Notacion = .espanolUnicode) -> String {
        let n = especie.rawValue
        let cabecera =
            contrapuntoArriba
            ? TextosDePartitura.traducidos.map { $0.especieConElContrapuntoEncima(n) }
            : TextosDePartitura.traducidos.map { $0.especieConElContrapuntoDebajo(n) }
        let faltas = self.faltas
        let lineas =
            faltas.isEmpty
            ? [TextosDePartitura.traducidos.map(\.sinFaltas).en(notacion)] : faltas.map { $0.descripcion(en: notacion) }
        return ([cabecera.en(notacion)] + lineas).joined(separator: "\n")
    }
}
