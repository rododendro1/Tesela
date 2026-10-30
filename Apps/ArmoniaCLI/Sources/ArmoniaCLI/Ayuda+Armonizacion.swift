import Armonia

extension LineaDeComandos {
    /// La ayuda del análisis, la armonización, la realización y la revisión de corales y del contrapunto, en el orden
    /// en que sale.
    static let ayudaDeArmonizacion: [EntradaDeAyuda] = [
        // analizar <acordes> [--en <tonalidad>]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisAnalizar),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionAnalizar),
            ejemplo: ejemplo("armonia analizar Do Fa Sol7 Do Lam Re7 Sol",
                             "armonia analyze C F G7 C Am D7 G")),
        // analizar --archivo <fichero> [--ventana <duración>]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisAnalizarArchivo),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionAnalizarArchivo),
            ejemplo: ejemplo("armonia analizar --archivo coral.mid",
                             "armonia analyze --file chorale.musicxml")),
        // armonizar <melodía> [--en <tonalidad>] [--propuestas 3]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisArmonizar),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionArmonizar),
            ejemplo: ejemplo("armonia armonizar Mi4 Fa4 Re4 Do4",
                             "armonia harmonize E4 F4 D4 C4")),
        // realizar <acordes> [--en <tonalidad>]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisRealizar),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionRealizar),
            ejemplo: ejemplo("armonia realizar Do Fa Sol7 Do",
                             "armonia realize C F G7 C")),
        // revisar <acordes>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisRevisar),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionRevisar),
            ejemplo: ejemplo("armonia revisar Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4",
                             "armonia check C3 E4 G4 C5, G2 D4 G4 B4")),
        // contrapunto <cantus> / <contrapunto> [--especie 1]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisContrapunto),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionContrapunto),
            ejemplo: ejemplo("armonia contrapunto Re4 Fa4 Mi4 Re4 / -:2 La4 Re5 La4 Si4 Do#5 Re5:1 --especie 2",
                             "armonia counterpoint D4 F4 E4 D4 / -:2 A4 D5 A4 B4 C#5 D5:1 --species 2")),
    ]
}
