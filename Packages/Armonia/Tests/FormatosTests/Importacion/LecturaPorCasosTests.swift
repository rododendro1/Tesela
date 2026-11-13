import Foundation
import Testing

@testable import Formatos
@testable import Partituras

/// Una duración como fracción de redonda: «3/8», «1».
private func f(_ duracion: Duracion) -> String {
    duracion.denominador == 1 ? "\(duracion.numerador)" : "\(duracion.numerador)/\(duracion.denominador)"
}

/// Las notas de una pieza como «altura inicio duración», en el orden en que se leen.
private func notas(_ pieza: PiezaImportada) -> [String] {
    pieza.notas.map { "\($0.altura) \(f($0.inicio)) \(f($0.duracion))" }
}

/// Lo que se lee de ABC y de MEI, construcción a construcción: cada caso es un trozo de música y las notas que salen
/// de él. Un caso que falla dice qué signo se lee mal; las pruebas de ficheros enteros
/// (`ImportacionMEIYABCTests`) dicen que algo falla, pero no qué.
@Suite struct LecturaPorCasosTests {
    // MARK: ABC

    /// Un trozo de música de ABC en 4/4, con la negra por unidad y en Do mayor.
    struct CasoABC: CustomTestStringConvertible, Sendable {
        let musica: String
        let notas: [String]
        var testDescription: String { musica }
    }

    static let casosABC: [CasoABC] = [
        // Las notas y sus octavas.
        CasoABC(musica: "C D E F", notas: ["Do4 0 1/4", "Re4 1/4 1/4", "Mi4 1/2 1/4", "Fa4 3/4 1/4"]),
        CasoABC(musica: "c C, c'", notas: ["Do5 0 1/4", "Do3 1/4 1/4", "Do6 1/2 1/4"]),
        // Las longitudes, por la unidad.
        CasoABC(musica: "C2 C/ C3/2 C//", notas: ["Do4 0 1/2", "Do4 1/2 1/8", "Do4 5/8 3/8", "Do4 1 1/16"]),
        // Una alteración vale hasta la barra y en su octava; el becuadro la quita.
        CasoABC(musica: "^F F f | F", notas: ["Fa♯4 0 1/4", "Fa♯4 1/4 1/4", "Fa5 1/2 1/4", "Fa4 3/4 1/4"]),
        CasoABC(musica: "_B =B", notas: ["Si♭4 0 1/4", "Si4 1/4 1/4"]),
        // El acorde dura lo de su primera nota por lo que va detrás del corchete.
        CasoABC(musica: "[CEG]2 C", notas: ["Do4 0 1/2", "Mi4 0 1/2", "Sol4 0 1/2", "Do4 1/2 1/4"]),
        // La ligadura junta las dos notas; dentro de un acorde, liga el acorde entero.
        CasoABC(musica: "C- C D", notas: ["Do4 0 1/2", "Re4 1/2 1/4"]),
        CasoABC(musica: "[C-E-] [CE]", notas: ["Do4 0 1/2", "Mi4 0 1/2"]),
        // El tresillo: tres en el tiempo de dos. Un paréntesis sin cifra es una ligadura de expresión.
        CasoABC(musica: "(3CDE F", notas: ["Do4 0 1/6", "Re4 1/6 1/6", "Mi4 1/3 1/6", "Fa4 1/2 1/4"]),
        CasoABC(musica: "(CD)", notas: ["Do4 0 1/4", "Re4 1/4 1/4"]),
        // El ritmo con puntillo.
        CasoABC(musica: "C>D E<F", notas: ["Do4 0 3/8", "Re4 3/8 1/8", "Mi4 1/2 1/8", "Fa4 5/8 3/8"]),
        // Los silencios, visibles o no, y los de compases enteros.
        CasoABC(musica: "z C x D", notas: ["Do4 1/4 1/4", "Re4 3/4 1/4"]),
        CasoABC(musica: "Z2 | C", notas: ["Do4 2 1/4"]),
        // Los campos en medio de la música valen desde ahí.
        CasoABC(musica: "F [K:G] F", notas: ["Fa4 0 1/4", "Fa♯4 1/4 1/4"]),
        CasoABC(musica: "C [L:1/8] C C", notas: ["Do4 0 1/4", "Do4 1/4 1/8", "Do4 3/8 1/8"]),
        // Lo que no suena: los cifrados y los textos entre comillas, los adornos y los comentarios.
        CasoABC(musica: "\"Am\"C !trill!D", notas: ["Do4 0 1/4", "Re4 1/4 1/4"]),
        CasoABC(musica: "C % D E", notas: ["Do4 0 1/4"]),
        // Las repeticiones y las casillas se despliegan.
        CasoABC(musica: "|: C D :| E", notas: ["Do4 0 1/4", "Re4 1/4 1/4", "Do4 1/2 1/4", "Re4 3/4 1/4", "Mi4 1 1/4"]),
    ]

