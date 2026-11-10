import Testing

@testable import Elementos
@testable import Teoria

@Suite struct RitmoConNombreTests {
    /// Cada ritmo del catálogo tiene un nombre que no se repite, un patrón de `x`, `o` y `.` que empieza a sonar en
    /// algún pulso, una agrupación que suma sus pulsos y una referencia.
    @Test func catalogo() {
        let catalogo = RitmoConNombre.catalogo
        #expect(catalogo.count == 42)
        #expect(Set(catalogo.map(\.nombre)).count == catalogo.count)
        #expect(Set(catalogo).count == catalogo.count)
        for ritmo in catalogo {
            #expect(ritmo.patron.allSatisfy { "xo.".contains($0) }, "\(ritmo)")
            #expect(!ritmo.ataques.isEmpty, "\(ritmo)")
            #expect(ritmo.agrupacion.reduce(0, +) == ritmo.pulsos, "\(ritmo)")
            #expect(ritmo.intervalos.reduce(0, +) == ritmo.pulsos, "\(ritmo)")
            #expect([2, 4, 8, 16].contains(ritmo.unidad), "\(ritmo)")
            #expect(!ritmo.referencias.isEmpty, "\(ritmo)")
            #expect(ritmo.id == ritmo.nombre && ritmo.description == ritmo.nombre)
        }
        for familia in FamiliaDeRitmo.allCases {
            #expect(!RitmoConNombre.todos(de: familia).isEmpty, "\(familia)")
            #expect(Set(Idioma.allCases.map { familia.nombre(en: .conPalabras($0)) }).count > 1)
        }
        #expect(RitmoConNombre.todos(de: .tala).contains(.tintal))
    }

    /// Lo que se lee del patrón.
    @Test func patron() {
        let clave = RitmoConNombre.claveDeSon
        #expect(clave.pulsos == 16)
        #expect(clave.ataques == [0, 3, 6, 10, 12])
        #expect(clave.intervalos == [3, 3, 4, 2, 4])
        #expect(clave.tiempos == [0, 4, 8, 12])
        #expect(RitmoConNombre.tresillo.intervalos == [3, 3, 2])
        #expect(RitmoConNombre.claveDeSonDosTres.ataques.first == 2)
        let propio = RitmoConNombre(nombre: "mío", patron: "x.o.", familia: .danza)
        #expect(propio.agrupacion == [4])
        #expect(propio.golpes == [.fuerte, nil, .debil, nil])
        #expect(propio.nombre(en: .conPalabras(.ingles)) == "mío")
        #expect(RitmoConNombre(nombre: "nada", patron: "....", familia: .danza).intervalos.isEmpty)
    }

    /// E(k, n) de Bjorklund, por el algoritmo de Bresenham.
    @Test func euclideo() {
        #expect(RitmoConNombre.euclideo(ataques: 3, pulsos: 8) == "x..x..x.")
        #expect(RitmoConNombre.euclideo(ataques: 5, pulsos: 8) == "x.x.xx.x")
        #expect(RitmoConNombre.euclideo(ataques: 0, pulsos: 4) == "....")
        #expect(RitmoConNombre.euclideo(ataques: 9, pulsos: 4) == "xxxx")
        #expect(RitmoConNombre.euclideo(ataques: 3, pulsos: 0) == "")
    }

    /// Cada fichero de idioma da todos los ritmos del catálogo, una sola vez y sin repetir nombres.
    @Test func nombresEnTodosLosIdiomas() {
        let catalogo = RitmoConNombre.catalogo
        for idioma in Idioma.allCases {
            let nombres = NombresDeRitmos.de(idioma)
            #expect(nombres.filas.count == catalogo.count, "\(idioma)")
            #expect(Set(nombres.filas.map(\.elemento)) == Set(catalogo), "\(idioma)")
            let escritos = catalogo.compactMap { nombres.nombre(de: $0) }
            #expect(escritos.count == catalogo.count, "\(idioma)")
            #expect(escritos.allSatisfy { !$0.isEmpty }, "\(idioma)")
            #expect(Set(escritos.map(NombresDeRitmos.Tabla.normalizar)).count == catalogo.count, "\(idioma)")
        }
        #expect(RitmoConNombre.claveDeSon.nombre(en: .conPalabras(.ingles)) == "son clave")
    }

