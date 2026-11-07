import Foundation
import Testing

@testable import Elementos
@testable import Partituras
@testable import Teoria

/// Lo que se escribe alrededor de las notas: el cifrado de cada acorde, los intervalos, los semitonos y la tónica.
@Suite struct PentagramaConEtiquetasTests {
    private func contar(_ trozo: String, en texto: String) -> Int {
        texto.components(separatedBy: trozo).count - 1
    }

    // MARK: Varias octavas

    /// Re dórico en dos octavas sube de Re4 a Re6 (quince notas); bajando, vuelve a la tónica.
    @Test func laEscalaEnVariasOctavas() {
        let escala = Escala("Re dórico")
        let subida = escala.alturasMicrotonales(octava: 4, octavas: 2, sentido: .ascendente)
        #expect(subida.count == 15)
        #expect(subida.first?.altura == Altura("Re4") && subida.last?.altura == Altura("Re6"))
        let bajada = escala.alturasMicrotonales(octava: 4, octavas: 2, sentido: .descendente)
        #expect(bajada.map(\.altura) == subida.map(\.altura).reversed())
        #expect(contar("<g><title>", en: escala.svgPentagrama(octavas: 2)) == 15)
        #expect(escala.voz(octavas: 3).eventos.count == 22)
    }

    // MARK: Cifrado

    /// En una progresión, cada acorde lleva su cifrado encima; sin cifrados, ninguno.
    @Test func lasDisposicionesLlevanSuCifrado() {
        let acordes = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
        let voces = DisposicionDeAcorde.drop2.conducir(acordes) ?? []
        let svg = Partitura(acordes: voces, titulo: "ii–V–I", porEvento: .init(cifrados: .enOrden(acordes))).svg()
        #expect(["Rem7", "Sol7", "Domaj7"].allSatisfy { svg.contains(">\($0)</text>") })
        let sinCifrados = Partitura(acordes: voces, titulo: "ii–V–I").svg()
        #expect(!sinCifrados.contains(">Rem7</text>"))
    }

    /// Los acordes de una progresión son una partitura de redondas sin ritmo: con ritmo, la misma voz se dibuja de
    /// otra forma, y los formatos la escriben igual.
    @Test func losAcordesSonUnaPartituraSinRitmo() {
        let acordes = [Acorde("Do"), Acorde("Sol7")]
        let voces = DisposicionDeAcorde.cerrada.conducir(acordes) ?? []
        let partitura = Partitura(acordes: voces, titulo: "I–V7", porEvento: .init(cifrados: .enOrden(acordes)))
        #expect(!partitura.dibujaElRitmo)
        let voz = partitura.pentagramas[0].voces[0]
        #expect(voz.voz.eventos.map(\.alturas) == voces)
        #expect(voz.voz.eventos.allSatisfy { $0.duracion == .redonda })
        #expect(voz.cifrados == [.cero: acordes[0], .redonda: acordes[1]])
        var conRitmo = partitura
        conRitmo.dibujaElRitmo = true
        #expect(conRitmo.svg() != partitura.svg())
        #expect(partitura.svg().contains(">Sol7</text>"))
    }

    /// Una progresión arpegiada lleva el cifrado de cada acorde encima de la primera nota de su arpegio, y el
    /// arpegio suelto, con `cifrado`, el suyo.
    @Test func losArpegiosLlevanSuCifrado() {
        let acordes = [Acorde("Do"), Acorde("Fa")]
        let voz = Voz(arpegiando: acordes, patron: .alberti)
        let svg = voz.svgPentagrama(titulo: "Alberti", acordes: [0: acordes[0], 4: acordes[1]])
        #expect(svg.contains(">Do</text>") && svg.contains(">Fa</text>"))
        #expect(Arpegio(Acorde("Do7")).svgPentagrama(cifrado: true).contains(">Do7</text>"))
        #expect(!Arpegio(Acorde("Do7")).svgPentagrama().contains(">Do7</text>"))
    }

    // MARK: Intervalos

    /// Los intervalos se cuentan desde la tónica de la escala, desde la fundamental del acorde (con 9, 11 y 13 si
    /// tiene séptima) o desde la del acorde que suena.
    @Test func losIntervalosDeLasNotas() {
        var opciones = OpcionesDePentagrama()
        opciones.marcas.intervalosDeLasNotas = true
        let dorico = Escala("Re dórico").svgPentagrama(opciones: opciones)
        for intervalo in ["1", "2", "♭3", "4", "5", "6", "♭7"] {
            #expect(dorico.contains(">\(intervalo)</text>"), Comment(rawValue: intervalo))
        }
        #expect(Acorde("Sol9").svgPentagrama(opciones: opciones).contains(">1 3 5 ♭7 9</text>"))
        #expect(!Escala("Re dórico").svgPentagrama().contains(">♭3</text>"))
    }

