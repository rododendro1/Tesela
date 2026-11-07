// MARK: - Tablas de los sistemas de nombres
//
// Los nombres de cada `SistemaDeNombres` en sus tres grafías (original, transliterada y ASCII), y los que se leen
// además: la otra transliteración de Βου (Bou), el komal y el tivra del sargam, los lü chinos en caracteres
// tradicionales y los coreanos en hanja. Fuentes: Wikipedia («Byzantine music», «Svara», «Japanese musical scales»,
// «Korean musical notation», «Twelve-tone equal temperament» en sus versiones china, japonesa y coreana, «Solfège»
// en árabe y en hebreo) y el catálogo de escalas de Tesela, con los lü chinos de `TipoDeEscala.shierLu`.

extension SistemaDeNombres {
    /// Cómo nombra el sistema las notas: con siete nombres o con doce, y sus tablas.
    var disposicion: Disposicion {
        switch self {
        case .bizantino:
            return .siete(
                naturales: { grafia in
                    grafia == .original
                        ? ["Νη", "Πα", "Βου", "Γα", "Δι", "Κε", "Ζω"] : ["Ni", "Pa", "Vou", "Ga", "Di", "Ke", "Zo"]
                },
                alteraciones: .signos)
        case .sargam:
            return .siete(
                naturales: { grafia in
                    switch grafia {
                    case .original: return ["सा", "रे", "ग", "म", "प", "ध", "नि"]
                    case .transliterada: return ["Sā", "Re", "Ga", "ma", "Pa", "Dha", "Ni"]
                    case .ascii: return ["Sa", "Re", "Ga", "ma", "Pa", "Dha", "Ni"]
                    }
                },
                alteraciones: .propias({ grafia in
                    // El komal y el tivra: en devanagari, con la raya de debajo (U+0952) y el trazo de encima (U+0951).
                    switch grafia {
                    case .original:
                        return SistemaDeNombres.propias([
                            (1, -1, "रे\u{0952}"), (2, -1, "ग\u{0952}"), (3, 1, "म\u{0951}"), (5, -1, "ध\u{0952}"),
                            (6, -1, "नि\u{0952}"),
                        ])
                    case .transliterada, .ascii:
                        return SistemaDeNombres.propias([
                            (1, -1, "re"), (2, -1, "ga"), (3, 1, "Ma"), (5, -1, "dha"), (6, -1, "ni"),
                        ])
                    }
                }))
        case .japones:
            return .siete(
                naturales: { grafia in
                    grafia == .original
                        ? ["ハ", "ニ", "ホ", "ヘ", "ト", "イ", "ロ"] : ["Ha", "Ni", "Ho", "He", "To", "I", "Ro"]
                },
                alteraciones: .prefijos({ grafia in
                    switch grafia {
                    case .original: return ["嬰", "変", "重嬰", "重変"]
                    case .transliterada: return ["ei ", "hen ", "jū-ei ", "jū-hen "]
                    case .ascii: return ["ei ", "hen ", "ju-ei ", "ju-hen "]
                    }
                }))
        case .coreano:
            return .siete(
                naturales: { grafia in
                    grafia == .original
                        ? ["다", "라", "마", "바", "사", "가", "나"] : ["Da", "Ra", "Ma", "Ba", "Sa", "Ga", "Na"]
                },
                alteraciones: .prefijos({ grafia in
                    grafia == .original
                        ? ["올림", "내림", "겹올림", "겹내림"] : ["ollim ", "naerim ", "gyeop-ollim ", "gyeop-naerim "]
                }))
        case .guidoniano:
            return .siete(naturales: { _ in ["Ut", "Re", "Mi", "Fa", "Sol", "La", "Si"] }, alteraciones: .signos)
        case .luChinos:
            return .doce(
                nombres: { grafia in
                    switch grafia {
                    case .original:
                        return ["黄钟", "大吕", "太簇", "夹钟", "姑洗", "仲吕", "蕤宾", "林钟", "夷则", "南吕", "无射", "应钟"]
                    case .transliterada:
                        return [
                            "huángzhōng", "dàlǚ", "tàicù", "jiāzhōng", "gūxiǎn", "zhònglǚ", "ruíbīn", "línzhōng",
                            "yízé", "nánlǚ", "wúyì", "yìngzhōng",
                        ]
                    case .ascii:
                        return [
                            "huangzhong", "dalu", "taicu", "jiazhong", "guxian", "zhonglu", "ruibin", "linzhong",
                            "yize", "nanlu", "wuyi", "yingzhong",
                        ]
                    }
                },
                primera: 0, desdeQuinta: 0)
        case .luJaponeses:
            return .doce(
                nombres: { grafia in
                    switch grafia {
                    case .original:
                        return ["壱越", "断金", "平調", "勝絶", "下無", "双調", "鳧鐘", "黄鐘", "鸞鏡", "盤渉", "神仙", "上無"]
                    case .transliterada:
                        return [
                            "ichikotsu", "tangin", "hyōjō", "shōsetsu", "shimomu", "sōjō", "fushō", "ōshiki", "rankei",
                            "banshiki", "shinsen", "kamimu",
                        ]
                    case .ascii:
                        return [
                            "ichikotsu", "tangin", "hyojo", "shosetsu", "shimomu", "sojo", "fusho", "oshiki", "rankei",
                            "banshiki", "shinsen", "kamimu",
                        ]
                    }
                },
                primera: 2, desdeQuinta: -1)
        case .luCoreanos:
            return .doce(
                nombres: { grafia in
                    grafia == .original
                        ? ["황종", "대려", "태주", "협종", "고선", "중려", "유빈", "임종", "이칙", "남려", "무역", "응종"]
                        : [
                            "hwangjong", "daeryeo", "taeju", "hyeopjong", "goseon", "jungnyeo", "yubin", "imjong",
                            "ichik", "namnyeo", "muyeok", "eungjong",
                        ]
                },
                primera: 3, desdeQuinta: -3)
        case .jianpu:
            return .siete(
                naturales: { _ in ["1", "2", "3", "4", "5", "6", "7"] },
                alteraciones: .prefijos({ grafia in grafia == .ascii ? ["#", "b", "##", "bb"] : ["♯", "♭", "𝄪", "𝄫"] }))
        case .gongche:
            return .siete(
                naturales: { grafia in
                    switch grafia {
                    case .original: return ["上", "尺", "工", "凡", "六", "五", "乙"]
                    case .transliterada: return ["shàng", "chě", "gōng", "fán", "liù", "wǔ", "yǐ"]
                    case .ascii: return ["shang", "che", "gong", "fan", "liu", "wu", "yi"]
                    }
                },
                alteraciones: .signos)
        case .wusheng:
            return .siete(
                naturales: { grafia in
                    switch grafia {
                    case .original: return ["宫", "商", "角", "清角", "徵", "羽", "变宫"]
                    case .transliterada: return ["gōng", "shāng", "jué", "qīngjué", "zhǐ", "yǔ", "biàngōng"]
                    case .ascii: return ["gong", "shang", "jue", "qingjue", "zhi", "yu", "biangong"]
                    }
                },
                alteraciones: .propias({ grafia in
                    switch grafia {
                    case .original: return SistemaDeNombres.propias([(3, 1, "变徵"), (6, -1, "闰")])
                    case .transliterada: return SistemaDeNombres.propias([(3, 1, "biànzhǐ"), (6, -1, "rùn")])
                    case .ascii: return SistemaDeNombres.propias([(3, 1, "bianzhi"), (6, -1, "run")])
                    }
                }))
        case .carnatico:
            return .siete(
                naturales: { grafia in
                    let (uno, dos, tres) = grafia == .ascii ? ("1", "2", "3") : ("₁", "₂", "₃")
                    return ["Sa", "Ri" + dos, "Ga" + tres, "Ma" + uno, "Pa", "Da" + dos, "Ni" + tres]
                },
                alteraciones: .propias({ grafia in
                    let (uno, dos, tres) = grafia == .ascii ? ("1", "2", "3") : ("₁", "₂", "₃")
                    return SistemaDeNombres.propias([
                        (1, -1, "Ri" + uno), (1, 1, "Ri" + tres), (2, -2, "Ga" + uno), (2, -1, "Ga" + dos),
                        (3, 1, "Ma" + dos), (5, -1, "Da" + uno), (5, 1, "Da" + tres), (6, -2, "Ni" + uno),
                        (6, -1, "Ni" + dos),
                    ])
                }))
        case .tonicSolFa:
            return .siete(naturales: { _ in ["d", "r", "m", "f", "s", "l", "t"] }, alteraciones: .signos)
        case .notasDeForma:
            return .siete(naturales: { _ in ["fa", "sol", "la", "fa", "sol", "la", "mi"] }, alteraciones: .signos)
        case .solfeoArabe:
            return .siete(
                naturales: { grafia in
                    grafia == .original ? ["دو", "ري", "مي", "فا", "صول", "لا", "سي"] : SistemaDeNombres.solfeo
                },
                alteraciones: .signos)
        case .solfeoHebreo:
            return .siete(
                naturales: { grafia in
                    grafia == .original ? ["דו", "רה", "מי", "פה", "סול", "לה", "סי"] : SistemaDeNombres.solfeo
                },
                alteraciones: .signos)
        }
    }

