import Elementos

// MARK: - India: el Nāṭyaśāstra

extension TipoDeEscala {
    // MARK: Grāma y mūrchanā (el Nāṭyaśāstra)
    //
    // Las escalas madre del Nāṭyaśāstra de Bharata (hacia el siglo II) y del Dattilam. El ṣaḍja-grāma reparte los 22
    // śruti de la octava entre sus siete notas (Sa 4, Ri 3, Ga 2, Ma 4, Pa 4, Dha 3, Ni 2, cada nota en el último
    // śruti de su intervalo) y el madhyama-grāma baja Pa un śruti (Pa 3, Dha 4). Cada grāma da siete mūrchanā, la
    // escala que empieza en cada una de sus notas, en el orden del texto: las del ṣaḍja-grāma bajan desde Sa
    // (Uttaramandrā) hasta Ri; las del madhyama-grāma, desde Ma (Sauvīrī) hasta Pa.
    //
    // Se escriben como el modelo de E. J. Arnold de los thāṭ, el que siguen los śruti de sus `afinaciones:`: el
    // ṣaḍja-grāma es Sa Ri(10/9) ga(32/27) ma(4/3) Pa(3/2) Dha(5/3) ni(16/9), las notas de Kāfī, y el madhyama-grāma
    // tiene Pa una coma sintónica más bajo (40/27). Cada mūrchanā lleva las razones de su grāma contadas desde su
    // primera nota. En doce notas son los siete modos diatónicos (el ṣaḍja-grāma es el dórico); su versión microtonal
    // va en los 22 śruti, salvo la de las que tienen una razón que no es uno de ellos (la quinta una coma corta de
    // 40/27 o la quinta disminuida de 64/45), que va en cents.

