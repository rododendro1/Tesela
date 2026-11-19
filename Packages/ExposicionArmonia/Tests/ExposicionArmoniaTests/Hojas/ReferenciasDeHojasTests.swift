import Armonia
import Foundation
import Testing

@testable import ExposicionArmonia

/// Las hojas de estudio comparadas con las guardadas en `Tests/ExposicionArmoniaTests/Hojas/Referencias`: un cambio de
/// maquetación que nadie buscaba (una sección que se mueve, una página que se parte, un texto que se sale) hace fallar
/// la prueba.
///
/// Si el cambio es el que se quería, se regeneran los ficheros y se revisa el diff en el pull request:
///
///     TESELA_REGENERAR_REFERENCIAS=1 swift test --filter ReferenciasDeHojasTests
@Suite struct ReferenciasDeHojasTests {
    @Test(arguments: HojaDeReferencia.allCases)
    func comoLaGuardada(_ hoja: HojaDeReferencia) throws {
        try ReferenciaDeHoja.comprobar(hoja.contenido, en: hoja.fichero)
    }

    @Test func ningunFicheroSobra() throws {
        let guardados = try FileManager.default.contentsOfDirectory(atPath: ReferenciaDeHoja.carpeta.path)
            .filter { !$0.hasPrefix(".") }
        #expect(
            Set(guardados) == Set(HojaDeReferencia.allCases.map(\.fichero)),
            "Referencias que ninguna hoja escribe, u hojas sin referencia")
    }
}

/// Una hoja por caso: la de una escala (con su reloj al lado y el mástil), la de un acorde (con el pentagrama en el
/// encabezado), la de una progresión analizada, la de una tonalidad, la de un ritmo, las dos comparaciones y una en
/// HTML.
enum HojaDeReferencia: String, CaseIterable, CustomTestStringConvertible {
    case escalaReDorico = "escala-re-dorico"
    case acordeSol7 = "acorde-sol7"
    case analisisIiVI = "analisis-ii-v-i"
    case tonalidadReMayor = "tonalidad-re-mayor"
    case ritmoTresillo = "ritmo-tresillo"
    case comparacionDeEscalas = "comparacion-do-mayor-do-dorico"
    case comparacionDeProgresiones = "comparacion-de-progresiones"
    case acordeSol7EnHTML = "acorde-sol7-html"

    var testDescription: String { rawValue }

    var fichero: String { rawValue + (self == .acordeSol7EnHTML ? ".html" : ".svg") }

    var contenido: String {
        let notacion = Notacion.compacta(.espanol)
        switch self {
        case .escalaReDorico:
            return HojaDeEstudio.escala(Escala(.re, .dorico), en: notacion)
        case .acordeSol7:
            return HojaDeEstudio.acorde(Acorde("Sol7"), en: notacion)
        case .analisisIiVI:
            let analisis = try! PresentacionDeAnalisis.analizar("Rem7 Sol7 Do7M", notacion: notacion)
            return HojaDeEstudio.analisis(analisis, en: notacion)
        case .tonalidadReMayor:
            return HojaDeEstudio.tonalidad(Tonalidad(.re), en: notacion)
        case .ritmoTresillo:
            return HojaDeEstudio.ritmo(.tresillo, en: notacion)
        case .comparacionDeEscalas:
            return HojaDeEstudio.comparacion(Escala(.do), con: Escala(.do, .dorico), en: notacion)
        case .comparacionDeProgresiones:
            return HojaDeEstudio.comparacion(
                [Acorde("Do"), Acorde("Lam"), Acorde("Rem"), Acorde("Sol7")],
                con: [Acorde("Do"), Acorde("La7"), Acorde("Rem"), Acorde("Re♭7")], notacion: notacion) ?? ""
        case .acordeSol7EnHTML:
            return HojaDeEstudio.acorde(Acorde("Sol7"), en: notacion, formato: .html)
        }
    }
}

/// Las hojas guardadas y cómo se comparan.
enum ReferenciaDeHoja {
    static let carpeta = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent().appendingPathComponent("Referencias")

    static var regenerar: Bool { ProcessInfo.processInfo.environment["TESELA_REGENERAR_REFERENCIAS"] == "1" }

    /// Falla si `texto` no es igual al fichero `nombre`, con la primera línea distinta. Con
    /// `TESELA_REGENERAR_REFERENCIAS=1`, o si el fichero no existe, lo escribe (y si no existía, también falla, para
    /// que no pase sin que nadie lo mire).
    static func comprobar(
        _ texto: String, en nombre: String, sourceLocation: SourceLocation = #_sourceLocation
    ) throws {
        let fichero = carpeta.appendingPathComponent(nombre)
        guard !regenerar, let guardado = try? String(contentsOf: fichero, encoding: .utf8) else {
            let existia = FileManager.default.fileExists(atPath: fichero.path)
            try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)
            try Data(texto.utf8).write(to: fichero)
            if !existia {
                Issue.record(
                    "\(nombre) no existía: se ha creado; revísalo y añádelo al repositorio",
                    sourceLocation: sourceLocation)
            }
            return
        }
        guard texto != guardado else { return }
        let nuevas = texto.components(separatedBy: "\n")
        let viejas = guardado.components(separatedBy: "\n")
        let linea = zip(nuevas, viejas).enumerated().first { $1.0 != $1.1 }?.offset ?? min(nuevas.count, viejas.count)
        let ahora = linea < nuevas.count ? nuevas[linea] : "(fin)"
        let antes = linea < viejas.count ? viejas[linea] : "(fin)"
        Issue.record(
            """
            \(nombre) ha cambiado en la línea \(linea + 1):
              guardada: \(antes.prefix(300))
              ahora:    \(ahora.prefix(300))
            Si es lo que se quería: TESELA_REGENERAR_REFERENCIAS=1 swift test --filter ReferenciasDeHojasTests
            """, sourceLocation: sourceLocation)
    }
}
