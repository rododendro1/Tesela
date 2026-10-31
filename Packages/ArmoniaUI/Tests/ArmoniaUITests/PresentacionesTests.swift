import Armonia
import Foundation
import Hexagonos
import XCTest

@testable import ArmoniaPresentacion
@testable import ArmoniaUI

// Las presentaciones de las vistas de análisis, coral y redes, y los ficheros que exportan. No usan
// SwiftUI: se ejecutan también en Linux.

final class FicheroParaExportarTests: XCTestCase {
    func testElNombreLlevaLaExtensionYNoLlevaBarras() {
        XCTAssertEqual(FicheroParaExportar.midi(Data(), nombre: "Sol7/Si").nombreDeFichero, "Sol7-Si.mid")
        XCTAssertEqual(FicheroParaExportar.musicXML("", nombre: "Coral").nombreDeFichero, "Coral.musicxml")
        XCTAssertEqual(FicheroParaExportar.mei("", nombre: "Coral").nombreDeFichero, "Coral.mei")
        XCTAssertEqual(FicheroParaExportar.svg("", nombre: "  ").nombreDeFichero, "Tesela.svg")
        XCTAssertEqual(
            FicheroParaExportar.svg("", nombre: String(repeating: "a", count: 200)).nombreDeFichero.count,
            80 + ".svg".count)
    }

    func testSeEscribeEnLaCarpetaDeExportaciones() throws {
        let carpeta = FileManager.default.temporaryDirectory.appendingPathComponent(
            UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: carpeta) }
        let fichero = FicheroParaExportar.svg("<svg/>", nombre: "Dibujo")
        let url = try fichero.escribir(en: carpeta)
        XCTAssertEqual(url.lastPathComponent, "Dibujo.svg")
        XCTAssertEqual(url.deletingLastPathComponent().lastPathComponent, "Exportaciones")
        XCTAssertEqual(try Data(contentsOf: url), Data("<svg/>".utf8))
        // Escribir otra vez sustituye el fichero.
        try FicheroParaExportar.svg("<svg></svg>", nombre: "Dibujo").escribir(en: carpeta)
        XCTAssertEqual(try Data(contentsOf: url), Data("<svg></svg>".utf8))
    }

    func testCadaFormatoTieneExtensionTituloEIconoDistintos() {
        let formatos = FicheroParaExportar.Formato.allCases
        XCTAssertEqual(Set(formatos.map(\.extensionDeFichero)).count, formatos.count)
        XCTAssertEqual(Set(formatos.map(\.titulo)).count, formatos.count)
        XCTAssertEqual(Set(formatos.map(\.icono)).count, formatos.count)
    }

    func testElIdentificadorEsElNombreDelFichero() {
        let fichero = FicheroParaExportar.musicXML("", nombre: "Coral")
        XCTAssertEqual(fichero.id, fichero.nombreDeFichero)
    }
}