    // MARK: Semitonos y tónica

    /// Do mayor tiene dos semitonos (Mi–Fa, Si–Do), y cada uno lleva su arco; Do mayor en dos octavas, cuatro.
    @Test func losSemitonosLlevanUnArco() {
        var opciones = OpcionesDePentagrama()
        let sinArcos = Escala(.do).svgPentagrama(opciones: opciones)
        opciones.marcas.semitonos = true
        let arcos = contar("Q", en: Escala(.do).svgPentagrama(opciones: opciones)) - contar("Q", en: sinArcos)
        #expect(arcos == 2)
        let dos = Escala(.do).svgPentagrama(octavas: 2, opciones: opciones)
        #expect(contar("Q", en: dos) - contar("Q", en: Escala(.do).svgPentagrama(octavas: 2)) == 4)
    }

    /// La tónica, en color en cada octava; la nota resaltada (la que suena) manda sobre ella.
    @Test func laTonicaEnColor() {
        var opciones = OpcionesDePentagrama()
        opciones.marcas.tonica = true
        #expect(contar("fill=\"#1971C2\"", en: Escala(.do).svgPentagrama(opciones: opciones)) == 2)
        #expect(contar("fill=\"#1971C2\"", en: Escala(.do).svgPentagrama()) == 0)
        opciones.marcas.resaltada = 0
        let resaltada = Escala(.do).svgPentagrama(opciones: opciones)
        #expect(contar("fill=\"#1971C2\"", en: resaltada) == 1)
        #expect(contar("fill=\"#E8590C\"", en: resaltada) == 1)
    }
}

/// Los grados en números romanos, los dedos, las secuencias con ritmo y la tablatura.
@Suite struct PentagramaParaEstudiarTests {
    private func contar(_ trozo: String, en texto: String) -> Int {
        texto.components(separatedBy: trozo).count - 1
    }

    /// Cada acorde de una progresión lleva su grado debajo, en las disposiciones y en una voz arpegiada.
    @Test func losGradosEnNumerosRomanos() {
        let acordes = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
        let voces = DisposicionDeAcorde.drop2.conducir(acordes) ?? []
        let grados = Tonalidad(.do).analizar(acordes).cifrados
        #expect(grados == ["ii7", "V7", "Imaj7"])
        let svg = Partitura(
            acordes: voces, titulo: "ii–V–I", porEvento: .init(cifrados: .enOrden(acordes), grados: .enOrden(grados))
        ).svg()
        #expect(grados.allSatisfy { svg.contains(">\($0)</text>") })
        let voz = Voz(arpegiando: [Acorde("Do"), Acorde("Sol")])
        let arpegiada = voz.svgPentagrama(titulo: "I–V", grados: [0: "I", 4: "V"])
        #expect(arpegiada.contains(">I</text>") && arpegiada.contains(">V</text>"))
        #expect(!Escala(.do).svgPentagrama().contains(">I</text>"))
    }

