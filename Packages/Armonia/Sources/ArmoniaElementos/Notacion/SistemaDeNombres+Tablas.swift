// MARK: - Tablas de los sistemas de nombres
//
// Los nombres de cada `SistemaDeNombres` en sus tres grafías (original, transliterada y ASCII), y los que se leen
// además: la otra transliteración de Βου (Bou), el komal y el tivra del sargam, los lü chinos en caracteres
// tradicionales y los coreanos en hanja. Fuentes: Wikipedia («Byzantine music», «Svara», «Japanese musical scales»,
// «Korean musical notation», «Twelve-tone equal temperament» en sus versiones china, japonesa y coreana) y el
// catálogo de escalas de Tesela, con los lü chinos de `TipoDeEscala.shierLu`.

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
                alteraciones: .sargam)
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
        }
    }

    /// Los nombres que se leen además de los de las tres grafías, con su nota (o su grado, en el sargam).
    var otrasFormas: [(String, Nota)] {
        switch self {
        case .bizantino:
            // La otra transliteración de Βου, la que sigue la letra.
            return [("Bou", Nota(.mi))]
        case .sargam:
            // El komal y el tivra transliterados, y Sa y Pa en minúscula, que no se confunden con nada.
            return [
                ("re", Nota(.re, .bemol)), ("ga", Nota(.mi, .bemol)), ("dha", Nota(.la, .bemol)),
                ("ni", Nota(.si, .bemol)), ("Ma", Nota(.fa, .sostenido)), ("sa", Nota(.do)), ("pa", Nota(.sol)),
            ]
        case .japones, .coreano, .guidoniano:
            return []
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
