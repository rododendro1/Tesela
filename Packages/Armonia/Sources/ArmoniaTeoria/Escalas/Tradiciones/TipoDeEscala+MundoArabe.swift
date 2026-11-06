import ArmoniaNucleo

// MARK: - MundoArabe

extension TipoDeEscala {
    // MARK: Maqamat árabes (temperados)
    //
    // Los seis primeros no tienen cuartos de tono, y el temperamento igual los escribe sin aproximar: son
    // nombres de escalas que ya había (Ḥijāz es el frigio dominante; Nahāwand, la menor armónica…). Rāst,
    // Bayātī, Ṣabā y Sūznāk sí los tienen, y van aproximados como se suelen escribir: el cuarto de tono se
    // queda en su letra y se redondea hacia el lado de la costumbre (Mi𝄳 a Mi en Rāst y Sūznāk, a Mi♭ en
    // Bayātī y Ṣabā). Sīkāh, Huzām, ʿIrāq y Rāḥat al-Arwāḥ tienen la tónica en un cuarto de tono (Mi𝄳, Si𝄳): se
    // escriben sobre la nota temperada a la que se redondea (Mi, Si), y su versión microtonal la baja.
    // Transliterados con el sistema ALA-LC (ḥ, ā, ʿ), y sin diacríticos como alias. Rāst se llama
    // «maqām Rāst» porque «Rast» sola es el dromos griego, y Nikrīz, «maqām Nikrīz», por el dromos Nikríz.
    //
    // Āthār Kurd, maqām Nikrīz, Lāmī y Ṣabā Zamzam no tienen cuartos de tono: sus ajnas (Kurd, Nikrīz, Lāmī,
    // Ḥijāz, Nahāwand, Ṣabā Zamzam) están todos en doce notas. Fuente: Maqam World (Sami Abu Shumays).

    /// حجاز (Re Mi♭ Fa♯ Sol La Si♭ Do).
    public static let hiyaz = TipoDeEscala(
        nombre: "Ḥijāz",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["maqam Hijaz"], variantes: ["Ḥiŷāz", "Hejaz", "حجاز"])
    /// نهاوند, la menor armónica.
    public static let nahawand = TipoDeEscala(
        nombre: "Nahāwand",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["Nihavend", "Nihavent", "نهاوند"])
    /// كرد, el frigio.
    public static let kurd = TipoDeEscala(
        nombre: "Kurd",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["maqam Kurd"], variantes: ["كرد"])
    /// عجم, la mayor.
    public static let ajam = TipoDeEscala(
        nombre: "ʿAjam",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["Ajam", "Acem", "عجم"])
    /// حجازكار, la doble armónica.
    public static let hiyazkar = TipoDeEscala(
        nombre: "Ḥijāzkār",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["Ḥiŷāzkār", "حجازكار"])
    /// نوى أثر, la menor húngara.
    public static let nawaAthar = TipoDeEscala(
        nombre: "Nawā Athar",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["Nawathar", "Neveser", "نوى أثر"])

