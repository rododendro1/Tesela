import ArmoniaNucleo

// MARK: - Africa

extension TipoDeEscala {
    // MARK: Afinaciones equidistantes de África
    //
    // Dos afinaciones de xilófono que reparten la octava en partes casi iguales, como las describe Gerhard Kubik:
    // la equipentatónica del sur de Uganda (cinco partes de 240 cents), la del amadinda y el akadinda de Buganda, y
    // la equiheptatónica del bajo Zambeze (siete de 171 cents), la del timbila de los chopi de Mozambique. Cada
    // instrumento se afina a su manera y se aparta bastante del ideal; aquí va el ideal, en doce notas con cada grado
    // redondeado al semitono más cercano y en cents en su versión microtonal.
    // Fuente: Encyclopædia Britannica («African music: Equi-tonal systems»).

    /// Amadinda (cinco partes iguales de 240 cents): Do Re Fa Sol Si♭ en doce notas, como el sléndro.
    public static let amadinda = TipoDeEscala(
        nombre: "Amadinda", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Akadinda", "equipentatónica de Uganda"])
    /// Timbila (siete partes iguales de 171 cents): Do Re Mi♭ Fa Sol La Si♭ en doce notas, el dórico.
    public static let timbila = TipoDeEscala(
        nombre: "Timbila",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["Chopi", "equiheptatónica chopi"])

    public static let africanas: [TipoDeEscala] = [.amadinda, .timbila]
}

// MARK: Ficha

extension FichaDeTradicion {
    static let africa = FichaDeTradicion(
        .africa,
        [.init(.afinacion, TipoDeEscala.africanas)],
        microtonales: [
            // En cents: cinco partes de 240 y siete de 171,4 (redondeados).
            TipoDeEscalaMicrotonal(.amadinda, .razones, pasos: [0, 240, 480, 720, 960]),
            TipoDeEscalaMicrotonal(.timbila, .razones, pasos: [0, 171, 343, 514, 686, 857, 1029]),
        ])
}
