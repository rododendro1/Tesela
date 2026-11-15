import Elementos
import Foundation

// MARK: - Escala

/// Escala concreta: tónica + tipo.
public struct Escala: Hashable, Sendable {
    public let tonica: Nota
    public let tipo: TipoDeEscala

    /// La escala de ese tipo sobre esa tónica: `Escala(.re, .dorico)`.
    public init(_ tonica: Nota, _ tipo: TipoDeEscala = .mayor) {
        self.tonica = tonica
        self.tipo = tipo
    }

    /// Lee textos como "Re dórico", "Fa# menor armónica", "Sib mayor", "La menor",
    /// o en inglés: "D dorian", "F# harmonic minor", "Bb major".
    /// Si no se puede leer, el error indica dónde y por qué.
    /// También lee la tónica en catalán, gallego, euskera, portugués, francés o italiano,
    /// con el tipo en español o en esas lenguas: "re bemoll dòric", "fa sostido menor", "re doriarra",
    /// "fá sustenido dórico", "ré bémol dorien", "fa diesis lidio". Con la tónica en ruso o en griego,
    /// el tipo va en esa lengua (los más comunes) o en inglés: "ре дорийский", "λα αρμονική ελάσσονα",
    /// "до lydian dominant". Y escalas propias, por sus notas ("Do Re Mi♭ Fa♯ Sol La Si") o por su tónica y sus
    /// pasos en semitonos ("Do 2-1-3-1-2-2-1"): ``Escala/propia(_:)``.
    public init(leyendo texto: String) throws {
        self = try Escala.leer(texto)
    }

    private static func leer(_ texto: String) throws -> Escala {
        var lector = Lector(texto)
        try lector.exigirContenido()
        do {
            // Con la tónica en español ("Re"), el tipo también va en español ("dórico");
            // con letra ("D"), se acepta en inglés ("dorian") o en español.
            guard let (tonica, idioma) = lector.leerNombreNotaConIdioma() else { throw lector.error(.notaNoReconocida) }
            lector.saltarEspacios()
            let nombre = lector.restoSinEspacios
            guard let tipo = TipoDeEscala.buscar(nombre: nombre, aceptarIngles: idioma == .ingles) else {
                throw lector.error(.tipoDeEscalaNoReconocido(nombre))
            }
            return Escala(tonica, tipo)
        } catch {
            // La tónica puede ocupar varias palabras ("si bemol bikoitza"); se prueba de más a menos.
            let palabras = texto.split(separator: " ").map(String.init)
            for cuantas in stride(from: min(3, palabras.count - 1), through: 1, by: -1) {
                let tonica = palabras[..<cuantas].joined(separator: " ")
                let tipo = palabras[cuantas...].joined(separator: " ")
                guard let (nombre, notacion) = Escala.leerTonica(tonica) else { continue }
                let encontrado = TipoDeEscala.buscar(nombre: tipo, conTonicaEn: notacion)
                if let encontrado { return Escala(nombre, encontrado) }
            }
            // Un diao: un lü y un modo chino («黄钟宫», «林钟商», «línzhōng shāng»).
            if let diao = Escala(diao: texto) { return diao }
            // Una escala propia: sus notas («Do Re Mi♭ Fa♯ Sol La Si») o su tónica y sus pasos («Do 2-1-3-1-2-2-1»).
            if let propia = Escala.leerPropia(texto) { return propia }
            throw error
        }
    }

    /// Tónica en una de las lenguas que se leen sin indicar la notación, en francés, italiano o
    /// alemán («Fis dorisch»; «B dorisch» es Si♭, porque «B dorian» ya se ha leído antes en inglés) o, la
    /// última, en español o inglés con palabras («Fa sostenido dórico», «F sharp dorian»).
    private static func leerTonica(_ texto: String) -> (Nota, Notacion)? {
        let clave = texto.claveDeBusqueda
        let otras = [
            Notacion.conPalabras(.frances), .conPalabras(.italiano), .conPalabras(.aleman), .conPalabras(.hungaro),
            .conPalabras(.sueco),
        ]
        for notacion in Notacion.deLecturaGenerica + otras + Notacion.conPalabras {
            if let nombre = Nota.porNombre[notacion][clave] { return (nombre, notacion) }
        }
        return nil
    }

