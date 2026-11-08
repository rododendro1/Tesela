import Elementos

// MARK: - Turquia
//
// Las versiones microtonales (`afinaciones:` en cada escala). Makamlar (comas de AEU).

extension TipoDeEscala {
    // MARK: Makamlar turcos (temperados)
    //
    // En la teoría de Arel-Ezgi-Uzdilek (AEU) la octava tiene 53 comas, y las alteraciones son de 1 coma
    // (koma), 4 (bakiye), 5 (küçük mücennep) y 8 (büyük mücennep). Aquí cada nota se redondea a su
    // semitono más cercano: la koma desaparece y las demás se escriben como ♯ o ♭. Uşşak y Hüseynî, cuya
    // segâh (Si una koma bajo, que en la práctica suena casi un cuarto de tono bajo) se pierde al redondear,
    // tienen además su versión microtonal (`TipoDeEscala.microtonal`), como Segâh, con la tónica en la segâh,
    // que se escribe sobre Si. Saba, cuyas fuentes no coinciden en el tetracordo, sigue fuera.
    // Los nombres van en turco con «makamı» detrás, como se dicen: «Rast» sola es el dromos griego.
    //
    // Mâhur, Acemaşiran, Sultânîyegâh y Şedaraban son *şed*: las notas de otro makam (Çârgâh, Nihâvend,
    // Hicazkâr) llevadas a otra perde. Hümâyun, Uzzâl y Zirgüleli Hicaz son, con Hicaz, las cuatro formas del
    // tetracordo Hicaz en la dügâh, que cambian lo que sigue. Varios comparten notas con otro makam y se distinguen
    // por el recorrido (seyir), la nota de reposo (güçlü) y el registro, que una escala no recoge. Fuente: los
    // artículos de cada makam de la TDV İslâm Ansiklopedisi.

