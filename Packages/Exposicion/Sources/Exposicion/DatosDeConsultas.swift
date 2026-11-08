import Armonia

// Los datos de lo que se consulta de un acorde, unas notas, una escala, un conjunto o una serie, sin darles forma:
// los mismos para el texto de `armonia`, para su salida `--json` y para las apps, así que se calculan en un solo
// sitio. Los nombres de notas, acordes y escalas van en la notación pedida y, al lado, lo que no depende de ella (las
// clases de altura: 0 = Do … 11 = Si).
//
// Son `Codable`, y sus nombres son las claves del JSON de `armonia … --json`: en español, sin tildes y siempre las
// mismas, sea cual sea el idioma. Cambiar uno rompe a quien lee ese JSON. Lo que es `nil` no sale en el JSON.

/// Un acorde: su cifrado, su nombre, sus notas y el papel de cada una.
///
///     let datos = DatosDeAcorde(Acorde("Sol7/Si"), notacion: .compacta(.espanol))
///     datos.inversion   // 1
public struct DatosDeAcorde: Hashable, Sendable, Codable {
    /// Una nota del acorde con su papel: «Si tercera».
    public struct Componente: Hashable, Sendable, Codable {
        public let nota: String
        public let papel: String
    }

    public let cifrado: String
    public let nombre: String
    public let fundamental: String
    public let bajo: String
    /// 0 en estado fundamental, 1 en primera inversión…; `nil` si el bajo no es nota del acorde.
    public let inversion: Int?
    public let notas: [String]
    public let clases: [Int]
    public let componentes: [Componente]

    /// Los datos del acorde, escritos en la notación.
    public init(_ acorde: Acorde, notacion: Notacion) {
        cifrado = acorde.cifrado(en: notacion)
        nombre = acorde.tipo.nombre(en: notacion)
        fundamental = acorde.fundamental.nombre(en: notacion)
        bajo = acorde.bajo.nombre(en: notacion)
        inversion = acorde.inversion
        notas = acorde.notas.map { $0.nombre(en: notacion) }
        clases = acorde.notas.map(\.claseDeAltura)
        componentes = acorde.componentes.map {
            Componente(nota: $0.nota.nombre(en: notacion), papel: $0.papel.nombre(en: notacion))
        }
    }

    /// Si el bajo no es la fundamental: un acorde invertido o con un bajo ajeno a él.
    public var tieneOtroBajo: Bool { bajo != fundamental }
}

/// Un acorde que pueden formar unas notas, con las suyas que faltan.
public struct DatosDeCandidato: Hashable, Sendable, Codable {
    public let cifrado: String
    public let nombre: String
    /// Las notas del acorde que no están entre las tocadas.
    public let omitidas: [String]

    public init(_ candidato: Candidato<Acorde>, notacion: Notacion) {
        cifrado = candidato.valor.cifrado(en: notacion)
        nombre = candidato.valor.tipo.nombre(en: notacion)
        omitidas = candidato.omitidas.map { $0.nombre(en: notacion) }
    }

    /// Los acordes que pueden formar unas notas escritas, del más probable al menos y como mucho `limite`; ninguno
    /// si no forman ninguno. Si todas llevan octava («Si2 Re4 Sol4»), cuenta cuál es el bajo; si no, solo las notas.
    ///
    ///     let candidatos = try DatosDeCandidato.identificar(["Do", "Mi", "Sol", "Sib"], en: .compacta(.espanol))
    ///     candidatos[0].cifrado   // "Do7"
    public static func identificar(
        _ textos: [String], limite: Int = 5, en notacion: Notacion
    ) throws -> [DatosDeCandidato] {
        let candidatos: [Candidato<Acorde>]
        if let alturas = try? textos.map({ try Altura(leyendo: $0) }) {
            candidatos = Acorde.candidatos(alturas: alturas)
        } else {
            candidatos = Acorde.candidatos(notas: try textos.map { try Nota(leyendo: $0) })
        }
        return candidatos.prefix(limite).map { DatosDeCandidato($0, notacion: notacion) }
    }
}

