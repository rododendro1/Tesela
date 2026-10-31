import ArmoniaNucleo

// MARK: - Escalas «exóticas» de la tradición occidental, simétricas y otras.

extension TipoDeEscala {
    // Escalas «exóticas» de la tradición occidental, con dos segundas aumentadas o casi.

    /// Dos tetracordos con 2ª aumentada (Do Re♭ Mi Fa Sol La♭ Si): el mismo contenido que el
    /// dromos Hitzazkiár y el thaat Bhairav.
    public static let dobleArmonica = TipoDeEscala(
        nombre: "doble armónica",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["doble armónica mayor", "bizantina", "gitana mayor"])
    /// La menor armónica con la 4ª aumentada (Do Re Mi♭ Fa♯ Sol La♭ Si).
    public static let menorHungara = TipoDeEscala(
        nombre: "menor húngara",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["gitana menor", "doble armónica menor", "de Liszt", "Liszt"])
    /// Do Re♯ Mi Fa♯ Sol La Si♭.
    public static let mayorHungara = TipoDeEscala(
        nombre: "mayor húngara",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ])
    /// La menor armónica con la 2ª menor (Do Re♭ Mi♭ Fa Sol La♭ Si).
    public static let napolitanaMenor = TipoDeEscala(
        nombre: "napolitana menor",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ])
    /// La menor melódica con la 2ª menor (Do Re♭ Mi♭ Fa Sol La Si).
    public static let napolitanaMayor = TipoDeEscala(
        nombre: "napolitana mayor",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ])
    /// La «escala enigmática» del Ave Maria de Verdi (Do Re♭ Mi Fa♯ Sol♯ La♯ Si).
    public static let enigmatica = TipoDeEscala(
        nombre: "enigmática",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaAumentada, .sextaAumentada, .septimaMayor,
        ])
    /// Do Re♭ Mi Fa Sol♭ La♭ Si.
    public static let persa = TipoDeEscala(
        nombre: "persa",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMayor,
        ])
    /// Do Re Mi Fa Sol♭ La♭ Si♭: la mayor con la mitad superior de tonos enteros.
    public static let mayorLocria = TipoDeEscala(
        nombre: "mayor locria",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["árabe"])
    /// Do Re Mi Fa♯ Sol La♭ Si♭: lidio con la mitad superior menor.
    public static let lidioMenor = TipoDeEscala(
        nombre: "lidio menor",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ])
    /// La escala del «acorde místico» de Skriabin (Do Re Mi Fa♯ La Si♭).
    public static let prometeo = TipoDeEscala(
        nombre: "Prometeo",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .sextaMayor, .septimaMenor,
        ],
        alias: ["mística", "de Prometeo", "Skriabin", "Scriabin"])

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
            "disminuida dominante", "dominante disminuida", "modo 2 de Messiaen", "disminuida auxiliar blues",
            "de Rimski-Kórsakov", "Rimski-Kórsakov", "Rimsky-Korsakov",
        ])
    /// Terceras menores y semitonos alternos (Do Mi♭ Mi Sol Sol♯ Si).
    public static let aumentada = TipoDeEscala(
        nombre: "aumentada",
        intervalos: [
            .unisono, .terceraMenor, .terceraMayor, .quintaJusta,
            .quintaAumentada, .septimaMayor,
        ],
        alias: ["hexatónica aumentada", "simétrica aumentada", "de Weitzmann", "Weitzmann"])
    /// Do Re Mi♭ Mi Sol La: la pentatónica mayor con la 3ª menor de paso.
    public static let bluesMayor = TipoDeEscala(
        nombre: "blues mayor",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .terceraMayor,
            .quintaJusta, .sextaMayor,
        ])
    /// La pentatónica suspendida (Do Re Fa Sol Si♭), sin terceras.
    public static let egipcia = TipoDeEscala(
        nombre: "egipcia",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["pentatónica suspendida"])
    /// Las doce notas, escritas con sostenidos al subir desde la tónica salvo la 2ª, 3ª, 6ª y 7ª
    /// menores (Do Re♭ Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si): la de cuatro bemoles de las seis de
    /// `cromaticasPorQuintas`, la ventana −5…6.
    public static let cromatica = TipoDeEscala(
        nombre: "cromática",
        intervalos: [
            .unisono, .segundaMenor, .segundaMayor, .terceraMenor, .terceraMayor, .cuartaJusta,
            .cuartaAumentada, .quintaJusta, .sextaMenor, .sextaMayor, .septimaMenor, .septimaMayor,
        ],
        alias: ["cromática con cuatro bemoles", "cromática −5…6"])

    // MARK: Cromáticas por ventana de quintas

    // Una escala cromática escrita son doce quintas seguidas de la línea de quintas, contadas desde
    // la tónica (Fa = −1, Do = 0, Sol = 1): doce quintas seguidas dan las doce clases de altura sin
    // repetir ninguna. Para que la ventana contenga la escala mayor de la tónica (de −1 a 5), tiene
    // que empezar entre −6 y −1: son seis. Cada una cambia una nota de la anterior de bemol a
    // sostenido, por el orden de la línea de quintas (Sol♭ → Fa♯, Re♭ → Do♯, La♭ → Sol♯, Mi♭ → Re♯ y
    // Si♭ → La♯). Se nombran por sus bemoles, porque los sostenidos son los que faltan hasta cinco.

    /// La cromática de las doce quintas seguidas que empiezan en `primera`, en pasos de quinta desde
    /// la tónica: −6 da cinco bemoles (Do Re♭ Re Mi♭ Mi Fa Sol♭ Sol La♭ La Si♭ Si); −1, cinco
    /// sostenidos (Do Do♯ Re Re♯ Mi Fa Fa♯ Sol Sol♯ La La♯ Si); −5 es `cromatica`.
    ///
    /// - Precondition: `primera` está entre −6 y −1, para que la escala mayor de la tónica quede dentro.
    public static func cromatica(desdeLaQuinta primera: Int) -> TipoDeEscala {
        precondition((-6...(-1)).contains(primera), "La ventana de una cromática empieza entre −6 y −1 quintas")
        if primera == -5 { return .cromatica }
        let intervalos = (primera..<(primera + 12)).map { quintas in
            // La octava que deja el intervalo entre 0 y 11 semitonos.
            Intervalo(pasosDeQuinta: quintas, pasosDeOctava: -divisionEntera(7 * quintas, 12))
        }.sorted { $0.semitonos < $1.semitonos }
        let ventana = (primera, primera + 11)
        return TipoDeEscala(
            nombre: nombresDeLasCromaticas[primera + 6],
            intervalos: intervalos,
            alias: ["cromática \(signo(ventana.0))…\(signo(ventana.1))"])
    }

    /// Los nombres en español, de la ventana −6 a la −1.
    private static let nombresDeLasCromaticas = [
        "cromática con cinco bemoles", "cromática con cuatro bemoles", "cromática con tres bemoles",
        "cromática con dos bemoles", "cromática con un bemol", "cromática con cinco sostenidos",
    ]

    /// El número con el signo menos tipográfico: −3.
    private static func signo(_ n: Int) -> String { n < 0 ? "−\(-n)" : "\(n)" }

    /// −6…5: Do Re♭ Re Mi♭ Mi Fa Sol♭ Sol La♭ La Si♭ Si.
    public static let cromaticaConCincoBemoles = cromatica(desdeLaQuinta: -6)
    /// −5…6, la `cromatica`: Do Re♭ Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si.
    public static let cromaticaConCuatroBemoles = cromatica
    /// −4…7: Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si.
    public static let cromaticaConTresBemoles = cromatica(desdeLaQuinta: -4)
    /// −3…8: Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si.
    public static let cromaticaConDosBemoles = cromatica(desdeLaQuinta: -3)
    /// −2…9: Do Do♯ Re Re♯ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si.
    public static let cromaticaConUnBemol = cromatica(desdeLaQuinta: -2)
    /// −1…10: Do Do♯ Re Re♯ Mi Fa Fa♯ Sol Sol♯ La La♯ Si.
    public static let cromaticaConCincoSostenidos = cromatica(desdeLaQuinta: -1)

    /// Las seis, de la de más bemoles a la de más sostenidos.
    public static let cromaticasPorQuintas: [TipoDeEscala] = (-6...(-1)).map(cromatica(desdeLaQuinta:))
}

