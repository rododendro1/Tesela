import Elementos

// MARK: - El período de una escala en su tradición

/// Un período de la historia de una tradición no europea, con los nombres que se usan en ella: los de la teoría india
/// (del Nāṭyaśāstra, de los mēḷa), los de la teoría árabe, persa y turca (abasí, sistematista, de Cantemir) y las
/// dinastías chinas y los períodos japoneses. Las épocas (`Epoca`) son europeas y sirven para filtrar todo el catálogo;
/// el período dice lo mismo como se dice en cada tradición.
///
/// No se escribe en las escalas: sale de su tradición y del año en que aparece (`TipoDeEscala.anioDeOrigen`), con
/// `PeriodoMusical.de(_:anio:)`.
///
///     TipoDeEscala.melakarta(29)?.periodo    // .mela (Veṅkaṭamakhin, 1660)
///     TipoDeEscala.rastMakami.periodo        // .cantemir (hacia 1700)
public enum PeriodoMusical: String, Sendable, Codable, CaseIterable {
    // India. Los años de cada período, en todos, están en `tabla(de:)`.
    /// Los Vedas y el canto del Sāmaveda.
    case vedico
    /// El Nāṭyaśāstra, sus grāma y sus mūrchanā.
    case natyasastra
    /// El Saṅgītaratnākara de Śārṅgadeva y los tratados que lo siguen.
    case sangitaratnakara
    /// Los 72 mēḷa de Veṅkaṭamakhin y la música carnática de la Trinidad.
    case mela
    /// Los thāṭ de Bhātkhaṇḍe y la teoría india de hoy.
    case bhatkhande

    // Mundo árabe, Persia, Turquía y Azerbaiyán
    /// Al-Kindī, al-Fārābī y la teoría de la corte de Bagdad.
    case abasi
    /// Ṣafī al-Dīn y la escuela sistematista, con sus diecisiete notas.
    case sistematista
    /// Los imperios otomano y safávida; acaba en otro año en cada tradición.
    case otomanoSafavi
    /// En Persia, la corte qayar, donde Mirzā ʿAbdollāh fijó el radif y sus dastgāh.
    case qayar
    /// En el mundo árabe, el Congreso de Música Árabe de El Cairo y la teoría árabe de hoy.
    case congresoDelCairo
    /// En Turquía, Cantemir y su notación por letras.
    case cantemir
    /// En Turquía, Selim III y los makamlar nuevos de su corte (Hicazkâr, Suzinâk, Ferahfezâ).
    case selimIII
    /// En Turquía, la teoría de Arel, Ezgi y Uzdilek, en 53 comas.
    case arelEzgiUzdilek

    // China
    /// El Guanzi y el Lüshi chunqiu.
    case zhou
    /// Las dinastías Qin y Han.
    case qinHan
    /// Las Seis Dinastías.
    case seisDinastias
    /// La dinastía Tang.
    case tang
    /// La dinastía Song.
    case song
    /// La dinastía Yuan.
    case yuan
    /// La dinastía Ming: el temperamento igual de Zhu Zaiyu.
    case ming
    /// La dinastía Qing.
    case qing

    // Japón
    /// Los períodos Nara y Heian: el gagaku de la corte.
    case naraHeian
    /// Los períodos Kamakura y Muromachi.
    case kamakuraMuromachi
    /// El período Edo: el koto, el shamisen y la escala in.
    case edo

    /// La música de hoy en Persia, Azerbaiyán, China y Japón.
    case moderno

