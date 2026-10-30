import XCTest
@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaTeoria
@testable import ArmoniaPartitura

final class PentagramaSVGTests: XCTestCase {
    private func contar(_ trozo: String, en texto: String) -> Int {
        texto.components(separatedBy: trozo).count - 1
    }

    /// Cada nota lleva su nombre en un `<title>`; el SVG es el mismo cada vez.
    func testLaEscalaDeDoMayorTieneOchoNotasConNombre() {
        let svg = Escala(.do).svgPentagrama()
        XCTAssertTrue(svg.hasPrefix("<svg"))
        XCTAssertTrue(svg.hasSuffix("</svg>"))
        XCTAssertEqual(contar("<g><title>", en: svg), 8)
        XCTAssertTrue(svg.contains("<title>Do4</title>"))
        XCTAssertTrue(svg.contains("<title>Do5</title>"))
        XCTAssertEqual(svg, Escala(.do).svgPentagrama())
    }

    /// Una escala con armadura no escribe alteraciones delante de las notas.
    func testLaArmaduraAhorraLasAlteraciones() {
        let con = Escala(.re).svgPentagrama()
        let sin = Escala(.re).svgPentagrama(opciones: OpcionesDePentagrama(armadura: .ninguna))
        XCTAssertLessThan(con.count, sin.count)
    }

    /// La bajada de la menor melódica es distinta de la subida: 8 + 7 notas.
    func testLaMenorMelodicaIncluyeLaBajada() {
        let escala = Escala("La menor melódica")
        XCTAssertEqual(contar("<g><title>", en: escala.svgPentagrama()), 15)
        XCTAssertEqual(contar("<g><title>", en: escala.svgPentagrama(sentido: .ascendente)), 8)
    }

    /// Las notas del acorde van en un solo grupo de columnas y llevan el cifrado encima.
    func testElAcordeLlevaCifradoYTodasSusNotas() {
        let svg = Acorde("Sol7").svgPentagrama()
        XCTAssertEqual(contar("<g><title>", en: svg), 4)
        XCTAssertTrue(svg.contains(">Sol7</text>"))
        XCTAssertFalse(Acorde("Sol7").svgPentagrama(cifrado: false).contains("<text"))
    }

    /// El cifrado largo cabe en la imagen: el ancho del viewBox es mayor que el de las notas solas.
    func testElCifradoLargoEnsanchaElPentagrama() {
        func ancho(_ svg: String) -> Double {
            let resto = svg.components(separatedBy: "viewBox=\"0 ")[1]
            let numeros = resto.components(separatedBy: "\"")[0].split(separator: " ")
            return Double(numeros[1])!
        }
        XCTAssertGreaterThan(ancho(Acorde("Do7b9").svgPentagrama()), ancho(Acorde("Do7b9").svgPentagrama(cifrado: false)))
    }

    /// Fuera del pentagrama hay líneas adicionales; dentro, ninguna.
    func testLineasAdicionales() {
        XCTAssertEqual(PentagramaSVG.lugaresDeLasLineasAdicionales(de: 4), [])
        XCTAssertEqual(PentagramaSVG.lugaresDeLasLineasAdicionales(de: -2), [-2])
        XCTAssertEqual(PentagramaSVG.lugaresDeLasLineasAdicionales(de: -4), [-2, -4])
        XCTAssertEqual(PentagramaSVG.lugaresDeLasLineasAdicionales(de: 10), [10])
    }

    /// Los nombres que se escriben se escapan.
    func testEscapar() {
        XCTAssertEqual(PentagramaSVG.escapar("a<b&\"c"), "a&lt;b&amp;&quot;c")
    }

    // MARK: Pentagrama doble

    private func pentagramasDibujados(_ svg: String) -> Int {
        contar("stroke-width=\"0.13\"", en: svg) / 5
    }

    /// Un pentagrama de un lado solo, por muchas líneas adicionales que haga falta.
    func testPorDefectoUnSoloPentagrama() {
        XCTAssertEqual(pentagramasDibujados(Escala(.do).svgPentagrama()), 1)
        XCTAssertEqual(pentagramasDibujados(Escala(.do).svgPentagrama(octava: 6)), 1)
    }

    /// Con `.doble` se dibujan los dos pentagramas y las notas se reparten por el Do central.
    func testElPentagramaDobleSeFuerza() {
        let svg = Escala(.do).svgPentagrama(octava: 3, opciones: OpcionesDePentagrama(pentagramas: .doble))
        XCTAssertEqual(pentagramasDibujados(svg), 2)
        XCTAssertEqual(contar("<g><title>", en: svg), 8)
        XCTAssertEqual(pentagramasDibujados(Escala(.do).svgPentagrama(opciones: OpcionesDePentagrama(pentagramas: .simple))), 1)
    }

