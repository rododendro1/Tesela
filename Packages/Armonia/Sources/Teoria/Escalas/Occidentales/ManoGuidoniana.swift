import Elementos

/// La mano guidoniana: el gamut de la solmisación medieval, las veinte posiciones de Γ ut (Sol2) a ee la (Mi5), y los
/// siete hexacordos que se solapan en ellas.
///
/// Guido d'Arezzo describió los hexacordos (ut re mi fa sol la, con el semitono mi–fa en medio) en la *Epistola de
/// ignoto cantu* y el *Micrologus* (h. 1026); la mano, con una nota en cada articulación, tomó su forma en el siglo
/// XII. Cada hexacordo empieza en Sol (duro, con Si), en Do (natural) o en Fa (blando, con Si♭), y el gamut tiene
/// siete: Sol2, Do3, Fa3, Sol3, Do4, Fa4 y Sol4. Cada posición se nombra por su letra y por la sílaba que tiene en cada
/// hexacordo que pasa por ella, del más grave al más agudo: «C fa ut» es Do3, fa del hexacordo duro de Sol2 y ut del
/// natural de Do3. La décima y la decimoséptima tienen dos notas, Si♭ (fa del blando) y Si (mi del duro): «b fa ♮ mi».
///
/// Las letras van como en los tratados: Γ para la más grave, mayúsculas en la octava grave (A–G), minúsculas en la
/// media (a–g) y dobles en la aguda (aa–ee). Las sílabas no se traducen. Pasar de un hexacordo a otro en una nota
/// que está en los dos es una mutación: el La3 es la del natural y re del duro (`mutacion(en:desde:hasta:)`).
///
/// ```swift
/// ManoGuidoniana.gamut.count                                     // 20
/// ManoGuidoniana.nombre(de: Altura(.do, octava: 3))              // "C fa ut"
/// ManoGuidoniana.silabas(de: Altura(.sol, octava: 3))            // ["sol", "re", "ut"]
/// ManoGuidoniana.nombre(de: Altura(Nota(.si, .bemol), octava: 3)) // "b fa ♮ mi"
/// ```
public enum ManoGuidoniana {
    /// Las seis sílabas del hexacordo, de ut a la.
    public static let silabas = ["ut", "re", "mi", "fa", "sol", "la"]

    /// Uno de los siete hexacordos del gamut: su tipo (natural, duro o blando, de los hexacordos del catálogo) y la
    /// altura de su ut.
    public struct Hexacordo: Hashable, Sendable {
        /// `TipoDeEscala.hexacordoNatural`, `.hexacordoDuro` o `.hexacordoBlando`.
        public let tipo: TipoDeEscala
        public let ut: Altura

        /// Las seis alturas, de ut a la.
        public var alturas: [Altura] { tipo.intervalos.map { ut + $0 } }

        /// La sílaba de `altura` en este hexacordo, o `nil` si no está en él.
        public func silaba(de altura: Altura) -> String? {
            alturas.firstIndex(of: altura).map { ManoGuidoniana.silabas[$0] }
        }
    }

    /// Los siete hexacordos, del más grave al más agudo: duro en Sol2, natural en Do3, blando en Fa3, duro en Sol3,
    /// natural en Do4, blando en Fa4 y duro en Sol4.
    public static let hexacordos: [Hexacordo] = [
        Hexacordo(tipo: .hexacordoDuro, ut: Altura(.sol, octava: 2)),
        Hexacordo(tipo: .hexacordoNatural, ut: Altura(.do, octava: 3)),
        Hexacordo(tipo: .hexacordoBlando, ut: Altura(.fa, octava: 3)),
        Hexacordo(tipo: .hexacordoDuro, ut: Altura(.sol, octava: 3)),
        Hexacordo(tipo: .hexacordoNatural, ut: Altura(.do, octava: 4)),
        Hexacordo(tipo: .hexacordoBlando, ut: Altura(.fa, octava: 4)),
        Hexacordo(tipo: .hexacordoDuro, ut: Altura(.sol, octava: 4)),
    ]

    /// Una posición del gamut: su nombre («C fa ut») y sus alturas (una, o dos en las de Si♭ y Si).
    public struct Posicion: Hashable, Sendable {
        public let nombre: String
        public let alturas: [Altura]
    }

    /// Las veinte posiciones, de Γ ut a ee la.
    public static let gamut: [Posicion] = {
        // Las alturas de los siete hexacordos, sin repetir, de grave a agudo; Si♭ y Si comparten posición.
        let todas = Set(hexacordos.flatMap(\.alturas)).sorted()
        var posiciones: [(letra: String, alturas: [Altura])] = []
        for altura in todas {
            let letra = ManoGuidoniana.letra(de: altura)
            if let ultima = posiciones.last, ultima.letra == letra {
                posiciones[posiciones.count - 1].alturas.append(altura)
            } else {
                posiciones.append((letra, [altura]))
            }
        }
        return posiciones.map { posicion in
            let partes = posicion.alturas.map { altura in
                let silabas = ManoGuidoniana.silabas(de: altura).joined(separator: " ")
                // En la posición doble, cada nota con su letra: «b fa ♮ mi».
                if posicion.alturas.count == 1 { return silabas }
                let becuadro = String(repeating: "♮", count: posicion.letra.count)
                return "\(altura.nota.alteracion == .bemol ? posicion.letra : becuadro) \(silabas)"
            }
            let nombre =
                posicion.alturas.count == 1 ? "\(posicion.letra) \(partes[0])" : partes.joined(separator: " ")
            return Posicion(nombre: nombre, alturas: posicion.alturas)
        }
    }()

    /// Las sílabas de `altura` en los hexacordos que pasan por ella, del más grave al más agudo: ["sol", "re", "ut"]
    /// para Sol3. Vacío si no está en el gamut.
    public static func silabas(de altura: Altura) -> [String] {
        hexacordos.compactMap { $0.silaba(de: altura) }
    }

    /// El nombre de la posición de `altura` («C fa ut», «b fa ♮ mi»), o `nil` si no está en el gamut.
    public static func nombre(de altura: Altura) -> String? {
        gamut.first { $0.alturas.contains(altura) }?.nombre
    }

    /// La mutación en `altura` de un hexacordo a otro: la sílaba que tiene en cada uno, o `nil` si no está en los
    /// dos. El La3 del natural de Do3 al duro de Sol3: ("la", "re").
    public static func mutacion(
        en altura: Altura, desde: Hexacordo, hasta: Hexacordo
    ) -> (desde: String, hasta: String)? {
        guard let de = desde.silaba(de: altura), let a = hasta.silaba(de: altura) else { return nil }
        return (de, a)
    }

    /// La letra del gamut: Γ, A–G en la octava grave, a–g en la media y aa–ee en la aguda. Las octavas van de La a
    /// Sol, como en los tratados: La2 es A, La3 es a y La4 es aa.
    static func letra(de altura: Altura) -> String {
        let natural = altura.nota.natural
        let letra = natural.letra.lowercased()
        // Las de Do a Sol pertenecen a la octava del La de debajo.
        let octava = altura.octava - (natural.indiceDiatonico >= 5 ? 0 : 1)
        switch octava {
        case ...1: return "Γ"
        case 2: return letra.uppercased()
        case 3: return letra
        default: return letra + letra
        }
    }
}
