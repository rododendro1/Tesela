import ArmoniaNucleo
import ArmoniaTeoria
// Nombres de las claves y de los instrumentos predefinidos en los catorce idiomas de los textos (`Traduccion`). El resto de nombres que dependen del idioma, en `Fundamentos/Nota+Idiomas.swift` y `Fundamentos/Intervalo+Idiomas.swift`.

// MARK: - Clave

extension Clave {
    public var nombre: String { nombre(en: .espanolUnicode) }

    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .sol:
            return TextosDePartitura.traducidos.map(\.claveDeSol)
        case .solOctavaBaja:
            return TextosDePartitura.traducidos.map(\.claveDeSolOctavaBaja)
        case .solOctavaAlta:
            return TextosDePartitura.traducidos.map(\.claveDeSolOctavaAlta)
        case .fa:
            return TextosDePartitura.traducidos.map(\.claveDeFa)
        case .faEnTercera:
            return TextosDePartitura.traducidos.map(\.claveDeFaEnTercera)
        case .doEnPrimera:
            return TextosDePartitura.traducidos.map(\.claveDeDoEnPrimera)
        case .doEnSegunda:
            return TextosDePartitura.traducidos.map(\.claveDeDoEnSegunda)
        case .doEnTercera:
            return TextosDePartitura.traducidos.map(\.claveDeDoEnTercera)
        case .doEnCuarta:
            return TextosDePartitura.traducidos.map(\.claveDeDoEnCuarta)
        }
    }
}

// MARK: - InstrumentoDePartitura

extension InstrumentoDePartitura {
    /// Catalán, gallego y euskera de los instrumentos predefinidos, por su nombre en español. Un
    /// instrumento que no está aquí usa su nombre español.
    package static let nombresPeninsulares: [String: (catalan: String, gallego: String, euskera: String)] = [
        "piano": ("piano", "piano", "pianoa"),
        "flauta": ("flauta", "frauta", "flauta"),
        "flautín": ("flautí", "frautín", "pikoloa"),
        "flauta en sol": ("flauta en sol", "frauta en sol", "sol flauta"),
        "oboe": ("oboè", "óboe", "oboea"),
        "corno inglés": ("corn anglès", "corno inglés", "korno ingelesa"),
        "clarinete en si♭": ("clarinet en si♭", "clarinete en si♭", "si♭ klarinetea"),
        "clarinete en la": ("clarinet en la", "clarinete en la", "la klarinetea"),
        "clarinete en mi♭": ("clarinet en mi♭", "clarinete en mi♭", "mi♭ klarinetea"),
        "clarinete bajo": ("clarinet baix", "clarinete baixo", "klarinete baxua"),
        "fagot": ("fagot", "fagot", "fagota"),
        "saxofón soprano": ("saxòfon soprano", "saxofón soprano", "saxofoi sopranoa"),
        "saxofón alto": ("saxòfon alt", "saxofón alto", "saxofoi altua"),
        "saxofón tenor": ("saxòfon tenor", "saxofón tenor", "saxofoi tenorra"),
        "saxofón barítono": ("saxòfon baríton", "saxofón barítono", "saxofoi baritonoa"),
        "trompeta en si♭": ("trompeta en si♭", "trompeta en si♭", "si♭ tronpeta"),
        "trompeta en do": ("trompeta en do", "trompeta en do", "do tronpeta"),
        "fliscorno": ("fiscorn", "fliscorno", "fliscornoa"),
        "trompa en fa": ("trompa en fa", "trompa en fa", "fa tronpa"),
        "trombón": ("trombó", "trombón", "tronboia"),
        "tuba": ("tuba", "tuba", "tuba"),
        "violín": ("violí", "violín", "biolina"),
        "viola": ("viola", "viola", "biola"),
        "violonchelo": ("violoncel", "violonchelo", "biolontxeloa"),
        "contrabajo": ("contrabaix", "contrabaixo", "kontrabaxua"),
        "guitarra": ("guitarra", "guitarra", "gitarra"),
        "bajo eléctrico": ("baix elèctric", "baixo eléctrico", "baxu elektrikoa"),
        "xilófono": ("xilòfon", "xilófono", "xilofonoa"),
        "glockenspiel": ("glockenspiel", "glockenspiel", "glockenspiela"),
        "celesta": ("celesta", "celesta", "zelesta"),
    ]

