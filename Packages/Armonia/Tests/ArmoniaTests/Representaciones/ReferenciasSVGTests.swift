import Foundation
import Hexagonos
import Testing

@testable import Armonia

/// Los dibujos del motor comparados con los guardados en `Tests/ArmoniaTests/Referencias`: un cambio en el SVG que
/// nadie buscaba (una nota que se mueve, un color, una flecha que desaparece) hace fallar la prueba.
///
/// Si el cambio es el que se quería, se regeneran los ficheros y se revisa el diff en el pull request:
///
///     TESELA_REGENERAR_REFERENCIAS=1 swift test --filter ReferenciasSVGTests
@Suite struct ReferenciasSVGTests {
    @Test(arguments: DibujoDeReferencia.allCases)
    func comoElGuardado(_ dibujo: DibujoDeReferencia) throws {
        try Referencia.comprobar(dibujo.svg, en: "\(dibujo.rawValue).svg")
    }

    @Test func ningunFicheroSobra() throws {
        let guardados = try FileManager.default.contentsOfDirectory(atPath: Referencia.carpeta.path)
            .filter { $0.hasSuffix(".svg") }
        let esperados = DibujoDeReferencia.allCases.map { "\($0.rawValue).svg" }
        #expect(Set(guardados) == Set(esperados), "Referencias que ningún caso dibuja, o casos sin referencia")
    }
}

/// Un dibujo por caso: lo bastante variados para pasar por las claves, las alteraciones, el pentagrama doble, los
/// textos en otro idioma, las flechas de los recorridos y cada forma de rejilla.
enum DibujoDeReferencia: String, CaseIterable, CustomTestStringConvertible {
    case pentagramaReDorico = "pentagrama-re-dorico"
    case pentagramaLaMenorMelodica = "pentagrama-la-menor-melodica"
    case pentagramaSiBemolMayorEnIngles = "pentagrama-si-bemol-mayor-en-ingles"
    case pentagramaDoble = "pentagrama-doble"
    case pentagramaAcordeSol7Si = "pentagrama-acorde-sol7-si"
    case pentagramaAcordeExtenso = "pentagrama-acorde-extenso"
    case pentagramaArpegioAlberti = "pentagrama-arpegio-alberti"
    case tonnetzDoMayor = "tonnetz-do-mayor"
    case tonnetzEscala = "tonnetz-escala"
    case tonnetzRecorrido = "tonnetz-recorrido"
    case tablaArmonicaRecorrido = "tabla-armonica-recorrido"
    case tecladoWickiHayden = "teclado-wicki-hayden"
    case tecladoAcordeonC = "teclado-acordeon-c"

    var testDescription: String { rawValue }

    var svg: String {
        switch self {
        case .pentagramaReDorico:
            return Escala("Re dórico").svgPentagrama()
        case .pentagramaLaMenorMelodica:
            return Escala("La menor melódica").svgPentagrama()
        case .pentagramaSiBemolMayorEnIngles:
            return Escala("Si♭ mayor").svgPentagrama(
                opciones: OpcionesDePentagrama(notacion: .ingles, nombresDeLasNotas: true))
        case .pentagramaDoble:
            return Escala(.do).svgPentagrama(octava: 3, opciones: OpcionesDePentagrama(pentagramas: .doble))
        case .pentagramaAcordeSol7Si:
            return Acorde("Sol7/Si").svgPentagrama()
        case .pentagramaAcordeExtenso:
            return Acorde("Do13♯11").svgPentagrama()
        case .pentagramaArpegioAlberti:
            return Arpegio(Acorde("Do"), patron: .alberti).svgPentagrama()
        case .tonnetzDoMayor:
            return Tonnetz(Acorde("Do")).svg()
        case .tonnetzEscala:
            return Tonnetz(Escala("Do mayor")).svg(notacion: .ingles)
        case .tonnetzRecorrido:
            return Tonnetz(recorrido: [Acorde("Do"), Acorde("Lam"), Acorde("Fa"), Acorde("Rem")])!.svg()
        case .tablaArmonicaRecorrido:
            return TablaArmonica(caminoDesde: Acorde("Do"), hasta: Acorde("Mi"))!.svg()
        case .tecladoWickiHayden:
            return TecladoIsomorfico.wickiHayden.svg(
                FormasDeMapa.rectangulo(columnas: 8, filas: 5, .filasImpares), marcadas: [60, 64, 67])
        case .tecladoAcordeonC:
            return TecladoIsomorfico.acordeonC.svg(
                FormasDeMapa.rectangulo(columnas: 6, filas: 6, .columnasImpares), marcadas: [50, 53, 57],
                preferirBemoles: true)
        }
    }
}

/// Guarda y compara ficheros de referencia, junto a las pruebas.
enum Referencia {
    static let carpeta = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("Referencias")

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
              guardado: \(antes.prefix(300))
              ahora:    \(ahora.prefix(300))
            Si es lo que se quería: TESELA_REGENERAR_REFERENCIAS=1 swift test --filter ReferenciasSVGTests
            """, sourceLocation: sourceLocation)
    }
}
