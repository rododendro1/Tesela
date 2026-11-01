import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria
@testable import ArmoniaTrastes

// La parte de la API que no usan las apps ni el resto del motor: las descripciones, los atajos y los
// casos raros de cada idioma. Cada prueba fija lo que da hoy, para que un cambio no pase sin verse.

@Suite struct APIPocoUsadaDelNucleoTests {
    @Test func descripciones() {
        #expect("\(NotaNatural.re)" == "Re")
        #expect("\(Alteracion(1))" == "sostenido")
        #expect("\(CalidadDeIntervalo.mayor)" == "mayor")
        #expect("\(Consonancia.perfecta)" == "consonancia perfecta")
        #expect(Consonancia.disonancia.nombre == "disonancia")
        #expect(Consonancia.disonancia.nombre(en: .inglesASCII) == "dissonance")
        #expect(
            ErrorDeLectura(texto: "", posicion: nil, motivo: .textoVacio).errorDescription
                == "Valor no válido: el texto está vacío")
    }

    @Test func alteracionesYNotas() throws {
        #expect((Alteracion(2) - Alteracion(3)) == Alteracion(-1))
        #expect(Nota("Fa").sostenido == Nota("Fa#"))
        #expect(Nota("Fa#").nombreASCII == "Fa#")
        #expect(try (Nota(leyendo: "Si𝄫").nombre) == "Si♭♭")
        #expect(try (Nota(leyendo: "Do♮")) == Nota("Do"))
        // Con más de cuatro signos, el número.
        #expect(Alteracion(5).nombre(en: .aleman) == "5 Kreuze")
        #expect(Alteracion(-5).nombre(en: .aleman) == "5 Be")
        #expect(Alteracion(5).nombre(en: .euskera) == "5 diesa")
    }

    @Test func alturas() throws {
        #expect(Altura("Do4").esEnarmonica(de: Altura("Si#3")))
        #expect(!(Altura("Do4").esEnarmonica(de: Altura("Do5"))))
        #expect(try (Altura(leyendo: "C#4", en: .inglesASCII)) == Altura("Do#4"))
    }

    @Test func intervalos() {
        #expect(Intervalo.terceraMayor.descendente.sentido == .descendente)
        #expect(Intervalo.terceraMayor.descendente.ascendente == .terceraMayor)
        #expect(abs(Intervalo.quintaJusta.cents() - (700)) <= 1e-9)
        // Las multiplicidades de más de tres, y el unísono en masculino en occitano.
        for idioma in Idioma.allCases {
            let notacion = Notacion.delIdioma(idioma)
            #expect(
                Intervalo(numero: 4, calidad: .aumentada(4))?.nombre(en: notacion)
                    != Intervalo(numero: 4, calidad: .aumentada(3))?.nombre(en: notacion),
                Comment(rawValue: idioma.codigo))
        }
        #expect(Intervalo(numero: 1, calidad: .aumentada(1))?.nombre(en: .occitano) == "unisson aumentat")
        #expect(Intervalo(numero: 1, calidad: .aumentada(2))?.nombre(en: .occitano) == "unisson doblament aumentat")
        #expect(Intervalo(numero: 1, calidad: .disminuida(1)) == nil)
        #expect(Intervalo.ordinalEnCifras(5, en: .griego) == "5η")
        #expect(Intervalo.ordinalEnCifras(5, en: .ruso) == "5-я")
    }

    @Test func pluralesRusos() {
        #expect(Traduccion.pluralRuso(1, "a", "b", "c") == "1 a")
        #expect(Traduccion.pluralRuso(3, "a", "b", "c") == "3 b")
        #expect(Traduccion.pluralRuso(12, "a", "b", "c") == "12 c")
        #expect(Traduccion.pluralRuso(21, "a", "b", "c") == "21 a")
        #expect(Traduccion.pluralRuso(25, "a", "b", "c") == "25 c")
    }

    @Test func conjuntosCodable() throws {
        let conjunto = ConjuntoDeClases([0, 4, 7])
        let datos = try JSONEncoder().encode(conjunto)
        #expect(String(decoding: datos, as: UTF8.self) == "[0,4,7]")
        #expect(try (JSONDecoder().decode(ConjuntoDeClases.self, from: datos)) == conjunto)
    }

    @Test func unCaminoQueNoLlega() {
        let camino: [Int]? = caminoMasCorto(
            desde: 0, clave: { $0 }, vecinos: { n in n < 3 ? [(n + 1, n + 1)] : [] },
            llega: { $0 == 10 })
        #expect(camino == nil)
    }
}

