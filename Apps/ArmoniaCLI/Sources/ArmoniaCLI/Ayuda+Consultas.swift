import Armonia

extension LineaDeComandos {
    /// Las consultas: acordes, notas, intervalos, escalas y tonalidades, en el orden en que salen en la ayuda.
    static let ordenesDeConsultas: [Orden] = [
        Orden(nombres: ["acorde", "chord"], ayuda: ayudaDeAcorde) { resto, notacion in
            guard !resto.isEmpty else { return uso(.faltaCifrado, notacion) }
            return bien(
                try resto.map { try describir(acorde: Acorde(leyendo: $0), notacion) }.joined(separator: "\n\n"))
        },
        Orden(nombres: ["identificar", "identify"], ayuda: ayudaDeIdentificar) { resto, notacion in
            guard !resto.isEmpty else { return uso(.faltanNotas, notacion) }
            return bien(try identificar(resto, notacion))
        },
        Orden(nombres: ["arpegio", "arpeggio"], ayuda: ayudaDeArpegio) { try arpegio($0, $1) },
        Orden(nombres: ["intervalo", "interval"], ayuda: ayudaDeIntervalo) { resto, notacion in
            guard resto.count == 2 else { return uso(.dosNotas, notacion) }
            return bien(try intervalo(resto[0], resto[1], notacion))
        },
        Orden(nombres: ["escala", "scale"], ayuda: ayudaDeEscala) { resto, notacion in
            guard !resto.isEmpty else { return uso(.faltaEscala, notacion) }
            return bien(describir(escala: try Escala(leyendo: resto.joined(separator: " ")), notacion))
        },
        Orden(nombres: ["tonalidad", "key"], ayuda: ayudaDeTonalidad) { resto, notacion in
            guard !resto.isEmpty else { return uso(.faltaTonalidad, notacion) }
            return bien(describir(tonalidad: try Tonalidad(leyendo: resto.joined(separator: " ")), notacion))
        },
    ]

    static let ayudaDeAcorde: [EntradaDeAyuda] = [
        // acorde <cifrado>…
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisAcorde),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionAcorde),
            ejemplo: ejemplo(
                "armonia acorde Sol7/Si",
                "armonia chord G7/B"))
    ]

    static let ayudaDeIdentificar: [EntradaDeAyuda] = [
        // identificar <notas>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisIdentificar),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionIdentificar),
            ejemplo: ejemplo(
                "armonia identificar Do Mi Sol Sib",
                "armonia identify C E G Bb"))
    ]

    static let ayudaDeArpegio: [EntradaDeAyuda] = [
        // arpegio <cifrado> [--patron <patrón>]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisArpegio),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionArpegio),
            ejemplo: ejemplo(
                "armonia arpegio Do7 --patron alberti",
                "armonia arpeggio C7 --pattern alberti"))
    ]

    static let ayudaDeIntervalo: [EntradaDeAyuda] = [
        // intervalo <nota> <nota>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisIntervalo),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionIntervalo),
            ejemplo: ejemplo(
                "armonia intervalo Do4 Mi5",
                "armonia interval C4 E5"))
    ]

    static let ayudaDeEscala: [EntradaDeAyuda] = [
        // escala <escala>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisEscala),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionEscala),
            ejemplo: ejemplo(
                "armonia escala Re dórico",
                "armonia scale D dorian"))
    ]

    static let ayudaDeTonalidad: [EntradaDeAyuda] = [
        // tonalidad <tonalidad>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisTonalidad),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionTonalidad),
            ejemplo: ejemplo(
                "armonia tonalidad La menor",
                "armonia key A minor"))
    ]
}
