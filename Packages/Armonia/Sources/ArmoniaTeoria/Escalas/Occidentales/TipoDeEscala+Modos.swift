import ArmoniaNucleo
// MARK: - Modos de la menor armónica, de la menor melódica y de la mayor armónica, y otros modos habituales.

extension TipoDeEscala {
    // Modos de la menor armónica (2.º a 7.º grado).
    public static let locrioSextaNatural = TipoDeEscala(
        nombre: "locrio ♮6",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
                     .quintaDisminuida, .sextaMayor, .septimaMenor],
        alias: ["locrio natural 6", "locrio ♯6"])
    public static let jonicoAumentado = TipoDeEscala(
        nombre: "jónico ♯5",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
                     .quintaAumentada, .sextaMayor, .septimaMayor],
        alias: ["jónico aumentado"])
    public static let doricoCuartaAumentada = TipoDeEscala(
        nombre: "dórico ♯4",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
                     .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["dórico ucraniano", "menor rumana", "rumana"])
    public static let frigioDominante = TipoDeEscala(
        nombre: "frigio dominante",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
                     .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["frigio mayor", "frigio ♯3", "española", "frigio español", "dominante ♭9 ♭13", "frigio ♮3"])
    public static let lidioSegundaAumentada = TipoDeEscala(
        nombre: "lidio ♯2",
        intervalos: [.unisono, .segundaAumentada, .terceraMayor, .cuartaAumentada,
                     .quintaJusta, .sextaMayor, .septimaMayor])
    public static let ultralocrio = TipoDeEscala(
        nombre: "ultralocrio",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
                     .quintaDisminuida, .sextaMenor, .septimaDisminuida],
        alias: ["superlocrio ♭♭7", "alterada disminuida"])

    // Modos de la menor melódica (2.º a 7.º grado).
    public static let doricoSegundaMenor = TipoDeEscala(
        nombre: "dórico ♭2",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
                     .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["frigio ♮6"])
    public static let lidioAumentado = TipoDeEscala(
        nombre: "lidio aumentado",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
                     .quintaAumentada, .sextaMayor, .septimaMayor],
        alias: ["lidio ♯5"])
    public static let lidioDominante = TipoDeEscala(
        nombre: "lidio dominante",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
                     .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["lidio ♭7", "acústica", "de Bartók", "Bartók", "de los armónicos", "armónicos", "nordestina", "escala nordestina", "mixolidio ♯4"])
    public static let mixolidioSextaMenor = TipoDeEscala(
        nombre: "mixolidio ♭6",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
                     .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["hindú", "mayor melódica", "eólico dominante"])
    public static let locrioSegundaNatural = TipoDeEscala(
        nombre: "locrio ♮2",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
                     .quintaDisminuida, .sextaMenor, .septimaMenor],
        alias: ["locrio natural 2", "semidisminuida"])
    public static let alterada = TipoDeEscala(
        nombre: "alterada",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
                     .quintaDisminuida, .sextaMenor, .septimaMenor],
        alias: ["superlocrio", "superlocria"])

    // Otras.
    public static let mayorArmonica = TipoDeEscala(
        nombre: "mayor armónica",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
                     .quintaJusta, .sextaMenor, .septimaMayor])
    public static let bebopDominante = TipoDeEscala(
        nombre: "bebop dominante",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
                     .quintaJusta, .sextaMayor, .septimaMenor, .septimaMayor],
        alias: ["bebop"])
    public static let bebopMayor = TipoDeEscala(
        nombre: "bebop mayor",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
                     .quintaJusta, .quintaAumentada, .sextaMayor, .septimaMayor])
    public static let bebopDorico = TipoDeEscala(
        nombre: "bebop dórico",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .terceraMayor,
                     .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["bebop menor"])

    // Modos de la mayor armónica (2.º a 7.º grado).
    public static let doricoQuintaDisminuida = TipoDeEscala(
        nombre: "dórico ♭5",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
                     .quintaDisminuida, .sextaMayor, .septimaMenor],
        alias: ["dórico b5"])
    public static let frigioCuartaDisminuida = TipoDeEscala(
        nombre: "frigio ♭4",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
                     .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["superfrigio"])
    public static let lidioTerceraMenor = TipoDeEscala(
        nombre: "lidio ♭3",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
                     .quintaJusta, .sextaMayor, .septimaMayor],
        alias: ["lidio disminuido"])
    public static let mixolidioSegundaMenor = TipoDeEscala(
        nombre: "mixolidio ♭2",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
                     .quintaJusta, .sextaMayor, .septimaMenor])
    public static let lidioAumentadoSegundaAumentada = TipoDeEscala(
        nombre: "lidio aumentado ♯2",
        intervalos: [.unisono, .segundaAumentada, .terceraMayor, .cuartaAumentada,
                     .quintaAumentada, .sextaMayor, .septimaMayor])
    public static let locrioSeptimaDisminuida = TipoDeEscala(
        nombre: "locrio ♭♭7",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
                     .quintaDisminuida, .sextaMenor, .septimaDisminuida])
}
