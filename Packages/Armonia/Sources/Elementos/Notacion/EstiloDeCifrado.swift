// MARK: - Estilo de cifrado

/// Cómo se escribe un cifrado. Todos los estilos se vuelven a leer igual con
/// `Acorde(leyendo:)`, así que el estilo solo cambia la presentación.
///
///     let a: Acorde = "Sib7(b9)"
///     a.cifrado                                 // "Si♭7(♭9)"
///     a.cifrado(estilo: .ascii(.ingles))           // "Bb7(b9)"
///     Acorde("Sim7b5").cifrado(estilo: .jazz)   // "Bø7"
public struct EstiloDeCifrado: Hashable, Sendable {
    /// Cómo se escribe el acorde menor: Dom o Domin.
    public enum Menor: String, Hashable, Sendable {
        case m = "m"
        case min = "min"
    }
    /// Cómo se escribe el acorde disminuido: Do° o Dodim.
    public enum Disminuido: String, Hashable, Sendable {
        case circulo = "°"
        case dim = "dim"
    }
    /// Cómo se escribe el acorde aumentado: Do+ o Doaug.
    public enum Aumentado: String, Hashable, Sendable {
        case mas = "+"
        case aug = "aug"
    }
    /// Cómo se escribe la séptima mayor: Domaj7, DoM7 o DoΔ7.
    public enum SeptimaMayor: String, Hashable, Sendable {
        case maj = "maj"
        case mayuscula = "M"
        case delta = "Δ"
    }
    /// Cómo se escribe el semidisminuido: Dom7(♭5) o Doø7.
    public enum Semidisminuido: Hashable, Sendable {
        /// m7(♭5)
        case menorSeptimaQuintaBemol
        /// ø7
        case barrado
    }

    public var notacion: Notacion
    /// Escribe ♭ y ♯ como b y # en las tensiones.
    public var tensionesEnASCII: Bool
    public var menor: Menor
    public var disminuido: Disminuido
    public var aumentado: Aumentado
    public var septimaMayor: SeptimaMayor
    public var semidisminuido: Semidisminuido

    /// Sin `tensionesEnASCII`, las tensiones llevan b y # si las notas las llevan (`Notacion.usaASCII`): el
    /// estilo básico de cada notación es `EstiloDeCifrado(notacion:)`, y `.ascii(.ingles)` escribe Bb7(b9).
    public init(
        notacion: Notacion = .compacta(.espanol),
        tensionesEnASCII: Bool? = nil,
        menor: Menor = .m,
        disminuido: Disminuido = .circulo,
        aumentado: Aumentado = .mas,
        septimaMayor: SeptimaMayor = .maj,
        semidisminuido: Semidisminuido = .menorSeptimaQuintaBemol
    ) {
        self.notacion = notacion
        self.tensionesEnASCII = tensionesEnASCII ?? notacion.usaASCII
        self.menor = menor
        self.disminuido = disminuido
        self.aumentado = aumentado
        self.septimaMayor = septimaMayor
        self.semidisminuido = semidisminuido
    }

    /// Do♯m7(♭5), Mi♭maj7: el de `.compacta(.espanol)`.
    public static let predeterminado = EstiloDeCifrado()
    /// El estilo básico de la notación compacta de un idioma: `.compacta(.espanol)` escribe Do♯m7(♭5) y Mi♭maj7 (es el
    /// `predeterminado`), y `.compacta(.ingles)`, C♯m7(♭5) y E♭maj7.
    public static func compacta(_ idioma: Idioma) -> EstiloDeCifrado { EstiloDeCifrado(notacion: .compacta(idioma)) }
    /// El estilo básico de la notación ASCII de un idioma: `.ascii(.espanol)` escribe Do#m7(b5) y Mibmaj7, y
    /// `.ascii(.ingles)`, C#m7(b5) y Ebmaj7.
    public static func ascii(_ idioma: Idioma) -> EstiloDeCifrado { EstiloDeCifrado(notacion: .ascii(idioma)) }
    /// Notación habitual en jazz: C#ø7, EbΔ7.
    public static let jazz = EstiloDeCifrado(notacion: .ascii(.ingles), septimaMayor: .delta, semidisminuido: .barrado)
    /// Calidades escritas con palabras: Domin7, Fadim, Solaug. No confundir con las notaciones con palabras
    /// (`Notacion.conPalabras(.espanol)`), que escriben así las alteraciones de las notas.
    public static let calidadesConPalabras = EstiloDeCifrado(menor: .min, disminuido: .dim, aumentado: .aug)

    package func nombre(_ nota: Nota) -> String { nota.nombreCompacto(en: notacion) }
}
