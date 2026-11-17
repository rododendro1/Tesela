import Armonia
import ExposicionArmonia

// MARK: - Consultas: el catálogo de ornamentos

extension LineaDeComandos {
    /// Los ornamentos que pide `ornamentos [<texto>] [--sobre <altura>] [--en <escala>] [--duracion <figura>]
    /// [--estadisticas]`, cada uno presentado con lo que suena sobre la altura de `--sobre` (en la escala de `--en` o,
    /// sin ella, en la mayor de la nota), con qué figuras si la nota dura `--duracion`, y si se quiere su ficha. Una
    /// nota sin octava va en la cuarta. Con un nombre exacto, solo ese; si no, los que lo contienen (todos, sin texto).
    static func ornamentosPedidos(_ textos: [String], _ notacion: Notacion) throws -> (
        ornamentos: [OrnamentoPresentado], ficha: Bool
    ) {
        var argumentos = Argumentos(textos)
        var principal: Altura?
        if let texto = try argumentos.valor(.sobre) {
            if let altura = try? Altura(leyendo: texto, enLaOrden: notacion) {
                principal = altura
            } else {
                principal = Altura(try Nota(leyendo: texto, enLaOrden: notacion), octava: 4)
            }
        }
        var escala: Escala?
        if let texto = try argumentos.valorConPalabras(.en) { escala = try LineaDeComandos.escala(texto, en: notacion) }
        let duracion = try argumentos.valor(.duracion).map { try Duracion(leyendo: $0) }
        let ficha = argumentos.quitarMarca(.estadisticas)
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        let hallados =
            OrnamentoConNombre.buscar(nombre: texto).map { [$0] } ?? OrnamentoConNombre.buscar(conteniendo: texto)
        guard let sobre = principal ?? duracion.map({ _ in Altura(.do, octava: 4) }) else {
            return (hallados.map { OrnamentoPresentado($0, en: notacion) }, ficha)
        }
        let deLaNota = escala ?? Escala(sobre.nota, .mayor)
        if let primero = hallados.first, primero.alturas(sobre: sobre, en: deLaNota) == nil {
            throw ErrorDeUso.alturaFueraDeLaEscala(sobre.nombre(en: notacion), deLaNota.nombre(en: notacion))
        }
        return (
            hallados.map { OrnamentoPresentado($0, sobre: sobre, escala: deLaNota, duracion: duracion, en: notacion) },
            ficha
        )
    }

    /// `ornamentos [<texto>] [opciones]`: cada ornamento del catálogo, o los que tienen el texto en el nombre o en un
    /// alias en algún idioma, con sus pasos por grados y, con `--sobre`, lo que suena (con `--duracion`, con sus
    /// figuras: sin `--sobre`, sobre Do4). Con `--estadisticas`, debajo
    /// de cada uno, su ficha.
    ///
    ///     grupeto: +1 0 −1 0 · Mi4 Re4 Do4 Re4
    static func ornamentos(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (hallados, ficha) = try ornamentosPedidos(textos, notacion)
        guard !hallados.isEmpty else {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + Mensaje.ningunOrnamento.texto(en: notacion) + "\n", codigo: 1)
        }
        let lineas = hallados.flatMap { presentado -> [String] in
            var linea = presentado.nombre + ": " + presentado.textoDeLosPasos
            if let notas = presentado.tocado ?? presentado.alturas { linea += " · " + notas.joined(separator: " ") }
            guard ficha else { return [linea] }
            return [linea] + presentado.ficha(en: notacion).map { "  " + $0.nombre + ": " + $0.valor }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// `ornamentos [<texto>] [opciones] --json`: los mismos ornamentos, con toda su ficha.
    static func ornamentosJSON(_ textos: [String], _ notacion: Notacion) throws -> [OrnamentoPresentado] {
        try ornamentosPedidos(textos, notacion).ornamentos
    }
}
