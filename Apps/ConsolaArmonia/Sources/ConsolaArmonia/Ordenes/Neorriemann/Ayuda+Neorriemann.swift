import Armonia

extension LineaDeComandos {
    /// Las transformaciones neorriemannianas y la conducción de voces, en el orden en que salen en la ayuda.
    static let ordenesDeNeorriemann: [Orden] = [
        Orden(
            nombres: ["vecinos", "neighbors"], ayuda: ayudaDeVecinos, json: { try vecinosJSON($0, $1) },
            ejecutar: { try vecinos($0, $1) }),
        Orden(
            nombres: ["camino-parsimonioso", "smooth-path"],
            ayuda: ayudaDeConduccionParsimoniosa, json: { try caminoParsimoniosoJSON($0, $1) },
            ejecutar: { try caminoParsimonioso($0, $1) }),
        Orden(
            nombres: ["conduccion-minima", "conducción-mínima", "minimal-voice-leading"],
            ayuda: ayudaDeConduccionMinima, json: { try conduccionMinimaJSON($0, $1) },
            ejecutar: { resto, notacion in
                try Argumentos(resto).sinOpcionesDesconocidas()
                guard resto.count == 2 else { throw ErrorDeUso.dosAcordesDeConduccion }
                let conduccion = try Acorde(leyendoEnLaOrden: resto[0]).conduccionMinima(
                    hasta: try Acorde(leyendoEnLaOrden: resto[1]))
                return bien(conduccion.texto(en: notacion))
            }),
        Orden(
            nombres: ["plr", "neoriemannian"], ayuda: ayudaDePlr, json: { try plrJSON($0, $1) },
            ejecutar: { try plr($0, $1) }),
    ]

    static let ayudaDeVecinos: [EntradaDeAyuda] = [
        // vecinos <acorde> [--voces 2]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisVecinos),
            descripcion: TextosDeConsola.traduccion(\.descripcionVecinos),
            ejemplo: ejemplo(
                "armonia vecinos Sol7",
                "armonia neighbors G7"),
            opciones: [.voces, .ampliada])
    ]

    static let ayudaDeConduccionParsimoniosa: [EntradaDeAyuda] = [
        // camino-parsimonioso <acorde> <acorde> [--voces 2] [--ampliada]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisConduccionParsimoniosa),
            descripcion: TextosDeConsola.traduccion(\.descripcionConduccionParsimoniosa),
            ejemplo: ejemplo(
                "armonia camino-parsimonioso Sol7 Rem7",
                "armonia smooth-path G7 Dm7"),
            opciones: [.voces, .ampliada])
    ]

    static let ayudaDeConduccionMinima: [EntradaDeAyuda] = [
        // conduccion-minima <acorde> <acorde>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisConduccionMinima),
            descripcion: TextosDeConsola.traduccion(\.descripcionConduccionMinima),
            ejemplo: ejemplo(
                "armonia conduccion-minima Sol7 Do",
                "armonia minimal-voice-leading G7 C"))
    ]

    static let ayudaDePlr: [EntradaDeAyuda] = [
        // plr <tríada> <P, L, R…>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisPlr),
            descripcion: TextosDeConsola.traduccion(\.descripcionPlr),
            ejemplo: ejemplo(
                "armonia plr Do PLR",
                "armonia plr C PLR")),
        // plr camino <tríada> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisPlrCamino),
            descripcion: TextosDeConsola.traduccion(\.descripcionPlrCamino),
            ejemplo: ejemplo(
                "armonia plr camino Do Mibm",
                "armonia plr shortest C Ebm")),
        // plr ciclo <ciclo> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisPlrCiclo),
            descripcion: TextosDeConsola.traduccion(\.descripcionPlrCiclo),
            ejemplo: ejemplo(
                "armonia plr ciclo hexatonico Do",
                "armonia plr cycle hexatonic C")),
    ]
}