final class PresentacionDeAnalisisTests: XCTestCase {
    func testUnaProgresionSinModulaciones() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Lam Re7 Sol7 Do", notacion: .espanolUnicode)
        XCTAssertEqual(analisis.tramos.count, 1)
        XCTAssertNil(analisis.tramos[0].cabecera)
        XCTAssertEqual(analisis.tramos[0].filas.map(\.cifrado), ["Do", "Lam", "Re7", "Sol7", "Do"])
        XCTAssertEqual(analisis.tramos[0].filas.first?.grado, "I")
        XCTAssertFalse(analisis.cadencias.isEmpty)
    }

    func testLasModulacionesAbrenUnTramo() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Fa Sol7 Do Lam Re7 Sol", notacion: .espanolUnicode)
        XCTAssertEqual(analisis.tramos.count, 2)
        XCTAssertNotNil(analisis.tramos[1].cabecera)
        XCTAssertEqual(analisis.tramos.flatMap(\.filas).count, 7)
    }

    func testLaProgresionArpegiada() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Lam Re7 Sol7 Do", notacion: .espanolUnicode)
        XCTAssertEqual(analisis.acordes, [Acorde("Do"), Acorde("Lam"), Acorde("Re7"), Acorde("Sol7"), Acorde("Do")])
        XCTAssertEqual(analisis.tonalidad, Tonalidad(.do))
        let arpegiada = try XCTUnwrap(analisis.arpegiada(.alberti, notacion: .espanolUnicode))
        // Una blanca por acorde, en corcheas.
        XCTAssertEqual(arpegiada.voz.eventos.count, 20)
        XCTAssertEqual(arpegiada.ficheros.map(\.formato), [.musicXML, .mei, .midi])
        XCTAssertEqual(arpegiada.ficheros[0].nombre, "Progresión arpegiada (bajo de Alberti)")
        XCTAssertEqual(arpegiada.sonido.notas.count, 20)
        // Los ficheros de la progresión y los de la arpegiada no se pisan.
        let nombres = (analisis.ficheros + arpegiada.ficheros).map(\.nombreDeFichero)
        XCTAssertEqual(Set(nombres).count, nombres.count)
        XCTAssertNil(
            PresentacionDeArpegios.progresion([], patron: .ascendente, tonalidad: nil, notacion: .espanolUnicode))
    }

    func testUnArpegioSeExporta() {
        let arpegio = PresentacionDeArpegios.arpegio(
            Arpegio(Acorde("Sol7"), patron: .idaYVuelta), notacion: .espanolUnicode)
        XCTAssertEqual(arpegio.voz.eventos.count, 9)
        XCTAssertEqual(arpegio.ficheros.map(\.formato), [.musicXML, .mei, .midi])
        XCTAssertEqual(arpegio.sonido.notas.first?.altura.midi, 67)
    }

    func testOtrasFigurasYOctavas() throws {
        let semicorcheas = PresentacionDeArpegios.arpegio(
            Arpegio(Acorde("Do"), patron: .quebrado, octavas: 2, conOctava: false), figura: .semicorchea,
            notacion: .espanolUnicode)
        XCTAssertTrue(semicorcheas.voz.eventos.allSatisfy { $0.duracion == .semicorchea })
        // Dos octavas sin la final: seis notas, quebradas de dos en dos (cuatro parejas).
        XCTAssertEqual(semicorcheas.voz.eventos.count, 8)
        let analisis = try PresentacionDeAnalisis.analizar("Do Sol7 Do", notacion: .espanolUnicode)
        let negras = try XCTUnwrap(analisis.arpegiada(.ascendente, figura: .negra, notacion: .espanolUnicode))
        // Una blanca por acorde: dos negras cada uno.
        XCTAssertEqual(negras.voz.eventos.count, 6)
        XCTAssertTrue(negras.voz.eventos.allSatisfy { $0.duracion == .negra })
    }

    func testLosFicherosDelArpegioSeLeenConLasMismasNotas() throws {
        let arpegio = PresentacionDeArpegios.arpegio(
            Arpegio(Acorde("Fa#m7"), patron: .alberti), notacion: .espanolUnicode)
        let sonido = arpegio.sonido.notas
        for fichero in arpegio.ficheros where fichero.formato != .mei {
            let pieza = try PiezaImportada(leyendo: fichero.datos)
            XCTAssertEqual(pieza.notas.map(\.altura.midi), sonido.map(\.midi), "\(fichero.formato)")
            XCTAssertEqual(Set(pieza.notas.map(\.duracion)), [.corchea], "\(fichero.formato)")
        }
        // MusicXML guarda el título y la ortografía: Fa♯ y Do♯, no Sol♭ y Re♭.
        let xml = try PiezaImportada(musicXML: arpegio.ficheros[0].datos)
        XCTAssertEqual(xml.titulo, arpegio.ficheros[0].nombre)
        XCTAssertEqual(xml.notas.map(\.altura.nombre), sonido.map(\.altura.nombre))
    }

    func testLaProgresionArpegiadaLlevaLaArmaduraYSusAcordes() throws {
        let acordes = [Acorde("Re"), Acorde("Sol"), Acorde("La7"), Acorde("Re")]
        let arpegiada = try XCTUnwrap(
            PresentacionDeArpegios.progresion(
                acordes, patron: .ascendente,
                tonalidad: Tonalidad(.re),
                notacion: .inglesASCII))
        let patron = Arpegio.Patron.ascendente.nombre(en: .inglesASCII)
        XCTAssertEqual(arpegiada.ficheros[0].nombre, "Progresión arpegiada (\(patron))")
        for fichero in arpegiada.ficheros where fichero.formato != .mei {
            let pieza = try PiezaImportada(leyendo: fichero.datos)
            XCTAssertEqual(pieza.tonalidad, Tonalidad(.re), "\(fichero.formato)")
            // Cada acorde dura una blanca: leída de blanca en blanca, la pieza da la progresión.
            XCTAssertEqual(pieza.duracion, Duracion(2), "\(fichero.formato)")
            XCTAssertEqual(pieza.acordes(ventana: .blanca).map(\.cifrado), acordes.map(\.cifrado), "\(fichero.formato)")
        }
    }

    func testConLosAcordesYaLeidosSaleLoMismo() throws {
        let texto = "Do Fa Sol7 Do Lam Re7 Sol"
        let acordes = try texto.split(separator: " ").map { try Acorde(leyendo: String($0)) }
        let leido = try PresentacionDeAnalisis.analizar(texto, notacion: .espanolUnicode)
        XCTAssertEqual(PresentacionDeAnalisis.analizar(acordes, notacion: .espanolUnicode), leido)
        let enDo = try PresentacionDeAnalisis.analizar(texto, en: Tonalidad(.do), notacion: .espanolUnicode)
        XCTAssertEqual(PresentacionDeAnalisis.analizar(acordes, en: Tonalidad(.do), notacion: .espanolUnicode), enDo)
        XCTAssertNil(PresentacionDeAnalisis.analizar([], notacion: .espanolUnicode))
    }

    func testExportaPartiturasYMIDI() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Fa Sol7 Do", notacion: .espanolUnicode)
        XCTAssertEqual(analisis.ficheros.map(\.formato), [.musicXML, .mei, .midi])
        XCTAssertTrue(String(decoding: analisis.ficheros[0].datos, as: UTF8.self).contains("score-partwise"))
        XCTAssertTrue(String(decoding: analisis.ficheros[1].datos, as: UTF8.self).contains("<mei "))
        XCTAssertEqual(analisis.ficheros[2].datos.prefix(4), Data("MThd".utf8))
    }

    func testLaNotacionSeUsaEnLosCifrados() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Sol7 Do", notacion: .inglesASCII)
        XCTAssertEqual(analisis.tramos[0].filas.map(\.cifrado), ["C", "G7", "C"])
    }

    func testUnTextoQueNoSeLeeEsUnError() {
        XCTAssertThrowsError(try PresentacionDeAnalisis.analizar("Do Xyz", notacion: .espanolUnicode))
    }

    func testConUnaTonalidadDadaNoModula() throws {
        let analisis = try PresentacionDeAnalisis.analizar(
            "Do Fa Sol7 Do Lam Re7 Sol", en: Tonalidad(leyendo: "Do mayor"),
            notacion: .espanolUnicode)
        XCTAssertEqual(analisis.tramos.count, 1)
        XCTAssertTrue(analisis.titulo.hasSuffix("Do mayor"), analisis.titulo)
        XCTAssertEqual(analisis.tramos[0].filas.count, 7)
        XCTAssertEqual(analisis.ficheros.count, 3)
    }

    func testUnAcordeSinFuncionLaDejaEnBlanco() throws {
        let acordes = try ["Do", "Fa#+", "Sol7"].map { try Acorde(leyendo: $0) }
        let analisis = try XCTUnwrap(PresentacionDeAnalisis.analizar(acordes, notacion: .espanolUnicode))
        XCTAssertEqual(analisis.tramos.flatMap(\.filas).map(\.funcion), ["tónica", "", "dominante"])
    }
}

