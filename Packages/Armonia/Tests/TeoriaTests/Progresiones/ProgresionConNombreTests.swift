import Testing

@testable import Elementos
@testable import Teoria

@Suite struct ProgresionConNombreTests {
    /// Cada progresión del catálogo tiene un nombre que no se repite y su cifrado se lee entero.
    @Test func catalogo() throws {
        let catalogo = ProgresionConNombre.catalogo
        #expect(catalogo.count == 29)
        #expect(Set(catalogo.map(\.nombre)).count == catalogo.count)
        #expect(Set(catalogo).count == catalogo.count)
        for progresion in catalogo {
            let acordes = try progresion.tonalidad(sobre: .do).acordes(romanos: progresion.cifrado)
            #expect(acordes.count == progresion.grados.count, "\(progresion)")
            #expect(progresion.acordes(sobre: .do) == acordes, "\(progresion)")
            #expect(!progresion.estilos.isEmpty && !progresion.referencias.isEmpty, "\(progresion)")
        }
    }

    /// Los acordes de algunas, en una tonalidad.
    @Test func acordes() {
        #expect(ProgresionConNombre.iiVI.acordes(sobre: .do) == ["Rem7", "Sol7", "Domaj7"])
        #expect(ProgresionConNombre.monte.acordes(en: Tonalidad(.do)) == ["Do7", "Fa", "Re7", "Sol"])
        #expect(ProgresionConNombre.andaluza.acordes(sobre: .la) == ["Lam", "Sol", "Fa", "Mi"])
        #expect(ProgresionConNombre.andaluza.tonalidad(sobre: .la) == Tonalidad(.la, .menor))
        #expect(
            ProgresionConNombre.coltrane.acordes(sobre: .do)
                == ["Domaj7", "Mib7", "Labmaj7", "Si7", "Mimaj7", "Sol7", "Domaj7"])
        #expect(ProgresionConNombre.blues.grados.count == 12)
    }

    /// Cada fichero de idioma da todas las progresiones del catálogo, una sola vez y sin repetir nombres.
    @Test func nombresEnTodosLosIdiomas() {
        let catalogo = ProgresionConNombre.catalogo
        for idioma in Idioma.allCases {
            let nombres = NombresDeProgresiones.de(idioma)
            #expect(nombres.filas.count == catalogo.count, "\(idioma)")
            #expect(Set(nombres.filas.map(\.progresion)) == Set(catalogo), "\(idioma)")
            let escritos = catalogo.compactMap { nombres.nombre(de: $0) }
            #expect(escritos.count == catalogo.count, "\(idioma)")
            #expect(escritos.allSatisfy { !$0.isEmpty }, "\(idioma)")
            #expect(Set(escritos.map(NombresDeProgresiones.normalizar)).count == catalogo.count, "\(idioma)")
        }
        #expect(ProgresionConNombre.andaluza.nombre(en: .conPalabras(.ingles)) == "Andalusian cadence")
        #expect(ProgresionConNombre.cadenciaRota.nombre(en: .conPalabras(.aleman)) == "Trugschluss")
    }

    /// Ningún nombre, alias ni variante, en ningún idioma, es de dos progresiones distintas.
    @Test func ningunNombreEsDeDos() {
        var duenos: [String: ProgresionConNombre] = [:]
        for progresion in ProgresionConNombre.catalogo {
            for clave in NombresDeProgresiones.claves(de: progresion) {
                if let otra = duenos[clave] { #expect(otra == progresion, "«\(clave)»: \(otra) y \(progresion)") }
                duenos[clave] = progresion
            }
        }
    }

    /// Se busca por el nombre, un alias o una variante en cualquier idioma, sin mirar guiones ni mayúsculas.
    @Test func buscar() {
        #expect(ProgresionConNombre.buscar(nombre: "ii-V-I") == .iiVI)
        #expect(ProgresionConNombre.buscar(nombre: "II–V–I") == .iiVI)
        #expect(ProgresionConNombre.buscar(nombre: "Andalusian cadence") == .andaluza)
        #expect(ProgresionConNombre.buscar(nombre: "tetracordo andaluz") == .andaluza)
        #expect(ProgresionConNombre.buscar(nombre: "Trugschluss") == .cadenciaRota)
        #expect(ProgresionConNombre.buscar(nombre: "bVI-bVII-I") == .eolica)
        #expect(ProgresionConNombre.buscar(nombre: "andaluza") == nil)
        let cadencias = ProgresionConNombre.buscar(conteniendo: "cadencia")
        #expect(cadencias.first == .cadenciaPerfecta)
        #expect(cadencias.contains(.andaluza) && !cadencias.contains(.monte))
        #expect(ProgresionConNombre.buscar(conteniendo: "") == ProgresionConNombre.catalogo)
    }
}
