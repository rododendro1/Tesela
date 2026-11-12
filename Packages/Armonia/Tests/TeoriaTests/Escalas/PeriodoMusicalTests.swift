import Testing

@testable import Elementos
@testable import Teoria

@Suite struct PeriodoMusicalTests {
    /// El año de una escala sale de la obra que la documenta, de su fuente o de su categoría, por ese orden.
    @Test func elAnioDeOrigen() {
        #expect(TipoDeEscala.menorHungara.anioDeOrigen == 1859)
        #expect(TipoDeEscala.ionicus.anioDeOrigen == 1547)
        #expect(TipoDeEscala.melakarta(29)?.anioDeOrigen == 1660)
        #expect(TipoDeEscala.mayor.anioDeOrigen == nil)
        #expect(TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta]).anioDeOrigen == nil)
        // La época de una fuente es la de su año.
        for fuente in FuenteTeorica.allCases {
            #expect(fuente.epoca == Epoca(anio: fuente.anio), "\(fuente)")
        }
        #expect(FuenteTeorica.ptolomeo.epoca == .antiguedad)
        #expect(FuenteTeorica.safiAlDin.epoca == .edadMedia)
        #expect(FuenteTeorica.zhuZaiyu.epoca == .renacimiento)
        #expect(FuenteTeorica.chrysanthos.epoca == .tonal)
        // Las categorías con año dan su época a sus escalas.
        #expect(TipoDeEscala.melakarta(29)?.epocaDeOrigen == .tonal)
        #expect(
            TipoDeEscala.tradicionales.filter { $0.categoria == .thaat }.allSatisfy { $0.epocaDeOrigen == .sigloXX })
        #expect(
            TipoDeEscala.tradicionales.filter { $0.categoria == .murchana }.allSatisfy {
                $0.epocaDeOrigen == .antiguedad
            })
    }

    /// Los períodos de cada tradición, en sus límites.
    @Test func losPeriodosDeCadaTradicion() {
        #expect(PeriodoMusical.de(.india, anio: -600) == .vedico)
        #expect(PeriodoMusical.de(.india, anio: 0) == .natyasastra)
        #expect(PeriodoMusical.de(.india, anio: 1250) == .sangitaratnakara)
        #expect(PeriodoMusical.de(.india, anio: 1660) == .mela)
        #expect(PeriodoMusical.de(.india, anio: 1909) == .bhatkhande)
        #expect(PeriodoMusical.de(.mundoArabe, anio: 700) == nil)
        #expect(PeriodoMusical.de(.mundoArabe, anio: 900) == .abasi)
        #expect(PeriodoMusical.de(.mundoArabe, anio: 1252) == .sistematista)
        #expect(PeriodoMusical.de(.mundoArabe, anio: 1920) == .otomanoSafavi)
        #expect(PeriodoMusical.de(.mundoArabe, anio: 1932) == .congresoDelCairo)
        #expect(PeriodoMusical.de(.persia, anio: 1700) == .otomanoSafavi)
        #expect(PeriodoMusical.de(.persia, anio: 1880) == .qayar)
        #expect(PeriodoMusical.de(.persia, anio: 1930) == .moderno)
        #expect(PeriodoMusical.de(.azerbaiyan, anio: 1945) == .moderno)
        #expect(PeriodoMusical.de(.turquia, anio: 1700) == .cantemir)
        #expect(PeriodoMusical.de(.turquia, anio: 1800) == .selimIII)
        #expect(PeriodoMusical.de(.turquia, anio: 1933) == .arelEzgiUzdilek)
        #expect(PeriodoMusical.de(.china, anio: -239) == .zhou)
        #expect(PeriodoMusical.de(.china, anio: 1584) == .ming)
        #expect(PeriodoMusical.de(.china, anio: 1950) == .moderno)
        #expect(PeriodoMusical.de(.japon, anio: 1700) == .edo)
        #expect(PeriodoMusical.de(.occidental, anio: 1700) == nil)
        #expect(PeriodoMusical.de(.bizancio, anio: 1832) == nil)
    }

    /// El período de una escala sale de su tradición y de su año.
    @Test func elPeriodoDeUnaEscala() {
        #expect(TipoDeEscala.melakarta(29)?.periodo == .mela)
        #expect(TipoDeEscala.rastMakami.periodo == .cantemir)
        #expect(TipoDeEscala.rastDortlusu.periodo == .arelEzgiUzdilek)
        #expect(TipoDeEscala.nihavendMakami.periodo == nil) // sin año
        #expect(TipoDeEscala.mayor.periodo == nil) // occidental
        #expect(TipoDeEscala.echosProtos.periodo == nil) // Bizancio no tiene períodos propios
        for tipo in TipoDeEscala.tradicionales where tipo.fuente == .safiAlDin {
            #expect(tipo.periodo == .sistematista, Comment(rawValue: tipo.nombre))
        }
        for tipo in TipoDeEscala.catalogo {
            if let periodo = tipo.periodo, let tradicion = tipo.tradicion, let anio = tipo.anioDeOrigen {
                #expect(PeriodoMusical.de(tradicion, anio: anio) == periodo, Comment(rawValue: tipo.nombre))
            }
        }
    }

    /// Cada período tiene nombre en los trece idiomas, distinto de los demás.
    @Test func nombres() {
        #expect(PeriodoMusical.mela.nombre == "período de los mēḷa")
        #expect(PeriodoMusical.edo.nombre(en: .delIdioma(.ingles)) == "Edo period")
        for idioma in Idioma.allCases {
            let nombres = PeriodoMusical.allCases.map { $0.nombre(en: .delIdioma(idioma)) }
            #expect(nombres.allSatisfy { !$0.isEmpty }, "\(idioma)")
            #expect(Set(nombres).count == nombres.count, "\(idioma)")
        }
    }
}
