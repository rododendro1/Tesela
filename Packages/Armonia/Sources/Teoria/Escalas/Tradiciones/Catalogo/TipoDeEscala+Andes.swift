import Elementos

// MARK: - Andes

extension TipoDeEscala {
    // MARK: Escalas andinas

    /// La pentatónica menor de los Andes (huayno, yaraví).
    public static let andina = TipoDeEscala(
        nombre: "pentatónica andina", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["andina"],
        tradicion: .andes, categoria: .escala)
    /// La tritónica de las melodías más antiguas: una tríada menor (Do Mi♭ Sol).
    public static let tritonicaAndina = TipoDeEscala(
        nombre: "tritónica andina", intervalos: [.unisono, .terceraMenor, .quintaJusta],
        alias: ["tritónica"],
        tradicion: .andes, categoria: .escala)

    package static let andinas: [TipoDeEscala] = [.andina, .tritonicaAndina]
}
