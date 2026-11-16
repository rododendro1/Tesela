import Foundation
import Testing

@testable import Elementos
@testable import Teoria

@Suite struct OrnamentoConNombreTests {
    /// Cada ornamento del catálogo tiene un nombre que no se repite, una referencia y pasos que acaban en la nota
    /// principal.
    @Test func catalogo() {
        let catalogo = OrnamentoConNombre.catalogo
        #expect(Set(catalogo.map(\.nombre)).count == catalogo.count)
        for ornamento in catalogo {
            #expect(ornamento.id == ornamento.nombre && ornamento.description == ornamento.nombre)
            #expect(!ornamento.referencias.isEmpty, "\(ornamento)")
            #expect(ornamento.pasos.count >= 2 && ornamento.pasos.last == 0, "\(ornamento)")
            #expect(ornamento.caracter.isEmpty)
        }
    }

    /// Las alturas sobre una nota principal van por los grados de la escala, y cruzan la octava.
    @Test func alturas() throws {
        let doMayor = Escala(.do, .mayor)
        #expect(
            OrnamentoConNombre.grupeto.alturas(sobre: "Re4", en: doMayor) == ["Mi4", "Re4", "Do4", "Re4"])
        #expect(OrnamentoConNombre.mordente.alturas(sobre: "Do4", en: doMayor) == ["Do4", "Si3", "Do4"])
        #expect(OrnamentoConNombre.schleifer.alturas(sobre: "Mi5", en: doMayor) == ["Do5", "Re5", "Mi5"])
        let laMenor = Escala(.la, .menorArmonica)
        #expect(OrnamentoConNombre.trinoCorto.alturas(sobre: "La4", en: laMenor) == ["Si4", "La4", "Si4", "La4"])
        #expect(OrnamentoConNombre.apoyaturaInferior.alturas(sobre: "La4", en: laMenor) == ["Sol#4", "La4"])
        // La nota principal tiene que ser de la escala.
        #expect(OrnamentoConNombre.trino.alturas(sobre: "Fa#4", en: doMayor) == nil)
    }

    /// La obra que lo documenta y su época.
    @Test func documentada() {
        #expect(OrnamentoConNombre.trino.documentada == .bach1720)
        #expect(OrnamentoConNombre.trino.anioDeOrigen == 1720)
        #expect(OrnamentoConNombre.schleifer.anioDeOrigen == 1753)
        #expect(OrnamentoConNombre.mordenteSuperior.documentada == nil)
        #expect(OrnamentoConNombre.trino.epocaDeOrigen == .barroco)
        #expect(OrnamentoConNombre.mordenteSuperior.epocaDeOrigen == .barroco) // La de su estilo.
        #expect(OrnamentoConNombre.catalogo.allSatisfy { $0.estilos == [.clasica] })
    }

    /// Cada fichero de idioma da todos los ornamentos del catálogo, una sola vez y sin repetir nombres.
    @Test func nombresEnTodosLosIdiomas() {
        let catalogo = OrnamentoConNombre.catalogo
        for idioma in Idioma.allCases {
            let nombres = NombresDeOrnamentos.de(idioma)
            #expect(nombres.filas.count == catalogo.count, "\(idioma)")
            #expect(Set(nombres.filas.map(\.elemento)) == Set(catalogo), "\(idioma)")
            let escritos = catalogo.compactMap { nombres.nombre(de: $0) }
            #expect(escritos.count == catalogo.count, "\(idioma)")
            #expect(Set(escritos.map(NombresDeOrnamentos.Tabla.normalizar)).count == catalogo.count, "\(idioma)")
        }
    }

    /// Ningún nombre, alias ni variante, en ningún idioma, es de dos ornamentos distintos.
    @Test func ningunNombreEsDeDos() {
        var duenos: [String: OrnamentoConNombre] = [:]
        for ornamento in OrnamentoConNombre.catalogo {
            for clave in ornamento.claves {
                if let otro = duenos[clave] { #expect(otro == ornamento, "«\(clave)»: \(otro) y \(ornamento)") }
                duenos[clave] = ornamento
            }
        }
    }

    /// Se busca por el nombre, un alias o una variante en cualquier idioma.
    @Test func buscar() {
        #expect(OrnamentoConNombre.buscar(nombre: "turn") == .grupeto)
        #expect(OrnamentoConNombre.buscar(nombre: "Pralltriller") == .trinoCorto)
        #expect(OrnamentoConNombre.buscar(nombre: "trill") == .trino)
        #expect(OrnamentoConNombre.buscar(nombre: "no es un ornamento") == nil)
        #expect(OrnamentoConNombre.buscar(conteniendo: "trino") == [.trino, .trinoConTerminacion, .trinoCorto])
        #expect(OrnamentoConNombre.trino.nombre(en: .conPalabras(.ingles)) == "trill")
        #expect(OrnamentoConNombre.trinoCorto.alias(en: .conPalabras(.ingles)) == ["Pralltriller"])
        #expect(OrnamentoConNombre.grupeto.alias(en: .conPalabras(.espanol)) == ["gruppetto"])
        #expect(OrnamentoConNombre.trino.variantes(en: .conPalabras(.ingles)).isEmpty)
    }
}
