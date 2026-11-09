import Testing

@testable import Elementos
@testable import Teoria

/// Los doce cakra de los mēḷa.
@Suite struct CakraDeMelaTests {
    @Test func cadaCakraTieneSeisMelas() {
        #expect(CakraDeMela.allCases.count == 12)
        #expect(CakraDeMela(mela: 1) == .indu)
        #expect(CakraDeMela(mela: 15) == .agni)
        #expect(CakraDeMela(mela: 29) == .bana)
        #expect(CakraDeMela(mela: 72) == .aditya)
        #expect(CakraDeMela(mela: 0) == nil && CakraDeMela(mela: 73) == nil)
        #expect(CakraDeMela.rtu.melas == 31...36)
        #expect(CakraDeMela.allCases.flatMap { Array($0.melas) } == Array(1...72))
        #expect(CakraDeMela.rsi.nombre == "Ṛṣi" && CakraDeMela.bana.nombreEnDevanagari == "बाण")
        #expect(CakraDeMela.indu < .aditya)
    }

    /// En un cakra se quedan Ri, Ga y Ma, y cambian Dha y Ni.
    @Test func losMelasDeUnCakraCompartenElTetracordoBajo() throws {
        for cakra in CakraDeMela.allCases {
            let bajos = try cakra.melas.map { try #require(TipoDeEscala.melakarta($0)).intervalos.prefix(4) }
            #expect(Set(bajos.map(Array.init)).count == 1, "\(cakra.nombre)")
            #expect(TipoDeEscala.melakarta(cakra.melas.lowerBound)?.cakra == cakra)
        }
        #expect(TipoDeEscala.mayor.cakra == .bana)
        #expect(TipoDeEscala.pentatonicaMayor.cakra == nil)
    }

    @Test func mnemonicosYSolfa() {
        #expect(CakraDeMela.silabas == ["pa", "śrī", "go", "bhū", "mā", "ṣa"])
        #expect(TipoDeEscala.melakarta(15)?.mnemonicoDeMela == "Agni-go")
        #expect(TipoDeEscala.mayor.mnemonicoDeMela == "Bāṇa-mā")
        #expect(TipoDeEscala.melakarta(1)?.mnemonicoDeMela == "Indu-pa")
        #expect(TipoDeEscala.melakarta(72)?.mnemonicoDeMela == "Āditya-ṣa")
        #expect(TipoDeEscala.melakarta(15)?.solfaDeMela == ["sa", "ra", "gu", "ma", "pa", "dha", "nu"])
        #expect(TipoDeEscala.mayor.solfaDeMela?.joined(separator: " ") == "sa ri gu ma pa dhi nu")
        #expect(TipoDeEscala.melakarta(65)?.solfaDeMela == ["sa", "ri", "gu", "mi", "pa", "dhi", "nu"])
        #expect(
            TipoDeEscala.pentatonicaMayor.mnemonicoDeMela == nil && TipoDeEscala.pentatonicaMayor.solfaDeMela == nil)
        // Los 72 dan siete sílabas distintas, y la misma sílaba de lugar da el mismo Dha y Ni en todos los cakra.
        for numero in 1...72 {
            let mela = TipoDeEscala.melakarta(numero)
            #expect(mela?.solfaDeMela?.count == 7, "\(numero)")
            let arriba = mela?.solfaDeMela?.suffix(2)
            #expect(arriba == TipoDeEscala.melakarta((numero - 1) % 6 + 1)?.solfaDeMela?.suffix(2))
        }
    }
}
