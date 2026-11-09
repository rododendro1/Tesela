import Armonia

// MARK: - Consultas: el catálogo de progresiones

extension LineaDeComandos {
    /// `progresiones [<texto>] [--en <tonalidad>]`: cada progresión del catálogo, o las que tienen el texto en el
    /// nombre o en un alias en algún idioma, con su cifrado romano y sus acordes sobre Do, o sobre la tónica de
    /// `--en`, en el modo de la progresión.
    ///
    ///     cadencia andaluza: i VII VI V · Lam Sol Fa Mi
    static func progresiones(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(textos)
        // `--en` lleva una nota (`--en La`) o una tonalidad (`--en La menor`), de la que vale la tónica.
        var tonica = Nota.do
        if let texto = try argumentos.valorConPalabras(.en, siFalta: .faltaTonalidadTrasEn) {
            tonica =
                try (try? Nota(leyendo: texto, enLaOrden: notacion))
                ?? Tonalidad(leyendo: texto, enLaOrden: notacion).tonica
        }
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        let halladas =
            ProgresionConNombre.buscar(nombre: texto).map { [$0] } ?? ProgresionConNombre.buscar(conteniendo: texto)
        guard !halladas.isEmpty else {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + Mensaje.ningunaProgresion.texto(en: notacion) + "\n", codigo: 1)
        }
        let lineas = halladas.map { progresion in
            let acordes = progresion.acordes(sobre: tonica).map { $0.cifrado(en: notacion) }
            return "\(progresion.nombre(en: notacion)): \(progresion.cifrado) · " + acordes.joined(separator: " ")
        }
        return bien(lineas.joined(separator: "\n"))
    }
}
