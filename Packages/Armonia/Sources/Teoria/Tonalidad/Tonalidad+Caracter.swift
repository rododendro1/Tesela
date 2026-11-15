import Elementos

// MARK: - El carácter de las tonalidades
//
// Del siglo XVII al XIX el carácter era de las tonalidades, no de las escalas: Re mayor y Mi♭ mayor tienen las
// mismas notas por encima de su tónica, pero no el mismo carácter. Como en las escalas, cada carácter lleva su fuente,
// y lo que no tiene fuente no tiene carácter. Va por el nombre: Re♭ mayor tiene el suyo y Do♯ mayor, que no describe
// nadie, ninguno.
//
// Por ahora, dos: el de Charpentier (la «énergie des modes» de las Règles de composition, hacia 1690, en Cessac 1988)
// y el de Schubart (Ideen zu einer Ästhetik der Tonkunst, 1806, en la traducción de Steblin 1983). Juntos enseñan cómo
// cambia una tonalidad en un siglo: Fa mayor, «furieux et emporté» en Charpentier, es «complaisance & calm» en
// Schubart. Cada uno va resumido en las palabras de `Afecto` que mejor lo dicen, y con sus palabras en `texto`.

extension Tonalidad {
    /// Las tonalidades que describen Charpentier y Schubart, con lo que dice cada uno.
    package static let caracteres: [(tonalidad: Tonalidad, caracter: [Caracter])] = deCharpentier + deSchubart

    /// Las veinticuatro de Schubart. Cada descripción es una frase larga; `texto` lleva un trozo, en la traducción de
    /// Steblin.
    private static let deSchubart: [(tonalidad: Tonalidad, caracter: [Caracter])] = [
        (
            Tonalidad(armadura: 0),
            schubart([.inocente], "Completely pure. Its character is: innocence, simplicity, naïvety, children's talk.")
        ),
        (
            Tonalidad(armadura: -5),
            schubart([.inquieto, .triste], "A leering key, degenerating into grief and rapture.")
        ),
        (
            Tonalidad(armadura: 2),
            schubart(
                [.festivo, .majestuoso], "The key of triumph, of Hallelujahs, of war-cries, of victory-rejoicing.")
        ),
        (
            Tonalidad(armadura: -3),
            schubart([.amoroso, .devoto], "The key of love, of devotion, of intimate conversation with God.")
        ),
        (
            Tonalidad(armadura: 4),
            schubart([.alegre, .festivo], "Noisy shouts of joy, laughing pleasure and not yet complete, full delight.")
        ),
        (Tonalidad(armadura: -1), schubart([.sereno], "Complaisance & calm.")),
        (
            Tonalidad(armadura: 6),
            schubart(
                [.valiente, .alegre],
                "Triumph over difficulty, free sigh of relief uttered when hurdles are surmounted.")
        ),
        (
            Tonalidad(armadura: 1),
            schubart(
                [.sereno, .tierno],
                "Everything rustic, idyllic and lyrical, every calm and satisfied passion […] every gentle and peaceful emotion of the heart."
            )
        ),
        (
            Tonalidad(armadura: -4),
            schubart(
                [.sombrio, .solemne],
                "Key of the grave. Death, grave, putrefaction, judgment, eternity lie in its radius.")
        ),
        (
            Tonalidad(armadura: 3),
            schubart(
                [.amoroso, .alegre, .devoto],
                "Declarations of innocent love, satisfaction with one's state of affairs […] youthful cheerfulness and trust in God."
            )
        ),
        (
            Tonalidad(armadura: -2),
            schubart([.alegre, .amoroso], "Cheerful love, clear conscience, hope aspiration for a better world.")
        ),
        (
            Tonalidad(armadura: 5),
            schubart(
                [.colerico, .desesperado],
                "Strongly coloured, announcing wild passions […] Anger, rage, jealousy, fury, despair.")
        ),

        (
            Tonalidad(armadura: -3, modo: .menor),
            schubart(
                [.amoroso, .lastimero, .nostalgico],
                "Declaration of love and at the same time the lament of unhappy love.")
        ),
        (
            Tonalidad(armadura: 4, modo: .menor),
            schubart([.lastimero, .devoto], "Penitential lamentation, intimate conversation with God.")
        ),
        (
            Tonalidad(armadura: -1, modo: .menor),
            schubart([.triste, .sombrio], "Melancholy womanliness, the spleen and humours brood.")
        ),
        (
            Tonalidad(armadura: 6, modo: .menor),
            schubart(
                [.desesperado, .sombrio, .inquieto],
                "Feelings of the anxiety of the soul's deepest distress, of brooding despair, of blackest depression.")
        ),
        (
            Tonalidad(armadura: 1, modo: .menor),
            schubart([.inocente, .amoroso], "Naïve, womanly innocent declaration of love, lament without grumbling.")
        ),
        (
            Tonalidad(armadura: -4, modo: .menor),
            schubart(
                [.sombrio, .lastimero], ocasion: .lamento,
                "Deep depression, funereal lament, groans of misery and longing for the grave.")
        ),
        (
            Tonalidad(armadura: 3, modo: .menor),
            schubart([.sombrio, .colerico], "A gloomy key […] Resentment and discontent are its language.")
        ),
        (
            Tonalidad(armadura: -2, modo: .menor),
            schubart(
                [.inquieto, .colerico],
                "Discontent, uneasiness, worry about a failed scheme; bad-tempered gnashing of teeth.")
        ),
        (
            Tonalidad(armadura: -7, modo: .menor),
            schubart(
                [.lastimero, .inquieto],
                "Grumbler, heart squeezed until it suffocates; wailing lament, difficult struggle.")
        ),
        (
            Tonalidad(armadura: 0, modo: .menor),
            schubart([.devoto, .tierno], "Pious womanliness and tenderness of character.")
        ),
        (
            Tonalidad(armadura: -5, modo: .menor),
            schubart(
                [.sombrio, .colerico],
                "A quaint creature, often dressed in the garment of night […] discontented with itself and with everything."
            )
        ),
        (
            Tonalidad(armadura: 2, modo: .menor),
            schubart(
                [.sereno, .devoto],
                "The key of patience, of calm awaiting one's fate and of submission to divine dispensation.")
        ),
    ]