    /// Aragonés y asturiano de los instrumentos predefinidos, por su nombre en español. Un instrumento que no
    /// está aquí usa su nombre español.
    package static let nombresAragonesesYAsturianos: [String: (aragones: String, asturiano: String)] = [
        "piano": ("piano", "pianu"),
        "flauta": ("flauta", "flauta"),
        "flautín": ("flautín", "flautín"),
        "flauta en sol": ("flauta en sol", "flauta en sol"),
        "oboe": ("oboe", "oboe"),
        "corno inglés": ("corno anglés", "cornu inglés"),
        "clarinete en si♭": ("clarinet en si♭", "clarinete en si♭"),
        "clarinete en la": ("clarinet en la", "clarinete en la"),
        "clarinete en mi♭": ("clarinet en mi♭", "clarinete en mi♭"),
        "clarinete bajo": ("clarinet baixo", "clarinete baxu"),
        "fagot": ("fagot", "fagot"),
        "saxofón soprano": ("saxofón soprano", "saxofón soprano"),
        "saxofón alto": ("saxofón alto", "saxofón altu"),
        "saxofón tenor": ("saxofón tenor", "saxofón tenor"),
        "saxofón barítono": ("saxofón barítono", "saxofón barítonu"),
        "trompeta en si♭": ("trompeta en si♭", "trompeta en si♭"),
        "trompeta en do": ("trompeta en do", "trompeta en do"),
        "fliscorno": ("fliscorno", "fliscornu"),
        "trompa en fa": ("trompa en fa", "trompa en fa"),
        "trombón": ("trombón", "trombón"),
        "tuba": ("tuba", "tuba"),
        "violín": ("violín", "violín"),
        "viola": ("viola", "viola"),
        "violonchelo": ("violonchelo", "violonchelu"),
        "contrabajo": ("contrabaixo", "contrabaxu"),
        "guitarra": ("guitarra", "guitarra"),
        "bajo eléctrico": ("baixo electrico", "baxu llétricu"),
        "xilófono": ("xilófono", "xilófonu"),
        "glockenspiel": ("glockenspiel", "glockenspiel"),
        "celesta": ("celesta", "celesta"),
    ]

    /// Portugués, francés e italiano de los instrumentos predefinidos, por su nombre en español. Un
    /// instrumento que no está aquí usa su nombre español.
    package static let nombresRomanicos: [String: (portugues: String, frances: String, italiano: String)] = [
        "piano": ("piano", "piano", "pianoforte"),
        "flauta": ("flauta", "flûte", "flauto"),
        "flautín": ("flautim", "piccolo", "ottavino"),
        "flauta en sol": ("flauta em sol", "flûte en sol", "flauto contralto"),
        "oboe": ("oboé", "hautbois", "oboe"),
        "corno inglés": ("corne-inglês", "cor anglais", "corno inglese"),
        "clarinete en si♭": ("clarinete em si♭", "clarinette en si♭", "clarinetto in si♭"),
        "clarinete en la": ("clarinete em lá", "clarinette en la", "clarinetto in la"),
        "clarinete en mi♭": ("clarinete em mi♭", "clarinette en mi♭", "clarinetto in mi♭"),
        "clarinete bajo": ("clarinete baixo", "clarinette basse", "clarinetto basso"),
        "fagot": ("fagote", "basson", "fagotto"),
        "saxofón soprano": ("saxofone soprano", "saxophone soprano", "sassofono soprano"),
        "saxofón alto": ("saxofone alto", "saxophone alto", "sassofono contralto"),
        "saxofón tenor": ("saxofone tenor", "saxophone ténor", "sassofono tenore"),
        "saxofón barítono": ("saxofone barítono", "saxophone baryton", "sassofono baritono"),
        "trompeta en si♭": ("trompete em si♭", "trompette en si♭", "tromba in si♭"),
        "trompeta en do": ("trompete em dó", "trompette en ut", "tromba in do"),
        "fliscorno": ("fliscórnio", "bugle", "flicorno"),
        "trompa en fa": ("trompa em fá", "cor en fa", "corno in fa"),
        "trombón": ("trombone", "trombone", "trombone"),
        "tuba": ("tuba", "tuba", "tuba"),
        "violín": ("violino", "violon", "violino"),
        "viola": ("viola", "alto", "viola"),
        "violonchelo": ("violoncelo", "violoncelle", "violoncello"),
        "contrabajo": ("contrabaixo", "contrebasse", "contrabbasso"),
        "guitarra": ("guitarra", "guitare", "chitarra"),
        "bajo eléctrico": ("baixo elétrico", "basse électrique", "basso elettrico"),
        "xilófono": ("xilofone", "xylophone", "xilofono"),
        "glockenspiel": ("glockenspiel", "glockenspiel", "glockenspiel"),
        "celesta": ("celesta", "célesta", "celesta"),
    ]

