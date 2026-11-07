import Foundation
import Testing

@testable import Elementos
@testable import Partituras
@testable import Teoria

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
            encabezado: Encabezado(tonalidad: Tonalidad(.re), nombreDeLaParte: "Bajo"))
        var opciones = OpcionesDePentagrama(maquetacion: .init(clave: .fa))
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

    /// Lo que se anota en una voz sola: grados, bajo cifrado, dedos y, con cuerdas, la tablatura.
    @Test func loQueSeAnotaEnUnaVoz() throws {
        let voz = try Voz(leyendo: "Do3:4 Mi3:4 Sol3:2")
        let pulsaciones: [Int: [Tablatura.Pulsacion]] = [
            0: [.init(cuerda: 1, traste: 3)], 2: [.init(cuerda: 3, traste: 0)],
        ]
        let linea = Partitura.Linea(
            voz, grados: [.cero: "I"], bajoCifrado: [.negra: ["6"]], dedos: [.blanca: [1]],
            pulsaciones: voz.porInicio(pulsaciones))
        let partitura = Partitura(linea, numeroDeCuerdas: 6, encabezado: Encabezado(titulo: "Do"))
        let aMano = voz.svgPentagrama(
            titulo: "Do", grados: [0: "I"], bajoCifrado: [1: ["6"]], dedos: [2: [1]],
            tablatura: Tablatura(numeroDeCuerdas: 6, pulsaciones: pulsaciones))
        #expect(partitura.svg() == aMano)
        #expect(partitura.pentagramas[0].numeroDeCuerdas == 6 && partitura.compas == voz.compas)
        // Sin cuerdas, no hay tablatura, aunque la voz tenga pulsaciones.
        let sinCuerdas = voz.svgPentagrama(titulo: "Voz", grados: [0: "I"], bajoCifrado: [1: ["6"]], dedos: [2: [1]])
        #expect(Partitura(linea).svg() == sinCuerdas)
    }

    @Test func losIniciosDeLosEventos() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2")
        #expect(voz.inicios == [.cero, .negra, Duracion(3, 8), .blanca])
        #expect(voz.porInicio([1: "Re", 3: "Fa", 9: "nada"]) == [.negra: "Re", .blanca: "Fa"])
    }
}