    /// Re mayor con la mano derecha: los dedos de `digitacionDePiano` encima de cada nota, y al bajar, al revés.
    @Test func losDedosDelPiano() {
        let escala = Escala(.re)
        let svg = escala.svgPentagrama(digitacion: .derecha)
        let dedos = escala.digitacionDePiano(.derecha).dedos
        #expect(dedos == [1, 2, 3, 1, 2, 3, 4, 5])
        for dedo in Set(dedos) { #expect(contar(">\(dedo)</text>", en: svg) == dedos.filter { $0 == dedo }.count) }
        let bajando = escala.svgPentagrama(sentido: .descendente, digitacion: .derecha)
        #expect(contar(">5</text>", en: bajando) == 1)
        #expect(!escala.svgPentagrama().contains(">5</text>"))
    }

    /// Por terceras en corcheas (con la armadura de la escala), en grupos de tres en tresillos y de cuatro en
    /// semicorcheas; la última nota es una negra.
    @Test func lasSecuenciasConRitmo() {
        let terceras = Escala(.re).svgPentagrama(secuencia: .terceras)
        #expect(contar("d=\"\(GlifosSMuFL.sostenido.trazado)\"", en: terceras) == 2) // la armadura
        #expect(contar("d=\"\(GlifosSMuFL.cifraDeCompas4.trazado)\"", en: terceras) == 2)
        #expect(terceras.contains(">Re mayor · por terceras</title>"))
        #expect(Escala.figura(deGruposDe: 2) == .corchea)
        #expect(Escala.figura(deGruposDe: 3) == Duracion.corchea.grupoIrregular(3, en: 2))
        #expect(Escala.figura(deGruposDe: 4) == .semicorchea)
        let tresillos = Escala(.do).svgPentagrama(secuencia: .gruposDeTres)
        #expect(contar("d=\"\(GlifosSMuFL.cifraDeTresillo.trazado)\"", en: tresillos) == 7)
    }

    /// La tablatura va debajo, con una línea por cuerda (cortada alrededor de cada número), «TAB» y el traste de
    /// cada nota; las notas que da el mástil se escriben con las de la escala o el acorde.
    @Test func laTablatura() {
        // Do Mi Sol en la guitarra: 5.ª cuerda (la 1 desde la grave), traste 3; 4.ª, 2; 3.ª, al aire.
        let tablatura = Tablatura(
            numeroDeCuerdas: 6,
            pulsaciones: [
                0: [.init(cuerda: 1, traste: 3)], 1: [.init(cuerda: 2, traste: 2)], 2: [.init(cuerda: 3, traste: 0)],
            ])
        let alturas = [Altura("Do4"), Altura("Mi4"), Altura("Sol4")]
        let svg = Acorde("Do").svgPentagrama(arpegiadoEn: alturas, tablatura: tablatura)
        #expect(svg.contains(">T</text>") && svg.contains(">A</text>") && svg.contains(">B</text>"))
        #expect(svg.contains(">3</text>") && svg.contains(">2</text>") && svg.contains(">0</text>"))
        // Cinco staff lines + seis cuerdas, tres de ellas cortadas en dos.
        #expect(contar("stroke-width=\"0.13\"", en: svg) == 5 + 6 + 3)
        #expect(svg.contains(">Do</text>"))
        // La♯3 del mástil se escribe Si♭3 en Do7.
        let do7 = Acorde("Do7").svgPentagrama(
            arpegiadoEn: [Altura("Do3"), Altura("La♯3")], ritmo: .uniforme(.corchea))
        #expect(do7.contains("<title>Si♭₃</title>") && !do7.contains("La♯"))
        #expect(Altura.reescritas([Altura("Re♯4")], con: Escala("Do menor").notas) == [Altura("Mi♭4")])
        let tocada = Escala("Fa mayor").svgPentagrama(tocadaEn: [Altura("La♯4")], porEvento: .init(dedos: [0: [2]]))
        #expect(tocada.contains("<title>Si♭₄</title>") && tocada.contains(">2</text>"))
    }

    /// Lo que se toca en el mástil es una partitura: con su armadura, su tónica y lo de cada nota por su inicio.
    @Test func loTocadoEsUnaPartitura() {
        let alturas = [Altura("Re4"), Altura("Mi4"), Altura("Fa♯4")]
        let escala = Escala("Re dórico")
        let partitura = escala.partitura(tocadaEn: alturas, porEvento: .init(dedos: [1: [3]]))
        #expect(!partitura.dibujaElRitmo)
        #expect(partitura.encabezado.titulo == nil && partitura.encabezado.tema == .escala(escala))
        #expect(partitura.encabezado.titulo(en: .espanolCompacto) == escala.nombre(en: .espanolCompacto))
        #expect(partitura.pentagramas[0].armadura == escala.notasDeLaArmadura)
        let linea = partitura.pentagramas[0].voces[0]
        #expect(linea.tonica == escala.tonica)
        #expect(linea.dedos == [.redonda: [3]])
        #expect(partitura.svg() == escala.svgPentagrama(tocadaEn: alturas, porEvento: .init(dedos: [1: [3]])))
        let conRitmo = escala.partitura(tocadaEn: alturas, ritmo: .uniforme(.corchea))
        #expect(conRitmo.dibujaElRitmo)
        #expect(conRitmo.pentagramas[0].voces[0].voz.eventos.map(\.duracion) == [.corchea, .corchea, .negra])
        let arpegio = Acorde("Re7").partitura(arpegiadoEn: alturas)
        #expect(arpegio.pentagramas[0].voces[0].cifrados == [.cero: Acorde("Re7")])
        #expect(arpegio.svg() == Acorde("Re7").svgPentagrama(arpegiadoEn: alturas))
    }

    /// La notación de la partitura vale también al dibujarla, salvo que las opciones fijen otra; y el título que se
    /// nombra por lo que se toca la sigue.
    @Test func laNotacionDeLaPartitura() {
        let escala = Escala("Re dórico")
        var partitura = escala.partitura(tocadaEn: [Altura("Re4"), Altura("Mi4")])
        let enIngles = escala.nombre(en: .inglesASCII)
        #expect(enIngles != escala.nombre(en: .espanolCompacto))
        #expect(partitura.encabezado.titulo(en: .inglesASCII) == enIngles)
        // Las opciones mandan si fijan una; si no, la de la partitura.
        #expect(partitura.svg(opciones: .init(notacion: .inglesASCII)).contains(enIngles))
        #expect(!partitura.svg().contains(enIngles))
        partitura.notacion = .inglesASCII
        #expect(partitura.svg().contains(enIngles))
        #expect(partitura.svg() == partitura.svg(opciones: .init(notacion: .inglesASCII)))
        let tocada = escala.svgPentagrama(tocadaEn: [Altura("Re4")], opciones: .init(notacion: .inglesASCII))
        #expect(tocada.contains(enIngles))
        // Un título escrito a mano se queda como está.
        partitura.encabezado.titulo = "Mi escala"
        #expect(partitura.encabezado.titulo(en: .inglesASCII) == "Mi escala")
        // Sin notación fijada, las opciones dibujan en español compacto lo que no es una partitura.
        #expect(OpcionesDePentagrama().notacionFijada == nil && OpcionesDePentagrama().notacion == .espanolCompacto)
        var opciones = OpcionesDePentagrama()
        opciones.notacion = .inglesASCII
        #expect(opciones.notacionFijada == .inglesASCII)
        // El acorde arpegiado, con su cifrado en la notación de la partitura.
        var arpegio = Acorde("Re7").partitura(arpegiadoEn: [Altura("Re4")])
        #expect(arpegio.encabezado.tema == .acorde(Acorde("Re7")))
        arpegio.notacion = .inglesASCII
        #expect(arpegio.encabezado.titulo(en: arpegio.notacion) == Acorde("Re7").cifrado(en: .inglesASCII))
    }

    /// La tablatura cuenta las cuerdas como el mástil, desde la más grave, y al dibujarla pone la más aguda arriba.
    @Test func lasCuerdasDeLaTablaturaYDelMastil() {
        // El Do3 de la guitarra: la cuerda 1 desde la grave (la 5.ª), traste 3, en la línea 4 desde arriba.
        let pulsacion = Tablatura.Pulsacion(cuerda: 1, traste: 3)
        #expect(pulsacion.linea(de: 6) == 4)
        let grave = Tablatura(numeroDeCuerdas: 6, pulsaciones: [0: [.init(cuerda: 0, traste: 3)]])
        let aguda = Tablatura(numeroDeCuerdas: 6, pulsaciones: [0: [.init(cuerda: 5, traste: 3)]])
        let alturas = [Altura("Sol2")]
        let abajo = Acorde("Sol").svgPentagrama(arpegiadoEn: alturas, tablatura: grave)
        let arriba = Acorde("Sol").svgPentagrama(arpegiadoEn: alturas, tablatura: aguda)
        // El traste de la cuerda grave va más abajo que el de la aguda.
        func yDelTraste(_ svg: String) -> Double? {
            guard let fin = svg.range(of: ">3</text>") else { return nil }
            let antes = svg[..<fin.lowerBound]
            guard let y = antes.range(of: " y=\"", options: .backwards) else { return nil }
            return Double(antes[y.upperBound...].prefix { $0 != "\"" })
        }
        let (yAbajo, yArriba) = (yDelTraste(abajo), yDelTraste(arriba))
        #expect(yAbajo != nil && yArriba != nil)
        if let yAbajo, let yArriba { #expect(yAbajo > yArriba) }
    }

    /// El ritmo de unas notas tocadas una tras otra: redondas sin él, la figura con él y una negra al final.
    @Test func elRitmoDeLasNotasTocadas() {
        #expect(Partitura.Ritmo.libre.uniforme == nil && Partitura.Ritmo.uniforme(.corchea).uniforme == .corchea)
        #expect((0..<3).map { Partitura.Ritmo.libre.duracion(de: $0, entre: 3) } == [.redonda, .redonda, .redonda])
        let corcheas = (0..<3).map { Partitura.Ritmo.uniforme(.corchea).duracion(de: $0, entre: 3) }
        #expect(corcheas == [.corchea, .corchea, .negra])
        #expect(Partitura.Ritmo.uniforme(.blanca).duracion(de: 1, entre: 2) == .blanca)
        #expect(Partitura.Ritmo.uniforme(.corchea).duracion(de: 0, entre: 1) == .corchea)
    }

    /// Lo que se anota nota a nota pasa a los inicios de la línea y vuelve igual.
    @Test func loQueSeAnotaNotaANota() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2")
        let porEvento = Partitura.AnotacionesPorEvento(
            cifrados: [0: Acorde("Do"), 3: Acorde("Fa")], grados: [3: "IV"], bajoCifrado: [1: ["6"]],
            dedos: [2: [3]], pulsaciones: [0: [.init(cuerda: 1, traste: 3)]])
        let linea = Partitura.Linea(voz, porEvento: porEvento)
        #expect(linea.cifrados == [.cero: Acorde("Do"), .blanca: Acorde("Fa")])
        #expect(linea.dedos == [Duracion(3, 8): [3]] && linea.bajoCifrado == [.negra: ["6"]])
        #expect(linea.porEvento == porEvento)
        // Lo que no es de ninguna nota se descarta.
        #expect(Partitura.Linea(voz, porEvento: .init(grados: [9: "V"])).grados.isEmpty)
        #expect(voz.porEvento(voz.porInicio([1: "a", 3: "b"])) == [1: "a", 3: "b"])
    }

    /// Las partituras de acordes, escalas y arpegios toman todo lo que se anota en `porEvento`, por el índice de cada
    /// nota o columna.
    @Test func porNotaEnLasPartiturasTocadas() throws {
        let columnas: [[Altura]] = [["Do4", "Mi4", "Sol4"], ["Si3", "Fa4", "Sol4"]]
        let porEvento = Partitura.AnotacionesPorEvento(
            cifrados: .enOrden([Acorde("Do"), Acorde("Sol7")]), grados: .enOrden(["I", "V7"]),
            dedos: [1: [1, 3, 5]])
        #expect(porEvento.cifrados == [0: Acorde("Do"), 1: Acorde("Sol7")] && porEvento.grados == [0: "I", 1: "V7"])
        let acordes = Partitura(acordes: columnas, porEvento: porEvento)
        let linea = acordes.pentagramas[0].voces[0]
        #expect(linea.grados == [.cero: "I", .redonda: "V7"] && linea.dedos == [.redonda: [1, 3, 5]])
        #expect(acordes.encabezado.tema == .progresion([Acorde("Do"), Acorde("Sol7")]))
        #expect(Partitura(acordes: columnas).encabezado.tema == nil)
        // El análisis.
        let analisis = try #require(Tonalidad(.do).analizar([Acorde("Do")]).acordes.first)
        let analizada = Partitura(acordes: [columnas[0]], porEvento: .init(analisis: [0: analisis]))
        #expect(analizada.pentagramas[0].voces[0].analisis == [.cero: analisis])
        // Una escala con los dedos y el grado de cada nota.
        let alturas: [Altura] = ["Do4", "Re4", "Mi4"]
        let escala = Escala(.do).partitura(
            tocadaEn: alturas, porEvento: .init(grados: [0: "I"], dedos: [0: [1], 1: [2], 2: [3]]))
        #expect(escala.pentagramas[0].voces[0].grados == [.cero: "I"])
        #expect(escala.pentagramas[0].voces[0].dedos[Duracion.redonda * 2] == [3])
        #expect(
            Escala(.do).svgPentagrama(tocadaEn: alturas, porEvento: .init(dedos: [0: [1]]))
                == Escala(.do).partitura(tocadaEn: alturas, porEvento: .init(dedos: [0: [1]])).svg())
        // Un arpegio: el cifrado del acorde va en la primera nota, salvo que `porEvento` diga otro.
        let do7 = Acorde("Do7")
        let arpegio = do7.partitura(arpegiadoEn: ["Do4", "Mi4", "Sol4", "La#4"], porEvento: .init(dedos: [3: [4]]))
        #expect(arpegio.pentagramas[0].voces[0].cifrados == [.cero: do7])
        #expect(arpegio.pentagramas[0].voces[0].dedos == [Duracion.redonda * 3: [4]])
        #expect(arpegio.pentagramas[0].voces[0].voz.eventos[3].alturas == ["Si♭4"])
        let otro = do7.partitura(arpegiadoEn: ["Do4"], porEvento: .init(cifrados: [0: Acorde("Do")]))
        #expect(otro.pentagramas[0].voces[0].cifrados == [.cero: Acorde("Do")])
        #expect(do7.svgPentagrama(arpegiadoEn: ["Do4"]) == do7.partitura(arpegiadoEn: ["Do4"]).svg())
    }

