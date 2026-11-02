import Armonia

extension LineaDeComandos {
    /// Las consultas: acordes, notas, intervalos, escalas y tonalidades, en el orden en que salen en la ayuda.
    static let ordenesDeConsultas: [Orden] = [
        Orden(nombres: ["acorde", "chord"], ayuda: ayudaDeAcorde) { try acorde($0, $1) },
        Orden(nombres: ["identificar", "identify"], ayuda: ayudaDeIdentificar) { resto, notacion in
            guard !resto.isEmpty else { return uso(.faltanNotas, notacion) }
            return bien(try identificar(resto, notacion))
        },
        Orden(nombres: ["arpegio", "arpeggio"], ayuda: ayudaDeArpegio) { try arpegio($0, $1) },
        Orden(nombres: ["intervalo", "interval"], ayuda: ayudaDeIntervalo) { resto, notacion in
            guard resto.count == 2 else { return uso(.dosNotas, notacion) }
            return bien(try intervalo(resto[0], resto[1], notacion))
        },
        Orden(nombres: ["escala", "scale"], ayuda: ayudaDeEscala) { try escala($0, $1) },
        Orden(nombres: ["escalas", "scales"], ayuda: ayudaDeEscalas) { escalas($0, $1) },
        Orden(nombres: ["tonalidad", "key"], ayuda: ayudaDeTonalidad) { resto, notacion in
            guard !resto.isEmpty else { return uso(.faltaTonalidad, notacion) }
            return bien(describir(tonalidad: try Tonalidad(leyendo: resto.joined(separator: " ")), notacion))
        },
        Orden(nombres: ["conjunto", "set"], ayuda: ayudaDeConjunto) { resto, notacion in
            guard !resto.isEmpty else { return uso(.faltaConjunto, notacion) }
            return bien(describir(conjunto: try ConjuntoDeClases(leyendo: resto.joined(separator: " ")), notacion))
        },
        Orden(nombres: ["serie", "row"], ayuda: ayudaDeSerie) { resto, notacion in
            guard !resto.isEmpty else { return uso(.faltaSerie, notacion) }
            return bien(describir(serie: try SerieDodecafonica(leyendo: resto.joined(separator: " ")), notacion))
        },
    ]

    static let ayudaDeAcorde: [EntradaDeAyuda] = [
        // acorde <cifrado>…
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisAcorde),
            descripcion: TextosDeCLI.traduccion(\.descripcionAcorde),
            ejemplo: ejemplo(
                "armonia acorde Sol7/Si",
                "armonia chord G7/B"),
            notas: TextosDeCLI.traduccion(\.notasAcorde))
    ]

    static let ayudaDeIdentificar: [EntradaDeAyuda] = [
        // identificar <notas>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisIdentificar),
            descripcion: TextosDeCLI.traduccion(\.descripcionIdentificar),
            ejemplo: ejemplo(
                "armonia identificar Do Mi Sol Sib",
                "armonia identify C E G Bb"))
    ]

    static let ayudaDeArpegio: [EntradaDeAyuda] = [
        // arpegio <cifrado> [--patron <patrón>]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisArpegio),
            descripcion: TextosDeCLI.traduccion(\.descripcionArpegio),
            ejemplo: ejemplo(
                "armonia arpegio Do7 --patron alberti",
                "armonia arpeggio C7 --pattern alberti"),
            notas: TextosDeCLI.traduccion(\.notasArpegio))
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
            notas: TextosDeCLI.traduccion(\.notasEscala))
    ]

    static let ayudaDeEscalas: [EntradaDeAyuda] = [
        // escalas [<texto>] [--tradicion <tradición>] [--categoria <categoría>]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisEscalas),
            descripcion: TextosDeCLI.traduccion(\.descripcionEscalas),
            ejemplo: ejemplo(
                "armonia escalas --tradicion turquia",
                "armonia scales --tradition turkey"),
            notas: TextosDeCLI.traduccion(\.notasEscalas))
    ]

    static let ayudaDeTonalidad: [EntradaDeAyuda] = [
        // tonalidad <tonalidad>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTonalidad),
            descripcion: TextosDeCLI.traduccion(\.descripcionTonalidad),
            ejemplo: ejemplo(
                "armonia tonalidad La menor",
                "armonia key A minor"))
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
