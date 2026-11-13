import Elementos

// MARK: - Los acordes de nombre propio
//
// Acordes concretos de una obra o de un estilo, con sus notas desde la más grave tal como se escriben (sobre Do,
// salvo que se diga otra cosa) y la obra donde se leen. No dan nombre a su tipo de acorde, si lo tienen.

extension AcordeConNombre {
    /// El acorde de Tristán, del segundo compás del preludio de «Tristan und Isolde» (Wagner, 1859): sobre Fa, Fa Si
    /// Re♯ Sol♯.
    public static let tristan = AcordeConNombre(
        nombre: "acorde de Tristán",
        intervalos: [.unisono, .cuartaAumentada, .sextaAumentada, .novenaAumentada],
        estilos: [.clasica], referencias: [.rothgeb1995], documentada: .wagner1859)
    /// El acorde místico o de Prometeo de Skriabin, por cuartas: Do Fa♯ Si♭ Mi La Re.
    public static let mistico = AcordeConNombre(
        nombre: "acorde místico",
        intervalos: [
            .unisono, .cuartaAumentada, .septimaMenor, .terceraMayor + .octava, .decimoterceraMayor,
            .novenaMayor + .octava,
        ],
        alias: ["acorde de Prometeo"],
        estilos: [.deCompositor], referencias: [Referencia.samson1977.paginas("156–157")], documentada: .skriabin1910)
    /// El acorde de Petrushka (Stravinski, 1911): Do mayor y Fa♯ mayor a la vez, a un trítono. No se lee por terceras.
    public static let petrushka = AcordeConNombre(
        nombre: "acorde de Petrushka",
        intervalos: [
            .unisono, .terceraMayor, .quintaJusta, .cuartaAumentada + .octava, .sextaAumentada + .octava,
            .unisonoAumentado + .octava + .octava,
        ],
        estilos: [.deCompositor], referencias: [Referencia.taruskin1987.paginas("269")],
        documentada: .stravinski1911)
    /// El acorde de «Farben», la tercera de las Cinco piezas para orquesta, op. 16, de Schönberg (1909): Do Sol♯ Si Mi
    /// La.
    public static let farben = AcordeConNombre(
        nombre: "acorde de Farben",
        intervalos: [.unisono, .quintaAumentada, .septimaMayor, .terceraMayor + .octava, .sextaMayor + .octava],
        estilos: [.deCompositor], referencias: [Referencia.burkhart1973.paginas("146")],
        documentada: .schoenberg1909)
    /// El acorde So What, el de Bill Evans en «So What» (Miles Davis, 1959): tres cuartas justas y una tercera mayor.
    /// Sobre Mi, Mi La Re Sol Si.
    public static let soWhat = AcordeConNombre(
        nombre: "acorde So What",
        intervalos: [.unisono, .cuartaJusta, .septimaMenor, .terceraMenor + .octava, .quintaJusta + .octava],
        estilos: [.jazz], referencias: [.levine1989])
    /// El acorde de Hendrix, 7(♯9): sobre Mi, Mi Sol♯ Re Fa𝄪 (que suena como Sol).
    public static let hendrix = AcordeConNombre(
        nombre: "acorde de Hendrix",
        intervalos: [.unisono, .terceraMayor, .septimaMenor, .novenaAumentada],
        estilos: [.popRock, .blues])
    /// El acorde mu de Steely Dan: la tríada mayor con la segunda añadida junto a la tercera, Do Re Mi Sol.
    public static let mu = AcordeConNombre(
        nombre: "acorde mu",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta],
        estilos: [.popRock])
    /// El acorde por cuartas justas: Do Fa Si♭ Mi♭.
    public static let porCuartas = AcordeConNombre(
        nombre: "acorde por cuartas",
        intervalos: [.unisono, .cuartaJusta, .septimaMenor, .terceraMenor + .octava],
        alias: ["acorde cuartal"],
        estilos: [.jazz, .deCompositor], referencias: [.persichetti1961])
    /// El acorde de «Elektra» (Strauss, 1909), el del motivo de Elektra: Mi mayor sobre Re♭ mayor, escrito sobre Do♯
    /// (Do♯ Mi♯ Sol♯ Mi Si). Su ortografía cambia de una fuente a otra.
    public static let elektra = AcordeConNombre(
        nombre: "acorde de Elektra",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .terceraMenor + .octava, .septimaMenor + .octava],
        estilos: [.deCompositor], documentada: .strauss1909)
    /// El acorde de los augures, de «La consagración de la primavera» (Stravinski, 1913): Mi♭7 sobre Fa♭ mayor,
    /// Fa♭ La♭ Do♭ Mi♭ Sol Si♭ Re♭.
    public static let augures = AcordeConNombre(
        nombre: "acorde de los augures",
        intervalos: [
            .unisono, .terceraMayor, .quintaJusta, .septimaMayor, .novenaAumentada, .undecimaAumentada,
            .decimoterceraMayor,
        ],
        alias: ["acorde de La consagración de la primavera"], estilos: [.deCompositor], referencias: [.taruskin1996],
        documentada: .stravinski1913)
    /// El acorde con que empieza la «Sinfonía de los salmos» (Stravinski, 1930): Mi menor con la tercera doblada,
    /// Mi Sol Si Sol.
    public static let salmos = AcordeConNombre(
        nombre: "acorde de la Sinfonía de los salmos",
        intervalos: [.unisono, .terceraMenor, .quintaJusta, .terceraMenor + .octava], estilos: [.deCompositor],
        documentada: .stravinski1930)
    /// El acorde alfa de Lendvai, en Bartók: dos séptimas disminuidas superpuestas, Do Mi♭ Fa♯ La Do♯ Mi Sol Si♭. Está
    /// por comprobar en Lendvai (1971) qué notas da.
    public static let alfa = AcordeConNombre(
        nombre: "acorde alfa",
        intervalos: [
            .unisono, .terceraMenor, .cuartaAumentada, .sextaMayor, .unisonoAumentado + .octava,
            .terceraMayor + .octava, .quintaJusta + .octava, .septimaMenor + .octava,
        ],
        alias: ["acorde alfa de Lendvai"], estilos: [.deCompositor])

    /// Los de nombre propio, en su orden.
    public static let conNombrePropio: [AcordeConNombre] = [
        .tristan, .mistico, .petrushka, .farben, .soWhat, .hendrix, .mu, .porCuartas, .elektra, .augures, .salmos,
        .alfa,
    ]

    /// Todos los acordes del catálogo: los genéricos (`genericos`) y después los de nombre propio (`conNombrePropio`).
    public static let catalogo: [AcordeConNombre] = genericos + conNombrePropio
}
