import Armonia
import Foundation
import Testing

@testable import ArmoniaPresentacion

@Suite struct PresentacionDePentagramaTests {
    @Test func laEscalaDaSuDibujoYSuFichero() {
        let pentagrama = PentagramaPresentado(Escala("Re dórico"))
        #expect(pentagrama.svg.hasPrefix("<svg"))
        #expect(pentagrama.fichero.formato == .svg)
        #expect(pentagrama.fichero.nombreDeFichero == "Pentagrama Re dórico.svg")
        #expect(String(decoding: pentagrama.fichero.datos, as: UTF8.self) == pentagrama.svg)
        #expect(pentagrama.descripcion.hasPrefix("Re dórico: Re4, Mi4"))
    }

    @Test func elAcordeLlevaElCifradoYLasNotasSolasSiSePide() {
        let pentagrama = PentagramaPresentado(Acorde("Sol7"))
        #expect(pentagrama.svg.contains(">Sol7</text>"))
        #expect(pentagrama.descripcion == "Sol7: Sol, Si, Re, Fa")
        #expect(!pentagrama.svg.contains("Sol4 Si4"))
        #expect(PentagramaPresentado(Acorde("Sol7"), nombresDeLasNotas: true).svg.contains("Sol4 Si4"))
    }

    @Test func laNotacionSeSigue() {
        let pentagrama = PentagramaPresentado(Escala("Do mayor"), notacion: .inglesASCII)
        #expect(pentagrama.svg.contains("<title>C4</title>"))
    }

    @Test func laRelacionDeAspecto() {
        #expect(PentagramaPresentado.relacionDeAspecto(deSVG: #"<svg viewBox="0 -3 20 10">"#) == 2)
        #expect(PentagramaPresentado.relacionDeAspecto(deSVG: "<svg>") == 4)
        #expect(PentagramaPresentado.relacionDeAspecto(deSVG: #"<svg viewBox="0 0 0 0">"#) == 4)
        let medida = PentagramaPresentado(Escala("Do mayor")).relacionDeAspecto
        #expect(medida > 1)
    }

    @Test func elArpegioVaNotaANota() {
        let pentagrama = PentagramaPresentado(Arpegio(Acorde("Do"), patron: .alberti))
        #expect(pentagrama.descripcion.hasSuffix(": Do4, Sol4, Mi4, Sol4"), Comment(rawValue: pentagrama.descripcion))
        #expect(pentagrama.fichero.nombreDeFichero.hasPrefix("Pentagrama Arpegio de Do"))
        #expect(pentagrama.svg.hasPrefix("<svg"))
    }

    @Test func laNotaQueSuenaSeResalta() {
        let arpegio = Arpegio(Acorde("Do"))
        let normal = PentagramaPresentado(arpegio)
        #expect(!normal.svg.contains("#E8590C"))
        let resaltada = PentagramaPresentado(arpegio, resaltada: 2)
        // Solo la tercera nota (Sol4) cambia de color.
        #expect((resaltada.svg.components(separatedBy: "<g fill=\"#E8590C\"><title>").count - 1) == 1)
        #expect(resaltada.svg.contains("<g fill=\"#E8590C\"><title>Sol4</title>"))
        #expect(PentagramaPresentado(Escala("Do mayor"), resaltada: 0).svg.contains("<title>Do4") == true)
    }

    @Test func unViewBoxSinCerrar() {
        #expect(PentagramaPresentado.relacionDeAspecto(deSVG: #"<svg viewBox="0 -3 20 10"#) == 4)
    }
}

@Suite struct PresentacionDePentagramaMasTests {
    @Test func elAcordeConBajoEmpiezaPorElBajoYElFicheroNoLlevaBarras() {
        let pentagrama = PentagramaPresentado(Acorde("Sol7/Si"))
        #expect(pentagrama.descripcion == "Sol7/Si: Si, Re, Fa, Sol")
        #expect(pentagrama.fichero.nombreDeFichero == "Pentagrama Sol7-Si.svg")
    }

    @Test func laOctavaCambiaLasAlturas() {
        #expect(PentagramaPresentado(Escala("Re dórico"), octava: 3).descripcion.hasPrefix("Re dórico: Re3, Mi3"))
        #expect(
            PentagramaPresentado(Escala("Re dórico"), octava: 3).svg != PentagramaPresentado(Escala("Re dórico")).svg)
    }

    @Test func elSentidoCambiaElDibujo() {
        let subida = PentagramaPresentado(Escala("Do mayor"), sentido: .ascendente)
        let bajada = PentagramaPresentado(Escala("Do mayor"), sentido: .descendente)
        #expect(subida.svg != bajada.svg)
        // La descripción dice las notas de la escala, no el orden del dibujo.
        #expect(subida.descripcion == bajada.descripcion)
    }

    @Test func laNotacionSeSigueTambienEnElAcorde() {
        let pentagrama = PentagramaPresentado(Acorde("Sol7"), notacion: .inglesASCII)
        #expect(pentagrama.descripcion == "G7: G, B, D, F")
        #expect(pentagrama.svg.contains(">G7</text>"))
        #expect(pentagrama.fichero.nombreDeFichero == "Pentagrama G7.svg")
    }

    @Test func laProporcionEsLaDeSuDibujo() {
        for pentagrama in [
            PentagramaPresentado(Escala("La menor melódica")), PentagramaPresentado(Acorde("Do")),
        ] {
            #expect(pentagrama.relacionDeAspecto == PentagramaPresentado.relacionDeAspecto(deSVG: pentagrama.svg))
            #expect(pentagrama.relacionDeAspecto != 4, "el SVG del motor lleva viewBox")
        }
    }
}
