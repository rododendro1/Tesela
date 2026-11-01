import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

@Suite struct TonnetzTests {
    private func punto(_ a: Int, _ b: Int) -> PuntoDeLaRed { PuntoDeLaRed(quintas: a, terceras: b) }

    @Test func puntos() {
        #expect(punto(0, 1).nota == .mi)
        #expect(punto(4, 0).nota == .mi) // el mismo nombre, otro punto
        #expect(punto(2, 1).nota == Nota(.fa, .sostenido))
        #expect(punto(1, -1).nota == Nota(.mi, .bemol))
        #expect(punto(0, 1).claseDeAltura == 4)
        #expect(punto(3, 0).claseDeAltura == 9)
        #expect(punto(4, -1).claseDeAltura == 0) // un ciclo del toro de doce notas
        #expect(Set(punto(0, 0).vecinos.map(\.nota)) == [.sol, .fa, .mi, Nota(.la, .bemol), Nota(.mi, .bemol), .la])
        #expect(punto(0, 0).distancia(hasta: punto(1, -1)) == 1) // tercera menor
        #expect(punto(0, 0).distancia(hasta: punto(1, 1)) == 2)
        #expect(punto(0, 0).distancia(hasta: punto(3, -2)) == 3)
        #expect(punto(0, 0).distancia(hasta: punto(-2, -1)) == 3)
    }

    @Test func acordes() {
        let mayor = Tonnetz(Acorde("Do"))
        #expect(mayor.puntos == [punto(0, 0), punto(0, 1), punto(1, 0)])
        #expect(mayor.triadas.map(\.acorde) == [Acorde("Do")])
        #expect(mayor.triadas[0].mayor)
        #expect(mayor.aristas.map(\.eje).sorted { "\($0)" < "\($1)" } == [.quintaJusta, .terceraMayor, .terceraMenor])
        let menor = Tonnetz(Acorde("Lam"))
        #expect(menor.triadas.map(\.acorde) == [Acorde("Lam")])
        #expect(!(menor.triadas[0].mayor))
        // Una séptima mayor son dos triángulos: Do y Mim.
        #expect(Tonnetz(Acorde("Domaj7")).triadas.map(\.acorde) == [Acorde("Do"), Acorde("Mim")])
        #expect(Tonnetz(Acorde("Sol7")).triadas.map(\.acorde) == [Acorde("Sol")])
        #expect(Tonnetz(Acorde("Sol7")).esConexo)
        // La ortografía se conserva: un acorde de Sol♭ y otro de Fa♯ no comparten puntos.
        #expect(Tonnetz(Acorde("Solb")).triadas.map(\.acorde) == [Acorde("Solb")])
        #expect(Set(Tonnetz(Acorde("Solb")).puntos).isDisjoint(with: Tonnetz(Acorde("Fa#")).puntos))
    }

    @Test func escalas() {
        let diatonica = Tonnetz(Escala(.do))
        #expect(diatonica.esConexo)
        #expect(diatonica.notas == Escala(.do).notas)
        // Las seis tríadas de la escala menos la disminuida.
        #expect(Set(diatonica.triadas.map(\.acorde)) == ["Do", "Rem", "Mim", "Fa", "Lam"])
        let todas = Set(diatonica.triadas.map(\.acorde)).union(Tonnetz([.sol, .si, .re]).triadas.map(\.acorde))
        #expect(todas.count == 6)
        // Tonos enteros: sin quintas ni terceras menores, solo dos líneas de terceras mayores.
        let tonos = Tonnetz(Escala(.do, .tonosEnteros))
        #expect(!tonos.esConexo)
        #expect(tonos.triadas.isEmpty)
        #expect(Set(tonos.aristas.map(\.eje)) == [.terceraMayor])
        // La aumentada encadena tríadas mayores y menores alternas.
        #expect(Tonnetz(Escala(.do, .aumentada)).triadas.count == 4)
        // Con las notas repetidas, cada una una vez.
        #expect(Tonnetz([.do, .mi, .do, .sol]).puntos.count == 3)
        #expect(Tonnetz([]).puntos.isEmpty)
    }

