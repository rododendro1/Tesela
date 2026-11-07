import Elementos
import Foundation

// MARK: - Tablas de los nombres por octava
//
// Cada fila: la nota temperada (en el turco, la pitagórica) con su octava, el ajuste en los pasos del sistema, y el
// nombre en su escritura y transliterado; el ASCII se saca del transliterado, sin diacríticos ni ʿ. Fuentes: para las
// perde, el artículo «Turkish makam» de Wikipedia, con las comas de cada una desde Kaba Çârgâh, que coinciden con los
// makamlar del catálogo (Rast makamı: Rast 31, Dügâh 40, Segâh 48… Eviç 79); para las notas árabes, Touma (The Music
// of the Arabs, 1996) y maqamworld.com; para las cuerdas griegas, «Musical system of ancient Greece».

extension NombresPorOctava {
    /// Una fila de la tabla: la altura, su ajuste y sus nombres (original, transliterado y ASCII).
    typealias Fila = (altura: Altura, ajuste: Int, nombres: [String])

    /// Las alturas con nombre del sistema, de la grave a la aguda.
    var tabla: [Fila] {
        switch self {
        case .arabe: return NombresPorOctava.arabes
        case .turco: return NombresPorOctava.turcas
        case .griegoAntiguo: return NombresPorOctava.griegas
        }
    }

    private static func fila(_ nota: Nota, _ octava: Int, _ original: String, _ transliterado: String) -> Fila {
        fila(nota, octava, 0, original, transliterado)
    }

    private static func fila(
        _ nota: Nota, _ octava: Int, _ ajuste: Int, _ original: String, _ transliterado: String
    ) -> Fila {
        let ascii = transliterado.folding(options: .diacriticInsensitive, locale: nil).filter { $0 != "ʿ" }
        return (Altura(nota, octava: octava), ajuste, [original, transliterado, ascii])
    }

    /// Las notas árabes, de Yakāh (Sol3) a Ramal Tūtī (Sol5), con Rāst en Do4.
    private static let arabes: [Fila] = [
        fila("Sol", 3, "يكاه", "Yakāh"),
        fila("Lab", 3, "قرار حصار", "Qarār Ḥiṣār"),
        fila("La", 3, "عشيران", "ʿUshayrān"),
        fila("Sib", 3, "عجم عشيران", "ʿAjam ʿUshayrān"),
        fila("Si", 3, -1, "عراق", "ʿIrāq"),
        fila("Si", 3, "كوشت", "Kawasht"),
        fila("Do", 4, "راست", "Rāst"),
        fila("Reb", 4, "زيركولاه", "Zīrkūlāh"),
        fila("Re", 4, "دوكاه", "Dūkāh"),
        fila("Mib", 4, "كردي", "Kurdī"),
        fila("Mi", 4, -1, "سيكاه", "Sīkāh"),
        fila("Mi", 4, "بوسليك", "Būsalīk"),
        fila("Fa", 4, "جهاركاه", "Jahārkāh"),
        fila("Fa#", 4, "حجاز", "Ḥijāz"),
        fila("Sol", 4, "نوى", "Nawā"),
        fila("Lab", 4, "حصار", "Ḥiṣār"),
        fila("La", 4, "حسيني", "Ḥusaynī"),
        fila("Sib", 4, "عجم", "ʿAjam"),
        fila("Si", 4, -1, "أوج", "Awj"),
        fila("Si", 4, "ماهور", "Māhūr"),
        fila("Do", 5, "كردان", "Kardān"),
        fila("Reb", 5, "شهناز", "Shahnāz"),
        fila("Re", 5, "محير", "Muḥayyar"),
        fila("Mib", 5, "سنبلة", "Sunbula"),
        fila("Mi", 5, -1, "بزرك", "Buzurk"),
        fila("Mi", 5, "جواب بوسليك", "Jawāb Būsalīk"),
        fila("Fa", 5, "ماهوران", "Māhūrān"),
        fila("Fa#", 5, "جواب حجاز", "Jawāb Ḥijāz"),
        fila("Sol", 5, "رمل توتي", "Ramal Tūtī"),
    ]

    /// Las perde de Arel-Ezgi-Uzdilek, de Kaba Çârgâh (Do4) a Tîz Çârgâh (Do6), con Rast en Sol4. Las «nim» y las
    /// «dik» son la perde de al lado una koma más baja o más alta: Nim Hicâz es Do♯5 una koma bajo; Dik Acem, Fa5 una
    /// koma alto.
    private static let turcas: [Fila] = perdes.map { nota, octava, ajuste, nombre in
        fila(nota, octava, ajuste, nombre, nombre)
    }

