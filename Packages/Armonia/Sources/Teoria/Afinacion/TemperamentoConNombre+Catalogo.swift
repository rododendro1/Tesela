import Elementos
import Foundation

// MARK: - El catálogo de temperamentos
//
// Los temperamentos y los sistemas de afinación con nombre: los regulares (el igual, el pitagórico, los mesotónicos),
// los circulares del Barroco, la afinación justa, las octavas partidas en partes iguales y los sistemas de otras
// tradiciones. Cada uno con cómo se afina, quién lo propuso y la obra donde se lee. Los nombres en los otros idiomas
// están en `Afinacion/Nombres/`.

extension TemperamentoConNombre {
    // MARK: Regulares

    /// Doce semitonos iguales de 100 cents: la quinta, 2 cents más estrecha que la pura.
    public static let temperamentoIgual = TemperamentoConNombre(
        nombre: "temperamento igual", construccion: .regular(700), familia: .regular,
        alias: ["12 divisiones iguales", "12-TET"], referencias: [.lindley2001, .barbour1951], documentada: .zhu1584,
        estilos: [.clasica, .jazz, .popRock], lugares: [.pais(.china)])
    /// Todas las quintas puras (3/2): las terceras mayores, una coma sintónica más anchas que las puras.
    public static let pitagorico = TemperamentoConNombre(
        nombre: "afinación pitagórica", construccion: .regular(1200 * log2(1.5)), familia: .regular,
        alias: ["pitagórico"], referencias: [.barbour1951], lugares: [.historico(.greciaAntigua)])
    /// Cada quinta, ¼ de coma sintónica más estrecha, para que las terceras mayores sean puras (5/4). La quinta
    /// Sol♯–Mi♭ es la del lobo.
    public static let mesotonicoCuartoDeComa = TemperamentoConNombre(
        nombre: "mesotónico de 1/4 de coma",
        construccion: .regular(TemperamentoRegular.mesotonico(fraccionDeComa: 4).quinta), familia: .regular,
        alias: ["mesotónico"], referencias: [.barbour1951, .lindley2001], documentada: .aron1523, estilos: [.clasica],
        lugares: [.pais(.italia)])
    /// Cada quinta, ⅓ de coma sintónica más estrecha: las terceras menores puras (6/5).
    public static let mesotonicoTercioDeComa = TemperamentoConNombre(
        nombre: "mesotónico de 1/3 de coma",
        construccion: .regular(TemperamentoRegular.mesotonico(fraccionDeComa: 3).quinta), familia: .regular,
        referencias: [.barbour1951], documentada: .salinas1577, estilos: [.clasica], lugares: [.pais(.espana)])
    /// Cada quinta, 2/7 de coma sintónica más estrecha: el de Zarlino, entre el de ¼ y el de ⅓.
    public static let mesotonicoDosSeptimosDeComa = TemperamentoConNombre(
        nombre: "mesotónico de 2/7 de coma",
        construccion: .regular(TemperamentoRegular.mesotonico(fraccionDeComa: 3.5).quinta), familia: .regular,
        referencias: [.barbour1951], documentada: .zarlino1558, estilos: [.clasica], lugares: [.pais(.italia)])
    /// Cada quinta, ⅕ de coma sintónica más estrecha: las terceras mayores y las quintas, igual de impuras.
    public static let mesotonicoQuintoDeComa = TemperamentoConNombre(
        nombre: "mesotónico de 1/5 de coma",
        construccion: .regular(TemperamentoRegular.mesotonico(fraccionDeComa: 5).quinta), familia: .regular,
        referencias: [.barbour1951])
    /// Cada quinta, ⅙ de coma sintónica más estrecha: el de los órganos de Silbermann, casi el de 55 divisiones.
    public static let mesotonicoSextoDeComa = TemperamentoConNombre(
        nombre: "mesotónico de 1/6 de coma",
        construccion: .regular(TemperamentoRegular.mesotonico(fraccionDeComa: 6).quinta), familia: .regular,
        autor: "Gottfried Silbermann", referencias: [.barbour1951, .lindley2001], estilos: [.clasica],
        lugares: [.pais(.alemania)])
    // MARK: Circulares

