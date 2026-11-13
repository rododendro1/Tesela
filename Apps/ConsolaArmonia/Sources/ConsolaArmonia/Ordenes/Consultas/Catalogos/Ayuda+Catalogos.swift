import Armonia

extension LineaDeComandos {
    /// Las consultas de los catálogos: escalas, tradiciones, progresiones, ritmos, temperamentos, notas, funciones y
    /// acordes con nombre. Salen en la ayuda entre `escala` y `tonalidad`, dentro de las consultas.
    static let ordenesDeCatalogos: [Orden] = [
        Orden(
            nombres: ["escalas", "scales"], ayuda: ayudaDeEscalas, json: { try escalasJSON($0, $1.notacion) },
            ejecutar: { try escalas($0, $1.notacion) }),
        Orden(
            nombres: ["tradiciones", "traditions"], ayuda: ayudaDeTradiciones,
            json: { try tradicionesJSON($0, $1.notacion) },
            ejecutar: { try tradiciones($0, $1.notacion) }),
        Orden(
            nombres: ["progresiones", "progressions"], ayuda: ayudaDeProgresiones,
            json: { try progresionesJSON($0, $1.notacion) },
            ejecutar: { try progresiones($0, $1.notacion) }),
        Orden(
            nombres: ["ritmos", "rhythms"], ayuda: ayudaDeRitmos, json: { try ritmosJSON($0, $1.notacion) },
            ejecutar: { try ritmos($0, $1.notacion) }),
        Orden(
            nombres: ["temperamentos", "temperaments"], ayuda: ayudaDeTemperamentos,
            json: { try temperamentosJSON($0, $1.notacion) }, ejecutar: { try temperamentos($0, $1.notacion) }),
        Orden(
            nombres: ["notas", "notes"], ayuda: ayudaDeNotasConNombre, json: { try notasJSON($0, $1.notacion) },
            ejecutar: { try notas($0, $1.notacion) }),
        Orden(
            nombres: ["funciones", "functions"], ayuda: ayudaDeFunciones,
            json: { try funcionesJSON($0, $1.notacion) }, ejecutar: { try funciones($0, $1.notacion) }),
        Orden(
            nombres: ["acordes", "chords"], ayuda: ayudaDeAcordesConNombre,
            json: { try acordesConNombreJSON($0, $1.notacion) },
            ejecutar: { try acordesConNombre($0, $1.notacion) }),
    ]

    static let ayudaDeTradiciones: [EntradaDeAyuda] = [
        // tradiciones [<tradición>]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisTradiciones),
            descripcion: TextosDeConsola.traduccion(\.descripcionTradiciones),
            ejemplo: ejemplo("armonia tradiciones", "armonia traditions"))
    ]

    static let ayudaDeProgresiones: [EntradaDeAyuda] = [
        // progresiones [<texto>] [--en <tonalidad>]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisProgresiones),
            descripcion: TextosDeConsola.traduccion(\.descripcionProgresiones),
            ejemplo: ejemplo("armonia progresiones andaluza --en La", "armonia progressions andalusian --in A"),
            opciones: [.en, .epoca, .afecto])
    ]

    static let ayudaDeRitmos: [EntradaDeAyuda] = [
        // ritmos [<texto>] [--familia <familia>] [--estilo <estilo>] [--epoca <época>] [--estadisticas]
        //     [--comparar <ritmo>]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisRitmos),
            descripcion: TextosDeConsola.traduccion(\.descripcionRitmos),
            ejemplo: ejemplo(
                "armonia ritmos clave de son --estadisticas", "armonia rhythms son clave --statistics"),
            notas: TextosDeConsola.traduccion(\.notasRitmos),
            opciones: [.familia, .estilo, .epoca, .estadisticas, .comparar])
    ]

    static let ayudaDeTemperamentos: [EntradaDeAyuda] = [
        // temperamentos [<texto>] [--familia <familia>] [--estadisticas | --reloj [--quintas] [--colores]]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisTemperamentos),
            descripcion: TextosDeConsola.traduccion(\.descripcionTemperamentos),
            ejemplo: ejemplo(
                "armonia temperamentos mesotonico --estadisticas", "armonia temperaments meantone --statistics"),
            notas: TextosDeConsola.traduccion(\.notasTemperamentos),
            opciones: [.familia, .estadisticas, .reloj, .quintas, .colores])
    ]

    static let ayudaDeNotasConNombre: [EntradaDeAyuda] = [
        // notas [<texto>] [--familia <familia>] [--estadisticas]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisNotasConNombre),
            descripcion: TextosDeConsola.traduccion(\.descripcionNotasConNombre),
            ejemplo: ejemplo(
                "armonia notas diapasón barroco --estadisticas", "armonia notes baroque pitch --statistics"),
            notas: TextosDeConsola.traduccion(\.notasNotasConNombre),
            opciones: [.familia, .estadisticas])
    ]

    static let ayudaDeFunciones: [EntradaDeAyuda] = [
        // funciones [<texto>] [--familia <familia>] [--estadisticas]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisFunciones),
            descripcion: TextosDeConsola.traduccion(\.descripcionFunciones),
            ejemplo: ejemplo(
                "armonia funciones --familia blues --estadisticas", "armonia functions --family blues --statistics"),
            notas: TextosDeConsola.traduccion(\.notasFunciones),
            opciones: [.familia, .estadisticas])
    ]

    static let ayudaDeAcordesConNombre: [EntradaDeAyuda] = [
        // acordes [<texto>] [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisAcordesConNombre),
            descripcion: TextosDeConsola.traduccion(\.descripcionAcordesConNombre),
            ejemplo: ejemplo("armonia acordes tristan --sobre Fa", "armonia chords tristan --over F"),
            notas: TextosDeConsola.traduccion(\.notasAcordesConNombre),
            opciones: [
                .sobre, .notas, .estilo, .epoca, .afecto, .porTerceras, .noPorTerceras, .sinSemitonos, .conIntervalo,
                .sinIntervalo,
                .orden, .estadisticas, .resumen,
            ])
    ]

    static let ayudaDeEscalas: [EntradaDeAyuda] = [
        // escalas [<texto>] [--tradicion <tradición>] [--categoria <categoría>]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisEscalas),
            descripcion: TextosDeConsola.traduccion(\.descripcionEscalas),
            ejemplo: ejemplo(
                "armonia escalas --tradicion turquia",
                "armonia scales --tradition turkey"),
            notas: TextosDeConsola.traduccion(\.notasEscalas),
            opciones: [
                .tradicion, .categoria, .fuente, .estilo, .lugar, .agrupar, .epoca, .afecto, .escuela, .notas, .orden,
                .sinSemitonos, .regulares, .fragmentos, .sinFragmentos, .afinacion,
                .conIntervalo,
                .sinIntervalo,
                .conPaso, .comparar, .vecinasDe, .parecidasA, .escaleraDe, .mapa,
            ])
    ]
}
