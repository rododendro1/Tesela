import Elementos

// MARK: - Los cakra de los mēḷa

/// Los doce cakra («ruedas») en que se agrupan los 72 mēḷa, de seis en seis: los del 1 al 6 son el cakra Indu, los del
/// 67 al 72, el Āditya. En cada cakra cambian Dha y Ni y se quedan Ri, Ga y Ma. Los seis primeros llevan Ma1 (la cuarta
/// justa) y los seis últimos Ma2 (la aumentada). Cada nombre es una palabra que, en sánscrito, vale por su número:
/// Indu, la luna, que es una; Netra, los dos ojos; Agni, los tres fuegos; Veda, los cuatro Vedas; Bāṇa, las cinco
/// flechas de Kāma; Ṛtu, las seis estaciones; Ṛṣi, los siete sabios; Vasu, los ocho Vasus; Brahma, nueve; Diśi, las
/// diez direcciones; Rudra, los once Rudras, y Āditya, los doce Ādityas.
///
///     CakraDeMela(mela: 29)                       // .bana
///     TipoDeEscala.mayor.cakra?.nombre            // "Bāṇa"
///     CakraDeMela.rtu.melas                       // 31...36
public enum CakraDeMela: Int, CaseIterable, Sendable, Comparable {
    case indu = 1
    case netra, agni, veda, bana, rtu, rsi, vasu, brahma, disi, rudra, aditya

    /// El cakra de un mēḷa por su número (1…72); `nil` fuera de ahí.
    public init?(mela numero: Int) {
        guard (1...72).contains(numero) else { return nil }
        self.init(rawValue: (numero - 1) / 6 + 1)
    }

    /// Su número, del 1 al 12.
    public var numero: Int { rawValue }

    /// Los números de sus seis mēḷa.
    public var melas: ClosedRange<Int> { (rawValue - 1) * 6 + 1...rawValue * 6 }

    /// El nombre transliterado según el AITS (IAST), que es el mismo en todos los idiomas: «Indu», «Bāṇa», «Ṛṣi».
    public var nombre: String {
        ["Indu", "Netra", "Agni", "Veda", "Bāṇa", "Ṛtu", "Ṛṣi", "Vasu", "Brahma", "Diśi", "Rudra", "Āditya"][
            rawValue - 1]
    }

    /// El nombre en devanagari: «इन्दु», «बाण».
    public var nombreEnDevanagari: String {
        ["इन्दु", "नेत्र", "अग्नि", "वेद", "बाण", "ऋतु", "ऋषि", "वसु", "ब्रह्म", "दिशि", "रुद्र", "आदित्य"][rawValue - 1]
    }

    public static func < (a: CakraDeMela, b: CakraDeMela) -> Bool { a.rawValue < b.rawValue }
}

extension CakraDeMela {
    /// Las sílabas que dicen el lugar de un mēḷa en su cakra, del 1.º al 6.º: pa, śrī, go, bhū, mā y ṣa. Cada una da
    /// el Dha y el Ni (el tetracordo de arriba), igual en todos los cakra: pa, Dha1 Ni1; śrī, Dha1 Ni2; go, Dha1 Ni3;
    /// bhū, Dha2 Ni2; mā, Dha2 Ni3; ṣa, Dha3 Ni3. El cakra da el Ri y el Ga (el de abajo) y el Ma.
    public static let silabas = ["pa", "śrī", "go", "bhū", "mā", "ṣa"]
}

extension TipoDeEscala {
    /// El nombre mnemónico de su mēḷa: su cakra y la sílaba de su lugar en él (`CakraDeMela.silabas`).
    /// Māyāmālavagauḷa, el 15, es «Agni-go»; la mayor, el 29, «Bāṇa-mā». `nil` si no encaja en ningún mēḷa.
    public var mnemonicoDeMela: String? {
        guard let numero = numeroDeMelakarta, let cakra = CakraDeMela(mela: numero) else { return nil }
        return cakra.nombre + "-" + CakraDeMela.silabas[(numero - 1) % 6]
    }

    /// Las sílabas de solfa carnática de su mēḷa, de Sa a Ni, que dicen qué Ri, Ga, Ma, Dha y Ni lleva: ra, ri, ru
    /// (Ri1 a Ri3); ga, gi, gu (Ga1 a Ga3); ma, mi (Ma1, Ma2); dha, dhi, dhu (Dha1 a Dha3), y na, ni, nu (Ni1 a Ni3).
    /// Māyāmālavagauḷa es «sa ra gu ma pa dha nu». `nil` si no encaja en ningún mēḷa.
    ///
    ///     TipoDeEscala.mayor.solfaDeMela?.joined(separator: " ")   // "sa ri gu ma pa dhi nu"
    public var solfaDeMela: [String]? {
        guard let numero = numeroDeMelakarta, let mela = TipoDeEscala.melakarta(numero) else { return nil }
        let silabas: [Intervalo: String] = [
            .unisono: "sa", .segundaMenor: "ra", .segundaMayor: "ri", .segundaAumentada: "ru",
            .terceraDisminuida: "ga", .terceraMenor: "gi", .terceraMayor: "gu", .cuartaJusta: "ma",
            .cuartaAumentada: "mi", .quintaJusta: "pa", .sextaMenor: "dha", .sextaMayor: "dhi", .sextaAumentada: "dhu",
            .septimaDisminuida: "na", .septimaMenor: "ni", .septimaMayor: "nu",
        ]
        return mela.intervalos.compactMap { silabas[$0] }
    }

    /// El cakra de su mēḷa (`numeroDeMelakarta`): Bāṇa para Dhīraśaṅkarābharaṇam, que es la mayor (29). `nil` si
    /// no encaja en ningún mēḷa.
    public var cakra: CakraDeMela? { numeroDeMelakarta.flatMap(CakraDeMela.init(mela:)) }
}
