import Armonia
import Testing

@testable import Exposicion

// La escala que se elige en la pestaña de escalas, y lo que esa pestaña dibuja y exporta además de sus secciones.
@Suite struct EleccionDeEscalaTests {
    let notacion = Notacion.espanolCompacto

    @Test func laEscalaElegida() {
        var eleccion = EleccionDeEscala()
        #expect(eleccion.escala == Escala(.do, .mayor))
        // La tónica, con la grafía de una tonalidad: Si♭, no La♯.
        eleccion.tonica = EleccionDeEscala.tonicas.firstIndex { $0.claseDeAltura == 10 }!
        #expect(eleccion.escala.tonica.nombre(en: notacion) == "Si♭")
        // Un índice fuera del catálogo no se sale.
        eleccion.tipo = EleccionDeEscala.catalogo.count + 3
        #expect(eleccion.escala.tipo == EleccionDeEscala.catalogo.last)
        // La escrita manda si se lee; si no, la elegida.
        eleccion.propia = "Re Mi Fa Sol La Si Do"
        #expect(eleccion.escala.tonica == .re)
        eleccion.propia = "no es una escala"
        #expect(eleccion.escala.tonica.nombre(en: notacion) == "Si♭")
        #expect(EleccionDeEscala.tonicas.count == 12)
        let tipos = EleccionDeEscala.habituales.count + EleccionDeEscala.deOtrasTradiciones.count
        #expect(tipos == EleccionDeEscala.catalogo.count)
    }

    @Test func elegirUnaEscalaPedida() {
        var eleccion = EleccionDeEscala(propia: "Do Re Mi")
        eleccion.elegir(Escala(.re, .dorico))
        #expect(eleccion.propia.isEmpty)
        #expect(eleccion.escala == Escala(.re, .dorico))
        #expect(eleccion.escala.nombre(en: notacion) == Escala(.re, .dorico).nombre(en: notacion))
        #expect(EleccionDeEscala.nombreDelTipo(eleccion.tipo, en: notacion) == TipoDeEscala.dorico.nombre(en: notacion))
    }

    @Test func losFicherosDeLaPestana() {
        let escala = Escala(.do, .mayor)
        typealias Estudio = PresentacionDeEstudioDeEscala
        let teclados = Estudio.teclados(de: escala, en: notacion)
        #expect(teclados.map(\.titulo) == ["Do mayor · Mano derecha", "Do mayor · Mano izquierda"])
        #expect(teclados.allSatisfy { $0.svg.hasPrefix("<svg") })
        #expect(Estudio.ficherosDeLosTeclados(de: escala, en: notacion).map(\.nombre) == teclados.map(\.titulo))
        #expect(Estudio.ficheroDeLaHoja(de: escala, en: notacion).nombre == "Hoja de estudio Do mayor")
        #expect(Estudio.ficheroDelMapaDeBrillo(de: escala, en: notacion).nombre == "Mapa de brillo Do")
        let mapa = Estudio.mapaDeBrillo(numeroDeNotas: 7, resaltada: escala, en: notacion)
        #expect(Estudio.mapaDeBrillo(de: escala, en: notacion) == mapa)
        let comparacion = Estudio.ficheroDeLaComparacion(escala, con: Escala(.do, .lidio), en: notacion)
        #expect(comparacion.nombre == "Do mayor · Do lidio")
    }

    @Test func lasPosicionesEnElMastil() throws {
        let escala = Escala(.sol, .mayor)
        let posicion = try #require(Mastil(.guitarra, numeroDeTrastes: 15).posicionesCAGED(de: escala).first)
        let trastes = PresentacionDeEstudioDeEscala.trastes(de: posicion, en: notacion)
        #expect(trastes.contains("\(posicion.rangoDeTrastes.lowerBound)"))
        let sonido = PresentacionDeEstudioDeEscala.sonido(de: posicion, en: escala)
        #expect(!sonido.notas.isEmpty)
    }
}
