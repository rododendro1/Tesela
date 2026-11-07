import Foundation
import Testing

@testable import Elementos
@testable import Formatos
@testable import Partituras
@testable import Teoria

/// Una duración como fracción de redonda: «3/8», «1».
private func f(_ duracion: Duracion) -> String {
    duracion.denominador == 1 ? "\(duracion.numerador)" : "\(duracion.numerador)/\(duracion.denominador)"
}

/// La lectura de MEI y ABC y el lector de XML propio.
@Suite struct ImportacionMEIYABCTests {
    /// Las notas como (altura, inicio, duración), en orden: lo que tiene que salir igual por cualquier formato.
    private func sonido(_ pieza: PiezaImportada) -> [String] {
        pieza.notas.map { "\($0.altura) \(f($0.inicio)) \(f($0.duracion))" }.sorted()
    }

    private func porTodosLosFormatos(
        musicXML: String, mei: String, abc: String, _ comentario: Comment
    ) throws {
        let esperado = sonido(try PiezaImportada(musicXML: Data(musicXML.utf8)))
        #expect(!esperado.isEmpty)
        let porMEI = try PiezaImportada(leyendo: Data(mei.utf8))
        let porABC = try PiezaImportada(leyendo: Data(abc.utf8))
        #expect(sonido(porMEI) == esperado, comentario)
        #expect(sonido(porABC) == esperado, comentario)
    }

    // MARK: Ida y vuelta

    @Test func lasVocesSalenIgualPorMEIYPorABC() throws {
        let voces = [
            ("Do4:4 Re4:8 Mi4:8~ Mi4:4 Sol4+Si4:2", "3/4"),
            ("Do4:8 Re4:8 Mi4:8 Fa4:4. Sol4:16 La4:16 Si4:2", "4/4"),
            ("Fa#4:4 Sib4:4 Do#5:4 Mib5:4 Fa#4:2 Fa4:2", "4/4"),
            ("La3:2 -:4 Mi4:4 La4:1~ La4:1", "4/4"),
            ("Do4:1/12 Re4:1/12 Mi4:1/12 Fa4:4 Sol4:2", "2/4"),
            ("Sol4:4. La4:8 Si4:4 -:2", "6/8"),
        ]
        for (texto, compas) in voces {
            let voz = try Voz(leyendo: texto, compas: Compas(leyendo: compas))
            try porTodosLosFormatos(
                musicXML: voz.partitura().musicXML(), mei: voz.partitura(encabezado: Encabezado(titulo: "Voz")).mei(),
                abc: voz.partitura(encabezado: Encabezado(titulo: "Voz")).abc(),
                Comment(rawValue: texto))
        }
    }

    @Test func losCoralesYLosAnalisisSalenIgual() throws {
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa2 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        try porTodosLosFormatos(
            musicXML: coral.partitura(
                duracion: .blanca, compas: Compas(3, 2), encabezado: Encabezado(tonalidad: Tonalidad(.do))
            ).musicXML(),
            mei: coral.partitura(
                duracion: .blanca, compas: Compas(3, 2),
                encabezado: Encabezado(titulo: "Cadencia", tonalidad: Tonalidad(.do))
            ).mei(),
            abc: coral.partitura(
                duracion: .blanca, compas: Compas(3, 2),
                encabezado: Encabezado(titulo: "Cadencia", tonalidad: Tonalidad(.do))
            ).abc(),
            "coral")
        let analisis = try AnalisisArmonico.analizar(leyendo: "Sib Mib/Sol Fa7/La Sib")
        try porTodosLosFormatos(
            musicXML: analisis.partitura().musicXML(), mei: analisis.partitura().mei(), abc: analisis.partitura().abc(),
            "análisis")

        let pieza = try PiezaImportada(
            leyendo: Data(analisis.partitura(encabezado: Encabezado(titulo: "Cadencia")).mei().utf8))
        #expect(pieza.titulo == "Cadencia")
        #expect(pieza.tonalidad?.armadura == -2)
        #expect(pieza.acordes().map(\.cifrado) == ["Si♭", "Mi♭/Sol", "Fa7/La", "Si♭"])
        let porABC = try PiezaImportada(
            leyendo: Data(analisis.partitura(encabezado: Encabezado(titulo: "Cadencia")).abc().utf8))
        #expect(porABC.titulo == "Cadencia")
        #expect(porABC.tonalidad?.armadura == -2)
        #expect(porABC.acordes().map(\.cifrado) == ["Si♭", "Mi♭/Sol", "Fa7/La", "Si♭"])
    }

