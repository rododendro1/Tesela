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

    /// Los cifrados de los acordes de jazz que se añadieron con su escala: el 7(♭9,♭13) va con el frigio dominante, el
    /// 7sus4(♭9) con el frigio, el °(maj7) con la disminuida y el 7(♭13) con el mixolidio ♭6.
    @Test func lasEscalasDeLosAcordesNuevos() {
        #expect(Acorde("Do7(b9,b13)").escalas().first?.escala == Escala(.do, .frigioDominante))
        #expect(Acorde("Do7sus4(b9)").escalas().first?.escala == Escala(.do, .frigio))
        #expect(Acorde("Do°(maj7)").escalas().first?.escala == Escala(.do, .disminuida))
        #expect(Acorde("Do7(b13)").escalas().first?.escala == Escala(.do, .mixolidioSextaMenor))
        #expect(Acorde("Do°(maj7)").cifrado == "Do°(maj7)" && Acorde("Do°7M").cifrado == "Do°(maj7)")
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

    /// 7alt es la séptima de dominante sin la 5.ª justa, con la ♭5, la ♯5, la ♭9 y la ♯9: le va la alterada.
    @Test func elAlteradoTieneSuEscala() {
        let alt = Acorde("Do7alt")
        #expect(alt.tipo.cifrado == "7(♭5,♯5,♭9,♯9)")
        #expect(!alt.notas.contains(.sol))
        #expect(alt.escalas().first?.escala == Escala(.do, .alterada))
        #expect(alt.escalas().first?.motivo == .delCifrado)
    }

    /// Un bajo ajeno que hace del acorde un sus manda: Fa/Sol se toca como Sol9sus4.
    @Test func elBajoQueHaceUnSusVaPrimero() throws {
        let primera = try #require(Acorde("Fa/Sol").escalas().first)
        #expect(primera.escala == Escala(.sol, .mixolidio) && primera.motivo == .delBajo)
        // El Re, la 5.ª que el acorde calla, es suya.
        let re = try #require(primera.notas.first { $0.nota == .re })
        #expect(re.papel == .delAcorde && re.cifra == "5")
        // Do/Re♭ no es un sus sobre el Re♭: van antes las de Do.
        #expect(Acorde("Do/Reb").escalas().first?.escala.tonica == .do)
    }

    /// Sobre una tríada, la 7.ª de la escala no es tensión: es la séptima que la escala le pone.
    @Test func laSeptimaSobreUnaTriada() throws {
        let notas = Escala(.fa, .lidioDominante).notas(sobre: Acorde("Fa"))
        let mi = try #require(notas.first { $0.nota == .mi.bemol })
        #expect(mi.papel == .septimaDeLaEscala && mi.cifra == "♭7")
        #expect(!Escala(.fa, .lidioDominante).tensiones(sobre: Acorde("Fa")).contains(.mi.bemol))
        // Sobre un acorde con séptima, como siempre.
        #expect(Escala(.do, .mixolidio).notas(sobre: Acorde("Do7")).allSatisfy { $0.papel != .septimaDeLaEscala })
    }
}
