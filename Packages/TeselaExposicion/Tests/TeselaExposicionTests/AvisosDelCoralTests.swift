import Armonia
import Testing

@testable import TeselaExposicion

// Los avisos del coral en todos los idiomas.

@Suite struct AvisosDelCoralTests {
    @Test func losAvisosTienenTextoEnCadaNotacion() {
        let avisos: [CoralPresentado.Aviso] = [
            .sinArmonizacion, .faltanOctavas, .sinCoralParaLaMelodia, .sinRealizacion,
            .sinFaltasDeConduccion,
        ]
        for notacion in Notacion.allCases {
            for aviso in avisos {
                #expect(!(aviso.texto(en: notacion).isEmpty), "\(aviso) en \(notacion)")
            }
        }
        // Y cada uno dice algo distinto.
        #expect(Set(avisos.map { $0.texto(en: .espanolCompacto) }).count == avisos.count)
        #expect(
            CoralPresentado.Aviso.sinRealizacion.texto(en: .espanolCompacto)
                != CoralPresentado.Aviso.sinRealizacion.texto(en: .inglesASCII))
    }
}
