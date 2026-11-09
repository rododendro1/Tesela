import Testing

@testable import Elementos
@testable import Teoria

/// Los esquemas armónicos: las progresiones del catálogo con reglas propias (jazz y blues, secuencias y esquemas
/// galantes) y las demás, por sus grados.
@Suite struct EsquemaArmonicoTests {
    private func tipos(_ acordes: [Acorde]) -> [ProgresionConNombre] {
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
        let menor = EsquemaArmonico.buscar(en: ["Siø7", "Mi7", "Lam"])
        #expect(menor.map(\.tipo) == [.iiVIMenor])
        #expect(menor.map(\.tonica) == [.la])
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
        let blues = ProgresionConNombre.blues.acordes(en: Tonalidad(.fa))
        let cifrados = ["Fa7", "Fa7", "Fa7", "Fa7", "Si♭7", "Si♭7", "Fa7", "Fa7", "Do7", "Si♭7", "Fa7", "Fa7"]
        #expect(blues.map(\.cifrado) == cifrados)
        #expect(EsquemaArmonico.buscar(en: blues).filter { $0.tipo == .blues }.map(\.tonica) == [.fa])
        // Con el IV en el segundo compás, el V en el décimo y el V en el último.
        var rapido = blues
        rapido[1] = Acorde("Sib7")
        rapido[9] = Acorde("Do7")
        rapido[11] = Acorde("Do7")
        #expect(EsquemaArmonico.esBlues(rapido))
        // Sin IV no es blues.
        #expect(!EsquemaArmonico.esBlues(Array(repeating: Acorde("Fa7"), count: 12)))
        #expect(!EsquemaArmonico.esBlues(Array(blues.prefix(11))))
        // Menor, con el ♭VI en el noveno compás.
        let menor = ProgresionConNombre.bluesMenor.acordes(sobre: .la)
        #expect(menor[8].cifrado == "Fa7")
        #expect(EsquemaArmonico.buscar(en: menor).filter { $0.indices == 0..<12 }.map(\.tipo) == [.bluesMenor])
        var conElV = menor
        conElV[8] = Acorde("Mi7")
        #expect(EsquemaArmonico.esBlues(conElV))
        rapido[8] = Acorde("Reb7")
        #expect(!EsquemaArmonico.esBlues(rapido))
    }

    // MARK: Secuencias

    @Test func quintasDescendentes() {
        let diatonica = ProgresionConNombre.quintasDescendentes.acordes(en: Tonalidad(.do))
        #expect(diatonica.map(\.cifrado) == ["Do", "Fa", "Si°", "Mim", "Lam", "Rem", "Sol", "Do"])
        let quintas = EsquemaArmonico.buscar(en: diatonica).filter { $0.tipo == .quintasDescendentes }
        #expect(quintas.map(\.indices) == [0..<8])
        // Tres acordes no bastan.
        #expect(!tipos(["Lam", "Rem", "Sol"]).contains(.quintasDescendentes))
    }

    @Test func romanescaYPachelbel() {
        let canon = ProgresionConNombre.pachelbel.acordes(en: Tonalidad(.re))
        #expect(canon.map(\.cifrado) == ["Re", "La", "Sim", "Fa♯m", "Sol", "Re", "Sol", "La"])
        let enElCanon = tipos(canon)
        #expect(enElCanon.contains(.pachelbel))
        #expect(!enElCanon.contains(.romanesca))
        #expect(tipos(["Do", "Sol", "Lam", "Mim"]) == [.romanesca])
    }