    /// Los períodos de una tradición, en orden, con sus años: desde el primero y hasta el anterior al del siguiente.
    /// Vacío si la tradición no los tiene. Es la única tabla de los límites: de ella salen `de(_:anio:)`,
    /// `periodos(de:)` y `anios(en:)`. El primero empieza donde empieza la tradición (antes, `nil`) y el último acaba
    /// en `Int.max`. Un mismo período puede tener otros años en otra tradición: el otomano y safávida acaba en 1650 en
    /// Turquía, en 1736 en Persia, en 1900 en Azerbaiyán y en 1932 en el mundo árabe. El `switch` no tiene `default`:
    /// una tradición nueva no compila sin decir los suyos.
    ///
    ///     PeriodoMusical.tabla(de: .japon).first   // (.naraHeian, 710..<1185)
    public static func tabla(de tradicion: Tradicion) -> [(periodo: PeriodoMusical, anios: Range<Int>)] {
        let tabla: [(PeriodoMusical, Int)]
        switch tradicion {
        case .india:
            tabla = [
                (.vedico, Int.min), (.natyasastra, -500), (.sangitaratnakara, 1200), (.mela, 1660), (.bhatkhande, 1900),
            ]
        case .mundoArabe:
            tabla = [(.abasi, 750), (.sistematista, 1250), (.otomanoSafavi, 1500), (.congresoDelCairo, 1932)]
        case .azerbaiyan:
            tabla = [(.abasi, 750), (.sistematista, 1250), (.otomanoSafavi, 1500), (.moderno, 1900)]
        case .persia:
            tabla = [(.abasi, 750), (.sistematista, 1250), (.otomanoSafavi, 1500), (.qayar, 1736), (.moderno, 1925)]
        case .turquia:
            tabla = [
                (.abasi, 750), (.sistematista, 1250), (.otomanoSafavi, 1500), (.cantemir, 1650), (.selimIII, 1789),
                (.arelEzgiUzdilek, 1910),
            ]
        case .china:
            tabla = [
                (.zhou, -1046), (.qinHan, -221), (.seisDinastias, 220), (.tang, 618), (.song, 960), (.yuan, 1271),
                (.ming, 1368), (.qing, 1644), (.moderno, 1912),
            ]
        case .japon:
            tabla = [(.naraHeian, 710), (.kamakuraMuromachi, 1185), (.edo, 1603), (.moderno, 1868)]
        case .occidental, .grecia, .greciaAntigua, .mesopotamia, .gregoriano, .renacimiento, .corea, .etiopia,
            .indonesia, .klezmer, .andes, .bizancio, .africa, .sudesteAsiatico, .europa, .vietnam, .brasil:
            tabla = []
        }
        return tabla.indices.map { i in
            (tabla[i].0, tabla[i].1..<(i + 1 < tabla.count ? tabla[i + 1].1 : Int.max))
        }
    }

    /// El período de un año en una tradición, o `nil` si la tradición no tiene períodos propios o el año cae antes del
    /// primero. Los de una tradición se suceden sin huecos (`tabla(de:)`).
    ///
    ///     PeriodoMusical.de(.india, anio: 1660)     // .mela
    ///     PeriodoMusical.de(.china, anio: -239)     // .zhou
    public static func de(_ tradicion: Tradicion, anio: Int) -> PeriodoMusical? {
        tabla(de: tradicion).first { $0.anios.contains(anio) }?.periodo
    }

    /// Los períodos de una tradición, en orden; vacío si no los tiene. Son los de `tabla(de:)`.
    public static func periodos(de tradicion: Tradicion) -> [PeriodoMusical] { tabla(de: tradicion).map(\.periodo) }

    /// Sus años en una tradición, o `nil` si no es de ella (`tabla(de:)`).
    ///
    ///     PeriodoMusical.cantemir.anios(en: .turquia)   // 1650..<1789
    public func anios(en tradicion: Tradicion) -> Range<Int>? {
        PeriodoMusical.tabla(de: tradicion).first { $0.periodo == self }?.anios
    }

    /// El nombre con sus años en una tradición, con «…» donde no tiene: «período de Cantemir (1650–1789)». Los años
    /// antes de Cristo van con signo menos. Solo el nombre si no es de esa tradición.
    public func nombreConAnios(en tradicion: Tradicion, notacion: Notacion) -> String {
        guard let anios = anios(en: tradicion) else { return nombre(en: notacion) }
        let inicio = anios.lowerBound == Int.min ? "…" : String(anios.lowerBound)
        let fin = anios.upperBound == Int.max ? "…" : String(anios.upperBound)
        return nombre(en: notacion) + " (" + inicio + "–" + fin + ")"
    }

