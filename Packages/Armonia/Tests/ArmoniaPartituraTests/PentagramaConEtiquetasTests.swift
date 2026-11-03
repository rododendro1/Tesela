import Foundation
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

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
        let svg = DisposicionDeAcorde.svgPentagrama(voces, titulo: "ii–V–I", cifrados: acordes)
        #expect(["Rem7", "Sol7", "Domaj7"].allSatisfy { svg.contains(">\($0)</text>") })
        let sinCifrados = DisposicionDeAcorde.svgPentagrama(voces, titulo: "ii–V–I")
        #expect(!sinCifrados.contains(">Rem7</text>"))
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
        opciones.intervalosDeLasNotas = true
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
        opciones.marcarSemitonos = true
        let arcos = contar("Q", en: Escala(.do).svgPentagrama(opciones: opciones)) - contar("Q", en: sinArcos)
        #expect(arcos == 2)
        let dos = Escala(.do).svgPentagrama(octavas: 2, opciones: opciones)
        #expect(contar("Q", en: dos) - contar("Q", en: Escala(.do).svgPentagrama(octavas: 2)) == 4)
    }

    /// La tónica, en color en cada octava; la nota resaltada (la que suena) manda sobre ella.
    @Test func laTonicaEnColor() {
        var opciones = OpcionesDePentagrama()
        opciones.marcarTonica = true
        #expect(contar("fill=\"#1971C2\"", en: Escala(.do).svgPentagrama(opciones: opciones)) == 2)
        #expect(contar("fill=\"#1971C2\"", en: Escala(.do).svgPentagrama()) == 0)
        opciones.resaltada = 0
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
        let svg = DisposicionDeAcorde.svgPentagrama(voces, titulo: "ii–V–I", cifrados: acordes, grados: grados)
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
        // Do Mi Sol en la guitarra: 5.ª cuerda, traste 3; 4.ª, 2; 3.ª, al aire.
        let tablatura = Tablatura(
            cuerdas: 6,
            notas: [
                0: [.init(cuerda: 4, traste: 3)], 1: [.init(cuerda: 3, traste: 2)], 2: [.init(cuerda: 2, traste: 0)],
            ])
        let alturas = [Altura("Do4"), Altura("Mi4"), Altura("Sol4")]
        let svg = Acorde("Do").svgPentagrama(arpegiadoEn: alturas, tablatura: tablatura)
        #expect(svg.contains(">T</text>") && svg.contains(">A</text>") && svg.contains(">B</text>"))
        #expect(svg.contains(">3</text>") && svg.contains(">2</text>") && svg.contains(">0</text>"))
        // Cinco staff lines + seis cuerdas, tres de ellas cortadas en dos.
        #expect(contar("stroke-width=\"0.13\"", en: svg) == 5 + 6 + 3)
        #expect(svg.contains(">Do</text>"))
        // La♯3 del mástil se escribe Si♭3 en Do7.
        let do7 = Acorde("Do7").svgPentagrama(arpegiadoEn: [Altura("Do3"), Altura("La♯3")], figura: .corchea)
        #expect(do7.contains("<title>Si♭₃</title>") && !do7.contains("La♯"))
        #expect(Altura.reescritas([Altura("Re♯4")], con: Escala("Do menor").notas) == [Altura("Mi♭4")])
        let tocada = Escala("Fa mayor").svgPentagrama(tocadaEn: [Altura("La♯4")], digitos: [0: [2]])
        #expect(tocada.contains("<title>Si♭₄</title>") && tocada.contains(">2</text>"))
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
        let svg = DisposicionDeAcorde.svgPentagrama(voces, titulo: "I–V65–I", bajoCifrado: cifras)
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
        #expect(!DisposicionDeAcorde.svgPentagrama(voces, titulo: "I–V–I").contains(">6</text>"))
    }

    /// Do mayor en tres octavas desde Do2, en un solo pentagrama: empieza en clave de fa y pasa a la de sol, más
    /// pequeña, delante de la nota; sin cambios de clave, lleva la marca de octava.
    @Test func losCambiosDeClave() {
        var opciones = OpcionesDePentagrama(pentagramas: .simple)
        opciones.cambiosDeClave = true
        let svg = Escala(.do).svgPentagrama(octava: 2, octavas: 3, sentido: .ascendente, opciones: opciones)
        #expect(contar("d=\"\(GlifosSMuFL.claveDeFa.trazado)\"", en: svg) == 1)
        #expect(contar("d=\"\(GlifosSMuFL.claveDeSol.trazado)\"", en: svg) == 1)
        #expect(svg.contains("scale(0.75)"))
        #expect(!svg.contains("8va") && !svg.contains("8vb"))
        let sinCambios = Escala(.do).svgPentagrama(
            octava: 2, octavas: 3, sentido: .ascendente, opciones: OpcionesDePentagrama(pentagramas: .simple))
        #expect(!sinCambios.contains("scale(0.75)"))
        // En el pentagrama doble no hay cambios.
        opciones.pentagramas = .doble
        #expect(!Escala(.do).svgPentagrama(octava: 2, octavas: 3, opciones: opciones).contains("scale(0.75)"))
        #expect(PentagramaSVG.clavesPorRegistro([[Altura("Do2")], [Altura("Do6")]], desde: .fa) == [.fa, .sol])
    }

    /// Sobre Do, el Re es una nota de paso (verde) y el Re♯, en Do mayor, cromática (roja); las del acorde, sin color.
    @Test func lasNotasAjenasAlAcorde() throws {
        let voz = try Voz(leyendo: "Mi4:8 Re4:8 Do4:8 Re♯4:8 Mi4:2")
        var opciones = OpcionesDePentagrama(armadura: .tonalidad(Tonalidad(.do)))
        opciones.marcarNotasAjenas = true
        let svg = voz.svgPentagrama(titulo: "Do", acordes: [0: Acorde("Do")], opciones: opciones)
        #expect(contar("fill=\"#2F9E44\"", en: svg) == 1)
        #expect(contar("fill=\"#C2255C\"", en: svg) == 1)
        // Sin tonalidad, todas las ajenas son de paso; sin acorde, ninguna.
        var sinTonalidad = OpcionesDePentagrama()
        sinTonalidad.marcarNotasAjenas = true
        let sinColorCromatico = voz.svgPentagrama(titulo: "Do", acordes: [0: Acorde("Do")], opciones: sinTonalidad)
        #expect(contar("fill=\"#2F9E44\"", en: sinColorCromatico) == 2)
        #expect(!voz.svgPentagrama(titulo: "Do", opciones: sinTonalidad).contains("#2F9E44"))
    }
}
