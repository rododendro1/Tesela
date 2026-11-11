import Armonia
import Foundation
import Testing

@testable import Exposicion

// Las presentaciones de las vistas de análisis y coral, y los ficheros que exportan.

@Suite struct FicheroParaExportarTests {
    @Test func elNombreLlevaLaExtensionYNoLlevaBarras() {
        #expect(FicheroParaExportar.midi(Data(), nombre: "Sol7/Si").nombreDeFichero == "Sol7-Si.mid")
        #expect(FicheroParaExportar.musicXML("", nombre: "Coral").nombreDeFichero == "Coral.musicxml")
        #expect(FicheroParaExportar.mei("", nombre: "Coral").nombreDeFichero == "Coral.mei")
        #expect(FicheroParaExportar.lilyPond("", nombre: "Coral").nombreDeFichero == "Coral.ly")
        #expect(FicheroParaExportar.abc("", nombre: "Coral").nombreDeFichero == "Coral.abc")
        #expect(FicheroParaExportar.svg("", nombre: "  ").nombreDeFichero == "Tesela.svg")
        #expect(FicheroParaExportar.html("", nombre: "Hoja").nombreDeFichero == "Hoja.html")
        #expect(FicheroParaExportar.Formato.html.partitura == nil)
        #expect(FicheroParaExportar.Formato.html.titulo(en: .ascii(.ingles)) == "HTML page")
        #expect(
            FicheroParaExportar.svg("", nombre: String(repeating: "a", count: 200)).nombreDeFichero.count
                == (80 + ".svg".count))
    }

    @Test func seEscribeEnLaCarpetaDeExportaciones() throws {
        let carpeta = FileManager.default.temporaryDirectory.appendingPathComponent(
            UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: carpeta) }
        let fichero = FicheroParaExportar.svg("<svg/>", nombre: "Dibujo")
        let url = try fichero.escribir(en: carpeta)
        #expect(url.lastPathComponent == "Dibujo.svg")
        #expect(url.deletingLastPathComponent().lastPathComponent == "Exportaciones")
        #expect(try (Data(contentsOf: url)) == Data("<svg/>".utf8))
        // Escribir otra vez sustituye el fichero.
        try FicheroParaExportar.svg("<svg></svg>", nombre: "Dibujo").escribir(en: carpeta)
        #expect(try (Data(contentsOf: url)) == Data("<svg></svg>".utf8))
    }

    @Test func cadaFormatoTieneExtensionTituloEIconoDistintos() {
        let formatos = FicheroParaExportar.Formato.allCases
        #expect(Set(formatos.map(\.extensionDeFichero)).count == formatos.count)
        #expect(Set(formatos.map(\.titulo)).count == formatos.count)
        #expect(Set(formatos.map(\.icono)).count == formatos.count)
    }

    @Test func cadaPartituraTieneSuFormatoDeFichero() throws {
        for partitura in FormatoDePartitura.allCases {
            let formato = FicheroParaExportar.Formato(partitura)
            #expect(formato.partitura == partitura)
            #expect(formato.extensionDeFichero == partitura.extensionDeFichero)
        }
        #expect(FicheroParaExportar.Formato.svg.partitura == nil)
        // `partituras` da una por formato, en su orden, con lo que escribe `exportar(como:…)`.
        let voz = try Voz(leyendo: "Do4:4 Re4:4 Mi4:2")
        let ficheros = FicheroParaExportar.partituras(nombre: "Tema") {
            voz.partitura(encabezado: Encabezado(titulo: "Tema")).exportar(como: $0)
        }
        #expect(ficheros.compactMap(\.formato.partitura) == FormatoDePartitura.allCases)
        #expect(
            ficheros.map(\.nombreDeFichero) == [
                "Tema.musicxml", "Tema.mei", "Tema.ly", "Tema.gmn", "Tema.abc", "Tema.mid",
            ])
        #expect(ficheros[3].datos == Data(voz.partitura(encabezado: Encabezado(titulo: "Tema")).guido().utf8))
    }

    @Test func elIdentificadorEsElNombreDelFichero() {
        let fichero = FicheroParaExportar.musicXML("", nombre: "Coral")
        #expect(fichero.id == fichero.nombreDeFichero)
    }
}