    // MARK: Notas

    /// Notas de la forma ascendente, desde la tónica. Es la forma que usan los grados, la
    /// armonización, la armadura y el conjunto de clases de altura.
    public var notas: [Nota] { tipo.intervalos.map { tonica + $0 } }

    /// Notas que aparecen al subir o al bajar, de grave a agudo: en La menor melódica,
    /// La Si Do Re Mi Fa Fa♯ Sol Sol♯. En una escala no direccional, igual que `notas`.
    public var notasEnAmbasDirecciones: [Nota] { tipo.intervalosEnAmbasDirecciones.map { tonica + $0 } }

    /// Notas de una dirección: las de subida o las de bajada (de grave a agudo).
    public func notas(sentido: SentidoDelIntervalo) -> [Nota] {
        sentido == .ascendente ? notas : Escala(tonica, tipo.formaDescendente).notas
    }

    /// Grado contado desde 1; se repite cíclicamente (grado 8 = grado 1).
    public func grado(_ n: Int) -> Nota {
        tonica + tipo.intervalos[modulo(n - 1, tipo.intervalos.count)]
    }

    /// Alturas de la escala con octava. Al subir, de la tónica en `octava` a la tónica superior;
    /// al bajar, de la tónica superior a la tónica en `octava`, con la forma descendente del tipo
    /// (La menor melódica baja con Sol♮ y Fa♮). Si el tipo tiene recorrido (`TipoDeEscala.recorrido`,
    /// `recorridoDescendente`), en su orden: Do Ānandabhairavi sube Do Mi♭ Re Mi♭ Fa Sol La Sol Do.
    public func alturas(octava: Int, sentido: SentidoDelIntervalo = .ascendente) -> [Altura] {
        let inicio = Altura(tonica, octava: octava)
        let intervalos =
            sentido == .ascendente ? tipo.intervalos : tipo.intervalosDescendentes ?? tipo.intervalos
        if let recorrido = sentido == .ascendente ? tipo.recorrido : tipo.recorridoDescendente {
            return recorrido.map { grado in
                let indice = grado - 1
                let octavas = Int((Double(indice) / Double(intervalos.count)).rounded(.down))
                var altura = inicio + intervalos[modulo(indice, intervalos.count)]
                for _ in 0..<abs(octavas) {
                    altura = octavas > 0 ? altura + Intervalo.octava : altura - Intervalo.octava
                }
                return altura
            }
        }
        let alturas = intervalos.map { inicio + $0 } + [inicio + Intervalo.octava]
        return sentido == .ascendente ? alturas : alturas.reversed()
    }

    /// Contiene el nombre exacto (Fa♯ ≠ Sol♭), al subir o al bajar; con `sentido`, solo en
    /// esa dirección. La menor melódica contiene Sol (al bajar) y Sol♯ (al subir).
    public func contiene(_ nota: Nota, sentido: SentidoDelIntervalo? = nil) -> Bool {
        (sentido.map { notas(sentido: $0) } ?? notasEnAmbasDirecciones).contains(nota)
    }

    /// Contiene la altura, sin importar la ortografía (al subir o al bajar, o en `sentido`).
    public func contieneEnarmonico(_ nota: Nota, sentido: SentidoDelIntervalo? = nil) -> Bool {
        (sentido.map { notas(sentido: $0) } ?? notasEnAmbasDirecciones).contains { $0.esEnarmonica(de: nota) }
    }

    /// Grado (contado desde 1) de una nota en la forma ascendente, si pertenece a ella.
    public func grado(de nota: Nota) -> Int? {
        notas.firstIndex(of: nota).map { $0 + 1 }
    }

    // MARK: Armadura y relaciones

    /// Armadura (+ sostenidos, − bemoles) para escalas diatónicas: las siete notas
    /// ocupan siete posiciones consecutivas de la línea de quintas.
    /// Re mayor → 2, Mi♭ mayor → −3, Re dórico → 0. `nil` para escalas no diatónicas.
    public var armadura: Int? {
        let posiciones = Set(notas.map(\.pasosDeQuinta))
        guard posiciones.count == 7, let minimo = posiciones.min(),
            posiciones == Set(minimo..<(minimo + 7))
        else { return nil }
        return minimo + 1
    }

