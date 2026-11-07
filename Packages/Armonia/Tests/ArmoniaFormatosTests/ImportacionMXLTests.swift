import Foundation
import Testing

@testable import ArmoniaElementos
@testable import ArmoniaFormatos
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

/// MusicXML comprimido (.mxl) y el ritmo armónico de lo que se importa.
@Suite struct ImportacionMXLTests {
    /// Un .mxl como los de MuseScore, hecho con el `zipfile` de Python: `mimetype` sin comprimir,
    /// `META-INF/container.xml` y la partitura en `partitura/coral.musicxml`, comprimidos con DEFLATE. La
    /// partitura, «Comprimido», son tres redondas: Do, Sol y Do.
    static let mxl = Data(
        base64Encoded:
            "UEsDBBQAAAAAAAAAIQAuQhWCIgAAACIAAAAIAAAAbWltZXR5cGVhcHBsaWNhdGlvbi92bmQucmVjb3JkYXJlLm11c2ljeG1sUEsD"
            + "BBQAAAAIAMVEX119HtJcigAAALoAAAAWAAAATUVUQS1JTkYvY29udGFpbmVyLnhtbE2OMQ7CMAxF954i8orawMaQtBsnKAewEhcs"
            + "pUnkuhXcnrJQtj+8r/fc8JqT2UgWLtnDpTuDoRxK5PzwcB9v7RWGvnGhZEXOJL2TUnTiRMsxzbSm1FbUp4eKoqyroA1FMHXzunDY"
            + "JWBmioytvit5wFoTB9TdarccO6Gdjij040/fj+2d/fPZI6P5AFBLAwQUAAAACADFRF9d+B0u7EABAACBBQAAGAAAAHBhcnRpdHVy"
            + "YS9jb3JhbC5tdXNpY3htbO1UTU/DMAy971dUuZdsMCQOXiYxPq47wA/IWkOttUmVuBv796RNoRuMA9LYiUtqv8Tv+TlVYP5WlckG"
            + "nSdrZmJyMRYJmszmZF5n4vnpIb0RczUCn1mHaa0db8njUDANBQq21q3jmjJxiWphq9pRRbkFuQfHREHLk5bkWe0RJ5TPxHIi+m2j"
            + "K1RL0iZQDADIoUD1G5HokKJC7RuHiWmqFbpgLGCa2dGqYfQKctpQ68CrCcghgTXuFLzQCxdejUH2EcgOZ2o7WKFmr6YgY9DlKe9q"
            + "/MBiAjIel/uyxnKAauKsCNYZa7UIjtov2Iz1puPoo+Aunssbpzm01+59xtCJbAtbYlCKgpE9rllhXS4Pte7PqPV4ci3Z3+n3y70U"
            + "xyZ7+g5+dnt7Rq27L1rXfzjZq6OT/f9nfz9Z2b9Yhw+pGr0DUEsBAhQDFAAAAAAAAAAhAC5CFYIiAAAAIgAAAAgAAAAAAAAAAAAA"
            + "AIABAAAAAG1pbWV0eXBlUEsBAhQDFAAAAAgAxURfXX0e0lyKAAAAugAAABYAAAAAAAAAAAAAAIABSAAAAE1FVEEtSU5GL2NvbnRh"
            + "aW5lci54bWxQSwECFAMUAAAACADFRF9d+B0u7EABAACBBQAAGAAAAAAAAAAAAAAAgAEGAQAAcGFydGl0dXJhL2NvcmFsLm11c2lj"
            + "eG1sUEsFBgAAAAADAAMAwAAAAHwCAAAAAA==")!