    /// Un rango muy ancho, a los dos lados del Do central, pasa solo al pentagrama doble; con la clave fija, no.
    func testElRangoAnchoPasaAlPentagramaDoble() {
        let notas = [Altura(.do, octava: 2), Altura(.sol, octava: 5)]
        let automatico = PentagramaSVG(columnas: [notas], armadura: [], cifrado: nil, titulo: "", opciones: OpcionesDePentagrama()).svg()
        XCTAssertEqual(pentagramasDibujados(automatico), 2)
        let conClave = PentagramaSVG(columnas: [notas], armadura: [], cifrado: nil, titulo: "", opciones: OpcionesDePentagrama(clave: .sol)).svg()
        XCTAssertEqual(pentagramasDibujados(conClave), 1)
        let solo = PentagramaSVG(columnas: [[Altura(.sol, octava: 6), Altura(.do, octava: 7)]], armadura: [], cifrado: nil, titulo: "", opciones: OpcionesDePentagrama()).svg()
        XCTAssertEqual(pentagramasDibujados(solo), 1)   // todo por encima del Do central: el de fa iría vacío
    }

    // MARK: Marca de octava y texto

    /// Una escala muy aguda o muy grave se escribe una octava más cerca, con la marca 8va u 8vb.
    func testLaMarcaDeOctava() {
        XCTAssertFalse(Escala(.do).svgPentagrama().contains(">8v"))
        XCTAssertTrue(Escala(.do).svgPentagrama(octava: 6).contains(">8va<"))
        XCTAssertTrue(Escala(.do).svgPentagrama(octava: 1).contains(">8vb<"))
        // Los nombres son los de las notas que suenan, no los de las escritas.
        XCTAssertTrue(Escala(.do).svgPentagrama(octava: 6).contains("<title>Do6</title>"))
        XCTAssertFalse(Escala(.do).svgPentagrama(octava: 6, opciones: OpcionesDePentagrama(marcaDeOctava: false)).contains(">8v"))
        XCTAssertFalse(Escala(.do).svgPentagrama(octava: 6, opciones: OpcionesDePentagrama(clave: .sol)).contains(">8v"))
    }

    private func etiquetas(_ svg: String) -> [(x: Double, texto: String)] {
        svg.components(separatedBy: "<text x=\"").dropFirst().compactMap { trozo in
            guard trozo.contains("font-size=\"1.2\""), let x = Double(trozo.prefix(while: { $0 != "\"" })),
                  let inicio = trozo.firstIndex(of: ">"), let fin = trozo.range(of: "</text>") else { return nil }
            return (x, String(trozo[trozo.index(after: inicio)..<fin.lowerBound]))
        }
    }

    /// Los nombres de las notas no se pisan: entre dos centros cabe la mitad de cada nombre y un hueco.
    func testLasEtiquetasNoSePisan() {
        let lista = etiquetas(Escala("Si♭ mayor").svgPentagrama(opciones: OpcionesDePentagrama(nombresDeLasNotas: true)))
        XCTAssertEqual(lista.count, 8)
        for (a, b) in zip(lista, lista.dropFirst()) {
            let anchoA = PentagramaSVG.anchoEstimado(a.texto, cuerpoDeLetra: 1.2, proporcion: 1)
            let anchoB = PentagramaSVG.anchoEstimado(b.texto, cuerpoDeLetra: 1.2, proporcion: 1)
            XCTAssertGreaterThanOrEqual(b.x - a.x, (anchoA + anchoB) / 2 + 0.5 - 0.01, "\(a.texto) \(b.texto)")
        }
    }

    /// La medida del texto sale de una tabla de anchos: «i» es estrecha, «m» ancha, las tildes no cuentan.
    func testLaMedidaDelTexto() {
        func ancho(_ texto: String, _ proporcion: Double = 1) -> Double {
            PentagramaSVG.anchoEstimado(texto, cuerpoDeLetra: 2, proporcion: proporcion)
        }
        XCTAssertLessThan(ancho("iii"), ancho("mmm"))
        XCTAssertEqual(ancho("é"), ancho("e"))
        XCTAssertEqual(ancho("Do", 2), 2 * ancho("Do"), accuracy: 1e-9)
        XCTAssertGreaterThan(ancho("Ми♭"), 0)        // cirílico: valor por defecto
        XCTAssertGreaterThan(ancho("Φα"), ancho("α"))
    }

    /// El cifrado y las etiquetas llevan `textLength`: no se salen de su sitio con otra tipografía.
    func testElTextoLlevaSuLongitud() {
        let svg = Acorde("Do7b9").svgPentagrama(opciones: OpcionesDePentagrama(nombresDeLasNotas: true))
        XCTAssertEqual(contar("textLength=", en: svg), 2)
    }

