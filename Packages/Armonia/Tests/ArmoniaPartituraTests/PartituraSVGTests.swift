import Foundation
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

/// La partitura en SVG: con un pentagrama, como su voz; con varios, como un sistema.
@Suite struct PartituraSVGTests {
    private func veces(_ glifo: Glifo, en svg: String) -> Int {
        svg.components(separatedBy: "d=\"\(glifo.trazado)\"").count - 1
    }

    @Test func unaVozEsSuPentagrama() throws {
        let voz = try Voz(leyendo: "Do4:4 Mi4:4 Sol4:2")
        let partitura = Partitura(
            pentagramas: [
                .init(voces: [.init(voz, cifrados: [.cero: Acorde("Do")], analisis: [:])]), .init(voces: []),
            ],
            encabezado: Encabezado(titulo: "Do"))
        #expect(partitura.svg() == voz.svgPentagrama(titulo: "Do", acordes: [0: Acorde("Do")]))
        // Sin título, el de la parte; con tonalidad, su armadura.
        let enRe = Partitura(
            pentagramas: [.init(clave: .fa, voces: [.init(voz)])],
            encabezado: Encabezado(tonalidad: Tonalidad(.re), parte: "Bajo"))
        var opciones = OpcionesDePentagrama(clave: .fa)
        opciones.armadura = .tonalidad(Tonalidad(.re))
        #expect(enRe.svg() == voz.svgPentagrama(titulo: "Bajo", opciones: opciones))
    }

    @Test func dosVocesEnUnPentagrama() throws {
        let soprano = try Voz(leyendo: "Mi5:2 Re5:2")
        let contralto = try Voz(leyendo: "Do5:2 Si4:2")
        let partitura = Partitura(pentagramas: [.init(voces: [.init(soprano), .init(contralto)])])
        #expect(partitura.svg() == soprano.svgPentagrama(junto: contralto, titulo: "Voz"))
    }

    @Test func variosPentagramasSonUnSistema() throws {
        let derecha = try Voz(leyendo: "Mi5:4 Re5:4 Do5:2")
        let izquierda = try Voz(leyendo: "Do3:2 Sol2:2")
        let piano = Partitura(
            pentagramas: [.init(clave: .sol, voces: [.init(derecha)]), .init(clave: .fa, voces: [.init(izquierda)])],
            encabezado: Encabezado(titulo: "Piano"), llave: true)
        let svg = piano.svg()
        #expect(svg == Voz.svgSistema([[derecha], [izquierda]], titulo: "Piano", claves: [.sol, .fa], llave: true))
        #expect(veces(GlifosSMuFL.llave, en: svg) == 1)
        // El análisis va debajo de la nota en que empieza.
        let analizado = try #require(Tonalidad(.do).analizar([Acorde("Do"), Acorde("Sol")]).acordes.last)
        let conGrado = Partitura(pentagramas: [.init(voces: [.init(izquierda, analisis: [.blanca: analizado])])])
        #expect(conGrado.svg() == izquierda.svgPentagrama(titulo: "Voz", grados: [1: analizado.cifrado]))
    }
}
