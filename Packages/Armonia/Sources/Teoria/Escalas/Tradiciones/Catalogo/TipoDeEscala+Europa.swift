import Elementos

// MARK: - Folklore europeo
//
// Las versiones microtonales (`afinaciones:` en cada escala). En cents: los armónicos 8 a 15 (9/8, 5/4, 11/8, 3/2,
// 13/8, 7/4 y 15/8, redondeados) y las razones de la gaita (9/8, 5/4, 4/3, 3/2, 5/3 y 7/4); los grados medidos en
// Svaneti.

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
        alias: ["ucraniana"],
        categoria: .escala, subtradicion: .ucrania)
    /// La escala de los górales de Podhale, en los Tatras polacos (Do Re Mi Fa♯ Sol La Si♭): mayor con la 4ª
    /// aumentada y la 7ª menor, como la acústica.
    public static let podhalanska = TipoDeEscala(
        nombre: "podhalańska",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["skala podhalańska", "podhalana", "escala podhalana", "Podhale", "góralska"],
        categoria: .escala, subtradicion: .polonia)
    /// La pentatónica de la canción popular húngara, la que estudiaron Bartók y Kodály: la–do–re–mi–sol
    /// (Do Mi♭ Fa Sol Si♭ desde Do), sin semitonos.
    public static let pentatonicaHungara = TipoDeEscala(
        nombre: "pentatónica húngara",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        categoria: .escala, subtradicion: .hungria)

    /// La escala istriana (Do Re♭ Mi♭ Fa♭ Sol♭ La♭♭; Mi Fa Sol La♭ Si♭ Do♭ sobre Mi), la del canto a dos voces y
    /// de las sopile de Istria y el Kvarner: seis notas que alternan semitonos y tonos, y que cierra con una
    /// cadencia frigia. No es temperada y cada intérprete la entona a su manera (Žganec y Sremec, «Hrvatske narodne
    /// pjesme i plesovi», 1951; Marušić, «Reception of Istrian Musical Traditions», 2007). El Hardanger noruego
    /// no está todavía: las fuentes describen la afinación del violín, no una escala fija.
    public static let istriana = TipoDeEscala(
        nombre: "istriana",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaDisminuida, .sextaDisminuida,
        ],
        alias: ["escala istriana", "istarska ljestvica", "istarska"],
        categoria: .escala, subtradicion: .istria)

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
        alias: ["Alphorn", "trompa alpina", "cuerno de los Alpes"],
        categoria: .escala, subtradicion: .alpes,
        afinaciones: [.init(.razones, pasos: [0, 204, 386, 551, 702, 841, 969, 1088])])
    /// La escala de la gaita escocesa de las Highlands: un mixolidio (Do Re Mi Fa Sol La Si♭ desde Do; en la gaita,
    /// sobre La).
    public static let gaitaEscocesa = TipoDeEscala(
        nombre: "gaita escocesa",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["Great Highland Bagpipe", "gaita de las Highlands", "píob mhór"],
        categoria: .escala, subtradicion: .escocia,
        afinaciones: [.init(.razones, pasos: [0, 204, 386, 498, 702, 884, 969])])

    // MARK: Canto georgiano
    //
    // La polifonía tradicional de Georgia no usa la escala temperada ni la justa: las cuartas y las quintas son casi
    // puras, pero los pasos son de unos 165 a 185 cents, entre el semitono y el tono, y la tercera es neutra. Los
    // grados son los medidos en los cantos de Svaneti (Scherbaum, Mzhavanadze, Rosenzweig y Müller, «Tuning systems of
    // traditional Georgian singing determined from a new corpus of field recordings», Musicologist, 2022): en el
    // canto melódico, del 1.º al 6.º, y el 7.º en el armónico. En doce notas, cada uno va a la nota más cercana.

    /// La escala del canto polifónico georgiano, como se mide en Svaneti (Do Re Mi♭ Fa Sol La Si♭ en doce notas):
    /// pasos casi iguales, con la tercera neutra y la segunda y la sexta bajas.
    public static let georgiana = TipoDeEscala(
        nombre: "georgiana",
        intervalos: TipoDeEscala.dorico.intervalos,
        alias: ["escala georgiana", "svana", "Svaneti", "canto georgiano"],
        categoria: .escala, subtradicion: .georgia,
        afinaciones: [.init(.razones, pasos: [0, 163, 332, 509, 693, 868, 1018])])

    package static let europeas: [TipoDeEscala] = [
        .doricoUcraniano, .podhalanska, .pentatonicaHungara, .cuernoAlpino, .gaitaEscocesa, .georgiana,
        .istriana,
    ]
}
