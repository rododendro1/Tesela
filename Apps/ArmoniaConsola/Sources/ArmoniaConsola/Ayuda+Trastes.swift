import Armonia

extension LineaDeComandos {
    /// Las digitaciones y las posiciones en el mástil, en el orden en que salen en la ayuda.
    static let ordenesDeTrastes: [Orden] = [
        Orden(
            nombres: ["digitaciones", "digitacion", "digitación", "fingerings"],
            ayuda: ayudaDeDigitaciones,
            json: { try digitacionesJSON($0, $1) },
            ejecutar: { try digitaciones($0, $1) }),
        Orden(
            nombres: ["posiciones", "positions"], ayuda: ayudaDePosiciones, json: { try posicionesJSON($0, $1) },
            ejecutar: { try posiciones($0, $1) }),
    ]

    static let ayudaDeDigitaciones: [EntradaDeAyuda] = [
        // digitaciones <cifrado>… [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisDigitaciones),
            descripcion: TextosDeCLI.traduccion(\.descripcionDigitaciones),
            ejemplo: ejemplo(
                "armonia digitaciones Sol7/Si --instrumento ukelele",
                "armonia fingerings G7/B --instrument ukulele"),
            opciones: [.instrumento, .limite, .traste, .dedosDeLaDigitacion, .completo, .diagrama, .capo, .musicxml])
    ]

    static let ayudaDePosiciones: [EntradaDeAyuda] = [
        // posiciones <escala> [--caged]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisPosiciones),
            descripcion: TextosDeCLI.traduccion(\.descripcionPosiciones),
            ejemplo: ejemplo("armonia posiciones Sol mayor --caged", "armonia positions G major --caged"),
            notas: TextosDeCLI.traduccion(\.notasPosiciones),
            opciones: [.caged, .secuencia, .bajando, .formas, .instrumento, .capo]),
        // posiciones --arpegio <cifrado> [--caged|--barrido]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisPosicionesArpegio),
            descripcion: TextosDeCLI.traduccion(\.descripcionPosicionesArpegio),
            ejemplo: ejemplo(
                "armonia posiciones --arpegio Lam --barrido", "armonia positions --arpeggio Am --sweep"),
            opciones: [.arpegio, .caged, .barrido, .idaYVuelta]),
    ]
}
