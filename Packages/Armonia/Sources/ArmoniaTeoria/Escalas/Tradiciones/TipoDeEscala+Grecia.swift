import ArmoniaNucleo

// MARK: - Grecia

extension TipoDeEscala {
    // MARK: Dromoi (música popular griega)

    public static let ousak = TipoDeEscala(
        nombre: "Ousák",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ], alias: ["Usak", "Oussak", "Ουσάκ"])
    public static let hitzaz = TipoDeEscala(
        nombre: "Hitzáz",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ], alias: ["Hijaz", "Hicaz", "Χιτζάζ"])
    public static let hitzazkiar = TipoDeEscala(
        nombre: "Hitzazkiár",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], alias: ["Hijazkiar", "Hicazkar", "Χιτζαζκιάρ"])
    public static let pireotikos = TipoDeEscala(
        nombre: "Pireótikos",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], alias: ["Piraiotikos", "Pireaiotikos", "Πειραιώτικος"])
    public static let tabahaniotikos = TipoDeEscala(
        nombre: "Tabahaniótikos",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["Ταμπαχανιώτικος"])
    public static let niavent = TipoDeEscala(
        nombre: "Niavént",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], alias: ["Nihavent", "Νιαβέντ"])
    public static let nikriz = TipoDeEscala(
        nombre: "Nikríz",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ], alias: ["Souzinak", "Susinak", "Poimeniko", "Νικρίζ"])
    public static let kartzigar = TipoDeEscala(
        nombre: "Kartzigár",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ], alias: ["Kartsigar", "Karcigar", "Καρτσιγάρ"])
    public static let sabah = TipoDeEscala(
        nombre: "Sabáh",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ], alias: ["Sabach", "Sampah", "Σαμπάχ"])
    public static let houzam = TipoDeEscala(
        nombre: "Houzám",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ], alias: ["Huzam", "Χουζάμ"])
    public static let sengah = TipoDeEscala(
        nombre: "Sengáh",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], alias: ["Segah", "Sengiach", "Σεγκιάχ"])
    public static let tsinganikos = TipoDeEscala(
        nombre: "Tsingánikos",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        alias: ["Τσιγγάνικος"])

    // Dromoi que suben y bajan distinto.

    /// Sube como la mayor y baja con la 7ª menor (en la práctica, la 3ª y la 7ª son microtonales).
    public static let rast = TipoDeEscala(
        nombre: "Rast",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["Ραστ"])
    /// Sube como Kartzigár y baja como la menor natural.
    public static let kiourdi = TipoDeEscala(
        nombre: "Kiourdí",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Kurdi", "Kioúrdi", "Κιουρντί"])
    /// Sube como el mixolidio y baja como la menor natural.
    public static let houseini = TipoDeEscala(
        nombre: "Houseïní",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Huseyni", "Houséïni", "Χουσεϊνί"])

    /// Los dromoi más habituales, en su versión temperada.
    public static let dromoi: [TipoDeEscala] = [
        .ousak, .hitzaz, .hitzazkiar, .pireotikos, .tabahaniotikos, .niavent, .nikriz,
        .kartzigar, .sabah, .houzam, .sengah, .tsinganikos, .rast, .kiourdi, .houseini,
    ]
}

// MARK: Ficha

extension FichaDeTradicion {
    static let grecia = FichaDeTradicion(
        .grecia,
        [.init(.dromos, TipoDeEscala.dromoi)],
        microtonales: [
            // Dromoi, todos. Ousák y Sabáh, con la segunda neutra de Bayātī y de Ṣabā, en cuartos de tono (la segâh de
            // Uşşak, una koma bajo Mi, no cabe en su Mi♭). Los demás, en comas, con las perdes de Arel-Ezgi-Uzdilek:
            // los que tienen las notas de un makam, con las de ese makam (Hicaz, Hicazkâr, Suzinak, Nev'eser, Nikriz,
            // Karcığar, Rast); los que solo existen en Grecia, con sus mismos tetracordos: la segunda aumentada de 12 o
            // 13 comas entre dos semitonos de 4 o 5, como en Hicaz, la cuarta aumentada de Nikriz y lo demás
            // pitagórico.
            TipoDeEscalaMicrotonal(.ousak, .cuartosDeTono, pasos: [0, 3, 6, 10, 14, 16, 20]),
            TipoDeEscalaMicrotonal(.sabah, .cuartosDeTono, pasos: [0, 3, 6, 8, 14, 16, 20]),
            TipoDeEscalaMicrotonal(.hitzaz, .comas53, pasos: [0, 5, 17, 22, 31, 35, 44]),
            TipoDeEscalaMicrotonal(.hitzazkiar, .comas53, pasos: [0, 5, 17, 22, 31, 36, 48]),
            // Pireótikos: Hicaz con la cuarta aumentada de Nikriz y un tetracordo Hicaz en la quinta.
            TipoDeEscalaMicrotonal(.pireotikos, .comas53, pasos: [0, 5, 17, 26, 31, 36, 48]),
            // Tabahaniótikos, como Suzinak: un pentacordo Rast y un tetracordo Hicaz.
            TipoDeEscalaMicrotonal(.tabahaniotikos, .comas53, pasos: [0, 9, 17, 22, 31, 36, 48]),
            // Niavént, como Nev'eser: un pentacordo Nikriz y un tetracordo Hicaz.
            TipoDeEscalaMicrotonal(.niavent, .comas53, pasos: [0, 9, 13, 26, 31, 36, 48]),
            // Nikríz: un pentacordo Nikriz y un tetracordo Bûselik.
            TipoDeEscalaMicrotonal(.nikriz, .comas53, pasos: [0, 9, 13, 26, 31, 40, 44]),
            // Kartzigár, como Karcığar: un tetracordo Uşşak y un pentacordo Hicaz en la cuarta.
            TipoDeEscalaMicrotonal(.kartzigar, .comas53, pasos: [0, 8, 13, 22, 27, 39, 44]),
            // Houzám y Sengáh: la segunda aumentada de 13 comas, y dos semitonos de 4 y 5 hasta la cuarta.
            TipoDeEscalaMicrotonal(.houzam, .comas53, pasos: [0, 13, 17, 22, 31, 40, 49]),
            TipoDeEscalaMicrotonal(.sengah, .comas53, pasos: [0, 13, 17, 22, 31, 36, 48]),
            // Tsingánikos: un tetracordo Hicaz y otro en la cuarta.
            TipoDeEscalaMicrotonal(.tsinganikos, .comas53, pasos: [0, 5, 17, 22, 27, 39, 44]),
            TipoDeEscalaMicrotonal(
                .rast, .comas53, pasos: [0, 9, 17, 22, 31, 40, 48], pasosDescendentes: [0, 9, 17, 22, 31, 40, 44]),
            // Kiourdí sube como Kartzigár y baja como Uşşak; Houseïní sube como Rast al bajar y baja como Bûselik.
            TipoDeEscalaMicrotonal(
                .kiourdi, .comas53, pasos: [0, 8, 13, 22, 27, 39, 44], pasosDescendentes: [0, 8, 13, 22, 31, 35, 44]),
            TipoDeEscalaMicrotonal(
                .houseini, .comas53, pasos: [0, 9, 17, 22, 31, 40, 44], pasosDescendentes: [0, 9, 13, 22, 31, 35, 44]),
        ])
}
