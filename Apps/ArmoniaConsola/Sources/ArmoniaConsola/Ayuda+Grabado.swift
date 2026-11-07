import Armonia

extension LineaDeComandos {
    /// La partitura o el dibujo en PDF, SVG o PNG con un programa externo (LilyPond, MuseScore, Verovio, Guido,
    /// rsvg-convert), y cuáles de ellos están instalados.
    static let ordenesDeGrabado: [Orden] = [
        // `grabar` acepta también las opciones de la partitura que graba.
        Orden(
            nombres: ["grabar", "engrave"], ayuda: ayudaDeGrabar,
            opciones: ayudaDeGrabar.flatMap(\.opciones) + opcionesDePartitura
        ) { try grabar($0, $1) },
        Orden(
            nombres: ["motores", "engines"], ayuda: ayudaDeMotores, json: { try motoresJSON($0, $1) },
            ejecutar: { try motores($0, $1) }),
    ]

    static let ayudaDeGrabar: [EntradaDeAyuda] = [
        // grabar <partitura o dibujo> [--motor lilypond|musescore|verovio|guido|propio] [--formato pdf|svg|png]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisGrabar),
            descripcion: TextosDeCLI.traduccion(\.descripcionGrabar),
            ejemplo: ejemplo(
                "armonia grabar coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 > coral.pdf",
                "armonia engrave chorale C3 E4 G4 C5, G2 D4 G4 B4 > chorale.pdf"),
            notas: TextosDeCLI.traduccion(\.notasGrabar),
            opciones: [.motor, .formato])
    ]

    static let ayudaDeMotores: [EntradaDeAyuda] = [
        // motores
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisMotores),
            descripcion: TextosDeCLI.traduccion(\.descripcionMotores),
            ejemplo: ejemplo("armonia motores", "armonia engines"))
    ]
}
