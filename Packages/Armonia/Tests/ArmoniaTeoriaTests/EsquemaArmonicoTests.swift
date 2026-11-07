import Testing

@testable import ArmoniaElementos
@testable import ArmoniaTeoria

/// Los esquemas armónicos: jazz (ii–V–I, turnaround, backdoor, blues) y secuencias (quintas, romanesca, canon de
/// Pachelbel, monte, fonte y ponte).
@Suite struct EsquemaArmonicoTests {
    private func tipos(_ acordes: [Acorde]) -> [EsquemaArmonico.Tipo] {
        EsquemaArmonico.buscar(en: acordes).map(\.tipo)
    }

    // MARK: Jazz

    @Test func iiVI() {
        let esquemas = EsquemaArmonico.buscar(en: ["Rem7", "Sol7", "Do7M"])
        #expect(esquemas.map(\.tipo) == [.iiVI])
        #expect(esquemas[0].tonica == .do)
        #expect(esquemas[0].indices == 0..<3)
        #expect(esquemas[0].description == "ii–V–I (acordes 1 → 3)")
        // En menor, con el iiø7; y secundario, hacia el ii.
        #expect(EsquemaArmonico.buscar(en: ["Siø7", "Mi7", "Lam"]).map(\.tonica) == [.la])
        #expect(EsquemaArmonico.buscar(en: ["Mim7", "La7", "Rem7"]).map(\.tonica) == [.re])
        // Sin resolver, un ii–V.
        let iiV = EsquemaArmonico.buscar(en: ["Rem7", "Sol7", "Mim7"])
        #expect(iiV.map(\.tipo) == [.iiV])
        #expect(iiV[0].tonica == .do)
        #expect(tipos(["Rem7", "Sol7"]) == [.iiV])
    }

    @Test func turnaroundYBackdoor() {
        #expect(tipos(["Do7M", "Lam7", "Rem7", "Sol7", "Do7M"]) == [.turnaround, .quintasDescendentes, .iiVI])
        let desdeElIII = EsquemaArmonico.buscar(en: ["Mim7", "Lam7", "Rem7", "Sol7"])
        #expect(desdeElIII.first { $0.tipo == .turnaround }?.tonica == .do)
        let backdoor = EsquemaArmonico.buscar(en: ["Fam7", "Sib7", "Do7M"])
        #expect(backdoor.map(\.tipo) == [.backdoor])
        #expect(backdoor[0].tonica == .do)
    }

    @Test func blues() {
        let blues = EsquemaArmonico.Tipo.blues.acordes(en: Tonalidad(.fa))
        let cifrados = ["Fa7", "Fa7", "Fa7", "Fa7", "Si♭7", "Si♭7", "Fa7", "Fa7", "Do7", "Si♭7", "Fa7", "Do7"]
        #expect(blues.map(\.cifrado) == cifrados)
        #expect(EsquemaArmonico.buscar(en: blues).filter { $0.tipo == .blues }.map(\.tonica) == [.fa])
        // Con el IV en el segundo compás y el V en el décimo.
        var rapido = blues
        rapido[1] = Acorde("Sib7")
        rapido[9] = Acorde("Do7")
        #expect(EsquemaArmonico.esBlues(rapido))
        // Sin IV no es blues.
        #expect(!EsquemaArmonico.esBlues(Array(repeating: Acorde("Fa7"), count: 12)))
        #expect(!EsquemaArmonico.esBlues(Array(blues.prefix(11))))
        // Menor.
        #expect(EsquemaArmonico.esBlues(EsquemaArmonico.Tipo.blues.acordes(en: Tonalidad(.la, .menor))))
    }

    // MARK: Secuencias

    @Test func quintasDescendentes() {
        let diatonica = EsquemaArmonico.Tipo.quintasDescendentes.acordes(en: Tonalidad(.do))
        #expect(diatonica.map(\.cifrado) == ["Do", "Fa", "Si°", "Mim", "Lam", "Rem", "Sol", "Do"])
        let quintas = EsquemaArmonico.buscar(en: diatonica).filter { $0.tipo == .quintasDescendentes }
        #expect(quintas.map(\.indices) == [0..<8])
        // Tres acordes no bastan.
        #expect(!tipos(["Lam", "Rem", "Sol"]).contains(.quintasDescendentes))
    }

    @Test func romanescaYPachelbel() {
        let canon = EsquemaArmonico.Tipo.pachelbel.acordes(en: Tonalidad(.re))
        #expect(canon.map(\.cifrado) == ["Re", "La", "Sim", "Fa♯m", "Sol", "Re", "Sol", "La"])
        let enElCanon = tipos(canon)
        #expect(enElCanon.contains(.pachelbel))
        #expect(!enElCanon.contains(.romanesca))
        #expect(tipos(["Do", "Sol", "Lam", "Mim"]) == [.romanesca])
    }

    @Test func monteFonteYPonte() {
        let monte = EsquemaArmonico.buscar(en: EsquemaArmonico.Tipo.monte.acordes(en: Tonalidad(.do)))
        #expect(monte.map(\.tipo) == [.monte])
        #expect(monte[0].tonica == .do)
        let fonte = EsquemaArmonico.Tipo.fonte.acordes(en: Tonalidad(.do))
        #expect(fonte.map(\.cifrado) == ["La7", "Rem", "Sol7", "Do"])
        #expect(tipos(fonte).contains(.fonte))
        #expect(EsquemaArmonico.buscar(en: fonte).first { $0.tipo == .fonte }?.tonica == .do)
        let ponte = EsquemaArmonico.buscar(en: ["Sol", "Sol7", "Do"])
        #expect(ponte.map(\.tipo) == [.ponte])
        #expect(ponte[0].indices == 0..<2)
        // Sin la séptima no es ponte.
        #expect(tipos(["Sol", "Sol", "Do"]) == [])
    }

    @Test func generacion() {
        #expect(EsquemaArmonico.Tipo.iiVI.acordes(en: Tonalidad(.do)).map(\.cifrado) == ["Rem7", "Sol7", "Domaj7"])
        #expect(EsquemaArmonico.Tipo.iiVI.acordes(en: Tonalidad(.la, .menor)).map(\.cifrado).first == "Sim7(♭5)")
        #expect(
            EsquemaArmonico.Tipo.backdoor.acordes(en: Tonalidad(.do)).map(\.cifrado) == ["Fam7", "Si♭7", "Domaj7"])
        // Cada esquema generado se reconoce a sí mismo.
        for tipo in EsquemaArmonico.Tipo.allCases {
            for tonalidad in [Tonalidad(.do), Tonalidad(Nota.mi.bemol), Tonalidad(.la, .menor)] {
                let acordes = tipo.acordes(en: tonalidad)
                #expect(tipos(acordes).contains(tipo), "\(tipo) en \(tonalidad)")
            }
        }
    }

    @Test func enLosQuinceIdiomas() {
        for idioma in Idioma.allCases {
            let nombres = EsquemaArmonico.Tipo.allCases.map { $0.nombre(en: Notacion.delIdioma(idioma)) }
            #expect(Set(nombres).count == nombres.count, Comment(rawValue: nombres.joined(separator: ", ")))
        }
        #expect(EsquemaArmonico.Tipo.blues.nombre(en: .inglesASCII) == "12-bar blues")
        let ii = EsquemaArmonico.buscar(en: ["Rem7", "Sol7", "Do7M"])[0]
        #expect(ii.descripcion(en: .inglesASCII) == "ii–V–I (chords 1 → 3)")
    }
}
