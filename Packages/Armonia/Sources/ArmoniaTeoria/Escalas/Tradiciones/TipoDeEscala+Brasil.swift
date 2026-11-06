import ArmoniaNucleo

// MARK: - Brasil

extension TipoDeEscala {
    // MARK: Modos nordestinos
    //
    // Los tres modos de la música del Nordeste de Brasil (el baião, el forró, el xaxado, los aboios y las
    // cantorias de los repentistas): el mixolidio, el lidio con la 7ª menor (la «escala nordestina», que es también
    // la acústica) y el dórico. Llevan su nombre en portugués; «nordestina», a secas, sigue siendo el lidio
    // dominante.

    /// Mixolídio nordestino: Do Re Mi Fa Sol La Si♭.
    public static let mixolidioNordestino = TipoDeEscala(
        nombre: "mixolídio nordestino", intervalos: TipoDeEscala.mixolidio.intervalos,
        alias: ["modo mixolídio nordestino"],
        categoria: .escala)
    /// Lídio nordestino: Do Re Mi Fa♯ Sol La Si♭.
    public static let lidioNordestino = TipoDeEscala(
        nombre: "lídio nordestino", intervalos: TipoDeEscala.lidioDominante.intervalos,
        alias: ["modo lídio nordestino", "lídio com sétima menor", "lídio-mixolídio"],
        categoria: .escala)
    /// Dórico nordestino: Do Re Mi♭ Fa Sol La Si♭.
    public static let doricoNordestino = TipoDeEscala(
        nombre: "dórico nordestino", intervalos: TipoDeEscala.dorico.intervalos,
        alias: ["modo dórico nordestino"],
        categoria: .escala)

    public static let brasilenas: [TipoDeEscala] = [.mixolidioNordestino, .lidioNordestino, .doricoNordestino]
}

// MARK: Ficha

extension FichaDeTradicion {
    static let brasil = FichaDeTradicion(.brasil, [TipoDeEscala.brasilenas])
}
