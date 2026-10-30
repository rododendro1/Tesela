import XCTest
@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaTeoria
@testable import ArmoniaRepresentaciones
import Hexagonos

/// El formato UIL (Park y Gerhard, 2013): lectura, escritura, giros de 30° y espejo.
final class FormatoUILTests: XCTestCase {
    private func misma(_ a: TecladoIsomorfico, _ b: TecladoIsomorfico, _ mensaje: String = "",
                       file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(a.orientacion, b.orientacion, mensaje, file: file, line: line)
        XCTAssertEqual(a.semitonosEnQ, b.semitonosEnQ, mensaje, file: file, line: line)
        XCTAssertEqual(a.semitonosEnR, b.semitonosEnR, mensaje, file: file, line: line)
    }

    // MARK: Lectura

    func testLeeLosCamposYLosEscribeNormalizados() throws {
        let wh = try FormatoUIL(leyendo: "2,7,5;R30M")
        XCTAssertEqual([wh.menor, wh.mayor, wh.diferencia, wh.rotacion, wh.tonos], [2, 7, 5, 30, 12])
        XCTAssertTrue(wh.espejo)
        XCTAssertEqual(wh.descripcion, "2,7,5;R30M")
        XCTAssertEqual(try FormatoUIL(leyendo: " 2, 7 , 5 ; r30 m ").descripcion, "2,7,5;R30M")
        XCTAssertEqual(try FormatoUIL(leyendo: "3,7,4").descripcion, "3,7,4;R0")        // el giro se puede omitir
        XCTAssertEqual(try FormatoUIL(leyendo: "1,3,2;R-90").rotacion, 270)
        XCTAssertEqual(try FormatoUIL(leyendo: "1,3,2;R450").rotacion, 90)
        XCTAssertEqual(try FormatoUIL(leyendo: "1,4,3;R30M;T7").descripcion, "1,4,3;R30M;T7")
        XCTAssertEqual(try FormatoUIL(leyendo: "1,4,3;R30M;T7TET").tonos, 7)
        XCTAssertEqual(try FormatoUIL(leyendo: "1,3,2;R0;S0").rotacion, 0)
    }

    func testLasOtrasFormasDeEscribirLosIntervalos() throws {
        // La Tabla 2 del artículo: abreviaturas, cifras romanas y razones dan el mismo 2,7,5.
        for texto in ["M2,P5,P4;R30M", "II,V,IV;R30M", "9:8,3:2,4:3;R30M"] {
            XCTAssertEqual(try FormatoUIL(leyendo: texto).descripcion, "2,7,5;R30M", texto)
        }
        XCTAssertEqual(try FormatoUIL(leyendo: "m2,m3,M2").descripcion, "1,3,2;R0")
        XCTAssertEqual(try FormatoUIL(leyendo: "♭II,♭III,II").descripcion, "1,3,2;R0")
    }

    func testRechazaLoQueNoEsUIL() {
        func fallo(_ texto: String) -> ErrorDeUIL? {
            do { _ = try FormatoUIL(leyendo: texto); return nil } catch { return error as? ErrorDeUIL }
        }
        XCTAssertEqual(fallo(""), .formatoNoValido(""))
        XCTAssertEqual(fallo("2,7"), .formatoNoValido("2,7"))
        XCTAssertEqual(fallo("2,7,x"), .formatoNoValido("2,7,x"))
        XCTAssertEqual(fallo("2,7,5;Q3"), .formatoNoValido("2,7,5;Q3"))
        XCTAssertEqual(fallo("2,7,5;R"), .formatoNoValido("2,7,5;R"))
        XCTAssertEqual(fallo("2,7,5;R30X"), .formatoNoValido("2,7,5;R30X"))
        // L ≤ D y G = L + D.
        XCTAssertEqual(fallo("7,5,2"), .intervalosIncoherentes(menor: 7, mayor: 5, diferencia: 2))
        XCTAssertEqual(fallo("5,7,2"), .intervalosIncoherentes(menor: 5, mayor: 7, diferencia: 2))
        XCTAssertEqual(fallo("2,8,5"), .intervalosIncoherentes(menor: 2, mayor: 8, diferencia: 5))
        XCTAssertEqual(fallo("0,2,2"), .intervalosIncoherentes(menor: 0, mayor: 2, diferencia: 2))
        // El giro, de 30 en 30.
        XCTAssertEqual(fallo("2,7,5;R45"), .rotacionNoValida(45))
        XCTAssertEqual(fallo("2,7,5;R30;S2"), .cizallaNoSoportada(2))
        // Las abreviaturas y las razones solo valen con 12 notas.
        XCTAssertEqual(fallo("M2,P5,P4;T7"), .formatoNoValido("M2,P5,P4;T7"))
        XCTAssertFalse(ErrorDeUIL.formatoNoValido("x").description.isEmpty)
    }

