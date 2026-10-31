import Armonia

extension LineaDeComandos {
    /// Las digitaciones y las posiciones en el mástil, en el orden en que salen en la ayuda.
    static let ordenesDeTrastes: [Orden] = [
        Orden(
            nombres: ["digitaciones", "digitacion", "digitación", "fingerings"],
            ayuda: ayudaDeDigitaciones
        ) { try digitaciones($0, $1) },
        Orden(nombres: ["posiciones", "positions"], ayuda: ayudaDePosiciones) { try posiciones($0, $1) },
    ]

    static let ayudaDeDigitaciones: [EntradaDeAyuda] = [
        // digitaciones <cifrado>… [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisDigitaciones),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionDigitaciones),
            ejemplo: ejemplo(
                "armonia digitaciones Sol7/Si --instrumento ukelele",
                "armonia fingerings G7/B --instrument ukulele"))
    ]

    static let ayudaDePosiciones: [EntradaDeAyuda] = [
        // posiciones <escala> [--caged]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisPosiciones),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionPosiciones),
            ejemplo: ejemplo("armonia posiciones Sol mayor --caged", "armonia positions G major --caged"))
    ]
}
