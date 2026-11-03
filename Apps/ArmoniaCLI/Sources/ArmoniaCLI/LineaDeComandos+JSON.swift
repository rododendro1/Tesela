import Armonia
import ArmoniaPresentacion
import Foundation

// MARK: - La salida en JSON
//
// Con `--json`, las consultas que lo admiten dan sus datos en JSON en lugar de texto, para leerlos desde un script o
// desde otro programa:
//
//     armonia acorde Sol7/Si --json | jq '.[0].notas'
//
// Las claves son siempre las mismas, en español y sin tildes, sea cual sea el idioma, y cambiarlas rompe a quien las
// lea. Los nombres de notas, acordes y escalas van en la notación elegida (`--ingles`, `--idioma`…), como en el
// texto, y al lado van los datos que no dependen de ella: las clases de altura (0 = Do … 11 = Si). Los errores no
// cambian: van en texto a la salida de errores, con el mismo código de salida.

extension LineaDeComandos {
    /// Un error de uso dentro de una salida en JSON: `ejecutar` lo escribe como cualquier otro (`uso(_:_:)`).
    struct FalloDeUso: Error {
        let error: ErrorDeUso
    }

    /// Lo que hace una orden con `--json`: sus datos, a partir del resto de los argumentos.
    typealias SalidaJSON = @Sendable (_ argumentos: [String], _ notacion: Notacion) throws -> any Encodable

    /// Lo que da cada orden con `--json`, por el primero de sus nombres (`Orden.nombres`).
    static let salidasJSON: [String: SalidaJSON] = [
        "acorde": { try acordeJSON($0, $1) },
        "identificar": { try identificarJSON($0, $1) },
        "escala": { try escalaJSON($0, $1) },
        "analizar": { try analizarJSON($0, $1) },
        "conjunto": { try conjuntoJSON($0, $1) },
        "serie": { try serieJSON($0, $1) },
    ]

    /// Los datos en JSON con las claves ordenadas y sangría de dos espacios, para que la salida no cambie de una vez
    /// a otra.
    static func textoJSON(_ datos: any Encodable) throws -> String {
        let codificador = JSONEncoder()
        codificador.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return String(decoding: try codificador.encode(datos), as: UTF8.self)
    }

    /// Las palabras de la orden, sin opciones: lanza `FalloDeUso` si queda alguna opción sin leer o si no hay
    /// ninguna palabra.
    private static func palabras(_ argumentos: Argumentos, siFaltan error: ErrorDeUso) throws -> [String] {
        if let desconocida = argumentos.opcionDesconocida { throw FalloDeUso(error: .opcionDesconocida(desconocida)) }
        guard !argumentos.restantes.isEmpty else { throw FalloDeUso(error: error) }
        return argumentos.restantes
    }

    /// Una nota por clase de altura (0…11), escritas todas a la vez para que no se repita ninguna.
    private static func nombresDeLasClases(_ notacion: Notacion) -> [String] {
        let total = ConjuntoDeClases(0..<12)
        let notas = Dictionary(uniqueKeysWithValues: zip(total.clases, total.notas()))
        return (0..<12).map { notas[$0]?.nombre(en: notacion) ?? String($0) }
    }

    // MARK: Acordes

    struct AcordeJSON: Encodable {
        struct Componente: Encodable {
            let nota: String
            let papel: String
        }
        let cifrado: String
        let nombre: String
        let fundamental: String
        let bajo: String
        /// 0 en estado fundamental, 1 en primera inversión…; `nil` si el bajo no es nota del acorde.
        let inversion: Int?
        let notas: [String]
        let clases: [Int]
        let componentes: [Componente]

        init(_ acorde: Acorde, _ notacion: Notacion) {
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
    }

    /// `acorde Sol7 Do --json`: cada acorde con sus notas, una lista aunque sea uno solo.
    static func acordeJSON(_ textos: [String], _ notacion: Notacion) throws -> [AcordeJSON] {
        try palabras(Argumentos(textos), siFaltan: .faltaCifrado).map { AcordeJSON(try Acorde(leyendo: $0), notacion) }
    }

    struct CandidatoJSON: Encodable {
        let cifrado: String
        let nombre: String
        /// Las notas del acorde que no están entre las tocadas.
        let omitidas: [String]
    }

    /// `identificar Do Mi Sol Sib --json`: los acordes que pueden formar las notas, del más probable al menos (como
    /// mucho cinco, como en el texto); vacío si no forman ninguno.
    static func identificarJSON(_ textos: [String], _ notacion: Notacion) throws -> [CandidatoJSON] {
        let notas = try palabras(Argumentos(textos), siFaltan: .faltanNotas)
        // Con octava se tiene en cuenta el bajo; sin ella, solo las notas.
        let candidatos: [Candidato<Acorde>]
        if let alturas = try? notas.map({ try Altura(leyendo: $0) }) {
            candidatos = Acorde.candidatos(alturas)
        } else {
            candidatos = Acorde.candidatos(try notas.map { try Nota(leyendo: $0) })
        }
        return candidatos.prefix(5).map {
            CandidatoJSON(
                cifrado: $0.valor.cifrado(en: notacion), nombre: $0.valor.tipo.nombre(en: notacion),
                omitidas: $0.omitidas.map { $0.nombre(en: notacion) })
        }
    }

    // MARK: Escalas y análisis

