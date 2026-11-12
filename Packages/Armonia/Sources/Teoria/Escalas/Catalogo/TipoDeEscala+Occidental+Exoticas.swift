import Elementos

// MARK: - Escalas «exóticas» de la tradición occidental, simétricas y otras.

extension TipoDeEscala {
    // Escalas «exóticas» de la tradición occidental, con dos segundas aumentadas o casi.

    /// Dos tetracordos con 2ª aumentada (Do Re♭ Mi Fa Sol La♭ Si): el mismo contenido que el
    /// dromos Hitzazkiár y el thāṭ Bhairav.
    public static let dobleArmonica = TipoDeEscala(
        nombre: "doble armónica",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["doble armónica mayor", "bizantina", "gitana mayor"],
        estilos: [.folclore, .popRock], corrientes: [.heavyMetal])
    /// La menor armónica con la 4ª aumentada (Do Re Mi♭ Fa♯ Sol La♭ Si).
    public static let menorHungara = TipoDeEscala(
        nombre: "menor húngara",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["gitana menor", "doble armónica menor", "de Liszt", "Liszt"],
        estilos: [.folclore], regiones: [.hungria], documentada: .liszt1859)
    /// Do Re♯ Mi Fa♯ Sol La Si♭.
    public static let mayorHungara = TipoDeEscala(
        nombre: "mayor húngara",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        estilos: [.folclore], regiones: [.hungria], documentada: .persichetti1961)
    /// La menor armónica con la 2ª menor (Do Re♭ Mi♭ Fa Sol La♭ Si).
    public static let napolitanaMenor = TipoDeEscala(
        nombre: "napolitana menor",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        estilos: [.clasica])
    /// La menor melódica con la 2ª menor (Do Re♭ Mi♭ Fa Sol La Si).
    public static let napolitanaMayor = TipoDeEscala(
        nombre: "napolitana mayor",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        estilos: [.clasica])
    /// La «escala enigmática» del Ave Maria de Verdi (Do Re♭ Mi Fa♯ Sol♯ La♯ Si).
    public static let enigmatica = TipoDeEscala(
        nombre: "enigmática",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaAumentada, .sextaAumentada, .septimaMayor,
        ],
        alias: ["de Verdi", "Verdi"],
        estilos: [.clasica], documentada: .verdi1889)
    /// Do Re♭ Mi Fa Sol♭ La♭ Si.
    public static let persa = TipoDeEscala(
        nombre: "persa",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMayor,
        ],
        estilos: [.sintetica])
    /// Do Re Mi Fa Sol♭ La♭ Si♭: la mayor con la mitad superior de tonos enteros.
    public static let mayorLocria = TipoDeEscala(
        nombre: "mayor locria",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["árabe"],
        estilos: [.sintetica])
    /// Do Re Mi Fa♯ Sol La♭ Si♭: lidio con la mitad superior menor.
    public static let lidioMenor = TipoDeEscala(
        nombre: "lidio menor",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        estilos: [.sintetica])
    /// La escala del «acorde místico» de Skriabin (Do Re Mi Fa♯ La Si♭).
    public static let prometeo = TipoDeEscala(
        nombre: "Prometeo",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .sextaMayor, .septimaMenor,
        ],
        alias: ["mística", "de Prometeo", "Skriabin"], variantes: ["Scriabin"],
        estilos: [.deCompositor], documentada: .skriabin1910)
    /// El Prometeo con la segunda menor (Do Re♭ Mi Fa♯ La Si♭), el otro modo de Skriabin.
    public static let prometeoNapolitano = TipoDeEscala(
        nombre: "Prometeo napolitano",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .sextaMayor, .septimaMenor,
        ],
        estilos: [.deCompositor])

    // Simétricas y otras.

    /// La disminuida que empieza por semitono (Do Re♭ Mi♭ Mi Fa♯ Sol La Si♭), la de los acordes
    /// de dominante con ♭9 y ♯9.
    public static let disminuidaSemitonoTono = TipoDeEscala(
        nombre: "disminuida semitono-tono",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .terceraMayor,
            .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: [
            "disminuida dominante", "dominante disminuida", "modo 2 de Messiaen", "de Rimski-Kórsakov",
            "Rimski-Kórsakov", "de Stravinski", "Stravinski", "disminuida auxiliar blues",
        ],
        variantes: ["Rimsky-Korsakov"],
        estilos: [.jazz, .deCompositor], corrientes: [.bebop], documentada: .rimskiKorsakov1867)
    /// Terceras menores y semitonos alternos (Do Mi♭ Mi Sol Sol♯ Si).
    public static let aumentada = TipoDeEscala(
        nombre: "aumentada",
        intervalos: [
            .unisono, .terceraMenor, .terceraMayor, .quintaJusta,
            .quintaAumentada, .septimaMayor,
        ],
        alias: ["hexatónica aumentada", "simétrica aumentada", "de Weitzmann", "Weitzmann"],
        estilos: [.jazz, .deCompositor])
    /// Do Re Mi♭ Mi Sol La: la pentatónica mayor con la 3ª menor de paso.
    public static let bluesMayor = TipoDeEscala(
        nombre: "blues mayor",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .terceraMayor,
            .quintaJusta, .sextaMayor,
        ],
        estilos: [.blues])
    /// La pentatónica suspendida (Do Re Fa Sol Si♭), sin terceras.
    public static let egipcia = TipoDeEscala(
        nombre: "egipcia",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["pentatónica suspendida"],
        estilos: [.folclore])
    /// Las doce notas, escritas con sostenidos al subir desde la tónica salvo la 2ª, 3ª, 6ª y 7ª
    /// menores (Do Re♭ Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si): la de cuatro bemoles de las seis de
    /// `cromaticasPorQuintas`, la ventana −5…6.
    public static let cromatica = TipoDeEscala(
        nombre: "cromática",
        intervalos: [
            .unisono, .segundaMenor, .segundaMayor, .terceraMenor, .terceraMayor, .cuartaJusta,
            .cuartaAumentada, .quintaJusta, .sextaMenor, .sextaMayor, .septimaMenor, .septimaMayor,
        ],
        alias: ["cromática con cuatro bemoles", "cromática −5…6"],
        estilos: [.clasica, .deCompositor])

    // MARK: Cromáticas por ventana de quintas

    // Una escala cromática escrita son doce quintas seguidas de la línea de quintas, contadas desde
    // la tónica (Fa = −1, Do = 0, Sol = 1): doce quintas seguidas dan las doce clases de altura sin
    // repetir ninguna. Para que la ventana contenga la escala mayor de la tónica (de −1 a 5), tiene
    // que empezar entre −6 y −1: son seis. Cada una cambia una nota de la anterior de bemol a
    // sostenido, por el orden de la línea de quintas (Sol♭ → Fa♯, Re♭ → Do♯, La♭ → Sol♯, Mi♭ → Re♯ y
    // Si♭ → La♯). Se nombran por sus bemoles, porque los sostenidos son los que faltan hasta cinco.

    /// La cromática con las notas de esa ventana de quintas, leída con Do como tónica: en otra tónica, cada nota se
    /// transporta con ella. `.bemoles` (de −6 a 5) da cinco bemoles (Do Re♭ Re Mi♭ Mi Fa Sol♭ Sol La♭ La Si♭ Si);
    /// `.sostenidos` (de −1 a 10), cinco sostenidos (Do Do♯ Re Re♯ Mi Fa Fa♯ Sol Sol♯ La La♯ Si); `.masSimple` (de
    /// −5 a 6) es `cromatica`.
    ///
    /// - Precondition: la ventana empieza entre Sol♭ (−6) y Fa (−1), para que la escala mayor de Do quede dentro.
    public static func cromatica(ventana: VentanaDeQuintas) -> TipoDeEscala {
        let primera = ventana.inicio
        precondition((-6...(-1)).contains(primera), "La ventana de una cromática empieza entre Sol♭ y Fa")
        if primera == -5 { return .cromatica }
        let intervalos = (primera..<(primera + 12)).map { quintas in
            // La octava que deja el intervalo entre 0 y 11 semitonos.
            Intervalo(pasosDeQuinta: quintas, pasosDeOctava: -divisionEntera(7 * quintas, 12))
        }.sorted { $0.semitonos < $1.semitonos }
        return TipoDeEscala(
            nombre: nombresDeLasCromaticas[primera + 6],
            intervalos: intervalos,
            alias: ["cromática \(signo(primera))…\(signo(primera + 11))"])
    }

    /// Los nombres en español, de la ventana −6 a la −1.
    private static let nombresDeLasCromaticas = [
        "cromática con cinco bemoles", "cromática con cuatro bemoles", "cromática con tres bemoles",
        "cromática con dos bemoles", "cromática con un bemol", "cromática con cinco sostenidos",
    ]

    /// El número con el signo menos tipográfico: −3.
    private static func signo(_ n: Int) -> String { n < 0 ? "−\(-n)" : "\(n)" }

    /// −6…5: Do Re♭ Re Mi♭ Mi Fa Sol♭ Sol La♭ La Si♭ Si.
    public static let cromaticaConCincoBemoles = cromatica(ventana: .bemoles).con(estilos: [.clasica, .deCompositor])
    /// −5…6, la `cromatica`: Do Re♭ Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si.
    public static let cromaticaConCuatroBemoles = cromatica
    /// −4…7: Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si.
    public static let cromaticaConTresBemoles = cromatica(ventana: VentanaDeQuintas(inicio: -4))
        .con(estilos: [.clasica, .deCompositor])
    /// −3…8: Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si.
    public static let cromaticaConDosBemoles = cromatica(ventana: .habitual).con(estilos: [.clasica, .deCompositor])
    /// −2…9: Do Do♯ Re Re♯ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si.
    public static let cromaticaConUnBemol = cromatica(ventana: VentanaDeQuintas(inicio: -2))
        .con(estilos: [.clasica, .deCompositor])
    /// −1…10: Do Do♯ Re Re♯ Mi Fa Fa♯ Sol Sol♯ La La♯ Si.
    public static let cromaticaConCincoSostenidos = cromatica(ventana: .sostenidos).con(estilos: [
        .clasica, .deCompositor,
    ])

    /// Las seis, de la de más bemoles a la de más sostenidos.
    public static let cromaticasPorQuintas: [TipoDeEscala] = (-6...(-1)).map {
        cromatica(ventana: VentanaDeQuintas(inicio: $0))
    }
}

