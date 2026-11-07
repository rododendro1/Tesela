import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Los diao: los modos chinos con el lü de su tónica (黄钟宫, 林钟商), en las dos lecturas, 为调 y 之调.
@Suite struct DiaoTests {
    @Test func seLeen() throws {
        #expect(Escala(diao: "黄钟宫") == Escala(.do, .gong))
        #expect(Escala(diao: "林钟商") == Escala(.sol, .shang))
        #expect(Escala(diao: "林鐘商") == Escala(.sol, .shang))
        #expect(Escala(diao: "línzhōng shāng") == Escala(.sol, .shang))
        #expect(Escala(diao: "linzhong shang") == Escala(.sol, .shang))
        #expect(Escala(diao: "taicu yu") == Escala(.re, .yu))
        #expect(Escala(diao: "黄钟清乐") == Escala(.do, .qingyue))
        // Huángzhōng zhǐ: el modo zhǐ, no la partícula.
        #expect(Escala(diao: "huangzhong zhi") == Escala(.do, .zhi))
        #expect(try Escala(leyendo: "林钟商") == Escala(.sol, .shang))
        #expect(Escala(diao: "黄钟") == nil)
        #expect(Escala(diao: "黄钟 dórico") == nil)
        #expect(Escala(diao: "Do gōng") == nil)
    }

    @Test func lasDosLecturas() {
        // 之调: el lü es gōng. 林钟之商: gōng en Sol, shāng en La.
        #expect(Escala(diao: "林钟之商") == Escala(.la, .shang))
        #expect(Escala(diao: "linzhong zhi shang") == Escala(.la, .shang))
        #expect(Escala(diao: "黄钟之羽") == Escala(.la, .yu))
        // 为调: el lü es la tónica, como sin partícula.
        #expect(Escala(diao: "林钟为商") == Escala(.sol, .shang))
        #expect(Escala(diao: "林鐘為商") == Escala(.sol, .shang))
        // En gōng coinciden.
        #expect(Escala(diao: "太簇之宫") == Escala(diao: "太簇宫"))
        #expect(Escala(lu: Nota(.sol), modo: .zhi, lectura: .zhi) == Escala(.re, .zhi))
        // Dàlǚ es Do♯, en la cadena de quintas de los lü.
        #expect(Escala(diao: "大吕之商") == Escala(Nota(.re, .sostenido), .shang))
    }

    @Test func losSesenta() {
        let diao = Escala.sesentaDiao()
        #expect(diao.count == 60)
        #expect(Set(diao.map(\.nombre)).count == 60)
        #expect(diao[0].nombre == "huángzhōng gōng")
        #expect(diao[0].escala == Escala(.do, .gong))
        #expect(diao[6].escala == Escala(Nota(.do, .sostenido), .shang))
        #expect(Escala.sesentaDiao(grafia: .original)[35].nombre == "林钟宫")
        for (nombre, escala) in Escala.sesentaDiao(grafia: .original) {
            #expect(Escala(diao: nombre) == escala, Comment(rawValue: nombre))
        }
    }

    @Test func nombreDeDiao() {
        #expect(Escala(.sol, .shang).nombreDeDiao(grafia: .original) == "林钟商")
        #expect(Escala(.sol, .shang).nombreDeDiao() == "línzhōng shāng")
        #expect(Escala(.sol, .shang).nombreDeDiao(grafia: .ascii) == "linzhong shang")
        #expect(Escala(.re, .dorico).nombreDeDiao() == nil)
        // Re♭ y Do♯ son los dos dàlǚ.
        #expect(Escala(Nota(.re, .bemol), .gong).nombreDeDiao(grafia: .original) == "大吕宫")
    }
}
