import ArmoniaElementos

// Las notas extrañas a la armonía: las de una melodía que no son del acorde que suena con ellas, y por qué están
// ahí (de paso, bordadura, apoyatura, retardo, anticipación, escapada, pedal). Se clasifican por cómo se llega a
// ellas y cómo se sale: por grado conjunto, por salto o repitiendo la nota.

// MARK: - NotaExtrana

/// Por qué está en una melodía una nota que no es del acorde, según cómo se llega a ella y cómo se sale.
///
/// Un grado conjunto es una segunda (mayor, menor o aumentada) o un semitono cromático (Do–Do♯); un salto, todo
/// intervalo mayor.
public enum NotaExtrana: Hashable, Sendable, CaseIterable, CustomStringConvertible {
    /// Se llega y se sale por grado conjunto en el mismo sentido: do–**re**–mi sobre Do.
    case notaDePaso
    /// Se llega y se sale por grado conjunto, volviendo hacia la nota de la que se partió: do–**re**–do sobre Do.
    case bordadura
    /// Se llega por salto y se sale por grado conjunto: do–**fa**–mi sobre Do. Suele caer en parte fuerte.
    case apoyatura
    /// La nota de antes, que era del acorde anterior, se mantiene cuando cambia el acorde y luego baja (o sube) por
    /// grado conjunto: do (sobre Fa) – **do** – si (sobre Sol), el retardo 4-3.
    case retardo
    /// Llega antes de tiempo la nota del acorde siguiente: re–**do** sobre Sol y luego do sobre Do.
    case anticipacion
    /// Se llega por grado conjunto y se sale por salto: re–**mi**–si sobre Sol (la *échappée*).
    case escapada
    /// Una nota que se repite mientras los acordes cambian por debajo (o por encima): sol–**sol**–sol sobre Do, Fa/Do
    /// y Do.
    case pedal
    /// Ninguna de las anteriores: se llega y se sale por salto, o la melodía empieza o acaba en ella sin resolverla.
    case libre

    public var description: String { nombre }
}

extension NotaExtrana: Nombrable {
    /// «nota de paso», «bordadura», «apoyatura», «retardo»…; «passing tone», «neighbor tone», «appoggiatura»,
    /// «suspension»…
    public func nombre(en notacion: Notacion) -> String {
        let nombres = TextosDeTeoria.en(notacion, \.nombresDeNotasExtranas)
        return nombres[NotaExtrana.allCases.firstIndex(of: self)!]
    }
}

// MARK: - NotaDeLaMelodia

/// Una nota de una melodía con el acorde que suena con ella: si es del acorde y, si no, qué nota extraña es.
///
///     let notas = NotaDeLaMelodia.analizar(["Do5", "Re5", "Mi5"], sobre: ["Do", "Do", "Do"])!
///     notas.map(\.extrana)     // [nil, .notaDePaso, nil]
public struct NotaDeLaMelodia: Hashable, Sendable, CustomStringConvertible {
    public let altura: Altura
    public let acorde: Acorde
    /// `nil` si la nota es del acorde (también si lo es solo escrita de otra forma: La♭ en Mi7 vale por Sol♯).
    public let extrana: NotaExtrana?
    /// Si la nota cae en parte fuerte, cuando se sabe (ver ``analizar(_:sobre:partesFuertes:)``).
    public let acentuada: Bool?
    /// En un retardo, sus cifras sobre el bajo, de la nota retardada a su resolución: «4-3», «7-6», «9-8». `nil` en
    /// las demás notas.
    public let cifrasDelRetardo: String?

    /// Si la nota es del acorde con que suena.
    public var esDelAcorde: Bool { extrana == nil }

    /// "Re5 (nota de paso)", "Do5 (retardo 4-3)", "Mi5".
    public var description: String { texto(altura.nombreCompleto, en: .espanolCompacto) }

    /// "Re₅ (nota de paso)" en `.espanolCompacto`, "D5 (passing tone)" en `.inglesASCII`.
    public func texto(en notacion: Notacion) -> String { texto(altura.nombre(en: notacion), en: notacion) }

    private func texto(_ nota: String, en notacion: Notacion) -> String {
        guard let extrana else { return nota }
        let cifras = cifrasDelRetardo.map { " \($0)" } ?? ""
        return "\(nota) (\(extrana.nombre(en: notacion))\(cifras))"
    }
}

