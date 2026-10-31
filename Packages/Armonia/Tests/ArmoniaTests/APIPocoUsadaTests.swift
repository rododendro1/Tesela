import Foundation
import XCTest

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria
@testable import ArmoniaTrastes

// La parte de la API que no usan las apps ni el resto del motor: las descripciones, los atajos y los
// casos raros de cada idioma. Cada prueba fija lo que da hoy, para que un cambio no pase sin verse.

final class APIPocoUsadaDelNucleoTests: XCTestCase {
    func testDescripciones() {
        XCTAssertEqual("\(NotaNatural.re)", "Re")
        XCTAssertEqual("\(Alteracion(1))", "sostenido")
        XCTAssertEqual("\(CalidadDeIntervalo.mayor)", "mayor")
        XCTAssertEqual("\(Consonancia.perfecta)", "consonancia perfecta")
        XCTAssertEqual(Consonancia.disonancia.nombre, "disonancia")
        XCTAssertEqual(Consonancia.disonancia.nombre(en: .inglesASCII), "dissonance")
        XCTAssertEqual(
            ErrorDeLectura(texto: "", posicion: nil, motivo: .textoVacio).errorDescription,
            "Valor no válido: el texto está vacío")
    }

    func testAlteracionesYNotas() {
        XCTAssertEqual(Alteracion(2) - Alteracion(3), Alteracion(-1))
        XCTAssertEqual(Nota("Fa").sostenido, Nota("Fa#"))
        XCTAssertEqual(Nota("Fa#").nombreASCII, "Fa#")
        XCTAssertEqual(try Nota(leyendo: "Si𝄫").nombre, "Si♭♭")
        XCTAssertEqual(try Nota(leyendo: "Do♮"), Nota("Do"))
        // Con más de cuatro signos, el número.
        XCTAssertEqual(Alteracion(5).nombre(en: .aleman), "5 Kreuze")
        XCTAssertEqual(Alteracion(-5).nombre(en: .aleman), "5 Be")
        XCTAssertEqual(Alteracion(5).nombre(en: .euskera), "5 diesa")
    }

    func testAlturas() throws {
        XCTAssertTrue(Altura("Do4").esEnarmonica(de: Altura("Si#3")))
        XCTAssertFalse(Altura("Do4").esEnarmonica(de: Altura("Do5")))
        XCTAssertEqual(try Altura(leyendo: "C#4", en: .inglesASCII), Altura("Do#4"))
    }

    func testIntervalos() {
        XCTAssertEqual(Intervalo.terceraMayor.descendente.sentido, .descendente)
        XCTAssertEqual(Intervalo.terceraMayor.descendente.ascendente, .terceraMayor)
        XCTAssertEqual(Intervalo.quintaJusta.cents(), 700, accuracy: 1e-9)
        // Las multiplicidades de más de tres, y el unísono en masculino en occitano.
        for idioma in Idioma.allCases {
            let notacion = Notacion.delIdioma(idioma)
            XCTAssertNotEqual(
                Intervalo(numero: 4, calidad: .aumentada(4))?.nombre(en: notacion),
                Intervalo(numero: 4, calidad: .aumentada(3))?.nombre(en: notacion), idioma.codigo)
        }
        XCTAssertEqual(Intervalo(numero: 1, calidad: .aumentada(1))?.nombre(en: .occitano), "unisson aumentat")
        XCTAssertEqual(
            Intervalo(numero: 1, calidad: .aumentada(2))?.nombre(en: .occitano), "unisson doblament aumentat")
        XCTAssertNil(Intervalo(numero: 1, calidad: .disminuida(1)))
        XCTAssertEqual(Intervalo.ordinalEnCifras(5, en: .griego), "5η")
        XCTAssertEqual(Intervalo.ordinalEnCifras(5, en: .ruso), "5-я")
    }

