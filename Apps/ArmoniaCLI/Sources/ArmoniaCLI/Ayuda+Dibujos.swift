import Armonia

extension LineaDeComandos {
    /// La ayuda de los dibujos del Tonnetz y de la tabla armónica, en el orden en que sale.
    static let ayudaDeDibujos: [EntradaDeAyuda] = [
        // tonnetz <notas>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisTonnetz),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionTonnetz),
            ejemplo: ejemplo("armonia tonnetz Do Mi Sol Si > tonnetz.svg",
                             "armonia tonnetz C E G B > tonnetz.svg")),
        // tonnetz --acorde <cifrado> | --escala <escala> | --clases <números>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisTonnetzAcorde),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionTonnetzAcorde),
            ejemplo: ejemplo("armonia tonnetz --escala Re dórico > dorico.svg",
                             "armonia tonnetz --scale D dorian > dorian.svg")),
        // tonnetz --recorrido <tríadas> | --camino <tríada> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisTonnetzRecorrido),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionTonnetzRecorrido),
            ejemplo: ejemplo("armonia tonnetz --recorrido Do Lam Fa Rem > recorrido.svg",
                             "armonia tonnetz --sequence C Am F Dm > sequence.svg")),
        // tonnetz --ciclo <ciclo> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisTonnetzCiclo),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionTonnetzCiclo),
            ejemplo: ejemplo("armonia tonnetz --ciclo hexatonico Do > ciclo.svg",
                             "armonia tonnetz --cycle hexatonic C > cycle.svg"),
            notas: TextosDeCLI.traducidos.map(\.notasTonnetzCiclo)),
        // tabla <notas o alturas>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisTabla),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionTabla),
            ejemplo: ejemplo("armonia tabla Do3 Sol3 Mi4 > tabla.svg",
                             "armonia tabla C3 G3 E4 > table.svg")),
        // tabla --acorde <cifrado> | --escala <escala> | --clases <números>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisTablaAcorde),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionTablaAcorde),
            ejemplo: ejemplo("armonia tabla --acorde Domaj7 > domaj7.svg",
                             "armonia tabla --chord Cmaj7 > cmaj7.svg")),
    ]
}
