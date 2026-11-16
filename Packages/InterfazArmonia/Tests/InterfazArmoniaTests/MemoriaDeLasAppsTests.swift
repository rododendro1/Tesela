import Armonia
import ExposicionArmonia
import Foundation
import Testing

@testable import InterfazArmonia

@Suite struct MemoriaDeLasAppsTests {
    @Test func loUltimoDeCadaLugar() {
        var memoria = MemoriaDeLasApps()
        #expect(memoria.ultimo(en: .acordes) == nil)
        memoria.anotar("Sol7/Si", en: .acordes)
        memoria.anotar("  Do   Fa Sol7 ", en: .analisis)
        memoria.anotar("Lam7", en: .acordes)
        #expect(memoria.ultimo(en: .acordes) == "Lam7")
        #expect(memoria.ultimo(en: .analisis) == "Do Fa Sol7")
        // Lo vacío no se recuerda.
        memoria.anotar("   ", en: .acordes)
        #expect(memoria.ultimo(en: .acordes) == "Lam7")
    }

    @Test func elHistorialSinRepetidosYConLimite() {
        var memoria = MemoriaDeLasApps()
        memoria.anotar("Do", en: .acordes)
        memoria.anotar("Re dórico", en: .escalas)
        memoria.anotar("Sol7", en: .acordes)
        memoria.anotar("Do", en: .acordes)
        // Lo más reciente primero, y lo repetido sube en lugar de repetirse.
        #expect(memoria.historial(de: .acordes).map(\.texto) == ["Do", "Sol7"])
        #expect(memoria.historial(de: .escalas).map(\.texto) == ["Re dórico"])
        for n in 1...30 { memoria.anotar("Do\(n)", en: .acordes) }
        let acordes = memoria.historial(de: .acordes)
        #expect(acordes.count == MemoriaDeLasApps.limiteDelHistorial)
        #expect(acordes.first?.texto == "Do30")
        // El límite es por lugar: las escalas siguen ahí.
        #expect(memoria.historial(de: .escalas).count == 1)
        memoria.borrarHistorial(de: .acordes)
        #expect(memoria.historial(de: .acordes).isEmpty)
        #expect(memoria.ultimo(en: .acordes) == "Do30")
        #expect(memoria.historial(de: .escalas).count == 1)
    }

    @Test func losFavoritos() {
        var memoria = MemoriaDeLasApps()
        memoria.alternarFavorito("Sol7/Si", en: .acordes)
        memoria.alternarFavorito("Re dórico", en: .escalas)
        #expect(memoria.esFavorito("Sol7/Si", en: .acordes))
        #expect(memoria.esFavorito(" Sol7/Si ", en: .acordes))
        // El mismo texto en otro lugar es otro favorito.
        #expect(!memoria.esFavorito("Sol7/Si", en: .analisis))
        #expect(memoria.favoritos(de: .escalas).map(\.texto) == ["Re dórico"])
        memoria.alternarFavorito("Sol7/Si", en: .acordes)
        #expect(!memoria.esFavorito("Sol7/Si", en: .acordes))
        memoria.alternarFavorito("", en: .acordes)
        #expect(memoria.favoritos(de: .acordes).isEmpty)
    }

    @Test func seGuardaYSeLee() throws {
        var memoria = MemoriaDeLasApps()
        memoria.anotar("Sol7/Si", en: .acordes)
        memoria.anotar("Re dórico", en: .escalas)
        memoria.alternarFavorito("Do Fa Sol7 Do", en: .analisis)
        #expect(MemoriaDeLasApps(guardada: memoria.guardada) == memoria)
        // Lo que no se lee (vacío, de otra versión) es una memoria vacía, no un error.
        #expect(MemoriaDeLasApps(guardada: "") == MemoriaDeLasApps())
        #expect(MemoriaDeLasApps(guardada: "{}") == MemoriaDeLasApps())
        #expect(MemoriaDeLasApps(guardada: "no es JSON") == MemoriaDeLasApps())
        // En los ajustes, con su clave.
        let nombre = "MemoriaDeLasAppsTests.\(UUID().uuidString)"
        let ajustes = try #require(UserDefaults(suiteName: nombre))
        defer { ajustes.removePersistentDomain(forName: nombre) }
        #expect(MemoriaDeLasApps.cargar(de: ajustes) == MemoriaDeLasApps())
        memoria.guardar(en: ajustes)
        #expect(ajustes.string(forKey: AjustesDeLasApps.claveDeMemoria) == memoria.guardada)
        #expect(MemoriaDeLasApps.cargar(de: ajustes) == memoria)
    }