    // MARK: La Tabla 1 del artículo

    func testLosTecladosDeLaTabla1() throws {
        XCTAssertEqual(FormatoUIL.conocidos.count, 8)
        // (nombre, semitonos en q, semitonos en r, orientación) calculados a mano con la regla del artículo:
        // la base es [G, D, −L, −G, −D, L] desde el norte en sentido horario, [G, L, −D, −G, −L, D] en espejo.
        let esperados: [String: (Int, Int, Orientacion)] = [
            "Wicki-Hayden": (2, -5, .puntiaguda),
            "Harmonic table": (-3, -7, .plana),
            "Gerhard": (3, -1, .plana),
            "Park": (5, 2, .puntiaguda),
            "Jankó": (2, 1, .puntiaguda),
            "C-system": (-3, -1, .puntiaguda),
            "B-system": (-3, -2, .puntiaguda),
            "Bayan": (3, 1, .puntiaguda),
        ]
        for disposicion in FormatoUIL.conocidos {
            let teclado = try disposicion.teclado()
            let (enQ, enR, orientacion) = try XCTUnwrap(esperados[disposicion.nombre], disposicion.nombre)
            XCTAssertEqual([teclado.semitonosEnQ, teclado.semitonosEnR], [enQ, enR], disposicion.nombre)
            XCTAssertEqual(teclado.orientacion, orientacion, disposicion.nombre)
            XCTAssertEqual(teclado.nombre, disposicion.nombre)
            XCTAssertTrue(disposicion.formato.esCompleto, disposicion.nombre)
        }
    }

    func testLosTecladosQueYaTeniaSonLosDelArticulo() throws {
        misma(try TecladoIsomorfico.conUIL("2,7,5;R30M"), .wickiHayden)
        misma(try TecladoIsomorfico.conUIL("3,7,4;R0"), .tablaArmonica)
        misma(try TecladoIsomorfico.conUIL("1,2,1;R90"), .janko)
        // Y al revés: cada uno sabe escribirse.
        XCTAssertEqual(TecladoIsomorfico.wickiHayden.uil?.descripcion, "2,7,5;R30M")
        XCTAssertEqual(TecladoIsomorfico.tablaArmonica.uil?.descripcion, "3,7,4;R0")
        XCTAssertEqual(TecladoIsomorfico.janko.uil?.descripcion, "1,2,1;R90")
        XCTAssertEqual(TecladoIsomorfico.wickiHaydenPlano.uil?.descripcion, "2,7,5;R0M")
        XCTAssertEqual(TecladoIsomorfico.wickiHaydenEspejo.uil?.descripcion, "2,7,5;R330")
        // Los acordeones de la app son los del artículo girados 90°.
        XCTAssertEqual(TecladoIsomorfico.acordeonC.uil?.descripcion, "1,3,2;R0M")
        XCTAssertEqual(TecladoIsomorfico.acordeonB.uil?.descripcion, "1,3,2;R0")
        misma(try TecladoIsomorfico.conUIL("1,3,2;R270M").rotado(grados: 90)!, .acordeonC)
        misma(try TecladoIsomorfico.conUIL("1,3,2;R270").rotado(grados: 90)!, .acordeonB)
    }

    func testElNombreYElOrigenDelTeclado() throws {
        let teclado = try TecladoIsomorfico.conUIL("2,7,5;R30M", nombre: "Mío", midiDelOrigen: 48)
        XCTAssertEqual(teclado.nombre, "Mío")
        XCTAssertEqual(teclado.midi(en: .origen), 48)
        XCTAssertEqual(try TecladoIsomorfico.conUIL("2,7,5;R30M").nombre, "2,7,5;R30M")
    }

    // MARK: Giros y espejo

