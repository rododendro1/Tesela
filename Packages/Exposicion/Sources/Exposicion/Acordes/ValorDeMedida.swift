import Armonia

// MARK: - El valor de una medida, para el JSON y el TSV

/// El valor de una medida tal como va al JSON: un número, un texto, un sí o no, una lista o un objeto de campos con
/// nombre. Los decimales son exactos (`Redondeo` solo se aplica al escribirlos en `textoPlano`).
///
///     ValorDeMedida.lista([.entero(0), .entero(4), .entero(7)]).textoPlano   // "0 4 7"
///     ValorDeMedida.decimal(2.2222).textoPlano                                // "2.222"
public enum ValorDeMedida: Hashable, Sendable, Encodable {
    case entero(Int)
    case decimal(Double)
    case texto(String)
    case booleano(Bool)
    case lista([ValorDeMedida])
    /// Los campos, en el orden en que se leen; el JSON los ordena por su clave.
    case objeto([Campo])

    /// Un campo de un objeto: su clave y su valor.
    public struct Campo: Hashable, Sendable {
        public let clave: String
        public let valor: ValorDeMedida

        public init(_ clave: String, _ valor: ValorDeMedida) {
            self.clave = clave
            self.valor = valor
        }
    }

    /// Una lista de enteros.
    public static func enteros(_ numeros: [Int]) -> ValorDeMedida { .lista(numeros.map(ValorDeMedida.entero)) }

    /// Una lista de decimales.
    public static func decimales(_ numeros: [Double]) -> ValorDeMedida { .lista(numeros.map(ValorDeMedida.decimal)) }

    /// El valor en una celda de TSV: los números como en `Redondeo.texto`, los sí o no como «sí» y «no», las listas
    /// separadas por espacios (o por « · » si son de objetos) y los objetos con sus valores separados por espacios.
    public var textoPlano: String {
        switch self {
        case .entero(let numero): String(numero)
        case .decimal(let numero): Redondeo.texto(numero)
        case .texto(let texto): texto
        case .booleano(let valor): valor ? "sí" : "no"
        case .lista(let valores):
            valores.map(\.textoPlano).joined(separator: valores.contains { $0.esObjeto } ? " · " : " ")
        case .objeto(let campos): campos.map(\.valor.textoPlano).joined(separator: " ")
        }
    }

    private var esObjeto: Bool {
        if case .objeto = self { return true }
        return false
    }

    public func encode(to encoder: any Encoder) throws {
        var contenedor = encoder.singleValueContainer()
        switch self {
        case .entero(let numero): try contenedor.encode(numero)
        case .decimal(let numero): try contenedor.encode(numero)
        case .texto(let texto): try contenedor.encode(texto)
        case .booleano(let valor): try contenedor.encode(valor)
        case .lista(let valores): try contenedor.encode(valores)
        case .objeto(let campos):
            try contenedor.encode(
                Dictionary(campos.map { ($0.clave, $0.valor) }, uniquingKeysWith: { primero, _ in primero }))
        }
    }
}