    /// راست (Do Re Mi𝄳 Fa Sol La Si𝄳, y Si♭ al bajar), aproximado: sube como la mayor y baja como el
    /// mixolidio, como el dromos Rast.
    public static let maqamRast = TipoDeEscala(
        nombre: "maqām Rāst",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["راست"])
    /// بياتي (Re Mi𝄳 Fa Sol La Si♭ Do), aproximado: como el frigio, igual que el dromos Ousák.
    public static let bayati = TipoDeEscala(
        nombre: "Bayātī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["maqam Bayati"], variantes: ["Bayyātī", "بياتي"])
    /// صبا (Re Mi𝄳 Fa Sol♭ La Si♭ Do), aproximado: Re Mi♭ Fa Sol♭ La Si♭ Do.
    public static let saba = TipoDeEscala(
        nombre: "Ṣabā",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["maqam Saba"], variantes: ["صبا"])
    /// سوزناك (Do Re Mi𝄳 Fa Sol La♭ Si: un jins Rāst y un jins Ḥijāz), aproximado: la mayor armónica.
    public static let suznak = TipoDeEscala(
        nombre: "Sūznāk",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["maqam Suznak"], variantes: ["سوزناك"])
    /// حسيني (Re Mi𝄳 Fa Sol La Si𝄳 Do: un jins Bayātī y otro en la quinta), aproximado: como Bayātī, con Si♭.
    public static let husayni = TipoDeEscala(
        nombre: "Ḥusaynī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["maqam Husayni"], variantes: ["Husseini", "حسيني"])
    /// نيروز (Do Re Mi𝄳 Fa Sol La𝄳 Si♭: un jins Rāst y un jins Bayātī en la quinta), aproximado: la menor natural.
    public static let nayruz = TipoDeEscala(
        nombre: "Nayrūz",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["maqam Nairuz"], variantes: ["Nairuz", "نيروز"])
    /// سيكاه (Mi𝄳 Fa Sol La Si𝄳 Do Re: un jins Sīkāh y un jins Rāst), aproximado sobre Mi: el frigio.
    public static let sikah = TipoDeEscala(
        nombre: "Sīkāh",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["maqam Sikah"], variantes: ["سيكاه"])
    /// هزام (Mi𝄳 Fa Sol La♭ Si Do Re: un jins Sīkāh y un jins Ḥijāz en Sol), aproximado sobre Mi. Se llama
    /// «maqām Huzām» porque «Huzam» es también el dromos Houzám.
    public static let huzam = TipoDeEscala(
        nombre: "maqām Huzām",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["هزام"])
    /// عراق (Si𝄳 Do Re Mi𝄳 Fa Sol La: un jins Sīkāh y un jins Bayātī en Re), aproximado sobre Si: el locrio.
    public static let iraq = TipoDeEscala(
        nombre: "ʿIrāq",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["maqam Iraq"], variantes: ["Iraq", "عراق"])
    /// راحة الأرواح (Si𝄳 Do Re Mi♭ Fa♯ Sol La: Huzām desde Si𝄳), aproximado sobre Si.
    public static let rahatAlArwah = TipoDeEscala(
        nombre: "Rāḥat al-Arwāḥ",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["راحة الأرواح"])
    /// بياتي شوري (Re Mi𝄳 Fa Sol La♭ Si Do: un jins Bayātī y un jins Ḥijāz en Sol), aproximado: Mi𝄳 a Mi♭.
    public static let bayatiShuri = TipoDeEscala(
        nombre: "Bayātī Shūrī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        variantes: ["بياتي شوري"])
    /// جهاركاه (Fa Sol La Si♭ Do Re Mi𝄳: un jins Jiharkāh y un jins Rāst en Do), aproximado: la mayor.
    public static let jiharkah = TipoDeEscala(
        nombre: "Jiharkāh",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["Jaharkah", "جهاركاه"])
    /// آثار كرد (Do Re♭ Mi♭ Fa♯ Sol La♭ Si: un jins Āthār Kurd, que es un Kurd con la cuarta de Nikrīz, y un jins
    /// Ḥijāzkār en Sol).
    public static let atharKurd = TipoDeEscala(
        nombre: "Āthār Kurd",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["آثار كرد"])
    /// نكريز (Do Re Mi♭ Fa♯ Sol La Si♭: un jins Nikrīz y un jins Nahāwand en Sol), como el dromos Nikríz.
    public static let maqamNikriz = TipoDeEscala(
        nombre: "maqām Nikrīz",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["Nakriz"], variantes: ["نكريز"])
    /// لامي (Re Mi♭ Fa Sol La♭ Si♭ Do: un jins Lāmī y un jins Kurd en Sol), el locrio.
    public static let lami = TipoDeEscala(
        nombre: "Lāmī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        variantes: ["لامي"])
    /// صبا زمزم (Re Mi♭ Fa Sol♭ La Si♭ Do: Ṣabā con Mi♭ en lugar de Mi𝄳, un jins Ṣabā Zamzam y un jins Ḥijāz en Fa).
    public static let sabaZamzam = TipoDeEscala(
        nombre: "Ṣabā Zamzam",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["صبا زمزم"])

    public static let maqamat: [TipoDeEscala] = [
        .hiyaz, .nahawand, .kurd, .ajam, .hiyazkar, .nawaAthar, .maqamRast, .bayati, .saba, .suznak, .husayni,
        .nayruz, .sikah, .huzam, .iraq, .rahatAlArwah, .bayatiShuri, .jiharkah, .atharKurd, .maqamNikriz, .lami,
        .sabaZamzam,
    ]

    // MARK: Ajnas (fragmentos)
    //
    // Los ajnas (singular «jins») son los trozos de tres, cuatro o cinco notas de los que se hacen los maqamat: un
    // maqam es un jins en la tónica y otro, que se puede cambiar, encima (Sūznāk es un jins Rāst y un jins Ḥijāz en
    // la quinta). Aquí van los nueve principales, cada uno con su número de notas habitual: tetracordos casi todos;
    // Sīkāh, un tricordo, y Nahāwand, ʿAjam y Nikrīz, pentacordos. Se llaman «jins …» para no confundirse con su
    // maqam. Rāst, Bayātī, Ṣabā y Sīkāh tienen cuartos de tono y van aproximados como sus maqamat. Fuente: Maqam World
    // (Sami Abu Shumays).

    /// جنس راست (Do Re Mi𝄳 Fa), aproximado: Do Re Mi Fa.
    public static let jinsRast = TipoDeEscala(
        nombre: "jins Rāst", intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta],
        variantes: ["جنس راست"])
    /// جنس بياتي (Re Mi𝄳 Fa Sol), aproximado: Re Mi♭ Fa Sol.
    public static let jinsBayati = TipoDeEscala(
        nombre: "jins Bayātī", intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta],
        variantes: ["جنس بياتي"])
    /// جنس صبا (Re Mi𝄳 Fa Sol♭), aproximado: Re Mi♭ Fa Sol♭.
    public static let jinsSaba = TipoDeEscala(
        nombre: "jins Ṣabā", intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida],
        variantes: ["جنس صبا"])
    /// جنس سيكاه (Mi𝄳 Fa Sol), aproximado sobre Mi: Mi Fa Sol.
    public static let jinsSikah = TipoDeEscala(
        nombre: "jins Sīkāh", intervalos: [.unisono, .segundaMenor, .terceraMenor], variantes: ["جنس سيكاه"])
    /// جنس حجاز (Re Mi♭ Fa♯ Sol): la segunda aumentada en medio.
    public static let jinsHijaz = TipoDeEscala(
        nombre: "jins Ḥijāz", intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta],
        variantes: ["جنس حجاز"])
    /// جنس كرد (Re Mi♭ Fa Sol).
    public static let jinsKurd = TipoDeEscala(
        nombre: "jins Kurd", intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta], variantes: ["جنس كرد"])
    /// جنس نهاوند (Do Re Mi♭ Fa Sol).
    public static let jinsNahawand = TipoDeEscala(
        nombre: "jins Nahāwand", intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta],
        variantes: ["جنس نهاوند"])
    /// جنس عجم (Do Re Mi Fa Sol).
    public static let jinsAjam = TipoDeEscala(
        nombre: "jins ʿAjam", intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta],
        variantes: ["جنس عجم"])
    /// جنس نكريز (Do Re Mi♭ Fa♯ Sol).
    public static let jinsNikriz = TipoDeEscala(
        nombre: "jins Nikrīz",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaAumentada, .quintaJusta],
        variantes: ["جنس نكريز"])

    public static let ajnas: [TipoDeEscala] = [
        .jinsRast, .jinsBayati, .jinsSaba, .jinsSikah, .jinsHijaz, .jinsKurd, .jinsNahawand, .jinsAjam, .jinsNikriz,
    ]

    // MARK: Los adwār de Ṣafī al-Dīn
    //
    // Ṣafī al-Dīn al-Urmawī (siglo XIII), en el Kitāb al-adwār, parte la octava en diecisiete notas pitagóricas, con
    // dos tamaños de paso: el limma (256/243, 90 cents) y la coma (531441/524288, 24 cents). Con ellos el tono
    // (9/8, 204) es limma, limma y coma, y la segunda neutra, dos limmas (180). De sus doce modos (shudūd), estos son
    // los cuatro de siete notas que se describen igual en las fuentes; Rāst tiene la tercera y la sexta neutras.
    // Los demás (ʿIrāq, Iṣfahān, Zīrafkand, Buzurg, Rāhawī, Zankūla, Ḥusaynī y Ḥijāzī) faltan: o tienen ocho notas o
    // las fuentes no coinciden en sus grados. Se llaman «shadd» para no confundirse con los maqamat de hoy.

    /// شد عشاق (Do Re Mi Fa Sol La Si♭, pitagórico): tono, tono, limma, tono, tono, limma y tono.
    public static let shaddUshshaq = TipoDeEscala(
        nombre: "shadd ʿUshshāq",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["ʿUshshāq de Ṣafī al-Dīn"])
    /// شد نوى (Do Re Mi♭ Fa Sol La♭ Si♭, pitagórico): tono, limma, tono, tono, limma, tono y tono.
    public static let shaddNawa = TipoDeEscala(
        nombre: "shadd Nawā",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Nawā de Ṣafī al-Dīn"])
    /// شد أبو سليك (Do Re♭ Mi♭ Fa Sol♭ La♭ Si♭, pitagórico): limma, tono, tono, limma, tono, tono y tono.
    public static let shaddAbuSalik = TipoDeEscala(
        nombre: "shadd Abū Salīk",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["Abū Salīk de Ṣafī al-Dīn"], variantes: ["shadd Būsalīk"])
    /// شد راست (Do Re Mi Fa Sol La Si♭, con el Mi y el La neutros): tono, dos limmas, limma y coma, tono, dos limmas,
    /// limma y coma, y tono.
    public static let shaddRast = TipoDeEscala(
        nombre: "shadd Rāst",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["Rāst de Ṣafī al-Dīn"])

    /// Los cuatro shudūd de Ṣafī al-Dīn que están: ʿUshshāq, Nawā, Abū Salīk y Rāst.
    public static let adwar: [TipoDeEscala] = [.shaddUshshaq, .shaddNawa, .shaddAbuSalik, .shaddRast]
}

