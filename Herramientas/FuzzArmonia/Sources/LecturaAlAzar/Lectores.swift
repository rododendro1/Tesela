import Armonia
import Foundation

/// Lo que se prueba con datos al azar: cada lector del motor que recibe algo de fuera, con lo que se hace después
/// con lo leído. El primer byte de los datos elige el lector y el resto es lo que lee (los lectores de texto, como
/// UTF-8). Un lector puede fallar con un error, que es lo esperado con datos estropeados, pero no detener el
/// programa ni colgarse.
public enum LecturaAlAzar {
    /// Un lector: su nombre (el de los ficheros de partida) y qué hace con los datos.
    public struct Lector: Sendable {
        public let nombre: String
        public let leer: @Sendable (Data) throws -> Void
    }

    public static let lectores: [Lector] = [
        Lector(nombre: "fichero") { datos in
            // MIDI, MusicXML, MXL, MEI o ABC, según lo que contenga: lo que abren las apps y `armonia importar`.
            let pieza = try PiezaImportada(leyendo: datos)
            _ = pieza.duracion
            _ = pieza.tonalidadEstimada
            _ = pieza.acordes()
            _ = pieza.analisis()
            _ = pieza.notas.map(\.altura.nombre)
        },
        texto("acorde") { texto in
            let acorde = try Acorde(leyendo: texto)
            _ = acorde.description
            _ = acorde.nombre
            _ = acorde.posicionCerrada()
        },
        texto("tipo de acorde") { _ = try TipoDeAcorde(leyendo: $0) },
        texto("nota") { _ = try Nota(leyendo: $0) },
        texto("altura") { _ = try Altura(leyendo: $0).midi },
        texto("intervalo") { _ = try Intervalo(leyendo: $0) },
        texto("escala") { texto in
            let escala = try Escala(leyendo: texto)
            _ = escala.notas
        },
        texto("tonalidad") { _ = try Tonalidad(leyendo: $0) },
        texto("arpegio") { _ = try Arpegio(leyendo: $0) },
        texto("análisis") { texto in
            let analisis = try AnalisisArmonico.analizar(leyendo: texto)
            _ = analisis.description
        },
        texto("recorrido tonal") { _ = try RecorridoTonal(leyendo: $0).tramos },
        texto("coral") { texto in
            let coral = try Coral(leyendo: texto)
            _ = coral.partitura().musicXML()
        },
        texto("voz") { texto in
            let voz = try Voz(leyendo: texto, compas: "3/4")
            _ = voz.partitura().musicXML()
        },
        texto("evento") { _ = try Evento(leyendo: $0) },
        texto("duración") { _ = try Duracion(leyendo: $0) },
        texto("compás") { _ = try Compas(leyendo: $0) },
        Lector(nombre: "MEI") { datos in
            // Directo al lector de MEI, para que los cambios al azar no lo conviertan en otro formato.
            let pieza = try PiezaImportada(mei: datos)
            _ = pieza.acordes()
            _ = pieza.analisis()
        },
        texto("ABC") { texto in
            let pieza = try PiezaImportada(abc: texto)
            _ = pieza.acordes()
            _ = pieza.analisis()
        },
        texto("conjunto de clases") { texto in
            let conjunto = try ConjuntoDeClasesDeAltura(leyendo: texto)
            _ = conjunto.numeroDeForte
        },
        texto("serie dodecafónica") { texto in
            let serie = try SerieDodecafonica(leyendo: texto)
            _ = serie.matriz
            _ = serie.formasCombinatorias
            _ = try SerieDodecafonica(leyendo: serie.description)
        },
        texto("UIL") { texto in
            // Los teclados que abre TonnetzApp: se leen y se vuelven a escribir.
            let formato = try FormatoUIL(leyendo: texto)
            _ = try FormatoUIL(leyendo: formato.descripcion)
        },
    ]

    /// Lee los datos con el lector que elige su primer byte.
    public static func leer(_ datos: Data) {
        guard let primero = datos.first else { return }
        let lector = lectores[Int(primero) % lectores.count]
        _ = try? lector.leer(datos.dropFirst())
    }

