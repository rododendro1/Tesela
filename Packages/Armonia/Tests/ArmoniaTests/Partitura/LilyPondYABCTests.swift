import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

@Suite struct LilyPondYABCTests {
    // MARK: Lectores mínimos, para comprobar lo que suena

    /// Las alturas de las notas de un `.ly`, en orden (las de un acorde, de grave a agudo), sin las que siguen
    /// ligadas a la anterior.
    private func alturasLilyPond(_ ly: String) -> [Int] {
        // Sin la cabecera ni lo que va al principio de cada voz: solo los compases.
        let instrucciones = ["\\version", "\\header", "\\score", "\\new", "\\voice", "\\clef", "\\bar", "\\layout"]
        let musica = ly.components(separatedBy: "\n").filter { linea in
            let limpia = linea.trimmingCharacters(in: .whitespaces)
            return !instrucciones.contains { limpia.hasPrefix($0) } && !limpia.hasPrefix("title")
                && !limpia.hasPrefix("tagline") && !limpia.isEmpty && limpia != "}" && limpia != ">>"
        }.joined(separator: " ")
        let sinTextos = musica.replacingOccurrences(
            of: #"[\^_]\\markup (\\column \{[^}]*\}|"[^"]*")"#, with: "", options: .regularExpression)
        let nota = try! NSRegularExpression(pattern: #"(?<![\\a-z])([a-g])((?:is|es)*)([',]*)"#)
        let rango = NSRange(sinTextos.startIndex..., in: sinTextos)
        var alturas: [Int] = []
        // Lo que viene ligado: la nota o el acorde anterior acaba en `~`.
        var ligadas: Set<Int> = []
        var actuales: Set<Int> = []
        var dentroDeAcorde = false
        var posicion = sinTextos.startIndex
        for m in nota.matches(in: sinTextos, range: rango) {
            let antes = sinTextos[posicion..<Range(m.range, in: sinTextos)!.lowerBound]
            let abre = antes.lastIndex(of: "<")
            let cierra = antes.lastIndex(of: ">")
            // Empieza un evento si no se estaba dentro de un acorde o si entre medias se cierra o se abre uno.
            if !dentroDeAcorde || abre != nil || cierra != nil {
                ligadas = antes.contains("~") ? actuales : []
                actuales = []
            }
            if let abre {
                dentroDeAcorde = cierra.map { $0 < abre } ?? true
            } else if cierra != nil {
                dentroDeAcorde = false
            }
            posicion = Range(m.range, in: sinTextos)!.upperBound
            let letra = String(sinTextos[Range(m.range(at: 1), in: sinTextos)!])
            let alteracion = String(sinTextos[Range(m.range(at: 2), in: sinTextos)!])
            let marcas = String(sinTextos[Range(m.range(at: 3), in: sinTextos)!])
            let base = ["c": 0, "d": 2, "e": 4, "f": 5, "g": 7, "a": 9, "b": 11][letra]!
            let semitonos = alteracion.count / 2 * (alteracion.hasPrefix("is") ? 1 : -1)
            let octava = 3 + marcas.filter { $0 == "'" }.count - marcas.filter { $0 == "," }.count
            let midi = 12 * (octava + 1) + base + semitonos
            actuales.insert(midi)
            if !ligadas.contains(midi) { alturas.append(midi) }
        }
        return alturas
    }

    /// Las alturas de las notas de una voz de ABC (con `K:` y `L:1/4`), aplicando la armadura y las alteraciones
    /// que valen hasta la barra, sin las que siguen ligadas a la anterior.
    private func alturasABC(_ abc: String, voz: Int = 1) -> [Int] {
        let lineas = abc.components(separatedBy: "\n")
        let clave = lineas.first { $0.hasPrefix("K:") }!.dropFirst(2)
        let armadura = try! Tonalidad(
            leyendo: clave.replacingOccurrences(of: "m", with: " menor").replacingOccurrences(of: "#", with: "♯")
                + (clave.hasSuffix("m") ? "" : " mayor"))
        let propias = Dictionary(
            armadura.notasDeLaArmadura.map { ($0.natural.rawValue, $0.alteracion.semitonos) },
            uniquingKeysWith: { a, _ in a })
        // La música de la voz: lo que va tras su `V:` del cuerpo (después de `K:`).
        let cuerpo = lineas.drop { !$0.hasPrefix("K:") }.dropFirst()
        var musica = ""
        var dentro = false
        for linea in cuerpo {
            if linea.hasPrefix("V:") {
                dentro = linea == "V:\(voz)"
                continue
            }
            if dentro { musica += linea + " " }
        }
        musica = musica.replacingOccurrences(of: #""[^"]*""#, with: "", options: .regularExpression)
        let nota = try! NSRegularExpression(pattern: #"(\|)|(\^\^|\^|__|_|=)?([A-Ga-g])([',]*)|(-)|(\])|(\[)"#)
        var alturas: [Int] = []
        var vigentes: [Int: Int] = [:]
        var ligadas: Set<Int> = []
        var actuales: Set<Int> = []
        var siguientesLigadas: Set<Int> = []
        var enAcorde = false
        for m in nota.matches(in: musica, range: NSRange(musica.startIndex..., in: musica)) {
            func grupo(_ i: Int) -> String? { Range(m.range(at: i), in: musica).map { String(musica[$0]) } }
            if grupo(1) != nil {
                vigentes = [:]
                continue
            }
            if grupo(5) != nil {
                siguientesLigadas = actuales
                continue
            }
            if grupo(7) != nil {
                enAcorde = true
                ligadas = siguientesLigadas
                siguientesLigadas = []
                actuales = []
                continue
            }
            if grupo(6) != nil {
                enAcorde = false
                continue
            }
            guard let letra = grupo(3) else { continue }
            if !enAcorde {
                ligadas = siguientesLigadas
                siguientesLigadas = []
                actuales = []
            }
            let natural = ["C", "D", "E", "F", "G", "A", "B"].firstIndex(of: letra.uppercased())!
            let marcas = grupo(4) ?? ""
            let octava =
                (letra == letra.lowercased() ? 5 : 4) + marcas.filter { $0 == "'" }.count
                - marcas.filter { $0 == "," }.count
            let lugar = octava * 7 + natural
            if let alteracion = grupo(2) {
                vigentes[lugar] = ["^^": 2, "^": 1, "=": 0, "_": -1, "__": -2][alteracion]!
            }
            let semitonos = vigentes[lugar] ?? propias[natural] ?? 0
            let midi = 12 * (octava + 1) + [0, 2, 4, 5, 7, 9, 11][natural] + semitonos
            actuales.insert(midi)
            if !ligadas.contains(midi) { alturas.append(midi) }
        }
        return alturas
    }

    /// Las alturas de una voz como se escriben: una por nota (sin las ligadas a la anterior).
    private func alturas(_ voz: Voz) -> [Int] {
        Exportacion.compases(de: voz).joined().filter(\.nuevo).flatMap { $0.evento.alturas.map(\.midi) }
    }

    // MARK: LilyPond

    @Test func lilyPondEscribeLasAlturasEnAbsoluto() {
        #expect(EscritorLilyPond.altura(Altura("Do4")) == "c'")
        #expect(EscritorLilyPond.altura(Altura("Fa#3")) == "fis")
        #expect(EscritorLilyPond.altura(Altura("Sib1")) == "bes,,")
        #expect(EscritorLilyPond.altura(Altura("Mibb6")) == "eeses'''")
        // Sin triples: la nota vecina que suena igual.
        #expect(EscritorLilyPond.altura(Altura(Nota(.fa, Alteracion(3)), octava: 4)) == "gis'")
        #expect(EscritorLilyPond.altura(Altura(Nota(.do, Alteracion(-3)), octava: 4)) == "beses")
        #expect(EscritorLilyPond.duracion(Duracion(3, 8)) == "4.")
        #expect(EscritorLilyPond.duracion(Duracion(2)) == "\\breve")
        #expect(EscritorLilyPond.duracion(Duracion(5, 16)) == "1*5/16")
    }

    @Test func lilyPondDeUnaVoz() throws {
        let voz = try Voz(
            leyendo: "Sol4:4 Do5:2 Re5:8 Mi5:8 Fa#5:4 Sol5:2. Do5:1/12 Re5:1/12 Mi5:1/12 Fa5:4 -:4", compas: "3/4",
            anacrusa: .negra)
        let ly = voz.lilyPond(
            tonalidad: Tonalidad(.sol), tempo: Tempo(60, unidad: Duracion(3, 8)), titulo: #"Mi "canción""#)
        #expect(ly.hasPrefix("\\version \"2.24.0\"\n"))
        #expect(ly.contains(#"title = "Mi \"canción\"""#))
        #expect(ly.contains(#"\new Staff \with { instrumentName = "Voz" }"#))
        #expect(ly.contains(#"\clef "treble" \key g \major \time 3/4 \tempo 4. = 60 \partial 4"#))
        #expect(ly.contains("g''2~ |"))
        #expect(ly.contains("\\tuplet 3/2 { c''8 d''8 e''8 } f''4 |\n      r4\n"))
        #expect(ly.contains(#"\bar "|.""#))
        #expect(alturasLilyPond(ly) == alturas(voz))
    }

    @Test func lilyPondDeUnCoralConCifradosYAnalisis() throws {
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa2 La3 Fa4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let ly = coral.lilyPond(duracion: .blanca, compas: "3/2", titulo: "Cadencia", cifrados: true, analisis: true)
        #expect(ly.contains(#"\new PianoStaff \with { instrumentName = "Coro" } <<"#))
        #expect(ly.components(separatedBy: "\\new Staff <<").count == 3)
        #expect(ly.components(separatedBy: "\\voiceOne").count == 3)
        #expect(ly.contains(#"c''2^\markup "Do" c''2^\markup "Fa" b'2^\markup "Sol" |"#))
        // El análisis y la tonalidad, debajo del bajo.
        #expect(ly.contains(#"c2_\markup \column { "Do mayor:" "I" "T" } f,2_\markup \column { "IV" "S" }"#))
        #expect(ly.contains(#"\clef "bass""#))
    }

    @Test func lilyPondDeUnaProgresionEnAmalgama() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        let ly = analisis.lilyPond(compas: Compas(7, 8, agrupacion: [2, 2, 3]), notacion: .inglesCompacto)
        #expect(ly.contains(#"\time 2,2,3 7/8"#))
        #expect(ly.contains(#"<d' fis' a' c''>8~^\markup "D7""#))
        #expect(ly.contains(#"\new PianoStaff \with { instrumentName = "Piano" }"#))
        #expect(!ly.contains("title"))
    }

    // MARK: ABC

    @Test func abcEscribeLasNotasYLasDuraciones() {
        #expect(EscritorABC.nombre(.do, octava: 4) == "C")
        #expect(EscritorABC.nombre(.do, octava: 5) == "c")
        #expect(EscritorABC.nombre(.la, octava: 6) == "a'")
        #expect(EscritorABC.nombre(.si, octava: 2) == "B,,")
        #expect(EscritorABC.longitud(.negra) == "")
        #expect(EscritorABC.longitud(.corchea) == "/2")
        #expect(EscritorABC.longitud(Duracion(3, 8)) == "3/2")
        #expect(EscritorABC.longitud(Duracion(3, 4)) == "3")
        #expect(EscritorABC.texto("Mi \"coral\"") == "Mi 'coral'")
    }

    @Test func abcDeUnaVoz() throws {
        let voz = try Voz(
            leyendo: "Sol4:4 Do5:2 Re5:8 Mi5:8 Fa#5:4 Sol5:2. Do5:1/12 Re5:1/12 Mi5:1/12 Fa5:4 Sib4:4 Si4:4 La4:2",
            compas: "3/4", anacrusa: .negra)
        let abc = voz.abc(tonalidad: Tonalidad(.sol), tempo: Tempo(60, unidad: Duracion(3, 8)), titulo: "Escala")
        #expect(abc.hasPrefix("X:1\nT:Escala\nM:3/4\nL:1/4\nQ:3/8=60\nV:1 clef=treble name=\"Voz\"\nK:G\n"))
        // Las corcheas de un pulso van juntas; el Fa♯ es de la armadura y el Fa♮, no.
        #expect(abc.contains("c2 d/2e/2 | f g2- | g (3:2:3c/2d/2e/2 =f |"))
        #expect(abc.contains("_B =B A- |"))
        #expect(abc.hasSuffix(" |]\n"))
        #expect(alturasABC(abc) == alturas(voz))
    }

    @Test func abcDeUnCoralConCifradosYAnalisis() throws {
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa2 La3 Fa4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let abc = coral.abc(duracion: .blanca, compas: "3/2", cifrados: true, analisis: true)
        #expect(abc.contains("%%score {(1 2) | (3 4)}\n"))
        #expect(abc.contains("V:1 clef=treble name=\"Coro\" stem=up\nV:2 clef=treble stem=down\n"))
        #expect(abc.contains("V:4 clef=bass stem=down\nK:C\n"))
        #expect(abc.contains("V:1\n\"^Do\"c2 \"^Fa\"c2 \"^Sol\"B2 | \"^Do\"c6 |]\n"))
        #expect(abc.contains("V:4\n\"_Do mayor:\"\"_I\"\"_T\"C,2 \"_IV\"\"_S\"F,,2"))
    }

    @Test func abcEscribeLasAlteracionesComoUnaPartitura() throws {
        // En Mi♭ mayor: el Mi♭ no se escribe; el Mi♮ sí, y vale hasta la barra (en esa octava).
        let voz = try Voz(leyendo: "Mi4:4 Mib4:4 Mi5:4 Mi4:4 Mi4:4 Fa##4:4 Sol###4:2", compas: "4/4")
        let abc = voz.abc(tonalidad: Tonalidad(Nota(.mi, .bemol)))
        #expect(abc.contains("K:Eb\n"))
        #expect(abc.contains("=E _E =e =E | =E ^^F ^A2 |]"))
        #expect(alturasABC(abc) == alturas(voz))
        let menor = try Voz(leyendo: "Do#4:1", compas: "4/4").abc(tonalidad: Tonalidad(Nota(.do, .sostenido), .menor))
        #expect(menor.contains("K:C#m\n"))
    }

    @Test func abcDeUnaProgresionYDelCompas() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        let abc = analisis.abc(compas: Compas(7, 8, agrupacion: [2, 2, 3]))
        #expect(abc.contains("M:(2+2+3)/8\n"))
        #expect(abc.contains("%%score {1 | 2}\n"))
        #expect(abc.contains("[D^FAc]/2-"))
        #expect(try Voz(leyendo: "Do4:2", compas: "2/2").abc().contains("M:C|\n"))
        #expect(try Voz(leyendo: "-:1 Do4:1", compas: "4/4").abc().contains("Z | C4 |]"))
    }

    // MARK: Al azar

    @Test(arguments: 0..<40) func lasAlturasSeConservan(semilla: UInt64) throws {
        var azar = GeneradorConSemilla(semilla: semilla)
        let compases: [Compas] = ["4/4", "3/4", "6/8", "2/2", Compas(7, 8, agrupacion: [2, 2, 3])]
        let compas = compases.randomElement(using: &azar)!
        let figuras = [
            Duracion(1, 4), Duracion(1, 8), Duracion(3, 8), Duracion(1, 2), Duracion(1, 16), Duracion(1, 12),
        ]
        var eventos: [Evento] = []
        for _ in 0..<Int.random(in: 1...16, using: &azar) {
            var duracion = figuras.randomElement(using: &azar)!
            if duracion == Duracion(1, 12) {
                // Un tresillo entero de corcheas.
                for _ in 0..<3 {
                    eventos.append(
                        Evento(Altura(Nota(pasosDeQuinta: Int.random(in: -9...9, using: &azar)), octava: 4), duracion))
                }
                continue
            }
            if Bool.random(using: &azar) { duracion = duracion + .corchea }
            let alturas = (0..<Int.random(in: 0...3, using: &azar)).map { _ in
                Altura(
                    Nota(pasosDeQuinta: Int.random(in: -12...12, using: &azar)),
                    octava: Int.random(in: 2...6, using: &azar))
            }
            eventos.append(Evento(alturas: Array(Set(alturas)).sorted { $0.midi < $1.midi }, duracion: duracion))
        }
        let voz = Voz(eventos, compas: compas)
        let tonalidad = Tonalidad(armadura: Int.random(in: -6...6, using: &azar), modo: .mayor)
        let contexto = Comment(rawValue: voz.eventos.map(\.description).joined(separator: " ") + " en \(compas)")
        let esperadas = alturas(voz).sorted()
        #expect(alturasLilyPond(voz.lilyPond(tonalidad: tonalidad)).sorted() == esperadas, contexto)
        #expect(alturasABC(voz.abc(tonalidad: tonalidad)).sorted() == esperadas, contexto)
    }
}
