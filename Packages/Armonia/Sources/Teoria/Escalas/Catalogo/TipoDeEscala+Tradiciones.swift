import Elementos

// MARK: - Escalas de la India, dromoi griegos, echoi bizantinos, maqamat, dastgāh, makamlar, mugam, escalas chinas,
// japonesas, coreanas, etíopes, de Indonesia, andinas, klezmer, de la Grecia antigua y de Mesopotamia
//
// Escalas de otras tradiciones, en su aproximación al temperamento igual: los 72 mēḷa de
// la música carnática y algunos de sus rāgas janya, los 10 thāṭ de la indostánica y los dromoi del rebético y la música
// popular griega. En la práctica varias usan microtonos (sobre todo los dromoi, que vienen de
// los makam otomanos); aquí se escriben con los intervalos de la escala temperada.
//
// Los nombres indios siguen el AITS (Alfabeto Internacional de Transliteración Sánscrita, IAST);
// los griegos llevan el acento de la palabra griega. La búsqueda no distingue diacríticos, y la
// transliteración habitual sin ellos (Mayamalavagowla, Hijaz…) se acepta como alias.
//
// No forman parte de `TipoDeEscala.todos`, para no cambiar las búsquedas de escalas habituales,
// pero `TipoDeEscala(leyendo:)` y `Escala("Re hitzaz")` las encuentran.
//
// `categoria` y `tradicion` (en `CategoriaTradicional.swift`) dicen de cada una si es un rāga, un mēḷa, un dromos,
// un maqam, un makam, un mugam…: las dice la declaración de cada escala (`categoria: .raga`), y la tradición, si no
// la da la categoría, una subtradición o la fuente, se escribe (`tradicion: .japon`). Cada lista de
// `listasTradicionales` tiene solo escalas de su tradición. Sus nombres en cada idioma están en `Escalas/Nombres/`.
//
// Cada tradición tiene su fichero, `TipoDeEscala+Nombre.swift` (el nombre del caso de `Tradicion`, con mayúscula):
// Africa, Andes, Azerbaiyan (mugam), Bizancio (echoi), Brasil (modos nordestinos), China, Corea, Etiopia, Europa
// (folklore europeo), Gregoriano (modos, hexacordos y modos de Glareano), Grecia (dromoi), GreciaAntigua
// (tetracordos, géneros y harmoniai), India, Indonesia, Japon, Klezmer, Mesopotamia (afinaciones babilónicas),
// MundoArabe (maqamat y ajnas), Persia (dastgāh), Renacimiento (musica ficta), SudesteAsiatico, Turquia (makamlar
// y çeşni) y Vietnam. Cada uno declara sus escalas y sus listas. Una escala nueva se declara en el fichero de su
// tradición con todos sus datos (`FichaDeEscala`): su categoría, su versión microtonal si la tiene (`afinaciones:
// [.init(.cuartosDeTono, pasos: […])]`) y su escala madre, si la tiene (`padre: .melakarta(28)`, `padre: .kalyan`);
// y se apunta en una de sus listas. Una lista nueva se apunta, con su tradición, en `listasTradicionales`.

extension TipoDeEscala {
    /// Escalas de otras tradiciones: thāṭ, dromoi, mēḷa, janya, chinas, japonesas, etíopes, maqamat, de Indonesia
    /// (laras y pathet), klezmer, rāgas indostánicos, dastgāh, coreanas, andinas, de la Grecia antigua, makamlar
    /// turcos, mugam azerbaiyanos, echoi bizantinos, afinaciones babilónicas, los ajnas árabes y los çeşni turcos,
    /// afinaciones de África y del sudeste asiático, los modos gregorianos, más géneros y harmoniai griegos y los
    /// hexacordos de Guido, las escalas populares de Europa, los modos de Glareano, las de Vietnam, los modos
    /// nordestinos de Brasil, los colores de Aristóxeno, los adwār de Ṣafī al-Dīn, los lü chinos y los modos con
    /// musica ficta y los géneros de Vicentino del Renacimiento. El orden de las listas decide qué nombre gana en la
    /// búsqueda: las nuevas van al final.
    public static let tradicionales: [TipoDeEscala] = listasTradicionales.flatMap(\.tipos)