    /// Las alturas, con la ortografía de unas notas: la primera que suena igual, sin cambiar el número MIDI.
    @Test func lasAlturasReescritas() {
        #expect(Altura.reescritas(["Do4", "La#3"], con: Acorde("Do7").notas) == ["Do4", "Si♭3"])
        let siSostenido = Altura.reescritas(["Do4"], con: [Nota.si.sostenido])
        #expect(siSostenido == [Altura(Nota.si.sostenido, octava: 3)] && siSostenido[0].midi == 60)
        #expect(Altura.reescritas(["Re4"], con: [.do]) == ["Re4"])
    }
}

/// El bajo cifrado, los cambios de clave y las notas ajenas al acorde.
@Suite struct PentagramaDeArmoniaTests {
    private func contar(_ trozo: String, en texto: String) -> Int {
        texto.components(separatedBy: trozo).count - 1
    }

    /// Las cifras van debajo de su acorde, una encima de otra: el 6 por encima del 5.
    @Test func elBajoCifrado() {
        let acordes = [Acorde("Do"), Acorde("Sol7/Si"), Acorde("Do")]
        let voces = DisposicionDeAcorde.cerrada.conducir(acordes) ?? []
        let cifras = acordes.map { Tonalidad(.do).cifrasDeBajo(de: $0) }
        let svg = Partitura(acordes: voces, titulo: "I–V65–I", porEvento: .init(bajoCifrado: .enOrden(cifras))).svg()
        let seis = svg.range(of: ">6</text>")
        let cinco = svg.range(of: ">5</text>")
        #expect(seis != nil && cinco != nil)
        func y(_ rango: Range<String.Index>?) -> Double? {
            guard let rango else { return nil }
            let antes = svg[..<rango.lowerBound]
            guard let inicio = antes.range(of: " y=\"", options: .backwards) else { return nil }
            return Double(antes[inicio.upperBound...].prefix { $0 != "\"" })
        }
        #expect((y(seis) ?? 0) < (y(cinco) ?? 0))
        #expect(!Partitura(acordes: voces, titulo: "I–V–I").svg().contains(">6</text>"))
    }

