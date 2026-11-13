import Armonia
import Testing

@testable import Exposicion

/// Lo que separa a dos acordes, a dos escalas o a los acordes de una progresión, escrito y en JSON.
@Suite struct RelacionesPresentadasTests {
    let espanol = Notacion.compacta(.espanol)

    @Test func entreAcordes() throws {
        let sol7 = try Acorde(leyendo: "Sol7")
        let relacion = RelacionEntreAcordesPresentada(sol7.relacion(con: try Acorde(leyendo: "Do")), en: espanol)
        #expect(relacion.con == "Do")
        #expect(relacion.tonalidad == "Do mayor")
        let datos = relacion.datos(en: espanol)
        #expect(datos.first?.valor == "4 · 2.449 · 2")
        #expect(datos.contains { $0.nombre == "Distancia de Lerdahl (Do mayor)" && $0.valor == "5" })
        // Sin Tonnetz (Sol7 no es una tríada) ni relaciones de Forte (tienen distinto tamaño).
        #expect(!datos.contains { $0.nombre == "Pasos en el Tonnetz" || $0.nombre == "Relaciones de Forte" })
        let hexatonica = RelacionEntreAcordesPresentada(
            try Acorde(leyendo: "Do").relacion(con: try Acorde(leyendo: "Lab")), en: espanol)
        #expect(hexatonica.datos(en: espanol).contains { $0.nombre == "Pasos en el Tonnetz" && $0.valor == "2" })
    }

    @Test func conLaTonalidad() throws {
        let acorde = try Acorde(leyendo: "Sol7")
        let presentado = AcordeEnLaTonalidadPresentado(acorde, en: Tonalidad(.do), notacion: espanol)
        #expect(presentado.funcionProbable == "dominante")
        #expect(presentado.tonalidadesCercanas.count == 3)
        #expect(presentado.escalasDelCatalogo.count == 8)
        let datos = presentado.datos(en: espanol)
        #expect(datos.map(\.nombre).contains("Escalas del catálogo"))
        #expect(datos.last?.valor.hasSuffix(", …") == true)
        // Fa♯ mayor en Do: sus notas no dicen ninguna función.
        let lejano = AcordeEnLaTonalidadPresentado(try Acorde(leyendo: "Fa#"), en: Tonalidad(.do), notacion: espanol)
        #expect(lejano.funcionProbable == nil)
        #expect(!lejano.datos(en: espanol).map(\.nombre).contains("Función probable"))
    }

    @Test func entreEscalas() {
        let aSol = RelacionEntreEscalasPresentada(Escala(.do, .mayor).relacion(con: Escala(.sol, .mayor)), en: espanol)
        #expect(aSol.conduccion == "Fa→Fa♯ (+1)")
        let datos = aSol.datos(en: espanol)
        #expect(datos.contains { $0.nombre == "Conducción mínima" })
        #expect(datos.contains { $0.nombre == "Conducción de Tymoczko (taxista · euclídea · máximo)" })
        // Con la cromática no hay conducción, y con el mismo conjunto, ninguna voz se mueve.
        let cromatica = RelacionEntreEscalasPresentada(
            Escala(.do, .mayor).relacion(con: Escala(.do, .cromatica)), en: espanol)
        #expect(cromatica.semitonosMovidos == nil)
        #expect(!cromatica.datos(en: espanol).contains { $0.nombre == "Conducción mínima" })
        #expect(cromatica.datos(en: espanol).contains { $0.nombre == "Relaciones de Forte" } == false)
        let igual = RelacionEntreEscalasPresentada(Escala(.do, .mayor).relacion(con: Escala(.re, .dorico)), en: espanol)
        #expect(igual.conduccion == nil)
        #expect(igual.semitonosMovidos == 0)
    }

    @Test func progresion() throws {
        let acordes = try ["Do", "Fa", "Sol7", "Do"].map { try Acorde(leyendo: $0) }
        let progresion = EstadisticasDeProgresionPresentadas(Tonalidad(.do).estadisticas(de: acordes), en: espanol)
        #expect(progresion.funciones == ["T", "S", "D", "T"])
        let datos = progresion.datos(en: espanol)
        #expect(datos.first?.valor == "0 5 8 5")
        #expect(datos.contains { $0.valor == "3 + 5 + 4 = 12" })
        let lejana = EstadisticasDeProgresionPresentadas(
            Tonalidad(.do).estadisticas(de: [try Acorde(leyendo: "Fa#")]), en: espanol)
        #expect(lejana.funciones == ["?"])
    }

    @Test func relacionesDeForte() {
        let distintas = RelacionEntreConjuntosPresentada(
            ConjuntoDeClasesDeAltura([0, 2, 4]).relacion(con: [0, 2, 6]))
        #expect(distintas.datos(en: espanol).last?.valor == "R2 · Rp")
    }
}
