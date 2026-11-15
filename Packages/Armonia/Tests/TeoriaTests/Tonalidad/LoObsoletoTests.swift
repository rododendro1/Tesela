import Testing

@testable import Elementos
@testable import Teoria

// Lo que queda obsoleto hasta la 0.6.0 sigue dando lo mismo que lo que lo sustituye. Las pruebas se marcan obsoletas
// para que llamarlo no dé avisos.

@Suite struct LoObsoletoTests {
    @available(*, deprecated)
    @Test func elAcordeDeUnGradoConCuatriada() {
        let mayor = Escala(.do)
        #expect(mayor.acorde(grado: 5, cuatriada: true) == mayor.acorde(grado: 5, notas: 4))
        #expect(mayor.armonizar(cuatriadas: false) == mayor.armonizar(notas: 3))
        #expect(mayor.arpegio(grado: 2, cuatriada: true) == mayor.arpegio(grado: 2, notas: 4))
        #expect(mayor.arpegios(cuatriadas: true) == mayor.arpegios(notas: 4))
        let laMenor = Tonalidad(.la, .menor)
        #expect(laMenor.acorde(grado: 5, cuatriada: true) == Acorde("Mi7"))
        #expect(laMenor.armonizar(cuatriadas: true) == laMenor.armonizar(notas: 4).compactMap { $0 })
    }

    @available(*, deprecated)
    @Test func losCifradosRomanosEnTexto() {
        let laMenor = Tonalidad(.la, .menor)
        #expect(laMenor.cifradoRomano(grado: 7, cuatriada: true) == "vii°7")
        #expect(laMenor.cifradosRomanos() == laMenor.romanos().map { $0?.description ?? "" })
        let armonica = Escala(.la, .menorArmonica)
        #expect(armonica.cifradoRomano(grado: 3) == "♭III+")
        #expect(armonica.cifradosRomanos(cuatriadas: true) == armonica.romanos(notas: 4).map { $0?.description })
    }

    @available(*, deprecated)
    @Test func laArmonizacionConTensionesEnUnaTupla() {
        let mayor = Escala(.do)
        let tupla = mayor.armonizacionConTensiones
        #expect(tupla.map(\.acorde) == mayor.gradosArmonizados.map(\.acorde))
        #expect(tupla.map(\.tensiones) == mayor.gradosArmonizados.map(\.tensiones))
    }
}
