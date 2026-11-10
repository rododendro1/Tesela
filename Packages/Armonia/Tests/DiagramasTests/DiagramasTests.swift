import Foundation
import Testing

@testable import Diagramas
@testable import Elementos
@testable import Teoria

@Suite struct CorrespondenciaDeColoresTests {
    @Test func colorRGB() {
        let naranja = ColorRGB(hexadecimal: "#FF8000")!
        #expect(naranja.rojo == 255)
        #expect(naranja.verde == 128)
        #expect(naranja.azul == 0)
        #expect(naranja.hexadecimal == "#FF8000")
        #expect(ColorRGB(hexadecimal: "0d98ba")?.hexadecimal == "#0D98BA")
        #expect(ColorRGB(hexadecimal: "#FF80") == nil)
        #expect(ColorRGB(hexadecimal: "#-00001") == nil)
        #expect(ColorRGB(hexadecimal: "#GG0000") == nil)
        #expect(ColorRGB(rojo: 300, verde: -4, azul: 16).hexadecimal == "#FF0010")
        #expect(ColorRGB(tono: 0, saturacion: 1, brillo: 1).hexadecimal == "#FF0000")
        #expect(ColorRGB(tono: 120, saturacion: 1, brillo: 1).hexadecimal == "#00FF00")
        #expect(ColorRGB(tono: 240, saturacion: 1, brillo: 1).hexadecimal == "#0000FF")
        #expect(ColorRGB(tono: 30, saturacion: 1, brillo: 1).hexadecimal == "#FF8000")
        #expect(ColorRGB(tono: -60, saturacion: 1, brillo: 1).hexadecimal == "#FF00FF")
        #expect(ColorRGB(tono: 0, saturacion: 0, brillo: 0.5).hexadecimal == "#808080")
    }

    @Test func correspondencias() {
        // Newton: por letra; las alteraciones no cambian el color.
        #expect(Nota.do.color(segun: .newton).hexadecimal == "#FF0000")
        #expect(Nota.la.color(segun: .newton) == Nota("La#").color(segun: .newton))
        #expect(CorrespondenciaDeColores.newton.nombreDelColor(de: .la) == "añil")
        // Castel: Do azul, Re verde, Mi amarillo, Sol rojo.
        #expect(CorrespondenciaDeColores.castel.nombreDelColor(de: .do) == "azul")
        #expect(CorrespondenciaDeColores.castel.nombreDelColor(de: .sol) == "rojo")
        // Scriabin: por clase de altura, así que Do♯ y Re♭ comparten color.
        #expect(CorrespondenciaDeColores.scriabin.nombreDelColor(de: .re) == "amarillo")
        #expect(CorrespondenciaDeColores.scriabin.nombreDelColor(de: .fa) == "rojo oscuro")
        #expect(Nota("Do#").color(segun: .scriabin) == Nota("Reb").color(segun: .scriabin))
        // Círculo de quintas: 30° por quinta.
        #expect(Acorde("Do").colores(segun: .circuloDeQuintas).map(\.hexadecimal) == ["#FF0000", "#00FF00", "#FF8000"])
        #expect(CorrespondenciaDeColores.circuloDeQuintas.nombreDelColor(de: .do) == nil)
        #expect(Escala(.do).colores(segun: .scriabin).count == 7)
        #expect(Altura("Re5").color(segun: .scriabin) == Nota.re.color(segun: .scriabin))
        // Cada correspondencia da doce colores distintos (Newton, siete).
        for sinestesia in CorrespondenciaDeColores.allCases {
            let colores = Set((0..<12).map { Nota(pasosDeQuinta: $0 * 7 % 12 - 5).color(segun: sinestesia) })
            #expect(colores.count == (sinestesia == .newton ? 7 : 12), Comment(rawValue: sinestesia.nombre))
        }
    }
}

