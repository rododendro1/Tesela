import ArmoniaElementos

// MARK: - Renacimiento

extension TipoDeEscala {
    // MARK: Musica ficta y musica recta
    //
    // Los modos de la polifonía del Renacimiento no se cantaban con las notas escritas: los cantores añadían
    // alteraciones que no estaban en la partitura, la musica ficta («fingida»), frente a la musica recta, las notas de
    // la mano guidoniana (las siete naturales y el Si♭ del hexacordo blando). Las dos reglas más citadas: en la
    // cadencia, la nota bajo la final sube un semitono (el subsemitonium modi: Do♯ en Re, Fa♯ en Sol), y una nota que
    // pasa por encima del La y vuelve baja a Si♭ («una nota super la semper est canendum fa»). Así, el dórico sube con
    // Do♯ y baja con Si♭ y Do, como la menor melódica; el mixolidio sube con Fa♯ y baja con Fa; y el lidio de los modos
    // 5 y 6 se cantaba casi siempre con Si♭, que lo vuelve un jónico sobre Fa. El frigio no tiene subsemitonium (su Re
    // no sube a Re♯) y aquí no está; el resto son los modos gregorianos y los de Glareano, que ya están.
    //
    // Las versiones microtonales son las de los temperamentos mesotónicos del Renacimiento, en cents: la primera, el
    // de ¼ de coma sintónica, el de Pietro Aron (Toscanello, 1523), con las terceras mayores puras (5/4); después,
    // el de 2/7 de coma de Gioseffo Zarlino (Le istitutioni harmoniche, 1558) y el de ⅓ de coma de Francisco de
    // Salinas (De musica libri septem, 1577), con las terceras menores puras (6/5). Cada nota está a un número de
    // quintas mesotónicas de la final, así que Do♯ y Re♭ no son la misma nota: el Do♯ del dórico con ficta, a cinco
    // quintas de Re, cae a 1083 cents, y un Re♭ caería a 1124, una diesis (41 cents) más arriba.

    /// El dórico con ficta (Re): sube con el Do♯ de la cadencia y baja con Do y con el Si♭ de «fa super la».
    public static let doricoConFicta = TipoDeEscala(
        nombre: "dórico con ficta",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["dórico con musica ficta"],
        categoria: .escala,
        afinaciones: [
            .init(
                .razones, pasos: [0, 193, 310, 503, 697, 890, 1083],
                pasosDescendentes: [0, 193, 310, 503, 697, 814, 1007]),
            .init(
                .razones, pasos: [0, 192, 313, 504, 696, 887, 1079],
                pasosDescendentes: [0, 192, 313, 504, 696, 817, 1008], fuente: "Zarlino, 1558"),
            .init(
                .razones, pasos: [0, 190, 316, 505, 695, 884, 1074],
                pasosDescendentes: [0, 190, 316, 505, 695, 821, 1010], fuente: "Salinas, 1577"),
        ])
    /// El mixolidio con ficta (Sol): sube con el Fa♯ de la cadencia y baja con Fa.
    public static let mixolidioConFicta = TipoDeEscala(
        nombre: "mixolidio con ficta",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["mixolidio con musica ficta"],
        categoria: .escala,
        afinaciones: [
            .init(
                .razones, pasos: [0, 193, 386, 503, 697, 890, 1083],
                pasosDescendentes: [0, 193, 386, 503, 697, 890, 1007]),
            .init(
                .razones, pasos: [0, 192, 383, 504, 696, 887, 1079],
                pasosDescendentes: [0, 192, 383, 504, 696, 887, 1008], fuente: "Zarlino, 1558"),
            .init(
                .razones, pasos: [0, 190, 379, 505, 695, 884, 1074],
                pasosDescendentes: [0, 190, 379, 505, 695, 884, 1010], fuente: "Salinas, 1577"),
        ])
    /// El lidio con Si♭ (Fa Sol La Si♭ Do Re Mi): los modos 5 y 6 como se cantaban, con las notas de la mayor.
    public static let lidioConSiBemol = TipoDeEscala(
        nombre: "lidio con si bemol",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        alias: ["lidio con b molle", "tritus con b molle"],
        categoria: .escala,
        afinaciones: [
            .init(.razones, pasos: [0, 193, 386, 503, 697, 890, 1083]),
            .init(.razones, pasos: [0, 192, 383, 504, 696, 887, 1079], fuente: "Zarlino, 1558"),
            .init(.razones, pasos: [0, 190, 379, 505, 695, 884, 1074], fuente: "Salinas, 1577"),
        ])
    /// La musica recta en una octava desde Do: las siete naturales y el Si♭ (Do Re Mi Fa Sol La Si♭ Si), las notas
    /// de los tres hexacordos.
    public static let musicaRecta = TipoDeEscala(
        nombre: "musica recta",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
            .septimaMayor,
        ],
        alias: ["musica vera"],
        categoria: .escala,
        afinaciones: [
            .init(.razones, pasos: [0, 193, 386, 503, 697, 890, 1007, 1083]),
            .init(.razones, pasos: [0, 192, 383, 504, 696, 887, 1008, 1079], fuente: "Zarlino, 1558"),
            .init(.razones, pasos: [0, 190, 379, 505, 695, 884, 1010, 1074], fuente: "Salinas, 1577"),
        ])

    /// Los modos con ficta y la musica recta.
    package static let escalasRenacentistas: [TipoDeEscala] = [
        .doricoConFicta, .mixolidioConFicta, .lidioConSiBemol, .musicaRecta,
    ]
}