    /// Do–Sol, Sol–Re, Re–La y Si–Fa♯, ¼ de coma pitagórica más estrechas; las demás, puras.
    public static let werckmeisterIII = TemperamentoConNombre(
        nombre: "Werckmeister III", construccion: .circular(.werckmeisterIII), familia: .circular,
        referencias: [.lindley2001, .barbour1951], documentada: .werckmeister1691, estilos: [.clasica],
        lugares: [.pais(.alemania)])
    /// Do–Sol, Re–La, Mi–Si, Fa♯–Do♯ y Si♭–Fa, ⅓ de coma pitagórica más estrechas; Sol♯–Re♯ y Re♯–La♯, ⅓ más anchas.
    public static let werckmeisterIV = TemperamentoConNombre(
        nombre: "Werckmeister IV", construccion: .circular(.werckmeisterIV), familia: .circular,
        referencias: [.lindley2001, .barbour1951], documentada: .werckmeister1691, estilos: [.clasica],
        lugares: [.pais(.alemania)])
    /// Sol–Re, Re–La, Si–Fa♯, Fa♯–Do♯ y Fa–Do, ¼ de coma pitagórica más estrechas; Sol♯–Re♯, ¼ más ancha.
    public static let werckmeisterV = TemperamentoConNombre(
        nombre: "Werckmeister V", construccion: .circular(.werckmeisterV), familia: .circular,
        referencias: [.lindley2001, .barbour1951], documentada: .werckmeister1691, estilos: [.clasica],
        lugares: [.pais(.alemania)])
    /// Re–La y La–Mi, ½ coma sintónica más estrechas, con Do–Mi pura; Fa♯–Do♯, un esquisma.
    public static let kirnbergerII = TemperamentoConNombre(
        nombre: "Kirnberger II", construccion: .circular(.kirnbergerII), familia: .circular,
        referencias: [.lindley2001, .barbour1951], documentada: .kirnberger1771, estilos: [.clasica],
        lugares: [.pais(.alemania)])
    /// De Do a Mi, cuatro quintas ¼ de coma sintónica más estrechas, con Do–Mi pura; Fa♯–Do♯, un esquisma.
    public static let kirnbergerIII = TemperamentoConNombre(
        nombre: "Kirnberger III", construccion: .circular(.kirnbergerIII), familia: .circular,
        autor: "Johann Philipp Kirnberger", anio: 1779, referencias: [.lindley2001, .barbour1951], estilos: [.clasica],
        lugares: [.pais(.alemania)])
    /// De Fa a Si, seis quintas ⅙ de coma pitagórica más estrechas; las demás, puras.
    public static let vallotti = TemperamentoConNombre(
        nombre: "Vallotti", construccion: .circular(.vallotti), familia: .circular, autor: "Francesco Antonio Vallotti",
        anio: 1750, referencias: [.lindley2001, .barbour1951], estilos: [.clasica], lugares: [.pais(.italia)])
    /// El de Vallotti, una quinta más arriba: de Do a Fa♯, seis quintas ⅙ de coma pitagórica más estrechas.
    public static let young = TemperamentoConNombre(
        nombre: "Young", construccion: .circular(.young), familia: .circular, autor: "Thomas Young", anio: 1799,
        referencias: [.lindley2001, .barbour1951], estilos: [.clasica], lugares: [.pais(.reinoUnido)])
    /// Una de las reconstrucciones del temperamento de Bach: cinco quintas, ⅕ de coma pitagórica más estrechas.
    public static let kellner = TemperamentoConNombre(
        nombre: "Kellner", construccion: .circular(.kellner), familia: .circular, alias: ["Bach-Kellner"],
        documentada: .kellner1977, estilos: [.clasica], lugares: [.pais(.alemania)])
    /// Otra, leída en las terceras del Clave bien temperado: seis quintas, ⅙ de coma pitagórica más estrechas.
    public static let barnes = TemperamentoConNombre(
        nombre: "Barnes", construccion: .circular(.barnes), familia: .circular, alias: ["Bach-Barnes"],
        documentada: .barnes1979, estilos: [.clasica], lugares: [.pais(.reinoUnido)])
    /// Otra, leída en el dibujo de la portada del Clave bien temperado: ⅙ de coma de Fa a Mi, puras de Mi a Do♯ y
    /// ¹⁄₁₂ de Do♯ a Fa.
    public static let lehman = TemperamentoConNombre(
        nombre: "Lehman", construccion: .circular(.lehman), familia: .circular, alias: ["Bach-Lehman"],
        documentada: .lehman2005, estilos: [.clasica], lugares: [.pais(.estadosUnidos)])
    // MARK: Justa