    private static func schubart(_ afectos: [Afecto], ocasion: Ocasion? = nil, _ texto: String) -> [Caracter] {
        [.init(afectos, ocasion: ocasion, testigo: .schubart, texto: texto, referencia: .steblin1983)]
    }

    private static func charpentier(_ afectos: [Afecto], _ texto: String) -> [Caracter] {
        [.init(afectos, testigo: .charpentier, texto: texto, referencia: .cessac1988)]
    }

    /// Las dieciocho de la «énergie des modes» de Charpentier, en las palabras de las *Règles de composition*.
    private static let deCharpentier: [(tonalidad: Tonalidad, caracter: [Caracter])] = [
        (Tonalidad(armadura: 0), charpentier([.alegre, .valiente], "Gai et guerrier")),
        (Tonalidad(armadura: -3, modo: .menor), charpentier([.sombrio, .triste], "Obscur et triste")),
        (Tonalidad(armadura: 2), charpentier([.alegre, .valiente], "Joyeux et très guerrier")),
        (Tonalidad(armadura: -1, modo: .menor), charpentier([.grave, .devoto], "Grave et dévot")),
        (Tonalidad(armadura: -3), charpentier([.colerico, .severo], "Cruel et dur")),
        (Tonalidad(armadura: -6, modo: .menor), charpentier([.terrible], "Horrible et affreux")),
        (Tonalidad(armadura: 4), charpentier([.colerico, .inquieto], "Querelleur et criard")),
        (
            Tonalidad(armadura: 1, modo: .menor),
            charpentier([.blando, .amoroso, .lastimero], "Efféminé, amoureux et plaintif")
        ),
        (Tonalidad(armadura: -1), charpentier([.colerico], "Furieux et emporté")),
        (Tonalidad(armadura: -4, modo: .menor), charpentier([.sombrio, .lastimero], "Obscur et plaintif")),
        (Tonalidad(armadura: 1), charpentier([.alegre, .tierno], "Doucement joyeux")),
        (Tonalidad(armadura: -2, modo: .menor), charpentier([.grave, .majestuoso], "Sérieux et magnifique")),
        (Tonalidad(armadura: 3), charpentier([.alegre], "Joyeux et champêtre")),
        (Tonalidad(armadura: 0, modo: .menor), charpentier([.tierno, .lastimero], "Tendre et plaintif")),
        (Tonalidad(armadura: -2), charpentier([.majestuoso, .alegre], "Magnifique et joyeux")),
        (Tonalidad(armadura: -5, modo: .menor), charpentier([.sombrio, .terrible], "Obscur et terrible")),
        (Tonalidad(armadura: 5), charpentier([.severo, .lastimero], "Dur et plaintif")),
        (Tonalidad(armadura: 2, modo: .menor), charpentier([.triste], "Solitaire et mélancolique")),
    ]

    /// Tónica (por su nombre, no por su sonido) y modo → lo que dicen sus fuentes.
    private static let caracterPorTonalidad: [Tonalidad: [Caracter]] = {
        var tabla: [Tonalidad: [Caracter]] = [:]
        for (tonalidad, caracter) in caracteres { tabla[tonalidad, default: []] += caracter }
        return tabla.mapValues(Caracter.enOrdenCronologico)
    }()

    /// Las tonalidades que describe alguna fuente: las mayores y después las menores, de la de más bemoles a la de
    /// más sostenidos. `armonia tonalidades` las lista.
    ///
    ///     Tonalidad.conCaracter.count             // 25
    ///     Tonalidad.conCaracter.first?.armadura   // -5, Re♭ mayor
    public static let conCaracter: [Tonalidad] = caracterPorTonalidad.keys.sorted {
        ($0.modo == .mayor ? 0 : 1, $0.armadura) < ($1.modo == .mayor ? 0 : 1, $1.armadura)
    }

    /// Lo que dicen las fuentes del carácter de la tonalidad, en orden cronológico; vacío si ninguna dice nada. Es
    /// del nombre: Re♭ mayor tiene el de Schubart y Do♯ mayor, que nadie describe, ninguno.
    ///
    ///     Tonalidad(.do).caracter[0].texto             // "Gai et guerrier"
    ///     Tonalidad(.do).caracter[1].afectos           // [.inocente]
    ///     Tonalidad(.re).caracter.map(\.testigo)       // [.charpentier, .schubart]
    ///     Tonalidad(Nota(.do, .sostenido)).caracter    // []
    public var caracter: [Caracter] { Tonalidad.caracterPorTonalidad[self] ?? [] }
}
