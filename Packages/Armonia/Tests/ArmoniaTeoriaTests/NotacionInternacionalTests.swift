import Foundation
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

@Suite struct NotacionInternacionalTests {
    @Test func notas() {
        #expect(Nota("Fa#").nombre(en: .inglesASCII) == "F#")
        #expect(Nota("Fa#").nombre(en: .inglesCompacto) == "F♯")
        #expect(Nota("Sibb").nombre(en: .inglesCompacto) == "B𝄫")
        #expect(Nota("B♭") == Nota("Sib"))
        #expect(Altura("C#4") == Altura("Do#4"))
        #expect(Altura("Sib3").nombre(en: .inglesASCII) == "Bb3")
        #expect(Altura("Sib3").nombre(en: .inglesCompacto) == "B♭₃")
        #expect(Altura("B♭3") == Altura("Sib3"))
    }

    @Test func intervalos() {
        #expect(Intervalo.terceraMayor.abreviatura(en: .inglesASCII) == "M3")
        #expect(Intervalo.quintaJusta.abreviatura(en: .inglesASCII) == "P5")
        #expect((-Intervalo.cuartaAumentada).abreviatura(en: .inglesASCII) == "-A4")
        #expect(Intervalo("M3") == .terceraMayor)
        #expect(Intervalo("P8") == .octava)
        #expect(Intervalo("-m3") == -Intervalo.terceraMenor)
        #expect(Intervalo("AA4") == Intervalo(numero: 4, calidad: .aumentada(2)))
        #expect(Intervalo("dd5") == Intervalo(numero: 5, calidad: .disminuida(2)))

        #expect(Intervalo.terceraMayor.nombre(en: .inglesASCII) == "major third")
        #expect(Intervalo.quintaJusta.nombre(en: .inglesASCII) == "perfect fifth")
        #expect(Intervalo.octava.nombre(en: .inglesASCII) == "perfect octave")
        #expect(Intervalo.unisonoAumentado.nombre(en: .inglesASCII) == "augmented unison")
        #expect(Intervalo.novenaMenor.nombre(en: .inglesASCII) == "minor ninth")
        #expect((-Intervalo.sextaMenor).nombre(en: .inglesASCII) == "descending minor sixth")
        #expect(Intervalo(numero: 4, calidad: .aumentada(2))!.nombre(en: .inglesASCII) == "doubly augmented fourth")
        #expect(Intervalo.ordinal(21, en: .ingles) == "21st")
        #expect(Intervalo.ordinal(22, en: .ingles) == "22nd")
        #expect(Intervalo.ordinal(23, en: .ingles) == "23rd")
        #expect(Intervalo.ordinal(111, en: .ingles) == "111th")
    }

