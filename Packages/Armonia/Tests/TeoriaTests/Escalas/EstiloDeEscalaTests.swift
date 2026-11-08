import Testing

@testable import Elementos
@testable import Teoria

@Suite struct EstiloDeEscalaTests {
    /// Toda escala de `todos` tiene al menos un estilo, y todos occidentales; las de otras tradiciones, ninguno
    /// occidental; las propias, ninguno.
    @Test func todasLasHabitualesTienenEstilo() {
        for tipo in TipoDeEscala.occidentales {
            #expect(!tipo.estilos.isEmpty, Comment(rawValue: tipo.nombre))
            #expect(tipo.estilos.allSatisfy { $0.tradicion == .occidental }, Comment(rawValue: tipo.nombre))
            #expect(tipo.regiones.isEmpty, Comment(rawValue: tipo.nombre))
            #expect(tipo.tradicion == .occidental, Comment(rawValue: tipo.nombre))
        }
        for tipo in TipoDeEscala.tradicionales {
            #expect(tipo.estilos.allSatisfy { $0.tradicion != .occidental }, Comment(rawValue: tipo.nombre))
        }
        #expect(TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta]).estilos.isEmpty)
    }

    /// Se busca por el nombre: Kāfī tiene las notas del dórico, pero no sus estilos.
    @Test func losEstilosSonDelNombre() {
        #expect(TipoDeEscala.kafi == .dorico)
        #expect(TipoDeEscala.dorico.estilos == [.clasica, .jazz])
        #expect(TipoDeEscala.kafi.estilos == [.indostanica])
        #expect(TipoDeEscala(nombre: "dórico", intervalos: [.unisono, .quintaJusta]).estilos.isEmpty)
    }

    @Test func ejemplosDeCadaEstilo() {
        #expect(TipoDeEscala.alterada.estilos == [.jazz])
        #expect(TipoDeEscala.menorMelodica.estilos == [.clasica])
        #expect(TipoDeEscala.menorMelodicaJazz.estilos == [.jazz])
        #expect(TipoDeEscala.blues.estilos == [.blues])
        #expect(TipoDeEscala.pentatonicaMenor.estilos == [.blues, .popular])
        #expect(TipoDeEscala.disminuida.estilos == [.jazz, .sigloXX])
        #expect(TipoDeEscala.lidioDominante.estilos == [.jazz, .sigloXX])
        #expect(TipoDeEscala.flamenca.estilos == [.popular])
        #expect(TipoDeEscala.ultrafrigio.estilos == [.sintetica])
        #expect(EstiloDeEscala.blues.tipos.first == .pentatonicaMayor)
        #expect(EstiloDeEscala.sigloXX.tipos.contains(.messiaen3))
        // En el orden del catálogo, sin repetir; cada estilo tiene alguna escala.
        for estilo in EstiloDeEscala.allCases {
            let nombres = estilo.tipos.map(\.nombre)
            #expect(!nombres.isEmpty, "\(estilo)")
            #expect(nombres == TipoDeEscala.catalogo.map(\.nombre).filter { nombres.contains($0) })
        }
        #expect(EstiloDeEscala.gagaku.tipos.allSatisfy { $0.tradicion == .japon })
    }

    /// Cada estilo tiene nombre en los trece idiomas, y en español es también su `nombre`.
    @Test func losNombresDeLosEstilosSeTraducen() {
        for uso in EstiloDeEscala.allCases {
            #expect(uso.nombre(en: .compacta(.espanol)) == uso.nombre)
            for idioma in Idioma.allCases {
                #expect(
                    !uso.nombre(en: Notacion.compacta(.espanol).conTextos(en: idioma)).isEmpty,
                    Comment(rawValue: "\(uso) en \(idioma)"))
            }
        }
        #expect(EstiloDeEscala.sigloXX.nombre == "siglo XX")
        #expect(EstiloDeEscala.sigloXX.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "20th century")
    }
}
