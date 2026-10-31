import Armonia

extension LineaDeComandos {
    /// La ayuda de la conducción de voces y las transformaciones neorriemannianas, en el orden en que sale.
    static let ayudaDeNeorriemann: [EntradaDeAyuda] = [
        // vecinos <acorde> [--voces 2]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisVecinos),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionVecinos),
            ejemplo: ejemplo(
                "armonia vecinos Sol7",
                "armonia neighbors G7")),
        // conduccion-parsimoniosa <acorde> <acorde> [--voces 2] [--ampliada]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisConduccionParsimoniosa),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionConduccionParsimoniosa),
            ejemplo: ejemplo(
                "armonia conduccion-parsimoniosa Sol7 Rem7",
                "armonia smooth-path G7 Dm7")),
        // conduccion-minima <acorde> <acorde>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisConduccionMinima),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionConduccionMinima),
            ejemplo: ejemplo(
                "armonia conduccion-minima Sol7 Do",
                "armonia minimal-voice-leading G7 C")),
        // plr <tríada> <P, L, R…>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisPlr),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionPlr),
            ejemplo: ejemplo(
                "armonia plr Do PLR",
                "armonia plr C PLR")),
        // plr <tríada> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisPlrCamino),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionPlrCamino),
            ejemplo: ejemplo(
                "armonia plr Do Mibm",
                "armonia plr C Ebm")),
        // plr <tríada> <ciclo>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisPlrCiclo),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionPlrCiclo),
            ejemplo: ejemplo(
                "armonia plr Do hexatonico",
                "armonia plr C hexatonic")),
    ]
}