// MARK: - Hexatónicas gaélicas y de dos tríadas, y otras escalas de seis notas.

extension TipoDeEscala {
    // Hexatónicas gaélicas: los modos con un hueco de la música tradicional escocesa e irlandesa.

    /// Do Re Mi Sol La Si.
    public static let jonicoSinCuarta = TipoDeEscala(
        nombre: "jónico sin 4ª",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor, .septimaMayor],
        alias: ["jónico sin cuarta", "jónica gaélica", "jónico hexatónico"],
        estilos: [.folclore])
    /// Do Re Fa Sol La Si♭.
    public static let mixolidioSinTercera = TipoDeEscala(
        nombre: "mixolidio sin 3ª",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["mixolidio sin tercera", "mixolidia gaélica", "mixolidio hexatónico"],
        estilos: [.folclore])
    /// Do Re Mi♭ Fa Sol Si♭.
    public static let doricoSinSexta = TipoDeEscala(
        nombre: "dórico sin 6ª",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["dórico sin sexta", "dórica gaélica", "dórico hexatónico"],
        estilos: [.folclore])
    /// Do Mi♭ Fa Sol La♭ Si♭.
    public static let eolicoSinSegunda = TipoDeEscala(
        nombre: "eólico sin 2ª",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["eólico sin segunda", "eólica gaélica", "eólico hexatónico"],
        estilos: [.folclore])

    /// Dos acordes mayores a un tono (Do + Re: Do Re Mi Fa♯ Sol La), para improvisar con pares de
    /// tríadas.
    public static let hexatonicaDeDosTriadas = TipoDeEscala(
        nombre: "hexatónica de dos tríadas",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor],
        alias: ["dos tríadas", "par de tríadas", "hexatónica mayor de dos tríadas"],
        estilos: [.jazz])
    /// Dos acordes menores a un tono (Rem + Mim: Re Mi Fa Sol La Si), la pareja menor de la
    /// anterior.
    public static let hexatonicaMenorDeDosTriadas = TipoDeEscala(
        nombre: "hexatónica menor de dos tríadas",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["par de tríadas menores"],
        estilos: [.jazz])

    /// Do Re♭ Mi Fa♯ Sol La Si♭, del folclore rumano y balcánico.
    public static let mayorRumana = TipoDeEscala(
        nombre: "mayor rumana",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        estilos: [.folclore], regiones: [.rumania])

    /// La menor húngara con la 4ª justa además de la aumentada, de ocho notas
    /// (Do Re Mi♭ Fa Fa♯ Sol La♭ Si).
    public static let argelina = TipoDeEscala(
        nombre: "argelina",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        estilos: [.folclore])
    /// Dos acordes mayores a distancia de tritono, el «acorde de Petrushka» de Stravinski
    /// (Do Re♭ Mi Fa♯ Sol Si♭).
    public static let petrushka = TipoDeEscala(
        nombre: "Petrushka",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .septimaMenor,
        ],
        alias: ["de Petrushka", "de tritono", "tritono"], variantes: ["Petrouchka"],
        estilos: [.deCompositor], documentada: .stravinski1911)
    /// Dos tricordos cromáticos a distancia de tritono (Do Re♭ Re Fa♯ Sol La♭). Tiene las notas del modo 5 de
    /// Messiaen, desde su cuarto grado.
    public static let tritonoDeDosSemitonos = TipoDeEscala(
        nombre: "tritono de dos semitonos",
        intervalos: [
            .unisono, .segundaMenor, .segundaMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor,
        ],
        estilos: [.deCompositor])
    /// La «escala de armónicos» de los catálogos en inglés (Do Mi♭ Mi Fa Sol La), con las dos terceras.
    public static let hexatonicaDeArmonicos = TipoDeEscala(
        nombre: "hexatónica de armónicos",
        intervalos: [
            .unisono, .terceraMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor,
        ],
        estilos: [.deCompositor])
}

