// swift-format-ignore-file
// Tabla de datos, una fila por tradición, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo

// MARK: - El nombre de cada tradición

extension Tradicion {
    /// El nombre de la tradición en el idioma de los textos de la notación: «Japón», «Japan», «Japonia», «Ιαπωνία».
    /// En español, también `nombre` (de `Nombrable`).
    ///
    ///     Tradicion.japon.nombre(en: .delIdioma(.euskera))   // "Japonia"
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los quince idiomas. El `switch` no tiene `default`: una tradición nueva no compila sin el suyo.
    private var traduccion: Traduccion {
        switch self {
        case .india:
            Traduccion(
                "India", "India", ca: "Índia", gl: "India", ast: "India", an: "India", eu: "India", pt: "Índia", fr: "Inde", oc: "Índia", it: "India", de: "Indien", el: "Ινδία", ru: "Индия", hu: "India")
        case .grecia:
            Traduccion(
                "Grecia", "Greece", ca: "Grècia", gl: "Grecia", ast: "Grecia", an: "Grecia", eu: "Grezia", pt: "Grécia", fr: "Grèce", oc: "Grècia", it: "Grecia", de: "Griechenland", el: "Ελλάδα", ru: "Греция", hu: "Görögország")
        case .greciaAntigua:
            Traduccion(
                "Grecia antigua", "Ancient Greece", ca: "Grècia antiga", gl: "Grecia antiga", ast: "Grecia antigua", an: "Grecia antiga", eu: "Antzinako Grezia", pt: "Grécia antiga", fr: "Grèce antique", oc: "Grècia antica", it: "Grecia antica", de: "Antikes Griechenland", el: "Αρχαία Ελλάδα", ru: "Древняя Греция", hu: "Ókori Görögország")
        case .mundoArabe:
            Traduccion(
                "Mundo árabe", "Arab world", ca: "Món àrab", gl: "Mundo árabe", ast: "Mundu árabe", an: "Mundo arabe", eu: "Mundu arabiarra", pt: "Mundo árabe", fr: "Monde arabe", oc: "Mond arabi", it: "Mondo arabo", de: "Arabische Welt", el: "Αραβικός κόσμος", ru: "Арабский мир", hu: "Arab világ")
        case .persia:
            Traduccion(
                "Persia", "Persia", ca: "Pèrsia", gl: "Persia", ast: "Persia", an: "Persia", eu: "Persia", pt: "Pérsia", fr: "Perse", oc: "Pèrsia", it: "Persia", de: "Persien", el: "Περσία", ru: "Персия", hu: "Perzsia")
        case .turquia:
            Traduccion(
                "Turquía", "Turkey", ca: "Turquia", gl: "Turquía", ast: "Turquía", an: "Turquía", eu: "Turkia", pt: "Turquia", fr: "Turquie", oc: "Turquia", it: "Turchia", de: "Türkei", el: "Τουρκία", ru: "Турция", hu: "Törökország")
        case .azerbaiyan:
            Traduccion(
                "Azerbaiyán", "Azerbaijan", ca: "Azerbaidjan", gl: "Acerbaixán", ast: "Azerbaixán", an: "Azerbaichán", eu: "Azerbaijan", pt: "Azerbaijão", fr: "Azerbaïdjan", oc: "Azerbaitjan", it: "Azerbaigian", de: "Aserbaidschan", el: "Αζερμπαϊτζάν", ru: "Азербайджан", hu: "Azerbajdzsán")
        case .china:
            Traduccion(
                "China", "China", ca: "Xina", gl: "China", ast: "China", an: "China", eu: "Txina", pt: "China", fr: "Chine", oc: "China", it: "Cina", de: "China", el: "Κίνα", ru: "Китай", hu: "Kína")
        case .japon:
            Traduccion(
                "Japón", "Japan", ca: "Japó", gl: "Xapón", ast: "Xapón", an: "Chapón", eu: "Japonia", pt: "Japão", fr: "Japon", oc: "Japon", it: "Giappone", de: "Japan", el: "Ιαπωνία", ru: "Япония", hu: "Japán")
        case .corea:
            Traduccion(
                "Corea", "Korea", ca: "Corea", gl: "Corea", ast: "Corea", an: "Corea", eu: "Korea", pt: "Coreia", fr: "Corée", oc: "Corèa", it: "Corea", de: "Korea", el: "Κορέα", ru: "Корея", hu: "Korea")
        case .etiopia:
            Traduccion(
                "Etiopía", "Ethiopia", ca: "Etiòpia", gl: "Etiopía", ast: "Etiopía", an: "Etiopía", eu: "Etiopia", pt: "Etiópia", fr: "Éthiopie", oc: "Etiopia", it: "Etiopia", de: "Äthiopien", el: "Αιθιοπία", ru: "Эфиопия", hu: "Etiópia")
        case .indonesia:
            Traduccion(
                "Indonesia", "Indonesia", ca: "Indonèsia", gl: "Indonesia", ast: "Indonesia", an: "Indonesia", eu: "Indonesia", pt: "Indonésia", fr: "Indonésie", oc: "Indonesia", it: "Indonesia", de: "Indonesien", el: "Ινδονησία", ru: "Индонезия", hu: "Indonézia")
        case .klezmer:
            Traduccion(
                "Klezmer", "Klezmer", ca: "Klezmer", gl: "Klezmer", ast: "Klezmer", an: "Klezmer", eu: "Klezmer", pt: "Klezmer", fr: "Klezmer", oc: "Klezmer", it: "Klezmer", de: "Klezmer", el: "Κλέζμερ", ru: "Клезмер", hu: "Klezmer")
        case .andes:
            Traduccion(
                "Andes", "Andes", ca: "Andes", gl: "Andes", ast: "Andes", an: "Andes", eu: "Andeak", pt: "Andes", fr: "Andes", oc: "Andes", it: "Ande", de: "Anden", el: "Άνδεις", ru: "Анды", hu: "Andok")
        case .bizancio:
            Traduccion(
                "Bizancio", "Byzantium", ca: "Bizanci", gl: "Bizancio", ast: "Bizanciu", an: "Bizancio", eu: "Bizantzio", pt: "Bizâncio", fr: "Byzance", oc: "Bizanci", it: "Bisanzio", de: "Byzanz", el: "Βυζάντιο", ru: "Византия", hu: "Bizánc")
        case .mesopotamia:
            Traduccion(
                "Mesopotamia", "Mesopotamia", ca: "Mesopotàmia", gl: "Mesopotamia", ast: "Mesopotamia", an: "Mesopotamia", eu: "Mesopotamia", pt: "Mesopotâmia", fr: "Mésopotamie", oc: "Mesopotamia", it: "Mesopotamia", de: "Mesopotamien", el: "Μεσοποταμία", ru: "Месопотамия", hu: "Mezopotámia")
        case .africa:
            Traduccion(
                "África", "Africa", ca: "Àfrica", gl: "África", ast: "África", an: "Africa", eu: "Afrika", pt: "África", fr: "Afrique", oc: "Africa", it: "Africa", de: "Afrika", el: "Αφρική", ru: "Африка", hu: "Afrika")
        case .sudesteAsiatico:
            Traduccion(
                "Sudeste asiático", "Southeast Asia", ca: "Sud-est asiàtic", gl: "Sueste asiático", ast: "Sureste asiáticu", an: "Sudeste asiatico", eu: "Asia hego-ekialdea", pt: "Sudeste Asiático", fr: "Asie du Sud-Est", oc: "Sud-èst asiatic", it: "Sud-est asiatico", de: "Südostasien", el: "Νοτιοανατολική Ασία", ru: "Юго-Восточная Азия", hu: "Délkelet-Ázsia")
        case .gregoriano:
            Traduccion(
                "Canto gregoriano", "Gregorian chant", ca: "Cant gregorià", gl: "Canto gregoriano", ast: "Cantu gregorianu", an: "Canto gregoriano", eu: "Kantu gregorianoa", pt: "Canto gregoriano", fr: "Chant grégorien", oc: "Cant gregorian", it: "Canto gregoriano", de: "Gregorianischer Choral", el: "Γρηγοριανό μέλος", ru: "Григорианский хорал", hu: "Gregorián ének")
        }
    }
}

extension Tradicion: Nombrable {}
