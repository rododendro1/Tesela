import ArmoniaNucleo

// Tonalidad: una tónica y un modo (mayor o menor), con lo que eso implica en la práctica
// común: armadura, relativa y homónima, tonos vecinos, funciones de los grados y armonía.
//
// Una `Escala` es solo un conjunto ordenado de notas (Re dórico, Do blues, Sol alterada); una
// `Tonalidad` es el marco tonal. La diferencia importa sobre todo en menor: La menor tiene la
// armadura de la menor natural, pero escribe y armoniza con la sensible Sol♯ (V mayor, vii°).

public struct Tonalidad: Hashable, Sendable {
    public enum Modo: Hashable, Sendable, CaseIterable {
        case mayor
        case menor
    }

    public let tonica: Nota
    public let modo: Modo

    public init(_ tonica: Nota, _ modo: Modo = .mayor) {
        self.tonica = tonica
        self.modo = modo
    }

    /// La tonalidad de una escala mayor o menor (natural, armónica o melódica); `nil` para
    /// otras escalas, como los modos o la pentatónica.
    public init?(_ escala: Escala) {
        switch escala.tipo {
        case .mayor: self.init(escala.tonica, .mayor)
        case .menorNatural, .menorArmonica, .menorMelodica, .menorMelodicaJazz: self.init(escala.tonica, .menor)
        default: return nil
        }
    }

    /// Tonalidad con una armadura dada: `Tonalidad(armadura: 3)` → La mayor;
    /// `Tonalidad(armadura: -2, modo: .menor)` → Sol menor.
    public init(armadura: Int, modo: Modo = .mayor) {
        self.init(Nota(pasosDeQuinta: modo == .mayor ? armadura : armadura + 3), modo)
    }

    // MARK: Escalas

    /// La escala que da la armadura: mayor o menor natural.
    public var escala: Escala { Escala(tonica, modo == .mayor ? .mayor : .menorNatural) }

    /// La escala con la que se escribe y se armoniza: la mayor, o en menor la armónica (con la sensible).
    public var escalaDeReferencia: Escala { Escala(tonica, modo == .mayor ? .mayor : .menorArmonica) }

    /// Todas las notas propias de la tonalidad: en menor, también el 6.º y el 7.º elevados
    /// (Fa♯ y Sol♯ en La menor).
    public var notasPropias: [Nota] {
        guard modo == .menor else { return escala.notas }
        var notas = escala.notas
        for nota in Escala(tonica, .menorMelodica).notas where !notas.contains(nota) { notas.append(nota) }
        return notas
    }

    // MARK: Armadura y relaciones

    /// Número de alteraciones de la armadura (+ sostenidos, − bemoles).
    public var armadura: Int { escala.armadura ?? 0 }

    /// Alteraciones de la armadura en su orden: La mayor → [Fa♯, Do♯, Sol♯].
    public var notasDeLaArmadura: [Nota] { escala.notasDeLaArmadura ?? [] }

    /// Las tonalidades de un modo por el círculo de quintas, de 7 bemoles a 7 sostenidos.
    public static func circuloDeQuintas(_ modo: Modo = .mayor) -> [Tonalidad] {
        (-7...7).map { Tonalidad(armadura: $0, modo: modo) }
    }

    /// Relativa: misma armadura, otro modo (Do mayor ↔ La menor).
    public var relativa: Tonalidad {
        modo == .mayor ? Tonalidad(tonica + .sextaMayor, .menor) : Tonalidad(tonica + .terceraMenor, .mayor)
    }

    /// Homónima: misma tónica, otro modo (Do mayor ↔ Do menor).
    public var homonima: Tonalidad { Tonalidad(tonica, modo == .mayor ? .menor : .mayor) }

    /// Distancia en el círculo de quintas: cuántas alteraciones cambian en la armadura.
    public func distancia(hasta otra: Tonalidad) -> Int { abs(armadura - otra.armadura) }

    /// La escritura enarmónica con menos alteraciones: Do♯ mayor → Re♭ mayor. Con seis
    /// alteraciones en cada lado (Fa♯/Sol♭ mayor) no cambia.
    public var enarmonicaMasSimple: Tonalidad {
        let opciones = [-12, 0, 12].map { Tonalidad(Nota(pasosDeQuinta: tonica.pasosDeQuinta + $0), modo) }
        return opciones.min { a, b in
            abs(a.armadura) < abs(b.armadura) || (abs(a.armadura) == abs(b.armadura) && a == self)
        } ?? self
    }

    /// Tonos vecinos: los que difieren en una alteración como mucho, en mayor o menor
    /// (para Do mayor: La menor, Sol mayor, Mi menor, Fa mayor y Re menor).
    public var vecinas: [Tonalidad] {
        var resultado: [Tonalidad] = []
        for desplazamiento in [0, 1, -1] {
            for otroModo in Modo.allCases {
                let t = Tonalidad(armadura: armadura + desplazamiento, modo: otroModo)
                if t != self { resultado.append(t) }
            }
        }
        return resultado
    }

