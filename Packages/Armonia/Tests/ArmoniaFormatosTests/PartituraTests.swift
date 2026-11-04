import Foundation
import Testing

@testable import ArmoniaFormatos
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

/// La partitura única: la de cada tipo da lo mismo que sus funciones de siempre, en todos los formatos, y una hecha a
/// mano se escribe en todos.
@Suite struct PartituraTests {
    private let voz = try! Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
    private let coral = try! Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
    private let progresion = try! AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")

    @Test func laDeUnaVoz() {
        let partitura = voz.partitura(encabezado: Encabezado(titulo: "Escala", tempo: Tempo(90)))
        #expect(partitura.parte == "Voz" && partitura.instrumento == 0)
        #expect(partitura.encabezado.tonalidad != nil && partitura.compas == voz.compas)
        #expect(voz.partitura(clave: .fa).pentagramas[0].claveEscrita == .fa)
        let flauta = voz.partitura(encabezado: Encabezado(parte: "Flauta", instrumento: 73))
        #expect(flauta.parte == "Flauta" && flauta.instrumento == 73)
        #expect(flauta.musicXML().contains("<part-name>Flauta</part-name>"))
    }

    @Test func laDeUnCoral() {
        let partitura = coral.partitura(duracion: .blanca, cifrados: true, analisis: true)
        #expect(partitura.parte == "Coro" && partitura.instrumento == 52)
        #expect(partitura.pentagramas.map(\.claveEscrita) == [.sol, .fa])
        #expect(partitura.lineas.count == 4 && partitura.tonalidadDelAnalisis != nil)
        #expect(!partitura.lineas[0].linea.cifrados.isEmpty && !partitura.lineas[3].linea.analisis.isEmpty)
        let piano = coral.partitura(encabezado: Encabezado(parte: "Piano", instrumento: 0))
        #expect(piano.parte == "Piano" && piano.instrumento == 0 && piano.tonalidadDelAnalisis == nil)
    }

    @Test func laDeUnaProgresion() throws {
        let partitura = progresion.partitura(duracion: .blanca)
        #expect(partitura.llave && partitura.parte == "Piano" && partitura.instrumento == 0)
        #expect(partitura.encabezado.tonalidad == progresion.tonalidad)
        #expect(progresion.partitura().lineas.allSatisfy { !$0.linea.marcadores.isEmpty || $0.pentagrama == 2 })
        let sinNada = progresion.partitura(cifrados: false, analisis: false)
        #expect(sinNada.tonalidadDelAnalisis == nil)
    }

    @Test func laDeUnContrapunto() throws {
        let ejercicio = try Contrapunto(
            cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "La4 La4 Sol4 Fa4", especie: .primera)
        let partitura = ejercicio.partitura(encabezado: Encabezado(titulo: "Fux"))
        #expect(partitura.encabezado.parte == "Contrapunctus · Cantus firmus" && partitura.instrumento == 52)
        #expect(partitura.lineas.count == 2 && partitura.encabezado.titulo == "Fux")
    }

    /// Un coral a cuatro voces en SVG: soprano y contralto en el de sol, tenor y bajo en el de fa.
    @Test func elCoralEnDosPentagramas() throws {
        func veces(_ glifo: Glifo, en svg: String) -> Int { svg.components(separatedBy: glifo.trazado).count - 1 }
        func contar(_ texto: String, en svg: String) -> Int { svg.components(separatedBy: texto).count - 1 }
        let coral = try Coral(leyendo: "Do3 Sol3 Mi4 Do5 | Sol2 Sol3 Re4 Si4 | Do3 Sol3 Mi4 Do5")
        let svg = coral.partitura(duracion: .blanca, encabezado: Encabezado(titulo: "Cadencia")).svg()
        // El último acorde, alargado hasta la barra: una redonda en cada voz.
        #expect(veces(GlifosSMuFL.blanca, en: svg) == 8 && veces(GlifosSMuFL.redonda, en: svg) == 4)
        #expect(veces(GlifosSMuFL.claveDeSol, en: svg) == 1 && veces(GlifosSMuFL.claveDeFa, en: svg) == 1)
        #expect(contar("stroke-width=\"0.13\"", en: svg) == 10)
        #expect(svg.contains("<title>Sol₂</title>") && svg.contains("<title>Si₄</title>"))
        var lineas = OpcionesDePentagrama()
        lineas.compasesPorLinea = 1
        let partido = coral.partitura(duracion: .redonda).svg(opciones: lineas)
        #expect(contar("stroke-width=\"0.13\"", en: partido) == 30)
    }

    /// El último acorde de un coral se alarga hasta la barra también en MIDI: cuatro negras en 3/4 suenan seis.
    @Test func elUltimoAcordeLlegaALaBarra() throws {
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let pieza = try PiezaImportada(midi: coral.partitura(compas: "3/4").midi())
        #expect(pieza.duracion == .blanca * 3)
    }

    /// Una partitura hecha a mano: dos pentagramas, el de arriba con dos voces, en todos los formatos.
    @Test func unaPartituraHechaAMano() throws {
        let soprano = try Voz(leyendo: "Mi5:2 Re5:2")
        let contralto = try Voz(leyendo: "Do5:2 Si4:2")
        let bajo = try Voz(leyendo: "Do3:2 Sol2:2")
        let partitura = Partitura(
            pentagramas: [
                .init(
                    clave: .sol,
                    voces: [
                        .init(soprano, nombre: "Soprano", plicaArriba: true, cifrados: [.cero: Acorde("Do")]),
                        .init(contralto, nombre: "Contralto", plicaArriba: false),
                    ]),
                .init(voces: [.init(bajo, nombre: "Bajo", marcadores: [.blanca: "V"])]),
            ],
            encabezado: Encabezado(titulo: "Tres voces", tonalidad: Tonalidad(.do), tempo: Tempo(60)))
        #expect(partitura.compas == .compasillo && partitura.anacrusa == .cero)
        #expect(partitura.lineas.map(\.pentagrama) == [1, 1, 2])
        #expect(partitura.pentagramas[1].claveEscrita == .fa)
        let xml = partitura.musicXML()
        #expect(xml.contains("<staves>2</staves>") && xml.contains("<work-title>Tres voces</work-title>"))
        #expect(xml.contains("<stem>up</stem>") && xml.contains("<harmony"))
        #expect(partitura.mei().contains("<staffDef"))
        #expect(partitura.lilyPond().contains("\\new PianoStaff"))
        #expect(partitura.guido().hasPrefix("{"))
        #expect(partitura.abc().contains("T:Tres voces"))
        let pieza = try PiezaImportada(midi: partitura.midi())
        #expect(pieza.notas.count == 6 && pieza.titulo == "Tres voces")
        #expect(Set(pieza.notas.map(\.parte)).count == 3)
        // El marcador del bajo («V»), como metaevento 0x06.
        let bytes = [UInt8](partitura.midi())
        #expect(bytes.indices.dropLast(3).contains { Array(bytes[$0...($0 + 3)]) == [0xFF, 0x06, 0x01, 0x56] })
    }
}
