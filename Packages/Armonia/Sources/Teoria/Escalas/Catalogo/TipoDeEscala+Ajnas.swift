import Elementos

// MARK: - Los ajnas y los çeşni de cada maqām y cada makam
//
// Un maqām se describe por sus ajnas: el de la tónica y el que empieza en la nota de apoyo (el ghammāz, casi siempre
// la cuarta o la quinta). Un makam turco, en el sistema de Arel, Ezgi y Uzdilek, por un çeşni de cuatro notas
// (dörtlü) y otro de cinco (beşli). Aquí están los de cada maqām según Maqam World y los de cada makam según la TDV
// İslâm Ansiklopedisi, siempre que los dos sean fragmentos del catálogo y casen con las notas temperadas de la escala: Bayātī es
// el jins Bayātī en la tónica y el Nahāwand en la cuarta; Rast makamı, el Rast beşlisi y el Rast dörtlüsü en la
// quinta.
//
// Faltan los que usan un fragmento que el catálogo no tiene: Lāmī, Ṣabā Zamzam, Jiharkāh, Āthār Kurd, el Segâh
// üçlüsü, el Saba dörtlüsü, el Hüseynî beşlisi, el Nikriz beşlisi, el Zirgüleli Hicaz beşlisi y el jins Ḥijāzkār. Solo se da el otro,
// si lo hay. De Nayrūz no hay ninguno, y de ʿIrāq falta el Bayātī de la tercera: su aproximación temperada no casa con
// la de su jins Rāst o Bayātī. Tampoco están Hüzzam, Karcığar, Sûzinak ni Nikriz, que no se han podido comprobar en la
// TDV. Todos están comprobados en sus páginas de Maqam World y de la TDV (noviembre de 2026).

/// Un fragmento (jins o çeşni) de una escala y el grado en que empieza, desde 1: el jins Nahāwand en el 4.º de Bayātī.
public struct FragmentoDeLaEscala: Hashable, Sendable {
    public let fragmento: TipoDeEscala
    /// El grado de la escala en que empieza, desde 1 (la tónica).
    public let grado: Int

    /// Un fragmento que empieza en un grado de la escala.
    public init(_ fragmento: TipoDeEscala, en grado: Int) {
        self.fragmento = fragmento
        self.grado = grado
    }
}

extension TipoDeEscala {
    /// Los fragmentos con los que la describe su teoría: los ajnas de un maqām (Maqam World) o los çeşni de un makam
    /// (la TDV İslâm Ansiklopedisi), del grave al agudo. Vacío en las demás escalas y en los maqāmāt y makam que usan un fragmento
    /// que el catálogo no tiene.
    ///
    ///     TipoDeEscala.bayati.ajnas.map(\.fragmento.nombre)   // ["jins Bayātī", "jins Nahāwand"]
    ///     TipoDeEscala.bayati.ajnas.map(\.grado)              // [1, 4]
    public var ajnas: [FragmentoDeLaEscala] { TipoDeEscala.ajnasDeclarados[identidad]?.fragmentos ?? [] }

    /// La obra de la que salen sus `ajnas`; `nil` si no tiene.
    public var fuenteDeLosAjnas: Referencia? { TipoDeEscala.ajnasDeclarados[identidad]?.fuente }

    struct AjnasDeclarados: Sendable {
        let fragmentos: [FragmentoDeLaEscala]
        let fuente: Referencia
    }

