import Armonia
import Foundation
import Hexagonos
import XCTest

@testable import ArmoniaPresentacion
@testable import ArmoniaUI

// Los textos de la interfaz de las apps y la notación inicial. No usan SwiftUI: se ejecutan también en Linux.

final class TextosDeAppsTests: XCTestCase {
    /// Una muestra de cada texto.
    static let todos: [@Sendable (Notacion) -> String] = [
        { $0.texto(\.acordes) },
        { $0.texto(\.escalas) },
        { $0.texto(\.analisis) },
        { $0.texto(\.coral) },
        { $0.texto(\.acorde) },
        { $0.campo(.cifrado) },
        { $0.texto(\.informacion) },
        { $0.texto(\.nombre) },
        { $0.texto(\.cifrado) },
        { $0.texto(\.notas) },
        { $0.texto(\.digitaciones) },
        { $0.texto(\.instrumentoYAfinacion) },
        { $0.texto(\.sinDigitaciones) },
        { $0.texto(\.calculando) },
        { $0.texto { $0.dedosYCejilla(1, nil) } },
        { $0.texto { $0.dedosYCejilla(4, 3) } },
        { $0.texto(\.arpegio) },
        { $0.texto(\.patron) },
        { $0.texto(\.escalasCompatibles) },
        { $0.texto(\.arpegioEnElMastil) },
        { $0.texto { $0.trastes(5, 8) } },
        { $0.texto(\.identificar) },
        { $0.texto(\.tocaElMastil) },
        { $0.texto(\.tocaNotas) },
        { $0.texto(\.borrar) },
        { $0.texto(\.sinAcordeConocido) },
        { $0.texto(\.verEnAcordes) },
        { $0.texto(\.tecladoMIDI) },
        { $0.texto(\.dispositivosMIDI) },
        { $0.texto(\.teoriaPostonal) },
        { $0.texto(\.formaPrima) },
        { $0.texto(\.numeroDeForte) },
        { $0.texto(\.vectorIntervalico) },
        { $0.texto(\.escala) },
        { $0.texto(\.tonica) },
        { $0.texto(\.tipo) },
        { $0.texto(\.habituales) },
        { $0.texto(\.otrasTradiciones) },
        { $0.texto(\.acordesDeLaEscala) },
        { $0.texto(\.mastilDeGuitarra) },
        { $0.texto(\.posicionesEnElMastil) },
        { $0.texto { $0.notasPorCuerda(3) } },
        { $0.texto { $0.notasPorCuerda(1) } },
        { $0.texto { $0.forma("E") } },
        { $0.texto(\.pentagrama) },
        { $0.texto(\.progresion) },
        { $0.texto(\.campoDeProgresion) },
        { $0.texto(\.resultado) },
        { $0.texto(\.acordeAAcorde) },
        { $0.texto(\.cadencias) },
        { $0.texto(\.arpegiar) },
        { $0.texto(\.tarea) },
        { $0.texto(\.campoDeTonalidad) },
        { $0.texto(\.tonalidad) },
        { $0.texto(\.armonizaciones) },
        { $0.texto(\.aCuatroVoces) },
        { $0.texto(\.conduccionDeLasVoces) },
        { $0.texto(\.avisos) },
        { $0.texto(\.recorridoPLR) },
        { $0.texto(\.modo) },
        { $0.texto(\.red) },
        { $0.texto(\.formatoUIL) },
        { $0.texto(\.giro) },
        { $0.texto(\.espejo) },
        { $0.texto(\.noSeDibuja) },
        { $0.campo(.triadaInicial) },
        { $0.texto(\.reiniciar) },
        { $0.texto(\.deshacer) },
        { $0.campo(.acorde) },
        { $0.campo(.escala) },
        { $0.texto(\.textos) },
        { $0.texto(\.comoLasNotas) },
        { $0.texto(\.octavaEnSubindice) },
        { $0.texto(\.exportar) },
        { $0.texto(\.abrir) },
        { $0.texto(\.escuchar) },
        { $0.texto(\.afinacionAlEscuchar) },
        { $0.texto(\.rejillaHexagonal) },
        { $0.texto { $0.casillas(1) } },
        { $0.texto { $0.casillas(19) } },
        { $0.texto { $0.casillaElegida(q: 2, r: -1) } },
        { $0.texto { $0.mastilDe("guitarra", 0, 5) } },
        { $0.texto { $0.posicion(1, 3) } },
        { $0.texto { $0.marcas(13) } },
        { $0.texto { $0.cuerdasApagadas("1, 6") } },
        { $0.texto(\.sinMarcas) },
        { $0.texto(\.octavas) },
        { $0.texto(\.conLaOctavaFinal) },
        { $0.texto(\.figura) },
        { $0.texto { $0.capoEnElTraste(0) } },
        { $0.texto { $0.capoEnElTraste(2) } },
        { $0.texto(\.rearmonizar) },
        { $0.texto(\.aplicar) },
        { $0.texto(\.detener) },
        { $0.texto(\.transponer) },
    ]