    /// Do mayor en tres octavas desde Do2, en un solo pentagrama: empieza en clave de fa y pasa a la de sol, más
    /// pequeña, delante de la nota; sin cambios de clave, lleva la marca de octava.
    @Test func losCambiosDeClave() {
        var opciones = OpcionesDePentagrama(maquetacion: .init(pentagramas: .simple))
        opciones.maquetacion.cambiosDeClave = true
        let svg = Escala(.do).svgPentagrama(octava: 2, octavas: 3, sentido: .ascendente, opciones: opciones)
        #expect(contar("d=\"\(GlifosSMuFL.claveDeFa.trazado)\"", en: svg) == 1)
        #expect(contar("d=\"\(GlifosSMuFL.claveDeSol.trazado)\"", en: svg) == 1)
        #expect(svg.contains("scale(0.75)"))
        #expect(!svg.contains("8va") && !svg.contains("8vb"))
        let simple = OpcionesDePentagrama(maquetacion: .init(pentagramas: .simple))
        let sinCambios = Escala(.do).svgPentagrama(octava: 2, octavas: 3, sentido: .ascendente, opciones: simple)
        #expect(!sinCambios.contains("scale(0.75)"))
        // En el pentagrama doble no hay cambios.
        opciones.maquetacion.pentagramas = .doble
        #expect(!Escala(.do).svgPentagrama(octava: 2, octavas: 3, opciones: opciones).contains("scale(0.75)"))
        #expect(PentagramaSVG.clavesPorRegistro([[Altura("Do2")], [Altura("Do6")]], desde: .fa) == [.fa, .sol])
    }

