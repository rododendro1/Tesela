import Hexagonos
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria
@testable import ArmoniaTrastes

// Los nombres de antes (`Obsoletos.swift` de cada módulo) siguen dando lo mismo que los nuevos hasta que se quiten.
// Se usan a propósito, así que estas pruebas compilan con avisos de obsoleto.

@Suite struct ObsoletosTests {
    @available(*, deprecated)
    @Test func lasAlturasConPreferirBemoles() {
        #expect(Altura(midi: 70, preferirBemoles: true) == Altura(midi: 70, ventana: .bemoles))
        #expect(Altura(midi: 70, preferirBemoles: false) == Altura(midi: 70))

        var opciones = OpcionesDeDiagrama(preferirBemoles: true)
        #expect(opciones.ventana == .bemoles && opciones.preferirBemoles)
        opciones.preferirBemoles = false
        #expect(opciones.ventana == .sostenidos && !opciones.preferirBemoles)

        let casilla = CasillaCuadrada(columna: 1, fila: 0)
        #expect(
            TecladoCuadrado.quintas.altura(en: casilla, preferirBemoles: true)
                == TecladoCuadrado.quintas.altura(en: casilla, ventana: .bemoles))
        let coordenada = CoordenadaAxial(q: 1, r: 0)
        #expect(
            TecladoIsomorfico.wickiHayden.altura(en: coordenada, preferirBemoles: true)
                == TecladoIsomorfico.wickiHayden.altura(en: coordenada, ventana: .bemoles))

        let mastil = Mastil(.guitarra)
        let posicion = PosicionEnElMastil(cuerda: 1, traste: 1)
        #expect(mastil.altura(en: posicion, preferirBemoles: true).nota.nombre == "Si♭")
        #expect(mastil.alturaSiExiste(en: posicion, preferirBemoles: true)?.nota.nombre == "Si♭")
    }

    @available(*, deprecated)
    @Test func losNombresDeAntes() {
        var maquetacion = OpcionesDePentagrama.Maquetacion(disposicionDelAcorde: .abierta)
        #expect(maquetacion.posicionDelAcorde == .abierta && maquetacion.disposicionDelAcorde == .abierta)
        maquetacion.disposicionDelAcorde = .cerrada
        #expect(maquetacion.posicionDelAcorde == .cerrada)

        let acorde = Acorde("Do9")
        #expect(acorde.partitura(disposicion: .abierta) == acorde.partitura(posicion: .abierta))

        #expect(Escala(.re, .dorico).escalaMadre?.modo == 2)
        #expect(Acorde("Sol7").conjuntoDeClases == Acorde("Sol7").conjuntoDeClasesDeAltura)
    }
}