@Suite struct APIPocoUsadaDeLaTeoriaTests {
    @Test func descripciones() {
        #expect("\(FuncionTonal.dominante)" == "dominante")
        #expect(FuncionTonal.dominante.nombre == "dominante")
        #expect("\(NombreDeGrado.dominante)" == "dominante")
        #expect("\(TipoDeAcorde(""))" == "mayor")
        #expect("\(TipoDeAcorde("m7"))" == "m7")
        #expect("\(Cadencia.Tipo.plagal)" == "cadencia plagal")
        #expect(Cadencia.Tipo.plagal.nombre(en: .inglesASCII) == "plagal cadence")
        #expect("\(FaltaDeConduccion.Tipo.superposicion)" == "Superposición")
        #expect(FaltaDeConduccion.Tipo.separacionExcesiva.nombre == "Más de una octava")
        #expect(CalidadDeTriada.sinTercera.nombre == "sin tercera")
        #expect(PapelEnAcorde.tension(9).nombre(en: .espanolUnicode) == "novena")
        #expect(PapelEnAcorde.tension(4).nombre(en: .espanolUnicode) == "tensión 4ª")
        #expect(Tonalidad(.do, .mayor).analizar([Acorde("Sol7")]).acordes[0].description == "V7")
    }

    @Test func acordes() {
        #expect(Acorde("Do7/Mi").nombre == "Do séptima de dominante, primera inversión")
        #expect(Acorde("Do/Re").nombre == "Do mayor, con bajo en Re")
        #expect(Acorde("Do7").contiene(Nota("Sib")))
        #expect(!(Acorde("Do7").contiene(Nota("Si"))))
        #expect(TipoDeAcorde("7").tieneSeptima)
        #expect(!(TipoDeAcorde("m").tieneSeptima))
        #expect(Acorde("Do7").estructura.tieneSeptima)
        #expect(Acorde("Do7").estructura.intervalos(conPapel: .tercera) == [.terceraMayor])
        #expect(Acorde.identificar(clasesDeAltura: [2, 5, 9], escala: Escala(.do, .mayor)).first?.cifrado == "Rem")
        #expect(Arpegio(Acorde("Do")).notas == [Nota("Do"), Nota("Mi"), Nota("Sol"), Nota("Do")])
    }

    @Test func tonalidades() {
        let doMayor = Tonalidad(.do, .mayor)
        #expect(doMayor.grado(5) == Nota("Sol"))
        #expect(doMayor.nombre(claseDeAltura: 10) == Nota("Sib"))
        #expect(doMayor.lugar(en: .ruso) == "в до мажоре")
        #expect(Tonalidad(.la, .menor).lugar(en: .ruso) == "в ля миноре")
        #expect(doMayor.lugar(en: .griego) == "σε ντο μείζονα")
        let notas = [Nota("Sol"), Nota("Si"), Nota("Re"), Nota("Fa#")]
        #expect(Tonalidad.identificar(notas: notas) == Tonalidad.candidatos(notas: notas).map(\.valor))
    }

    @Test func unRecorridoQueModulaSinPivote() throws {
        let recorrido = try #require(
            RecorridoTonal(["Do", "Fa", "Sol7", "Do", "Fa#", "Si", "Do#7", "Fa#"].map { Acorde(texto: $0)! }))
        #expect(recorrido.tonalidadDePartida == Tonalidad(.do, .mayor))
        #expect(try recorrido.tonalidadDeLlegada == (Tonalidad(leyendo: "Fa# mayor")))
        #expect(recorrido.modulaciones.map(\.description) == ["De Do mayor a Fa♯ mayor en el acorde 5 (directa)"])
        #expect(recorrido.tramos.map(\.description) == ["I–IV–V7–I en Do mayor", "I–IV–V7–I en Fa♯ mayor"])
    }

    @Test func corales() throws {
        #expect(Coral.nombreDeVoz(4, de: 5, en: .espanolUnicode) == "voz 5")
        let armonizacion = try #require(
            Tonalidad(.do, .mayor).armonizar(melodia: [Nota("Mi"), Nota("Re"), Nota("Do")]).first?.valor)
        #expect(armonizacion.realizar(soprano: [Altura("Mi5"), Altura("Re5"), Altura("Do5")]) != nil)
        #expect(armonizacion.realizar(soprano: [Altura("Mi5"), Altura("Mi5"), Altura("Do5")]) == nil)
        // Una melodía de una sola nota.
        #expect(Tonalidad(.do, .mayor).armonizarACuatroVoces([Altura("Do5")])?.coral.acordes.count == 1)
    }
}

