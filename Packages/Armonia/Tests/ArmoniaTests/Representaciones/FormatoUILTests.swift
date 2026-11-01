import Foundation
import Hexagonos
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

/// El formato UIL (Park y Gerhard, 2013): lectura, escritura, giros de 30° y espejo.
@Suite struct FormatoUILTests {
    private func misma(
        _ a: TecladoIsomorfico, _ b: TecladoIsomorfico, _ mensaje: String = "",
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        #expect(a.orientacion == b.orientacion, Comment(rawValue: mensaje), sourceLocation: sourceLocation)
        #expect(a.semitonosEnQ == b.semitonosEnQ, Comment(rawValue: mensaje), sourceLocation: sourceLocation)
        #expect(a.semitonosEnR == b.semitonosEnR, Comment(rawValue: mensaje), sourceLocation: sourceLocation)
    }

    // MARK: Lectura

    @Test func leeLosCamposYLosEscribeNormalizados() throws {
        let wh = try FormatoUIL(leyendo: "2,7,5;R30M")
        #expect([wh.menor, wh.mayor, wh.diferencia, wh.rotacion, wh.tonos] == [2, 7, 5, 30, 12] as [Int])
        #expect(wh.espejo)
        #expect(wh.descripcion == "2,7,5;R30M")
        #expect(try (FormatoUIL(leyendo: " 2, 7 , 5 ; r30 m ").descripcion) == "2,7,5;R30M")
        #expect(try (FormatoUIL(leyendo: "3,7,4").descripcion) == "3,7,4;R0") // el giro se puede omitir
        #expect(try (FormatoUIL(leyendo: "1,3,2;R-90").rotacion) == 270)
        #expect(try (FormatoUIL(leyendo: "1,3,2;R450").rotacion) == 90)
        #expect(try (FormatoUIL(leyendo: "1,4,3;R30M;T7").descripcion) == "1,4,3;R30M;T7")
        #expect(try (FormatoUIL(leyendo: "1,4,3;R30M;T7TET").tonos) == 7)
        #expect(try (FormatoUIL(leyendo: "1,3,2;R0;S0").rotacion) == 0)
    }

    @Test func lasOtrasFormasDeEscribirLosIntervalos() throws {
        // La Tabla 2 del artículo: abreviaturas, cifras romanas y razones dan el mismo 2,7,5.
        for texto in ["M2,P5,P4;R30M", "II,V,IV;R30M", "9:8,3:2,4:3;R30M"] {
            #expect(try (FormatoUIL(leyendo: texto).descripcion) == "2,7,5;R30M", Comment(rawValue: texto))
        }
        #expect(try (FormatoUIL(leyendo: "m2,m3,M2").descripcion) == "1,3,2;R0")
        #expect(try (FormatoUIL(leyendo: "♭II,♭III,II").descripcion) == "1,3,2;R0")
    }

    @Test func rechazaLoQueNoEsUIL() throws {
        func fallo(_ texto: String) -> ErrorDeUIL? {
            do {
                _ = try FormatoUIL(leyendo: texto)
                return nil
            } catch { return error as? ErrorDeUIL }
        }
        #expect(fallo("") == .formatoNoValido(""))
        #expect(fallo("2,7") == .formatoNoValido("2,7"))
        #expect(fallo("2,7,x") == .formatoNoValido("2,7,x"))
        #expect(fallo("2,7,5;Q3") == .formatoNoValido("2,7,5;Q3"))
        #expect(fallo("2,7,5;R") == .formatoNoValido("2,7,5;R"))
        #expect(fallo("2,7,5;R30X") == .formatoNoValido("2,7,5;R30X"))
        // L ≤ D y G = L + D.
        #expect(fallo("7,5,2") == .intervalosIncoherentes(menor: 7, mayor: 5, diferencia: 2))
        #expect(fallo("5,7,2") == .intervalosIncoherentes(menor: 5, mayor: 7, diferencia: 2))
        #expect(fallo("2,8,5") == .intervalosIncoherentes(menor: 2, mayor: 8, diferencia: 5))
        #expect(fallo("0,2,2") == .intervalosIncoherentes(menor: 0, mayor: 2, diferencia: 2))
        // El giro, de 30 en 30.
        #expect(fallo("2,7,5;R45") == .rotacionNoValida(45))
        #expect(fallo("2,7,5;R30;S2") == .cizallaNoSoportada(2))
        // Las abreviaturas y las razones solo valen con 12 notas.
        #expect(fallo("M2,P5,P4;T7") == .formatoNoValido("M2,P5,P4;T7"))
        #expect(!(ErrorDeUIL.formatoNoValido("x").description.isEmpty))
    }