    /// La justa de 5 límites de Ptolomeo sobre Do: 1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8, y las demás teclas por quintas y
    /// terceras puras.
    public static let afinacionJusta = TemperamentoConNombre(
        nombre: "afinación justa", construccion: .justa, familia: .justa, alias: ["entonación justa"],
        referencias: [.barbour1951], lugares: [.historico(.greciaAntigua)])
    // MARK: Divisiones iguales

    /// La octava en 5 partes: cerca del sléndro del gamelan, aunque el de cada gamelan se aparta de ella.
    public static let divisiones5 = TemperamentoConNombre(
        nombre: "5 divisiones iguales", construccion: .divisiones(5), familia: .divisionesIguales, alias: ["5-TET"],
        referencias: [.sethares2005, .surjodiningrat1972], tradicion: .indonesia)
    /// La octava en 7 partes: la de la música tailandesa, según se mide en sus instrumentos.
    public static let divisiones7 = TemperamentoConNombre(
        nombre: "7 divisiones iguales", construccion: .divisiones(7), familia: .divisionesIguales, alias: ["7-TET"],
        referencias: [.sethares2005, .morton1976], tradicion: .sudesteAsiatico, lugares: [.pais(.tailandia)])
    /// La octava en 17 partes: quintas casi pitagóricas, sin terceras justas.
    public static let divisiones17 = TemperamentoConNombre(
        nombre: "17 divisiones iguales", construccion: .divisiones(17), familia: .divisionesIguales,
        alias: ["17-TET"], referencias: [.sethares2005])
    /// La octava en 19 partes: la quinta, casi la del mesotónico de ⅓ de coma; distingue Do♯ de Re♭.
    public static let divisiones19 = TemperamentoConNombre(
        nombre: "19 divisiones iguales", construccion: .divisiones(19), familia: .divisionesIguales,
        alias: ["19-TET"], referencias: [.sethares2005], documentada: .mandelbaum1961, lugares: [.pais(.estadosUnidos)])
    /// La octava en 22 partes: terceras casi puras y la séptima armónica cerca; no tiene un mesotónico.
    public static let divisiones22 = TemperamentoConNombre(
        nombre: "22 divisiones iguales", construccion: .divisiones(22), familia: .divisionesIguales,
        alias: ["22-TET"], referencias: [.sethares2005], documentada: .bosanquet1876, lugares: [.pais(.reinoUnido)])
    /// La octava en 31 partes: casi el mesotónico de ¼ de coma, y la séptima armónica casi pura.
    public static let divisiones31 = TemperamentoConNombre(
        nombre: "31 divisiones iguales", construccion: .divisiones(31), familia: .divisionesIguales,
        alias: ["31-TET"], referencias: [.sethares2005], documentada: .huygens1691, lugares: [.pais(.paisesBajos)])
    /// La octava en 41 partes: quintas casi pitagóricas y terceras casi puras.
    public static let divisiones41 = TemperamentoConNombre(
        nombre: "41 divisiones iguales", construccion: .divisiones(41), familia: .divisionesIguales, alias: ["41-TET"],
        referencias: [.sethares2005])
    /// La octava en 43 merides de Sauveur: casi el mesotónico de ⅕ de coma.
    public static let divisiones43 = TemperamentoConNombre(
        nombre: "43 divisiones iguales", construccion: .divisiones(43), familia: .divisionesIguales,
        alias: ["43-TET", "merides de Sauveur"], referencias: [.sethares2005], documentada: .sauveur1701,
        lugares: [.pais(.francia)])
    /// La octava en 96 partes, dieciseisavos de tono: el sonido 13 de Julián Carrillo.
    public static let divisiones96 = TemperamentoConNombre(
        nombre: "96 divisiones iguales", construccion: .divisiones(96), familia: .divisionesIguales,
        autor: "Julián Carrillo", alias: ["96-TET", "sonido 13"], referencias: [.sethares2005],
        lugares: [.pais(.mexico)])
    // MARK: De otras tradiciones