// MARK: - Hexatónicas gaélicas y de dos tríadas, y otras escalas de seis notas.

extension TipoDeEscala {
    // Hexatónicas gaélicas: los modos con un hueco de la música tradicional escocesa e irlandesa.

    /// Do Re Mi Sol La Si.
    public static let jonicoSinCuarta = TipoDeEscala(
        nombre: "jónico sin 4ª",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor, .septimaMayor],
        alias: ["jónico sin cuarta", "jónica gaélica", "jónico hexatónico"])
    /// Do Re Fa Sol La Si♭.
    public static let mixolidioSinTercera = TipoDeEscala(
        nombre: "mixolidio sin 3ª",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["mixolidio sin tercera", "mixolidia gaélica", "mixolidio hexatónico"])
    /// Do Re Mi♭ Fa Sol Si♭.
    public static let doricoSinSexta = TipoDeEscala(
        nombre: "dórico sin 6ª",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["dórico sin sexta", "dórica gaélica", "dórico hexatónico"])
    /// Do Mi♭ Fa Sol La♭ Si♭.
    public static let eolicoSinSegunda = TipoDeEscala(
        nombre: "eólico sin 2ª",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["eólico sin segunda", "eólica gaélica", "eólico hexatónico"])

    /// Dos acordes mayores a un tono (Do + Re: Do Re Mi Fa♯ Sol La), para improvisar con pares de
    /// tríadas.
    public static let hexatonicaDeDosTriadas = TipoDeEscala(
        nombre: "hexatónica de dos tríadas",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor],
        alias: ["dos tríadas", "par de tríadas", "hexatónica mayor de dos tríadas"])
    /// Dos acordes menores a un tono (Rem + Mim: Re Mi Fa Sol La Si), la pareja menor de la
    /// anterior.
    public static let hexatonicaMenorDeDosTriadas = TipoDeEscala(
        nombre: "hexatónica menor de dos tríadas",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["par de tríadas menores"])

    /// Do Re♭ Mi Fa♯ Sol La Si♭, del folclore rumano y balcánico.
    public static let mayorRumana = TipoDeEscala(
        nombre: "mayor rumana",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ])

    /// La menor húngara con la 4ª justa además de la aumentada, de ocho notas
    /// (Do Re Mi♭ Fa Fa♯ Sol La♭ Si).
    public static let argelina = TipoDeEscala(
        nombre: "argelina",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ])
    /// Dos acordes mayores a distancia de tritono, el «acorde de Petrushka» de Stravinski
    /// (Do Re♭ Mi Fa♯ Sol Si♭).
    public static let petrushka = TipoDeEscala(
        nombre: "Petrushka",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .septimaMenor,
        ],
        alias: ["de Petrushka", "Petrouchka", "de tritono", "tritono"])
}