    /// El modo que empieza en el grado indicado (la rotación de la escala): `Escala(.do).modo(grado: 2)` → Re dórico.
    public func modo(grado: Int) -> Escala {
        Escala(self.grado(grado), tipo.modo(grado: grado))
    }

    public func transponer(_ intervalo: Intervalo) -> Escala {
        Escala(tonica + intervalo, tipo)
    }

    // MARK: Armonización

    /// Cómo se apilan las notas de los acordes de una escala.
    public enum Apilamiento: Hashable, Sendable, CaseIterable {
        /// Por terceras, la armonía tonal: Do–Mi–Sol–Si en Do mayor.
        case terceras
        /// Por cuartas, la armonía cuartal del jazz modal: Mi–La–Re–Sol en Re dórico, la base del acorde de *So
        /// What*.
        case cuartas

        /// El número del intervalo entre una nota y la siguiente: 3 o 4.
        var numero: Int { self == .terceras ? 3 : 4 }
    }

    /// Acorde por terceras superpuestas sobre un grado (tríada o cuatríada): ``acorde(grado:notas:por:)`` con tres o
    /// cuatro notas.
    public func acorde(grado: Int, cuatriada: Bool = false) -> Acorde? {
        acorde(grado: grado, notas: cuatriada ? 4 : 3)
    }

    /// El acorde de `notas` notas (de 2 a 7) apiladas sobre un grado, por terceras o por cuartas. En una
    /// heptatónica, por terceras, un grado sí y otro no (con 5, 6 y 7 notas, los de 9.ª, 11.ª y 13.ª: Do7M(9) en
    /// Do mayor); por cuartas, dos grados no y uno sí. En las demás, cada nota es la siguiente de la escala que
    /// está a una 3.ª (o a una 4.ª) de la anterior, por su nombre: en Do blues, Do–Mi♭–Sol–Si♭ (Dom7), y no
    /// Do–Fa–Sol. `nil` si falta ese intervalo (el 2.º grado de Do pentatónica mayor, Re, no tiene Fa) o si las
    /// notas no forman un tipo conocido.
    public func acorde(grado: Int, notas cuantas: Int, por apilamiento: Apilamiento = .terceras) -> Acorde? {
        guard (2...7).contains(cuantas) else { return nil }
        var nombres = [self.grado(grado)]
        if tipo.intervalos.count == 7 {
            nombres = (0..<cuantas).map { self.grado(grado + (apilamiento.numero - 1) * $0) }
        } else {
            var posicion = grado
            while nombres.count < cuantas, let ultima = nombres.last {
                let siguiente = (1..<tipo.intervalos.count).first {
                    ultima.intervalo(hasta: self.grado(posicion + $0)).numeroSimple == apilamiento.numero
                }
                guard let siguiente else { return nil }
                posicion += siguiente
                nombres.append(self.grado(posicion))
            }
        }
        let raiz = nombres[0]
        guard let tipo = TipoDeAcorde(pasosDeQuinta: Set(nombres.map { $0.pasosDeQuinta - raiz.pasosDeQuinta })) else {
            return nil
        }
        return Acorde(raiz, tipo)
    }

    /// Acordes de todos los grados, por terceras (``acorde(grado:cuatriada:)``): `nil` si un grado no tiene la 3.ª
    /// o no forma un tipo conocido.
    public func armonizar(cuatriadas: Bool = false) -> [Acorde?] {
        armonizar(notas: cuatriadas ? 4 : 3)
    }

    /// Los acordes de `notas` notas de todos los grados, por terceras o por cuartas (``acorde(grado:notas:por:)``).
    ///
    ///     Escala(.re, .dorico).armonizar(notas: 4, por: .cuartas)[1]?.fundamental   // Mi (Mi–La–Re–Sol)
    public func armonizar(notas cuantas: Int, por apilamiento: Apilamiento = .terceras) -> [Acorde?] {
        (1...tipo.intervalos.count).map { acorde(grado: $0, notas: cuantas, por: apilamiento) }
    }

