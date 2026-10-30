import ArmoniaNucleo
// MARK: - Escalas «exóticas» de la tradición occidental, simétricas y otras.

extension TipoDeEscala {
    // Escalas «exóticas» de la tradición occidental, con dos segundas aumentadas o casi.

    /// Dos tetracordos con 2ª aumentada (Do Re♭ Mi Fa Sol La♭ Si): el mismo contenido que el
    /// dromos Hitzazkiár y el thaat Bhairav.
    public static let dobleArmonica = TipoDeEscala(
        nombre: "doble armónica",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
                     .quintaJusta, .sextaMenor, .septimaMayor],
        alias: ["doble armónica mayor", "bizantina", "gitana mayor"])
    /// La menor armónica con la 4ª aumentada (Do Re Mi♭ Fa♯ Sol La♭ Si).
    public static let menorHungara = TipoDeEscala(
        nombre: "menor húngara",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
                     .quintaJusta, .sextaMenor, .septimaMayor],
        alias: ["gitana menor", "doble armónica menor", "de Liszt", "Liszt"])
    /// Do Re♯ Mi Fa♯ Sol La Si♭.
    public static let mayorHungara = TipoDeEscala(
        nombre: "mayor húngara",
        intervalos: [.unisono, .segundaAumentada, .terceraMayor, .cuartaAumentada,
                     .quintaJusta, .sextaMayor, .septimaMenor])
    /// La menor armónica con la 2ª menor (Do Re♭ Mi♭ Fa Sol La♭ Si).
    public static let napolitanaMenor = TipoDeEscala(
        nombre: "napolitana menor",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
                     .quintaJusta, .sextaMenor, .septimaMayor])
    /// La menor melódica con la 2ª menor (Do Re♭ Mi♭ Fa Sol La Si).
    public static let napolitanaMayor = TipoDeEscala(
        nombre: "napolitana mayor",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
                     .quintaJusta, .sextaMayor, .septimaMayor])
    /// La «escala enigmática» del Ave Maria de Verdi (Do Re♭ Mi Fa♯ Sol♯ La♯ Si).
    public static let enigmatica = TipoDeEscala(
        nombre: "enigmática",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
                     .quintaAumentada, .sextaAumentada, .septimaMayor])
    /// Do Re♭ Mi Fa Sol♭ La♭ Si.
    public static let persa = TipoDeEscala(
        nombre: "persa",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
                     .quintaDisminuida, .sextaMenor, .septimaMayor])
    /// Do Re Mi Fa Sol♭ La♭ Si♭: la mayor con la mitad superior de tonos enteros.
    public static let mayorLocria = TipoDeEscala(
        nombre: "mayor locria",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
                     .quintaDisminuida, .sextaMenor, .septimaMenor],
        alias: ["árabe"])
    /// Do Re Mi Fa♯ Sol La♭ Si♭: lidio con la mitad superior menor.
    public static let lidioMenor = TipoDeEscala(
        nombre: "lidio menor",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
                     .quintaJusta, .sextaMenor, .septimaMenor])
    /// La escala del «acorde místico» de Skriabin (Do Re Mi Fa♯ La Si♭).
    public static let prometeo = TipoDeEscala(
        nombre: "Prometeo",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
                     .sextaMayor, .septimaMenor],
        alias: ["mística", "de Prometeo", "Skriabin", "Scriabin"])

    // Simétricas y otras.

    /// La disminuida que empieza por semitono (Do Re♭ Mi♭ Mi Fa♯ Sol La Si♭), la de los acordes
    /// de dominante con ♭9 y ♯9.
    public static let disminuidaSemitonoTono = TipoDeEscala(
        nombre: "disminuida semitono-tono",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .terceraMayor,
                     .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["disminuida dominante", "dominante disminuida", "modo 2 de Messiaen", "disminuida auxiliar blues",
                "de Rimski-Kórsakov", "Rimski-Kórsakov", "Rimsky-Korsakov"])
    /// Terceras menores y semitonos alternos (Do Mi♭ Mi Sol Sol♯ Si).
    public static let aumentada = TipoDeEscala(
        nombre: "aumentada",
        intervalos: [.unisono, .terceraMenor, .terceraMayor, .quintaJusta,
                     .quintaAumentada, .septimaMayor],
        alias: ["hexatónica aumentada", "simétrica aumentada", "de Weitzmann", "Weitzmann"])
    /// Do Re Mi♭ Mi Sol La: la pentatónica mayor con la 3ª menor de paso.
    public static let bluesMayor = TipoDeEscala(
        nombre: "blues mayor",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .terceraMayor,
                     .quintaJusta, .sextaMayor])
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
        intervalos: [.unisono, .segundaMenor, .segundaMayor, .terceraMenor, .terceraMayor, .cuartaJusta,
                     .cuartaAumentada, .quintaJusta, .sextaMenor, .sextaMayor, .septimaMenor, .septimaMayor],
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
