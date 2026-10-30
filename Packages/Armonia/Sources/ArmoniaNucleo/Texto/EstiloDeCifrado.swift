// MARK: - Estilo de cifrado

/// Cómo se escribe un cifrado. Todos los estilos se vuelven a leer igual con
/// `Acorde(leyendo:)`, así que el estilo solo cambia la presentación.
///
///     let a: Acorde = "Sib7(b9)"
///     a.cifrado                                 // "Si♭7(♭9)"
///     a.cifrado(estilo: .inglesASCII)           // "Bb7(b9)"
///     Acorde("Sim7b5").cifrado(estilo: .jazz)   // "Bø7"
public struct EstiloDeCifrado: Hashable, Sendable {
    public enum Menor: String, Hashable, Sendable { case m = "m", min = "min" }
    public enum Disminuido: String, Hashable, Sendable { case circulo = "°", dim = "dim" }
    public enum Aumentado: String, Hashable, Sendable { case mas = "+", aug = "aug" }
    public enum SeptimaMayor: String, Hashable, Sendable { case maj = "maj", mayuscula = "M", delta = "Δ" }
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
    /// estilo básico de cada notación es `EstiloDeCifrado(notacion:)`, y `.inglesASCII` escribe Bb7(b9).
    public init(notacion: Notacion = .espanolUnicode,
                tensionesEnASCII: Bool? = nil,
                menor: Menor = .m,
                disminuido: Disminuido = .circulo,
                aumentado: Aumentado = .mas,
                septimaMayor: SeptimaMayor = .maj,
                semidisminuido: Semidisminuido = .menorSeptimaQuintaBemol) {
        self.notacion = notacion
        self.tensionesEnASCII = tensionesEnASCII ?? notacion.usaASCII
        self.menor = menor
        self.disminuido = disminuido
        self.aumentado = aumentado
        self.septimaMayor = septimaMayor
        self.semidisminuido = semidisminuido
    }

    /// Do♯m7(♭5), Mi♭maj7.
    public static let predeterminado = EstiloDeCifrado()
    /// Solo caracteres ASCII: Do#m7(b5), Mibmaj7.
    public static let espanolASCII = EstiloDeCifrado(notacion: .espanolASCII)
    /// Letras internacionales: C#m7(b5), Ebmaj7.
    public static let inglesASCII = EstiloDeCifrado(notacion: .inglesASCII)
    /// Letras internacionales con símbolos tipográficos: C♯m7(♭5), E♭maj7.
    public static let inglesUnicode = EstiloDeCifrado(notacion: .inglesUnicode)
    /// Notación habitual en jazz: C#ø7, EbΔ7.
    public static let jazz = EstiloDeCifrado(notacion: .inglesASCII, septimaMayor: .delta, semidisminuido: .barrado)
    /// Calidades escritas con palabras: Domin7, Fadim, Solaug. No confundir con las notaciones con palabras
    /// (`Notacion.espanol`), que escriben así las alteraciones de las notas.
    public static let calidadesConPalabras = EstiloDeCifrado(menor: .min, disminuido: .dim, aumentado: .aug)

    package func nombre(_ nota: Nota) -> String { nota.nombreCompacto(en: notacion) }
}