    /// La colocación es la más compacta: nunca peor que la voraz, y mejor en muchas escalas.
    @Test func colocacionOptima() {
        func suma(_ p: [PuntoDeLaRed]) -> Int {
            p.indices.reduce(0) { s, i in
                s + p.indices.filter { $0 > i }.reduce(0) { $0 + p[i].distancia(hasta: p[$1]) }
            }
        }
        let candidatos: (Int, ClosedRange<Int>) -> [PuntoDeLaRed] = { pasos, filas in
            filas.map { PuntoDeLaRed(quintas: pasos - 4 * $0, terceras: $0) }
        }
        var mejoras = 0
        for tipo in TipoDeEscala.todos {
            let tonnetz = Tonnetz(Escala(.do, tipo))
            let voraz = Tonnetz.colocarVoraz(tonnetz.notas.map(\.pasosDeQuinta), candidatos: candidatos)
            let optima = (Tonnetz.grupos(tonnetz.puntos), suma(tonnetz.puntos))
            #expect(optima.0 <= Tonnetz.grupos(voraz), Comment(rawValue: tipo.nombre))
            if optima.0 == Tonnetz.grupos(voraz) { #expect(optima.1 <= suma(voraz), Comment(rawValue: tipo.nombre)) }
            if optima < (Tonnetz.grupos(voraz), suma(voraz)) { mejoras += 1 }
            #expect(
                tonnetz.notas
                    == Escala(.do, tipo).notas.reduce(into: [Nota]()) { if !$0.contains($1) { $0.append($1) } })
        }
        #expect(mejoras >= 20)
        // La egipcia (Do Re Fa Sol Si♭) es una franja de quintas con dos terceras: suma 15, no 17.
        #expect(suma(Tonnetz(Escala(.do, .egipcia)).puntos) == 15)
        // La menor melódica, compacta y conexa.
        let melodica = Tonnetz(Escala(.do, .menorMelodica))
        #expect(melodica.esConexo)
        #expect(suma(melodica.puntos) == 36)
    }

    @Test func clasesDeAltura() {
        let triada = Tonnetz(ConjuntoDeClases([0, 4, 7]))
        #expect(!triada.tieneOrtografia)
        #expect(triada.puntos.map(\.claseDeAltura) == [0, 4, 7])
        #expect(triada.triadas.count == 1)
        // Sin ortografía, el acorde de séptima disminuida es una línea de terceras menores.
        let disminuido = Tonnetz(ConjuntoDeClases([0, 3, 6, 9]))
        #expect(disminuido.esConexo)
        #expect(Set(disminuido.aristas.map(\.eje)) == [.terceraMenor])
        // Toda tríada mayor o menor, transportada, sigue siendo un triángulo.
        for n in 0..<12 {
            #expect(Tonnetz(ConjuntoDeClases([0, 4, 7]).transponer(n)).triadas.count == 1, "\(n)")
            #expect(Tonnetz(ConjuntoDeClases([0, 3, 7]).transponer(n)).triadas.count == 1, "\(n)")
        }
        #expect("\(triada)" == "0 (0, 0) · 4 (0, 1) · 7 (1, 0)")
        #expect("\(Tonnetz(Acorde("Do")))" == "Do (0, 0) · Mi (0, 1) · Sol (1, 0)")
    }

    /// Cualquier conjunto de notas se coloca conexo si sus notas, sin ortografía, lo permiten:
    /// toda tríada consonante al azar sale como un triángulo.
    @Test func triadasAlAzar() {
        var azar = GeneradorConSemilla(semilla: 2026)
        for _ in 0..<200 {
            let fundamental = Nota(pasosDeQuinta: Int.random(in: -10...10, using: &azar))
            let acorde = Acorde(fundamental, Bool.random(using: &azar) ? .mayor : .menor)
            let tonnetz = Tonnetz(acorde)
            #expect(tonnetz.triadas.map(\.acorde) == [acorde], Comment(rawValue: acorde.cifrado))
            #expect(tonnetz.notas == acorde.notas)
        }
    }

