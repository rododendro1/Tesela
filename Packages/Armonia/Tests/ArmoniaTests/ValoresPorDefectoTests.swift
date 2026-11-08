import ApoyoDePruebas
import Foundation
import Testing

@testable import Armonia
@testable import Diagramas
@testable import Elementos
@testable import Formatos
@testable import Partituras
@testable import Polifonia
@testable import Teoria
@testable import Trastes

// Lo que pasa cuando falta un dato que suele venir: un atributo de MEI, la armadura de una escala, las marcas de un
// diagrama. Cada prueba fija el valor que se toma entonces.

/// Una duración como fracción de redonda: «3/8», «1».
private func fraccion(_ duracion: Duracion) -> String {
    duracion.denominador == 1 ? "\(duracion.numerador)" : "\(duracion.numerador)/\(duracion.denominador)"
}

@Suite struct ValoresPorDefectoTests {
    @Test func unMEIConLoMinimo() throws {
        // Sin `n` en el pentagrama ni en la casilla, sin modo, sin unidad del compás, sin tempo, un tresillo sin
        // `num` ni `numbase`, un silencio con puntillo y una dinámica que apunta a una nota que no existe.
        let mei = """
            <mei><music><body><mdiv><score>
              <scoreDef><staffGrp><staffDef n="1" lines="5"/></staffGrp></scoreDef>
              <section>
                <keySig sig="2f"/><meterSig count="3"/><tempo/>
                <measure>
                  <staff><layer>
                    <tuplet><note pname="b" oct="4" dur="8"/><note pname="c" oct="5" dur="8"/>
                      <note pname="d" oct="5" dur="8"/></tuplet>
                    <rest dur="4"><dot/></rest>
                    <note pname="e" oct="5" dur="8" accid="f" glyph.name="accidentalFlat"/>
                  </layer></staff>
                  <dynam startid="#nadie">p</dynam>
                </measure>
                <ending>
                  <measure><staff><layer><note pname="f" oct="4" dur="2"/></layer></staff></measure>
                </ending>
              </section>
            </score></mdiv></body></music></mei>
            """
        let pieza = try PiezaImportada(leyendo: Data(mei.utf8))
        #expect(pieza.tonalidad == Tonalidad(Nota("Sib")))
        #expect(pieza.compas == nil)
        #expect(pieza.tempo == nil)
        #expect(
            pieza.notas.map { "\($0.altura) \(fraccion($0.inicio)) \(fraccion($0.duracion))" } == [
                "Si♭4 0 1/12", "Do5 1/12 1/12", "Re5 1/6 1/12", "Mi♭5 5/8 1/8", "Fa4 3/4 1/2",
            ])
        #expect(pieza.notas.allSatisfy { $0.dinamica == nil })
    }

    @Test func losErroresDeLecturaEnCadaIdioma() {
        let errores: [ErrorDeLecturaDeFichero] = [
            .formatoDesconocido, .comprimido, .midiDanado, .midiConTiempoSMPTE, .xmlDanado(linea: 3),
            .noEsMusicXMLPorPartes, .sinNotas, .sinAcordes,
        ]
        for notacion in [Notacion.delIdioma(.espanol), .conPalabras(.ingles), .ascii(.aleman)] {
            let textos = errores.map { $0.descripcion(en: notacion) }
            #expect(Set(textos).count == errores.count, "\(notacion)")
            #expect(!textos.contains(""))
        }
        #expect(ErrorDeLecturaDeFichero.xmlDanado(linea: 3).descripcion(en: .delIdioma(.espanol)).contains("3"))
    }

    @Test func unaPiezaVaciaNoDura() {
        let pieza = PiezaImportada(titulo: nil, tonalidad: nil, compas: nil, tempo: nil, notas: [])
        #expect(pieza.duracion == .cero)
    }

    @Test func laEnarmonicaDeUnaEscalaSinArmadura() {
        // La pentatónica no tiene armadura: se cuentan sus alteraciones.
        let escala = Escala(Nota("Do#"), .pentatonicaMayor)
        #expect(escala.armadura == nil)
        #expect(escala.enarmonicaMasSimple == Escala(Nota("Reb"), .pentatonicaMayor))
    }

    @Test func lasMarcasYLasCasillas() {
        #expect(MarcasDeDiagrama().isEmpty)
        #expect(!MarcasDeDiagrama([60]).isEmpty)
        #expect("\(CasillaCuadrada(columna: 2, fila: -1))" == "(2, -1)")
        let teclado = TecladoCuadrado(nombre: "", semitonosEnH: 1, semitonosEnV: 5)
        #expect(
            teclado.altura(en: CasillaCuadrada(columna: 1, fila: 0)).midi
                == teclado.midi(en: .init(columna: 1, fila: 0)))
    }

    @Test func lasTransformacionesEnCadena() throws {
        let doMayor = try #require(Tonnetz.Triada(Acorde("Do")))
        #expect("\(doMayor.transformar([.p, .l]))" == "\(doMayor.transformar(.p).transformar(.l))")
        #expect(doMayor.transformar([]) == doMayor)
    }

    @Test func atajosDeLaPolifoniaYLosTrastes() throws {
        #expect("\(NotaExtrana.pedal)" == NotaExtrana.pedal.nombre)
        let propuesta = try Contrapunto.proponer(sobre: "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4")
        #expect(propuesta.first?.esCorrecto == true)
        let mastil = Mastil(.guitarra)
        let digitacion = Digitacion(mastil: mastil, trastes: [nil, 3, 2, 0, 1, 0])
        #expect(Set([digitacion, Digitacion(mastil: mastil, trastes: [nil, 3, 2, 0, 1, 0])]).count == 1)
        let (acordes, bajo) = Exportacion.progresion(
            [Acorde("Do"), Acorde("Sol")], duracion: Duracion(1, 2), final: Duracion(1))
        #expect(acordes.map(\.duracion) == [Duracion(1, 2), Duracion(1)])
        #expect(bajo.count == 2)
    }

    @Test func unABCConLoMinimo() throws {
        // `K:` vacío, un quintillo sin más números (en un compás simple, cinco en el tiempo de dos), un tresillo con
        // los dos puntos vacíos y una casilla que no se cierra antes del final: la vuelta salta la casilla.
        let abc = "X:1\nL:1/8\nK:\n(5cdefg (3::cde |1 c4 :|"
        let pieza = try PiezaImportada(abc: abc)
        #expect(pieza.tonalidad == nil)
        let primeraVez = [
            "Do5 1/20", "Re5 1/20", "Mi5 1/20", "Fa5 1/20", "Sol5 1/20", "Do5 1/12", "Re5 1/12", "Mi5 1/12",
        ]
        #expect(
            pieza.notas.map { "\($0.altura) \(fraccion($0.duracion))" } == primeraVez + ["Do5 1/2"] + primeraVez
        )
    }

    @Test func unTonnetzSinOrigenNoLlevaTitulo() throws {
        let tonnetz = Tonnetz(puntos: [PuntoDeLaRed(quintas: 0, terceras: 0)], tieneOrtografia: false, recorrido: [])
        let raiz = try #require(ElementoXML.leer(tonnetz.svg()))
        #expect(raiz.buscar("title").allSatisfy { $0.texto.isEmpty })
    }

    @Test func elContrapuntoDebajoYLasEspeciesTerceraYQuinta() throws {
        let debajo = try #require(
            Contrapunto.proponer(sobre: "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4", arriba: false).first)
        #expect(!debajo.contrapuntoArriba)
        #expect(debajo.informe(en: .ascii(.ingles)).hasPrefix("Species 1, counterpoint below"))
        // En tercera especie, dos blancas en un compás que no es el penúltimo no son el ritmo de la especie.
        let tercera = try Contrapunto(
            cantusFirmus: "Do4 Si3 Do4", contrapunto: "Sol4:2 La4:2 Si4 Re5 Do5 Si4 Do5:1", especie: .tercera)
        #expect(tercera.faltas.map(\.tipo).contains(.ritmoDeLaEspecie))
        // En quinta especie vale cualquier figura desde la corchea.
        let quinta = try Contrapunto(
            cantusFirmus: "Do4 Si3 Do4", contrapunto: "Sol4:2 La4:4 Si4:4 Re5:2 Do5:8 Si4:8 Do5:4 Do5:1",
            especie: .quinta)
        #expect(!quinta.faltas.map(\.tipo).contains(.ritmoDeLaEspecie))
    }
}