final class PresentacionDeCoralTests: XCTestCase {
    func testArmonizarConOctavasDaElCoral() throws {
        let coral = try PresentacionDeCoral.presentar(.armonizar, "Mi4 Fa4 Re4 Do4", notacion: .espanolUnicode)
        XCTAssertEqual(coral.titulo, "Do mayor")
        XCTAssertEqual(coral.propuestas.first, "Do Fa Sol Do (I–IV–V–I)")
        XCTAssertEqual(coral.filas.map(\.grado), ["I", "IV", "V", "I"])
        XCTAssertEqual(coral.filas.first?.voces, "Do3 Sol3 Do4 Mi4")
        XCTAssertTrue(coral.avisos.isEmpty, "\(coral.avisos)")
        XCTAssertEqual(coral.ficheros.map(\.formato), [.musicXML, .mei, .midi])
    }

    func testArmonizarSinOctavasNoDaCoral() throws {
        let coral = try PresentacionDeCoral.presentar(.armonizar, "Mi Re Do", propuestas: 1, notacion: .espanolUnicode)
        XCTAssertEqual(coral.propuestas, ["Do Sol Do (I–V–I)"])
        XCTAssertTrue(coral.filas.isEmpty)
        XCTAssertTrue(coral.ficheros.isEmpty)
        XCTAssertEqual(coral.avisos, [.faltanOctavas])
        XCTAssertEqual(
            coral.avisos[0].texto(en: .espanolUnicode),
            "Escribe las notas con su octava (Mi4 Re4 Do4) para verlas a cuatro voces.")
        XCTAssertEqual(
            coral.avisos[0].texto(en: .inglesASCII),
            "Write the notes with their octave (E4 D4 C4) to see them in four parts.")
    }

