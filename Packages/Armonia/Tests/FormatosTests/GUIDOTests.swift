import Foundation
import Testing

@testable import Elementos
@testable import Formatos
@testable import PartituraArmonia
@testable import Teoria

@Suite struct GUIDOTests {
    @Test func escribeLasAlturasYLasDuraciones() {
        #expect(EscritorGUIDO.altura(Altura("Do4")) == "c1")
        #expect(EscritorGUIDO.altura(Altura("Fa#3")) == "f#0")
        #expect(EscritorGUIDO.altura(Altura("Sib1")) == "b&-2")
        #expect(EscritorGUIDO.altura(Altura("Mibb6")) == "e&&3")
        // Sin triples: la nota vecina que suena igual.
        #expect(EscritorGUIDO.altura(Altura(Nota(.fa, Alteracion(3)), octava: 4)) == "g#1")
        #expect(EscritorGUIDO.duracion(.negra) == "/4")
        #expect(EscritorGUIDO.duracion(Duracion(3, 8)) == "*3/8")
        #expect(EscritorGUIDO.duracion(Duracion(1, 12)) == "/12")
        #expect(EscritorGUIDO.duracion(Duracion(2)) == "*2")
        #expect(EscritorGUIDO.duracion(Duracion(5, 16)) == "*5/16")
        #expect(EscritorGUIDO.clave(.fa) == "f4")
        #expect(EscritorGUIDO.clave(.solOctavaBaja) == "g2-8")
        #expect(EscritorGUIDO.cadena(#"Mi "canción""#) == #""Mi \"canción\"""#)
    }

    @Test func deUnaVoz() throws {
        let voz = try Voz(
            leyendo: "Sol4:4 Do5:2 Re5:8 Mi5:8 Fa#5:4 Sol5:2. Do5:1/12 Re5:1/12 Mi5:1/12 Fa5:4 -:4", compas: "3/4",
            anacrusa: .negra)
        let gmn = voz.partitura(
            encabezado: Encabezado(
                titulo: #"Mi "canción""#, tonalidad: Tonalidad(.sol), tempo: Tempo(60, unidad: Duracion(3, 8)))
        ).guido()
        #expect(
            gmn.hasPrefix(
                #"{\#n  [ \title<"Mi \"canción\""> \staff<1> \instr<"Voz"> \clef<"g2"> \key<1> "#
                    + #"\meter<"3/4", autoBarlines="off"> \tempo<"[3/8] = 60", "3/8=60">\#n"#))
        // La anacrusa, en su propio compás; las barras, a mano.
        #expect(gmn.contains("\n    g1/4 \\bar\n    c2/2 d2/8 e2/8 \\bar\n"))
        // La ligadura cruza la barra y se cierra después de la nota siguiente; el tresillo, con `\tuplet`.
        #expect(gmn.contains("f#2/4 \\tieBegin:1 g2/2 \\bar\n"))
        #expect(gmn.contains(#"g2/4 \tieEnd:1 \tuplet<"-3-">( c2/12 d2/12 e2/12 ) f2/4 \bar"#))
        #expect(gmn.hasSuffix("    _/4\n    \\endBar\n  ]\n}\n"))
        #expect(gmn.components(separatedBy: "\\tieBegin").count == gmn.components(separatedBy: "\\tieEnd").count)
    }

    @Test func deUnCoralConCifradosYAnalisis() throws {
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa2 La3 Fa4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let gmn = coral.partitura(
            duracion: .blanca, compas: "3/2", encabezado: Encabezado(titulo: "Cadencia"), conCifrados: true,
            conAnalisis: true
        ).guido()
        #expect(gmn.contains(#"\title<"Cadencia"> \accol<id=1, range="1-2"> \staff<1> \instr<"Coro">"#))
        #expect(gmn.components(separatedBy: "\\staff<").count == 5)
        #expect(gmn.components(separatedBy: "\\stemsUp").count == 3)
        #expect(gmn.contains(#"\harmony<"Do">(c2/2) \harmony<"Fa">(c2/2) \harmony<"Sol">(b1/2) \bar"#))
        // El análisis y la tonalidad, debajo del bajo, cada línea más baja.
        #expect(
            gmn.contains(#"\text<"Do mayor:", dy=-8hs>(\text<"I", dy=-11hs>(\text<"T", dy=-14hs>(c0/2)))"#))
        #expect(gmn.contains(#"\stemsDown \clef<"f4">"#))
    }

    @Test func deUnaProgresionEnAmalgama() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        let gmn = analisis.partitura(
            duracion: .blanca, compas: Compas(7, 8, agrupacion: [2, 2, 3]), notacion: .inglesCompacto
        ).guido()
        #expect(gmn.contains(#"\meter<"2+2+3/8", autoBarlines="off">"#))
        #expect(gmn.contains(#"\harmony<"D7">({d1/8, f#1/8, a1/8, c2/8})"#))
        #expect(gmn.contains(#"\instr<"Piano">"#))
        #expect(!gmn.contains("\\title"))
        #expect(gmn.components(separatedBy: "\\tieBegin").count == gmn.components(separatedBy: "\\tieEnd").count)
    }
}