    /// Con una tipografía más ancha, el texto pide más sitio.
    func testElAnchoDeLosCaracteresSeAjusta() {
        func ancho(_ svg: String) -> Double {
            let resto = svg.components(separatedBy: "viewBox=\"0 ")[1]
            return Double(resto.components(separatedBy: "\"")[0].split(separator: " ")[1])!
        }
        let normal = Acorde("Do7b9").svgPentagrama()
        let ancho2 = Acorde("Do7b9").svgPentagrama(opciones: OpcionesDePentagrama(anchoDeLosCaracteres: 1.4))
        XCTAssertGreaterThan(ancho(ancho2), ancho(normal))
    }

    // MARK: Llave y posición abierta

    /// El pentagrama doble lleva una llave a la izquierda, en el margen que se añade al `viewBox`.
    func testElPentagramaDobleLlevaLlave() {
        let doble = Escala(.do).svgPentagrama(octava: 3, opciones: OpcionesDePentagrama(pentagramas: .doble))
        XCTAssertTrue(doble.contains("viewBox=\"-1.9 "))
        XCTAssertTrue(doble.contains("scale(3.5)"))
        let simple = Escala(.do).svgPentagrama()
        XCTAssertTrue(simple.contains("viewBox=\"0 "))
        XCTAssertFalse(simple.contains("scale("))
    }

    /// Los acordes muy extensos (la trecena) ponen el bajo una octava más grave; los demás, en posición cerrada.
    func testLaPosicionAbierta() {
        XCTAssertFalse(Acorde("Sol7").svgPentagrama().contains("<title>Sol3</title>"))
        XCTAssertTrue(Acorde("Sol7").svgPentagrama(opciones: OpcionesDePentagrama(disposicionDelAcorde: .abierta)).contains("<title>Sol3</title>"))
        XCTAssertTrue(Acorde("Do13").svgPentagrama().contains("<title>Do3</title>"))
        XCTAssertFalse(Acorde("Do13").svgPentagrama(opciones: OpcionesDePentagrama(disposicionDelAcorde: .cerrada)).contains("<title>Do3</title>"))
        // Con el bajo tan grave y lo demás tan agudo, pasa al pentagrama doble.
        XCTAssertEqual(pentagramasDibujados(Acorde("Do13").svgPentagrama()), 2)
    }

    // MARK: Alteraciones y 8va en el pentagrama doble

    private func anchoDelDibujo(_ svg: String) -> Double {
        let resto = svg.components(separatedBy: "viewBox=\"")[1]
        return Double(resto.components(separatedBy: "\"")[0].split(separator: " ")[2])!
    }

    private func pentagrama(_ notas: [(String, Int)]) -> String {
        PentagramaSVG(columnas: [notas.map { Altura(Nota($0.0), octava: $0.1) }], armadura: [], cifrado: nil, titulo: "",
                      opciones: OpcionesDePentagrama()).svg()
    }

    /// Las alteraciones se reparten en pocas columnas, escalonadas: siete alteradas no piden siete columnas.
    func testLasAlteracionesCabenEnPocasColumnas() {
        let naturales = pentagrama([("Do", 4), ("Mi", 4), ("Sol", 4), ("Si", 4), ("Re", 5), ("Fa", 5), ("La", 5)])
        let alteradas = pentagrama([("Do#", 4), ("Mib", 4), ("Sol#", 4), ("Sib", 4), ("Re#", 5), ("Fa#", 5), ("Lab", 5)])
        XCTAssertEqual(contar("<g><title>", en: alteradas), 7)
        XCTAssertLessThan(anchoDelDibujo(alteradas) - anchoDelDibujo(naturales), 5.5)
        XCTAssertGreaterThan(anchoDelDibujo(alteradas), anchoDelDibujo(naturales))
    }

    /// En el pentagrama doble, cada uno lleva su marca: 8va el de arriba y 8vb el de abajo.
    func testLaMarcaDeOctavaPorPentagrama() {
        let ambas = pentagrama([("Do", 1), ("Do", 7)])
        XCTAssertEqual(pentagramasDibujados(ambas), 2)
        XCTAssertTrue(ambas.contains(">8va<"))
        XCTAssertTrue(ambas.contains(">8vb<"))
        let soloArriba = pentagrama([("Do", 3), ("Do", 7)])
        XCTAssertEqual(pentagramasDibujados(soloArriba), 2)
        XCTAssertTrue(soloArriba.contains(">8va<"))
        XCTAssertFalse(soloArriba.contains(">8vb<"))
        XCTAssertFalse(pentagrama([("Do", 3), ("Do", 5)]).contains(">8v"))
    }
}
