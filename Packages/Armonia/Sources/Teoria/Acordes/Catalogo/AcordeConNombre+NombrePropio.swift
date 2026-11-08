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
        estilos: [.clasica], referencias: [.rothgeb1995])
    /// El acorde místico o de Prometeo de Skriabin, por cuartas: Do Fa♯ Si♭ Mi La Re.
    public static let mistico = AcordeConNombre(
        nombre: "acorde místico",
        intervalos: [
            .unisono, .cuartaAumentada, .septimaMenor, .terceraMayor + .octava, .decimoterceraMayor,
            .novenaMayor + .octava,
        ],
        alias: ["acorde de Prometeo"],
        estilos: [.sigloXX], referencias: [Referencia.samson1977.paginas("156–157")])
    /// El acorde de Petrushka (Stravinski, 1911): Do mayor y Fa♯ mayor a la vez, a un trítono. No se lee por terceras.
    public static let petrushka = AcordeConNombre(
        nombre: "acorde de Petrushka",
        intervalos: [
            .unisono, .terceraMayor, .quintaJusta, .cuartaAumentada + .octava, .sextaAumentada + .octava,
            .unisonoAumentado + .octava + .octava,
        ],
        estilos: [.sigloXX], referencias: [Referencia.taruskin1987.paginas("269")])
    /// El acorde de «Farben», la tercera de las Cinco piezas para orquesta, op. 16, de Schönberg (1909): Do Sol♯ Si Mi La.
    public static let farben = AcordeConNombre(
        nombre: "acorde de Farben",
        intervalos: [.unisono, .quintaAumentada, .septimaMayor, .terceraMayor + .octava, .sextaMayor + .octava],
        estilos: [.sigloXX], referencias: [Referencia.burkhart1973.paginas("146")])
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
        estilos: [.blues, .popular])
    /// El acorde mu de Steely Dan: la tríada mayor con la segunda añadida junto a la tercera, Do Re Mi Sol.
    public static let mu = AcordeConNombre(
        nombre: "acorde mu",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta],
        estilos: [.popular])
    /// El acorde por cuartas justas: Do Fa Si♭ Mi♭.
    public static let porCuartas = AcordeConNombre(
        nombre: "acorde por cuartas",
        intervalos: [.unisono, .cuartaJusta, .septimaMenor, .terceraMenor + .octava],
        alias: ["acorde cuartal"],
        estilos: [.sigloXX, .jazz], referencias: [.persichetti1961])

    /// Los de nombre propio, en su orden.
    public static let conNombrePropio: [AcordeConNombre] = [
        .tristan, .mistico, .petrushka, .farben, .soWhat, .hendrix, .mu, .porCuartas,
    ]

    /// Todos los acordes del catálogo: los genéricos (`genericos`) y después los de nombre propio (`conNombrePropio`).
    public static let catalogo: [AcordeConNombre] = genericos + conNombrePropio
}
