/// Si una medida vale lo esperado hasta la milésima: el motor da el valor exacto, y las pruebas lo comparan con lo
/// que se escribe, que va con tres decimales como mucho.
func casi(_ valor: Double?, _ esperado: Double, tolerancia: Double = 0.0005) -> Bool {
    guard let valor else { return false }
    return abs(valor - esperado) <= tolerancia
}