    @Test func escalas() {
        #expect(Escala("D dorian") == Escala("Re dórico"))
        #expect(Escala("Bb harmonic minor") == Escala(Nota("Sib"), .menorArmonica))
        #expect(Escala("A minor").tipo == .menorNatural)
        #expect(Escala("F# whole-tone").tipo == .tonosEnteros)
        #expect(Escala("C Major Pentatonic").tipo == .pentatonicaMayor)
        #expect(Escala(.re, .dorico).nombre(en: .inglesASCII) == "D dorian")
        #expect(Escala("Mib menor armónica").nombre(en: .inglesCompacto) == "E♭ harmonic minor")
        #expect(
            Escala(.do, TipoDeEscala.pentatonicaMayor.modo(grado: 3)).nombre(en: .inglesASCII)
                == "C pentatónica mayor, modo 3")
        #expect(Escala(.do, TipoDeEscala.pentatonicaMayor.modo(grado: 2)).nombre(en: .inglesASCII) == "C Egyptian")
        for tipo in TipoDeEscala.occidentales {
            let escala = Escala("F#", tipo)
            #expect(
                (try? Escala(leyendo: escala.nombre(en: .inglesASCII))) == escala,
                Comment(rawValue: escala.nombre(en: .inglesASCII)))
            #expect((try? Escala(leyendo: escala.nombre(en: .inglesCompacto))) == escala)
        }
    }

    @Test func acordes() {
        let acorde: Acorde = "Sol7/Si"
        #expect(acorde.cifrado(en: .inglesASCII) == "G7/B")
        #expect(acorde.nombre(en: .inglesASCII) == "G dominant seventh, first inversion")
        #expect(Acorde("Do/Re").nombre(en: .inglesASCII) == "C major over D")
        #expect(Acorde("Sib7(b9)/Re").cifrado(estilo: .inglesCompacto) == "B♭7(♭9)/D")
        #expect(Acorde("Sib7(b9)/Re").cifrado(estilo: .espanolCompacto) == "Si♭7(♭9)/Re")
        #expect(EstiloDeCifrado.espanolCompacto == .predeterminado)
        #expect(Acorde("B♭7(♭9)/D") == Acorde("Sib7(b9)/Re"))
        #expect(TipoDeAcorde.semidisminuido.nombre(en: .inglesASCII) == "half-diminished seventh")
        #expect(TipoDeAcorde("7(b9,#11)").nombre(en: .inglesASCII) == "7(b9,#11) chord")
        // " chord" solo lo añaden los tipos sin nombre conocido; "power chord" es el nombre propio.
        for tipo in TipoDeAcorde.todos where tipo != .potencia {
            #expect(!(tipo.nombre(en: .inglesASCII).hasSuffix(" chord")), Comment(rawValue: tipo.nombre))
        }
    }

    @Test func notacionUnica() {
        #expect(Notacion(escritura: EscrituraDeNotas(idioma: .espanol, ascii: true)) == .espanolASCII)
        #expect(Notacion(escritura: EscrituraDeNotas(idioma: .ingles, ascii: false)) == .inglesCompacto)
        #expect(Notacion.inglesASCII.idiomaDeLasNotas == .ingles)
        #expect(Notacion.inglesASCII.usaASCII)
        #expect(!Notacion.espanolCompacto.usaASCII)

        let escala: Escala = "Fa# dórico"
        #expect(escala.nombre(en: .espanolCompacto) == "Fa♯ dórico")
        #expect(escala.nombre(en: .espanolASCII) == "Fa# dórico")
        #expect(escala.nombre(en: .inglesASCII) == "F# dorian")
        #expect(escala.nombre(en: .inglesCompacto) == "F♯ dorian")
        #expect(Altura("Sib3").nombre(en: .inglesCompacto) == "B♭₃")
        #expect(Acorde("Sol7/Si").nombre(en: .inglesCompacto) == "G dominant seventh, first inversion")
        #expect(Acorde("Fa#7").nombre(en: .inglesCompacto) == "F♯ dominant seventh, root position")
        #expect(Intervalo.quintaJusta.abreviatura(en: .inglesASCII) == "P5")
        #expect(Intervalo.quintaJusta.abreviatura(en: .espanolCompacto) == "5J")
    }

    /// Las notas en una notación y los textos en otro idioma.
    @Test func notasYTextosPorSeparado() throws {
        let rusoEnEspanol = Notacion.conPalabras(.ruso).conTextos(en: .espanol)
        #expect(rusoEnEspanol == Notacion(escritura: .conPalabras(.ruso), textos: .espanol))
        #expect(rusoEnEspanol.idiomaDeLasNotas == .ruso)
        #expect(rusoEnEspanol.textos == .espanol)
        #expect(rusoEnEspanol.notas == .conPalabras(.ruso))
        #expect(rusoEnEspanol.escritura == .conPalabras(.ruso))
        #expect(rusoEnEspanol.textos == .espanol)
        #expect(rusoEnEspanol.esCombinada)
        #expect(!Notacion.conPalabras(.ruso).esCombinada)
        #expect(Notacion.conPalabras(.ruso).textos == .ruso)
        #expect(Notacion(escritura: .conPalabras(.aleman), textos: .aleman) == .conPalabras(.aleman))
        #expect(Notacion.allCases.map(\.escritura) == EscrituraDeNotas.allCases)
        #expect(Acorde("Sol7/Si").nombre(en: rusoEnEspanol) == "соль séptima de dominante, primera inversión")
        #expect(Acorde("Sol7/La").nombre(en: rusoEnEspanol) == "соль séptima de dominante, con bajo en ля")
        #expect(Acorde("Fa#m7").cifrado(en: rusoEnEspanol) == "Фа♯m7")
        #expect(Tonalidad("Fa# mayor").nombre(en: rusoEnEspanol) == "фа-диез мажор")
        #expect(Intervalo.terceraMayor.nombre(en: rusoEnEspanol) == "3ª mayor")
        #expect(Intervalo.quintaJusta.abreviatura(en: rusoEnEspanol) == "5J")
        #expect(try (Nota(leyendo: "фа-диез", en: rusoEnEspanol)) == Nota("Fa#"))
        #expect(try (Altura(leyendo: "фа-диез3", en: rusoEnEspanol)) == Altura("Fa#3"))
        // Letras inglesas con textos en euskera; sílabas con textos en inglés.
        let inglesEnEuskera = Notacion.inglesASCII.conTextos(en: .euskera)
        #expect(Acorde("Sol7").nombre(en: inglesEnEuskera) == "G dominanteko zazpigarrena, oinarrizko egoera")
        #expect(Escala(.re, .dorico).nombre(en: inglesEnEuskera) == "D doriarra")
        #expect(
            Acorde("Sol7").nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles))
                == "Sol dominant seventh, root position")
        #expect(Tonalidad("Fa# mayor").nombre(en: Notacion.conPalabras(.aleman).conTextos(en: .frances)) == "Fis-Dur")
        #expect(Acorde("Sib7").cifrado(en: Notacion.conPalabras(.aleman).conTextos(en: .frances)) == "B7")
        // Si el idioma ya es el de los textos, la notación queda simple; no se anidan.
        #expect(Notacion.conPalabras(.catalan).conTextos(en: .catalan) == .conPalabras(.catalan))
        #expect(Notacion.conPalabras(.aleman).conTextos(en: .aleman) == .conPalabras(.aleman))
        #expect(Notacion.conPalabras(.griego).conTextos(en: .griego) == .conPalabras(.griego))
        #expect(Notacion.conPalabras(.griego).conTextos(en: .ingles).esCombinada)
        #expect(rusoEnEspanol.conTextos(en: .frances) == Notacion(escritura: .conPalabras(.ruso), textos: .frances))
        #expect(rusoEnEspanol.conTextos(en: .ruso) == .conPalabras(.ruso))
        #expect(!Notacion.allCases.contains(rusoEnEspanol))
        // Los mensajes de error.
        do {
            _ = try Acorde(leyendo: "Do7(b3)")
            Issue.record("Do7(b3) no es un cifrado válido")
        } catch let error as ErrorDeLecturaDeTeoria {
            #expect(error.descripcion(en: Notacion.inglesASCII.conTextos(en: .espanol)) == error.description)
        } catch {
            Issue.record("\(error)")
        }
    }

    /// Las escalas se leen también con la tónica y el tipo en francés, italiano, griego o ruso.
    @Test func escalasEnOtrasLenguas() {
        #expect((try? Escala(leyendo: "ré dorien")) == Escala(.re, .dorico))
        #expect((try? Escala(leyendo: "fa dièse lydien")) == Escala(Nota("Fa#"), .lidio))
        #expect((try? Escala(leyendo: "si bémol mineur harmonique")) == Escala(Nota("Sib"), .menorArmonica))
        #expect((try? Escala(leyendo: "fa diesis lidio")) == Escala(Nota("Fa#"), .lidio))
        #expect((try? Escala(leyendo: "si bemolle minore melodica")) == Escala(Nota("Sib"), .menorMelodica))
        #expect((try? Escala(leyendo: "ре дорийский")) == Escala(.re, .dorico))
        #expect((try? Escala(leyendo: "ля гармонический минор")) == Escala(.la, .menorArmonica))
        #expect((try? Escala(leyendo: "фа-диез минорная пентатоника")) == Escala(Nota("Fa#"), .pentatonicaMenor))
        #expect((try? Escala(leyendo: "λα αρμονική ελάσσονα")) == Escala(.la, .menorArmonica))
        #expect((try? Escala(leyendo: "ρε δωριος")) == Escala(.re, .dorico))
        #expect((try? Escala(leyendo: "σι ύφεση μιξολύδιος")) == Escala(Nota("Sib"), .mixolidio))
        // Con la tónica en ruso o griego, el tipo puede ir en inglés.
        #expect((try? Escala(leyendo: "до lydian dominant")) == Escala(.do, .lidioDominante))
        #expect((try? Escala(leyendo: "ντο altered")) == Escala(.do, .alterada))
        // Todos los nombres franceses e italianos del catálogo se leen.
        for tipo in TipoDeEscala.occidentales {
            for notacion in [Notacion.conPalabras(.frances), .conPalabras(.italiano)] {
                let escala = Escala(Nota("Fa#"), tipo)
                #expect(
                    (try? Escala(leyendo: escala.nombre(en: notacion))) == escala,
                    Comment(rawValue: escala.nombre(en: notacion))
                )
            }
        }
        // Los nombres con otras formas de leerse (alias y variantes) en ruso y en griego se leen todos.
        for tipo in TipoDeEscala.occidentales {
            if let entrada = NombresDeEscalas.de(.ruso).porTipo[tipo] {
                for nombre in [entrada.nombre] + entrada.alias + entrada.variantes {
                    #expect((try? Escala(leyendo: "ре " + nombre)) == Escala(.re, tipo), Comment(rawValue: nombre))
                }
            }
            if let entrada = NombresDeEscalas.de(.griego).porTipo[tipo] {
                for nombre in [entrada.nombre] + entrada.alias + entrada.variantes {
                    #expect((try? Escala(leyendo: "ρε " + nombre)) == Escala(.re, tipo), Comment(rawValue: nombre))
                }
            }
        }
        // El español no cambia: no se mezclan idiomas.
        #expect((try? Escala(leyendo: "Re dorian")) == nil)
    }

    @Test func vocabularioEIdas() throws {
        #expect(Notacion.conPalabras(.aleman).idiomaDeLasNotas == .aleman)
        #expect(Notacion.conPalabras(.frances).idiomaDeLasAbreviaturas == .ingles)
        #expect(Notacion.espanolASCII.idiomaDeLasAbreviaturas == .espanol)
        #expect(Notacion(escritura: EscrituraDeNotas(idioma: .italiano, ascii: false)) == .conPalabras(.italiano))
        // En alemán, el resto del vocabulario también.
        #expect(Escala(.re, .dorico).nombre(en: .conPalabras(.aleman)) == "D dorisch")
        #expect(Intervalo.terceraMayor.nombre(en: .conPalabras(.aleman)) == "große Terz")
        // Todos los nombres de nota (hasta cuatro alteraciones) vuelven a leerse igual.
        for notacion in [
            Notacion.conPalabras(.aleman), .conPalabras(.frances), .conPalabras(.italiano), .conPalabras(.catalan),
            .conPalabras(.gallego),
            .conPalabras(.euskera), .conPalabras(.portugues),
        ] {
            for quintas in -29...33 {
                let nombre = Nota(pasosDeQuinta: quintas)
                #expect(
                    try (Nota(leyendo: nombre.nombre(en: notacion), en: notacion)) == nombre, "\(nombre) \(notacion)")
                let nota = Altura(nombre, octava: 2)
                #expect(try (Altura(leyendo: nota.nombre(en: notacion), en: notacion)) == nota)
            }
            for tonalidad in Tonalidad.circuloDeQuintas() + Tonalidad.circuloDeQuintas(.menor) {
                #expect(
                    (try? Tonalidad(leyendo: tonalidad.nombre(en: notacion))) == tonalidad,
                    Comment(rawValue: tonalidad.nombre(en: notacion)))
            }
        }
    }

    @Test func sinonimosAlLeer() throws {
        // Undécima y decimotercera, y también oncena y trecena.
        #expect(try PapelEnAcorde(leyendo: "undécima") == .tension(11))
        #expect(try PapelEnAcorde(leyendo: "Oncena") == .tension(11))
        #expect(try PapelEnAcorde(leyendo: "decimotercera") == .tension(13))
        #expect(try PapelEnAcorde(leyendo: "trecena") == .tension(13))
        #expect(try PapelEnAcorde(leyendo: "séptima") == .septima)
        #expect(try PapelEnAcorde(leyendo: "suspension") == .suspension)
        #expect(try PapelEnAcorde(leyendo: "thirteenth") == .tension(13))
        #expect(try PapelEnAcorde(leyendo: "root") == .fundamental)
        #expect(throws: ErrorDeLecturaDeTeoria.self) { try PapelEnAcorde(leyendo: "duodécima") }
        #expect(Intervalo.decimoterceraMayor == Intervalo("13M"))
        #expect(Intervalo.undecimaAumentada.semitonos == 18)
        // Submediante junto a superdominante.
        #expect(try NombreDeGrado(leyendo: "submediante") == .superdominante)
        #expect(try NombreDeGrado(leyendo: "Superdominante") == .superdominante)
        #expect(try NombreDeGrado(leyendo: "submediant") == .superdominante)
        #expect(try NombreDeGrado(leyendo: "tónica") == .tonica)
        #expect(try NombreDeGrado(leyendo: "TONICA") == .tonica)
        #expect(try NombreDeGrado(leyendo: "leading tone") == .sensible)
        #expect(throws: ErrorDeLecturaDeTeoria.self) { try NombreDeGrado(leyendo: "dominantísima") }
        #expect(Escala(.la, .menorNatural).nombreDeGrado(de: .fa) == .superdominante)
    }
}
