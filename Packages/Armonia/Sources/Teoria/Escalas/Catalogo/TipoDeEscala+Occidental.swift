import Elementos

// MARK: - Modos de la menor armónica, de la menor melódica y de la mayor armónica, y otros modos habituales.

extension TipoDeEscala {
    // Modos de la menor armónica (2.º a 7.º grado).
    public static let locrioSextaNatural = TipoDeEscala(
        nombre: "locrio ♮6",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        alias: ["locrio natural 6", "locrio ♯6"],
        estilos: [.sintetica])
    public static let jonicoAumentado = TipoDeEscala(
        nombre: "jónico ♯5",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        alias: ["jónico aumentado"],
        estilos: [.sintetica])
    public static let doricoCuartaAumentada = TipoDeEscala(
        nombre: "dórico ♯4",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["menor rumana", "rumana"],
        estilos: [.folclore], regiones: [.ucrania, .rumania])
    public static let frigioDominante = TipoDeEscala(
        nombre: "frigio dominante",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["española", "frigio español", "frigio mayor", "frigio ♯3", "frigio ♮3", "dominante ♭9 ♭13"],
        estilos: [.flamenco, .jazz, .popRock], corrientes: [.heavyMetal, .metalNeoclasico])
    public static let lidioSegundaAumentada = TipoDeEscala(
        nombre: "lidio ♯2",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        estilos: [.sintetica])
    public static let ultralocrio = TipoDeEscala(
        nombre: "ultralocrio",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaDisminuida, .sextaMenor, .septimaDisminuida,
        ],
        alias: ["superlocrio ♭♭7", "alterada disminuida"],
        estilos: [.sintetica])

    // Modos de la menor melódica (2.º a 7.º grado).
    public static let doricoSegundaMenor = TipoDeEscala(
        nombre: "dórico ♭2",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["frigio ♮6"],
        estilos: [.jazz])
    public static let lidioAumentado = TipoDeEscala(
        nombre: "lidio aumentado",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        alias: ["lidio ♯5"],
        estilos: [.jazz])
    public static let lidioDominante = TipoDeEscala(
        nombre: "lidio dominante",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: [
            "acústica", "lidio ♭7", "mixolidio ♯4", "de los armónicos", "armónicos", "de Bartók", "Bartók",
            "nordestina", "escala nordestina",
        ],
        estilos: [.jazz, .deCompositor], corrientes: [.modal])
    public static let mixolidioSextaMenor = TipoDeEscala(
        nombre: "mixolidio ♭6",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["eólico dominante", "hindú", "mayor melódica"],
        estilos: [.jazz])
    public static let locrioSegundaNatural = TipoDeEscala(
        nombre: "locrio ♮2",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["semidisminuida", "locrio natural 2"],
        estilos: [.jazz])
    public static let alterada = TipoDeEscala(
        nombre: "alterada",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["superlocrio"], variantes: ["superlocria"],
        estilos: [.jazz], corrientes: [.bebop])

    // Otras.
    public static let mayorArmonica = TipoDeEscala(
        nombre: "mayor armónica",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        estilos: [.clasica])
    public static let bebopDominante = TipoDeEscala(
        nombre: "bebop dominante",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor, .septimaMayor,
        ],
        alias: ["bebop"],
        estilos: [.jazz], corrientes: [.bebop])
    /// La mayor con la 5ª aumentada de paso (Do Re Mi Fa Sol Sol♯ La Si). Es también la «sexta disminuida» de Barry
    /// Harris: el acorde de sexta (Do Mi Sol La) y el de séptima disminuida de la sensible (Si Re Fa Sol♯) alternados.
    public static let bebopMayor = TipoDeEscala(
        nombre: "bebop mayor",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        alias: ["sexta disminuida", "sexta mayor disminuida", "de sexta disminuida", "Barry Harris"],
        estilos: [.jazz], corrientes: [.bebop])
    public static let bebopDorico = TipoDeEscala(
        nombre: "bebop dórico",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .terceraMayor,
            .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["bebop menor"],
        estilos: [.jazz], corrientes: [.bebop])
    /// El locrio con la 5ª justa de paso (Do Re♭ Mi♭ Fa Sol♭ Sol La♭ Si♭), la del acorde semidisminuido.
    public static let bebopLocrio = TipoDeEscala(
        nombre: "bebop locrio",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        estilos: [.jazz], corrientes: [.bebop])
    /// El lidio con la 5ª aumentada de paso (Do Re Mi Fa♯ Sol Sol♯ La Si), como la bebop mayor.
    public static let bebopLidio = TipoDeEscala(
        nombre: "bebop lidio",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        estilos: [.jazz], corrientes: [.bebop])

    // Modos de la mayor armónica (2.º a 7.º grado).
    public static let doricoQuintaDisminuida = TipoDeEscala(
        nombre: "dórico ♭5",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        variantes: ["dórico b5"],
        estilos: [.sintetica])
    public static let frigioCuartaDisminuida = TipoDeEscala(
        nombre: "frigio ♭4",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["superfrigio"],
        estilos: [.sintetica])
    public static let lidioTerceraMenor = TipoDeEscala(
        nombre: "lidio ♭3",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["lidio disminuido"],
        estilos: [.sintetica])
    public static let mixolidioSegundaMenor = TipoDeEscala(
        nombre: "mixolidio ♭2",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        estilos: [.sintetica])
    public static let lidioAumentadoSegundaAumentada = TipoDeEscala(
        nombre: "lidio aumentado ♯2",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaAumentada,
            .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        estilos: [.sintetica])
    public static let locrioSeptimaDisminuida = TipoDeEscala(
        nombre: "locrio ♭♭7",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaDisminuida,
        ],
        estilos: [.sintetica])
}

