import Foundation
import Testing

@testable import Elementos

/// Las tablas que se calculan al pedirlas: cada valor una vez, también desde varios hilos.
@Suite struct TablaPerezosaTests {
    /// Cuenta cuántas veces se calcula cada valor.
    private final class Contador: @unchecked Sendable {
        private let cerrojo = NSLock()
        private var veces: [Int: Int] = [:]
        func sumar(_ clave: Int) {
            cerrojo.lock()
            veces[clave, default: 0] += 1
            cerrojo.unlock()
        }
        func cuantas(_ clave: Int) -> Int {
            cerrojo.lock()
            defer { cerrojo.unlock() }
            return veces[clave] ?? 0
        }
    }

    @Test func calculaCadaValorAlPedirlo() {
        let contador = Contador()
        let cuadrados = TablaPerezosa<Int, Int> { n in
            contador.sumar(n)
            return n * n
        }
        #expect(contador.cuantas(3) == 0)
        #expect(cuadrados[3] == 9)
        #expect(cuadrados[3] == 9)
        #expect(contador.cuantas(3) == 1)
        #expect(contador.cuantas(4) == 0)
    }

    @Test func desdeVariosHilosDaElMismoValor() async {
        let tabla = TablaPerezosa<Int, [Int]> { n in Array(0..<n) }
        let resultados = await withTaskGroup(of: [Int].self) { grupo in
            for _ in 0..<32 { grupo.addTask { tabla[100] } }
            return await grupo.reduce(into: []) { $0.append($1) }
        }
        #expect(resultados.allSatisfy { $0 == Array(0..<100) })
    }

    /// El cálculo de un valor puede pedir otros de la misma tabla.
    @Test func unValorPuedePedirOtro() {
        final class Caja: @unchecked Sendable { var tabla: TablaPerezosa<Int, Int>? }
        let caja = Caja()
        caja.tabla = TablaPerezosa { n in n <= 1 ? 1 : n * (caja.tabla?[n - 1] ?? 0) }
        #expect(caja.tabla?[5] == 120)
    }

    @Test func lasNotasSeLeenEnCadaNotacion() throws {
        #expect(try Nota(leyendo: "Fis", en: .compacta(.aleman)) == Nota(.fa, .sostenido))
        #expect(try Nota(leyendo: "H Be", en: .conPalabras(.aleman)) == Nota(.si, .bemol))
        #expect(Nota.porNombre[.conPalabras(.frances)]["re bemol".claveDeBusqueda] == Nota(.re, .bemol))
    }
}