/// El teclado de piano dibujado en SVG.
@Suite struct TecladoDePianoTests {
    @Test func teclas() {
        let teclado = TecladoDePiano(desde: 61, hasta: 70)
        #expect(teclado.desde == 60 && teclado.hasta == 71)
        #expect(teclado.blancas == [60, 62, 64, 65, 67, 69, 71])
        #expect(teclado.negras == [61, 63, 66, 68, 70])
        #expect(teclado.x(de: 62) == 24)
        #expect(teclado.x(de: 61) == 17)
        let doMayor = TecladoDePiano(cubriendo: Escala(.do).alturas(octava: 4))
        #expect(doMayor.desde == 60 && doMayor.hasta == 72)
        let vacio = TecladoDePiano(cubriendo: [])
        #expect(vacio.desde == 60 && vacio.hasta == 72)
        #expect(TecladoDePiano(desde: 64, hasta: 60).hasta == 64)
    }

    @Test func dibujo() {
        let teclado = TecladoDePiano(desde: 60, hasta: 72)
        let svg = teclado.svg(
            marcadas: [60: "1", 61: "2", 64: "3"], primeras: [60], opciones: .init(titulo: "Do & Re"))
        #expect(svg.hasPrefix("<svg xmlns=\"http://www.w3.org/2000/svg\""))
        #expect(svg.hasSuffix("</svg>\n"))
        #expect(svg.contains("<title>Do &amp; Re</title>"))
        // El fondo, ocho blancas y cinco negras.
        #expect(svg.components(separatedBy: "<rect").count - 1 == 14)
        #expect(svg.components(separatedBy: "<circle").count - 1 == 3)
        #expect(svg.components(separatedBy: DibujoSVG.Color.primera).count - 1 == 1)
        #expect(svg.contains(">2</text>"))
        let sinTitulo = teclado.svg()
        #expect(!sinTitulo.contains("<title>") && !sinTitulo.contains("<circle"))
        // Marcadas sin rótulo: el círculo, con el nombre de la nota en la notación; sin nombres, sin texto.
        let conNombres = teclado.svg(marcadas: [60, 61, 64], opciones: .init(notacion: .ascii(.ingles)))
        #expect(conNombres.contains(">C</text>") && conNombres.contains(">C#</text>"))
        #expect(conNombres.contains(">E</text>"))
        let conBemoles = teclado.svg(marcadas: [61], opciones: .init(ventana: .bemoles))
        #expect(conBemoles.contains(">Re♭</text>"))
        // Con una ventana de quintas: alrededor de Re, Do♯ y Mi♭.
        let enRe = teclado.svg(marcadas: [61, 63], opciones: .init(ventana: .centrada(en: "Re")))
        #expect(enRe.contains(">Do♯</text>") && enRe.contains(">Mi♭</text>"))
        // Marcadas con sus alturas, se nombran como se escriben: el Si♭ de Fa mayor, no La♯.
        let fa = MarcasDeDiagrama(Escala("Fa mayor").alturas(octava: 4))
        #expect(fa.contains(70) && fa.altura(de: 70) == Altura("Si♭4") && fa.rotulo(de: 70) == nil)
        let enFa = teclado.svg(marcadas: fa)
        #expect(enFa.contains(">Si♭</text>") && !enFa.contains(">La♯</text>"))
        let sinRotulos = teclado.svg(marcadas: [60, 64], opciones: .init(nombresDeLasNotas: false))
        #expect(sinRotulos.components(separatedBy: "<circle").count - 1 == 2)
        #expect(!sinRotulos.contains("</text>"))
        // La escala agranda el dibujo sin cambiar lo que tiene dentro.
        func ancho(_ svg: String) -> Double? {
            svg.components(separatedBy: #"width=""#).dropFirst().first?.split(separator: "\"").first
                .flatMap { Double(String($0)) }
        }
        #expect(ancho(teclado.svg()) == 208)
        #expect(ancho(teclado.svg(opciones: .init(escala: 2))) == 416)
    }
}

/// El reloj de una escala: sus notas en el círculo cromático o en el de quintas.
@Suite struct RelojDeClasesTests {
    @Test func horas() {
        let diatonica = [0, 2, 4, 5, 7, 9, 11]
        #expect(RelojDeClasesDeAltura(clases: diatonica).horas == diatonica)
        // En el de quintas, la diatónica son siete horas seguidas, de Fa (las 11) a Si (las 5).
        #expect(RelojDeClasesDeAltura(clases: diatonica, orden: .quintas).horas == [0, 1, 2, 3, 4, 5, 11])
        #expect(RelojDeClasesDeAltura.hora(de: 7, en: .quintas) == 1)
        #expect(RelojDeClasesDeAltura(clases: [12, -1], tonica: 12).clases == [0, 11])
        #expect(RelojDeClasesDeAltura(clases: [12, -1], tonica: 12).tonica == 0)
    }