    /// Un zip con los ficheros guardados tal cual (método 0), sin CRC (no se comprueba).
    static func zip(_ ficheros: [(nombre: String, datos: [UInt8])], metodo: UInt16 = 0) -> Data {
        func le(_ valor: Int, _ n: Int) -> [UInt8] { (0..<n).map { UInt8(truncatingIfNeeded: valor >> (8 * $0)) } }
        var locales: [UInt8] = []
        var central: [UInt8] = []
        for (nombre, datos) in ficheros {
            let n = [UInt8](nombre.utf8)
            let desplazamiento = locales.count
            locales +=
                le(0x0403_4B50, 4) + le(20, 2) + le(0, 2) + le(Int(metodo), 2) + le(0, 4) + le(0, 4)
                + le(datos.count, 4) + le(datos.count, 4) + le(n.count, 2) + le(0, 2) + n + datos
            central +=
                le(0x0201_4B50, 4) + le(20, 2) + le(20, 2) + le(0, 2) + le(Int(metodo), 2) + le(0, 4)
                + le(0, 4) + le(datos.count, 4) + le(datos.count, 4) + le(n.count, 2) + le(0, 2) + le(0, 2)
                + le(0, 2) + le(0, 2) + le(0, 4) + le(desplazamiento, 4) + n
        }
        let fin =
            le(0x0605_4B50, 4) + le(0, 2) + le(0, 2) + le(ficheros.count, 2) + le(ficheros.count, 2)
            + le(central.count, 4) + le(locales.count, 4) + le(0, 2)
        return Data(locales + central + fin)
    }

    @Test func unMXLComprimidoConDEFLATESeLee() throws {
        let pieza = try PiezaImportada(leyendo: ImportacionMXLTests.mxl)
        #expect(pieza.titulo == "Comprimido")
        #expect(pieza.notas.count == 9)
        #expect(pieza.acordes().map(\.cifrado) == ["Do", "Sol", "Do"])
        #expect(try (PiezaImportada(mxl: ImportacionMXLTests.mxl)) == pieza)
    }

    @Test func unZipSinContenedorUsaLaPrimeraPartitura() throws {
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let xml = [UInt8](
            coral.partitura(duracion: .blanca, encabezado: Encabezado(titulo: "Guardado")).musicXML().utf8)
        let datos = ImportacionMXLTests.zip([("META-INF/otro.xml", [UInt8]("<x/>".utf8)), ("coral.musicxml", xml)])
        let pieza = try PiezaImportada(leyendo: datos)
        #expect(try pieza == (PiezaImportada(musicXML: Data(xml))))
        #expect(pieza.titulo == "Guardado")
    }

    @Test func elContenedorDiceCualEsLaPartitura() {
        let contenedor = "<container><rootfiles><rootfile full-path='a/b.xml' media-type='x'/></rootfiles></container>"
        #expect(ArchivoZip.rutaDeLaPartitura(contenedor) == "a/b.xml")
        #expect(ArchivoZip.rutaDeLaPartitura("<container></container>") == nil)
        #expect(ArchivoZip.rutaDeLaPartitura("<rootfile full-path=\"\"/>") == nil)
    }

    @Test func dEFLATEConBloquesFijosYGuardados() throws {
        let texto = [UInt8]("Do Mi Sol, Do Mi Sol, Do Mi Sol: arpegio".utf8)
        // zlib con Z_FIXED (códigos fijos) y con nivel 0 (un bloque guardado).
        let comprimidos = [
            "c8lX8M1UCM7P0VFwwcK0UkgsKkhNz8wHAA==", "ASgA1/9EbyBNaSBTb2wsIERvIE1pIFNvbCwgRG8gTWkgU29sOiBhcnBlZ2lv",
        ]
        for base64 in comprimidos {
            var inflado = Inflado([UInt8](Data(base64Encoded: base64)!), maximo: 1000)
            try inflado.descomprimir()
            #expect(inflado.salida == texto, Comment(rawValue: base64))
        }
        // Lo que pasa del máximo, cortado o con un tipo de bloque que no existe, no se lee.
        var corto = Inflado([UInt8](Data(base64Encoded: "c8lX8M1UCM7P0VFwwcK0UkgsKkhNz8wHAA==")!), maximo: 10)
        #expect(throws: (any Error).self) { try corto.descomprimir() }
        var cortado = Inflado([0x73, 0xC9], maximo: 1000)
        #expect(throws: (any Error).self) { try cortado.descomprimir() }
        var reservado = Inflado([0x07], maximo: 1000)
        #expect(throws: (any Error).self) { try reservado.descomprimir() }
    }