    // MARK: Grados y armonía

    /// Nota de un grado (contado desde 1) en la escala que da la armadura.
    public func grado(_ n: Int) -> Nota { escala.grado(n) }

    /// Función de un grado. En menor, el 7.º grado es la sensible (Sol♯ en La menor).
    public func nombreDeGrado(_ grado: Int) -> NombreDeGrado {
        escalaDeReferencia.nombreDeGrado(grado) ?? .tonica
    }

    /// Función de una nota: en La menor, Sol♯ es la sensible y Sol, la subtónica.
    /// `nil` si la nota no es propia de la tonalidad.
    public func nombreDeGrado(de nota: Nota) -> NombreDeGrado? {
        guard let indice = escala.notas.firstIndex(where: { $0.natural == nota.natural }),
            notasPropias.contains(nota)
        else { return nil }
        if indice == 6 {
            return modo == .menor && nota == escala.notas[6] ? .subtonica : .sensible
        }
        return escala.nombreDeGrado(indice + 1)
    }

    /// Acorde de un grado según la práctica común: en mayor, el de la escala mayor; en menor,
    /// los de la menor natural salvo el V y el vii, que usan la sensible (Mi7 y Sol♯°7 en La menor).
    public func acorde(grado: Int, cuatriada: Bool = false) -> Acorde {
        let i = modulo(grado - 1, 7)
        let base = modo == .menor && (i == 4 || i == 6) ? escalaDeReferencia : escala
        return base.acorde(grado: grado, cuatriada: cuatriada) ?? Acorde(base.grado(grado), .mayor)
    }

    public func armonizar(cuatriadas: Bool = false) -> [Acorde] {
        (1...7).map { acorde(grado: $0, cuatriada: cuatriadas) }
    }

    /// Cifrado romano según la práctica común (en menor sin alteraciones delante: el VII es la
    /// sensible, vii°): Do mayor → I ii iii IV V vi vii°; La menor → i ii° III iv V VI vii°.
    public func cifradoRomano(grado: Int, cuatriada: Bool = false) -> String {
        let delGrado = acorde(grado: grado, cuatriada: cuatriada)
        let romanos = ["I", "II", "III", "IV", "V", "VI", "VII"]
        let numeral = romanos[modulo(grado - 1, 7)]
        return (delGrado.tipo.esMenor ? numeral.lowercased() : numeral) + delGrado.tipo.sufijoRomano
    }

    public func cifradosRomanos(cuatriadas: Bool = false) -> [String] {
        (1...7).map { cifradoRomano(grado: $0, cuatriada: cuatriadas) }
    }

    // MARK: Ortografía

    /// Escribe notas MIDI en la tonalidad (en menor, con la sensible y el 6.º elevado cuando sube).
    public func ortografiar(midi: [Int]) -> [Altura] { escalaDeReferencia.ortografiar(midi: midi) }

    /// Nombre de una clase de altura en la tonalidad.
    public func nombre(claseDeAltura clase: Int) -> Nota {
        escalaDeReferencia.nombre(claseDeAltura: clase)
    }

    /// "La menor", "Re♭ mayor".
    public var nombre: String { "\(tonica.nombre) \(modo.nombre)" }
}

extension Tonalidad: CustomStringConvertible {
    public var description: String { nombre }
}

extension Tonalidad.Modo: Nombrable {}

extension Tonalidad: RepresentableComoTexto, Nombrable, Transponible, ConClasesDeAltura {
    /// Lee "La menor", "Do mayor", "Fa# menor", "A minor", "Bb major". También acepta
    /// "menor natural", "menor armónica" o "menor melódica", que dan la misma tonalidad menor.
    ///
    /// También lee las demás notaciones: "Fis-Dur", "fis-Moll", "B-Dur" (Si♭ mayor),
    /// "ré bémol majeur", "fa diesis minore".
    public init(leyendo texto: String) throws {
        let escala: Escala
        do {
            escala = try Escala(leyendo: texto)
        } catch let error as ErrorDeLectura {
            guard let otra = Tonalidad.leerEnOtrasNotaciones(texto) else { throw error }
            self = otra
            return
        }
        guard let tonalidad = Tonalidad(escala) else {
            throw ErrorDeLectura(texto: texto, posicion: nil, motivo: .modoNoReconocido(escala.tipo.nombre))
        }
        self = tonalidad
    }