    @Test func sVG() throws {
        for tonnetz in [Tonnetz(Escala(.re, .dorico)), Tonnetz(ConjuntoDeClases([0, 4, 7, 11])), Tonnetz([])] {
            let svg = tonnetz.svg()
            let raiz = try #require(ElementoXML.leer(svg))
            #expect(raiz.nombre == "svg")
            #expect(!(raiz.todos("circle").isEmpty))
        }
        let raiz = try #require(ElementoXML.leer(Tonnetz(Acorde("Do")).svg(margen: 1)))
        // Las tres notas marcadas, con sus nombres, y un triángulo.
        let marcadas = raiz.todos("text").filter { $0.atributos["font-weight"] == "bold" }.map(\.texto)
        #expect(Set(marcadas) == ["Do", "Mi", "Sol"])
        #expect(raiz.todos("polygon").count == 1)
        #expect(raiz.todos("line").filter { $0.atributos["stroke-width"] == "3" }.count == 3)
        // En inglés, y con clases de altura, todas las repeticiones de cada clase.
        let ingles = try #require(ElementoXML.leer(Tonnetz(Acorde("Fa#")).svg(notacion: .inglesASCII)))
        #expect(ingles.todos("text").contains { $0.texto == "F#" })
        let clases = try #require(ElementoXML.leer(Tonnetz(ConjuntoDeClases([0, 4, 7])).svg(margen: 3)))
        #expect(clases.todos("text").filter { $0.atributos["font-weight"] == "bold" }.count > 3)
    }

    @Test func transformaciones() {
        #expect(Acorde("Do").transformar(.p) == Acorde("Dom"))
        #expect(Acorde("Do").transformar(.l) == Acorde("Mim"))
        #expect(Acorde("Do").transformar(.r) == Acorde("Lam"))
        #expect(Acorde("Lam").transformar(.l) == Acorde("Fa"))
        #expect(Acorde("Lam").transformar(.r) == Acorde("Do"))
        // La ortografía se conserva.
        #expect(Acorde("Mib").transformar(.r) == Acorde("Dom"))
        #expect(Acorde("Do#m").transformar(.l) == Acorde("La"))
        // Las compuestas.
        #expect(Acorde("Do").transformar(TransformacionNeorriemanniana.n) == Acorde("Fam"))
        #expect(Acorde("Do").transformar(TransformacionNeorriemanniana.s) == Acorde("Do#m"))
        #expect(Acorde("Do").transformar(TransformacionNeorriemanniana.h) == Acorde("Sol#m"))
        #expect(Acorde("Do").transformar(leyendo: "P L R") == Acorde("Fam"))
        #expect(Acorde("Do").transformar(leyendo: "n") == Acorde("Fam"))
        #expect(Acorde("Do").transformar(leyendo: "PX") == nil)
        #expect(Acorde("Do").transformar(leyendo: "") == nil)
        // Solo tríadas mayores y menores; la inversión se ignora.
        #expect(Acorde("Sol7").transformar(.p) == nil)
        #expect(Acorde("Sidim").transformar(.r) == nil)
        #expect(Acorde("Do/Mi").transformar(.r) == Acorde("Lam"))
        #expect(TransformacionNeorriemanniana.entre("Do", "Lam") == .r)
        #expect(TransformacionNeorriemanniana.entre("Do", "Re") == nil)
        #expect(TransformacionNeorriemanniana.l.nombre == "cambio de sensible")
        // Son involuciones, y cada una comparte un lado con la tríada: dos notas en común.
        var azar = GeneradorConSemilla(semilla: 7)
        for _ in 0..<100 {
            let acorde = Acorde(
                Nota(pasosDeQuinta: Int.random(in: -12...12, using: &azar)), Bool.random(using: &azar) ? .mayor : .menor
            )
            for t in TransformacionNeorriemanniana.allCases {
                let otro = acorde.transformar(t)!
                #expect(otro.transformar(t) == acorde, "\(acorde) \(t)")
                #expect(Set(acorde.notas).intersection(otro.notas).count == 2, "\(acorde) \(t)")
                #expect(otro.tipo != acorde.tipo)
            }
        }
        // En el Tonnetz, cada transformación da un triángulo vecino.
        let triada = Tonnetz.Triada(Acorde("Do"))!
        for vecina in triada.vecinas {
            #expect(Set(triada.vertices).intersection(vecina.vertices).count == 2)
        }
    }

