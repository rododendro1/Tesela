import Elementos

// MARK: - India: música indostánica
//
// Los diez thāṭ de Bhatkhande y los rāgas indostánicos, con sus śruti (el modelo de E. J. Arnold, en la cabecera
// de `TipoDeEscala+India.swift`).

extension TipoDeEscala {
    // MARK: Thāṭ (música indostánica)

    public static let bilaval = TipoDeEscala(
        nombre: "Bilāval",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ], variantes: ["Bilawal"], nombresOriginales: [.init("बिलावल", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 3, 7, 9, 13, 16, 20])])
    public static let kalyan = TipoDeEscala(
        nombre: "Kalyāṇ",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ], nombresOriginales: [.init("कल्याण", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 3, 7, 11, 13, 16, 20])])
    public static let khamaj = TipoDeEscala(
        nombre: "Khamāj",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        nombresOriginales: [.init("खमाज", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 3, 7, 9, 13, 16, 18])])
    public static let kafi = TipoDeEscala(
        nombre: "Kāfī",
        intervalos: TipoDeEscala.dorico.intervalos,
        nombresOriginales: [.init("काफ़ी", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 3, 5, 9, 13, 16, 18])])
    public static let asavari = TipoDeEscala(
        nombre: "Āsāvarī",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        nombresOriginales: [.init("आसावरी", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 3, 5, 9, 13, 14, 18])])
    public static let bhairavi = TipoDeEscala(
        nombre: "Bhairavī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        nombresOriginales: [.init("भैरवी", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 1, 5, 9, 13, 14, 18])])
    public static let bhairav = TipoDeEscala(
        nombre: "Bhairav",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [.init("भैरव", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 1, 7, 9, 13, 14, 20])])
    public static let marva = TipoDeEscala(
        nombre: "Mārvā",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ], variantes: ["Marwa"], nombresOriginales: [.init("मारवा", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 2, 7, 11, 13, 16, 20])])
    public static let purvi = TipoDeEscala(
        nombre: "Pūrvī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], variantes: ["Poorvi"], nombresOriginales: [.init("पूर्वी", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 2, 7, 11, 13, 15, 20])])
    public static let todi = TipoDeEscala(
        nombre: "Toḍī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [.init("तोडी", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 1, 5, 11, 13, 14, 21])])

    /// Los diez thāṭ de Bhatkhande.
    package static let thaats: [TipoDeEscala] = [
        .bilaval, .kalyan, .khamaj, .kafi, .asavari, .bhairavi, .bhairav, .marva, .purvi, .todi,
    ]

    // MARK: Rāgas indostánicos
    //
    // Algunos de los rāgas más tocados, con su āroh (subida) y avaroh (bajada) en la forma recta que dan los libros de
    // teoría. Bihāg lleva además su recorrido vakra, el de la Wikipedia en inglés. Darbārī Kānaḍa, que es vakra de por
    // sí, va con sus notas rectas: su ga y su dha ati-komal, con andolan, y la Wikipedia da dos recorridos distintos.
    // Deś tampoco lo lleva: su bajada termina en el Ni de abajo (Re Ga Ni Sa), y un recorrido de bajada acaba en Sa.

    /// Bhūpālī: la pentatónica mayor (Sa Re Ga Pa Dha).
    public static let bhupali = TipoDeEscala(
        nombre: "Bhūpālī", intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        variantes: ["Bhoopali", "Bhupal"], nombresOriginales: [.init("भूपाली", .hindi)],
        categoria: .raga, padre: .kalyan, afinaciones: [.init(.sruti, pasos: [0, 3, 7, 13, 16])])
    /// Mālkauns (Sa ga ma dha ni): el Hindolam carnático.
    public static let malkauns = TipoDeEscala(
        nombre: "Mālkauns", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMenor, .septimaMenor],
        variantes: ["Malkosh"], nombresOriginales: [.init("मालकौंस", .hindi)],
        categoria: .raga, padre: .bhairavi, afinaciones: [.init(.sruti, pasos: [0, 5, 9, 14, 18])])
    /// Durgā (Sa Re ma Pa Dha).
    public static let durga = TipoDeEscala(
        nombre: "Durgā", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        nombresOriginales: [.init("दुर्गा", .hindi)],
        categoria: .raga, padre: .bilaval, afinaciones: [.init(.sruti, pasos: [0, 3, 9, 13, 16])])
    /// Yaman: el thāṭ Kalyāṇ entero, con la 4ª aumentada.
    public static let yaman = TipoDeEscala(
        nombre: "Yaman",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["Yaman Kalyāṇ"], variantes: ["Iman"], nombresOriginales: [.init("यमन", .hindi)],
        categoria: .raga, padre: .kalyan, afinaciones: [.init(.sruti, pasos: [0, 3, 7, 11, 13, 16, 20])])
    /// Bāgeśrī: sube sin Re ni Pa y baja sin Pa.
    public static let bagesri = TipoDeEscala(
        nombre: "Bāgeśrī",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Bageshri", "Bageshree"], nombresOriginales: [.init("बागेश्री", .hindi)],
        categoria: .raga, padre: .kafi,
        afinaciones: [.init(.sruti, pasos: [0, 5, 9, 16, 18], pasosDescendentes: [0, 3, 5, 9, 16, 18])])
    /// Śivarañjanī (Sa Re ga Pa Dha).
    public static let sivaranjani = TipoDeEscala(
        nombre: "Śivarañjanī", intervalos: [.unisono, .segundaMayor, .terceraMenor, .quintaJusta, .sextaMayor],
        variantes: ["Shivaranjani"], nombresOriginales: [.init("शिवरंजनी", .hindi)],
        categoria: .raga, padre: .kafi, afinaciones: [.init(.sruti, pasos: [0, 3, 5, 13, 16])])
    /// Kalāvatī (Sa Ga Pa Dha ni), el Valaji carnático.
    public static let kalavati = TipoDeEscala(
        nombre: "Kalāvatī", intervalos: [.unisono, .terceraMayor, .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["Valaji"], nombresOriginales: [.init("कलावती", .hindi)],
        categoria: .raga, padre: .khamaj, afinaciones: [.init(.sruti, pasos: [0, 7, 13, 16, 18])])
    /// Candrakauns (Sa ga ma dha Ni): el Mālkauns con Ni natural.
    public static let candrakauns = TipoDeEscala(
        nombre: "Candrakauns", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMenor, .septimaMayor],
        variantes: ["Chandrakauns", "Chandrakons"], nombresOriginales: [.init("चंद्रकौंस", .hindi)],
        categoria: .raga)
    /// Megh (Sa Re ma Pa ni): como la egipcia.
    public static let megh = TipoDeEscala(
        nombre: "Megh", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Megh Malhar"], nombresOriginales: [.init("मेघ", .hindi)],
        categoria: .raga, padre: .kafi, afinaciones: [.init(.sruti, pasos: [0, 3, 9, 13, 18])])
    /// Deś: sube sin Ga ni Dha y con Ni natural; baja con ni komal. Bhatkhande lo pone en Khamāj, que solo tiene el
    /// komal: el Ni natural es una nota externa (`notasExternas`).
    public static let des = TipoDeEscala(
        nombre: "Deś",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Desh"], nombresOriginales: [.init("देश", .hindi)],
        categoria: .raga, padre: .khamaj, notasExternas: [.septimaMayor],
        afinaciones: [.init(.sruti, pasos: [0, 3, 9, 13, 20], pasosDescendentes: [0, 3, 7, 9, 13, 16, 18])])
    /// Lalit (Sa re Ga ma Ma dha Ni, sin Pa): los dos Ma seguidos, el natural y el tīvra (Do Re♭ Mi Fa Fa♯ La♭ Si).
    public static let lalit = TipoDeEscala(
        nombre: "Lalit",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .cuartaAumentada, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [.init("ललित", .hindi)],
        categoria: .raga)
    /// Bhīmpalāsī (thāṭ Kāfī): sube sin Re ni Dha (Sa ga ma Pa ni) y baja con todas (Sa Re ga ma Pa Dha ni).
    public static let bhimpalasi = TipoDeEscala(
        nombre: "Bhīmpalāsī",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Bhimpalas", "Bheempalasi"], nombresOriginales: [.init("भीमपलासी", .hindi)],
        categoria: .raga, padre: .kafi,
        afinaciones: [.init(.sruti, pasos: [0, 5, 9, 13, 18], pasosDescendentes: [0, 3, 5, 9, 13, 16, 18])])
    /// Bihāg (thāṭ Bilāval): sube desde el Ni de abajo sin Re ni Dha (Ni Sa Ga ma Pa Ni Ṡa) y baja en zigzag con
    /// todas, Ṡa Ni Dha Pa Ma Pa Ga ma Ga Re Sa. El Ma tīvra solo sale ahí, de paso, y no es de Bilāval: es una nota
    /// externa (`notasExternas`), con el śruti del de Kalyāṇ (45/32). La Wikipedia en inglés escribe el Dha entre
    /// paréntesis, porque se toca de paso.
    public static let bihag = TipoDeEscala(
        nombre: "Bihāg",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .cuartaAumentada, .quintaJusta, .sextaMayor,
            .septimaMayor,
        ],
        variantes: ["Behag"], recorrido: [0, 1, 2, 3, 4, 5, 6],
        recorridoDescendente: [9, 8, 7, 6, 5, 6, 3, 4, 3, 2, 1],
        nombresOriginales: [.init("बिहाग", .hindi)],
        categoria: .raga, padre: .bilaval, notasExternas: [.cuartaAumentada],
        afinaciones: [.init(.sruti, pasos: [0, 7, 9, 13, 20], pasosDescendentes: [0, 3, 7, 9, 11, 13, 16, 20])])
    /// Darbārī Kānaḍa (thāṭ Āsāvarī: Sa Re ga ma Pa dha ni), en su forma recta: la menor natural, como Āsāvarī.
    public static let darbariKanada = TipoDeEscala(
        nombre: "Darbārī Kānaḍa",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Darbari"], variantes: ["Darbārī Kānaṛā", "Darbari Kanhra"],
        nombresOriginales: [.init("दरबारी कान्हड़ा", .hindi)],
        categoria: .raga, padre: .asavari, afinaciones: [.init(.sruti, pasos: [0, 3, 5, 9, 13, 14, 18])])
    /// Pūriyā Dhanāśrī (thāṭ Pūrvī: Sa re Ga Ma Pa dha Ni, Do Re♭ Mi Fa♯ Sol La♭ Si).
    public static let puriyaDhanasri = TipoDeEscala(
        nombre: "Pūriyā Dhanāśrī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["Puriya Dhanashri", "Puriya Dhanashree"], nombresOriginales: [.init("पूरिया धनाश्री", .hindi)],
        categoria: .raga, padre: .purvi, afinaciones: [.init(.sruti, pasos: [0, 2, 7, 11, 13, 15, 20])])

    // Cuatro más, con el āroh y el avaroh de la Wikipedia en inglés (noviembre de 2026), en su forma recta: dos con
    // ga komal, Ma tivra y Pa (Madhuvantī, con Re y Dha śuddha al bajar; Multānī, de Toḍī, con re y dha komal),
    // Hindol (Kalyāṇ sin Re ni Pa) y Sohinī (Mārvā sin Pa, que sube sin Re).

    /// Madhuvantī: sube Sa ga Ma Pa Ni y baja Sa Ni Dha Pa Ma ga Re. Sin `padre`: se suele poner en Toḍī, pero su Re y
    /// su Dha śuddha no están en ese thāṭ.
    public static let madhuvanti = TipoDeEscala(
        nombre: "Madhuvantī",
        intervalos: [.unisono, .terceraMenor, .cuartaAumentada, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        nombresOriginales: [.init("मधुवंती", .hindi)],
        categoria: .raga)
    /// Multānī: sube Sa ga Ma Pa Ni y baja Sa Ni dha Pa Ma ga re.
    public static let multani = TipoDeEscala(
        nombre: "Multānī",
        intervalos: [.unisono, .terceraMenor, .cuartaAumentada, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaAumentada, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [.init("मुलतानी", .hindi)],
        categoria: .raga, padre: .todi,
        afinaciones: [.init(.sruti, pasos: [0, 5, 11, 13, 21], pasosDescendentes: [0, 1, 5, 11, 13, 14, 21])])
    /// Hindol (Sa Ga Ma Dha Ni, con Ma tivra), en su forma recta; no es el Hindolam carnático, que es Mālkauns.
    public static let hindol = TipoDeEscala(
        nombre: "Hindol",
        intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .sextaMayor, .septimaMayor],
        nombresOriginales: [.init("हिंडोल", .hindi)],
        categoria: .raga, padre: .kalyan, afinaciones: [.init(.sruti, pasos: [0, 7, 11, 16, 20])])
    /// Sohinī: sube Sa Ga Ma Dha Ni y baja Sa Ni Dha Ma Ga re, en su forma recta.
    public static let sohini = TipoDeEscala(
        nombre: "Sohinī",
        intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .sextaMayor, .septimaMayor],
        intervalosDescendentes: [.unisono, .segundaMenor, .terceraMayor, .cuartaAumentada, .sextaMayor, .septimaMayor],
        variantes: ["Sohni"], nombresOriginales: [.init("सोहनी", .hindi)],
        categoria: .raga, padre: .marva,
        afinaciones: [.init(.sruti, pasos: [0, 7, 11, 16, 20], pasosDescendentes: [0, 2, 7, 11, 16, 20])])

    // Ocho más, también de la Wikipedia en inglés (noviembre de 2026) y en su forma recta. Van sin `padre` los que
    // tienen notas que no están en el thāṭ que les da su artículo (Vṛndāvanī Sāraṅg y Ahir Bhairav) o cuyo artículo no
    // da thāṭ (Gujarī Toḍī y Jog).

    /// Jaunpurī (thāṭ Āsāvarī): sube sin ga (Sa Re ma Pa dha ni) y baja con todas.
    public static let jaunpuri = TipoDeEscala(
        nombre: "Jaunpurī",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["Jonpuri"], nombresOriginales: [.init("जौनपुरी", .hindi)],
        categoria: .raga, padre: .asavari,
        afinaciones: [.init(.sruti, pasos: [0, 3, 9, 13, 14, 18], pasosDescendentes: [0, 3, 5, 9, 13, 14, 18])])
    /// Miyāṅ kī Toḍī (thāṭ Toḍī): sube sin Pa (Sa re ga Ma dha Ni) y baja con él.
    public static let miyanKiTodi = TipoDeEscala(
        nombre: "Miyāṅ kī Toḍī",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaAumentada, .sextaMenor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaAumentada, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [.init("मियाँ की तोड़ी", .hindi)],
        categoria: .raga, padre: .todi,
        afinaciones: [.init(.sruti, pasos: [0, 1, 5, 11, 14, 21], pasosDescendentes: [0, 1, 5, 11, 13, 14, 21])])
    /// Gujarī Toḍī: Miyāṅ kī Toḍī sin Pa, ni al subir ni al bajar.
    public static let gujariTodi = TipoDeEscala(
        nombre: "Gujarī Toḍī",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaAumentada, .sextaMenor, .septimaMayor],
        nombresOriginales: [.init("गुजरी तोड़ी", .hindi)],
        categoria: .raga)
    /// Rāgeśrī (thāṭ Khamāj): sube sin Re ni Pa (Sa Ga ma Dha ni) y baja sin Pa.
    public static let rageshri = TipoDeEscala(
        nombre: "Rāgeśrī",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Rageshri", "Rageshree"], nombresOriginales: [.init("रागेश्री", .hindi)],
        categoria: .raga, padre: .khamaj,
        afinaciones: [.init(.sruti, pasos: [0, 7, 9, 16, 18], pasosDescendentes: [0, 3, 7, 9, 16, 18])])
    /// Vṛndāvanī Sāraṅg: sube con Ni (Sa Re ma Pa Ni) y baja con ni komal (Sa ni Pa ma Re), sin Ga ni Dha. Su artículo
    /// la pone en Kāfī, que no tiene Ni.
    public static let vrindavaniSarang = TipoDeEscala(
        nombre: "Vṛndāvanī Sāraṅg",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        variantes: ["Brindabani Sarang", "Vrindavani Sarang"], nombresOriginales: [.init("वृन्दावनी सारंग", .hindi)],
        categoria: .raga)
    /// Jog: sube Sa Ga ma Pa ni y baja Sa ni Pa ma Ga ma ga, con las dos Ga; en la forma recta, Sa ni Pa ma Ga ga.
    public static let jog = TipoDeEscala(
        nombre: "Jog",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [.unisono, .terceraMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        nombresOriginales: [.init("जोग", .hindi)],
        categoria: .raga)
    /// Ahir Bhairav: Sa re Ga ma Pa Dha ni. Su artículo la pone en Bhairav, que tiene dha y Ni.
    public static let ahirBhairav = TipoDeEscala(
        nombre: "Ahir Bhairav",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        nombresOriginales: [.init("अहीर भैरव", .hindi)],
        categoria: .raga)
    /// Pūriyā (thāṭ Mārvā): Sa re Ga Ma Dha Ni, sin Pa, como Mārvā.
    public static let puriya = TipoDeEscala(
        nombre: "Pūriyā",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaAumentada, .sextaMayor, .septimaMayor],
        nombresOriginales: [.init("पूरिया", .hindi)],
        categoria: .raga, padre: .marva, afinaciones: [.init(.sruti, pasos: [0, 2, 7, 11, 16, 20])])

    // Ocho más, de la misma fuente. Van sin `padre` Paṭdīp (Kāfī con Ni y Dha śuddha), Kirvāṇī (que no cabe en ningún
    // thāṭ), Bairāgī (Bhairav con ni komal) y Naṭ Bhairav (Bhairav con Re śuddha).

    /// Basant (thāṭ Pūrvī): sube Sa Ga Ma dha Ni y baja con todas (Sa Ni dha Pa Ma Ga re).
    public static let basant = TipoDeEscala(
        nombre: "Basant",
        intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .sextaMenor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["Vasant"], nombresOriginales: [.init("बसंत", .hindi)],
        categoria: .raga, padre: .purvi,
        afinaciones: [.init(.sruti, pasos: [0, 7, 11, 15, 20], pasosDescendentes: [0, 2, 7, 11, 13, 15, 20])])
    /// Śrī (thāṭ Pūrvī): sube Sa re Ma Pa Ni y baja con todas.
    public static let shri = TipoDeEscala(
        nombre: "Śrī",
        intervalos: [.unisono, .segundaMenor, .cuartaAumentada, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["Shree"], nombresOriginales: [.init("श्री", .hindi)],
        categoria: .raga, padre: .purvi,
        afinaciones: [.init(.sruti, pasos: [0, 2, 11, 13, 20], pasosDescendentes: [0, 2, 7, 11, 13, 15, 20])])
    /// Paṭdīp: Bhīmpalāsī con Ni śuddha; sube Sa ga ma Pa Ni y baja con Re y Dha śuddha.
    public static let patdip = TipoDeEscala(
        nombre: "Paṭdīp",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["Patdeep"], nombresOriginales: [.init("पटदीप", .hindi)],
        categoria: .raga)
    /// Kirvāṇī: Sa Re ga ma Pa dha Ni, como el mēḷa Kīravāṇī.
    public static let kirvani = TipoDeEscala(
        nombre: "Kirvāṇī",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["Kirwani"], nombresOriginales: [.init("किरवाणी", .hindi)],
        categoria: .raga)
    /// Bairāgī: Sa re ma Pa ni (Do Re♭ Fa Sol Si♭).
    public static let bairagi = TipoDeEscala(
        nombre: "Bairāgī",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        variantes: ["Bairagi Bhairav"], nombresOriginales: [.init("बैरागी", .hindi)],
        categoria: .raga)
    /// Naṭ Bhairav: Sa Re Ga ma Pa dha Ni, la mayor armónica.
    public static let natBhairav = TipoDeEscala(
        nombre: "Naṭ Bhairav",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [.init("नट भैरव", .hindi)],
        categoria: .raga)
    /// Dhānī (thāṭ Kāfī): Mālkauns con Pa en lugar de dha (Sa ga ma Pa ni).
    public static let dhani = TipoDeEscala(
        nombre: "Dhānī", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        nombresOriginales: [.init("धानी", .hindi)],
        categoria: .raga, padre: .kafi, afinaciones: [.init(.sruti, pasos: [0, 5, 9, 13, 18])])
    /// Guṇakrī (thāṭ Bhairav): Sa re ma Pa dha (Do Re♭ Fa Sol La♭).
    public static let gunakri = TipoDeEscala(
        nombre: "Guṇakrī", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .sextaMenor],
        variantes: ["Gunkali"], nombresOriginales: [.init("गुणक्री", .hindi)],
        categoria: .raga, padre: .bhairav, afinaciones: [.init(.sruti, pasos: [0, 1, 9, 13, 14])])

    /// Rāgas indostánicos incluidos.
    package static let ragasIndostanicos: [TipoDeEscala] = [
        .bhupali, .malkauns, .durga, .yaman, .bagesri, .des, .sivaranjani, .kalavati, .candrakauns, .megh, .lalit,
        .bhimpalasi, .bihag, .darbariKanada, .puriyaDhanasri, .madhuvanti, .multani, .hindol, .sohini, .jaunpuri,
        .miyanKiTodi,
        .gujariTodi, .rageshri, .vrindavaniSarang, .jog, .ahirBhairav, .puriya,
        .basant, .shri, .patdip, .kirvani, .bairagi, .natBhairav, .dhani, .gunakri,
    ]
}
