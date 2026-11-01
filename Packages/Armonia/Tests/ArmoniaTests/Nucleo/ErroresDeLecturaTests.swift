import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

/// Los errores al leer y sus mensajes en cada idioma.
@Suite struct ErroresDeLecturaTests {
    /// Comprueba que leer `texto` lanza el motivo indicado en la posición indicada.
    private func comprobar<T>(
        _ leer: @autoclosure () throws -> T, _ motivo: ErrorDeLectura.Motivo,
        posicion: Int?, sourceLocation: SourceLocation = #_sourceLocation
    ) {
        do {
            _ = try leer()
            Issue.record("Se esperaba un error", sourceLocation: sourceLocation)
        } catch {
            guard let error = error as? ErrorDeLectura else {
                Issue.record("Error inesperado: \(error)", sourceLocation: sourceLocation)
                return
            }
            #expect(error.motivo == motivo, sourceLocation: sourceLocation)
            #expect(error.posicion == posicion, sourceLocation: sourceLocation)

        }
    }

    @Test func acordes() throws {
        comprobar(try Acorde(leyendo: "Do7(b3)"), .tensionNoValida("b3"), posicion: 4)
        comprobar(try Acorde(leyendo: "Do7 9"), .numeroRepetido(9), posicion: 4)
        comprobar(try Acorde(leyendo: "Doxyz"), .simboloNoReconocido("yz"), posicion: 3)
        comprobar(try Acorde(leyendo: "Do/Xa"), .bajoNoValido("Xa"), posicion: 3)
        comprobar(try Acorde(leyendo: "Do8"), .numeroDeAcordeNoValido(8), posicion: 2)
        comprobar(try Acorde(leyendo: "Doomit1"), .gradoNoOmitible(1), posicion: 2)
        comprobar(try Acorde(leyendo: "Doadd3"), .tensionNoValida("3"), posicion: 5)
        comprobar(try Acorde(leyendo: "Hm7"), .notaNoReconocida, posicion: 0)
        comprobar(try Acorde(leyendo: "   "), .textoVacio, posicion: 0)
        do {
            _ = try Acorde(leyendo: "Dodimø")
            Issue.record("Se esperaba un error")
        } catch {
            guard case .calidadesIncompatibles = (error as? ErrorDeLectura)?.motivo else {
                Issue.record("\(error)")
                return
            }

        }
        do {
            _ = try Acorde(leyendo: "Dom5")
            Issue.record("Se esperaba un error")
        } catch {
            #expect((error as? ErrorDeLectura)?.posicion == nil)

        }
    }

    @Test func conjuntosNoInterpretables() throws {
        do {
            _ = try TipoDeAcorde(comprobandoPasosDeQuinta: [0, -3, 4])
            Issue.record("Se esperaba un error")
        } catch {
            #expect("\(error)".contains("tercera mayor y menor"), "\(error)")

        }
        do {
            _ = try TipoDeAcorde(comprobandoPasosDeQuinta: [0, 4, 7])
            Issue.record("Se esperaba un error")
        } catch {
            #expect("\(error)".contains("1ª aumentada no tiene papel"), "\(error)")

        }
        do {
            _ = try TipoDeAcorde(comprobandoPasosDeQuinta: [4, 1])
            Issue.record("Se esperaba un error")
        } catch {
            #expect("\(error)".contains("falta la fundamental"), "\(error)")

        }
        #expect(throws: Never.self) { try TipoDeAcorde(comprobandoPasosDeQuinta: [0, 4, 1]) }
    }

    @Test func notasIntervalosYEscalas() throws {
        comprobar(try Nota(leyendo: "Fa#4"), .caracteresSobrantes("4"), posicion: 3)
        comprobar(try Nota(leyendo: ""), .textoVacio, posicion: 0)
        comprobar(try Altura(leyendo: "Do"), .octavaNoValida(""), posicion: 2)
        comprobar(try Altura(leyendo: "Do4x"), .octavaNoValida("4x"), posicion: 2)
        comprobar(try Intervalo(leyendo: "5M"), .intervaloInexistente(numero: 5, calidad: .mayor), posicion: 0)
        comprobar(try Intervalo(leyendo: "3X"), .calidadNoValida("X"), posicion: 1)
        comprobar(try Intervalo(leyendo: "X3"), .numeroDeIntervaloNoValido("X3"), posicion: 0)
        comprobar(try Intervalo(leyendo: "M"), .numeroDeIntervaloNoValido(""), posicion: 1)
        comprobar(try Escala(leyendo: "Re dorian"), .tipoDeEscalaNoReconocido("dorian"), posicion: 3)
    }