// MARK: - Escalas de jazz: bebop menores, pentatónicas del jazz y blues ampliadas.

extension TipoDeEscala {
    // Bebop menores: una nota de paso más para que los tiempos caigan en notas del acorde.

    /// La menor melódica con la 5ª aumentada de paso (Do Re Mi♭ Fa Sol Sol♯ La Si). Es también la «sexta menor
    /// disminuida» de Barry Harris: el acorde de sexta menor (Do Mi♭ Sol La) y el de séptima disminuida de la
    /// sensible alternados.
    public static let bebopMenorMelodica = TipoDeEscala(
        nombre: "bebop menor melódica",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        alias: ["bebop melódica", "sexta menor disminuida", "de sexta menor disminuida"],
        estilos: [.jazz], corrientes: [.bebop])
    /// La menor armónica con la 7ª menor de paso (Do Re Mi♭ Fa Sol La♭ Si♭ Si).
    public static let bebopMenorArmonica = TipoDeEscala(
        nombre: "bebop menor armónica",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor, .septimaMayor,
        ],
        alias: ["bebop armónica"],
        estilos: [.jazz], corrientes: [.bebop])

    /// El frigio con la 3ª mayor y la menor, de ocho notas (Do Re♭ Mi♭ Mi Fa Sol La♭ Si♭): la del
    /// flamenco, sobre la cadencia andaluza.
    public static let flamenca = TipoDeEscala(
        nombre: "flamenca",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["andaluza", "frigio flamenco", "española de ocho notas", "gitana española"],
        estilos: [.flamenco], regiones: [.andalucia])

    // Pentatónicas del jazz.

    /// Do Re Mi Sol Si♭: la de los acordes de séptima de dominante.
    public static let pentatonicaDominante = TipoDeEscala(
        nombre: "pentatónica dominante",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .septimaMenor],
        estilos: [.jazz])
    /// Do Mi♭ Fa Sol La: la menor con la 6ª mayor en vez de la 7ª.
    public static let pentatonicaMenorSexta = TipoDeEscala(
        nombre: "pentatónica menor 6",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["pentatónica dórica", "pentatónica menor con sexta"],
        estilos: [.jazz])
    /// Do Re Mi Sol La♭, también llamada «de Coltrane».
    public static let pentatonicaMayorSextaMenor = TipoDeEscala(
        nombre: "pentatónica mayor ♭6",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMenor],
        alias: ["pentatónica de Coltrane", "Coltrane"],
        estilos: [.jazz])
    /// Do Mi♭ Fa Sol♭ Si♭.
    public static let pentatonicaMenorQuintaDisminuida = TipoDeEscala(
        nombre: "pentatónica menor ♭5",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaDisminuida, .septimaMenor],
        estilos: [.jazz])
    /// Do Re Mi♭ Sol La: la mayor con la 3ª menor. Tiene las notas del kumoijōshi japonés y del Śivarañjanī indio.
    public static let pentatonicaMayorTerceraMenor = TipoDeEscala(
        nombre: "pentatónica mayor ♭3",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .quintaJusta, .sextaMayor],
        estilos: [.jazz])
    /// Do Mi♭ Fa Sol La♭: la menor con la 6ª menor en lugar de la 7ª.
    public static let pentatonicaMenorSextaMenor = TipoDeEscala(
        nombre: "pentatónica menor ♭6",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor],
        estilos: [.jazz])
    /// Do Mi Fa Sol Si♭: la de los acordes de séptima de dominante con 4ª.
    public static let pentatonicaMixolidia = TipoDeEscala(
        nombre: "pentatónica mixolidia",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        estilos: [.jazz])
    /// Do Mi Fa♯ Sol Si: la de los acordes de séptima mayor con ♯11.
    public static let pentatonicaLidia = TipoDeEscala(
        nombre: "pentatónica lidia",
        intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .quintaJusta, .septimaMayor],
        estilos: [.jazz])
    /// Do Re Fa Sol La: la pentatónica mayor desde su 4.º grado, la de las gaitas escocesas (las
    /// mismas notas que Durgā o Zhǐ).
    public static let pentatonicaEscocesa = TipoDeEscala(
        nombre: "pentatónica escocesa",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["escocesa"],
        estilos: [.folclore], regiones: [.escocia])

    // Blues ampliadas.

    /// Do Re Mi♭ Mi Fa Sol♭ Sol La Si♭: la blues con la mayor y la menor juntas.
    public static let bluesDeNueveNotas = TipoDeEscala(
        nombre: "blues de nueve notas",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["blues de 9 notas", "blues eneatónica"],
        estilos: [.blues])
    /// Do Re Mi♭ Fa Sol♭ Sol Si♭: la blues con la 2ª.
    public static let bluesMenorConSegunda = TipoDeEscala(
        nombre: "blues menor con 2ª",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .quintaJusta, .septimaMenor,
        ],
        alias: ["blues con segunda", "blues menor con segunda", "blues con 2ª"],
        estilos: [.blues])

    /// El hexacordo de Guido d'Arezzo: ut re mi fa sol la, tono, tono, semitono, tono, tono.
    /// Natural sobre Do, duro sobre Sol y blando sobre Fa (`Escala.hexacordoNatural`…).
    public static let hexacordo = TipoDeEscala(
        nombre: "hexacordo",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["hexacordo de Guido", "ut re mi fa sol la"],
        estilos: [.clasica])
}