    /// El ṣaḍja-grāma, desde Sa: el dórico en doce notas.
    public static let sadjaGrama = TipoDeEscala(
        nombre: "ṣaḍja-grāma",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["shadja grama", "shadjagrama"], nombresOriginales: [.init("षड्जग्राम", .sanscrito)],
        categoria: .grama,
        // Grāma y mūrchanā del Nāṭyaśāstra, con las razones de los thāṭ: en śruti, por su número desde Sa, y en
        // cents las que tienen una quinta una coma corta (40/27) o la quinta disminuida de 64/45, que no son
        // ninguno de los 22.
        afinaciones: [.init(.sruti, pasos: [0, 3, 5, 9, 13, 16, 18])])
    /// El madhyama-grāma, desde Sa: el dórico en doce notas.
    public static let madhyamaGrama = TipoDeEscala(
        nombre: "madhyama-grāma",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["madhyamagrama"], nombresOriginales: [.init("मध्यमग्राम", .sanscrito)],
        categoria: .grama,
        afinaciones: [.init(.razones, pasos: [0, 182, 294, 498, 680, 884, 996])])
    /// La mūrchanā del ṣaḍja-grāma desde Sa: el dórico en doce notas.
    public static let uttaramandra = TipoDeEscala(
        nombre: "Uttaramandrā",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        nombresOriginales: [.init("उत्तरमन्द्रा", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama, afinaciones: [.init(.sruti, pasos: [0, 3, 5, 9, 13, 16, 18])])
    /// La mūrchanā del ṣaḍja-grāma desde Ni: la mayor en doce notas.
    public static let rajani = TipoDeEscala(
        nombre: "Rajanī",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        nombresOriginales: [.init("रजनी", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama, afinaciones: [.init(.sruti, pasos: [0, 4, 7, 9, 13, 17, 20])])
    /// La mūrchanā del ṣaḍja-grāma desde Dha: el locrio en doce notas.
    public static let uttarayata = TipoDeEscala(
        nombre: "Uttarāyatā",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        nombresOriginales: [.init("उत्तरायता", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama,
        afinaciones: [.init(.razones, pasos: [0, 112, 316, 498, 610, 814, 1018])])
    /// La mūrchanā del ṣaḍja-grāma desde Pa: el eólico en doce notas.
    public static let suddhasadja = TipoDeEscala(
        nombre: "Śuddhaṣaḍjā",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        variantes: ["Shuddhashadja"], nombresOriginales: [.init("शुद्धषड्जा", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama,
        afinaciones: [.init(.razones, pasos: [0, 182, 294, 498, 680, 792, 996])])
    /// La mūrchanā del ṣaḍja-grāma desde Ma: el mixolidio en doce notas.
    public static let matsarikrta = TipoDeEscala(
        nombre: "Matsarīkṛtā",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Matsarikrita"], nombresOriginales: [.init("मत्सरीकृता", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama, afinaciones: [.init(.sruti, pasos: [0, 4, 7, 9, 13, 16, 18])])
    /// La mūrchanā del ṣaḍja-grāma desde Ga: el lidio en doce notas.
    public static let asvakranta = TipoDeEscala(
        nombre: "Aśvakrāntā",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["Ashvakranta"], nombresOriginales: [.init("अश्वक्रान्ता", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama, afinaciones: [.init(.sruti, pasos: [0, 4, 8, 11, 13, 17, 20])])
    /// La mūrchanā del ṣaḍja-grāma desde Ri: el frigio en doce notas.
    public static let abhirudgata = TipoDeEscala(
        nombre: "Abhirudgatā",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        nombresOriginales: [.init("अभिरुद्गता", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama, afinaciones: [.init(.sruti, pasos: [0, 2, 6, 10, 13, 15, 19])])
    /// La mūrchanā del madhyama-grāma desde Ma: el mixolidio en doce notas.
    public static let sauviri = TipoDeEscala(
        nombre: "Sauvīrī",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        nombresOriginales: [.init("सौवीरी", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama, afinaciones: [.init(.sruti, pasos: [0, 3, 7, 9, 13, 16, 18])])
    /// La mūrchanā del madhyama-grāma desde Ga: el lidio en doce notas.
    public static let harinasva = TipoDeEscala(
        nombre: "Hariṇāśvā",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["Harinashva"], nombresOriginales: [.init("हरिणाश्वा", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama, afinaciones: [.init(.sruti, pasos: [0, 4, 7, 11, 13, 17, 20])])
    /// La mūrchanā del madhyama-grāma desde Ri: el frigio en doce notas.
    public static let kalopanata = TipoDeEscala(
        nombre: "Kalopanatā",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        nombresOriginales: [.init("कलोपनता", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama, afinaciones: [.init(.sruti, pasos: [0, 2, 6, 9, 13, 15, 19])])
    /// La mūrchanā del madhyama-grāma desde Sa: el dórico en doce notas.
    public static let suddhamadhya = TipoDeEscala(
        nombre: "Śuddhamadhyā",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Shuddhamadhya"], nombresOriginales: [.init("शुद्धमध्या", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama,
        afinaciones: [.init(.razones, pasos: [0, 182, 294, 498, 680, 884, 996])])
    /// La mūrchanā del madhyama-grāma desde Ni: la mayor en doce notas.
    public static let margi = TipoDeEscala(
        nombre: "Mārgī",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        nombresOriginales: [.init("मार्गी", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama, afinaciones: [.init(.sruti, pasos: [0, 4, 7, 9, 13, 16, 20])])
    /// La mūrchanā del madhyama-grāma desde Dha: el locrio en doce notas.
    public static let pauravi = TipoDeEscala(
        nombre: "Pauravī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        nombresOriginales: [.init("पौरवी", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama,
        afinaciones: [.init(.razones, pasos: [0, 112, 316, 498, 610, 814, 996])])
    /// La mūrchanā del madhyama-grāma desde Pa: el eólico en doce notas.
    public static let hrsyaka = TipoDeEscala(
        nombre: "Hṛṣyakā",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        variantes: ["Hrishyaka"], nombresOriginales: [.init("हृष्यका", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama, afinaciones: [.init(.sruti, pasos: [0, 4, 6, 10, 13, 15, 19])])

    /// Los dos grāma.
    package static let gramas: [TipoDeEscala] = [.sadjaGrama, .madhyamaGrama]
    /// Las catorce mūrchanā, en el orden del Nāṭyaśāstra: las siete del ṣaḍja-grāma y las siete del madhyama-grāma.
    package static let murchanas: [TipoDeEscala] = [
        .uttaramandra, .rajani, .uttarayata, .suddhasadja, .matsarikrta, .asvakranta, .abhirudgata,
        .sauviri, .harinasva, .kalopanata, .suddhamadhya, .margi, .pauravi, .hrsyaka,
    ]
}
