import ArmoniaNucleo

// MARK: - Grecia
//
// Las versiones microtonales (`afinaciones:` en cada escala). Dromoi, todos. Ousák y Sabáh, con la segunda neutra de
// Bayātī y de Ṣabā, en cuartos de tono (la segâh de Uşşak, una koma bajo Mi, no cabe en su Mi♭). Los demás, en comas,
// con las perdes de Arel-Ezgi-Uzdilek: los que tienen las notas de un makam, con las de ese makam (Hicaz, Hicazkâr,
// Suzinak, Nev'eser, Nikriz, Karcığar, Rast); los que solo existen en Grecia, con sus mismos tetracordos: la segunda
// aumentada de 12 o 13 comas entre dos semitonos de 4 o 5, como en Hicaz, la cuarta aumentada de Nikriz y lo demás
// pitagórico.

extension TipoDeEscala {
    // MARK: Dromoi (música popular griega)

    public static let ousak = TipoDeEscala(
        nombre: "Ousák",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ], variantes: ["Usak", "Oussak", "Ουσάκ"],
        categoria: .dromos, afinaciones: [.init(.cuartosDeTono, pasos: [0, 3, 6, 10, 14, 16, 20])])
    public static let hitzaz = TipoDeEscala(
        nombre: "Hitzáz",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ], variantes: ["Hijaz", "Hicaz", "Χιτζάζ"],
        categoria: .dromos, afinaciones: [.init(.comas53, pasos: [0, 5, 17, 22, 31, 35, 44])])
    public static let hitzazkiar = TipoDeEscala(
        nombre: "Hitzazkiár",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], variantes: ["Hijazkiar", "Hicazkar", "Χιτζαζκιάρ"],
        categoria: .dromos, afinaciones: [.init(.comas53, pasos: [0, 5, 17, 22, 31, 36, 48])])
    public static let pireotikos = TipoDeEscala(
        nombre: "Pireótikos",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], variantes: ["Piraiotikos", "Pireaiotikos", "Πειραιώτικος"],
        categoria: .dromos,
        // Pireótikos: Hicaz con la cuarta aumentada de Nikriz y un tetracordo Hicaz en la quinta.
        afinaciones: [.init(.comas53, pasos: [0, 5, 17, 26, 31, 36, 48])])
    public static let tabahaniotikos = TipoDeEscala(
        nombre: "Tabahaniótikos",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["Ταμπαχανιώτικος"],
        categoria: .dromos,
        // Tabahaniótikos, como Suzinak: un pentacordo Rast y un tetracordo Hicaz.
        afinaciones: [.init(.comas53, pasos: [0, 9, 17, 22, 31, 36, 48])])
    public static let niavent = TipoDeEscala(
        nombre: "Niavént",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], variantes: ["Nihavent", "Νιαβέντ"],
        categoria: .dromos,
        // Niavént, como Nev'eser: un pentacordo Nikriz y un tetracordo Hicaz.
        afinaciones: [.init(.comas53, pasos: [0, 9, 13, 26, 31, 36, 48])])
    public static let nikriz = TipoDeEscala(
        nombre: "Nikríz",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ], alias: ["Souzinak", "Poimeniko"], variantes: ["Susinak", "Νικρίζ"],
        categoria: .dromos,
        // Nikríz: un pentacordo Nikriz y un tetracordo Bûselik.
        afinaciones: [.init(.comas53, pasos: [0, 9, 13, 26, 31, 40, 44])])
    public static let kartzigar = TipoDeEscala(
        nombre: "Kartzigár",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ], variantes: ["Kartsigar", "Karcigar", "Καρτσιγάρ"],
        categoria: .dromos,
        // Kartzigár, como Karcığar: un tetracordo Uşşak y un pentacordo Hicaz en la cuarta.
        afinaciones: [.init(.comas53, pasos: [0, 8, 13, 22, 27, 39, 44])])
    public static let sabah = TipoDeEscala(
        nombre: "Sabáh",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ], variantes: ["Sabach", "Sampah", "Σαμπάχ"],
        categoria: .dromos, afinaciones: [.init(.cuartosDeTono, pasos: [0, 3, 6, 8, 14, 16, 20])])
    public static let houzam = TipoDeEscala(
        nombre: "Houzám",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ], variantes: ["Huzam", "Χουζάμ"],
        categoria: .dromos,
        // Houzám y Sengáh: la segunda aumentada de 13 comas, y dos semitonos de 4 y 5 hasta la cuarta.
        afinaciones: [.init(.comas53, pasos: [0, 13, 17, 22, 31, 40, 49])])
    public static let sengah = TipoDeEscala(
        nombre: "Sengáh",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], variantes: ["Segah", "Sengiach", "Σεγκιάχ"],
        categoria: .dromos, afinaciones: [.init(.comas53, pasos: [0, 13, 17, 22, 31, 36, 48])])
    public static let tsinganikos = TipoDeEscala(
        nombre: "Tsingánikos",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Τσιγγάνικος"],
        categoria: .dromos,
        // Tsingánikos: un tetracordo Hicaz y otro en la cuarta.
        afinaciones: [.init(.comas53, pasos: [0, 5, 17, 22, 27, 39, 44])])

    // Dromoi que suben y bajan distinto.

    /// Sube como la mayor y baja con la 7ª menor (en la práctica, la 3ª y la 7ª son microtonales).
    public static let rast = TipoDeEscala(
        nombre: "Rast",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Ραστ"],
        categoria: .dromos,
        afinaciones: [
            .init(.comas53, pasos: [0, 9, 17, 22, 31, 40, 48], pasosDescendentes: [0, 9, 17, 22, 31, 40, 44])
        ])
    /// Sube como Kartzigár y baja como la menor natural.
    public static let kiourdi = TipoDeEscala(
        nombre: "Kiourdí",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["Kurdi", "Kioúrdi", "Κιουρντί"],
        categoria: .dromos,
        // Kiourdí sube como Kartzigár y baja como Uşşak; Houseïní sube como Rast al bajar y baja como Bûselik.
        afinaciones: [
            .init(.comas53, pasos: [0, 8, 13, 22, 27, 39, 44], pasosDescendentes: [0, 8, 13, 22, 31, 35, 44])
        ])
    /// Sube como el mixolidio y baja como la menor natural.
    public static let houseini = TipoDeEscala(
        nombre: "Houseïní",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["Huseyni", "Houséïni", "Χουσεϊνί"],
        categoria: .dromos,
        afinaciones: [
            .init(.comas53, pasos: [0, 9, 17, 22, 31, 40, 44], pasosDescendentes: [0, 9, 13, 22, 31, 35, 44])
        ])

    /// Los dromoi más habituales, en su versión temperada.
    package static let dromoi: [TipoDeEscala] = [
        .ousak, .hitzaz, .hitzazkiar, .pireotikos, .tabahaniotikos, .niavent, .nikriz,
        .kartzigar, .sabah, .houzam, .sengah, .tsinganikos, .rast, .kiourdi, .houseini,
    ]
}
