import XCTest
@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaTeoria
@testable import ArmoniaRepresentaciones
@testable import ArmoniaPartitura

final class NotacionInternacionalTests: XCTestCase {
    func testNotas() {
        XCTAssertEqual(Nota("Fa#").nombre(en: .inglesASCII), "F#")
        XCTAssertEqual(Nota("Fa#").nombre(en: .inglesUnicode), "F♯")
        XCTAssertEqual(Nota("Sibb").nombre(en: .inglesUnicode), "B♭♭")
        XCTAssertEqual(Nota("B♭"), Nota("Sib"))
        XCTAssertEqual(Altura("C#4"), Altura("Do#4"))
        XCTAssertEqual(Altura("Sib3").nombre(en: .inglesASCII), "Bb3")
        XCTAssertEqual(Altura("Sib3").nombre(en: .inglesUnicode), "B♭3")
        XCTAssertEqual(Altura("B♭3"), Altura("Sib3"))
    }

    func testIntervalos() {
        XCTAssertEqual(Intervalo.terceraMayor.abreviatura(en: .inglesASCII), "M3")
        XCTAssertEqual(Intervalo.quintaJusta.abreviatura(en: .inglesASCII), "P5")
        XCTAssertEqual((-Intervalo.cuartaAumentada).abreviatura(en: .inglesASCII), "-A4")
        XCTAssertEqual(Intervalo("M3"), .terceraMayor)
        XCTAssertEqual(Intervalo("P8"), .octava)
        XCTAssertEqual(Intervalo("-m3"), -Intervalo.terceraMenor)
        XCTAssertEqual(Intervalo("AA4"), Intervalo(numero: 4, calidad: .aumentada(2)))
        XCTAssertEqual(Intervalo("dd5"), Intervalo(numero: 5, calidad: .disminuida(2)))

        XCTAssertEqual(Intervalo.terceraMayor.nombre(en: .inglesASCII), "major third")
        XCTAssertEqual(Intervalo.quintaJusta.nombre(en: .inglesASCII), "perfect fifth")
        XCTAssertEqual(Intervalo.octava.nombre(en: .inglesASCII), "perfect octave")
        XCTAssertEqual(Intervalo.unisonoAumentado.nombre(en: .inglesASCII), "augmented unison")
        XCTAssertEqual(Intervalo.novenaMenor.nombre(en: .inglesASCII), "minor ninth")
        XCTAssertEqual((-Intervalo.sextaMenor).nombre(en: .inglesASCII), "descending minor sixth")
        XCTAssertEqual(Intervalo(numero: 4, calidad: .aumentada(2))!.nombre(en: .inglesASCII), "doubly augmented fourth")
        XCTAssertEqual(Intervalo.ordinal(21, en: .ingles), "21st")
        XCTAssertEqual(Intervalo.ordinal(22, en: .ingles), "22nd")
        XCTAssertEqual(Intervalo.ordinal(23, en: .ingles), "23rd")
        XCTAssertEqual(Intervalo.ordinal(111, en: .ingles), "111th")
    }

    func testEscalas() {
        XCTAssertEqual(Escala("D dorian"), Escala("Re dórico"))
        XCTAssertEqual(Escala("Bb harmonic minor"), Escala(Nota("Sib"), .menorArmonica))
        XCTAssertEqual(Escala("A minor").tipo, .menorNatural)
        XCTAssertEqual(Escala("F# whole-tone").tipo, .tonosEnteros)
        XCTAssertEqual(Escala("C Major Pentatonic").tipo, .pentatonicaMayor)
        XCTAssertEqual(Escala(.re, .dorico).nombre(en: .inglesASCII), "D dorian")
        XCTAssertEqual(Escala("Mib menor armónica").nombre(en: .inglesUnicode), "E♭ harmonic minor")
        XCTAssertEqual(Escala(.do, TipoDeEscala.pentatonicaMayor.rotacion(3)).nombre(en: .inglesASCII),
                       "C pentatónica mayor, modo 3")
        XCTAssertEqual(Escala(.do, TipoDeEscala.pentatonicaMayor.rotacion(2)).nombre(en: .inglesASCII), "C Egyptian")
        for tipo in TipoDeEscala.todos {
            let escala = Escala("F#", tipo)
            XCTAssertEqual(Escala(texto: escala.nombre(en: .inglesASCII)), escala, escala.nombre(en: .inglesASCII))
            XCTAssertEqual(Escala(texto: escala.nombre(en: .inglesUnicode)), escala)
        }
    }

