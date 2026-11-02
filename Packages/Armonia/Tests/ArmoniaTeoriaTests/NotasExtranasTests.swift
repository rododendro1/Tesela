import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

@Suite struct NotasExtranasTests {
    private func extranas(_ melodia: [Altura], _ acordes: [Acorde]) -> [NotaExtrana?] {
        NotaDeLaMelodia.analizar(melodia, sobre: acordes)!.map(\.extrana)
    }

    // MARK: Cada tipo

    @Test func notaDePasoYBordadura() {
        #expect(extranas(["Do5", "Re5", "Mi5"], ["Do", "Do", "Do"]) == [nil, .notaDePaso, nil])
        #expect(extranas(["Mi5", "Re5", "Do5"], ["Do", "Do", "Do"]) == [nil, .notaDePaso, nil])
        #expect(extranas(["Do5", "Re5", "Do5"], ["Do", "Do", "Do"]) == [nil, .bordadura, nil])
        #expect(extranas(["Mi5", "Fa5", "Mi5"], ["Do", "Do", "Do"]) == [nil, .bordadura, nil])
        // De paso cromática y bordadura cromática.
        #expect(extranas(["Do5", "Do#5", "Re5"], ["Do", "Do", "Rem"]) == [nil, .notaDePaso, nil])
        #expect(extranas(["Sol4", "Fa#4", "Sol4"], ["Do", "Do", "Do"]) == [nil, .bordadura, nil])
        // La segunda aumentada de la menor armónica es grado conjunto.
        #expect(extranas(["Fa4", "Sol#4", "La4"], ["Rem", "Rem", "Rem"]) == [nil, .notaDePaso, nil])
    }

    @Test func apoyaturaYEscapada() {
        #expect(extranas(["Do5", "Fa5", "Mi5"], ["Do", "Do", "Do"]) == [nil, .apoyatura, nil])
        // Al empezar, sin nota antes: también apoyatura si resuelve por grado conjunto.
        #expect(extranas(["Re5", "Do5"], ["Do", "Do"]) == [.apoyatura, nil])
        #expect(extranas(["Re5", "Mi5", "Si4"], ["Sol", "Sol", "Sol"]) == [nil, .escapada, nil])
    }

    @Test func retardo() {
        let notas = NotaDeLaMelodia.analizar(
            ["Mi5", "Re5", "Do5", "Do5", "Si4", "Do5"], sobre: ["Do", "Do", "Fa", "Sol", "Sol", "Do"])!
        #expect(notas.map(\.extrana) == [nil, .notaDePaso, nil, .retardo, nil, nil])
        #expect(notas[3].cifrasDelRetardo == "4-3")
        #expect(notas.compactMap(\.cifrasDelRetardo) == ["4-3"])
        // 7-6 sobre Sol/Si y 9-8 sobre Do.
        #expect(
            NotaDeLaMelodia.analizar(["La4", "La4", "Sol4"], sobre: ["Fa", "Sol/Si", "Sol/Si"])![1].cifrasDelRetardo
                == "7-6")
        #expect(
            NotaDeLaMelodia.analizar(["Re5", "Re5", "Do5"], sobre: ["Sol", "Do", "Do"])![1].cifrasDelRetardo == "9-8")
        // Sube en vez de bajar: también retardo.
        #expect(extranas(["Si4", "Si4", "Do5"], ["Sol", "Do", "Do"]) == [nil, .retardo, nil])
        // Se mantiene y no resuelve por grado conjunto.
        #expect(extranas(["Si4", "Si4", "Mi5"], ["Sol", "Do", "Do"]) == [nil, .libre, nil])
    }

    @Test func anticipacionYPedal() {
        #expect(extranas(["Re5", "Do5", "Do5"], ["Sol", "Sol", "Do"]) == [nil, .anticipacion, nil])
        #expect(extranas(["Sol4", "Sol4", "Sol4"], ["Do", "Fa/Do", "Do"]) == [nil, .pedal, nil])
        // Varias seguidas: todas pedal mientras sigue extraña.
        #expect(
            extranas(["Do5", "Do5", "Do5", "Do5"], ["Do", "Sol/Re", "Sol7/Re", "Do"]) == [nil, .pedal, .pedal, nil])
    }

    @Test func libre() {
        #expect(extranas(["Do5", "La5", "Mi5"], ["Do", "Do", "Do"]) == [nil, .libre, nil])
        // Al acabar, sin resolver.
        #expect(extranas(["Do5", "Re5"], ["Do", "Do"]) == [nil, .libre])
    }

    // MARK: Entrada y presentación

    @Test func notasEnarmonicasYBajo() {
        // La♭ en Mi7 vale por Sol♯; el bajo ajeno al acorde cuenta como del acorde.
        #expect(extranas(["Lab4"], ["Mi7"]) == [nil])
        #expect(extranas(["Re4"], ["Do/Re"]) == [nil])
    }

    @Test func partesFuertes() {
        let notas = NotaDeLaMelodia.analizar(
            ["Re5", "Do5", "Si4", "Do5"], sobre: ["Do", "Do", "Sol", "Do"], partesFuertes: [true, false, true, false])!
        // La apoyatura en parte fuerte queda acentuada.
        #expect(notas[0].extrana == .apoyatura)
        #expect(notas.map(\.acentuada) == [true, false, true, false])
        #expect(NotaDeLaMelodia.analizar(["Do5"], sobre: ["Do"])![0].acentuada == nil)
    }

    @Test func longitudesDistintas() {
        #expect(NotaDeLaMelodia.analizar(["Do5", "Re5"], sobre: ["Do"]) == nil)
        #expect(NotaDeLaMelodia.analizar(["Do5"], sobre: ["Do"], partesFuertes: [true, false]) == nil)
        #expect(NotaDeLaMelodia.analizar([], sobre: []) == [])
    }

    @Test func soloLasExtranas() {
        let melodia: [Altura] = ["Do5", "Re5", "Mi5", "Fa5", "Mi5"]
        let notas = NotaDeLaMelodia.analizar(melodia, sobre: Array(repeating: "Do", count: 5))!
        #expect(notas.notasExtranas.map(\.indice) == [1, 3])
        #expect(notas.notasExtranas.map(\.nota.extrana) == [.notaDePaso, .bordadura])
    }

    @Test func nombresYTexto() {
        #expect(NotaExtrana.notaDePaso.nombre == "nota de paso")
        #expect(NotaExtrana.retardo.nombre(en: .inglesASCII) == "suspension")
        let notas = NotaDeLaMelodia.analizar(["Do5", "Re5", "Mi5"], sobre: ["Do", "Do", "Do"])!
        #expect(notas.map(\.description) == ["Do5", "Re5 (nota de paso)", "Mi5"])
        let retardo = NotaDeLaMelodia.analizar(["Do5", "Do5", "Si4"], sobre: ["Fa", "Sol", "Sol"])![1]
        #expect(retardo.description == "Do5 (retardo 4-3)")
        #expect(retardo.texto(en: .inglesASCII).hasSuffix("(suspension 4-3)"))
    }

    @Test func enLosQuinceIdiomas() {
        for idioma in Idioma.allCases {
            let nombres = NotaExtrana.allCases.map { $0.nombre(en: Notacion.delIdioma(idioma)) }
            let comentario = Comment(rawValue: nombres.joined(separator: ", "))
            #expect(Set(nombres).count == NotaExtrana.allCases.count, comentario)
            #expect(!nombres.contains(""))
        }
    }
}
