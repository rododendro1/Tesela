import Armonia

extension LineaDeComandos {
    /// Las consultas: acordes, notas, intervalos, escalas y tonalidades, en el orden en que salen en la ayuda.
    static let ordenesDeConsultas: [Orden] = [
        Orden(
            nombres: ["acorde", "chord"], ayuda: ayudaDeAcorde, json: { try acordeJSON($0, $1.notacion) },
            ejecutar: { try acorde($0, $1.notacion) }),
        Orden(
            nombres: ["identificar", "identify"], ayuda: ayudaDeIdentificar,
            json: { try identificarJSON($0, $1.notacion) },
            ejecutar: { try identificarConOpciones($0, $1) }),
        Orden(
            nombres: ["arpegio", "arpeggio"], ayuda: ayudaDeArpegio, json: { try arpegioJSON($0, $1.notacion) },
            ejecutar: { try arpegio($0, $1.notacion) }),
        Orden(
            nombres: ["intervalo", "interval"], ayuda: ayudaDeIntervalo, json: { try intervaloJSON($0, $1.notacion) },
            ejecutar: { try consultarIntervalo($0, $1.notacion) }),
        Orden(
            nombres: ["escala", "scale"], ayuda: ayudaDeEscala, json: { try escalaJSON($0, $1.notacion) },
            ejecutar: { try escala($0, $1) }),
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
            nombres: ["acordes", "chords"], ayuda: ayudaDeAcordesConNombre,
            json: { try acordesConNombreJSON($0, $1.notacion) },
            ejecutar: { try acordesConNombre($0, $1.notacion) }),
        Orden(
            nombres: ["tonalidad", "key"], ayuda: ayudaDeTonalidad, json: { try tonalidadJSON($0, $1.notacion) },
            ejecutar: { try consultarTonalidad($0, $1.notacion) }),
        Orden(
            nombres: ["conjunto", "set"], ayuda: ayudaDeConjunto, json: { try conjuntoJSON($0, $1.notacion) },
            ejecutar: { try consultarConjunto($0, $1.notacion) }),
        Orden(
            nombres: ["serie", "row"], ayuda: ayudaDeSerie, json: { try serieJSON($0, $1.notacion) },
            ejecutar: { try consultarSerie($0, $1.notacion) }),
    ]

    static let ayudaDeAcorde: [EntradaDeAyuda] = [
        // acorde <cifrado>…
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisAcorde),
            descripcion: TextosDeConsola.traduccion(\.descripcionAcorde),
            ejemplo: ejemplo(
                "armonia acorde Sol7/Si",
                "armonia chord G7/B"),
            notas: TextosDeConsola.traduccion(\.notasAcorde),
            opciones: [.disposiciones, .nombres, .tonalidades, .sustituciones, .en, .comparar, .bebop, .pentatonicas])
    ]

    static let ayudaDeIdentificar: [EntradaDeAyuda] = [
        // identificar <notas>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisIdentificar),
            descripcion: TextosDeConsola.traduccion(\.descripcionIdentificar),
            ejemplo: ejemplo(
                "armonia identificar Do Mi Sol Sib",
                "armonia identify C E G Bb"),
            notas: TextosDeConsola.traduccion(\.notasIdentificar),
            opciones: [.escalas, .archivo])
    ]

    static let ayudaDeArpegio: [EntradaDeAyuda] = [
        // arpegio <cifrado> [--patron <patrón>]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisArpegio),
            descripcion: TextosDeConsola.traduccion(\.descripcionArpegio),
            ejemplo: ejemplo(
                "armonia arpegio Do7 --patron alberti",
                "armonia arpeggio C7 --pattern alberti"),
            notas: TextosDeConsola.traduccion(\.notasArpegio),
            opciones: [.patron, .octavas, .sinOctava, .desde, .tensiones, .grados, .aproximacion])
    ]

    static let ayudaDeIntervalo: [EntradaDeAyuda] = [
        // intervalo <nota> <nota>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisIntervalo),
            descripcion: TextosDeConsola.traduccion(\.descripcionIntervalo),
            ejemplo: ejemplo(
                "armonia intervalo Do4 Mi5",
                "armonia interval C4 E5"))
    ]

    static let ayudaDeEscala: [EntradaDeAyuda] = [
        // escala <escala> [--acordes]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisEscala),
            descripcion: TextosDeConsola.traduccion(\.descripcionEscala),
            ejemplo: ejemplo(
                "armonia escala Re dórico",
                "armonia scale D dorian"),
            notas: TextosDeConsola.traduccion(\.notasEscala),
            opciones: [
                .acordes, .secuencia, .bajando, .octavas, .piano, .modos, .comparar, .simetria, .vecinas, .doce,
                .triadas, .estadisticas, .escalera, .parecidas, .progresiones, .tetracordos, .bibtex,
            ])
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
            opciones: [.en])
    ]

    static let ayudaDeAcordesConNombre: [EntradaDeAyuda] = [
        // acordes [<texto>] [--sobre <nota>]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisAcordesConNombre),
            descripcion: TextosDeConsola.traduccion(\.descripcionAcordesConNombre),
            ejemplo: ejemplo("armonia acordes tristan --sobre Fa", "armonia chords tristan --over F"),
            opciones: [.sobre])
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
                .tradicion, .categoria, .fuente, .uso, .notas, .orden, .sinSemitonos, .regulares, .conIntervalo,
                .sinIntervalo,
                .conPaso, .comparar, .vecinasDe, .parecidasA, .escaleraDe, .mapa,
            ])
    ]

    static let ayudaDeTonalidad: [EntradaDeAyuda] = [
        // tonalidad <tonalidad>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisTonalidad),
            descripcion: TextosDeConsola.traduccion(\.descripcionTonalidad),
            ejemplo: ejemplo(
                "armonia tonalidad La menor --modulaciones",
                "armonia key A minor --modulations"),
            opciones: [.modulaciones])
    ]

    static let ayudaDeConjunto: [EntradaDeAyuda] = [
        // conjunto <clases>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisConjunto),
            descripcion: TextosDeConsola.traduccion(\.descripcionConjunto),
            ejemplo: ejemplo(
                "armonia conjunto 4-Z15",
                "armonia set 4-Z15"))
    ]

    static let ayudaDeSerie: [EntradaDeAyuda] = [
        // serie <serie>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisSerie),
            descripcion: TextosDeConsola.traduccion(\.descripcionSerie),
            ejemplo: ejemplo(
                "armonia serie 0e742 938t156",
                "armonia row 0e742 938t156"))
    ]
}
