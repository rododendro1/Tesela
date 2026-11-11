import Armonia
import Exposicion
import Foundation
import Testing

@testable import Interfaz

@Suite struct ModeloDeAnalisisTests {
    private let espanol = Notacion.compacta(.espanol)

    private struct FicheroRoto: Error {}

    /// Una progresión como si se hubiera abierto de un MusicXML.
    private func importada(_ texto: String) throws -> ProgresionImportada {
        let analisis = try AnalisisArmonico.analizar(leyendo: texto)
        return try ImportacionDeProgresion.leer(Data(analisis.partitura().musicXML().utf8))
    }

    @Test func alAbrirAnalizaLaProgresionDeEjemplo() throws {
        let analisis = try ModeloDeAnalisis().analizar(en: espanol).get()
        #expect(analisis.acordes.count == 7)
    }

    @Test func unFicheroAbiertoPoneSusAcordesEnElCampo() throws {
        var modelo = ModeloDeAnalisis()
        modelo.abrir(.success(try importada("Do Lam Fa Sol")))
        #expect(modelo.texto == "Do Lam Fa Sol")
        #expect(modelo.abierta != nil)
        #expect(try modelo.analizar(en: espanol).get().acordes.count == 4)
    }

    @Test func alRetocarLoAbiertoSeAnalizaLoEscrito() throws {
        var modelo = ModeloDeAnalisis()
        modelo.abrir(.success(try importada("Do Lam Fa Sol")))
        modelo.texto = "Do Lam Fa Sol Do"
        #expect(modelo.abierta == nil)
        #expect(try modelo.analizar(en: espanol).get().acordes.count == 5)
    }

    @Test func unFicheroQueNoSeLeeGuardaElErrorHastaQueSeEscribe() {
        var modelo = ModeloDeAnalisis()
        modelo.abrir(.failure(FicheroRoto()))
        #expect(modelo.errorAlAbrir is FicheroRoto)
        #expect(modelo.texto == ModeloDeAnalisis().texto)
        modelo.texto = "Do Sol"
        #expect(modelo.errorAlAbrir == nil)
    }

    @Test func abrirOtroFicheroBorraElError() throws {
        var modelo = ModeloDeAnalisis()
        modelo.abrir(.failure(FicheroRoto()))
        modelo.abrir(.success(try importada("Do Sol")))
        #expect(modelo.errorAlAbrir == nil)
    }

    @Test func laClaveDelAnalisisCambiaConElTextoYLaNotacion() {
        var modelo = ModeloDeAnalisis()
        let antes = modelo.claveDelAnalisis(en: espanol)
        #expect(modelo.claveDelAnalisis(en: .compacta(.ingles)) != antes)
        modelo.texto = "Do Sol"
        #expect(modelo.claveDelAnalisis(en: espanol) != antes)
    }

    @Test func seTransponeLoEscrito() throws {
        var modelo = ModeloDeAnalisis(texto: "Do Fa Sol Do")
        let tonalidad = try #require(try modelo.analizar(en: espanol).get().tonalidad)
        modelo.transponer(de: tonalidad, a: Tonalidad(.re, .mayor), en: espanol)
        #expect(modelo.texto == "Re Sol La Re")
    }

    @Test func loAbiertoSeTransponeConSuRitmo() throws {
        var modelo = ModeloDeAnalisis()
        modelo.abrir(.success(try importada("Do Fa Sol Do")))
        let tonalidad = try #require(try modelo.analizar(en: espanol).get().tonalidad)
        modelo.transponer(de: tonalidad, a: Tonalidad(.re, .mayor), en: espanol)
        #expect(modelo.texto == "Re Sol La Re")
        #expect(modelo.abierta != nil)
    }

    @Test func laOtraVersionSaltaLoQueNoSeLee() {
        var modelo = ModeloDeAnalisis()
        modelo.contra = "Do Xq Sol7"
        #expect(modelo.otraVersion.count == 2)
    }

    @Test func lasDoceTonalidadesPartenDeLaDelAnalisis() throws {
        let analisis = try ModeloDeAnalisis(texto: "Do Fa Sol Do").analizar(en: espanol).get()
        #expect(ModeloDeAnalisis.tonalidadDeLasDoce(analisis) == analisis.tonalidad)
    }

    @Test func seExportanLaProgresionLasHojasYLaComparacionSiLaHay() throws {
        var modelo = ModeloDeAnalisis(texto: "Do Fa Sol Do")
        let analisis = try modelo.analizar(en: espanol).get()
        let sin = modelo.ficheros(de: analisis, en: espanol)
        #expect(!sin.isEmpty)
        #expect(modelo.arpegiada(analisis, en: espanol) != nil)
        modelo.contra = "Do Rem7 Sol7 Do"
        #expect(modelo.ficheros(de: analisis, en: espanol).count == sin.count + 1)
    }
}
