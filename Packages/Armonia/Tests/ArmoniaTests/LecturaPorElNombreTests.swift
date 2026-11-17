import Armonia
import Foundation
import Testing

/// Los tipos que se leen por su nombre lo leen en cualquiera de los trece idiomas: `T(leyendo: x.texto(en: n)) == x`.
struct LecturaPorElNombreTests {
    private func idaYVuelta<T: RepresentableComoTexto & Equatable>(_ valores: [T]) {
        for valor in valores {
            for notacion in Notacion.allCases {
                let texto = valor.texto(en: notacion)
                #expect((try? T(leyendo: texto)) == valor, "\(texto) (\(notacion))")
            }
        }
    }

    @Test func papelesEnElAcorde() throws {
        idaYVuelta(
            [.fundamental, .tercera, .suspension, .quinta, .sexta, .septima, .tension(9), .tension(11)]
                as [PapelEnAcorde])
        #expect(try PapelEnAcorde(leyendo: "Terz") == .tercera)
    }

    @Test func nombresDeLosGrados() throws {
        idaYVuelta(
            [.tonica, .supertonica, .mediante, .subdominante, .dominante, .superdominante, .sensible, .subtonica]
                as [NombreDeGrado])
        #expect(try NombreDeGrado(leyendo: "tonique") == .tonica)
    }

    @Test func ciclosNeorriemannianos() throws {
        idaYVuelta(CicloNeorriemanniano.allCases)
        #expect(try CicloNeorriemanniano(leyendo: "ziklo hexatonikoa") == .hexatonico)
    }

    @Test func encordados() { idaYVuelta(Encordado.todos) }

    @Test func tiposDeEscala() throws {
        idaYVuelta(TipoDeEscala.catalogo)
        #expect(try TipoDeEscala(leyendo: "dorisch") == .dorico)
        let literal: TipoDeEscala = "Dorian"
        #expect(literal == .dorico)
    }

    @Test func seCodificanPorSuTexto() throws {
        let datos = try JSONEncoder().encode([NombreDeGrado.dominante])
        #expect(String(decoding: datos, as: UTF8.self) == #"["dominante"]"#)
        #expect(try JSONDecoder().decode([NombreDeGrado].self, from: datos) == [.dominante])
    }
}
