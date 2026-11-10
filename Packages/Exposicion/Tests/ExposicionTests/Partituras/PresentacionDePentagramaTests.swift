import Armonia
import Foundation
import Testing

@testable import Exposicion

@Suite struct PresentacionDePentagramaTests {
    @Test func laEscalaDaSuDibujoYSuFichero() {
        let pentagrama = PentagramaPresentado(Escala("Re dórico"), en: .compacta(.espanol))
        #expect(pentagrama.svg.hasPrefix("<svg"))
        #expect(pentagrama.fichero.formato == .svg)
        #expect(pentagrama.fichero.nombreDeFichero == "Pentagrama Re dórico.svg")
        #expect(String(decoding: pentagrama.fichero.datos, as: UTF8.self) == pentagrama.svg)
        #expect(pentagrama.descripcion.hasPrefix("Re dórico: Re₄, Mi₄"))
    }

    @Test func elAcordeLlevaElCifradoYLasNotasSolasSiSePide() {
        let pentagrama = PentagramaPresentado(Acorde("Sol7"), en: .compacta(.espanol))
        #expect(pentagrama.svg.contains(">Sol7</text>"))
        #expect(pentagrama.descripcion == "Sol7: Sol, Si, Re, Fa")
        #expect(!pentagrama.svg.contains("Sol₄ Si₄"))
        #expect(
            PentagramaPresentado(Acorde("Sol7"), en: .compacta(.espanol), nombresDeLasNotas: true).svg.contains(
                "Sol₄ Si₄"))
    }

    @Test func laNotacionSeSigue() {
        let pentagrama = PentagramaPresentado(Escala("Do mayor"), en: .ascii(.ingles))
        #expect(pentagrama.svg.contains("<title>C4</title>"))
    }

    @Test func laRelacionDeAspecto() {
        #expect(PentagramaPresentado.relacionDeAspecto(deSVG: #"<svg viewBox="0 -3 20 10">"#) == 2)
        #expect(PentagramaPresentado.relacionDeAspecto(deSVG: "<svg>") == 4)
        #expect(PentagramaPresentado.relacionDeAspecto(deSVG: #"<svg viewBox="0 0 0 0">"#) == 4)
        let medida = PentagramaPresentado(Escala("Do mayor"), en: .compacta(.espanol)).relacionDeAspecto
        #expect(medida > 1)
    }

    @Test func elArpegioVaNotaANota() {
        let pentagrama = PentagramaPresentado(Arpegio(Acorde("Do"), patron: .alberti), en: .compacta(.espanol))
        #expect(pentagrama.descripcion.hasSuffix(": Do₄, Sol₄, Mi₄, Sol₄"), Comment(rawValue: pentagrama.descripcion))
        #expect(pentagrama.fichero.nombreDeFichero.hasPrefix("Pentagrama Arpegio de Do"))
        #expect(pentagrama.svg.hasPrefix("<svg"))
    }

    @Test func laNotaQueSuenaSeResalta() {
        let arpegio = Arpegio(Acorde("Do"))
        let normal = PentagramaPresentado(arpegio, en: .compacta(.espanol))
        #expect(!normal.svg.contains("#E8590C"))
        let resaltada = PentagramaPresentado(arpegio, en: .compacta(.espanol), resaltada: 2)
        // Solo la tercera nota (Sol4) cambia de color.
        #expect((resaltada.svg.components(separatedBy: "<g fill=\"#E8590C\"><title>").count - 1) == 1)
        #expect(resaltada.svg.contains("<g fill=\"#E8590C\"><title>Sol₄</title>"))
        #expect(
            PentagramaPresentado(Escala("Do mayor"), en: .compacta(.espanol), resaltada: 0).svg.contains(
                "<title>Do₄") == true)
    }

    /// El arpegio que suena en tresillos de corchea se dibuja así, con la nota que suena resaltada y la armadura de
    /// la tonalidad, si se da.
    @Test func laVozSeDibujaConSuRitmo() {
        let figura = Duracion.corchea.grupoIrregular(3, en: 2)
        let arpegio = PresentacionDeArpegios.arpegio(
            Arpegio(Acorde("Mi7")), figura: figura, en: .compacta(.espanol))
        let pentagrama = PentagramaPresentado(arpegio.voz, titulo: "Mi7", en: .compacta(.espanol), resaltada: 1)
        #expect(pentagrama.descripcion == "Mi7: Mi₄, Sol♯₄, Si₄, Re₅, Mi₅")
        #expect(pentagrama.fichero.nombreDeFichero == "Pentagrama Mi7.svg")
        #expect(pentagrama.svg.contains("<g fill=\"#E8590C\"><title>Sol♯₄</title>"))
        let enLaMenor = PentagramaPresentado(
            arpegio.voz, titulo: "Mi7", tonalidad: Tonalidad(.la, .menor), en: .compacta(.espanol))
        #expect(enLaMenor.svg != pentagrama.svg)
    }

    @Test func unViewBoxSinCerrar() {
        #expect(PentagramaPresentado.relacionDeAspecto(deSVG: #"<svg viewBox="0 -3 20 10"#) == 4)
    }
}

@Suite struct PresentacionDePentagramaMasTests {
    @Test func elAcordeConBajoEmpiezaPorElBajoYElFicheroNoLlevaBarras() {
        let pentagrama = PentagramaPresentado(Acorde("Sol7/Si"), en: .compacta(.espanol))
        #expect(pentagrama.descripcion == "Sol7/Si: Si, Re, Fa, Sol")
        #expect(pentagrama.fichero.nombreDeFichero == "Pentagrama Sol7-Si.svg")
    }

    @Test func laOctavaCambiaLasAlturas() {
        #expect(
            PentagramaPresentado(Escala("Re dórico"), octava: 3, en: .compacta(.espanol)).descripcion.hasPrefix(
                "Re dórico: Re₃, Mi₃"))
        #expect(
            PentagramaPresentado(Escala("Re dórico"), octava: 3, en: .compacta(.espanol)).svg
                != PentagramaPresentado(Escala("Re dórico"), en: .compacta(.espanol)).svg)
    }

    @Test func elSentidoCambiaElDibujo() {
        let subida = PentagramaPresentado(Escala("Do mayor"), sentido: .ascendente, en: .compacta(.espanol))
        let bajada = PentagramaPresentado(Escala("Do mayor"), sentido: .descendente, en: .compacta(.espanol))
        #expect(subida.svg != bajada.svg)
        // La descripción dice las notas de la escala, no el orden del dibujo.
        #expect(subida.descripcion == bajada.descripcion)
    }

    @Test func laNotacionSeSigueTambienEnElAcorde() {
        let pentagrama = PentagramaPresentado(Acorde("Sol7"), en: .ascii(.ingles))
        #expect(pentagrama.descripcion == "G7: G, B, D, F")
        #expect(pentagrama.svg.contains(">G7</text>"))
        #expect(pentagrama.fichero.nombreDeFichero == "Pentagrama G7.svg")
    }

    @Test func laProporcionEsLaDeSuDibujo() {
        for pentagrama in [
            PentagramaPresentado(Escala("La menor melódica"), en: .compacta(.espanol)),
            PentagramaPresentado(Acorde("Do"), en: .compacta(.espanol)),
        ] {
            #expect(pentagrama.relacionDeAspecto == PentagramaPresentado.relacionDeAspecto(deSVG: pentagrama.svg))
            #expect(pentagrama.relacionDeAspecto != 4, "el SVG del motor lleva viewBox")
        }
    }
}
