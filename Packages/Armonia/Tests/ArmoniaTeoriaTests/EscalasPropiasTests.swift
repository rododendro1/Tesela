import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// Las escalas propias, las vecinas y la escala en las doce tonalidades.
@Suite struct EscalasPropiasTests {
    @Test func porSusNotas() throws {
        let dorica = try #require(Escala.propia([.re, .mi, .fa, .sol, .la, .si, .do]))
        #expect(dorica.tipo == .dorico)
        #expect(dorica.tonica == .re)
        // Unas notas que no están en el catálogo: el nombre lleva su número de Forte y sus pasos.
        let rara = try #require(Escala.propia([.do, Nota(.re, .bemol), .re, .mi, .sol]))
        let forte = try #require(ConjuntoDeClases([0, 1, 2, 4, 7]).numeroDeForte)
        #expect(rara.tipo.nombre == forte + " (1-1-2-3-5)")
        #expect(rara.nombre(en: .inglesASCII).hasSuffix("(1-1-2-3-5)"))
        #expect(rara.numeroDeForte == forte)
        #expect(rara.pasosEnSemitonos == [1, 1, 2, 3, 5])
        #expect(Escala.propia([]) == nil)
        #expect(Escala(.do).pasosEnSemitonos == [2, 2, 1, 2, 2, 2, 1])
        #expect(Escala(.do).numeroDeForte == "7-35")
    }

    @Test func porSusPasos() throws {
        let pentatonica = try #require(Escala.propia(desde: .do, pasos: [2, 2, 3, 2, 3]))
        #expect(pentatonica.tipo == .pentatonicaMayor)
        // Sin el último paso, el que vuelve a la tónica, también vale.
        #expect(Escala.propia(desde: .do, pasos: [2, 2, 3, 2]) == pentatonica)
        let mayor = try #require(Escala.propia(desde: .re, pasos: [2, 2, 1, 2, 2, 2, 1]))
        #expect(mayor.notas.map(\.nombre) == ["Re", "Mi", "Fa♯", "Sol", "La", "Si", "Do♯"])
        #expect(Escala.propia(desde: .do, pasos: []) == nil)
        #expect(Escala.propia(desde: .do, pasos: [2, 0, 10]) == nil)
        #expect(Escala.propia(desde: .do, pasos: [6, 6, 6]) == nil)
    }

    @Test func seLeen() throws {
        #expect(try Escala(leyendo: "Re Mi Fa Sol La Si Do").tipo == .dorico)
        #expect(try Escala(leyendo: "Do 2-2-3-2-3").tipo == .pentatonicaMayor)
        #expect(try Escala(leyendo: "C 2-1-2-2-1-2-2").tipo == .menorNatural)
        #expect(Escala(texto: "Do 2-x-3") == nil)
        #expect(Escala(texto: "Do Re foo") == nil)
        #expect(Escala(texto: "foo 2-2-3") == nil)
        #expect(Escala.leerPropia("Do") == nil)
    }

    @Test func vecinas() {
        let vecinas = Escala(.do).vecinas()
        #expect(vecinas.contains { $0.escala == Escala(.do, .lidio) && $0.de == .fa && $0.a == Nota(.fa, .sostenido) })
        #expect(vecinas.contains { $0.escala == Escala(.do, .mixolidio) && $0.de == .si && $0.a == Nota(.si, .bemol) })
        #expect(vecinas.allSatisfy { $0.escala.notas.count == 7 })
        #expect(Set(vecinas.map(\.escala)).count == vecinas.count)
        // Al mover la tónica, la escala que sale tiene otra.
        #expect(vecinas.contains { $0.de == .do })
        #expect(Escala(.do, .cromatica).vecinas().isEmpty)
    }

    @Test func enLasDoceTonalidades() {
        let mayores = Escala(.do).enLasDoceTonalidades.map(\.tonica.nombre)
        #expect(mayores == ["Do", "Sol", "Re", "La", "Mi", "Si", "Fa♯", "Re♭", "La♭", "Mi♭", "Si♭", "Fa"])
        let menores = Escala(.la, .menorNatural).enLasDoceTonalidades
        #expect(menores.count == 12)
        #expect(menores.map(\.tonica.nombre).contains("Do♯"))
        #expect(!menores.map(\.tonica.nombre).contains("Re♭"))
        #expect(menores.allSatisfy { $0.tipo == .menorNatural })
    }
}