    @Test func losZipsQueNoSeLeen() throws {
        func error(_ datos: Data) -> ErrorDeLecturaDeFichero? {
            do {
                _ = try PiezaImportada(leyendo: datos)
                return nil
            } catch {
                return error as? ErrorDeLecturaDeFichero
            }
        }
        #expect(error(ImportacionMXLTests.zip([("hola.txt", [UInt8]("hola".utf8))])) == .comprimido)
        #expect(error(ImportacionMXLTests.zip([("a.xml", [UInt8]("<x/>".utf8))], metodo: 12)) == .comprimido)
        #expect(error(ImportacionMXLTests.mxl.prefix(ImportacionMXLTests.mxl.count - 30)) == .comprimido)
        // Una partitura que no es MusicXML por partes, dentro del zip: el error es el de MusicXML.
        let porTiempos = ImportacionMXLTests.zip([("a.xml", [UInt8]("<score-timewise/>".utf8))])
        #expect(error(porTiempos) == .noEsMusicXMLPorPartes)
    }

    // MARK: Ritmo armónico

    private let ritmo = RitmoArmonico([
        AcordeConDuracion("Do", .blanca), AcordeConDuracion("Fa", .negra), AcordeConDuracion("Sol7", .negra),
        AcordeConDuracion("Do", .redonda),
    ])

    @Test func losAcordesConLoQueDuran() throws {
        let partitura = ritmo.partitura()
        for datos in [partitura.midi(), Data(partitura.musicXML().utf8)] {
            let pieza = try PiezaImportada(leyendo: datos)
            let leido = pieza.ritmoArmonico()
            #expect(leido.acordes.map(\.acorde.cifrado) == ["Do", "Fa", "Sol7", "Do"])
            #expect(leido.duraciones == ritmo.duraciones)
            #expect(pieza.acordesConInicio().map(\.inicio) == [.cero, .blanca, Duracion(3, 4), .redonda])
        }
    }

    @Test func laProgresionSeExportaConSuRitmo() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do")
        let xml = ritmo.con(duracion: .negra).partitura().musicXML()
        #expect(xml == analisis.partitura().musicXML())
        // Una blanca, dos negras y el último acorde alargado hasta la barra: dos compases de 4/4.
        let conBlanca = RitmoArmonico(Array(ritmo.acordes.dropLast()) + [AcordeConDuracion("Do", .blanca)])
        let dos = conBlanca.partitura().musicXML()
        #expect((dos.components(separatedBy: "<measure ").count - 1) == 2)
        #expect(dos.contains("<type>quarter</type>"))
        #expect(ritmo.con(duracion: .blanca).partitura().mei() == analisis.partitura(duracion: .blanca).mei())
        // En la tonalidad que se pida, en su compás y a su tempo, si el encabezado no da otro.
        let enFa = RitmoArmonico(ritmo.acordes, compas: "3/4", tempo: Tempo(80)).partitura(en: Tonalidad(.fa))
        #expect(enFa.encabezado.tonalidad == Tonalidad(.fa) && enFa.compas == "3/4")
        #expect(enFa.encabezado.tempo == Tempo(80))
        // Con menos de un compás, uno.
        let corto = RitmoArmonico(["Do", "Fa", "Sol7"], duracion: .negra).partitura().musicXML()
        #expect((corto.components(separatedBy: "<measure ").count - 1) == 1)
        // Sin acordes, una partitura vacía, en Do mayor.
        #expect(RitmoArmonico([AcordeConDuracion]()).partitura().encabezado.tonalidad == Tonalidad(.do))
        #expect(ritmo.transponer(.segundaMayor).acordes.map(\.acorde) == ["Re", "Sol", "La7", "Re"])
    }

    @Test func unaProgresionArpegiadaConSuRitmo() {
        let voz = Voz(arpegiando: RitmoArmonico([AcordeConDuracion("Do", .blanca), AcordeConDuracion("Sol", .negra)]))
        #expect(voz.eventos.count == 6)
        #expect(voz.eventos.map(\.duracion).reduce(.cero, +) == Duracion(3, 4))
        #expect(Voz(arpegiando: RitmoArmonico(ritmo.acordes, compas: "3/4")).compas == "3/4")
    }
}