    /// Ningún nombre, alias ni variante, en ningún idioma, es de dos ritmos distintos.
    @Test func ningunNombreEsDeDos() {
        var duenos: [String: RitmoConNombre] = [:]
        for ritmo in RitmoConNombre.catalogo {
            for clave in ritmo.claves {
                if let otro = duenos[clave] { #expect(otro == ritmo, "«\(clave)»: \(otro) y \(ritmo)") }
                duenos[clave] = ritmo
            }
        }
    }

    /// Se busca por el nombre, un alias o una variante en cualquier idioma, sin mirar tildes ni mayúsculas.
    @Test func buscar() {
        #expect(RitmoConNombre.buscar(nombre: "son clave") == .claveDeSon)
        #expect(RitmoConNombre.buscar(nombre: "Clave de Son") == .claveDeSon)
        #expect(RitmoConNombre.buscar(nombre: "tintal") == .tintal)
        #expect(RitmoConNombre.buscar(nombre: "tīntāl") == .tintal)
        #expect(RitmoConNombre.buscar(nombre: "no es un ritmo") == nil)
        let claves = RitmoConNombre.buscar(conteniendo: "clave")
        #expect(claves.first == .claveDeSon)
        #expect(claves.contains(.claveDeRumba) && !claves.contains(.tresillo))
        #expect(RitmoConNombre.buscar(conteniendo: "") == RitmoConNombre.catalogo)
    }

    /// Las medidas de Toussaint.
    @Test func estadisticas() {
        let clave = RitmoConNombre.claveDeSon.estadisticas
        #expect(clave.pulsos == 16)
        #expect(clave.ataques == 5)
        #expect(clave.fuertes == 5)
        #expect(clave.vectorDeDistancias == [0, 1, 2, 2, 0, 3, 2, 0])
        #expect(!clave.euclideo)
        #expect(!clave.profundo)
        #expect(clave.simetriasPorRotacion == 0)
        #expect(clave.contratiempo == 1)
        #expect(clave.uniformidad > 0 && clave.uniformidad < 1)
        #expect(clave.sincopa > 0)
        #expect(RitmoConNombre.tresillo.estadisticas.euclideo)
        #expect(RitmoConNombre.cinquillo.estadisticas.euclideo)
        #expect(RitmoConNombre.bembe.estadisticas.euclideo)
        #expect(RitmoConNombre.shiko.estadisticas.profundo)
        let regular = RitmoConNombre(nombre: "corcheas", patron: "x.x.x.x.", agrupacion: [2, 2, 2, 2], familia: .danza)
            .estadisticas
        #expect(regular.uniformidad == 1)
        #expect(regular.simetriasPorRotacion == 3)
        #expect(regular.sincopa == 0)
        let nada = RitmoConNombre(nombre: "nada", patron: "....", familia: .danza).estadisticas
        #expect(nada.uniformidad == 0 && nada.sincopa == 0 && !nada.profundo)
        let vacio = RitmoConNombre(nombre: "vacío", patron: "", familia: .danza).estadisticas
        #expect(!vacio.euclideo && vacio.simetriasPorRotacion == 0)
    }

    /// Las distancias de Hamming y de intercambio, solo entre ritmos comparables.
    @Test func distancias() {
        #expect(RitmoConNombre.claveDeSon.distanciaDeHamming(a: .claveDeRumba) == 2)
        #expect(RitmoConNombre.claveDeSon.distanciaDeIntercambio(a: .claveDeRumba) == 1)
        #expect(RitmoConNombre.claveDeSon.distanciaDeHamming(a: .tresillo) == nil)
        #expect(RitmoConNombre.claveDeSon.distanciaDeIntercambio(a: .shiko) == 1)
        #expect(RitmoConNombre.claveDeSon.distanciaDeIntercambio(a: .tresillo) == nil)
    }
}