    /// Rast (Sol La Si Do Re Mi Fa♯, con Si y Fa♯ una koma bajos): sube como la mayor y baja con Fa, como el
    /// mixolidio.
    public static let rastMakami = TipoDeEscala(
        nombre: "Rast makamı",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["makam Rast"],
        categoria: .makam,
        afinaciones: [
            .init(.comas53, pasos: [0, 9, 17, 22, 31, 40, 48], pasosDescendentes: [0, 9, 17, 22, 31, 40, 44])
        ])
    /// Hicaz (La Si♭ Do♯ Re | Mi Fa♯ Sol): un tetracordo Hicaz y, al subir, un pentacordo Rast en la cuarta;
    /// al bajar, Fa, como el frigio dominante.
    public static let hicazMakami = TipoDeEscala(
        nombre: "Hicaz makamı",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Hicaz"],
        categoria: .makam,
        afinaciones: [
            .init(.comas53, pasos: [0, 5, 17, 22, 31, 39, 44], pasosDescendentes: [0, 5, 17, 22, 30, 35, 44])
        ])
    /// Hicazkâr (Sol La♭ Si Do Re Mi♭ Fa♯): la doble armónica.
    public static let hicazkarMakami = TipoDeEscala(
        nombre: "Hicazkâr makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["makam Hicazkâr"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 5, 17, 22, 31, 36, 48])])
    /// Nihâvend (Sol La Si♭ Do Re Mi♭ Fa♯): un pentacordo Bûselik y, en la quinta, un tetracordo Hicaz al
    /// subir y uno Kürdî al bajar: la menor armónica y la natural.
    public static let nihavendMakami = TipoDeEscala(
        nombre: "Nihâvend makamı",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Nihâvend"],
        categoria: .makam)
    /// Kürdî (La Si♭ Do Re Mi Fa Sol): el frigio.
    public static let kurdiMakami = TipoDeEscala(
        nombre: "Kürdî makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Kürdî"],
        categoria: .makam)
    /// Bûselik (La Si Do Re Mi Fa Sol): un pentacordo Bûselik y un tetracordo Kürdî, la menor natural.
    public static let buselikMakami = TipoDeEscala(
        nombre: "Bûselik makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Bûselik"],
        categoria: .makam)
    /// Çârgâh (Do Re Mi Fa Sol La Si): la mayor.
    public static let cargahMakami = TipoDeEscala(
        nombre: "Çârgâh makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["makam Çârgâh"],
        categoria: .makam)
    /// Uşşak (La Si Do Re Mi Fa Sol, con Si una koma y media bajo: la segâh): un tetracordo Uşşak y un pentacordo
    /// Bûselik en la cuarta. Aproximado: la menor natural; su segâh solo suena en la versión microtonal.
    public static let ussakMakami = TipoDeEscala(
        nombre: "Uşşak makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Uşşak"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 8, 13, 22, 31, 35, 44])])
    /// Hüseynî (La Si Do Re Mi Fa♯ Sol, con la segâh y Fa♯ una koma bajo): un pentacordo Hüseynî y un tetracordo
    /// Uşşak en la quinta; al bajar, Fa. Aproximado: sube como el dórico y baja como la menor natural.
    public static let huseyniMakami = TipoDeEscala(
        nombre: "Hüseynî makamı",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Hüseynî"],
        categoria: .makam,
        afinaciones: [
            .init(.comas53, pasos: [0, 8, 13, 22, 31, 39, 44], pasosDescendentes: [0, 8, 13, 22, 31, 35, 44])
        ])
    /// Segâh (Si Do Re Mi Fa♯ Sol La, con Si y Fa♯ una koma bajos): un pentacordo Segâh desde la segâh y un
    /// tetracordo Uşşak en la eviç. Aproximado sobre Si: el frigio.
    public static let segahMakami = TipoDeEscala(
        nombre: "Segâh makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Segâh"],
        categoria: .makam,
        // Segâh, desde la segâh (Si una koma bajo): sobre Si, el primer paso es −1.
        afinaciones: [.init(.comas53, pasos: [-1, 4, 13, 22, 30, 35, 44])])
    /// Hüzzam (Si Do Re Mi♭ Fa♯ Sol La, desde la segâh, con Si y Fa♯ una koma bajos y Mi♭ una alto): un pentacordo
    /// Hüzzam y un tetracordo Hicaz en la nevâ. Aproximado sobre Si.
    public static let huzzamMakami = TipoDeEscala(
        nombre: "Hüzzam makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Hüzzam"],
        categoria: .makam,
        // Hüzzam, desde la segâh; Saba, Karcığar, Suzinak, Nikriz y Nev'eser, con las perdes de sus dromoi.
        afinaciones: [.init(.comas53, pasos: [-1, 4, 13, 18, 30, 35, 44])])
    /// Saba (La Si Do Re♭ Mi Fa Sol, con la segâh): un tetracordo Saba y uno Hicaz en la çârgâh. Aproximado: la segâh a
    /// Si, como el dromos Sabáh.
    public static let sabaMakami = TipoDeEscala(
        nombre: "Saba makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Saba"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 8, 13, 18, 31, 35, 44])])
    /// Karcığar (La Si Do Re Mi♭ Fa♯ Sol): un tetracordo Uşşak y un pentacordo Hicaz en la cuarta, como el dromos
    /// Kartzigár.
    public static let karcigarMakami = TipoDeEscala(
        nombre: "Karcığar makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        alias: ["makam Karcığar"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 8, 13, 22, 27, 39, 44])])
    /// Suzinak (Sol La Si Do Re Mi♭ Fa♯): un pentacordo Rast y un tetracordo Hicaz, la mayor armónica.
    public static let suzinakMakami = TipoDeEscala(
        nombre: "Suzinak makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["makam Suzinak"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 9, 17, 22, 31, 36, 48])])
    /// Nikriz (Sol La Si♭ Do♯ Re Mi Fa): un pentacordo Nikriz y un tetracordo Bûselik, el dórico con la 4ª aumentada.
    public static let nikrizMakami = TipoDeEscala(
        nombre: "Nikriz makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["makam Nikriz"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 9, 13, 26, 31, 40, 44])])
    /// Nev'eser (Sol La Si♭ Do♯ Re Mi♭ Fa♯): un pentacordo Nikriz y un tetracordo Hicaz, la menor húngara.
    public static let neveserMakami = TipoDeEscala(
        nombre: "Nev'eser makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["makam Nev'eser"], variantes: ["Neveser makamı"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 9, 13, 26, 31, 36, 48])])

    /// Mâhur (Sol La Si Do Re Mi Fa♯): un pentacordo y un tetracordo Çârgâh, la mayor pitagórica sobre la rast.
    public static let mahurMakami = TipoDeEscala(
        nombre: "Mâhur makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["makam Mâhur"],
        categoria: .makam)
    /// Acemaşiran (Fa Sol La Si♭ Do Re Mi): Çârgâh llevado a la acemaşiran, con el Si♭ (kürdî) en la armadura.
    public static let acemasiranMakami = TipoDeEscala(
        nombre: "Acemaşiran makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["makam Acemaşiran"], variantes: ["Acem-aşiran makamı"],
        categoria: .makam)
    /// Sultânîyegâh (Re Mi Fa Sol La Si♭ Do♯): Bûselik llevado a la yegâh, un pentacordo Bûselik y, en la dügâh, un
    /// tetracordo Hicaz al subir y uno Kürdî al bajar, como Nihâvend.
    public static let sultaniyegahMakami = TipoDeEscala(
        nombre: "Sultânîyegâh makamı",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Sultânîyegâh"],
        categoria: .makam,
        // Sultânîyegâh, Bûselik en la yegâh: el tetracordo Hicaz de la dügâh (Si♭ y Do♯ con bakiye) al subir y el
        // Kürdî al bajar. Şedaraban y Zirgüleli Hicaz, con las perdes de Hicazkâr; Hümâyun y Uzzâl, con el
        // tetracordo Hicaz de Hicaz y su pentacordo Bûselik o su tetracordo Uşşak (eviç, Fa♯ una koma bajo).
        afinaciones: [
            .init(.comas53, pasos: [0, 9, 13, 22, 31, 36, 48], pasosDescendentes: [0, 9, 13, 22, 31, 35, 44])
        ])
    /// Şedaraban (Re Mi♭ Fa♯ Sol La Si♭ Do♯): Zirgüleli Hicaz llevado a la yegâh, un pentacordo Zirgüleli Hicaz y un
    /// tetracordo Hicaz en la dügâh. La doble armónica.
    public static let sedarabanMakami = TipoDeEscala(
        nombre: "Şedaraban makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["makam Şedaraban"], variantes: ["Şedarabân makamı"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 5, 17, 22, 31, 36, 48])])
    /// Hümâyun (La Si♭ Do♯ Re Mi Fa Sol): un tetracordo Hicaz y un pentacordo Bûselik en la nevâ, el frigio
    /// dominante.
    public static let humayunMakami = TipoDeEscala(
        nombre: "Hümâyun makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Hümâyun"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 5, 17, 22, 31, 35, 44])])
    /// Uzzâl (La Si♭ Do♯ Re Mi Fa♯ Sol): un pentacordo Hicaz y un tetracordo Uşşak en la hüseynî, con las notas
    /// de Hicaz al subir.
    public static let uzzalMakami = TipoDeEscala(
        nombre: "Uzzâl makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["makam Uzzâl"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 5, 17, 22, 31, 39, 44])])
    /// Zirgüleli Hicaz (La Si♭ Do♯ Re Mi Fa Sol♯): un pentacordo Hicaz y un tetracordo Hicaz en la hüseynî, la doble
    /// armónica.
    public static let zirguleliHicazMakami = TipoDeEscala(
        nombre: "Zirgüleli Hicaz makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["makam Zirgüleli Hicaz"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 5, 17, 22, 31, 36, 48])])

    /// Kürdîlihicazkâr (Sol La♭ Si♭ Do Re Mi♭ Fa): el Kürdî llevado a la rast, inicio y reposo de un makam que arriba
    /// toma prestadas las regiones de Hicazkâr, Arazbar o de un Bûselik en la çârgâh. Su dizi de la rast es el frigio.
    public static let kurdilihicazkarMakami = TipoDeEscala(
        nombre: "Kürdîlihicazkâr makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Kürdîlihicazkâr"], variantes: ["Kürdîli Hicazkâr makamı"],
        categoria: .makam,
        // Kürdîlihicazkâr, con las perdes de Kürdî en la rast (La♭, Si♭ y Mi♭ con küçük mücennep); Muhayyer, con
        // las de Hüseynî; Ferahfezâ, con las de Acemaşiran desde la yegâh, e Isfahan, con las de Uşşak.
        afinaciones: [.init(.comas53, pasos: [0, 4, 13, 22, 31, 35, 44])])
    /// Muhayyer (La Si Do Re Mi Fa♯ Sol, con la segâh y Fa♯ una koma bajo): las notas de Hüseynî, un pentacordo
    /// Hüseynî y un tetracordo Uşşak en la hüseynî, pero bajando desde la muhayyer, la octava aguda.
    public static let muhayyerMakami = TipoDeEscala(
        nombre: "Muhayyer makamı",
        intervalos: TipoDeEscala.dorico.intervalos,
        alias: ["makam Muhayyer"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 8, 13, 22, 31, 39, 44])])
    /// Ferahfezâ (Re Mi Fa Sol La Si♭ Do): las notas de Acemaşiran con un pentacordo Bûselik en la yegâh, donde
    /// reposa: la menor natural sobre Re.
    public static let ferahfezaMakami = TipoDeEscala(
        nombre: "Ferahfezâ makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Ferahfezâ"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 9, 13, 22, 31, 35, 44])])
    /// Isfahan (La Si Do Re Mi Fa Sol, con la segâh): un tetracordo Uşşak y un pentacordo Bûselik en la nevâ, las
    /// notas de Uşşak, que sube y baja como Bayatî. Aproximado: la menor natural.
    public static let isfahanMakami = TipoDeEscala(
        nombre: "Isfahan makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Isfahan"], variantes: ["İsfahan makamı"],
        categoria: .makam, afinaciones: [.init(.comas53, pasos: [0, 8, 13, 22, 31, 35, 44])])

    /// Los makamlar: los que el temperamento igual escribe sin cambiarles el carácter y los que solo se oyen bien
    /// con su versión microtonal (Uşşak, Hüseynî y Segâh).
    package static let makamlar: [TipoDeEscala] = [
        .rastMakami, .hicazMakami, .hicazkarMakami, .nihavendMakami, .kurdiMakami, .buselikMakami, .cargahMakami,
        .ussakMakami, .huseyniMakami, .segahMakami, .huzzamMakami, .sabaMakami, .karcigarMakami, .suzinakMakami,
        .nikrizMakami, .neveserMakami, .mahurMakami, .acemasiranMakami, .sultaniyegahMakami, .sedarabanMakami,
        .humayunMakami, .uzzalMakami, .zirguleliHicazMakami, .kurdilihicazkarMakami, .muhayyerMakami,
        .ferahfezaMakami, .isfahanMakami,
    ]

    // MARK: Çeşni (fragmentos)
    //
    // Los dörtlü (tetracordos) y beşli (pentacordos) de AEU, de los que se hacen los makamlar: Rast es un beşli Rast
    // en la rast y un dörtlü Rast en la nevâ. Son seis, cada uno de cuatro y de cinco notas: Çârgâh, Bûselik, Kürdî,
    // Rast, Uşşak y Hicaz. Los tres primeros son pitagóricos y no cambian al redondear; los otros tres tienen versión
    // microtonal (la segâh de Rast y Uşşak, la segunda aumentada de Hicaz, de 12 comas).

    /// Do Re Mi Fa.
    public static let cargahDortlusu = TipoDeEscala(
        nombre: "Çârgâh dörtlüsü", intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta],
        categoria: .cesni)
    /// Do Re Mi Fa Sol.
    public static let cargahBeslisi = TipoDeEscala(
        nombre: "Çârgâh beşlisi", intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta],
        categoria: .cesni)
    /// La Si Do Re.
    public static let buselikDortlusu = TipoDeEscala(
        nombre: "Bûselik dörtlüsü", intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta],
        categoria: .cesni)
    /// La Si Do Re Mi.
    public static let buselikBeslisi = TipoDeEscala(
        nombre: "Bûselik beşlisi", intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta],
        categoria: .cesni)
    /// La Si♭ Do Re.
    public static let kurdiDortlusu = TipoDeEscala(
        nombre: "Kürdî dörtlüsü", intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta],
        categoria: .cesni)
    /// La Si♭ Do Re Mi.
    public static let kurdiBeslisi = TipoDeEscala(
        nombre: "Kürdî beşlisi", intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaJusta],
        categoria: .cesni)
    /// Sol La Si Do, con Si una koma bajo.
    public static let rastDortlusu = TipoDeEscala(
        nombre: "Rast dörtlüsü", intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta],
        categoria: .cesni,
        // Çeşni.
        afinaciones: [.init(.comas53, pasos: [0, 9, 17, 22])])
    /// Sol La Si Do Re, con Si una koma bajo.
    public static let rastBeslisi = TipoDeEscala(
        nombre: "Rast beşlisi", intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta],
        categoria: .cesni, afinaciones: [.init(.comas53, pasos: [0, 9, 17, 22, 31])])
    /// La Si Do Re, con la segâh (Si una koma bajo). Aproximado: La Si Do Re.
    public static let ussakDortlusu = TipoDeEscala(
        nombre: "Uşşak dörtlüsü", intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta],
        categoria: .cesni, afinaciones: [.init(.comas53, pasos: [0, 8, 13, 22])])
    /// La Si Do Re Mi, con la segâh.
    public static let ussakBeslisi = TipoDeEscala(
        nombre: "Uşşak beşlisi", intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta],
        categoria: .cesni, afinaciones: [.init(.comas53, pasos: [0, 8, 13, 22, 31])])
    /// La Si♭ Do♯ Re.
    public static let hicazDortlusu = TipoDeEscala(
        nombre: "Hicaz dörtlüsü", intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta],
        categoria: .cesni, afinaciones: [.init(.comas53, pasos: [0, 5, 17, 22])])
    /// La Si♭ Do♯ Re Mi.
    public static let hicazBeslisi = TipoDeEscala(
        nombre: "Hicaz beşlisi", intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta],
        categoria: .cesni, afinaciones: [.init(.comas53, pasos: [0, 5, 17, 22, 31])])

    package static let cesniler: [TipoDeEscala] = [
        .cargahDortlusu, .cargahBeslisi, .buselikDortlusu, .buselikBeslisi, .kurdiDortlusu, .kurdiBeslisi,
        .rastDortlusu, .rastBeslisi, .ussakDortlusu, .ussakBeslisi, .hicazDortlusu, .hicazBeslisi,
    ]
}