    /// Las listas de `tradicionales`, cada una con su tradición, en el orden en que tienen prioridad: de aquí sale
    /// `tradicionales`. La tradición de cada escala está en su ficha, y una prueba comprueba que es la de su lista.
    /// Una lista nueva se apunta aquí, al final, y una tradición nueva necesita al menos una.
    static let listasTradicionales: [ListaTradicional] = [
        .init(.india, thaats, referencias: [.jairazbhoy1971, .kaufmann1968, .rechberger2008]), .init(.grecia, dromoi),
        .init(.india, melakartas, referencias: [.kaufmann1976, .rechberger2008]),
        .init(.india, janyas, referencias: [.kaufmann1976]),
        .init(.india, gramas, referencias: [.rowell1992]), .init(.india, murchanas, referencias: [.rowell1992]),
        .init(.china, chinas, referencias: [.rechberger2008]),
        .init(.japon, japonesas, referencias: [.malm1959, .rechberger2008]),
        .init(.etiopia, etiopes, referencias: [.kebede1971]),
        .init(.mundoArabe, maqamat, referencias: [.maqamWorld, .touma1996, .farraj2019, .rechberger2008]),
        .init(.indonesia, indonesias, referencias: [.surjodiningrat1972, .tenzer2000]),
        .init(.indonesia, pathets, referencias: [.surjodiningrat1972, .tenzer2000]),
        .init(.klezmer, klezmer, referencias: [.rubin2020]),
        .init(.india, ragasIndostanicos, referencias: [.jairazbhoy1971, .kaufmann1968]),
        .init(.persia, dastgah, referencias: [.farhat1990, .rechberger2008]),
        .init(.corea, coreanas), .init(.andes, andinas, referencias: [.harcourt1925]),
        .init(.greciaAntigua, tetracordosGriegos, referencias: [.chalmers1993, .west1992]),
        .init(.greciaAntigua, generosDeArquitasYPtolomeo, referencias: [.chalmers1993, .west1992]),
        .init(.greciaAntigua, harmoniai, referencias: [.west1992, .rechberger2008]),
        .init(.turquia, makamlar, referencias: [.tdvIslamAnsiklopedisi, .signell1977, .rechberger2008]),
        .init(.azerbaiyan, mugamlar, referencias: [.hacibeyov1945]),
        .init(.bizancio, echoi, referencias: [.rechberger2008]),
        .init(.mesopotamia, mesopotamicas, referencias: [.kilmer1971, .gurney1994, .west1994]),
        .init(.mundoArabe, ajnas, referencias: [.maqamWorld, .touma1996]),
        .init(.turquia, cesniler, referencias: [.signell1977]), .init(.africa, africanas),
        .init(.sudesteAsiatico, sudesteAsiaticas),
        .init(.gregoriano, modosGregorianos, referencias: [.apel1958, .powers2001, .rechberger2008]),
        .init(.greciaAntigua, generosDeDidimoYEratostenes, referencias: [.chalmers1993, .west1992]),
        .init(.greciaAntigua, harmoniaiCromaticas, referencias: [.west1992]),
        .init(.greciaAntigua, harmoniaiEnarmonicas, referencias: [.west1992]),
        .init(.greciaAntigua, harmoniaiDeAristides, referencias: [.west1992, .mathiesen1999]),
        .init(.gregoriano, hexacordos, referencias: [.apel1958]), .init(.europa, europeas),
        .init(.gregoriano, modosDeGlareano),
        .init(.vietnam, vietnamitas, referencias: [.tranVanKhe1962]), .init(.brasil, brasilenas),
        .init(.greciaAntigua, coloresDeAristoxeno, referencias: [.chalmers1993, .west1992]),
        .init(.mundoArabe, adwar, referencias: [.wright1978]), .init(.china, lus, referencias: [.barbour1951]),
        .init(.renacimiento, escalasRenacentistas, referencias: [.barbour1951]),
        .init(.renacimiento, generosDeVicentino),
    ]
}

/// Una lista de escalas de otra tradición (los thāṭ, los mēḷa, los dromoi…) y la tradición de todas ellas.
struct ListaTradicional: Sendable {
    let tradicion: Tradicion
    let tipos: [TipoDeEscala]
    /// Las obras donde se leen todas sus escalas: van en las `referencias` de cada una.
    let referencias: [Referencia]

    init(_ tradicion: Tradicion, _ tipos: [TipoDeEscala], referencias: [Referencia] = []) {
        self.tradicion = tradicion
        self.tipos = tipos
        self.referencias = referencias
    }
}