@Suite struct APIPocoUsadaDeLasRepresentacionesTests {
    @Test func descripciones() throws {
        #expect("\(MovimientoDeVoz(desde: Nota("Fa"), hasta: Nota("Mi")))" == "Fa→Mi")
        #expect(
            CicloNeorriemanniano.allCases.map { $0.nombre } == ["ciclo hexatónico", "ciclo octatónico", "ciclo LR"])
        #expect(CicloNeorriemanniano.lr.description == "ciclo LR")
        #expect("\(TransformacionNeorriemanniana.p)" == "P")
        #expect("\(Tonnetz.Triada(Acorde("Lam"))!)" == "Lam")
        #expect("\(CorrespondenciaDeColores.newton)" == "Newton (1704)")
        #expect(CorrespondenciaDeColores.scriabin.nombre == "Scriabin (1911)")
        #expect(try "\(FormatoUIL(leyendo: "2,7,5;R30M"))" == "2,7,5;R30M")
    }

    @Test func erroresDeUIL() throws {
        #expect(
            "\(ErrorDeUIL.intervalosIncoherentes(menor: 1, mayor: 2, diferencia: 3))"
                == "Intervalos incoherentes: 1,2,3. Deben cumplir 0 < L ≤ D y G = L + D.")
        #expect("\(ErrorDeUIL.rotacionNoValida(45))" == "El giro de 45° no es múltiplo de 30°.")
        #expect("\(ErrorDeUIL.afinacionNoSoportada(tonos: 19))" == "Solo se dibujan teclados de 12 notas, no de 19.")
        #expect("\(ErrorDeUIL.cizallaNoSoportada(2))" == "La cizalla S2 no está soportada.")
        #expect(throws: (any Error).self) { try FormatoUIL(leyendo: "2,7,5;R0Tx") }
        #expect(try (FormatoUIL(leyendo: "2,7,5;R30;M").descripcion) == "2,7,5;R30M")
    }

    @Test func afinacionDesdeLaFrecuenciaDeLaTonica() {
        let afinacion = AfinacionJusta(tonica: Nota("La"), frecuenciaDeLaTonica: 432)
        #expect(abs(afinacion.frecuencia(de: Altura("La4")) - (432)) <= 1e-9)
    }
}

@Suite struct APIPocoUsadaDeLaPartituraTests {
    @Test func descripciones() {
        #expect("\(Figura.negra)" == "negra")
        #expect("\(Clave.fa)" == "clave de fa")
        #expect(
            Clave.allCases.map(\.nombre) == [
                "clave de sol", "clave de sol octava baja", "clave de sol octava alta", "clave de fa",
                "clave de fa en tercera", "clave de do en primera", "clave de do en segunda", "clave de do en tercera",
                "clave de do en cuarta",
            ])
        #expect("\(InstrumentoDePartitura.flauta)" == "flauta")
        #expect("\(FaltaDeContrapunto.Tipo.allCases[0])" == "Ritmo ajeno a la especie")
        #expect(FaltaDeContrapunto.Tipo.allCases[0].nombre == "Ritmo ajeno a la especie")
        #expect(ErrorDeImportacion.sinAcordes.errorDescription == "En el fichero no suena ningún acorde.")
    }

    @Test func duracionesYPentagrama() {
        #expect((3 * Duracion.corchea) == Duracion(3, 8))
        #expect(Clave.sol.posicion(de: Altura("Si4")).estaDentroDelPentagrama)
        #expect(!(Clave.sol.posicion(de: Altura("Do6")).estaDentroDelPentagrama))
        let clarinete = InstrumentoDePartitura.clarineteEnSib
        #expect(clarinete.sonido(de: Nota("Re")) == Nota("Do"))
    }

    @Test func musicXMLConUnBajoAlteradoYUnTempoSinFigura() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Lab Lab/Mib Mib7 Lab")
        #expect(analisis.musicXML().contains("<bass-alter>-1</bass-alter>"))
        let voz = try Voz(leyendo: "Do4:4 Re4:4")
        #expect(voz.musicXML(tempo: Tempo(60, unidad: Duracion(1, 3))).contains(#"<sound tempo="80"/>"#))
    }

    @Test func unTransporteConCambioDeOctava() throws {
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
        #expect(pieza.notas.map(\.altura) == [Altura("Do3")])
    }

    @Test func melodiaDesdeMIDISinTonalidad() {
        #expect(Melodia(midi: []).alturas == [])
    }

    @Test func unAcordeConUnaNotaQueNoSeLee() throws {
        do {
            _ = try Evento(leyendo: "Do4+Xx4:4")
            Issue.record("Se esperaba un error")
        } catch {
            #expect((error as? ErrorDeLectura)?.posicion == 4)

        }
    }
}

@Suite struct APIPocoUsadaDeLosTrastesTests {
    @Test func descripciones() throws {
        #expect("\(PosicionEnElMastil(cuerda: 0, traste: 3))" == "cuerda 1 desde arriba, traste 3")
        #expect(Encordado.guitarra.numeroTradicional(deCuerda: 0) == 6)
        #expect(Encordado.ukelele.numeroTradicional(deCuerda: 0) == 4)
        let digitacion = try #require(Mastil(.guitarra).digitaciones(de: Acorde("Do")).first)
        #expect("\(digitacion)" == digitacion.tablatura)
    }
}
