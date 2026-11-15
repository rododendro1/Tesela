import Armonia

// MARK: - El retículo de la entonación justa

extension LineaDeComandos {
    /// `reticulo Do Lam Rem Sol Do`: la progresión en el retículo de la entonación justa (SVG), con la deriva en el
    /// título si vuelve a su primera fundamental; con `--resumen`, en texto: la razón y el desvío de cada fundamental.
    static func reticulo(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        let resumen = argumentos.quitarMarca(.resumen)
        let reticulo = try reticuloPedido(&argumentos, notacion)
        guard resumen else {
            return bien(reticulo.svg(opciones: .init(notacion: notacion)).trimmingCharacters(in: "\n"))
        }
        var lineas = reticulo.acordes.map { puesto in
            let punto = puesto.fundamental
            return puesto.acorde.cifrado(en: notacion) + ": " + reticulo.nota(de: punto).nombreCompacto(en: notacion)
                + " " + punto.razon.description + " · " + Redondeo.texto(punto.desvio) + " ¢"
        }
        if let deriva = reticulo.deriva {
            lineas.append(TextosDeConsola.en(notacion) { $0.derivaDelReticulo(Redondeo.texto(deriva)) })
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// `reticulo … --json`: cada acorde con los puntos de sus notas, y la deriva.
    static func reticuloJSON(_ argumentos: [String], _ notacion: Notacion) throws -> ReticuloPresentado {
        var argumentos = Argumentos(argumentos)
        _ = argumentos.quitarMarca(.resumen)
        return ReticuloPresentado(try reticuloPedido(&argumentos, notacion), en: notacion)
    }

    private static func reticuloPedido(_ argumentos: inout Argumentos, _ notacion: Notacion) throws -> ReticuloJusto {
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltanAcordesDelReticulo }
        let acordes = try argumentos.restantes.map { try Acorde(leyendo: $0, enLaOrden: notacion) }
        return ReticuloJusto(acordes)
    }
}

/// Lo que da `reticulo … --json`.
struct ReticuloPresentado: Encodable, Sendable {
    struct Nota: Encodable, Sendable {
        let nota: String
        let quintas: Int
        let terceras: Int
        let razon: String
        let cents: Double
        let desvio: Double
    }

    struct AcordeEnElReticulo: Encodable, Sendable {
        let cifrado: String
        let fundamental: Nota
        let notas: [Nota]
    }

    let tonica: String
    let acordes: [AcordeEnElReticulo]
    let deriva: Double?

    init(_ reticulo: ReticuloJusto, en notacion: Notacion) {
        func nota(_ punto: ReticuloJusto.Punto) -> Nota {
            Nota(
                nota: reticulo.nota(de: punto).nombreCompacto(en: notacion), quintas: punto.quintas,
                terceras: punto.terceras, razon: punto.razon.description, cents: Redondeo.valor(punto.cents),
                desvio: Redondeo.valor(punto.desvio))
        }
        tonica = reticulo.tonica.nombreCompacto(en: notacion)
        acordes = reticulo.acordes.map {
            AcordeEnElReticulo(
                cifrado: $0.acorde.cifrado(en: notacion), fundamental: nota($0.fundamental), notas: $0.notas.map(nota))
        }
        deriva = reticulo.deriva
    }
}