    // MARK: La Tabla 1 del artículo

    @Test func losTecladosDeLaTabla1() throws {
        #expect(FormatoUIL.conocidos.count == 8)
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
            let (enQ, enR, orientacion) = try #require(
                esperados[disposicion.nombre], Comment(rawValue: disposicion.nombre))
            #expect(
                [teclado.semitonosEnQ, teclado.semitonosEnR] == [enQ, enR] as [Int],
                Comment(rawValue: disposicion.nombre))
            #expect(teclado.orientacion == orientacion, Comment(rawValue: disposicion.nombre))
            #expect(teclado.nombre == disposicion.nombre)
            #expect(disposicion.formato.esCompleto, Comment(rawValue: disposicion.nombre))
        }
    }

    @Test func losTecladosQueYaTeniaSonLosDelArticulo() throws {
        misma(try TecladoIsomorfico.conUIL("2,7,5;R30M"), .wickiHayden)
        misma(try TecladoIsomorfico.conUIL("3,7,4;R0"), .tablaArmonica)
        misma(try TecladoIsomorfico.conUIL("1,2,1;R90"), .janko)
        // Y al revés: cada uno sabe escribirse.
        #expect(TecladoIsomorfico.wickiHayden.uil?.descripcion == "2,7,5;R30M")
        #expect(TecladoIsomorfico.tablaArmonica.uil?.descripcion == "3,7,4;R0")
        #expect(TecladoIsomorfico.janko.uil?.descripcion == "1,2,1;R90")
        #expect(TecladoIsomorfico.wickiHaydenPlano.uil?.descripcion == "2,7,5;R0M")
        #expect(TecladoIsomorfico.wickiHaydenEspejo.uil?.descripcion == "2,7,5;R330")
        // Gerhard y Park, tal cual los da el artículo.
        misma(try TecladoIsomorfico.conUIL("1,4,3;R60"), .gerhard)
        misma(try TecladoIsomorfico.conUIL("2,5,3;R90M"), .park)
        #expect(TecladoIsomorfico.gerhard.uil?.descripcion == "1,4,3;R60")
        #expect(TecladoIsomorfico.park.uil?.descripcion == "2,5,3;R90M")
        // Los acordeones de la app son los del artículo girados 90°.
        #expect(TecladoIsomorfico.acordeonC.uil?.descripcion == "1,3,2;R0M")
        #expect(TecladoIsomorfico.acordeonB.uil?.descripcion == "1,3,2;R0")
        misma(try TecladoIsomorfico.conUIL("1,3,2;R270M").rotado(grados: 90)!, .acordeonC)
        misma(try TecladoIsomorfico.conUIL("1,3,2;R270").rotado(grados: 90)!, .acordeonB)
    }

    @Test func elNombreYElOrigenDelTeclado() throws {
        let teclado = try TecladoIsomorfico.conUIL("2,7,5;R30M", nombre: "Mío", midiDelOrigen: 48)
        #expect(teclado.nombre == "Mío")
        #expect(teclado.midi(en: .origen) == 48)
        #expect(try (TecladoIsomorfico.conUIL("2,7,5;R30M").nombre) == "2,7,5;R30M")
    }

    // MARK: Giros y espejo

    @Test func girarSumaAlGiroDelUIL() throws {
        for (menor, mayor, diferencia) in [(2, 7, 5), (1, 3, 2), (1, 4, 3), (2, 5, 3), (3, 7, 4), (1, 2, 1)] {
            for giro in stride(from: 0, to: 360, by: 30) {
                for espejo in [false, true] {
                    let formato = try FormatoUIL(
                        menor: menor, mayor: mayor, diferencia: diferencia, rotacion: giro, espejo: espejo)
                    let teclado = try formato.teclado()
                    let siguiente = try formato.rotado(grados: 30).teclado()
                    misma(teclado.rotado(doceavos: 1), siguiente, formato.descripcion)
                    misma(teclado.rotado(grados: 90)!, try formato.rotado(grados: 90).teclado(), formato.descripcion)
                    // El espejo cambia M y niega el giro (salvo cuando L = D, donde es indiferente).
                    if let reflejado = formato.reflejado, formato.caso != .igualdad {
                        misma(teclado.reflejado, try reflejado.teclado(), formato.descripcion)
                    }
                    // Lo que se escribe se lee igual: el formato del teclado da el mismo teclado.
                    misma(
                        try #require(teclado.uil, Comment(rawValue: formato.descripcion)).teclado(), teclado,
                        formato.descripcion)
                }
            }
        }
    }

    @Test func doceGirosDanLaVueltaYElEspejoSeDeshace() {
        for teclado in [TecladoIsomorfico.wickiHayden, .tablaArmonica, .janko, .acordeonC, .wickiHaydenEspejo] {
            misma(teclado.rotado(doceavos: 12), teclado, teclado.nombre)
            misma(teclado.rotado(doceavos: -3).rotado(doceavos: 3), teclado, teclado.nombre)
            misma(teclado.reflejado.reflejado, teclado, teclado.nombre)
            #expect(teclado.rotado(doceavos: 1).orientacion == (teclado.orientacion == .plana ? .puntiaguda : .plana))
            #expect(teclado.rotado(doceavos: 2).orientacion == teclado.orientacion)
            #expect(teclado.rotado(doceavos: 1).midi(en: .origen) == teclado.midi(en: .origen))
            // Un teclado girado sigue siendo consistente: lo contrario en la dirección opuesta.
            for d in DireccionHexagonal.allCases {
                let girado = teclado.rotado(doceavos: 5)
                #expect(girado.semitonos(hacia: d) == -girado.semitonos(hacia: d.opuesta))
            }
        }
        #expect(TecladoIsomorfico.janko.rotado(grados: 45) == nil)
        #expect(TecladoIsomorfico.janko.rotado(grados: -30) != nil)
    }

    @Test func wickiHaydenGiradoYEnEspejo() throws {
        // Wicki-Hayden (R30M) girado −30° es el plano, R0M; en espejo es el «espejo» de la app.
        misma(TecladoIsomorfico.wickiHayden.rotado(grados: -30)!, .wickiHaydenPlano)
        misma(TecladoIsomorfico.wickiHayden.reflejado, .wickiHaydenEspejo)
        // Los intervalos de cada rumbo del Wicki-Hayden: 30°: quinta, 90°: tono, 330°: cuarta.
        let wh = TecladoIsomorfico.wickiHayden
        #expect([wh.semitonos(rumbo: 30), wh.semitonos(rumbo: 90), wh.semitonos(rumbo: 330)] == [7, 2, 5])
        #expect(wh.semitonos(rumbo: 0) == nil)
        #expect(wh.semitonos(rumbo: -30) == 5)
        #expect(try (FormatoUIL(leyendo: "2,7,5;R30M").semitonos(rumbo: 90)) == 2)
        #expect(try (FormatoUIL(leyendo: "2,7,5;R30M").semitonos(rumbo: 0)) == nil)
    }

    // MARK: Propiedades

    @Test func completosYDegenerados() throws {
        for texto in ["2,7,5", "3,7,4", "1,2,1", "0,1,1", "1,4,3", "2,5,3"] {
            #expect(try FormatoUIL(leyendo: texto).esCompleto, Comment(rawValue: texto))
        }
        // Sin el semitono (L = 2): solo suenan seis notas de una escala de tonos enteros.
        let tonos = try FormatoUIL(leyendo: "2,6,4")
        #expect(!tonos.esCompleto)
        // Con radio 12 hay casillas por debajo de MIDI 0: `%` daría restos negativos.
        let deTonos = try tonos.teclado()
        #expect(
            Set(FormasDeMapa.hexagono(radio: 12).map { ((deTonos.midi(en: $0) % 12) + 12) % 12 }) == [
                0, 2, 4, 6, 8, 10,
            ])
        #expect(try !(FormatoUIL(leyendo: "3,9,6").esCompleto))
        // Los completos suenan las doce notas.
        let wh = try FormatoUIL(leyendo: "2,7,5;R30M").teclado()
        #expect(Set(FormasDeMapa.hexagono(radio: 12).map { ((wh.midi(en: $0) % 12) + 12) % 12 }).count == 12)
    }

    @Test func losCasosEspeciales() throws {
        #expect(try (FormatoUIL(leyendo: "0,1,1").caso) == .cero)
        #expect(try (FormatoUIL(leyendo: "1,2,1").caso) == .igualdad)
        #expect(try (FormatoUIL(leyendo: "2,7,5").caso) == .general)
        // En el caso cero y el de igualdad el espejo no cambia nada, salvo un giro que lo compensa.
        let janko = try TecladoIsomorfico.conUIL("1,2,1;R90")
        misma(try TecladoIsomorfico.conUIL("1,2,1;R90M"), janko)
        #expect(try (FormatoUIL(leyendo: "0,1,1;R0").teclado().semitonos(rumbo: 0)) == 1)
        #expect(try (TecladoIsomorfico.conUIL("1,2,1;R90M").uil?.descripcion) == "1,2,1;R90")
    }

    @Test func elEjeDeAlturaDeLaTabla1() throws {
        // Sin giro ni espejo el eje está entre 0° y 30°, y en el caso cero vale 30°; con espejo, entre R − 30° y R.
        // Jankó: sube a la derecha.
        #expect(try abs(FormatoUIL(leyendo: "1,2,1;R90").anguloDelEjeDeAltura - (90)) <= 1e-9)
        #expect(try abs(FormatoUIL(leyendo: "0,1,1;R0").anguloDelEjeDeAltura - (30)) <= 1e-9)
        #expect(try abs(FormatoUIL(leyendo: "2,7,5;R30M").anguloDelEjeDeAltura - (16.1)) <= 0.05)
        #expect(try abs(FormatoUIL(leyendo: "3,7,4;R0").anguloDelEjeDeAltura - (4.72)) <= 0.05)
        #expect(try abs(FormatoUIL(leyendo: "1,3,2;R270M").anguloDelEjeDeAltura - (259.11)) <= 0.05)
        for formato in FormatoUIL.conocidos.map(\.formato) {
            let angulo = formato.anguloDelEjeDeAltura
            let desde = Double(formato.rotacion) - (formato.espejo ? 30 : 0)
            let relativo = (angulo - desde + 360).truncatingRemainder(dividingBy: 360)
            #expect(relativo >= -1e-9 && relativo <= 30 + 1e-9, Comment(rawValue: formato.descripcion))
        }
    }

    // MARK: Afinaciones que no son de 12 notas

    @Test func otrasAfinacionesSeDescribenPeroNoSeDibujan() throws {
        let sieteNotas = try FormatoUIL(leyendo: "1,4,3;R30M;T7")
        #expect(sieteNotas.esCompleto)
        do {
            _ = try sieteNotas.teclado()
            Issue.record("Se esperaba un error")
        } catch {
            #expect((error as? ErrorDeUIL) == .afinacionNoSoportada(tonos: 7))

        }
    }

    // MARK: Dibujo

    @Test func unTecladoDelArticuloSeDibuja() throws {
        let teclado = try TecladoIsomorfico.conUIL("2,5,3;R90M")
        let svg = teclado.svg(FormasDeMapa.hexagono(radio: 3), marcadas: [60, 64, 67])
        let raiz = try #require(ElementoXML.leer(svg))
        #expect(raiz.todos("polygon").count == 37)
        #expect(svg.contains(">Do₄<"))
    }
}
