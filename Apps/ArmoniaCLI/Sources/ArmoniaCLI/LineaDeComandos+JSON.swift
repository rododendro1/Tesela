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

    // MARK: Acordes y escalas
    //
    // Los datos son los de `ArmoniaPresentacion` (DatosDeConsultas.swift), los mismos que da el texto: sus nombres
    // son las claves del JSON.

    /// `acorde Sol7 Do --json`: cada acorde con sus notas, una lista aunque sea uno solo.
    static func acordeJSON(_ textos: [String], _ notacion: Notacion) throws -> [DatosDeAcorde] {
        try palabras(Argumentos(textos), siFaltan: .faltaCifrado).map {
            DatosDeAcorde(try Acorde(leyendo: $0), notacion: notacion)
        }
    }

    /// `identificar Do Mi Sol Sib --json`: los acordes que pueden formar las notas, del más probable al menos (como
    /// mucho cinco, como en el texto); vacío si no forman ninguno.
    static func identificarJSON(_ textos: [String], _ notacion: Notacion) throws -> [DatosDeCandidato] {
        try DatosDeCandidato.identificar(palabras(Argumentos(textos), siFaltan: .faltanNotas), notacion: notacion)
    }

    /// `escala Re dórico --json`: la escala con sus notas y los acordes de sus grados.
    static func escalaJSON(_ textos: [String], _ notacion: Notacion) throws -> DatosDeEscala {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaEscala).joined(separator: " ")
        return DatosDeEscala(try Escala(leyendo: texto), notacion: notacion)
    }

    // MARK: Análisis

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

    /// `conjunto 0 4 7 --json`: el conjunto con sus formas y sus vectores.
    static func conjuntoJSON(_ textos: [String], _ notacion: Notacion) throws -> DatosDeConjunto {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaConjunto).joined(separator: " ")
        return DatosDeConjunto(try ConjuntoDeClases(leyendo: texto), notacion: notacion)
    }

    /// `serie 0 e 7 4 2 9 3 8 t 1 5 6 --json`: la serie con sus intervalos, sus hexacordos, sus formas y la matriz.
    static func serieJSON(_ textos: [String], _ notacion: Notacion) throws -> DatosDeSerie {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaSerie).joined(separator: " ")
        return DatosDeSerie(try SerieDodecafonica(leyendo: texto), notacion: notacion)
    }
}
