import Armonia
import Foundation

// MARK: - Los errores en JSON
//
// Con `--json`, un error sale también en JSON, en la salida de errores y con el mismo código de salida, para que un
// programa no tenga que leer una frase traducida:
//
//     armonia acorde Xx --json
//     {"error":{"codigo":1,"mensaje":"No se puede leer «Xx» (carácter 1): …","posicion":0,"texto":"Xx",
//      "tipo":"notaNoReconocida"}}
//
// `tipo` es el caso del error (`ErrorDeUso`) o del motivo de la lectura (`ErrorAlLeer.motivo`), que no cambia con el
// idioma; `mensaje`, el texto que se escribiría sin `--json`, sin «armonia: » delante.

/// Un error, como sale con `--json`.
struct ErrorEnJSON: Encodable {
    struct Detalle: Encodable {
        /// El código de salida: 1 si no se puede leer o no hay nada que dar, 2 si la orden está mal escrita.
        let codigo: Int32
        /// Qué error es, sin traducir: `opcionDesconocida`, `notaNoReconocida`…
        let tipo: String
        let mensaje: String
        /// Lo que se quiso escribir, si se parece a una orden o una opción conocida.
        var propuesta: String? = nil
        /// En los errores de lectura, lo que se leía y el carácter (desde 0) donde se paró, si es en uno.
        var texto: String? = nil
        var posicion: Int? = nil
    }

    let error: Detalle

    init(_ detalle: Detalle) { error = detalle }

    /// Cualquier otro error, con su texto.
    init(otro error: any Error) {
        self.error = Detalle(codigo: 1, tipo: Self.caso(type(of: error)), mensaje: "\(error)")
    }

    /// El nombre del caso de un `enum`, sin lo que lleva: `opcionDesconocida("--jsn")` → `opcionDesconocida`.
    static func caso(_ valor: Any) -> String {
        let texto = String(describing: valor)
        return String(texto.prefix { $0 != "(" })
    }

    /// Un error de uso, con lo que se quiso escribir.
    init(_ error: ErrorDeUso, en notacion: Notacion, enCurso: LineaDeComandos.OrdenEnCurso?) {
        self.error = Detalle(
            codigo: 2, tipo: error.tipo, mensaje: error.descripcion(en: notacion),
            propuesta: error.propuesta(enCurso: enCurso))
    }

    /// Un error del motor o de lectura: con lo que se leía, si es de lectura.
    init(_ error: any ErrorDeArmonia, en notacion: Notacion) {
        var detalle = Detalle(
            codigo: 1, tipo: Self.caso(type(of: error)), mensaje: error.descripcion(en: notacion))
        if let lectura = error as? any ErrorAlLeer {
            detalle = Detalle(
                codigo: 1, tipo: Self.caso(lectura.motivo), mensaje: detalle.mensaje, texto: lectura.texto,
                posicion: lectura.posicion)
        }
        self.error = detalle
    }

    /// El JSON en una línea, para la salida de errores.
    var texto: String { ((try? LineaDeComandos.textoJSON(self, enUnaLinea: true)) ?? "{}") + "\n" }
}