    /// Alemán, occitano, griego y ruso de los instrumentos predefinidos, por su nombre en español. Un
    /// instrumento que no está aquí usa su nombre inglés. En alemán y en ruso, la afinación va con letras
    /// alemanas: «Klarinette in B» es el clarinete en si♭.
    package static let nombresDeOtrasLenguas: [String: (aleman: String, occitano: String, ruso: String, griego: String)] = [
        "piano": ("Klavier", "piano", "фортепиано", "πιάνο"),
        "flauta": ("Flöte", "flaüta", "флейта", "φλάουτο"),
        "flautín": ("Piccoloflöte", "flautin", "флейта-пикколо", "πίκολο"),
        "flauta en sol": ("Altflöte in G", "flaüta en sòl", "альтовая флейта", "φλάουτο άλτο σε σολ"),
        "oboe": ("Oboe", "oboè", "гобой", "όμποε"),
        "corno inglés": ("Englischhorn", "còrn anglés", "английский рожок", "αγγλικό κόρνο"),
        "clarinete en si♭": ("Klarinette in B", "clarinet en si♭", "кларнет in B", "κλαρινέτο σε σι♭"),
        "clarinete en la": ("Klarinette in A", "clarinet en la", "кларнет in A", "κλαρινέτο σε λα"),
        "clarinete en mi♭": ("Klarinette in Es", "clarinet en mi♭", "кларнет in Es", "κλαρινέτο σε μι♭"),
        "clarinete bajo": ("Bassklarinette", "clarinet bas", "бас-кларнет", "μπάσο κλαρινέτο"),
        "fagot": ("Fagott", "fagòt", "фагот", "φαγκότο"),
        "saxofón soprano": ("Sopransaxophon", "saxofòn soprano", "саксофон-сопрано", "σαξόφωνο σοπράνο"),
        "saxofón alto": ("Altsaxophon", "saxofòn alt", "саксофон-альт", "σαξόφωνο άλτο"),
        "saxofón tenor": ("Tenorsaxophon", "saxofòn tenor", "саксофон-тенор", "σαξόφωνο τενόρο"),
        "saxofón barítono": ("Baritonsaxophon", "saxofòn bariton", "саксофон-баритон", "σαξόφωνο βαρύτονο"),
        "trompeta en si♭": ("Trompete in B", "trompeta en si♭", "труба in B", "τρομπέτα σε σι♭"),
        "trompeta en do": ("Trompete in C", "trompeta en do", "труба in C", "τρομπέτα σε ντο"),
        "fliscorno": ("Flügelhorn", "flicòrn", "флюгельгорн", "φλικόρνο"),
        "trompa en fa": ("Horn in F", "còrn en fa", "валторна in F", "κόρνο σε φα"),
        "trombón": ("Posaune", "trombòn", "тромбон", "τρομπόνι"),
        "tuba": ("Tuba", "tuba", "туба", "τούμπα"),
        "violín": ("Violine", "violon", "скрипка", "βιολί"),
        "viola": ("Viola", "viòla", "альт", "βιόλα"),
        "violonchelo": ("Violoncello", "violoncèl", "виолончель", "βιολοντσέλο"),
        "contrabajo": ("Kontrabass", "contrabassa", "контрабас", "κοντραμπάσο"),
        "guitarra": ("Gitarre", "guitarra", "гитара", "κιθάρα"),
        "bajo eléctrico": ("E-Bass", "bassa electrica", "бас-гитара", "ηλεκτρικό μπάσο"),
        "xilófono": ("Xylophon", "xilofòn", "ксилофон", "ξυλόφωνο"),
        "glockenspiel": ("Glockenspiel", "glockenspiel", "колокольчики", "γκλόκενσπιλ"),
        "celesta": ("Celesta", "celèsta", "челеста", "τσελέστα"),
    ]
}