    /// Sobre Do, el Re es una nota de paso (verde) y el Re♯, en Do mayor, cromática (roja); las del acorde, sin color.
    @Test func lasNotasAjenasAlAcorde() throws {
        let voz = try Voz(leyendo: "Mi4:8 Re4:8 Do4:8 Re♯4:8 Mi4:2")
        var opciones = OpcionesDePentagrama(armadura: .tonalidad(Tonalidad(.do)))
        opciones.marcas.notasAjenas = true
        let svg = voz.svgPentagrama(titulo: "Do", acordes: [0: Acorde("Do")], opciones: opciones)
        #expect(contar("fill=\"#2F9E44\"", en: svg) == 1)
        #expect(contar("fill=\"#C2255C\"", en: svg) == 1)
        // Sin tonalidad, todas las ajenas son de paso; sin acorde, ninguna.
        var sinTonalidad = OpcionesDePentagrama()
        sinTonalidad.marcas.notasAjenas = true
        let sinColorCromatico = voz.svgPentagrama(titulo: "Do", acordes: [0: Acorde("Do")], opciones: sinTonalidad)
        #expect(contar("fill=\"#2F9E44\"", en: sinColorCromatico) == 2)
        #expect(!voz.svgPentagrama(titulo: "Do", opciones: sinTonalidad).contains("#2F9E44"))
    }