// MARK: - Modos de la doble armónica, de las napolitanas y de la mayor húngara.

extension TipoDeEscala {
    // Modos de la doble armónica (2.º, 3.º, 5.º, 6.º y 7.º grado; el 4.º es la menor húngara).

    /// Do Re♯ Mi Fa♯ Sol La♯ Si.
    public static let lidioSegundaSextaAumentadas = TipoDeEscala(
        nombre: "lidio ♯2 ♯6",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaAumentada, .septimaMayor,
        ],
        estilos: [.sintetica])
    /// Do Re♭ Mi♭ Fa♭ Sol La♭ Si𝄫.
    public static let ultrafrigio = TipoDeEscala(
        nombre: "ultrafrigio",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaDisminuida,
        ],
        estilos: [.sintetica])
    /// Do Re♭ Mi Fa Sol♭ La Si♭.
    public static let oriental = TipoDeEscala(
        nombre: "oriental",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        estilos: [.sintetica])
    /// Do Re♯ Mi Fa Sol♯ La Si.
    public static let jonicoSegundaQuintaAumentadas = TipoDeEscala(
        nombre: "jónico ♯2 ♯5",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta,
            .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        estilos: [.sintetica])
    /// Do Re♭ Mi𝄫 Fa Sol♭ La♭ Si𝄫.
    public static let locrioTerceraSeptimaDisminuidas = TipoDeEscala(
        nombre: "locrio ♭♭3 ♭♭7",
        intervalos: [
            .unisono, .segundaMenor, .terceraDisminuida, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaDisminuida,
        ],
        estilos: [.sintetica])

    // Modos de la napolitana mayor (2.º, 3.º, 6.º y 7.º; el 4.º es el lidio menor y el 5.º,
    // la mayor locria).

    /// Do Re Mi Fa♯ Sol♯ La♯ Si: tonos enteros con sensible.
    public static let lidioAumentadoSextaAumentada = TipoDeEscala(
        nombre: "lidio aumentado ♯6",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaAumentada, .sextaAumentada, .septimaMayor,
        ],
        alias: ["tonos enteros con sensible"],
        estilos: [.sintetica])
    /// Do Re Mi Fa♯ Sol♯ La Si♭.
    public static let lidioDominanteAumentado = TipoDeEscala(
        nombre: "lidio dominante aumentado",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaAumentada, .sextaMayor, .septimaMenor,
        ],
        alias: ["lidio dominante ♯5", "lidio aumentado ♭7"],
        estilos: [.sintetica])
    /// Do Re Mi♭ Fa♭ Sol♭ La♭ Si♭.
    public static let locrioSegundaNaturalCuartaDisminuida = TipoDeEscala(
        nombre: "locrio ♮2 ♭4",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaDisminuida,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["semidisminuida ♭4", "locrio natural 2 ♭4"],
        estilos: [.sintetica])
    /// Do Re♭ Mi𝄫 Fa♭ Sol♭ La♭ Si♭.
    public static let superlocrioTerceraDisminuida = TipoDeEscala(
        nombre: "superlocrio ♭♭3",
        intervalos: [
            .unisono, .segundaMenor, .terceraDisminuida, .cuartaDisminuida,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["alterada ♭♭3"],
        estilos: [.sintetica])

    // Modos de la napolitana menor (2.º a 7.º).

    /// Do Re Mi Fa♯ Sol La♯ Si.
    public static let lidioSextaAumentada = TipoDeEscala(
        nombre: "lidio ♯6",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaAumentada, .septimaMayor,
        ],
        estilos: [.sintetica])
    /// Do Re Mi Fa Sol♯ La Si♭.
    public static let mixolidioAumentado = TipoDeEscala(
        nombre: "mixolidio aumentado",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaAumentada, .sextaMayor, .septimaMenor,
        ],
        alias: ["mixolidio ♯5"],
        estilos: [.sintetica])
    /// Do Re Mi♭ Fa♯ Sol La♭ Si♭: la menor natural con la 4ª aumentada.
    public static let eolicoCuartaAumentada = TipoDeEscala(
        nombre: "eólico ♯4",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["gitana húngara", "menor ♯4"],
        estilos: [.sintetica])
    /// Do Re♭ Mi Fa Sol♭ La♭ Si♭.
    public static let locrioDominante = TipoDeEscala(
        nombre: "locrio dominante",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["locrio ♮3", "locrio mayor ♭2"],
        estilos: [.sintetica])
    /// Do Re♯ Mi Fa Sol La Si.
    public static let jonicoSegundaAumentada = TipoDeEscala(
        nombre: "jónico ♯2",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        estilos: [.sintetica])
    /// Do Re♭ Mi𝄫 Fa♭ Sol♭ La♭ Si𝄫.
    public static let ultralocrioTerceraDisminuida = TipoDeEscala(
        nombre: "ultralocrio ♭♭3",
        intervalos: [
            .unisono, .segundaMenor, .terceraDisminuida, .cuartaDisminuida,
            .quintaDisminuida, .sextaMenor, .septimaDisminuida,
        ],
        estilos: [.sintetica])

    // Modos de la mayor húngara (2.º a 7.º).

    /// Do Re♭ Mi♭ Fa♭ Sol♭ La𝄫 Si𝄫.
    public static let ultralocrioSextaDisminuida = TipoDeEscala(
        nombre: "ultralocrio ♭♭6",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaDisminuida, .sextaDisminuida, .septimaDisminuida,
        ],
        alias: ["alterada ♭♭6 ♭♭7"],
        estilos: [.sintetica])
    /// Do Re Mi♭ Fa Sol♭ La♭ Si.
    public static let menorArmonicaQuintaDisminuida = TipoDeEscala(
        nombre: "menor armónica ♭5",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMayor,
        ],
        estilos: [.sintetica])
    /// Do Re♭ Mi♭ Fa♭ Sol♭ La Si♭: la alterada con la 6ª mayor.
    public static let superlocrioSextaNatural = TipoDeEscala(
        nombre: "superlocrio ♮6",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        alias: ["alterada ♮6"],
        estilos: [.sintetica])
    /// Do Re Mi♭ Fa Sol♯ La Si.
    public static let menorMelodicaQuintaAumentada = TipoDeEscala(
        nombre: "menor melódica ♯5",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        alias: ["menor de jazz ♯5"],
        estilos: [.sintetica])
    /// Do Re♭ Mi♭ Fa♯ Sol La Si♭.
    public static let doricoSegundaMenorCuartaAumentada = TipoDeEscala(
        nombre: "dórico ♭2 ♯4",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["dórico ♭9 ♯11"],
        estilos: [.sintetica])
    /// Do Re Mi♯ Fa♯ Sol♯ La Si.
    public static let lidioAumentadoTerceraAumentada = TipoDeEscala(
        nombre: "lidio aumentado ♯3",
        intervalos: [
            .unisono, .segundaMayor, .terceraAumentada, .cuartaAumentada,
            .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        estilos: [.sintetica])
}