    @Test func camino() {
        #expect(Tonnetz.camino(desde: "Do", hasta: "Do") == [])
        #expect(Tonnetz.camino(desde: "Do", hasta: "Lam") == [.r])
        #expect(Tonnetz.camino(desde: "Do", hasta: "Lab") == [.p, .l])
        #expect(Tonnetz.camino(desde: "Do", hasta: "Mibm") == [.p, .r, .p])
        #expect(Tonnetz.camino(desde: "Do", hasta: "Fa#") == [.r, .p, .r, .p])
        #expect(Tonnetz.camino(desde: "Do", hasta: "Fa") == [.r, .l])
        #expect(Tonnetz.camino(desde: "Do", hasta: "Sol7") == nil)
        // Con ortografía, La♭ y Sol♯ son destinos distintos; sin ella, el mismo.
        #expect(Tonnetz.camino(desde: "Do", hasta: "Lab")?.count == 2)
        #expect(Tonnetz.camino(desde: "Do", hasta: "Sol#")!.count > 2)
        #expect(Tonnetz.camino(desde: "Do", hasta: "Sol#", enarmonico: true) == [.p, .l])
        // Todo camino lleva a su destino, y ninguno entre las 24 tríadas pasa de 5 pasos sin ortografía.
        for n in 0..<12 {
            for mayor in [true, false] {
                let destino = Acorde(Nota(pasosDeQuinta: n - 5), mayor ? .mayor : .menor)
                let camino = Tonnetz.camino(desde: "Do", hasta: destino)!
                #expect(Acorde("Do").transformar(camino) == destino)
                #expect(Tonnetz.camino(desde: "Do", hasta: destino, enarmonico: true)!.count <= 5)
            }
        }
    }