// MARK: - Escalas de jazz: bebop menores, pentatónicas del jazz y blues ampliadas.

extension TipoDeEscala {
    // Bebop menores: una nota de paso más para que los tiempos caigan en notas del acorde.

    /// La menor melódica con la 5ª aumentada de paso (Do Re Mi♭ Fa Sol Sol♯ La Si).
    public static let bebopMenorMelodica = TipoDeEscala(
        nombre: "bebop menor melódica",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        alias: ["bebop melódica"])
    /// La menor armónica con la 7ª menor de paso (Do Re Mi♭ Fa Sol La♭ Si♭ Si).
    public static let bebopMenorArmonica = TipoDeEscala(
        nombre: "bebop menor armónica",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor, .septimaMayor,
        ],
        alias: ["bebop armónica"])

    /// El frigio con la 3ª mayor y la menor, de ocho notas (Do Re♭ Mi♭ Mi Fa Sol La♭ Si♭): la del
    /// flamenco, sobre la cadencia andaluza.
    public static let flamenca = TipoDeEscala(
        nombre: "flamenca",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["andaluza", "frigio flamenco", "española de ocho notas", "gitana española"])

    // Pentatónicas del jazz.

    /// Do Re Mi Sol Si♭: la de los acordes de séptima de dominante.
    public static let pentatonicaDominante = TipoDeEscala(
        nombre: "pentatónica dominante",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .septimaMenor])
    /// Do Mi♭ Fa Sol La: la menor con la 6ª mayor en vez de la 7ª.
    public static let pentatonicaMenorSexta = TipoDeEscala(
        nombre: "pentatónica menor 6",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["pentatónica dórica", "pentatónica menor con sexta"])
    /// Do Re Mi Sol La♭, también llamada «de Coltrane».
    public static let pentatonicaMayorSextaMenor = TipoDeEscala(
        nombre: "pentatónica mayor ♭6",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMenor],
        alias: ["pentatónica de Coltrane", "Coltrane"])
    /// Do Mi♭ Fa Sol♭ Si♭.
    public static let pentatonicaMenorQuintaDisminuida = TipoDeEscala(
        nombre: "pentatónica menor ♭5",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaDisminuida, .septimaMenor])
    /// Do Mi Fa Sol Si♭: la de los acordes de séptima de dominante con 4ª.
    public static let pentatonicaMixolidia = TipoDeEscala(
        nombre: "pentatónica mixolidia",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMenor])
    /// Do Mi Fa♯ Sol Si: la de los acordes de séptima mayor con ♯11.
    public static let pentatonicaLidia = TipoDeEscala(
        nombre: "pentatónica lidia",
        intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .quintaJusta, .septimaMayor])
    /// Do Re Fa Sol La: la pentatónica mayor desde su 4.º grado, la de las gaitas escocesas (las
    /// mismas notas que Sléndro, Durgā o Zhǐ).
    public static let pentatonicaEscocesa = TipoDeEscala(
        nombre: "pentatónica escocesa",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["escocesa"])

    // Blues ampliadas.

    /// Do Re Mi♭ Mi Fa Sol♭ Sol La Si♭: la blues con la mayor y la menor juntas.
    public static let bluesDeNueveNotas = TipoDeEscala(
        nombre: "blues de nueve notas",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["blues de 9 notas", "blues eneatónica"])
    /// Do Re Mi♭ Fa Sol♭ Sol Si♭: la blues con la 2ª.
    public static let bluesMenorConSegunda = TipoDeEscala(
        nombre: "blues menor con 2ª",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .quintaJusta, .septimaMenor,
        ],
        alias: ["blues con segunda", "blues menor con segunda", "blues con 2ª"])

    /// El hexacordo de Guido d'Arezzo: ut re mi fa sol la, tono, tono, semitono, tono, tono.
    /// Natural sobre Do, duro sobre Sol y blando sobre Fa (`Escala.hexacordoNatural`…).
    public static let hexacordo = TipoDeEscala(
        nombre: "hexacordo",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["hexacordo de Guido", "ut re mi fa sol la"])
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
        alias: ["Messiaen 3", "Tcherepnin", "de Tcherepnin", "nueve notas", "de nueve notas"])
    /// Semitono, semitono, tercera menor, semitono, dos veces (Do Re♭ Re Fa Fa♯ Sol La♭ Si). Seis
    /// transposiciones.
    public static let messiaen4 = TipoDeEscala(
        nombre: "modo 4 de Messiaen",
        intervalos: [
            .unisono, .segundaMenor, .segundaMayor, .cuartaJusta, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["Messiaen 4"])
    /// Semitono, tercera mayor, semitono, dos veces (Do Re♭ Fa Fa♯ Sol Si). Seis transposiciones.
    public static let messiaen5 = TipoDeEscala(
        nombre: "modo 5 de Messiaen",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .cuartaAumentada, .quintaJusta, .septimaMayor],
        alias: ["Messiaen 5"])
    /// Tono, tono, semitono, semitono, dos veces (Do Re Mi Fa Fa♯ Sol♯ La♯ Si). Seis transposiciones.
    public static let messiaen6 = TipoDeEscala(
        nombre: "modo 6 de Messiaen",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .cuartaAumentada,
            .quintaAumentada, .sextaAumentada, .septimaMayor,
        ],
        alias: ["Messiaen 6"])
    /// Semitono, semitono, semitono, tono, semitono, dos veces (Do Re♭ Re Mi♭ Fa Fa♯ Sol La♭ La Si).
    /// Seis transposiciones.
    public static let messiaen7 = TipoDeEscala(
        nombre: "modo 7 de Messiaen",
        intervalos: [
            .unisono, .segundaMenor, .segundaMayor, .terceraMenor, .cuartaJusta,
            .cuartaAumentada, .quintaJusta, .sextaMenor, .sextaMayor, .septimaMayor,
        ],
        alias: ["Messiaen 7"])
}