    func testPluralesRusos() {
        XCTAssertEqual(Traduccion.pluralRuso(1, "a", "b", "c"), "1 a")
        XCTAssertEqual(Traduccion.pluralRuso(3, "a", "b", "c"), "3 b")
        XCTAssertEqual(Traduccion.pluralRuso(12, "a", "b", "c"), "12 c")
        XCTAssertEqual(Traduccion.pluralRuso(21, "a", "b", "c"), "21 a")
        XCTAssertEqual(Traduccion.pluralRuso(25, "a", "b", "c"), "25 c")
    }

    func testConjuntosCodable() throws {
        let conjunto = ConjuntoDeClases([0, 4, 7])
        let datos = try JSONEncoder().encode(conjunto)
        XCTAssertEqual(String(decoding: datos, as: UTF8.self), "[0,4,7]")
        XCTAssertEqual(try JSONDecoder().decode(ConjuntoDeClases.self, from: datos), conjunto)
    }

    func testUnCaminoQueNoLlega() {
        let camino: [Int]? = caminoMasCorto(
            desde: 0, clave: { $0 }, vecinos: { n in n < 3 ? [(n + 1, n + 1)] : [] },
            llega: { $0 == 10 })
        XCTAssertNil(camino)
    }
}

final class APIPocoUsadaDeLaTeoriaTests: XCTestCase {
    func testDescripciones() {
        XCTAssertEqual("\(FuncionTonal.dominante)", "dominante")
        XCTAssertEqual(FuncionTonal.dominante.nombre, "dominante")
        XCTAssertEqual("\(NombreDeGrado.dominante)", "dominante")
        XCTAssertEqual("\(TipoDeAcorde(""))", "mayor")
        XCTAssertEqual("\(TipoDeAcorde("m7"))", "m7")
        XCTAssertEqual("\(Cadencia.Tipo.plagal)", "cadencia plagal")
        XCTAssertEqual(Cadencia.Tipo.plagal.nombre(en: .inglesASCII), "plagal cadence")
        XCTAssertEqual("\(FaltaDeConduccion.Tipo.superposicion)", "Superposición")
        XCTAssertEqual(FaltaDeConduccion.Tipo.separacionExcesiva.nombre, "Más de una octava")
        XCTAssertEqual(CalidadDeTriada.sinTercera.nombre, "sin tercera")
        XCTAssertEqual(PapelEnAcorde.tension(9).nombre(en: .espanolUnicode), "novena")
        XCTAssertEqual(PapelEnAcorde.tension(4).nombre(en: .espanolUnicode), "tensión 4ª")
        XCTAssertEqual(Tonalidad(.do, .mayor).analizar([Acorde("Sol7")]).acordes[0].description, "V7")
    }

    func testAcordes() {
        XCTAssertEqual(Acorde("Do7/Mi").nombre, "Do séptima de dominante, primera inversión")
        XCTAssertEqual(Acorde("Do/Re").nombre, "Do mayor, con bajo en Re")
        XCTAssertTrue(Acorde("Do7").contiene(Nota("Sib")))
        XCTAssertFalse(Acorde("Do7").contiene(Nota("Si")))
        XCTAssertTrue(TipoDeAcorde("7").tieneSeptima)
        XCTAssertFalse(TipoDeAcorde("m").tieneSeptima)
        XCTAssertTrue(Acorde("Do7").estructura.tieneSeptima)
        XCTAssertEqual(Acorde("Do7").estructura.intervalos(conPapel: .tercera), [.terceraMayor])
        XCTAssertEqual(
            Acorde.identificar(clasesDeAltura: [2, 5, 9], escala: Escala(.do, .mayor)).first?.cifrado, "Rem")
        XCTAssertEqual(Arpegio(Acorde("Do")).notas, [Nota("Do"), Nota("Mi"), Nota("Sol"), Nota("Do")])
    }

    func testTonalidades() {
        let doMayor = Tonalidad(.do, .mayor)
        XCTAssertEqual(doMayor.grado(5), Nota("Sol"))
        XCTAssertEqual(doMayor.nombre(claseDeAltura: 10), Nota("Sib"))
        XCTAssertEqual(doMayor.lugar(en: .ruso), "в до мажоре")
        XCTAssertEqual(Tonalidad(.la, .menor).lugar(en: .ruso), "в ля миноре")
        XCTAssertEqual(doMayor.lugar(en: .griego), "σε ντο μείζονα")
        let notas = [Nota("Sol"), Nota("Si"), Nota("Re"), Nota("Fa#")]
        XCTAssertEqual(Tonalidad.identificar(notas: notas), Tonalidad.candidatos(notas: notas).map(\.valor))
    }

