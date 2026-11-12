import Testing

@testable import Elementos
@testable import Teoria

@Suite struct EpocaTests {
    /// Las épocas van por orden cronológico.
    @Test func elOrdenEsCronologico() {
        #expect(
            Epoca.allCases.sorted() == [
                .antiguedad, .edadMedia, .renacimiento, .barroco, .clasicismo, .romanticismo, .sigloXX, .sigloXXI,
            ])
        #expect(Epoca.tonales.allSatisfy(\.esTonal) && !Epoca.sigloXX.esTonal)
        #expect(Epoca.antiguedad < .sigloXX)
    }

    /// Cada época tiene nombre en los trece idiomas, distinto en cada uno de los cinco.
    @Test func nombres() {
        #expect(Epoca.romanticismo.nombre == "Romanticismo")
        #expect(Epoca.nombreDeLaEpocaTonal(en: .compacta(.espanol)) == "época tonal")
        #expect(Epoca.edadMedia.nombre(en: .delIdioma(.ingles)) == "Middle Ages")
        #expect(Epoca.barroco.nombre(en: .delIdioma(.aleman)) == "Barock")
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

    /// Kāfī tiene las notas del dórico, pero no es occidental: no se fecha por los modos gregorianos, sino por los thāṭ
    /// de Bhātkhaṇḍe (1909).
    @Test func soloLasOccidentalesSeFechanPorSusNotas() {
        #expect(TipoDeEscala.kafi == .dorico)
        #expect(TipoDeEscala.kafi.epocaDeOrigen == .sigloXX)
        #expect(TipoDeEscala(nombre: "mía", intervalos: TipoDeEscala.dorico.intervalos).epocaDeOrigen == nil)
    }

    /// Las de jazz no se fechan por sus notas: la bebop dominante es del siglo XX.
    @Test func lasDeJazzNoSeFechanPorSusNotas() {
        #expect(TipoDeEscala.bebopDominante.epocaDeOrigen == .sigloXX)
        #expect(TipoDeEscala.alterada.epocaDeOrigen == .sigloXX)
        #expect(TipoDeEscala.alterada.epocasDeUso == [.sigloXXI])
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
        #expect(TipoDeEscala.locrioSextaNatural.epocaDeOrigen == .barroco) // modo 2 de la menor armónica
        #expect(TipoDeEscala.menorArmonica.epocaDeOrigen == .barroco)
        #expect(TipoDeEscala.menorMelodicaJazz.epocaDeOrigen == .sigloXX)
        #expect(TipoDeEscala.flamenca.epocaDeOrigen == nil)
        #expect(TipoDeEscala.mayorRumana.epocaDeOrigen == nil)
    }

    /// La menor melódica es del Barroco, por el modo menor de Rameau (1722), aunque sus notas estén en una escala del
    /// Renacimiento.
    /// La mayor húngara es del siglo XX, por Persichetti (1961), y con ella sus seis modos sintéticos.
    @Test func laMayorHungaraEsDelSigloXX() {
        #expect(TipoDeEscala.mayorHungara.epocaDeOrigen == .sigloXX)
        #expect(TipoDeEscala.ultralocrioSextaDisminuida.epocaDeOrigen == .sigloXX)
    }

    @Test func laMenorMelodicaEsBarroca() {
        #expect(TipoDeEscala.menorMelodica.documentada == .rameau1722)
        #expect(TipoDeEscala.menorMelodica.epocaDeOrigen == .barroco)
    }

    /// La de origen no se repite en las de uso, y `epocas` las junta en orden.
    @Test func origenYUso() {
        #expect(TipoDeEscala.dorico.epocasDeUso == [.barroco, .clasicismo, .romanticismo, .sigloXX, .sigloXXI])
        #expect(TipoDeEscala.dorico.epocas.first == .edadMedia && TipoDeEscala.dorico.epocas.count == 6)
        // La menor armónica, también en los siglos XX y XXI, por el metal neoclásico.
        #expect(TipoDeEscala.menorArmonica.epocasDeUso == [.clasicismo, .romanticismo, .sigloXX, .sigloXXI])
        #expect(TipoDeEscala.locrio.epocas == Epoca.tonales + [.sigloXX, .sigloXXI])
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
        #expect(cuenta[.renacimiento] == 2)
        #expect(cuenta[.barroco] == 34)
        #expect(cuenta[.clasicismo] == nil)
        #expect(cuenta[.romanticismo] == 11)
        #expect(cuenta[.sigloXX] == 52)
        #expect(cuenta[.sigloXXI] == nil)
        #expect(cuenta[nil] == 14)
    }

    /// La regla 0: el año de la obra que documenta la escala va por delante de todas.
    @Test func laObraQueLaDocumenta() {
        #expect(Epoca(anio: 499) == .antiguedad && Epoca(anio: 500) == .edadMedia)
        #expect(Epoca(anio: 1399) == .edadMedia && Epoca(anio: 1400) == .renacimiento)
        #expect(Epoca(anio: 1599) == .renacimiento && Epoca(anio: 1600) == .barroco)
        #expect(Epoca(anio: 1749) == .barroco && Epoca(anio: 1750) == .clasicismo)
        #expect(Epoca(anio: 1819) == .clasicismo && Epoca(anio: 1820) == .romanticismo)
        #expect(Epoca(anio: 1899) == .romanticismo && Epoca(anio: 1900) == .sigloXX)
        #expect(Epoca(anio: 1999) == .sigloXX && Epoca(anio: 2000) == .sigloXXI)
        #expect(TipoDeEscala.menorHungara.documentada == .liszt1859)
        #expect(TipoDeEscala.menorHungara.epocaDeOrigen == .romanticismo)
        #expect(TipoDeEscala.menorHungara.referencias.contains(.liszt1859))
        #expect(TipoDeEscala.echosProtos.documentada == .chrysanthos1832)
        #expect(TipoDeEscala.echosProtos.epocaDeOrigen == .romanticismo)
        #expect(TipoDeEscala.rastMakami.documentada == .cantemir1700)
        #expect(TipoDeEscala.rastMakami.epocaDeOrigen == .barroco)
        // Toda obra que documenta una escala tiene año.
        for tipo in TipoDeEscala.catalogo {
            if let obra = tipo.documentada { #expect(obra.anio != nil, Comment(rawValue: tipo.nombre)) }
        }
        #expect(TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta]).documentada == nil)
    }

    /// La regla 5: las sintéticas y las populares toman la época de las escalas de las que son un modo.
    @Test func losModosDeLasFechadas() {
        #expect(TipoDeEscala.dobleArmonica.esModo(de: .menorHungara))
        #expect(TipoDeEscala.dobleArmonica.epocaDeOrigen == .romanticismo)
        #expect(TipoDeEscala.ultrafrigio.epocaDeOrigen == .romanticismo)
        #expect(TipoDeEscala.mayorLocria.epocaDeOrigen == .barroco) // por la napolitana mayor
        #expect(!TipoDeEscala.menorHungara.esModo(de: .menorHungara))
        // La mayor húngara, por Persichetti (1961), y con ella sus modos.
        #expect(TipoDeEscala.mayorHungara.epocaDeOrigen == .sigloXX)
        #expect(TipoDeEscala.superlocrioSextaNatural.epocaDeOrigen == .sigloXX)
    }

    /// Los çeşni son de Arel-Ezgi-Uzdilek, del siglo XX.
    @Test func losCesniDeArelEzgiUzdilek() {
        #expect(TipoDeEscala.rastDortlusu.fuente == .arelEzgiUzdilek)
        #expect(TipoDeEscala.rastDortlusu.epocaDeOrigen == .sigloXX)
        #expect(TipoDeEscala.tradicionales(fuente: .arelEzgiUzdilek).count == 12)
        #expect(FuenteTeorica.arelEzgiUzdilek.tradicion == .turquia)
        #expect(FuenteTeorica.arelEzgiUzdilek.referencia == .ezgi1933)
    }

    /// Las obras que documentan las escalas de compositor: los tonos enteros son de Glinka (1842), las octatónicas de
    /// Rimski-Kórsakov (1867), la enigmática de Verdi (1889) y los modos 3 a 7 de Messiaen (1944).
    @Test func lasEscalasDeCompositor() {
        #expect(TipoDeEscala.tonosEnteros.anioDeOrigen == 1842)
        #expect(TipoDeEscala.tonosEnteros.epocaDeOrigen == .romanticismo)
        #expect(TipoDeEscala.tonosEnteros.epocasDeUso == [.sigloXX, .sigloXXI])
        #expect(
            TipoDeEscala.disminuida.anioDeOrigen == 1867 && TipoDeEscala.disminuidaSemitonoTono.anioDeOrigen == 1867)
        #expect(TipoDeEscala.enigmatica.anioDeOrigen == 1889)
        #expect(TipoDeEscala.prometeo.anioDeOrigen == 1910 && TipoDeEscala.petrushka.anioDeOrigen == 1911)
        for tipo in [TipoDeEscala.messiaen3, .messiaen4, .messiaen5, .messiaen6, .messiaen7] {
            #expect(tipo.anioDeOrigen == 1944, Comment(rawValue: tipo.nombre))
        }
        #expect(Referencia.glinka1842.clase == .partitura)
        #expect(Referencia.bibtex([.glinka1842]).contains("@misc{glinka1842"))
    }

    /// La época del nombre: la mayor tiene las notas del jónico de Glareano, pero se llama «mayor» desde el Barroco;
    /// los modos llevan los nombres griegos desde la «Alia musica».
    @Test func laEpocaDelNombre() {
        #expect(TipoDeEscala.mayor.epocaDeOrigen == .renacimiento && TipoDeEscala.mayor.epocaDelNombre == .barroco)
        #expect(TipoDeEscala.menorNatural.epocaDelNombre == .barroco)
        #expect(TipoDeEscala.dorico.epocaDelNombre == .edadMedia)
        #expect(TipoDeEscala.alterada.epocaDelNombre == .sigloXX)
        #expect(TipoDeEscala.flamenca.epocaDelNombre == nil)
    }
}
