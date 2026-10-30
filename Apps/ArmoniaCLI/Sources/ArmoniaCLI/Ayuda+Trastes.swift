import Armonia

extension LineaDeComandos {
    /// La ayuda de las digitaciones, en el orden en que sale.
    static let ayudaDeTrastes: [EntradaDeAyuda] = [
        // digitaciones <cifrado>… [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisDigitaciones),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionDigitaciones),
            ejemplo: ejemplo("armonia digitaciones Sol7/Si --instrumento ukelele",
                             "armonia fingerings G7/B --instrument ukulele")),
    ]
}