    func testAcordes() {
        let acorde: Acorde = "Sol7/Si"
        XCTAssertEqual(acorde.cifrado(en: .inglesASCII), "G7/B")
        XCTAssertEqual(acorde.nombre(en: .inglesASCII), "G dominant seventh, first inversion")
        XCTAssertEqual(Acorde("Do/Re").nombre(en: .inglesASCII), "C major over D")
        XCTAssertEqual(Acorde("Sib7(b9)/Re").cifrado(estilo: .inglesUnicode), "B♭7(♭9)/D")
        XCTAssertEqual(Acorde("B♭7(♭9)/D"), Acorde("Sib7(b9)/Re"))
        XCTAssertEqual(TipoDeAcorde.semidisminuido.nombre(en: .inglesASCII), "half-diminished seventh")
        XCTAssertEqual(TipoDeAcorde("7(b9,#11)").nombre(en: .inglesASCII), "7(b9,#11) chord")
        // " chord" solo lo añaden los tipos sin nombre conocido; "power chord" es el nombre propio.
        for tipo in TipoDeAcorde.todos where tipo != .potencia {
            XCTAssertFalse(tipo.nombre(en: .inglesASCII).hasSuffix(" chord"), tipo.nombre)
        }
    }

    func testNotacionUnica() {
        XCTAssertEqual(Notacion(escritura: EscrituraDeNotas(idioma: .espanol, ascii: true)), .espanolASCII)
        XCTAssertEqual(Notacion(escritura: EscrituraDeNotas(idioma: .ingles, ascii: false)), .inglesUnicode)
        XCTAssertEqual(Notacion.inglesASCII.idiomaDeLasNotas, .ingles)
        XCTAssertTrue(Notacion.inglesASCII.usaASCII)
        XCTAssertFalse(Notacion.espanolUnicode.usaASCII)

        let escala: Escala = "Fa# dórico"
        XCTAssertEqual(escala.nombre(en: .espanolUnicode), "Fa♯ dórico")
        XCTAssertEqual(escala.nombre(en: .espanolASCII), "Fa# dórico")
        XCTAssertEqual(escala.nombre(en: .inglesASCII), "F# dorian")
        XCTAssertEqual(escala.nombre(en: .inglesUnicode), "F♯ dorian")
        XCTAssertEqual(Altura("Sib3").nombre(en: .inglesUnicode), "B♭3")
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: .inglesUnicode), "G dominant seventh, first inversion")
        XCTAssertEqual(Acorde("Fa#7").nombre(en: .inglesUnicode), "F♯ dominant seventh, root position")
        XCTAssertEqual(Intervalo.quintaJusta.abreviatura(en: .inglesASCII), "P5")
        XCTAssertEqual(Intervalo.quintaJusta.abreviatura(en: .espanolUnicode), "5J")
    }

    /// Las notas en una notación y los textos en otro idioma.
    func testNotasYTextosPorSeparado() {
        let rusoEnEspanol = Notacion.ruso.conTextos(en: .espanol)
        XCTAssertEqual(rusoEnEspanol, Notacion(escritura: .ruso, textos: .espanol))
        XCTAssertEqual(rusoEnEspanol.idiomaDeLasNotas, .ruso)
        XCTAssertEqual(rusoEnEspanol.textos, .espanol)
        XCTAssertEqual(rusoEnEspanol.notas, .ruso)
        XCTAssertEqual(rusoEnEspanol.escritura, .ruso)
        XCTAssertEqual(rusoEnEspanol.textos, .espanol)
        XCTAssertTrue(rusoEnEspanol.esCombinada)
        XCTAssertFalse(Notacion.ruso.esCombinada)
        XCTAssertEqual(Notacion.ruso.textos, .ruso)
        XCTAssertEqual(Notacion(escritura: .aleman, textos: .aleman), .aleman)
        XCTAssertEqual(Notacion.allCases.map(\.escritura), EscrituraDeNotas.allCases)
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: rusoEnEspanol), "соль séptima de dominante, primera inversión")
        XCTAssertEqual(Acorde("Sol7/La").nombre(en: rusoEnEspanol), "соль séptima de dominante, con bajo en ля")
        XCTAssertEqual(Acorde("Fa#m7").cifrado(en: rusoEnEspanol), "Фа♯m7")
        XCTAssertEqual(Tonalidad("Fa# mayor").nombre(en: rusoEnEspanol), "фа-диез мажор")
        XCTAssertEqual(Intervalo.terceraMayor.nombre(en: rusoEnEspanol), "3ª mayor")
        XCTAssertEqual(Intervalo.quintaJusta.abreviatura(en: rusoEnEspanol), "5J")
        XCTAssertEqual(try Nota(leyendo: "фа-диез", en: rusoEnEspanol), Nota("Fa#"))
        XCTAssertEqual(try Altura(leyendo: "фа-диез3", en: rusoEnEspanol), Altura("Fa#3"))
        // Letras inglesas con textos en euskera; sílabas con textos en inglés.
        let inglesEnEuskera = Notacion.inglesASCII.conTextos(en: .euskera)
        XCTAssertEqual(Acorde("Sol7").nombre(en: inglesEnEuskera), "G dominanteko zazpigarrena, oinarrizko egoera")
        XCTAssertEqual(Escala(.re, .dorico).nombre(en: inglesEnEuskera), "D doriarra")
        XCTAssertEqual(Acorde("Sol7").nombre(en: Notacion.espanolUnicode.conTextos(en: .ingles)),
                       "Sol dominant seventh, root position")
        XCTAssertEqual(Tonalidad("Fa# mayor").nombre(en: Notacion.aleman.conTextos(en: .frances)), "Fis-Dur")
        XCTAssertEqual(Acorde("Sib7").cifrado(en: Notacion.aleman.conTextos(en: .frances)), "B7")
        // Si el idioma ya es el de los textos, la notación queda simple; no se anidan.
        XCTAssertEqual(Notacion.catalan.conTextos(en: .catalan), .catalan)
        XCTAssertEqual(Notacion.aleman.conTextos(en: .aleman), .aleman)
        XCTAssertEqual(Notacion.griego.conTextos(en: .griego), .griego)
        XCTAssertTrue(Notacion.griego.conTextos(en: .ingles).esCombinada)
        XCTAssertEqual(rusoEnEspanol.conTextos(en: .frances), Notacion(escritura: .ruso, textos: .frances))
        XCTAssertEqual(rusoEnEspanol.conTextos(en: .ruso), .ruso)
        XCTAssertFalse(Notacion.allCases.contains(rusoEnEspanol))
        // Los mensajes de error.
        do {
            _ = try Acorde(leyendo: "Do7(b3)")
            XCTFail("Do7(b3) no es un cifrado válido")
        } catch let error as ErrorDeLectura {
            XCTAssertEqual(error.descripcion(en: Notacion.inglesASCII.conTextos(en: .espanol)), error.description)
        } catch {
            XCTFail("\(error)")
        }
    }

    /// Las escalas se leen también con la tónica y el tipo en francés, italiano, griego o ruso.
    func testEscalasEnOtrasLenguas() {
        XCTAssertEqual(Escala(texto: "ré dorien"), Escala(.re, .dorico))
        XCTAssertEqual(Escala(texto: "fa dièse lydien"), Escala(Nota("Fa#"), .lidio))
        XCTAssertEqual(Escala(texto: "si bémol mineur harmonique"), Escala(Nota("Sib"), .menorArmonica))
        XCTAssertEqual(Escala(texto: "fa diesis lidio"), Escala(Nota("Fa#"), .lidio))
        XCTAssertEqual(Escala(texto: "si bemolle minore melodica"), Escala(Nota("Sib"), .menorMelodica))
        XCTAssertEqual(Escala(texto: "ре дорийский"), Escala(.re, .dorico))
        XCTAssertEqual(Escala(texto: "ля гармонический минор"), Escala(.la, .menorArmonica))
        XCTAssertEqual(Escala(texto: "фа-диез минорная пентатоника"), Escala(Nota("Fa#"), .pentatonicaMenor))
        XCTAssertEqual(Escala(texto: "λα αρμονική ελάσσονα"), Escala(.la, .menorArmonica))
        XCTAssertEqual(Escala(texto: "ρε δωριος"), Escala(.re, .dorico))
        XCTAssertEqual(Escala(texto: "σι ύφεση μιξολύδιος"), Escala(Nota("Sib"), .mixolidio))
        // Con la tónica en ruso o griego, el tipo puede ir en inglés.
        XCTAssertEqual(Escala(texto: "до lydian dominant"), Escala(.do, .lidioDominante))
        XCTAssertEqual(Escala(texto: "ντο altered"), Escala(.do, .alterada))
        // Todos los nombres franceses e italianos del catálogo se leen.
        for tipo in TipoDeEscala.todos {
            for notacion in [Notacion.frances, .italiano] {
                let escala = Escala(Nota("Fa#"), tipo)
                XCTAssertEqual(Escala(texto: escala.nombre(en: notacion)), escala, escala.nombre(en: notacion))
            }
        }
        // Los nombres con otras formas de leerse (alias) en ruso y en griego se leen todos.
        for tipo in TipoDeEscala.todos {
            if let entrada = NombresDeEscalas.de(.ruso).porTipo[tipo], !entrada.alias.isEmpty {
                for nombre in [entrada.nombre] + entrada.alias {
                    XCTAssertEqual(Escala(texto: "ре " + nombre), Escala(.re, tipo), nombre)
                }
            }
            if let entrada = NombresDeEscalas.de(.griego).porTipo[tipo], !entrada.alias.isEmpty {
                for nombre in [entrada.nombre] + entrada.alias {
                    XCTAssertEqual(Escala(texto: "ρε " + nombre), Escala(.re, tipo), nombre)
                }
            }
        }
        // El español no cambia: no se mezclan idiomas.
        XCTAssertNil(Escala(texto: "Re dorian"))
    }

    func testVocabularioEIdas() {
        XCTAssertEqual(Notacion.aleman.idiomaDeLasNotas, .aleman)
        XCTAssertEqual(Notacion.frances.idiomaDeLasAbreviaturas, .ingles)
        XCTAssertEqual(Notacion.espanolASCII.idiomaDeLasAbreviaturas, .espanol)
        XCTAssertEqual(Notacion(escritura: EscrituraDeNotas(idioma: .italiano, ascii: false)), .italiano)
        // En alemán, el resto del vocabulario también.
        XCTAssertEqual(Escala(.re, .dorico).nombre(en: .aleman), "D dorisch")
        XCTAssertEqual(Intervalo.terceraMayor.nombre(en: .aleman), "große Terz")
        // Todos los nombres de nota (hasta cuatro alteraciones) vuelven a leerse igual.
        for notacion in [Notacion.aleman, .frances, .italiano, .catalan, .gallego, .euskera, .portugues] {
            for quintas in -29...33 {
                let nombre = Nota(pasosDeQuinta: quintas)
                XCTAssertEqual(try Nota(leyendo: nombre.nombre(en: notacion), en: notacion), nombre,
                               "\(nombre) \(notacion)")
                let nota = Altura(nombre, octava: 2)
                XCTAssertEqual(try Altura(leyendo: nota.nombre(en: notacion), en: notacion), nota)
            }
            for tonalidad in Tonalidad.circuloDeQuintas() + Tonalidad.circuloDeQuintas(.menor) {
                XCTAssertEqual(Tonalidad(texto: tonalidad.nombre(en: notacion)), tonalidad, tonalidad.nombre(en: notacion))
            }
        }
    }

    func testSinonimosAlLeer() {
        // Undécima y decimotercera, y también oncena y trecena.
        XCTAssertEqual(PapelEnAcorde("undécima"), .tension(11))
        XCTAssertEqual(PapelEnAcorde("Oncena"), .tension(11))
        XCTAssertEqual(PapelEnAcorde("decimotercera"), .tension(13))
        XCTAssertEqual(PapelEnAcorde("trecena"), .tension(13))
        XCTAssertEqual(PapelEnAcorde("séptima"), .septima)
        XCTAssertEqual(PapelEnAcorde("suspension"), .suspension)
        XCTAssertEqual(PapelEnAcorde("thirteenth"), .tension(13))
        XCTAssertEqual(PapelEnAcorde("root"), .fundamental)
        XCTAssertNil(PapelEnAcorde("duodécima"))
        XCTAssertEqual(Intervalo.decimoterceraMayor, Intervalo("13M"))
        XCTAssertEqual(Intervalo.undecimaAumentada.semitonos, 18)
        // Submediante junto a superdominante.
        XCTAssertEqual(NombreDeGrado("submediante"), .superdominante)
        XCTAssertEqual(NombreDeGrado("Superdominante"), .superdominante)
        XCTAssertEqual(NombreDeGrado("submediant"), .superdominante)
        XCTAssertEqual(NombreDeGrado("tónica"), .tonica)
        XCTAssertEqual(NombreDeGrado("TONICA"), .tonica)
        XCTAssertEqual(NombreDeGrado("leading tone"), .sensible)
        XCTAssertNil(NombreDeGrado("dominantísima"))
        XCTAssertEqual(Escala(.la, .menorNatural).nombreDeGrado(de: .fa), .superdominante)
    }
}
