import ArmoniaNucleo
import ArmoniaTeoria

// Lo que se escribe con las notas de una voz en el pentagrama, por evento, y cómo se lleva a las columnas del dibujo
// o a los eventos de una línea: en un solo sitio, para que nada se quede atrás al añadir otra anotación.

extension Voz {
    /// Lo que se escribe con las notas de una voz, por evento: los acordes, los grados, el bajo cifrado, los dedos,
    /// la tablatura y los microtonos (si son `nil`, los de los eventos).
    struct AnotacionesDelPentagrama {
        var acordes: [Int: Acorde] = [:]
        var grados: [Int: String] = [:]
        var bajoCifrado: [Int: [String]] = [:]
        var digitos: [Int: [Int]] = [:]
        var tablatura: Tablatura?
        var microtonos: [Int: [PentagramaSVG.Microtono?]]?
        /// El acorde que suena al empezar, si no hay ninguno en el primer evento (en una línea de una voz larga).
        var acordeVigente: Acorde?

        /// Las mismas, con cada índice llevado a otro (o quitado, si `nuevo` da `nil`); si dos van al mismo, se
        /// queda el primero. Los microtonos no se mueven: van en todos los eventos, no solo en el que empieza.
        func reasignadas(_ nuevo: (Int) -> Int?) -> AnotacionesDelPentagrama {
            func mover<T>(_ porIndice: [Int: T]) -> [Int: T] {
                var movidas: [Int: T] = [:]
                for (indice, valor) in porIndice.sorted(by: { $0.key < $1.key }) {
                    if let destino = nuevo(indice), movidas[destino] == nil { movidas[destino] = valor }
                }
                return movidas
            }
            var resultado = AnotacionesDelPentagrama(
                acordes: mover(acordes), grados: mover(grados), bajoCifrado: mover(bajoCifrado),
                digitos: mover(digitos),
                tablatura: tablatura.map {
                    Tablatura(cuerdas: $0.cuerdas, notas: mover($0.notas), afinacion: $0.afinacion, capo: $0.capo)
                },
                microtonos: microtonos)
            resultado.acordeVigente = acordeVigente
            return resultado
        }
    }
}