// MARK: - Modos de transposición limitada de Messiaen.

extension TipoDeEscala {
    // Modos de transposición limitada de Messiaen (el 1.º es la de tonos enteros y el 2.º, la
    // disminuida semitono-tono). Cada uno se repite dentro de la octava, así que solo tiene
    // unas pocas transposiciones distintas.

    /// Tono, semitono, semitono, tres veces (Do Re Mi♭ Mi Fa♯ Sol La♭ Si♭ Si): la escala de nueve
    /// notas de Tcherepnin. Cuatro transposiciones.
    public static let messiaen3 = TipoDeEscala(
        nombre: "modo 3 de Messiaen",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMenor, .septimaMayor,
        ],
        alias: ["Messiaen 3", "Tcherepnin", "de Tcherepnin", "nueve notas", "de nueve notas"],
        estilos: [.deCompositor], documentada: .messiaen1944)
    /// Semitono, semitono, tercera menor, semitono, dos veces (Do Re♭ Re Fa Fa♯ Sol La♭ Si). Seis
    /// transposiciones.
    public static let messiaen4 = TipoDeEscala(
        nombre: "modo 4 de Messiaen",
        intervalos: [
            .unisono, .segundaMenor, .segundaMayor, .cuartaJusta, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["Messiaen 4"],
        estilos: [.deCompositor], documentada: .messiaen1944)
    /// Semitono, tercera mayor, semitono, dos veces (Do Re♭ Fa Fa♯ Sol Si). Seis transposiciones.
    public static let messiaen5 = TipoDeEscala(
        nombre: "modo 5 de Messiaen",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .cuartaAumentada, .quintaJusta, .septimaMayor],
        alias: ["Messiaen 5"],
        estilos: [.deCompositor], documentada: .messiaen1944)
    /// Tono, tono, semitono, semitono, dos veces (Do Re Mi Fa Fa♯ Sol♯ La♯ Si). Seis transposiciones.
    public static let messiaen6 = TipoDeEscala(
        nombre: "modo 6 de Messiaen",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .cuartaAumentada,
            .quintaAumentada, .sextaAumentada, .septimaMayor,
        ],
        alias: ["Messiaen 6"],
        estilos: [.deCompositor], documentada: .messiaen1944)
    /// Semitono, semitono, semitono, tono, semitono, dos veces (Do Re♭ Re Mi♭ Fa Fa♯ Sol La♭ La Si).
    /// Seis transposiciones.
    public static let messiaen7 = TipoDeEscala(
        nombre: "modo 7 de Messiaen",
        intervalos: [
            .unisono, .segundaMenor, .segundaMayor, .terceraMenor, .cuartaJusta,
            .cuartaAumentada, .quintaJusta, .sextaMenor, .sextaMayor, .septimaMayor,
        ],
        alias: ["Messiaen 7"],
        estilos: [.deCompositor], documentada: .messiaen1944)
}