@Suite struct PresentacionDeAnalisisTests {
    @Test func unaProgresionSinModulaciones() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Lam Re7 Sol7 Do", notacion: .compacta(.espanol))
        #expect(analisis.tramos.count == 1)
        #expect(analisis.tramos[0].cabecera == nil)
        #expect(analisis.tramos[0].filas.map(\.cifrado) == ["Do", "Lam", "Re7", "Sol7", "Do"])
        #expect(analisis.tramos[0].filas.first?.grado == "I")
        #expect(!analisis.cadencias.isEmpty)
    }

    @Test func lasModulacionesAbrenUnTramo() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Fa Sol7 Do Lam Re7 Sol", notacion: .compacta(.espanol))
        #expect(analisis.tramos.count == 2)
        #expect(analisis.tramos[1].cabecera != nil)
        #expect(analisis.tramos.flatMap(\.filas).count == 7)
    }

    @Test func laProgresionArpegiada() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Lam Re7 Sol7 Do", notacion: .compacta(.espanol))
        #expect(analisis.acordes == [Acorde("Do"), Acorde("Lam"), Acorde("Re7"), Acorde("Sol7"), Acorde("Do")])
        #expect(analisis.tonalidad == Tonalidad(.do))
        let arpegiada = try #require(analisis.arpegiada(.alberti, en: .compacta(.espanol)))
        // Una blanca por acorde, en corcheas.
        #expect(arpegiada.voz.eventos.count == 20)
        #expect(arpegiada.ficheros.map(\.formato) == [.musicXML, .mei, .lilyPond, .guido, .abc, .midi])
        #expect(arpegiada.ficheros[0].nombre == "Progresión arpegiada (bajo de Alberti)")
        #expect(arpegiada.sonido.notas.count == 20)
        // Los ficheros de la progresión y los de la arpegiada no se pisan.
        let nombres = (analisis.ficheros + arpegiada.ficheros).map(\.nombreDeFichero)
        #expect(Set(nombres).count == nombres.count)
        #expect(
            PresentacionDeArpegios.progresion([], patron: .ascendente, tonalidad: nil, en: .compacta(.espanol))
                == nil
        )
    }

    @Test func unArpegioSeExporta() {
        let arpegio = PresentacionDeArpegios.arpegio(
            Arpegio(Acorde("Sol7"), patron: .idaYVuelta), en: .compacta(.espanol))
        #expect(arpegio.voz.eventos.count == 9)
        #expect(arpegio.ficheros.map(\.formato) == [.musicXML, .mei, .lilyPond, .guido, .abc, .midi])
        #expect(arpegio.sonido.notas.first?.altura.midi == 67)
    }

    @Test func otrasFigurasYOctavas() throws {
        let semicorcheas = PresentacionDeArpegios.arpegio(
            Arpegio(Acorde("Do"), patron: .quebrado, octavas: 2, conOctava: false), figura: .semicorchea,
            en: .compacta(.espanol))
        #expect(semicorcheas.voz.eventos.allSatisfy { $0.duracion == .semicorchea })
        // Dos octavas sin la final: seis notas, quebradas de dos en dos (cuatro parejas).
        #expect(semicorcheas.voz.eventos.count == 8)
        let analisis = try PresentacionDeAnalisis.analizar("Do Sol7 Do", notacion: .compacta(.espanol))
        let negras = try #require(analisis.arpegiada(.ascendente, figura: .negra, en: .compacta(.espanol)))
        // Una blanca por acorde: dos negras cada uno.
        #expect(negras.voz.eventos.count == 6)
        #expect(negras.voz.eventos.allSatisfy { $0.duracion == .negra })
    }

    @Test func tresillosTempoSwingYEnlace() throws {
        let tresillo = Duracion.corchea.grupoIrregular(3, en: 2)
        let arpegio = PresentacionDeArpegios.arpegio(
            Arpegio(Acorde("Do"), conOctava: false), figura: tresillo, tempo: Tempo(120), en: .compacta(.espanol))
        #expect(arpegio.voz.eventos.allSatisfy { $0.duracion == tresillo })
        // A 120, cada negra dura medio segundo y cada corchea de tresillo, un sexto.
        #expect(arpegio.sonido.inicios.map { ($0 * 6).rounded() } == [0, 1, 2])
        #expect(String(decoding: arpegio.ficheros[0].datos, as: UTF8.self).contains("<per-minute>120"))
        let conSwing = PresentacionDeArpegios.arpegio(
            Arpegio(Acorde("Do")), swing: true, en: .compacta(.espanol))
        let recta = PresentacionDeArpegios.arpegio(Arpegio(Acorde("Do")), en: .compacta(.espanol))
        #expect(conSwing.sonido != recta.sonido)
        #expect(conSwing.ficheros == recta.ficheros)
        // Enlazados, el Fa empieza por el Do, la nota más cercana al último Do del primero.
        let analisis = try PresentacionDeAnalisis.analizar("Do Fa", notacion: .compacta(.espanol))
        let suelta = try #require(analisis.arpegiada(.ascendente, figura: .semicorchea, en: .compacta(.espanol)))
        let enlazada = try #require(
            analisis.arpegiada(.ascendente, figura: .semicorchea, enlazados: true, en: .compacta(.espanol)))
        #expect(suelta.voz.eventos[8].alturas.first?.nota == .fa)
        #expect(enlazada.voz.eventos[8].alturas.first?.nota == .do)
        let lenta = try #require(
            PresentacionDeArpegios.progresion(
                [Acorde("Do")], patron: .ascendente, tonalidad: nil, tempo: Tempo(60), swing: true,
                en: .compacta(.espanol)))
        #expect(lenta.sonido.notas.count == 4)
    }

    @Test func losFicherosDelArpegioSeLeenConLasMismasNotas() throws {
        let arpegio = PresentacionDeArpegios.arpegio(
            Arpegio(Acorde("Fa#m7"), patron: .alberti), en: .compacta(.espanol))
        let sonido = arpegio.sonido.notas
        for fichero in arpegio.ficheros where [.musicXML, .midi].contains(fichero.formato) {
            let pieza = try PiezaImportada(leyendo: fichero.datos)
            #expect(pieza.notas.map(\.altura.midi) == sonido.map(\.midi), "\(fichero.formato)")
            #expect(Set(pieza.notas.map(\.duracion)) == [.corchea], "\(fichero.formato)")
        }
        // MusicXML guarda el título y la ortografía: Fa♯ y Do♯, no Sol♭ y Re♭.
        let xml = try PiezaImportada(musicXML: arpegio.ficheros[0].datos)
        #expect(xml.titulo == arpegio.ficheros[0].nombre)
        #expect(xml.notas.map(\.altura.nombre) == sonido.map(\.altura.nombre))
    }

    @Test func laProgresionArpegiadaLlevaLaArmaduraYSusAcordes() throws {
        let acordes = [Acorde("Re"), Acorde("Sol"), Acorde("La7"), Acorde("Re")]
        let arpegiada = try #require(
            PresentacionDeArpegios.progresion(
                acordes, patron: .ascendente,
                tonalidad: Tonalidad(.re),
                en: .ascii(.ingles)))
        let patron = Arpegio.Patron.ascendente.nombre(en: .ascii(.ingles))
        #expect(arpegiada.ficheros[0].nombre == "Progresión arpegiada (\(patron))")
        for fichero in arpegiada.ficheros where [.musicXML, .midi].contains(fichero.formato) {
            let pieza = try PiezaImportada(leyendo: fichero.datos)
            #expect(pieza.tonalidad == Tonalidad(.re), "\(fichero.formato)")
            // Cada acorde dura una blanca: leída de blanca en blanca, la pieza da la progresión.
            #expect(pieza.duracion == Duracion(2), "\(fichero.formato)")
            #expect(pieza.acordes(ventana: .blanca).map(\.cifrado) == acordes.map(\.cifrado), "\(fichero.formato)")
        }
    }

    @Test func conLosAcordesYaLeidosSaleLoMismo() throws {
        let texto = "Do Fa Sol7 Do Lam Re7 Sol"
        let acordes = try texto.split(separator: " ").map { try Acorde(leyendo: String($0)) }
        let leido = try PresentacionDeAnalisis.analizar(texto, notacion: .compacta(.espanol))
        #expect(PresentacionDeAnalisis.analizar(acordes, notacion: .compacta(.espanol)) == leido)
        let enDo = try PresentacionDeAnalisis.analizar(texto, en: Tonalidad(.do), notacion: .compacta(.espanol))
        #expect(PresentacionDeAnalisis.analizar(acordes, en: Tonalidad(.do), notacion: .compacta(.espanol)) == enDo)
        #expect(PresentacionDeAnalisis.analizar([], notacion: .compacta(.espanol)) == nil)
    }

    @Test func exportaPartiturasYMIDI() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Fa Sol7 Do", notacion: .compacta(.espanol))
        #expect(analisis.ficheros.map(\.formato) == [.musicXML, .mei, .lilyPond, .guido, .abc, .midi])
        #expect(String(decoding: analisis.ficheros[0].datos, as: UTF8.self).contains("score-partwise"))
        #expect(String(decoding: analisis.ficheros[1].datos, as: UTF8.self).contains("<mei "))
        #expect(String(decoding: analisis.ficheros[2].datos, as: UTF8.self).hasPrefix("\\version"))
        #expect(String(decoding: analisis.ficheros[3].datos, as: UTF8.self).contains("\\staff<1>"))
        #expect(String(decoding: analisis.ficheros[4].datos, as: UTF8.self).hasPrefix("X:1"))
        #expect(analisis.ficheros[5].datos.prefix(4) == Data("MThd".utf8))
    }

    @Test func laNotacionSeUsaEnLosCifrados() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Sol7 Do", notacion: .ascii(.ingles))
        #expect(analisis.tramos[0].filas.map(\.cifrado) == ["C", "G7", "C"])
    }

    @Test func unTextoQueNoSeLeeEsUnError() throws {
        #expect(throws: (any Error).self) {
            try PresentacionDeAnalisis.analizar("Do Xyz", notacion: .compacta(.espanol))
        }
    }

    @Test func conUnaTonalidadDadaNoModula() throws {
        let analisis = try PresentacionDeAnalisis.analizar(
            "Do Fa Sol7 Do Lam Re7 Sol", en: Tonalidad(leyendo: "Do mayor"),
            notacion: .compacta(.espanol))
        #expect(analisis.tramos.count == 1)
        #expect(analisis.titulo.hasSuffix("Do mayor"), Comment(rawValue: analisis.titulo))
        #expect(analisis.tramos[0].filas.count == 7)
        #expect(analisis.ficheros.count == 6)
    }

    @Test func unAcordeSinFuncionLaDejaEnBlanco() throws {
        let acordes = try ["Do", "Fa#+", "Sol7"].map { try Acorde(leyendo: $0) }
        let analisis = try #require(PresentacionDeAnalisis.analizar(acordes, notacion: .compacta(.espanol)))
        #expect(analisis.tramos.flatMap(\.filas).map(\.funcion) == ["tónica", "", "dominante"])
    }
}