    /// Lectura en alemán ("Fis-Dur", "a-Moll"), francés ("ré majeur"), italiano ("re maggiore") y las
    /// demás lenguas de `Notacion` ("фа-диез мажор", "λα ελάσσονα").
    package static func leerEnOtrasNotaciones(_ texto: String) -> Tonalidad? {
        let limpio = texto.trimmingEspacios()
        for notacion in [Notacion.aleman, .frances, .italiano] + Notacion.deLecturaGenerica {
            for modo in [Modo.mayor, .menor] {
                let palabra = modo.nombre(en: notacion)
                let separador = notacion == .aleman ? "-" : " "
                let sufijo = (separador + palabra).claveDeBusqueda
                let clave = limpio.claveDeBusqueda
                guard clave.hasSuffix(sufijo) else { continue }
                let tonica = String(limpio.dropLast(separador.count + palabra.count)).trimmingEspacios()
                if let nombre = try? Nota(leyendo: tonica, en: notacion) { return Tonalidad(nombre, modo) }
            }
        }
        return nil
    }

    /// Como `init(leyendo:)`, devolviendo `nil` en lugar de un error.
    public init?(texto: String) {
        guard let tonalidad = try? Tonalidad(leyendo: texto) else { return nil }
        self = tonalidad
    }

    public func texto(en notacion: Notacion) -> String { nombre(en: notacion) }

    public func transponer(_ intervalo: Intervalo) -> Tonalidad { Tonalidad(tonica + intervalo, modo) }

    /// Las clases de altura de la escala que da la armadura (7-35 para toda tonalidad).
    public var conjuntoDeClases: ConjuntoDeClases { escala.conjuntoDeClases }
}

// MARK: - Idiomas
//
// Nombres de los modos y de las tonalidades en cada idioma. El resto de nombres que dependen del idioma, en `Fundamentos/Nota.swift` y `Fundamentos/Intervalo.swift`.

// MARK: - Tonalidad.Modo

extension Tonalidad.Modo {
    public var nombre: String { self == .mayor ? "mayor" : "menor" }

    public func nombre(en notacion: Notacion) -> String {
        switch notacion.idiomaDeLasNotas {
        case .espanol: return nombre
        case .ingles: return self == .mayor ? "major" : "minor"
        case .catalan: return self == .mayor ? "major" : "menor"
        case .gallego: return self == .mayor ? "maior" : "menor"
        case .euskera: return self == .mayor ? "maiorra" : "minorra"
        case .portugues: return self == .mayor ? "maior" : "menor"
        case .frances: return self == .mayor ? "majeur" : "mineur"
        case .occitano: return self == .mayor ? "major" : "menor"
        case .italiano: return self == .mayor ? "maggiore" : "minore"
        case .aleman: return self == .mayor ? "Dur" : "Moll"
        case .griego: return self == .mayor ? "μείζονα" : "ελάσσονα"
        case .ruso: return self == .mayor ? "мажор" : "минор"
        case .asturiano, .aragones: return nombre
        }
    }
}

// MARK: - Tonalidad

extension Tonalidad {
    /// "La menor" en español, "A minor" en inglés, "a-Moll" en alemán (con la tónica en minúscula
    /// si es menor), "la mineur" en francés, "la minore" en italiano, "ля минор" en ruso, "λα ελάσσονα"
    /// en griego.
    public func nombre(en notacion: Notacion) -> String {
        guard notacion.idiomaDeLasNotas == .aleman else {
            return "\(tonica.nombre(en: notacion)) \(modo.nombre(en: notacion))"
        }
        let nombreTonica = tonica.nombre(en: .aleman)
        return (modo == .menor ? nombreTonica.lowercased() : nombreTonica) + "-" + modo.nombre(en: .aleman)
    }
}

extension Tonalidad {
    /// La tonalidad como lugar, en los idiomas de los textos: "en Do mayor", "in C major",
    /// "en do major", "en do maior", "em dó maior", "en do majeur", "in do maggiore", "in C-Dur",
    /// "σε ντο μείζονα", en ruso con el preposicional ("в до мажоре") y, en euskera, con el inesivo:
    /// "do maiorrean".
    package func lugar(en notacion: Notacion) -> String {
        let completo = self.nombre(en: notacion)
        switch notacion.textos {
        case .espanol, .catalan, .gallego, .asturiano, .aragones, .frances, .occitano: return "en " + completo
        case .portugues: return "em " + completo
        case .ingles, .italiano, .aleman: return "in " + completo
        case .griego: return "σε " + completo
        case .ruso:
            // En preposicional: "в до мажоре", "в ля миноре".
            let declinado = completo.hasSuffix("мажор") || completo.hasSuffix("минор") ? completo + "е" : completo
            return "в " + declinado
        case .euskera: return Tonalidad.declinar(completo, "ean")
        }
    }

    /// En euskera los nombres acaban en "maiorra" o "minorra": el caso sustituye a la "a" del artículo
    /// ("do maiorra" → "do maiorrean", "do maiorretik", "do maiorrera").
    package static func declinar(_ nombre: String, _ sufijo: String) -> String {
        nombre.hasSuffix("a") ? String(nombre.dropLast()) + sufijo : nombre + sufijo
    }
}
