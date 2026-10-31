import Armonia

extension LineaDeComandos {
    /// Las transformaciones neorriemannianas y la conducción de voces, en el orden en que salen en la ayuda.
    static let ordenesDeNeorriemann: [Orden] = [
        Orden(nombres: ["vecinos", "neighbors"], ayuda: ayudaDeVecinos) { try vecinos($0, $1) },
        Orden(
            nombres: ["conduccion-parsimoniosa", "conducción-parsimoniosa", "smooth-path"],
            ayuda: ayudaDeConduccionParsimoniosa
        ) { try caminoParsimonioso($0, $1) },
        Orden(
            nombres: ["conduccion-minima", "conducción-mínima", "minimal-voice-leading"],
            ayuda: ayudaDeConduccionMinima
        ) { resto, notacion in
            guard resto.count == 2 else { return uso(.dosAcordesDeConduccion, notacion) }
            let conduccion = try Acorde(leyendo: resto[0]).conduccionMinima(hasta: try Acorde(leyendo: resto[1]))
            return bien(conduccion.texto(en: notacion))
        },
        Orden(nombres: ["plr", "neoriemannian"], ayuda: ayudaDePlr) { try plr($0, $1) },
    ]

    static let ayudaDeVecinos: [EntradaDeAyuda] = [
        // vecinos <acorde> [--voces 2]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisVecinos),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionVecinos),
            ejemplo: ejemplo(
                "armonia vecinos Sol7",
                "armonia neighbors G7"))
    ]

    static let ayudaDeConduccionParsimoniosa: [EntradaDeAyuda] = [
        // conduccion-parsimoniosa <acorde> <acorde> [--voces 2] [--ampliada]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisConduccionParsimoniosa),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionConduccionParsimoniosa),
            ejemplo: ejemplo(
                "armonia conduccion-parsimoniosa Sol7 Rem7",
                "armonia smooth-path G7 Dm7"))
    ]

    static let ayudaDeConduccionMinima: [EntradaDeAyuda] = [
        // conduccion-minima <acorde> <acorde>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisConduccionMinima),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionConduccionMinima),
            ejemplo: ejemplo(
                "armonia conduccion-minima Sol7 Do",
                "armonia minimal-voice-leading G7 C"))
    ]

    static let ayudaDePlr: [EntradaDeAyuda] = [
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
