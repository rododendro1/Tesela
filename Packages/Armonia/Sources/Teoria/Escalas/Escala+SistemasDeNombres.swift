import Elementos

// Las notas de una escala con los nombres de otra tradición (`SistemaDeNombres`): el sargam desde la tónica de la
// escala (Re dórico es Sā Re ga ma Pa Dha ni) y el bizantino con Ni en Do (el primer echos, sobre Re, es Pa Vou Ga Di
// Ke Zo Ni), también en su versión microtonal (Pa Vou⁻² Ga Di Ke Zo⁻² Ni, en moria).

extension Escala {
    /// Los nombres de las notas de la escala en un sistema de otra tradición. En los móviles, como el sargam, desde
    /// la tónica de la escala; en los fijos, como el bizantino, los de cada nota.
    ///
    ///     Escala(.re, .dorico).nombres(en: .sargam)       // Sā Re ga ma Pa Dha ni
    ///     Escala(.re, .dorico).nombres(en: .bizantino)    // Pa Vou Ga Di Ke Zo Ni
    ///     Escala(.do, .mayor).nombres(en: .sargam, grafia: .original)     // सा रे ग म प ध नि
    public func nombres(en sistema: SistemaDeNombres, grafia: Grafia = .transliterada) -> [String] {
        sistema.nombres(de: notas, tonica: tonica, grafia: grafia)
    }
}

extension NotaMicrotonal {
    /// El nombre en un sistema de otra tradición, con el signo de su sistema microtonal detrás: «Vou⁻²» (dos moria
    /// bajo Vou), «Ga↓» (una coma bajo el Ga pitagórico). En los móviles, el grado se cuenta desde `tonica`.
    public func nombre(
        en sistemaDeNombres: SistemaDeNombres, tonica: Nota = Nota(.do), grafia: Grafia = .transliterada
    ) -> String {
        let base = sistemaDeNombres.nombre(de: temperada, tonica: tonica, grafia: grafia)
        guard ajuste != 0 else { return base }
        // El signo del ajuste, como lo escribe `nombre(en:)` tras la nota temperada: ⁻², ↓, (−37¢).
        let notacion: Notacion = grafia == .ascii ? .ascii(.espanol) : .compacta(.espanol)
        let completo = NotaMicrotonal.nombre(temperada, sistema: sistema, ajuste: ajuste, en: notacion)
        let temperado = temperada.nombre(en: notacion)
        guard completo.hasPrefix(temperado) else { return base + "(\(ajuste > 0 ? "+" : "")\(ajuste))" }
        return base + String(completo.dropFirst(temperado.count))
    }
}

// MARK: - Nombres por octava

extension Escala {
    /// Los nombres de las notas de la escala en un sistema que nombra cada altura en su octava, con la tónica en
    /// `octava` y los grados hacia arriba; `nil` en cada nota que el sistema no nombra. En el árabe y el turco, con la
    /// versión microtonal de la escala, si la tiene y es de su sistema; si no, con las notas temperadas.
    ///
    ///     Escala(.do, .maqamRast).nombres(en: .arabe, octava: 4)
    ///     // Rāst Dūkāh Sīkāh Jahārkāh Nawā Ḥusaynī Awj
    ///     Escala(.sol, .rastMakami).nombres(en: .turco, octava: 4)
    ///     // Rast Dügâh Segâh Çârgâh Nevâ Hüseynî Eviç
    public func nombres(en sistema: NombresPorOctava, octava: Int, grafia: Grafia = .transliterada) -> [String?] {
        let base = Altura(tonica, octava: octava)
        if let microtonales = notasMicrotonales(), let primera = microtonales.first, sistema.admite(primera.sistema) {
            return microtonales.map { nota in
                // La octava de cada grado: la de la altura temperada más cerca de sus cents sobre la tónica.
                let octavas = (octava - 1)...(octava + 2)
                let cercana = octavas.min { a, b in
                    abs(Escala.centsSobre(base, Altura(nota.temperada, octava: a)) - nota.cents)
                        < abs(Escala.centsSobre(base, Altura(nota.temperada, octava: b)) - nota.cents)
                }
                return sistema.nombre(de: nota, octava: cercana ?? octava, grafia: grafia)
            }
        }
        return tipo.intervalos.map { intervalo in sistema.nombre(de: base + intervalo, grafia: grafia) }
    }

    /// Los cents temperados de `altura` sobre `base`.
    private static func centsSobre(_ base: Altura, _ altura: Altura) -> Double {
        Double(100 * (altura.midi - base.midi))
    }
}

// MARK: - Śruti

