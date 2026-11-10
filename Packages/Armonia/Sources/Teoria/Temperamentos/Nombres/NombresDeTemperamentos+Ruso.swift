// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de los temperamentos del catálogo en ruso. Qué es cada campo, en `NombresDeTemperamentos.swift`.

extension NombresDeTemperamentos {
    static let ruso = Tabla([
        .init(.temperamentoIgual, "равномерная темперация"),
        .init(.pitagorico, "пифагоров строй"),
        .init(.mesotonicoCuartoDeComa, "среднетоновый строй в 1/4 коммы"),
        .init(.mesotonicoTercioDeComa, "среднетоновый строй в 1/3 коммы"),
        .init(.mesotonicoDosSeptimosDeComa, "среднетоновый строй в 2/7 коммы"),
        .init(.mesotonicoQuintoDeComa, "среднетоновый строй в 1/5 коммы"),
        .init(.mesotonicoSextoDeComa, "среднетоновый строй в 1/6 коммы"),
        .init(.werckmeisterIII, "Werckmeister III"),
        .init(.kirnbergerII, "Kirnberger II"),
        .init(.kirnbergerIII, "Kirnberger III"),
        .init(.vallotti, "Vallotti"),
        .init(.young, "Young"),
        .init(.afinacionJusta, "чистый строй"),
        .init(.divisiones19, "19 равных долей октавы"),
        .init(.divisiones22, "22 равных долей октавы"),
        .init(.divisiones31, "31 равных долей октавы"),
        .init(.divisiones41, "41 равных долей октавы"),
        .init(.cuartosDeTono, "четверти тона"),
        .init(.koronYSori, "корон и сори"),
        .init(.comas53, "53 коммы Арел-Эзги-Уздилека"),
        .init(.moria72, "72 мория"),
        .init(.sruti22, "22 шрути"),
    ])
}