    /// Los 24 cuartos de tono de la teoría árabe moderna: Mi𝄳, medio bemol.
    public static let cuartosDeTono = TemperamentoConNombre(
        nombre: "cuartos de tono", construccion: .sistema(.cuartosDeTono), familia: .tradicional, anio: 1932,
        alias: ["24 divisiones iguales", "24-TET"], referencias: [.touma1996, .maqamWorld], tradicion: .mundoArabe)
    /// La notación persa de Vaziri: el koron baja un cuarto de tono y el sori lo sube.
    public static let koronYSori = TemperamentoConNombre(
        nombre: "koron y sori", construccion: .sistema(.persa), familia: .tradicional, autor: "Ali-Naqi Vaziri",
        anio: 1922, referencias: [.farhat1990], tradicion: .persia)
    /// Las 53 comas de la teoría turca: la nota pitagórica y las comas que se aparta de ella.
    public static let comas53 = TemperamentoConNombre(
        nombre: "53 comas de Arel-Ezgi-Uzdilek", construccion: .sistema(.comas53), familia: .tradicional,
        autor: "Hüseyin Sadettin Arel", alias: ["53 comas"], referencias: [.signell1977], tradicion: .turquia)
    /// Los 72 moria de la octava de la Comisión Patriarcal de Constantinopla, la teoría de la salmodia bizantina.
    public static let moria72 = TemperamentoConNombre(
        nombre: "72 moria", construccion: .sistema(.moria72), familia: .tradicional, anio: 1881,
        referencias: [.chrysanthos1832], tradicion: .bizancio)
    /// Los 22 śruti de la música india: razones justas, a un limma, una coma o un semitono menor una de otra.
    public static let sruti22 = TemperamentoConNombre(
        nombre: "22 śruti", construccion: .sistema(.sruti), familia: .tradicional, alias: ["śruti"],
        referencias: [.rowell1992, .jairazbhoy1971], tradicion: .india)

    /// Todo el catálogo, en el orden de este fichero.
    public static let catalogo: [TemperamentoConNombre] = [
        .temperamentoIgual, .pitagorico, .mesotonicoCuartoDeComa, .mesotonicoTercioDeComa, .mesotonicoDosSeptimosDeComa,
        .mesotonicoQuintoDeComa, .mesotonicoSextoDeComa, .werckmeisterIII, .werckmeisterIV, .werckmeisterV,
        .kirnbergerII, .kirnbergerIII, .vallotti, .young, .kellner, .barnes, .lehman, .afinacionJusta, .divisiones5,
        .divisiones7, .divisiones17, .divisiones19, .divisiones22, .divisiones31, .divisiones41, .divisiones43,
        .divisiones96, .cuartosDeTono,
        .koronYSori, .comas53, .moria72, .sruti22,
    ]
}
