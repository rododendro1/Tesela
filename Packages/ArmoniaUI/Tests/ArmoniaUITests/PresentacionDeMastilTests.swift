import Armonia
import Foundation
import Testing

@testable import ArmoniaUI

@Suite struct PresentacionDeMastilTests {
    private let guitarra = Mastil(.guitarra)

    private func digitacion(_ trastes: [Int?]) -> Digitacion {
        Digitacion(mastil: guitarra, trastes: trastes)
    }

    // MARK: Rango

    @Test func cercaDeLaCejillaSeVeDesdeElCero() {
        #expect(PresentacionDeMastil.rango(de: digitacion([nil, 3, 2, 0, 1, 0])) == (0...5)) // Do
        #expect(PresentacionDeMastil.rango(de: digitacion([1, 3, 3, 2, 1, 1])) == (0...5)) // Fa con cejilla
    }

    @Test func sinTrastesPisadosSeVeDesdeElCero() {
        #expect(PresentacionDeMastil.rango(de: digitacion([nil, nil, 0, 0, nil, nil])) == (0...5))
    }

    @Test func lejosDeLaCejillaHayUnaVentanaConMargen() {
        #expect(PresentacionDeMastil.rango(de: digitacion([nil, 7, 9, 9, 8, 7])) == (6...10))
    }

    @Test func laVentanaTieneAlMenosCuatroTrastes() {
        #expect(PresentacionDeMastil.rango(de: digitacion([nil, 0, 7, 7, 7, 7])) == (6...9))
        #expect(PresentacionDeMastil.rango(de: digitacion([nil, 5, 5, 5, 5, nil])) == (4...7))
    }

    @Test func todaPosicionPisadaCabeEnElRango() throws {
        for cifrado in ["Do", "Sol7/Si", "Rem7", "Fa#m7b5", "Mib", "Sib"] {
            let acorde = try Acorde(leyendo: cifrado)
            for forma in guitarra.digitaciones(de: acorde, maximoTraste: 15) {
                let rango = PresentacionDeMastil.rango(de: forma)
                for posicion in forma.posiciones where posicion.traste > 0 {
                    #expect(rango.contains(posicion.traste), "\(cifrado) \(forma.tablatura): \(rango)")
                }
            }
        }
    }

    // MARK: Cuerdas apagadas

    @Test func lasCuerdasApagadas() {
        #expect(PresentacionDeMastil.apagadas(de: digitacion([nil, 3, 2, 0, 1, 0])) == [0])
        #expect(PresentacionDeMastil.apagadas(de: digitacion([nil, nil, 0, 0, nil, 1])) == [0, 1, 4])
        #expect(PresentacionDeMastil.apagadas(de: digitacion([3, 2, 0, 0, 0, 3])) == [])
    }

    // MARK: Ortografía

    @Test func laOrtografiaEsLaDeLaEscala() {
        // Con `Altura(midi:)` el Si♭ saldría como La♯.
        let ortografia = PresentacionDeMastil.ortografia(de: Escala(.fa, .mayor).notas)
        #expect(ortografia[10]?.nombre(en: .espanolUnicode) == "Si♭")
        #expect(ortografia[5]?.nombre(en: .espanolUnicode) == "Fa")
        #expect(ortografia[1] == nil) // Do♯ no está en Fa mayor
    }

    @Test func laOrtografiaDelAcordeConBemoles() throws {
        let ortografia = PresentacionDeMastil.ortografia(de: try Acorde(leyendo: "Mib").notas)
        #expect(ortografia[3]?.nombre(en: .espanolUnicode) == "Mi♭")
        #expect(ortografia[10]?.nombre(en: .espanolUnicode) == "Si♭")
    }

    @Test func siDosNotasComparteClaveGanaLaPrimera() {
        let notas = [Nota(pasosDeQuinta: 6), Nota(pasosDeQuinta: -6)] // Fa♯ y Sol♭
        #expect(PresentacionDeMastil.ortografia(de: notas)[6]?.nombre(en: .espanolUnicode) == "Fa♯")
    }

    @Test func sinNotasNoHayOrtografia() {
        #expect(PresentacionDeMastil.ortografia(de: []).isEmpty)
    }

    // MARK: Descripción

    @Test func laDescripcionVaDeGraveAAgudo() {
        let marcas = [PosicionEnElMastil(cuerda: 1, traste: 3), PosicionEnElMastil(cuerda: 0, traste: 0)]
        #expect(
            PresentacionDeMastil.descripcion(marcas: marcas, apagadas: [], cuerdas: 6)
                == "cuerda 6, traste 0; cuerda 5, traste 3")
        #expect(
            PresentacionDeMastil.descripcion(marcas: marcas, apagadas: [5], cuerdas: 6)
                == "cuerda 6, traste 0; cuerda 5, traste 3; cuerdas apagadas: 1")
    }

    @Test func laDescripcionSeAcortaSiHayMuchasMarcas() {
        let muchas = (0...12).map { PosicionEnElMastil(cuerda: 0, traste: $0) }
        #expect(PresentacionDeMastil.descripcion(marcas: muchas, apagadas: [], cuerdas: 6) == "13 marcas")
    }

    @Test func sinMarcas() {
        #expect(PresentacionDeMastil.descripcion(marcas: [], apagadas: [], cuerdas: 6) == "Sin marcas")
    }

    // MARK: Tocar el mástil

    @Test func elToqueVaAlTrasteYALaCuerdaMasCercana() {
        // Trece columnas de 20 puntos (0…12) y seis cuerdas separadas 20: la grave a 108 del borde de arriba.
        func posicion(_ x: Double, _ y: Double) -> PosicionEnElMastil? {
            PresentacionDeMastil.posicion(
                enX: x, y: y, ancho: 276, alto: 130, cuerdas: 6, rango: 0...12, conCanal: false)
        }
        #expect(posicion(78, 88) == PosicionEnElMastil(cuerda: 1, traste: 3))
        #expect(posicion(10, 100) == PosicionEnElMastil(cuerda: 0, traste: 0))
        #expect(posicion(266, 8) == PosicionEnElMastil(cuerda: 5, traste: 12))
        #expect(posicion(5, 88) == nil) // en el margen
        #expect(posicion(78, 125) == nil) // debajo de la cuerda grave, donde van los números de traste
    }

    @Test func elCanalDeLasCuerdasAlAireNoSeToca() {
        // Del 5 al 8 con canal: cinco columnas de 52 puntos, la primera para el canal.
        func posicion(_ x: Double) -> PosicionEnElMastil? {
            PresentacionDeMastil.posicion(
                enX: x, y: 108, ancho: 276, alto: 130, cuerdas: 6, rango: 5...8, conCanal: true)
        }
        #expect(posicion(40) == nil)
        #expect(posicion(113) == PosicionEnElMastil(cuerda: 0, traste: 6))
    }

    @Test func unaSolaCuerdaONinguna() {
        func posicion(_ y: Double, cuerdas: Int) -> PosicionEnElMastil? {
            PresentacionDeMastil.posicion(
                enX: 100, y: y, ancho: 276, alto: 130, cuerdas: cuerdas, rango: 0...12, conCanal: false)
        }
        #expect(posicion(100, cuerdas: 0) == nil)
        // Con una cuerda, abajo del todo, y hasta 12 puntos por encima o por debajo.
        #expect(posicion(108, cuerdas: 1)?.cuerda == 0)
        #expect(posicion(97, cuerdas: 1)?.cuerda == 0)
        #expect(posicion(60, cuerdas: 1) == nil)
    }
}