extension SistemaMicrotonal {
    /// Los nombres de los 22 śruti, desde Sa: tīvrā, kumudvatī, mandā, chandovatī, dayāvatī… kṣobhiṇī, en el orden
    /// de las razones de `razonesDeLosSruti`. Es la correspondencia moderna, con cada svara en el primer śruti de su
    /// grupo: Sa en tīvrā, Re (9/8) en dayāvatī, Ga (5/4) en raudrī, Ma en vajrikā, Pa en kṣiti, Dha (27/16) en
    /// madantī y Ni (15/8) en ugrā. En el Nāṭyaśāstra, cada svara estaba en el último (Sa en chandovatī).
    public static func nombresDeLosSruti(en grafia: Grafia = .transliterada) -> [String] {
        switch grafia {
        case .original:
            return [
                "तीव्रा", "कुमुद्वती", "मन्दा", "छन्दोवती", "दयावती", "रञ्जनी", "रक्तिका", "रौद्री",
                "क्रोधा", "वज्रिका", "प्रसारिणी", "प्रीति", "मार्जनी", "क्षिति", "रक्ता", "सन्दीपनी",
                "आलापिनी", "मदन्ती", "रोहिणी", "रम्या", "उग्रा", "क्षोभिणी",
            ]
        case .transliterada:
            return [
                "tīvrā", "kumudvatī", "mandā", "chandovatī", "dayāvatī", "rañjanī", "raktikā", "raudrī", "krodhā",
                "vajrikā", "prasāriṇī", "prīti", "mārjanī", "kṣiti", "raktā", "sandīpanī", "ālāpinī", "madantī",
                "rohiṇī", "ramyā", "ugrā", "kṣobhiṇī",
            ]
        case .ascii:
            return [
                "tivra", "kumudvati", "manda", "chandovati", "dayavati", "ranjani", "raktika", "raudri", "krodha",
                "vajrika", "prasarini", "priti", "marjani", "kshiti", "rakta", "sandipani", "alapini", "madanti",
                "rohini", "ramya", "ugra", "kshobhini",
            ]
        }
    }
}

extension NotaMicrotonal {
    /// El nombre de su śruti, si es una nota de los 22 śruti (`SistemaMicrotonal.sruti`): en Bilāval, Re es dayāvatī
    /// y Ga, raudrī. `nil` en los demás sistemas.
    public func nombreDelSruti(en grafia: Grafia = .transliterada) -> String? {
        guard sistema == .sruti else { return nil }
        var enLaOctava = cents.truncatingRemainder(dividingBy: 1200)
        if enLaOctava < 0 { enLaOctava += 1200 }
        if enLaOctava > 1199.5 { enLaOctava -= 1200 }
        guard let indice = SistemaMicrotonal.centsDeLosSruti.firstIndex(where: { abs($0 - enLaOctava) < 0.5 }) else {
            return nil
        }
        return SistemaMicrotonal.nombresDeLosSruti(en: grafia)[indice]
    }
}

// MARK: - Gamelan

/// Las dos afinaciones (laras) del gamelan javanés, con los nombres de sus notas.
public enum Laras: String, Hashable, Sendable, CaseIterable, Codable {
    /// Cinco notas por octava, casi iguales: 1 barang, 2 gulu, 3 dhadha, 5 lima y 6 nem (sin 4 ni 7).
    case slendro
    /// Siete notas desiguales: 1 bem (o panunggul), 2 gulu, 3 dhadha, 4 pélog, 5 lima, 6 nem y 7 barang.
    case pelog

    /// El nombre de la nota de cifra kepatihan `cifra` (de 1 a 7); `nil` si la laras no la tiene. Con la grafía
    /// original, la cifra («5»); transliterada, el nombre («lima», «pélog»); en ASCII, sin tildes («pelog»).
    public func nombre(deLaCifra cifra: Int, grafia: Grafia = .transliterada) -> String? {
        let nombres: [Int: String]
        switch self {
        case .slendro: nombres = [1: "barang", 2: "gulu", 3: "dhadha", 5: "lima", 6: "nem"]
        case .pelog: nombres = [1: "bem", 2: "gulu", 3: "dhadha", 4: "pélog", 5: "lima", 6: "nem", 7: "barang"]
        }
        guard let nombre = nombres[cifra] else { return nil }
        switch grafia {
        case .original: return String(cifra)
        case .transliterada: return nombre
        case .ascii: return nombre == "pélog" ? "pelog" : nombre
        }
    }
}

extension TipoDeEscala {
    /// La laras de una escala javanesa del catálogo, y la cifra kepatihan de cada grado: el pélog pathet nem es
    /// 5 6 1 2 3 en pélog; el sléndro pathet sanga, 5 6 1 2 3 en sléndro. `nil` en las demás.
    public var gamelan: (laras: Laras, cifras: [Int])? {
        TipoDeEscala.cifrasDelGamelan[identidad]
    }

    private static let cifrasDelGamelan: [IdentidadDeEscala: (laras: Laras, cifras: [Int])] = [
        TipoDeEscala.pelogLima.identidad: (.pelog, [1, 2, 3, 5, 6]),
        TipoDeEscala.pelogNem.identidad: (.pelog, [5, 6, 1, 2, 3]),
        TipoDeEscala.pelogBarang.identidad: (.pelog, [6, 7, 2, 3, 5]),
        TipoDeEscala.slendro.identidad: (.slendro, [1, 2, 3, 5, 6]),
        TipoDeEscala.slendroNem.identidad: (.slendro, [2, 3, 5, 6, 1]),
        TipoDeEscala.slendroSanga.identidad: (.slendro, [5, 6, 1, 2, 3]),
        TipoDeEscala.slendroManyura.identidad: (.slendro, [6, 1, 2, 3, 5]),
    ]
}

extension Escala {
    /// Los nombres javaneses de las notas de una escala del gamelan (`TipoDeEscala.gamelan`): el pélog pathet nem es
    /// lima nem bem gulu dhadha; con la grafía original, las cifras: 5 6 1 2 3. `nil` si no es javanesa.
    public func nombresDelGamelan(grafia: Grafia = .transliterada) -> [String]? {
        guard let gamelan = tipo.gamelan else { return nil }
        return gamelan.cifras.compactMap { gamelan.laras.nombre(deLaCifra: $0, grafia: grafia) }
    }
}
