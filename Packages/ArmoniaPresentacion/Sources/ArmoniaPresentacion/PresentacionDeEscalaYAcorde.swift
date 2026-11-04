import Armonia

/// Una escala sobre un acorde, como la enseñan las apps y la línea de comandos: su nombre, de qué escala es modo,
/// cada nota con su grado sobre el acorde, las tensiones disponibles y las notas a evitar.
public struct EscalaSobreAcordePresentada: Hashable, Sendable {
    public let escala: Escala
    /// «Re dórico».
    public let nombre: String
    /// «modo 2 de Do mayor»; `nil` si no es modo de otra escala o si es la propia madre (Do mayor).
    public let modo: String?
    /// Cada nota con su grado sobre el acorde: «Re 1 · Mi 9 · Fa ♭3 · Sol 11 · La 5 · Si 13 · Do ♭7».
    public let notas: String
    /// «Mi 9 · Sol 11 · Si 13», o "" si no tiene.
    public let tensiones: String
    /// «Si♭ ♭13», o "" si no tiene.
    public let aEvitar: String
    /// Lo que cabe en una línea: «Tensiones: Mi 9 · Sol 11 · Si 13 — A evitar: Si♭ ♭13».
    public let resumen: String
    /// Las tríadas de tensiones que se tocan sobre el acorde con esta escala: «Re · Sim · Sol · Lam» en Do lidio
    /// sobre Do7M; "" si no tiene.
    public let estructurasSuperiores: String
}

/// Los acordes que caben sobre un grado de una escala, para la vista de escalas y `armonia escala --acordes`.
public struct AcordesDelGrado: Hashable, Sendable {
    /// «1 · Do».
    public let grado: String
    public let acordes: [Acorde]
    /// Sus cifrados: «Do · Dosus2 · Dosus4 · Do6…».
    public let cifrados: String
}

/// La relación escala-acorde en la vista de acordes, en la de escalas y en el análisis, y en `armonia analizar
/// --escalas`. No usa SwiftUI, así que se prueba en Linux.
///
///     let dorico = PresentacionDeEscalaYAcorde.presentar(
///         Escala(.re, .dorico), sobre: Acorde("Rem7"), notacion: .espanolCompacto)
///     dorico.tensiones   // "Mi 9 · Sol 11 · Si 13"
///     dorico.modo        // "modo 2 de Do mayor"
public enum PresentacionDeEscalaYAcorde {
    /// La escala sobre el acorde, escrita en la notación: sus notas, las del acorde y las que evitar.
    public static func presentar(
        _ escala: Escala, sobre acorde: Acorde, notacion: Notacion
    ) -> EscalaSobreAcordePresentada {
        let notas = escala.notas(sobre: acorde)
        func lista(_ papel: PapelEnLaEscala?) -> String {
            notas.filter { papel == nil || $0.papel == papel }
                .map { "\($0.nota.nombre(en: notacion)) \($0.cifra)" }
                .joined(separator: " · ")
        }
        let tensiones = lista(.tension)
        let aEvitar = lista(.aEvitar)
        var partes: [String] = []
        if !tensiones.isEmpty { partes.append(notacion.texto(\.tensiones) + ": " + tensiones) }
        if !aEvitar.isEmpty { partes.append(notacion.texto(\.notasAEvitar) + ": " + aEvitar) }
        return EscalaSobreAcordePresentada(
            escala: escala,
            nombre: escala.nombre(en: notacion),
            modo: modo(de: escala, notacion: notacion),
            notas: lista(nil),
            tensiones: tensiones,
            aEvitar: aEvitar,
            resumen: partes.joined(separator: " — "),
            estructurasSuperiores: escala.estructurasSuperiores(sobre: acorde).map { $0.cifrado(en: notacion) }
                .joined(separator: " · "))
    }

    /// Los acordes que caben en la escala, grado a grado (`Escala.acordesQueCaben(grado:)`), sin los grados en los
    /// que no cabe ninguno.
    public static func acordesQueCaben(_ escala: Escala, notacion: Notacion) -> [AcordesDelGrado] {
        escala.acordesQueCaben.enumerated().compactMap { i, acordes in
            guard !acordes.isEmpty else { return nil }
            return AcordesDelGrado(
                grado: "\(i + 1) · " + escala.grado(i + 1).nombre(en: notacion), acordes: acordes,
                cifrados: acordes.map { $0.cifrado(en: notacion) }.joined(separator: " · "))
        }
    }

    /// «modo 2 de Do mayor»; `nil` si la escala no es modo de otra o si es la propia madre.
    public static func modo(de escala: Escala, notacion: Notacion) -> String? {
        guard let modo = escala.escalaMadre, modo.modo > 1 else { return nil }
        return modo.nombre(en: notacion)
    }

    /// La escala de un acorde analizado en una tonalidad, presentada sobre él; `nil` si no tiene ninguna.
    public static func escala(
        de analizado: AcordeAnalizado, en tonalidad: Tonalidad, notacion: Notacion
    ) -> EscalaSobreAcordePresentada? {
        tonalidad.escalaDelAcorde(analizado).map { presentar($0, sobre: analizado.acorde, notacion: notacion) }
    }
}
