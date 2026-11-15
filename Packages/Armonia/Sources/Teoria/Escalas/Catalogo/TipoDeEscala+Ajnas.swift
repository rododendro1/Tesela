import Elementos

// MARK: - Los ajnas y los çeşni de cada maqām y cada makam
//
// Un maqām se describe por sus ajnas: el de la tónica y el que empieza en la nota de apoyo (el ghammāz, casi siempre la
// cuarta o la quinta). Un makam turco, en el sistema de Arel, Ezgi y Uzdilek, por un çeşni de cuatro notas (dörtlü) y
// otro de cinco (beşli). Aquí están los de cada maqām según Maqam World y los de cada makam según la TDV İslâm
// Ansiklopedisi, siempre que los dos sean fragmentos del catálogo y casen con las notas temperadas de la escala: Bayātī
// es el jins Bayātī en la tónica y el Nahāwand en la cuarta; Rast makamı, el Rast beşlisi y el Rast dörtlüsü en la
// quinta.
//
// Faltan los que usan un fragmento que el catálogo no tiene: Lāmī, Ṣabā Zamzam, Jiharkāh, Āthār Kurd, el Segâh üçlüsü,
// el Saba dörtlüsü, el Hüseynî beşlisi, el Nikriz beşlisi, el Zirgüleli Hicaz beşlisi y el jins Ḥijāzkār. Solo se da el
// otro, si lo hay. De Nayrūz no hay ninguno, y de ʿIrāq falta el Bayātī de la tercera: su aproximación temperada no
// casa con la de su jins Rāst o Bayātī. Tampoco están Hüzzam, Karcığar, Sûzinak ni Nikriz, que no se han podido
// comprobar en la TDV. Todos están comprobados en sus páginas de Maqam World y de la TDV (noviembre de 2026).
//
// Se escriben en la declaración de cada uno (`ajnas: [.init(.jinsBayati, en: 1), .init(.jinsNahawand, en: 4)]`), en
// TipoDeEscala+MundoArabe.swift y TipoDeEscala+Turquia.swift.

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
    /// (la TDV İslâm Ansiklopedisi), del grave al agudo. Vacío en las demás escalas y en los maqāmāt y makam que usan
    /// un fragmento que el catálogo no tiene.
    ///
    ///     TipoDeEscala.bayati.ajnas.map(\.fragmento.nombre)   // ["jins Bayātī", "jins Nahāwand"]
    ///     TipoDeEscala.bayati.ajnas.map(\.grado)              // [1, 4]
    public var ajnas: [FragmentoDeLaEscala] { datosDelCatalogo.ajnas }

    /// La obra de la que salen sus `ajnas`: Maqam World en los maqāmāt y la TDV İslâm Ansiklopedisi en los makamlar;
    /// `nil` si no tiene.
    public var fuenteDeLosAjnas: Referencia? {
        guard !ajnas.isEmpty else { return nil }
        return categoria == .makam ? .tdvIslamAnsiklopedisi : .maqamWorld
    }
}

extension Escala {
    /// Las notas de uno de sus fragmentos (`TipoDeEscala.ajnas`): Sol La Si♭ Do Re para el jins Nahāwand de Re Bayātī.
    public func notas(de fragmento: FragmentoDeLaEscala) -> [Nota] {
        let primera = grado(fragmento.grado)
        return fragmento.fragmento.intervalos.map { primera + $0 }
    }
}
