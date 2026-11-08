import Armonia

/// Un dato de una escala con su nombre: «Brillo por quintas: +2».
public struct DatoDeEscalaPresentado: Hashable, Sendable {
    public let nombre: String
    public let valor: String
}

/// Un peldaño de la escalera de brillo: la escala, su brillo por quintas y la nota que sube desde el anterior.
public struct PeldanoDeBrilloPresentado: Hashable, Sendable {
    public let escala: Escala
    /// «Do lidio».
    public let nombre: String
    /// Su brillo por quintas: «+3».
    public let brillo: String
    /// La nota que sube desde el peldaño anterior: «Fa → Fa♯»; vacío en el primero.
    public let cambio: String
    /// Es la escala de la que se parte.
    public let esLaDePartida: Bool
    public let sonido: Escucha
}

extension PresentacionDeEstudioDeEscala {
    // MARK: Estadísticas

    /// Lo que se mide de una escala (`EstadisticasDeEscala`), un dato por fila, escrito en la notación: el número de
    /// notas con su cardinal, el brillo (solo en las de siete notas), el brillo por quintas, los pasos, el vector
    /// interválico, el número de Forte (si lo tiene), las transposiciones distintas y sus rasgos (si tiene alguno).
    ///
    ///     let datos = PresentacionDeEstudioDeEscala.estadisticas(de: Escala(.do, .mayor),
    ///         en: .compacta(.espanol))
    ///     datos.map(\.valor)   // ["7 (heptatónica)", "0", "+2", "2 2 1 2 2 2 1", "[2, 5, 4, 3, 6, 1]", "7-35",
    ///                          //  "12", "máximamente regular"]
    public static func estadisticas(de escala: Escala, en notacion: Notacion) -> [DatoDeEscalaPresentado] {
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

    /// Varias escalas en una tabla, una por fila: el nombre, las notas, el brillo por quintas, los pasos, el vector
    /// interválico, el número de Forte y los rasgos, para compararlas de un vistazo.
    ///
    ///     let tabla = PresentacionDeEstudioDeEscala.tablaDeEstadisticas(
    ///         [Escala(.do), Escala(.do, .lidio)], en: .compacta(.espanol))
    ///     tabla.filas[1][2]   // "+3"
    public static func tablaDeEstadisticas(
        _ escalas: [Escala], en notacion: Notacion
    ) -> (encabezados: [String], filas: [[String]]) {
        let encabezados = [
            notacion.texto(\.escala), notacion.texto(\.notas), notacion.texto(\.brilloPorQuintas),
            notacion.texto(\.pasosEnSemitonos), notacion.texto(\.vectorIntervalico), notacion.texto(\.numeroDeForte),
            notacion.texto(\.rasgos),
        ]
        let filas = escalas.map { escala -> [String] in
            let datos = estadisticas(de: escala, en: notacion)
            func valor(_ campo: (TextosDeApps) -> String) -> String {
                datos.first { $0.nombre == notacion.texto(campo) }?.valor ?? "—"
            }
            return [
                escala.nombre(en: notacion), escala.notas.map { $0.nombre(en: notacion) }.joined(separator: " "),
                valor(\.brilloPorQuintas), valor(\.pasosEnSemitonos), valor(\.vectorIntervalico),
                valor(\.numeroDeForte), valor(\.rasgos),
            ]
        }
        return (encabezados, filas)
    }

    /// «+2», «0», «-1», «+0.43»: con signo, sin decimales si es entero y con dos como mucho si no.
    public static func conSigno(_ valor: Double) -> String {
        let redondeado = (valor * 100).rounded() / 100
        let cifras = redondeado == redondeado.rounded() ? "\(Int(abs(redondeado)))" : "\(abs(redondeado))"
        if redondeado > 0 { return "+" + cifras }
        if redondeado < 0 { return "-" + cifras }
        return "0"
    }

    // MARK: La escalera de brillo

    /// Las escalas con la misma tónica de la más oscura a la más brillante, a una nota cada una de la siguiente
    /// (`Escala.escaleraDeBrillo`), con su brillo por quintas y la nota que sube.
    ///
    ///     PresentacionDeEstudioDeEscala.escaleraDeBrillo(de: Escala(.do), en: .compacta(.espanol))
    ///         .first { $0.nombre == "Do lidio" }?.cambio   // "Fa → Fa♯"
    public static func escaleraDeBrillo(de escala: Escala, en notacion: Notacion) -> [PeldanoDeBrilloPresentado] {
        let escalera = escala.escaleraDeBrillo()
        return escalera.peldanos.enumerated().map { i, peldano in
            let subida = i == 0 ? nil : escalera.subidas[i - 1]
            return PeldanoDeBrilloPresentado(
                escala: peldano, nombre: peldano.nombre(en: notacion),
                brillo: conSigno(peldano.estadisticas.brilloPorQuintas),
                cambio: subida.map { $0.desde.nombre(en: notacion) + " → " + $0.hasta.nombre(en: notacion) } ?? "",
                esLaDePartida: i == escalera.posicion, sonido: .escala(peldano))
        }
    }
}
