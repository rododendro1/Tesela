import Foundation
import Testing

@testable import Hexagonos

@Suite struct MapaHexagonalTests {
    @Test func valores() {
        var mapa = MapaHexagonal(repitiendo: "hierba", en: FormasDeMapa.hexagono(radio: 2))
        #expect(mapa.count == 19)
        #expect(!mapa.isEmpty)
        #expect(mapa[.origen] == "hierba")
        #expect(mapa[CoordenadaAxial(q: 5, r: 0)] == nil)
        mapa[CoordenadaAxial(q: 1, r: 0)] = "agua"
        #expect(mapa[CoordenadaAxial(q: 1, r: 0)] == "agua")
        mapa[CoordenadaAxial(q: 5, r: 0)] = "roca"
        #expect(mapa.count == 20)
        #expect(mapa.contiene(CoordenadaAxial(q: 5, r: 0)))
        mapa[CoordenadaAxial(q: 5, r: 0)] = nil
        #expect(!mapa.contiene(CoordenadaAxial(q: 5, r: 0)))
        #expect(mapa.quitar(.origen) == "hierba")
        #expect(mapa.quitar(.origen) == nil)
        #expect(mapa.count == 18)
        #expect(Set(mapa.casillas) == Set(FormasDeMapa.hexagono(radio: 2)).subtracting([.origen]))
        #expect(mapa.casillas(donde: { $0 == "agua" }) == [CoordenadaAxial(q: 1, r: 0)])
        #expect(MapaHexagonal<Int>().isEmpty)
    }

    @Test func porDefecto() {
        var cuenta = MapaHexagonal<Int>()
        for casilla in [CoordenadaAxial.origen, CoordenadaAxial(q: 1, r: 0), .origen] {
            cuenta[casilla, porDefecto: 0] += 1
        }
        #expect(cuenta == [.origen: 2, CoordenadaAxial(q: 1, r: 0): 1])
        #expect(cuenta[CoordenadaAxial(q: 9, r: 9), porDefecto: 0] == 0)
        #expect(cuenta.count == 2)
    }

    @Test func coleccion() {
        let mapa = MapaHexagonal(FormasDeMapa.hexagono(radio: 1)) { $0.distanciaAlOrigen }
        #expect(mapa.count == 7)
        #expect(mapa.reduce(0) { $0 + $1.valor } == 6)
        #expect(mapa.filter { $0.valor == 0 }.map { $0.casilla } == [.origen])
        var vistas = 0
        for (casilla, valor) in mapa {
            #expect(casilla.distanciaAlOrigen == valor)
            vistas += 1
        }
        #expect(vistas == 7)
        #expect("\(mapa)" == "MapaHexagonal (7 casillas)")
        #expect("\(MapaHexagonal(repitiendo: 0, en: [.origen]))" == "MapaHexagonal (1 casilla)")
        // En un literal con la casilla repetida, vale la última.
        let casilla = CoordenadaAxial.origen
        let repetido: MapaHexagonal = [casilla: 1, casilla: 2]
        #expect(repetido[casilla] == 2)
    }

    @Test func vecinas() {
        let mapa = MapaHexagonal(FormasDeMapa.hexagono(radio: 1)) { $0.q }
        #expect(mapa.vecinas(de: .origen).map { $0.casilla } == CoordenadaAxial.origen.vecinos)
        let borde = CoordenadaAxial(q: 1, r: 0)
        #expect(mapa.vecinas(de: borde).map { $0.casilla } == borde.vecinos.filter { $0.distanciaAlOrigen <= 1 })
        #expect(mapa.vecinas(de: borde).map { $0.valor } == mapa.vecinas(de: borde).map { $0.casilla.q })
        #expect(mapa.vecinas(de: CoordenadaAxial(q: 2, r: -1)).count == 2) // fuera del mapa
    }

    @Test func transformarYFiltrar() {
        let mapa = MapaHexagonal(FormasDeMapa.hexagono(radio: 2)) { $0.distanciaAlOrigen }
        let texto = mapa.transformado { "\($0)" }
        #expect(texto[CoordenadaAxial(q: 2, r: 0)] == "2")
        let cerca = mapa.filtrado { _, valor in valor < 2 }
        #expect(Set(cerca.casillas) == Set(FormasDeMapa.hexagono(radio: 1)))
    }

