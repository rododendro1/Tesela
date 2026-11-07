import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// La cadena de sesenta quintas de Jing Fang y su relación con las 53 comas.
@Suite struct JingFangTests {
    @Test func laCadena() {
        #expect(JingFang.cadena.count == 60)
        #expect(abs(JingFang.cents(deLaQuinta: 1) - 701.955) < 0.001)
        // La duodécima no vuelve: la coma pitagórica.
        #expect(abs(JingFang.cents(deLaQuinta: 12) - 23.460) < 0.001)
        // La 53 casi vuelve: la coma de Mercator.
        #expect(abs(JingFang.comaDeMercator - 3.615) < 0.001)
        #expect(JingFang.cadena.allSatisfy { $0 >= 0 && $0 < 1200 })
    }

    @Test func lasCincuentaYTresComas() {
        #expect(JingFang.pasoEnLas53Comas(deLaQuinta: 1) == 31)
        #expect(JingFang.pasoEnLas53Comas(deLaQuinta: 12) == 1)
        #expect(JingFang.pasoEnLas53Comas(deLaQuinta: 53) == 0)
        // Las 53 primeras caen cada una en una coma distinta, a menos de 4 cents.
        #expect(Set((0..<53).map { JingFang.pasoEnLas53Comas(deLaQuinta: $0) }).count == 53)
        #expect((0..<53).allSatisfy { abs(JingFang.desvioDeLas53Comas(deLaQuinta: $0)) < 4 })
    }

    @Test func nombres() {
        #expect(JingFang.nombre(deLaQuinta: 0, grafia: .original) == "黄钟")
        #expect(JingFang.nombre(deLaQuinta: 11) == "zhònglǚ")
        #expect(JingFang.nombre(deLaQuinta: 12, grafia: .original) == "执始")
        #expect(JingFang.nombre(deLaQuinta: 59) == "nánshì")
        #expect(JingFang.nombre(deLaQuinta: 30) == nil)
    }
}