    func testUnRecorridoQueModulaSinPivote() throws {
        let recorrido = try XCTUnwrap(
            RecorridoTonal(["Do", "Fa", "Sol7", "Do", "Fa#", "Si", "Do#7", "Fa#"].map { Acorde(texto: $0)! }))
        XCTAssertEqual(recorrido.tonalidadDePartida, Tonalidad(.do, .mayor))
        XCTAssertEqual(recorrido.tonalidadDeLlegada, try Tonalidad(leyendo: "Fa# mayor"))
        XCTAssertEqual(recorrido.modulaciones.map(\.description), ["De Do mayor a Fa♯ mayor en el acorde 5 (directa)"])
        XCTAssertEqual(recorrido.tramos.map(\.description), ["I–IV–V7–I en Do mayor", "I–IV–V7–I en Fa♯ mayor"])
    }

    func testCorales() throws {
        XCTAssertEqual(Coral.nombreDeVoz(4, de: 5, en: .espanolUnicode), "voz 5")
        let armonizacion = try XCTUnwrap(
            Tonalidad(.do, .mayor).armonizar(melodia: [Nota("Mi"), Nota("Re"), Nota("Do")]).first?.valor)
        XCTAssertNotNil(armonizacion.realizar(soprano: [Altura("Mi5"), Altura("Re5"), Altura("Do5")]))
        XCTAssertNil(armonizacion.realizar(soprano: [Altura("Mi5"), Altura("Mi5"), Altura("Do5")]))
        // Una melodía de una sola nota.
        XCTAssertEqual(Tonalidad(.do, .mayor).armonizarACuatroVoces([Altura("Do5")])?.coral.acordes.count, 1)
    }
}

final class APIPocoUsadaDeLasRepresentacionesTests: XCTestCase {
    func testDescripciones() throws {
        XCTAssertEqual("\(MovimientoDeVoz(desde: Nota("Fa"), hasta: Nota("Mi")))", "Fa→Mi")
        XCTAssertEqual(
            CicloNeorriemanniano.allCases.map { $0.nombre }, ["ciclo hexatónico", "ciclo octatónico", "ciclo LR"])
        XCTAssertEqual(CicloNeorriemanniano.lr.description, "ciclo LR")
        XCTAssertEqual("\(TransformacionNeorriemanniana.p)", "P")
        XCTAssertEqual("\(Tonnetz.Triada(Acorde("Lam"))!)", "Lam")
        XCTAssertEqual("\(CorrespondenciaDeColores.newton)", "Newton (1704)")
        XCTAssertEqual(CorrespondenciaDeColores.scriabin.nombre, "Scriabin (1911)")
        XCTAssertEqual("\(try FormatoUIL(leyendo: "2,7,5;R30M"))", "2,7,5;R30M")
    }

    func testErroresDeUIL() {
        XCTAssertEqual(
            "\(ErrorDeUIL.intervalosIncoherentes(menor: 1, mayor: 2, diferencia: 3))",
            "Intervalos incoherentes: 1,2,3. Deben cumplir 0 < L ≤ D y G = L + D.")
        XCTAssertEqual("\(ErrorDeUIL.rotacionNoValida(45))", "El giro de 45° no es múltiplo de 30°.")
        XCTAssertEqual(
            "\(ErrorDeUIL.afinacionNoSoportada(tonos: 19))", "Solo se dibujan teclados de 12 notas, no de 19.")
        XCTAssertEqual("\(ErrorDeUIL.cizallaNoSoportada(2))", "La cizalla S2 no está soportada.")
        XCTAssertThrowsError(try FormatoUIL(leyendo: "2,7,5;R0Tx"))
        XCTAssertEqual(try FormatoUIL(leyendo: "2,7,5;R30;M").descripcion, "2,7,5;R30M")
    }

