import Foundation
import Testing

@testable import Elementos

/// Las notaciones con los nombres de un sistema fijo de otra tradición: el bizantino, el japonés, los lü…
@Suite struct NotacionConSistemaTests {
    @Test func escribe() throws {
        let bizantino = try #require(Notacion.sistema(.bizantino))
        #expect(Nota("Fa#").nombre(en: bizantino) == "Ga♯")
        #expect(Nota("Do").nombre(en: bizantino) == "Ni")
        #expect(Nota("Sib").nombreCompacto(en: bizantino) == "Zo♭")
        #expect(NotaNatural.re.nombre(en: bizantino) == "Pa")
        #expect(Altura("La4").nombre(en: bizantino) == "Ke4")
        let original = try #require(Notacion.sistema(.bizantino, grafia: .original))
        #expect(Nota("Re").nombre(en: original) == "Πα")
        let ascii = try #require(Notacion.sistema(.bizantino, grafia: .ascii))
        #expect(Nota("Mib").nombre(en: ascii) == "Voub")
        let japones = try #require(Notacion.sistema(.japones, grafia: .original))
        #expect(Nota("Fa#").nombre(en: japones) == "嬰ヘ")
        let lu = try #require(Notacion.sistema(.luChinos, grafia: .original))
        #expect(Nota("Reb").nombre(en: lu) == "大吕")
        #expect(Nota("Do#").nombre(en: lu) == "大吕")
    }

    @Test func lee() throws {
        let bizantino = try #require(Notacion.sistema(.bizantino))
        #expect(try Nota(leyendo: "Γα♯", en: bizantino) == Nota("Fa#"))
        #expect(try Nota(leyendo: "vou b", en: bizantino) == Nota("Mib"))
        #expect(try Altura(leyendo: "Ke4", en: bizantino) == Altura("La4"))
        #expect(try Altura(leyendo: "Ga♯₃", en: bizantino) == Altura("Fa#3"))
        let japones = try #require(Notacion.sistema(.japones))
        #expect(try Altura(leyendo: "ei He 4", en: japones) == Altura("Fa#4"))
        #expect(throws: ErrorDeLectura.self) { try Nota(leyendo: "Fa", en: bizantino) }
        // Cada escritura lee lo que escribe.
        for notacion in Notacion.deOtrasTradiciones {
            let escritura = notacion.escritura
            for quintas in -7...7 {
                let nota = Nota(pasosDeQuinta: quintas)
                let leida = try Nota(leyendo: nota.nombre(en: notacion), en: notacion)
                // Los lü nombran la clase de altura: Re♭ se lee como Do♯.
                #expect(leida.claseDeAltura == nota.claseDeAltura, "\(escritura.sistema!) \(nota)")
                if escritura.sistema?.disposicionDeSiete == true { #expect(leida == nota) }
            }
        }
    }

    @Test func soloLosFijos() {
        #expect(Notacion.sistema(.sargam) == nil)
        #expect(Notacion.sistema(.jianpu) == nil)
        #expect(Notacion.deOtrasTradiciones.count == 9 * 3)
        #expect(!EscrituraDeNotas.allCases.contains { $0.sistema != nil })
    }

    @Test func textos() throws {
        let notacion = try #require(Notacion.sistema(.bizantino, textos: .euskera))
        #expect(notacion.textos == .euskera)
        #expect(notacion.esCombinada)
        #expect(notacion.sistemaDeNombres == .bizantino)
        #expect(notacion.notacionDeLasNotas.sistemaDeNombres == .bizantino)
        #expect(try #require(Notacion.sistema(.bizantino)).textos == .espanol)
        #expect(notacion.octavas == .cifras)
        #expect(Altura("La4").nombre(en: notacion.conOctavas(.subindices)) == "Ke₄")
    }

    @Test func codificacion() throws {
        for escritura in Notacion.deOtrasTradiciones.map(\.escritura) + EscrituraDeNotas.allCases {
            let datos = try JSONEncoder().encode(escritura)
            #expect(try JSONDecoder().decode(EscrituraDeNotas.self, from: datos) == escritura)
        }
        let movil = Data(#"{"sistema":"sargam","grafia":"ascii"}"#.utf8)
        #expect(throws: DecodingError.self) { try JSONDecoder().decode(EscrituraDeNotas.self, from: movil) }
    }
}

extension SistemaDeNombres {
    /// ¿Tiene siete nombres (y escribe las alteraciones), y no doce, como los lü?
    fileprivate var disposicionDeSiete: Bool {
        if case .siete = disposicion { return true }
        return false
    }
}