extension NotaDeLaMelodia {
    /// Clasifica cada nota de una melodía según el acorde que suena con ella: `acordes[i]` es el de
    /// `melodia[i]` (si un acorde dura varias notas, se repite). Las notas que no son del acorde se clasifican por
    /// cómo se llega a ellas y cómo se sale (ver ``NotaExtrana``). `partesFuertes[i]`, si se da, dice si la nota
    /// `i` cae en parte fuerte, y queda en ``acentuada``: la clasificación no depende de ello, así que una nota de
    /// paso en parte fuerte sigue siendo nota de paso (acentuada).
    ///
    /// `nil` si `acordes` (o `partesFuertes`) no tiene tantos elementos como la melodía.
    ///
    ///     // El do que suena sobre Fa se mantiene cuando llega Sol y baja al si: un retardo 4-3.
    ///     let notas = NotaDeLaMelodia.analizar(["Mi5", "Re5", "Do5", "Do5", "Si4", "Do5"],
    ///                                          sobre: ["Do", "Do", "Fa", "Sol", "Sol", "Do"])!
    ///     notas.map(\.extrana)            // [nil, .notaDePaso, nil, .retardo, nil, nil]
    ///     notas[3].cifrasDelRetardo       // "4-3"
    public static func analizar(
        _ melodia: [Altura], sobre acordes: [Acorde], partesFuertes: [Bool]? = nil
    ) -> [NotaDeLaMelodia]? {
        guard acordes.count == melodia.count, partesFuertes.map({ $0.count == melodia.count }) ?? true else {
            return nil
        }
        let delAcorde = melodia.indices.map { esDelAcorde(melodia[$0], acordes[$0]) }
        return melodia.indices.map { i in
            var extrana: NotaExtrana?
            var cifras: String?
            if !delAcorde[i] {
                extrana = clasificar(i, melodia: melodia, delAcorde: delAcorde)
                if extrana == .retardo {
                    cifras = cifrasDeRetardo(melodia[i], acordes[i], resolucion: melodia[i + 1], acordes[i + 1])
                }
            }
            return NotaDeLaMelodia(
                altura: melodia[i], acorde: acordes[i], extrana: extrana, acentuada: partesFuertes?[i],
                cifrasDelRetardo: cifras)
        }
    }

    // MARK: Clasificación

    static func esDelAcorde(_ altura: Altura, _ acorde: Acorde) -> Bool {
        (acorde.notas + [acorde.bajo]).contains { $0.esEnarmonica(de: altura.nota) }
    }

    /// Si de `a` a `b` hay un grado conjunto: una segunda de hasta tres semitonos (la aumentada de la menor
    /// armónica) o un semitono cromático (Do–Do♯).
    static func esGradoConjunto(_ a: Altura, _ b: Altura) -> Bool {
        let pasos = abs(b.pasos - a.pasos)
        let semitonos = abs(b.midi - a.midi)
        return (pasos == 1 && (1...3).contains(semitonos)) || (pasos == 0 && semitonos == 1)
    }

    private static func clasificar(_ i: Int, melodia: [Altura], delAcorde: [Bool]) -> NotaExtrana {
        let nota = melodia[i]
        let anterior = i > 0 ? melodia[i - 1] : nil
        let siguiente = i + 1 < melodia.count ? melodia[i + 1] : nil
        let repiteLaAnterior = anterior.map { $0.esEnarmonica(de: nota) } ?? false
        let repiteLaSiguiente = siguiente.map { $0.esEnarmonica(de: nota) } ?? false
        let llegaPorGrado = anterior.map { esGradoConjunto($0, nota) } ?? false
        let salePorGrado = siguiente.map { esGradoConjunto(nota, $0) } ?? false

        if repiteLaAnterior {
            // Una nota que se mantiene: pedal si sigue también después o si ya era extraña; retardo si venía del
            // acorde anterior y resuelve por grado conjunto.
            if repiteLaSiguiente || !delAcorde[i - 1] { return .pedal }
            return salePorGrado ? .retardo : .libre
        }
        if repiteLaSiguiente, delAcorde[i + 1] { return .anticipacion }
        if let anterior, let siguiente, llegaPorGrado, salePorGrado {
            let entrada = nota.midi - anterior.midi
            let salida = siguiente.midi - nota.midi
            return (entrada > 0) == (salida > 0) ? .notaDePaso : .bordadura
        }
        if salePorGrado, anterior == nil || !llegaPorGrado { return .apoyatura }
        if llegaPorGrado, siguiente != nil { return .escapada }
        return .libre
    }

    /// «4-3», «7-6», «9-8»: el número del intervalo simple sobre el bajo de la nota retardada y de su resolución.
    /// Una segunda se lee como novena, y su resolución en el unísono como octava.
    private static func cifrasDeRetardo(
        _ nota: Altura, _ acorde: Acorde, resolucion: Altura, _ acordeDeLaResolucion: Acorde
    ) -> String {
        var retardada = acorde.bajo.intervalo(hasta: nota.nota).numeroSimple
        var resuelta = acordeDeLaResolucion.bajo.intervalo(hasta: resolucion.nota).numeroSimple
        if retardada == 2 { retardada = 9 }
        if retardada == 9, resuelta == 1 { resuelta = 8 }
        return "\(retardada)-\(resuelta)"
    }
}

/// Una nota extraña de una melodía y su posición en ella: lo que da `notasExtranas`.
public struct NotaExtranaEnLaMelodia: Hashable, Sendable {
    /// Su posición en la melodía, desde 0.
    public let indice: Int
    public let nota: NotaDeLaMelodia

    /// La nota extraña en esa posición de la melodía, desde 0.
    public init(indice: Int, nota: NotaDeLaMelodia) {
        self.indice = indice
        self.nota = nota
    }
}

extension Array where Element == NotaDeLaMelodia {
    /// Solo las notas extrañas, con su posición en la melodía.
    public var notasExtranas: [NotaExtranaEnLaMelodia] {
        enumerated().filter { !$0.element.esDelAcorde }.map {
            NotaExtranaEnLaMelodia(indice: $0.offset, nota: $0.element)
        }
    }
}