@Suite struct PresentacionDeCoralTests {
    @Test func armonizarConOctavasDaElCoral() throws {
        let coral = try PresentacionDeCoral.presentar(.armonizar, "Mi4 Fa4 Re4 Do4", en: .compacta(.espanol))
        #expect(coral.titulo == "Do mayor")
        #expect(coral.propuestas.first == "Do Fa Sol Do (I–IV–V–I)")
        #expect(coral.filas.map(\.grado) == ["I", "IV", "V", "I"])
        #expect(coral.filas.first?.voces == "Do₃ Sol₃ Do₄ Mi₄")
        #expect(coral.avisos.isEmpty, "\(coral.avisos)")
        #expect(coral.ficheros.map(\.formato) == [.musicXML, .mei, .lilyPond, .guido, .abc, .midi])
    }

    @Test func armonizarSinOctavasNoDaCoral() throws {
        let coral = try PresentacionDeCoral.presentar(.armonizar, "Mi Re Do", propuestas: 1, en: .compacta(.espanol))
        #expect(coral.propuestas == ["Do Sol Do (I–V–I)"])
        #expect(coral.filas.isEmpty)
        #expect(coral.ficheros.isEmpty)
        #expect(coral.avisos == [.faltanOctavas])
        #expect(
            coral.avisos[0].texto(en: .compacta(.espanol))
                == "Escribe las notas con su octava (Mi₄ Re₄ Do₄) para verlas a cuatro voces.")
        #expect(
            coral.avisos[0].texto(en: .ascii(.ingles))
                == "Write the notes with their octave (E4 D4 C4) to see them in four parts.")
    }

    @Test func laTonalidadDadaManda() throws {
        let coral = try PresentacionDeCoral.presentar(
            .armonizar, "Do Si La Sol# La", tonalidad: "La menor",
            en: .compacta(.espanol))
        #expect(coral.titulo == "La menor")
        #expect(throws: (any Error).self) {
            try PresentacionDeCoral.presentar(.armonizar, "Do", tonalidad: "Xyz", en: .compacta(.espanol))
        }
    }

    @Test func realizarEscribeCuatroVocesSinFaltas() throws {
        let coral = try PresentacionDeCoral.presentar(.realizar, "Do Fa Sol7 Do", en: .compacta(.espanol))
        #expect(coral.filas.map(\.cifrado) == ["Do", "Fa", "Sol7", "Do"])
        #expect(coral.filas.allSatisfy { $0.voces.split(separator: " ").count == 4 })
        #expect(coral.avisos.isEmpty, "\(coral.avisos)")
        #expect(coral.ficheros.count == 6)
    }

    @Test func revisarEncuentraLasParalelas() throws {
        let coral = try PresentacionDeCoral.presentar(
            .revisar, "Do3 Sol3 Mi4 Do5, Re3 La3 Fa4 Re5", en: .compacta(.espanol))
        #expect(coral.filas.map(\.voces) == ["Do₃ Sol₃ Mi₄ Do₅", "Re₃ La₃ Fa₄ Re₅"])
        #expect(coral.filas.map(\.cifrado) == ["Do", "Rem"])
        #expect(!coral.avisos.isEmpty)
        #expect(!coral.avisos.contains(.sinFaltasDeConduccion))
        #expect(coral.avisos.allSatisfy { !$0.texto(en: .compacta(.espanol)).isEmpty })
    }

    @Test func revisarUnBuenEnlace() throws {
        let coral = try PresentacionDeCoral.presentar(
            .revisar, "Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4", en: .compacta(.espanol))
        #expect(coral.avisos == [.sinFaltasDeConduccion])
        #expect(coral.avisos[0].texto(en: .compacta(.espanol)) == "Sin faltas de conducción.")
        #expect(coral.avisos[0].texto(en: .conPalabras(.euskera)) == "Ez dago ahots-eramate akatsik.")
    }

    @Test func unTextoVacioEsUnError() throws {
        for tarea in PresentacionDeCoral.Tarea.allCases {
            #expect(throws: (any Error).self, "\(tarea)") {
                try PresentacionDeCoral.presentar(tarea, "  ", en: .compacta(.espanol))
            }
        }
    }

    @Test func losEjemplosFuncionan() throws {
        for tarea in PresentacionDeCoral.Tarea.allCases {
            #expect(throws: Never.self, "\(tarea)") {
                try PresentacionDeCoral.presentar(tarea, tarea.ejemplo, en: .compacta(.espanol))
            }
        }
    }

    @Test func lasTareas() {
        #expect(PresentacionDeCoral.Tarea.allCases.map(\.id) == PresentacionDeCoral.Tarea.allCases)
        #expect(PresentacionDeCoral.Tarea.allCases.map(\.usaTonalidad) == [true, true, false])
        for tarea in PresentacionDeCoral.Tarea.allCases {
            // La indicación lleva el ejemplo, o al menos su primera palabra.
            #expect(tarea.indicacion.contains(tarea.ejemplo.split(separator: " ")[0]), "\(tarea)")
        }
    }

    @Test func losAvisosDeLoQueNoSeArmonizaNiSeRealiza() throws {
        // Notas que no son de Do mayor: no hay armonización ni coral.
        let fuera = try PresentacionDeCoral.armonizar(
            "Do#4 Re#4 Fa4 Sol#4", en: Tonalidad(.do, .mayor), notacion: .compacta(.espanol))
        #expect(fuera.avisos == [.sinArmonizacion, .sinCoralParaLaMelodia])
        #expect(fuera.propuestas == [])
        #expect(fuera.sonido == .silencio)
        // Una melodía que no cabe en las voces se armoniza, pero sin coral.
        #expect(
            try (PresentacionDeCoral.armonizar("Do1 Do8", en: nil, notacion: .compacta(.espanol)).avisos) == [
                .sinCoralParaLaMelodia
            ])
        let sinRealizacion = try PresentacionDeCoral.realizar(
            "Do7(b9,#9,#11,b13)", en: nil, notacion: .compacta(.espanol))
        #expect(sinRealizacion.avisos == [.sinRealizacion])
        #expect(sinRealizacion.filas == [])
        #expect(sinRealizacion.sonido == .silencio)
    }

    @Test func unaMelodiaConRitmo() throws {
        // En un acorde se armoniza la nota más aguda; una voz con solo silencios es un texto vacío.
        let coral = try PresentacionDeCoral.armonizar("Do4+Mi4:4 Re4:4 Do4:2", en: nil, notacion: .compacta(.espanol))
        #expect(coral.avisos == [])
        #expect(!coral.propuestas.isEmpty)
        #expect(throws: (any Error).self) {
            try PresentacionDeCoral.armonizar("-:4 -:4", en: nil, notacion: .compacta(.espanol))
        }
    }
}
