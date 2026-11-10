import Elementos
import Foundation

// MARK: - El catálogo de temperamentos
//
// Los temperamentos y los sistemas de afinación con nombre: los regulares (el igual, el pitagórico, los mesotónicos),
// los circulares del Barroco, la afinación justa, las octavas partidas en partes iguales y los sistemas de otras
// tradiciones. Cada uno con cómo se afina, quién lo propuso y la obra donde se lee. Los nombres en los otros idiomas
// están en `Temperamentos/Nombres/`.

extension TemperamentoConNombre {
    // MARK: Regulares

    /// Doce semitonos iguales de 100 cents: la quinta, 2 cents más estrecha que la pura.
    public static let temperamentoIgual = TemperamentoConNombre(
        nombre: "temperamento igual", construccion: .regular(700), familia: .regular, autor: "Zhu Zaiyu", anio: 1584,
        alias: ["12 divisiones iguales", "12-TET"], referencias: [.lindley2001, .barbour1951])
    /// Todas las quintas puras (3/2): las terceras mayores, una coma sintónica más anchas que las puras.
    public static let pitagorico = TemperamentoConNombre(
        nombre: "afinación pitagórica", construccion: .regular(1200 * log2(1.5)), familia: .regular,
        alias: ["pitagórico"], referencias: [.barbour1951])
    /// Cada quinta, ¼ de coma sintónica más estrecha, para que las terceras mayores sean puras (5/4). La quinta Sol♯–Mi♭ es la del lobo.
    public static let mesotonicoCuartoDeComa = TemperamentoConNombre(
        nombre: "mesotónico de 1/4 de coma",
        construccion: .regular(TemperamentoRegular.mesotonico(fraccionDeComa: 4).quinta), familia: .regular,
        autor: "Pietro Aron", anio: 1523, alias: ["mesotónico"], referencias: [.barbour1951, .lindley2001])
    /// Cada quinta, ⅓ de coma sintónica más estrecha: las terceras menores puras (6/5).
    public static let mesotonicoTercioDeComa = TemperamentoConNombre(
        nombre: "mesotónico de 1/3 de coma",
        construccion: .regular(TemperamentoRegular.mesotonico(fraccionDeComa: 3).quinta), familia: .regular,
        autor: "Francisco de Salinas", anio: 1577, referencias: [.salinas1577, .barbour1951])
    /// Cada quinta, 2/7 de coma sintónica más estrecha: el de Zarlino, entre el de ¼ y el de ⅓.
    public static let mesotonicoDosSeptimosDeComa = TemperamentoConNombre(
        nombre: "mesotónico de 2/7 de coma",
        construccion: .regular(TemperamentoRegular.mesotonico(fraccionDeComa: 3.5).quinta), familia: .regular,
        autor: "Gioseffo Zarlino", anio: 1558, referencias: [.zarlino1558, .barbour1951])
    /// Cada quinta, ⅕ de coma sintónica más estrecha: las terceras mayores y las quintas, igual de impuras.
    public static let mesotonicoQuintoDeComa = TemperamentoConNombre(
        nombre: "mesotónico de 1/5 de coma",
        construccion: .regular(TemperamentoRegular.mesotonico(fraccionDeComa: 5).quinta), familia: .regular,
        referencias: [.barbour1951])
    /// Cada quinta, ⅙ de coma sintónica más estrecha: el de los órganos de Silbermann, casi el de 55 divisiones.
    public static let mesotonicoSextoDeComa = TemperamentoConNombre(
        nombre: "mesotónico de 1/6 de coma",
        construccion: .regular(TemperamentoRegular.mesotonico(fraccionDeComa: 6).quinta), familia: .regular,
        autor: "Gottfried Silbermann", referencias: [.barbour1951, .lindley2001])
    // MARK: Circulares

    /// Do–Sol, Sol–Re, Re–La y Si–Fa♯, ¼ de coma pitagórica más estrechas; las demás, puras.
    public static let werckmeisterIII = TemperamentoConNombre(
        nombre: "Werckmeister III", construccion: .circular(.werckmeisterIII), familia: .circular,
        autor: "Andreas Werckmeister", anio: 1691, referencias: [.lindley2001, .barbour1951])
    /// Re–La y La–Mi, ½ coma sintónica más estrechas, con Do–Mi pura; Fa♯–Do♯, un esquisma.
    public static let kirnbergerII = TemperamentoConNombre(
        nombre: "Kirnberger II", construccion: .circular(.kirnbergerII), familia: .circular,
        autor: "Johann Philipp Kirnberger", anio: 1771, referencias: [.lindley2001, .barbour1951])
    /// De Do a Mi, cuatro quintas ¼ de coma sintónica más estrechas, con Do–Mi pura; Fa♯–Do♯, un esquisma.
    public static let kirnbergerIII = TemperamentoConNombre(
        nombre: "Kirnberger III", construccion: .circular(.kirnbergerIII), familia: .circular,
        autor: "Johann Philipp Kirnberger", anio: 1779, referencias: [.lindley2001, .barbour1951])
    /// De Fa a Si, seis quintas ⅙ de coma pitagórica más estrechas; las demás, puras.
    public static let vallotti = TemperamentoConNombre(
        nombre: "Vallotti", construccion: .circular(.vallotti), familia: .circular, autor: "Francesco Antonio Vallotti",
        anio: 1750, referencias: [.lindley2001, .barbour1951])
    /// El de Vallotti, una quinta más arriba: de Do a Fa♯, seis quintas ⅙ de coma pitagórica más estrechas.
    public static let young = TemperamentoConNombre(
        nombre: "Young", construccion: .circular(.young), familia: .circular, autor: "Thomas Young", anio: 1799,
        referencias: [.lindley2001, .barbour1951])
    // MARK: Justa

