import ArmoniaNucleo

// MARK: - Solfeo relativo

/// El solfeo relativo («do móvil»), como en el método Kodály: las sílabas no nombran la altura sino el grado
/// en la tonalidad. En Re mayor, Re es «do» y Fa♯ es «mi»; en La menor, La es «la» (o «do», con
/// ``Menor/enDo``).
///
///     let solfeo = SolfeoRelativo(Tonalidad("Re mayor"))
///     solfeo.silaba(de: "Fa#")                    // "mi"
///     solfeo.silaba(de: "Sol#")                   // "fi"
///     solfeo.silabas(de: Escala("Re mayor").notas, en: .hungaro)   // ["dó", "ré", "mi", "fá", "szó", "lá", "ti"]
///
/// Las sílabas son las del método: «do re mi fa so la ti» en casi todos los idiomas, y «dó ré mi fá szó lá ti» en
/// húngaro. Las notas alteradas cambian la vocal: subidas, «di ri fi si li» («szi» en húngaro); bajadas,
/// «ra me se le te» («ra ma lo ta» en húngaro). Las que no tienen sílaba propia (Mi♯, Do♭ del do, dobles
/// alteraciones…) llevan la sílaba natural con sus signos: «mi♯», «do♭», «re♯♯».
public struct SolfeoRelativo: Hashable, Sendable {
    /// Qué sílaba es la tónica de una tonalidad menor.
    public enum Menor: Hashable, Sendable, CaseIterable {
        /// La tónica menor es «la», como en el método Kodály: La menor y Do mayor cantan las mismas sílabas.
        case enLa
        /// La tónica es siempre «do», también en menor: la tercera de La menor es «me».
        case enDo
    }

    /// La tonalidad que da el «do».
    public let tonalidad: Tonalidad
    /// Qué sílaba es la tónica si la tonalidad es menor.
    public let menor: Menor

    /// El solfeo de una tonalidad, con la tónica menor en «la» (Kodály) o en «do».
    public init(_ tonalidad: Tonalidad, menor: Menor = .enLa) {
        self.tonalidad = tonalidad
        self.menor = menor
    }

    /// La nota que se canta «do»: la tónica o, en menor con ``Menor/enLa``, la tónica de la relativa mayor.
    public var notaDo: Nota {
        tonalidad.modo == .menor && menor == .enLa ? tonalidad.tonica + .terceraMenor : tonalidad.tonica
    }

    /// La sílaba de una nota: «mi», «fi», «te». En húngaro, con sus sílabas («szó», «szi», «ta»); en los
    /// demás idiomas, con las del método.
    public func silaba(de nota: Nota, en idioma: Idioma = .espanol) -> String {
        let silabas = idioma == .hungaro ? SolfeoRelativo.hungaras : SolfeoRelativo.internacionales
        // La posición en la línea de quintas desde el do: fa = -1, do = 0, so = 1… ti = 5.
        let distancia = nota.pasosDeQuinta - notaDo.pasosDeQuinta
        let alteracion = Alteracion(divisionEntera(distancia + 1, 7))
        let grado = NotaNatural(pasosDeQuinta: distancia).rawValue
        switch alteracion.semitonos {
        case 0: return silabas.naturales[grado]
        case 1: if let subida = silabas.subidas[grado] { return subida }
        case -1: if let bajada = silabas.bajadas[grado] { return bajada }
        default: break
        }
        return silabas.naturales[grado] + alteracion.simbolo
    }

    /// Las sílabas de varias notas: las de una escala, una melodía o un acorde.
    public func silabas(de notas: [Nota], en idioma: Idioma = .espanol) -> [String] {
        notas.map { silaba(de: $0, en: idioma) }
    }

    /// Las sílabas de un idioma: las siete naturales, de do a ti, y las de las notas subidas y bajadas un semitono
    /// (`nil` si no tienen sílaba propia).
    private struct Silabas: Sendable {
        let naturales: [String]
        let subidas: [String?]
        let bajadas: [String?]
    }

    /// Las del método Kodály fuera de Hungría (y del tonic sol-fa): do re mi fa so la ti.
    private static let internacionales = Silabas(
        naturales: ["do", "re", "mi", "fa", "so", "la", "ti"],
        subidas: ["di", "ri", nil, "fi", "si", "li", nil],
        bajadas: [nil, "ra", "me", nil, "se", "le", "te"])

    /// Las húngaras: dó ré mi fá szó lá ti; subidas, di ri fi szi li; bajadas, ra ma lo ta.
    private static let hungaras = Silabas(
        naturales: ["dó", "ré", "mi", "fá", "szó", "lá", "ti"],
        subidas: ["di", "ri", nil, "fi", "szi", "li", nil],
        bajadas: [nil, "ra", "ma", nil, nil, "lo", "ta"])
}

extension Escala {
    /// Las sílabas del solfeo relativo de las notas de la escala, con su tónica como «do» (o como «la», si
    /// la escala es menor natural y `menor` es ``SolfeoRelativo/Menor/enLa``): Re dórico canta «do re me fa so
    /// la te».
    public func solfeoRelativo(menor: SolfeoRelativo.Menor = .enLa, en idioma: Idioma = .espanol) -> [String] {
        let modo: Tonalidad.Modo = tipo == .menorNatural ? .menor : .mayor
        return SolfeoRelativo(Tonalidad(tonica, modo), menor: menor).silabas(de: notas, en: idioma)
    }
}
