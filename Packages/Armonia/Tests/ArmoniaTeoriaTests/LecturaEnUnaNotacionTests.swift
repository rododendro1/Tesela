import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// Lo que escriben `cifrado(en:)` y `nombre(en:)` se lee de vuelta con `leyendo:en:`, en los quince idiomas.
@Suite struct LecturaEnUnaNotacionTests {
    static let notaciones = Idioma.allCases.flatMap { [Notacion.compacta($0), .conPalabras($0)] }
    static let tonicas = (-7...7).map { Nota(pasosDeQuinta: $0) }

    @Test(arguments: notaciones) func losAcordesDeIdaYVuelta(_ notacion: Notacion) {
        for fundamental in Self.tonicas {
            for tipo in TipoDeAcorde.todos {
                var acordes = [Acorde(fundamental, tipo), Acorde(fundamental, tipo, inversion: 1)]
                if tipo == .dominanteSeptima {
                    acordes.append(Acorde(fundamental, tipo, bajo: fundamental + .segundaMayor))
                }
                for acorde in acordes {
                    let texto = acorde.cifrado(en: notacion)
                    #expect((try? Acorde(leyendo: texto, en: notacion)) == acorde, "«\(texto)» en \(notacion)")
                }
            }
        }
    }

    @Test(arguments: notaciones) func lasEscalasDeIdaYVuelta(_ notacion: Notacion) {
        for tonica in Self.tonicas {
            for tipo in TipoDeEscala.occidentales {
                let escala = Escala(tonica, tipo)
                let texto = escala.nombre(en: notacion)
                let leida = try? Escala(leyendo: texto, en: notacion)
                #expect(leida?.tonica == tonica && leida?.tipo.esIdentico(a: tipo) == true, "«\(texto)» en \(notacion)")
            }
        }
    }

    @Test(arguments: notaciones) func lasTonalidadesDeIdaYVuelta(_ notacion: Notacion) {
        for tonica in Self.tonicas {
            for modo in [Tonalidad.Modo.mayor, .menor] {
                let tonalidad = Tonalidad(tonica, modo)
                let texto = tonalidad.nombre(en: notacion)
                #expect((try? Tonalidad(leyendo: texto, en: notacion)) == tonalidad, "«\(texto)» en \(notacion)")
            }
        }
    }

    /// Sin la notación, «B» es Si en inglés; en alemán y en húngaro es Si♭.
    @Test func laBAlemana() throws {
        #expect(try Acorde(leyendo: "B7/D", en: .compacta(.aleman)) == Acorde("Sib7/Re"))
        #expect(try Acorde(leyendo: "H7", en: .compacta(.aleman)) == Acorde("Si7"))
        #expect(try Acorde(leyendo: "Asus4", en: .compacta(.aleman)) == Acorde("Lasus4"))
        #expect(try Acorde(leyendo: "As6/9", en: .compacta(.aleman)) == Acorde("Lab6/9"))
        #expect(try Escala(leyendo: "B dorisch", en: .compacta(.aleman)) == Escala("Sib dórico"))
        #expect(try Tonalidad(leyendo: "B-Dur", en: .compacta(.aleman)) == Tonalidad("Sib mayor"))
        #expect(try Acorde(leyendo: "Rém7", en: .compacta(.frances)) == Acorde("Rem7"))
        #expect(try Escala(leyendo: "re dorian", en: .conPalabras(.occitano)) == Escala("Re dórico"))
        #expect(try Nota(leyendo: "Mi𝄫", en: .compacta(.catalan)) == Nota(.mi, .dobleBemol))
    }

    @Test func losErrores() {
        #expect(throws: ErrorDeLectura.self) { try Acorde(leyendo: "", en: .compacta(.aleman)) }
        #expect(throws: (any Error).self) { try Acorde(leyendo: "Xm7", en: .compacta(.aleman)) }
        #expect(throws: ErrorDeLecturaDeTeoria.self) { try Escala(leyendo: "D blabla", en: .compacta(.aleman)) }
        #expect(throws: ErrorDeLecturaDeTeoria.self) { try Tonalidad(leyendo: "D-blabla", en: .compacta(.aleman)) }
        // En español e inglés, como sin notación.
        #expect((try? Acorde(leyendo: "Bb7", en: .inglesCompacto)) == Acorde("Sib7"))
    }
}
