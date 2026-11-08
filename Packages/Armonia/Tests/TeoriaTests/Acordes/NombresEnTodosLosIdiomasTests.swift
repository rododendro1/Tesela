import Testing

@testable import Elementos
@testable import Teoria

@Suite struct NombresEnTodosLosIdiomasTests {
    @Test func calidadesDeTriada() {
        let calidades: [CalidadDeTriada] = [
            .mayor, .menor, .disminuida, .aumentada, .suspendida, .potencia, .sinTercera,
        ]
        for idioma in Idioma.allCases {
            let nombres = calidades.map { $0.nombre(en: .conPalabras(idioma)) }
            #expect(nombres.allSatisfy { !$0.isEmpty })
            #expect(Set(nombres).count == calidades.count)
        }
        #expect(
            CalidadDeTriada.mayor.nombre(en: .conPalabras(.espanol))
                != CalidadDeTriada.menor.nombre(en: .conPalabras(.espanol)))
    }

    @Test func naturalesDeCadaSistema() {
        for sistema in SistemaDeNombres.allCases {
            for grafia in Grafia.allCases {
                let naturales = sistema.naturales(en: grafia)
                #expect(naturales.count == 7)
                #expect(naturales.allSatisfy { !$0.isEmpty })
            }
        }
    }

    @Test func gradoFueraDeLaEscala() {
        #expect(Tonalidad(.re).nombreDeGrado(99) == .tonica)
    }
}
