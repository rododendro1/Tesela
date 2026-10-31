import Armonia

extension LineaDeComandos {
    /// La ayuda de las digitaciones, en el orden en que sale.
    static let ayudaDeTrastes: [EntradaDeAyuda] = [
        // digitaciones <cifrado>… [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisDigitaciones),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionDigitaciones),
            ejemplo: ejemplo(
                "armonia digitaciones Sol7/Si --instrumento ukelele",
                "armonia fingerings G7/B --instrument ukulele")),
        // posiciones <escala> [--caged]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisPosiciones),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionPosiciones),
            ejemplo: ejemplo("armonia posiciones Sol mayor --caged", "armonia positions G major --caged")),
    ]
}
