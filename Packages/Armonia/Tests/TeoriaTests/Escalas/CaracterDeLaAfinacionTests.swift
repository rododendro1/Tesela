import Testing

@testable import Elementos
@testable import Teoria

/// Temperada, justa, microtonal o en otras partes iguales: lo que es la afinación de cada escala.
@Suite struct CaracterDeLaAfinacionTests {
    @Test func losEjemplos() {
        #expect(TipoDeEscala.bayati.caracterDeLaAfinacion == .microtonal)
        #expect(TipoDeEscala.kalyan.caracterDeLaAfinacion == .justa)
        #expect(TipoDeEscala.slendro.caracterDeLaAfinacion == .partesIguales(5))
        #expect(TipoDeEscala.mayor.caracterDeLaAfinacion == nil && !TipoDeEscala.mayor.esMicrotonal)
        #expect(TipoDeEscala.blues.caracterDeLaAfinacion == .microtonal)
        #expect(TipoDeEscala.bayati.esMicrotonal && !TipoDeEscala.kalyan.esMicrotonal)
    }

    /// Cada sistema da lo que se espera: los cuartos de tono y el koron, microtonales; los śruti, justos; las comas,
    /// microtonales; el pélog en nueve partes, el sléndro en cinco, el timbila en siete.
    @Test func cadaSistema() {
        let afinaciones = TipoDeEscala.catalogo.compactMap(\.microtonal)
        for afinacion in afinaciones where [.cuartosDeTono, .persa, .comas53].contains(afinacion.sistema) {
            #expect(afinacion.caracter == .microtonal, Comment(rawValue: afinacion.temperada.nombre))
        }
        #expect(afinaciones.filter { $0.sistema == .sruti }.allSatisfy { $0.caracter == .justa })
        let partes = Dictionary(
            afinaciones.compactMap { a -> (String, Int)? in
                if case .partesIguales(let n) = a.caracter { (a.temperada.nombre, n) } else { nil }
            }, uniquingKeysWith: { a, _ in a })
        #expect(partes["Pélog selisir"] == 9 && partes["Sléndro"] == 5 && partes["Timbila"] == 7)
        #expect(Set(partes.values) == [5, 7, 9])
    }

    /// Una justa no se aparta tanto como una microtonal, y una temperada casi nada.
    @Test func losUmbrales() {
        for afinacion in TipoDeEscala.catalogo.compactMap(\.microtonal) where afinacion.sistema != .comas53 {
            let desvio =
                (afinacion.desvios(sentido: .ascendente) + afinacion.desvios(sentido: .descendente))
                .map(abs).max() ?? 0
            switch afinacion.caracter {
            case .temperada: #expect(desvio <= 1)
            case .justa:
                #expect(desvio < CaracterDeLaAfinacion.umbralMicrotonal, Comment(rawValue: afinacion.temperada.nombre))
            case .microtonal: #expect(desvio >= CaracterDeLaAfinacion.umbralMicrotonal)
            case .partesIguales: break
            }
        }
    }
}