    /// La justa de 5 límites de Ptolomeo sobre Do: 1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8, y las demás teclas por quintas y terceras puras.
    public static let afinacionJusta = TemperamentoConNombre(
        nombre: "afinación justa", construccion: .justa, familia: .justa, alias: ["entonación justa"],
        referencias: [.barbour1951])
    // MARK: Divisiones iguales

    /// La octava en 19 partes: la quinta, casi la del mesotónico de ⅓ de coma; distingue Do♯ de Re♭.
    public static let divisiones19 = TemperamentoConNombre(
        nombre: "19 divisiones iguales", construccion: .divisiones(19), familia: .divisionesIguales,
        autor: "Joel Mandelbaum", anio: 1961, alias: ["19-TET"], referencias: [.sethares2005])
    /// La octava en 22 partes: terceras casi puras y la séptima armónica cerca; no tiene un mesotónico.
    public static let divisiones22 = TemperamentoConNombre(
        nombre: "22 divisiones iguales", construccion: .divisiones(22), familia: .divisionesIguales,
        autor: "R. H. M. Bosanquet", anio: 1876, alias: ["22-TET"], referencias: [.sethares2005])
    /// La octava en 31 partes: casi el mesotónico de ¼ de coma, y la séptima armónica casi pura.
    public static let divisiones31 = TemperamentoConNombre(
        nombre: "31 divisiones iguales", construccion: .divisiones(31), familia: .divisionesIguales,
        autor: "Christiaan Huygens", anio: 1691, alias: ["31-TET"], referencias: [.sethares2005])
    /// La octava en 41 partes: quintas casi pitagóricas y terceras casi puras.
    public static let divisiones41 = TemperamentoConNombre(
        nombre: "41 divisiones iguales", construccion: .divisiones(41), familia: .divisionesIguales, alias: ["41-TET"],
        referencias: [.sethares2005])
    // MARK: De otras tradiciones

    /// Los 24 cuartos de tono de la teoría árabe moderna: Mi𝄳, medio bemol.
    public static let cuartosDeTono = TemperamentoConNombre(
        nombre: "cuartos de tono", construccion: .sistema(.cuartosDeTono), familia: .tradicional, anio: 1932,
        alias: ["24 divisiones iguales", "24-TET"], referencias: [.touma1996, .maqamWorld])
    /// La notación persa de Vaziri: el koron baja un cuarto de tono y el sori lo sube.
    public static let koronYSori = TemperamentoConNombre(
        nombre: "koron y sori", construccion: .sistema(.persa), familia: .tradicional, autor: "Ali-Naqi Vaziri",
        anio: 1922, referencias: [.farhat1990])
    /// Las 53 comas de la teoría turca: la nota pitagórica y las comas que se aparta de ella.
    public static let comas53 = TemperamentoConNombre(
        nombre: "53 comas de Arel-Ezgi-Uzdilek", construccion: .sistema(.comas53), familia: .tradicional,
        autor: "Hüseyin Sadettin Arel", alias: ["53 comas"], referencias: [.signell1977])
    /// Los 72 moria de la octava de la Comisión Patriarcal de Constantinopla, la teoría de la salmodia bizantina.
    public static let moria72 = TemperamentoConNombre(
        nombre: "72 moria", construccion: .sistema(.moria72), familia: .tradicional, anio: 1881,
        referencias: [.chrysanthos1832])
    /// Los 22 śruti de la música india: razones justas, a un limma, una coma o un semitono menor una de otra.
    public static let sruti22 = TemperamentoConNombre(
        nombre: "22 śruti", construccion: .sistema(.sruti), familia: .tradicional, alias: ["śruti"],
        referencias: [.rowell1992, .jairazbhoy1971])

    /// Todo el catálogo, en el orden de este fichero.
    public static let catalogo: [TemperamentoConNombre] = [
        .temperamentoIgual, .pitagorico, .mesotonicoCuartoDeComa, .mesotonicoTercioDeComa, .mesotonicoDosSeptimosDeComa,
        .mesotonicoQuintoDeComa, .mesotonicoSextoDeComa, .werckmeisterIII, .kirnbergerII, .kirnbergerIII, .vallotti,
        .young, .afinacionJusta, .divisiones19, .divisiones22, .divisiones31, .divisiones41, .cuartosDeTono,
        .koronYSori, .comas53, .moria72, .sruti22,
    ]
}
