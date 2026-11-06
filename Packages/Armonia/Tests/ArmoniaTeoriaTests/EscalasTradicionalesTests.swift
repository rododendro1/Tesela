import Foundation
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// Escalas concretas de otras tradiciones: Aristóxeno y Ṣafī al-Dīn, el folklore europeo, Vietnam, Brasil y Birmania.
@Suite struct EscalasTradicionalesTests {
    /// Los colores de Aristóxeno, en doceavos de tono, y los adwār de Ṣafī al-Dīn, pitagóricos.
    @Test func aristoxenoYSafiAlDin() throws {
        #expect(TipoDeEscala.coloresDeAristoxeno.allSatisfy { $0.tradicion == .greciaAntigua })
        #expect(TipoDeEscala.coloresDeAristoxeno.allSatisfy { $0.categoria == .tetracordo })
        #expect(TipoDeEscala.tetracordoCromaticoBlandoDeAristoxeno.microtonal?.desvios == [0, -33, 33, 0])
        #expect(TipoDeEscala.tetracordoCromaticoHemiolico.microtonal?.desvios == [0, -25, -50, 0])
        #expect(try TipoDeEscala(leyendo: "cromático tónico") == .tetracordoCromatico)
        #expect(TipoDeEscala.adwar.allSatisfy { $0.tradicion == .mundoArabe && $0.categoria == .maqam })
        #expect(TipoDeEscala.shaddNawa == .menorNatural)
        #expect(TipoDeEscala.shaddRast.microtonal?.desvios == [0, 4, -16, -2, 2, -18, -4])
        #expect((try? TipoDeEscala(leyendo: "Rast de Safi al-Din"))?.nombre == "shadd Rāst")
    }

    /// El folklore europeo: tres escalas populares, dos instrumentos de afinación natural y el canto georgiano, con
    /// sus cents.
    @Test func elFolkloreEuropeo() throws {
        #expect(TipoDeEscala.tradicionales(tradicion: .europa) == TipoDeEscala.europeas)
        #expect(TipoDeEscala.europeas.allSatisfy { $0.categoria == .escala })
        #expect(TipoDeEscala.doricoUcraniano == .doricoCuartaAumentada)
        #expect(TipoDeEscala.podhalanska == .lidioDominante)
        #expect(TipoDeEscala.pentatonicaHungara == .pentatonicaMenor)
        #expect(TipoDeEscala.gaitaEscocesa == .mixolidio)
        // El nombre gana al alias: «dórico ucraniano» es ya la escala europea, igual que el dórico ♯4.
        let ucraniano = try TipoDeEscala(leyendo: "dórico ucraniano")
        #expect(ucraniano.nombre == "dórico ucraniano" && ucraniano.tradicion == .europa)
        #expect((try? TipoDeEscala(leyendo: "Podhale"))?.nombre == "podhalańska")
        #expect((try? TipoDeEscala(leyendo: "Alphorn"))?.nombre == "cuerno alpino")
        let alpino = Escala("Do cuerno alpino").notas.map(\.nombre)
        #expect(alpino == ["Do", "Re", "Mi", "Fa♯", "Sol", "La♭", "Si♭", "Si"])
        // El 11.º armónico, 49 cents bajo Fa♯; la 7ª natural de la gaita, 31 bajo Si♭.
        #expect(TipoDeEscala.cuernoAlpino.microtonal?.desvios[3] == -49)
        #expect(TipoDeEscala.gaitaEscocesa.microtonal?.desvios[6] == -31)
        #expect(TipoDeEscala.mixolidio.microtonal == nil)
        // El canto georgiano: la segunda, 37 cents baja; la tercera, neutra, 32 sobre Mi♭.
        #expect(TipoDeEscala.georgiana == .dorico)
        #expect(TipoDeEscala.georgiana.microtonal?.desvios == [0, -37, 32, 9, -7, -32, 18])
        #expect((try? TipoDeEscala(leyendo: "Svaneti"))?.nombre == "georgiana")
        #expect(TipoDeEscala.georgiana.nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles)) == "Georgian")
        #expect(Tradicion.europa.nombre == "Folklore europeo")
        #expect(Tradicion.europa.nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles)) == "European folk")
    }

    /// Vietnam, Brasil y el arpa birmana.
    @Test func vietnamBrasilYMyanmar() {
        #expect(TipoDeEscala.tradicionales(tradicion: .vietnam).map(\.nombre) == ["Bắc", "Vọng cổ"])
        #expect(TipoDeEscala.bac.microtonal?.cents == [0, 189, 501, 698, 891])
        #expect((try? TipoDeEscala(leyendo: "hoi oan"))?.nombre == "Vọng cổ")
        #expect(TipoDeEscala.tradicionales(tradicion: .brasil).count == 3)
        #expect(TipoDeEscala.lidioNordestino == .lidioDominante)
        #expect((try? TipoDeEscala(leyendo: "nordestina"))?.nombre == "lidio dominante")
        #expect(TipoDeEscala.saung.tradicion == .sudesteAsiatico && TipoDeEscala.saung.clase == .afinacion)
        #expect(TipoDeEscala.saung.microtonal?.desvios == [0, -18, -36, -9, -27])
        #expect(Tradicion.vietnam.nombre(en: Notacion.espanolCompacto.conTextos(en: .portugues)) == "Vietname")
        #expect(Tradicion.brasil.nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles)) == "Brazil")
    }
}
