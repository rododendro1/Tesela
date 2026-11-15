import Elementos

// MARK: - El carácter de las tonalidades
//
// En los siglos XVIII y XIX el carácter era de las tonalidades, no de las escalas: Re mayor y Mi♭ mayor tienen las
// mismas notas por encima de su tónica, pero no el mismo carácter. Como en las escalas, cada carácter lleva su fuente,
// y lo que no tiene fuente no tiene carácter. Va por el nombre: Re♭ mayor tiene el suyo y Do♯ mayor, que Schubart no
// describe, ninguno.
//
// Por ahora, el de Schubart (Ideen zu einer Ästhetik der Tonkunst, 1806), en la traducción de Steblin 1983. Cada
// descripción de Schubart es una frase larga; aquí va en las palabras del vocabulario de `Afecto` que mejor la
// resumen, y la frase entera se lee en Steblin.

extension Tonalidad {
    /// Las tonalidades que describe Schubart con lo que dice de cada una.
    package static let caracteres: [(tonalidad: Tonalidad, caracter: [Caracter])] = [
        // «Completely pure. Its character is: innocence, simplicity, naïvety, children's talk.»
        (Tonalidad(armadura: 0), schubart([.inocente])),
        // «A leering key, degenerating into grief and rapture.»
        (Tonalidad(armadura: -5), schubart([.inquieto, .triste])),
        // «The key of triumph, of Hallelujahs, of war-cries, of victory-rejoicing.»
        (Tonalidad(armadura: 2), schubart([.festivo, .majestuoso])),
        // «The key of love, of devotion, of intimate conversation with God.»
        (Tonalidad(armadura: -3), schubart([.amoroso, .devoto])),
        // «Noisy shouts of joy, laughing pleasure and not yet complete, full delight.»
        (Tonalidad(armadura: 4), schubart([.alegre, .festivo])),
        // «Complaisance & calm.»
        (Tonalidad(armadura: -1), schubart([.sereno])),
        // «Triumph over difficulty, free sigh of relief uttered when hurdles are surmounted.»
        (Tonalidad(armadura: 6), schubart([.valiente, .alegre])),
        // «Everything rustic, idyllic and lyrical, every calm and satisfied passion […] every gentle and peaceful
        // emotion of the heart.»
        (Tonalidad(armadura: 1), schubart([.sereno, .tierno])),
        // «Key of the grave. Death, grave, putrefaction, judgment, eternity lie in its radius.»
        (Tonalidad(armadura: -4), schubart([.sombrio, .solemne])),
        // «Declarations of innocent love, satisfaction with one's state of affairs […] youthful cheerfulness and trust
        // in God.»
        (Tonalidad(armadura: 3), schubart([.amoroso, .alegre, .devoto])),
        // «Cheerful love, clear conscience, hope aspiration for a better world.»
        (Tonalidad(armadura: -2), schubart([.alegre, .amoroso])),
        // «Strongly coloured, announcing wild passions […] Anger, rage, jealousy, fury, despair.»
        (Tonalidad(armadura: 5), schubart([.colerico, .desesperado])),

        // «Declaration of love and at the same time the lament of unhappy love.»
        (Tonalidad(armadura: -3, modo: .menor), schubart([.amoroso, .lastimero, .nostalgico])),
        // «Penitential lamentation, intimate conversation with God.»
        (Tonalidad(armadura: 4, modo: .menor), schubart([.lastimero, .devoto])),
        // «Melancholy womanliness, the spleen and humours brood.»
        (Tonalidad(armadura: -1, modo: .menor), schubart([.triste, .sombrio])),
        // «Feelings of the anxiety of the soul's deepest distress, of brooding despair, of blackest depression.»
        (Tonalidad(armadura: 6, modo: .menor), schubart([.desesperado, .sombrio, .inquieto])),
        // «Naïve, womanly innocent declaration of love, lament without grumbling.»
        (Tonalidad(armadura: 1, modo: .menor), schubart([.inocente, .amoroso])),
        // «Deep depression, funereal lament, groans of misery and longing for the grave.»
        (Tonalidad(armadura: -4, modo: .menor), schubart([.sombrio, .lastimero], ocasion: .lamento)),
        // «A gloomy key […] Resentment and discontent are its language.»
        (Tonalidad(armadura: 3, modo: .menor), schubart([.sombrio, .colerico])),
        // «Discontent, uneasiness, worry about a failed scheme; bad-tempered gnashing of teeth.»
        (Tonalidad(armadura: -2, modo: .menor), schubart([.inquieto, .colerico])),
        // «Grumbler, heart squeezed until it suffocates; wailing lament, difficult struggle.»
        (Tonalidad(armadura: -7, modo: .menor), schubart([.lastimero, .inquieto])),
        // «Pious womanliness and tenderness of character.»
        (Tonalidad(armadura: 0, modo: .menor), schubart([.devoto, .tierno])),
        // «A quaint creature, often dressed in the garment of night […] discontented with itself and with
        // everything.»
        (Tonalidad(armadura: -5, modo: .menor), schubart([.sombrio, .colerico])),
        // «The key of patience, of calm awaiting one's fate and of submission to divine dispensation.»
        (Tonalidad(armadura: 2, modo: .menor), schubart([.sereno, .devoto])),
    ]

    private static func schubart(_ afectos: [Afecto], ocasion: Ocasion? = nil) -> [Caracter] {
        [.init(afectos, ocasion: ocasion, testigo: .schubart, referencia: .steblin1983)]
    }

    /// Tónica (por su nombre, no por su sonido) y modo → lo que dicen sus fuentes.
    private static let caracterPorTonalidad: [Tonalidad: [Caracter]] = {
        var tabla: [Tonalidad: [Caracter]] = [:]
        for (tonalidad, caracter) in caracteres { tabla[tonalidad, default: []] += caracter }
        return tabla.mapValues(Caracter.enOrdenCronologico)
    }()

    /// Lo que dicen las fuentes del carácter de la tonalidad, en orden cronológico; vacío si ninguna dice nada. Es
    /// del nombre: Re♭ mayor tiene el de Schubart y Do♯ mayor, que él no describe, ninguno.
    ///
    ///     Tonalidad(.do).caracter[0].afectos           // [.inocente]
    ///     Tonalidad(.re).caracter[0].testigo           // .schubart
    ///     Tonalidad(Nota(.do, .sostenido)).caracter    // []
    public var caracter: [Caracter] { Tonalidad.caracterPorTonalidad[self] ?? [] }
}