    struct EscalaJSON: Encodable {
        struct AcordeDelGrado: Encodable {
            let grado: String
            let cifrado: String
        }
        let nombre: String
        let notas: [String]
        let clases: [Int]
        /// De qué escala es modo («Modo 2 de Do mayor»), si lo es de alguna conocida.
        let modo: String?
        /// Las cuatríadas de cada grado, si la escala es heptatónica y todas forman un acorde conocido.
        let acordes: [AcordeDelGrado]?
    }

    /// `escala Re dórico --json`: la escala con sus notas y los acordes de sus grados.
    static func escalaJSON(_ textos: [String], _ notacion: Notacion) throws -> EscalaJSON {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaEscala).joined(separator: " ")
        let escala = try Escala(leyendo: texto)
        let acordes = escala.armonizar(cuatriadas: true).compactMap { $0 }
        let romanos = escala.cifradosRomanos(cuatriadas: true).compactMap { $0 }
        let completos = acordes.count == escala.notas.count && romanos.count == acordes.count
        return EscalaJSON(
            nombre: escala.nombre(en: notacion), notas: escala.notas.map { $0.nombre(en: notacion) },
            clases: escala.notas.map(\.claseDeAltura),
            modo: PresentacionDeEscalaYAcorde.modo(de: escala, notacion: notacion),
            acordes: completos
                ? zip(romanos, acordes).map { EscalaJSON.AcordeDelGrado(grado: $0, cifrado: $1.cifrado(en: notacion)) }
                : nil)
    }

    struct AnalisisJSON: Encodable {
        struct Tramo: Encodable {
            /// «en Sol mayor» al modular; `nil` en el primer tramo si no hay modulaciones.
            let cabecera: String?
            let acordes: [Fila]
        }
        struct Fila: Encodable {
            let cifrado: String
            let grado: String
            /// Vacío si el acorde no tiene función en la tonalidad.
            let funcion: String
        }
        let titulo: String
        let tramos: [Tramo]
        let cadencias: [String]
    }

    /// `analizar Do Fa Sol7 Do [--en Do mayor] --json`: el análisis por tramos, como en el texto.
    static func analizarJSON(_ textos: [String], _ notacion: Notacion) throws -> AnalisisJSON {
        var argumentos = Argumentos(textos)
        guard let tonalidad = try argumentos.quitarTonalidad() else { throw FalloDeUso(error: .faltaTonalidadTrasEn) }
        let acordes = try palabras(argumentos, siFaltan: .faltanAcordesDelAnalisis)
        let analisis = try PresentacionDeAnalisis.analizar(
            acordes.joined(separator: " "), en: tonalidad, notacion: notacion)
        return AnalisisJSON(
            titulo: analisis.titulo,
            tramos: analisis.tramos.map { tramo in
                AnalisisJSON.Tramo(
                    cabecera: tramo.cabecera,
                    acordes: tramo.filas.map {
                        AnalisisJSON.Fila(cifrado: $0.cifrado, grado: $0.grado, funcion: $0.funcion)
                    })
            },
            cadencias: analisis.cadencias)
    }

    // MARK: Teoría postonal

    struct ConjuntoJSON: Encodable {
        let clases: [Int]
        let notas: [String]
        let forte: String?
        let formaNormal: [Int]
        let formaPrima: [Int]
        let vectorIntervalico: [Int]
        let vectorDeIndice: [Int]
    }

    /// `conjunto 0 4 7 --json`: el conjunto con sus formas y sus vectores.
    static func conjuntoJSON(_ textos: [String], _ notacion: Notacion) throws -> ConjuntoJSON {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaConjunto).joined(separator: " ")
        let conjunto = try ConjuntoDeClases(leyendo: texto)
        return ConjuntoJSON(
            clases: conjunto.clases, notas: conjunto.notas().map { $0.nombre(en: notacion) },
            forte: conjunto.numeroDeForte, formaNormal: conjunto.formaNormal, formaPrima: conjunto.formaPrima,
            vectorIntervalico: conjunto.vectorIntervalico, vectorDeIndice: conjunto.vectorDeIndice)
    }

    struct SerieJSON: Encodable {
        let clases: [Int]
        let notas: [String]
        let intervalos: [Int]
        let deTodosLosIntervalos: Bool
        /// El número de Forte de cada hexacordo (o sus clases, si no lo tiene).
        let hexacordos: [String]
        let formasCombinatorias: [String]
        let formasDistintas: Int
        /// Cada fila es una P, de izquierda a derecha; cada columna, una I, de arriba abajo.
        let matriz: [[Int]]
    }

    /// `serie 0 e 7 4 2 9 3 8 t 1 5 6 --json`: la serie con sus intervalos, sus hexacordos, sus formas y la matriz.
    static func serieJSON(_ textos: [String], _ notacion: Notacion) throws -> SerieJSON {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaSerie).joined(separator: " ")
        let serie = try SerieDodecafonica(leyendo: texto)
        let nombres = nombresDeLasClases(notacion)
        let (primero, segundo) = serie.hexacordos
        return SerieJSON(
            clases: serie.clases, notas: serie.clases.map { nombres[$0] }, intervalos: serie.intervalos,
            deTodosLosIntervalos: serie.esDeTodosLosIntervalos,
            hexacordos: [primero, segundo].map { $0.numeroDeForte ?? $0.description },
            formasCombinatorias: serie.formasCombinatorias.map(\.description),
            formasDistintas: serie.numeroDeFormasDistintas, matriz: serie.matriz)
    }
}