    @Test func simetrias() {
        let mapa = MapaHexagonal(FormasDeMapa.triangulo(lado: 3)) { "\($0.q),\($0.r)" }
        let vector = CoordenadaAxial(q: 2, r: -5)
        let desplazado = mapa.desplazado(por: vector)
        let centro = CoordenadaAxial(q: 1, r: 1)
        let girado = mapa.rotado(sextos: 2, alrededorDe: centro)
        let reflejado = mapa.reflejado(sobre: .s)
        for (casilla, valor) in mapa {
            #expect(desplazado[casilla + vector] == valor)
            #expect(girado[casilla.rotada(sextos: 2, alrededorDe: centro)] == valor)
            #expect(reflejado[casilla.reflejada(sobre: .s)] == valor)
        }
        #expect(girado.count == mapa.count)
        #expect(mapa.rotado(sextos: 6) == mapa)
        #expect(mapa.rotado(sextos: 1).rotado(sextos: -1) == mapa)
    }

    @Test func caminosYVisibilidad() {
        var terreno = MapaHexagonal(repitiendo: 1.0, en: FormasDeMapa.hexagono(radio: 3))
        terreno[CoordenadaAxial(q: 1, r: 0)] = 10
        let camino = terreno.caminoMasBarato(desde: .origen, hasta: CoordenadaAxial(q: 2, r: 0)) { $0 }
        #expect(camino?.coste == 3)
        // Fuera del mapa no se puede pisar.
        #expect(terreno.caminoMasBarato(desde: .origen, hasta: CoordenadaAxial(q: 4, r: 0)) { $0 } == nil)
        // Un muro (nil) se rodea.
        let conMuro = terreno.caminoMasBarato(desde: .origen, hasta: CoordenadaAxial(q: 2, r: 0)) { $0 > 5 ? nil : $0 }
        #expect(conMuro?.coste == 3)

        let alcanzables = terreno.alcanzables(desde: .origen, presupuesto: 2) { $0 }
        #expect(alcanzables[CoordenadaAxial(q: 1, r: 0)] == nil)
        #expect(alcanzables[CoordenadaAxial(q: 2, r: -1)] == 2)
        #expect(alcanzables.keys.allSatisfy { terreno.contiene($0) })
        // Las casillas que faltan en el mapa no tapan.
        let conHueco = MapaHexagonal(repitiendo: false, en: [CoordenadaAxial.origen, CoordenadaAxial(q: 2, r: 0)])
        #expect(Set(conHueco.visibles(desde: .origen) { $0 }) == [CoordenadaAxial.origen, CoordenadaAxial(q: 2, r: 0)])

        let visibles = terreno.visibles(desde: .origen) { $0 > 5 }
        #expect(!visibles.contains(CoordenadaAxial(q: 2, r: 0)))
        #expect(!visibles.contains(CoordenadaAxial(q: 1, r: 0)))
        #expect(visibles.contains(CoordenadaAxial(q: 0, r: 2)))
    }

    @Test func codable() throws {
        let mapa: MapaHexagonal = [CoordenadaAxial(q: 1, r: 0): "agua", .origen: "hierba"]
        let codificador = JSONEncoder()
        codificador.outputFormatting = .sortedKeys
        let datos = try codificador.encode(mapa)
        #expect(
            String(decoding: datos, as: UTF8.self) == #"[{"q":0,"r":0,"valor":"hierba"},{"q":1,"r":0,"valor":"agua"}]"#)
        #expect(try (JSONDecoder().decode(MapaHexagonal<String>.self, from: datos)) == mapa)
        let repetida = Data(#"[{"q":0,"r":0,"valor":"a"},{"q":0,"r":0,"valor":"b"}]"#.utf8)
        #expect(throws: (any Error).self) { try JSONDecoder().decode(MapaHexagonal<String>.self, from: repetida) }
    }

    @Test func igualdadYHash() {
        let a = MapaHexagonal(FormasDeMapa.hexagono(radio: 1)) { $0.q }
        var b = a
        #expect(a == b)
        #expect(Set([a, b]).count == 1)
        b[.origen] = 7
        #expect(a != b)
    }

    @Test func limites() {
        let mapa = MapaHexagonal(repitiendo: 0, en: FormasDeMapa.hexagono(radio: 2))
        let trazado = Trazado(orientacion: .puntiaguda, tamano: 10)
        let limites = mapa.limites(con: trazado)
        #expect(limites != nil)
        #expect((limites?.minimo.x ?? 0) == (trazado.limites(de: FormasDeMapa.hexagono(radio: 2))?.minimo.x ?? 1))
        #expect(MapaHexagonal<Int>().limites(con: trazado) == nil)
    }
}
