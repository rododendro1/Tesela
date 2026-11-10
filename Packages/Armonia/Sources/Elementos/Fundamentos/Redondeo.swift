import Foundation

// MARK: - Redondeo
//
// El motor da las medidas exactas, y se redondean solo al escribirlas: en el texto de la consola y de las apps, en los
// dibujos SVG y en los ejemplos. Todos usan este, para que un mismo número se escriba igual en todas partes.

/// Cómo se redondea un número para escribirlo.
public enum Redondeo {
    /// El número con `decimales` decimales como mucho: `valor(2/3)` es 0,667.
    public static func valor(_ numero: Double, decimales: Int = 3) -> Double {
        let escala = pow(10, Double(decimales))
        let redondeado = (numero * escala).rounded() / escala
        return redondeado == 0 ? 0 : redondeado // sin −0
    }

    /// El número escrito con `decimales` decimales como mucho y sin ceros de más: «700», «0.125», «-31.174».
    public static func texto(_ numero: Double, decimales: Int = 3) -> String {
        let redondeado = valor(numero, decimales: decimales)
        if redondeado == redondeado.rounded(), abs(redondeado) < 1e15 { return String(Int64(redondeado)) }
        return String(redondeado)
    }
}
