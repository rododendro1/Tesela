import Elementos

// MARK: - Persia
//
// Las versiones microtonales (`afinaciones:` en cada escala). Dastgāh (koron).

extension TipoDeEscala {
    // MARK: Dastgāh persas (temperados)
    //
    // Casi todos los dastgāh usan koron (un cuarto de tono bajo): solo Māhur y Rāst-Panjgāh se
    // escriben sin aproximar. Los demás, y los āvāz que derivan de Šur (Bayāt-e Tork, Afšāri, Dašti,
    // Abu ʿAtā) y de Homāyun (Bayāt-e Esfahān), van con la aproximación temperada habitual, el koron
    // redondeado a semitono hacia abajo, y su versión microtonal lo devuelve a su sitio. Segāh, con la
    // tónica en un koron, se escribe sobre Mi. Las notas, como en la Wikipedia inglesa (Dastgāh) y en la
    // guía del radif de Ableton. Transliterados como en la Encyclopædia Iranica.
    //
    // Los maqom del Shashmaqom uzbeko y tayiko (Buzruk, Rost, Navo, Dugoh, Segoh, Iroq), vecinos de estos, no
    // están todavía: sus escalas cambian de una sección a otra y las fuentes no dan una por maqom.

    /// ماهور: la mayor.
    public static let mahur = TipoDeEscala(
        nombre: "Māhur",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["Mahoor", "ماهور"],
        categoria: .dastgah)
    /// همایون, aproximado: como el frigio dominante.
    public static let homayun = TipoDeEscala(
        nombre: "Homāyun",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["Homayoun", "همایون"],
        categoria: .dastgah, afinaciones: [.init(.persa, pasos: [0, 3, 8, 10, 14, 16, 20])])
    /// چهارگاه, aproximado: como la doble armónica.
    public static let cahargah = TipoDeEscala(
        nombre: "Čahārgāh",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["Chahārgāh", "چهارگاه"],
        categoria: .dastgah, afinaciones: [.init(.persa, pasos: [0, 3, 8, 10, 14, 17, 22])])

    /// شور (Re Mi𝄳 Fa Sol La Si♭ Do), aproximado: como el frigio.
    public static let sur = TipoDeEscala(
        nombre: "Šur",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["Shur", "Shoor", "شور"],
        categoria: .dastgah, afinaciones: [.init(.persa, pasos: [0, 3, 6, 10, 14, 16, 20])])
    /// راست پنجگاه: el mixolidio.
    public static let rastPanjgah = TipoDeEscala(
        nombre: "Rāst-Panjgāh",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["راست پنجگاه"],
        categoria: .dastgah)
    /// سهگاه (Mi𝄳 Fa Sol La𝄳 Si♭ Do Re), con la tónica en un koron, aproximado sobre Mi. Se llama «dastgāh Segāh»
    /// porque «Segah» es también el dromos Sengáh.
    public static let segah = TipoDeEscala(
        nombre: "dastgāh Segāh",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        variantes: ["سه\u{200C}گاه"],
        categoria: .dastgah, afinaciones: [.init(.persa, pasos: [-1, 2, 6, 9, 12, 16, 20])])
    /// نوا (Sol La Si♭ Do Re Mi𝄳 Fa), aproximado: la menor natural.
    public static let nava = TipoDeEscala(
        nombre: "Navā",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["نوا"],
        categoria: .dastgah, afinaciones: [.init(.persa, pasos: [0, 4, 6, 10, 14, 17, 20])])
    /// بیات ترک (Fa Sol La Si♭ Do Re Mi𝄳), un āvāz de Šur, aproximado: el mixolidio.
    public static let bayateTork = TipoDeEscala(
        nombre: "Bayāt-e Tork",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Bayat-e Turk", "بیات ترک"],
        categoria: .dastgah, afinaciones: [.init(.persa, pasos: [0, 4, 8, 10, 14, 18, 21])])
    /// افشاری (Do Re Mi𝄳 Fa Sol La𝄳 Si♭), un āvāz de Šur, aproximado: la menor natural.
    public static let afshari = TipoDeEscala(
        nombre: "Afšāri",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["Afshari", "افشاری"],
        categoria: .dastgah, afinaciones: [.init(.persa, pasos: [0, 4, 7, 10, 14, 17, 20])])
    /// دشتی (Re Mi𝄳 Fa Sol La Si♭ Do), un āvāz de Šur con sus mismas notas y el šāhed en La, aproximado: el frigio.
    public static let dashti = TipoDeEscala(
        nombre: "Dašti",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["Dashti", "دشتی"],
        categoria: .dastgah, afinaciones: [.init(.persa, pasos: [0, 3, 6, 10, 14, 16, 20])])
    /// ابوعطا (Re Mi𝄳 Fa Sol La𝄳 Si♭ Do), un āvāz de Šur, aproximado: el locrio.
    public static let abuAta = TipoDeEscala(
        nombre: "Abu ʿAtā",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["Abuata"], variantes: ["Abu Ata", "ابوعطا"],
        categoria: .dastgah, afinaciones: [.init(.persa, pasos: [0, 3, 6, 10, 13, 16, 20])])
    /// بیات اصفهان (Sol La Si♭ Do Re Mi𝄳 Fa♯), un āvāz de Homāyun, aproximado: la menor armónica.
    public static let bayateEsfahan = TipoDeEscala(
        nombre: "Bayāt-e Esfahān",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["Isfahan"], variantes: ["Bayat-e Isfahan", "بیات اصفهان"],
        categoria: .dastgah, afinaciones: [.init(.persa, pasos: [0, 4, 6, 10, 14, 17, 22])])

    /// Los dastgāh y, con ellos, los āvāz que derivan de Šur y de Homāyun.
    package static let dastgah: [TipoDeEscala] = [
        .mahur, .homayun, .cahargah, .sur, .rastPanjgah, .segah, .nava, .bayateTork, .afshari, .dashti, .abuAta,
        .bayateEsfahan,
    ]
}