    static let ajnasDeclarados: [IdentidadDeEscala: AjnasDeclarados] = {
        var tabla: [IdentidadDeEscala: AjnasDeclarados] = [:]
        func arabe(_ maqam: TipoDeEscala, _ fragmentos: FragmentoDeLaEscala...) {
            tabla[maqam.identidad] = AjnasDeclarados(fragmentos: fragmentos, fuente: .maqamWorld)
        }
        func turco(_ makam: TipoDeEscala, _ fragmentos: FragmentoDeLaEscala...) {
            tabla[makam.identidad] = AjnasDeclarados(fragmentos: fragmentos, fuente: .tdvIslamAnsiklopedisi)
        }
        // Maqāmāt árabes.
        arabe(.hiyaz, .init(.jinsHijaz, en: 1), .init(.jinsNahawand, en: 4))
        arabe(.nahawand, .init(.jinsNahawand, en: 1), .init(.jinsHijaz, en: 5))
        arabe(.kurd, .init(.jinsKurd, en: 1), .init(.jinsNahawand, en: 4))
        // Maqam World da arriba el «ʿAjam alto», con la tónica en la octava; aquí, el jins ʿAjam en la quinta.
        arabe(.ajam, .init(.jinsAjam, en: 1), .init(.jinsAjam, en: 5))
        // Arriba, el jins Ḥijāzkār en la octava, que no está en el catálogo.
        arabe(.hiyazkar, .init(.jinsHijaz, en: 1))
        // Arriba, el jins Ḥijāzkār en torno a la quinta, que no está en el catálogo.
        arabe(.nawaAthar, .init(.jinsNikriz, en: 1))
        // El de la quinta es el «Rāst alto» de Maqam World, con la tónica en la octava: las mismas notas.
        arabe(.maqamRast, .init(.jinsRast, en: 1), .init(.jinsRast, en: 5))
        arabe(.bayati, .init(.jinsBayati, en: 1), .init(.jinsNahawand, en: 4))
        arabe(.saba, .init(.jinsSaba, en: 1), .init(.jinsHijaz, en: 3))
        arabe(.suznak, .init(.jinsRast, en: 1), .init(.jinsHijaz, en: 5))
        arabe(.husayni, .init(.jinsBayati, en: 1))
        arabe(.sikah, .init(.jinsSikah, en: 1), .init(.jinsRast, en: 3))
        arabe(.huzam, .init(.jinsSikah, en: 1), .init(.jinsHijaz, en: 3), .init(.jinsRast, en: 6))
        arabe(.iraq, .init(.jinsSikah, en: 1), .init(.jinsRast, en: 6))
        arabe(.rahatAlArwah, .init(.jinsSikah, en: 1), .init(.jinsHijaz, en: 3), .init(.jinsRast, en: 6))
        arabe(.bayatiShuri, .init(.jinsBayati, en: 1), .init(.jinsHijaz, en: 4))
        arabe(.maqamNikriz, .init(.jinsNikriz, en: 1), .init(.jinsNahawand, en: 5))
        // Makamlar turcos, como los describe la TDV İslâm Ansiklopedisi en el artículo de cada uno.
        turco(.rastMakami, .init(.rastBeslisi, en: 1), .init(.rastDortlusu, en: 5))
        turco(.hicazMakami, .init(.hicazDortlusu, en: 1), .init(.rastBeslisi, en: 4))
        turco(.hicazkarMakami, .init(.hicazBeslisi, en: 1), .init(.hicazDortlusu, en: 5))
        turco(.nihavendMakami, .init(.buselikBeslisi, en: 1), .init(.hicazDortlusu, en: 5))
        turco(.kurdiMakami, .init(.kurdiDortlusu, en: 1), .init(.buselikBeslisi, en: 4))
        turco(.buselikMakami, .init(.buselikBeslisi, en: 1), .init(.kurdiDortlusu, en: 5))
        turco(.cargahMakami, .init(.cargahBeslisi, en: 1), .init(.cargahDortlusu, en: 5))
        turco(.ussakMakami, .init(.ussakDortlusu, en: 1), .init(.buselikBeslisi, en: 4))
        // Abajo, el Hüseynî beşlisi; en Saba, el Saba dörtlüsü; en Nev'eser, el Nikriz beşlisi.
        turco(.huseyniMakami, .init(.ussakDortlusu, en: 5))
        turco(.sabaMakami, .init(.hicazBeslisi, en: 3))
        turco(.neveserMakami, .init(.hicazDortlusu, en: 5))
        turco(.mahurMakami, .init(.cargahBeslisi, en: 1), .init(.cargahDortlusu, en: 5))
        turco(.sultaniyegahMakami, .init(.buselikBeslisi, en: 1), .init(.hicazDortlusu, en: 5))
        turco(.uzzalMakami, .init(.hicazBeslisi, en: 1), .init(.ussakDortlusu, en: 5))
        turco(.zirguleliHicazMakami, .init(.hicazBeslisi, en: 1), .init(.hicazDortlusu, en: 5))
        return tabla
    }()
}

extension Escala {
    /// Las notas de uno de sus fragmentos (`TipoDeEscala.ajnas`): Sol La Si♭ Do Re para el jins Nahāwand de Re Bayātī.
    public func notas(de fragmento: FragmentoDeLaEscala) -> [Nota] {
        let primera = grado(fragmento.grado)
        return fragmento.fragmento.intervalos.map { primera + $0 }
    }
}