// MARK: Ficha

extension FichaDeTradicion {
    static let mundoArabe = FichaDeTradicion(
        .mundoArabe,
        [
            .init(.maqam, TipoDeEscala.maqamat), .init(.jins, TipoDeEscala.ajnas),
            .init(.maqam, TipoDeEscala.adwar),
        ],
        microtonales: [
            // Maqamat (cuartos de tono).
            TipoDeEscalaMicrotonal(
                .maqamRast, .cuartosDeTono, pasos: [0, 4, 7, 10, 14, 18, 21],
                pasosDescendentes: [0, 4, 7, 10, 14, 18, 20]),
            TipoDeEscalaMicrotonal(.bayati, .cuartosDeTono, pasos: [0, 3, 6, 10, 14, 16, 20]),
            TipoDeEscalaMicrotonal(.saba, .cuartosDeTono, pasos: [0, 3, 6, 8, 14, 16, 20]),
            TipoDeEscalaMicrotonal(.suznak, .cuartosDeTono, pasos: [0, 4, 7, 10, 14, 16, 22]),
            TipoDeEscalaMicrotonal(.husayni, .cuartosDeTono, pasos: [0, 3, 6, 10, 14, 17, 20]),
            TipoDeEscalaMicrotonal(.nayruz, .cuartosDeTono, pasos: [0, 4, 7, 10, 14, 17, 20]),
            // Con la tónica en un cuarto de tono, escritas sobre la nota temperada: Sīkāh en Mi es Mi𝄳 Fa Sol La Si𝄳.
            TipoDeEscalaMicrotonal(.sikah, .cuartosDeTono, pasos: [-1, 2, 6, 10, 13, 16, 20]),
            TipoDeEscalaMicrotonal(.huzam, .cuartosDeTono, pasos: [-1, 2, 6, 8, 14, 16, 20]),
            TipoDeEscalaMicrotonal(.iraq, .cuartosDeTono, pasos: [-1, 2, 6, 9, 12, 16, 20]),
            TipoDeEscalaMicrotonal(.rahatAlArwah, .cuartosDeTono, pasos: [-1, 2, 6, 8, 14, 16, 20]),
            TipoDeEscalaMicrotonal(.bayatiShuri, .cuartosDeTono, pasos: [0, 3, 6, 10, 12, 18, 20]),
            TipoDeEscalaMicrotonal(.jiharkah, .cuartosDeTono, pasos: [0, 4, 8, 10, 14, 18, 21]),
            // Ajnas.
            TipoDeEscalaMicrotonal(.jinsRast, .cuartosDeTono, pasos: [0, 4, 7, 10]),
            TipoDeEscalaMicrotonal(.jinsBayati, .cuartosDeTono, pasos: [0, 3, 6, 10]),
            TipoDeEscalaMicrotonal(.jinsSaba, .cuartosDeTono, pasos: [0, 3, 6, 8]),
            TipoDeEscalaMicrotonal(.jinsSikah, .cuartosDeTono, pasos: [-1, 2, 6]),
            // Los shudūd de Ṣafī al-Dīn, en cents de sus razones pitagóricas.
            TipoDeEscalaMicrotonal(.shaddUshshaq, .razones, pasos: [0, 204, 408, 498, 702, 906, 996]),
            TipoDeEscalaMicrotonal(.shaddNawa, .razones, pasos: [0, 204, 294, 498, 702, 792, 996]),
            TipoDeEscalaMicrotonal(.shaddAbuSalik, .razones, pasos: [0, 90, 294, 498, 588, 792, 996]),
            TipoDeEscalaMicrotonal(.shaddRast, .razones, pasos: [0, 204, 384, 498, 702, 882, 996]),
        ])
}
