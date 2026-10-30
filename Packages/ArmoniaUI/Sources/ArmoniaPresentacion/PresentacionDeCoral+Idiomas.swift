import Armonia
// Los textos de las tareas del coral en los catorce idiomas de los textos (`Traduccion`). Los demás
// textos de las apps están en TextoDeLasApps.swift.

extension PresentacionDeCoral.Tarea {
    /// El nombre de la tarea en el selector: «Armonizar», «Harmonize»…
    public func titulo(en notacion: Notacion) -> String {
        let traduccion: Traduccion
        switch self {
        case .armonizar:
            traduccion = Traduccion("Armonizar", "Harmonize", ca: "Harmonitzar", gl: "Harmonizar", ast: "Armonizar",
                                    an: "Armonizar", eu: "Harmonizatu", pt: "Harmonizar",
                                    fr: "Harmoniser", oc: "Armonizar", it: "Armonizzare", de: "Harmonisieren",
                                    el: "Εναρμόνιση", ru: "Гармонизовать")
        case .realizar:
            traduccion = Traduccion("Realizar", "Realize", ca: "Realitzar", gl: "Realizar", ast: "Realizar",
                                    an: "Realizar", eu: "Gauzatu", pt: "Realizar",
                                    fr: "Réaliser", oc: "Realizar", it: "Realizzare", de: "Aussetzen",
                                    el: "Υλοποίηση", ru: "Реализовать")
        case .revisar:
            traduccion = Traduccion("Revisar", "Check", ca: "Revisar", gl: "Revisar", ast: "Revisar",
                                    an: "Revisar", eu: "Berrikusi", pt: "Rever",
                                    fr: "Vérifier", oc: "Verificar", it: "Controllare", de: "Prüfen",
                                    el: "Έλεγχος", ru: "Проверить")
        }
        return traduccion.en(notacion)
    }

    /// Qué se escribe en el campo de texto, con los ejemplos en la notación.
    public func indicacion(en notacion: Notacion) -> String {
        let traduccion: Traduccion
        switch self {
        case .armonizar:
            let e = TextoDeLasApps.alturas("Mi4 Fa4 Re4 Do4", notacion)
            // Con ritmo: «Mi4:4 Re4:8», con las notas en la notación.
            let r = [("Mi4", 4), ("Re4", 8)].map { TextoDeLasApps.alturas($0.0, notacion) + ":\($0.1)" }
                .joined(separator: " ")
            traduccion = Traduccion("Melodía (\(e), sin octavas o con ritmo: \(r))",
                                    "Melody (\(e), without octaves or with rhythm: \(r))",
                                    ca: "Melodia (\(e), sense octaves o amb ritme: \(r))",
                                    gl: "Melodía (\(e), sen oitavas ou con ritmo: \(r))",
                                    ast: "Melodía (\(e), ensin octaves o con ritmu: \(r))",
                                    an: "Melodía (\(e), sin octavas u con ritmo: \(r))",
                                    eu: "Melodia (\(e), zortzidunik gabe edo erritmoarekin: \(r))",
                                    pt: "Melodia (\(e), sem oitavas ou com ritmo: \(r))",
                                    fr: "Mélodie (\(e), sans octaves ou avec rythme : \(r))",
                                    oc: "Melodia (\(e), sens octavas o amb ritme: \(r))",
                                    it: "Melodia (\(e), senza ottave o con ritmo: \(r))",
                                    de: "Melodie (\(e), ohne Oktaven oder mit Rhythmus: \(r))",
                                    el: "Μελωδία (\(e), χωρίς οκτάβες ή με ρυθμό: \(r))", ru: "Мелодия (\(e), без октав или с ритмом: \(r))")
        case .realizar:
            let e = ["Do", "Fa", "Sol7", "Do"].map { TextoDeLasApps.cifrado($0, notacion) }.joined(separator: " ")
            traduccion = TextoDeLasApps.acordes.traduccion(notacion).aplicando { "\($0) (\(e))" }
        case .revisar:
            let e = TextoDeLasApps.alturas("Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4", notacion)
            traduccion = Traduccion("Voces de grave a agudo (\(e))", "Voices from low to high (\(e))",
                                    ca: "Veus de greu a agut (\(e))", gl: "Voces de grave a agudo (\(e))",
                                    ast: "Voces de grave a agudu (\(e))", an: "Voces de grave a agudo (\(e))",
                                    eu: "Ahotsak, baxuenetik altuenera (\(e))", pt: "Vozes do grave ao agudo (\(e))",
                                    fr: "Voix du grave à l'aigu (\(e))", oc: "Voses del grèu a l'agut (\(e))",
                                    it: "Voci dal grave all'acuto (\(e))", de: "Stimmen von tief nach hoch (\(e))",
                                    el: "Φωνές από το βαθύ στο οξύ (\(e))", ru: "Голоса снизу вверх (\(e))")
        }
        return traduccion.en(notacion)
    }
}