    @Test func elCompasYElTempo() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:4 Mi4:4", compas: "3/4")
        for texto in [
            voz.partitura(encabezado: Encabezado(tempo: Tempo(90))).mei(),
            voz.partitura(encabezado: Encabezado(tempo: Tempo(90))).abc(),
        ] {
            let pieza = try PiezaImportada(leyendo: Data(texto.utf8))
            #expect(pieza.compas == Compas(3, 4))
            #expect(pieza.tempo.map { abs($0.negrasPorMinuto - 90) < 0.01 } == true)
        }
    }

    @Test func lasEscalasMicrotonales() throws {
        // MEI escribe los cuartos de tono y las comas; ABC, solo los cuartos (el resto, temperado).
        let tipos = TipoDeEscala.tradicionales.filter { $0.microtonal != nil }
        for tipo in tipos {
            let voz = Escala(.re, tipo).voz()
            let esperados = voz.eventos.flatMap { evento in
                evento.alturas.indices.map { i in
                    (
                        cents: Double(evento.alturas[i].midi * 100) + evento.notas[i].desvio,
                        desvio: evento.notas[i].desvio,
                        natural: evento.alturas[i].nota.natural,
                        signo: SignoMicrotonal(
                            semitonos: evento.alturas[i].nota.alteracion.semitonos, desvio: evento.notas[i].desvio)
                    )
                }
            }
            for formato in ["MEI", "ABC"] {
                let pieza = try PiezaImportada(
                    leyendo: Data((formato == "MEI" ? voz.partitura().mei() : voz.partitura().abc()).utf8))
                let leidos = pieza.notas.sorted { $0.inicio < $1.inicio }
                #expect(leidos.count == esperados.count, Comment(rawValue: "\(tipo.nombre) \(formato)"))
                for (leido, esperado) in zip(leidos, esperados) {
                    let cents = Double(leido.altura.midi * 100) + leido.desvio
                    // Los cuartos de tono salen exactos; las comas de MEI, a menos de media coma (Arel-Ezgi-Uzdilek
                    // las redondea a 53 por octava), y lo que el formato no puede escribir, temperado.
                    let margen: Double
                    switch esperado.signo {
                    case nil where abs(esperado.desvio) < 0.5: margen = 0.05
                    case .cuartos?, .koron?, .sori?:
                        // Un desvío que no es un cuarto de tono justo (la segunda neutra de 151 cents del diatónico
                        // igual de Ptolomeo) se escribe con el cuarto de tono más cercano.
                        let cuartos = esperado.desvio / 50
                        margen = 0.05 + 50 * abs(cuartos - cuartos.rounded())
                    case .comas? where formato == "MEI": margen = 11.4
                    default: margen = 50.01
                    }
                    #expect(abs(cents - esperado.cents) < margen, Comment(rawValue: "\(tipo.nombre) \(formato)"))
                    #expect(
                        leido.altura.nota.natural == esperado.natural, Comment(rawValue: "\(tipo.nombre) \(formato)"))
                }
            }
        }
    }

    // MARK: MEI escrito a mano

    @Test func unMEISinAlteracionesQueSuenan() throws {
        // Sin `accid.ges` ni `dur.ppq`, como lo escriben otros programas: la armadura (un sostenido), la alteración
        // que vale hasta la barra, un tresillo, puntillos, un acorde con ligadura y dos pentagramas.
        let mei = """
            <?xml version="1.0" encoding="UTF-8"?>
            <mei xmlns="http://www.music-encoding.org/ns/mei" meiversion="4.0.1">
              <meiHead><fileDesc><titleStmt><title>A mano</title></titleStmt></fileDesc></meiHead>
              <music><body><mdiv><score>
                <scoreDef key.sig="1s" meter.count="2" meter.unit="4" midi.bpm="100">
                  <staffGrp><staffDef n="1" lines="5"/><staffDef n="2" lines="5"/></staffGrp>
                </scoreDef>
                <section>
                  <measure n="1">
                    <staff n="1"><layer n="1">
                      <note pname="f" oct="4" dur="4"/>
                      <note pname="c" oct="5" dur="8" accid="s"/>
                      <note pname="c" oct="5" dur="8"/>
                    </layer></staff>
                    <staff n="2"><layer n="1">
                      <chord dur="2" tie="i"><note pname="g" oct="3" tie="i"/><note pname="b" oct="3" tie="i"/></chord>
                    </layer></staff>
                  </measure>
                  <measure n="2">
                    <staff n="1"><layer n="1">
                      <tuplet num="3" numbase="2">
                        <note pname="c" oct="5" dur="8"/><note pname="d" oct="5" dur="8"/><note pname="e" oct="5" dur="8"/>
                      </tuplet>
                      <note pname="f" oct="5" dur="8" dots="1"/>
                      <note pname="g" oct="5" dur="16"><accid accid="f"/></note>
                    </layer></staff>
                    <staff n="2"><layer n="1">
                      <chord dur="4"><note pname="g" oct="3" tie="t"/><note pname="b" oct="3" tie="t"/></chord>
                      <rest dur="4"/>
                    </layer></staff>
                  </measure>
                  <measure n="3"><staff n="1"><layer n="1"><mRest/></layer></staff></measure>
                  <measure n="4"><staff n="1"><layer n="1"><note pname="c" oct="5" dur="2"/></layer></staff></measure>
                </section>
              </score></mdiv></body></music>
            </mei>
            """
        let pieza = try PiezaImportada(leyendo: Data(mei.utf8))
        #expect(pieza.titulo == "A mano")
        #expect(pieza.tonalidad == Tonalidad(.sol))
        #expect(pieza.compas == Compas(2, 4))
        #expect(pieza.tempo.map { abs($0.negrasPorMinuto - 100) < 0.01 } == true)
        let notas = pieza.notas.map { "\($0.altura) \(f($0.inicio)) \(f($0.duracion)) \($0.parte)" }
        #expect(
            notas == [
                "Sol3 0 3/4 1", "Si3 0 3/4 1", "Fa♯4 0 1/4 0",
                "Do♯5 1/4 1/8 0", "Do♯5 3/8 1/8 0",
                "Do5 1/2 1/12 0", "Re5 7/12 1/12 0", "Mi5 2/3 1/12 0",
                "Fa♯5 3/4 3/16 0", "Sol♭5 15/16 1/16 0",
                "Do5 3/2 1/2 0",
            ])
    }

    @Test func unMEIQueNoEsPartitura() throws {
        let error = { (texto: String) -> ErrorDeLecturaDeFichero? in
            do {
                _ = try PiezaImportada(leyendo: Data(texto.utf8))
                return nil
            } catch { return error as? ErrorDeLecturaDeFichero }
        }
        #expect(error("<mei><music/></mei>") == .sinNotas)
        #expect(error("<mei><music><note pname=\"c\" oct=\"4\" dur=\"4\"></mei>") == .xmlDanado(linea: 1))
        #expect(throws: ErrorDeLecturaDeFichero.noEsMusicXMLPorPartes) {
            try PiezaImportada(mei: Data("<score-partwise/>".utf8))
        }
        // Valores que no son de MEI: la nota no se lee, pero no se detiene nada.
        let raro = """
            <mei><music><body><mdiv><score><section><measure><staff n="1"><layer>
            <note pname="h" oct="4" dur="4"/><note pname="c" oct="99999999999" dur="4"/>
            <note pname="c" oct="4" dur="3"/><note pname="c" oct="4" dur="4" dots="40"/>
            <note pname="c" oct="4" dur="4" accid="zz"/>
            <tuplet num="0" numbase="0"><note pname="d" oct="4" dur="4"/></tuplet>
            </layer></staff></measure></section></score></mdiv></body></music></mei>
            """
        let pieza = try PiezaImportada(leyendo: Data(raro.utf8))
        #expect(pieza.notas.map(\.altura) == ["Do4", "Re4"])
    }

    // MARK: ABC escrito a mano

    @Test func unABCComoLosDeLosCancioneros() throws {
        let abc = """
            %abc-2.1
            X:1
            T:The Kesh
            T:Otro título
            R:jig
            M:6/8
            L:1/8
            Q:3/8=120
            K:Gmaj
            % un comentario
            "G"GAG GAB|"D"ABA ABd|edd gdd|edB dBA:|
            [CEG]2 z (3cde c>d d<e|^f f =f F,, G'-|G4 _/B {g}A2 !trill!B|]
            w: una letra que no cuenta
            """
        let pieza = try PiezaImportada(leyendo: Data(abc.utf8))
        #expect(pieza.titulo == "The Kesh")
        #expect(pieza.compas == Compas(6, 8))
        #expect(pieza.tonalidad == Tonalidad(.sol))
        #expect(pieza.tempo == Tempo(120, unidad: Duracion(3, 8)))
        let notas = pieza.notas.map { "\($0.altura) \(f($0.inicio)) \(f($0.duracion))" }
        // La primera línea: 24 corcheas desde Sol4 (los cifrados entre comillas no cuentan), dos veces: acaba en una
        // repetición, que vuelve al principio.
        #expect(notas.prefix(3) == ["Sol4 0 1/8", "La4 1/8 1/8", "Sol4 1/4 1/8"])
        #expect(notas[23] == "La4 23/8 1/8")
        #expect(notas[24] == "Sol4 3 1/8")
        #expect(notas[47] == "La4 47/8 1/8")
        #expect(
            Array(notas[48...]) == [
                // El acorde, el silencio, el tresillo y el ritmo con puntillo («c>d d<e»).
                "Do4 6 1/4", "Mi4 6 1/4", "Sol4 6 1/4",
                "Do5 51/8 1/12", "Re5 155/24 1/12", "Mi5 157/24 1/12",
                "Do5 53/8 3/16", "Re5 109/16 1/16", "Re5 55/8 1/16", "Mi5 111/16 3/16",
                // Las alteraciones valen hasta la barra y en su octava: el Fa♯ de la armadura vuelve en Fa,,
                // (Fa♯2). Sol' y Sol4 no se ligan: no son la misma nota.
                "Fa♯5 57/8 1/8", "Fa♯5 29/4 1/8", "Fa5 59/8 1/8", "Fa♯2 15/2 1/8", "Sol5 61/8 1/8", "Sol4 31/4 1/2",
                // `_/B` es un cuarto de tono bajo Si (Si♭ y 50 cents), y vale hasta la barra.
                "Si♭4 33/4 1/8", "La4 67/8 1/4", "Si♭4 69/8 1/8",
            ])
        #expect(pieza.notas[64].desvio == 50 && pieza.notas[66].desvio == 50)
        // El adorno ({g}) va aparte, donde empieza la nota a la que adorna.
        #expect(pieza.notasDeAdorno.map { "\($0.altura) \(f($0.inicio)) \(f($0.duracion))" } == ["Sol5 67/8 0"])
    }

    @Test func lasVocesDeUnABC() throws {
        let abc = """
            X:1
            M:4/4
            L:1/4
            K:C
            V:1
            c d e f|
            V:2
            C2 G,2|
            V:1
            g4|]
            V:2
            [C,E,G,]4|]
            """
        let pieza = try PiezaImportada(abc: abc)
        let partes = Dictionary(grouping: pieza.notas, by: \.parte).mapValues {
            $0.map { "\($0.altura) \(f($0.inicio))" }
        }
        #expect(partes[0] == ["Do5 0", "Re5 1/4", "Mi5 1/2", "Fa5 3/4", "Sol5 1"])
        #expect(partes[1] == ["Do4 0", "Sol3 1/2", "Do3 1", "Mi3 1", "Sol3 1"])
        // Sin `X:` no es ABC, y sin notas no hay pieza.
        #expect(throws: ErrorDeLecturaDeFichero.formatoDesconocido) {
            try PiezaImportada(leyendo: Data("c d e f".utf8))
        }
        #expect(throws: ErrorDeLecturaDeFichero.sinNotas) {
            try PiezaImportada(leyendo: Data("X:1\nT:Nada\nK:C\n".utf8))
        }
    }

    @Test func losModosYLasUnidadesDeABC() throws {
        func primera(_ cabecera: String, _ musica: String) throws -> PiezaImportada {
            try PiezaImportada(abc: "X:1\n" + cabecera + "\n" + musica + "\n")
        }
        // K: con modos: Re dórico no tiene armadura, Mi frigio tampoco, La mixolidio tiene dos sostenidos.
        #expect(try primera("K:D dor", "F").notas[0].altura == "Fa4")
        #expect(try primera("K:A mix", "F C").notas.map(\.altura) == ["Fa♯4", "Do♯4"])
        #expect(try primera("K:Bbm", "E").notas[0].altura == "Mi♭4")
        #expect(try primera("K:Bbm", "E").tonalidad == Tonalidad(armadura: -5, modo: .menor))
        // Sin L:, la unidad es la semicorchea si el compás es de menos de 3/4, y la corchea si no.
        #expect(try primera("M:2/4\nK:C", "C").notas[0].duracion == Duracion(1, 16))
        #expect(try primera("M:3/4\nK:C", "C").notas[0].duracion == Duracion(1, 8))
        #expect(
            try primera("L:1/4\nK:C", "C3/2 C/ C// C3").notas.map(\.duracion) == [
                Duracion(3, 8), Duracion(1, 8), Duracion(1, 16), Duracion(3, 4),
            ])
        // Un cambio en medio de la música, y un silencio de varios compases.
        #expect(
            try primera("M:4/4\nL:1/4\nK:C", "C [L:1/8] C Z2 | [K:F] B").notas.map { "\($0.altura) \(f($0.inicio))" }
                == [
                    "Do4 0", "Do4 1/4", "Si♭4 19/8",
                ])
    }

    // MARK: El lector de XML

    private final class Registro: LectorDeElementosXML {
        var sucesos: [String] = []
        func abre(_ nombre: String, atributos: [String: String]) {
            sucesos.append(
                "<" + nombre + atributos.sorted { $0.key < $1.key }.map { " \($0.key)=\($0.value)" }.joined())
        }
        func texto(_ texto: String) {
            if !texto.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { sucesos.append(texto) }
        }
        func cierra(_ nombre: String) { sucesos.append("/" + nombre) }
    }

    private func leer(_ texto: String) throws -> [String] {
        let registro = Registro()
        try LectorXML.leer(Data(texto.utf8), con: registro)
        return registro.sucesos
    }

    private func linea(_ texto: String) -> Int? {
        do {
            _ = try leer(texto)
            return nil
        } catch ErrorDeLecturaDeFichero.xmlDanado(let linea) {
            return linea
        } catch { return -1 }
    }

    @Test func elLectorDeXML() throws {
        #expect(
            try leer(
                """
                <?xml version="1.0"?>
                <!DOCTYPE a PUBLIC "-//x//DTD//EN" "http://x/a.dtd" [ <!ENTITY e "no se expande"> <!-- ] --> ]>
                <!-- un comentario -->
                <a b='1' c="&lt;&amp;&#233;&#x1D11E;">x &gt; y<br/><![CDATA[<tal cual>]]>&e;</a>
                """) == ["<a b=1 c=<&é𝄞", "x > y", "<br", "/br", "<tal cual>", "&e;", "/a"])
        // Lo que no está bien formado, con su línea.
        #expect(linea("<a>\n<b></a>") == 2)
        #expect(linea("<a></a><b/>") == 1)
        #expect(linea("texto<a/>") == 1)
        #expect(linea("<a b=1/>") == 1)
        #expect(linea("<a b=\"1\" b=\"2\"/>") == 1)
        #expect(linea("<a\n\nb=\"1") == 3)
        #expect(linea("<a>\n<!-- sin cerrar") == 2)
        #expect(linea("<a>&#0;</a>") == 1)
        #expect(linea("<a><1b/></a>") == 1)
        #expect(linea("") == 1)
        #expect(linea("<a>") == 1)
        // En UTF-16, con su marca.
        let utf16 = Data([0xFF, 0xFE]) + "<a>ñ</a>".data(using: .utf16LittleEndian)!
        let registro = Registro()
        try LectorXML.leer(utf16, con: registro)
        #expect(registro.sucesos == ["<a", "ñ", "/a"])
        #expect(LectorXML.raiz(de: Data("<?xml version=\"1.0\"?><!DOCTYPE mei><mei><sin cerrar".utf8)) == "mei")
    }
}
