import Foundation
import Testing

@testable import Elementos
@testable import Teoria

@Suite struct TemperamentoConNombreTests {
    /// Cada temperamento del catálogo tiene un nombre que no se repite, sus pasos de menor a mayor desde 0 y por
    /// debajo de la octava, y una referencia.
    @Test func catalogo() {
        let catalogo = TemperamentoConNombre.catalogo
        #expect(catalogo.count == 22)
        #expect(Set(catalogo.map(\.nombre)).count == catalogo.count)
        for temperamento in catalogo {
            let pasos = temperamento.pasos
            #expect(abs(pasos[0]) < 1e-9, "\(temperamento)")
            #expect(zip(pasos, pasos.dropFirst()).allSatisfy { $0 < $1 }, "\(temperamento)")
            #expect(pasos.last! < 1200, "\(temperamento)")
            #expect(!temperamento.referencias.isEmpty, "\(temperamento)")
            #expect(temperamento.id == temperamento.nombre && temperamento.description == temperamento.nombre)
            #expect((temperamento.afinacion() == nil) == (temperamento.familia == .tradicional), "\(temperamento)")
        }
        for familia in FamiliaDeTemperamento.allCases {
            #expect(!TemperamentoConNombre.todos(de: familia).isEmpty, "\(familia)")
            #expect(Set(Idioma.allCases.map { familia.nombre(en: .conPalabras($0)) }).count > 1)
        }
    }

    /// Cada temperamento para escuchar y cada sistema microtonal (salvo el de cents cualesquiera) está en el catálogo.
    @Test func historicasYSistemas() throws {
        for temperamento in TemperamentoConNombre.paraEscuchar {
            #expect(TemperamentoConNombre.catalogo.contains(temperamento))
            #expect(temperamento.afinacion(tonica: .re) != nil)
        }
        for sistema in SistemaMicrotonal.allCases where sistema != .razones {
            #expect(sistema.temperamento?.sistemaMicrotonal == sistema)
            #expect(sistema.temperamento?.pasosPorOctava == sistema.pasosPorOctava)
        }
        #expect(SistemaMicrotonal.razones.temperamento == nil)
    }

    /// Los pasos y la quinta de algunos.
    @Test func pasos() {
        #expect(TemperamentoConNombre.temperamentoIgual.pasos == (0..<12).map { Double($0) * 100 })
        #expect(TemperamentoConNombre.temperamentoIgual.quinta == 700)
        #expect(abs(TemperamentoConNombre.mesotonicoCuartoDeComa.quinta! - 696.578) < 0.001)
        #expect(abs(TemperamentoConNombre.divisiones31.quinta! - 696.774) < 0.001)
        #expect(TemperamentoConNombre.werckmeisterIII.quinta == nil)
        #expect(TemperamentoConNombre.comas53.pasosPorOctava == 53)
        let justa = TemperamentoConNombre.afinacionJusta.pasos
        #expect(abs(justa[4] - RazonDeFrecuencias(5, 4).cents) < 1e-9)
        #expect(abs(justa[7] - RazonDeFrecuencias(3, 2).cents) < 1e-9)
        #expect(TemperamentoConNombre.sruti22.pasos.count == 22)
        #expect(TemperamentoConNombre.afinacionJusta.nombre(en: .conPalabras(.ingles)) == "just intonation")
    }

    /// Lo que se mide: los pasos, las aproximaciones justas, las quintas y las terceras.
    @Test func estadisticas() throws {
        let igual = TemperamentoConNombre.temperamentoIgual.estadisticas
        #expect(igual.uniforme && igual.pasoMenor == 100 && igual.pasoMayor == 100)
        #expect(igual.desviacionesDelIgual == [Double](repeating: 0, count: 12))
        let quinta = try #require(igual.aproximaciones.first)
        #expect(quinta.razon == RazonDeFrecuencias(3, 2) && quinta.cents == 700 && abs(quinta.error + 1.955) < 0.001)
        let meso = TemperamentoConNombre.mesotonicoCuartoDeComa.estadisticas
        #expect(!meso.uniforme)
        #expect(abs(try #require(meso.quintaDelLobo) - 737.637) < 0.001)
        #expect(abs(try #require(meso.terceraMasPura) - 386.314) < 0.001)
        #expect(abs(try #require(meso.terceraMasLejana) - 427.373) < 0.001)
        #expect(meso.quintas?.count == 12 && meso.tercerasMayores?.count == 12)
        let pitagorico = TemperamentoConNombre.pitagorico.estadisticas
        #expect(abs(try #require(pitagorico.quintaDelLobo) - 678.495) < 0.001)
        let treintaYUno = TemperamentoConNombre.divisiones31.estadisticas
        #expect(treintaYUno.uniforme && treintaYUno.quintas == nil && treintaYUno.quintaDelLobo == nil)
        #expect(abs(treintaYUno.aproximaciones[3].error) < 1.2)
        let sruti = TemperamentoConNombre.sruti22.estadisticas
        #expect(!sruti.uniforme && abs(sruti.aproximaciones[1].error) < 1e-9)
    }

    /// Cada fichero de idioma da todos los temperamentos del catálogo, una sola vez y sin repetir nombres.
    @Test func nombresEnTodosLosIdiomas() {
        let catalogo = TemperamentoConNombre.catalogo
        for idioma in Idioma.allCases {
            let nombres = NombresDeTemperamentos.de(idioma)
            #expect(nombres.filas.count == catalogo.count, "\(idioma)")
            #expect(Set(nombres.filas.map(\.elemento)) == Set(catalogo), "\(idioma)")
            let escritos = catalogo.compactMap { nombres.nombre(de: $0) }
            #expect(escritos.count == catalogo.count, "\(idioma)")
            #expect(Set(escritos.map(NombresDeTemperamentos.Tabla.normalizar)).count == catalogo.count, "\(idioma)")
        }
    }

    /// Ningún nombre, alias ni variante, en ningún idioma, es de dos temperamentos distintos.
    @Test func ningunNombreEsDeDos() {
        var duenos: [String: TemperamentoConNombre] = [:]
        for temperamento in TemperamentoConNombre.catalogo {
            for clave in temperamento.claves {
                if let otro = duenos[clave] { #expect(otro == temperamento, "«\(clave)»: \(otro) y \(temperamento)") }
                duenos[clave] = temperamento
            }
        }
    }

    /// Se busca por el nombre, un alias o una variante en cualquier idioma.
    @Test func buscar() {
        #expect(TemperamentoConNombre.buscar(nombre: "meantone") == .mesotonicoCuartoDeComa)
        #expect(TemperamentoConNombre.buscar(nombre: "mesotónico") == .mesotonicoCuartoDeComa)
        #expect(TemperamentoConNombre.buscar(nombre: "31-EDO") == .divisiones31)
        #expect(TemperamentoConNombre.buscar(nombre: "gleichstufige Stimmung") == .temperamentoIgual)
        #expect(TemperamentoConNombre.buscar(nombre: "53 comas") == .comas53)
        #expect(TemperamentoConNombre.buscar(nombre: "no es un temperamento") == nil)
        #expect(TemperamentoConNombre.buscar(conteniendo: "mesotónico").count == 5)
        #expect(TemperamentoConNombre.buscar(conteniendo: "") == TemperamentoConNombre.catalogo)
    }
}
