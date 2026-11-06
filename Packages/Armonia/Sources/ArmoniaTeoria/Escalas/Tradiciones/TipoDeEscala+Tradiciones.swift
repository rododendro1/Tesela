import ArmoniaNucleo

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
// un maqam, un makam, un mugam…: la categoría la dice la declaración de cada escala (`categoria: .raga`) y la
// tradición, su lista en `listasTradicionales`. Sus nombres en cada idioma están en `Escalas/Nombres/`.
//
// Cada tradición tiene su fichero, `TipoDeEscala+Nombre.swift` (el nombre del caso de `Tradicion`, con mayúscula):
// Africa, Andes, Azerbaiyan (mugam), Bizancio (echoi), Brasil (modos nordestinos), China, Corea, Etiopia, Europa
// (folklore europeo), Gregoriano (modos, hexacordos y modos de Glareano), Grecia (dromoi), GreciaAntigua
// (tetracordos, géneros y harmoniai), India, Indonesia, Japon, Klezmer, Mesopotamia (afinaciones babilónicas),
// MundoArabe (maqamat y ajnas), Persia (dastgāh), SudesteAsiatico, Turquia (makamlar y çeşni) y Vietnam. Cada uno
// declara sus escalas y sus listas. Una escala nueva se declara en el fichero de su tradición con todos sus datos
// (`FichaDeEscala`): su categoría, su versión microtonal si la tiene (`afinaciones: [.init(.cuartosDeTono, pasos:
// […])]`) y, si es un rāga janya, su mēḷa (`mela: 28`); y se apunta en una de sus listas. Una lista nueva se apunta,
// con su tradición, en `listasTradicionales`.

extension TipoDeEscala {
    /// Escalas de otras tradiciones: thāṭ, dromoi, mēḷa, janya, chinas, japonesas, etíopes, maqamat, de Indonesia
    /// (laras y pathet), klezmer, rāgas indostánicos, dastgāh, coreanas, andinas, de la Grecia antigua, makamlar
    /// turcos, mugam azerbaiyanos, echoi bizantinos, afinaciones babilónicas, los ajnas árabes y los çeşni turcos,
    /// afinaciones de África y del sudeste asiático, los modos gregorianos, más géneros y harmoniai griegos y los
    /// hexacordos de Guido, las escalas populares de Europa, los modos de Glareano, las de Vietnam, los modos
    /// nordestinos de Brasil, los colores de Aristóxeno y los adwār de Ṣafī al-Dīn. El orden de las listas decide
    /// qué nombre gana en la búsqueda: las nuevas van al final.
    public static let tradicionales: [TipoDeEscala] = listasTradicionales.flatMap(\.tipos)

    /// Las listas de `tradicionales`, cada una con su tradición, en el orden en que tienen prioridad: de aquí salen
    /// `tradicionales` y `tradicion`. Una lista nueva se apunta aquí, al final, y una tradición nueva necesita al
    /// menos una.
    static let listasTradicionales: [ListaTradicional] = [
        .init(.india, thaats), .init(.grecia, dromoi), .init(.india, melakartas), .init(.india, janyas),
        .init(.india, gramas), .init(.india, murchanas), .init(.china, chinas), .init(.japon, japonesas),
        .init(.etiopia, etiopes), .init(.mundoArabe, maqamat), .init(.indonesia, indonesias),
        .init(.indonesia, pathets), .init(.klezmer, klezmer), .init(.india, ragasIndostanicos), .init(.persia, dastgah),
        .init(.corea, coreanas), .init(.andes, andinas), .init(.greciaAntigua, tetracordosGriegos),
        .init(.greciaAntigua, generosDeArquitasYPtolomeo), .init(.greciaAntigua, harmoniai), .init(.turquia, makamlar),
        .init(.azerbaiyan, mugamlar), .init(.bizancio, echoi), .init(.mesopotamia, mesopotamicas),
        .init(.mundoArabe, ajnas), .init(.turquia, cesniler), .init(.africa, africanas),
        .init(.sudesteAsiatico, sudesteAsiaticas), .init(.gregoriano, modosGregorianos),
        .init(.greciaAntigua, generosDeDidimoYEratostenes), .init(.greciaAntigua, harmoniaiCromaticas),
        .init(.greciaAntigua, harmoniaiEnarmonicas), .init(.greciaAntigua, harmoniaiDeAristides),
        .init(.gregoriano, hexacordos), .init(.europa, europeas), .init(.gregoriano, modosDeGlareano),
        .init(.vietnam, vietnamitas), .init(.brasil, brasilenas), .init(.greciaAntigua, coloresDeAristoxeno),
        .init(.mundoArabe, adwar),
    ]
}

/// Una lista de escalas de otra tradición (los thāṭ, los mēḷa, los dromoi…) y la tradición de todas ellas.
struct ListaTradicional: Sendable {
    let tradicion: Tradicion
    let tipos: [TipoDeEscala]

    init(_ tradicion: Tradicion, _ tipos: [TipoDeEscala]) {
        self.tradicion = tradicion
        self.tipos = tipos
    }
}