    func testAfinacionDesdeLaFrecuenciaDeLaTonica() {
        let afinacion = EntonacionJusta(tonica: Nota("La"), frecuenciaTonica: 432)
        XCTAssertEqual(afinacion.frecuencia(de: Altura("La4")), 432, accuracy: 1e-9)
    }
}

final class APIPocoUsadaDeLaPartituraTests: XCTestCase {
    func testDescripciones() {
        XCTAssertEqual("\(Figura.negra)", "negra")
        XCTAssertEqual("\(Clave.fa)", "clave de fa")
        XCTAssertEqual(
            Clave.allCases.map(\.nombre),
            [
                "clave de sol", "clave de sol octava baja", "clave de sol octava alta", "clave de fa",
                "clave de fa en tercera", "clave de do en primera", "clave de do en segunda", "clave de do en tercera",
                "clave de do en cuarta",
            ])
        XCTAssertEqual("\(InstrumentoDePartitura.flauta)", "flauta")
        XCTAssertEqual("\(FaltaDeContrapunto.Tipo.allCases[0])", "Ritmo ajeno a la especie")
        XCTAssertEqual(FaltaDeContrapunto.Tipo.allCases[0].nombre, "Ritmo ajeno a la especie")
        XCTAssertEqual(ErrorDeImportacion.sinAcordes.errorDescription, "En el fichero no suena ningún acorde.")
    }

    func testDuracionesYPentagrama() {
        XCTAssertEqual(3 * Duracion.corchea, Duracion(3, 8))
        XCTAssertTrue(Clave.sol.posicion(de: Altura("Si4")).estaDentroDelPentagrama)
        XCTAssertFalse(Clave.sol.posicion(de: Altura("Do6")).estaDentroDelPentagrama)
        let clarinete = InstrumentoDePartitura.clarineteEnSib
        XCTAssertEqual(clarinete.sonido(de: Nota("Re")), Nota("Do"))
    }

    func testMusicXMLConUnBajoAlteradoYUnTempoSinFigura() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Lab Lab/Mib Mib7 Lab")
        XCTAssertTrue(analisis.musicXML().contains("<bass-alter>-1</bass-alter>"))
        let voz = try Voz(leyendo: "Do4:4 Re4:4")
        XCTAssertTrue(voz.musicXML(tempo: Tempo(60, unidad: Duracion(1, 3))).contains(#"<sound tempo="80"/>"#))
    }

    func testUnTransporteConCambioDeOctava() throws {
        let xml = """
            <score-partwise version="4.0">
              <part id="P1">
                <measure number="1">
                  <attributes>
                    <divisions>1</divisions>
                    <transpose><diatonic>0</diatonic><chromatic>0</chromatic><octave-change>-1</octave-change></transpose>
                  </attributes>
                  <note><pitch><step>C</step><octave>4</octave></pitch><duration>4</duration></note>
                </measure>
              </part>
            </score-partwise>
            """
        let pieza = try PiezaImportada(leyendo: Data(xml.utf8))
        XCTAssertEqual(pieza.notas.map(\.altura), [Altura("Do3")])
    }

    func testMelodiaDesdeMIDISinTonalidad() {
        XCTAssertEqual(Melodia(midi: []).alturas, [])
    }

    func testUnAcordeConUnaNotaQueNoSeLee() {
        XCTAssertThrowsError(try Evento(leyendo: "Do4+Xx4:4")) { error in
            XCTAssertEqual((error as? ErrorDeLectura)?.posicion, 4)
        }
    }
}

final class APIPocoUsadaDeLosTrastesTests: XCTestCase {
    func testDescripciones() throws {
        XCTAssertEqual("\(PosicionEnElMastil(cuerda: 0, traste: 3))", "cuerda 1, traste 3")
        let digitacion = try XCTUnwrap(Mastil(.guitarra).digitaciones(de: Acorde("Do")).first)
        XCTAssertEqual("\(digitacion)", digitacion.tablatura)
    }
}
