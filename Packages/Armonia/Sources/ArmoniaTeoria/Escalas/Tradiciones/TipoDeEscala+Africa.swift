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

    // MARK: Kora y mbira
    //
    // Las cuatro afinaciones de la kora mandinga, como las midió Roderic Knight en la de Foday Musa Suso (Gambia,
    // 1976), de la Database of Musical Scales: hardino y tomora ba, mayores; sauta, con la 4ª aumentada (lidia), y
    // tomora mesengo, menor (dórica). Cada koraísta afina un poco distinto; los cents son los de esa medida. Y la
    // nyamaropa, la afinación más antigua y común de la mbira dzavadzimu de los shona (Zimbabue), cercana al
    // mixolidio; varía mucho de un instrumento a otro, así que no lleva versión en cents.

    /// Hardino (kora): la mayor, con la 2ª y la 6ª algo bajas.
    public static let hardino = TipoDeEscala(
        nombre: "Hardino", intervalos: TipoDeEscala.mayor.intervalos, alias: ["kora hardino"])
    /// Sauta (kora): la lidia, con la 4ª aumentada.
    public static let sauta = TipoDeEscala(
        nombre: "Sauta", intervalos: TipoDeEscala.lidio.intervalos, alias: ["kora sauta"])
    /// Tomora ba o silaba (kora): la mayor, con la 3ª y la 7ª algo bajas.
    public static let tomoraBa = TipoDeEscala(
        nombre: "Tomora ba", intervalos: TipoDeEscala.mayor.intervalos, alias: ["Silaba", "Tomoraba", "kora silaba"])
    /// Tomora mesengo (kora): la dórica, con la 2ª, la 3ª, la 6ª y la 7ª algo altas.
    public static let tomoraMesengo = TipoDeEscala(
        nombre: "Tomora mesengo", intervalos: TipoDeEscala.dorico.intervalos, alias: ["Tomoramesengo"])
    /// Nyamaropa (mbira dzavadzimu): cercana al mixolidio.
    public static let nyamaropa = TipoDeEscala(
        nombre: "Nyamaropa", intervalos: TipoDeEscala.mixolidio.intervalos, alias: ["mbira nyamaropa"])

    public static let africanas: [TipoDeEscala] = [
        .amadinda, .timbila, .hardino, .sauta, .tomoraBa, .tomoraMesengo, .nyamaropa,
    ]
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
            // Las medidas de Knight, en cents.
            TipoDeEscalaMicrotonal(.hardino, .razones, pasos: [0, 185, 405, 500, 700, 885, 1105]),
            TipoDeEscalaMicrotonal(.sauta, .razones, pasos: [0, 185, 405, 605, 700, 885, 1105]),
            TipoDeEscalaMicrotonal(.tomoraBa, .razones, pasos: [0, 200, 385, 500, 700, 900, 1085]),
            TipoDeEscalaMicrotonal(.tomoraMesengo, .razones, pasos: [0, 230, 325, 500, 700, 930, 1025]),
        ])
}