    @Test(arguments: casosABC) func abc(_ caso: CasoABC) throws {
        let pieza = try PiezaImportada(abc: "X:1\nM:4/4\nL:1/4\nK:C\n" + caso.musica + "\n")
        #expect(notas(pieza) == caso.notas)
    }

    @Test func lasDecoracionesYLosAdornosDeABC() throws {
        let pieza = try PiezaImportada(abc: "X:1\nM:4/4\nL:1/4\nK:C\n!mf! C .D !fermata!E {g}F\n")
        #expect(pieza.notas.map(\.dinamica) == [.mf, nil, nil, nil])
        #expect(pieza.notas.map(\.articulaciones) == [[], [.staccato], [.calderon], []])
        // La nota de adorno, aparte y sin duración, donde empieza la nota a la que adorna.
        #expect(pieza.notasDeAdorno.map { "\($0.altura) \(f($0.inicio)) \(f($0.duracion))" } == ["Sol5 3/4 0"])
    }

    // MARK: MEI

    /// Lo que va dentro de una capa de un compás de 4/4 de MEI.
    struct CasoMEI: CustomTestStringConvertible, Sendable {
        let descripcion: String
        let capa: String
        let notas: [String]
        var testDescription: String { descripcion }
    }

    static let casosMEI: [CasoMEI] = [
        CasoMEI(
            descripcion: "notas", capa: #"<note pname="c" oct="4" dur="4"/><note pname="g" oct="5" dur="2"/>"#,
            notas: ["Do4 0 1/4", "Sol5 1/4 1/2"]),
        CasoMEI(
            descripcion: "puntillos, en atributo o en elemento",
            capa: #"<note pname="c" oct="4" dur="4" dots="1"/><note pname="d" oct="4" dur="4"><dot/></note>"#,
            notas: ["Do4 0 3/8", "Re4 3/8 3/8"]),
        CasoMEI(
            descripcion: "alteraciones, en atributo o en elemento",
            capa:
                #"<note pname="f" oct="4" dur="4" accid="s"/><note pname="b" oct="4" dur="4"><accid accid="f"/></note>"#,
            notas: ["Fa♯4 0 1/4", "Si♭4 1/4 1/4"]),
        CasoMEI(
            descripcion: "acorde",
            capa:
                #"<chord dur="2"><note pname="c" oct="4"/><note pname="e" oct="4"/></chord><note pname="g" oct="4" dur="4"/>"#,
            notas: ["Do4 0 1/2", "Mi4 0 1/2", "Sol4 1/2 1/4"]),
        CasoMEI(
            descripcion: "silencio y espacio",
            capa: #"<rest dur="4"/><note pname="c" oct="4" dur="4"/><space dur="4"/><note pname="d" oct="4" dur="4"/>"#,
            notas: ["Do4 1/4 1/4", "Re4 3/4 1/4"]),
        CasoMEI(
            descripcion: "tresillo",
            capa: #"<tuplet num="3" numbase="2"><note pname="c" oct="4" dur="8"/><note pname="d" oct="4" dur="8"/>"#
                + #"<note pname="e" oct="4" dur="8"/></tuplet><note pname="f" oct="4" dur="4"/>"#,
            notas: ["Do4 0 1/12", "Re4 1/12 1/12", "Mi4 1/6 1/12", "Fa4 1/4 1/4"]),
        CasoMEI(
            descripcion: "ligadura",
            capa: #"<note pname="c" oct="4" dur="4" tie="i"/><note pname="c" oct="4" dur="4" tie="t"/>"#
                + #"<note pname="d" oct="4" dur="4"/>"#,
            notas: ["Do4 0 1/2", "Re4 1/2 1/4"]),
    ]

    @Test(arguments: casosMEI) func mei(_ caso: CasoMEI) throws {
        let mei = """
            <mei xmlns="http://www.music-encoding.org/ns/mei"><music><body><mdiv><score>
            <scoreDef meter.count="4" meter.unit="4"><staffGrp><staffDef n="1" lines="5"/></staffGrp></scoreDef>
            <section><measure n="1"><staff n="1"><layer n="1">\(caso.capa)</layer></staff></measure></section>
            </score></mdiv></body></music></mei>
            """
        #expect(notas(try PiezaImportada(mei: Data(mei.utf8))) == caso.notas)
    }

    @Test func lasRepeticionesDeMEI() throws {
        let compas = { (nota: String, atributos: String) in
            #"<measure \#(atributos)><staff n="1"><layer n="1"><note pname="\#(nota)" oct="4" dur="1"/></layer></staff></measure>"#
        }
        let mei = """
            <mei><music><body><mdiv><score><scoreDef meter.count="4" meter.unit="4"/><section>
            \(compas("c", #"left="rptstart""#))\(compas("d", #"right="rptend""#))\(compas("e", ""))
            </section></score></mdiv></body></music></mei>
            """
        #expect(
            notas(try PiezaImportada(mei: Data(mei.utf8))) == ["Do4 0 1", "Re4 1 1", "Do4 2 1", "Re4 3 1", "Mi4 4 1"])
    }
}