/// Una escala: su nombre, sus notas, de qué escala es modo y los acordes de sus grados.
public struct DatosDeEscala: Hashable, Sendable, Codable {
    /// El acorde de un grado, con su cifrado romano: «ii» «Rem7».
    public struct AcordeDelGrado: Hashable, Sendable, Codable {
        public let grado: String
        public let cifrado: String
    }

    public let nombre: String
    public let notas: [String]
    public let clases: [Int]
    /// De qué escala es modo («Modo 2 de Do mayor»), si lo es de alguna conocida.
    public let modo: String?
    /// Las cuatríadas de cada grado, si la escala es heptatónica y todas forman un acorde conocido.
    public let acordes: [AcordeDelGrado]?

    /// Los datos de la escala, escritos en la notación.
    public init(_ escala: Escala, notacion: Notacion) {
        nombre = escala.nombre(en: notacion)
        notas = escala.notas.map { $0.nombre(en: notacion) }
        clases = escala.notas.map(\.claseDeAltura)
        modo = PresentacionDeEscalaYAcorde.modo(de: escala, en: notacion)
        let cuatriadas = escala.armonizar(cuatriadas: true).compactMap { $0 }
        let romanos = escala.cifradosRomanos(cuatriadas: true).compactMap { $0 }
        if cuatriadas.count == escala.notas.count, romanos.count == cuatriadas.count {
            acordes = zip(romanos, cuatriadas).map { AcordeDelGrado(grado: $0, cifrado: $1.cifrado(en: notacion)) }
        } else {
            acordes = nil
        }
    }
}

/// Un conjunto de clases de altura: sus notas, sus formas y sus vectores.
///
///     let datos = DatosDeConjunto(ConjuntoDeClasesDeAltura([0, 4, 7]), notacion: .compacta(.espanol))
///     datos.forte        // "3-11"
///     datos.formaPrima   // [0, 3, 7]
public struct DatosDeConjunto: Hashable, Sendable, Codable {
    public let clases: [Int]
    public let notas: [String]
    /// `nil` si el conjunto no está en la tabla de Forte (el vacío).
    public let forte: String?
    public let formaNormal: [Int]
    public let formaPrima: [Int]
    public let vectorIntervalico: [Int]
    public let vectorDeIndice: [Int]

    /// Los datos del conjunto de clases, con las notas escritas en la notación.
    public init(_ conjunto: ConjuntoDeClasesDeAltura, notacion: Notacion) {
        clases = conjunto.clases
        notas = conjunto.notas().map { $0.nombre(en: notacion) }
        forte = conjunto.numeroDeForte
        formaNormal = conjunto.formaNormal
        formaPrima = conjunto.formaPrima
        vectorIntervalico = conjunto.vectorIntervalico
        vectorDeIndice = conjunto.vectorDeIndice
    }
}

/// Una serie dodecafónica: sus notas, sus intervalos, sus hexacordos, sus formas y su matriz.
public struct DatosDeSerie: Hashable, Sendable, Codable {
    public let clases: [Int]
    /// Una nota por clase, escritas todas a la vez para que ninguna se repita
    /// (`ConjuntoDeClasesDeAltura.nombresDeLasClases`).
    public let notas: [String]
    public let intervalos: [Int]
    public let deTodosLosIntervalos: Bool
    /// El número de Forte de cada hexacordo (o sus clases, si no lo tiene).
    public let hexacordos: [String]
    public let formasCombinatorias: [String]
    public let formasDistintas: Int
    /// Cada fila es una P, de izquierda a derecha; cada columna, una I, de arriba abajo.
    public let matriz: [[Int]]

    /// Los datos de la serie, con las notas escritas en la notación.
    public init(_ serie: SerieDodecafonica, notacion: Notacion) {
        let nombres = ConjuntoDeClasesDeAltura.nombresDeLasClases(en: notacion)
        let mitades = serie.hexacordos
        clases = serie.clases
        notas = serie.clases.map { nombres[$0] }
        intervalos = serie.intervalos
        deTodosLosIntervalos = serie.esDeTodosLosIntervalos
        hexacordos = [mitades.primero, mitades.segundo].map { $0.numeroDeForte ?? $0.description }
        formasCombinatorias = serie.formasCombinatorias.map(\.description)
        formasDistintas = serie.numeroDeFormasDistintas
        matriz = serie.matriz
    }
}