    @Test func losModelosEmpiezanPorLoRecordado() {
        #expect(ModeloDeAcordes(recordado: MemoriaDeLasApps()).texto == ModeloDeAcordes.textoInicial)
        #expect(ModeloDeAnalisis(recordado: MemoriaDeLasApps()).texto == ModeloDeAnalisis.textoInicial)
        var memoria = MemoriaDeLasApps()
        memoria.anotar("Lam7", en: .acordes)
        memoria.anotar("Rem7 Sol7 Do7M", en: .analisis)
        memoria.anotar("Lam", en: .tonnetzRecorrido)
        memoria.anotar("Fa7M", en: .tonnetzAcorde)
        memoria.anotar("Mi frigio", en: .tonnetzEscala)
        let acordes = ModeloDeAcordes(recordado: memoria)
        #expect(acordes.texto == "Lam7")
        #expect(acordes.acorde == (try? Acorde(leyendo: "Lam7")))
        #expect(ModeloDeAnalisis(recordado: memoria).texto == "Rem7 Sol7 Do7M")
        let tonnetz = ModeloDelTonnetz(recordado: memoria)
        #expect(tonnetz.textoInicial == "Lam" && tonnetz.textoAcorde == "Fa7M" && tonnetz.textoEscala == "Mi frigio")
        #expect(tonnetz.recorrido == [try? Acorde(leyendo: "Lam")].compactMap { $0 })
        #expect(ModeloDelTonnetz(recordado: MemoriaDeLasApps()).textoInicial == ModeloDelTonnetz().textoInicial)
    }

    /// Lo que enseña, sin SwiftUI, el artículo «Hacer una vista» (InterfazArmonia.docc/HacerUnaVista.md).
    @Test func elArticuloDeLaVista() {
        var modelo = ModeloDeAcordes(texto: "Lam7")
        #expect(modelo.acorde == Acorde("Lam7"))
        modelo.texto = "Lam7("
        #expect(modelo.acorde == nil)
        let acorde = Acorde("Sol7/Si")
        let pentagrama = PentagramaPresentado(acorde, en: .compacta(.espanol))
        #expect(pentagrama.fichero.formato == .svg)
        #expect(Escucha.acorde(acorde).notas.count == 4)
    }

    /// La escala se recuerda por su nombre en español y vuelve a la misma tónica y el mismo tipo del catálogo; la
    /// escrita, por sus notas.
    @Test func laEscalaRecordada() {
        var eleccion = EleccionDeEscala()
        eleccion.elegir(Escala(.re, .dorico))
        #expect(eleccion.paraRecordar == "Re dórico")
        let vuelta = EleccionDeEscala.recordada(eleccion.paraRecordar)
        #expect(vuelta == eleccion)
        #expect(vuelta.propia.isEmpty)
        let escrita = EleccionDeEscala(propia: "Do Re Mi Fa♯ Sol La Si")
        #expect(escrita.paraRecordar == "Do Re Mi Fa♯ Sol La Si")
        #expect(EleccionDeEscala.recordada(escrita.paraRecordar).escala == escrita.escala)
        // Lo que no se lee se queda escrito, como estaba.
        #expect(EleccionDeEscala(propia: "nada").paraRecordar == "Do mayor")
        // En el menú, en la notación de la app.
        let recuerdo = MemoriaDeLasApps.Recuerdo("Re dórico", en: .escalas)
        #expect(
            MemoriaDeLasApps.titulo(de: recuerdo, en: .compacta(.ingles))
                == Escala(.re, .dorico).nombre(en: .compacta(.ingles)))
        #expect(
            MemoriaDeLasApps.titulo(de: MemoriaDeLasApps.Recuerdo("Sol7", en: .acordes), en: .compacta(.ingles))
                == "Sol7")
    }
}
