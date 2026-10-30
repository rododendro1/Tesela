import Armonia

extension LineaDeComandos {
    /// La ayuda de las consultas: acordes, notas, intervalos, escalas y tonalidades, en el orden en que sale.
    static let ayudaDeConsultas: [EntradaDeAyuda] = [
        // acorde <cifrado>…
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisAcorde),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionAcorde),
            ejemplo: ejemplo("armonia acorde Sol7/Si",
                             "armonia chord G7/B")),
        // identificar <notas>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisIdentificar),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionIdentificar),
            ejemplo: ejemplo("armonia identificar Do Mi Sol Sib",
                             "armonia identify C E G Bb")),
        // arpegio <cifrado> [--patron <patrón>]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisArpegio),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionArpegio),
            ejemplo: ejemplo("armonia arpegio Do7 --patron alberti",
                             "armonia arpeggio C7 --pattern alberti")),
        // intervalo <nota> <nota>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisIntervalo),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionIntervalo),
            ejemplo: ejemplo("armonia intervalo Do4 Mi5",
                             "armonia interval C4 E5")),
        // escala <escala>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisEscala),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionEscala),
            ejemplo: ejemplo("armonia escala Re dórico",
                             "armonia scale D dorian")),
        // tonalidad <tonalidad>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisTonalidad),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionTonalidad),
            ejemplo: ejemplo("armonia tonalidad La menor",
                             "armonia key A minor")),
    ]
}
