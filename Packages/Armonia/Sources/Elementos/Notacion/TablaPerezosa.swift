import Foundation

/// Valores que se calculan la primera vez que se piden y se guardan, uno por llave: las tablas de lectura de cada
/// notación o los nombres de escala de cada idioma, que así no se calculan todos al pedir uno.
///
/// Se puede usar desde varios hilos. El valor se calcula fuera del cerrojo, así que `crear` puede pedir otros valores
/// de la misma tabla; si dos hilos piden a la vez el mismo, los dos lo calculan y se guarda el primero.
package final class TablaPerezosa<Llave: Hashable & Sendable, Valor: Sendable>: @unchecked Sendable {
    private let crear: @Sendable (Llave) -> Valor
    private var valores: [Llave: Valor] = [:]
    private let cerrojo = NSLock()

    package init(_ crear: @escaping @Sendable (Llave) -> Valor) {
        self.crear = crear
    }

    package subscript(llave: Llave) -> Valor {
        cerrojo.lock()
        let guardado = valores[llave]
        cerrojo.unlock()
        if let guardado { return guardado }
        let nuevo = crear(llave)
        cerrojo.lock()
        defer { cerrojo.unlock() }
        if let otro = valores[llave] { return otro }
        valores[llave] = nuevo
        return nuevo
    }
}