    /// El nombre en el idioma de los textos de la notación: «período de los mēḷa», «mēḷa period». En español, también
    /// `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`. El `switch` no tiene `default`: un período nuevo no
    /// compila sin el suyo.
    private var traduccion: Traduccion {
        switch self {
        case .vedico: TextosDeTeoria.traduccion(\.periodoVedico)
        case .natyasastra: TextosDeTeoria.traduccion(\.periodoNatyasastra)
        case .sangitaratnakara: TextosDeTeoria.traduccion(\.periodoSangitaratnakara)
        case .mela: TextosDeTeoria.traduccion(\.periodoMela)
        case .bhatkhande: TextosDeTeoria.traduccion(\.periodoBhatkhande)
        case .abasi: TextosDeTeoria.traduccion(\.periodoAbasi)
        case .sistematista: TextosDeTeoria.traduccion(\.periodoSistematista)
        case .otomanoSafavi: TextosDeTeoria.traduccion(\.periodoOtomanoSafavi)
        case .qayar: TextosDeTeoria.traduccion(\.periodoQayar)
        case .congresoDelCairo: TextosDeTeoria.traduccion(\.periodoCongresoDelCairo)
        case .cantemir: TextosDeTeoria.traduccion(\.periodoCantemir)
        case .selimIII: TextosDeTeoria.traduccion(\.periodoSelimIII)
        case .arelEzgiUzdilek: TextosDeTeoria.traduccion(\.periodoArelEzgiUzdilek)
        case .zhou: TextosDeTeoria.traduccion(\.periodoZhou)
        case .qinHan: TextosDeTeoria.traduccion(\.periodoQinHan)
        case .seisDinastias: TextosDeTeoria.traduccion(\.periodoSeisDinastias)
        case .tang: TextosDeTeoria.traduccion(\.periodoTang)
        case .song: TextosDeTeoria.traduccion(\.periodoSong)
        case .yuan: TextosDeTeoria.traduccion(\.periodoYuan)
        case .ming: TextosDeTeoria.traduccion(\.periodoMing)
        case .qing: TextosDeTeoria.traduccion(\.periodoQing)
        case .naraHeian: TextosDeTeoria.traduccion(\.periodoNaraHeian)
        case .kamakuraMuromachi: TextosDeTeoria.traduccion(\.periodoKamakuraMuromachi)
        case .edo: TextosDeTeoria.traduccion(\.periodoEdo)
        case .moderno: TextosDeTeoria.traduccion(\.periodoModerno)
        }
    }
}

extension PeriodoMusical: Nombrable {}

// MARK: - El año de una escala

extension CategoriaTradicional {
    /// El año de las categorías que son el sistema de un tratado o de un repertorio: los mēḷa, de la
    /// Caturdaṇḍīprakāśikā de Veṅkaṭamakhin (1660); los thāṭ, de la Hindustani Sangeet Paddhati de Bhātkhaṇḍe (1909);
    /// los grāma y las mūrchanā, del Nāṭyaśāstra (entre 200 a. C. y 200; se toma el año 0); los dastgāh, del radif de
    /// Mirzā ʿAbdollāh (hacia 1880); los mugam, de los «Fundamentos de la música popular azerbaiyana» de Hacıbəyov
    /// (1945); los dromoi, del rebético (desde los años veinte; se toma 1920). `nil` en las demás. El `switch` no tiene
    /// `default`: una categoría nueva no compila sin decir el suyo.
    public var anio: Int? {
        switch self {
        case .melakarta: 1660
        case .thaat: 1909
        case .grama, .murchana: 0
        case .dastgah: 1880
        case .mugam: 1945
        case .dromos: 1920
        case .raga, .janya, .maqam, .makam, .echos, .shteyger, .qenet, .laras, .pathet,
            .diao, .jo, .tetracordo, .jins, .cesni, .harmonia, .afinacion, .modoGregoriano, .hexacordo, .escala:
            nil
        }
    }
}

extension TipoDeEscala {
    /// El año en que aparece la escala, si se sabe: el de la obra que la documenta (`documentada`), el de su fuente
    /// teórica (`FuenteTeorica.anio`) o el de su categoría (`CategoriaTradicional.anio`), por ese orden. Los años antes
    /// de Cristo son negativos. `nil` en las demás.
    ///
    ///     TipoDeEscala.menorHungara.anioDeOrigen   // 1859
    ///     TipoDeEscala.ionicus.anioDeOrigen        // 1547 (Glareano)
    public var anioDeOrigen: Int? { documentada?.anio ?? fuente?.anio ?? categoria?.anio }

    /// El período de su tradición en que aparece (`PeriodoMusical.de(_:anio:)`), si su tradición los tiene y se sabe
    /// su año: los mēḷa, el de los mēḷa; Rast makamı, el de Cantemir. `nil` en las demás.
    public var periodo: PeriodoMusical? {
        guard let tradicion, let anio = anioDeOrigen else { return nil }
        return PeriodoMusical.de(tradicion, anio: anio)
    }
}

extension TipoDeEscala {
    /// Los períodos de su tradición en que se sigue usando, después del de origen y hasta hoy: los makamlar de
    /// Cantemir, el de Selim III y el de Arel-Ezgi-Uzdilek; los mēḷa, el de Bhātkhaṇḍe. Las tradiciones con períodos
    /// siguen vivas, así que sus escalas se siguen usando; las del Nāṭyaśāstra (los grāma y las mūrchanā, de
    /// escuela `.indiaAntigua`), no. Vacío si no tiene período.
    public var periodosDeUso: [PeriodoMusical] {
        guard let tradicion, let periodo, !escuelas.contains(.indiaAntigua) else { return [] }
        let todos = PeriodoMusical.periodos(de: tradicion)
        guard let i = todos.firstIndex(of: periodo) else { return [] }
        return Array(todos[(i + 1)...])
    }
}
