import Testing

@testable import Elementos
@testable import Teoria

@Suite struct UsoDeEscalaTests {
    /// Toda escala de `todos` tiene al menos un uso; las de otras tradiciones y las propias, ninguno.
    @Test func todasLasHabitualesTienenUso() {
        for tipo in TipoDeEscala.occidentales {
            #expect(!tipo.usos.isEmpty, Comment(rawValue: tipo.nombre))
        }
        for tipo in TipoDeEscala.tradicionales {
            #expect(tipo.usos.isEmpty, Comment(rawValue: tipo.nombre))
        }
        #expect(TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta]).usos.isEmpty)
    }

    /// Se busca por el nombre: Kāfī tiene las notas del dórico, pero no sus usos.
    @Test func losUsosSonDelNombre() {
        #expect(TipoDeEscala.kafi == .dorico)
        #expect(TipoDeEscala.dorico.usos == [.clasica, .jazz])
        #expect(TipoDeEscala.kafi.usos.isEmpty)
        #expect(TipoDeEscala(nombre: "dórico", intervalos: [.unisono, .quintaJusta]).usos.isEmpty)
    }

    @Test func ejemplosDeCadaUso() {
        #expect(TipoDeEscala.alterada.usos == [.jazz])
        #expect(TipoDeEscala.menorMelodica.usos == [.clasica])
        #expect(TipoDeEscala.menorMelodicaJazz.usos == [.jazz])
        #expect(TipoDeEscala.blues.usos == [.blues])
        #expect(TipoDeEscala.pentatonicaMenor.usos == [.blues, .popular])
        #expect(TipoDeEscala.disminuida.usos == [.jazz, .sigloXX])
        #expect(TipoDeEscala.lidioDominante.usos == [.jazz, .sigloXX])
        #expect(TipoDeEscala.flamenca.usos == [.popular])
        #expect(TipoDeEscala.ultrafrigio.usos == [.sintetica])
        #expect(TipoDeEscala.occidentales(uso: .blues).first == .pentatonicaMayor)
        #expect(TipoDeEscala.occidentales(uso: .sigloXX).contains(.messiaen3))
        // En el orden de `todos`, sin repetir.
        for uso in UsoDeEscala.allCases {
            let nombres = TipoDeEscala.occidentales(uso: uso).map(\.nombre)
            #expect(nombres == TipoDeEscala.occidentales.map(\.nombre).filter { nombres.contains($0) })
        }
    }

    /// Cada uso tiene nombre en los trece idiomas, y en español es también su `nombre`.
    @Test func losNombresDeLosUsosSeTraducen() {
        for uso in UsoDeEscala.allCases {
            #expect(uso.nombre(en: .espanolCompacto) == uso.nombre)
            for idioma in Idioma.allCases {
                #expect(
                    !uso.nombre(en: Notacion.espanolCompacto.conTextos(en: idioma)).isEmpty,
                    Comment(rawValue: "\(uso) en \(idioma)"))
            }
        }
        #expect(UsoDeEscala.sigloXX.nombre == "siglo XX")
        #expect(UsoDeEscala.sigloXX.nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles)) == "20th century")
    }
}
