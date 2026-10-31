import Armonia
import Hexagonos
import XCTest

@testable import ArmoniaPresentacion
@testable import ArmoniaUI

// Los textos de la interfaz de las apps y la notación inicial. No usan SwiftUI: se ejecutan también en Linux.

final class TextoDeLasAppsTests: XCTestCase {
    /// Una muestra de cada caso.
    static let todos: [TextoDeLasApps] = [
        .acordes, .escalas, .analisis, .coral, .acorde, .campoDeCifrado, .informacion, .nombre, .cifrado, .notas,
        .digitaciones, .instrumentoYAfinacion, .sinDigitaciones, .calculando, .dedos(1, cejilla: nil),
        .dedos(4, cejilla: 3), .arpegio, .patron, .escalasCompatibles,
        .arpegioEnElMastil, .trastes(desde: 5, hasta: 8), .identificar, .tocaElMastil, .tocaNotas,
        .borrar, .sinAcordeConocido, .verEnAcordes, .tecladoMIDI, .dispositivosMIDI, .teoriaPostonal, .formaPrima,
        .numeroDeForte, .vectorIntervalico, .escala, .tonica, .tipo, .habituales, .otrasTradiciones, .acordesDeLaEscala,
        .mastilDeGuitarra, .pentagrama, .progresion, .campoDeProgresion, .resultado, .acordeAAcorde, .cadencias,
        .arpegiar, .tarea,
        .campoDeTonalidad, .tonalidad, .armonizaciones, .aCuatroVoces, .conduccionDeLasVoces, .avisos,
        .recorridoPLR, .modo, .red, .formatoUIL, .giro, .espejo, .noSeDibuja, .campoDeTriadaInicial, .reiniciar,
        .deshacer, .campoDeAcorde,
        .campoDeEscala, .textos, .comoLasNotas, .exportar, .abrir, .escuchar, .afinacionAlEscuchar, .rejillaHexagonal,
        .casillas(1), .casillas(19),
        .casillaElegida(q: 2, r: -1), .mastilDe("guitarra", desde: 0, hasta: 5), .posicion(cuerda: 1, traste: 3),
        .marcas(13), .cuerdasApagadas("1, 6"), .sinMarcas,
    ]

    func testCadaTextoEstaEnCadaIdioma() {
        for idioma in Idioma.traducidos {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            for texto in Self.todos {
                XCTAssertFalse(notacion.texto(texto).isEmpty, "\(texto) en \(idioma)")
            }
        }
        XCTAssertEqual(Notacion.inglesASCII.texto(.digitaciones), "Fingerings")
        XCTAssertEqual(Notacion.euskera.texto(.acordes), "Akordeak")
        XCTAssertEqual(Notacion.aleman.texto(.escalas), "Skalen")
        XCTAssertEqual(Notacion.occitano.texto(.digitaciones), "Digitacions")
        XCTAssertEqual(Notacion.ruso.texto(.dedos(3, cejilla: 5)), "3 пальца, барре на 5-м ладу")
        XCTAssertEqual(Notacion.ruso.texto(.marcas(11)), "11 отметок")
        XCTAssertEqual(Notacion.griego.texto(.acordes), "Συγχορδίες")
    }

    func testLosEjemplosVanEnLaNotacion() {
        XCTAssertEqual(Notacion.espanolUnicode.texto(.campoDeCifrado), "Cifrado, por ejemplo Sol7/Si")
        XCTAssertEqual(Notacion.inglesASCII.texto(.campoDeCifrado), "Chord symbol, for example G7/B")
        XCTAssertEqual(Notacion.inglesASCII.texto(.campoDeTriadaInicial), "Starting triad (C, Am…)")
        XCTAssertEqual(
            PresentacionDeCoral.Tarea.armonizar.indicacion(en: .inglesASCII),
            "Melody (E4 F4 D4 C4, without octaves or with rhythm: E4:4 D4:8)")
        XCTAssertEqual(
            PresentacionDeCoral.Tarea.revisar.indicacion(en: .espanolUnicode),
            "Voces de grave a agudo (Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4)")
        XCTAssertEqual(PresentacionDeCoral.Tarea.realizar.indicacion(en: .inglesASCII), "Chords (C F G7 C)")
    }

    func testLosDedosYLaCejilla() {
        XCTAssertEqual(Notacion.espanolUnicode.texto(.dedos(1, cejilla: nil)), "1 dedo")
        XCTAssertEqual(Notacion.espanolUnicode.texto(.dedos(4, cejilla: 1)), "4 dedos, cejilla en el traste 1")
        XCTAssertEqual(Notacion.inglesASCII.texto(.dedos(3, cejilla: 5)), "3 fingers, barre at fret 5")
    }

