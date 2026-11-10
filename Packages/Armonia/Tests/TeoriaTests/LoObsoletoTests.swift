import Testing

@testable import Elementos
@testable import Teoria

/// Lo que queda obsoleto hasta la 0.5.0 sigue dando lo mismo que lo que lo sustituye. Las pruebas no pueden ser
/// obsoletas, así que llaman a lo obsoleto a través de un protocolo, sin avisos.
@Suite struct LoObsoletoTests {
    @Test func afinacionHistorica() throws { try (Pruebas() as any PruebasDeLoObsoleto).afinacionHistorica() }
    @Test func comparar() throws { try (Pruebas() as any PruebasDeLoObsoleto).comparar() }
    @Test func medidasYTextos() throws { try (Pruebas() as any PruebasDeLoObsoleto).medidasYTextos() }
}

private protocol PruebasDeLoObsoleto {
    func afinacionHistorica() throws
    func comparar() throws
    func medidasYTextos() throws
}

private struct Pruebas: PruebasDeLoObsoleto {
    @available(*, deprecated)
    func afinacionHistorica() throws {
        #expect(AfinacionHistorica.allCases.count == 8)
        #expect(AfinacionHistorica.allCases.map(\.temperamento) == TemperamentoConNombre.paraEscuchar)
        for historica in AfinacionHistorica.allCases {
            let temperamento = historica.temperamento
            #expect(temperamento.historica == historica)
            #expect(historica.distingueEnarmonicas == temperamento.distingueEnarmonicas, "\(historica)")
            let nueva = try #require(temperamento.afinacion(tonica: .re, frecuenciaDelLa4: 442))
            let vieja = historica.afinacion(tonica: .re, frecuenciaDelLa4: 442)
            #expect(abs(nueva.frecuencia(de: "Sol#4") - vieja.frecuencia(de: "Sol#4")) < 1e-9, "\(historica)")
            for idioma in Idioma.allCases {
                #expect(!historica.nombre(en: Notacion.delIdioma(idioma)).isEmpty)
            }
        }
        #expect(AfinacionHistorica.justa.nombre(en: .ascii(.ingles)) == "just intonation")
        #expect(AfinacionHistorica.kirnbergerIII.description == "Kirnberger III")
        #expect(TemperamentoConNombre.divisiones31.historica == nil)
        #expect(Escala(.do, .mayor).cents(en: .justa) == Escala(.do, .mayor).cents(con: .afinacionJusta))
        #expect(TipoDeEscala.dorico.afinacionSugerida == .mesotonico)
        #expect(TipoDeEscala.mayor.afinacionSugerida == .werckmeisterIII)
        #expect(Tradicion.india.afinacionSugerida == .justa)
        #expect(Estilo.jazz.afinacionSugerida == .igual)
        #expect(Estilo.carnatica.afinacionSugerida == nil)
    }

    @available(*, deprecated)
    func comparar() throws {
        let acordes = try #require(Acorde("Sol7").comparar(con: Acorde("Do")))
        let voces = try #require(Acorde("Sol7").relacion(con: Acorde("Do")).voces())
        #expect(acordes.comunes == [.sol])
        #expect(acordes.desde == voces.desde && acordes.hasta == voces.hasta)
        #expect(acordes.movimientos == voces.movimientos)
        #expect(acordes.movimientoTotal == voces.movimientoTotal)
        #expect(Acorde(.do, .potencia).comparar(con: Acorde("Sol"), disposicion: .shell) == nil)
        let escalas = Escala(.do).comparar(con: Escala(.do, .lidio))
        let relacion = Escala(.do).relacion(con: Escala(.do, .lidio))
        #expect(escalas.comunes == relacion.comunes && escalas.cambios == relacion.cambios)
        #expect(escalas.soloEnOrigen == relacion.soloEnOrigen && escalas.soloEnDestino == relacion.soloEnDestino)
        #expect(escalas.distanciaEnQuintas == 1)
    }

    @available(*, deprecated)
    func medidasYTextos() throws {
        let mayor = ConjuntoDeClasesDeAltura([0, 2, 4, 5, 7, 9, 11])
        #expect(mayor.medidas == mayor.estadisticas)
        let tonal = Escala(.do, .mayor).estadisticas.tonal
        #expect(tonal.triadasPorGrados == ["", "m", "m", "", "", "m", "°"])
        #expect(tonal.cuatriadasPorGrados == ["maj7", "m7", "m7", "maj7", "7", "m7", "ø7"])
        #expect(Escala(.do, .pentatonicaMayor).estadisticas.tonal.triadasPorGrados == nil)
        let primera = try #require(Acorde("Do7M").pentatonicas.first)
        #expect(primera.tensiones == ["9", "13"])
    }
}
