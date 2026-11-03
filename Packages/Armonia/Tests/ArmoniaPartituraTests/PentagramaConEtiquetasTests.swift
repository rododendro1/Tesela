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
