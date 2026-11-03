import Armonia

extension LineaDeComandos {
    /// La partitura o el dibujo en PDF, SVG o PNG con un programa externo (LilyPond, rsvg-convert).
    static let ordenesDeGrabado: [Orden] = [
        Orden(nombres: ["grabar", "engrave"], ayuda: ayudaDeGrabar) { try grabar($0, $1) }
    ]

    static let ayudaDeGrabar: [EntradaDeAyuda] = [
        // grabar <partitura o dibujo> [--motor lilypond|propio] [--formato pdf|svg|png]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisGrabar),
            descripcion: TextosDeCLI.traduccion(\.descripcionGrabar),
            ejemplo: ejemplo(
                "armonia grabar coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 > coral.pdf",
                "armonia engrave chorale C3 E4 G4 C5, G2 D4 G4 B4 > chorale.pdf"),
            notas: TextosDeCLI.traduccion(\.notasGrabar))
    ]
}