    /// Las tensiones disponibles sobre la cuatríada de un grado, con el modo de la escala que empieza en él: la
    /// tabla de la teoría acorde-escala que se enseña en Berklee. En Do mayor, I7M: 9 y 13; ii7: 9, 11 y 13; iii7: 11; IV7M:
    /// 9, ♯11 y 13; V7: 9 y 13; vi7: 9 y 11; viiø7: 11 y ♭13. La 13 del ii7 cuenta como tensión, aunque forma un
    /// tritono con la 3.ª (hay quien la evita). Vacío si el grado no tiene cuatríada.
    public func tensionesDisponibles(grado: Int) -> [NotaSobreElAcorde] {
        guard let acorde = acorde(grado: grado, cuatriada: true) else { return [] }
        return modo(grado: grado).notas(sobre: acorde).filter { $0.papel == .tension }
    }

    /// La cuatríada de cada grado con sus tensiones disponibles (``tensionesDisponibles(grado:)``): lo que piden
    /// la hoja de la escala y `armonia escala --tensiones`.
    public var armonizacionConTensiones: [(acorde: Acorde?, tensiones: [NotaSobreElAcorde])] {
        (1...tipo.intervalos.count).map { (acorde(grado: $0, cuatriada: true), tensionesDisponibles(grado: $0)) }
    }

    /// Cifrado romano del acorde de un grado. Las alteraciones del numeral se miden
    /// respecto a la escala `referencia` sobre la misma tónica (mayor por defecto):
    /// La menor armónica → i, ii°, ♭III+, iv, V, ♭VI, vii°;
    /// con `referencia: .menorNatural` → i, ii°, III+, iv, V, VI, ♯vii°.
    /// Solo para escalas heptatónicas.
    public func cifradoRomano(
        grado: Int, cuatriada: Bool = false,
        referencia: TipoDeEscala = .mayor
    ) -> String? {
        guard tipo.intervalos.count == 7, referencia.intervalos.count == 7,
            let acordeGrado = acorde(grado: grado, cuatriada: cuatriada)
        else { return nil }
        let i = modulo(grado - 1, 7)
        let diferencia =
            acordeGrado.fundamental.pasosDeQuinta - tonica.pasosDeQuinta
            - referencia.intervalos[i].pasosDeQuinta
        guard diferencia % 7 == 0 else { return nil }
        let romanos = ["I", "II", "III", "IV", "V", "VI", "VII"]
        let numeral = acordeGrado.tipo.esMenor ? romanos[i].lowercased() : romanos[i]
        return Alteracion(diferencia / 7).simbolo + numeral + acordeGrado.tipo.sufijoRomano
    }

    /// Cifrados romanos de todos los grados.
    public func cifradosRomanos(
        cuatriadas: Bool = false,
        referencia: TipoDeEscala = .mayor
    ) -> [String?] {
        (1...tipo.intervalos.count).map {
            cifradoRomano(grado: $0, cuatriada: cuatriadas, referencia: referencia)
        }
    }

    /// "Re dórico".
    public var nombre: String { "\(tonica.nombre) \(tipo.nombre)" }

    /// Nombre en la notación indicada: "Re dórico", "D dorian", `.compacta(.ingles)` → "B♭ harmonic minor".
    public func nombre(en notacion: Notacion) -> String {
        "\(tonica.nombre(en: notacion)) \(tipo.nombre(en: notacion))"
    }
}

extension Escala: CustomStringConvertible {
    public var description: String { nombre }
}

extension Escala: Codable {
    // Se codifica con su estructura (tónica y tipo con sus intervalos) y no como texto,
    // para conservar también los tipos sin nombre conocido, como los modos de escalas propias.
    private enum Claves: String, CodingKey { case tonica, tipo }

    public init(from decoder: Decoder) throws {
        let contenedor = try decoder.container(keyedBy: Claves.self)
        let tonica = try contenedor.decode(Nota.self, forKey: .tonica)
        let tipo = try contenedor.decode(TipoDeEscala.self, forKey: .tipo)
        self.init(tonica, tipo)
    }

    public func encode(to encoder: Encoder) throws {
        var contenedor = encoder.container(keyedBy: Claves.self)
        try contenedor.encode(tonica, forKey: .tonica)
        try contenedor.encode(tipo, forKey: .tipo)
    }
}