    /// Las perde, con su nota pitagórica, su octava, sus comas sobre ella y su nombre.
    private static let perdes: [(Nota, Int, Int, String)] = [
        ("Do", 4, 0, "Kaba Çârgâh"), ("Do#", 4, -1, "Kaba Nim Hicâz"), ("Do#", 4, 0, "Kaba Hicâz"),
        ("Re", 4, -1, "Kaba Dik Hicâz"), ("Re", 4, 0, "Yegâh"), ("Re#", 4, -1, "Kaba Nim Hisâr"),
        ("Re#", 4, 0, "Kaba Hisâr"), ("Mi", 4, -1, "Kaba Dik Hisâr"), ("Mi", 4, 0, "Hüseynî Aşîrân"),
        ("Fa", 4, 0, "Acem Aşîrân"), ("Fa", 4, 1, "Dik Acem Aşîrân"), ("Fa#", 4, -1, "Irak"), ("Fa#", 4, 0, "Gevest"),
        ("Sol", 4, -1, "Dik Gevest"), ("Sol", 4, 0, "Rast"), ("Sol#", 4, -1, "Nim Zirgüle"),
        ("Sol#", 4, 0, "Zirgüle"), ("La", 4, -1, "Dik Zirgüle"), ("La", 4, 0, "Dügâh"), ("Sib", 4, 0, "Kürdi"),
        ("Sib", 4, 1, "Dik Kürdi"), ("Si", 4, -1, "Segâh"), ("Si", 4, 0, "Bûselik"), ("Do", 5, -1, "Dik Bûselik"),
        ("Do", 5, 0, "Çârgâh"), ("Do#", 5, -1, "Nim Hicâz"), ("Do#", 5, 0, "Hicâz"), ("Re", 5, -1, "Dik Hicâz"),
        ("Re", 5, 0, "Nevâ"), ("Re#", 5, -1, "Nim Hisâr"), ("Re#", 5, 0, "Hisâr"), ("Mi", 5, -1, "Dik Hisâr"),
        ("Mi", 5, 0, "Hüseynî"), ("Fa", 5, 0, "Acem"), ("Fa", 5, 1, "Dik Acem"), ("Fa#", 5, -1, "Eviç"),
        ("Fa#", 5, 0, "Mâhûr"), ("Sol", 5, -1, "Dik Mâhûr"), ("Sol", 5, 0, "Gerdâniye"),
        ("Sol#", 5, -1, "Nim Şehnâz"), ("Sol#", 5, 0, "Şehnâz"), ("La", 5, -1, "Dik Şehnâz"),
        ("La", 5, 0, "Muhayyer"), ("Sib", 5, 0, "Sünbüle"), ("Sib", 5, 1, "Dik Sünbüle"),
        ("Si", 5, -1, "Tîz Segâh"), ("Si", 5, 0, "Tîz Bûselik"), ("Do", 6, -1, "Tîz Dik Bûselik"),
        ("Do", 6, 0, "Tîz Çârgâh"),
    ]

    /// Las quince cuerdas del sistema perfecto mayor, de proslambanómenos (La2) a nḗtē hyperbolaíōn (La4), y detrás
    /// las tres del tetracordo synēmménōn, el del sistema perfecto menor, que se une a la mésē (La3).
    private static let griegas: [Fila] = [
        fila("La", 2, "προσλαμβανόμενος", "proslambanómenos"),
        fila("Si", 2, "ὑπάτη ὑπάτων", "hypátē hypátōn"),
        fila("Do", 3, "παρυπάτη ὑπάτων", "parhypátē hypátōn"),
        fila("Re", 3, "λιχανὸς ὑπάτων", "lichanòs hypátōn"),
        fila("Mi", 3, "ὑπάτη μέσων", "hypátē mésōn"),
        fila("Fa", 3, "παρυπάτη μέσων", "parhypátē mésōn"),
        fila("Sol", 3, "λιχανὸς μέσων", "lichanòs mésōn"),
        fila("La", 3, "μέση", "mésē"),
        fila("Si", 3, "παραμέση", "paramésē"),
        fila("Do", 4, "τρίτη διεζευγμένων", "trítē diezeugménōn"),
        fila("Re", 4, "παρανήτη διεζευγμένων", "paranḗtē diezeugménōn"),
        fila("Mi", 4, "νήτη διεζευγμένων", "nḗtē diezeugménōn"),
        fila("Fa", 4, "τρίτη ὑπερβολαίων", "trítē hyperbolaíōn"),
        fila("Sol", 4, "παρανήτη ὑπερβολαίων", "paranḗtē hyperbolaíōn"),
        fila("La", 4, "νήτη ὑπερβολαίων", "nḗtē hyperbolaíōn"),
        fila("Sib", 3, "τρίτη συνημμένων", "trítē synēmménōn"),
        fila("Do", 4, "παρανήτη συνημμένων", "paranḗtē synēmménōn"),
        fila("Re", 4, "νήτη συνημμένων", "nḗtē synēmménōn"),
    ]
}
