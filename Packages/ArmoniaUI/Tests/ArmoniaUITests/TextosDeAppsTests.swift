import Armonia
import Foundation
import Hexagonos
import Testing

@testable import ArmoniaPresentacion
@testable import ArmoniaUI

// Los textos de la interfaz de las apps y la notación inicial. No usan SwiftUI: se ejecutan también en Linux.

@Suite struct TextosDeAppsTests {
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

    @Test func cadaTextoEstaEnCadaIdioma() {
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            for (i, texto) in Self.todos.enumerated() {
                #expect(!(texto(notacion).isEmpty), "texto \(i) en \(idioma)")
            }
        }
        #expect(Notacion.inglesASCII.texto(\.digitaciones) == "Fingerings")
        #expect(Notacion.euskera.texto(\.acordes) == "Akordeak")
        #expect(Notacion.aleman.texto(\.escalas) == "Skalen")
        #expect(Notacion.occitano.texto(\.digitaciones) == "Digitacions")
        #expect(Notacion.ruso.texto { $0.dedosYCejilla(3, 5) } == "3 пальца, барре на 5-м ладу")
        #expect(Notacion.ruso.texto { $0.marcas(11) } == "11 отметок")
        #expect(Notacion.griego.texto(\.acordes) == "Συγχορδίες")
    }

    /// Todos los textos caben en la pila de un hilo secundario de macOS (512 KB), también sin optimizar. Con un
    /// `TextosDeApps.traducidos.map` en cada caso del `switch` del antiguo `TextoDeLasApps`, cada caso guardaba en
    /// la pila su copia de los catorce idiomas y el campo de acorde desbordaba la del hilo principal (señal 11).
    @Test func losTextosCabenEnLaPilaDeUnHiloSecundario() {
        let todos = Self.todos
        let hecho = DispatchSemaphore(value: 0)
        let hilo = Thread {
            for idioma in Idioma.allCases {
                let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
                for (i, texto) in todos.enumerated() {
                    #expect(!(texto(notacion).isEmpty), "texto \(i) en \(idioma)")
                }
            }
            hecho.signal()
        }
        hilo.stackSize = 512 * 1024
        hilo.start()
        #expect(hecho.wait(timeout: .now() + 60) == .success)
    }

    @Test func losEjemplosVanEnLaNotacion() {
        #expect(Notacion.espanolCompacto.campo(.cifrado) == "Cifrado, por ejemplo Sol7/Si")
        #expect(Notacion.inglesASCII.campo(.cifrado) == "Chord symbol, for example G7/B")
        #expect(Notacion.inglesASCII.campo(.triadaInicial) == "Starting triad (C, Am…)")
        #expect(
            PresentacionDeCoral.Tarea.armonizar.indicacion(en: .inglesASCII)
                == "Melody (E4 F4 D4 C4, without octaves or with rhythm: E4:4 D4:8)")
        #expect(
            PresentacionDeCoral.Tarea.revisar.indicacion(en: .espanolCompacto)
                == "Voces de grave a agudo (Do₃ Mi₄ Sol₄ Do₅, Sol₂ Re₄ Sol₄ Si₄)")
        #expect(PresentacionDeCoral.Tarea.realizar.indicacion(en: .inglesASCII) == "Chords (C F G7 C)")
    }

    @Test func elCapo() {
        #expect(Notacion.espanolCompacto.texto { $0.capoEnElTraste(0) } == "Sin capo")
        #expect(Notacion.espanolCompacto.texto { $0.capoEnElTraste(2) } == "Capo en el traste 2")
        #expect(Notacion.inglesASCII.texto { $0.capoEnElTraste(3) } == "Capo on fret 3")
    }

    @Test func losDedosYLaCejilla() {
        #expect(Notacion.espanolCompacto.texto { $0.dedosYCejilla(1, nil) } == "1 dedo")
        #expect(Notacion.espanolCompacto.texto { $0.dedosYCejilla(4, 1) } == "4 dedos, cejilla en el traste 1")
        #expect(Notacion.inglesASCII.texto { $0.dedosYCejilla(3, 5) } == "3 fingers, barre at fret 5")
    }

    @Test func lasTareasLosFormatosYLasRedesTienenNombreEnCadaIdioma() {
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            let tareas = PresentacionDeCoral.Tarea.allCases.map { $0.titulo(en: notacion) }
            #expect(Set(tareas).count == tareas.count, "\(idioma)")
            let formatos = FicheroParaExportar.Formato.allCases.map { $0.titulo(en: notacion) }
            #expect(Set(formatos).count == formatos.count, "\(idioma)")
            let redes = RedDeNotas.allCases.map { $0.nombre(en: notacion) }
            #expect(Set(redes).count == redes.count, "\(idioma)")
        }
        #expect(RedDeNotas.tablaArmonica.nombre(en: .inglesASCII) == "Harmonic table")
    }

    @Test func losInstrumentosYLasTransformacionesTienenNombreEnCadaIdioma() {
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            let instrumentos = Encordado.todos.map { $0.nombre(en: notacion) }
            #expect(Set(instrumentos).count == instrumentos.count, "\(idioma)")
            let transformaciones = TransformacionNeorriemanniana.allCases.map { $0.nombre(en: notacion) }
            #expect(Set(transformaciones).count == transformaciones.count, "\(idioma)")
        }
        // En español, los del motor: es lo que se escribe en `--instrumento`.
        #expect(Encordado.todos.map { $0.nombre(en: .espanolCompacto) } == Encordado.todos.map(\.nombre))
        #expect(Encordado.guitarraDeSieteCuerdas.titulo(en: .inglesASCII) == "Seven-string guitar")
        #expect(Encordado.mandolina.nombre(en: .portugues) == "bandolim")
        #expect(TransformacionNeorriemanniana.l.nombre(en: .inglesASCII) == "leading-tone exchange")
        // Un instrumento propio conserva su nombre.
        let laud = Encordado(nombre: "laúd", cuerdas: Encordado.mandolina.cuerdas)
        #expect(laud.nombre(en: .inglesASCII) == "laúd")
    }

    @Test func loQueLeeVoiceOverVaEnElIdiomaDeLosTextos() {
        let marcas = [PosicionEnElMastil(cuerda: 1, traste: 3), PosicionEnElMastil(cuerda: 0, traste: 0)]
        #expect(
            PresentacionDeMastil.descripcion(marcas: marcas, apagadas: [5], cuerdas: 6, en: .inglesASCII)
                == "string 6, fret 0; string 5, fret 3; muted strings: 1")
        #expect(PresentacionDeMastil.descripcion(marcas: [], apagadas: [], cuerdas: 6, en: .frances) == "Aucune marque")
        #expect(
            PresentacionDeMastil.etiqueta(de: Mastil(.ukelele), rango: 0...5, en: .inglesASCII)
                == "Ukulele neck, frets 0 to 5")
        #expect(
            PresentacionDeMastil.etiqueta(de: Mastil(.guitarra), rango: 3...7, en: .espanolCompacto)
                == "Mástil de guitarra, trastes 3 a 7")
        #expect(PresentacionDeRejilla.descripcion(casillas: 1, seleccionada: nil, en: .inglesASCII) == "1 cell")
        #expect(Notacion.euskera.texto { $0.casillas(19) } == "19 gelaxka")
    }

    /// Las claves con que se guardan los idiomas en los ajustes no cambian: son los nombres de los casos.
    @Test func lasClavesYLosNombresDeLosIdiomas() {
        #expect(
            Idioma.allCases.map(\.clave) == [
                "espanol", "ingles", "catalan", "gallego", "asturiano", "aragones", "euskera", "portugues", "frances",
                "occitano", "italiano", "aleman", "griego", "ruso",
            ])
        #expect(
            Idioma.allCases.map(\.titulo) == [
                "Español", "English", "Català", "Galego", "Asturianu", "Aragonés", "Euskara", "Português", "Français",
                "Occitan", "Italiano", "Deutsch", "Ελληνικά", "Русский",
            ])
    }

    @Test func laNotacionInicialEsLaDelSistema() {
        #expect(Notacion.delSistema(idiomas: ["ca-ES", "es-ES"]) == .catalan)
        #expect(Notacion.delSistema(idiomas: ["en-GB"]) == .inglesASCII)
        #expect(Notacion.delSistema(idiomas: ["eu"]) == .euskera)
        #expect(Notacion.delSistema(idiomas: ["pt_BR"]) == .portugues)
        // Un idioma sin notación se salta; si no queda ninguno, el español.
        #expect(Notacion.delSistema(idiomas: ["ja-JP", "fr-CA"]) == .frances)
        #expect(Notacion.delSistema(idiomas: ["ja-JP"]) == .espanolCompacto)
        #expect(Notacion.delSistema(idiomas: []) == .espanolCompacto)
    }

    @Test func unaMarca() {
        #expect(Notacion.espanolCompacto.texto { $0.marcas(1) } == "1 marca")
        #expect(Notacion.euskera.texto { $0.marcas(1) } == "marka 1")
        for notacion in Idioma.allCases.map(Notacion.delIdioma) {
            #expect(
                notacion.texto { $0.marcas(1) } != notacion.texto { $0.marcas(2) }, Comment(rawValue: notacion.clave))
        }
    }

    @Test func losEjemplosQueNoSeLeenSeDejanComoVan() {
        #expect(Notacion.inglesASCII.cifradoDeEjemplo("Xyz") == "Xyz")
        #expect(Notacion.inglesASCII.alturasDeEjemplo("Mi4 Xyz, Do4") == "E4 Xyz, C4")
    }
}
