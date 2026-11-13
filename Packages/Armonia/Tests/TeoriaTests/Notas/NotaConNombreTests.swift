import Foundation
import Testing

@testable import Elementos
@testable import Teoria

@Suite struct NotaConNombreTests {
    /// Cada nota del catálogo tiene un nombre que no se repite, y las de las tradiciones y los diapasones, una
    /// referencia.
    @Test func catalogo() {
        let catalogo = NotaConNombre.catalogo
        #expect(catalogo.count == 15 + 20 + 29 + 49 + 18)
        #expect(Set(catalogo.map(\.nombre)).count == catalogo.count)
        for nota in catalogo {
            #expect(nota.id == nota.nombre && nota.description == nota.nombre)
            #expect((nota.familia == .referencia) == nota.referencias.isEmpty, "\(nota)")
            #expect(abs(nota.desvio) < 60, "\(nota)")
            #expect(nota.frecuencia > 0 && nota.midi == nota.altura.midi)
        }
        for familia in FamiliaDeNota.allCases {
            #expect(!NotaConNombre.todas(de: familia).isEmpty, "\(familia)")
            #expect(Set(Idioma.allCases.map { familia.nombre(en: .conPalabras($0)) }).count > 1)
        }
    }

    /// Las frecuencias de los diapasones y de las notas de referencia.
    @Test func frecuencias() {
        #expect(NotaConNombre.la440.frecuencia == 440 && NotaConNombre.la440.anioDeOrigen == 1939)
        #expect(NotaConNombre.la415.frecuencia == 415)
        #expect(abs(NotaConNombre.la4225.frecuencia - 422.5) < 1e-9)
        #expect(abs(NotaConNombre.do256.frecuencia - 256) < 1e-9)
        #expect(abs(NotaConNombre.do256.frecuenciaDelLa4 - 430.539) < 0.001)
        #expect(abs(NotaConNombre.doCentral.frecuencia - 261.626) < 0.001 && NotaConNombre.doCentral.midi == 60)
        #expect(NotaConNombre.laMasGraveDelPiano.frecuencia == 27.5)
        #expect(NotaConNombre.notaMidi0.midi == 0 && NotaConNombre.notaMidi127.midi == 127)
    }

    /// Las de las tradiciones y las guidonianas, con su altura con nombre o su posición, y lo que se apartan de la
    /// temperada.
    @Test func tradicionesYPosiciones() throws {
        let sikah = try #require(NotaConNombre.buscar(nombre: "Sīkāh"))
        #expect(sikah.familia == .arabe && sikah.desvio == -50 && sikah.altura == Altura(.mi, octava: 4))
        #expect(sikah.alias == ["سيكاه"] && sikah.variantes == ["Sikah"])
        #expect(sikah.alturaConNombre?.notaConNombre == sikah)
        let segah = try #require(NotaConNombre.buscar(nombre: "Segâh"))
        #expect(segah.familia == .turca && abs(segah.desvio + 13.208) < 0.001)
        let rast = try #require(NotaConNombre.buscar(nombre: "Rast (Sol4)"))
        #expect(rast.familia == .turca && rast.variantes.isEmpty)
        #expect(NotaConNombre.buscar(nombre: "Rast")?.familia == .arabe)
        let mese = try #require(NotaConNombre.buscar(nombre: "mese"))
        #expect(mese.familia == .griega && mese.desvio == 0 && mese.nombre(en: .conPalabras(.griego)) == "μέση")
        #expect(mese.nombre(en: .conPalabras(.ingles)) == "mésē")
        let doble = try #require(NotaConNombre.buscar(nombre: "b fa ♮ mi"))
        #expect(doble.altura == Altura(Nota(.si, .bemol), octava: 3) && doble.posicion?.alturas.count == 2)
        #expect(NotaConNombre.buscar(nombre: "e la mi")?.altura == Altura(.mi, octava: 3))
        #expect(NotaConNombre.buscar(nombre: "e la mi (Mi4)")?.altura == Altura(.mi, octava: 4))
        #expect(NotaConNombre.todas(de: .guidoniana).count == ManoGuidoniana.gamut.count)
        for sistema in NombresPorOctava.allCases {
            for altura in sistema.alturas { #expect(altura.notaConNombre?.alturaConNombre == altura, "\(altura)") }
        }
    }

    /// Cada fichero de idioma da todas las notas del catálogo, una sola vez y sin repetir nombres.
    @Test func nombresEnTodosLosIdiomas() {
        let catalogo = NotaConNombre.catalogo
        for idioma in Idioma.allCases {
            let nombres = NombresDeNotas.de(idioma)
            #expect(nombres.filas.count == catalogo.count, "\(idioma)")
            #expect(Set(nombres.filas.map(\.elemento)) == Set(catalogo), "\(idioma)")
            let escritos = catalogo.compactMap { nombres.nombre(de: $0) }
            #expect(escritos.count == catalogo.count, "\(idioma)")
            #expect(Set(escritos.map(NombresDeNotas.Tabla.normalizar)).count == catalogo.count, "\(idioma)")
        }
    }

    /// Ningún nombre, alias ni variante, en ningún idioma, es de dos notas distintas.
    @Test func ningunNombreEsDeDos() {
        var duenos: [String: NotaConNombre] = [:]
        for nota in NotaConNombre.catalogo {
            for clave in nota.claves {
                if let otra = duenos[clave] { #expect(otra == nota, "«\(clave)»: \(otra) y \(nota)") }
                duenos[clave] = nota
            }
        }
    }

    /// Se busca por el nombre, un alias o una variante en cualquier idioma.
    @Test func buscar() {
        #expect(NotaConNombre.buscar(nombre: "A440") == .la440)
        #expect(NotaConNombre.buscar(nombre: "la 440") == .la440)
        #expect(NotaConNombre.buscar(nombre: "baroque pitch") == .la415)
        #expect(NotaConNombre.buscar(nombre: "La 422.5") == .la4225)
        #expect(NotaConNombre.buscar(nombre: "middle C") == .doCentral)
        #expect(NotaConNombre.buscar(nombre: "Chorton") == .la466)
        #expect(NotaConNombre.buscar(nombre: "no es una nota") == nil)
        #expect(NotaConNombre.buscar(conteniendo: "piano") == [.laMasGraveDelPiano, .doMasAgudoDelPiano])
        #expect(NotaConNombre.buscar(conteniendo: "") == NotaConNombre.catalogo)
        #expect(NotaConNombre.doCentral.nombre(en: .conPalabras(.aleman)) == "mittleres C")
    }
}
