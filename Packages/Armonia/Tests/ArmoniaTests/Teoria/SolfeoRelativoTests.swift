import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

@Suite struct SolfeoRelativoTests {
    @Test func enMayor() {
        let solfeo = SolfeoRelativo(Tonalidad("Re mayor"))
        #expect(solfeo.notaDo == Nota("Re"))
        #expect(solfeo.silabas(de: Escala("Re mayor").notas) == ["do", "re", "mi", "fa", "so", "la", "ti"])
        #expect(solfeo.silaba(de: "Fa#") == "mi")
        // Subidas y bajadas.
        #expect(solfeo.silabas(de: ["Re#", "Mi#", "Sol#", "La#", "Si#"]) == ["di", "ri", "fi", "si", "li"])
        #expect(solfeo.silabas(de: ["Mib", "Fa", "Lab", "Sib", "Do"]) == ["ra", "me", "se", "le", "te"])
        // Sin sílaba propia: la natural con sus signos.
        #expect(solfeo.silaba(de: "Fa##") == "mi♯")
        #expect(solfeo.silaba(de: "Reb") == "do♭")
        #expect(solfeo.silaba(de: "Mi##") == "re♯♯")
    }

    @Test func enMenor() {
        // Kodály: la tónica menor es «la», y La menor canta como Do mayor.
        let enLa = SolfeoRelativo(Tonalidad("La menor"))
        #expect(enLa.notaDo == Nota("Do"))
        #expect(enLa.silabas(de: Escala("La menor").notas) == ["la", "ti", "do", "re", "mi", "fa", "so"])
        #expect(enLa.silaba(de: "Sol#") == "si")
        // Con la tónica en «do», la tercera menor es «me».
        let enDo = SolfeoRelativo(Tonalidad("La menor"), menor: .enDo)
        #expect(enDo.silabas(de: Escala("La menor").notas) == ["do", "re", "me", "fa", "so", "le", "te"])
    }

    @Test func enHungaro() {
        let solfeo = SolfeoRelativo(Tonalidad("Fa mayor"))
        #expect(
            solfeo.silabas(de: Escala("Fa mayor").notas, en: .hungaro) == ["dó", "ré", "mi", "fá", "szó", "lá", "ti"])
        #expect(solfeo.silaba(de: "Do#", en: .hungaro) == "szi")
        #expect(solfeo.silabas(de: ["Lab", "Reb", "Mib"], en: .hungaro) == ["ma", "lo", "ta"])
        // El szó bajado no tiene sílaba propia.
        #expect(solfeo.silaba(de: "Dob", en: .hungaro) == "szó♭")
        #expect(SolfeoRelativo(Tonalidad("Re menor")).silabas(de: ["Re", "Fa"], en: .hungaro) == ["lá", "dó"])
    }

    @Test func deUnaEscala() {
        #expect(Escala("Re dórico").solfeoRelativo() == ["do", "re", "me", "fa", "so", "la", "te"])
        #expect(Escala("Mi menor natural").solfeoRelativo() == ["la", "ti", "do", "re", "mi", "fa", "so"])
        #expect(Escala("Mi menor natural").solfeoRelativo(menor: .enDo, en: .hungaro).first == "dó")
        // En cualquier tonalidad de la misma clase, las mismas sílabas.
        for tonica in ["Do", "Fa#", "Sib", "Dob"] {
            #expect(
                Escala(Nota(texto: tonica)!, .mayor).solfeoRelativo() == ["do", "re", "mi", "fa", "so", "la", "ti"])
        }
    }
}