    @Test func recorrido() throws {
        // La progresión I–vi–IV: tres triángulos vecinos.
        let recorrido = try #require(Tonnetz(recorrido: ["Do", "Lam", "Fa"]))
        #expect(recorrido.recorrido.map(\.acorde) == [Acorde("Do"), Acorde("Lam"), Acorde("Fa")])
        #expect(recorrido.notas == [.do, .mi, .sol, .la, .fa])
        for (uno, otro) in zip(recorrido.recorrido, recorrido.recorrido.dropFirst()) {
            #expect(Set(uno.vertices).intersection(otro.vertices).count == 2)
        }
        // La bomba de comas: Do–Lam–Rem–Sol–Do vuelve a un Do desplazado una coma sintónica.
        let bomba = try #require(Tonnetz(recorrido: ["Do", "Lam", "Rem", "Sol", "Do"]))
        #expect(bomba.recorrido.first != bomba.recorrido.last)
        #expect(bomba.recorrido.first?.acorde == bomba.recorrido.last?.acorde)
        #expect(Tonnetz(recorrido: ["Do", "Sol7"]) == nil)
        #expect(Tonnetz(recorrido: [])!.puntos.isEmpty)
        // El camino más corto, como recorrido.
        let camino = try #require(Tonnetz(caminoDesde: "Do", hasta: "Mibm"))
        #expect(camino.recorrido.map(\.acorde) == [Acorde("Do"), Acorde("Dom"), Acorde("Mib"), Acorde("Mibm")])
        #expect(Tonnetz(caminoDesde: "Do", hasta: "Sol7") == nil)
        // El dibujo: flechas y el pie.
        let raiz = try #require(ElementoXML.leer(recorrido.svg()))
        #expect(raiz.todos("line").filter { $0.atributos["marker-end"] != nil }.count == 2)
        #expect(raiz.todos("text").contains { $0.texto == "Do –R→ Lam –L→ Fa" })
        let ingles = try #require(ElementoXML.leer(camino.svg(notacion: .inglesASCII)))
        #expect(
            ingles.todos("text").contains {
                $0.texto == "C –P→ Cm –R→ " + Acorde("Mib").cifrado(en: .inglesASCII) + " –P→ "
                    + Acorde("Mibm").cifrado(en: .inglesASCII)
            })
        #expect(
            try
                (#require(ElementoXML.leer(Tonnetz(Acorde("Do")).svg())).todos("line").first {
                    $0.atributos["marker-end"] != nil
                }) == nil)
        // Ida y vuelta entre los mismos triángulos: flechas curvas que no se montan.
        let vaiven = try #require(ElementoXML.leer(Tonnetz(recorrido: ["Do", "Dom", "Do", "Dom"])!.svg()))
        let curvas = vaiven.todos("path").filter { $0.atributos["marker-end"] != nil }
        let rectas = vaiven.todos("line").filter { $0.atributos["marker-end"] != nil }
        #expect((curvas.count + rectas.count) == 3)
        #expect(rectas.count == 1)
        #expect(Set(curvas.compactMap { $0.atributos["d"] }).count == 2)
        // Ida y vuelta, una vez cada una: dos curvas, sin recta en medio.
        let idaYVuelta = try #require(ElementoXML.leer(Tonnetz(recorrido: ["Do", "Lam", "Do"])!.svg()))
        #expect(idaYVuelta.todos("path").filter { $0.atributos["marker-end"] != nil }.count == 2)
        // Un recorrido sin vueltas, solo rectas.
        #expect(raiz.todos("path").filter { $0.atributos["marker-end"] != nil }.isEmpty)
    }

    @Test func tituloYLeyenda() throws {
        func leyenda(_ raiz: ElementoXML) -> [String] {
            raiz.todos("g").filter { $0.atributos["class"] == "leyenda" }.flatMap { $0.todos("text").map(\.texto) }
        }
        // El título: el acorde, la escala, las notas, el conjunto o el recorrido.
        for (tonnetz, titulo) in [
            (Tonnetz(Acorde("Domaj7")), "Domaj7"), (Tonnetz(Escala(.re, .dorico)), "Re dórico"),
            (Tonnetz([.do, .mi, .sol]), "Do · Mi · Sol"), (Tonnetz(ConjuntoDeClases([0, 4, 7])), "Conjunto [0, 4, 7]"),
            (Tonnetz(recorrido: ["Do", "Lam"])!, "Do –R→ Lam"),
        ] {
            let raiz = try #require(ElementoXML.leer(tonnetz.svg()))
            #expect(raiz.todos("title").first?.texto == titulo)
            #expect(
                raiz.todos("text").contains { $0.texto == titulo && $0.atributos["font-weight"] == "600" },
                Comment(rawValue: titulo))
        }
        #expect(
            try
                (#require(ElementoXML.leer(Tonnetz(Acorde("Do")).svg(notacion: .inglesASCII))).todos("title").first?
                .texto) == "C")
        #expect(
            try (#require(ElementoXML.leer(Tonnetz(Acorde("Do")).svg(titulo: "Tónica"))).todos("title").first?.texto)
                == "Tónica")
        #expect(try #require(ElementoXML.leer(Tonnetz(Acorde("Do")).svg(titulo: ""))).todos("title").isEmpty)
        // La leyenda, solo con lo que aparece.
        #expect(
            try leyenda(#require(ElementoXML.leer(Tonnetz(Acorde("Domaj7")).svg()))) == [
                "nota", "quinta o tercera entre notas", "tríada mayor", "tríada menor",
            ])
        #expect(
            try leyenda(#require(ElementoXML.leer(Tonnetz(Escala(.do, .tonosEnteros)).svg()))) == [
                "nota", "quinta o tercera entre notas",
            ])
        #expect(
            try leyenda(#require(ElementoXML.leer(Tonnetz(recorrido: ["Do", "Lam"])!.svg()))).last
                == "paso del recorrido (P, L, R)")
        #expect(
            try leyenda(#require(ElementoXML.leer(Tonnetz(ConjuntoDeClases([0])).svg()))) == [
                "clase de altura (todas sus copias)"
            ])
        #expect(
            try leyenda(#require(ElementoXML.leer(Tonnetz(Acorde("Do")).svg(notacion: .inglesASCII)))) == [
                "note", "fifth or third between notes", "major triad",
            ])
        #expect(try leyenda(#require(ElementoXML.leer(Tonnetz(Acorde("Do")).svg(leyenda: false)))).isEmpty)
        #expect(try leyenda(#require(ElementoXML.leer(Tonnetz([]).svg()))).isEmpty)
    }

    @Test func ciclos() {
        func cifrados(_ acorde: Acorde, _ ciclo: CicloNeorriemanniano) -> [String] {
            acorde.ciclo(ciclo)?.map(\.cifrado) ?? []
        }
        // Con la ortografía más sencilla: Mi y no Fa♭, Fa♯m y no Sol♭m (con Si♭♭).
        #expect(cifrados("Do", .hexatonico) == ["Do", "Dom", "La♭", "La♭m", "Mi", "Mim", "Do"])
        #expect(cifrados("Do", .octatonico) == ["Do", "Dom", "Mi♭", "Mi♭m", "Sol♭", "Fa♯m", "La", "Lam", "Do"])
        #expect(cifrados("Mim", .hexatonico) == ["Mim", "Mi", "Sol♯m", "Sol♯", "Dom", "Do", "Mim"])
        let lr = cifrados("Do", .lr)
        #expect(lr.count == 25)
        #expect(Array(lr.prefix(5)) == ["Do", "Mim", "Sol", "Sim", "Re"])
        #expect(Array(lr[10...16]) == ["Si", "Re♯m", "Fa♯", "La♯m", "Do♯", "Fam", "La♭"])
        #expect(lr.last == "Do")
        // Las 24 tríadas, una vez cada una; y en cada ciclo, de una a otra por P, L o R.
        for ciclo in CicloNeorriemanniano.allCases {
            for n in -6...6 {
                for mayor in [true, false] {
                    let inicio = Acorde(Nota(pasosDeQuinta: n), mayor ? .mayor : .menor)
                    let acordes = inicio.ciclo(ciclo)!
                    #expect(acordes.count == (ciclo.longitud + 1))
                    #expect(acordes.last == inicio)
                    let distintas = Set(
                        acordes.dropLast().map { [$0.fundamental.claseDeAltura, $0.tipo == .mayor ? 1 : 0] })
                    #expect(distintas.count == ciclo.longitud)
                    for (i, (uno, otro)) in zip(acordes, acordes.dropFirst()).enumerated() {
                        let transformado = uno.transformar(ciclo.transformaciones[i % 2])!
                        #expect(Set(transformado.notas.map(\.claseDeAltura)) == Set(otro.notas.map(\.claseDeAltura)))
                        // Sin dobles alteraciones (salvo en la de partida, que se respeta: Sol♭m).
                        if otro != inicio {
                            #expect(otro.notas.allSatisfy { abs($0.alteracion.semitonos) <= 1 }, "\(otro)")
                        }
                    }
                }
            }
        }
        #expect(Acorde("Sol7").ciclo(.hexatonico) == nil)
        #expect(CicloNeorriemanniano(leyendo: "Hexatónico") == .hexatonico)
        #expect(CicloNeorriemanniano(leyendo: "octatonic cycle") == .octatonico)
        #expect(CicloNeorriemanniano(leyendo: "ciclo LR") == .lr)
        #expect(CicloNeorriemanniano(leyendo: "pentatónico") == nil)
    }

    @Test func dibujoDeCiclos() throws {
        let tonnetz = try #require(Tonnetz(ciclo: .hexatonico, desde: "Do"))
        // La banda, recta: siete triángulos y nueve puntos, el último Do otra vez.
        #expect(tonnetz.recorrido.count == 7)
        #expect(tonnetz.puntos.count == 9)
        #expect(tonnetz.recorrido.last?.fundamental == PuntoDeLaRed(quintas: 0, terceras: -3))
        #expect(tonnetz.notas.map(\.description) == ["Do", "Mi", "Sol", "Mi♭", "La♭", "Do♭", "Mi", "Sol", "Do"])
        let svg = tonnetz.svg()
        #expect(svg.contains("Do –P→ Dom –L→ La♭ –P→ La♭m –L→ Mi –P→ Mim –L→ Do"))
        #expect(!svg.contains("Fa♭"))
        #expect(!(svg.contains("𝄫") || svg.contains("♭♭") || svg.contains("Re♭♭")))
        #expect(tonnetz.svg(notacion: .inglesASCII).contains("C –P→ Cm –L→ Ab"))
        #expect(Tonnetz(ciclo: .lr, desde: "Lam")?.recorrido.count == 25)
        #expect(Tonnetz(ciclo: .octatonico, desde: "Do7") == nil)
    }
}