    func testGirarSumaAlGiroDelUIL() throws {
        for (menor, mayor, diferencia) in [(2, 7, 5), (1, 3, 2), (1, 4, 3), (2, 5, 3), (3, 7, 4), (1, 2, 1)] {
            for giro in stride(from: 0, to: 360, by: 30) {
                for espejo in [false, true] {
                    let formato = try FormatoUIL(menor: menor, mayor: mayor, diferencia: diferencia, rotacion: giro, espejo: espejo)
                    let teclado = try formato.teclado()
                    let siguiente = try formato.rotado(grados: 30).teclado()
                    misma(teclado.rotado(pasos: 1), siguiente, formato.descripcion)
                    misma(teclado.rotado(grados: 90)!, try formato.rotado(grados: 90).teclado(), formato.descripcion)
                    // El espejo cambia M y niega el giro (salvo cuando L = D, donde es indiferente).
                    if let reflejado = formato.reflejado, formato.caso != .igualdad {
                        misma(teclado.reflejado, try reflejado.teclado(), formato.descripcion)
                    }
                    // Lo que se escribe se lee igual: el formato del teclado da el mismo teclado.
                    misma(try XCTUnwrap(teclado.uil, formato.descripcion).teclado(), teclado, formato.descripcion)
                }
            }
        }
    }

    func testDoceGirosDanLaVueltaYElEspejoSeDeshace() {
        for teclado in [TecladoIsomorfico.wickiHayden, .tablaArmonica, .janko, .acordeonC, .wickiHaydenEspejo] {
            misma(teclado.rotado(pasos: 12), teclado, teclado.nombre)
            misma(teclado.rotado(pasos: -3).rotado(pasos: 3), teclado, teclado.nombre)
            misma(teclado.reflejado.reflejado, teclado, teclado.nombre)
            XCTAssertEqual(teclado.rotado(pasos: 1).orientacion, teclado.orientacion == .plana ? .puntiaguda : .plana)
            XCTAssertEqual(teclado.rotado(pasos: 2).orientacion, teclado.orientacion)
            XCTAssertEqual(teclado.rotado(pasos: 1).midi(en: .origen), teclado.midi(en: .origen))
            // Un teclado girado sigue siendo consistente: lo contrario en la dirección opuesta.
            for d in DireccionHexagonal.allCases {
                let girado = teclado.rotado(pasos: 5)
                XCTAssertEqual(girado.semitonos(hacia: d), -girado.semitonos(hacia: d.opuesta))
            }
        }
        XCTAssertNil(TecladoIsomorfico.janko.rotado(grados: 45))
        XCTAssertNotNil(TecladoIsomorfico.janko.rotado(grados: -30))
    }

    func testWickiHaydenGiradoYEnEspejo() throws {
        // Wicki-Hayden (R30M) girado −30° es el plano, R0M; en espejo es el «espejo» de la app.
        misma(TecladoIsomorfico.wickiHayden.rotado(grados: -30)!, .wickiHaydenPlano)
        misma(TecladoIsomorfico.wickiHayden.reflejado, .wickiHaydenEspejo)
        // Los intervalos de cada rumbo del Wicki-Hayden: 30°: quinta, 90°: tono, 330°: cuarta.
        let wh = TecladoIsomorfico.wickiHayden
        XCTAssertEqual([wh.semitonos(rumbo: 30), wh.semitonos(rumbo: 90), wh.semitonos(rumbo: 330)], [7, 2, 5])
        XCTAssertNil(wh.semitonos(rumbo: 0))
        XCTAssertEqual(wh.semitonos(rumbo: -30), 5)
        XCTAssertEqual(try FormatoUIL(leyendo: "2,7,5;R30M").semitonos(rumbo: 90), 2)
        XCTAssertNil(try FormatoUIL(leyendo: "2,7,5;R30M").semitonos(rumbo: 0))
    }

    // MARK: Propiedades