    func testLaTonalidadDadaManda() throws {
        let coral = try PresentacionDeCoral.presentar(
            .armonizar, "Do Si La Sol# La", tonalidad: "La menor",
            notacion: .espanolUnicode)
        XCTAssertEqual(coral.titulo, "La menor")
        XCTAssertThrowsError(
            try PresentacionDeCoral.presentar(.armonizar, "Do", tonalidad: "Xyz", notacion: .espanolUnicode))
    }

    func testRealizarEscribeCuatroVocesSinFaltas() throws {
        let coral = try PresentacionDeCoral.presentar(.realizar, "Do Fa Sol7 Do", notacion: .espanolUnicode)
        XCTAssertEqual(coral.filas.map(\.cifrado), ["Do", "Fa", "Sol7", "Do"])
        XCTAssertTrue(coral.filas.allSatisfy { $0.voces.split(separator: " ").count == 4 })
        XCTAssertTrue(coral.avisos.isEmpty, "\(coral.avisos)")
        XCTAssertEqual(coral.ficheros.count, 3)
    }

    func testRevisarEncuentraLasParalelas() throws {
        let coral = try PresentacionDeCoral.presentar(
            .revisar, "Do3 Sol3 Mi4 Do5, Re3 La3 Fa4 Re5", notacion: .espanolUnicode)
        XCTAssertEqual(coral.filas.map(\.voces), ["Do3 Sol3 Mi4 Do5", "Re3 La3 Fa4 Re5"])
        XCTAssertEqual(coral.filas.map(\.cifrado), ["Do", "Rem"])
        XCTAssertFalse(coral.avisos.isEmpty)
        XCTAssertFalse(coral.avisos.contains(.sinFaltasDeConduccion))
        XCTAssertTrue(coral.avisos.allSatisfy { !$0.texto(en: .espanolUnicode).isEmpty })
    }

    func testRevisarUnBuenEnlace() throws {
        let coral = try PresentacionDeCoral.presentar(
            .revisar, "Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4", notacion: .espanolUnicode)
        XCTAssertEqual(coral.avisos, [.sinFaltasDeConduccion])
        XCTAssertEqual(coral.avisos[0].texto(en: .espanolUnicode), "Sin faltas de conducción.")
        XCTAssertEqual(coral.avisos[0].texto(en: .euskera), "Ez dago ahots-eramate akatsik.")
    }