    /// Los ficheros de partida, uno o varios por lector, con su byte delante: lo que escribe la propia biblioteca
    /// y ejemplos de lo que se escribe a mano. libFuzzer los va cambiando a partir de ahí.
    public static func semillas() throws -> [(nombre: String, datos: Data)] {
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa2 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8~ Mi4:4 Sol4+Si4:2", compas: "3/4")
        let ficheros: [Data] = [
            coral.partitura(
                duracion: .blanca, compas: Compas(3, 2),
                encabezado: Encabezado(tonalidad: Tonalidad(.do), tempo: Tempo(72))
            ).midi(),
            analisis.partitura().midi(),
            Data(
                coral.partitura(
                    duracion: .blanca, compas: Compas(3, 2), encabezado: Encabezado(tonalidad: Tonalidad(.do))
                ).musicXML().utf8),
            Data(analisis.partitura().musicXML().utf8),
            Data(voz.partitura().musicXML().utf8),
            mxl,
            Data(
                coral.partitura(
                    duracion: .blanca, compas: Compas(3, 2), encabezado: Encabezado(tonalidad: Tonalidad(.do))
                ).mei().utf8),
            Data(voz.partitura().abc().utf8),
        ]
        let partituras: [String: [Data]] = [
            "MEI": [
                Data(analisis.partitura().mei().utf8), Data(voz.partitura().mei().utf8),
                Data(try Escala(leyendo: "Re bayati").voz().partitura().mei().utf8),
            ],
            "ABC": [
                Data(analisis.partitura().abc().utf8),
                Data(try Escala(leyendo: "Re bayati").voz().partitura().abc().utf8),
                Data(Self.abcDeCancionero.utf8),
            ],
        ]
        let textos: [String: [String]] = [
            "acorde": ["Do", "Sol7/Si", "Fa#m7(b5)", "Mib maj9(#11)", "C7alt", "Lam6/9"],
            "tipo de acorde": ["m7", "7(b9,#11)", "sus4", "maj13"],
            "nota": ["Do#", "si bemol", "Fx", "фа-диез", "re bemoll"],
            "altura": ["Do4", "Fa#-1", "Sib9"],
            "intervalo": ["3M", "5J", "8A", "5d", "9m"],
            "escala": ["Re dórica", "Do mayor", "Sol mixolidia", "La menor armónica", "Re bayati"],
            "tonalidad": ["Do mayor", "Fa# menor", "Sib mayor"],
            "arpegio": ["arpegio Dom7", "Arpège de Do"],
            "análisis": ["Do Lam Re7 Sol7 Do", "Lam Mi7 Lam", "Do Fa Sol7/Re Do"],
            "recorrido tonal": ["Do Fa Sol7 Do Lam Re7 Sol"],
            "coral": ["Do3 Mi4 Sol4 Do5 | Fa2 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4"],
            "voz": ["Do4:4 Re4:8 Mi4:8~ Mi4:4 Sol4+Si4:2 -:4", "Mi4(50¢):4 Fa4:2."],
            "evento": ["Do4+Mi4:2~", "-:8", "Sol4:4.", "Mi♭4(50¢):4", "Do4+Si4(-15.094¢):2"],
            "duración": ["4", "8.", "2..", "16"],
            "compás": ["3/4", "6/8", "C"],
            "conjunto de clases": ["[0, 4, 7]", "01t", "4-Z15", "Do Mi Sol", "{t e 0}"],
            "serie dodecafónica": [
                "0 e 7 4 2 9 3 8 t 1 5 6", "0e742 938t156", "Fa Mi Do La Sol Re La♭ Re♭ Mi♭ Sol♭ Si♭ Si",
            ],
            "UIL": ["2,7,5;R30M", "1,4,3;R0", "2,7,5;R30;M"],
        ]
        var semillas: [(nombre: String, datos: Data)] = []
        for (i, lector) in lectores.enumerated() {
            let ejemplos =
                lector.nombre == "fichero"
                ? ficheros : partituras[lector.nombre] ?? (textos[lector.nombre] ?? []).map { Data($0.utf8) }
            for (j, ejemplo) in ejemplos.enumerated() {
                semillas.append(
                    ("\(lector.nombre.replacingOccurrences(of: " ", with: "-"))-\(j + 1)", Data([UInt8(i)]) + ejemplo))
            }
        }
        return semillas
    }

    private static func texto(_ nombre: String, _ leer: @escaping @Sendable (String) throws -> Void) -> Lector {
        Lector(nombre: nombre) { try leer(String(decoding: $0, as: UTF8.self)) }
    }

    /// Un ABC escrito a mano, como los de los cancioneros: adornos, repeticiones, tresillos, ligaduras y acordes.
    private static let abcDeCancionero = """
        X:1
        T:The Kesh
        M:6/8
        L:1/8
        Q:3/8=116
        K:G
        |:"G"GAG GAB|"D"ABA ABd|"G"edd gdd|"D"edB dBA|
        "G"GAG GAB|"D"ABA ABd|"C"edd gdB|1"D"AGF G3:|2"D"AGF G2||
        (3Bcd e2 ^f/=f/|[GBd]2 z G>A B<c|d2-d !trill!c2 B|]
        """

    /// Un .mxl como los de MuseScore (el de `ImportacionMXLTests`): tres redondas comprimidas con DEFLATE.
    private static let mxl = Data(
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
}