    func testLasTareasLosFormatosYLasRedesTienenNombreEnCadaIdioma() {
        for idioma in Idioma.traducidos {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            let tareas = PresentacionDeCoral.Tarea.allCases.map { $0.titulo(en: notacion) }
            XCTAssertEqual(Set(tareas).count, tareas.count, "\(idioma)")
            let formatos = FicheroParaExportar.Formato.allCases.map { $0.titulo(en: notacion) }
            XCTAssertEqual(Set(formatos).count, formatos.count, "\(idioma)")
            let redes = RedDeNotas.allCases.map { $0.nombre(en: notacion) }
            XCTAssertEqual(Set(redes).count, redes.count, "\(idioma)")
        }
        XCTAssertEqual(RedDeNotas.tablaArmonica.nombre(en: .inglesASCII), "Harmonic table")
    }

    func testLosInstrumentosYLasTransformacionesTienenNombreEnCadaIdioma() {
        for idioma in Idioma.traducidos {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            let instrumentos = Encordado.todos.map { $0.nombre(en: notacion) }
            XCTAssertEqual(Set(instrumentos).count, instrumentos.count, "\(idioma)")
            let transformaciones = TransformacionNeorriemanniana.allCases.map { $0.nombre(en: notacion) }
            XCTAssertEqual(Set(transformaciones).count, transformaciones.count, "\(idioma)")
        }
        // En español, los del motor: es lo que se escribe en `--instrumento`.
        XCTAssertEqual(Encordado.todos.map { $0.nombre(en: .espanolUnicode) }, Encordado.todos.map(\.nombre))
        XCTAssertEqual(Encordado.guitarraDeSieteCuerdas.titulo(en: .inglesASCII), "Seven-string guitar")
        XCTAssertEqual(Encordado.mandolina.nombre(en: .portugues), "bandolim")
        XCTAssertEqual(TransformacionNeorriemanniana.l.nombre(en: .inglesASCII), "leading-tone exchange")
        // Un instrumento propio conserva su nombre.
        let laud = Encordado(nombre: "laúd", cuerdas: Encordado.mandolina.cuerdas)
        XCTAssertEqual(laud.nombre(en: .inglesASCII), "laúd")
    }

    func testLoQueLeeVoiceOverVaEnElIdiomaDeLosTextos() {
        let marcas = [PosicionEnElMastil(cuerda: 1, traste: 3), PosicionEnElMastil(cuerda: 0, traste: 0)]
        XCTAssertEqual(
            PresentacionDeMastil.descripcion(marcas: marcas, apagadas: [5], en: .inglesASCII),
            "string 1, fret 0; string 2, fret 3; muted strings: 6")
        XCTAssertEqual(PresentacionDeMastil.descripcion(marcas: [], apagadas: [], en: .frances), "Aucune marque")
        XCTAssertEqual(
            PresentacionDeMastil.etiqueta(de: Mastil(.ukelele), rango: 0...5, en: .inglesASCII),
            "Ukulele neck, frets 0 to 5")
        XCTAssertEqual(
            PresentacionDeMastil.etiqueta(de: Mastil(.guitarra), rango: 3...7, en: .espanolUnicode),
            "Mástil de guitarra, trastes 3 a 7")
        XCTAssertEqual(PresentacionDeRejilla.descripcion(casillas: 1, seleccionada: nil, en: .inglesASCII), "1 cell")
        XCTAssertEqual(Notacion.euskera.texto(.casillas(19)), "19 gelaxka")
    }

    func testLaNotacionInicialEsLaDelSistema() {
        XCTAssertEqual(Notacion.delSistema(idiomas: ["ca-ES", "es-ES"]), .catalan)
        XCTAssertEqual(Notacion.delSistema(idiomas: ["en-GB"]), .inglesASCII)
        XCTAssertEqual(Notacion.delSistema(idiomas: ["eu"]), .euskera)
        XCTAssertEqual(Notacion.delSistema(idiomas: ["pt_BR"]), .portugues)
        // Un idioma sin notación se salta; si no queda ninguno, el español.
        XCTAssertEqual(Notacion.delSistema(idiomas: ["ja-JP", "fr-CA"]), .frances)
        XCTAssertEqual(Notacion.delSistema(idiomas: ["ja-JP"]), .espanolUnicode)
        XCTAssertEqual(Notacion.delSistema(idiomas: []), .espanolUnicode)
    }

    func testUnaMarca() {
        XCTAssertEqual(Notacion.espanolUnicode.texto(.marcas(1)), "1 marca")
        XCTAssertEqual(Notacion.euskera.texto(.marcas(1)), "marka 1")
        for notacion in Idioma.allCases.map(Notacion.delIdioma) {
            XCTAssertNotEqual(notacion.texto(.marcas(1)), notacion.texto(.marcas(2)), notacion.clave)
        }
    }

    func testLosEjemplosQueNoSeLeenSeDejanComoVan() {
        XCTAssertEqual(TextoDeLasApps.cifrado("Xyz", .inglesASCII), "Xyz")
        XCTAssertEqual(TextoDeLasApps.alturas("Mi4 Xyz, Do4", .inglesASCII), "E4 Xyz, C4")
    }
}
