import Foundation
import Testing

@testable import Elementos
@testable import Partituras
@testable import Teoria

/// Los errores al leer y sus mensajes en cada idioma.
@Suite struct ErroresDeLecturaTests {
    /// Comprueba que leer `texto` lanza el motivo indicado en la posición indicada.
    private func comprobar<T>(
        _ leer: @autoclosure () throws -> T, _ motivo: ErrorDeLectura.Motivo,
        posicion: Int?, sourceLocation: SourceLocation = #_sourceLocation
    ) {
        comprobar(try leer(), ErrorDeLectura.self, motivo, posicion: posicion, sourceLocation: sourceLocation)
    }

    /// Lo mismo con un motivo de Teoría.
    private func comprobar<T>(
        _ leer: @autoclosure () throws -> T, _ motivo: ErrorDeLecturaDeTeoria.Motivo,
        posicion: Int?, sourceLocation: SourceLocation = #_sourceLocation
    ) {
        comprobar(try leer(), ErrorDeLecturaDeTeoria.self, motivo, posicion: posicion, sourceLocation: sourceLocation)
    }

    private func comprobar<T, E: ErrorAlLeer>(
        _ leer: @autoclosure () throws -> T, _ tipo: E.Type, _ motivo: E.Motivo,
        posicion: Int?, sourceLocation: SourceLocation
    ) {
        do {
            _ = try leer()
            Issue.record("Se esperaba un error", sourceLocation: sourceLocation)
        } catch {
            guard let error = error as? E else {
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
        comprobar(try Acorde(leyendo: "Hm7"), .elementos(.notaNoReconocida), posicion: 0)
        comprobar(try Acorde(leyendo: "   "), .elementos(.textoVacio), posicion: 0)
        do {
            _ = try Acorde(leyendo: "Dodimø")
            Issue.record("Se esperaba un error")
        } catch {
            guard case .calidadesIncompatibles = error.motivo else {
                Issue.record("\(error)")
                return
            }

        }
        do {
            _ = try Acorde(leyendo: "Dom5")
            Issue.record("Se esperaba un error")
        } catch {
            #expect(error.posicion == nil)

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
            let error = error
            #expect(
                error.descripcion(en: .ascii(.ingles))
                    == ("Cannot read \"Do7(b3)\" (character 5): \"b3\" is not a valid tension "
                        + "(♭/♯ go with 5, 9, 11 and 13, and add with 2, 4, 6, 9, 11 and 13)"))
            #expect(error.descripcion(en: .compacta(.espanol)) == error.description)
            // El idioma lo da la notación.
            #expect(
                error.descripcion(en: .conPalabras(.aleman))
                    == ("„Do7(b3)“ kann nicht gelesen werden (Zeichen 5): „b3“ ist keine gültige Tension "
                        + "(♭/♯ gehen mit 5, 9, 11 und 13, add mit 2, 4, 6, 9, 11 und 13)"))
            #expect(
                error.descripcion(en: .conPalabras(.portugues))
                    == ("Não é possível ler «Do7(b3)» (caractere 5): «b3» não é uma tensão válida "
                        + "(admitem-se ♭/♯ com 5, 9, 11 e 13, e add com 2, 4, 6, 9, 11 e 13)"))
            #expect(
                error.descripcion(en: .conPalabras(.frances))
                    == ("Impossible de lire « Do7(b3) » (caractère 5) : « b3 » n'est pas une tension valide "
                        + "(♭/♯ s'emploient avec 5, 9, 11 et 13, et add avec 2, 4, 6, 9, 11 et 13)"))
            #expect(
                error.descripcion(en: .conPalabras(.italiano))
                    == ("Impossibile leggere «Do7(b3)» (carattere 5): «b3» non è una tensione valida "
                        + "(si ammettono ♭/♯ con 5, 9, 11 e 13, e add con 2, 4, 6, 9, 11 e 13)"))
            #expect(
                error.descripcion(en: .conPalabras(.catalan))
                    == ("No es pot llegir «Do7(b3)» (caràcter 5): «b3» no és una tensió vàlida "
                        + "(s'admeten ♭/♯ amb 5, 9, 11 i 13, i add amb 2, 4, 6, 9, 11 i 13)"))
            #expect(
                error.descripcion(en: .conPalabras(.gallego))
                    == ("Non se pode ler «Do7(b3)» (carácter 5): «b3» non é unha tensión válida "
                        + "(admítense ♭/♯ con 5, 9, 11 e 13, e add con 2, 4, 6, 9, 11 e 13)"))
            #expect(
                error.descripcion(en: .conPalabras(.euskera))
                    == ("Ezin da «Do7(b3)» irakurri (5. karakterea): «b3» ez da tentsio baliozkoa "
                        + "(♭/♯ 5, 9, 11 eta 13rekin onartzen dira, eta add 2, 4, 6, 9, 11 eta 13rekin)"))

        }
        do {
            _ = try Intervalo(leyendo: "5M")
            Issue.record("Se esperaba un error")
        } catch {
            #expect(
                error.explicacion(en: .ascii(.ingles))
                    == "there is no major 5th: unisons, 4ths, 5ths and octaves are perfect, augmented or diminished")

        }
        do {
            _ = try TipoDeAcorde(comprobandoPasosDeQuinta: [0, 7])
            Issue.record("Se esperaba un error")
        } catch {
            #expect(
                error.explicacion(en: .ascii(.ingles))
                    == "the augmented unison has no role in a tertian chord")

        }
        #expect(
            ErrorDeLectura(texto: "", posicion: nil, motivo: .textoVacio).descripcion(en: .ascii(.ingles))
                == "Invalid value: the text is empty")
        #expect(
            [1, 2, 3, 4, 11, 12, 13, 21, 22].map { Intervalo.ordinalEnCifras($0, en: .ingles) } == [
                "1st", "2nd", "3rd", "4th", "11th", "12th", "13th", "21st", "22nd",
            ])
    }

    /// Un motivo de cada caso de Elementos.
    private static let motivosDeElementos: [ErrorDeLectura.Motivo] = [
        .textoVacio, .notaNoReconocida, .caracteresSobrantes("x"), .octavaNoValida(""), .octavaNoValida("x"),
        .numeroDeIntervaloNoValido(""), .numeroDeIntervaloNoValido("x"), .calidadNoValida(""),
        .calidadNoValida("X"), .intervaloInexistente(numero: 1, calidad: .disminuida(1)),
        .intervaloInexistente(numero: 3, calidad: .justa), .alteracionNoReconocida("?"),
        .claseDeAlturaNoValida("x"), .numeroDeForteDesconocido("3-13"), .faltaElCierre("]"),
        .serieNoDodecafonica(faltan: [2], repetidas: [1]), .serieNoDodecafonica(faltan: [], repetidas: []),
        .idiomaNoReconocido("x", opciones: ["es", "en"]),
    ]

    /// Un motivo de cada caso de Teoría que es de la propia capa (sin `.elementos`).
    private static let motivosDeTeoria: [ErrorDeLecturaDeTeoria.Motivo] = [
        .simboloNoReconocido("x"), .tensionNoValida("b3"), .numeroDeAcordeNoValido(8), .numeroRepetido(9),
        .calidadesIncompatibles(.disminuidoYSemidisminuido), .calidadesIncompatibles(.quintaConCalidad),
        .gradoNoOmitible(1), .gradoNoOmitible(2), .acordeNoInterpretable(.faltaLaFundamental),
        .acordeNoInterpretable(.intervaloSinPapel(.unisonoAumentado)), .acordeNoInterpretable(.terceraMayorYMenor),
        .acordeNoInterpretable(.variasSeptimas), .acordeNoInterpretable(.septimaDisminuidaFueraDelDisminuido),
        .acordeNoInterpretable(.noEsPorTerceras), .bajoNoValido("x"), .idiomasMezclados("B"),
        .tipoDeEscalaNoReconocido(""), .tipoDeEscalaNoReconocido("x"), .modoNoReconocido("dórico"),
        .vocesDistintas, .vocesDeDistintaLongitud, .nombreNoReconocido("x", opciones: ["up", "down"]),
        .numeroFueraDeRango("x", desde: 1, hasta: 22),
        .trasteNoValido("x", ultimo: 12), .trasteQueNoTiene("x"), .cuerdasDistintas(esperadas: 6, leidas: 5),
        .cifradoRomanoNoValido("x"), .destinoNoTonicalizable("vii°"), .cifrasNoValidas("x"),
        .cifrasSinAcorde("x"),
    ]

    /// Un error de cada motivo, de las tres capas.
    private static let errores: [any ErrorAlLeer] =
        motivosDeElementos.map { ErrorDeLectura(texto: "x", posicion: 0, motivo: $0) }
        + (motivosDeTeoria + [.elementos(.notaNoReconocida)]).map {
            ErrorDeLecturaDeTeoria(texto: "x", posicion: 0, motivo: $0)
        }
        + [ErrorDeLecturaDePartitura.Motivo]([
            .duracionNoValida("x"), .compasNoValido("x"), .contrapuntoDeOtraDuracion(redondas: 8), .melodiaSinNotas,
            .elementos(.notaNoReconocida), .teoria(.tensionNoValida("b3")),
        ]).map { ErrorDeLecturaDePartitura(texto: "x", posicion: 0, motivo: $0) }

    /// Cada lectura lanza el error de su capa, con el motivo de la de debajo dentro y su mismo mensaje.
    @Test func elErrorDeLaCapaDeDebajo() throws {
        let nota = ErrorDeLectura(texto: "Hm7", posicion: 0, motivo: .notaNoReconocida)
        let deTeoria = ErrorDeLecturaDeTeoria(nota)
        #expect(deTeoria.motivo == .elementos(.notaNoReconocida))
        #expect(deTeoria.posicion == 0 && deTeoria.texto == "Hm7")
        for idioma in Idioma.allCases {
            #expect(deTeoria.descripcion(en: .compacta(idioma)) == nota.descripcion(en: .compacta(idioma)))
        }
        // En Partituras, la nota de un cifrado sigue siendo de Elementos, y lo demás del cifrado, de Teoría.
        #expect(ErrorDeLecturaDePartitura(deTeoria).motivo == .elementos(.notaNoReconocida))
        let tension = ErrorDeLecturaDeTeoria(texto: "Do7(b3)", posicion: 4, motivo: .tensionNoValida("b3"))
        let enPartitura = ErrorDeLecturaDePartitura(tension)
        #expect(enPartitura.motivo == .teoria(.tensionNoValida("b3")))
        #expect(enPartitura.description == tension.description)
        #expect(throws: ErrorDeLecturaDePartitura(nota)) { try enPartituras(Altura(leyendo: "Hm7")) }
        #expect(throws: ErrorDeLecturaDeTeoria(nota)) { try enTeoria(Nota(leyendo: "Hm7")) }
        #expect(try enTeoria(Nota(leyendo: "Do")) == .do)
        #expect(throws: enPartitura) { try enPartituras(deTeoria: Acorde(leyendo: "Do7(b3)")) }
        #expect(try enPartituras(deTeoria: Acorde(leyendo: "Do")).cifrado == "Do")
    }

    /// Cada motivo tiene su identificador, el nombre de su caso, sin repetirse en su capa.
    @Test func cadaMotivoConSuIdentificador() {
        func comprobar(_ motivos: [some MotivoDeLectura]) {
            for motivo in motivos {
                #expect(String(describing: motivo).hasPrefix(motivo.identificador), "\(motivo)")
            }
            let identificadores = motivos.map(\.identificador)
            #expect(
                Set(identificadores).count == Set(motivos.map { String(describing: $0).prefix { $0 != "(" } }).count)
        }
        comprobar(Self.motivosDeElementos)
        comprobar(Self.motivosDeTeoria + [.elementos(.textoVacio)])
        comprobar([
            ErrorDeLecturaDePartitura.Motivo.duracionNoValida("x"), .compasNoValido("x"),
            .contrapuntoDeOtraDuracion(redondas: 8), .melodiaSinNotas, .elementos(.textoVacio),
            .teoria(.vocesDistintas),
        ])
        #expect(ErrorDeLecturaDePartitura.Motivo.teoria(.elementos(.notaNoReconocida)).identificador == "teoria")
        #expect(
            ErrorDeLecturaDePartitura.Motivo.teoria(.elementos(.notaNoReconocida)).motivoOriginal.identificador
                == "notaNoReconocida")
    }

    /// Cada motivo de una capa, dentro del de la capa de encima, se explica igual en los trece idiomas, y su
    /// `motivoOriginal` es él.
    @Test func cadaMotivoDeDebajoSeExplicaIgualEnCadaIdioma() {
        func igual<Dentro: MotivoDeLectura>(_ fuera: some MotivoDeLectura, _ dentro: Dentro) {
            #expect(fuera.motivoOriginal as? Dentro == dentro, "\(fuera)")
            for idioma in Idioma.allCases {
                for notacion in [Notacion.compacta(idioma), .conPalabras(idioma), .ascii(idioma)] {
                    #expect(fuera.explicacion(en: notacion) == dentro.explicacion(en: notacion), "\(fuera)")
                }
            }
        }
        for motivo in Self.motivosDeElementos {
            #expect(motivo.motivoDeDebajo == nil)
            igual(ErrorDeLecturaDeTeoria.Motivo.elementos(motivo), motivo)
            igual(ErrorDeLecturaDePartitura.Motivo.elementos(motivo), motivo)
            igual(ErrorDeLecturaDePartitura.Motivo.teoria(.elementos(motivo)), motivo)
        }
        for motivo in Self.motivosDeTeoria {
            #expect(motivo.motivoDeDebajo == nil && motivo.motivoOriginal as? ErrorDeLecturaDeTeoria.Motivo == motivo)
            igual(ErrorDeLecturaDePartitura.Motivo.teoria(motivo), motivo)
        }
        #expect(ErrorDeLecturaDePartitura.Motivo.duracionNoValida("x").motivoDeDebajo == nil)
    }

    /// Todos los motivos tienen explicación en inglés, y la inglesa no lleva texto en español.
    @Test func todosLosMotivosEnLosDosIdiomas() {
        let espanol = ["el ", "la ", " no ", "falta", "sobra", "se esperaba", "tiene", "texto"]
        for error in Self.errores {
            let motivo = error.motivo
            let ingles = error.explicacion(en: .ascii(.ingles))
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
        for error in Self.errores {
            let motivo = error.motivo
            let espanol = error.explicacion
            for notacion in [
                Notacion.conPalabras(.catalan), .conPalabras(.gallego), .conPalabras(.euskera),
                .conPalabras(.portugues), .conPalabras(.frances),
                .conPalabras(.italiano),
            ] {
                let texto = error.explicacion(en: notacion)
                #expect(!texto.isEmpty, "\(motivo) \(notacion)")
                #expect(Set(citas(texto)) == Set(citas(espanol)), "\(motivo) \(notacion): \(texto)")
            }
            for notacion in [Notacion.conPalabras(.euskera), .conPalabras(.frances), .conPalabras(.italiano)] {
                #expect(error.explicacion(en: notacion) != espanol, "\(motivo) \(notacion)")
            }
        }
        #expect(
            ErrorDeLectura(texto: "", posicion: nil, motivo: .textoVacio).descripcion(en: .conPalabras(.gallego))
                == "Valor non válido: o texto está baleiro")
        #expect(
            ErrorDeLectura(texto: "x", posicion: nil, motivo: .intervaloInexistente(numero: 5, calidad: .mayor))
                .explicacion(en: .conPalabras(.euskera))
                == "5. handia ez da existitzen: unisonoa, 4.a, 5.a eta 8.a justuak, gehituak edo gutxituak dira")
    }

    @Test func losFallablesSiguenDevolviendoNil() {
        #expect((try? Acorde(leyendo: "Do7(b3)")) == nil)
        #expect((try? Nota(leyendo: "Fa#4")) == nil)
        #expect((try? Intervalo(leyendo: "5M")) == nil)
        #expect((try? Escala(leyendo: "Re dorian")) == nil)
    }

    @Test func lecturaYErrores() throws {
        #expect(throws: Never.self) { try Acorde(leyendo: "Sol7") }
        do {
            _ = try Acorde(leyendo: "Do7(b3)")
            Issue.record("Se esperaba un error")
        } catch {
            #expect(error.motivo == .tensionNoValida("b3"))

        }
    }
}