    // MARK: Todo sale de una partitura

    /// La escala, la secuencia, el acorde y el arpegio se dibujan desde su partitura, que es la que se exporta.
    @Test func losDibujosSalenDeSuPartitura() {
        let dorico = Escala("Re dórico")
        #expect(dorico.svgPentagrama() == dorico.partitura().svg())
        let digitada = dorico.partitura(octavas: 2, digitacion: .derecha)
        #expect(dorico.svgPentagrama(octavas: 2, digitacion: .derecha) == digitada.svg())
        let partitura = dorico.partitura()
        #expect(!partitura.dibujaElRitmo && partitura.pentagramas[0].voces[0].tonica == Nota.re)
        #expect(partitura.encabezado.titulo == nil && partitura.encabezado.tema == .escala(dorico))
        // La secuencia, con su ritmo y su título en la notación con que se dibuja.
        let terceras = Escala(.do).partitura(secuencia: .terceras)
        #expect(Escala(.do).svgPentagrama(secuencia: .terceras) == terceras.svg())
        #expect(terceras.dibujaElRitmo && terceras.encabezado.tema == .secuencia(.terceras, de: Escala(.do)))
        let enIngles =
            Escala(.do).nombre(en: .inglesPalabras) + " · " + SecuenciaDeEscala.terceras.nombre(en: .inglesPalabras)
        #expect(terceras.svg(opciones: .init(notacion: .inglesPalabras)).contains(">\(enIngles)</title>"))
        // El acorde, en una redonda con su cifrado; sin él, si se pide, pero contando desde su fundamental.
        let sol7 = Acorde("Sol7/Si")
        #expect(sol7.svgPentagrama() == sol7.partitura().svg())
        #expect(sol7.partitura().pentagramas[0].voces[0].voz.eventos.count == 1)
        let sinCifrado = sol7.svgPentagrama(cifrado: false)
        #expect(sinCifrado == sol7.partitura().svg(opciones: .init(marcas: .init(cifrados: false))))
        #expect(contar(">Sol7/Si</text>", en: sol7.svgPentagrama()) == 1 && !sinCifrado.contains(">Sol7/Si</text>"))
        let extenso = Acorde("Do13♯11")
        #expect(extenso.svgPentagrama() == extenso.partitura().svg())
        let cerrada = OpcionesDePentagrama(maquetacion: .init(posicionDelAcorde: .cerrada))
        let enCerrada = extenso.partitura(posicion: .cerrada).svg(opciones: cerrada)
        #expect(extenso.svgPentagrama(opciones: cerrada) == enCerrada)
        // El arpegio, sin cifrado salvo que se pida; la partitura lo lleva.
        let alberti = Arpegio(Acorde("Do"), patron: .alberti)
        #expect(alberti.svgPentagrama() == alberti.partitura().svg(opciones: .init(marcas: .init(cifrados: false))))
        #expect(alberti.svgPentagrama(cifrado: true) == alberti.partitura().svg())
        #expect(alberti.partitura().encabezado.tema == .arpegio(alberti))
        #expect(alberti.partitura().pentagramas[0].voces[0].cifrados == [.cero: Acorde("Do")])
        #expect(alberti.svgPentagrama().contains(">\(alberti.nombre(en: .espanolCompacto))</title>"))
        // Con una figura, con ritmo: la escala y el arpegio en corcheas, la última nota en negra.
        let enCorcheas = dorico.partitura(ritmo: .uniforme(.corchea))
        let eventos = enCorcheas.pentagramas[0].voces[0].voz.eventos
        #expect(enCorcheas.dibujaElRitmo && eventos.dropLast().allSatisfy { $0.duracion == .corchea })
        #expect(eventos.last?.duracion == .negra && enCorcheas.encabezado.tema == .escala(dorico))
        let arpegio = Arpegio(Acorde("Do7")).partitura(ritmo: .uniforme(.semicorchea))
        #expect(arpegio.dibujaElRitmo && arpegio.pentagramas[0].voces[0].voz.eventos.first?.duracion == .semicorchea)
    }

