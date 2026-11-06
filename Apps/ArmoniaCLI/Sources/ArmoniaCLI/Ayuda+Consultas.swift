import Armonia

extension LineaDeComandos {
    /// Las consultas: acordes, notas, intervalos, escalas y tonalidades, en el orden en que salen en la ayuda.
    static let ordenesDeConsultas: [Orden] = [
        Orden(
            nombres: ["acorde", "chord"], ayuda: ayudaDeAcorde, json: { try acordeJSON($0, $1) },
            ejecutar: { try acorde($0, $1) }),
        Orden(
            nombres: ["identificar", "identify"], ayuda: ayudaDeIdentificar, json: { try identificarJSON($0, $1) },
            ejecutar: { try identificarConOpciones($0, $1) }),
        Orden(
            nombres: ["arpegio", "arpeggio"], ayuda: ayudaDeArpegio, json: { try arpegioJSON($0, $1) },
            ejecutar: { try arpegio($0, $1) }),
        Orden(
            nombres: ["intervalo", "interval"], ayuda: ayudaDeIntervalo, json: { try intervaloJSON($0, $1) },
            ejecutar: { try consultarIntervalo($0, $1) }),
        Orden(
            nombres: ["escala", "scale"], ayuda: ayudaDeEscala, json: { try escalaJSON($0, $1) },
            ejecutar: { try escala($0, $1) }),
        Orden(nombres: ["escalas", "scales"], ayuda: ayudaDeEscalas) { try escalas($0, $1) },
        Orden(
            nombres: ["tradiciones", "traditions"], ayuda: ayudaDeTradiciones, json: { try tradicionesJSON($0, $1) },
            ejecutar: { try tradiciones($0, $1) }),
        Orden(
            nombres: ["tonalidad", "key"], ayuda: ayudaDeTonalidad, json: { try tonalidadJSON($0, $1) },
            ejecutar: { try consultarTonalidad($0, $1) }),
        Orden(
            nombres: ["conjunto", "set"], ayuda: ayudaDeConjunto, json: { try conjuntoJSON($0, $1) },
            ejecutar: { try consultarConjunto($0, $1) }),
        Orden(
            nombres: ["serie", "row"], ayuda: ayudaDeSerie, json: { try serieJSON($0, $1) },
            ejecutar: { try consultarSerie($0, $1) }),
    ]

    static let ayudaDeAcorde: [EntradaDeAyuda] = [
        // acorde <cifrado>…
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisAcorde),
            descripcion: TextosDeCLI.traduccion(\.descripcionAcorde),
            ejemplo: ejemplo(
                "armonia acorde Sol7/Si",
                "armonia chord G7/B"),
            notas: TextosDeCLI.traduccion(\.notasAcorde),
            opciones: [.disposiciones, .nombres, .tonalidades, .sustituciones, .en, .comparar, .bebop, .pentatonicas])
    ]

    static let ayudaDeIdentificar: [EntradaDeAyuda] = [
        // identificar <notas>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisIdentificar),
            descripcion: TextosDeCLI.traduccion(\.descripcionIdentificar),
            ejemplo: ejemplo(
                "armonia identificar Do Mi Sol Sib",
                "armonia identify C E G Bb"),
            notas: TextosDeCLI.traduccion(\.notasIdentificar),
            opciones: [.escalas, .archivo])
    ]

    static let ayudaDeArpegio: [EntradaDeAyuda] = [
        // arpegio <cifrado> [--patron <patrón>]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisArpegio),
            descripcion: TextosDeCLI.traduccion(\.descripcionArpegio),
            ejemplo: ejemplo(
                "armonia arpegio Do7 --patron alberti",
                "armonia arpeggio C7 --pattern alberti"),
            notas: TextosDeCLI.traduccion(\.notasArpegio),
            opciones: [.patron, .octavas, .sinOctava, .desde, .tensiones, .grados, .aproximacion])
    ]

    static let ayudaDeIntervalo: [EntradaDeAyuda] = [
        // intervalo <nota> <nota>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisIntervalo),
            descripcion: TextosDeCLI.traduccion(\.descripcionIntervalo),
            ejemplo: ejemplo(
                "armonia intervalo Do4 Mi5",
                "armonia interval C4 E5"))
    ]

    static let ayudaDeEscala: [EntradaDeAyuda] = [
        // escala <escala> [--acordes]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisEscala),
            descripcion: TextosDeCLI.traduccion(\.descripcionEscala),
            ejemplo: ejemplo(
                "armonia escala Re dórico",
                "armonia scale D dorian"),
            notas: TextosDeCLI.traduccion(\.notasEscala),
            opciones: [
                .acordes, .secuencia, .bajando, .octavas, .piano, .modos, .comparar, .simetria, .vecinas, .doce,
                .triadas, .estadisticas, .escalera, .contra, .parecidas, .progresiones,
            ])
    ]

    static let ayudaDeTradiciones: [EntradaDeAyuda] = [
        // tradiciones [<tradición>]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTradiciones),
            descripcion: TextosDeCLI.traduccion(\.descripcionTradiciones),
            ejemplo: ejemplo("armonia tradiciones", "armonia traditions"))
    ]

    static let ayudaDeEscalas: [EntradaDeAyuda] = [
        // escalas [<texto>] [--tradicion <tradición>] [--categoria <categoría>]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisEscalas),
            descripcion: TextosDeCLI.traduccion(\.descripcionEscalas),
            ejemplo: ejemplo(
                "armonia escalas --tradicion turquia",
                "armonia scales --tradition turkey"),
            notas: TextosDeCLI.traduccion(\.notasEscalas),
            opciones: [
                .tradicion, .categoria, .fuente, .uso, .notas, .orden, .sinSemitonos, .regulares, .conIntervalo,
                .sinIntervalo,
                .conPaso, .comparar, .mapa,
            ])
    ]

    static let ayudaDeTonalidad: [EntradaDeAyuda] = [
        // tonalidad <tonalidad>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTonalidad),
            descripcion: TextosDeCLI.traduccion(\.descripcionTonalidad),
            ejemplo: ejemplo(
                "armonia tonalidad La menor --modulaciones",
                "armonia key A minor --modulations"),
            opciones: [.modulaciones])
    ]

    static let ayudaDeConjunto: [EntradaDeAyuda] = [
        // conjunto <clases>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisConjunto),
            descripcion: TextosDeCLI.traduccion(\.descripcionConjunto),
            ejemplo: ejemplo(
                "armonia conjunto 4-Z15",
                "armonia set 4-Z15"))
    ]

    static let ayudaDeSerie: [EntradaDeAyuda] = [
        // serie <serie>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisSerie),
            descripcion: TextosDeCLI.traduccion(\.descripcionSerie),
            ejemplo: ejemplo(
                "armonia serie 0e742 938t156",
                "armonia row 0e742 938t156"))
    ]
}
