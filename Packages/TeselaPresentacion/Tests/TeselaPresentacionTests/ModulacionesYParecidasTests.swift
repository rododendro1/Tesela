import Armonia
import Testing

@testable import TeselaPresentacion

// Las modulaciones desde una tonalidad y las escalas más parecidas a una dada.
@Suite struct ModulacionesYParecidasTests {
    let notacion = Notacion.espanolCompacto

    @Test func modulacionesALosTonosVecinos() {
        let vecinas = PresentacionDeModulaciones.modulaciones(desde: Tonalidad(.do), en: notacion)
        #expect(vecinas.map(\.destino) == ["La menor", "Sol mayor", "Mi menor", "Fa mayor", "Re menor"])
        let aSol = vecinas[1]
        #expect(aSol.tecnica == "acorde común")
        #expect(aSol.pivote == "Lam = vi en Do mayor = ii en Sol mayor")
        #expect(aSol.acordes == "Do Fa Sol7 Do Lam Re7 Sol")
        #expect(aSol.sonido.notas.count > 0)
    }

    @Test func modulacionesAUnaTonalidad() {
        let aLab = PresentacionDeModulaciones.modulaciones(
            desde: Tonalidad(.do), hasta: Tonalidad(Nota.la.bemol), en: notacion)
        #expect(aLab.first?.tecnica == "séptima disminuida enarmónica")
        #expect(aLab.last?.tecnica == "directa")
        #expect(aLab.last?.pivote == nil)
        let aDo = PresentacionDeModulaciones.modulaciones(
            desde: Tonalidad(.do), hasta: Tonalidad(.do), en: notacion)
        #expect(aDo.isEmpty)
        let ingles = PresentacionDeModulaciones.modulaciones(desde: Tonalidad(.do), en: .inglesASCII)
        #expect(ingles.first?.destino == "A minor")
    }

    @Test func escalasParecidas() {
        let parecidas = Escala(.do).masParecidas()
        #expect(!parecidas.isEmpty && parecidas.count <= 16)
        // De la que menos cambia a la que más, y ninguna con las mismas notas.
        #expect(parecidas.map(\.diferencia) == parecidas.map(\.diferencia).sorted())
        #expect(parecidas.allSatisfy { $0.diferencia > 0 })
        let lidio = parecidas.first { $0.escala == Escala(.do, .lidio) }
        #expect(lidio?.quitadas == [Nota.fa])
        #expect(lidio?.anadidas == [Nota.fa.sostenido])
        #expect(lidio?.comunes.count == 6)
        // El juego de notas de Sol mayor sale como Do lidio, con la misma tónica.
        #expect(!parecidas.contains { $0.escala == Escala(.sol) })
        let presentadas = PresentacionDeEstudioDeEscala.parecidas(a: Escala(.do), en: notacion)
        #expect(presentadas.contains { $0.nombre == "Do lidio" && $0.detalle == "Notas comunes: 6 · −Fa · +Fa♯" })
    }
}