    /// El título y el tamaño, en las opciones, como en los diagramas.
    @Test func elTituloYElTamanoDeLasOpciones() throws {
        let escala = Escala(.do)
        #expect(escala.svgPentagrama().contains("<title id=\"titulo\">Do mayor</title>"))
        let propio = escala.svgPentagrama(opciones: .init(titulo: "Mi <escala>"))
        #expect(propio.contains("<title id=\"titulo\">Mi &lt;escala&gt;</title>"))
        #expect(!propio.contains("Do mayor</title>"))
        let ninguno = escala.svgPentagrama(opciones: .init(titulo: ""))
        #expect(!ninguno.contains("id=\"titulo\"") && ninguno.contains("aria-labelledby=\"descripcion\""))
        func medida(_ atributo: String, _ svg: String) -> Double? {
            svg.components(separatedBy: " \(atributo)=\"").dropFirst().first?.split(separator: "\"").first
                .flatMap { Double(String($0)) }
        }
        let normal = escala.svgPentagrama()
        let doble = escala.svgPentagrama(opciones: .init(escala: 2))
        let ancho = try #require(medida("width", normal))
        let alto = try #require(medida("height", normal))
        #expect(medida("width", doble) == 2 * ancho && medida("height", doble) == 2 * alto)
        // Lo de dentro no cambia: solo el tamaño con que se muestra.
        func caja(_ svg: String) -> String? {
            svg.components(separatedBy: "viewBox=\"").dropFirst().first?.split(separator: "\"").first.map(String.init)
        }
        #expect(caja(doble) != nil && caja(doble) == caja(normal))
    }

    /// Sin título, una progresión se titula con sus cifrados, en la notación con que se dibuja.
    @Test func laProgresionSeTitulaConSusCifrados() throws {
        let acordes = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
        let voces = DisposicionDeAcorde.drop2.conducir(acordes) ?? []
        let progresion = Partitura(acordes: voces, porEvento: .init(cifrados: .enOrden(acordes)))
        #expect(progresion.encabezado.titulo == nil && progresion.encabezado.tema == .progresion(acordes))
        for notacion in [Notacion.espanolCompacto, .inglesASCII] {
            let titulo = acordes.map { $0.cifrado(en: notacion) }.joined(separator: " – ")
            #expect(progresion.encabezado.titulo(en: notacion) == titulo)
            #expect(progresion.svg(opciones: .init(notacion: notacion)).contains(">\(titulo)</title>"))
        }
        // Con título, el suyo; sin título ni cifrados, ninguno (el de la parte).
        let titulada = Partitura(acordes: voces, titulo: "ii–V–I", porEvento: .init(cifrados: .enOrden(acordes)))
        #expect(titulada.encabezado.titulo(en: .inglesASCII) == "ii–V–I")
        #expect(Partitura(acordes: voces).encabezado.titulo(en: .espanolCompacto) == nil)
        // Los temas se guardan con lo que nombran.
        let temas: [Encabezado.Tema] = [
            .progresion(acordes), .arpegio(Arpegio(Acorde("Do7"), patron: .alberti)),
            .secuencia(.terceras, de: Escala(.do)),
        ]
        for tema in temas {
            let encabezado = Encabezado(tema: tema)
            #expect(try JSONDecoder().decode(Encabezado.self, from: JSONEncoder().encode(encabezado)) == encabezado)
        }
        // Los cifrados pueden callarse en el dibujo.
        let callados = progresion.svg(opciones: .init(marcas: .init(cifrados: false)))
        #expect(!callados.contains(">Rem7</text>") && progresion.svg().contains(">Rem7</text>"))
    }
}
