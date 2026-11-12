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
    // India
    /// Antes de 500 a. C.: los Vedas y el canto del Sāmaveda.
    case vedico
    /// De 500 a. C. a 1200: el Nāṭyaśāstra, sus grāma y sus mūrchanā.
    case natyasastra
    /// De 1200 a 1660: el Saṅgītaratnākara de Śārṅgadeva y los tratados que lo siguen.
    case sangitaratnakara
    /// De 1660 a 1900: los 72 mēḷa de Veṅkaṭamakhin y la música carnática de la Trinidad.
    case mela
    /// Desde 1900: los thāṭ de Bhātkhaṇḍe y la teoría india de hoy.
    case bhatkhande

    // Mundo árabe, Persia, Turquía y Azerbaiyán
    /// De 750 a 1250: al-Kindī, al-Fārābī y la teoría de la corte de Bagdad.
    case abasi
    /// De 1250 a 1500: Ṣafī al-Dīn y la escuela sistematista, con sus diecisiete notas.
    case sistematista
    /// De 1500 a 1932 en el mundo árabe (y hasta 1900 en Persia y Azerbaiyán, y 1650 en Turquía): los imperios otomano y
    /// safávida.
    case otomanoSafavi
    /// Desde 1932: el Congreso de Música Árabe de El Cairo y la teoría árabe de hoy.
    case congresoDelCairo
    /// De 1650 a 1789 en Turquía: Cantemir y su notación por letras.
    case cantemir
    /// De 1789 a 1910 en Turquía: Selim III y los makamlar nuevos de su corte (Hicazkâr, Suzinâk, Ferahfezâ).
    case selimIII
    /// Desde 1910 en Turquía: la teoría de Arel, Ezgi y Uzdilek, en 53 comas.
    case arelEzgiUzdilek

    // China
    /// Hasta 221 a. C.: el Guanzi y el Lüshi chunqiu.
    case zhou
    /// De 221 a. C. a 220.
    case qinHan
    /// De 220 a 618.
    case seisDinastias
    /// De 618 a 960.
    case tang
    /// De 960 a 1271.
    case song
    /// De 1271 a 1368.
    case yuan
    /// De 1368 a 1644: el temperamento igual de Zhu Zaiyu.
    case ming
    /// De 1644 a 1912.
    case qing

    // Japón
    /// De 710 a 1185: el gagaku de la corte.
    case naraHeian
    /// De 1185 a 1603.
    case kamakuraMuromachi
    /// De 1603 a 1868: el koto, el shamisen y la escala in.
    case edo

    /// Desde 1900 en Persia y Azerbaiyán, desde 1912 en China y desde 1868 en Japón.
    case moderno

    /// El período de un año en una tradición, o `nil` si la tradición no tiene períodos propios o el año cae antes del
    /// primero. Los de una tradición se suceden sin huecos.
    ///
    ///     PeriodoMusical.de(.india, anio: 1660)     // .mela
    ///     PeriodoMusical.de(.china, anio: -239)     // .zhou
    public static func de(_ tradicion: Tradicion, anio: Int) -> PeriodoMusical? {
        switch tradicion {
        case .india:
            switch anio {
            case ..<(-500): .vedico
            case ..<1200: .natyasastra
            case ..<1660: .sangitaratnakara
            case ..<1900: .mela
            default: .bhatkhande
            }
        case .mundoArabe, .persia, .azerbaiyan:
            switch anio {
            case ..<750: nil
            case ..<1250: .abasi
            case ..<1500: .sistematista
            case ..<1900: .otomanoSafavi
            case ..<1932 where tradicion == .mundoArabe: .otomanoSafavi
            default: tradicion == .mundoArabe ? .congresoDelCairo : .moderno
            }
        case .turquia:
            switch anio {
            case ..<750: nil
            case ..<1250: .abasi
            case ..<1500: .sistematista
            case ..<1650: .otomanoSafavi
            case ..<1789: .cantemir
            case ..<1910: .selimIII
            default: .arelEzgiUzdilek
            }
        case .china:
            switch anio {
            case ..<(-1046): nil
            case ..<(-221): .zhou
            case ..<220: .qinHan
            case ..<618: .seisDinastias
            case ..<960: .tang
            case ..<1271: .song
            case ..<1368: .yuan
            case ..<1644: .ming
            case ..<1912: .qing
            default: .moderno
            }
        case .japon:
            switch anio {
            case ..<710: nil
            case ..<1185: .naraHeian
            case ..<1603: .kamakuraMuromachi
            case ..<1868: .edo
            default: .moderno
            }
        case .occidental, .grecia, .greciaAntigua, .mesopotamia, .gregoriano, .renacimiento, .corea, .etiopia,
            .indonesia, .klezmer, .andes, .bizancio, .africa, .sudesteAsiatico, .europa, .vietnam, .brasil:
            nil
        }
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
    /// El año de las categorías que son el sistema de un tratado: los mēḷa, de la Caturdaṇḍīprakāśikā de
    /// Veṅkaṭamakhin (1660); los thāṭ, de la Hindustani Sangeet Paddhati de Bhātkhaṇḍe (1909); los grāma y las
    /// mūrchanā, del Nāṭyaśāstra (entre 200 a. C. y 200; se toma el año 0). `nil` en las demás, que no son de un
    /// tratado. El `switch` no tiene `default`: una categoría nueva no compila sin decir el suyo.
    public var anio: Int? {
        switch self {
        case .melakarta: 1660
        case .thaat: 1909
        case .grama, .murchana: 0
        case .raga, .janya, .dromos, .maqam, .dastgah, .makam, .mugam, .echos, .shteyger, .qenet, .laras, .pathet,
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