    @Test func dibujo() {
        let reloj = RelojDeClasesDeAltura(clases: [0, 4, 7], tonica: 0)
        let svg = reloj.svg(rotulos: [0: "Do", 4: "Mi"], opciones: .init(titulo: "Do & Mi"))
        #expect(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"))
        #expect(svg.components(separatedBy: "<circle").count - 1 == 13)
        #expect(svg.contains("<polygon"))
        // Las horas sin rótulo, con el nombre de su nota; sin nombres, con su número.
        #expect(svg.contains(">Do</text>") && svg.contains(">Sol</text>") && svg.contains(">Fa♯</text>"))
        let enIngles = reloj.svg(opciones: .init(notacion: .ascii(.ingles), ventana: .bemoles))
        #expect(enIngles.contains(">G</text>") && enIngles.contains(">Gb</text>"))
        // Hecho con notas, cada hora se nombra como la escribe la escala.
        let fa = Escala("Fa mayor")
        let relojDeFa = RelojDeClasesDeAltura(notas: fa.notas, tonica: fa.tonica)
        #expect(relojDeFa.clases == Set(fa.notas.map(\.claseDeAltura)) && relojDeFa.tonica == 5)
        #expect(relojDeFa.ortografia[10] == Nota("Si♭") && relojDeFa.svg().contains(">Si♭</text>"))
        #expect(!relojDeFa.svg().contains(">La♯</text>") && reloj.svg().contains(">La♯</text>"))
        let numeros = reloj.svg(rotulos: [0: "Do"], opciones: .init(nombresDeLasNotas: false))
        #expect(numeros.contains(">Do</text>") && numeros.contains(">7</text>"))
        #expect(svg.contains("<title>Do &amp; Mi</title>"))
        #expect(svg.contains(DibujoSVG.Color.primera))
        // Una sola nota no hace polígono; sin título, no hay texto de cabecera.
        let sola = RelojDeClasesDeAltura(clases: [0]).svg()
        #expect(!sola.contains("<polygon") && !sola.contains("<title>"))
    }
}

/// El reloj de cents: las notas de una escala con microtonos en el ángulo de sus cents.
@Suite struct RelojDeAlturasTests {
    @Test func posiciones() throws {
        let bayati = try #require(RelojDeAlturas(escala: Escala(.re, .bayati)))
        // Desde Do: Re a 200, el Mi𝄳 a 350 (un cuarto de tono sobre Mi♭), y Do, la séptima, arriba.
        #expect(bayati.posiciones == [200, 350, 500, 700, 900, 1000, 0])
        #expect(bayati.tonica == 200)
        #expect(bayati.marcas.map(\.rotulo) == ["Re", "Mi𝄳", "Fa", "Sol", "La", "Si♭", "Do"])
        // Solo el Mi𝄳 se aparta de su nota temperada, el Mi♭.
        #expect(bayati.marcas.compactMap(\.temperada) == [300])
        // Las 24 rayitas de los cuartos de tono, cada 50 cents.
        #expect(bayati.divisiones.count == 24 && bayati.divisiones.first == 0 && bayati.divisiones[1] == 50)
        // Sīkāh empieza en Mi𝄳: la tónica también es un microtono.
        let sikah = try #require(RelojDeAlturas(escala: Escala(.mi, .sikah)))
        #expect(sikah.tonica == 350 && sikah.posiciones.first == 350)
        // Sin microtonos, no hay reloj.
        #expect(RelojDeAlturas(escala: Escala("Do mayor")) == nil)
    }