extension Escala: RepresentableComoTexto, Nombrable, Transponible, ConClasesDeAltura {
    /// "Re dórico", "D dorian". Los tipos sin nombre conocido no se pueden volver a leer;
    /// por eso `Escala` se codifica con su estructura y no con este texto.
    public func texto(en notacion: Notacion) -> String { nombre(en: notacion) }

    /// Clases de altura de la escala: cualquier escala mayor → 7-35.
    /// Clases de altura de la forma ascendente (la menor melódica es 7-34, como la de jazz).
    public var conjuntoDeClasesDeAltura: ConjuntoDeClasesDeAltura { ConjuntoDeClasesDeAltura(notas: notas) }
}

// MARK: - Armaduras y círculo de quintas

extension Escala {
    /// Alteraciones de la armadura en su orden tradicional:
    /// Re mayor → [Fa♯, Do♯]; Mi♭ mayor → [Si♭, Mi♭, La♭]. `nil` si la escala no es diatónica.
    ///
    /// Más allá de siete, siguen los dobles (el octavo sostenido es Fa𝄪).
    public var notasDeLaArmadura: [Nota]? {
        guard let n = armadura else { return nil }
        if n > 0 { return (0..<n).map { Nota(pasosDeQuinta: 6 + $0) } }
        return (0..<(-n)).map { Nota(pasosDeQuinta: -2 - $0) }
    }

    /// Escala diatónica con una armadura dada: `Escala(armadura: 3)` → La mayor,
    /// `Escala(armadura: -2, tipo: .menorNatural)` → Sol menor, `Escala(armadura: 0, tipo: .dorico)` → Re dórico.
    /// `nil` si el tipo no es diatónico.
    public init?(armadura: Int, tipo: TipoDeEscala = .mayor) {
        let posiciones = tipo.intervalos.map(\.pasosDeQuinta)
        guard let minimo = posiciones.min(), Set(posiciones) == Set(minimo..<(minimo + 7)) else { return nil }
        self.init(Nota(pasosDeQuinta: armadura - 1 - minimo), tipo)
    }

    /// Las tonalidades de un tipo diatónico ordenadas por el círculo de quintas, de 7 bemoles
    /// a 7 sostenidos: Do♭, Sol♭, Re♭ … Do, Sol … Do♯ mayor.
    public static func circuloDeQuintas(_ tipo: TipoDeEscala = .mayor) -> [Escala] {
        (-7...7).compactMap { Escala(armadura: $0, tipo: tipo) }
    }

    /// Distancia en el círculo de quintas entre dos escalas diatónicas: cuántas alteraciones
    /// cambian en la armadura. Do mayor–Sol mayor → 1; Do mayor–La menor → 0.
    public func distancia(hasta otra: Escala) -> Int? {
        guard let a = armadura, let b = otra.armadura else { return nil }
        return abs(a - b)
    }

    /// La escritura enarmónica con menos alteraciones: Do♯ mayor (7♯) → Re♭ mayor (5♭).
    /// Con seis alteraciones en cada lado (Fa♯/Sol♭ mayor) no cambia.
    public var enarmonicaMasSimple: Escala {
        let opciones = [-12, 0, 12].map { Escala(Nota(pasosDeQuinta: tonica.pasosDeQuinta + $0), tipo) }
        func coste(_ escala: Escala) -> Int {
            escala.armadura.map(abs) ?? escala.notas.reduce(0) { $0 + $1.alteracion.numeroDeSignos }
        }
        return opciones.min { coste($0) < coste($1) || (coste($0) == coste($1) && $0 == self) } ?? self
    }
}

// MARK: - Los hexacordos

// Las tres escalas de seis notas de Guido d'Arezzo, sobre el tipo `hexacordo`. Lo que se hace con una escala está en
// Escala+….swift, y los grados con nombre, en NombreDeGrado.swift.

extension Escala {
    /// El hexacordo natural, sobre Do (Do Re Mi Fa Sol La).
    public static let hexacordoNatural = Escala(.do, .hexacordo)
    /// El hexacordo duro, sobre Sol (Sol La Si Do Re Mi), con el si «cuadrado».
    public static let hexacordoDuro = Escala(.sol, .hexacordo)
    /// El hexacordo blando, sobre Fa (Fa Sol La Si♭ Do Re), con el si «redondo».
    public static let hexacordoBlando = Escala(.fa, .hexacordo)
}