    /// Los nombres del solfeo latino, la transliteración del árabe y del hebreo.
    private static let solfeo = ["Do", "Re", "Mi", "Fa", "Sol", "La", "Si"]

    /// Los nombres propios de una lista de (grado, alteración, nombre).
    private static func propias(_ lista: [(Int, Int, String)]) -> [NombrePropio] {
        lista.map { NombrePropio(indice: $0.0, alteracion: $0.1, nombre: $0.2) }
    }

    /// Los nombres que se leen además de los de las tres grafías, con su nota (o su grado, en el sargam).
    var otrasFormas: [(String, Nota)] {
        switch self {
        case .bizantino:
            // La otra transliteración de Βου, la que sigue la letra.
            return [("Bou", Nota(.mi))]
        case .sargam:
            // Sa y Pa en minúscula, que no se confunden con nada.
            return [("sa", Nota(.do)), ("pa", Nota(.sol))]
        case .japones, .coreano, .guidoniano, .jianpu, .gongche, .tonicSolFa, .notasDeForma, .solfeoArabe,
            .solfeoHebreo:
            return []
        case .wusheng:
            // En caracteres tradicionales.
            return [("宮", Nota(.do)), ("變宮", Nota(.si)), ("變徵", Nota(.fa, .sostenido)), ("閏", Nota(.si, .bemol))]
        case .carnatico:
            // Abreviados, con la inicial: S R1 R2 R3 G1… N3, como se suelen escribir.
            return [
                ("S", Nota(.do)), ("R1", Nota(.re, .bemol)), ("R2", Nota(.re)), ("R3", Nota(.re, .sostenido)),
                ("G1", Nota(.mi, .dobleBemol)), ("G2", Nota(.mi, .bemol)), ("G3", Nota(.mi)), ("M1", Nota(.fa)),
                ("M2", Nota(.fa, .sostenido)), ("P", Nota(.sol)), ("D1", Nota(.la, .bemol)), ("D2", Nota(.la)),
                ("D3", Nota(.la, .sostenido)), ("N1", Nota(.si, .dobleBemol)), ("N2", Nota(.si, .bemol)),
                ("N3", Nota(.si)),
            ]
        case .luChinos:
            // En caracteres tradicionales, y con la ü escrita como v, como se teclea el pinyin.
            let tradicionales = ["黃鐘", "大呂", "太簇", "夾鐘", "姑洗", "仲呂", "蕤賓", "林鐘", "夷則", "南呂", "無射", "應鐘"]
            let conV = [("dalv", 1), ("zhonglv", 5), ("nanlv", 9)].map { nombre, clase in
                (nombre, SistemaDeNombres.notaDeLaClase(clase, desdeQuinta: 0))
            }
            return SistemaDeNombres.formas(tradicionales, primera: 0, desdeQuinta: 0) + conV
        case .luCoreanos:
            // En hanja, con el nombre entero y con la sílaba del jeongganbo.
            let enteros = ["黃鍾", "大呂", "太簇", "夾鍾", "姑洗", "仲呂", "蕤賓", "林鍾", "夷則", "南呂", "無射", "應鍾"]
            let silabas = ["黃", "大", "太", "夾", "姑", "仲", "蕤", "林", "夷", "南", "無", "應"]
            return SistemaDeNombres.formas(enteros, primera: 3, desdeQuinta: -3)
                + SistemaDeNombres.formas(silabas, primera: 3, desdeQuinta: -3)
        case .luJaponeses:
            return []
        }
    }

    /// Doce nombres, uno por semitono desde la clase de altura `primera`, con sus notas en la cadena de quintas que
    /// empieza en `desdeQuinta`.
    private static func formas(_ nombres: [String], primera: Int, desdeQuinta: Int) -> [(String, Nota)] {
        nombres.enumerated().map { indice, nombre in
            (nombre, notaDeLaClase(primera + indice, desdeQuinta: desdeQuinta))
        }
    }
}
