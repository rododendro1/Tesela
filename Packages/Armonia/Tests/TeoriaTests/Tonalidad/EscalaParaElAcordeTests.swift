import Testing

@testable import Elementos
@testable import Teoria

/// Las escalas de un acorde con su motivo (`Acorde.escalas(en:siguiente:entre:)`).
@Suite struct EscalaParaElAcordeTests {
    @Test func sinTonalidadPrimeroLaDelCifrado() throws {
        let escalas = Acorde("Do7").escalas()
        #expect(escalas.map(\.escala) == Acorde("Do7").escalasCompatibles())
        #expect(escalas[0].escala == Escala(.do, .mixolidio) && escalas[0].motivo == .delCifrado)
        #expect(escalas[1].motivo == .compatible)
        let lidioDominante = try #require(escalas.first { $0.escala == Escala(.do, .lidioDominante) })
        #expect(lidioDominante.alteracionesNoPedidas.map(\.cifra) == ["♯11"])
        #expect(escalas[0].alteracionesNoPedidas.isEmpty)
        #expect(escalas[0].notas == Escala(.do, .mixolidio).notas(sobre: Acorde("Do7")))
    }

    @Test func conTonalidadPrimeroLaQuePide() {
        let enDo = Tonalidad(.do, .mayor)
        let rem7 = Acorde("Rem7").escalas(en: enDo)
        #expect(rem7[0].escala == Escala(.re, .dorico) && rem7[0].motivo == .deLaTonalidad(.diatonico))
        // La7 antes de Rem7 es el V7/ii: La frigio dominante, de la tonalidad.
        let la7 = Acorde("La7").escalas(en: enDo, siguiente: Acorde("Rem7"))
        #expect(la7[0].escala == Escala(.la, .frigioDominante))
        #expect(la7[0].motivo == .deLaTonalidad(.dominanteSecundaria(de: 2)))
        // Lo mismo que Tonalidad.escalaDelAcorde, también cuando la tonalidad no basta.
        for cifrado in ["Rem7", "Sol7", "Sol7(b9)", "Do7M", "Fa#ø7", "Mib7"] {
            let acorde = Acorde(stringLiteral: cifrado)
            #expect(
                acorde.escalas(en: enDo, entre: TipoDeEscala.paraAcordes).first?.escala
                    == enDo.escalaDelAcorde(acorde), Comment(rawValue: cifrado))
        }
        // Sol7(♭9) en Do: la escala de la tonalidad no tiene el La♭, así que va primero la que menos notas saca.
        #expect(Acorde("Sol7(b9)").escalas(en: enDo)[0].escala == Escala(.sol, .frigioDominante))
    }

    @Test func elBajoAjenoDaLasDeSuAcorde() throws {
        let faSobreSol = Acorde("Fa/Sol")
        #expect(faSobreSol.acordeSobreElBajo?.fundamental == .sol)
        let delBajo = faSobreSol.escalas().filter { $0.motivo == .delBajo }
        #expect(delBajo.first?.escala == Escala(.sol, .mixolidio))
        #expect(delBajo.allSatisfy { $0.escala.contiene(acorde: faSobreSol) })
        #expect(Acorde("Do/Mi").acordeSobreElBajo == nil) // el bajo es del acorde
    }

    @Test func losMotivosTienenNombre() {
        let motivos: [EscalaParaElAcorde.Motivo] = [.deLaTonalidad(.diatonico), .delCifrado, .delBajo, .compatible]
        #expect(motivos.map(\.nombre) == ["de la tonalidad", "del cifrado", "del bajo", "compatible"])
        for idioma in Idioma.allCases {
            let nombres = motivos.map { $0.nombre(en: Notacion.compacta(.espanol).conTextos(en: idioma)) }
            #expect(Set(nombres).count == 4 && !nombres.contains(""), Comment(rawValue: "\(idioma)"))
        }
    }
}