    func testUnTextoVacioEsUnError() {
        for tarea in PresentacionDeCoral.Tarea.allCases {
            XCTAssertThrowsError(try PresentacionDeCoral.presentar(tarea, "  ", notacion: .espanolUnicode), "\(tarea)")
        }
    }

    func testLosEjemplosFuncionan() throws {
        for tarea in PresentacionDeCoral.Tarea.allCases {
            XCTAssertNoThrow(
                try PresentacionDeCoral.presentar(tarea, tarea.ejemplo, notacion: .espanolUnicode), "\(tarea)")
        }
    }

    func testLasTareas() {
        XCTAssertEqual(PresentacionDeCoral.Tarea.allCases.map(\.id), PresentacionDeCoral.Tarea.allCases)
        XCTAssertEqual(PresentacionDeCoral.Tarea.allCases.map(\.usaTonalidad), [true, true, false])
        for tarea in PresentacionDeCoral.Tarea.allCases {
            // La indicación lleva el ejemplo, o al menos su primera palabra.
            XCTAssertTrue(tarea.indicacion.contains(tarea.ejemplo.split(separator: " ")[0]), "\(tarea)")
        }
    }

    func testLosAvisosDeLoQueNoSeArmonizaNiSeRealiza() throws {
        // Notas que no son de Do mayor: no hay armonización ni coral.
        let fuera = try PresentacionDeCoral.armonizar(
            "Do#4 Re#4 Fa4 Sol#4", en: Tonalidad(.do, .mayor), notacion: .espanolUnicode)
        XCTAssertEqual(fuera.avisos, [.sinArmonizacion, .sinCoralParaLaMelodia])
        XCTAssertEqual(fuera.propuestas, [])
        XCTAssertEqual(fuera.sonido, .silencio)
        // Una melodía que no cabe en las voces se armoniza, pero sin coral.
        XCTAssertEqual(
            try PresentacionDeCoral.armonizar("Do1 Do8", en: nil, notacion: .espanolUnicode).avisos,
            [.sinCoralParaLaMelodia])
        let sinRealizacion = try PresentacionDeCoral.realizar("Do7(b9,#9,#11,b13)", en: nil, notacion: .espanolUnicode)
        XCTAssertEqual(sinRealizacion.avisos, [.sinRealizacion])
        XCTAssertEqual(sinRealizacion.filas, [])
        XCTAssertEqual(sinRealizacion.sonido, .silencio)
    }

    func testUnaMelodiaConRitmo() throws {
        // En un acorde se armoniza la nota más aguda; una voz con solo silencios es un texto vacío.
        let coral = try PresentacionDeCoral.armonizar("Do4+Mi4:4 Re4:4 Do4:2", en: nil, notacion: .espanolUnicode)
        XCTAssertEqual(coral.avisos, [])
        XCTAssertFalse(coral.propuestas.isEmpty)
        XCTAssertThrowsError(try PresentacionDeCoral.armonizar("-:4 -:4", en: nil, notacion: .espanolUnicode))
    }
}

final class PresentacionDeRedesTests: XCTestCase {
    func testCadaRedDibujaCadaContenido() throws {
        let contenidos: [ContenidoDeRed] = [
            .acorde(try Acorde(leyendo: "Dom7")),
            .escala(try Escala(leyendo: "Re dórico")),
            .recorrido([try Acorde(leyendo: "Do"), try Acorde(leyendo: "Lam"), try Acorde(leyendo: "Fa")]),
            .recorrido([try Acorde(leyendo: "Do")]),
        ]
        for red in RedDeNotas.allCases {
            for contenido in contenidos {
                let svg = try XCTUnwrap(
                    PresentacionDeRedes.svg(contenido, en: red, notacion: .espanolUnicode), "\(red)")
                XCTAssertTrue(svg.contains("<svg"), "\(red) \(contenido)")
            }
        }
    }

