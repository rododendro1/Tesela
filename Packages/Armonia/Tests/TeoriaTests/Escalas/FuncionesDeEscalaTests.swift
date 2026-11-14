import Elementos
import Testing

@testable import Teoria

/// Las notas con función de cada escala: el vādī y el saṃvādī de los rāgas, el qarār y el ghammāz de los maqāmāt.
struct FuncionesDeEscalaTests {
    @Test func elVadiYElSamvadiDeLosRagas() {
        #expect(TipoDeEscala.yaman.intervalo(de: .vadi) == .terceraMayor)
        #expect(TipoDeEscala.yaman.intervalo(de: .samvadi) == .septimaMayor)
        #expect(TipoDeEscala.yaman.funciones(de: .terceraMayor) == [.vadi])
        #expect(TipoDeEscala.bhairav.intervalo(de: .vadi) == .sextaMenor)
        #expect(TipoDeEscala.mohanam.funciones.isEmpty && TipoDeEscala.mayor.funciones.isEmpty)
        let conVadi = TipoDeEscala.catalogo.filter { $0.intervalo(de: .vadi) != nil }
        #expect(conVadi.count == 29)
        // Casi siempre a una cuarta o una quinta; en Mārvā, Pūriyā Dhanāśrī, Śrī y Rāgeśrī, no.
        let lejanos: Set<String> = ["Mārvā", "Pūriyā Dhanāśrī", "Śrī", "Rāgeśrī"]
        for raga in conVadi {
            let vadi = raga.intervalo(de: .vadi)!.semitonos
            let samvadi = raga.intervalo(de: .samvadi)!.semitonos
            let distancia = ((samvadi - vadi) % 12 + 12) % 12
            #expect([5, 7].contains(distancia) != lejanos.contains(raga.nombre), Comment(rawValue: raga.nombre))
        }
    }

    @Test func elGhammazSaleDeLosAjnas() {
        #expect(TipoDeEscala.bayati.intervalo(de: .ghammaz) == .cuartaJusta)
        #expect(TipoDeEscala.bayati.intervalo(de: .qarar) == .unisono)
        #expect(TipoDeEscala.maqamRast.intervalo(de: .ghammaz) == .quintaJusta)
        #expect(TipoDeEscala.huzam.intervalo(de: .ghammaz) == TipoDeEscala.huzam.intervalos[2])
        #expect(TipoDeEscala.rastMakami.intervalo(de: .ghammaz) == .quintaJusta)
        #expect(TipoDeEscala.bayati.funciones.allSatisfy { $0.referencia == .maqamWorld })
        // Sin un segundo jins no hay ghammāz.
        #expect(TipoDeEscala.husayni.funciones.isEmpty)
    }

    /// Toda nota con función es de la escala, al subir o al bajar, o una de sus notas externas.
    @Test func sonNotasDeLaEscala() {
        for tipo in TipoDeEscala.catalogo where !tipo.funciones.isEmpty {
            let suyas = Set((tipo.intervalosEnAmbasDirecciones + tipo.notasExternas).map(\.semitonos))
            for nota in tipo.funciones {
                #expect(suyas.contains(nota.intervalo.semitonos), "\(tipo.nombre): \(nota.funcion.nombre)")
            }
        }
    }
}