    @Test func mensajes() throws {
        do {
            _ = try Acorde(leyendo: "Do7(b3)")
            Issue.record("Debería fallar")
        } catch {
            #expect(
                "\(error)".hasPrefix("No se puede leer «Do7(b3)» (carácter 5): «b3» no es una tensión válida"),
                "\(error)")
        }
        let error = ErrorDeLectura(texto: "5M", posicion: 0, motivo: .intervaloInexistente(numero: 5, calidad: .mayor))
        #expect(error.explicacion.contains("justas, aumentadas o disminuidas"))
    }

    @Test func decodificacionConMensaje() throws {
        do {
            _ = try JSONDecoder().decode([Acorde].self, from: Data("[\"Doxyz\"]".utf8))
            Issue.record("Se esperaba un error")
        } catch {
            guard case DecodingError.dataCorrupted(let contexto) = error else {
                Issue.record("\(error)")
                return
            }
            #expect(contexto.debugDescription.contains("«yz»"), Comment(rawValue: contexto.debugDescription))

        }
    }

    @Test func mensajesEnIngles() throws {
        do {
            _ = try Acorde(leyendo: "Do7(b3)")
            Issue.record("Se esperaba un error")
        } catch {
            let error = error as! ErrorDeLectura
            #expect(
                error.descripcion(en: .inglesASCII)
                    == ("Cannot read \"Do7(b3)\" (character 5): \"b3\" is not a valid tension "
                        + "(♭/♯ go with 5, 9, 11 and 13, and add with 2, 4, 6, 9, 11 and 13)"))
            #expect(error.descripcion(en: .espanolCompacto) == error.description)
            // El idioma lo da la notación.
            #expect(
                error.descripcion(en: .aleman)
                    == ("„Do7(b3)“ kann nicht gelesen werden (Zeichen 5): „b3“ ist keine gültige Tension "
                        + "(♭/♯ gehen mit 5, 9, 11 und 13, add mit 2, 4, 6, 9, 11 und 13)"))
            #expect(
                error.descripcion(en: .portugues)
                    == ("Não é possível ler «Do7(b3)» (caractere 5): «b3» não é uma tensão válida "
                        + "(admitem-se ♭/♯ com 5, 9, 11 e 13, e add com 2, 4, 6, 9, 11 e 13)"))
            #expect(
                error.descripcion(en: .frances)
                    == ("Impossible de lire « Do7(b3) » (caractère 5) : « b3 » n'est pas une tension valide "
                        + "(♭/♯ s'emploient avec 5, 9, 11 et 13, et add avec 2, 4, 6, 9, 11 et 13)"))
            #expect(
                error.descripcion(en: .italiano)
                    == ("Impossibile leggere «Do7(b3)» (carattere 5): «b3» non è una tensione valida "
                        + "(si ammettono ♭/♯ con 5, 9, 11 e 13, e add con 2, 4, 6, 9, 11 e 13)"))
            #expect(
                error.descripcion(en: .catalan)
                    == ("No es pot llegir «Do7(b3)» (caràcter 5): «b3» no és una tensió vàlida "
                        + "(s'admeten ♭/♯ amb 5, 9, 11 i 13, i add amb 2, 4, 6, 9, 11 i 13)"))
            #expect(
                error.descripcion(en: .gallego)
                    == ("Non se pode ler «Do7(b3)» (carácter 5): «b3» non é unha tensión válida "
                        + "(admítense ♭/♯ con 5, 9, 11 e 13, e add con 2, 4, 6, 9, 11 e 13)"))
            #expect(
                error.descripcion(en: .euskera)
                    == ("Ezin da «Do7(b3)» irakurri (5. karakterea): «b3» ez da tentsio baliozkoa "
                        + "(♭/♯ 5, 9, 11 eta 13rekin onartzen dira, eta add 2, 4, 6, 9, 11 eta 13rekin)"))

        }
        do {
            _ = try Intervalo(leyendo: "5M")
            Issue.record("Se esperaba un error")
        } catch {
            #expect(
                (error as! ErrorDeLectura).explicacion(en: .inglesASCII)
                    == "there is no major 5th: unisons, 4ths, 5ths and octaves are perfect, augmented or diminished")

        }
        do {
            _ = try TipoDeAcorde(comprobandoPasosDeQuinta: [0, 7])
            Issue.record("Se esperaba un error")
        } catch {
            #expect(
                (error as! ErrorDeLectura).explicacion(en: .inglesASCII)
                    == "the augmented unison has no role in a tertian chord")

        }
        #expect(
            ErrorDeLectura(texto: "", posicion: nil, motivo: .textoVacio).descripcion(en: .inglesASCII)
                == "Invalid value: the text is empty")
        #expect(
            [1, 2, 3, 4, 11, 12, 13, 21, 22].map { Intervalo.ordinalEnCifras($0, en: .ingles) } == [
                "1st", "2nd", "3rd", "4th", "11th", "12th", "13th", "21st", "22nd",
            ])
    }

    private static let motivos: [ErrorDeLectura.Motivo] = [
        .textoVacio, .notaNoReconocida, .caracteresSobrantes("x"), .octavaNoValida(""), .octavaNoValida("x"),
        .numeroDeIntervaloNoValido(""), .numeroDeIntervaloNoValido("x"), .calidadNoValida(""),
        .calidadNoValida("X"), .intervaloInexistente(numero: 1, calidad: .disminuida(1)),
        .intervaloInexistente(numero: 3, calidad: .justa), .simboloNoReconocido("x"), .tensionNoValida("b3"),
        .numeroDeAcordeNoValido(8), .numeroRepetido(9), .calidadesIncompatibles(.disminuidoYSemidisminuido),
        .calidadesIncompatibles(.quintaConCalidad), .gradoNoOmitible(1), .gradoNoOmitible(2),
        .acordeNoInterpretable(.faltaLaFundamental), .acordeNoInterpretable(.intervaloSinPapel(.unisonoAumentado)),
        .acordeNoInterpretable(.terceraMayorYMenor), .acordeNoInterpretable(.variasSeptimas),
        .acordeNoInterpretable(.septimaDisminuidaFueraDelDisminuido), .acordeNoInterpretable(.noEsPorTerceras),
        .bajoNoValido("x"), .idiomasMezclados("B"), .tipoDeEscalaNoReconocido(""),
        .tipoDeEscalaNoReconocido("x"), .modoNoReconocido("dórico"), .alteracionNoReconocida("?"),
        .duracionNoValida("x"), .compasNoValido("x"), .vocesDistintas, .contrapuntoDeOtraDuracion(redondas: 8),
    ]

    /// Todos los motivos tienen explicación en inglés, y la inglesa no lleva texto en español.
    @Test func todosLosMotivosEnLosDosIdiomas() {
        let motivos = Self.motivos
        let espanol = ["el ", "la ", " no ", "falta", "sobra", "se esperaba", "tiene", "texto"]
        for motivo in motivos {
            let error = ErrorDeLectura(texto: "x", posicion: 0, motivo: motivo)
            let ingles = error.explicacion(en: .inglesASCII)
            #expect(!ingles.isEmpty, "\(motivo)")
            #expect(ingles != error.explicacion, "\(motivo)")
            #expect(!ingles.contains("«"), "\(motivo): \(ingles)")
            for palabra in espanol where ingles.hasPrefix(palabra) || ingles.contains(" " + palabra) {
                Issue.record("\(motivo): «\(palabra)» en «\(ingles)»")
            }
        }
    }

    /// Todos los motivos tienen explicación en catalán, gallego, euskera, portugués, francés e
    /// italiano, con los mismos datos entre comillas latinas que la española.
    @Test func todosLosMotivosEnCatalanGallegoEuskera() throws {
        let comillas = try NSRegularExpression(pattern: "«[^»]*»")
        func citas(_ texto: String) -> [String] {
            comillas.matches(in: texto, range: NSRange(texto.startIndex..., in: texto))
                .map { String(texto[Range($0.range, in: texto)!]) }
                // En francés, las comillas llevan espacios: « x ».
                .map { "«" + $0.dropFirst().dropLast().trimmingCharacters(in: .whitespaces) + "»" }
        }
        for motivo in Self.motivos {
            let error = ErrorDeLectura(texto: "x", posicion: 0, motivo: motivo)
            let espanol = error.explicacion
            for notacion in [Notacion.catalan, .gallego, .euskera, .portugues, .frances, .italiano] {
                let texto = error.explicacion(en: notacion)
                #expect(!texto.isEmpty, "\(motivo) \(notacion)")
                #expect(Set(citas(texto)) == Set(citas(espanol)), "\(motivo) \(notacion): \(texto)")
            }
            for notacion in [Notacion.euskera, .frances, .italiano] {
                #expect(error.explicacion(en: notacion) != espanol, "\(motivo) \(notacion)")
            }
        }
        #expect(
            ErrorDeLectura(texto: "", posicion: nil, motivo: .textoVacio).descripcion(en: .gallego)
                == "Valor non válido: o texto está baleiro")
        #expect(
            ErrorDeLectura(texto: "x", posicion: nil, motivo: .intervaloInexistente(numero: 5, calidad: .mayor))
                .explicacion(en: .euskera)
                == "5. handia ez da existitzen: unisonoa, 4.a, 5.a eta 8.a justuak, gehituak edo gutxituak dira")
    }

    @Test func losFallablesSiguenDevolviendoNil() {
        #expect(Acorde(texto: "Do7(b3)") == nil)
        #expect(Nota(texto: "Fa#4") == nil)
        #expect(Intervalo(texto: "5M") == nil)
        #expect(Escala(texto: "Re dorian") == nil)
    }

    @Test func lecturaYErrores() throws {
        #expect(throws: Never.self) { try Acorde(leyendo: "Sol7") }
        do {
            _ = try Acorde(leyendo: "Do7(b3)")
            Issue.record("Se esperaba un error")
        } catch {
            #expect((error as? ErrorDeLectura)?.motivo == .tensionNoValida("b3"))

        }
    }
}