    @Test func monteFonteYPonte() {
        let monte = EsquemaArmonico.buscar(en: ProgresionConNombre.monte.acordes(en: Tonalidad(.do)))
        #expect(monte.map(\.tipo) == [.monte])
        #expect(monte[0].tonica == .do)
        let fonte = ProgresionConNombre.fonte.acordes(en: Tonalidad(.do))
        #expect(fonte.map(\.cifrado) == ["La7", "Rem", "Sol7", "Do"])
        #expect(tipos(fonte).contains(.fonte))
        #expect(EsquemaArmonico.buscar(en: fonte).first { $0.tipo == .fonte }?.tonica == .do)
        let ponte = EsquemaArmonico.buscar(en: ["Sol", "Sol7", "Do"])
        #expect(ponte.map(\.tipo) == [.ponte])
        #expect(ponte[0].indices == 0..<2)
        // Sin la séptima no es ponte.
        #expect(tipos(["Sol", "Sol", "Do"]) == [])
    }

    // MARK: Las demás del catálogo

    @Test func porSusGrados() {
        let andaluza = EsquemaArmonico.buscar(en: ["Lam", "Sol", "Fa", "Mi"])
        #expect(andaluza.map(\.tipo) == [.andaluza])
        #expect(andaluza[0].tonica == .la)
        #expect(andaluza[0].description == "cadencia andaluza (acordes 1 → 4)")
        #expect(tipos(["Do", "Sol", "Lam", "Fa"]) == [.ejePop])
        #expect(tipos(["Do", "Lam", "Fa", "Sol"]) == [.deLos50])
        let eolica = EsquemaArmonico.buscar(en: ["Lab", "Sib", "Do"])
        #expect(eolica.map(\.tipo) == [.eolica])
        #expect(eolica[0].tonica == .do)
        // Con séptimas o sin ellas, pero con la calidad de cada tríada y el bajo de las invertidas.
        #expect(tipos(["Lam7", "Sol7", "Famaj7", "Mi7"]) == [.andaluza])
        #expect(tipos(["Lam", "Solm", "Fa", "Mi"]) == [])
        #expect(tipos(["Do", "Sol/Si", "Do"]) == [.doReMi])
        #expect(tipos(["Do", "Sol", "Do"]) == [])
        // Las cadencias de dos acordes no son esquemas: las busca `Cadencia`.
        #expect(tipos(["Sol7", "Do"]) == [])
        // En el orden en que empiezan y, a igualdad, en el del catálogo.
        #expect(tipos(["Do", "Sol", "Lam", "Fa", "Do", "Sol", "Lam", "Mim"]) == [.ejePop, .romanesca])
    }

    /// Cada progresión del catálogo de tres acordes o más, y el ii–V, se reconoce a sí misma con cualquier tónica.
    @Test func cadaProgresionSeReconoce() {
        let buscadas = ProgresionConNombre.catalogo.filter { $0.grados.count >= 3 || $0 == .iiV }
        #expect(buscadas.count == 47)
        for progresion in buscadas {
            for tonica in [Nota.do, Nota.mi.bemol, Nota.la, Nota.fa.sostenido] {
                let acordes = progresion.acordes(sobre: tonica)
                // Desde el primer acorde; la ponte acaba antes de su resolución.
                let halladas = EsquemaArmonico.buscar(en: acordes).filter { $0.inicio == 0 }
                #expect(halladas.map(\.tipo).contains(progresion), "\(progresion) sobre \(tonica)")
            }
        }
    }

    /// Dos progresiones que se reconocen por sus grados no tienen los mismos grados: si no, saldrían siempre juntas.
    @Test func ningunPatronSeRepite() {
        let patrones = EsquemaArmonico.patrones.map { "\($0.fundamentales) \($0.calidades) \($0.bajos)" }
        #expect(Set(patrones).count == patrones.count)
        #expect(EsquemaArmonico.patrones.count == ProgresionConNombre.catalogo.count - 5 - 13)
    }

    @Test func enLosDoceIdiomas() {
        #expect(ProgresionConNombre.blues.nombre(en: .ascii(.ingles)) == "12-bar blues")
        let ii = EsquemaArmonico.buscar(en: ["Rem7", "Sol7", "Do7M"])[0]
        #expect(ii.descripcion(en: .ascii(.ingles)) == "ii–V–I (chords 1 → 3)")
        #expect(ii.descripcion(en: .compacta(.aleman)).hasPrefix("ii–V–I"))
    }
}
