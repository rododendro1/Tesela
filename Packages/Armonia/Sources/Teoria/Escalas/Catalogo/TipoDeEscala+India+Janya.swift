import Elementos

// MARK: - India: janya
//
// Los rāgas janya de la música carnática, derivados de un mēḷa (`TipoDeEscala+India.swift`).

extension TipoDeEscala {
    // MARK: Janya (rāgas derivados, música carnática)

    // Algunos rāgas janya muy habituales, con su ārohaṇa (subida) y avarohaṇa (bajada). Los vakra (los que suben o
    // bajan en zigzag) llevan además su recorrido, el orden en que se tocan los grados.

    public static let mohanam = TipoDeEscala(
        nombre: "Mohanam", intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        variantes: ["Mohana"],
        nombresOriginales: [
            .init("मोहनम्", .sanscrito), .init("మోహనం", .telugu), .init("ಮೋಹನಂ", .canares), .init("மோகனம்", .tamil),
        ],
        categoria: .janya, padre: .melakarta(28))
    public static let hindolam = TipoDeEscala(
        nombre: "Hindolam", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMenor, .septimaMenor],
        nombresOriginales: [
            .init("हिन्दोलम्", .sanscrito), .init("హిందోలం", .telugu), .init("ಹಿಂದೋಲಂ", .canares), .init("இந்தோளம்", .tamil),
        ],
        categoria: .janya, padre: .melakarta(20))
    /// Sa ri ma Pa ni (Do Re♭ Fa Sol Si♭).
    public static let revati = TipoDeEscala(
        nombre: "Revati", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        nombresOriginales: [.init("रेवति", .sanscrito), .init("రేవతి", .telugu), .init("ರೇವತಿ", .canares)],
        categoria: .janya)
    /// Sa Ga Ma Pa Ni (Do Mi Fa♯ Sol Si): como la pentatónica lidia.
    public static let amrtavarsini = TipoDeEscala(
        nombre: "Amṛtavarṣiṇī", intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .quintaJusta, .septimaMayor],
        variantes: ["Amritavarshini", "Amrutavarshini"],
        nombresOriginales: [
            .init("अमृतवर्षिणी", .sanscrito), .init("అమృతవర్షిణి", .telugu), .init("ಅಮೃತವರ್ಷಿಣಿ", .canares),
            .init("அமிர்தவர்ஷிணி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(65))
    public static let hamsadhvani = TipoDeEscala(
        nombre: "Haṃsadhvani", intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .septimaMayor],
        variantes: ["Hamsadhwani"],
        nombresOriginales: [
            .init("हंसध्वनि", .sanscrito), .init("హంసధ్వని", .telugu), .init("ಹಂಸಧ್ವನಿ", .canares), .init("ஹம்சத்வனி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(29))
    public static let abhogi = TipoDeEscala(
        nombre: "Ābhogi", intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .sextaMayor],
        nombresOriginales: [
            .init("आभोगि", .sanscrito), .init("ఆభోగి", .telugu), .init("ಆಭೋಗಿ", .canares), .init("ஆபோகி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(22))
    public static let madhyamavati = TipoDeEscala(
        nombre: "Madhyamāvatī", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        nombresOriginales: [
            .init("मध्यमावती", .sanscrito), .init("మధ్యమావతి", .telugu), .init("ಮಧ್ಯಮಾವತಿ", .canares), .init("மத்தியமாவதி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(22))
    public static let bilahari = TipoDeEscala(
        nombre: "Bilahari",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        nombresOriginales: [
            .init("बिलहरि", .sanscrito), .init("బిలహరి", .telugu), .init("ಬಿಲಹರಿ", .canares), .init("பிலகரி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(29))
    public static let kambhoji = TipoDeEscala(
        nombre: "Kāmbhoji",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Kambodhi"],
        nombresOriginales: [
            .init("काम्भोजि", .sanscrito), .init("కాంభోజి", .telugu), .init("ಕಾಂಭೋಜಿ", .canares), .init("காம்போதி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(28))
    public static let arabhi = TipoDeEscala(
        nombre: "Ārabhi",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        nombresOriginales: [
            .init("आरभि", .sanscrito), .init("ఆరభి", .telugu), .init("ಆರಭಿ", .canares), .init("ஆரபி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(29))
    public static let kedaragaula = TipoDeEscala(
        nombre: "Kedāragauḷa",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Kedaragowla"],
        nombresOriginales: [
            .init("केदारगौळ", .sanscrito), .init("కేదారగౌళ", .telugu), .init("ಕೇದಾರಗೌಳ", .canares), .init("கேதாரகௌளை", .tamil),
        ],
        categoria: .janya, padre: .melakarta(28))
    /// Mohanakalyāṇi, del mēḷa 65 (Mecakalyāṇī): sube como Mohanam (Sa Ri₂ Ga₃ Pa Dha₂) y baja con las siete notas,
    /// con Ma₂ (Do Si La Sol Fa♯ Mi Re).
    public static let mohanakalyani = TipoDeEscala(
        nombre: "Mohanakalyāṇi",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        nombresOriginales: [
            .init("मोहनकल्याणि", .sanscrito), .init("మోహనకల్యాణి", .telugu), .init("ಮೋಹನಕಲ್ಯಾಣಿ", .canares), .init("மோகனகல்யாணி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(65))
    /// Sāveri, del mēḷa 15 (Māyāmālavagauḷa): sube Sa Ri₁ Ma₁ Pa Dha₁ y baja con las siete notas (Do Si La♭ Sol Fa
    /// Mi Re♭).
    public static let saveri = TipoDeEscala(
        nombre: "Sāveri",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .sextaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [
            .init("सावेरि", .sanscrito), .init("సావేరి", .telugu), .init("ಸಾವೇರಿ", .canares), .init("சாவேரி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(15))
    /// Nāṭa, del mēḷa 36 (Calanāṭa): sube Sa Ri₃ Ga₃ Ma₁ Pa Dha₃ Ni₃ (Do Re♯ Mi Fa Sol La♯ Si) y baja sin Ga ni Dha.
    public static let nata = TipoDeEscala(
        nombre: "Nāṭa",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaAumentada, .septimaMayor,
        ],
        intervalosDescendentes: [.unisono, .segundaAumentada, .cuartaJusta, .quintaJusta, .septimaMayor],
        variantes: ["Nattai"],
        nombresOriginales: [
            .init("नाट", .sanscrito), .init("నాట", .telugu), .init("ನಾಟ", .canares), .init("நாட்டை", .tamil),
        ],
        categoria: .janya, padre: .melakarta(36))

    /// Śuddha Sāveri, del mēḷa 29 (Dhīraśaṅkarābharaṇam): Sa Ri₂ Ma₁ Pa Dha₂ (Do Re Fa Sol La), la Durgā indostánica.
    public static let suddhaSaveri = TipoDeEscala(
        nombre: "Śuddha Sāveri", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        variantes: ["Shuddha Saveri"],
        nombresOriginales: [
            .init("शुद्ध सावेरि", .sanscrito), .init("శుద్ధ సావేరి", .telugu), .init("ಶುದ್ಧ ಸಾವೇರಿ", .canares), .init("சுத்தசாவேரி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(29))
    /// Śuddha Dhanyāsi, del mēḷa 22 (Kharaharapriyā): Sa Ga₂ Ma₁ Pa Ni₂ (Do Mi♭ Fa Sol Si♭), la pentatónica menor.
    public static let suddhaDhanyasi = TipoDeEscala(
        nombre: "Śuddha Dhanyāsi", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        variantes: ["Shuddha Dhanyasi"],
        nombresOriginales: [.init("शुद्ध धन्यासि", .sanscrito), .init("శుద్ధ ధన్యాసి", .telugu), .init("ಶುದ್ಧ ಧನ್ಯಾಸಿ", .canares)],
        categoria: .janya, padre: .melakarta(22))
    /// Śrīrañjani, del mēḷa 22 (Kharaharapriyā): Sa Ri₂ Ga₂ Ma₁ Dha₂ Ni₂ (Do Re Mi♭ Fa La Si♭), sin Pa.
    public static let sriranjani = TipoDeEscala(
        nombre: "Śrīrañjani",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Shriranjani"],
        nombresOriginales: [
            .init("श्रीरञ्जनि", .sanscrito), .init("శ్రీరంజని", .telugu), .init("ಶ್ರೀರಂಜನಿ", .canares), .init("சிறீரஞ்சனி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(22))
    /// Mālayamārutam, del mēḷa 16 (Cakravākam): Sa Ri₁ Ga₃ Pa Dha₂ Ni₂ (Do Re♭ Mi Sol La Si♭), sin Ma.
    public static let malayamarutam = TipoDeEscala(
        nombre: "Mālayamārutam",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Malayamarutham"],
        nombresOriginales: [
            .init("मलयमारुतम्", .sanscrito), .init("మలయమారుతం", .telugu), .init("ಮಲಯಮಾರುತಂ", .canares), .init("மலயமாருதம்", .tamil),
        ],
        categoria: .janya, padre: .melakarta(16))
    /// Gambhīranāṭa, del mēḷa 36 (Calanāṭa): Sa Ga₃ Ma₁ Pa Ni₃ (Do Mi Fa Sol Si).
    public static let gambhiranata = TipoDeEscala(
        nombre: "Gambhīranāṭa", intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        variantes: ["Gambheera Nattai"],
        nombresOriginales: [
            .init("गम्भीरनाट", .sanscrito), .init("గంభీరనాట", .telugu), .init("ಗಂಭೀರನಾಟ", .canares), .init("கம்பீரநாட்டை", .tamil),
        ],
        categoria: .janya, padre: .melakarta(36))
    /// Haṃsanādam, del mēḷa 60 (Nītimati): Sa Ri₂ Ma₂ Pa Ni₃ (Do Re Fa♯ Sol Si).
    public static let hamsanadam = TipoDeEscala(
        nombre: "Haṃsanādam", intervalos: [.unisono, .segundaMayor, .cuartaAumentada, .quintaJusta, .septimaMayor],
        nombresOriginales: [.init("हंसनादम्", .sanscrito), .init("హంసనాదం", .telugu), .init("ಹಂಸನಾದಂ", .canares)],
        categoria: .janya, padre: .melakarta(60))

    // Doce más, con el ārohaṇa, el avarohaṇa y el mēḷa de la Wikipedia en inglés (noviembre de 2026). Bauḷi va sin
    // `padre` porque su artículo no lo nombra.

    /// Haṃsānandi, del mēḷa 53 (Gamanaśrama): Sa Ri₁ Ga₃ Ma₂ Dha₂ Ni₃ (Do Re♭ Mi Fa♯ La Si), sin Pa.
    public static let hamsanandi = TipoDeEscala(
        nombre: "Haṃsānandi",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaAumentada, .sextaMayor, .septimaMayor],
        nombresOriginales: [
            .init("हंसानन्दि", .sanscrito), .init("హంసానంది", .telugu), .init("ಹಂಸಾನಂದಿ", .canares), .init("ஹம்சானந்தி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(53))
    /// Kalyāṇavasantam, del mēḷa 21 (Kīravāṇī): sube Sa Ga₂ Ma₁ Dha₁ Ni₃ (Do Mi♭ Fa La♭ Si) y baja con las siete notas.
    public static let kalyanavasantam = TipoDeEscala(
        nombre: "Kalyāṇavasantam",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMenor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["Kalyana Vasantham"],
        nombresOriginales: [
            .init("कल्याणवसन्तम्", .sanscrito), .init("కల్యాణవసంతం", .telugu), .init("ಕಲ್ಯಾಣವಸಂತಂ", .canares),
            .init("கல்யாணவசந்தம்", .tamil),
        ],
        categoria: .janya, padre: .melakarta(21))
    /// Bhūpālam, del mēḷa 45 (Śubhapantuvarāḷi): Sa Ri₁ Ga₂ Pa Dha₁ (Do Re♭ Mi♭ Sol La♭).
    public static let bhupalam = TipoDeEscala(
        nombre: "Bhūpālam", intervalos: [.unisono, .segundaMenor, .terceraMenor, .quintaJusta, .sextaMenor],
        nombresOriginales: [.init("भूपालम्", .sanscrito), .init("భూపాలం", .telugu), .init("ಭೂಪಾಲಂ", .canares)],
        categoria: .janya, padre: .melakarta(45))
    /// Revagupti, del mēḷa 15 (Māyāmālavagauḷa): Sa Ri₁ Ga₃ Pa Dha₁ (Do Re♭ Mi Sol La♭).
    public static let revagupti = TipoDeEscala(
        nombre: "Revagupti", intervalos: [.unisono, .segundaMenor, .terceraMayor, .quintaJusta, .sextaMenor],
        nombresOriginales: [
            .init("रेवगुप्ति", .sanscrito), .init("రేవగుప్తి", .telugu), .init("ರೇವಗುಪ್ತಿ", .canares), .init("ரேவகுப்தி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(15))
    /// Bauḷi: sube como Revagupti (Sa Ri₁ Ga₃ Pa Dha₁) y baja con Ni₃ (Do Si La♭ Sol Mi Re♭).
    public static let bauli = TipoDeEscala(
        nombre: "Bauḷi",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .quintaJusta, .sextaMenor],
        intervalosDescendentes: [.unisono, .segundaMenor, .terceraMayor, .quintaJusta, .sextaMenor, .septimaMayor],
        variantes: ["Bowli"],
        nombresOriginales: [.init("बौळि", .sanscrito), .init("బౌళి", .telugu), .init("ಬೌಳಿ", .canares)],
        categoria: .janya)
    /// Lalitā, del mēḷa 15 (Māyāmālavagauḷa): Sa Ri₁ Ga₃ Ma₁ Dha₁ Ni₃ (Do Re♭ Mi Fa La♭ Si), sin Pa.
    public static let lalita = TipoDeEscala(
        nombre: "Lalitā",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .sextaMenor, .septimaMayor],
        variantes: ["Lalitha"],
        nombresOriginales: [.init("ललिता", .sanscrito), .init("లలిత", .telugu), .init("ಲಲಿತ", .canares)],
        categoria: .janya, padre: .melakarta(15))
    /// Megharañjani, del mēḷa 15 (Māyāmālavagauḷa): Sa Ri₁ Ga₃ Ma₁ Ni₃ (Do Re♭ Mi Fa Si).
    public static let megharanjani = TipoDeEscala(
        nombre: "Megharañjani", intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .septimaMayor],
        nombresOriginales: [.init("मेघरञ्जनि", .sanscrito), .init("మేఘరంజని", .telugu), .init("ಮೇಘರಂಜನಿ", .canares)],
        categoria: .janya, padre: .melakarta(15))
    /// Dhanyāsi, del mēḷa 8 (Hanumatoḍi): sube Sa Ga₂ Ma₁ Pa Ni₂ (Do Mi♭ Fa Sol Si♭) y baja con las siete notas. La
    /// escuela de Dīkṣitar la pone en el mēḷa 20, con Ri₂ al bajar.
    public static let dhanyasi = TipoDeEscala(
        nombre: "Dhanyāsi",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        nombresOriginales: [.init("धन्यासि", .sanscrito), .init("ధన్యాసి", .telugu), .init("ಧನ್ಯಾಸಿ", .canares)],
        categoria: .janya, padre: .melakarta(8))
    /// Ābheri, del mēḷa 22 (Kharaharapriyā): sube Sa Ga₂ Ma₁ Pa Ni₂ (Do Mi♭ Fa Sol Si♭) y baja con las siete notas.
    public static let abheri = TipoDeEscala(
        nombre: "Ābheri",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        nombresOriginales: [
            .init("आभेरि", .sanscrito), .init("ఆభేరి", .telugu), .init("ಆಭೇರಿ", .canares), .init("ஆபேரி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(22))
    /// Maṇiraṅgu, del mēḷa 22 (Kharaharapriyā): sube Sa Ri₂ Ma₁ Pa Ni₂ (Do Re Fa Sol Si♭) y baja con Ga₂.
    public static let manirangu = TipoDeEscala(
        nombre: "Maṇiraṅgu",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        nombresOriginales: [.init("मणिरङ्गु", .sanscrito), .init("మణిరంగు", .telugu), .init("ಮಣಿರಂಗು", .canares)],
        categoria: .janya, padre: .melakarta(22))
    /// Nāgasvarāvaḷi, del mēḷa 28 (Harikāmbhoji): Sa Ga₃ Ma₁ Pa Dha₂ (Do Mi Fa Sol La).
    public static let nagasvaravali = TipoDeEscala(
        nombre: "Nāgasvarāvaḷi", intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        variantes: ["Nagaswaravali"],
        nombresOriginales: [
            .init("नागस्वरावळि", .sanscrito), .init("నాగస్వరావళి", .telugu), .init("ನಾಗಸ್ವರಾವಳಿ", .canares), .init("நாகஸ்வராவளி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(28))
    /// Sunādavinodinī, del mēḷa 53 (Gamanaśrama): Sa Ga₃ Ma₂ Dha₂ Ni₃ (Do Mi Fa♯ La Si), como el Hindol indostánico.
    public static let sunadavinodini = TipoDeEscala(
        nombre: "Sunādavinodinī",
        intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .sextaMayor, .septimaMayor],
        nombresOriginales: [
            .init("सुनादविनोदिनी", .sanscrito), .init("సునాదవినోదిని", .telugu), .init("ಸುನಾದವಿನೋದಿನಿ", .canares),
            .init("சுநாதவினோதினி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(53))

    // Siete más, de la misma fuente; Jaganmohini, Rasikarañjani y Śuddha Hindolam, de su «List of Janya ragas».

    /// Āndolikā, del mēḷa 22 (Kharaharapriyā): sube Sa Ri₂ Ma₁ Pa Ni₂ (Do Re Fa Sol Si♭) y baja sin Pa, con Dha₂.
    public static let andolika = TipoDeEscala(
        nombre: "Āndolikā",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [.unisono, .segundaMayor, .cuartaJusta, .sextaMayor, .septimaMenor],
        nombresOriginales: [
            .init("आन्दोलिका", .sanscrito), .init("ఆందోలిక", .telugu), .init("ಆಂದೋಲಿಕ", .canares),
            .init("ஆந்தோளிகா", .tamil),
        ],
        categoria: .janya, padre: .melakarta(22))
    /// Garuḍadhvani, del mēḷa 29 (Dhīraśaṅkarābharaṇam): sube con las siete notas y baja como Mohanam.
    public static let garudadhvani = TipoDeEscala(
        nombre: "Garuḍadhvani",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        intervalosDescendentes: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        nombresOriginales: [
            .init("गरुडध्वनि", .sanscrito), .init("గరుడధ్వని", .telugu), .init("ಗರುಡಧ್ವನಿ", .canares),
            .init("கருடத்வனி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(29))
    /// Bahudāri, del mēḷa 28 (Harikāmbhoji): sube Sa Ga₃ Ma₁ Pa Dha₂ Ni₂ (Do Mi Fa Sol La Si♭) y baja sin Dha.
    public static let bahudari = TipoDeEscala(
        nombre: "Bahudāri",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        nombresOriginales: [
            .init("बहुदारि", .sanscrito), .init("బహుదారి", .telugu), .init("ಬಹುದಾರಿ", .canares),
            .init("பகுதாரி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(28))
    /// Sālagabhairavi, del mēḷa 22 (Kharaharapriyā): sube Sa Ri₂ Ma₁ Pa Dha₂ (Do Re Fa Sol La) y baja con las siete.
    public static let salagabhairavi = TipoDeEscala(
        nombre: "Sālagabhairavi",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Salaga Bhairavi"],
        nombresOriginales: [
            .init("सालगभैरवि", .sanscrito), .init("సాలగభైరవి", .telugu), .init("ಸಾಲಗಭೈರವಿ", .canares),
            .init("சாலகபைரவி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(22))
    /// Jaganmohini, del mēḷa 15 (Māyāmālavagauḷa): sube Sa Ga₃ Ma₁ Pa Ni₃ (Do Mi Fa Sol Si) y baja con Ri₁.
    public static let jaganmohini = TipoDeEscala(
        nombre: "Jaganmohini",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        nombresOriginales: [
            .init("जगन्मोहिनि", .sanscrito), .init("జగన్మోహిని", .telugu), .init("ಜಗನ್ಮೋಹಿನಿ", .canares),
        ],
        categoria: .janya, padre: .melakarta(15))
    /// Rasikarañjani, del mēḷa 16 (Cakravākam): sube Sa Ri₁ Ga₃ Pa (Do Re♭ Mi Sol) y baja con Dha₂.
    public static let rasikaranjani = TipoDeEscala(
        nombre: "Rasikarañjani",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .quintaJusta],
        intervalosDescendentes: [.unisono, .segundaMenor, .terceraMayor, .quintaJusta, .sextaMayor],
        nombresOriginales: [
            .init("रसिकरञ्जनि", .sanscrito), .init("రసికరంజని", .telugu), .init("ರಸಿಕರಂಜನಿ", .canares),
        ],
        categoria: .janya, padre: .melakarta(16))
    /// Śuddha Hindolam, del mēḷa 22 (Kharaharapriyā): Sa Ga₂ Ma₁ Dha₂ Ni₂ (Do Mi♭ Fa La Si♭).
    public static let suddhaHindolam = TipoDeEscala(
        nombre: "Śuddha Hindolam",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMayor, .septimaMenor],
        alias: ["Varamu"], variantes: ["Shuddha Hindolam"],
        nombresOriginales: [
            .init("शुद्ध हिन्दोलम्", .sanscrito), .init("శుద్ధ హిందోలం", .telugu), .init("ಶುದ್ಧ ಹಿಂದೋಲಂ", .canares),
        ],
        categoria: .janya, padre: .melakarta(22))

    // Veintitrés vakra, que suben o bajan en zigzag y llevan su recorrido (`recorrido`, `recorridoDescendente`).
    // Nalinakānti y Kathanakutūhalam son de la Wikipedia en inglés (artículo «Janya»); el resto, de karnATik:
    // Bēgaḍa, Sahānā y Rītigauḷa porque sus artículos dan escalas distintas en distintos sitios, Darbārī Kānaḍa
    // carnática, que sube desde el ni de abajo (el grado 0 del recorrido), y los diez del final. Los bhāṣāṅga
    // llevan las notas que no son de su mēḷa en `notasExternas`.

    /// Ānandabhairavi, del mēḷa 22 (Kharaharapriyā): sube Sa ga Re ga ma Pa Dha Pa Ṡa (sin ni) y baja recto con las
    /// siete. Es bhāṣāṅga: en sus frases entran el Ga₃, el Dha₁ y el Ni₃ (`notasExternas`), que la escala no recoge.
    public static let anandabhairavi = TipoDeEscala(
        nombre: "Ānandabhairavi",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        recorrido: [1, 3, 2, 3, 4, 5, 6, 5, 7],
        nombresOriginales: [
            .init("आनन्दभैरवि", .sanscrito), .init("ఆనందభైరవి", .telugu), .init("ಆನಂದಭೈರವಿ", .canares),
            .init("ஆனந்தபைரவி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(22), notasExternas: [.terceraMayor, .sextaMenor, .septimaMayor])
    /// Suruṭṭi, del mēḷa 28 (Harikāmbhojī): sube Sa Re ma Pa ni Dha ni Ṡa (sin Ga) y baja Ṡa ni Dha Pa ma Ga Pa ma
    /// Re Sa.
    public static let surutti = TipoDeEscala(
        nombre: "Suruṭṭi",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        recorrido: [1, 2, 3, 4, 6, 5, 6, 7],
        recorridoDescendente: [8, 7, 6, 5, 4, 3, 5, 4, 2, 1],
        nombresOriginales: [.init("सुरुट्टि", .sanscrito), .init("సురుట్టి", .telugu), .init("ಸುರುಟ್ಟಿ", .canares)],
        categoria: .janya, padre: .melakarta(28))
    /// Aṭāṇā, del mēḷa 29 (Dhīraśaṅkarābharaṇam): sube recto Sa Re ma Pa Ni Ṡa y baja Ṡa Ni Dha Pa ma Pa Ga Re Sa.
    public static let atana = TipoDeEscala(
        nombre: "Aṭāṇā",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        recorridoDescendente: [8, 7, 6, 5, 4, 5, 3, 2, 1],
        nombresOriginales: [
            .init("अटाणा", .sanscrito), .init("అటాణ", .telugu), .init("ಅಟಾಣ", .canares), .init("அடாணா", .tamil),
        ],
        categoria: .janya, padre: .melakarta(29))
    /// Kēdāram, del mēḷa 29 (Dhīraśaṅkarābharaṇam): sube Sa ma Ga ma Pa Ni Ṡa (sin Re ni Dha) y baja recto Ṡa Ni Pa
    /// ma Ga Re Sa.
    public static let kedaram = TipoDeEscala(
        nombre: "Kēdāram",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        recorrido: [1, 3, 2, 3, 4, 5, 6],
        nombresOriginales: [
            .init("केदारम्", .sanscrito), .init("కేదారం", .telugu), .init("ಕೇದಾರಂ", .canares),
            .init("கேதாரம்", .tamil),
        ],
        categoria: .janya, padre: .melakarta(29))
    /// Darbār, del mēḷa 22 (Kharaharapriyā): sube recto Sa Re ma Pa Dha ni Ṡa (sin ga) y baja Ṡa ni Dha Pa ma Re ga
    /// ga Re Sa.
    public static let darbar = TipoDeEscala(
        nombre: "Darbār",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        recorridoDescendente: [8, 7, 6, 5, 4, 2, 3, 3, 2, 1],
        nombresOriginales: [
            .init("दर्बार्", .sanscrito), .init("దర్బార్", .telugu), .init("ದರ್ಬಾರ್", .canares),
            .init("தர்பார்", .tamil),
        ],
        categoria: .janya, padre: .melakarta(22))
    /// Mukhāri, del mēḷa 22 (Kharaharapriyā): sube Sa Re ma Pa ni Dha Ṡa (sin ga) y baja recto Ṡa ni dha Pa ma ga Re
    /// Sa, con el dha₁, que Kharaharapriyā no tiene (`notasExternas`).
    public static let mukhari = TipoDeEscala(
        nombre: "Mukhāri",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        recorrido: [1, 2, 3, 4, 6, 5, 7],
        nombresOriginales: [
            .init("मुखारि", .sanscrito), .init("ముఖారి", .telugu), .init("ಮುಖಾರಿ", .canares),
            .init("முகாரி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(22), notasExternas: [.sextaMenor])
    /// Gauḷa, del mēḷa 15 (Māyāmālavagauḷa): sube recto Sa re ma Pa Ni Ṡa y baja Ṡa Ni Pa ma re Ga ma re Sa.
    public static let gaula = TipoDeEscala(
        nombre: "Gauḷa",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        variantes: ["Gowla"],
        recorridoDescendente: [7, 6, 5, 4, 2, 3, 4, 2, 1],
        nombresOriginales: [
            .init("गौळ", .sanscrito), .init("గౌళ", .telugu), .init("ಗೌಳ", .canares), .init("கௌளை", .tamil),
        ],
        categoria: .janya, padre: .melakarta(15))
    /// Nalinakānti: sube Sa Ga Re ma Pa Ni Ṡa y baja recto Ṡa Ni Pa ma Ga Re Sa (sin Dha). Sin `padre`: la fuente no
    /// lo da, y sin Dha las notas caben en los mēḷa 27 y 29.
    public static let nalinakanti = TipoDeEscala(
        nombre: "Nalinakānti",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        recorrido: [1, 3, 2, 4, 5, 6, 7],
        nombresOriginales: [
            .init("नलिनकान्ति", .sanscrito), .init("నలినకాంతి", .telugu), .init("ನಲಿನಕಾಂತಿ", .canares),
        ],
        categoria: .janya)
    /// Kathanakutūhalam, con las siete notas del mēḷa 29 (Dhīraśaṅkarābharaṇam): sube Sa Re ma Dha Ni Ga Pa Ṡa y baja
    /// recto.
    public static let kathanakutuhalam = TipoDeEscala(
        nombre: "Kathanakutūhalam",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["Kathanakuthuhalam"],
        recorrido: [1, 2, 4, 6, 7, 3, 5, 8],
        nombresOriginales: [
            .init("कथनकुतूहलम्", .sanscrito), .init("కథనకుతూహలం", .telugu), .init("ಕಥನಕುತೂಹಲಂ", .canares),
            .init("கதனகுதூகலம்", .tamil),
        ],
        categoria: .janya, padre: .melakarta(29))
    /// Bēgaḍa, del mēḷa 29 (Dhīraśaṅkarābharaṇam): sube Sa Ga Re Ga ma Pa Dha ni Dha Pa Ṡa, con el ni₂ que el mēḷa no
    /// tiene (`notasExternas`), y baja recto Ṡa Ni Dha Pa ma Ga Re Sa.
    public static let begada = TipoDeEscala(
        nombre: "Bēgaḍa",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        recorrido: [1, 3, 2, 3, 4, 5, 6, 7, 6, 5, 8],
        nombresOriginales: [.init("बेगड", .sanscrito), .init("బేగడ", .telugu), .init("ಬೇಗಡ", .canares)],
        categoria: .janya, padre: .melakarta(29), notasExternas: [.septimaMenor], referencias: [.karnatik])
    /// Sahānā, del mēḷa 28 (Harikāmbhojī), con sus siete notas: sube Sa Re Ga ma Pa ma Dha ni Ṡa y baja Ṡa ni Ṡa Dha
    /// ni Dha Pa ma Ga ma Re Ga Re Sa.
    public static let sahana = TipoDeEscala(
        nombre: "Sahānā",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        recorrido: [1, 2, 3, 4, 5, 4, 6, 7, 8],
        recorridoDescendente: [8, 7, 8, 6, 7, 6, 5, 4, 3, 4, 2, 3, 2, 1],
        nombresOriginales: [
            .init("सहाना", .sanscrito), .init("సహాన", .telugu), .init("ಸಹಾನ", .canares), .init("சகானா", .tamil),
        ],
        categoria: .janya, padre: .melakarta(28), referencias: [.karnatik])
    /// Rītigauḷa, del mēḷa 22 (Kharaharapriyā): sube sin Pa, Sa ga Re ga ma ni Dha ma ni ni Ṡa, y baja Ṡa ni Dha ma
    /// ga ma Pa ma ga Re Sa.
    public static let ritigaula = TipoDeEscala(
        nombre: "Rītigauḷa",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Reethigowla"],
        recorrido: [1, 3, 2, 3, 4, 6, 5, 4, 6, 6, 7],
        recorridoDescendente: [8, 7, 6, 4, 3, 4, 5, 4, 3, 2, 1],
        nombresOriginales: [
            .init("रीतिगौळ", .sanscrito), .init("రీతిగౌళ", .telugu), .init("ರೀತಿಗೌಳ", .canares),
        ],
        categoria: .janya, padre: .melakarta(22), referencias: [.karnatik])

    /// Darbārī Kānaḍa carnática, del mēḷa 20 (Naṭabhairavi): sube desde el ni de abajo, ni Sa Re ga Re Sa ma Pa dha
    /// ni Ṡa, y baja Ṡa dha ni Pa ma Pa ga ma Re Sa. Se llama así para no confundirse con la indostánica, que va
    /// recta y es del thāṭ Āsāvarī.
    public static let darbariKanadaCarnatica = TipoDeEscala(
        nombre: "Darbārī Kānaḍa carnática",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        recorrido: [0, 1, 2, 3, 2, 1, 4, 5, 6, 7, 8],
        recorridoDescendente: [8, 6, 7, 5, 4, 5, 3, 4, 2, 1],
        nombresOriginales: [
            .init("दर्बारी कानड", .sanscrito), .init("దర్బారీ కానడ", .telugu), .init("ದರ್ಬಾರೀ ಕಾನಡ", .canares),
        ],
        categoria: .janya, padre: .melakarta(20), referencias: [.karnatik])

    // Dos bhāṣāṅga que suben y bajan rectos, con las notas que no son de su mēḷa en `notasExternas`.

    /// Dēvagāndhāri, del mēḷa 29 (Dhīraśaṅkarābharaṇam): sube Sa Re ma Pa Dha Ṡa y baja recto con las siete. En
    /// algunas frases entra el ni₂ (`notasExternas`), que la Wikipedia escribe en la bajada (Ṡa Ni Dha ni Dha Pa…) y
    /// karnATik no.
    public static let devagandhari = TipoDeEscala(
        nombre: "Dēvagāndhāri",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        nombresOriginales: [
            .init("देवगान्धारि", .sanscrito), .init("దేవగాంధారి", .telugu), .init("ದೇವಗಾಂಧಾರಿ", .canares),
            .init("தேவகாந்தாரி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(29), notasExternas: [.septimaMenor], referencias: [.karnatik])
    /// Bhairavi carnática, del mēḷa 20 (Naṭabhairavi): sube Sa Re ga ma Pa Dha ni Ṡa, con el Dha₂ que el mēḷa no
    /// tiene (`notasExternas`), y baja Ṡa ni dha Pa ma ga Re Sa. Se llama así para no confundirse con el thāṭ
    /// Bhairavī, que es indostánico.
    public static let bhairaviCarnatica = TipoDeEscala(
        nombre: "Bhairavi carnática",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        nombresOriginales: [
            .init("भैरवि", .sanscrito), .init("భైరవి", .telugu), .init("ಭೈರವಿ", .canares), .init("பைரவி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(20), notasExternas: [.sextaMayor], referencias: [.karnatik])

    /// Kāpi, bhāṣāṅga del mēḷa 22 (Kharaharapriyā): sube recto Sa Re ma Pa Ni Ṡa, con el Ni₃ que el mēḷa no tiene
    /// (`notasExternas`), y baja Ṡa ni Dha ni Pa ma ga Re Sa.
    public static let kapi = TipoDeEscala(
        nombre: "Kāpi",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        recorridoDescendente: [8, 7, 6, 7, 5, 4, 3, 2, 1],
        nombresOriginales: [
            .init("कापि", .sanscrito), .init("కాపి", .telugu), .init("ಕಾಪಿ", .canares), .init("காபி", .tamil),
        ],
        categoria: .janya, padre: .melakarta(22), notasExternas: [.septimaMayor], referencias: [.karnatik])
    /// Kānaḍa, del mēḷa 22 (Kharaharapriyā): sube recto Sa Re ga ma Dha ni Ṡa, sin Pa, y baja Ṡa ni Pa ma ga ma Re
    /// Sa, sin Dha. La fuente escribe el Dha sin número; es el Dha₂ del mēḷa.
    public static let kanada = TipoDeEscala(
        nombre: "Kānaḍa",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor,
        ],
        recorridoDescendente: [7, 6, 5, 4, 3, 4, 2, 1],
        nombresOriginales: [.init("कानड", .sanscrito), .init("కానడ", .telugu), .init("ಕಾನಡ", .canares)],
        categoria: .janya, padre: .melakarta(22), referencias: [.karnatik])
    /// Nīlāmbari, del mēḷa 29 (Dhīraśaṅkarābharaṇam): sube Sa Re Ga ma Pa Dha Pa Ni Ṡa y baja Ṡa Ni Pa ma Ga Re Ga
    /// Sa, sin Dha.
    public static let nilambari = TipoDeEscala(
        nombre: "Nīlāmbari",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor,
        ],
        recorrido: [1, 2, 3, 4, 5, 6, 5, 7, 8],
        recorridoDescendente: [7, 6, 5, 4, 3, 2, 3, 1],
        nombresOriginales: [
            .init("नीलाम्बरि", .sanscrito), .init("నీలాంబరి", .telugu), .init("ನೀಲಾಂಬರಿ", .canares),
        ],
        categoria: .janya, padre: .melakarta(29), referencias: [.karnatik])
    /// Nāyaki, del mēḷa 22 (Kharaharapriyā): sube Sa Re ma Pa Dha ni Dha Pa Ṡa, sin ga, y baja Ṡa ni Dha Pa ma Re ga
    /// Re Sa.
    public static let nayaki = TipoDeEscala(
        nombre: "Nāyaki",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        recorrido: [1, 2, 3, 4, 5, 6, 5, 4, 7],
        recorridoDescendente: [8, 7, 6, 5, 4, 2, 3, 2, 1],
        nombresOriginales: [.init("नायकि", .sanscrito), .init("నాయకి", .telugu), .init("ನಾಯಕಿ", .canares)],
        categoria: .janya, padre: .melakarta(22), referencias: [.karnatik])
    /// Sāraṅga, bhāṣāṅga del mēḷa 65 (Mēcakalyāṇi): sube recto con las siete notas del mēḷa y baja Ṡa Ni Dha Pa Ma
    /// Re Ga ma Re Sa, con el ma₁ que el mēḷa no tiene (`notasExternas`).
    public static let saranga = TipoDeEscala(
        nombre: "Sāraṅga",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .cuartaAumentada, .quintaJusta, .sextaMayor,
            .septimaMayor,
        ],
        recorridoDescendente: [9, 8, 7, 6, 5, 2, 3, 4, 2, 1],
        nombresOriginales: [.init("सारङ्ग", .sanscrito), .init("సారంగ", .telugu), .init("ಸಾರಂಗ", .canares)],
        categoria: .janya, padre: .melakarta(65), notasExternas: [.cuartaJusta], referencias: [.karnatik])
    /// Śrī carnática, del mēḷa 22 (Kharaharapriyā): sube recto Sa Re ma Pa ni Ṡa y baja Ṡa ni Pa Dha ni Pa ma Re ga
    /// Re Sa. Se llama así para no confundirse con el Śrī indostánico, que es del thāṭ Pūrvī.
    public static let sriCarnatica = TipoDeEscala(
        nombre: "Śrī carnática",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        recorridoDescendente: [8, 7, 5, 6, 7, 5, 4, 2, 3, 2, 1],
        nombresOriginales: [.init("श्री", .sanscrito), .init("శ్రీ", .telugu), .init("ಶ್ರೀ", .canares)],
        categoria: .janya, padre: .melakarta(22), referencias: [.karnatik])
    /// Hamīr Kalyāṇi, bhāṣāṅga del mēḷa 65 (Mēcakalyāṇi): sube Sa Pa Ma Pa Dha Ni Ṡa y baja Ṡa Ni Dha Pa Ma ma Ga Pa
    /// ma Re Sa, con el ma₁ que el mēḷa no tiene (`notasExternas`).
    public static let hamirKalyani = TipoDeEscala(
        nombre: "Hamīr Kalyāṇi",
        intervalos: [.unisono, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .cuartaAumentada, .quintaJusta, .sextaMayor,
            .septimaMayor,
        ],
        recorrido: [1, 3, 2, 3, 4, 5, 6],
        recorridoDescendente: [9, 8, 7, 6, 5, 4, 3, 6, 4, 2, 1],
        nombresOriginales: [
            .init("हमीर् कल्याणि", .sanscrito), .init("హమీర్ కల్యాణి", .telugu), .init("ಹಮೀರ್ ಕಲ್ಯಾಣಿ", .canares),
        ],
        categoria: .janya, padre: .melakarta(65), notasExternas: [.cuartaJusta], referencias: [.karnatik])
    /// Yamunā Kalyāṇi, del mēḷa 65 (Mēcakalyāṇi), sin Ni: sube Sa Re Ga Pa Ma Pa Dha Ṡa y baja Ṡa Dha Pa Ma Pa Ga Re
    /// Sa.
    public static let yamunaKalyani = TipoDeEscala(
        nombre: "Yamunā Kalyāṇi",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor],
        recorrido: [1, 2, 3, 5, 4, 5, 6, 7],
        recorridoDescendente: [7, 6, 5, 4, 5, 3, 2, 1],
        nombresOriginales: [
            .init("यमुना कल्याणि", .sanscrito), .init("యమునా కల్యాణి", .telugu), .init("ಯಮುನಾ ಕಲ್ಯಾಣಿ", .canares),
        ],
        categoria: .janya, padre: .melakarta(65), referencias: [.karnatik])
    /// Dēvamanōhari, del mēḷa 22 (Kharaharapriyā), sin ga: sube recto Sa Re ma Pa Dha ni Ṡa y baja Ṡa ni Dha ni Pa ma
    /// Re Sa.
    public static let devamanohari = TipoDeEscala(
        nombre: "Dēvamanōhari",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        recorridoDescendente: [7, 6, 5, 6, 4, 3, 2, 1],
        nombresOriginales: [
            .init("देवमनोहरि", .sanscrito), .init("దేవమనోహరి", .telugu), .init("ದೇವಮನೋಹರಿ", .canares),
        ],
        categoria: .janya, padre: .melakarta(22), referencias: [.karnatik])
    /// Behāg carnática, del mēḷa 29 (Dhīraśaṅkarābharaṇam): sube Sa Ga ma Pa Ni Dha Ni Ṡa, sin Re, y baja recto con
    /// las siete notas del mēḷa. Se llama así para no confundirse con el Bihāg indostánico, que también se escribe
    /// Behag.
    public static let behagCarnatica = TipoDeEscala(
        nombre: "Behāg carnática",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        recorrido: [1, 2, 3, 4, 6, 5, 6, 7],
        nombresOriginales: [.init("बेहाग्", .sanscrito), .init("బేహాగ్", .telugu), .init("ಬೇಹಾಗ್", .canares)],
        categoria: .janya, padre: .melakarta(29), referencias: [.karnatik])
    /// Khamās, del mēḷa 28 (Harikāmbhojī): sube en zigzag Sa ma Ga ma Pa Dha ni Ṡa, sin Re, y baja recto con las siete
    /// notas del mēḷa. Es bhāṣāṅga: en algunas frases entra el Ni₃ (`notasExternas`). Lo da así la Wikipedia en
    /// inglés, que lo llama vakra-ṣāḍava-sampūrṇa; la página de la K de karnATik se corta antes de llegar a él. El
    /// telugu y el tamil son los de la Wikipedia; el canarés sale del sánscrito, como en los demás janya (la Wikipedia
    /// escribe ಖಮಾಚ್).
    public static let khamas = TipoDeEscala(
        nombre: "Khamās",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Kamas"], recorrido: [1, 3, 2, 3, 4, 5, 6, 7],
        nombresOriginales: [
            .init("खमास्", .sanscrito), .init("ఖమాస్", .telugu), .init("ಖಮಾಸ್", .canares), .init("கமாச்", .tamil),
        ],
        categoria: .janya, padre: .melakarta(28), notasExternas: [.septimaMayor])

    /// Rāgas janya incluidos.
    package static let janyas: [TipoDeEscala] = [
        .mohanam, .hindolam, .hamsadhvani, .abhogi, .madhyamavati, .bilahari, .kambhoji, .arabhi, .kedaragaula,
        .revati, .amrtavarsini, .mohanakalyani, .saveri, .nata, .suddhaSaveri, .suddhaDhanyasi, .sriranjani,
        .malayamarutam, .gambhiranata, .hamsanadam, .hamsanandi, .kalyanavasantam, .bhupalam, .revagupti, .bauli,
        .lalita, .megharanjani, .dhanyasi, .abheri, .manirangu, .nagasvaravali, .sunadavinodini,
        .andolika, .garudadhvani, .bahudari, .salagabhairavi, .jaganmohini, .rasikaranjani, .suddhaHindolam,
        .anandabhairavi, .surutti, .atana, .kedaram, .darbar, .mukhari, .gaula, .nalinakanti, .kathanakutuhalam,
        .begada, .sahana, .ritigaula, .devagandhari, .bhairaviCarnatica,
        .darbariKanadaCarnatica, .kapi, .kanada, .nilambari, .nayaki, .saranga, .sriCarnatica, .hamirKalyani,
        .yamunaKalyani, .devamanohari, .behagCarnatica, .khamas,
    ]
}
