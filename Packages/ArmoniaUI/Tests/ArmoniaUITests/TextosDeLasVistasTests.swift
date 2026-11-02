import Armonia
import Foundation
import Testing

@testable import ArmoniaPresentacion
@testable import ArmoniaUI

// Los textos de las vistas (las redes, el mástil y la rejilla), los nombres de los idiomas en los ajustes y la
// notación inicial. No usan SwiftUI: se ejecutan también en Linux.

@Suite struct TextosDeLasVistasTests {
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

    @Test func loQueLeeVoiceOverVaEnElIdiomaDeLosTextos() {
        let marcas = [PosicionEnElMastil(cuerda: 1, traste: 3), PosicionEnElMastil(cuerda: 0, traste: 0)]
        #expect(
            PresentacionDeMastil.descripcion(marcas: marcas, apagadas: [5], cuerdas: 6, en: .inglesASCII)
                == "string 6, fret 0; string 5, fret 3; muted strings: 1")
        #expect(
            PresentacionDeMastil.descripcion(marcas: [], apagadas: [], cuerdas: 6, en: .francesPalabras)
                == "Aucune marque")
        #expect(
            PresentacionDeMastil.etiqueta(de: Mastil(.ukelele), rango: 0...5, en: .inglesASCII)
                == "Ukulele neck, frets 0 to 5")
        #expect(
            PresentacionDeMastil.etiqueta(de: Mastil(.guitarra), rango: 3...7, en: .espanolCompacto)
                == "Mástil de guitarra, trastes 3 a 7")
        #expect(PresentacionDeRejilla.descripcion(casillas: 1, seleccionada: nil, en: .inglesASCII) == "1 cell")
        #expect(Notacion.euskeraPalabras.texto { $0.casillas(19) } == "19 gelaxka")
    }

    /// Las claves con que se guardan los idiomas en los ajustes no cambian: son los nombres de los casos.
    @Test func lasClavesYLosNombresDeLosIdiomas() {
        #expect(
            Idioma.allCases.map(\.clave) == [
                "espanol", "ingles", "catalan", "gallego", "asturiano", "aragones", "euskera", "portugues", "frances",
                "occitano", "italiano", "aleman", "griego", "ruso", "hungaro",
            ])
        #expect(
            Idioma.allCases.map(\.titulo) == [
                "Español", "English", "Català", "Galego", "Asturianu", "Aragonés", "Euskara", "Português", "Français",
                "Occitan", "Italiano", "Deutsch", "Ελληνικά", "Русский", "Magyar",
            ])
    }

    @Test func laNotacionInicialEsLaDelSistema() {
        #expect(Notacion.delSistema(idiomas: ["ca-ES", "es-ES"]) == .catalanPalabras)
        #expect(Notacion.delSistema(idiomas: ["en-GB"]) == .inglesASCII)
        #expect(Notacion.delSistema(idiomas: ["eu"]) == .euskeraPalabras)
        #expect(Notacion.delSistema(idiomas: ["pt_BR"]) == .portuguesPalabras)
        // Un idioma sin notación se salta; si no queda ninguno, el español.
        #expect(Notacion.delSistema(idiomas: ["ja-JP", "fr-CA"]) == .francesPalabras)
        #expect(Notacion.delSistema(idiomas: ["ja-JP"]) == .espanolCompacto)
        #expect(Notacion.delSistema(idiomas: []) == .espanolCompacto)
    }

    @Test func unaMarca() {
        #expect(Notacion.espanolCompacto.texto { $0.marcas(1) } == "1 marca")
        #expect(Notacion.euskeraPalabras.texto { $0.marcas(1) } == "marka 1")
        for notacion in Idioma.allCases.map(Notacion.delIdioma) {
            #expect(
                notacion.texto { $0.marcas(1) } != notacion.texto { $0.marcas(2) }, Comment(rawValue: notacion.clave))
        }
    }
}
