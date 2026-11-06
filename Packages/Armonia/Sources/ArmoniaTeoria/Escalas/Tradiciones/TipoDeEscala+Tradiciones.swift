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
// tradición, la ficha en cuyas listas está. Sus nombres en cada idioma están en `Escalas/Nombres/`.
//
// Cada tradición tiene su fichero, `TipoDeEscala+Nombre.swift` (el nombre del caso de `Tradicion`, con mayúscula):
// Africa, Andes, Azerbaiyan (mugam), Bizancio (echoi), Brasil (modos nordestinos), China, Corea, Etiopia, Europa
// (folklore europeo), Gregoriano (modos, hexacordos y modos de Glareano), Grecia (dromoi), GreciaAntigua
// (tetracordos, géneros y harmoniai), India, Indonesia, Japon, Klezmer, Mesopotamia (afinaciones babilónicas),
// MundoArabe (maqamat y ajnas), Persia (dastgāh), SudesteAsiatico, Turquia (makamlar y çeşni) y Vietnam. Cada uno
// acaba con su ficha (`FichaDeTradicion`), que reúne sus listas en orden. Una escala nueva se declara en el fichero
// de su tradición con todos sus datos (`FichaDeEscala`): su categoría, su versión microtonal si la tiene
// (`afinaciones: [.init(.cuartosDeTono, pasos: […])]`) y, si es un rāga janya, su mēḷa (`mela: 28`); y se apunta en
// una de sus listas.

extension TipoDeEscala {
    /// Escalas de otras tradiciones: thāṭ, dromoi, mēḷa, janya, chinas, japonesas, etíopes, maqamat, de Indonesia
    /// (laras y pathet), klezmer, rāgas indostánicos, dastgāh, coreanas, andinas, de la Grecia antigua, makamlar
    /// turcos, mugam azerbaiyanos, echoi bizantinos, afinaciones babilónicas, los ajnas árabes y los çeşni turcos,
    /// afinaciones de África y del sudeste asiático, los modos gregorianos, más géneros y harmoniai griegos y los
    /// hexacordos de Guido, las escalas populares de Europa, los modos de Glareano, las de Vietnam, los modos
    /// nordestinos de Brasil, los colores de Aristóxeno y los adwār de Ṣafī al-Dīn. El orden de las listas decide
    /// qué nombre gana en la búsqueda: las nuevas van al final.
    public static let tradicionales: [TipoDeEscala] = [
        thaats, dromoi, melakartas, janyas, gramas, murchanas, chinas, japonesas, etiopes, maqamat, indonesias, pathets,
        klezmer, ragasIndostanicos, dastgah, coreanas, andinas, griegasAntiguas, makamlar, mugamlar, echoi,
        mesopotamicas, ajnas, cesniler, africanas, sudesteAsiaticas, modosGregorianos, generosDeDidimoYEratostenes,
        harmoniaiCromaticas, harmoniaiEnarmonicas, harmoniaiDeAristides, hexacordos, europeas,
        modosDeGlareano, vietnamitas, brasilenas, coloresDeAristoxeno, adwar,
    ].flatMap { $0 }
}