    @Test func sistemas() throws {
        // En las 53 comas, las rayitas empiezan en la tónica temperada: en Sol Rast, a 700 cents de Do.
        let rast = try #require(RelojDeAlturas(escala: Escala(.sol, .rastMakami)))
        #expect(rast.divisiones.count == 53 && rast.divisiones.contains(700))
        #expect(rast.marcas.map(\.rotulo) == ["Sol", "La", "Si⁻¹", "Do", "Re", "Mi", "Fa♯⁻¹"])
        let si = rast.marcas[2]
        #expect(abs(si.cents - (700 + 17 * 1200 / 53.0)) < 1e-9 && si.temperada == 1100)
        // Los echoi, en los 72 moria o, con la afinación de Chrysanthos, en cents cualesquiera, sin rayitas.
        let protos = Escala(.re, .echosProtos)
        #expect(try #require(RelojDeAlturas(escala: protos)).divisiones.count == 72)
        let chrysanthos = try #require(
            RelojDeAlturas(escala: protos, afinacion: TipoDeEscala.echosProtos.afinaciones[1]))
        #expect(chrysanthos.divisiones.isEmpty && chrysanthos.marcas[1].rotulo == "Mi(−29¢)")
        #expect(RelojDeAlturas.divisiones(de: .sruti).count == 22)
        // En otra notación, los nombres de esa notación.
        let ingles = try #require(RelojDeAlturas(escala: Escala(.re, .bayati), notacion: .ascii(.ingles)))
        #expect(ingles.marcas[1].rotulo == "Eqb")
    }

    @Test func marcas() {
        // Los cents se reducen a una octava, y una nota que no se aparta no lleva arquito.
        let marca = RelojDeAlturas.Marca(cents: 1250, temperada: 50, rotulo: "Do𝄲")
        #expect(marca.cents == 50 && marca.temperada == nil)
        #expect(RelojDeAlturas.Marca(cents: -50, temperada: 0, rotulo: "Do𝄳").cents == 1150)
        let reloj = RelojDeAlturas(marcas: [marca], tonica: 1250, divisiones: [0, 600, 1200, -600])
        #expect(reloj.tonica == 50 && reloj.divisiones == [0, 600])
        #expect(RelojDeAlturas.diferencia(1150, 50) == 100 && RelojDeAlturas.diferencia(50, 1150) == -100)
    }

    @Test func dibujo() throws {
        let reloj = try #require(RelojDeAlturas(escala: Escala(.re, .bayati)))
        let svg = reloj.svg(opciones: .init(titulo: "Re Bayātī"))
        #expect(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"))
        // El círculo, las doce horas y las siete notas; las 24 rayitas y un solo arquito, el del Mi𝄳.
        #expect(svg.components(separatedBy: "<circle").count == 21)
        #expect(svg.components(separatedBy: "<line").count - 1 == 24)
        #expect(svg.components(separatedBy: "<path").count - 1 == 1)
        #expect(svg.contains("<polygon") && svg.contains(">Mi𝄳</text>") && svg.contains(">Fa♯</text>"))
        #expect(svg.contains("<title>Re Bayātī</title>") && svg.contains(DibujoSVG.Color.primera))
        // Sin nombres, las horas llevan su número; sin título, no hay cabecera.
        let numeros = reloj.svg(opciones: .init(nombresDeLasNotas: false))
        #expect(numeros.contains(">7</text>") && !numeros.contains("<title>"))
        #expect(numeros.contains("width=\"280"))
        let doble = reloj.svg(opciones: .init(escala: 2))
        #expect(doble.contains("width=\"560"))
        // Una sola nota no hace polígono.
        let sola = RelojDeAlturas(marcas: [.init(cents: 350, rotulo: "Mi𝄳")]).svg()
        #expect(!sola.contains("<polygon") && !sola.contains("<path"))
    }
}
