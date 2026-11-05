import Armonia

/// Un dato de una escala con su nombre: «Brillo por quintas: +2».
public struct DatoDeEscalaPresentado: Hashable, Sendable {
    public let nombre: String
    public let valor: String
}

extension PresentacionDeEstudioDeEscala {
    // MARK: Estadísticas

    /// Lo que se mide de una escala (`EstadisticasDeEscala`), un dato por fila, escrito en la notación: el número de
    /// notas con su cardinal, el brillo (solo en las de siete notas), el brillo por quintas, los pasos, el vector
    /// interválico, el número de Forte (si lo tiene), las transposiciones distintas y sus rasgos (si tiene alguno).
    ///
    ///     let datos = PresentacionDeEstudioDeEscala.estadisticas(de: Escala(.do, .mayor),
    ///         notacion: .espanolCompacto)
    ///     datos.map(\.valor)   // ["7 (heptatónica)", "0", "+2", "2 2 1 2 2 2 1", "[2, 5, 4, 3, 6, 1]", "7-35",
    ///                          //  "12", "máximamente regular"]
    public static func estadisticas(de escala: Escala, notacion: Notacion) -> [DatoDeEscalaPresentado] {
        let estadisticas = escala.estadisticas
        func dato(_ campo: (TextosDeApps) -> String, _ valor: String) -> DatoDeEscalaPresentado {
            DatoDeEscalaPresentado(nombre: notacion.texto(campo), valor: valor)
        }
        let cardinal = estadisticas.cardinal.map { " (" + $0.nombre(en: notacion) + ")" } ?? ""
        var datos = [dato(\.numeroDeNotas, "\(estadisticas.numeroDeNotas)" + cardinal)]
        if let brillo = estadisticas.brillo { datos.append(dato(\.brillo, conSigno(Double(brillo)))) }
        datos.append(dato(\.brilloPorQuintas, conSigno(estadisticas.brilloPorQuintas)))
        datos.append(dato(\.pasosEnSemitonos, estadisticas.pasos.map(String.init).joined(separator: " ")))
        let vector = estadisticas.vectorIntervalico.map(String.init).joined(separator: ", ")
        datos.append(dato(\.vectorIntervalico, "[" + vector + "]"))
        if let forte = estadisticas.numeroDeForte { datos.append(dato(\.numeroDeForte, forte)) }
        datos.append(dato(\.transposicionesDistintas, "\(estadisticas.transposicionesDistintas)"))
        let rasgos = [
            estadisticas.anhemitonica ? notacion.texto(\.anhemitonica) : nil,
            estadisticas.cohemitonica ? notacion.texto(\.cohemitonica) : nil,
            estadisticas.maximamenteRegular ? notacion.texto(\.maximamenteRegular) : nil,
            estadisticas.aproximada ? notacion.texto(\.medidaAproximada) : nil,
        ].compactMap { $0 }
        if !rasgos.isEmpty { datos.append(dato(\.rasgos, rasgos.joined(separator: " · "))) }
        return datos
    }

    /// «+2», «0», «-1», «+0.43»: con signo, sin decimales si es entero y con dos como mucho si no.
    public static func conSigno(_ valor: Double) -> String {
        let redondeado = (valor * 100).rounded() / 100
        let cifras = redondeado == redondeado.rounded() ? "\(Int(abs(redondeado)))" : "\(abs(redondeado))"
        if redondeado > 0 { return "+" + cifras }
        if redondeado < 0 { return "-" + cifras }
        return "0"
    }
}
