import Armonia

/// Una escala sobre un acorde, como la enseñan las apps y la línea de comandos: su nombre, de qué escala es modo,
/// cada nota con su grado sobre el acorde, las tensiones disponibles y las notas a evitar.
public struct EscalaSobreAcordePresentada: Hashable, Sendable {
    public let escala: Escala
    /// «Re dórico».
    public let nombre: String
    /// Por qué se propone para el acorde («del cifrado», «de la tonalidad», «del bajo»), o `nil` si no se sabe
    /// o solo es compatible.
    public let motivo: String?
    /// «modo 2 de Do mayor»; `nil` si no es modo de otra escala o si es la propia madre (Do mayor).
    public let modo: String?
    /// Cada nota con su grado sobre el acorde: «Re 1 · Mi 9 · Fa ♭3 · Sol 11 · La 5 · Si 13 · Do ♭7».
    public let notas: String
    /// «Mi 9 · Sol 11 · Si 13», o "" si no tiene.
    public let tensiones: String
    /// «Si♭ ♭13», o "" si no tiene: las notas a evitar y las que chocan con el acorde.
    public let aEvitar: String
    /// Lo que cabe en una línea: «Tensiones: Mi 9 · Sol 11 · Si 13 — A evitar: Si♭ ♭13».
    public let resumen: String
    /// Lo mismo, para escribirlo detrás del nombre de la escala, con las etiquetas como en la consola (`etiqueta(_:)`):
    /// «Re dórico — tensiones: Mi 9 · Sol 11 · Si 13».
    public let resumenEnLinea: String
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
///     let dorico = EscalaSobreAcordePresentada(
///         Escala(.re, .dorico), sobre: Acorde("Rem7"), en: .compacta(.espanol))
///     dorico.tensiones   // "Mi 9 · Sol 11 · Si 13"
///     dorico.modo        // "modo 2 de Do mayor"
public enum PresentacionDeEscalaYAcorde {


    /// Las escalas para el acorde, en la tonalidad si se da, presentadas con su motivo: las de la hoja del acorde,
    /// de la vista de acordes y de `armonia acorde --escalas`.
    public static func escalas(
        de acorde: Acorde, en tonalidad: Tonalidad? = nil, notacion: Notacion
    ) -> [EscalaSobreAcordePresentada] {
        acorde.escalas(en: tonalidad).map { EscalaSobreAcordePresentada($0, sobre: acorde, en: notacion) }
    }

    /// El nombre con su motivo: «Do mixolidio (del cifrado)».
    public static func nombreConMotivo(_ presentada: EscalaSobreAcordePresentada) -> String {
        presentada.nombre + (presentada.motivo.map { " (" + $0 + ")" } ?? "")
    }

    /// Los acordes que caben en la escala, grado a grado (`Escala.acordesQueCaben(grado:)`), sin los grados en los
    /// que no cabe ninguno.
    public static func acordesQueCaben(_ escala: Escala, en notacion: Notacion) -> [AcordesDelGrado] {
        escala.acordesQueCaben.enumerated().compactMap { i, acordes in
            guard !acordes.isEmpty else { return nil }
            return AcordesDelGrado(
                grado: "\(i + 1) · " + escala.grado(i + 1).nombre(en: notacion), acordes: acordes,
                cifrados: acordes.map { $0.cifrado(en: notacion) }.joined(separator: " · "))
        }
    }

    /// «modo 2 de Do mayor»; `nil` si la escala no es modo de otra o si es la propia madre.
    public static func modo(de escala: Escala, en notacion: Notacion) -> String? {
        guard let modo = escala.escalaMadre, modo.grado > 1 else { return nil }
        return modo.nombre(en: notacion)
    }

    /// La escala de un acorde analizado en una tonalidad, presentada sobre él; `nil` si no tiene ninguna.
    public static func escala(
        de analizado: AcordeAnalizado, en tonalidad: Tonalidad, notacion: Notacion
    ) -> EscalaSobreAcordePresentada? {
        tonalidad.escalaDelAcorde(analizado).map { EscalaSobreAcordePresentada($0, sobre: analizado.acorde, en: notacion) }
    }
}

extension EscalaSobreAcordePresentada {
    /// Una escala propuesta para el acorde (``Acorde/escalas(en:siguiente:entre:)``), con su motivo si no es solo
    /// compatible.
    public init(_ propuesta: EscalaParaElAcorde, sobre acorde: Acorde, en notacion: Notacion) {
        let motivo = propuesta.motivo == .compatible ? nil : propuesta.motivo.nombre(en: notacion)
        // Las del bajo se leen sobre el acorde que forma el bajo.
        let sobre = propuesta.motivo == .delBajo ? acorde.acordeSobreElBajo ?? acorde : acorde
        self.init(propuesta.escala, sobre: sobre, en: notacion, motivo: motivo)
    }
}

extension EscalaSobreAcordePresentada {
    /// La escala sobre el acorde, escrita en la notación: sus notas, las del acorde y las que evitar.
    public init(_ escala: Escala, sobre acorde: Acorde, en notacion: Notacion, motivo: String? = nil) {
        let notas = escala.notas(sobre: acorde)
        func lista(_ papeles: Set<PapelEnLaEscala>?) -> String {
            notas.filter { papeles?.contains($0.papel) ?? true }
                .map { "\($0.nota.nombre(en: notacion)) \($0.cifra)" }
                .joined(separator: " · ")
        }
        let tensiones = lista([.tension])
        let aEvitar = lista([.aEvitar, .choque])
        var partes: [(etiqueta: String, valor: String)] = []
        if !tensiones.isEmpty { partes.append((notacion.texto(\.tensiones), tensiones)) }
        if !aEvitar.isEmpty { partes.append((notacion.texto(\.notasAEvitar), aEvitar)) }
        self.init(
            escala: escala,
            nombre: escala.nombre(en: notacion),
            motivo: motivo,
            modo: PresentacionDeEscalaYAcorde.modo(de: escala, en: notacion),
            notas: lista(nil),
            tensiones: tensiones,
            aEvitar: aEvitar,
            resumen: partes.map { $0.etiqueta + ": " + $0.valor }.joined(separator: " — "),
            resumenEnLinea: partes.map { notacion.etiqueta($0.etiqueta) + ": " + $0.valor }.joined(separator: " — "),
            estructurasSuperiores: escala.estructurasSuperiores(sobre: acorde).map { $0.cifrado(en: notacion) }
                .joined(separator: " · "))
    }
}