    func testCompletosYDegenerados() throws {
        for texto in ["2,7,5", "3,7,4", "1,2,1", "0,1,1", "1,4,3", "2,5,3"] {
            XCTAssertTrue(try FormatoUIL(leyendo: texto).esCompleto, texto)
        }
        // Sin el semitono (L = 2): solo suenan seis notas de una escala de tonos enteros.
        let tonos = try FormatoUIL(leyendo: "2,6,4")
        XCTAssertFalse(tonos.esCompleto)
        // Con radio 12 hay casillas por debajo de MIDI 0: `%` daría restos negativos.
        let deTonos = try tonos.teclado()
        XCTAssertEqual(Set(FormasDeMapa.hexagono(radio: 12).map { ((deTonos.midi(en: $0) % 12) + 12) % 12 }), [0, 2, 4, 6, 8, 10])
        XCTAssertFalse(try FormatoUIL(leyendo: "3,9,6").esCompleto)
        // Los completos suenan las doce notas.
        let wh = try FormatoUIL(leyendo: "2,7,5;R30M").teclado()
        XCTAssertEqual(Set(FormasDeMapa.hexagono(radio: 12).map { ((wh.midi(en: $0) % 12) + 12) % 12 }).count, 12)
    }

    func testLosCasosEspeciales() throws {
        XCTAssertEqual(try FormatoUIL(leyendo: "0,1,1").caso, .cero)
        XCTAssertEqual(try FormatoUIL(leyendo: "1,2,1").caso, .igualdad)
        XCTAssertEqual(try FormatoUIL(leyendo: "2,7,5").caso, .general)
        // En el caso cero y el de igualdad el espejo no cambia nada, salvo un giro que lo compensa.
        let janko = try TecladoIsomorfico.conUIL("1,2,1;R90")
        misma(try TecladoIsomorfico.conUIL("1,2,1;R90M"), janko)
        XCTAssertEqual(try FormatoUIL(leyendo: "0,1,1;R0").teclado().semitonos(rumbo: 0), 1)
        XCTAssertEqual(try TecladoIsomorfico.conUIL("1,2,1;R90M").uil?.descripcion, "1,2,1;R90")
    }

    func testElEjeDeAlturaDeLaTabla1() throws {
        // Sin giro ni espejo el eje está entre 0° y 30°, y en el caso cero vale 30°; con espejo, entre R − 30° y R.
        XCTAssertEqual(try FormatoUIL(leyendo: "1,2,1;R90").anguloDelEjeDeAltura, 90, accuracy: 1e-9)      // Jankó: sube a la derecha
        XCTAssertEqual(try FormatoUIL(leyendo: "0,1,1;R0").anguloDelEjeDeAltura, 30, accuracy: 1e-9)
        XCTAssertEqual(try FormatoUIL(leyendo: "2,7,5;R30M").anguloDelEjeDeAltura, 16.1, accuracy: 0.05)
        XCTAssertEqual(try FormatoUIL(leyendo: "3,7,4;R0").anguloDelEjeDeAltura, 4.72, accuracy: 0.05)
        XCTAssertEqual(try FormatoUIL(leyendo: "1,3,2;R270M").anguloDelEjeDeAltura, 259.11, accuracy: 0.05)
        for formato in FormatoUIL.conocidos.map(\.formato) {
            let angulo = formato.anguloDelEjeDeAltura
            let desde = Double(formato.rotacion) - (formato.espejo ? 30 : 0)
            let relativo = (angulo - desde + 360).truncatingRemainder(dividingBy: 360)
            XCTAssertTrue(relativo >= -1e-9 && relativo <= 30 + 1e-9, formato.descripcion)
        }
    }

    // MARK: Afinaciones que no son de 12 notas

    func testOtrasAfinacionesSeDescribenPeroNoSeDibujan() throws {
        let sieteNotas = try FormatoUIL(leyendo: "1,4,3;R30M;T7")
        XCTAssertTrue(sieteNotas.esCompleto)
        XCTAssertThrowsError(try sieteNotas.teclado()) { error in
            XCTAssertEqual(error as? ErrorDeUIL, .afinacionNoSoportada(tonos: 7))
        }
    }

    // MARK: Dibujo

    func testUnTecladoDelArticuloSeDibuja() throws {
        let teclado = try TecladoIsomorfico.conUIL("2,5,3;R90M")
        let svg = teclado.svg(FormasDeMapa.hexagono(radio: 3), marcadas: [60, 64, 67])
        let raiz = try XCTUnwrap(ElementoXML.leer(svg))
        XCTAssertEqual(raiz.todos("polygon").count, 37)
        XCTAssertTrue(svg.contains(">Do4<"))
    }
}
