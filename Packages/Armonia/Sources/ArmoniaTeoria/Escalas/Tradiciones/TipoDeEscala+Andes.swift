import ArmoniaNucleo

// MARK: - Andes

extension TipoDeEscala {
    // MARK: Escalas andinas

    /// La pentatónica menor de los Andes (huayno, yaraví).
    public static let andina = TipoDeEscala(
        nombre: "pentatónica andina", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["andina"],
        categoria: .escala)
    /// La tritónica de las melodías más antiguas: una tríada menor (Do Mi♭ Sol).
    public static let tritonicaAndina = TipoDeEscala(
        nombre: "tritónica andina", intervalos: [.unisono, .terceraMenor, .quintaJusta],
        alias: ["tritónica"],
        categoria: .escala)

    public static let andinas: [TipoDeEscala] = [.andina, .tritonicaAndina]
}

// MARK: Ficha

extension FichaDeTradicion {
    static let andes = FichaDeTradicion(.andes, [TipoDeEscala.andinas])
}