    func testCadaTextoEstaEnCadaIdioma() {
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            for (i, texto) in Self.todos.enumerated() {
                XCTAssertFalse(texto(notacion).isEmpty, "texto \(i) en \(idioma)")
            }
        }
        XCTAssertEqual(Notacion.inglesASCII.texto(\.digitaciones), "Fingerings")
        XCTAssertEqual(Notacion.euskera.texto(\.acordes), "Akordeak")
        XCTAssertEqual(Notacion.aleman.texto(\.escalas), "Skalen")
        XCTAssertEqual(Notacion.occitano.texto(\.digitaciones), "Digitacions")
        XCTAssertEqual(Notacion.ruso.texto { $0.dedosYCejilla(3, 5) }, "3 пальца, барре на 5-м ладу")
        XCTAssertEqual(Notacion.ruso.texto { $0.marcas(11) }, "11 отметок")
        XCTAssertEqual(Notacion.griego.texto(\.acordes), "Συγχορδίες")
    }

    /// Todos los textos caben en la pila de un hilo secundario de macOS (512 KB), también sin optimizar. Con un
    /// `TextosDeApps.traducidos.map` en cada caso del `switch` del antiguo `TextoDeLasApps`, cada caso guardaba en
    /// la pila su copia de los catorce idiomas y el campo de acorde desbordaba la del hilo principal (señal 11).
    func testLosTextosCabenEnLaPilaDeUnHiloSecundario() {
        let todos = Self.todos
        let hecho = DispatchSemaphore(value: 0)
        let hilo = Thread {
            for idioma in Idioma.allCases {
                let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
                for (i, texto) in todos.enumerated() {
                    XCTAssertFalse(texto(notacion).isEmpty, "texto \(i) en \(idioma)")
                }
            }
            hecho.signal()
        }
        hilo.stackSize = 512 * 1024
        hilo.start()
        XCTAssertEqual(hecho.wait(timeout: .now() + 60), .success)
    }

    func testLosEjemplosVanEnLaNotacion() {
        XCTAssertEqual(Notacion.espanolUnicode.campo(.cifrado), "Cifrado, por ejemplo Sol7/Si")
        XCTAssertEqual(Notacion.inglesASCII.campo(.cifrado), "Chord symbol, for example G7/B")
        XCTAssertEqual(Notacion.inglesASCII.campo(.triadaInicial), "Starting triad (C, Am…)")
        XCTAssertEqual(
            PresentacionDeCoral.Tarea.armonizar.indicacion(en: .inglesASCII),
            "Melody (E4 F4 D4 C4, without octaves or with rhythm: E4:4 D4:8)")
        XCTAssertEqual(
            PresentacionDeCoral.Tarea.revisar.indicacion(en: .espanolUnicode),
            "Voces de grave a agudo (Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4)")
        XCTAssertEqual(PresentacionDeCoral.Tarea.realizar.indicacion(en: .inglesASCII), "Chords (C F G7 C)")
    }

    func testElCapo() {
        XCTAssertEqual(Notacion.espanolUnicode.texto { $0.capoEnElTraste(0) }, "Sin capo")
        XCTAssertEqual(Notacion.espanolUnicode.texto { $0.capoEnElTraste(2) }, "Capo en el traste 2")
        XCTAssertEqual(Notacion.inglesASCII.texto { $0.capoEnElTraste(3) }, "Capo on fret 3")
    }

    func testLosDedosYLaCejilla() {
        XCTAssertEqual(Notacion.espanolUnicode.texto { $0.dedosYCejilla(1, nil) }, "1 dedo")
        XCTAssertEqual(Notacion.espanolUnicode.texto { $0.dedosYCejilla(4, 1) }, "4 dedos, cejilla en el traste 1")
        XCTAssertEqual(Notacion.inglesASCII.texto { $0.dedosYCejilla(3, 5) }, "3 fingers, barre at fret 5")
    }

    func testLasTareasLosFormatosYLasRedesTienenNombreEnCadaIdioma() {
        for idioma in Idioma.allCases {
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
        for idioma in Idioma.allCases {
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
            PresentacionDeMastil.descripcion(marcas: marcas, apagadas: [5], cuerdas: 6, en: .inglesASCII),
            "string 6, fret 0; string 5, fret 3; muted strings: 1")
        XCTAssertEqual(
            PresentacionDeMastil.descripcion(marcas: [], apagadas: [], cuerdas: 6, en: .frances), "Aucune marque")
        XCTAssertEqual(
            PresentacionDeMastil.etiqueta(de: Mastil(.ukelele), rango: 0...5, en: .inglesASCII),
            "Ukulele neck, frets 0 to 5")
        XCTAssertEqual(
            PresentacionDeMastil.etiqueta(de: Mastil(.guitarra), rango: 3...7, en: .espanolUnicode),
            "Mástil de guitarra, trastes 3 a 7")
        XCTAssertEqual(PresentacionDeRejilla.descripcion(casillas: 1, seleccionada: nil, en: .inglesASCII), "1 cell")
        XCTAssertEqual(Notacion.euskera.texto { $0.casillas(19) }, "19 gelaxka")
    }

    /// Las claves con que se guardan los idiomas en los ajustes no cambian: son los nombres de los casos.
    func testLasClavesYLosNombresDeLosIdiomas() {
        XCTAssertEqual(
            Idioma.allCases.map(\.clave),
            [
                "espanol", "ingles", "catalan", "gallego", "asturiano", "aragones", "euskera", "portugues", "frances",
                "occitano", "italiano", "aleman", "griego", "ruso",
            ])
        XCTAssertEqual(
            Idioma.allCases.map(\.titulo),
            [
                "Español", "English", "Català", "Galego", "Asturianu", "Aragonés", "Euskara", "Português", "Français",
                "Occitan", "Italiano", "Deutsch", "Ελληνικά", "Русский",
            ])
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
        XCTAssertEqual(Notacion.espanolUnicode.texto { $0.marcas(1) }, "1 marca")
        XCTAssertEqual(Notacion.euskera.texto { $0.marcas(1) }, "marka 1")
        for notacion in Idioma.allCases.map(Notacion.delIdioma) {
            XCTAssertNotEqual(notacion.texto { $0.marcas(1) }, notacion.texto { $0.marcas(2) }, notacion.clave)
        }
    }

    func testLosEjemplosQueNoSeLeenSeDejanComoVan() {
        XCTAssertEqual(Notacion.inglesASCII.cifradoDeEjemplo("Xyz"), "Xyz")
        XCTAssertEqual(Notacion.inglesASCII.alturasDeEjemplo("Mi4 Xyz, Do4"), "E4 Xyz, C4")
    }
}
