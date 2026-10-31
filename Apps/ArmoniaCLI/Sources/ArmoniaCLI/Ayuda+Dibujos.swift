import Armonia

extension LineaDeComandos {
    /// Los dibujos del Tonnetz y de la tabla armónica, en el orden en que salen en la ayuda.
    static let ordenesDeDibujos: [Orden] = [
        Orden(nombres: ["tonnetz"], ayuda: ayudaDeTonnetz) { try tonnetz($0, $1) },
        Orden(nombres: ["tabla", "harmonic-table"], ayuda: ayudaDeTabla) { try tablaArmonica($0, $1) },
    ]

    static let ayudaDeTonnetz: [EntradaDeAyuda] = [
        // tonnetz <notas>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTonnetz),
            descripcion: TextosDeCLI.traduccion(\.descripcionTonnetz),
            ejemplo: ejemplo(
                "armonia tonnetz Do Mi Sol Si > tonnetz.svg",
                "armonia tonnetz C E G B > tonnetz.svg")),
        // tonnetz --acorde <cifrado> | --escala <escala> | --clases <números>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTonnetzAcorde),
            descripcion: TextosDeCLI.traduccion(\.descripcionTonnetzAcorde),
            ejemplo: ejemplo(
                "armonia tonnetz --escala Re dórico > dorico.svg",
                "armonia tonnetz --scale D dorian > dorian.svg")),
        // tonnetz --recorrido <tríadas> | --camino <tríada> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTonnetzRecorrido),
            descripcion: TextosDeCLI.traduccion(\.descripcionTonnetzRecorrido),
            ejemplo: ejemplo(
                "armonia tonnetz --recorrido Do Lam Fa Rem > recorrido.svg",
                "armonia tonnetz --sequence C Am F Dm > sequence.svg")),
        // tonnetz --ciclo <ciclo> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTonnetzCiclo),
            descripcion: TextosDeCLI.traduccion(\.descripcionTonnetzCiclo),
            ejemplo: ejemplo(
                "armonia tonnetz --ciclo hexatonico Do > ciclo.svg",
                "armonia tonnetz --cycle hexatonic C > cycle.svg"),
            notas: TextosDeCLI.traduccion(\.notasTonnetzCiclo)),
    ]

    static let ayudaDeTabla: [EntradaDeAyuda] = [
        // tabla <notas o alturas>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTabla),
            descripcion: TextosDeCLI.traduccion(\.descripcionTabla),
            ejemplo: ejemplo(
                "armonia tabla Do3 Sol3 Mi4 > tabla.svg",
                "armonia tabla C3 G3 E4 > table.svg")),
        // tabla --acorde <cifrado> | --escala <escala> | --clases <números>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTablaAcorde),
            descripcion: TextosDeCLI.traduccion(\.descripcionTablaAcorde),
            ejemplo: ejemplo(
                "armonia tabla --acorde Domaj7 > domaj7.svg",
                "armonia tabla --chord Cmaj7 > cmaj7.svg")),
    ]
}
