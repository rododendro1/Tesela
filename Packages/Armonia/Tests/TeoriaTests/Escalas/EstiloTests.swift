import Testing

@testable import Elementos
@testable import Teoria

@Suite struct EstiloTests {
    /// Toda escala de `todos` tiene al menos un estilo y ninguna escuela; las de otras tradiciones, ningún estilo; las
    /// propias, ninguno.
    @Test func todasLasHabitualesTienenEstilo() {
        for tipo in TipoDeEscala.occidentales {
            #expect(!tipo.estilos.isEmpty, Comment(rawValue: tipo.nombre))
            #expect(tipo.escuelas.isEmpty, Comment(rawValue: tipo.nombre))
            #expect(tipo.regiones.isEmpty || tipo.estilos.allSatisfy { $0.esPopular }, Comment(rawValue: tipo.nombre))
            #expect(tipo.tradicion == .occidental, Comment(rawValue: tipo.nombre))
        }
        for tipo in TipoDeEscala.tradicionales {
            #expect(tipo.estilos.isEmpty, Comment(rawValue: tipo.nombre))
            for escuela in tipo.escuelas {
                #expect(escuela.tradicion == tipo.tradicion, Comment(rawValue: tipo.nombre))
            }
        }
        #expect(TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta]).estilos.isEmpty)
    }

    /// Se busca por el nombre: Kāfī tiene las notas del dórico, pero no sus estilos.
    @Test func losEstilosSonDelNombre() {
        #expect(TipoDeEscala.kafi == .dorico)
        #expect(TipoDeEscala.dorico.estilos == [.clasica, .jazz])
        #expect(TipoDeEscala.kafi.estilos.isEmpty && TipoDeEscala.kafi.escuelas == [.indostanica])
        #expect(TipoDeEscala(nombre: "dórico", intervalos: [.unisono, .quintaJusta]).estilos.isEmpty)
    }

    @Test func ejemplosDeCadaEstilo() {
        #expect(TipoDeEscala.alterada.estilos == [.jazz])
        #expect(TipoDeEscala.menorMelodica.estilos == [.clasica])
        #expect(TipoDeEscala.menorMelodicaJazz.estilos == [.jazz])
        #expect(TipoDeEscala.blues.estilos == [.blues])
        #expect(TipoDeEscala.pentatonicaMenor.estilos == [.blues, .folclore, .popRock])
        #expect(TipoDeEscala.disminuida.estilos == [.jazz, .deCompositor])
        #expect(TipoDeEscala.lidioDominante.estilos == [.jazz, .deCompositor])
        #expect(TipoDeEscala.flamenca.estilos == [.flamenco])
        #expect(TipoDeEscala.frigioDominante.estilos == [.jazz, .flamenco, .popRock])
        #expect(TipoDeEscala.mayorRumana.estilos == [.folclore])
        #expect(TipoDeEscala.mayorRumana.estilos.allSatisfy { $0.esPopular } && !Estilo.jazz.esPopular)
        #expect(TipoDeEscala.ultrafrigio.estilos == [.sintetica])
        #expect(Estilo.blues.tipos.first == .pentatonicaMayor)
        #expect(Estilo.deCompositor.tipos.contains(.messiaen3))
        // En el orden del catálogo, sin repetir; cada estilo tiene alguna escala.
        for estilo in Estilo.allCases {
            let nombres = estilo.tipos.map(\.nombre)
            #expect(!nombres.isEmpty, "\(estilo)")
            #expect(nombres == TipoDeEscala.catalogo.map(\.nombre).filter { nombres.contains($0) })
        }
        for escuela in Escuela.allCases {
            #expect(!escuela.tipos.isEmpty, "\(escuela)")
            #expect(escuela.tipos.allSatisfy { $0.tradicion == escuela.tradicion }, "\(escuela)")
        }
        #expect(Escuela.gagaku.tipos.allSatisfy { $0.tradicion == .japon })
        #expect(Escuela.de(.melakarta) == .carnatica && Escuela.de(.maqam) == nil)
    }

    /// Cada estilo tiene nombre en los trece idiomas, y en español es también su `nombre`.
    @Test func losNombresDeLosEstilosSeTraducen() {
        for uso in Estilo.allCases {
            #expect(uso.nombre(en: .compacta(.espanol)) == uso.nombre)
            for idioma in Idioma.allCases {
                #expect(
                    !uso.nombre(en: Notacion.compacta(.espanol).conTextos(en: idioma)).isEmpty,
                    Comment(rawValue: "\(uso) en \(idioma)"))
            }
        }
        #expect(Estilo.deCompositor.nombre == "de compositor")
        #expect(Estilo.deCompositor.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "composer scales")
        #expect(Estilo.popRock.nombre == "pop y rock")
        #expect(Estilo.nombreDeLosPopulares(en: .compacta(.espanol)) == "popular")
        // En cada idioma, los nombres de los estilos son distintos.
        for idioma in Idioma.allCases {
            let nombres = Estilo.allCases.map { $0.nombre(en: Notacion.compacta(.espanol).conTextos(en: idioma)) }
            #expect(Set(nombres).count == nombres.count, "\(idioma)")
        }
    }
}
