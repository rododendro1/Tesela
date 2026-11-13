import Armonia

// Los acordes de cada grado, en mayor y en menor: las tríadas y las cuatríadas diatónicas, los préstamos del modo
// homónimo, las dominantes y las sensibles secundarias, el sustituto tritonal, la napolitana y las sextas aumentadas.
// Cada fila es un cifrado romano que lee `Tonalidad.acorde(romano:)`, con lo que dice de él
// `Tonalidad.analizar(_:siguiente:)` (el grado, la función y de dónde sale), el acorde sobre Do y sus notas con los
// nombres de los sistemas móviles: el do móvil (`SolfeoRelativo`), el tonic sol-fa, el sargam, el carnático, el jianpu…
// (`SistemaDeNombres` de la familia `.movil`), todos con Do como tónica.

/// Un cifrado y el acorde al que resuelve, para que el análisis reconozca las dominantes secundarias, el sustituto
/// tritonal, la napolitana y las sextas aumentadas.
private struct Grado {
    let cifrado: String
    var resuelve: String?

    init(_ cifrado: String, resuelve: String? = nil) {
        self.cifrado = cifrado
        self.resuelve = resuelve
    }
}

/// Los de los dos modos, con los que van a otro grado.
private func secundarios(mayor: Bool) -> [Grado] {
    let destinos = mayor ? ["ii", "iii", "IV", "V", "vi"] : ["III", "iv", "v", "VI", "VII"]
    let dominantes = destinos.flatMap { [Grado("V/\($0)", resuelve: $0), Grado("V7/\($0)", resuelve: $0)] }
    let sensibles = destinos.flatMap { [Grado("vii°/\($0)", resuelve: $0), Grado("vii°7/\($0)", resuelve: $0)] }
    let tonica = mayor ? "I" : "i"
    return dominantes + sensibles + [
        Grado("subV7", resuelve: tonica), Grado("subV7/V", resuelve: "V"), Grado("N6", resuelve: "V"),
        Grado("It+6", resuelve: "V"), Grado("Fr+6", resuelve: "V"), Grado("Ger+6", resuelve: "V"),
    ]
}

private let gradosEnMayor: [Grado] =
    ["I", "ii", "iii", "IV", "V", "vi", "vii°", "Imaj7", "ii7", "iii7", "IVmaj7", "V7", "vi7", "viiø7"].map {
        Grado($0)
    }
    + ["i", "iv", "iv7", "♭III", "♭VI", "♭VII", "♭VImaj7", "vii°7"].map { Grado($0) }
    + secundarios(mayor: true)

private let gradosEnMenor: [Grado] =
    [
        "i", "ii°", "III", "iv", "v", "V", "VI", "VII", "vii°", "i7", "iiø7", "IIImaj7", "iv7", "v7", "V7", "VImaj7",
        "VII7", "vii°7",
    ].map { Grado($0) }
    + ["I", "IV", "III+"].map { Grado($0) }
    + secundarios(mayor: false)

/// Los sistemas de nombres móviles, en el orden de `SistemaDeNombres.allCases`.
private let sistemasMoviles = SistemaDeNombres.allCases.filter { $0.familia == .movil }

let columnasDeGrados: [String] =
    [
        "modo", "cifrado", "categoria", "grado", "nombre_del_grado", "funcion", "acorde_sobre_do", "notas",
        "do_movil", "do_movil_con_do_en_menor",
    ] + sistemasMoviles.map { "notas_en_\($0.rawValue)" } + ["se_reconoce"]

/// De dónde sale un acorde, con una palabra: «diatónico», «dominante secundaria»…
private func categoria(_ categoria: AcordeAnalizado.Categoria) -> String {
    switch categoria {
    case .diatonico: return "diatónico"
    case .dominanteSecundaria: return "dominante secundaria"
    case .sensibleSecundaria: return "sensible secundaria"
    case .sustitutoTritonal: return "sustituto tritonal"
    case .cuartaYSextaCadencial: return "cuarta y sexta cadencial"
    case .napolitana: return "napolitana"
    case .sextaAumentada: return "sexta aumentada"
    case .prestamo: return "préstamo"
    case .cromatico: return "cromático"
    }
}

/// La fila de un cifrado en Do mayor o Do menor; termina si el motor no lo lee.
private func filaDeGrado(_ grado: Grado, en tonalidad: Tonalidad) -> [String] {
    let acorde: Acorde
    let siguiente: Acorde?
    do {
        acorde = try tonalidad.acorde(romano: grado.cifrado)
        siguiente = try grado.resuelve.map { try tonalidad.acorde(romano: $0) }
    } catch {
        fallar("«\(grado.cifrado)» no se lee en \(tonalidad): \(error)")
    }
    let analizado = tonalidad.analizar(acorde, siguiente: siguiente)
    let notas = acorde.notas
    let nombresDeLasNotas: [String] = sistemasMoviles.map { sistema in
        sistema.nombres(de: notas, tonica: tonalidad.tonica).joined(separator: " ")
    }
    let modo: String = tonalidad.modo == .mayor ? "mayor" : "menor"
    let nombreDelGrado: String = tonalidad.nombreDeGrado(de: acorde.fundamental)?.nombre ?? ""
    let funcion: String = analizado.funcion?.nombre ?? ""
    let doMovil: String = SolfeoRelativo(tonalidad).silabas(de: notas).joined(separator: " ")
    let doMovilConDo: String = SolfeoRelativo(tonalidad, menor: .enDo).silabas(de: notas).joined(separator: " ")
    let ficha: [String] = [
        modo, grado.cifrado, categoria(analizado.categoria), String(analizado.grado), nombreDelGrado, funcion,
        acorde.cifrado, notas.map(\.nombre).joined(separator: " "), doMovil, doMovilConDo,
    ]
    return ficha + nombresDeLasNotas + [siONo(analizado.cifrado == grado.cifrado)]
}

let grados = Catalogo(
    fichero: "grados.tsv", columnas: columnasDeGrados,
    filas: gradosEnMayor.map { filaDeGrado($0, en: Tonalidad(.do, .mayor)) }
        + gradosEnMenor.map { filaDeGrado($0, en: Tonalidad(.do, .menor)) })
