import Testing

@testable import Elementos
@testable import Teoria

@Suite struct EpocaTests {
    /// Las épocas van por orden cronológico.
    @Test func elOrdenEsCronologico() {
        #expect(Epoca.allCases.sorted() == [.antiguedad, .edadMedia, .renacimiento, .tonal, .sigloXX])
        #expect(Epoca.antiguedad < .sigloXX)
    }

    /// Cada época tiene nombre en los trece idiomas, distinto en cada uno de los cinco.
    @Test func nombres() {
        #expect(Epoca.tonal.nombre == "época tonal")
        #expect(Epoca.edadMedia.nombre(en: .delIdioma(.ingles)) == "Middle Ages")
        #expect(Epoca.tonal.nombre(en: .delIdioma(.aleman)) == "tonale Epoche")
        for idioma in Idioma.allCases {
            let nombres = Epoca.allCases.map { $0.nombre(en: .delIdioma(idioma)) }
            #expect(Set(nombres).count == nombres.count)
            #expect(nombres.allSatisfy { !$0.isEmpty })
        }
    }

    /// La regla 3: las de la música clásica toman la época de las gregorianas y renacentistas con sus notas.
    @Test func losModosSonMedievalesYLaMayorRenacentista() {
        for tipo in [TipoDeEscala.dorico, .frigio, .lidio, .mixolidio] {
            #expect(tipo.epocaDeOrigen == .edadMedia, Comment(rawValue: tipo.nombre))
        }
        #expect(TipoDeEscala.mayor.epocaDeOrigen == .renacimiento)
        #expect(TipoDeEscala.menorNatural.epocaDeOrigen == .renacimiento)
        #expect(TipoDeEscala.hexacordo.epocaDeOrigen == .edadMedia)
    }

    /// Kāfī tiene las notas del dórico, pero no es occidental: no se fecha por los modos gregorianos.
    @Test func soloLasOccidentalesSeFechanPorSusNotas() {
        #expect(TipoDeEscala.kafi == .dorico)
        #expect(TipoDeEscala.kafi.epocaDeOrigen == nil)
        #expect(TipoDeEscala(nombre: "mía", intervalos: TipoDeEscala.dorico.intervalos).epocaDeOrigen == nil)
    }

    /// Las de jazz no se fechan por sus notas: la bebop dominante es del siglo XX.
    @Test func lasDeJazzNoSeFechanPorSusNotas() {
        #expect(TipoDeEscala.bebopDominante.epocaDeOrigen == .sigloXX)
        #expect(TipoDeEscala.alterada.epocaDeOrigen == .sigloXX)
        #expect(TipoDeEscala.alterada.epocasDeUso.isEmpty)
    }

    /// Las reglas 1 y 2: la fuente y la tradición.
    @Test func laFuenteYLaTradicion() {
        #expect(FuenteTeorica.glareano.epoca == .renacimiento)
        #expect(TipoDeEscala.ionicus.fuente == .glareano)
        #expect(TipoDeEscala.ionicus.epocaDeOrigen == .renacimiento)
        #expect(Tradicion.gregoriano.epoca == .edadMedia)
        #expect(Tradicion.occidental.epoca == nil)
        for tipo in TipoDeEscala.tradicionales where tipo.tradicion == .greciaAntigua {
            #expect(tipo.epocaDeOrigen == .antiguedad, Comment(rawValue: tipo.nombre))
        }
    }

    /// Las reglas 4 y 5: la escala madre de las sintéticas y los estilos.
    @Test func laMadreYLosEstilos() {
        #expect(TipoDeEscala.locrioSextaNatural.epocaDeOrigen == .tonal) // modo 2 de la menor armónica
        #expect(TipoDeEscala.menorArmonica.epocaDeOrigen == .tonal)
        #expect(TipoDeEscala.menorMelodicaJazz.epocaDeOrigen == .sigloXX)
        #expect(TipoDeEscala.flamenca.epocaDeOrigen == nil)
        #expect(TipoDeEscala.mayorRumana.epocaDeOrigen == nil)
    }

    /// La de origen no se repite en las de uso, y `epocas` las junta en orden.
    @Test func origenYUso() {
        #expect(TipoDeEscala.dorico.epocasDeUso == [.tonal, .sigloXX])
        #expect(TipoDeEscala.dorico.epocas == [.edadMedia, .tonal, .sigloXX])
        #expect(TipoDeEscala.menorArmonica.epocasDeUso.isEmpty)
        #expect(TipoDeEscala.locrio.epocas == [.tonal, .sigloXX])
        for tipo in TipoDeEscala.catalogo {
            #expect(!tipo.epocasDeUso.contains { $0 == tipo.epocaDeOrigen }, Comment(rawValue: tipo.nombre))
            #expect(tipo.epocas == tipo.epocas.sorted(), Comment(rawValue: tipo.nombre))
        }
    }

    /// Cuántas occidentales hay de cada época de origen: si cambia un estilo o una tradición, cambia el recuento y
    /// esta prueba lo dice.
    @Test func recuentoDeLasOccidentales() {
        var cuenta: [Epoca?: Int] = [:]
        for tipo in TipoDeEscala.occidentales { cuenta[tipo.epocaDeOrigen, default: 0] += 1 }
        #expect(cuenta[.antiguedad] == nil)
        #expect(cuenta[.edadMedia] == 5)
        #expect(cuenta[.renacimiento] == 3)
        #expect(cuenta[.tonal] == 22)
        #expect(cuenta[.sigloXX] == 45)
        #expect(cuenta[nil] == 37)
    }
}