    func testUnRecorridoVacioNoSeDibuja() {
        XCTAssertNil(PresentacionDeRedes.svg(.recorrido([]), en: .tonnetz, notacion: .espanolUnicode))
    }

    func testLosTecladosMarcanLasNotasEnTodasLasOctavas() throws {
        let svg = try XCTUnwrap(
            PresentacionDeRedes.svg(
                .acorde(try Acorde(leyendo: "Do")), en: .wickiHayden,
                notacion: .espanolUnicode))
        XCTAssertTrue(svg.contains(">Do4<"))
        XCTAssertTrue(svg.contains(">Do5<"))
        XCTAssertEqual(PresentacionDeRedes.casillasDelTeclado.count, 12 * 7)
        XCTAssertTrue(PresentacionDeRedes.casillasDelTeclado.contains(.origen))
        // También los de hexágonos planos, con el Do4 dentro y ninguna casilla repetida.
        XCTAssertEqual(PresentacionDeRedes.casillasDelTecladoPlano.count, 12 * 7)
        XCTAssertTrue(PresentacionDeRedes.casillasDelTecladoPlano.contains(.origen))
        XCTAssertEqual(Set(PresentacionDeRedes.casillasDelTecladoPlano).count, 12 * 7)
        XCTAssertEqual(PresentacionDeRedes.casillasDelTeclado(.acordeonC), PresentacionDeRedes.casillasDelTecladoPlano)
        XCTAssertEqual(PresentacionDeRedes.casillasDelTeclado(.janko), PresentacionDeRedes.casillasDelTeclado)
        XCTAssertEqual(PresentacionDeRedes.casillasDelTeclado(.gerhard), PresentacionDeRedes.casillasDelTecladoPlano)
        XCTAssertEqual(PresentacionDeRedes.casillasDelTeclado(.park), PresentacionDeRedes.casillasDelTeclado)
        XCTAssertEqual(RedDeNotas.gerhard.teclado, .gerhard)
        XCTAssertEqual(RedDeNotas.park.teclado, .park)
    }

    func testLasNotasNoSeRepiten() throws {
        let recorrido = ContenidoDeRed.recorrido([try Acorde(leyendo: "Do"), try Acorde(leyendo: "Lam")])
        XCTAssertEqual(recorrido.notas.count, 4)
    }

    func testElNombreDiceLaRedYElContenido() throws {
        let acorde = try Acorde(leyendo: "Dom7")
        XCTAssertEqual(
            PresentacionDeRedes.nombre(.acorde(acorde), en: .tablaArmonica, notacion: .espanolUnicode),
            "Tabla armónica · " + acorde.cifrado(en: .espanolUnicode))
    }

    func testElNombreDelFicheroDeCadaContenido() throws {
        XCTAssertEqual(RedDeNotas.allCases.map(\.id), RedDeNotas.allCases)
        let n = Notacion.espanolUnicode
        XCTAssertEqual(
            PresentacionDeRedes.nombre(.escala(try Escala(leyendo: "Re dórico")), en: .tonnetz, notacion: n),
            "Tonnetz · Re dórico")
        XCTAssertEqual(
            PresentacionDeRedes.nombre(
                .recorrido([try Acorde(leyendo: "Do"), try Acorde(leyendo: "Lam")]),
                en: .tonnetz, notacion: n), "Tonnetz · Do Lam")
        XCTAssertEqual(PresentacionDeRedes.nombre(.clases([0, 4, 7]), en: .tonnetz, notacion: n), "Tonnetz · Do")
        // Sin acorde para las clases, sus notas; sin teclado UIL, solo «UIL».
        XCTAssertEqual(PresentacionDeRedes.nombre(.clases([]), en: .tonnetz, notacion: n), "Tonnetz · ")
        XCTAssertEqual(
            PresentacionDeRedes.nombre(.clases([0, 4, 7]), en: .uil, notacion: n, uil: AjusteUIL(texto: "")),
            "UIL  · Do")
        XCTAssertNil(PresentacionDeRedes.svg(.recorrido([]), en: .tablaArmonica, notacion: n))
    }
}
