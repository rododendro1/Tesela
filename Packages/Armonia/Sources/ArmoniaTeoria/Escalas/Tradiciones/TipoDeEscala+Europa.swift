import ArmoniaNucleo

// MARK: - Folklore europeo

extension TipoDeEscala {
    // MARK: Escalas populares de Europa
    //
    // Otras escalas de la música popular europea ya están entre las occidentales, porque así se conocen en los
    // libros de teoría, y no se repiten aquí: la mayor rumana, la menor húngara (o gitana), la flamenca (andaluza), el
    // frigio dominante, la pentatónica escocesa, las hexatónicas gaélicas y la acústica de Bartók.

    /// El dórico ucraniano (Do Re Mi♭ Fa♯ Sol La Si♭): el dórico ♯4 de las canciones populares de Ucrania y de sus
    /// vecinos, y del klezmer, donde se llama Misheberakh.
    public static let doricoUcraniano = TipoDeEscala(
        nombre: "dórico ucraniano",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["ucraniana"])
    /// La escala de los górales de Podhale, en los Tatras polacos (Do Re Mi Fa♯ Sol La Si♭): mayor con la 4ª
    /// aumentada y la 7ª menor, como la acústica.
    public static let podhalanska = TipoDeEscala(
        nombre: "podhalańska",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["skala podhalańska", "podhalana", "escala podhalana", "Podhale", "góralska"])
    /// La pentatónica de la canción popular húngara, la que estudiaron Bartók y Kodály: la–do–re–mi–sol
    /// (Do Mi♭ Fa Sol Si♭ desde Do), sin semitonos.
    public static let pentatonicaHungara = TipoDeEscala(
        nombre: "pentatónica húngara",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor])

    // MARK: Instrumentos de afinación natural
    //
    // El cuerno de los Alpes no tiene agujeros: da los armónicos de su tubo, de una afinación exacta. Del 8.º al 15.º
    // forman una escala de ocho notas con tres que no son temperadas: el 11.º (el «fa del cuerno», 551 cents, casi a
    // medio camino entre Fa y Fa♯), el 13.º (841, entre La♭ y La) y el 7.º del registro (el 14.º, 969, una séptima
    // menor baja). En doce notas, cada uno va a la nota más cercana: Fa♯, La♭ y Si♭.
    //
    // La gaita de las Highlands escocesas toca un mixolidio sobre La en afinación casi justa: la 3ª y la 6ª mayores
    // de 5/4 y 5/3, y el Sol agudo, una séptima natural de 7/4, más baja que la temperada. Cada gaita y cada
    // fabricante afinan un poco distinto; estas son las razones con que se describe habitualmente.

    /// Los armónicos del 8.º al 15.º del cuerno de los Alpes (Do Re Mi Fa♯ Sol La♭ Si♭ Si en doce notas).
    public static let cuernoAlpino = TipoDeEscala(
        nombre: "cuerno alpino",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMenor, .septimaMayor,
        ],
        alias: ["Alphorn", "trompa alpina", "cuerno de los Alpes"])
    /// La escala de la gaita escocesa de las Highlands: un mixolidio (Do Re Mi Fa Sol La Si♭ desde Do; en la gaita,
    /// sobre La).
    public static let gaitaEscocesa = TipoDeEscala(
        nombre: "gaita escocesa",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["Great Highland Bagpipe", "gaita de las Highlands", "píob mhór"])

    public static let europeas: [TipoDeEscala] = [
        .doricoUcraniano, .podhalanska, .pentatonicaHungara, .cuernoAlpino, .gaitaEscocesa,
    ]
}

// MARK: Ficha

extension FichaDeTradicion {
    static let europa = FichaDeTradicion(
        .europa,
        [.init(.escala, TipoDeEscala.europeas)],
        microtonales: [
            // En cents: los armónicos 8 a 15 (9/8, 5/4, 11/8, 3/2, 13/8, 7/4 y 15/8, redondeados) y las razones de la
            // gaita (9/8, 5/4, 4/3, 3/2, 5/3 y 7/4).
            TipoDeEscalaMicrotonal(.cuernoAlpino, .razones, pasos: [0, 204, 386, 551, 702, 841, 969, 1088]),
            TipoDeEscalaMicrotonal(.gaitaEscocesa, .razones, pasos: [0, 204, 386, 498, 702, 884, 969]),
        ])
}
